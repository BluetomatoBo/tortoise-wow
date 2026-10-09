#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify_wip_locales.py —— 核对 sql/wip_updates/ 里的汉化脚本是否已经写进线上库（逐条精确比对）

原理：解析脚本里每条 `INSERT INTO locales_xxx (entry, col) SELECT <entry>, '<文本>' ...`，
取出 (表, 主键, 列, 期望文本)，再用 mysql 客户端把线上值取回来比 MD5
（MySQL 的 MD5() 按列字符集的字节算，utf8mb4 下与 Python 的 md5(text.encode('utf-8')) 一致）。

用法：
    python3 tools/dbdiff/verify_wip_locales.py \
        --file sql/wip_updates/locales_quest_live_text.sql \
        --mysql "mysql -h127.0.0.1 -uroot -p tw_world"

输出：一致 / 不同 / 为空 / 行不存在 四类计数 + 前若干条不一致的明细（用 --limit 调整）。
只读，不改任何数据。
"""
import argparse
import glob
import hashlib
import os
import re
import subprocess
import sys

HEAD_INSERT_SELECT = re.compile(r"INSERT\s+(?:IGNORE\s+)?INTO\s+`(?P<table>[a-z_]+)`\s*\(\s*`(?P<key>[a-z_]+)`\s*,"
                                r"\s*`(?P<col>[a-z_0-9]+)`\s*\)\s*SELECT\s+(?P<keyval>'[^']*'|\d+)\s*,\s*(?P<text>')", re.I | re.S)
HEAD_INSERT_VALUES = re.compile(r"INSERT\s+(?:IGNORE\s+)?INTO\s+`(?P<table>[a-z_]+)`\s*\((?P<cols>[^)]*)\)\s*VALUES\s*",
                                re.I | re.S)
HEAD_UPDATE = re.compile(r"UPDATE\s+`(?P<table>[a-z_]+)`\s+SET\s+(?P<sets>.*?)\s+WHERE\s+(?P<where>[^;]*)$", re.I | re.S)
SET_ONE = re.compile(r"`?(?P<col>[a-z_0-9]+)`?\s*=\s*(?P<val>')", re.I)
WHERE_KEY = re.compile(r"`?(?P<key>[a-z_]+)`?\s*=\s*'?(?P<val>-?\d+)'?", re.I)
UNESCAPE = {"0": "\0", "b": "\b", "n": "\n", "r": "\r", "t": "\t", "Z": "\x1a",
            "\\": "\\", "'": "'", '"': '"', "%": "%", "_": "_"}


def unescape(text):
    out, i, n = [], 0, len(text)
    while i < n:
        c = text[i]
        if c == "\\" and i + 1 < n:
            out.append(UNESCAPE.get(text[i + 1], text[i + 1])); i += 2; continue
        out.append(c); i += 1
    return "".join(out)


def split_statements(text):
    """按分号切（跳过字符串内），并剥掉整行注释。"""
    text = "\n".join(l for l in text.split("\n") if not l.lstrip().startswith("--"))
    out, buf, quote, i, n = [], [], None, 0, len(text)
    while i < n:
        c = text[i]
        if quote:
            buf.append(c)
            if c == "\\" and i + 1 < n:
                buf.append(text[i + 1]); i += 2; continue
            if c == quote: quote = None
            i += 1; continue
        if c in "'\"":
            quote = c; buf.append(c); i += 1; continue
        if c == ";":
            out.append("".join(buf)); buf = []; i += 1; continue
        buf.append(c); i += 1
    if buf: out.append("".join(buf))
    return out


def read_string_literal(text, start):
    """从 text[start] == ' 开始，读到配对的收尾引号（处理 \\' 与 '' 两种转义）"""
    assert text[start] == "'"
    buf, i, n = [], start + 1, len(text)
    while i < n:
        c = text[i]
        if c == "\\" and i + 1 < n:
            buf.append(text[i:i + 2]); i += 2; continue
        if c == "'":
            if i + 1 < n and text[i + 1] == "'":
                buf.append("''"); i += 2; continue
            return unescape("".join(buf)), i + 1
        buf.append(c); i += 1
    raise ValueError("引号没有闭合")


def split_tuples(body):
    """把 VALUES 后的 (a,b),(c,d) 切成 [ 'a,b', 'c,d' ]：尊重引号、反斜杠转义与括号。"""
    out, buf, depth, quote, i, n = [], [], 0, None, 0, len(body)
    while i < n:
        c = body[i]
        if quote:
            buf.append(c)
            if c == "\\" and i + 1 < n:
                buf.append(body[i + 1]); i += 2; continue
            if c == quote: quote = None
            i += 1; continue
        if c in "'\"":
            quote = c; buf.append(c); i += 1; continue
        if c == "(":
            depth += 1
            if depth == 1:
                buf = []; i += 1; continue
        elif c == ")":
            depth -= 1
            if depth == 0:
                out.append("".join(buf)); buf = []; i += 1; continue
        if depth: buf.append(c)
        i += 1
    return out


def split_fields(row):
    out, buf, quote, i, n = [], [], None, 0, len(row)
    while i < n:
        c = row[i]
        if quote:
            if c == "\\" and i + 1 < n:
                buf.append(row[i:i + 2]); i += 2; continue
            if c == quote:
                quote = None; i += 1; continue
            buf.append(c); i += 1; continue
        if c in "'\"":
            quote = c; i += 1; continue
        if c == ",":
            out.append("".join(buf).strip()); buf = []; i += 1; continue
        buf.append(c); i += 1
    out.append("".join(buf).strip())
    return out


def split_fields_raw(row):
    """与 split_fields 相同，但**保留**引号与转义（供 value_of 判断字段是不是字符串）"""
    out, buf, quote, i, n = [], [], None, 0, len(row)
    while i < n:
        c = row[i]
        if quote:
            buf.append(c)
            if c == "\\" and i + 1 < n:
                buf.append(row[i + 1]); i += 2; continue
            if c == quote: quote = None
            i += 1; continue
        if c in "'\"":
            quote = c; buf.append(c); i += 1; continue
        if c == ",":
            out.append("".join(buf).strip()); buf = []; i += 1; continue
        buf.append(c); i += 1
    out.append("".join(buf).strip())
    return out


def value_of(field):
    """字段文本 → 真实值；数字 / NULL / 函数调用返回 None（无法比对）"""
    f = field.strip()
    if len(f) >= 2 and f[0] == "'":
        v, _ = read_string_literal(f, 0)
        return v
    return None


def parse(path):
    """支持三种写法：
         INSERT INTO t (`entry`, `col`) SELECT <id>, '<文本>' ...        （本项目的 live_text 文件）
         INSERT [IGNORE] INTO t (`entry`, `col`[, ...]) VALUES (<id>, '<文本>'[,...])[, (...)]  （批量汉化文件）
         UPDATE t SET `col` = '<文本>'[, ...] WHERE `entry` = <id>       （mangos_string / quest_greeting 等）
    """
    text = open(path, encoding="utf-8", errors="replace").read()
    items = []
    multi_key = []
    for st in split_statements(text):
        # ---- INSERT ... SELECT ----
        m = HEAD_INSERT_SELECT.search(st)
        if m:
            value, _ = read_string_literal(st, m.end("text") - 1)
            items.append((m.group("table"), m.group("col"), m.group("keyval").strip().strip("'"), value))
            continue
        # ---- INSERT ... VALUES ----
        m = HEAD_INSERT_VALUES.search(st)
        if m:
            cols = [c.strip().strip("`") for c in m.group("cols").split(",")]
            if len(cols) < 2:
                continue
            for row in split_tuples(st[m.end():]):
                fields = split_fields_raw(row)
                if len(fields) != len(cols):
                    continue
                keyval = fields[0].strip().strip("'")
                if not re.match(r"^-?\d+$", keyval):
                    continue
                for idx in range(1, len(cols)):
                    v = value_of(fields[idx])
                    if v is not None:
                        items.append((m.group("table"), cols[idx], keyval, v))
            continue
        # ---- UPDATE ... SET ... WHERE key = N ----
        m = HEAD_UPDATE.search(st)
        if m:
            where = m.group("where")
            km = WHERE_KEY.search(where)
            if not km:
                continue
            keyval = km.group("val")
            if len(re.findall(r"`?[a-z_0-9]+`?\s*=\s*", where, re.I)) > 1:
                multi_key.append((m.group("table"), where.strip()))
                continue
            sets = m.group("sets")
            for sm in SET_ONE.finditer(sets):
                try:
                    value, _ = read_string_literal(sets, sm.end("val") - 1)
                except ValueError:
                    continue
                items.append((m.group("table"), sm.group("col"), keyval, value))
            continue
    if multi_key:
        tables = sorted(set(t for t, _ in multi_key))
        print("   注意：%s 里 %d 条 UPDATE 的 WHERE 有多个条件（复合主键，如 entry+half+word），"
              "本工具按单键比对会失真，已从统计中排除：%s" % ("", len(multi_key), ", ".join(tables)))
    return items


def mysql_run(cmd, sql, fatal=True):
    p = subprocess.Popen("%s --batch --skip-column-names -e %s" % (cmd, "'" + sql.replace("'", "'\\''") + "'"),
                         shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = p.communicate()
    if p.returncode != 0:
        if fatal:
            sys.exit("mysql 执行失败：%s\n%s" % (sql[:200], err.decode("utf-8", "replace")[:400]))
        return None, err.decode("utf-8", "replace").strip().split("\n")[-1][:120]
    return [l.split("\t") for l in out.decode("utf-8", "replace").split("\n") if l.strip()], None


def check_file(path, mysql, limit, quiet=False):
    """返回 (统计 dict, 明细 list, 跳过的表 dict)"""
    items = parse(path)
    if not quiet:
        print("脚本 %s：解析出 %d 条 (表, 列, 主键, 文本)" % (path.split("/")[-1], len(items)))
    by_table = {}
    for t, c, k, v in items:
        by_table.setdefault(t, []).append((c, k, v))

    total = {"一致": 0, "不同(线上非中文→需导入)": 0, "不同(线上已中文→人工看)": 0, "为空": 0,
             "行不存在": 0, "无法校验": 0}
    details = []
    skipped = {}
    for table, rows in by_table.items():
        for col in sorted(set(r[0] for r in rows)):
            # 同一 (列, 主键) 在文件里出现多次时以最后一条为准（与脚本执行顺序一致）
            want_map = {}
            for c, k, v in rows:
                if c == col:
                    want_map[k] = v
            keys = list(want_map)
            for i in range(0, len(keys), 200):
                chunk = keys[i:i + 200]
                inlist = ",".join("'%s'" % k for k in chunk)
                sel = ("SELECT `%s`, IFNULL(MD5(`%s`),'NULL'), IFNULL(CHAR_LENGTH(`%s`),0), "
                       "LEFT(REPLACE(REPLACE(`%s`,'\\n',' '),'\\r',' '),70) FROM `%s` WHERE `%s` IN (%s)"
                       % ("entry", col, col, col, table, "entry", inlist))
                rows_live, err = mysql_run(mysql, sel, fatal=False)
                if rows_live is None:
                    skipped[table] = err
                    total["无法校验"] += len(chunk)
                    break
                live = {}
                for r in rows_live:
                    if len(r) >= 4:
                        live[r[0]] = (r[1], int(r[2]), r[3])
                for k in chunk:
                    v = want_map[k]
                    want = hashlib.md5(v.encode("utf-8")).hexdigest()
                    got = live.get(k)
                    if got is None:
                        total["行不存在"] += 1
                        details.append((table, col, k, "行不存在（locales 表里没有这个 entry）", ""))
                    elif got[0] == "NULL" or got[1] == 0:
                        total["为空"] += 1
                        details.append((table, col, k, "线上为空", ""))
                    elif got[0] == want:
                        total["一致"] += 1
                    else:
                        live_has_cjk = bool(re.search(r"[\u4e00-\u9fff]", got[2] or ""))
                        key = "不同(线上已中文→人工看)" if live_has_cjk else "不同(线上非中文→需导入)"
                        total[key] += 1
                        details.append((table, col, k, key, got[2]))

    if not quiet:
        print("\n=== 比对结果 ===")
        for k in ("一致", "不同(线上非中文→需导入)", "不同(线上已中文→人工看)", "为空", "行不存在", "无法校验"):
            if total[k]:
                print("   %-6s %d" % (k, total[k]))
        for t, err in skipped.items():
            print("   跳过表 %s：%s" % (t, err))
        if details:
            print("\n=== 明细（最多 %d 条）===" % limit)
            for d in details[:limit]:
                print("   %s.%s entry=%s → %s%s" % (d[0], d[1], d[2], d[3], ("；线上开头：%r" % d[4]) if d[4] else ""))
            if len(details) > limit:
                print("   ... 还有 %d 条" % (len(details) - limit))
        elif not skipped:
            print("\n全部一致：脚本里的汉化已经完整落库 ✅")
    return total, details, skipped


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--file", help="单个汉化脚本（与 --dir 二选一）")
    ap.add_argument("--dir", help="目录：核对目录下所有 .sql（推荐，一次看全部）")
    ap.add_argument("--mysql", required=True, help='例如 "mysql -h127.0.0.1 -uroot -p tw_world"')
    ap.add_argument("--limit", type=int, default=15, help="明细最多打印多少条（默认 15）")
    args = ap.parse_args()
    if not args.file and not args.dir:
        ap.error("给 --file 或 --dir")

    if args.file:
        check_file(args.file, args.mysql, args.limit)
        return

    import glob as _glob
    files = sorted(_glob.glob(os.path.join(args.dir, "*.sql")))
    print("核对 %d 个文件（只读；MD5 精确比对）\n" % len(files))
    print("%-32s %7s %8s %8s %6s %6s %6s" % ("文件", "一致", "需导入", "已中文", "为空", "无此键", "跳过"))
    print("-" * 92)
    grand = {"一致": 0, "不同(线上非中文→需导入)": 0, "不同(线上已中文→人工看)": 0, "为空": 0, "行不存在": 0, "无法校验": 0}
    worst = []
    for p in files:
        total, details, skipped = check_file(p, args.mysql, 0, quiet=True)
        for k in grand:
            grand[k] += total[k]
        flag = ""
        if total["不同(线上非中文→需导入)"] or total["为空"] or total["行不存在"]:
            flag = "  ← 有未落库"
            worst.append((os.path.basename(p), details))
        print("%-32s %7d %8d %8d %6d %6d %6d%s" % (os.path.basename(p), total["一致"],
                                                   total["不同(线上非中文→需导入)"], total["不同(线上已中文→人工看)"],
                                                   total["为空"], total["行不存在"], total["无法校验"], flag))
    print("-" * 92)
    print("%-32s %7d %8d %8d %6d %6d %6d" % ("合计", grand["一致"], grand["不同(线上非中文→需导入)"],
                                              grand["不同(线上已中文→人工看)"], grand["为空"],
                                              grand["行不存在"], grand["无法校验"]))
    for name, details in worst[:5]:
        print("\n=== %s 的前几条未落库 ===" % name)
        for d in details[:5]:
            print("   %s.%s entry=%s → %s%s" % (d[0], d[1], d[2], d[3], ("；线上：%r" % d[4]) if d[4] else ""))


if __name__ == "__main__":
    main()
