#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
dbdiff ——「仓库里的 base dump + 增量」对比「线上 world 库」

用来回答：线上库里哪些表比仓库（sql/base/tw_world_*.sql 叠加 sql/database_updates/world/*.sql）
少了内容（例如上次启动日志里 reference_loot_template 三个引用组整组缺失那样的问题）。

数据源二选一：
  * --mysql "<mysql 命令>"   直接连线上库（在服务器上跑最方便，只需要 mysql 客户端，不需要 Python 驱动）
  * --from-dump <文件>       离线：先在服务器上 mysqldump 一份 world 库带回来对比

两种模式：
  * --counts                 逐表比行数，列出「线上少于仓库」的表（快，先跑这个）
  * --table T [--emit-sql F] 对某张表按主键逐行比，列出线上缺失的键，并可生成补数据的 INSERT IGNORE

没有第三方依赖，Python 3.6+ 即可。
"""
import argparse
import collections
import glob
import os
import re
import subprocess
import sys

# ---------------------------------------------------------------- SQL 解析

HEAD = re.compile(r"\b(?:INSERT|REPLACE)(?:\s+IGNORE)?\s+INTO\s+`([^`]+)`\s*(?:\(([^)]*)\))?\s*VALUES", re.I)
CREATET = re.compile(r"CREATE TABLE `([^`]+)` \((.*?)\n\) ENGINE", re.S)


def split_statements(text):
    """按分号切分，正确处理字符串与注释（与 verify_wip_locales.py 同一套规则）。

    三个坑：① 只认 `'` 为字符串定界符（MySQL 默认模式下双引号不是定界符，数据里有 ASCII 双引号）；
    ② `--` / `#` / `/* */` 注释要整段吃掉 —— 行内尾随注释（`...;  -- you're healed ...`）里的撇号
       会让引号状态错位、把语句粘成一条；③ `\'` 与 `''` 两种转义都要认。
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
            j = text.find("\n", i); i = n if j < 0 else j + 1; buf.append("\n"); continue
        if c == "#":
            j = text.find("\n", i); i = n if j < 0 else j + 1; buf.append("\n"); continue
        if text[i:i + 2] == "/*":
            j = text.find("*/", i + 2); i = n if j < 0 else j + 2; continue
        if c == ";":
            out.append("".join(buf)); buf = []; i += 1; continue
        buf.append(c); i += 1
    if buf: out.append("".join(buf))
    return out


def split_tuples(body):
    """把 VALUES 后的 (a,b),(c,d) 切成 [ 'a,b', 'c,d' ]（尊重引号、反斜杠转义与括号）。

    注意：进入字符串后遇到 `\\` 必须把「反斜杠 + 下一个字符」一起吃掉，否则 `\'`
    会被当成「字符串结束」，后面整段行文本都会粘进同一个字段（历史上就是这么错的）。
    """
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
    """把一行 (a,b,c) 的正文切成字段；字符串里的逗号不切。
    `\\x` 是转义（保留原样，交给 sql_literal/unset 处理），`\'` 不会提前结束字符串。"""
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


_UNESCAPE = {"0": "\0", "b": "\b", "n": "\n", "r": "\r", "t": "\t", "Z": "\x1a",
             "\\": "\\", "'": "'", '"': '"', "%": "%", "_": "_"}


def unescape(text):
    """把 mysqldump 写出来的转义还原成真实值：\' → '、\\ → \、\n → 换行 ……"""
    if "\\" not in text:
        return text
    out, i, n = [], 0, len(text)
    while i < n:
        c = text[i]
        if c == "\\" and i + 1 < n:
            nxt = text[i + 1]
            out.append(_UNESCAPE.get(nxt, nxt))
            i += 2
            continue
        out.append(c)
        i += 1
    return "".join(out)


def norm(v):
    v = (v or "").strip()
    if len(v) >= 2 and v[0] == "'" and v[-1] == "'":
        v = v[1:-1]
    return v


