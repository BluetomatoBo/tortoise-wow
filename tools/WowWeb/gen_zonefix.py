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
sys.path.insert(0, HERE)
from gen_zonegrid import vanilla_areas  # noqa: E402  （同一目录的生成器，复用它的区域表读取）
DEFAULT_OUT = os.path.join(HERE, "internal", "web", "zonefix.txt")

CELL = 533.3333333 / 16   # 码；与 gen_zonegrid 的 MCNK 格一致，混层（地表+洞穴同格）才分得开
RADIUS = 16         # 专属内容向外生长多少格（16 × 128 = 2048 码）
NEAR = 2.0          # 证据要「近一倍以上」才覆盖现状
NESTED = 0.85       # 小框有 85% 落在其它候选框里，就当成包含关系，不动

# 人工核验过的修正：现状区域 -> 应判区域，后附核验依据（这些格子里的内容属于谁）。
# 「城市嵌在区域里」的区域（NESTED_CITY）：框是**城市地图**的范围，但框内大部分是城外的野地。
# 这些区域没有专属内容（框完全在父区域内），所以按「专属内容距离」的统计判据看不见它们；
# 判据：格子里「野外内容」占一半以上就判给外圈区域，否则留在城市图上。
#
# alahthalas（阿尔萨拉斯，乌龟服新加的血精灵城）：城里是 WMO，玩家走进城里客户端才显示
# 城市地图；站在城外（树人、野兽、难民、萨拉斯哨兵）看到的是萨拉斯高地。
NESTED_CITY = {
    "alahthalas": (
        # 城里：Alah'Thalas 的 NPC、血精灵与达拉然的城装饰、传送球、书堆、邮箱
        ("alah", "bloodelf", "blood elf", "high elf", "highelf", "dalaran", "goober",
         "arcane", "party supplies", "translocation", "bookstack", "bookshelf",
         "fancydesk", "doodads", "mailbox"),
        # 野外：区域生物、矿草、难民、篝火 —— 站在城外，玩家客户端显示的是萨拉斯高地
        ("thalassian sentinel", "thalassian treant", "thalassian tender", "thalassian fox",
         "thalassian stag", "autumnal", "hawkstrider", "lynx", "farstride", "boar", "stag",
         "deer", "refugee", "withering", "moonwell", "stallhorn", "unicorn", "dragonhawk",
         "crawler", "netter", "coastrunner", "copper vein", "wood tree", "earthroot",
         "peacebloom", "silverleaf", "soulwraith", "campfire", "spirit healer"),
    ),
}

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
    ("wetlands", "gilneas"):
        "Spitecrest Wavesinger（乌龟服自定义，站在吉尔尼斯半岛西岸 x≈-2620）",
    ("silverpine", "gilneas"):
        "同一批 Spitecrest Wavesinger；原版地形把半岛标成了银松/湿地",
    ("stranglethorn", "lapidis"):
        "Chieftain Woh'zo / Hazzuri Beastkeeper（乌龟服自定义，x≈-12500 的拉皮迪斯岛）",
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
    ("cavernsoftime", "tanaris"):
        "Glasshide Gazer / Scorpid Dunestalker / Blisterpaw Hyena —— 塔纳利斯地表的怪（洞穴自己的青铜龙在 z≈-211）",
    ("timbermawentrance", "aszhara"):
        "Legashi Satyr / Mosshoof Courser / Storm Bay Warrior —— 艾萨拉的怪",
    ("timbermawtunnels", "felwood"):
        "木喉要塞隧道口外的费伍德内容",
    ("durotar", "blackstoneisland"):
        "黑石岛（乌龟服自定义）的内容站在杜隆塔尔海面上：主场投票 47/50",
    ("wetlands", "dunmorogh"):
        "卡兹莫丹机场一带的铁炉堡卫兵与机场工程师（主场投票 39/41 → 丹莫罗）",
    ("desolace", "stonetalonmountains"):
        "石爪山脉与凄凉之地交界西侧（主场投票 22/25）",
    ("stonetalonmountains", "desolace"):
        "同一条边界的东侧，两边各自析出（主场投票 32/42）",
    ("ahnqiraj", "ahnqiraj2f"):
        "安其拉神庙二层的虫子与箱子（主场投票 9/9）",
    ("lapidis", "gillijim"):
        "吉吉利姆岛（乌龟服自定义）的南海海盗（主场投票 18/18）",
    ("stormwind", "elwynn"):
        "暴风城框贴边的格子（框内位置 0.02）是城外地表：迪菲亚盗贼、野兔（位置 0.36 在艾尔文森林框中部）",
    ("undercity", "tirisfal"):
        "幽暗城框贴边的格子（0.10）是城外：血色传教士等提瑞斯法的内容",
    ("darnassus", "teldrassil"):
        "达纳苏斯框贴边的格子（0.02）是城外的泰达希尔地表：Gnarlpine 熊怪",
    ("deadminesentrance", "westfall"):
        "死亡矿井门口框里的地表迪菲亚工人（框内位置 0.24，与西部荒野框一致）",
    ("blackrockmountain", "burningsteppes"):
        "黑石山塔框边的采石场奴隶与黑石兽人（框内位置 0.13 vs 燃烧平原 0.28）",
    ("easternplaguelands", "thalassianhighlands"):
        "萨拉斯高地（乌龟服新开的高等精灵区）的内容：Thalassian Sentinel / Elder Thalassian Boar / "
        "Silver Covenant Recruit / Brilliant Mana Wyrm；坐标越过东瘟疫框右边界（x>3800），用户抽查确认",
    ("ashenvale", "stonetalonmountains"):
        "石爪山风险投资公司黑沙矿点的内容：Blacksand Oil / Mechanic / Oilworker / Woodworker，"
        "用户抽查确认",
    ("alahthalas", "thalassianhighlands"):
        "阿尔萨拉斯框里的城外格子：格子里没有城市自己的内容（Alah'Thalas 的 NPC、血精灵城装饰、"
        "传送球），只有树人、野兽、萨拉斯哨兵 → 判给萨拉斯高地；城里的留城市图（见 NESTED_CITY_MARKERS）",
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
    ("blastedlands", "swampofsorrows"): "奈瑟加德士兵/精英/矿工与恐槌食人魔都是诅咒之地的内容，"
                                         "用户按 wowhead 的区域标记核对一致，保持现状",
    ("badlands", "dunmorogh"): "Dark Iron Spy，位置存疑，先不动",
    ("deadwindpass", "elwynn"): "格子里的 Watcher Callahan / Kzixx 不是艾尔文森林的",
    ("ironforge", "dunmorogh"): "格子里是铁炉堡的 NPC（Bubulo Acerbus / Fizzlebang Booms）",
    ("thalassianhighlands", "westernplaguelands"): "血色十字军两种区域都有，存疑",
    ("thousandneedles", "tanaris"): "存疑，先不动",
    ("elwynn", "westfall"): "存疑，先不动",
    ("redridge", "elwynn"): "Dead-Tooth Jack / Defias Bandit，存疑",
    ("dunmorogh", "northwind"): "格子里混着霜鬃巨魔（丹莫罗的），存疑",
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
    query = ("SELECT id, map, position_x, position_y, position_z FROM creature "
             "UNION ALL SELECT id, map, position_x, position_y, position_z FROM gameobject;")
    out = subprocess.run(mysql.split() + ["-e", query], capture_output=True, text=True)
    if out.returncode != 0:
        sys.exit("mysql 读取失败：%s" % (out.stderr.strip() or out.returncode))
    rows = []
    for line in out.stdout.split("\n")[1:]:
        parts = line.split("\t")
        if len(parts) < 4 or not parts[0].strip():
            continue
        try:
            rows.append((int(parts[0]), int(parts[1]), float(parts[2]), float(parts[3]),
                         float(parts[4])))
        except ValueError:
            continue
    if not rows:
        sys.exit("没有读到刷新点，检查 --mysql")
    return rows


