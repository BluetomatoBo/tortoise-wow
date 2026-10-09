#!/bin/sh
# ---------------------------------------------------------------
# db_status.sh —— 连库自检：确认账号可用 + 一眼看到关键表规模
#   tools/dbdiff/db_status.sh [库名]      （默认 tw_world）
# 依赖：tools/dbdiff/mysql_local.sh（读 ~/.my.cnf）
# ---------------------------------------------------------------
DIR=$(cd "$(dirname "$0")" && pwd)
DB="${1:-tw_world}"
MY="$DIR/mysql_local.sh $DB -e"

echo "=== 连接信息"
$MY "SELECT VERSION() AS server, DATABASE() AS db, CURRENT_USER() AS who" || exit 1

echo
echo "=== 库列表"
$DIR/mysql_local.sh -e "SHOW DATABASES" | head -20

echo
echo "=== $DB 关键表行数"
$MY "SELECT 'creature' t, COUNT(*) n FROM creature
     UNION ALL SELECT 'creature_template', COUNT(*) FROM creature_template
     UNION ALL SELECT 'creature_movement', COUNT(*) FROM creature_movement
     UNION ALL SELECT 'quest_template', COUNT(*) FROM quest_template
     UNION ALL SELECT 'item_template', COUNT(*) FROM item_template
     UNION ALL SELECT 'locales_quest', COUNT(*) FROM locales_quest
     UNION ALL SELECT 'locales_creature', COUNT(*) FROM locales_creature
     UNION ALL SELECT 'migrations', COUNT(*) FROM migrations"

echo
echo "=== 最近应用的更新（后 5 条）"
$MY "SELECT Name, AppliedAt FROM migrations ORDER BY AppliedAt DESC LIMIT 5"
