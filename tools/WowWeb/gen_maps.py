#!/usr/bin/env python3
"""Build the zone maps and the world-coordinate boxes that place things on them.

A creature has a spawn point (map, x, y) and a quest an objective point; showing
either on a map needs two things:

  * the map's artwork, from the client's Interface\\WorldMap\\<Zone>\\.blp files
  * the zone's world-coordinate box, from the client's WorldMapArea.dbc

The box is what makes the coordinates meaningful. Its four floats are not named
the way one would guess: the field the file calls "left" holds the maximum Y and
"right" the minimum Y, while "top"/"bottom" hold the maximum and minimum X. That is
why the conversion swaps the axes, which is also what the AoWoW this site replaces
does (`coord_db2wow` in its includes/game.php):

    x% = 100 - (y - y_min) / (y_max - y_min) * 100
    y% = 100 - (x - x_min) / (x_max - x_min) * 100

Checked against the game: the Goldshire innkeeper stands at world (-9466.4, 21.4)
and the inn is at 42, 66 on the Elwynn map; the box gives 43.6, 66.0.

The artwork is not one file per zone but twelve, 256x256 each, which the client
lays out as a 4-wide, 3-tall grid: WorldMapFrame.xml anchors WorldMapDetailTile1
through 4 left to right, 5 through 8 below them and 9 through 12 below those,
inside a WorldMapDetailFrame that is 1002x668. WorldMapFrame.lua loads them as
Interface\\WorldMap\\<map>\\<map><1..12> and puts a point at
`x * WorldMapDetailFrame:GetWidth()`, so the drawing is exactly the frame's
1002x668 and the tile grid is 22 pixels wider and 100 taller than what is shown.

Serving tile 1 alone - which this generator did until the maps were checked against
that XML - shows the north-west corner of a zone, and puts every dot in the wrong
place on it, because a percentage of the whole zone was being drawn on a twelfth of
the picture. Hence: assemble the twelve, crop to the frame, then scale.

The tiles are terrain, though. A settlement is a painting of its own:
WorldMapOverlay.dbc holds one row per landmark of a zone (`GADGETZAN`,
`CAVERNSOFTIME`, ...) giving the name, the size the painting is drawn at, the pixel
offset in the frame and a hit rectangle. WorldMapFrame.lua draws every overlay of
the current map area on top of the tiles, which is why the terrain has bare dunes
where Gadgetzan stands and the town, its walls and its name are in the overlay.
Without the overlays the maps read as terrain with no places on it - which is the
"this map shows no details" half of the same complaint.

The labels are painted into the artwork, so *which* client the files come from
decides what language they are in. The verified file list (clientfiles.py) carries
Turtle's EU patches only - patch-8 and patch-9, named patch_EU and hotfix_EU - and a
client loads those *before* its own patch-X and patch-Z. Taking the art from the list
therefore ships "Gadgetzan" where the game shows "加基森": the labels are in the
files, and the files that win in the client are the ones with the Chinese ones. So a
client install is the authoritative source and the list is the fallback:

    python3 tools/WowWeb/gen_maps.py --client /path/to/wow-client

Writes:

  internal/web/assets/maps/<zone>.png   one per zone, paletted, half size
  internal/web/mapzones.txt             area id -> directory, map, bounds

Usage:

    python3 tools/WowWeb/gen_maps.py --client /path/to/wow-client   # the real thing
    python3 tools/WowWeb/gen_maps.py --no-client                     # from the file list
    python3 tools/WowWeb/gen_maps.py --scale 1                       # keep the frame's size

Files are looked for in this order, and the run reports how many came from each:

  1. the client's own MPQs, highest patch priority first (--client)
  2. files an earlier run extracted into the shared cache
  3. the CDN file list, which only has the EU patches

Without a client the tool still works, but every label on every map is whatever the
EU patches happen to say.
"""

import argparse
import os
import struct
import sys
from concurrent.futures import ProcessPoolExecutor

from blp import quantize, read_blp, write_paletted_png
from clientfiles import Client, client_key, read_dbc, safe_name

HERE = os.path.dirname(os.path.abspath(__file__))
MANIFEST = os.path.normpath(os.path.join(HERE, "..", "dbc_verification", "manifest_formatted.json"))
CACHE = os.path.join(os.path.expanduser("~"), ".cache", "tw-icons")

