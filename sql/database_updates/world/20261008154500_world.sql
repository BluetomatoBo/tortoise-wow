-- ==============================================
-- FILE: startup_log_cleanup_a.sql
-- GENERATED: 20261008154500
-- ==============================================
-- 启动日志里那批「孤儿数据 / 值对不上」的清理，按每条报错的原始数据逐条核对后生成。
-- 每条都只动日志点名的那几行/那个值，可重复执行（DELETE 天然幂等，UPDATE 带原值条件）。

-- creature_movement：304 行「路径指向不存在的生物」，一大堆同一个 guid 各报一遍 —— 按 guid 删（15 个）
DELETE FROM `creature_movement` WHERE `id` IN (
     8880, 8988, 9001, 9296, 9581, 9874, 21173, 21218, 660961, 1068616, 2562709, 2562710,
     2562711, 2562712, 2562713);

-- creature_linking：从属生物 guid 不存在（41 个）
DELETE FROM `creature_linking` WHERE `guid` IN (
     99967, 99968, 190215, 190216, 190217, 190219, 190220, 190221, 190223, 190224, 190226, 190227,
     190229, 190231, 2570745, 2570747, 2570748, 2570750, 2570752, 2570753, 2570754, 2570755, 2570757, 2570758,
     2570759, 2570760, 2570762, 2570766, 2570769, 2570803, 2570817, 2570818, 2570826, 2570830, 2570831, 2570832,
     2570833, 2570834, 2570837, 2577558, 2577560);

-- creature_addon：creature_addon 指向不存在的生物（12 个）
DELETE FROM `creature_addon` WHERE `guid` IN (
     9874, 21173, 21174, 42993, 43036, 43041, 2563413, 2578192, 2578193, 2597976, 2599181, 2622126);

-- pool_creature：池子里引用了不存在的生物刷怪（9 个）
DELETE FROM `pool_creature` WHERE `guid` IN (
     2562705, 2562706, 2562707, 2562708, 2562709, 2562710, 2562711, 2562712, 2562713);

-- pool_gameobject：池子里引用了不存在的物件刷怪（6 个）
DELETE FROM `pool_gameobject` WHERE `guid` IN (
     9522, 12566, 40023, 40024, 62923, 5021053);

-- game_event_quest：节日事件引用了不存在的任务（4 个）
DELETE FROM `game_event_quest` WHERE `quest` IN (
     8530, 8617, 8856, 8869);

-- npc_gossip：npc_gossip 指向不存在的生物 guid（3 个）
DELETE FROM `npc_gossip` WHERE `npc_guid` IN (
     36, 41, 40591);

-- creature_movement_scripts：没有被任何路径点引用的移动脚本（3 个）
DELETE FROM `creature_movement_scripts` WHERE `id` IN (
     5, 23, 5907);

-- creature_ai_scripts：没有被任何 AI 事件引用的脚本（3 个）
DELETE FROM `creature_ai_scripts` WHERE `id` IN (
     727602, 728602, 1443402);

-- item_required_target：item_required_target 指向不存在的生物模板（1 个）
DELETE FROM `item_required_target` WHERE `target_entry` IN (
     80332);

-- npc_vendor_template：没有被任何商人使用的商人物品模板（2 个）
DELETE FROM `npc_vendor_template` WHERE `entry` IN (
     1277702, 1279202);

-- creature_ai_events：AI 事件挂在完全不存在的生物 entry 上（1 个）
DELETE FROM `creature_ai_events` WHERE `creature_id` IN (
     160015);

-- gameobject_questrelation：物件任务关系指向不存在的物件（1 个）
DELETE FROM `gameobject_questrelation` WHERE `id` IN (
     173594);

-- gameobject_involvedrelation：物件交付关系指向不存在的物件（1 个）
DELETE FROM `gameobject_involvedrelation` WHERE `id` IN (
     173594);

-- generic_scripts：没有被任何地方引用的通用脚本（1 个）
DELETE FROM `generic_scripts` WHERE `id` IN (
     10731);

-- gameobject_loot_template：item 不在 item_template 里，内核直接跳过（1 行）
DELETE FROM `gameobject_loot_template` WHERE `entry` = 2 AND `item` = 70093;

