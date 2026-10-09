#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sync_wip_from_db.py —— 以**线上库为准**回写 sql/wip_updates/ 里的汉化文件（防止整份重导把好译文覆盖回旧版）

背景：wip_updates 里的批量汉化文件（locales_*.sql）是「当时生成」的版本，之后你在库上做过人工修订
（例：`诺拉斯特伊姆西特` → `诺拉·汽望`、`阿拉西娅对艾露恩的誓言` → `阿勒西的艾露恩之誓`）。
若某天有人把这些文件**整份重导**，就会把线上的好译文覆盖掉。本工具按线上值把文件里的字符串
字面量改写成线上值，使「仓库 = 线上」，之后重导就是幂等的。

安全约定：
  * 默认**只生成** `<file>.synced` 供 diff 审阅，**不改原文件**；确认后再用 --apply 覆盖（会先写 .bak）；
  * 只改「线上值是中文（含全角标点）且与脚本不同」的行；线上为空或非中文的行不动（那是真漏导，另走补数据）；
  * 字符串字面量按 MySQL 规则重新转义（\\ 与 ' ），不会破坏 SQL 结构。

用法：
    python3 tools/dbdiff/sync_wip_from_db.py --dir sql/wip_updates \
        --mysql "mysql -h127.0.0.1 -uroot -p tw_world"              # 生成 .synced
    python3 tools/dbdiff/sync_wip_from_db.py --dir sql/wip_updates \
        --mysql "mysql -h127.0.0.1 -uroot -p tw_world" --apply      # 覆盖（备份 .bak）
