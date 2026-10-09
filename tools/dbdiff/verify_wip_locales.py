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
    """按分号切分，正确处理字符串与注释。

    三个坑（都是本项目文件的实际形态）：
      * 只把 `'` 当字符串定界符 —— MySQL 默认模式下双引号不是定界符，而数据里有 ASCII 双引号
        （物品描述里的 "制造一块法术石…"），把 `"` 也当定界符会让状态错位；
      * 行内尾随注释 `...;  -- you're healed ...` —— 注释里的撇号同样是陷阱，
        必须把 `--`（以及 `#`、`/* */`）当注释吃掉，而不是只过滤「整行以 -- 开头」的行；
      * `\'` 与 SQL 标准的 `''` 两种转义都要认。
    """
    out, buf, i, n, in_str = [], [], 0, len(text), False
    while i < n:
        c = text[i]
        if in_str:
            buf.append(c)
            if c == "\\" and i + 1 < n:
                buf.append(text[i + 1]); i += 2; continue
            if c == "'":
                if i + 1 < n and text[i + 1] == "'":
                    buf.append("'"); i += 2; continue
                in_str = False
            i += 1; continue
        if c == "'":
            in_str = True; buf.append(c); i += 1; continue
        if c == "-" and text[i:i + 2] == "--" and (i + 2 >= n or text[i + 2] in " \t\r\n"):
            j = text.find("\n", i)
            i = n if j < 0 else j + 1
            buf.append("\n")
            continue
        if c == "#":
            j = text.find("\n", i)
            i = n if j < 0 else j + 1
            buf.append("\n")
            continue
        if text[i:i + 2] == "/*":
            j = text.find("*/", i + 2)
            i = n if j < 0 else j + 2
            continue
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
            items.append((m.group("table"), m.group("col"), m.group("keyval").strip().strip("'"), value,
                          m.group("key")))
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
                        items.append((m.group("table"), cols[idx], keyval, v, cols[0]))
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
                items.append((m.group("table"), sm.group("col"), keyval, value, km.group("key")))
            continue
    if multi_key:
        tables = sorted(set(t for t, _ in multi_key))
        print("   注意：%s 里 %d 条 UPDATE 的 WHERE 有多个条件（复合主键，如 entry+half+word），"
              "本工具按单键比对会失真，已从统计中排除：%s"
              % (os.path.basename(path), len(multi_key), ", ".join(tables)))
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


def fetch_full(mysql, table, col, key, keyval):
    """取线上完整文本（换行/制表符转成可见标记，保持单行）"""
    sel = ("SELECT REPLACE(REPLACE(REPLACE(`%s`,'\\r',''),'\\n','⏎'),'\\t','⇥') FROM `%s` WHERE `%s` = '%s' LIMIT 1"
           % (col, table, key, keyval))
    rows, err = mysql_run(mysql, sel, fatal=False)
    if rows is None or not rows:
        return None
    return rows[0][0] if rows[0] else ""


def first_diff(a, b):
    """返回 (位置, 脚本侧字符, 线上侧字符, Unicode 码位)"""
    n = min(len(a), len(b))
    for i in range(n):
        if a[i] != b[i]:
            return (i, a[i], b[i], "U+%04X / U+%04X" % (ord(a[i]), ord(b[i])))
    if len(a) == len(b):
        return None
    return (n, a[n:n + 1] or "（结束）", b[n:n + 1] or "（结束）", "长度不同")


def show_diff(mysql, table, col, key, keyval, want, live_snippet, limit=2, shown=None):
    full = fetch_full(mysql, table, col, key, keyval)
    print("   %s.%s entry=%s" % (table, col, keyval))
    print("      脚本：%r（%d 字）" % (want[:60], len(want)))
    print("      线上：%r（%d 字）" % ((full or "")[:60], len(full or "")))
    d = first_diff(want, full or "")
    if d:
        print("      首个差异：第 %d 个字符，脚本 %r / 线上 %r（%s）" % (d[0] + 1, d[1], d[2], d[3]))
    else:
        print("      （内容相同，差异在长度之外或不可见字符）")
    shown.add(keyval)


