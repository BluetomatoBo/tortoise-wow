#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_group_chance_from_log.py —— 从内核日志生成「按 entry 修正组概率」的 SQL（最忠实的一种做法）

为什么用日志而不是直接查库算：
  内核在加载掉落表时会**跳过**一些行（`condition_id` 不存在、负引用带条件、maxcount>255、
  IsValid 失败等），这些行不会进入掉落组 —— 也就是说内核算「组内合计」时并不包含它们。
  直接在 SQL 里 SUM 全表会把它们算进分母，得出的组集合和缩放比例都可能与内核不一致
  （表现就是生成出来的条数比日志里报的多）。
  内核日志里那行 `... has total chance > 100% (101.18)` 里的数字 **就是内核自己算出来的合计**，
  直接拿它当分母最准；而 entry / group 也都印在同一行里。

用法：
    python3 tools/dbdiff/gen_group_chance_from_log.py /data_2T/ts_wow/logs/server_*.log > /tmp/fix_group_chance.sql
    # 看一眼条数再执行：
    #   grep -c '^UPDATE' /tmp/fix_group_chance.sql
    mysql -h127.0.0.1 -uroot -p tw_world < /tmp/fix_group_chance.sql

生成的语句只缩放**正值行**（内核 RawTotalChance 只累加非任务条目，任务掉落是独立判定）。
"""
import re
import sys

LINE = re.compile(
    r"Table '(?P<table>[a-z_]+)' entry (?P<entry>\d+) group (?P<group>\d+) "
    r"has total chance > 100% \((?P<sum>[0-9.]+)\)")

TABLES = {
    "creature_loot_template", "gameobject_loot_template", "item_loot_template",
    "reference_loot_template", "pickpocketing_loot_template", "skinning_loot_template",
    "disenchant_loot_template", "fishing_loot_template", "mail_loot_template",
}


def main():
    files = sys.argv[1:]
    if not files:
        sys.exit(__doc__)
    seen = set()
    out = []
    for path in files:
        try:
            text = open(path, encoding="utf-8", errors="replace").read()
        except OSError as exc:
            sys.stderr.write("跳过 %s：%s\n" % (path, exc))
            continue
        for m in LINE.finditer(text):
            table, entry, group, total = m.group("table"), int(m.group("entry")), int(m.group("group")), float(m.group("sum"))
            if table not in TABLES:
                continue
            key = (table, entry, group)
            if key in seen or total <= 101.0:   # 内核的判定阈值就是 >101（LootMgr.cpp:1294）
                continue
            seen.add(key)
            out.append(
                "UPDATE `%s` SET `ChanceOrQuestChance` = ROUND(`ChanceOrQuestChance` * 100 / %s, 6)"
                " WHERE `entry` = %d AND `groupid` = %d AND `ChanceOrQuestChance` > 0;"
                % (table, ("%.6f" % total).rstrip("0").rstrip("."), entry, group))

    sys.stdout.write(
        "-- 由 tools/dbdiff/gen_group_chance_from_log.py 从内核日志生成\n"
        "-- 共 %d 组：分母用的是日志里内核自己算出的合计，条目/组号也取自日志\n"
        % len(out))
    sys.stdout.write("\n".join(sorted(out)) + ("\n" if out else ""))


if __name__ == "__main__":
    main()
