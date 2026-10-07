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

class Client:
    """The client files the manifest describes, cached and hash-checked."""

    def __init__(self, manifest_path, cache_dir, offline=False):
        self.offline = offline
        self.cache = cache_dir
        os.makedirs(cache_dir, exist_ok=True)
        self.entries = {}
        if not offline:
            self._collect(json.load(open(manifest_path, encoding="utf-8")))

    def _collect(self, node):
        if isinstance(node, dict):
            name = node.get("name")
            if name and node.get("type") == "file" and node.get("mirrors"):
                # The same path can be listed twice (base client and a patch);
                # the newer mtime is the one the client currently loads.
                old = self.entries.get(name)
                if old is None or node.get("mtime", 0) > old.get("mtime", 0):
                    self.entries[name] = node
            for value in node.values():
                self._collect(value)
        elif isinstance(node, list):
            for value in node:
                self._collect(value)

    def fetched(self, path):
        """Download one manifest entry into the cache and check its sha256.

        The hash is checked on every call, not only on the first download: a file
        left truncated by an interrupted run would otherwise be trusted forever.
        """
        entry = self.entries.get(path)
        if entry is None:
            return None
        local = os.path.join(self.cache, path.replace("/", "_"))
        want = entry["hash"].lower()
        if os.path.exists(local) and hashlib.sha256(open(local, "rb").read()).hexdigest() == want:
            return local
        data = self._download(entry["mirrors"])
        got = hashlib.sha256(data).hexdigest()
        if got != want:
            sys.exit("sha256 mismatch for %s:\n  want %s\n  got  %s" % (path, want, got))
        with open(local, "wb") as f:
            f.write(data)
        return local

    def _download(self, mirrors):
        errors = []
        for key in ("r2", "r2eu", "tc"):
            url = mirrors.get(key)
            if not url:
                continue
            try:
                return http_get(url)
            except Exception as exc:  # noqa: BLE001 - collected and reported
                errors.append("%s: %s" % (key, exc))
        sys.exit("every mirror failed for one file:\n  " + "\n  ".join(errors))

    def icon_blp(self, name):
        """The cached path of an icon's BLP, or None if the manifest has none."""
        return self.fetched("Interface/Icons/%s.blp" % name)


def http_get(url):
    """Fetch a URL, falling back to curl.

    urllib is tried first because it needs nothing installed; on a Python built
    without a CA bundle (the python.org installer on macOS is one) it fails with a
    certificate error, and curl usually has a system trust store to fall back on.
    """
    try:
        with urllib.request.urlopen(url, timeout=120) as response:
            return response.read()
    except Exception as first:
        try:
            done = subprocess.run(["curl", "-sL", "--fail", url],
                                  capture_output=True, timeout=300)
        except (OSError, subprocess.SubprocessError):
            raise first
        if done.returncode != 0:
            raise first
        return done.stdout


# ---------------------------------------------------------------------------
# DBC
# ---------------------------------------------------------------------------

def read_dbc(path):
    """Return (rows, string). rows are tuples of uint32; string(offset) resolves
    a record field into the file's string block."""
    data = open(path, "rb").read()
    magic, records, fields, record_size, string_size = struct.unpack("<4sIIII", data[:20])
    if magic != b"WDBC":
        sys.exit("%s is not a DBC (%r)" % (path, magic))
    first, block = 20, 20 + records * record_size
    strings = data[block:block + string_size]

    def string(offset):
        if offset <= 0 or offset >= len(strings):
            return ""
        end = strings.find(b"\0", offset)
        return strings[offset:end].decode("utf-8", "replace")

    rows = [struct.unpack_from("<%dI" % fields, data, first + i * record_size)
            for i in range(records)]
    return rows, string