def load_grid(path):
    """读 gen_zonegrid.py 生成的网格：{(map, cell_y): [(start, dir, len)]}。

    生成顺序是先 `gen_zonegrid.py` 再本脚本：嵌套区域的「地表边距」要用地形网格复核。
    """
    rows = {}
    if not os.path.isfile(path):
        return rows
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


def grid_dir(rows, map_id, x, y, cell):
    """地形网格在该点的答案（网格里没有该格就 None）。"""
    runs = rows.get((map_id, int(math.floor(y / cell))))
    if not runs:
        return None
    cx = int(math.floor(x / cell))
    for start, directory, length in runs:
        if start <= cx < start + length:
            return directory
    return None


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
                    help="报告里按组汇总格子里的生物/物件名与自定义内容数（要多查一次库）")
    ap.add_argument("--dump", metavar="PATH",
                    help="把每个候选格写成 TSV（map/cx/cy/现状区域/判据建议），供别的脚本核验")
    args = ap.parse_args()

    boxes = load_boxes(args.zones)
    by_map = collections.defaultdict(list)
    for b in boxes:
        by_map[b["map"]].append(b)
    name_of = {b["area"]: b["dir"] for b in boxes}
    area_of_dir = {b["dir"]: b["area"] for b in boxes}

    def area_of(b):
        return (b["x2"] - b["x1"]) * (b["y2"] - b["y1"])

    def candidates(m, x, y, with_continent=False):
        out = [b for b in by_map[m]
               if b["x1"] <= x <= b["x2"] and b["y1"] <= y <= b["y2"]]
        return out if with_continent else [b for b in out if b["area"] != 0]

    def current(m, x, y):
        """页面实际会用的判定：嵌套 →（网格）→ 面积最小的框。

        修正表是相对**这条路**写的：先按框规则算出来的候选，会与页面真正的答案不符。
        """
        c = [b for b in candidates(m, x, y)]
        if len(c) >= 2:
            small = min(c, key=area_of)
            if area_of(small) <= 3.0e6 and any(inside_fraction(small, b) >= NESTED for b in c if b is not small):
                return small["area"]
        if grid_rows:
            directory = grid_dir(grid_rows, m, x, y, 533.3333333 / 16)
            if directory in area_of_dir:
                return area_of_dir[directory]
        c = candidates(m, x, y) or candidates(m, x, y, True)
        return min(c, key=area_of)["area"] if c else None

    def inside_fraction(small, big):
        w = max(0.0, min(small["x2"], big["x2"]) - max(small["x1"], big["x1"]))
        h = max(0.0, min(small["y2"], big["y2"]) - max(small["y1"], big["y1"]))
        return (w * h) / area_of(small)

    grid_rows = load_grid(os.path.join(os.path.dirname(args.out), "zonegrid.txt"))
    if grid_rows:
        print("读了 zonegrid.txt（%d 行）：判定链与页面一致（嵌套 → 网格 → 框规则）" % len(grid_rows))

    spawns = spawns_from_mysql(args.mysql)
    print("刷新点 %d 个，区域框 %d 个" % (len(spawns), len(boxes)))

    # 每格里有哪些 entry（判「是不是乌龟服自定义内容」用）与哪些 z（判地表/洞穴用）
    entries_by_cell = collections.defaultdict(list)
    z_by_cell = collections.defaultdict(list)
    for entry, m, x, y, z in spawns:
        cell = (m, int(x // CELL), int(y // CELL))
        entries_by_cell[cell].append(entry)
        z_by_cell[cell].append(z)

    cells = collections.defaultdict(set)
    exclusive = collections.defaultdict(set)
    for _, m, x, y, z in spawns:
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

    # 嵌套城市（NESTED_CITY，如阿尔萨拉斯）：框是城市地图的范围，但框内大部分是城外的野地。
    # 判据是「格子里的内容有一半以上属于野外」—— 城里格实测 0~10%、野外格 50~100%，
    # 评论区的银行家/拍卖师这类没有地域词的名字靠这一条也能留在城里。
    nested_city = 0
    if NESTED_CITY:
        city_names = {}
        query = ("SELECT ct.name, c.id, c.map, FLOOR(c.position_x/%.6f), FLOOR(c.position_y/%.6f)"
                 " FROM creature c JOIN creature_template ct ON ct.entry = c.id"
                 " UNION ALL SELECT gt.name, g.id, g.map, FLOOR(g.position_x/%.6f), FLOOR(g.position_y/%.6f)"
                 " FROM gameobject g JOIN gameobject_template gt ON gt.entry = g.id;"
                 % (CELL, CELL, CELL, CELL))
        res = subprocess.run(args.mysql.split() + ["-e", query], capture_output=True, text=True)
        for line in res.stdout.split("\n")[1:]:
            parts = line.split("\t")
            if len(parts) < 5 or not parts[0].strip():
                continue
            try:
                city_names.setdefault((int(parts[2]), int(parts[3]), int(parts[4])), []).append(parts[0].lower())
            except ValueError:
                continue
        for cell, areas in cells.items():
            m, cx, cy = cell
            x, y = (cx + 0.5) * CELL, (cy + 0.5) * CELL
            cands = sorted(candidates(m, x, y), key=area_of)
            if len(cands) < 2:
                continue
            inner_dir = name_of.get(cands[0]["area"])
            outer_dir = name_of.get(cands[1]["area"])
            spec = NESTED_CITY.get(inner_dir)
            if not spec or not outer_dir:
                continue
            _city_flags, wild_flags = spec
            names = city_names.get(cell, [])
            if not names:
                continue
            wild = sum(1 for nam in names if any(flag in nam for flag in wild_flags))
            if wild * 2 < len(names):
                continue                                     # 野外不到一半 → 留城市
            if current(m, x, y) != cands[0]["area"]:
                continue
            fixes[cell] = cands[1]["area"]
            pairs[cell] = (inner_dir, outer_dir)
            groups[(inner_dir, outer_dir)] += 1
            nested_city += 1
        print("其中「嵌套城市的城外格子」候选 %d 格" % nested_city)

    # 自定义区域（乌龟服新加的，或者原版没启用、被乌龟服启用的）：它们的地形瓦片是老区域的
    # （吉尔尼斯半岛在原版数据里就标成希尔斯布莱德，拉皮迪斯岛标成荆棘谷），所以地形网格会给成
    # 邻居。但这些区域自己的内容确实站在那儿（61363 Greymane Preserver、91818 Chieftain Woh'zo），
    # 判据是：面积最小的那个框里、内容含**乌龟服自定义生物/物件**（entry >= 50000）的格子，
    # 判给这个框——这一支不看地形网格，因为它正是为「地形陈旧」准备的。
    custom_areas = set()
    vanilla = vanilla_areas(os.path.expanduser("~/Downloads/WoW_Classic"))
    if vanilla:
        print("原版 AreaTable 区域 %d 个" % len(vanilla))
        custom_areas = {b["area"] for b in boxes if b["area"] and b["area"] not in vanilla}
    custom_fix = 0
    if custom_areas:
        for cell, areas in cells.items():
            m, cx, cy = cell
            x, y = (cx + 0.5) * CELL, (cy + 0.5) * CELL
            cands = sorted(candidates(m, x, y), key=area_of)
            if not cands:
                continue
            entries = entries_by_cell.get(cell, ())
            if not entries or max(entries) < 50000:
                continue
            inner_dir = name_of.get(cands[0]["area"])
            outer = current(m, x, y)
            if outer == cands[0]["area"]:
                continue
            outer_dir = name_of.get(outer)
            if not inner_dir or not outer_dir:
                continue
            fixes[cell] = cands[0]["area"]
            pairs[cell] = (outer_dir, inner_dir)
            groups[(outer_dir, inner_dir)] += 1
            custom_fix += 1
    print("其中「自定义区域内含自定义内容」候选 %d 格" % custom_fix)

    # 嵌套区域的「地表边距」：城市/洞穴/副本门口这些框套在别的区域里，框规则会把整块地都算给自己，
    # 但落在**地表**的那些点其实属于外圈区域。判据用 z：同一格里所有点的 z 都贴着外圈专属内容的
    # z（±40 码）就算地表；只要有一个点明显更深/更高（洞穴内部），这一格就留给内圈。

    outer_of = {}
    for cell in cells:
        m, cx, cy = cell
        x, y = (cx + 0.5) * CELL, (cy + 0.5) * CELL
        cands = sorted(candidates(m, x, y), key=area_of)
        if len(cands) < 2:
            continue
        small = cands[0]
        if small["area"] == 0 or area_of(small) > 3.0e6:
            continue
        for big in cands[1:]:
            if big["area"] == 0 or inside_fraction(small, big) < 0.85:
                continue
            outer_of[cell] = (small["area"], big["area"])
            break
    outer_z = {}
    for area, seeds in exclusive.items():
        zs = [z for cell in seeds for z in z_by_cell.get(cell, [])]
        if len(zs) >= 5:
            zs.sort()
            outer_z[area] = zs[len(zs) // 2]
    nested_margin = 0
    for cell, (inner, outer) in outer_of.items():
        base = outer_z.get(outer)
        zs = z_by_cell.get(cell)
        if base is None or not zs:
            continue
        x, y = (cell[1] + 0.5) * CELL, (cell[2] + 0.5) * CELL
        if current(cell[0], x, y) != inner:
            continue                                     # 框规则本来就把这格算给内圈
        if any(abs(z - base) > 40 for z in zs):
            continue                                     # 有洞穴内部的点：整格留给内圈
        inner_dir = name_of.get(inner)
        outer_dir = name_of.get(outer)
        if not inner_dir or not outer_dir:
            continue
        # 地形网格必须同意（或者根本没数据，例如山体内部）：网格说是别处时不动，
        # 那多半是副本门口这种「地图框盖到了邻区地形上」的情况。
        terrain = grid_dir(grid_rows, cell[0], x, y, 533.3333333 / 16) if grid_rows else None
        if terrain is not None and terrain != outer_dir:
            continue
        fixes[cell] = outer
        pairs[cell] = (inner_dir, outer_dir)
        groups[(inner_dir, outer_dir)] += 1
        nested_margin += 1
    print("其中「嵌套区域的地表边距」候选 %d 格" % nested_margin)
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
        # 地形网格必须同意（或根本没数据）：网格说是别处时，多半是「地图框盖到了邻区地形上」
        # 的副本门口/洞穴，判据靠的是内容距离，不如地形本身可靠。
        if grid_rows:
            terrain = grid_dir(grid_rows, m, x, y, 533.3333333 / 16)
            if terrain is not None and terrain != name_of.get(a1):
                continue
        fixes[cell] = a1
        pairs[cell] = (name_of.get(cur, cur), name_of.get(a1, a1))
        groups[pairs[cell]] += 1

    print("候选修正格 %d 个，分 %d 组" % (len(fixes), len(groups)))
    for (a, b), n in groups.most_common():
        mark = "✅ 已核验" if (a, b) in VERIFIED else ("❌ 判据有误" if (a, b) in REJECTED else "? 未核验")
        print("   %-22s → %-22s %5d 格   %s" % (a, b, n, mark))

    if args.report:
        cell_names = {}
        if args.names:
            query = ("SELECT ct.name, c.id, c.map, FLOOR(c.position_x/%.6f), FLOOR(c.position_y/%.6f)"
                     " FROM creature c JOIN creature_template ct ON ct.entry = c.id"
                     " UNION ALL SELECT gt.name, g.id, g.map, FLOOR(g.position_x/%.6f), FLOOR(g.position_y/%.6f)"
                     " FROM gameobject g JOIN gameobject_template gt ON gt.entry = g.id;"
                     % (CELL, CELL, CELL, CELL))
            out = subprocess.run(args.mysql.split() + ["-e", query], capture_output=True, text=True)
            for line in out.stdout.split("\n")[1:]:
                parts = line.split("\t")
                if len(parts) < 5 or not parts[0].strip():
                    continue
                try:
                    key = (int(parts[2]), int(parts[3]), int(parts[4]))
                    entry = int(parts[1])
                except ValueError:
                    continue
                cell_names.setdefault(key, []).append((parts[0], entry))
        # 每组汇总全部格子的内容，而不是只看前两格：判据是否可信，看的就是这些名字属于谁。
        # 每格里记 (名字, entry)，entry >= 50000 是乌龟服自定义内容。
        by_pair = collections.defaultdict(list)
        for cell, pair in pairs.items():
            by_pair[pair].append(cell)
        print("\n=== 核验报告（每组汇总全部格子）===")
        print("列：现状(页面) → 判据建议 | 格数 | 内容数 | 自定义内容数(entry≥50000) | 内容名")
        print("mark：✅ 已核验采纳 / ❌ 已核验否掉 / ? 未核验；* 标记该区域是乌龟服新增")
        print()
        for pair, cells in sorted(by_pair.items(), key=lambda kv: -len(kv[1])):
            all_names = collections.Counter()
            total = custom = 0
            for cell in cells:
                for name, entry in cell_names.get(cell, ()):
                    all_names[name] += 1
                    total += 1
                    if entry >= 50000:
                        custom += 1
            mark = "✅" if pair in VERIFIED else ("❌" if pair in REJECTED else "?")
            def tag(directory):
                for b in boxes:
                    if b["dir"] == directory and b["area"] in custom_areas:
                        return directory + "*"
                return directory
            share = (100.0 * custom / total) if total else 0.0
            print("%-22s %-22s %6d %8d %7d (%3.0f%%)  %s %s" % (
                tag(pair[0]), tag(pair[1]), len(cells), total, custom, share, mark,
                ", ".join(n for n, _ in all_names.most_common(6))))

    if args.dump:
        with open(args.dump, "w", encoding="utf-8") as fh:
            fh.write("map\tcx\tcy\tcurrent\tsuggested\tgroup\n")
            for cell in sorted(fixes):
                pair = pairs[cell]
                cur_dir = pair[0]
                fh.write("%d\t%d\t%d\t%s\t%s\t%s->%s\n"
                         % (cell[0], cell[1], cell[2], cur_dir, name_of.get(fixes[cell]),
                            pair[0], pair[1]))
        print("候选格已导出 %s：%d 格" % (args.dump, len(fixes)))

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
