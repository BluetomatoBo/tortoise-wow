#!/usr/bin/env python3
"""Build the icon assets and the id -> icon-name table the site ships.

Two things are needed to draw an icon next to an item or a spell:

  * the artwork, as PNG, named after the client's texture (inv_sword_39.png)
  * the mapping from a database column to that name. The column holds a display
    id for items (item_template.display_id) and a spell icon id for spells
    (spell_template.spellIconId); the names behind those ids live in the client's
    ItemDisplayInfo.dbc and SpellIcon.dbc, which the server never loads.

Where each part comes from
--------------------------
**The mapping** comes from the client's own DBC files.
`tools/dbc_verification/manifest_formatted.json` records the client's file list
with a sha256 per file and a CDN mirror, so those two DBCs are fetched from there
and verified. The older AoWoW dump (Winfidonarleyan/turtle-wow) is still used, but
only for ids the current client no longer carries - its tables came from an older
client, so preferring it would show art the game no longer uses.

**The bulk of the artwork** comes from that dump, which has the icons already
converted to PNG (images/icons/{small,medium,large}). Icons the dump does not have
- Turtle's newer content - are fetched as the client's own BLP files from the same
CDN and decoded here (BLP1 paletted, BLP2 DXT1/DXT3/DXT5 and raw).

Nothing is downloaded without its sha256 matching the manifest.

Usage:

    # the dump, sparse-checked out for just the icons
    git clone --depth 1 --filter=blob:none --sparse \\
        https://github.com/Winfidonarleyan/turtle-wow /tmp/twdump
    cd /tmp/twdump && git sparse-checkout set \\
        "Dumps/Source Code/18 - Development_Turtlehead Current/main/images/icons"
    curl -sL -o /tmp/aowow.sql "https://raw.githubusercontent.com/Winfidonarleyan/turtle-wow/main/Dumps/Source%20Code/18%20-%20Development_Turtlehead%20Current/main/dbs/aowow.sql"

    python3 tools/WowWeb/gen_icons.py \\
        --dump "/tmp/twdump/Dumps/Source Code/18 - Development_Turtlehead Current/main" \\
        --sql /tmp/aowow.sql

--size picks which of the dump's three sets is copied. medium (36x36) is the
default because the pages draw them at 18px, so a 2x screen has real pixels; small
(18x18) is a quarter of the download.

--no-client skips the CDN and uses the dump's tables alone, which is what the
script did before the client DBCs were wired in. It needs no network.
"""

import argparse
import hashlib
import json
import os
import re
import shutil
import struct
import subprocess
import sys
import urllib.request
import zlib

from blp import Unsupported, read_blp, write_png
from clientfiles import Client, read_dbc

# The three sets the dump ships, and the size each is meant to be drawn at.
SETS = {"small": 18, "medium": 36, "large": 56}

# Where the client's file list lives, relative to this script.
MANIFEST = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                        "..", "dbc_verification", "manifest_formatted.json")


# ---------------------------------------------------------------------------
# The dump's tables
# ---------------------------------------------------------------------------

def read_table(sql_path, table):
    """Pull (id, name) pairs out of one aowow table's INSERT statements."""
    text = open(sql_path, encoding="utf-8", errors="replace").read()
    out = {}
    for block in re.split(r"INSERT INTO `%s`" % table, text)[1:]:
        stop = re.search(r";\s*\n", block)
        body = block[: stop.start()] if stop else block
        for match in re.finditer(r"\((\d+),\s*'([^']*)'\)", body):
            out[int(match.group(1))] = match.group(2)
    return out


# ---------------------------------------------------------------------------
# The client's files, from the mirrors the manifest names
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# DBC
# ---------------------------------------------------------------------------

def safe_name(name):
    """A name that a file, an embed pattern and a URL all accept.

    Some of the client's icons have characters in their DBC name that cannot go in
    an embedded file name or in a URL - this client has an apostrophe
    (btnmur'gulstaff), an ampersand and a space. go:embed refuses to build with such
    a file, so the name is normalised to [a-z0-9_.-] before it is used as the file
    name. The name is only a key: what matters is that icondata.txt and the file
    agree. main() reports a collision rather than overwriting one icon with another.
    """
    return re.sub(r"[^a-z0-9_.-]", "_", name)


