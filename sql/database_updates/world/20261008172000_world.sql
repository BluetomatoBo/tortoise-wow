-- ==============================================
-- FILE: script_assignment_part2.sql
-- GENERATED: 20261008172000
-- ==============================================
-- 接 171000，补第二个能确定的脚本赋值：
--   npc_daily_hk_dk —— 本仓库 base/增量里，creature_template entry 60053「Michael Duguder」
--   正好就写着 script_name = 'npc_daily_hk_dk'（线上库里这一列是空的，所以内核报「注册了但库里没赋值」）。
--   只在当前为空时写，幂等。
UPDATE `creature_template` SET `script_name` = 'npc_daily_hk_dk'
 WHERE `entry` = 60053 AND (`script_name` IS NULL OR `script_name` = '');
