#!/usr/bin/env python3
"""Build the zone maps and the world-coordinate boxes that place things on them.

A creature has a spawn point (map, x, y) and a quest an objective point; showing
either on a map needs two things:

  * the map's artwork, from the client's Interface\\WorldMap\\<Zone>\\<Zone>1.blp
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

Writes:

  internal/web/assets/maps/<zone>.png   one per zone, 256x256 as the client has it
  internal/web/mapzones.txt             area id -> directory, map, bounds

Usage:

    python3 tools/WowWeb/gen_maps.py                 # writes both, using the cache
    python3 tools/WowWeb/gen_maps.py --size 2        # a different tile variant

The artwork comes from a client (the file list this site verifies against does not
carry the base world maps). gen_maps.py writes the list of files it needs; pull
them out with extract_client_files.py, on a machine that has the client:

    python3 tools/WowWeb/extract_client_files.py --client /path/to/wow-client
    python3 tools/WowWeb/gen_maps.py
"""

import argparse
import os
import struct
import sys

from blp import Unsupported, read_blp, write_png
from clientfiles import Client, read_dbc

HERE = os.path.dirname(os.path.abspath(__file__))
MANIFEST = os.path.normpath(os.path.join(HERE, "..", "dbc_verification", "manifest_formatted.json"))
CACHE = os.path.join(os.path.expanduser("~"), ".cache", "tw-icons")

# The client keeps its zone maps at this path; the trailing number picks one of
# the variants it ships (all 256x256 in this client, nearly identical).
CLIENT_MAP = "Interface\\WorldMap\\%s\\%s%d.blp"


def float_at(row, index):
    """A DBC field that holds a float rather than an integer."""
    return struct.unpack("<f", struct.pack("<I", row[index]))[0]


def cache_name(path):
    """The name extract_client_files.py gives an extracted file."""
    return "".join(c if (c.isalnum() or c in "_.-") else "_" for c in path.lower())


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--size", type=int, default=1, help="which map variant to use (default 1)")
    ap.add_argument("--cache", default=CACHE, help="where extracted client files live")
    ap.add_argument("--manifest", default=MANIFEST, help="the client's file list with hashes")
    ap.add_argument("--out", default=os.path.join(HERE, "internal", "web", "assets", "maps"),
                    help="where the map images go")
    ap.add_argument("--data", default=os.path.join(HERE, "internal", "web", "mapzones.txt"),
                    help="where the zone boxes go")
    args = ap.parse_args()

    client = Client(args.manifest, args.cache)
    local = client.fetched("DBFilesClient/WorldMapArea.dbc")
    if local is None:
        sys.exit("the manifest has no WorldMapArea.dbc")
    rows, string = read_dbc(local)

    os.makedirs(args.out, exist_ok=True)
    blp_dir = os.path.join(args.cache, "blps")

    lines = []
    drawn = missing = 0
    needed = []
    for row in rows:
        area = row[2]
        zone_dir = string(row[3]).strip()
        if not zone_dir or area == 4294967295:
            continue
        # Area 0 is the continent row ("Azeroth", "Kalimdor"). It is kept: it is
        # the box that catches a point in a zone the client gives no map of its
        # own, and the lookup prefers the smallest box, so a real zone still wins
        # wherever there is one.
        # See the module comment: the file's names are rotated against the axes.
        y_max, y_min = float_at(row, 4), float_at(row, 5)
        x_max, x_min = float_at(row, 6), float_at(row, 7)
        if x_max == x_min or y_max == y_min:
            continue

        safe = "".join(c if (c.isalnum() or c in "-_") else "_" for c in zone_dir.lower())
        lines.append("\t".join([str(area), safe, str(row[1]),
                                "%.2f" % x_min, "%.2f" % x_max,
                                "%.2f" % y_min, "%.2f" % y_max]))

        path = CLIENT_MAP % (zone_dir, zone_dir, args.size)
        source = os.path.join(blp_dir, cache_name(path))
        if not os.path.isfile(source):
            needed.append(path)
            missing += 1
            continue
        try:
            w, h, image = read_blp(source)
        except Unsupported as exc:
            print("跳过 %s（%s）" % (zone_dir, exc))
            missing += 1
            continue
        write_png(os.path.join(args.out, safe + ".png"), w, h, image)
        drawn += 1

    with open(args.data, "w", encoding="utf-8") as f:
        f.write("# area id -> zone map, generated by tools/WowWeb/gen_maps.py\n")
        f.write("# <area>\t<directory>\t<mapID>\t<x_min>\t<x_max>\t<y_min>\t<y_max>\n")
        f.write("# the image is assets/maps/<directory>.png; the box is in world coordinates\n")
        f.write("\n".join(lines) + "\n")

    needed_path = os.path.join(args.cache, "needed-maps.txt")
    with open(needed_path, "w", encoding="utf-8") as f:
        f.write("\n".join(needed) + ("\n" if needed else ""))

    print("区域：%d 个有坐标框" % len(lines))
    print("地图：画出 %d 张，缺 %d 张 → %s" % (drawn, missing, args.out))
    print("文件：%s（%.1f KB）" % (args.data, os.path.getsize(args.data) / 1024))
    if missing:
        print("\n缺的图要从客户端取（在装有客户端的机器上跑）：")
        print("    python3 tools/WowWeb/extract_client_files.py --client <客户端目录>")
        print("  要取的文件清单已经写到 %s" % needed_path)


if __name__ == "__main__":
    main()