def safe_name(name):
    """A name that a file, an embed pattern and a URL all accept.

    Some of the client's icons have characters in their DBC name that cannot go
    in an embedded file name or in a URL - this client has an apostrophe
    (btnmur'gulstaff), an ampersand and a space. go:embed refuses to build with
    such a file, so the name is normalised to [a-z0-9_.-] before it is used as
    the file name. The name is only a key: what matters is that icondata.txt and
    the file agree. main() reports a collision rather than overwriting one icon
    with another.
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

def _rgb565(v):
    r, g, b = (v >> 11) & 0x1F, (v >> 5) & 0x3F, v & 0x1F
    return ((r << 3) | (r >> 2), (g << 2) | (g >> 4), (b << 3) | (b >> 2))


class Unsupported(Exception):
    """A BLP variant this tool cannot read. One odd file in a client is not a
    reason to abandon the other seven hundred, so the caller reports and skips."""


class Window:
    """A view onto one 4x4 corner of a bigger image, so the DXT1 colour decoder
    can fill a block without knowing where in the picture it is."""

    def __init__(self, image, bx, by):
        self.image, self.bx, self.by = image, bx, by

    def __getitem__(self, y):
        return Row(self.image[self.by + y], self.bx)


class Row:
    def __init__(self, row, bx):
        self.row, self.bx = row, bx

    def __setitem__(self, x, value):
        if self.bx + x < len(self.row):
            self.row[self.bx + x] = value


def _dxt_color(data, off, target, width=4, height=4):
    """Decode one DXT1 colour block into target, and return the next offset."""
    c0, c1, bits = struct.unpack_from("<HHI", data, off)
    palette = [_rgb565(c0), _rgb565(c1)]
    if c0 > c1:
        palette.append(tuple((2 * palette[0][i] + palette[1][i]) // 3 for i in range(3)))
        palette.append(tuple((palette[0][i] + 2 * palette[1][i]) // 3 for i in range(3)))
        alpha = (255, 255, 255, 255)
    else:
        # c0 <= c1 is the three-colour mode, and its fourth entry is transparent -
        # which is how a 1-bit alpha icon punches its outline out.
        palette.append(tuple((palette[0][i] + palette[1][i]) // 2 for i in range(3)))
        palette.append((0, 0, 0))
        alpha = (255, 255, 255, 0)
    for y in range(height):
        for x in range(width):
            r, g, b = palette[(bits >> (2 * (y * 4 + x))) & 3]
            target[y][x] = (r, g, b, alpha[(bits >> (2 * (y * 4 + x))) & 3])
    return off + 8


def _dxt1(data, w, h, image):
    off = 0
    for by in range(0, h, 4):
        for bx in range(0, w, 4):
            off = _dxt_color(data, off, Window(image, bx, by),
                             min(4, w - bx), min(4, h - by))


def _dxt3(data, w, h, image):
    off = 0
    for by in range(0, h, 4):
        for bx in range(0, w, 4):
            packed = struct.unpack_from("<Q", data, off)[0]
            off += 8
            for y in range(4):
                for x in range(4):
                    if bx + x < w and by + y < h:
                        window = Window(image, bx, by)
                        nibble = (packed >> (4 * (y * 4 + x))) & 0xF
                        window[y][x] = (0, 0, 0, nibble * 17)
            off = _dxt_color(data, off, Window(image, bx, by))
    return off


def _dxt5(data, w, h, image):
    off = 0
    for by in range(0, h, 4):
        for bx in range(0, w, 4):
            a0, a1 = data[off], data[off + 1]
            bits = int.from_bytes(data[off + 2:off + 8], "little")
            off += 8
            if a0 > a1:
                alphas = [a0, a1] + [((7 - i) * a0 + i * a1) // 7 for i in range(1, 7)]
            else:
                alphas = [a0, a1] + [((5 - i) * a0 + i * a1) // 5 for i in range(1, 5)] + [0, 255]
            window = Window(image, bx, by)
            for y in range(4):
                for x in range(4):
                    if bx + x < w and by + y < h:
                        window[y][x] = (0, 0, 0, alphas[(bits >> (3 * (y * 4 + x))) & 7])
            off = _dxt_color(data, off, window)
    return off


def _blank(w, h):
    return [[(0, 0, 0, 0)] * w for _ in range(h)]


def read_blp(path):
    """Decode a client icon into (width, height, rows of RGBA)."""
    data = open(path, "rb").read()
    if data[:4] == b"BLP1":
        return _read_blp1(data)
    if data[:4] == b"BLP2":
        return _read_blp2(data)
    sys.exit("%s is not a BLP (%r)" % (path, data[:4]))


def _read_blp1(data):
    compression = struct.unpack_from("<I", data, 4)[0]
    w, h = struct.unpack_from("<II", data, 12)
    offsets = struct.unpack_from("<16I", data, 28)
    image = _blank(w, h)
    if compression == 1:
        palette = [(data[156 + i * 4 + 2], data[156 + i * 4 + 1], data[156 + i * 4], 255)
                   for i in range(256)]
        off = 156 + 1024
        alpha_size = w * h if (data[8] & 0xF) == 8 else (w * h) // 8
        alpha = data[off:off + alpha_size]
        off += alpha_size
        for y in range(h):
            for x in range(w):
                r, g, b, _ = palette[data[off + y * w + x]]
                if alpha_size == w * h:
                    a = alpha[y * w + x]
                else:
                    a = ((alpha[(y * w + x) // 8] >> (7 - (x % 8))) & 1) * 255
                image[y][x] = (r, g, b, a)
    elif compression == 2:
        block = data[offsets[0]:offsets[0] + (w // 4) * (h // 4) * 16]
        if (data[8] & 0xF) == 8:
            _dxt5(block, w, h, image)
        else:
            _dxt1(block, w, h, image)
    else:
        raise Unsupported("BLP1 compression %d" % compression)
    return w, h, image


def _read_blp2(data):
    encoding, alpha_depth, alpha_encoding = data[8], data[9], data[10]
    w, h = struct.unpack_from("<II", data, 12)
    offsets = struct.unpack_from("<16I", data, 20)
    sizes = struct.unpack_from("<16I", data, 84)
    block = data[offsets[0]:offsets[0] + sizes[0]]
    image = _blank(w, h)
    if encoding in (1, 3):  # raw BGRA; the client uses 1 and 3 for 4-byte pixels
        for y in range(h):
            for x in range(w):
                i = (y * w + x) * 4
                image[y][x] = (block[i + 2], block[i + 1], block[i], block[i + 3])
    elif encoding == 2:  # DXT
        if alpha_depth in (0, 1) and alpha_encoding == 0:
            _dxt1(block, w, h, image)
        elif alpha_encoding == 7:
            _dxt5(block, w, h, image)
        else:
            _dxt3(block, w, h, image)
    else:
        raise Unsupported("BLP2 encoding %d" % encoding)
    return w, h, image


def write_png(path, w, h, image):
    """Write RGBA rows as a PNG. Hand-rolled so the tool needs nothing installed."""
    raw = b"".join(b"\x00" + bytes(c for pixel in row for c in pixel) for row in image)

    def chunk(tag, payload):
        return (struct.pack(">I", len(payload)) + tag + payload
                + struct.pack(">I", zlib.crc32(tag + payload) & 0xFFFFFFFF))

    out = (b"\x89PNG\r\n\x1a\n"
           + chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0))
           + chunk(b"IDAT", zlib.compress(raw, 9))
           + chunk(b"IEND", b""))
    with open(path, "wb") as f:
        f.write(out)


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
            blp = None if args.no_client else client.icon_blp(name)
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