# 各 locales 表 + 列 → 「英文原名」来源 (源表, 源列)。判译文好坏时最关键的一列。
# 键是 locales 表名，值是 {locales 列名: (源表, 源列)}；列名以 _loc4 结尾时按去掉后缀的名字匹配。
EN_SOURCE = {
    "locales_creature":            {"name": ("creature_template", "name"),
                                    "subname": ("creature_template", "subname")},
    "locales_gameobject":          {"name": ("gameobject_template", "name")},
    "locales_item":                {"name": ("item_template", "name"),
                                    "description": ("item_template", "description")},
    "locales_spell":               {"name": ("spell_template", "name"),
                                    "nameSubtext": ("spell_template", "nameSubtext"),
                                    "description": ("spell_template", "description"),
                                    "auraDescription": ("spell_template", "auraDescription")},
    "locales_quest":               {"Title": ("quest_template", "Title"),
                                    "Details": ("quest_template", "Details"),
                                    "Objectives": ("quest_template", "Objectives"),
                                    "OfferRewardText": ("quest_template", "OfferRewardText"),
                                    "RequestItemsText": ("quest_template", "RequestItemsText"),
                                    "EndText": ("quest_template", "EndText"),
                                    "CompletedText": ("quest_template", "CompletedText"),
                                    "ObjectiveText1": ("quest_template", "ObjectiveText1"),
                                    "ObjectiveText2": ("quest_template", "ObjectiveText2"),
                                    "ObjectiveText3": ("quest_template", "ObjectiveText3"),
                                    "ObjectiveText4": ("quest_template", "ObjectiveText4")},
    "locales_broadcast_text":      {"male_text": ("broadcast_text", "male_text"),
                                    "female_text": ("broadcast_text", "female_text")},
    "locales_page_text":           {"text": ("page_text", "text")},
    "locales_npc_text":            {"text0_0": ("npc_text", "text0_0")},
    "locales_gossip_menu_option":  {"option_text": ("gossip_menu_option", "option_text")},
    "locales_points_of_interest":  {"name": (None, None)},      # POI 的名字来自客户端 DBC，库内没有
    "locales_area":                {"name": ("area_template", "name")},
    "locales_faction":             {"name": ("faction", "name")},
    "locales_taxi_node":           {"name": ("taxi_nodes", "name")},
}

# repo_value 里出现这些标记，说明它是从网页/DB 页面整块抓下来的，
# 混进了「完成 / 奖励 / 完成任务后可获得」等界面残留 —— 与目标字段无关，无法用于比对。
CONTAMINATION_MARKS = ("完成任务后可获得", "你将获得：", "奖励 完成")


def source_of(table, column):
    """locales 表 + 列 → (源表, 源列)；查不到返回 (None, None)"""
    per = EN_SOURCE.get(table) or {}
    col = re.sub(r"_loc[0-9]+$", "", column)
    if col in per:
        return per[col]
    for k, v in per.items():
        if k.lower() == col.lower():
            return v
    return (None, None)


def looks_contaminated(value):
    return any(mark in value for mark in CONTAMINATION_MARKS)


def fetch_en_names(mysql, table, column, keys):
    """取英文原名（用于判断译文质量）；没有映射的表返回空 dict。"""
    src_table, src_col = source_of(table, column)
    if not src_table or not keys:
        return {}
    out = {}
    for i in range(0, len(keys), 200):
        chunk = keys[i:i + 200]
        sel = ("SELECT `entry`, IFNULL(LEFT(`%s`, 120), '') FROM `%s` WHERE `entry` IN (%s)"
               % (src_col, src_table, ",".join("'%s'" % k for k in chunk)))
        rows, err = mysql_run(mysql, sel, fatal=False)
        if rows is None:
            return out
        for r in rows:
            if len(r) >= 2:
                out[r[0]] = r[1].replace("\t", " ").replace("\n", " ")
    return out


def fetch_full_values(mysql, table, keycol, col, keys):
    """批量取**完整**值（不截断）—— 审阅导出必须用全文，否则生成的补丁会把长文本截断。"""
    out = {}
    for i in range(0, len(keys), 100):
        chunk = keys[i:i + 100]
        sel = ("SELECT `%s`, IFNULL(`%s`, '') FROM `%s` WHERE `%s` IN (%s)"
               % (keycol, col, table, keycol, ",".join("'%s'" % k for k in chunk)))
        rows, err = mysql_run(mysql, sel, fatal=False)
        if rows is None:
            return out
        for r in rows:
            if len(r) >= 2:
                out[r[0]] = r[1]
    return out