# The client keeps its zone maps at this path; the trailing number picks one of the
# twelve tiles, in the order WorldMapFrame.xml places them, or one piece of a
# landmark painting.
CLIENT_MAP = "Interface\\WorldMap\\%s\\%s%d.blp"
TILES = 12
TILE = 256
TILES_WIDE = 4
# WorldMapDetailFrame's size in WorldMapFrame.xml. The assembled tiles are
# 1024x768, and this is the part of that grid the client ever draws.
FRAME_W, FRAME_H = 1002, 668

# WorldMapOverlay.dbc, in the order GetMapOverlayInfo hands it to WorldMapFrame.lua.
# Which column holds what was read off the data: column 3 through 7 decode to
# fragments that name no file, while column 8 names the file in all 707 rows.
OVERLAY_NAME = 8                # the painting's name
OVERLAY_SIZE = slice(9, 11)     # width, height the painting is drawn at
OVERLAY_OFFSET = slice(11, 13)  # x, y of its top-left corner in the frame
OVERLAY_HIT = slice(13, 17)     # top, left, bottom, right of the clickable part


def float_at(row, index):
    """A DBC field that holds a float rather than an integer."""
    return struct.unpack("<f", struct.pack("<I", row[index]))[0]


def cache_name(path):
    """The name extract_client_files.py gives an extracted file."""
    return safe_name(client_key(path))


def local_name(zone_dir):
    """The output file of a zone, and the directory part of its image path."""
    return "".join(c if (c.isalnum() or c in "-_") else "_" for c in zone_dir.lower())


def tile_paths(zone_dir):
    return [CLIENT_MAP % (zone_dir, zone_dir, i + 1) for i in range(TILES)]


def overlay_parts(zone_dir, name, width, height):
    """The files one landmark painting is made of, and where each part is drawn.

    A painting wider or taller than 256 pixels ships as several 256x256 pieces, laid
    out left to right and top to bottom. WorldMapFrame.lua walks them the same way
    and takes the top-left corner of each piece (`SetTexCoord(0, w/256, ...)`, the
    file itself padded to the next power of two, the padding never drawn).
    """
    wide = (width + TILE - 1) // TILE
    tall = (height + TILE - 1) // TILE
    parts = []
    for j in range(tall):
        for k in range(wide):
            parts.append((CLIENT_MAP % (zone_dir, name, j * wide + k + 1),
                          256 * k, 256 * j,
                          min(TILE, width - 256 * k), min(TILE, height - 256 * j)))
    return parts


CLIENT_HINT = (
    "这条路走的是 CDN 清单，而清单里只有 EU 的 patch-8/patch-9；客户端自己的 patch-X/Z\n"
    "优先级更高，中文地名就在那里面。加上 --client <客户端目录> 让客户端说了算。"
)


class Sources:
    """Where each file came from, in the order that decides who wins.

    A client install beats an earlier extraction, and both beat the CDN list: the
    list only carries the EU patches, so a label that was localized in the client
    is English in the list's copy of the same file.
    """

    def __init__(self, client_reader, blp_dir, client):
        self.client_reader = client_reader
        self.blp_dir = blp_dir
        self.client = client
        self.counts = {}
        self.missing = []

    def found(self, path):
        if self.client_reader is not None:
            local = self.client_reader(path)
            if local:
                self.counts["客户端"] = self.counts.get("客户端", 0) + 1
                return local
        candidate = os.path.join(self.blp_dir, cache_name(path))
        if os.path.isfile(candidate):
            self.counts["本地抽取"] = self.counts.get("本地抽取", 0) + 1
            return candidate
        if self.client is not None:
            local = self.client.fetched(path)
            if local:
                self.counts["CDN"] = self.counts.get("CDN", 0) + 1
                return local
        self.missing.append(path)
        return None

    def report(self):
        parts = ["%s %d" % (name, count) for name, count in sorted(self.counts.items())]
        print("取文件：" + ("，".join(parts) if parts else "一个都没有"))
        if self.counts.get("CDN") and not self.counts.get("客户端"):
            print("注意：这次没有任何文件来自客户端安装。")
            print("      " + CLIENT_HINT)


