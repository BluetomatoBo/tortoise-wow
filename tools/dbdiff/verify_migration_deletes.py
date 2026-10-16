#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify_migration_deletes.py —— 检查「迁移删掉的行，是不是又被导进来的数据带回来了」

为什么会需要这个
    内核的自动更新器（src/shared/Database/AutoUpdater.cpp）按文件 SHA1 记进 `migrations`
    表，记录在就意味着那条迁移**执行成功**。但「DELETE 命中 0 行」在 MySQL 里也算成功 ——
    如果导库（DROP+CREATE 整表重建）与迁移同时在跑，删除就可能落在一个空表上，
    之后导进来的数据又把那些行带回来，而迁移永远不会再跑第二遍（记录已经在）。
    2026-09-30 世界库首次搭建时就发生了这件事：11 个生存训练师的旧刷怪点在布瑞尔等地
    各留了一份重复（详见 README 第二十六节）。

判定
    按 (迁移应用时间, 文件内语句位置) 还原每一行 guid 的操作序列，取**最后一次操作**：
      * 最后一次是 DELETE，但行还在 → 幽灵行（应删未删，几乎肯定是数据回灌）
      * 最后一次是 INSERT，但行不在 → 反向缺失（该在不在；通常是整表重建把迁移的插入冲掉了）
      * 整图删除（DELETE ... WHERE map = N）无法逐 guid 从文件还原，
        改为按「该行由更早的迁移插入、此后没有任何迁移再插入」筛出来，单独列（可能是正常内容）

用法
    python3 tools/dbdiff/verify_migration_deletes.py \
        --mysql "tools/dbdiff/mysql_local.sh tw_world" \
        --dir sql/database_updates/world \
        --table creature --table gameobject \
        --report /tmp/migration_delete_audit.tsv

    只读，不写任何数据。