def check_file(path, mysql, limit, quiet=False, show_diffs=0, entry_filter=None, only_missing=False,
               review=False, review_rows=None):
    """返回 (统计 dict, 明细 list, 跳过的表 dict)"""
    items = parse(path)
    if not quiet:
        print("脚本 %s：解析出 %d 条 (表, 列, 主键, 文本)" % (path.split("/")[-1], len(items)))
    by_table = {}
    for t, c, k, v, kc in items:
        by_table.setdefault((t, kc), []).append((c, k, v))

    total = {"一致": 0, "不同(线上非中文→需导入)": 0, "不同(线上已中文→人工看)": 0, "为空": 0,
             "行不存在": 0, "无法校验": 0}
    shown = set()
    diff_budget = [show_diffs]
    details = []
    skipped = {}
    for (table, keycol), rows in by_table.items():
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
                       % (keycol, col, col, col, table, keycol, inlist))
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
                    if entry_filter and k not in entry_filter:
                        continue
                    v = want_map[k]
                    want = hashlib.md5(v.encode("utf-8")).hexdigest()
                    got = live.get(k)
                    if got is None:
                        total["行不存在"] += 1
                        details.append((table, col, k, "行不存在（locales 表里没有这个 entry）", ""))
                    elif got[0] == "NULL" or got[1] == 0:
                        if not v.strip():
                            total["一致"] += 1          # 脚本要的就是空（占位空值），线上也空 → 无需处理
                            continue
                        total["为空"] += 1
                        details.append((table, col, k, "线上为空", ""))
                        if diff_budget[0] > 0 and k not in shown:
                            print("   %s.%s %s=%s → 线上为空；脚本 %r（%d 字）" % (table, col, keycol, k, v[:50], len(v)))
                            shown.add(k); diff_budget[0] -= 1
                    elif got[0] == want:
                        total["一致"] += 1
                    else:
                        # 中文判定放宽到「汉字或 CJK 标点/全角字符」：像 `$N？`、`$N。` 这种
                        # 只有全角标点的值，也是正常中文文本，不该被判成「非中文（需导入）」。
                        live_has_cjk = bool(re.search(r"[\u2e80-\u9fff\u3000-\u303f\uff00-\uffef]", got[2] or ""))
                        key = "不同(线上已中文→人工看)" if live_has_cjk else "不同(线上非中文→需导入)"
                        total[key] += 1
                        details.append((table, col, k, key, got[2]))
                        if review and review_rows is not None and key.startswith("不同(线上已中文"):
                            review_rows.append((os.path.basename(path), table, col, k, v, got[2],
                                                "repo含页面残留(不可比对)" if looks_contaminated(v) else ""))
                        if diff_budget[0] > 0 and k not in shown:
                            show_diff(mysql, table, col, keycol, k, v, got[2], shown=shown)
                            diff_budget[0] -= 1

    if not quiet:
        print("\n=== 比对结果 ===")
        for k in ("一致", "不同(线上非中文→需导入)", "不同(线上已中文→人工看)", "为空", "行不存在", "无法校验"):
            if total[k]:
                print("   %-6s %d" % (k, total[k]))
        for t, err in skipped.items():
            print("   跳过表 %s：%s" % (t, err))
        if details and only_missing:
            todo = [d for d in details if d[3] != "不同(线上已中文→人工看)"]
            print("\n=== 需要处理的 %d 条 ===" % len(todo))
            for d in todo:
                tail = "；线上开头：%r" % d[4] if d[4] else ""
                print("   %s.%s #%s → %s%s" % (d[0], d[1], d[2], d[3], tail))
            return total, details, skipped
        if details:
            print("\n=== 明细（最多 %d 条）===" % limit)
            for d in details[:limit]:
                tail = "；线上开头：%r" % d[4] if d[4] else ""
                print("   %s.%s #%s → %s%s" % (d[0], d[1], d[2], d[3], tail))
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
    ap.add_argument("--show-diff", type=int, default=0, help="对前 N 条差异拉线上全文并给出首个差异位置")
    ap.add_argument("--entry", help="只看某个 entry（多个用逗号分隔）")
    ap.add_argument("--only-missing", action="store_true", help="只列出真正要处理的行（为空/行不存在/线上非中文）")
    ap.add_argument("--review-out", help="把「线上已中文但与本文件不同」的行导出成 TSV（含英文原名与空的 decision 列）")
    args = ap.parse_args()
    if not args.file and not args.dir:
        ap.error("给 --file 或 --dir")

    entry_filter = set(x.strip() for x in args.entry.split(",")) if args.entry else None
    if args.file:
        check_file(args.file, args.mysql, args.limit, show_diffs=args.show_diff,
                   entry_filter=entry_filter, only_missing=args.only_missing)
        return

    import glob as _glob
    files = sorted(_glob.glob(os.path.join(args.dir, "*.sql")))
    print("核对 %d 个文件（只读；MD5 精确比对）\n" % len(files))
    print("%-32s %7s %8s %8s %6s %6s %6s" % ("文件", "一致", "需导入", "已中文", "为空", "无此键", "跳过"))
    print("-" * 92)
    grand = {"一致": 0, "不同(线上非中文→需导入)": 0, "不同(线上已中文→人工看)": 0, "为空": 0, "行不存在": 0, "无法校验": 0}
    worst = []
    review_rows = [] if args.review_out else None
    for p in files:
        total, details, skipped = check_file(p, args.mysql, 0, quiet=True, show_diffs=args.show_diff,
                                             entry_filter=entry_filter, review=bool(args.review_out),
                                             review_rows=review_rows)
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
    if args.review_out and review_rows:
        # 补上「英文原名」一列：按 (表, 列) 映射到源表取同名/对应列（locales_quest → quest_template 等）
        en_cache = {}
        by_tbl_col = {}
        for f_, t_, c_, k_, repo_v_, live_v_, note_ in review_rows:
            by_tbl_col.setdefault((t_, c_), set()).add(k_)
        for (t_, c_), keys in by_tbl_col.items():
            en_cache[(t_, c_)] = fetch_en_names(args.mysql, t_, c_, sorted(keys))
        # 用全文替换掉被 LEFT(...,70) 截断的 live 值（否则生成的补丁会写进截断文本）
        fixed = []
        by_tc = {}
        for f_, t_, c_, k_, repo_v_, live_v_, note_ in review_rows:
            by_tc.setdefault((t_, c_), []).append(k_)
        full_cache = {}
        for (t_, c_), keys in by_tc.items():
            full_cache[(t_, c_)] = fetch_full_values(args.mysql, t_, "entry", c_, sorted(set(keys)))
        for f_, t_, c_, k_, repo_v_, live_v_, note_ in review_rows:
            full = full_cache.get((t_, c_), {}).get(k_)
            fixed.append((f_, t_, c_, k_, repo_v_, full if full is not None else live_v_, note_))
        review_rows = fixed
        n_cont = 0
        with open(args.review_out, "w", encoding="utf-8") as fh:
            fh.write("file\ttable\tcolumn\tentry\tenglish\trepo_value\tlive_value\tdecision\tnote\n")
            for f_, t_, c_, k_, repo_v_, live_v_, note_ in review_rows:
                decision = ""
                if note_:
                    n_cont += 1
                    decision = "live"      # 仓库侧是页面残留，不存在「用仓库版」的可能 → 预填 live
                fh.write("\t".join([f_, t_, c_, k_,
                                     en_cache.get((t_, c_), {}).get(k_, ""),
                                     repo_v_.replace("\t", " ").replace("\n", " "),
                                     live_v_.replace("\t", " ").replace("\n", " "),
                                     decision, note_]) + "\n")
        miss = sum(1 for r in review_rows if not en_cache.get((r[1], r[2]), {}).get(r[3]))
        print("\n已导出审阅表：%s（%d 行；其中 %d 行 repo 是页面残留、已预填 live）" % (args.review_out, len(review_rows), n_cont))
        if miss:
            print("   提示：仍有 %d 行取不到英文原文（该列没有映射，如 POI 名来自客户端 DBC）—— 这些只能靠语义判断" % miss)
        print("填好 decision 列（repo / live / skip）后交给 gen_locale_patch.py 生成定向补丁")

    for name, details in worst[:5]:
        print("\n=== %s 的前几条未落库 ===" % name)
        for d in details[:5]:
            print("   %s.%s entry=%s → %s%s" % (d[0], d[1], d[2], d[3], ("；线上：%r" % d[4]) if d[4] else ""))


if __name__ == "__main__":
    main()
