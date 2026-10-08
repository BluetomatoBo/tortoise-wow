-- ============================================================
-- gen_group_chance_fix.sql —— 生成「按 entry 修正组概率合计超 100%」的语句
--
-- 为什么不能直接用 dbfix.log 里那几行：
--   内核打印的是
--     UPDATE creature_loot_template SET ChanceOrQuestChance=ChanceOrQuestChance*0.xxx WHERE groupid=N;
--   **漏了 entry=**，直接执行会把全表所有同 groupid 的行一起缩放（等于改掉全部掉落概率）。
--
-- 另外两处与内核判定的对齐（很重要）：
--   1) 内核判定的阈值是 **> 101**（LootMgr.cpp:1294 `if (chance > 101.0f)`，留 1% 容差），
--      不是 100.01 —— 用 100.01 会把内核根本不报的组也一起改了；
--   2) 内核算合计用的是 RawTotalChance()，**只累加非任务条目**（ChanceOrQuestChance > 0）；
--      任务掉落（负值）是独立判定，不参与竞争，所以也不该被缩放。
--   本生成器：分母只取正值合计、只缩放正值行、阈值 101，与内核完全一致。
--
-- 用法：
--   mysql -h127.0.0.1 -uroot -p -N -B tw_world \
--     -e "$(sed -n '/^SELECT/,$p' tools/dbdiff/gen_group_chance_fix.sql)" \
--     | grep '^UPDATE' > /tmp/fix_group_chance.sql
--   wc -l /tmp/fix_group_chance.sql    # 条数应当 ≈ 内核日志里「has total chance > 100%」的行数
--   mysql -h127.0.0.1 -uroot -p tw_world < /tmp/fix_group_chance.sql
-- ============================================================

SELECT CONCAT('UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = ROUND(`ChanceOrQuestChance` * 100 / ', `s`,
              ', 6) WHERE `entry` = ', `e`, ' AND `groupid` = ', `g`, ' AND `ChanceOrQuestChance` > 0;') AS stmt
  FROM (SELECT `entry` AS e, `groupid` AS g, ROUND(SUM(`ChanceOrQuestChance`), 6) AS s
          FROM `creature_loot_template`
         WHERE `groupid` <> 0 AND `ChanceOrQuestChance` > 0
         GROUP BY `entry`, `groupid`
        HAVING SUM(`ChanceOrQuestChance`) > 101) x;

SELECT CONCAT('UPDATE `item_loot_template` SET `ChanceOrQuestChance` = ROUND(`ChanceOrQuestChance` * 100 / ', `s`,
              ', 6) WHERE `entry` = ', `e`, ' AND `groupid` = ', `g`, ' AND `ChanceOrQuestChance` > 0;') AS stmt
  FROM (SELECT `entry` AS e, `groupid` AS g, ROUND(SUM(`ChanceOrQuestChance`), 6) AS s
          FROM `item_loot_template`
         WHERE `groupid` <> 0 AND `ChanceOrQuestChance` > 0
         GROUP BY `entry`, `groupid`
        HAVING SUM(`ChanceOrQuestChance`) > 101) x;

SELECT CONCAT('UPDATE `gameobject_loot_template` SET `ChanceOrQuestChance` = ROUND(`ChanceOrQuestChance` * 100 / ', `s`,
              ', 6) WHERE `entry` = ', `e`, ' AND `groupid` = ', `g`, ' AND `ChanceOrQuestChance` > 0;') AS stmt
  FROM (SELECT `entry` AS e, `groupid` AS g, ROUND(SUM(`ChanceOrQuestChance`), 6) AS s
          FROM `gameobject_loot_template`
         WHERE `groupid` <> 0 AND `ChanceOrQuestChance` > 0
         GROUP BY `entry`, `groupid`
        HAVING SUM(`ChanceOrQuestChance`) > 101) x;

SELECT CONCAT('UPDATE `reference_loot_template` SET `ChanceOrQuestChance` = ROUND(`ChanceOrQuestChance` * 100 / ', `s`,
              ', 6) WHERE `entry` = ', `e`, ' AND `groupid` = ', `g`, ' AND `ChanceOrQuestChance` > 0;') AS stmt
  FROM (SELECT `entry` AS e, `groupid` AS g, ROUND(SUM(`ChanceOrQuestChance`), 6) AS s
          FROM `reference_loot_template`
         WHERE `groupid` <> 0 AND `ChanceOrQuestChance` > 0
         GROUP BY `entry`, `groupid`
        HAVING SUM(`ChanceOrQuestChance`) > 101) x;
