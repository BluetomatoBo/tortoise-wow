#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""gen_zonegrid.py — 从客户端 ADT 生成 internal/web/zonegrid.txt：坐标→区域网格。

# 为什么

`mapzones.txt` 的框是**区域地图图片**的世界范围（来自 WorldMapArea.dbc），带邻区边缘，
相邻区域互相重叠；只按「最小的框」判归属，在小框其实只是边距的地方就会标错
（血色领地圈住东瘟疫的提尔之手、木喉要塞圈住费伍德、时光之穴圈住塔纳利斯……萨矿这类
满世界刷的物件一页上就会有好几张错图）。

游戏自己不是这么判的：服务端读的是地图文件里的**区域网格**——`GridMap::getArea()`
（`src/game/Maps/GridMap.cpp`）把世界坐标换算成瓦片里的 MCNK 块，取该块的 `areaid`；
那些 `.map` 文件是 `tools/extractor` 从客户端 ADT 的 MCNK 里抄出来的。所以这张网格
就是客户端 ADT 的 MCNK `areaid`：

    gx = int(32 - y / 533.3333)          # 瓦片名里的第一个数（注意轴是对调的）
    gy = int(32 - x / 533.3333)
    lx = int(16 * (32 - x / 533.3333)) & 15
    ly = int(16 * (32 - y / 533.3333)) & 15
    area = MCNK(gx, gy, ix=lx, iy=ly).areaid

# 区域号怎么变成页面上的地图

`area_template`（服务端自己的区域表，含乌龟服新增区域）给出 area → 父 zone：
先看该 area 自己有没有地图（mapzones 里有框），没有就取 `zone_id` 那张地图。
两条都没有的格子不写进文件，页面回落到原来的「最小框 + zonefix 修正」。

# 数据来源有两处，按优先级：

1. **乌龟服客户端自己改过的瓦片**：仓库的客户端清单（`tools/dbc_verification/manifest_formatted.json`）
   里逐文件列了 418 个 ADT（含 cncdn.turtlecraft.gg 直链），哈希校验后缓存到本地。实测
   它们与原版瓦片的区域号**确实不同**（北郡那格原版是 Elwynn 12，Turtle 版是 5587），
   所以优先用它们——那才是玩家客户端里真正的地形。
2. 其余瓦片用**本机原版客户端**（`--client`，默认 `~/Downloads/WoW_Classic`）的 MPQ。

