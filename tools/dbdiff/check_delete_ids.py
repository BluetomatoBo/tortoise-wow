#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""check_delete_ids.py —— 删数据前，先看这些 id 有没有被代码硬编码引用。

## 为什么要有这个

2026-10-11 服务端每次玩家登录都 SIGSEGV：
`Player::RecallPvPGear()`（src/game/Objects/Player.cpp）用
`sObjectMgr.GetNpcVendorTemplateItemList(1279202)` 取两个商人物品模板，
而 `20261008154500_world.sql` 把它们当「没有任何生物的 vendor_id 指向它的孤儿」删掉了 ——
模板不在，`GetNpcVendorTemplateItemList()` 返回 nullptr，`vendorList->m_items` 解引用空指针。

判据的错在：「没有**数据**引用」不等于「没有**代码**引用」。这类字段（商人物品模板、
脚本 id、技能 id、区域 id……）常常是几个模板只给代码用，数据侧当然找不到引用。
乌龟服自己也踩过同一个坑：官方更新 20260509055406 里专门有一段
"Reinstate the old PvP npc_vendor_template entries to satisfy the RecallPvPGear function"。

## 用法

```bash
# 写迁移之前跑：报告这些 id 在 src/ 里出现的地方
python3 tools/dbdiff/check_delete_ids.py sql/database_updates/world/20261008154500_world.sql
python3 tools/dbdiff/check_delete_ids.py --dir sql/database_updates/world/20261008*.sql

# 扫描范围：默认 src/，可加 sql/base（看 base 里还有谁用这些 id）
python3 tools/dbdiff/check_delete_ids.py --roots src sql/base <file.sql>
```

输出按「表 → id → 代码位置」列出，人工判断是不是真的能删。退出码：发现可疑引用返回 1，
干净返回 0（可以挂到写迁移前的检查流程里）。

## 局限（2026-10-11 补）

* **只认字面数字**。写成子查询的删除（`DELETE ... WHERE NOT EXISTS (SELECT 1 FROM ...)`，
  例如 `prune_imported_cruft.sql`）这里抽不出 id —— 那份脚本按同样思路人工复核过一遍，
  每条规则都对照了内核源码（结果见该文件头部注释）；工具遇到子查询式删除会打印提示。
* 只扫 `src/` 与 `sql/base`。别的仓库（比如网站、工具）里的引用要自己加 `--roots`。
* 4 位以下的 id 不查（噪声太大）。

## 已经踩过的两个坑

1. `npc_vendor_template` 1277702/1279202：内核 `Player::RecallPvPGear()` 硬编码用它们
   （2026-10-11 登录崩溃事故）。
2. `area_template` 的整表重建：`GuardMgr.cpp` 里 57 个 `AREA_*` 常量靠这张表，重建时要确认
   它们都还在（该次重建是把 base dump 灌回去，核对过）。
