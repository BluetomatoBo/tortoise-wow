#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""gen_pet_spell_data.py — 用客户端 CreatureSpellData.dbc 核对/补齐 pet_spell_data。

# 为什么客户端是这张表的权威来源

`creature_template.pet_spell_list_id` 指向 `pet_spell_data`（= 客户端 `CreatureSpellData.dbc`：
id + 4 个技能）。内核自己写着「fill data from DBC as more correct source if available」
（`ObjectMgr.cpp` 的 `LoadPetCreateSpells`）：驯服宠物时先用 `petcreateinfo_spell`，
再用本表**覆盖**；并在需要「教技能」时把技能换成它的学习包装（`effect 36 LEARN_SPELL`
且 trigger = 该技能的那一条）。同一个 id 还会发给客户端（`CMSG_CREATURE_QUERY` 的第 12 个
字段），客户端拿自己的 DBC 显示这只宠物会什么。

所以：**客户端 DBC = 原始数据**，服务端表是它的镜像。本工具把两者逐行比一遍，给出三类结论：

  * 只有客户端有 → 该补（缺行会让内核报 `has nonexistent pet_spell_list_id`，宠物也没有技能）
  * 两侧都有但客户端多技能 → 该更新（驯服的宠物少了客户端已经显示的那个技能）
  * 只有服务端有 / 新旧客户端有出入 → 单独列出，**默认不动**（属于乌龟服服务端自己的增删）

## 用哪个客户端文件

清单（`tools/dbc_verification/manifest_formatted.json`）里 `DBFilesClient/CreatureSpellData.dbc`
有两个版本（客户端用**较新**的那个，和所有其它文件同一条规则），取出来时按 sha256 校验。
本机原版 1.12.1 客户端的同名 DBC 也能读（`--vanilla-client`，走 StormLib），用于对照。

## 用法

    python3 tools/WowWeb/gen_pet_spell_data.py \
        --mysql "$(pwd)/tools/dbdiff/mysql_local.sh tw_world" --emit-sql /tmp/pet.sql
    python3 tools/WowWeb/gen_pet_spell_data.py --mysql ... --vanilla-client ~/Downloads/WoW_Classic