"""
import argparse
import hashlib
import importlib.util
import os
import re
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location("vwl", os.path.join(HERE, "verify_wip_locales.py"))
vwl = importlib.util.module_from_spec(spec)
spec.loader.exec_module(vwl)

CJK = re.compile(r"[\u2e80-\u9fff\u3000-\u303f\uff00-\uffef]")


def escape_mysql(text):
    """字面量转义：反斜杠、单引号，以及**控制字符**。
    少转义换行/回车会把值写成真实换行，重导时语义就变了（CRLF → LF，甚至多出一个字面 \\n）。"""
    return (text.replace("\\", "\\\\").replace("\0", "\\0")
                .replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t")
                .replace("'", "\\'"))


def statement_spans(text):
    """返回 [(start, end)]：每条语句在原文中的跨度（用 verify 工具同一套状态机）。"""
    spans, i, n, in_str, start = [], 0, len(text), False, 0
    while i < n:
        c = text[i]
        if in_str:
            if c == "\\" and i + 1 < n: i += 2; continue
            if c == "'":
                if i + 1 < n and text[i + 1] == "'": i += 2; continue
                in_str = False
            i += 1; continue
        if c == "'":
            in_str = True; i += 1; continue
        if c == "-" and text[i:i + 2] == "--" and (i + 2 >= n or text[i + 2] in " \t\r\n"):
            j = text.find("\n", i); i = n if j < 0 else j + 1; continue
        if c == "#":
            j = text.find("\n", i); i = n if j < 0 else j + 1; continue
        if text[i:i + 2] == "/*":
            j = text.find("*/", i + 2); i = n if j < 0 else j + 2; continue
        if c == ";":
            spans.append((start, i + 1)); start = i + 1
        i += 1
    if start < n: spans.append((start, n))
    return spans


# 单条语句里「(主键, 列) → 字面量跨度」的定位
RE_SELECT = re.compile(r"INSERT\s+(?:IGNORE\s+)?INTO\s+`(?P<table>[a-z_]+)`\s*\(\s*`(?P<key>[a-z_]+)`\s*,\s*"
                       r"`(?P<col>[a-z_0-9]+)`\s*\)\s*SELECT\s+(?P<keyval>'[^']*'|-?\d+)\s*,\s*'", re.I)
RE_VALUES = re.compile(r"INSERT\s+(?:IGNORE\s+)?INTO\s+`(?P<table>[a-z_]+)`\s*\((?P<cols>[^)]*)\)\s*VALUES\s*", re.I)


def literals_in(span_text):
    """返回 [((列, 主键), (字面量起始偏移, 结束偏移), 值)]，偏移相对 span 起点。"""
    out = []
    m = RE_SELECT.search(span_text)
    if m:
        start = m.end() - 1
        val, end = vwl.read_string_literal(span_text, start)
        out.append(((m.group("col"), m.group("keyval").strip().strip("'")), (start, end), val))
        return out
    m = RE_VALUES.search(span_text)
    if m:
        cols = [c.strip().strip("`") for c in m.group("cols").split(",")]
        for row in vwl.split_tuples(span_text[m.end():]):
            fields = vwl.split_fields_raw(row)
            if len(fields) != len(cols):
                continue
            keyval = fields[0].strip().strip("'")
            if not re.match(r"^-?\d+$", keyval):
                continue
            base = span_text.index(row, m.end())
            for idx in range(1, len(cols)):
                f = fields[idx]
                if not f.startswith("'"):
                    continue
                off = span_text.index(f, base)
                val, end = vwl.read_string_literal(span_text, off)
                out.append(((cols[idx], keyval), (off, end), val))
                base = off + (end - off)
        return out
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dir", required=True)
    ap.add_argument("--mysql", required=True)
    ap.add_argument("--apply", action="store_true", help="覆盖原文件（会先备份 .bak）")
    ap.add_argument("--include", help="只处理文件名匹配该 glob 的文件（可多次用逗号分隔，如 'locales_quest*.sql'）")
    args = ap.parse_args()

    import fnmatch as _fn
    includes = [x.strip() for x in args.include.split(",")] if args.include else None

    total_changed = 0
    for name in sorted(os.listdir(args.dir)):
        if not name.endswith(".sql"):
            continue
        if includes and not any(_fn.fnmatch(name, pat) for pat in includes):
            continue
        path = os.path.join(args.dir, name)
        items = vwl.parse(path)
        if not items:
            continue
        want = {}
        for t, c, k, v, kc in items:
            want.setdefault((t, kc), {})[(c, k)] = v

        # 取线上值
        live = {}
        for (table, keycol), mp in want.items():
            keys = sorted(set(k for _, k in mp))
            for i in range(0, len(keys), 200):
                chunk = keys[i:i + 200]
                cols = sorted(set(c for c, _ in mp))
                sel = "SELECT `%s`, %s FROM `%s` WHERE `%s` IN (%s)" % (
                    keycol, ",".join("IFNULL(`%s`,'')" % c for c in cols), table, keycol,
                    ",".join("'%s'" % k for k in chunk))
                rows, err = vwl.mysql_run(args.mysql, sel, fatal=False)
                if rows is None:
                    print("   %s：查询失败，跳过（%s）" % (name, err)); live = None; break
                for r in rows:
                    for idx, c in enumerate(cols):
                        # mysql --batch 输出把 \n / \t / \\ 转义过，取回真值再落盘（否则会二次转义）
                        raw = r[idx + 1] if len(r) > idx + 1 else ""
                        live[(table, keycol, c, r[0])] = vwl.unescape(raw)
            if live is None:
                break
        if live is None:
            continue

        text = open(path, encoding="utf-8", errors="replace").read()
        repls = []           # (start, end, new_literal, 列, 主键)
        for (s0, e0) in statement_spans(text):
            seg = text[s0:e0]
            m_sel, m_val = RE_SELECT.search(seg), RE_VALUES.search(seg)
            if m_sel:
                table, keycol = m_sel.group("table"), m_sel.group("key")
            elif m_val:
                table, keycol = m_val.group("table"), "entry"
            else:
                continue
            for (col, key), (ls, le), val in literals_in(seg):
                lv = live.get((table, keycol, col, key))
                if lv is None or not lv.strip() or not CJK.search(lv) or lv == val:
                    continue
                repls.append((s0 + ls, s0 + le, "'" + escape_mysql(lv) + "'", col, key))

        if not repls:
            continue
        repls.sort(reverse=True)
        out = text
        for start, end, new, col, key in repls:
            out = out[:start] + new + out[end:]
        total_changed += len(repls)
        dst = path if args.apply else path + ".synced"
        if args.apply:
            shutil.copy(path, path + ".bak")
        open(dst, "w", encoding="utf-8").write(out)
        print("   %-34s 改写 %3d 行 → %s" % (name, len(repls), dst))

    if total_changed:
        print("\n合计改写 %d 行。" % total_changed)
        if not args.apply:
            print("先 diff 审阅：diff -u <原文件> <原文件>.synced；确认后加 --apply 覆盖（会备份 .bak）")
    else:
        print("没有需要回写的行（仓库与线上一致）")


if __name__ == "__main__":
    main()
