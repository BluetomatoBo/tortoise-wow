#!/usr/bin/env python3
"""Build the icon assets and the id -> icon-name table the site ships.

Where the data comes from
-------------------------
Two things are needed to draw an icon next to an item or a spell:

  * the artwork, as PNG, named after the client's texture (INV_Sword_39.png)
  * the mapping from a database column to that name. The column holds a
    display id for items (item_template.display_id) and a spell icon id for
    spells (spell_template.spellIconId); the names behind those ids live in the
    client's ItemDisplayInfo.dbc and SpellIcon.dbc, which the server never loads.

Both are taken from the Turtlehead dump of the AoWoW database
(Winfidonarleyan/turtle-wow), which has the DBCs resolved into two tables
(aowow_icons, aowow_spellicons) and the icons already converted to PNG. That
covers the ids that existed when the DBCs were dumped; Turtle's own newer ids
are missing from it, and this script reports how many rather than pretending
otherwise.

Usage:

    # a sparse checkout of the dump, and the SQL from the same dump
    git clone --depth 1 --filter=blob:none --sparse \\
        https://github.com/Winfidonarleyan/turtle-wow /tmp/twdump
    cd /tmp/twdump
    git sparse-checkout set "Dumps/Source Code/18 - Development_Turtlehead Current/main/images/icons"

    python3 tools/WowWeb/gen_icons.py \\
        --dump "/tmp/twdump/Dumps/Source Code/18 - Development_Turtlehead Current/main" \\
        --sql  "/tmp/aowow.sql" \\
        --size medium

--size picks which of the dump's three sets is copied. medium (36x36) is the
default because the pages draw them at 18px, so a 2x screen has real pixels to
work with; small (18x18) is a quarter of the download.
"""

import argparse
import os
import re
import shutil
import sys

# The three sets the dump ships, and the size each is meant to be drawn at.
SETS = {"small": 18, "medium": 36, "large": 56}


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


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--dump", required=True,
                    help="the dump's .../main directory (holding images/)")
    ap.add_argument("--sql", required=True, help="path to the dump's aowow.sql")
    ap.add_argument("--size", default="medium", choices=sorted(SETS),
                    help="which icon set to copy (default: medium)")
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

    # Copy the artwork. The file name is the icon name lowercased, which is what
    # the pages ask for.
    os.makedirs(out_dir, exist_ok=True)
    copied = 0
    for name in names:
        dest = os.path.join(out_dir, name)
        if not os.path.exists(dest):
            shutil.copyfile(os.path.join(src_dir, name), dest)
            copied += 1

    have = {os.path.splitext(n)[0].lower() for n in names}

    def build(table, marker):
        pairs = read_table(args.sql, table)
        kept, dropped = [], 0
        for entry, icon in sorted(pairs.items()):
            icon = icon.strip().lower()
            if not icon:
                continue
            # A name the dump has no PNG for would be a dead reference: the page
            # would emit an <img> that 404s. Leaving it out means the page draws
            # no icon at all, which is what an unknown id looks like anyway.
            if icon not in have:
                dropped += 1
                continue
            kept.append((entry, icon))
        print("%-18s %6d 条，保留 %6d，无图丢弃 %d" % (table, len(pairs), len(kept), dropped))
        return kept, marker

    items, item_marker = build("aowow_icons", "D")
    spells, spell_marker = build("aowow_spellicons", "S")

    # One line per mapping: <marker><TAB><id><TAB><name>. A marker rather than
    # two files because the parser then reads one file with one loop, and the
    # repeated name prefixes compress away in git anyway.
    with open(data_path, "w", encoding="utf-8") as f:
        f.write("# id -> icon name, generated by tools/WowWeb/gen_icons.py\n")
        f.write("# D = item_template.display_id, S = spell_template.spellIconId\n")
        f.write("# name is the PNG's file name without the extension, lowercased\n")
        for marker, pairs in ((item_marker, items), (spell_marker, spells)):
            for entry, icon in pairs:
                f.write("%s\t%d\t%s\n" % (marker, entry, icon))

    print("\n图标：%s（%d 个文件，%d 个新拷入）→ %s"
          % (args.size, len(names), copied, out_dir))
    print("映射：%s（%.1f KB）" % (data_path, os.path.getsize(data_path) / 1024))
    print("图标按 %dpx 绘制（%s 集）" % (SETS[args.size], args.size))


if __name__ == "__main__":
    main()