def unset(s):
    """字段文本 → 真实值（NULL 归一化 + 反转义）"""
    s = s.strip()
    if s.upper() == "NULL":
        return "NULL"
    if len(s) >= 2 and s[0] == s[-1] and s[0] in "\"'":
        s = s[1:-1]
    return unescape(s)


def iter_inserts(text, table):
    """yield (列名列表或 None, VALUES 正文)"""
    for st in split_statements(text):
        m = HEAD.search(st)
        if not m or m.group(1) != table: continue
        cols = [c.strip().strip('`') for c in m.group(2).split(",")] if m.group(2) else None
        yield cols, st[m.end():]


# ---------------------------------------------------------------- 仓库侧：期望状态

class Repo(object):
    def __init__(self, sql_root):
        self.root = sql_root
        self.ddl = {}
        self.keys = {}
        self._files = None
        self._stmts_cache = {}
        self.unhandled = collections.Counter()
        self.unreliable = collections.Counter()
        self._vars = {}
        self._load_ddl()

    def _stmts(self, path):
        """把一个 .sql 文件拆成语句，并按表名分组缓存（每个文件只解析一次）。"""
        if path in self._stmts_cache: return self._stmts_cache[path]
        text = open(path, encoding="utf-8", errors="replace").read()
        grouped = collections.defaultdict(list)
        for st in split_statements(text):
            m = HEAD.search(st)
            if m:
                grouped[m.group(1)].append(st)
                continue
            m = re.match(r"\s*(DELETE\s+FROM|UPDATE)\s+`([^`]+)`", st, re.I)
            if m: grouped[m.group(2)].append(st)
        self._stmts_cache[path] = grouped
        return grouped

    def _load_ddl(self):
        path = os.path.join(self.root, "create_databases.sql")
        if not os.path.exists(path):
            sys.exit("找不到 %s" % path)
        text = open(path, encoding="utf-8", errors="replace").read()
        for name, body in CREATET.findall(text):
            cols = re.findall(r"^\s*`([^`]+)`", body, re.M)
            self.ddl[name] = cols
            pk = re.search(r"PRIMARY KEY \(([^)]*)\)", body)
            if not pk:
                pk = re.search(r"UNIQUE KEY `[^`]+` \(([^)]*)\)", body)
            self.keys[name] = [c.strip().strip('`') for c in pk.group(1).split(",")] if pk else None

    def files(self, table):
        out = []
        base = os.path.join(self.root, "base", "tw_world_%s.sql" % table)
        if os.path.exists(base): out.append(base)
        out += sorted(glob.glob(os.path.join(self.root, "database_updates", "world", "*.sql")))
        return out

    def tables(self):
        return sorted(os.path.basename(p)[len("tw_world_"):-len(".sql")]
                      for p in glob.glob(os.path.join(self.root, "base", "tw_world_*.sql")))

    def tree_fingerprint(self):
        parts = []
        try:
            with open(__file__, "rb") as fh:
                parts.append("tool:%d" % len(fh.read()))
        except Exception:
            pass
        for t in self.tables():
            for f in self.files(t):
                if os.path.exists(f):
                    st = os.stat(f)
                    parts.append("%s:%d:%d" % (f, st.st_size, int(st.st_mtime)))
        return "%d-%d" % (len(parts), hash(tuple(parts)))

    def cached_counts(self, cache_path):
        try:
            import json
            if not os.path.exists(cache_path): return None
            d = json.load(open(cache_path))
            if d.get("fingerprint") != self.tree_fingerprint(): return None
            return d.get("counts")
        except Exception:
            return None

    def save_counts(self, cache_path, counts):
        try:
            import json
            json.dump({"fingerprint": self.tree_fingerprint(), "counts": counts}, open(cache_path, "w"))
        except Exception:
            pass

    def expected(self, table):
        """把 base + 所有增量叠加成最终状态：{主键元组: 行字典}；没有主键时返回行列表。"""
        cols = self.ddl.get(table)
        if not cols: return None
        key = self.keys.get(table)
        rows = {}
        plain = []
        var = self._vars          # 会话变量（SET @x := ... 会被求值）
        for path in self.files(table):
            if not os.path.exists(path): continue
            for st in self._stmts(path).get(table, []):
                s = st.strip()
                if not s: continue
                ms = re.match(r"SET\s+@(\w+)\s*:?=\s*(.*)$", s, re.I | re.S)
                if ms:
                    expr = ms.group(2).strip()
                    while expr.startswith("(") and expr.endswith(")"):
                        expr = expr[1:-1].strip()
                    try:
                        self._vars[ms.group(1)] = self._eval_scalar(expr)
                    except Exception:
                        self._vars[ms.group(1)] = None
                    continue
                m = HEAD.search(s)
                if m and m.group(1) == table:
                    use = [c.strip().strip('`') for c in m.group(2).split(",")] if m.group(2) else cols
                    for row in split_tuples(s[m.end():]):
                        f = split_fields(row)
                        if len(f) != len(use): continue
                        d = dict(zip(use, [unset(x) for x in f]))
                        if key:
                            k = tuple(norm(d.get(c)) for c in key)
                            rows[k] = d
                        else:
                            plain.append(d)
                    continue
                m = re.match(r"DELETE\s+FROM\s+`%s`\s*(?:WHERE\s+(.*))?$" % table, s, re.I | re.S)
                if m:
                    cond = (m.group(1) or "").strip()
                    if not cond:
                        rows.clear(); plain = []; continue
                    pred = self.compile_cond(cond, var)
                    if pred is None:
                        self.unreliable[table] += 1
                        continue
                    for k in [k for k, d in rows.items() if pred(d)]: del rows[k]
                    plain = [d for d in plain if not pred(d)]
                    continue
                m = re.match(r"UPDATE\s+`%s`\s+SET\s+(.*?)\s+WHERE\s+(.*)$" % table, s, re.I | re.S)
                if m:
                    sets, cond = m.group(1), m.group(2)
                    assigns = self._assignments(sets)
                    pred = self.compile_cond(cond, var)
                    if pred is None:
                        self.unreliable[table] += 1
                        continue
                    for d in rows.values():
                        if pred(d):
                            for a in assigns: d[a[0]] = a[1]
                    for d in plain:
                        if pred(d):
                            for a in assigns: d[a[0]] = a[1]
                    continue
                if re.match(r"\s*(INSERT|REPLACE|UPDATE|DELETE)\b", s, re.I):
                    self.unhandled[table] += 1
        return rows if key else plain


    # ---------------------------------------------------------------- 条件求值
    # 返回 True / False / None（None = 本工具判不了这个条件，调用方保守处理并标记该表不可靠）
    _P_BETWEEN_VAR = re.compile(r"^@(?P<v>\w+)\s+BETWEEN\s+(?P<a>.+?)\s+AND\s+(?P<b>.+)$", re.I | re.S)
    _P_CMP_VAR     = re.compile(r"^@(?P<v>\w+)\s*(?P<op><>|!=|>=|<=|=|>|<)\s*(?P<val>.+)$", re.I | re.S)
    _P_BETWEEN     = re.compile(r"^`?(?P<col>[A-Za-z0-9_.]+)`?\s+BETWEEN\s+(?P<a>.+?)\s+AND\s+(?P<b>.+)$", re.I | re.S)
    _P_CMP         = re.compile(r"^`?(?P<col>[A-Za-z0-9_.]+)`?\s*(?P<op><>|!=|>=|<=|=|>|<)\s*(?P<val>.+)$", re.I | re.S)
    _P_IN          = re.compile(r"^`?(?P<col>[A-Za-z0-9_.]+)`?\s+(?P<inop>NOT\s+IN|IN)\s*\(\s*(?P<list>[^)]*)\)$", re.I | re.S)
    _P_NULL        = re.compile(r"^`?(?P<col>[A-Za-z0-9_.]+)`?\s+IS\s+(?P<null>NOT\s+NULL|NULL)$", re.I | re.S)

    @staticmethod
    def _split_and(cond):
        """按顶层 AND 切开（跳过括号内的、以及 BETWEEN ... AND ... 里的那个 AND）。"""
        parts, buf, depth, i = [], [], 0, 0
        while i < len(cond):
            c = cond[i]
            if c == "(":
                depth += 1
            elif c == ")":
                depth -= 1
            if depth == 0 and cond[i:i + 5].upper() == " AND ":
                if re.search(r"\bBETWEEN\s+[^()]*$", "".join(buf), re.I):
                    buf.append(cond[i:i + 5]); i += 5; continue
                parts.append("".join(buf)); buf = []; i += 5; continue
            buf.append(c); i += 1
        parts.append("".join(buf))
        return [x.strip() for x in parts if x.strip()]

    @staticmethod
    def _num(x):
        try:
            return float(str(x).strip())
        except Exception:
            return None

    def _value(self, d, txt, var):
        """字面量 / @变量 / 列名；判不了返回 None。"""
        txt = (txt or "").strip()
        if txt.startswith("("):
            return None
        if txt.startswith("@"):
            v = var.get(txt[1:])
            return None if v is None else str(v)
        if len(txt) >= 2 and txt[0] == txt[-1] and txt[0] in "\"'":
            return txt[1:-1]
        if re.match(r"^-?[\d.]+$", txt):
            return txt
        return None

    @staticmethod
    def _cmp(op, left, right):
        a, b = Repo._num(left), Repo._num(right)
        if op == "=":
            return (a == b) if (a is not None and b is not None) else (str(left) == str(right))
        if op in ("<>", "!="):
            return not Repo._cmp("=", left, right)
        if a is None or b is None:
            return None
        return {">": a > b, "<": a < b, ">=": a >= b, "<=": a <= b}[op]

    def _atom(self, d, atom, var):
        atom = atom.strip()
        m = self._P_BETWEEN_VAR.match(atom) or self._P_CMP_VAR.match(atom)
        if m:
            left = var.get(m.group("v"))
            if left is None:
                return None
            gd = m.groupdict()
            if "a" in gd and gd.get("a") is not None:
                a, b = self._value(d, gd["a"], var), self._value(d, gd["b"], var)
                if a is None or b is None:
                    return None
                return self._num(a) <= self._num(left) <= self._num(b)
            v = self._value(d, gd["val"], var)
            return None if v is None else self._cmp(gd["op"], left, v)

        m = self._P_BETWEEN.match(atom)
        if m:
            cur = d.get(m.group("col"))
            a, b = self._value(d, m.group("a"), var), self._value(d, m.group("b"), var)
            if cur is None or a is None or b is None:
                return None
            na, nb, nc = self._num(a), self._num(b), self._num(cur)
            if None in (na, nb, nc):
                return None
            return na <= nc <= nb

        m = self._P_IN.match(atom)
        if m:
            cur = d.get(m.group("col"))
            if cur is None:
                return None
            vals = [self._value(d, x, var) for x in m.group("list").split(",")]
            if any(v is None for v in vals):
                return None
            cur = self._num(cur)
            hit = any(self._cmp("=", cur, v) for v in vals)
            return (not hit) if m.group("inop").upper().startswith("NOT") else hit

        m = self._P_NULL.match(atom)
        if m:
            cur = d.get(m.group("col"))
            if cur is None:
                return None
            is_null = str(cur).strip().strip("'").upper() in ("", "NULL")
            return (not is_null) if m.group("null").upper().startswith("NOT") else is_null

        m = self._P_CMP.match(atom)
        if m:
            cur = d.get(m.group("col"))
            v = self._value(d, m.group("val"), var)
            if cur is None or v is None:
                return None
            return self._cmp(m.group("op"), str(cur).strip().strip("'"), v)
        return None

    def compile_cond(self, cond, var=None):
        """把一个 WHERE 条件编译成「逐行求值」的闭包；判不了就返回 None（调用方标记不可靠并跳过）。"""
        var = var or {}
        atoms = self._split_and(cond)
        checks = []
        for atom in atoms:
            check = self._compile_atom(atom, var)
            if check is None:
                return None
            checks.append(check)

        def pred(d):
            for f in checks:
                if not f(d):
                    return False
            return True

        return pred

    def _compile_atom(self, atom, var):
        """_atom 的「解析一次」版本：返回 f(d) -> bool，或 None。"""
        atom = atom.strip()
        m = self._P_BETWEEN_VAR.match(atom) or self._P_CMP_VAR.match(atom)
        if m:
            left = var.get(m.group("v"))
            if left is None:
                return None
            gd = m.groupdict()
            if gd.get("a") is not None:
                a, b = self._value(None, gd["a"], var), self._value(None, gd["b"], var)
                if a is None or b is None:
                    return None
                na, nb, nl = self._num(a), self._num(b), self._num(left)
                if None in (na, nb, nl):
                    return None
                return lambda d: na <= nl <= nb
            v = self._value(None, gd["val"], var)
            if v is None:
                return None
            op = gd["op"]
            return lambda d: self._cmp(op, left, v)

        m = self._P_BETWEEN.match(atom)
        if m:
            col, a, b = m.group("col"), self._value(None, m.group("a"), var), self._value(None, m.group("b"), var)
            if a is None or b is None:
                return None
            na, nb = self._num(a), self._num(b)
            if None in (na, nb):
                return None
            return lambda d: (self._num(d.get(col)) is not None and na <= self._num(d.get(col)) <= nb)

        m = self._P_IN.match(atom)
        if m:
            col = m.group("col")
            vals = [self._value(None, x, var) for x in m.group("list").split(",")]
            if any(v is None for v in vals):
                return None
            nums = {self._num(v) for v in vals}
            strs = set(map(str, vals))
            neg = m.group("inop").upper().startswith("NOT")
            def incheck(d):
                cur = d.get(col)
                if cur is None:
                    return False
                cur = str(cur).strip().strip("'")
                hit = (cur in strs) or (self._num(cur) in nums if self._num(cur) is not None else False)
                return (not hit) if neg else hit
            return incheck

        m = self._P_NULL.match(atom)
        if m:
            col, neg = m.group("col"), m.group("null").upper().startswith("NOT")
            def nullcheck(d):
                is_null = str(d.get(col) or "").strip().strip("'").upper() in ("", "NULL")
                return (not is_null) if neg else is_null
            return nullcheck

        m = self._P_CMP.match(atom)
        if m:
            col, op = m.group("col"), m.group("op")
            v = self._value(None, m.group("val"), var)
            if v is None:
                return None
            return lambda d: self._cmp(op, str(d.get(col) or "").strip().strip("'"), v)
        return None

    def _eval_scalar(self, expr):
        """给 SET @var 用的极简求值：数字/字符串字面量；其它（SELECT ...）交给调用方当作未知。"""
        expr = expr.strip()
        if re.match(r"^-?[\d.]+$", expr):
            return expr
        if len(expr) >= 2 and expr[0] == expr[-1] and expr[0] in "\"'":
            return expr[1:-1]
        return None

    @staticmethod
    def _assignments(sets):
        out = []
        for a in sets.split(","):
            m = re.match(r"\s*`?([A-Za-z0-9_]+)`?\s*=\s*(.+?)\s*$", a, re.S)
            if m: out.append((m.group(1), unset(m.group(2).strip().strip("'"))))
        return out

    @staticmethod
    def _match(d, cond):
        m = re.match(r"`?([A-Za-z0-9_.]+)`?\s*(=|IN)\s*(.*)$", cond.strip(), re.I | re.S)
        if not m: return False
        col, op, rest = m.group(1), m.group(2).upper(), m.group(3).strip()
        cur = (d.get(col) or "").strip()
        if op == "=":
            return cur == rest.strip().strip("'")
        items = [x.strip().strip("'") for x in rest.strip().strip("()").split(",")]
        return cur in items


