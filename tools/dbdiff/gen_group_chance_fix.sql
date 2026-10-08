-- ============================================================
-- gen_group_chance_fix.sql —— 生成「按 entry 修正组概率合计 > 100%」的语句
--
-- 背景：内核在 DBErrorFix 日志里给的那几条是
--     UPDATE creature_loot_template SET ChanceOrQuestChance=ChanceOrQuestChance*0.xxx WHERE groupid=N;
-- **漏了 entry=**，直接执行会把全表所有同 groupid 的行一起缩放（等于改掉全部掉落概率），
-- 所以不能直接用。下面这两条 SELECT 会按 entry 逐组生成正确的缩放语句：
-- 某个 (entry, group) 的合计 > 100 时，把它整组乘 100/合计（组内相对权重不变）。
--
-- 用法（把生成结果存成文件再执行）：
--   mysql -h127.0.0.1 -uroot -p -N -B tw_world -e "$(sed -n '/^SELECT/,$p' tools/dbdiff/gen_group_chance_fix.sql)" \
--     | grep '^UPDATE' > /tmp/fix_group_chance.sql
--   mysql -h127.0.0.1 -uroot -p tw_world < /tmp/fix_group_chance.sql
-- ============================================================

SELECT CONCAT('UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = ROUND(`ChanceOrQuestChance` * 100 / ',
              ROUND(SUM(`ChanceOrQuestChance`), 6), ', 6) WHERE `entry` = ', `entry`, ' AND `groupid` = ', `groupid`, ';') AS stmt
  FROM `creature_loot_template`
 WHERE `groupid` <> 0
 GROUP BY `entry`, `groupid`
HAVING SUM(`ChanceOrQuestChance`) > 100.01;

SELECT CONCAT('UPDATE `item_loot_template` SET `ChanceOrQuestChance` = ROUND(`ChanceOrQuestChance` * 100 / ',
              ROUND(SUM(`ChanceOrQuestChance`), 6), ', 6) WHERE `entry` = ', `entry`, ' AND `groupid` = ', `groupid`, ';') AS stmt
  FROM `item_loot_template`
 WHERE `groupid` <> 0
 GROUP BY `entry`, `groupid`
HAVING SUM(`ChanceOrQuestChance`) > 100.01;

SELECT CONCAT('UPDATE `gameobject_loot_template` SET `ChanceOrQuestChance` = ROUND(`ChanceOrQuestChance` * 100 / ',
              ROUND(SUM(`ChanceOrQuestChance`), 6), ', 6) WHERE `entry` = ', `entry`, ' AND `groupid` = ', `groupid`, ';') AS stmt
  FROM `gameobject_loot_template`
 WHERE `groupid` <> 0
 GROUP BY `entry`, `groupid`
HAVING SUM(`ChanceOrQuestChance`) > 100.01;

SELECT CONCAT('UPDATE `reference_loot_template` SET `ChanceOrQuestChance` = ROUND(`ChanceOrQuestChance` * 100 / ',
              ROUND(SUM(`ChanceOrQuestChance`), 6), ', 6) WHERE `entry` = ', `entry`, ' AND `groupid` = ', `groupid`, ';') AS stmt
  FROM `reference_loot_template`
 WHERE `groupid` <> 0
 GROUP BY `entry`, `groupid`
HAVING SUM(`ChanceOrQuestChance`) > 100.01;