"""
import argparse
import glob
import os
import re
import subprocess
import sys
from collections import Counter, defaultdict

INSERT_HEAD = re.compile(r"INSERT\s+INTO\s+`(?P<table>\w+)`", re.I)
DELETE_HEAD = re.compile(r"DELETE\s+(?:FROM\s+)?`?(?P<table>\w+)`?", re.I)
GUID_IN = re.compile(r"`?guid`?\s+IN\s*\((?P<ids>[^)]*)\)", re.I | re.S)
BETWEEN = re.compile(r"BETWEEN\s+(\d+)\s+AND\s+(\d+)", re.I)
MAP_EQ = re.compile(r"`?map`?\s*=\s*(\d+)", re.I)
ROW_HEAD = re.compile(r"[\s(]*(\d+)")


def strip_comments(text):
    text = re.sub(r"/\*.*?\*/", " ", text, flags=re.S)
    return re.sub(r"--[^\n]*", " ", text)


def file_events(path, table):
    """返回 [(文件内位置, 'insert'|'delete', guid, map)，按位置升序；map 只在 insert 时有值。"""
    text = strip_comments(open(path, encoding="utf-8", errors="replace").read())
    events = []
    for m in INSERT_HEAD.finditer(text):
        if m.group("table").lower() != table:
            continue
        values = text.find("VALUES", m.end())
        end = text.find(";", m.end())
        if values < 0 or end < 0 or values > end:
            continue                                    # INSERT ... SELECT 之类，跳过
        stop = text.find(";", values)
        for row in re.split(r"\),\s*\(", text[values + 6:stop]):
            head = ROW_HEAD.match(row)
            if not head:
                continue
            fields = [f.strip() for f in row.split(",")]
            map_id = int(fields[5]) if len(fields) > 5 and fields[5].lstrip("-").isdigit() else None
            events.append((m.start(), "insert", int(head.group(1)), map_id))
    for m in DELETE_HEAD.finditer(text):
        if m.group("table").lower() != table:
            continue
        stop = text.find(";", m.end())
        body = text[m.end():stop]
        for ids in GUID_IN.finditer(body):
            for value in re.findall(r"\d+", ids.group("ids")):
                events.append((m.start(), "delete", int(value), None))
        for a, b in BETWEEN.findall(body):
            a, b = int(a), int(b)
            if b - a <= 20000:                          # 小范围才展开
                for value in range(a, b + 1):
                    events.append((m.start(), "delete", value, None))
    return events


def map_deletes(path, table):
    text = strip_comments(open(path, encoding="utf-8", errors="replace").read())
    out = []
    for m in DELETE_HEAD.finditer(text):
        if m.group("table").lower() != table:
            continue
        body = text[m.end():text.find(";", m.end())]
        for value in MAP_EQ.findall(body):
            out.append(int(value))
    return out


def mysql_rows(mysql, sql):
    cmd = mysql.split() + ["--batch", "-N", "-B", "-e", sql]
    out = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if out.returncode != 0:
        sys.exit("mysql 失败：%s" % out.stderr.decode("utf-8", "replace").strip())
    return [line.split("\t") for line in out.stdout.decode("utf-8", "replace").split("\n") if line.strip()]


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--mysql", required=True, help="mysql 命令行（含库名）")
    parser.add_argument("--dir", default="sql/database_updates/world", help="迁移文件目录")
    parser.add_argument("--table", action="append", default=[], help="要检查的表（可重复），默认 creature")
    parser.add_argument("--exclude", action="append", default=[], help="忽略这些迁移文件名（不含 .sql）")
    parser.add_argument("--report", default="", help="把明细写成 TSV")
    args = parser.parse_args()
    tables = args.table or ["creature"]
    exclude = set(args.exclude)

    applied = {name: when for name, when in mysql_rows(args.mysql, "SELECT Name, AppliedAt FROM migrations;")}
    report = []

    for table in tables:
        print("######## %s" % table)
        live = {int(row[0]) for row in mysql_rows(args.mysql, "SELECT guid FROM `%s`;" % table) if row[0].isdigit()}
        ops = defaultdict(list)
        insert_map = {}
        for path in sorted(glob.glob(os.path.join(args.dir, "*.sql"))):
            name = os.path.basename(path)[:-4]
            when = applied.get(name)
            if not when or name in exclude:
                continue
            events_of_file = file_events(path, table)
            for pos, kind, guid, map_id in events_of_file:
                ops[guid].append((when, pos, kind, name))
                if kind == "insert" and map_id is not None:
                    insert_map[guid] = map_id
            for map_id in map_deletes(path, table):              # 整图删除：补一条删除事件
                for guid, row_map in insert_map.items():
                    if row_map == map_id:
                        ops[guid].append((when, -1, "delete", name))

        ghost, missing = [], []
        for guid, events in ops.items():
            events.sort()
            when, _, kind, name = events[-1]
            if kind == "delete" and guid in live:
                ghost.append((guid, name, when))
            elif kind == "insert" and guid not in live:
                missing.append((guid, name, when))
        print("  ① 最后一次操作是删除、但行还在（应删未删）：%d" % len(ghost))
        for guid, name, when in sorted(ghost)[:15]:
            print("       guid %-9d ← %s（%s）" % (guid, name, when))
        print("  ② 最后一次操作是插入、但行不在（该在不在）：%d" % len(missing))
        for name, count in Counter(n for _, n, _ in missing).most_common(5):
            print("       %-30s 缺 %d 行" % (name, count))
        report += [("ghost", table, guid, name, when) for guid, name, when in ghost]
        report += [("missing", table, guid, name, when) for guid, name, when in missing]

        # 整图删除：把「由更早迁移插入、之后没有任何迁移再插入」的活行列出来
        for path in sorted(glob.glob(os.path.join(args.dir, "*.sql"))):
            name = os.path.basename(path)[:-4]
            when = applied.get(name)
            if not when or name in exclude:
                continue
            for map_id in map_deletes(path, table):
                rows = [int(r[0]) for r in mysql_rows(args.mysql,
                        "SELECT guid FROM `%s` WHERE map=%d;" % (table, map_id)) if r[0].isdigit()]
                suspect = [g for g in rows if not any(t > when for t, _, k, _ in ops.get(g, []) if k == "insert")]
                print("  ③ %s 整图删除 map=%d：现存 %d 行，其中 %d 行是「更早插入、之后没有迁移再插入」"
                      % (name, map_id, len(rows), len(suspect)))
                report += [("map_leftover", "%s/map%d" % (table, map_id), g, name, when) for g in suspect]
        print()

    if args.report:
        with open(args.report, "w", encoding="utf-8") as handle:
            handle.write("kind\ttable\tguid\tmigration\tapplied_at\n")
            for row in report:
                handle.write("\t".join(str(x) for x in row) + "\n")
        print("明细已写：%s（%d 行）" % (args.report, len(report)))
    print("提示：① 基本都是「导库把删掉的行又带回来」；③ 只说明这些行比整图清理更早，"
          "未必是错（相邻 guid 往往是同一批正常内容），要人工判断。")
    return 0


if __name__ == "__main__":
    sys.exit(main())
