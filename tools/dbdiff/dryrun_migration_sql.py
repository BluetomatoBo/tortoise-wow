#!/usr/bin/env python3
# -*- coding: utf-8 -*-
r"""
dryrun_migration_sql.py —— 迁移 SQL 的**零写入**预检（语法 + 引用对象）

为什么需要
    内核的自动更新器（src/shared/Database/AutoUpdater.cpp）把每份迁移放进一个事务，
    只要有一条语句报错，`HandleMySQLError` 会 `assert(false)` → 整个 mangosd **启动即崩**。
    模块（modules/<名>/data/sql/{character,world}/）也一样。也就是说：
    **一份语法错误的迁移 = 服务器起不来**，而它可能躺在几十个文件、上百条语句里。

它怎么做到「不写入」
    用 MySQL 的 `PREPARE ... FROM <文本>`：只做**解析/语法校验**，不执行。
    所以 DDL（CREATE/ALTER/DROP）和 DML（INSERT/UPDATE/DELETE）都能安全地预检。
    语句文本用十六进制字面量传进去（`SET @s := CONVERT(0x… USING utf8mb4)`），
    完全不碰引号转义问题。

语法**或**语义
    * 语法（1064 等）→ PREPARE 就能抓到，这正是「MariaDB 专有写法」类事故（`ADD COLUMN
      IF NOT EXISTS`、`DROP COLUMN IF EXISTS`、`ADD INDEX IF NOT EXISTS`…）。
    * 引用的表/列是否存在 → 本工具另外查 `information_schema` 粗查一遍（见表名与
      「本次运行内已 CREATE 的表」的差集），作为 warning 报出；PREPARE 对 ALTER 不做对象解析。

用法
    # 核心迁移
    python3 tools/dbdiff/dryrun_migration_sql.py \
        --mysql "tools/dbdiff/mysql_local.sh" --dir sql/database_updates/world --db tw_world

    # 模块迁移（按 character/world 子目录自动选库）
    python3 tools/dbdiff/dryrun_migration_sql.py \
        --mysql "tools/dbdiff/mysql_local.sh" \
        --module-root modules/TortoiseBots/data/sql \
        --char-db tw_char --world-db tw_world

    # 只看 MariaDB 专有写法（不连数据库）
    python3 tools/dbdiff/dryrun_migration_sql.py --dir <目录> --lint-only

退出码：0 = 全部通过，1 = 有语句会被 MySQL 拒绝（或 lint/对象检查发现硬问题）。
"""
import argparse
import binascii
import glob
import os
import re
import subprocess
import sys

# 与内核切分器同源的实现（避免两套规则漂移）
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
try:
    from check_update_file import split_like_autoupdater
except Exception:                                            # pragma: no cover
    split_like_autoupdater = None

