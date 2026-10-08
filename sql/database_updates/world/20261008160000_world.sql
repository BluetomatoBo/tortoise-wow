-- ==============================================
-- FILE: startup_log_fixes_b.sql
-- GENERATED: 20261008160000
-- ==============================================
-- 第二批：能从 1.12 官方 dump 里挖出正确值、或者内核自己已经报出「应该是什么」的那些。
-- 每条都带原值条件，可重复执行。

-- 任务的分类是「技能类」（ZoneOrSort 为负），但 RequiredSkill 跟它对不上；
-- 内核在括号里给了应有的技能 id，照着设（6 个任务）
UPDATE `quest_template` SET `RequiredSkill` = 755 WHERE `entry` = 41319 AND `ZoneOrSort` = -371 AND `RequiredSkill` <> 755;
UPDATE `quest_template` SET `RequiredSkill` = 755 WHERE `entry` = 41317 AND `ZoneOrSort` = -371 AND `RequiredSkill` <> 755;
UPDATE `quest_template` SET `RequiredSkill` = 755 WHERE `entry` = 41304 AND `ZoneOrSort` = -371 AND `RequiredSkill` <> 755;
UPDATE `quest_template` SET `RequiredSkill` = 755 WHERE `entry` = 41361 AND `ZoneOrSort` = -371 AND `RequiredSkill` <> 755;
UPDATE `quest_template` SET `RequiredSkill` = 755 WHERE `entry` = 41318 AND `ZoneOrSort` = -371 AND `RequiredSkill` <> 755;
UPDATE `quest_template` SET `RequiredSkill` = 755 WHERE `entry` = 41362 AND `ZoneOrSort` = -371 AND `RequiredSkill` <> 755;

-- ReqCreatureOrGOId 是空的（0）却写了个需求数量，清数量（1 个任务）
UPDATE `quest_template` SET `ReqCreatureOrGOCount1` = 0 WHERE `entry` = 41659 AND `ReqCreatureOrGOId1` = 0;

-- ZoneOrSort 指向的区域在 area_template 与客户端 AreaTable.dbc 里都不存在，清 0（1 个任务）
UPDATE `quest_template` SET `ZoneOrSort` = 0 WHERE `entry` = 41633 AND `ZoneOrSort` = 1075;

-- NextQuestInChain 指向不存在的任务（1.12 里也没有这个任务，是 Turtle 自己的内容），清 0（1 个任务）
UPDATE `quest_template` SET `NextQuestInChain` = 0 WHERE `entry` = 40749 AND `NextQuestInChain` = 40750;

-- 这些物品的类别/品质无法分解（内核的检查就是这么判的），把分解表 id 清 0（4 个物品）
UPDATE `item_template` SET `disenchant_id` = 0 WHERE `entry` IN (
     61549, 4143, 1973, 9400);

-- 物品要求一个不存在的阵营声望，清 0（2 个物品）
UPDATE `item_template` SET `required_reputation_faction` = 0 WHERE `entry` = 80318 AND `required_reputation_faction` = 1000;
UPDATE `item_template` SET `required_reputation_faction` = 0 WHERE `entry` = 80302 AND `required_reputation_faction` = 999;

-- entry 0 的物品把 stackable 写成了 0（内核按默认值 1 处理），写回 1
UPDATE `item_template` SET `stackable` = 1 WHERE `entry` = 0 AND `stackable` = 0;

-- AI 脚本的 delay 在 creature_ai_scripts 里不支持，内核忽略它，这里清 0（1 条）
UPDATE `creature_ai_scripts` SET `delay` = 0 WHERE `id` IN (
     6217702) AND `delay` <> 0;

-- 这些事件类型永远不可能「可重复」，内核加载时会把标志位删掉；直接写回库（5 个事件）
UPDATE `creature_ai_events` SET `event_flags` = `event_flags` & 0xFE WHERE `id` IN (
     649203, 1669702, 2200027, 2200031, 2200033) AND (`event_flags` & 0x01);

-- creature_spells 的施放概率是 0 或 >100，内核一律当成 100；写回库（%d 条）。
-- 注意：日志里的 probability_N 是 0 基下标，列名是 1 基（即 probability_N+1）。
UPDATE `creature_spells` SET `probability_3` = 100 WHERE `entry` = 180211 AND `probability_3` = 0;
UPDATE `creature_spells` SET `probability_3` = 100 WHERE `entry` = 201100 AND `probability_3` = 0;
UPDATE `creature_spells` SET `probability_4` = 100 WHERE `entry` = 180319 AND `probability_4` = 0;
UPDATE `creature_spells` SET `probability_4` = 100 WHERE `entry` = 201100 AND `probability_4` = 0;
UPDATE `creature_spells` SET `probability_2` = 100 WHERE `entry` = 180133 AND `probability_2` = 0;

-- 重复施放的 Min > Max（日志里印的是毫秒，库里是秒）会让内核整条跳过；把 Max 抬到 Min（保守取值，
-- 只会按原意「每隔 Min 秒一次」施放）。想改成 0..Min 的随机区间也只需改这两列。
UPDATE `creature_spells` SET `delayRepeatMax_1` = `delayRepeatMin_1` WHERE `entry` = 63065 AND `delayRepeatMin_1` = 60 AND `delayRepeatMax_1` = 0;
UPDATE `creature_spells` SET `delayRepeatMax_1` = `delayRepeatMin_1` WHERE `entry` = 63066 AND `delayRepeatMin_1` = 60 AND `delayRepeatMax_1` = 0;
UPDATE `creature_spells` SET `delayRepeatMax_1` = `delayRepeatMin_1` WHERE `entry` = 113500 AND `delayRepeatMin_1` = 2 AND `delayRepeatMax_1` = 1;
UPDATE `creature_spells` SET `delayRepeatMax_1` = `delayRepeatMin_1` WHERE `entry` = 113510 AND `delayRepeatMin_1` = 2 AND `delayRepeatMax_1` = 1;

-- 训练师的这个法术不是「学习类」，内核给出了它对应的学习法术，换过去（1 条）
UPDATE `npc_trainer` SET `spell` = 17254 WHERE `entry` = 5807 AND `spell` = 17253;

-- areatrigger_tavern 里的触发器在客户端 AreaTrigger.dbc 里没有（2 条）
DELETE FROM `areatrigger_tavern` WHERE `id` IN (
     5336, 5400);

-- 战场的玩家尸体战利品表 id 不存在，内核会置 0（1 个战场）
UPDATE `battleground_template` SET `player_loot_id` = 0 WHERE `id` IN (
     1) AND `player_loot_id` <> 0;

-- 墓地挂在了「子区域」而不是「区域」上，按 area_template 的 zone_id 改成父区域（2 条）
UPDATE `game_graveyard_zone` SET `ghost_zone` = 5179 WHERE `ghost_zone` = 5180;
UPDATE `game_graveyard_zone` SET `ghost_zone` = 406 WHERE `ghost_zone` = 2041;

-- 这些生物的 `auras` 是字符串 "0"（不是空也不是 NULL），内核把它当法术 id 解析后报错；
-- 本库「没有光环」的写法是 NULL（13742 个），照此改（30 个模板）
UPDATE `creature_template` SET `auras` = NULL WHERE `entry` IN (
     8, 9, 12, 59970, 59971, 62196, 62198, 62796, 62798, 62799, 62800, 62801,
     62802, 62803, 62804, 62805, 62837, 63016, 63017, 63018, 63019, 63020, 63021, 63022,
     63023, 63024, 63025, 63077, 63106, 63179) AND `auras` = '0';

