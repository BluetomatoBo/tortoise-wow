-- ==============================================
-- FILE: startup_log_cleanup_e.sql
-- GENERATED: 20261008170000
-- ==============================================
-- 17:32 启动日志里剩下、能确定的最后一小批：
--   4) spell_threat / 未赋值的 7 个注册脚本 / 拾取-剥皮悬空 loot id 等，需要你库里的具体行才能定，见报告。
--   1) gameobject_loot_template 5000124：既不是任何 gameobject 的 lootid，也没被别的掉落表引用
--      （内核自己报「useless」）→ 删。
DELETE FROM `gameobject_loot_template` WHERE `entry` = 5000124;

--   2) npc_trainer 5807：5807 是「The Rake」（一只可驯服的迅猛龙宠物），没有训练师标记、
--      trainer_type=0，1.12 里也没有它的训练表行 → 这行（教 17253）是误挂的死数据 → 删。
DELETE FROM `npc_trainer` WHERE `entry` = 5807;

--   3) 19 个「Script not found」的 script_name：这些名字在本仓库源码里逐字搜都搜不到（脚本根本不存在），
--      内核每次启动都报「Script not found」，等价于这些生物/物件/物品/法术的 script_name 是空的。
--      把名字清成空串（内核判断「没有脚本」用的就是 script_name <> ''），行为完全不变。
--      注意：at_moonwhisper_missing_caravans 不在这里——它是内核自己注册过的 AreaTrigger 脚本，
--      那条报错是上游那段检查只看 creature 脚本注册表造成的误报（详见本次会话报告），不动数据。
UPDATE `creature_template` SET `script_name` = '' WHERE `script_name` IN (
    '0',
    'npc_kitten',
    'npc_lady_ripper',
    'npc_teslinah',
    'npc_alexandros_mograine',
    'npc_chromie_dialogue',
    'npc_breanna_darrowmont',
    'npc_chieftain_icepaw',
    'npc_frostshiv',
    'npc_nasuna',
    'npc_surgeon_go',
    'npc_distance_trigger',
    'spell_druid_wrath',
    'item_radio',
    'item_temporal_bronze_disc',
    'go_airplane',
    'go_curious_leaf',
    'custom_dungeon_portal',
    'duplicate_tirion_fordring'
);
UPDATE `gameobject_template` SET `script_name` = '' WHERE `script_name` IN (
    '0',
    'npc_kitten',
    'npc_lady_ripper',
    'npc_teslinah',
    'npc_alexandros_mograine',
    'npc_chromie_dialogue',
    'npc_breanna_darrowmont',
    'npc_chieftain_icepaw',
    'npc_frostshiv',
    'npc_nasuna',
    'npc_surgeon_go',
    'npc_distance_trigger',
    'spell_druid_wrath',
    'item_radio',
    'item_temporal_bronze_disc',
    'go_airplane',
    'go_curious_leaf',
    'custom_dungeon_portal',
    'duplicate_tirion_fordring'
);
UPDATE `item_template` SET `script_name` = '' WHERE `script_name` IN (
    '0',
    'npc_kitten',
    'npc_lady_ripper',
    'npc_teslinah',
    'npc_alexandros_mograine',
    'npc_chromie_dialogue',
    'npc_breanna_darrowmont',
    'npc_chieftain_icepaw',
    'npc_frostshiv',
    'npc_nasuna',
    'npc_surgeon_go',
    'npc_distance_trigger',
    'spell_druid_wrath',
    'item_radio',
    'item_temporal_bronze_disc',
    'go_airplane',
    'go_curious_leaf',
    'custom_dungeon_portal',
    'duplicate_tirion_fordring'
);
UPDATE `spell_template` SET `script_name` = '' WHERE `script_name` IN (
    '0',
    'npc_kitten',
    'npc_lady_ripper',
    'npc_teslinah',
    'npc_alexandros_mograine',
    'npc_chromie_dialogue',
    'npc_breanna_darrowmont',
    'npc_chieftain_icepaw',
    'npc_frostshiv',
    'npc_nasuna',
    'npc_surgeon_go',
    'npc_distance_trigger',
    'spell_druid_wrath',
    'item_radio',
    'item_temporal_bronze_disc',
    'go_airplane',
    'go_curious_leaf',
    'custom_dungeon_portal',
    'duplicate_tirion_fordring'
);
UPDATE `scripted_areatrigger` SET `script_name` = '' WHERE `script_name` IN (
    '0',
    'npc_kitten',
    'npc_lady_ripper',
    'npc_teslinah',
    'npc_alexandros_mograine',
    'npc_chromie_dialogue',
    'npc_breanna_darrowmont',
    'npc_chieftain_icepaw',
    'npc_frostshiv',
    'npc_nasuna',
    'npc_surgeon_go',
    'npc_distance_trigger',
    'spell_druid_wrath',
    'item_radio',
    'item_temporal_bronze_disc',
    'go_airplane',
    'go_curious_leaf',
    'custom_dungeon_portal',
    'duplicate_tirion_fordring'
);
UPDATE `scripted_event_id` SET `script_name` = '' WHERE `script_name` IN (
    '0',
    'npc_kitten',
    'npc_lady_ripper',
    'npc_teslinah',
    'npc_alexandros_mograine',
    'npc_chromie_dialogue',
    'npc_breanna_darrowmont',
    'npc_chieftain_icepaw',
    'npc_frostshiv',
    'npc_nasuna',
    'npc_surgeon_go',
    'npc_distance_trigger',
    'spell_druid_wrath',
    'item_radio',
    'item_temporal_bronze_disc',
    'go_airplane',
    'go_curious_leaf',
    'custom_dungeon_portal',
    'duplicate_tirion_fordring'
);
UPDATE `map_template` SET `script_name` = '' WHERE `script_name` IN (
    '0',
    'npc_kitten',
    'npc_lady_ripper',
    'npc_teslinah',
    'npc_alexandros_mograine',
    'npc_chromie_dialogue',
    'npc_breanna_darrowmont',
    'npc_chieftain_icepaw',
    'npc_frostshiv',
    'npc_nasuna',
    'npc_surgeon_go',
    'npc_distance_trigger',
    'spell_druid_wrath',
    'item_radio',
    'item_temporal_bronze_disc',
    'go_airplane',
    'go_curious_leaf',
    'custom_dungeon_portal',
    'duplicate_tirion_fordring'
);