-- pickpocketing_loot_template：item 不在 item_template 里，内核直接跳过（1 行）
DELETE FROM `pickpocketing_loot_template` WHERE `entry` = 988079 AND `item` = 1709;

-- npc_vendor：卖的东西不在 item_template 里（1 行）
DELETE FROM `npc_vendor` WHERE `entry` = 61620 AND `item` = 83422;

-- condition_id 指向不存在的 conditions：内核会当成「无条件」继续用，所以把条件清 0（行为不变）
UPDATE `fishing_loot_template` SET `condition_id` = 0 WHERE `entry` = 5024 AND `item` = 56086 AND `condition_id` = 4223;
UPDATE `fishing_loot_template` SET `condition_id` = 0 WHERE `entry` = 5121 AND `item` = 56087 AND `condition_id` = 4223;
UPDATE `gossip_menu` SET `condition_id` = 0 WHERE `entry` = 41457 AND `text_id` = 61474 AND `condition_id` = 30000;
UPDATE `gossip_menu` SET `condition_id` = 0 WHERE `entry` = 41458 AND `text_id` = 30112 AND `condition_id` = 30000;
UPDATE `creature_ai_events` SET `condition_id` = 0 WHERE `creature_id` = 10696 AND `condition_id` = 10696;
UPDATE `creature_ai_events` SET `condition_id` = 0 WHERE `creature_id` = 10696 AND `condition_id` = 10696;

-- creature：MovementType=0(idle) 却带着 wander_distance，内核每次都把它改回 0 —— 直接改库里（42 个）
UPDATE `creature` SET `wander_distance` = 0 WHERE `guid` IN (
     16595, 16598, 42340, 53866, 68543, 80730, 80732, 2568023, 2575438, 2575439, 2575440, 2575441,
     2575442, 2575443, 2575444, 2575445, 2575446, 2575447, 2575448, 2575449, 2575450, 2575451, 2575452, 2575453,
     2575454, 2575455, 2575456, 2575457, 2575458, 2575459, 2575460, 2575634, 2575635, 2575650, 2575651, 2575652,
     2575661, 2575724, 2577353, 2577354, 2577355, 2578194) AND `movement_type` = 0 AND `wander_distance` <> 0;

-- creature：随机移动却没有 wander_distance，内核把它当成 idle —— 按内核的做法改成 idle（7 个）
UPDATE `creature` SET `movement_type` = 0 WHERE `guid` IN (
     2565624, 2578856, 2578857, 2578858, 2578859, 2578860, 2588245) AND `movement_type` = 1 AND `wander_distance` = 0;

-- creature_template.inhabit_type = 0（既不能走也不能游）；本库 11186 个生物用 3（陆地+水），按此补齐（6 个）
UPDATE `creature_template` SET `inhabit_type` = 3 WHERE `entry` IN (
     33042, 50542, 50543, 62478, 62479, 62480) AND `inhabit_type` = 0;

-- creature_equip_template：槽位里的物品既不能手持、也不在 item_template（内核强制置 0），直接改库（11 条）
UPDATE `creature_equip_template` SET `equipentry2` = 0 WHERE `entry` = 20153 AND `equipentry2` = 4130;
UPDATE `creature_equip_template` SET `equipentry2` = 0 WHERE `entry` = 20184 AND `equipentry2` = 4130;
UPDATE `creature_equip_template` SET `equipentry2` = 0 WHERE `entry` = 20185 AND `equipentry2` = 4130;
UPDATE `creature_equip_template` SET `equipentry2` = 0 WHERE `entry` = 20186 AND `equipentry2` = 4130;
UPDATE `creature_equip_template` SET `equipentry2` = 0 WHERE `entry` = 20189 AND `equipentry2` = 18661;
UPDATE `creature_equip_template` SET `equipentry1` = 0 WHERE `entry` = 20195 AND `equipentry1` = 7873;
UPDATE `creature_equip_template` SET `equipentry1` = 0 WHERE `entry` = 20196 AND `equipentry1` = 5085;
UPDATE `creature_equip_template` SET `equipentry1` = 0 WHERE `entry` = 20445 AND `equipentry1` = 4294;
UPDATE `creature_equip_template` SET `equipentry1` = 0 WHERE `entry` = 20183 AND `equipentry1` = 23505;
UPDATE `creature_equip_template` SET `equipentry1` = 0 WHERE `entry` = 20464 AND `equipentry1` = 1682;
UPDATE `creature_equip_template` SET `equipentry2` = 0 WHERE `entry` = 20162 AND `equipentry2` = 27754;

