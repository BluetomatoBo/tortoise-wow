#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_locale_patch.py —— 按审阅表生成「定向覆盖补丁」（只动 decision = repo 的那几行）

配合 verify_wip_locales.py --review-out 使用：

    python3 tools/dbdiff/verify_wip_locales.py --dir sql/wip_updates \
        --mysql "mysql -h127.0.0.1 -uroot -p tw_world" --review-out /tmp/locale_review.tsv
    # 打开 /tmp/locale_review.tsv，逐行在最后一列填 repo（用仓库文件的译文）/ live / skip
    python3 tools/dbdiff/gen_locale_patch.py --review /tmp/locale_review.tsv > /tmp/locale_patch.sql
    mysql -h127.0.0.1 -uroot -p tw_world < /tmp/locale_patch.sql

生成的语句形如
    UPDATE `locales_creature` SET `name_loc4` = '黑暗者纳科格' WHERE `entry` = 62739;
并带 `AND (`name_loc4` IS NULL OR `name_loc4` <> '...')` 幂等守卫；只读 TSV、不碰任何文件。
"""
import argparse
import sys

sys.path.insert(0, __file__.rsplit("/", 1)[0])
import importlib.util
spec = importlib.util.spec_from_file_location("vwl", __file__.rsplit("/", 1)[0] + "/verify_wip_locales.py")
vwl = importlib.util.module_from_spec(spec)
spec.loader.exec_module(vwl)


def escape_mysql(text):
    return text.replace("\\", "\\\\").replace("'", "\\'")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--review", required=True, help="填好 decision 列的审阅表 TSV")
    ap.add_argument("--out", help="输出 SQL 文件（默认打到 stdout）")
    ap.add_argument("--decisions", default="repo", help="把哪些 decision 值当作「采用仓库译文」（默认 repo）")
    ap.add_argument("--include-skip", action="store_true", help="连 decision=skip 也生成（默认跳过）")
    args = ap.parse_args()

    want = set(x.strip() for x in args.decisions.split(",") if x.strip())
    lines = open(args.review, encoding="utf-8", errors="replace").read().split("\n")
    if not lines or "decision" not in lines[0]:
        sys.exit("审阅表格式不对：第一行应为表头，且含 decision 列")
    header = lines[0].split("\t")
    idx = {name: i for i, name in enumerate(header)}
    for need in ("table", "column", "entry", "repo_value", "decision"):
        if need not in idx:
            sys.exit("审阅表缺少列：%s" % need)

    out = ["-- 由 tools/dbdiff/gen_locale_patch.py 依据审阅表生成",
           "-- 只覆盖 decision 为 %s 的行（定向、幂等）" % "/".join(sorted(want)),
           "SET NAMES utf8mb4;", ""]
    n = 0
    for line in lines[1:]:
        if not line.strip():
            continue
        f = line.split("\t")
        # 容忍行尾制表符被编辑器吃掉：不足表头长度时按空值补齐（decision 为空 = 跳过）
        if len(f) < len(header):
            f = f + [""] * (len(header) - len(f))
        if len(f) != len(header):
            continue
        decision = f[idx["decision"]].strip().lower()
        if decision not in want and not (args.include_skip and decision == "skip"):
            continue
        table, col, key, val = f[idx["table"]], f[idx["column"]], f[idx["entry"]], f[idx["repo_value"]]
        lit = escape_mysql(val)
        out.append("UPDATE `%s` SET `%s` = '%s' WHERE `entry` = %s"
                   " AND (`%s` IS NULL OR `%s` <> '%s');" % (table, col, lit, key, col, col, lit))
        n += 1

    out.append("")
    out.append("-- 共 %d 条；生效：mangosd 控制台 `.reload locales_quest`（或对应表）" % n)
    text = "\n".join(out) + "\n"
    if args.out:
        open(args.out, "w", encoding="utf-8").write(text)
        print("已写出 %s（%d 条）" % (args.out, n))
    else:
        sys.stdout.write(text)


if __name__ == "__main__":
    main()
