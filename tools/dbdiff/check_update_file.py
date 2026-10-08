#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
check_update_file.py —— 检查 sql/database_updates/world/*.sql 里的文件能不能被内核的自动更新器吃下去。

内核的自动更新器（src/shared/Database/AutoUpdater.cpp）切分语句的做法是：**只跟踪引号作用域**，
遇到不在引号里的 `;` 就切成一条语句 —— 它**不剥注释**。由此有两个坑：

  1. 注释里出现落单的英文单引号（例如 doesn't / it's / 人名里的 '），解析器会以为进了字符串，
     一直到最后都没闭合 → `[FAIL] mid-string query at the end of SQL`，整份更新都不会执行；
  2. 文件末尾如果还有一段只有注释的内容（最后一个 `;` 之后），它会被当成一条语句执行
     → MySQL 报 Query was empty。

用法：
    python3 tools/dbdiff/check_update_file.py sql/database_updates/world/*.sql
"""
import sys


def split_like_autoupdater(text):
    None_, Single, Double = 0, 1, 2
    scope, queries, q = None_, [], ""
    for i, ch in enumerate(text):
        if ch == "'":
            if scope == None_:
                scope = Single
            elif scope == Single and text[i - 1] != "\\":
                scope = None_
        elif ch == '"':
            if scope == None_:
                scope = Double
            elif scope == Double and text[i - 1] != "\\":
                scope = None_
        q += ch
        if ch == ";" and scope == None_:
            queries.append(q)
            q = ""
    return queries, q, scope


def check(path):
    # 只有内核会自动执行的文件（sql/database_updates/**）才需要严格按更新器规则检查；
    # 手工执行的脚本（如 verify_refs.sql、prune_imported_cruft.sql）里「分号后的纯注释」无害。
    auto = ("database_updates" in path) or ("/updates/" in path)
    text = open(path, encoding="utf-8", errors="replace").read()
    queries, tail, scope = split_like_autoupdater(text)
    problems, notes = [], []
    if scope != 0:
        problems.append("结尾仍处于字符串中 → 更新器会报 mid-string query at the end of SQL")
    if tail.strip("\t\r\n ;"):
        if all(l.strip().startswith("--") or not l.strip() for l in tail.split("\n")):
            msg = "最后一个 ; 之后还有纯注释内容 → 更新器会把它当语句执行（Query was empty）"
            (problems if auto else notes).append(msg if auto else "(仅自动更新文件需要注意) " + msg)
    # 纯注释的语句块
    for i, q in enumerate(queries):
        body = [l for l in q.split("\n") if l.strip() and not l.lstrip().startswith("--")]
        if not body:
            msg = "第 %d 块是纯注释（更新器仍会执行）" % (i + 1)
            (problems if auto else notes).append(msg)
    n_real = len([q for q in queries if any(l.strip() and not l.lstrip().startswith("--") for l in q.split("\n"))])
    if problems:
        verdict = "!! " + "；".join(problems)
    elif notes:
        verdict = "OK（非自动更新文件，注释块提示略过）"
    else:
        verdict = "OK"
    print("%-46s 语句 %3d 条，单引号 %4d 个 %s" % (path.split("/")[-1], n_real, text.count("'"), verdict))
    return not problems


if __name__ == "__main__":
    files = sys.argv[1:]
    if not files:
        import glob
        files = sorted(glob.glob("sql/database_updates/world/*.sql"))
    bad = [f for f in files if not check(f)]
    print("\n有问题：%d / %d" % (len(bad), len(files)))
    sys.exit(1 if bad else 0)