def client_reader(root, cache_dir):
    """A path -> local file lookup straight out of an installed client's archives.

    Highest patch priority first, exactly as the client loads them, so the copy
    that comes out is the copy the game would use. Extracted files are cached, so
    a second run does not touch the MPQs.
    """
    import extract_client_files as extract

    data_dir = None
    for candidate in ("Data", "data"):
        if os.path.isdir(os.path.join(root, candidate)):
            data_dir = os.path.join(root, candidate)
            break
    if data_dir is None:
        sys.exit("no Data directory below %s" % root)

    archives = []
    for name in sorted(os.listdir(data_dir)):
        if not name.lower().endswith(".mpq"):
            continue
        try:
            archives.append(extract.Archive(os.path.join(data_dir, name)))
        except OSError as exc:
            print("跳过 %s（%s）" % (name, exc))
    if not archives:
        sys.exit("no readable MPQ archives in %s" % data_dir)
    archives.sort(key=lambda a: extract.patch_priority(os.path.basename(a.path)), reverse=True)
    print("客户端 %s：%d 个 MPQ，按补丁优先级降序" % (root, len(archives)))
    os.makedirs(cache_dir, exist_ok=True)

    def read(path):
        dest = os.path.join(cache_dir, cache_name(path))
        if os.path.isfile(dest):
            return dest
        want = path.replace("/", "\\")
        for archive in archives:
            data = archive.read(want)
            if data:
                with open(dest, "wb") as f:
                    f.write(data)
                return dest
        return None

    return read


def find_zone(sources, string, area_row_id, zone_dir, overlays):
    """Everything a zone is drawn from, and every file that could not be found.

    Returns the twelve tile files and the landmark paintings, each painting being
    the parts to read with the place in the frame each of them goes.
    """
    tiles = []
    for path in tile_paths(zone_dir):
        local = sources.found(path)
        if local is not None:
            tiles.append(local)

    paintings = []
    for row in overlays.get(area_row_id, []):
        name = string(row[OVERLAY_NAME]).strip()
        if not name:
            continue
        width, height = row[OVERLAY_SIZE]
        offset_x, offset_y = row[OVERLAY_OFFSET]
        parts = []
        for path, dx, dy, part_w, part_h in overlay_parts(zone_dir, name, width, height):
            local = sources.found(path)
            if local is None:
                continue
            parts.append((local, offset_x + dx, offset_y + dy, part_w, part_h))
        if parts:
            paintings.append((row, parts))
    return tiles, paintings


