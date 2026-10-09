-- ==============================================
-- FILE: fix_snowball_wars_targets.sql
-- GENERATED: 20261008204000
-- ==============================================
-- 任务 50319 / 50320（Snowball Wars: Episode I / II）的目标生物指向了不存在的老编号
-- （50319/50329/50339/50349 与 50320/50330/50340/50350），内核因此报 8 行
-- `Quest N has ReqCreatureOrGOIdN = N but creature with entry N does not exist, quest cannot be done.`，
-- 任务实际无法完成。
--
-- 正确编号来自公开 DB（octowow.st/db/?quest=50319 与 ?quest=50320）以及本仓库的 creature_template：
--   50319 → 60000 Warlock / 60001 Priest / 60002 Mage / 60003 Warrior
--   50320 → 60004 Druid   / 60005 Paladin/ 60006 Hunter / 60007 Shaman
-- 这些生物在仓库里是 `Snowball Hit Trigger: GetClass`（子名 Snowball Wars）、level 1、type=7，
-- 与任务 ObjectiveText（Throw snowball at Warlock/Priest/Mage/Warrior …）逐项对应。

-- 1) 把两个任务的目标改成正确的触发生物（次数保持 1；重复执行结果相同）
UPDATE `quest_template` SET `ReqCreatureOrGOId1` = 60000, `ReqCreatureOrGOId2` = 60001,
       `ReqCreatureOrGOId3` = 60002, `ReqCreatureOrGOId4` = 60003
 WHERE `entry` = 50319;

UPDATE `quest_template` SET `ReqCreatureOrGOId1` = 60004, `ReqCreatureOrGOId2` = 60005,
       `ReqCreatureOrGOId3` = 60006, `ReqCreatureOrGOId4` = 60007
 WHERE `entry` = 50320;