# MariaDB 专有 / MySQL 不接受的写法（先静态拦一遍，报错信息更好读）
MARIADB_PATTERNS = [
    (re.compile(r"\bADD\s+COLUMN\s+IF\s+NOT\s+EXISTS\b", re.I),
     "ADD COLUMN IF NOT EXISTS 是 MariaDB 专有语法，MySQL 会报 1064"),
    (re.compile(r"\bDROP\s+COLUMN\s+IF\s+EXISTS\b", re.I),
     "DROP COLUMN IF EXISTS 是 MariaDB 专有语法，MySQL 会报 1064"),
    (re.compile(r"\bADD\s+(?:INDEX|KEY|UNIQUE|CONSTRAINT|FOREIGN\s+KEY)\s+.*?\bIF\s+NOT\s+EXISTS\b", re.I),
     "ADD INDEX/CONSTRAINT ... IF NOT EXISTS 是 MariaDB 专有语法，MySQL 会报 1064"),
    (re.compile(r"\bDROP\s+(?:INDEX|KEY|CONSTRAINT|FOREIGN\s+KEY)\s+IF\s+EXISTS\b", re.I),
     "DROP INDEX/CONSTRAINT ... IF EXISTS 是 MariaDB 专有语法，MySQL 会报 1064"),
    (re.compile(r"\bCREATE\s+OR\s+REPLACE\s+TABLE\b", re.I),
     "CREATE OR REPLACE TABLE 是 MariaDB 专有语法"),
    (re.compile(r"\bALTER\s+IGNORE\b", re.I), "ALTER IGNORE 是 MariaDB 专有语法"),
    (re.compile(r"\bRETURNING\b", re.I), "RETURNING 是 MariaDB/PostgreSQL 写法，MySQL 不支持"),
    (re.compile(r"\bCREATE\s+SEQUENCE\b", re.I), "SEQUENCE 是 MariaDB/PostgreSQL 特性，MySQL 不支持"),
]
# 这些语句由内核/工具自身使用（会话变量、动态 SQL），不需要预检
SKIP_HEADS = re.compile(r"^\s*(SET|PREPARE|EXECUTE|DEALLOCATE|DO)\b", re.I)
# --ddl-only 只预检结构变更（迁移目录动辄几万条 INSERT，逐条 PREPARE 太慢）
DDL_HEADS = re.compile(r"^\s*(CREATE|ALTER|DROP|RENAME|TRUNCATE)\b", re.I)
# 记录一份运行内创建的表：CREATE TABLE [IF NOT EXISTS] `x`
CREATED_TABLE = re.compile(r"^\s*CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?`?([\w$]+)`?", re.I)
# 语句里的主表名（用于对象存在性粗查）
MAIN_TABLE = re.compile(
    r"^\s*(?:ALTER|INSERT\s+INTO|INSERT\s+IGNORE\s+INTO|REPLACE\s+INTO|UPDATE|DELETE\s+FROM|"
    r"CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?|DROP\s+TABLE\s+(?:IF\s+EXISTS\s+)?|TRUNCATE(?:\s+TABLE)?)"
    r"\s+`?([\w$]+)`?", re.I)


def split_statements(text):
    """优先用仓库里的内核同源切分器；拿不到就退回简单实现。"""
    if split_like_autoupdater is not None:
        queries, _ = split_like_autoupdater(text)[0], None
        return [q.strip() for q in queries if q.strip()]
    out, buf, ins = [], [], False
    for ch in text:
        buf.append(ch)
        if ch == "'":
            ins = not ins
        elif ch == ";" and not ins:
            out.append("".join(buf).strip())
            buf = []
    if "".join(buf).strip():
        out.append("".join(buf).strip())
    return out


def hex_literal(text):
    return "0x" + binascii.hexlify(text.encode("utf-8")).decode("ascii")


def strip_strings(stmt):
    """把单引号字符串的内容换成空，避免文案里的词（比如任务文本里的 RETURNING）被当成语法。"""
    out, i, n, ins = [], 0, len(stmt), False
    while i < n:
        ch = stmt[i]
        if ins:
            if ch == "\\" and i + 1 < n:
                i += 2
                continue
            if ch == "'":
                if i + 1 < n and stmt[i + 1] == "'":       # '' 转义
                    i += 2
                    continue
                ins = False
                out.append("''")
            i += 1
            continue
        out.append(ch)
        if ch == "'":
            ins = True
        i += 1
    return "".join(out)


def lint(statements):
    """静态检查：返回 [(序号, 说明)]。字符串字面量已剥掉，只看出现在语法位置的关键词。"""
    hits = []
    for i, stmt in enumerate(statements):
        code = strip_strings(stmt)
        for pattern, message in MARIADB_PATTERNS:
            if pattern.search(code):
                hits.append((i, message))
                break
    return hits


