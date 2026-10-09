-- ==============================================
-- FILE: fix_last_two_ai_scripts.sql
-- GENERATED: 20261008205000
-- ==============================================
-- 最后两条 `CreatureEventAI: Event N has a non-existent script = N in actionN_script.`
-- 查证后一条「删」、一条「补」：
--
-- 1) 899705  Genn Greymane（61418）「Say at 50% HP」——**多余的事件，删掉**。
--    他的 50% 血量台词由 C++ 脚本直接完成：
--      src/scripts/dungeons/gilneas_city/instance_gilneas_city.cpp 的 genn_greymaneAI：
--        if (m_creature->GetHealthPercent() < 50.0f && !event50PercentHP)
--            DoScriptText(81055, m_creature)；
--    而 AI 选择器（src/game/AI/CreatureAISelector.cpp:44-46）**优先使用 C++ 脚本**，
--    所以这条 EventAI 事件从来不会执行，只是加载时被校验、报出缺脚本。
--    （文本 81055「Our nation stands strong! I did what was neccesary.」在仓库里已有中文：
--      locales_broadcast_text 81055 male_text_loc4）
--    → 删掉事件本身；守卫「该生物确实挂着 script_name」，万一以后脚本被移除，事件会保留。
DELETE FROM `creature_ai_events`
 WHERE `id` = 899705 AND `creature_id` = 61418
   AND EXISTS (SELECT 1 FROM (SELECT `entry` FROM `creature_template`
                 WHERE `entry` = 61418 AND `script_name` <> '') x);

-- 2) 1069602  Refuge Pointe Defender（10696）「Emote Talk OOC」——**按 1.12 官方库的同类脚本补上**。
--    乌龟 dump 与 1.12 vmangos dump 里都没有这个 id 的行，但 1.12 官方库（mangoszero/database，
--    World/Setup/FullDB/creature_ai_scripts.sql）里同一种脚本写得很清楚：
--      'Argent Recruiter - Talk Emote OOC'  →  动作 = 做「talk」表情（emote id 1 = EMOTE_ONESHOT_TALK），
--      'Argent Emissary - Talk Emote OOC'      脱战定时 6-9 秒触发（与本库事件 1069602 的参数一致）
--      'Stomper Kreeg - Start/Stop Dance Emote OOC' 也是同一套路，只是换了表情 id
--    按本内核的脚本命令格式译为：command = 1 (SCRIPT_COMMAND_EMOTE)、datalong = 1 (talk)。
--    事件参数（event_type=1 TIMER_OOC、param1..4 = 6000/9000/6000/9000）保持不动。
--    creature_ai_scripts 没有主键，所以用 NOT EXISTS 守卫，重复执行不会插重复行。
INSERT INTO `creature_ai_scripts`
  (`id`, `delay`, `priority`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`,
   `target_param1`, `target_param2`, `target_type`, `data_flags`,
   `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `condition_id`, `comments`)
SELECT '1069602', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0',
       '0', '0', '0', '0', '0', '0', '0', '0', '0',
       'Refuge Pointe Defender - Emote Talk OOC (talk emote, per mangoszero 1.12 pattern)'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM (SELECT `id` FROM `creature_ai_scripts` WHERE `id` = 1069602) y);