"""

import argparse
import glob
import os
import re
import sys

DELETE_HEAD = re.compile(r"DELETE\s+FROM\s+`(\w+)`(.*?);", re.S | re.I)
# 4 位起：这类表的主键（entry/guid/模板 id）基本都是四位以上，小数字在代码里到处都是，
# 按数字比对只会淹掉结果；真要看小 id 就只能人肉查了。
NUMBER = re.compile(r"(?<![\w.])(\d{4,})(?![\w.])")
# 「像在引用一个 id」的行：命名常量、case 分支、比较、查表调用……代码里到处是 4 位数字
# （毫秒、坐标、距离），只有落在这种上下文里才值得人看一眼。
ID_CONTEXT = re.compile(
    r"(entry|Entry|_id|_ID|Id\b|case\s|==|!=|template|Template|Lookup|"
    r"NPC_|SPELL_|ITEM_|QUEST_|AREA_|GO_|CREATURE_|GAMEOBJECT_|TEXT_|SOUND_|VENDOR_|"
    r"Spell\w*\(|Item\w*\(|Quest\w*\(|Area\w*\(|Vendor\w*\()")


SUBQUERY_DELETE = re.compile(r"DELETE\b.*?\bWHERE\b.*?\(\s*SELECT\b", re.S | re.I)


def note_subquery_deletes(paths):
    """子查询式删除抽不出 id，只能提示人工按同样思路过一遍。"""
    count = 0
    for path in paths:
        text = open(path, encoding="utf-8", errors="replace").read()
        count += len(SUBQUERY_DELETE.findall(text))
    if count:
        print("提示：%d 条 DELETE 用的是子查询（不是 id 清单），本工具抽不出它们的 id；" % count)
        print("      这类规则要人工对照内核源码复核（参考 tools/dbdiff/prune_imported_cruft.sql 的写法）。\n")


def deleted_ids(paths):
    """{id: {表名}} —— 迁移里被删掉的 id。"""
    out = {}
    for path in paths:
        text = open(path, encoding="utf-8", errors="replace").read()
        for match in DELETE_HEAD.finditer(text):
            table, body = match.group(1), match.group(2)
            for raw in NUMBER.findall(body):
                value = int(raw)
                out.setdefault(value, set()).add(table)
    return out


def scan_sources(roots, want):
    """代码里出现的这些 id：{id: [(文件, 行号, 行内容)]}。"""
    hits = {}
    for root in roots:
        for dirpath, _, files in os.walk(root):
            for name in files:
                if not name.endswith((".cpp", ".h", ".sql", ".py", ".txt")):
                    continue
                path = os.path.join(dirpath, name)
                try:
                    handle = open(path, encoding="utf-8", errors="replace")
                except OSError:
                    continue
                with handle:
                    for lineno, line in enumerate(handle, 1):
                        stripped = line.lstrip()
                        if stripped.startswith(("//", "*", "/*", "--", "#")):
                            continue
                        tokens = list(NUMBER.finditer(line))
                        # 一行里挤了一堆数字的多半是数据数组/索引表，不是「按 id 取一行」
                        if len(tokens) > 3:
                            continue
                        for token in tokens:
                            value = int(token.group(1))
                            if value not in want:
                                continue
                            start, end = token.span()
                            if (start and line[start - 1] == ".") or (end < len(line) and line[end] == "."):
                                continue            # 浮点数的一部分
                            if not ID_CONTEXT.search(line):
                                continue        # 4 位数字的普通用法（时间、坐标、距离）
                            hits.setdefault(value, []).append((path, lineno, line.strip()[:120]))
    return hits


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[1],
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("files", nargs="*", help="要检查的迁移/更新 SQL")
    ap.add_argument("--dir", action="append", default=[],
                    help="用通配符指定一批文件，例如 'sql/database_updates/world/20261008*.sql'")
    ap.add_argument("--roots", nargs="+", default=["src", "sql/base"],
                    help="在这些目录里找引用（默认 src 与 sql/base）")
    args = ap.parse_args()

    paths = list(args.files)
    for pattern in args.dir:
        paths.extend(sorted(glob.glob(pattern)))
    if not paths:
        ap.error("没有输入文件（给文件名，或用 --dir '...*.sql'）")

    note_subquery_deletes(paths)
    ids = deleted_ids(paths)
    print("检查 %d 个文件：%d 个待删 id，涉及 %d 张表"
          % (len(paths), len(ids), len(set().union(*ids.values())) if ids else 0))
    hits = scan_sources(args.roots, set(ids))
    if not hits:
        print("\n✅ 这些 id 在 %s 里都没有出现，删掉不会让代码拿到 nullptr"
              % "、".join(args.roots))
        return 0

    print("\n⚠️  下面这些 id 在代码/基础数据里出现过，删之前确认它们不是代码硬编码要用的：\n")
    for value in sorted(hits, key=lambda v: -len(hits[v])):
        tables = ",".join(sorted(ids[value]))
        print("  %d（来自 %s）" % (value, tables))
        for path, lineno, line in hits[value][:4]:
            print("      %s:%d  %s" % (path, lineno, line))
        if len(hits[value]) > 4:
            print("      …还有 %d 处" % (len(hits[value]) - 4))
    return 1


if __name__ == "__main__":
    sys.exit(main())