```bash
python3 tools/WowWeb/gen_zonegrid.py \
    --mysql "tools/dbdiff/mysql_local.sh tw_world"
```
"""

import argparse
import collections
import os
import struct
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_OUT = os.path.join(HERE, "internal", "web", "zonegrid.txt")

GRID = 533.3333333          # 一个 ADT 瓦片的边长（码）
CELLS = 16                  # 一个瓦片里的 MCNK 块数（每边）
CELL_SIZE = GRID / CELLS    # 33.3333 码，也是网格的最小格

# 远端 ADT（副本等）没有区域地图，跳过；只做两张大陆图。
CONTINENTS = (("Azeroth", 0), ("Kalimdor", 1))


def load_zones(path):
    """mapzones.txt → {(map, area): dir}、{dir: area}，以及每个地图上的框列表。"""
    by_area, by_dir = {}, {}
    by_map = collections.defaultdict(list)
    for line in open(path, encoding="utf-8"):
        if line.startswith("#") or not line.strip():
            continue
        area, directory, map_id, x1, x2, y1, y2 = line.split("\t")
        entry = dict(area=int(area), dir=directory, map=int(map_id), x1=float(x1), x2=float(x2),
                     y1=float(y1), y2=float(y2))
        by_area[(entry["map"], entry["area"])] = directory
        by_dir[directory] = entry["area"]
        by_map[entry["map"]].append(entry)
    return by_area, by_dir, by_map


def extent(box):
    return (box["x2"] - box["x1"]) * (box["y2"] - box["y1"])


def box_rule(by_map, map_id, x, y):
    """页面回落时用的规则：包含该点、面积最小的框。"""
    inside = [b for b in by_map[map_id] if b["x1"] <= x <= b["x2"] and b["y1"] <= y <= b["y2"]]
    if not inside:
        return None
    return min(inside, key=extent)["dir"]


def load_area_zones(mysql):
    """area_template → {area: (map_id, zone_id)}。"""
    out = {}
    query = "SELECT entry, map_id, zone_id FROM area_template;"
    import subprocess
    res = subprocess.run(mysql.split() + ["-e", query], capture_output=True, text=True)
    if res.returncode != 0:
        sys.exit("读 area_template 失败：%s" % (res.stderr.strip() or res.returncode))
    for line in res.stdout.split("\n")[1:]:
        parts = line.split("\t")
        if len(parts) < 3 or not parts[0].strip():
            continue
        try:
            out[int(parts[0])] = (int(parts[1]), int(parts[2]))
        except ValueError:
            continue
    return out


def open_archives(data_dir):
    """按补丁优先级降序打开 Data/*.MPQ。"""
    sys.path.insert(0, HERE)
    import extract_client_files as extract
    priority = ["patch-9", "patch-8", "patch-7", "patch-6", "patch-5", "patch-4", "patch-3",
                "patch-2", "patch", "terrain", "wmo", "model", "texture", "dbc", "misc",
                "base", "backup"]

    def rank(name):
        stem = os.path.splitext(os.path.basename(name))[0].lower()
        return priority.index(stem) if stem in priority else len(priority)

    archives = []
    for name in sorted(os.listdir(data_dir)):
        if not name.lower().endswith(".mpq"):
            continue
        try:
            archives.append(extract.Archive(os.path.join(data_dir, name)))
        except OSError:
            continue
    archives.sort(key=lambda a: rank(a.path))
    return archives


def vanilla_areas(client_dir):
    """本机原版客户端 AreaTable 的区域号集合：不在里面的区域就是乌龟服新增的。"""
    systems = []
    sys.path.insert(0, HERE)
    import extract_client_files as extract
    from clientfiles import read_dbc
    data_dir = os.path.join(client_dir, "Data")
    for name in ("dbc.MPQ", "terrain.MPQ", "patch-2.MPQ", "patch.MPQ", "base.MPQ", "backup.MPQ",
                 "model.MPQ", "texture.MPQ", "wmo.MPQ", "misc.MPQ", "interface.MPQ", "fonts.MPQ",
                 "sound.MPQ", "speech.MPQ", "speech2.MPQ"):
        path = os.path.join(data_dir, name)
        if not os.path.isfile(path):
            continue
        try:
            systems.append(extract.Archive(path))
        except OSError:
            continue
    for system in systems:
        raw = system.read("DBFilesClient\\AreaTable.dbc")
        if not raw:
            continue
        tmp = os.path.join(tempfile.gettempdir(), "wowweb-vanilla-areatable.dbc")
        with open(tmp, "wb") as fh:
            fh.write(raw)
        rows, _ = read_dbc(tmp)
        return {row[0] for row in rows}
    return set()


def read_adt(archives, client, map_dir, gx, gy):
    """一个瓦片：优先清单里（乌龟服改过的）那份，否则本机原版客户端。"""
    if client is not None:
        path = client.fetched("world/maps/%s/%s_%d_%d.adt" % (map_dir.lower(), map_dir.lower(), gx, gy))
        if path:
            with open(path, "rb") as fh:
                return fh.read()
    want = "World\\Maps\\%s\\%s_%d_%d.adt" % (map_dir, map_dir, gx, gy)
    for archive in archives:
        data = archive.read(want)
        if data:
            return data
    return None


def chunks(data, known_areas):
    """ADT 的 MCNK：{(ix, iy): areaid}。

    这个客户端（1.12 简中）把块标识写成了倒序：文件里是 `KNCM` 而不是 `MCNK`，
    数值字段仍是小端。按倒序标识扫描，再按正常偏移读 ix/iy/areaid。

    扫描会撞上假阳性：极少数瓦片的贴图数据里正好出现 `KNCM` 这四个字节。所以只收
    ix/iy 在 0..15 且 areaid 在 `area_template` 里出现过的块——三张瓦片里因此各少了
    一两个假块，真块一个都不少。
    """
    out = {}
    pos = 0
    while True:
        at = data.find(b"KNCM", pos)
        if at < 0:
            break
        if at + 8 + 0x38 <= len(data):
            ix, iy = struct.unpack_from("<2I", data, at + 8 + 4)
            area = struct.unpack_from("<I", data, at + 8 + 0x34)[0]
            if ix <= 15 and iy <= 15 and (area == 0 or area in known_areas):
                out[(ix, iy)] = area
        pos = at + 4
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[1],
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--client", default=os.path.expanduser("~/Downloads/WoW_Classic"),
                    help="原版客户端根目录（里面有 Data/*.MPQ）")
    ap.add_argument("--manifest", default=os.path.join(HERE, "..", "dbc_verification",
                                                       "manifest_formatted.json"),
                    help="客户端清单：里面列了乌龟服改过的瓦片")
    ap.add_argument("--cache", default=os.path.join(tempfile.gettempdir(), "wowweb-zonegrid"),
                    help="清单瓦片的下载缓存目录")
    ap.add_argument("--mysql", required=True, help="读 area_template 的命令")
    ap.add_argument("--zones", default=os.path.join(HERE, "internal", "web", "mapzones.txt"))
    ap.add_argument("--out", default=DEFAULT_OUT)
    args = ap.parse_args()

    zones_by_area, zones_by_dir, boxes_by_map = load_zones(args.zones)
    area_zone = load_area_zones(args.mysql)
    known_areas = set(area_zone)

    # 乌龟服新增的区域：原版客户端的 AreaTable 里没有它们。这些区域的**地形瓦片是原版的**，
    # 地形里的区域号属于旁边的老区域（吉尔尼斯半岛在原版数据里就是希尔斯布莱德），
    # 而它们自己的区域号只出现在服务端表里。所以：区域号是新增的、且框规则也判给它的格子
    # 不写进网格，页面回落到框规则——否则吉尔尼斯、拉皮迪斯这类区域的怪会被判给邻居。
    vanilla = vanilla_areas(args.client)
    custom_dirs = {d for (m, a), d in zones_by_area.items() if a and a not in vanilla}
    print("乌龟服新增区域 %d 个（%s）：它们的地形是老区域的，网格会按地形给答案，"
          "靠 gen_zonefix.py 的修正表把它们自己的内容抢回来"
          % (len(custom_dirs), ", ".join(sorted(custom_dirs)[:8])))
    archives = open_archives(os.path.join(args.client, "Data"))
    print("客户端 %s：%d 个 MPQ" % (args.client, len(archives)))

    client = None
    if os.path.isfile(args.manifest):
        sys.path.insert(0, HERE)
        from clientfiles import Client
        client = Client(args.manifest, args.cache)
        print("清单 %s：%d 个文件（含乌龟服改过的瓦片，会下载并校验哈希）"
              % (os.path.basename(args.manifest), len(client.entries)))
    else:
        print("没有清单文件，只用本机原版客户端")

    # rows[(map, cell_y)] = {cell_x: dir}
    rows = collections.defaultdict(dict)
    stats = collections.Counter()
    unresolved = collections.Counter()
    tiles = 0
    for map_dir, map_id in CONTINENTS:
        for gx in range(64):
            for gy in range(64):
                data = read_adt(archives, client, map_dir, gx, gy)
                if data is None:
                    continue
                tiles += 1
                for (ix, iy), area in chunks(data, known_areas).items():
                    if not area:
                        stats["空格子（area 0）"] += 1
                        continue
                    directory = zones_by_area.get((map_id, area))
                    if directory is None:
                        parent = area_zone.get(area)
                        if parent is not None:
                            directory = zones_by_area.get((parent[0], parent[1]))
                    if directory is None:
                        stats["区域没有地图"] += 1
                        unresolved[area] += 1
                        continue
                    cell_x = (32 - gy) * CELLS - iy - 1
                    cell_y = (32 - gx) * CELLS - ix - 1
                    rows[(map_id, cell_y)][cell_x] = directory
                    stats[directory] += 1
        print("  %s：已读 %d 个瓦片，累计 %d 格" % (map_dir, tiles, sum(len(r) for r in rows.values())))

    total = sum(len(r) for r in rows.values())
    print("有归属的格子 %d 个（%d 行，%d 个区域）" % (total, len(rows), len(stats) - 2))
    print("统计：空格子 %d，区域没有地图 %d" % (stats["空格子（area 0）"], stats["区域没有地图"]))
    if unresolved:
        top = ", ".join("%d×%d" % (a, n) for a, n in unresolved.most_common(8))
        print("  没有地图的区域号（前 8）：%s" % top)

    with open(args.out, "w", encoding="utf-8") as fh:
        fh.write("# 坐标 → 区域网格：由 tools/WowWeb/gen_zonegrid.py 从客户端 ADT 的 MCNK areaid 生成，别手改\n")
        fh.write("# 格式：<map>\\t<cell_y>\\t<xstart>:<区域目录> [<xstart>:<区域目录> ...]（x 从 xstart 起连续）\n")
        fh.write("# 格子边长 %.4f 码；世界坐标 → 格子：x=floor(X/%.4f)，y=floor(Y/%.4f)\n"
                 % (CELL_SIZE, CELL_SIZE, CELL_SIZE))
        fh.write("# 区域目录对应 internal/web/mapzones.txt 的目录名；没有列出的格子页面回落到框规则\n")
        for (map_id, cell_y) in sorted(rows):
            cells = rows[(map_id, cell_y)]
            runs = []
            for cell_x in sorted(cells):
                if runs and runs[-1][1] == cells[cell_x] and runs[-1][0] + runs[-1][2] == cell_x:
                    runs[-1][2] += 1
                else:
                    runs.append([cell_x, cells[cell_x], 1])
            body = []
            for start, directory, length in runs:
                body.append("%d:%s" % (start, directory) if length == 1 else "%d:%s*%d" % (start, directory, length))
            fh.write("%d\t%d\t%s\n" % (map_id, cell_y, " ".join(body)))
    print("写入 %s：%d 行" % (args.out, len(rows)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