# ---------------------------------------------------------------- 线上侧：读数据

def mysql_run(cmd, sql, sep="\t"):
    """跑一条 mysql 命令，返回按 sep 切分的行列表。"""
    full = "%s --batch --skip-column-names -e %s" % (cmd, shell_quote(sql))
    p = subprocess.Popen(full, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = p.communicate()
    if p.returncode != 0:
        sys.exit("mysql 执行失败：%s\n%s" % (sql[:200], err.decode("utf-8", "replace")[:500]))
    rows = []
    for line in out.decode("utf-8", "replace").split("\n"):
        if not line.strip(): continue
        rows.append(line.split(sep))
    return rows


def shell_quote(s):
    return "'" + s.replace("'", "'\\''") + "'"


class DumpSource(object):
    """从 mysqldump 文件里取行（流式，一行一个 INSERT 批次）。"""

    def __init__(self, path, tables=None):
        self.path = path
        self.want = set(tables) if tables else None
        self._data = collections.defaultdict(list)   # table -> [ (cols或None, values正文) ]
        self._load()

    def _load(self):
        cur = None
        buf = []
        with open(self.path, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                if cur is None:
                    m = HEAD.search(line)
                    if m and (self.want is None or m.group(1) in self.want):
                        cur = m.group(1)
                        cols = [c.strip().strip('`') for c in m.group(2).split(",")] if m.group(2) else None
                        buf = [line[m.end():]]
                    continue
                buf.append(line)
                if line.rstrip().endswith(";"):
                    body = "".join(buf)
                    self._data[cur].append((cols, body[:body.rfind(";")]))
                    cur = None
                    buf = []
        # 不完整的最后一条也收进来
        if cur is not None and buf:
            self._data[cur].append((cols, "".join(buf)))

    def count(self, table):
        n = 0
        for c, body in self._data.get(table, []):
            n += len(split_tuples(body))
        return n

    def table(self, table):
        """返回 [(列名或 None, 行字段列表)] 列表"""
        out = []
        for c, body in self._data.get(table, []):
            for row in split_tuples(body):
                out.append((c, [unset(x) for x in split_fields(row)]))
        return out


class MysqlSource(object):
    def __init__(self, cmd):
        self.cmd = cmd

    def count(self, table):
        return int(mysql_run(self.cmd, "SELECT COUNT(*) FROM `%s`" % table)[0][0])

    def keys(self, table, cols):
        expr = ",".join("IFNULL(`%s`,'')" % c for c in cols)
        return [tuple(norm(x) for x in r) for r in mysql_run(self.cmd, "SELECT %s FROM `%s`" % (expr, table))]


# ---------------------------------------------------------------- 对比逻辑

def cmp_counts(repo, source):
    print("%-34s %10s %10s %10s" % ("表", "仓库", "线上", "差"))
    print("-" * 70)
    missing = []
    tables = repo.tables()
    cached = repo.cached_counts(os.path.join(os.getcwd(), ".dbdiff_counts.json")) or {}
    fresh = {}
    for i, t in enumerate(tables, 1):
        if t in cached:
            n_exp = cached[t]
        else:
            sys.stderr.write("\r[%d/%d] 解析仓库里的 %-34s" % (i, len(tables), t))
            sys.stderr.flush()
            exp = repo.expected(t)
            n_exp = len(exp) if exp is not None else 0
            fresh[t] = n_exp
        n_live = source.count(t)
        delta = n_live - n_exp
        flag = ""
        if delta < 0:
            flag = "  ← 线上少 %d" % (-delta)
            missing.append(t)
        elif delta > 0:
            flag = "  （线上多 %d，通常是你们自己的改动）" % delta
        print("%-34s %10d %10d %10d%s" % (t, n_exp, n_live, delta, flag))
    sys.stderr.write("\n")
    if fresh:
        cached.update(fresh)
        repo.save_counts(os.path.join(os.getcwd(), ".dbdiff_counts.json"), cached)
        sys.stderr.write("（期望行数已缓存到 %s，下次 --counts 秒回）\n" % os.path.join(os.getcwd(), ".dbdiff_counts.json"))
    print()
    if repo.unreliable:
        print("提示：这些表里有本工具判不了的 WHERE 条件（位运算/子查询等），相应行没被处理，期望行数不可靠：")
        for t, n in repo.unreliable.most_common(8):
            print("   %-38s %d 条语句" % (t, n))
        print()
    if repo.unhandled:
        print("提示：这些表里有本工具不解析的语句（例如 INSERT ... SELECT），期望行数可能偏低：")
        for t, n in repo.unhandled.most_common(8):
            print("   %-38s %d 条" % (t, n))
        print()
    if missing:
        print("线上比仓库少的表（先查这些）：")
        for t in missing:
            print("   %s" % t)
        print("\n逐个看细节：  python3 %s --table <表名> ..." % os.path.basename(sys.argv[0]))
    else:
        print("所有 base 表的行数都不少于仓库快照。")
    return missing


def cmp_table(repo, source, table, emit_sql=None, limit=50):
    cols = repo.ddl.get(table)
    key = repo.keys.get(table)
    if not cols:
        sys.exit("create_databases.sql 里没有表 %s" % table)
    if not key:
        sys.exit("表 %s 没有主键/唯一键，只能比行数（用 --counts）" % table)
    exp = repo.expected(table) or {}
    if isinstance(source, MysqlSource):
        live = set(source.keys(table, key))
    else:
        want = set()
        for c, f in source.table(table):
            d = dict(zip(c or cols, f))
            want.add(tuple(norm(d.get(k)) for k in key))
        live = want
    missing = [k for k in exp if k not in live]
    extra = [k for k in live if k not in exp]
    print("表 `%s`：仓库 %d 行，线上 %d 行，线上缺 %d 行，线上多 %d 行" % (table, len(exp), len(live), len(missing), len(extra)))
    if missing:
        print("线上缺失的主键（最多列 %d 个）：" % limit)
        for k in missing[:limit]:
            print("   %s" % " / ".join(k))
        if len(missing) > limit: print("   ... 还有 %d 个" % (len(missing) - limit))
    if extra:
        print("线上多出来的主键（最多列 10 个）：")
        for k in extra[:10]:
            print("   %s" % " / ".join(k))
    if emit_sql and missing:
        with open(emit_sql, "w", encoding="utf-8") as fh:
            fh.write("-- dbdiff 生成：把仓库里存在、线上缺失的行补进去（INSERT IGNORE，已存在则跳过）\n")
            fh.write("-- 表 %s，缺失 %d 行\n" % (table, len(missing)))
            order = [c for c in cols]
            fh.write("INSERT IGNORE INTO `%s` (%s) VALUES\n" % (table, ", ".join("`%s`" % c for c in order)))
            vals = []
            for k in missing:
                d = exp[k]
                vals.append("(" + ", ".join(sql_literal(d.get(c)) for c in order) + ")")
            for i in range(0, len(vals), 5):
                fh.write("    " + ",\n    ".join(vals[i:i + 5]) + (";\n" if i + 5 >= len(vals) else ",\n"))
        print("\n已写出补数据脚本：%s（%d 行）" % (emit_sql, len(missing)))
    return missing


def all_tables(repo, source, emit_dir=None, quiet=False):
    """逐表按主键对比（比 --counts 精确：upstream 的 UPDATE/DELETE 也可能让行数看不出缺口）。"""
    rows = []
    for i, t in enumerate(repo.tables(), 1):
        key = repo.keys.get(t)
        if not key:
            continue
        sys.stderr.write("\r[%d/%d] 对比 %-40s" % (i, len(repo.tables()), t))
        sys.stderr.flush()
        exp = repo.expected(t) or {}
        if isinstance(source, MysqlSource):
            live = set(source.keys(t, key))
        else:
            live = set()
            for c, f in source.table(t):
                d = dict(zip(c or repo.ddl.get(t) or [], f))
                live.add(tuple(norm(d.get(k)) for k in key))
        missing = [k for k in exp if k not in live]
        rows.append((t, len(exp), len(live), len(missing), len(live) - len(exp)))
        if missing and emit_dir:
            path = os.path.join(emit_dir, "fix_%s.sql" % t)
            _emit(repo, t, exp, missing, path)
    sys.stderr.write("\n")
    print("%-38s %9s %9s %8s" % ("表", "仓库", "线上", "线上缺"))
    print("-" * 68)
    total = 0
    for t, ne, nl, nm, delta in sorted(rows, key=lambda r: -r[3]):
        if nm == 0 and delta <= 0:
            continue
        total += nm
        print("%-38s %9d %9d %8d%s" % (t, ne, nl, nm, "   ← 要补" if nm else ""))
    print("-" * 68)
    print("合计缺失行：%d" % total)
    if emit_dir and total:
        print("补数据脚本写在 %s/fix_*.sql（INSERT IGNORE，只补不覆盖）" % emit_dir)
    elif total:
        print("要生成补数据脚本，加 --emit-dir <目录>")
    return rows


def _emit(repo, table, exp, missing, path):
    cols = repo.ddl[table]
    with open(path, "w", encoding="utf-8") as fh:
        fh.write("-- dbdiff 生成：表 %s 缺失 %d 行（INSERT IGNORE，已存在则跳过）\n" % (table, len(missing)))
        fh.write("INSERT IGNORE INTO `%s` (%s) VALUES\n" % (table, ", ".join("`%s`" % c for c in cols)))
        vals = ["(" + ", ".join(sql_literal(exp[k].get(c)) for c in cols) + ")" for k in missing]
        for i in range(0, len(vals), 5):
            fh.write("    " + ",\n    ".join(vals[i:i + 5]) + (";\n" if i + 5 >= len(vals) else ",\n"))


def sql_literal(v):
    if v is None: return "NULL"
    v = str(v)
    if v.upper() == "NULL": return "NULL"
    return "'" + v.replace("\\", "\\\\").replace("'", "\\'") + "'"


def main():
    ap = argparse.ArgumentParser(description="仓库 base dump 与线上 world 库的差异对比")
    ap.add_argument("--sql-root", default="sql", help="仓库 sql 目录（默认 ./sql）")
    ap.add_argument("--mysql", help='线上库的 mysql 命令，例如 "mysql -h127.0.0.1 -uroot -pxxx tw_world"')
    ap.add_argument("--from-dump", help="离线：mysqldump 出来的 .sql 文件")
    ap.add_argument("--counts", action="store_true", help="逐表比行数")
    ap.add_argument("--table", help="按主键细比某个表")
    ap.add_argument("--emit-sql", help="把 --table 缺失的行写成 INSERT IGNORE 脚本")
    ap.add_argument("--all-tables", action="store_true", help="逐表按主键全量对比（最彻底，也最慢）")
    ap.add_argument("--emit-dir", help="配合 --all-tables：把每张表缺失的行写成 fix_<表>.sql")
    ap.add_argument("--limit", type=int, default=50, help="打印多个缺失键（默认 50）")
    args = ap.parse_args()

    if not args.mysql and not args.from_dump:
        ap.error("要么给 --mysql，要么给 --from-dump")
    repo = Repo(args.sql_root)
    if args.mysql:
        source = MysqlSource(args.mysql)
    else:
        tables = [args.table] if args.table else repo.tables()
        source = DumpSource(args.from_dump, None if not args.table else tables)

    if args.emit_dir and not os.path.isdir(args.emit_dir):
        os.makedirs(args.emit_dir)
    if args.all_tables:
        all_tables(repo, source, args.emit_dir)
    elif args.counts or not args.table:
        cmp_counts(repo, source)
    if args.table:
        cmp_table(repo, source, args.table, args.emit_sql, args.limit)


if __name__ == "__main__":
    main()