"""

import argparse
import os
import shlex
import subprocess
import sys

from clientfiles import Client, read_dbc

HERE = os.path.dirname(os.path.abspath(__file__))
MANIFEST = os.path.normpath(os.path.join(HERE, "..", "dbc_verification", "manifest_formatted.json"))
CACHE = os.path.join(os.path.expanduser("~"), ".cache", "tw-icons")
DBC = "DBFilesClient/CreatureSpellData.dbc"


def live_rows(mysql):
    """线上 pet_spell_data：{entry: (spell1, spell2, spell3, spell4)}。"""
    out = subprocess.run(shlex.split(mysql) + ["-N", "-B", "--raw", "-e",
                          "SELECT entry, spell_id1, spell_id2, spell_id3, spell_id4 FROM pet_spell_data"],
                         capture_output=True, text=True).stdout
    rows = {}
    for line in out.splitlines():
        parts = line.split("\t")
        if len(parts) == 5:
            rows[int(parts[0])] = tuple(int(x) for x in parts[1:])
    return rows


def referenced(mysql):
    """哪些 pet_spell_list_id 正被生物引用（数量）。"""
    out = subprocess.run(shlex.split(mysql) + ["-N", "-B", "--raw", "-e",
                          "SELECT pet_spell_list_id, COUNT(*) FROM creature_template "
                          "WHERE pet_spell_list_id <> 0 GROUP BY pet_spell_list_id"],
                         capture_output=True, text=True).stdout
    ref = {}
    for line in out.splitlines():
        parts = line.split("\t")
        if len(parts) == 2:
            ref[int(parts[0])] = int(parts[1])
    return ref


def vanilla_rows(client_root):
    """从本机原版客户端 MPQ 里读同名 DBC（可选，用于对照）。"""
    if not client_root:
        return {}
    sys.path.insert(0, HERE)
    import glob
    import extract_client_files as E
    archives = sorted(glob.glob(os.path.join(client_root, "Data", "*.MPQ")),
                      key=lambda p: E.patch_priority(os.path.basename(p)))
    for path in reversed(archives):
        try:
            data = E.Archive(path).read("DBFilesClient\\CreatureSpellData.dbc")
        except OSError:
            continue
        if data:
            tmp = "/tmp/_vanilla_creaturespelldata.dbc"
            open(tmp, "wb").write(data)
            return {r[0]: tuple(r[1:5]) for r in read_dbc(tmp)[0]}
    return {}


def sql_literal(values):
    return "(" + ",".join(str(v) for v in values) + ")"


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--mysql", required=True, help="线上库的 mysql 命令")
    ap.add_argument("--manifest", default=MANIFEST)
    ap.add_argument("--cache", default=CACHE)
    ap.add_argument("--vanilla-client", help="原版客户端根目录（可选，读了只做对照）")
    ap.add_argument("--emit-sql", help="把「该补 / 该更新」的语句写到这里")
    args = ap.parse_args()

    client = Client(args.manifest, args.cache)
    local = client.fetched(DBC)
    if local is None:
        sys.exit("清单里没有 %s" % DBC)
    want = {r[0]: tuple(r[1:5]) for r in read_dbc(local)[0]}
    have = live_rows(args.mysql)
    ref = referenced(args.mysql)
    vanilla = vanilla_rows(args.vanilla_client)

    only_client = sorted(k for k in want if k not in have)
    differing = sorted(k for k in want if k in have and want[k] != have[k])
    # 客户端一侧全 0 而服务端有技能 = 「客户端把这只宠物的技能清掉了」，
    # 与「客户端多给了技能」是两回事，含义相反；默认只报告不动（需人工确认）。
    stale = [k for k in differing if any(want[k])]
    cleared = [k for k in differing if not any(want[k])]
    only_server = sorted(k for k in have if k not in want)

    print("客户端 %s：%d 行；线上 pet_spell_data：%d 行" % (os.path.basename(local), len(want), len(have)))
    print("  两侧一致：%d 行" % (len(set(want) & set(have)) - len(stale)))
    print("  只有客户端有（该补）：%d 行，其中被生物引用 %d 行（共 %d 只生物）" %
          (len(only_client), sum(1 for k in only_client if k in ref),
           sum(ref.get(k, 0) for k in only_client)))
    for k in only_client:
        print("     #%-7d %s  引用 %d 只" % (k, sql_literal(want[k]), ref.get(k, 0)))
    print("  两侧都有但客户端多技能（该更新）：%d 行，被生物引用 %d 只" % (len(stale), sum(ref.get(k, 0) for k in stale)))
    for k in stale:
        print("     #%-7d 线上 %s → 客户端 %s  引用 %d 只" % (k, sql_literal(have[k]), sql_literal(want[k]), ref.get(k, 0)))
    print("  客户端把技能清成 0（默认不动，需人工确认）：%d 行" % len(cleared))
    for k in cleared:
        print("     #%-7d 线上 %s → 客户端 %s  引用 %d 只" % (k, sql_literal(have[k]), sql_literal(want[k]), ref.get(k, 0)))
    print("  只有服务端有（默认不动）：%d 行 → %s" % (len(only_server), only_server[:10]))
    if vanilla:
        v_conflict = [k for k in stale if k in vanilla and tuple(vanilla[k]) != want[k]]
        print("  原版 1.12.1 客户端对照：%d 行；与最新客户端不一致的 %d 行 %s"
              % (len(vanilla), len(v_conflict), v_conflict[:5] or "（无）"))

    if args.emit_sql:
        with open(args.emit_sql, "w", encoding="utf-8") as fh:
            fh.write("INSERT IGNORE INTO `pet_spell_data` (`entry`, `spell_id1`, `spell_id2`, `spell_id3`, `spell_id4`) VALUES\n")
            fh.write(",\n".join("  (%d,%d,%d,%d,%d)" % ((k,) + want[k]) for k in only_client) + ";\n")
            for k in stale:
                for slot, (old, new) in enumerate(zip(have[k], want[k]), start=1):
                    if old != new:
                        fh.write("UPDATE `pet_spell_data` SET `spell_id%d` = %d "
                                 "WHERE `entry` = %d AND `spell_id%d` = %d;\n" % (slot, new, k, slot, old))
        print("SQL 已写入 %s" % args.emit_sql)


if __name__ == "__main__":
    main()
