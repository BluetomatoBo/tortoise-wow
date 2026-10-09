#!/bin/sh
# ---------------------------------------------------------------
# mysql_local.sh —— 用 ~/.my.cnf 里的账号连乌龟服数据库（不依赖 PATH 里的 mysql）
#
# 用法（工具里当 --mysql 用）：
#   python3 tools/dbdiff/verify_wip_locales.py --dir sql/wip_updates \
#       --mysql "$(pwd)/tools/dbdiff/mysql_local.sh tw_world"
#   tools/dbdiff/mysql_local.sh tw_world -e "SELECT COUNT(*) FROM creature"
#   tools/dbdiff/mysql_local.sh -e "SHOW DATABASES"        # 不指定库
#
# 环境变量：
#   MYSQL_BIN  指定 mysql 可执行文件（默认 PATH 里的，其次 Homebrew）
#   MYSQL_CNF  指定配置文件（默认 ~/.my.cnf）
# ---------------------------------------------------------------
set -e
MYSQL_BIN="${MYSQL_BIN:-$(command -v mysql 2>/dev/null || true)}"
if [ -z "$MYSQL_BIN" ] && [ -x /opt/homebrew/opt/mysql-client/bin/mysql ]; then
    MYSQL_BIN=/opt/homebrew/opt/mysql-client/bin/mysql
fi
if [ -z "$MYSQL_BIN" ]; then
    echo "mysql_local.sh: 找不到 mysql 客户端（可 brew install mysql-client，或设 MYSQL_BIN）" >&2
    exit 127
fi
CNF="${MYSQL_CNF:-$HOME/.my.cnf}"
if [ ! -f "$CNF" ]; then
    echo "mysql_local.sh: 缺少 $CNF —— 请把 host/user/password 填进去" >&2
    exit 2
fi
# 第一个非选项参数当作库名（mysql 允许库名放最后）
DB=""
if [ $# -gt 0 ]; then
    case "$1" in
        -*) : ;;
        *) DB="$1"; shift ;;
    esac
fi
exec "$MYSQL_BIN" --defaults-extra-file="$CNF" "$@" ${DB:+"$DB"}
