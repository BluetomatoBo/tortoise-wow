#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""gen_zonefix.py — 生成 internal/web/zonefix.txt：区域判定的格子修正表。

# 问题

`mapzones.txt` 里的框来自客户端 `WorldMapArea.dbc`，它是**该区域地图图片的世界范围**，
不只是这块地本身：图片会带一圈邻区的边缘，所以相邻区域的框会互相重叠，而
`ZoneAt` 只能「取最小的那个框」。对绝大多数刷新点这是对的，但在「小框其实只是
边距」的地方就会标错——例如血色领地（4012，乌龟服自定义区）的框把东瘟疫之地
提尔之手一带圈了进去，于是 `/db/npcs/8531`（呢喃食尸鬼）画到了血色领地的图上。

# 判据

用刷新点自己当证据：把「只落在一个区域框里」的点当作该区域的**专属内容**，
然后对落在多个框里的格子，取「专属内容更近」的那个区域（要求近一倍以上）；
若候选框之间存在包含关系（城市/洞穴套在大区域里），保持现状不动。

# 为什么要人工核验

这套判据对**边距型**的错误是对的，但对「区域真的相邻、两边内容都在附近」的情况
会误判：实测把暴风城守卫判给了 Northwind、把安戈洛的 A-Me 01 判给了千针石林。
所以本脚本只输出 `VERIFIED` 里的人工核验过的区域对（核验方法：看这些格子里的
生物/物件名字属于谁，`--report` 会打印出来），其余一律保持原规则。

用法（在仓库根目录）：