def assemble(tile_files, paintings):
    """The frame the client draws: the twelve tiles, then the landmark paintings."""
    canvas = [[None] * (TILES_WIDE * TILE) for _ in range(TILES * TILE // TILES_WIDE)]
    for index, path in enumerate(tile_files):
        w, h, image = read_blp(path)
        if (w, h) != (TILE, TILE):
            raise ValueError("%s is %dx%d, not %dx%d" % (path, w, h, TILE, TILE))
        row0, col = divmod(index, TILES_WIDE)
        for y in range(TILE):
            line = canvas[row0 * TILE + y]
            source = image[y]
            for x in range(TILE):
                line[col * TILE + x] = source[x]

    for _row, parts in paintings:
        for path, dx, dy, part_w, part_h in parts:
            w, h, image = read_blp(path)
            for y in range(part_h):
                fy = dy + y
                if not 0 <= fy < FRAME_H or y >= h:
                    continue
                line = canvas[fy]
                source = image[y]
                for x in range(part_w):
                    fx = dx + x
                    if 0 <= fx < FRAME_W and x < w and source[x][3]:
                        line[fx] = source[x]

    return [row[:FRAME_W] for row in canvas[:FRAME_H]]


def content_box(rows):
    """The bounding box of the drawn part, for the "is this the whole map?" check.

    Every zone map fills the frame exactly, so this has to come out as the whole
    thing. A smaller box means the client grew a map that is not laid out the way
    WorldMapFrame.xml says, and the tiles being assembled are not that map.
    """
    minx, miny, maxx, maxy = FRAME_W, FRAME_H, -1, -1
    for y, row in enumerate(rows):
        for x, px in enumerate(row):
            if px[3]:
                if x < minx:
                    minx = x
                if x > maxx:
                    maxx = x
                if y < miny:
                    miny = y
                if y > maxy:
                    maxy = y
    return minx, miny, maxx, maxy


def shrink(rows, factor):
    """Box-filter the painting down by an integer factor."""
    if factor <= 1:
        return [[px[:3] for px in row] for row in rows]
    out = []
    for y in range(0, len(rows) - factor + 1, factor):
        line = []
        for x in range(0, len(rows[0]) - factor + 1, factor):
            r = g = b = 0
            for dy in range(factor):
                src = rows[y + dy]
                for dx in range(factor):
                    px = src[x + dx]
                    r += px[0]
                    g += px[1]
                    b += px[2]
            n = factor * factor
            line.append((r // n, g // n, b // n))
        out.append(line)
    return out


def mean_error(rows, palette, indices):
    """Mean absolute difference the palette costs, per channel. Reported, not used."""
    total = 0
    for y, row in enumerate(rows):
        for x, px in enumerate(row):
            entry = palette[indices[y][x]]
            total += abs(px[0] - entry[0]) + abs(px[1] - entry[1]) + abs(px[2] - entry[2])
    return total / (len(rows) * len(rows[0]) * 3)


def build_zone(job):
    """One zone: read the tiles and the paintings, assemble, shrink, quantize, write."""
    zone_dir, tiles, paintings, out_path, scale, colors = job
    try:
        rows = assemble(tiles, paintings)
    except Exception as exc:  # noqa: BLE001 - reported, not fatal
        return zone_dir, None, None, str(exc)
    box = content_box(rows)
    note = "" if box == (0, 0, FRAME_W - 1, FRAME_H - 1) else \
        "画出来的内容只有 %d,%d..%d,%d" % box
    small = shrink(rows, scale)
    palette, indices = quantize(small, colors=colors)
    write_paletted_png(out_path, len(small[0]), len(small), palette, indices)
    return zone_dir, mean_error(small, palette, indices), len(paintings), note


def check_hit_rect(row):
    """The field layout check: the clickable rectangle has to be inside the painting.

    Nothing in the DBC names its columns; the sizes and offsets above were read by
    following the order GetMapOverlayInfo returns. This is what says that reading is
    right: it holds for all 707 rows of this client, and none of them under any other
    arrangement of the same fields.
    """
    width, height = row[OVERLAY_SIZE]
    offset_x, offset_y = row[OVERLAY_OFFSET]
    top, left, bottom, right = row[OVERLAY_HIT]
    if not (offset_x <= left and right <= offset_x + width
            and offset_y <= top and bottom <= offset_y + height):
        return "第 %d 行的命中框不在画内：%s" % (row[0], row)
    return ""


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--scale", type=int, default=2,
                    help="shrink the 1002x668 frame by this factor (default 2)")
    ap.add_argument("--colors", type=int, default=256, help="palette size (default 256)")
    ap.add_argument("--jobs", type=int, default=0, help="zones to build at once (default: cpu count)")
    ap.add_argument("--client", default=None,
                    help="an installed client; its MPQs decide which files win (see the module doc)")
    ap.add_argument("--client-cache", default=None,
                    help="where files read from --client are cached (default: <cache>/client)")
    ap.add_argument("--no-client", action="store_true", help="do not download from the CDN")
    ap.add_argument("--cache", default=CACHE, help="where downloaded/extracted files live")
    ap.add_argument("--blp-dir", default=None,
                    help="where extract_client_files.py put the files (default: <cache>/blps)")
    ap.add_argument("--manifest", default=MANIFEST, help="the client's file list with hashes")
    ap.add_argument("--out", default=os.path.join(HERE, "internal", "web", "assets", "maps"),
                    help="where the map images go")
    ap.add_argument("--data", default=os.path.join(HERE, "internal", "web", "mapzones.txt"),
                    help="where the zone boxes go")
    args = ap.parse_args()

    blp_dir = args.blp_dir or os.path.join(args.cache, "blps")
    client = None if args.no_client else Client(args.manifest, args.cache)
    client_reader_func = None
    if args.client:
        if not os.path.isdir(args.client):
            sys.exit("no such client directory: %s" % args.client)
        client_reader_func = client_reader(
            args.client, args.client_cache or os.path.join(args.cache, "client"))
    sources = Sources(client_reader_func, blp_dir, client)

    def dbc(name):
        """A client DBC: from the CDN, or from an earlier run's cache."""
        path = client.fetched(name) if client else None
        if path is None:
            path = os.path.join(args.cache, safe_name(client_key(name)))
            if not os.path.isfile(path):
                sys.exit("no %s: the manifest has none and %s is missing" % (name, path))
        return read_dbc(path)

    area_rows, area_string = dbc("DBFilesClient/WorldMapArea.dbc")
    overlay_rows, overlay_string = dbc("DBFilesClient/WorldMapOverlay.dbc")

    # The overlay table is keyed by the WorldMapArea row, not by the area id: the
    # paintings of a zone hang off the row that draws it.
    overlays = {}
    hit_problems = []
    for row in overlay_rows:
        overlays.setdefault(row[1], []).append(row)
        problem = check_hit_rect(row)
        if problem:
            hit_problems.append(problem)

    os.makedirs(args.out, exist_ok=True)
    boxes, jobs, skipped, seen = [], [], [], {}
    for row in area_rows:
        area, row_id = row[2], row[0]
        zone_dir = area_string(row[3]).strip()
        if not zone_dir or area == 4294967295:
            continue
        # Area 0 is the continent row ("Azeroth", "Kalimdor"). It is kept: it is the
        # box that catches a point in a zone the client gives no map of its own, and
        # the lookup prefers the smallest box, so a real zone still wins wherever
        # there is one.
        # See the module comment: the file's names are rotated against the axes.
        y_max, y_min = float_at(row, 4), float_at(row, 5)
        x_max, x_min = float_at(row, 6), float_at(row, 7)
        if x_max == x_min or y_max == y_min:
            continue

        if zone_dir not in seen:
            seen[zone_dir] = find_zone(sources, overlay_string, row_id, zone_dir, overlays)
        tiles, paintings = seen[zone_dir]
        if len(tiles) < TILES or not paintings and overlays.get(row_id):
            if zone_dir not in skipped:
                skipped.append(zone_dir)
            continue
        jobs.append((zone_dir, tiles, paintings,
                     os.path.join(args.out, local_name(zone_dir) + ".png"), args.scale, args.colors))
        boxes.append((area, zone_dir, row[1], x_min, x_max, y_min, y_max))

    sources.report()

    # The field-layout check is about the DBC, not a zone: report it once.
    for problem in hit_problems[:3]:
        print("注意 " + problem)
    if len(hit_problems) > 3:
        print("注意 还有 %d 行的命中框不对" % (len(hit_problems) - 3))

    workers = args.jobs or (os.cpu_count() or 1)
    built, worst, paintings_drawn = {}, 0.0, 0
    with ProcessPoolExecutor(max_workers=workers) as pool:
        for zone_dir, error, count, note in pool.map(build_zone, jobs):
            if error is None:
                print("跳过 %s（%s）" % (zone_dir, count))
                continue
            if note:
                print("注意 %s：%s" % (zone_dir, note))
            built[local_name(zone_dir)] = error
            paintings_drawn += count or 0
            worst = max(worst, error)

    # A zone whose tiles did not assemble is dropped from the table, so a point in it
    # falls back to the continent box, which still has a map.
    lines = ["\t".join([str(area), local_name(zone_dir), str(map_id),
                        "%.2f" % x_min, "%.2f" % x_max, "%.2f" % y_min, "%.2f" % y_max])
             for area, zone_dir, map_id, x_min, x_max, y_min, y_max in boxes
             if local_name(zone_dir) in built]
    total_kb = sum(os.path.getsize(os.path.join(args.out, line.split("\t")[1] + ".png")) // 1024
                   for line in lines)

    with open(args.data, "w", encoding="utf-8") as f:
        f.write("# area id -> zone map, generated by tools/WowWeb/gen_maps.py\n")
        f.write("# <area>\t<directory>\t<mapID>\t<x_min>\t<x_max>\t<y_min>\t<y_max>\n")
        f.write("# the image is assets/maps/<directory>.png: the client's %dx%d zone map\n"
                % (FRAME_W, FRAME_H))
        f.write("# (twelve tiles in a 4x3 grid, plus the WorldMapOverlay.dbc paintings on\n")
        f.write("# top, see WorldMapFrame.xml) shrunk by %d\n" % args.scale)
        f.write("# the box is in world coordinates\n")
        f.write("\n".join(lines) + "\n")

    needed_path = os.path.join(args.cache, "needed-maps.txt")
    with open(needed_path, "w", encoding="utf-8") as f:
        f.write("\n".join(sources.missing) + ("\n" if sources.missing else ""))

    print("区域：%d 个有坐标框" % len(lines))
    print("地图：写出 %d 张，共 %.1f MB，%d 幅地标画，最差平均误差 %.2f" %
          (len(lines), total_kb / 1024, paintings_drawn, worst))
    print("文件：%s" % args.data)
    if skipped:
        print("\n%d 个区域缺文件，已从表里去掉（落在这些区域的点会画到大陆图上）：" % len(skipped))
        print("   " + "、".join(sorted(skipped)[:10]) + ("…" if len(skipped) > 10 else ""))
        if not args.client:
            print("  试过的地方记在 %s；用客户端再跑一遍能补全，而且地名是中文的：" % needed_path)
            print("    python3 tools/WowWeb/gen_maps.py --client <客户端目录>")


if __name__ == "__main__":
    main()
