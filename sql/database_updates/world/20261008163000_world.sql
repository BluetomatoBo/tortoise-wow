-- ==============================================
-- FILE: ai_scripts_restore.sql
-- GENERATED: 20261008163000
-- ==============================================
-- 启动日志：`CreatureEventAI: Event N has a non-existent script = N in action1_script`（5 行里能补的 3 行）
--   * 185202 / 1007801：本仓库 base dump 里就有这两条脚本（Araj the Summoner 出生时放霜甲、Terrorspark
--     出生/仇恨时放火盾），线上库缺的是这两行 → 原样补回；
--   * 799901（Tyrande Whisperwind - Play Sound 5885 on Aggro）：1.12 官方 dump 里同 id 的脚本是
--     action1_type=4(Play Sound)/参数 5885，注释与本仓库事件行一模一样 → 按内核的
--     SCRIPT_COMMAND_PLAY_SOUND(16)（datalong=sound_id）译过来。
--   * 余下 899705（Genn Greymane - Say at 50% HP，缺的是台词 id）与 1069602（Refuge Pointe Defender -
--     Emote Talk OOC）：两个数据源里都没有对应记录，无法凭空补 → 见报告。

-- creature_ai_scripts 这张表没有主键，所以逐条用 NOT EXISTS 守卫，重复执行不会插重复行
INSERT INTO `creature_ai_scripts` (`id`, `delay`, `priority`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `target_param1`, `target_param2`, `target_type`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `condition_id`, `comments`) SELECT '185202', '0', '0', '15', '12556', '3', '0', '0', '0', '0', '1', '4', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'Araj the Summoner - Cast Spell Frost Armor' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM `creature_ai_scripts` WHERE `id` = 185202);
INSERT INTO `creature_ai_scripts` (`id`, `delay`, `priority`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `target_param1`, `target_param2`, `target_type`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `condition_id`, `comments`) SELECT '1007801', '0', '0', '15', '11966', '1', '0', '0', '0', '0', '1', '4', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'Terrorspark - Cast Spell Fire Shield' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM `creature_ai_scripts` WHERE `id` = 1007801);
INSERT INTO `creature_ai_scripts` (`id`, `delay`, `priority`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `target_param1`, `target_param2`, `target_type`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `condition_id`, `comments`) SELECT '799901', '0', '0', '16', '5885', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'Tyrande Whisperwind - Play Sound 5885 on Aggro (按 1.12 dump 同 id 记录译成 SCRIPT_COMMAND_PLAY_SOUND)' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM `creature_ai_scripts` WHERE `id` = 799901);
