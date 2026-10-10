#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""gen_zonecontent.py — 生成 internal/web/zonecontent.txt：每个区域的刷出点统计。

# 为什么在生成时算

「这个区域里有哪些生物/物件」的答案不在任何一张表里：刷出点只存 world 坐标，
要算它属于哪个区域，得走 mapzones.txt 的框 + zonegrid.txt 的区域网格 + zonefix.txt
的修正 —— 也就是页面上的 ZoneAt。全库 15 万个刷新点每次请求都算一遍不现实，
所以在这里算好，页面只读结果。

判定链与 internal/web/mapzones.go 的 ZoneAt 一致：
  1. zonefix.txt 的格子修正（框不含该点则跳过）
  2. 嵌套小框（城市/洞穴，≤3M 平方码、85% 落在别的候选框里）
  3. zonegrid.txt 的客户端区域网格（框不含该点则跳过）
  4. 面积最小的包含框

# 输出

    <区域目录>\t<生物点>\t<生物种>\t<物件点>\t<物件种>\t<任务数>\t<top生物>\t<top物件>

top 是 `entry:点数` 按点数降序的前 TOP_N 个。区域目录与 mapzones.txt 一致，页面用它找地图。

用法（仓库根目录）：

```bash
python3 tools/WowWeb/gen_zonecontent.py --mysql "tools/dbdiff/mysql_local.sh tw_world"
```
"""

import argparse
import collections
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_OUT = os.path.join(HERE, "internal", "web", "zonecontent.txt")

TOP_N = 25               # 详情页每组列出多少个
GRID_CELL = 533.3333333 / 16
NESTED_LIMIT = 3.0e6     # 与 Go 的 nestedBoxLimit 一致
NESTED_SHARE = 0.85      # 与 Go 的嵌套判定一致


def load_boxes(path):
    """mapzones.txt → {map: [框]} 与 {目录: 框}。"""
    boxes = collections.defaultdict(list)
    by_dir = {}
    for line in open(path, encoding="utf-8"):
        if line.startswith("#") or not line.strip():
            continue
        area, directory, map_id, x1, x2, y1, y2 = line.split("\t")
        box = {"area": int(area), "dir": directory, "map": int(map_id),
               "x1": float(x1), "x2": float(x2), "y1": float(y1), "y2": float(y2)}
        boxes[box["map"]].append(box)
        by_dir[directory] = box
    return boxes, by_dir


def load_grid(path):
    """zonegrid.txt → {(map, cell_y): [(start, dir, len)]}。"""
    rows = {}
    for line in open(path, encoding="utf-8"):
        if line.startswith("#") or not line.strip():
            continue
        map_id, cell_y, body = line.split("\t")
        runs = []
        for part in body.split():
            spec, _, length = part.partition("*")
            start, _, directory = spec.partition(":")
            runs.append((int(start), directory, int(length) if length else 1))
        rows[(int(map_id), int(cell_y))] = runs
    return rows


def load_fix(path):
    """zonefix.txt → {(map, cx, cy): area}。"""
    fix = {}
    if not os.path.isfile(path):
        return fix
    for line in open(path, encoding="utf-8"):
        if line.startswith("#") or not line.strip():
            continue
        map_id, cx, cy, area = (int(v) for v in line.split("\t"))
        fix[(map_id, cx, cy)] = area
    return fix


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[1],
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--mysql", required=True, help="读世界库的命令")
    ap.add_argument("--zones", default=os.path.join(HERE, "internal", "web", "mapzones.txt"))
    ap.add_argument("--grid", default=os.path.join(HERE, "internal", "web", "zonegrid.txt"))
    ap.add_argument("--fix", default=os.path.join(HERE, "internal", "web", "zonefix.txt"))
    ap.add_argument("--out", default=DEFAULT_OUT)
    args = ap.parse_args()

    boxes, box_of_dir = load_boxes(args.zones)
    grid = load_grid(args.grid)
    fix = load_fix(args.fix)
    print("框 %d 个、网格 %d 行、修正 %d 格" % (
        sum(len(v) for v in boxes.values()), len(grid), len(fix)))

    def extent(b):
        return (b["x2"] - b["x1"]) * (b["y2"] - b["y1"])

    def contains(b, x, y):
        return b["x1"] <= x <= b["x2"] and b["y1"] <= y <= b["y2"]

    def inside_share(small, big):
        w = max(0.0, min(small["x2"], big["x2"]) - max(small["x1"], big["x1"]))
        h = max(0.0, min(small["y2"], big["y2"]) - max(small["y1"], big["y1"]))
        return (w * h) / extent(small) if w > 0 and h > 0 else 0.0

    def zone_of(map_id, x, y):
        """与 Go 的 ZoneAt 同一条链，返回区域目录或 None。"""
        cell = (map_id, int(x // GRID_CELL), int(y // GRID_CELL))
        want = fix.get(cell)
        if want is not None:
            for b in boxes[map_id]:
                if b["area"] == want and contains(b, x, y):
                    return b["dir"]
        candidates = [b for b in boxes[map_id] if b["area"] != 0 and contains(b, x, y)]
        if len(candidates) >= 2:
            small = min(candidates, key=extent)
            if extent(small) <= NESTED_LIMIT and \
               any(inside_share(small, b) >= NESTED_SHARE
                   for b in candidates if b is not small):
                return small["dir"]
        runs = grid.get((map_id, int(y // GRID_CELL)))
        if runs:
            cx = int(x // GRID_CELL)
            for start, directory, length in runs:
                if start <= cx < start + length:
                    b = box_of_dir.get(directory)
                    if b is not None and contains(b, x, y):
                        return directory
                    break                       # 网格给的图不含该点 → 交回框规则
        inside = [b for b in boxes[map_id] if contains(b, x, y)]
        return min(inside, key=extent)["dir"] if inside else None

    def read_points(table):
        """[(entry, map, x, y)] —— table 是 creature 或 gameobject。"""
        run = subprocess.run(args.mysql.split() + ["-e",
              "SELECT id, map, position_x, position_y FROM %s;" % table],
              capture_output=True, text=True)
        if run.returncode != 0:
            sys.exit("读 %s 失败：%s" % (table, run.stderr.strip() or run.returncode))
        points = []
        for line in run.stdout.split("\n")[1:]:
            parts = line.split("\t")
            if len(parts) < 4 or not parts[0].strip():
                continue
            try:
                points.append((int(parts[0]), int(parts[1]), float(parts[2]), float(parts[3])))
            except ValueError:
                continue
        return points

    counters = {}
    for kind, table in (("creature", "creature"), ("object", "gameobject")):
        points = read_points(table)
        hits = collections.defaultdict(collections.Counter)
        missed = 0
        for entry, map_id, x, y in points:
            directory = zone_of(map_id, x, y)
            if directory is None:
                missed += 1
                continue
            hits[directory][entry] += 1
        counters[kind] = hits
        print("%s：%d 个刷出点，落到 %d 个区域，归不到区域 %d 个"
              % (table, len(points), len(hits), missed))

    # 任务：quest_template.ZoneOrSort 为正数时是区域 id，映射到目录
    area_of_dir = {b["dir"]: b["area"] for b in box_of_dir.values()}
    dir_of_area = {}
    for directory, area in area_of_dir.items():
        dir_of_area.setdefault(area, directory)
    quests = collections.Counter()
    run = subprocess.run(args.mysql.split() + ["-e",
          "SELECT ZoneOrSort, COUNT(*) FROM quest_template WHERE ZoneOrSort > 0 GROUP BY ZoneOrSort;"],
          capture_output=True, text=True)
    unmatched = 0
    for line in run.stdout.split("\n")[1:]:
        parts = line.split("\t")
        if len(parts) < 2 or not parts[0].strip():
            continue
        directory = dir_of_area.get(int(parts[0]))
        if directory:
            quests[directory] += int(parts[1])
        else:
            unmatched += int(parts[1])
    print("任务：%d 个区域的 ZoneOrSort 能对上地图，%d 个任务对不上（区域没有独立地图）"
          % (len(quests), unmatched))

    with open(args.out, "w", encoding="utf-8") as fh:
        fh.write("# 区域内容统计：由 tools/WowWeb/gen_zonecontent.py 生成，别手改\n")
        fh.write("# 格式：<区域目录>\\t<生物点>\\t<生物种>\\t<物件点>\\t<物件种>\\t<任务数>"
                 "\\t<top生物 entry:点数,...>\\t<top物件 ...>\n")
        fh.write("# 点数的口径与页面一致（mapzones + zonegrid + zonefix 的 ZoneAt 判定）；"
                 "top 取点数降序前 %d 个\n" % TOP_N)
        all_dirs = sorted(set(counters["creature"]) | set(counters["object"]),
                          key=lambda d: -(sum(counters["creature"][d].values())
                                          + sum(counters["object"][d].values())))
        for directory in all_dirs:
            cre = counters["creature"][directory]
            obj = counters["object"][directory]
            top_cre = ",".join("%d:%d" % (e, n) for e, n in cre.most_common(TOP_N))
            top_obj = ",".join("%d:%d" % (e, n) for e, n in obj.most_common(TOP_N))
            fh.write("%s\t%d\t%d\t%d\t%d\t%d\t%s\t%s\n" % (
                directory, sum(cre.values()), len(cre), sum(obj.values()), len(obj),
                quests.get(directory, 0), top_cre, top_obj))
    print("写入 %s：%d 个区域" % (args.out, len(all_dirs)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