-- 2) 兜底：万一线上库缺这几个触发生物模板，按仓库 dump 补上（INSERT IGNORE，已存在则跳过）
INSERT IGNORE INTO `creature_template` (`entry`, `display_id1`, `display_id2`, `display_id3`, `display_id4`, `mount_display_id`, `name`, `subname`, `gossip_menu_id`, `level_min`, `level_max`, `health_min`, `health_max`, `mana_min`, `mana_max`, `armor`, `faction`, `npc_flags`, `speed_walk`, `speed_run`, `scale`, `detection_range`, `call_for_help_range`, `leash_range`, `rank`, `xp_multiplier`, `dmg_min`, `dmg_max`, `dmg_school`, `attack_power`, `dmg_multiplier`, `base_attack_time`, `ranged_attack_time`, `unit_class`, `unit_flags`, `dynamic_flags`, `beast_family`, `trainer_type`, `trainer_spell`, `trainer_class`, `trainer_race`, `ranged_dmg_min`, `ranged_dmg_max`, `ranged_attack_power`, `type`, `type_flags`, `loot_id`, `pickpocket_loot_id`, `skinning_loot_id`, `holy_res`, `fire_res`, `nature_res`, `frost_res`, `shadow_res`, `arcane_res`, `spell_id1`, `spell_id2`, `spell_id3`, `spell_id4`, `spell_list_id`, `pet_spell_list_id`, `spawn_spell_id`, `auras`, `gold_min`, `gold_max`, `ai_name`, `movement_type`, `inhabit_type`, `civilian`, `racial_leader`, `regeneration`, `equipment_id`, `trainer_id`, `vendor_id`, `mechanic_immune_mask`, `school_immune_mask`, `immunity_flags`, `flags_extra`, `phase_quest_id`, `script_name`) VALUES
    ('60000', '1555', '0', '0', '0', '0', 'Snowball Hit Trigger: GetClass', 'Snowball Wars', '0', '1', '1', '11', '33', '0', '0', '7', '35', '0', '1.2', '1.14286', '1', '18', '5', '0', '0', '1', '2.2', '2.2', '0', '44', '1', '2000', '2000', '1', '0', '0', '0', '0', '0', '0', '0', '1.1', '1.1', '0', '7', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', NULL, '0', '0', '', '0', '3', '0', '0', '3', '0', '0', '0', '0', '0', '0', '524288', '0', ''),
    ('60001', '1555', '0', '0', '0', '0', 'Snowball Hit Trigger: GetClass', 'Snowball Wars', '0', '1', '1', '11', '33', '0', '0', '7', '35', '0', '1.2', '1.14286', '1', '18', '5', '0', '0', '1', '2.2', '2.2', '0', '44', '1', '2000', '2000', '1', '0', '0', '0', '0', '0', '0', '0', '1.1', '1.1', '0', '7', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', NULL, '0', '0', '', '0', '3', '0', '0', '3', '0', '0', '0', '0', '0', '0', '524288', '0', ''),
    ('60002', '1555', '0', '0', '0', '0', 'Snowball Hit Trigger: GetClass', 'Snowball Wars', '0', '1', '1', '11', '33', '0', '0', '7', '35', '0', '1.2', '1.14286', '1', '18', '5', '0', '0', '1', '2.2', '2.2', '0', '44', '1', '2000', '2000', '1', '0', '0', '0', '0', '0', '0', '0', '1.1', '1.1', '0', '7', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', NULL, '0', '0', '', '0', '3', '0', '0', '3', '0', '0', '0', '0', '0', '0', '524288', '0', ''),
    ('60003', '1555', '0', '0', '0', '0', 'Snowball Hit Trigger: GetClass', 'Snowball Wars', '0', '1', '1', '11', '33', '0', '0', '7', '35', '0', '1.2', '1.14286', '1', '18', '5', '0', '0', '1', '2.2', '2.2', '0', '44', '1', '2000', '2000', '1', '0', '0', '0', '0', '0', '0', '0', '1.1', '1.1', '0', '7', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', NULL, '0', '0', '', '0', '3', '0', '0', '3', '0', '0', '0', '0', '0', '0', '524288', '0', ''),
    ('60004', '1555', '0', '0', '0', '0', 'Snowball Hit Trigger: GetClass', 'Snowball Wars', '0', '1', '1', '11', '33', '0', '0', '7', '35', '0', '1.2', '1.14286', '1', '18', '5', '0', '0', '1', '2.2', '2.2', '0', '44', '1', '2000', '2000', '1', '0', '0', '0', '0', '0', '0', '0', '1.1', '1.1', '0', '7', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', NULL, '0', '0', '', '0', '3', '0', '0', '3', '0', '0', '0', '0', '0', '0', '524288', '0', ''),
    ('60005', '1555', '0', '0', '0', '0', 'Snowball Hit Trigger: GetClass', 'Snowball Wars', '0', '1', '1', '11', '33', '0', '0', '7', '35', '0', '1.2', '1.14286', '1', '18', '5', '0', '0', '1', '2.2', '2.2', '0', '44', '1', '2000', '2000', '1', '0', '0', '0', '0', '0', '0', '0', '1.1', '1.1', '0', '7', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', NULL, '0', '0', '', '0', '3', '0', '0', '3', '0', '0', '0', '0', '0', '0', '524288', '0', ''),
    ('60006', '1555', '0', '0', '0', '0', 'Snowball Hit Trigger: GetClass', 'Snowball Wars', '0', '1', '1', '11', '33', '0', '0', '7', '35', '0', '1.2', '1.14286', '1', '18', '5', '0', '0', '1', '2.2', '2.2', '0', '44', '1', '2000', '2000', '1', '0', '0', '0', '0', '0', '0', '0', '1.1', '1.1', '0', '7', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', NULL, '0', '0', '', '0', '3', '0', '0', '3', '0', '0', '0', '0', '0', '0', '524288', '0', ''),
    ('60007', '1555', '0', '0', '0', '0', 'Snowball Hit Trigger: GetClass', 'Snowball Wars', '0', '1', '1', '11', '33', '0', '0', '7', '35', '0', '1.2', '1.14286', '1', '18', '5', '0', '0', '1', '2.2', '2.2', '0', '44', '1', '2000', '2000', '1', '0', '0', '0', '0', '0', '0', '0', '1.1', '1.1', '0', '7', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', NULL, '0', '0', '', '0', '3', '0', '0', '3', '0', '0', '0', '0', '0', '0', '524288', '0', '');