-- spell_affect：这些行指向的效果不是「以法术修饰」类光环（或被内核判定为多余），内核会跳过（8 个法术）
DELETE FROM `spell_affect` WHERE `entry` IN (
     12042, 16166, 29187, 29189, 29191, 52507, 52508, 52845);

-- creature_template.loot_id 指向不存在的 creature_loot_template 表（这些生物不掉任何东西，
-- 而且每杀一只都会在运行日志里再报一次「loot id #N used but it doesn't have records」）。
-- 1.12 官方 dump 里同 id 的这几个也是 LootId=0（Healing Ward、Witherbark Bloodling 等），
-- 所以把字段清 0；哪天补上了战利品表，再把 loot_id 设回来即可。
UPDATE `creature_template` SET `loot_id` = 0 WHERE `entry` IN (
     3844, 7768, 16062, 59989, 61220, 61254, 61255, 61256, 61398, 61400, 61427, 61482,
     61510, 61511, 61514, 61557, 61594, 61602, 61603, 61604, 61608, 61772, 61860, 61941,
     61944, 61959, 61960, 61976, 61984, 61985, 61994, 61995, 62023, 62024, 62026, 62027,
     62028, 62029, 62030, 62031, 62032, 62033, 62034, 62041, 62042, 62043, 62049, 62050,
     62055, 62056, 62058, 62059, 62060, 62061, 62062, 62819, 62840, 62841, 62844, 62846,
     62847, 62850, 62851, 62852, 62853, 62854, 62855, 62856, 62857, 62858, 62859, 62860,
     62861, 62863, 62864, 62896, 62897, 62898, 62903, 62908, 62909, 62911, 62912, 62915,
     62916, 62918, 62919, 62920, 62921, 62922, 62975, 62980, 62981, 62982, 62986, 62987,
     62993, 62994, 63044, 63045, 63046, 63047, 63048, 63049, 63051, 63053, 63057, 63058,
     63060, 63069, 63070, 63073, 63074, 63076, 63082, 63093, 63105, 63120, 63123, 63125,
     63126, 63128, 63171, 63174, 63175, 63176, 63177, 63180, 63181, 63191, 80937) AND `loot_id` IN (
     3844, 7768, 10482, 61220, 61254, 61255, 61256, 61398, 61400, 61427, 61482, 61510,
     61511, 61514, 61557, 61594, 61602, 61603, 61604, 61608, 61772, 61860, 61941, 61944,
     61959, 61960, 61976, 61984, 61985, 61994, 61995, 62023, 62024, 62026, 62027, 62028,
     62029, 62030, 62031, 62032, 62033, 62034, 62041, 62042, 62043, 62049, 62050, 62055,
     62056, 62058, 62059, 62060, 62061, 62062, 62819, 62840, 62841, 62844, 62846, 62847,
     62850, 62851, 62852, 62853, 62854, 62855, 62856, 62857, 62858, 62859, 62860, 62861,
     62863, 62864, 62896, 62897, 62898, 62903, 62908, 62909, 62911, 62912, 62915, 62916,
     62918, 62919, 62920, 62921, 62922, 62975, 62980, 62981, 62982, 62986, 62987, 62993,
     62994, 63044, 63045, 63046, 63047, 63048, 63049, 63051, 63053, 63057, 63058, 63060,
     63069, 63070, 63073, 63074, 63076, 63082, 63093, 63105, 63120, 63123, 63125, 63126,
     63128, 63171, 63174, 63175, 63176, 63177, 63180, 63181, 63191, 92300);

