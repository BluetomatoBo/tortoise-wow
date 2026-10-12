#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""extend_spellcategory.py — 给 SpellCategory.dbc 补上「数据里用到、文件里没有」的分组 id。

# 为什么需要它

`ObjectMgr::LoadItemPrototype` 有一条存在性检查：物品的 `spellcategory_1..5` 在
`SpellCategory.dbc` 里查不到就报 `Item (Entry: N) has wrong (not existing) spell category`。
本服务器上有 174 个物品命中（用到的 id 到 1175），而**没有任何现成文件包含这些 id**：

    原版 1.12.1 客户端       137 行，最大 id 1011
    服务器 DataDir 的那份     137 行，最大 id 1011（同一份）
    乌龟服 1.18.1 客户端      133 行，最大 id 932（比原版还少，是蛤龟自己重排过的）
    数据实际用到              最大 id 1175（物品）、1176（法术）

也就是说「刷新客户端 DBC 就能修好」这个说法不成立（客户端那份覆盖得更少）。

# 为什么补 0 是安全的

* 服务端**只检查这一行在不在**（`sSpellCategoryStore.LookupEntry`），从不读 `Flags`
  —— 全源码搜不到任何使用该字段的地方，也没有 `SPELL_CATEGORY_FLAG_*` 常量。
* 客户端那边：`Spell.dbc` 自己就用到了 1176 号分组，而它随身的 SpellCategory.dbc 只到 932
  → 客户端对这些分组本来也是「查不到 → 按默认（0）」处理。补一行 0 与「查不到」等价。

所以补出来的行 flag 一律取 0；原本存在的行**原样保留**（新文件是各来源的并集 + 数据里的 id）。

# 用法

    # 在服务器上或本机跑都行；--dbc 可以给多份作为底稿（会取并集）
    python3 tools/dbc_verification/extend_spellcategory.py \\
        --dbc /data_2T/ts_wow/dbc/SpellCategory.dbc \\
        --mysql "tools/dbdiff/mysql_local.sh tw_world" \\
        --out SpellCategory.dbc

输出文件的加载校验：行数、最大 id、按 id 升序、以及「数据里用到的 id 是否都在其中」。
"""

import argparse
import os
import shlex
import struct
import subprocess
import sys

FIELD_COUNT = 2
RECORD_SIZE = 8


def read_dbc(path):
    """返回 [(id, flags)]，做基本的结构校验。"""
    data = open(path, "rb").read()
    magic, records, fields, record_size, string_size = struct.unpack("<4sIIII", data[:20])
    if magic != b"WDBC":
        sys.exit("%s 不是 DBC（magic=%r）" % (path, magic))
    if (fields, record_size) != (FIELD_COUNT, RECORD_SIZE):
        sys.exit("%s 的结构不是 SpellCategory 的样子（fields=%d recSize=%d）"
                 % (path, fields, record_size))
    rows = []
    off = 20
    for _ in range(records):
        rows.append(struct.unpack("<II", data[off:off + RECORD_SIZE]))
        off += RECORD_SIZE
    return rows


def write_dbc(path, rows):
    rows = sorted(rows)
    out = bytearray(struct.pack("<4sIIII", b"WDBC", len(rows), FIELD_COUNT, RECORD_SIZE, 1))
    for id_, flags in rows:
        out += struct.pack("<II", id_, flags)
    out += b"\0"                      # 字符串块（长度 1，与各来源一致）
    open(path, "wb").write(bytes(out))


def used_ids(mysql):
    """数据里用到的 id：物品的 spellcategory_1..5 + 法术的 category。"""
    sql = ("SELECT v FROM ("
           "SELECT spellcategory_1 v FROM item_template UNION ALL SELECT spellcategory_2 FROM item_template "
           "UNION ALL SELECT spellcategory_3 FROM item_template UNION ALL SELECT spellcategory_4 FROM item_template "
           "UNION ALL SELECT spellcategory_5 FROM item_template UNION ALL SELECT category FROM spell_template"
           ") t WHERE v > 0")
    out = subprocess.run(shlex.split(mysql) + ["-N", "-B", "--raw", "-e", sql],
                         capture_output=True, text=True).stdout
    return {int(x) for x in out.split() if x.strip().isdigit()}


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--dbc", nargs="+", required=True, help="底稿（可给多份，取并集）")
    ap.add_argument("--mysql", required=True, help="线上库的 mysql 命令")
    ap.add_argument("--out", required=True, help="写出的新文件")
    args = ap.parse_args()

    merged = {}
    for path in args.dbc:
        rows = read_dbc(path)
        ids = sorted(r[0] for r in rows)
        print("%-44s %4d 行  最大 id %d" % (os.path.basename(path), len(rows), ids[-1]))
        for id_, flags in rows:
            if id_ in merged and merged[id_] != flags:
                print("   ⚠ id %d 的 flags 在不同底稿里不同（%d / %d），保留先出现的"
                      % (id_, merged[id_], flags))
                continue
            merged.setdefault(id_, flags)

    want = used_ids(args.mysql)
    missing = sorted(want - set(merged))
    print("数据里用到 %d 个 id，其中文件里缺 %d 个（最大 %s）"
          % (len(want), len(missing), missing[-1] if missing else "—"))
    if missing:
        print("   补上（flags=0）：%s%s" % (missing[:20], " …" if len(missing) > 20 else ""))

    for id_ in missing:
        merged[id_] = 0

    write_dbc(args.out, list(merged.items()))
    rows = read_dbc(args.out)
    ids = [r[0] for r in rows]
    still = sorted(want - set(ids))
    print("已写出 %s：%d 行，最大 id %d，升序 %s，数据里的 id 全覆盖 %s"
          % (args.out, len(rows), ids[-1], "是" if ids == sorted(ids) else "否",
             "是" if not still else ("否，仍缺 %s" % still)))
    if still:
        sys.exit(1)


if __name__ == "__main__":
    main()