```bash
python3 tools/WowWeb/gen_zonefix.py --report \
    --mysql "tools/dbdiff/mysql_local.sh tw_world"          # 只打印核验报告
python3 tools/WowWeb/gen_zonefix.py --write \
    --mysql "tools/dbdiff/mysql_local.sh tw_world"          # 重写 zonefix.txt
```
"""

import argparse
import collections
import math
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_OUT = os.path.join(HERE, "internal", "web", "zonefix.txt")

CELL = 128.0        # 码；格子越小越贴合，128 码约合 4 个 MCNK 块
RADIUS = 16         # 专属内容向外生长多少格（16 × 128 = 2048 码）
NEAR = 2.0          # 证据要「近一倍以上」才覆盖现状
NESTED = 0.85       # 小框有 85% 落在其它候选框里，就当成包含关系，不动

# 人工核验过的修正：现状区域 -> 应判区域，后附核验依据（这些格子里的内容属于谁）。
VERIFIED = {
    ("scarletenclave", "easternplaguelands"):
        "Plaguebat / Putrid Gargoyle / Blighted Surge / Carrion Grub —— 东瘟疫之地的怪",
    ("arathi", "hinterlands"):
        "Witherbark / Vilebranch 巨魔 —— 辛特兰的怪",
    ("hilsbrad", "arathi"):
        "Boulderfist Ogre / Highland Thrasher / Hightusk Boar —— 阿拉希高地的怪",
    ("hilsbrad", "hinterlands"):
        "Mangy Silvermane / Old Farwell / Grant Lafford —— 辛特兰的 NPC",
    ("hilsbrad", "gilneas"):
        "Greymane Preserver —— 吉尔尼斯（乌龟服自定义区）的怪",
    ("easternplaguelands", "westernplaguelands"):
        "Plague Lurker / Diseased Grizzly / Elder Meadowrun —— 西瘟疫之地的怪",
    ("westfall", "stranglethorn"):
        "Hemet Nesingwary / Zandalar Headshrinker / Saltwater Crocolisk —— 荆棘谷的 NPC 与怪",
    ("alterac", "silverpine"):
        "Rot Hide Plague Weaver / Snapjaw / Lake Skulker —— 银松森林的怪",
    ("alterac", "hinterlands"):
        "Old Cliff Jumper / Soaring Razorbeak / Wildhammer Sentry —— 辛特兰的怪与 NPC",
    ("redridge", "swampofsorrows"):
        "Draenethyst Crystals / Lost One Muckdweller —— 悲伤沼泽的物件与怪",
    ("ungorocrater", "tanaris"):
        "Sandfury Hideskinner / Glasshide Basilisk —— 塔纳利斯的怪",
    ("badlands", "burningsteppes"):
        "Karfang Grunt / Taskmaster Ok'gog / Gazush the Rabid —— 燃烧平原的黑石兽人",
    ("searinggorge", "badlands"):
        "Elder Crag Coyote / Ridge Stalker Patriarch —— 荒芜之地的怪",
    ("westernplaguelands", "tirisfal"):
        "Deathguard / Spectral Apparition / Undercity Reveler —— 提瑞斯法林地的怪与 NPC",
    ("hyjal", "aszhara"):
        "Hederine Manastalker / Hederine Slayer / Krampus —— 艾萨拉的怪",
    ("uldaman", "badlands"):
        "Stonevault Cave Hunter / Stonesplinter Bonesnapper —— 奥达曼门外的穴居人",
    ("blackmorass2f", "blackmorass"):
        "Infinite Dragonspawn / Infinite Riftguard —— 时光之穴",
    ("redridge", "swampofsorrows"):
        "Draenethyst Crystals / Lost One Muckdweller —— 悲伤沼泽的物件与怪",
}

# 判据给得出、但按内容核验**不对**的：保留现状，写在这里免得以后有人又加回来。
REJECTED = {
    ("stormwind", "northwind"): "格子里的怪是 Stormwind City Guard（暴风城守卫）",
    ("undercity", "tirisfal"): "格子里的 NPC 是幽暗城的（Lordaeron Citizen / Keeper Bel'dugur）",
    ("duskwood", "westfall"): "格子里的 NPC 是暮色森林的（Agent Kearnen / Klaven Mortwake）",
    ("duskwood", "elwynn"): "同上，暮色森林一带",
    ("ungorocrater", "thousandneedles"): "格子里是 A-Me 01 / U'cha —— 安戈洛环形山的",
    ("thousandneedles", "feralas"): "格子里是 Highperch Wyvern —— 千针石林的",
    ("silithus", "ahnqirajentrance"): "格子里是 Hive'Regal 的虫子 —— 希利苏斯的",
    ("badlands", "dunmorogh"): "Dark Iron Spy，位置存疑，先不动",
    ("deadwindpass", "elwynn"): "格子里的 Watcher Callahan / Kzixx 不是艾尔文森林的",
    ("ironforge", "dunmorogh"): "格子里是铁炉堡的 NPC（Bubulo Acerbus / Fizzlebang Booms）",
    ("wetlands", "dunmorogh"): "Airfield Engineer / Ironforge Guard，位置存疑，先不动",
    ("thalassianhighlands", "westernplaguelands"): "血色十字军两种区域都有，存疑",
    ("thousandneedles", "tanaris"): "存疑，先不动",
    ("elwynn", "westfall"): "存疑，先不动",
    ("redridge", "elwynn"): "Dead-Tooth Jack / Defias Bandit，存疑",
    ("lapidis", "gillijim"): "两个都是乌龟服自定义岛，存疑",
}


def load_boxes(path):
    boxes = []
    for line in open(path, encoding="utf-8"):
        if line.startswith("#") or not line.strip():
            continue
        area, directory, map_id, x1, x2, y1, y2 = line.split("\t")
        boxes.append(dict(area=int(area), dir=directory, map=int(map_id),
                          x1=float(x1), x2=float(x2), y1=float(y1), y2=float(y2)))
    return boxes


def spawns_from_mysql(mysql):
    """读出所有生物与物件的刷新坐标。"""
    query = ("SELECT id, map, position_x, position_y FROM creature "
             "UNION ALL SELECT id, map, position_x, position_y FROM gameobject;")
    out = subprocess.run(mysql.split() + ["-e", query], capture_output=True, text=True)
    if out.returncode != 0:
        sys.exit("mysql 读取失败：%s" % (out.stderr.strip() or out.returncode))
    rows = []
    for line in out.stdout.split("\n")[1:]:
        parts = line.split("\t")
        if len(parts) < 4 or not parts[0].strip():
            continue
        try:
            rows.append((int(parts[0]), int(parts[1]), float(parts[2]), float(parts[3])))
        except ValueError:
            continue
    if not rows:
        sys.exit("没有读到刷新点，检查 --mysql")
    return rows


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[1],
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--mysql", required=True,
                    help='读世界库的命令，例如 "tools/dbdiff/mysql_local.sh tw_world"')
    ap.add_argument("--zones", default=os.path.join(HERE, "internal", "web", "mapzones.txt"))
    ap.add_argument("--out", default=DEFAULT_OUT)
    ap.add_argument("--report", action="store_true", help="打印核验报告（按区域对分组，附格子里的名字）")
    ap.add_argument("--write", action="store_true", help="写出 zonefix.txt")
    ap.add_argument("--names", action="store_true",
                    help="报告里附上格子里的生物/物件名（要多查一次库）")
    args = ap.parse_args()

    boxes = load_boxes(args.zones)
    by_map = collections.defaultdict(list)
    for b in boxes:
        by_map[b["map"]].append(b)
    name_of = {b["area"]: b["dir"] for b in boxes}

    def area_of(b):
        return (b["x2"] - b["x1"]) * (b["y2"] - b["y1"])

    def candidates(m, x, y, with_continent=False):
        out = [b for b in by_map[m]
               if b["x1"] <= x <= b["x2"] and b["y1"] <= y <= b["y2"]]
        return out if with_continent else [b for b in out if b["area"] != 0]

    def current(m, x, y):
        c = candidates(m, x, y) or candidates(m, x, y, True)
        return min(c, key=area_of)["area"] if c else None

    def inside_fraction(small, big):
        w = max(0.0, min(small["x2"], big["x2"]) - max(small["x1"], big["x1"]))
        h = max(0.0, min(small["y2"], big["y2"]) - max(small["y1"], big["y1"]))
        return (w * h) / area_of(small)

    spawns = spawns_from_mysql(args.mysql)
    print("刷新点 %d 个，区域框 %d 个" % (len(spawns), len(boxes)))

    cells = collections.defaultdict(set)
    exclusive = collections.defaultdict(set)
    for _, m, x, y in spawns:
        c = candidates(m, x, y)
        if not c:
            continue
        cell = (m, int(math.floor(x / CELL)), int(math.floor(y / CELL)))
        cells[cell] |= {b["area"] for b in c}
        if len(c) == 1:
            exclusive[c[0]["area"]].add(cell)

    dist = {}
    for area, seeds in exclusive.items():
        d = {k: 0 for k in seeds}
        queue = collections.deque(seeds)
        while queue:
            m, cx, cy = queue.popleft()
            step = d[(m, cx, cy)]
            if step >= RADIUS:
                continue
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                k = (m, cx + dx, cy + dy)
                if k in d or k[0] != m:
                    continue
                d[k] = step + 1
                queue.append(k)
        dist[area] = d
    print("有专属内容的区域 %d 个" % len(exclusive))

    fixes = {}          # cell -> area
    pairs = {}          # cell -> (现状区域, 应判区域)
    groups = collections.Counter()
    for cell, areas in cells.items():
        m, cx, cy = cell
        x, y = (cx + 0.5) * CELL, (cy + 0.5) * CELL
        cands = sorted(candidates(m, x, y), key=area_of)
        if not cands:
            continue
        small = cands[0]
        if all(inside_fraction(small, b) >= NESTED for b in cands[1:]):
            continue                                     # 包含关系：城市/洞穴，不动
        ranked = sorted((dist[a].get(cell, 10 ** 6), a) for a in areas if a in dist)
        ranked = [t for t in ranked if t[0] < 10 ** 6]
        if len(ranked) < 2:
            continue
        (d1, a1), (d2, _) = ranked[0], ranked[1]
        if not (d1 == 0 or d1 * NEAR <= d2):
            continue                                     # 证据不够强
        cur = current(m, x, y)
        if a1 == cur:
            continue
        fixes[cell] = a1
        pairs[cell] = (name_of.get(cur, cur), name_of.get(a1, a1))
        groups[pairs[cell]] += 1

    print("候选修正格 %d 个，分 %d 组" % (len(fixes), len(groups)))
    for (a, b), n in groups.most_common():
        mark = "✅ 已核验" if (a, b) in VERIFIED else ("❌ 判据有误" if (a, b) in REJECTED else "? 未核验")
        print("   %-22s → %-22s %5d 格   %s" % (a, b, n, mark))

    if args.report:
        names = {}
        if args.names:
            query = ("SELECT ct.name, c.map, FLOOR(c.position_x/128), FLOOR(c.position_y/128)"
                     " FROM creature c JOIN creature_template ct ON ct.entry = c.id"
                     " UNION ALL SELECT gt.name, g.map, FLOOR(g.position_x/128), FLOOR(g.position_y/128)"
                     " FROM gameobject g JOIN gameobject_template gt ON gt.entry = g.id;")
            out = subprocess.run(args.mysql.split() + ["-e", query], capture_output=True, text=True)
            for line in out.stdout.split("\n")[1:]:
                parts = line.split("\t")
                if len(parts) < 4 or not parts[0].strip():
                    continue
                try:
                    key = (int(parts[1]), int(parts[2]), int(parts[3]))
                except ValueError:
                    continue
                names.setdefault(key, set()).add(parts[0])
        print("\n=== 核验报告（每组两个格子的内容）===")
        for (a, b), n in groups.most_common():
            keys = sorted(k for k, v in fixes.items() if name_of.get(v) == b)
            print("\n[%d 格] %s → %s" % (n, a, b))
            for key in keys[:2]:
                text = ", ".join(sorted(names.get(key, {"(未查名字)"}))[:8])
                print("    %s: %s" % (str(key[1:]), text))

    if args.write:
        kept = {cell: area for cell, area in fixes.items() if pairs[cell] in VERIFIED}
        dropped = {cell for cell, area in fixes.items() if pairs[cell] not in VERIFIED}
        print("候选 %d 格；核验通过 %d 格；丢弃 %d 格（未核验或已判错）"
              % (len(fixes), len(kept), len(dropped)))
        header = [
            "# 区域判定的格子修正：<map> <cell_x> <cell_y> <area>",
            "# 由 tools/WowWeb/gen_zonefix.py 生成，别手改（要改就改那份脚本里的 VERIFIED/REJECTED）",
            "#",
            "# mapzones.txt 的框是「区域地图图片的世界范围」，含邻区边缘，所以相邻区域的框会重叠；",
            "# 页面默认取最小的框，在「小框只是边距」的地方会标错（例如血色领地的框圈住了",
            "# 东瘟疫之地的提尔之手，/db/npcs/8531 因此画到血色领地）。",
            "#",
            "# 判据：用刷新点当证据——只落在一个框里的点算该区域的专属内容，落在多个框里的",
            "# 格子取「专属内容更近」的区域（近一倍以上）；候选框有包含关系（城市/洞穴套在",
            "# 大区域里）时保持现状。判据对边距型错误正确，但对相邻两区内容都在附近的情况",
            "# 会误判，所以只保留人工按内容核验过的区域对：",
            "#",
        ]
        for (a, b), why in sorted(VERIFIED.items()):
            header.append("#   %-22s → %-22s %s" % (a, b, why))
        header += [
            "#",
            "# 判据给得出但**核验为错**、有意保留现状的（别再加回来）：",
            "#",
        ]
        for (a, b), why in sorted(REJECTED.items()):
            header.append("#   %-22s / %-22s %s" % (a, b, why))
        header += [
            "#",
            "# 格子边长 %d 码；只列有刷新点的格子。重算：python3 tools/WowWeb/gen_zonefix.py \\" % int(CELL),
            '#     --write --mysql "tools/dbdiff/mysql_local.sh tw_world"',
            "#",
        ]
        with open(args.out, "w", encoding="utf-8") as fh:
            fh.write("\n".join(header))
            for (m, cx, cy), area in sorted(kept.items()):
                fh.write("%d\t%d\t%d\t%d\n" % (m, cx, cy, area))
        print("\n写入 %s：%d 格（核验过的区域对）" % (args.out, len(kept)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
