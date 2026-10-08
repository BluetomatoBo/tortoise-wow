-- ==============================================
-- FILE: redundant_proc_and_threat_rows.sql
-- GENERATED: 20261008153000
-- ==============================================
-- 启动时这两类「数据多余」的报错：行里那一列等于没写，清掉行为逐字不变。
--
-- 1) `spell_proc_event`.`procFlags` 与技能自己的 procFlags 完全相同时，内核报
--    "has exactly same proc flags as in spell.dbc, field value redundant"。
--    注意它比对的「技能自己的」来自 `spell_template` 而不是 Spell.dbc ——
--    本核心的技能数据是从世界库这张表读的（SpellMgr::LoadSpellTemplate）。
--    运行时取值（UnitAuraProcHandler）是
--        EventProcFlag = spellProcEvent->procFlags ? spellProcEvent->procFlags : spellProto->procFlags
--    也就是「0 = 不覆盖，用技能自己的」，所以清成 0 与现在完全等价；
--    行里其它列（SpellFamilyName/Mask、procEx、Cooldown）全部保留 —— 那才是这些行存在的理由。
--
--    用 JOIN 现算而不是写死编号：只动「确实等于该技能自身 procFlags」的行，
--    任何真正在覆盖技能数据的行都碰不到。可重复执行（第二次没有行满足条件）。
--
-- 2) `spell_threat` 25918：它是某条技能链上的第 2 级（仓库快照里属 25894 链），数据与所在链
--    第 1 级完全相同（内核判定 redundant）——删除后由第 1 级自动填充，结果相同。仓库里 20260815005950_world.sql
--    （redundant_spell_threat.sql）本来就删过它，这里再删一次：线上库它还在，
--    说明那一份更新没落到这个库上。同一份文件里的 51600/51601/51602 不在这次的日志里，
--    没有证据说明它们在这台服务器上也多余，就不动。
--
-- 生效：mangosd 控制台 `.reload spell_proc_event` / `.reload spell_threats`（或重启）

UPDATE `spell_proc_event` `e`
  JOIN `spell_template` `s` ON `s`.`entry` = `e`.`entry`
   SET `e`.`procFlags` = 0
 WHERE `e`.`procFlags` <> 0 AND `e`.`procFlags` = `s`.`procFlags`;

DELETE FROM `spell_threat` WHERE `entry` = 25918;
