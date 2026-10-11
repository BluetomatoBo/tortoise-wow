#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
check_update_file.py —— 检查 sql/database_updates/world/*.sql 能不能被内核的自动更新器吃下去。

内核的切分实现在 `src/shared/Database/AutoUpdater.cpp`（ApplyFile → 逐字符扫描）。按源码，
它**会剥注释**：`--` 行注释与 `/* */` 块注释里的字符根本不进 query 缓冲，注释里的引号
也不参与字符串判定。所以「注释里写了个 it's」是安全的。

> 2026-10-11 用线上库复核过这条：仓库里 **11 个注释含单引号的迁移文件，全部被内核成功执行**
> （`migrations` 表里都有记录，含当天新写的 `20261011130000_world`）——
> 之前本工具把它判成「mid-string query at the end of SQL」是**误报**（旧版没模拟注释作用域）。

真正会出事的只有两类：

  1. **正文里的引号不闭合**：`'` / `"` 落单（注释之外）→ 作用域一直开着 →
     内核报 `[FAIL] mid-string query at the end of SQL`，**整份更新都不执行**。
  2. **`#` 行注释里出现引号**：MySQL 认 `#` 是注释，但内核**不认**（它只认 `--` 和 `/* */`），
     会把这行当正文 → 里面的引号让作用域错位，甚至把后面的 `;` 吞掉。
     这一类本工具会点出来（改写成 `--` 即可）。

其余情况（纯注释的语句块、最后一个 `;` 之后的注释尾）内核都会跳过，只作提示。

用法：
    python3 tools/dbdiff/check_update_file.py sql/database_updates/world/*.sql
"""
import re
import sys


def split_like_autoupdater(text, hash_comments=False):
    """逐字符模拟 AutoUpdater.cpp 的切分：跟踪注释作用域 + 引号作用域，不在字符串里的 ; 切句。

    hash_comments=True 时额外把 `#` 当行注释（MySQL 的行为，用来对比内核少认一种注释的后果）。
    """
    NONE, SINGLE, DOUBLE = 0, 1, 2
    C_NONE, C_LINE, C_BLOCK = 0, 1, 2
    scope, cscope = NONE, C_NONE
    queries, q = [], ""
    n = len(text)
    for i, ch in enumerate(text):
        if ch in "\r\n":
            if ch == "\n":
                q += " "
            if cscope == C_LINE:
                cscope = C_NONE
            continue

        if ch == "/":
            if cscope == C_BLOCK and i > 0 and text[i - 1] == "*":
                cscope = C_NONE
                continue
            if i < n - 1 and scope == NONE and text[i + 1] == "*":
                cscope = C_BLOCK
                continue

        if cscope != C_NONE:
            continue

        if ch == "-" and i < n - 1 and scope == NONE and text[i + 1] == "-":
            cscope = C_LINE
            continue

        if hash_comments and ch == "#" and scope == NONE:
            cscope = C_LINE
            continue

        if ch == "'":
            if scope == NONE:
                scope = SINGLE
            elif scope == SINGLE and (i == 0 or text[i - 1] != "\\"):
                scope = NONE
        elif ch == '"':
            if scope == NONE:
                scope = DOUBLE
            elif scope == DOUBLE and (i == 0 or text[i - 1] != "\\"):
                scope = NONE

        q += ch
        if ch == ";" and scope == NONE:
            queries.append(q)
            q = ""
    return queries, q, scope


def _norm(queries):
    return [q.replace(" ", "").replace("\n", "").strip(";") for q in queries if q.replace(" ", "").replace("\n", "").strip(";")]


def check(path):
    text = open(path, encoding="utf-8", errors="replace").read()
    queries, tail, scope = split_like_autoupdater(text)
    problems, notes = [], []

    if scope != 0:
        problems.append("正文里的引号没闭合 → 内核报 mid-string query at the end of SQL，整份不执行")

    # 内核不认 `#`：只有当文件真的依赖 `#` 注释时才有害（`#` 出现在字符串里无害）
    if _norm(split_like_autoupdater(text, hash_comments=True)[0]) != _norm(queries):
        problems.append("`#` 注释影响了切分 —— 内核不认 `#`（只认 `--`/`/* */`），请改成 `--`")

    if tail.strip():
        notes.append("最后一个 `;` 之后还有内容（内核会尝试执行，纯注释无妨）")

    n_real = len(_norm(queries))
    verdict = ("!! " + "；".join(problems)) if problems else ("OK" + ("（提示：%s）" % "；".join(notes) if notes else ""))
    print("%-46s 语句 %3d 条  %s" % (path.split("/")[-1], n_real, verdict))
    return not problems


if __name__ == "__main__":
    files = sys.argv[1:]
    if not files:
        import glob
        files = sorted(glob.glob("sql/database_updates/world/*.sql"))
    bad = [f for f in files if not check(f)]
    print("\n有问题：%d / %d" % (len(bad), len(files)))
    sys.exit(1 if bad else 0)