-- SCRIPT_COMMAND_TALK 的 dataint 是负数：那是旧的 `script_texts` id（该表已废弃），内核只认
-- broadcast_text 的**正数** id，所以这些台词现在既不播、又各报一条「out of range」+ 一条
-- 「missing text id」。把文本从 script_texts 搬进 broadcast_text（新 id 用原来的数字取正，
-- 便于对照），再把脚本指过去 —— 台词恢复播放，两条报错一起消失。
-- 注意：以下新 id 在 broadcast_text 里已存在，会以 ON DUPLICATE 覆盖：[(1999940, 6141001, 1999940, {'entry': '-1999940', 'content_default': ' I have returned...', 'sound': ' 0', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Windhorn Canyon - Spirit of Champion Rotag - Spawn'}), (1999889, 6203801, 1999889, {'entry': '-1999889', 'content_default': ' The destiny of our clan is set in stone, you can not change fate.', 'sound': ' 60592', 'type': ' 0', 'language': ' 0', 'emote': ' 0', 'comment': ' Dragonmaw Retreat - Elder Hollowblood - Aggro'}), (1999890, 6203802, 1999890, {'entry': '-1999890', 'content_default': ' Behold, the power of the elements!', 'sound': ' 60593', 'type': ' 0', 'language': ' 0', 'emote': ' 0', 'comment': ' Dragonmaw Retreat - Elder Hollowblood - 50% Health'}), (1999891, 6203803, 1999891, {'entry': '-1999891', 'content_default': ' My legacy...', 'sound': ' 60594', 'type': ' 0', 'language': ' 0', 'emote': ' 0', 'comment': ' Dragonmaw Retreat - Elder Hollowblood - Death'}), (1999883, 6206701, 1999883, {'entry': '-1999883', 'content_default': ' You wont interrupt my plans...', 'sound': ' 60520', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Dragonmaw Retreat - Web Master Torkon - Aggro'}), (1999884, 6206702, 1999884, {'entry': '-1999884', 'content_default': ' The brood will live on, my work will not end here!', 'sound': ' 60521', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Dragonmaw Retreat - Web Master Torkon - 50% Health'}), (1999885, 6206703, 1999885, {'entry': '-1999885', 'content_default': ' Pointless...', 'sound': ' 60522', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Dragonmaw Retreat - Web Master Torkon - Death'}), (1999895, 6206801, 1999895, {'entry': '-1999895', 'content_default': ' Unidentified intruder detected.', 'sound': ' 60501', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Dragonmaw Retreat - Slagfist Destroyer - Aggro'}), (1999896, 6206802, 1999896, {'entry': '-1999896', 'content_default': ' Execute destruction measure 13.', 'sound': ' 60502', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Dragonmaw Retreat - Slagfist Destroyer - 50% Health'}), (1999897, 6206803, 1999897, {'entry': '-1999897', 'content_default': ' Protocal failure...', 'sound': ' 60503', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Dragonmaw Retreat - Slagfist Destroyer - Death'}), (1999892, 6207001, 1999892, {'entry': '-1999892', 'content_default': ' More Slaves? How fortunate for you to deliver yourself to me!', 'sound': ' 60523', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Dragonmaw Retreat - Overlord Blackheart - Aggro'}), (1999893, 6207002, 1999893, {'entry': '-1999893', 'content_default': ' Get into order, maggots!', 'sound': ' 60524', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Dragonmaw Retreat - Overlord Blackheart - 50% Health'}), (1999894, 6207003, 1999894, {'entry': '-1999894', 'content_default': ' Overlord Blackheart begins to laugh maniacally.', 'sound': ' 60525', 'type': ' 2', 'language': ' 0', 'emote': ' 0', 'comment': ' Dragonmaw Retreat - Overlord Blackheart - Death'}), (1999886, 6207101, 1999886, {'entry': '-1999886', 'content_default': ' I have been tasked to keep our sacred flame, do not test me!', 'sound': ' 60492', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Dragonmaw Retreat - Garlok Flamekeeper - Aggro'}), (1999887, 6207102, 1999887, {'entry': '-1999887', 'content_default': ' You have no place here!', 'sound': ' 60493', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Dragonmaw Retreat - Garlok Flamekeeper - 50% Health'}), (1999888, 6207103, 1999888, {'entry': '-1999888', 'content_default': ' My duty... Is failed...', 'sound': ' 60494', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Dragonmaw Retreat - Garlok Flamekeeper - Death'}), (1999929, 6277902, 1999929, {'entry': '-1999929', 'content_default': ' This canyon will make for excellent hunting!', 'sound': ' 60663', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Windhorn Canyon - Pathun Duskhide - Aggro'}), (1999930, 6277903, 1999930, {'entry': '-1999930', 'content_default': ' You shall be crushed!', 'sound': ' 60664', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Windhorn Canyon - Pathun Duskhide - 50% Health'}), (1999931, 6277904, 1999931, {'entry': '-1999931', 'content_default': ' I travel to the great beyond...', 'sound': ' 60665', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Windhorn Canyon - Pathun Duskhide - Death'}), (1999942, 6278101, 1999942, {'entry': '-1999942', 'content_default': ' Our destiny has been foretold!', 'sound': ' 60669', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Windhorn Canyon - Prophet Stormhoof - Aggro'}), (1999943, 6278102, 1999943, {'entry': '-1999943', 'content_default': ' I have seen the future, and it is your death!', 'sound': ' 60670', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Windhorn Canyon - Prophet Stormhoof - 50% Health'}), (1999944, 6278103, 1999944, {'entry': '-1999944', 'content_default': ' My sight, has left me!', 'sound': ' 60671', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Windhorn Canyon - Prophet Stormhoof - Death'}), (1999932, 6278302, 1999932, {'entry': '-1999932', 'content_default': ' Behold the howling wind!', 'sound': ' 60676', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Windhorn Canyon - Ambassador Vortalus - Aggro'}), (1999933, 6278303, 1999933, {'entry': '-1999933', 'content_default': ' We seek unity...', 'sound': ' 60677', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Windhorn Canyon - Ambassador Vortalus - 50% Health'}), (1999934, 6278304, 1999934, {'entry': '-1999934', 'content_default': ' Disperse...', 'sound': ' 60678', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Windhorn Canyon - Ambassador Vortalus - Death'}), (1999935, 6278402, 1999935, {'entry': '-1999935', 'content_default': ' Be destroyed by my hands!', 'sound': ' 60666', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Windhorn Canyon - Walgan Bloodcaller - Aggro'}), (1999936, 6278403, 1999936, {'entry': '-1999936', 'content_default': ' Enough!', 'sound': ' 60667', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Windhorn Canyon - Walgan Bloodcaller - 50% Health'}), (1999937, 6278404, 1999937, {'entry': '-1999937', 'content_default': ' This cannot... be...', 'sound': ' 60668', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Windhorn Canyon - Walgan Bloodcaller - Death'}), (1999991, 6312901, 1999991, {'entry': '-1999991', 'content_default': ' I have seen da future, and you aint in it!', 'sound': ' 60711', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Frostmane Hollow - Kanza the Seer - Aggro'}), (1999990, 6313102, 1999990, {'entry': '-1999990', 'content_default': ' The Frostmane be da strongest, be da fiercest! Dis be our home, you think you can mess wit us?', 'sound': ' 60710', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Frostmane Hollow - Battlemaster Ubukaz - Aggro'}), (1999989, 6313201, 1999989, {'entry': '-1999989', 'content_default': ' Tansha, kill them all!', 'sound': ' 60709', 'type': ' 1', 'language': ' 0', 'emote': ' 0', 'comment': ' Frostmane Hollow - Handler Oboka - Aggro'})]
INSERT INTO `broadcast_text` (`entry`, `male_text`, `female_text`, `chat_type`, `sound_id`, `language_id`, `emote_id1`, `emote_id2`, `emote_id3`, `emote_delay1`, `emote_delay2`, `emote_delay3`) VALUES
     (1999940, 'I have returned...', 'I have returned...', 1, 0, 0, 0, 0, 0, 0, 0, 0),
     (1999889, 'The destiny of our clan is set in stone, you can not change fate.', 'The destiny of our clan is set in stone, you can not change fate.', 0, 60592, 0, 0, 0, 0, 0, 0, 0),
     (1999890, 'Behold, the power of the elements!', 'Behold, the power of the elements!', 0, 60593, 0, 0, 0, 0, 0, 0, 0),
     (1999891, 'My legacy...', 'My legacy...', 0, 60594, 0, 0, 0, 0, 0, 0, 0),
     (1999883, 'You wont interrupt my plans...', 'You wont interrupt my plans...', 1, 60520, 0, 0, 0, 0, 0, 0, 0),
     (1999884, 'The brood will live on, my work will not end here!', 'The brood will live on, my work will not end here!', 1, 60521, 0, 0, 0, 0, 0, 0, 0),
     (1999885, 'Pointless...', 'Pointless...', 1, 60522, 0, 0, 0, 0, 0, 0, 0),
     (1999895, 'Unidentified intruder detected.', 'Unidentified intruder detected.', 1, 60501, 0, 0, 0, 0, 0, 0, 0),
     (1999896, 'Execute destruction measure 13.', 'Execute destruction measure 13.', 1, 60502, 0, 0, 0, 0, 0, 0, 0),
     (1999897, 'Protocal failure...', 'Protocal failure...', 1, 60503, 0, 0, 0, 0, 0, 0, 0),
     (1999892, 'More Slaves? How fortunate for you to deliver yourself to me!', 'More Slaves? How fortunate for you to deliver yourself to me!', 1, 60523, 0, 0, 0, 0, 0, 0, 0),
     (1999893, 'Get into order, maggots!', 'Get into order, maggots!', 1, 60524, 0, 0, 0, 0, 0, 0, 0),
     (1999894, 'Overlord Blackheart begins to laugh maniacally.', 'Overlord Blackheart begins to laugh maniacally.', 2, 60525, 0, 0, 0, 0, 0, 0, 0),
     (1999886, 'I have been tasked to keep our sacred flame, do not test me!', 'I have been tasked to keep our sacred flame, do not test me!', 1, 60492, 0, 0, 0, 0, 0, 0, 0),
     (1999887, 'You have no place here!', 'You have no place here!', 1, 60493, 0, 0, 0, 0, 0, 0, 0),
     (1999888, 'My duty... Is failed...', 'My duty... Is failed...', 1, 60494, 0, 0, 0, 0, 0, 0, 0),
     (1999929, 'This canyon will make for excellent hunting!', 'This canyon will make for excellent hunting!', 1, 60663, 0, 0, 0, 0, 0, 0, 0),
     (1999930, 'You shall be crushed!', 'You shall be crushed!', 1, 60664, 0, 0, 0, 0, 0, 0, 0),
     (1999931, 'I travel to the great beyond...', 'I travel to the great beyond...', 1, 60665, 0, 0, 0, 0, 0, 0, 0),
     (1999942, 'Our destiny has been foretold!', 'Our destiny has been foretold!', 1, 60669, 0, 0, 0, 0, 0, 0, 0),
     (1999943, 'I have seen the future, and it is your death!', 'I have seen the future, and it is your death!', 1, 60670, 0, 0, 0, 0, 0, 0, 0),
     (1999944, 'My sight, has left me!', 'My sight, has left me!', 1, 60671, 0, 0, 0, 0, 0, 0, 0),
     (1999932, 'Behold the howling wind!', 'Behold the howling wind!', 1, 60676, 0, 0, 0, 0, 0, 0, 0),
     (1999933, 'We seek unity...', 'We seek unity...', 1, 60677, 0, 0, 0, 0, 0, 0, 0),
     (1999934, 'Disperse...', 'Disperse...', 1, 60678, 0, 0, 0, 0, 0, 0, 0),
     (1999935, 'Be destroyed by my hands!', 'Be destroyed by my hands!', 1, 60666, 0, 0, 0, 0, 0, 0, 0),
     (1999936, 'Enough!', 'Enough!', 1, 60667, 0, 0, 0, 0, 0, 0, 0),
     (1999937, 'This cannot... be...', 'This cannot... be...', 1, 60668, 0, 0, 0, 0, 0, 0, 0),
     (1999991, 'I have seen da future, and you aint in it!', 'I have seen da future, and you aint in it!', 1, 60711, 0, 0, 0, 0, 0, 0, 0),
     (1999990, 'The Frostmane be da strongest, be da fiercest! Dis be our home, you think you can mess wit us?', 'The Frostmane be da strongest, be da fiercest! Dis be our home, you think you can mess wit us?', 1, 60710, 0, 0, 0, 0, 0, 0, 0),
     (1999989, 'Tansha, kill them all!', 'Tansha, kill them all!', 1, 60709, 0, 0, 0, 0, 0, 0, 0)
