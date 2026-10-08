-- ==============================================
-- FILE: script_assignment_part1.sql
-- GENERATED: 20261008171000
-- ==============================================
-- 7 个「内核注册了、但库里没有任何行引用」的脚本，先补能确定的那一个：
--   spell_hunter_alone_against_the_world（src/scripts/spells/spell_hunter.cpp:1090 注册的 AuraScript）
--   对应法术是 52891 / 52892「Alone Against the World」（你库里查到的两条），
--   和仓库里 20260721013813 那份 spell_script_assignment.sql 的写法一致（同一条链的所有 rank 都写上）。
--   只在 script_name 还是空的时候写，避免覆盖你们已有的赋值；幂等。
UPDATE `spell_template` SET `script_name` = 'spell_hunter_alone_against_the_world'
 WHERE `entry` IN (52891, 52892) AND (`script_name` IS NULL OR `script_name` = '');