def mysql_run(mysql, db, sql):
    cmd = mysql.split() + (["--force", "--batch", db] if db else ["--force", "--batch"])
    proc = subprocess.run(cmd, input=sql.encode("utf-8"),
                          stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return (proc.stdout.decode("utf-8", "replace"),
            proc.stderr.decode("utf-8", "replace"),
            proc.returncode)


def existing_tables(mysql, db):
    out, _, _ = mysql_run(mysql, db, "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA='%s';" % db)
    return {line.strip() for line in out.split("\n") if line.strip()}


def dryrun(mysql, db, statements, only_ddl=False):
    """把语句编码成 PREPARE 预检脚本，跑一次，返回 {序号: 错误信息}。"""
    lines, index_at_line = [], {}
    for i, stmt in enumerate(statements):
        if SKIP_HEADS.match(stmt):
            continue
        if only_ddl and not DDL_HEADS.match(stmt):
            continue
        index_at_line[len(lines) + 1] = i                 # 下面第一行的行号 → 语句序号
        lines.append("SET @dryrun_sql := CONVERT(%s USING utf8mb4);" % hex_literal(stmt))
        lines.append("PREPARE dryrun_stmt FROM @dryrun_sql;")
        lines.append("DEALLOCATE PREPARE dryrun_stmt;")
    if not lines:
        return {}
    _, err, _ = mysql_run(mysql, db, "\n".join(lines) + "\n")
    errors = {}
    for match in re.finditer(r"ERROR (\d+).*?at line (\d+):\s*(.*)", err):
        code, line, message = match.group(1), int(match.group(2)), match.group(3).strip()
        missing = re.search(r"Table '[^'`.]*\.([\w$]+)' doesn't exist", message)
        if missing:
            message += "\x00%s" % missing.group(1)          # 附加缺表名，供上层判定
        # 报错行落在哪条语句的块里：找 <= line 的最近起点
        owner = None
        for start, idx in sorted(index_at_line.items()):
            if start <= line:
                owner = idx
            else:
                break
        if owner is not None:
            errors.setdefault(owner, "ERROR %s: %s" % (code, message))
    return errors


def check_file(mysql, db, path, args, created_earlier=None):
    """（供外部调用；main 里用的是带「创建顺序快照」的内联版本）"""
    text = open(path, encoding="utf-8", errors="replace").read()
    statements = split_statements(text)
    problems, warnings = [], []

    for idx, message in lint(statements):
        problems.append((idx, statements[idx], "静态检查：" + message))

    created_earlier = {t.lower() for t in (created_earlier or set())}
    if not args.lint_only and mysql:
        for idx, message in dryrun(mysql, db, statements).items():
            missing = None
            if "\x00" in message:
                message, missing = message.split("\x00", 1)
            if missing and missing.lower() in created_earlier:
                continue                                     # 由本次运行里更早的文件创建，属预期
            problems.append((idx, statements[idx], "MySQL 预检：" + message))
        if args.check_objects:
            known = None
            for i, stmt in enumerate(statements):
                created = CREATED_TABLE.match(stmt)
                if created:
                    continue
                target = MAIN_TABLE.match(stmt)
                if not target:
                    continue
                table = target.group(1)
                if known is None:
                    known = existing_tables(mysql, db)
                earlier = {m.group(1) for m in
                           (CREATED_TABLE.match(s) for s in statements[:i]) if m}
                if table.lower() not in {t.lower() for t in known} and table.lower() not in {t.lower() for t in earlier}:
                    warnings.append((i, stmt, "引用的表 `%s` 在 %s 里不存在，本次运行内也没有先建它" % (table, db)))
    return statements, problems, warnings


def collect(args):
    """返回 [(数据库, 文件路径)]，按内核的应用顺序（文件名）排。"""
    jobs = []
    if args.dir:
        for pattern in args.dir:
            for path in sorted(glob.glob(pattern, recursive=True)):
                jobs.append((args.db, path))
    if args.module_root:
        for folder, db in (("character", args.char_db), ("world", args.world_db), ("auth", args.login_db)):
            if not db:
                continue
            for path in sorted(glob.glob(os.path.join(args.module_root, folder, "*.sql"), recursive=True)):
                jobs.append((db, path))
    return jobs


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--mysql", default="", help="mysql 命令行（不含库名），如 tools/dbdiff/mysql_local.sh")
    parser.add_argument("--dir", action="append", default=[], help="迁移文件或通配符（可重复）")
    parser.add_argument("--db", default="", help="--dir 用的目标库")
    parser.add_argument("--module-root", default="", help="模块的 data/sql 目录（自动分 character/world）")
    parser.add_argument("--char-db", default="", help="模块 character 子目录的目标库")
    parser.add_argument("--world-db", default="", help="模块 world 子目录的目标库")
    parser.add_argument("--login-db", default="", help="模块 auth 子目录的目标库")
    parser.add_argument("--lint-only", action="store_true", help="只做静态检查，不连数据库")
    parser.add_argument("--check-objects", action="store_true", help="额外粗查引用的表是否存在")
    parser.add_argument("--ddl-only", action="store_true",
                        help="只预检 CREATE/ALTER/DROP/RENAME/TRUNCATE（大迁移目录用，快很多）")
    args = parser.parse_args()

    jobs = collect(args)
    if not jobs:
        sys.exit("没有找到要检查的文件（用 --dir 或 --module-root）")
    if not args.lint_only and not args.mysql:
        sys.exit("需要 --mysql（或用 --lint-only 只做静态检查）")

    print("检查 %d 个文件（目标库：%s）%s" % (
        len(jobs), ", ".join(sorted({db for db, _ in jobs if db})),
        "；仅静态检查" if args.lint_only else "；每条语句用 PREPARE 预检，不写入"))
    print()
    # 预扫：按内核的应用顺序记录每个库里「到目前为止创建过哪些表」，
    # 这样后面那些 INSERT/ALTER 引用「同一次运行里更早创建的表」就不会被误报 1146。
    plan, created = [], {}
    for db, path in jobs:
        statements = split_statements(open(path, encoding="utf-8", errors="replace").read())
        snapshot = set(created.get(db, ()))
        plan.append((db, path, statements, snapshot))
        for stmt in statements:
            made = CREATED_TABLE.match(stmt)
            if made:
                snapshot.add(made.group(1).lower())
        created[db] = snapshot

    bad_files = 0
    total_problems = warn_count = 0
    for db, path, statements, snapshot in plan:
        problems, warnings = [], []
        for idx, message in lint(statements):
            problems.append((idx, statements[idx], "静态检查：" + message))
        if not args.lint_only and args.mysql:
            for idx, message in dryrun(args.mysql, db, statements, args.ddl_only).items():
                missing = None
                if "\x00" in message:
                    message, missing = message.split("\x00", 1)
                if missing and missing.lower() in snapshot:
                    continue                                 # 由更早的迁移创建，属预期
                problems.append((idx, statements[idx], "MySQL 预检：" + message))
        warnings = []
        if args.check_objects and not args.lint_only and args.mysql:
            known = existing_tables(args.mysql, db)
            seen = set(snapshot)
            for i, stmt in enumerate(statements):
                if CREATED_TABLE.match(stmt):
                    seen.add(CREATED_TABLE.match(stmt).group(1).lower())
                    continue
                target = MAIN_TABLE.match(stmt)
                if target and target.group(1).lower() not in {t.lower() for t in known} \
                        and target.group(1).lower() not in seen:
                    warnings.append((i, stmt, "引用的表 `%s` 在 %s 里不存在，本次运行内也没有先建它"
                                     % (target.group(1), db)))
        if not problems and not warnings:
            print("  OK   %-58s %3d 条语句" % (os.path.basename(path), len(statements)))
            continue
        name = os.path.basename(path)
        if problems:
            bad_files += 1
            total_problems += len(problems)
            print("  FAIL %-58s %3d 条语句，%d 条会被 MySQL 拒绝" % (name, len(statements), len(problems)))
            for idx, stmt, message in problems[:6]:
                print("        #%d %s" % (idx + 1, message))
                print("           %s" % re.sub(r"\s+", " ", stmt)[:150])
            if len(problems) > 6:
                print("        …还有 %d 条" % (len(problems) - 6))
        else:
            print("  WARN %-58s %3d 条语句" % (name, len(statements)))
        for idx, stmt, message in warnings[:4]:
            warn_count += 1
            print("        #%d 提示：%s" % (idx + 1, message))
            print("           %s" % re.sub(r"\s+", " ", stmt)[:150])
    print()
    print("结果：%d 个文件有问题（%d 条语句会被拒绝），%d 条提示" % (bad_files, total_problems, warn_count))
    if bad_files:
        print("提示：内核遇到迁移里的 SQL 错误会 assert(false) 直接崩，服务器起不来 —— 先改这些文件再重启。")
    return 1 if bad_files else 0


if __name__ == "__main__":
    sys.exit(main())