def icon_name(raw):
    """Normalise a name from a DBC or a table into the PNG's file name.

    They arrive in every shape the client uses: a full path
    (Interface\\Icons\\Spell_Fire_Fire), a texture with an extension
    (inv_chest_fur.tga), or already bare. Lowercased, because that is how the
    files are named.
    """
    name = raw.strip().replace("\\", "/").rsplit("/", 1)[-1]
    name = re.sub(r"\.(blp|tga|png)$", "", name, flags=re.I)
    return name.lower()


# ---------------------------------------------------------------------------
# BLP: the client's icon, as RGBA
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--dump", required=True,
                    help="the dump's .../main directory (holding images/)")
    ap.add_argument("--sql", required=True, help="path to the dump's aowow.sql")
    ap.add_argument("--size", default="medium", choices=sorted(SETS),
                    help="which icon set to copy (default: medium)")
    ap.add_argument("--manifest", default=os.path.normpath(MANIFEST),
                    help="the client's file list with hashes (default: tools/dbc_verification)")
    ap.add_argument("--cache", default=os.path.join(os.path.expanduser("~"), ".cache", "tw-icons"),
                    help="where downloaded client files are kept between runs")
    ap.add_argument("--blp-dir", default=None,
                    help="a directory of .blp files extracted from an installed client, "
                         "used for names the CDN has none for (default: <cache>/blps, "
                         "which extract_client_icons.py fills)")
    ap.add_argument("--no-client", action="store_true",
                    help="skip the CDN: the dump's tables only, no DBC merge, no BLP icons")
    ap.add_argument("--out", default=None,
                    help="destination (default: internal/web/assets/icons next to this script)")
    ap.add_argument("--data", default=None,
                    help="where to write the id table (default: internal/web/icondata.txt)")
    args = ap.parse_args()

    here = os.path.dirname(os.path.abspath(__file__))
    out_dir = args.out or os.path.join(here, "internal", "web", "assets", "icons")
    data_path = args.data or os.path.join(here, "internal", "web", "icondata.txt")

    src_dir = os.path.join(args.dump, "images", "icons", args.size)
    if not os.path.isdir(src_dir):
        sys.exit("no such icon set: %s" % src_dir)
    names = sorted(f for f in os.listdir(src_dir) if f.lower().endswith(".png"))
    if not names:
        sys.exit("no PNG files in %s" % src_dir)

    os.makedirs(out_dir, exist_ok=True)
    copied = 0
    for name in names:
        dest = os.path.join(out_dir, safe_name(os.path.splitext(name)[0].lower()) + ".png")
        if not os.path.exists(dest):
            shutil.copyfile(os.path.join(src_dir, name), dest)
            copied += 1
    have = {safe_name(os.path.splitext(n)[0].lower()) for n in names}

    # --- the mappings ----------------------------------------------------
    items = {i: icon_name(n) for i, n in read_table(args.sql, "aowow_icons").items() if n.strip()}
    spells = {i: icon_name(n) for i, n in read_table(args.sql, "aowow_spellicons").items() if n.strip()}
    from_dump = (len(items), len(spells))

    blp_dir = args.blp_dir or os.path.join(args.cache, "blps")
    needed_path = os.path.join(args.cache, "needed-icons.txt")
    client = Client(os.path.normpath(args.manifest), args.cache, offline=args.no_client)
    drawn = 0
    if not args.no_client:
        for path, field, table, label in (
            ("DBFilesClient/ItemDisplayInfo.dbc", 5, items, "物品显示"),
            ("DBFilesClient/SpellIcon.dbc", 1, spells, "法术图标"),
        ):
            local = client.fetched(path)
            if local is None:
                print("清单里没有 %s，跳过" % path)
                continue
            rows, string = read_dbc(local)
            fresh = 0
            for row in rows:
                name = icon_name(string(row[field]))
                if not name:
                    continue
                if row[0] not in table:
                    fresh += 1
                table[row[0]] = name
            print("%-14s %s：%d 条记录，%d 个 id 是转储里没有的"
                  % (label, os.path.basename(path), len(rows), fresh))

    # --- the artwork the dump does not have ------------------------------
    missing = sorted({n for n in list(items.values()) + list(spells.values()) if n not in have})
    print("\n映射里有、图集里没有的图标：%d 个" % len(missing))
    if missing:
        # Two sources, in this order: the client files the manifest lists (whose
        # sha256 is checked), then whatever a client of yours has been made to
        # hand over by extract_client_icons.py. The second is what covers Turtle's
        # own patch content.
        from_cdn = from_local = 0
        unreadable = []
        for name in missing:
            # The BLP is looked up under the name the client uses; the PNG is
            # written under the name a file and a URL can carry.
            blp = None if args.no_client else client.fetched("Interface/Icons/%s.blp" % name)
            if blp:
                from_cdn += 1
            elif os.path.exists(os.path.join(blp_dir, name + ".blp")):
                blp = os.path.join(blp_dir, name + ".blp")
                from_local += 1
            if not blp:
                continue
            try:
                w, h, image = read_blp(blp)
            except Unsupported as exc:
                unreadable.append("%s (%s)" % (name, exc))
                continue
            write_png(os.path.join(out_dir, safe_name(name) + ".png"), w, h, image)
            have.add(safe_name(name))
            drawn += 1
        print("  从清单 CDN 的 BLP 解码 %d 个，从 --blp-dir 解码 %d 个" % (from_cdn, from_local))
        if unreadable:
            print("  读不了的 BLP %d 个：%s" % (len(unreadable), ", ".join(unreadable[:5])))

    still = [n for n in missing if n not in have]
    os.makedirs(args.cache, exist_ok=True)
    with open(needed_path, "w", encoding="utf-8") as f:
        f.write("\n".join(still) + ("\n" if still else ""))
    print("  仍无图 %d 个（那些 id 不画图标）" % len(still))
    if still:
        print("  想补它们：在你装有客户端图标的机器上跑")
        print("      python3 tools/WowWeb/extract_client_icons.py --client <客户端目录>")
        print("  然后重跑本脚本；名单已经写到 %s" % needed_path)

    # --- what ships ------------------------------------------------------
    # Names that differ only in the characters safe_name() rewrites would land on
    # the same file: one icon would silently stand in for another. There are none
    # today; the check is here so that a future client cannot introduce it quietly.
    seen = {}
    for name in sorted(set(items.values()) | set(spells.values())):
        clash = seen.get(safe_name(name))
        if clash and clash != name:
            sys.exit("icon names collide after normalising: %r and %r" % (clash, name))
        seen[safe_name(name)] = name

    items = {i: safe_name(n) for i, n in items.items()}
    spells = {i: safe_name(n) for i, n in spells.items()}
    kept_items = [(i, n) for i, n in sorted(items.items()) if n in have]
    kept_spells = [(i, n) for i, n in sorted(spells.items()) if n in have]
    with open(data_path, "w", encoding="utf-8") as f:
        f.write("# id -> icon name, generated by tools/WowWeb/gen_icons.py\n")
        f.write("# D = item_template.display_id, S = spell_template.spellIconId\n")
        f.write("# name is the PNG's file name without the extension, lowercased\n")
        for marker, pairs in (("D", kept_items), ("S", kept_spells)):
            for entry, name in pairs:
                f.write("%s\t%d\t%s\n" % (marker, entry, name))

    print("\n图标：%s（原有 %d，新拷入 %d，从客户端解码 %d）→ %s"
          % (args.size, len(names), copied, drawn, out_dir))
    print("映射：物品 %d/%d、法术 %d/%d 条有图（转储原本 %d/%d）"
          % (len(kept_items), len(items), len(kept_spells), len(spells),
             from_dump[0], from_dump[1]))
    print("文件：%s（%.1f KB）" % (data_path, os.path.getsize(data_path) / 1024))
    print("图标按 %dpx 绘制（%s 集）" % (SETS[args.size], args.size))


if __name__ == "__main__":
    main()
