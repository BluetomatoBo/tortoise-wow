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
    """按分号切分，跳过字符串里的分号（与内核 AutoUpdater 的逻辑一致，但会先剥掉整行注释）。"""
    text = "\n".join(l for l in text.split("\n") if not l.lstrip().startswith("--"))
    out, buf, quote, i, n = [], [], None, 0, len(text)
    while i < n:
        c = text[i]
        if quote:
            buf.append(c)
            if c == "\\":
                buf.append(text[i + 1:i + 2]); i += 2; continue
            if c == quote: quote = None
            i += 1; continue
        if c in "'\"":
            quote = c; buf.append(c); i += 1; continue
        if c == ";":
            out.append("".join(buf)); buf = []; i += 1; continue
        buf.append(c); i += 1
    if buf: out.append("".join(buf))
    return out


def split_tuples(body):
    """把 VALUES 后的 (a,b),(c,d) 切成 [ 'a,b', 'c,d' ]（尊重引号与括号）。"""
    out, buf, depth, quote = [], [], 0, None
    for c in body:
        if quote:
            buf.append(c)
            if c == "\\": buf.append(c)
            elif c == quote: quote = None
            continue
        if c in "'\"":
            quote = c; buf.append(c); continue
        if c == "(":
            depth += 1
            if depth == 1: buf = []; continue
        elif c == ")":
            depth -= 1
            if depth == 0: out.append("".join(buf)); buf = []; continue
        if depth: buf.append(c)
    return out


def split_fields(row):
    out, buf, quote = [], [], None
    i = 0
    while i < len(row):
        c = row[i]
        if quote:
            if c == "\\":
                buf.append(row[i:i + 2]); i += 2; continue
            if c == quote: quote = None
            else: buf.append(c)
            i += 1; continue
        if c in "'\"":
            quote = c; i += 1; continue
        if c == ",":
            out.append("".join(buf).strip()); buf = []; i += 1; continue
        buf.append(c); i += 1
    out.append("".join(buf).strip())
    return out


def unset(s):
    return "NULL" if s.upper() == "NULL" else s


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

    def expected(self, table):
        """把 base + 所有增量叠加成最终状态：{主键元组: 行字典}；没有主键时返回行列表。"""
        cols = self.ddl.get(table)
        if not cols: return None
        key = self.keys.get(table)
        rows = {}
        plain = []
        for path in self.files(table):
            if not os.path.exists(path): continue
            for st in self._stmts(path).get(table, []):
                s = st.strip()
                if not s: continue
                m = HEAD.search(s)
                if m and m.group(1) == table:
                    use = [c.strip().strip('`') for c in m.group(2).split(",")] if m.group(2) else cols
                    for row in split_tuples(s[m.end():]):
                        f = split_fields(row)
                        if len(f) != len(use): continue
                        d = dict(zip(use, [unset(x) for x in f]))
                        if key:
                            k = tuple((d.get(c) or "").strip() for c in key)
                            rows[k] = d
                        else:
                            plain.append(d)
                    continue
                m = re.match(r"DELETE\s+FROM\s+`%s`\s*(?:WHERE\s+(.*))?$" % table, s, re.I | re.S)
                if m:
                    cond = (m.group(1) or "").strip()
                    if not cond:
                        rows.clear(); plain = []; continue
                    for k in [k for k, d in rows.items() if self._match(d, cond)]: del rows[k]
                    plain = [d for d in plain if not self._match(d, cond)]
                    continue
                m = re.match(r"UPDATE\s+`%s`\s+SET\s+(.*?)\s+WHERE\s+(.*)$" % table, s, re.I | re.S)
                if m:
                    sets, cond = m.group(1), m.group(2)
                    for k, d in rows.items():
                        for a in self._assignments(sets):
                            d[a[0]] = a[1]
                    for d in plain:
                        if self._match(d, cond):
                            for a in self._assignments(sets):
                                d[a[0]] = a[1]
        return rows if key else plain

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
        return [tuple(r) for r in mysql_run(self.cmd, "SELECT %s FROM `%s`" % (expr, table))]


# ---------------------------------------------------------------- 对比逻辑

def cmp_counts(repo, source):
    print("%-34s %10s %10s %10s" % ("表", "仓库", "线上", "差"))
    print("-" * 70)
    missing = []
    tables = repo.tables()
    for i, t in enumerate(tables, 1):
        sys.stderr.write("\r[%d/%d] 解析仓库里的 %-34s" % (i, len(tables), t))
        sys.stderr.flush()
        exp = repo.expected(t)
        n_exp = len(exp) if exp is not None else 0
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
            want.add(tuple((d.get(k) or "").strip() for k in key))
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

    if args.counts or not args.table:
        cmp_counts(repo, source)
    if args.table:
        cmp_table(repo, source, args.table, args.emit_sql, args.limit)


if __name__ == "__main__":
    main()