ON DUPLICATE KEY UPDATE `male_text` = VALUES(`male_text`), `female_text` = VALUES(`female_text`),
    `chat_type` = VALUES(`chat_type`), `sound_id` = VALUES(`sound_id`), `language_id` = VALUES(`language_id`),
    `emote_id1` = VALUES(`emote_id1`);

UPDATE `creature_ai_scripts` SET `dataint` = 1999940 WHERE `id` = 6141001 AND `dataint` = -1999940;
UPDATE `creature_ai_scripts` SET `dataint` = 1999889 WHERE `id` = 6203801 AND `dataint` = -1999889;
UPDATE `creature_ai_scripts` SET `dataint` = 1999890 WHERE `id` = 6203802 AND `dataint` = -1999890;
UPDATE `creature_ai_scripts` SET `dataint` = 1999891 WHERE `id` = 6203803 AND `dataint` = -1999891;
UPDATE `creature_ai_scripts` SET `dataint` = 1999883 WHERE `id` = 6206701 AND `dataint` = -1999883;
UPDATE `creature_ai_scripts` SET `dataint` = 1999884 WHERE `id` = 6206702 AND `dataint` = -1999884;
UPDATE `creature_ai_scripts` SET `dataint` = 1999885 WHERE `id` = 6206703 AND `dataint` = -1999885;
UPDATE `creature_ai_scripts` SET `dataint` = 1999895 WHERE `id` = 6206801 AND `dataint` = -1999895;
UPDATE `creature_ai_scripts` SET `dataint` = 1999896 WHERE `id` = 6206802 AND `dataint` = -1999896;
UPDATE `creature_ai_scripts` SET `dataint` = 1999897 WHERE `id` = 6206803 AND `dataint` = -1999897;
UPDATE `creature_ai_scripts` SET `dataint` = 1999892 WHERE `id` = 6207001 AND `dataint` = -1999892;
UPDATE `creature_ai_scripts` SET `dataint` = 1999893 WHERE `id` = 6207002 AND `dataint` = -1999893;
UPDATE `creature_ai_scripts` SET `dataint` = 1999894 WHERE `id` = 6207003 AND `dataint` = -1999894;
UPDATE `creature_ai_scripts` SET `dataint` = 1999886 WHERE `id` = 6207101 AND `dataint` = -1999886;
UPDATE `creature_ai_scripts` SET `dataint` = 1999887 WHERE `id` = 6207102 AND `dataint` = -1999887;
UPDATE `creature_ai_scripts` SET `dataint` = 1999888 WHERE `id` = 6207103 AND `dataint` = -1999888;
UPDATE `creature_ai_scripts` SET `dataint` = 1999929 WHERE `id` = 6277902 AND `dataint` = -1999929;
UPDATE `creature_ai_scripts` SET `dataint` = 1999930 WHERE `id` = 6277903 AND `dataint` = -1999930;
UPDATE `creature_ai_scripts` SET `dataint` = 1999931 WHERE `id` = 6277904 AND `dataint` = -1999931;
UPDATE `creature_ai_scripts` SET `dataint` = 1999942 WHERE `id` = 6278101 AND `dataint` = -1999942;
UPDATE `creature_ai_scripts` SET `dataint` = 1999943 WHERE `id` = 6278102 AND `dataint` = -1999943;
UPDATE `creature_ai_scripts` SET `dataint` = 1999944 WHERE `id` = 6278103 AND `dataint` = -1999944;
UPDATE `creature_ai_scripts` SET `dataint` = 1999932 WHERE `id` = 6278302 AND `dataint` = -1999932;
UPDATE `creature_ai_scripts` SET `dataint` = 1999933 WHERE `id` = 6278303 AND `dataint` = -1999933;
UPDATE `creature_ai_scripts` SET `dataint` = 1999934 WHERE `id` = 6278304 AND `dataint` = -1999934;
UPDATE `creature_ai_scripts` SET `dataint` = 1999935 WHERE `id` = 6278402 AND `dataint` = -1999935;
UPDATE `creature_ai_scripts` SET `dataint` = 1999936 WHERE `id` = 6278403 AND `dataint` = -1999936;
UPDATE `creature_ai_scripts` SET `dataint` = 1999937 WHERE `id` = 6278404 AND `dataint` = -1999937;
UPDATE `creature_ai_scripts` SET `dataint` = 1999991 WHERE `id` = 6312901 AND `dataint` = -1999991;
UPDATE `creature_ai_scripts` SET `dataint` = 1999990 WHERE `id` = 6313102 AND `dataint` = -1999990;
UPDATE `creature_ai_scripts` SET `dataint` = 1999989 WHERE `id` = 6313201 AND `dataint` = -1999989;

