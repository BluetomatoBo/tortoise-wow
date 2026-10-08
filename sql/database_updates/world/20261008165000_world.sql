-- ==============================================
-- FILE: startup_log_cleanup_d.sql
-- GENERATED: 20261008165000
-- ==============================================
-- 第二轮启动日志（2026-10-08 17:32）里剩下、且能确定怎么修的几类：
--   1) creature_movement 里 45 行「路径指向不存在的生物 guid 2700777」——是我上一份 161000 的失误：
--      我把一条 45 点的无主路径改指给了 2700777，这个 guid 只存在于仓库 base dump，不在你线上库里。
--      这条路径原本属于 2593426（它自己存在于你库里，但路径起点离它 87 码、本来就没被用过）→ 直接删掉这 45 行。
DELETE FROM `creature_movement` WHERE `id` = 2700777;

--   2) creature_ai_scripts 里 16001501 / 16001502 没有任何 AI 事件引用（内核自己报的）→ 删。
DELETE FROM `creature_ai_scripts` WHERE `id` IN (16001501, 16001502);

--   3) 185202（Araj 出生放霜甲）与 1007801（Terrorspark 放火盾）这两条脚本其实一直都在，但
--      ScriptMgr 的校验会跳过「target_type 非 0 且 data_flags 带 SF_GENERAL_TARGET_SELF、又没带 swap 标志」
--      的行（ScriptMgr.cpp:171）——所以事件一直报「non-existent script」。CAST_SPELL 的目标就是施法者自己，
--      写法应该是 target_type=0、data_flags=0（内核默认对 source 生效）→ 改成合法写法即可。
UPDATE `creature_ai_scripts` SET `target_type` = 0, `data_flags` = 0
 WHERE `id` IN (185202, 1007801) AND `target_type` = 1 AND `data_flags` = 4;

--   4) 14 个任务「设了声望阵营但奖励值是 0」（内核报 `RewRepFactionN` = 0 其实是它打印了值那一列，
--      阵营那一列是有值的）。按 1.12 官方 dump 里同一任务的阵营/数值补回——每条都带「阵营必须等于 1.12」
--      与「值是 0」两个守卫，所以只有本来就想这么设的行会被改（上一批 13 个任务用的同一套办法）。
UPDATE `quest_template` SET `RewRepValue1` = 350 WHERE `entry` = 498 AND `RewRepFaction1` = 76 AND `RewRepValue1` = 0;
UPDATE `quest_template` SET `RewRepValue2` = 150 WHERE `entry` = 498 AND `RewRepFaction2` = 530 AND `RewRepValue2` = 0;
UPDATE `quest_template` SET `RewRepValue3` = 150 WHERE `entry` = 498 AND `RewRepFaction3` = 81 AND `RewRepValue3` = 0;
UPDATE `quest_template` SET `RewRepValue1` = 250 WHERE `entry` = 532 AND `RewRepFaction1` = 68 AND `RewRepValue1` = 0;
UPDATE `quest_template` SET `RewRepValue1` = 350 WHERE `entry` = 553 AND `RewRepFaction1` = 68 AND `RewRepValue1` = 0;
UPDATE `quest_template` SET `RewRepValue1` = 250 WHERE `entry` = 849 AND `RewRepFaction1` = 81 AND `RewRepValue1` = 0;
UPDATE `quest_template` SET `RewRepValue1` = 250 WHERE `entry` = 877 AND `RewRepFaction1` = 81 AND `RewRepValue1` = 0;
UPDATE `quest_template` SET `RewRepValue1` = 250 WHERE `entry` = 905 AND `RewRepFaction1` = 76 AND `RewRepValue1` = 0;
UPDATE `quest_template` SET `RewRepValue1` = 250 WHERE `entry` = 3825 AND `RewRepFaction1` = 47 AND `RewRepValue1` = 0;
UPDATE `quest_template` SET `RewRepValue1` = 350 WHERE `entry` = 5163 AND `RewRepFaction1` = 577 AND `RewRepValue1` = 0;
UPDATE `quest_template` SET `RewRepValue1` = 150 WHERE `entry` = 6124 AND `RewRepFaction1` = 609 AND `RewRepValue1` = 0;
UPDATE `quest_template` SET `RewRepValue1` = 75 WHERE `entry` = 6129 AND `RewRepFaction1` = 609 AND `RewRepValue1` = 0;
UPDATE `quest_template` SET `RewRepValue1` = 250 WHERE `entry` = 6381 AND `RewRepFaction1` = 81 AND `RewRepValue1` = 0;
UPDATE `quest_template` SET `RewRepValue1` = 250 WHERE `entry` = 6395 AND `RewRepFaction1` = 68 AND `RewRepValue1` = 0;
-- 2994 / 60134 在 1.12 里根本没有声望奖励（是 Turtle 自己的内容），值=0 时本来也不会发声望，
-- 把阵营清 0 让内核不再报（行为完全不变：原来就是「不发声望」）。
UPDATE `quest_template` SET `RewRepFaction1` = 0 WHERE `entry` IN (2994, 60134) AND `RewRepFaction1` <> 0 AND `RewRepValue1` = 0;
UPDATE `quest_template` SET `RewRepFaction2` = 0 WHERE `entry` IN (2994, 60134) AND `RewRepFaction2` <> 0 AND `RewRepValue2` = 0;
UPDATE `quest_template` SET `RewRepFaction3` = 0 WHERE `entry` IN (2994, 60134) AND `RewRepFaction3` <> 0 AND `RewRepValue3` = 0;
UPDATE `quest_template` SET `RewRepFaction4` = 0 WHERE `entry` IN (2994, 60134) AND `RewRepFaction4` <> 0 AND `RewRepValue4` = 0;
UPDATE `quest_template` SET `RewRepFaction5` = 0 WHERE `entry` IN (2994, 60134) AND `RewRepFaction5` <> 0 AND `RewRepValue5` = 0;
