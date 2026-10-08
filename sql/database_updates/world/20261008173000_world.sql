-- ==============================================
-- FILE: spell_threat_empty_rank1.sql
-- GENERATED: 20261008173000
-- ==============================================
-- 最后一条「redundant」报错：
--   Spell 25918 listed in `spell_threat` as custom rank has same data as Rank 1, so redundant
--   线上 25800~26000 区间现在只剩 6 行，25918 已经不在表里了，但报错还会出现（内核是拿「链首」那一行的数据
--   往下填 high rank 时撞见已有同样的数据才会报）。链首 25894 那行是 (Threat=0, multiplier=0, ap_bonus=0)，
--   也就是「什么都不改」的空数据行：删掉它之后，整条链不再进入这条检查，运行时行为逐字不变
--   （威胁/倍率取默认值，本来就是 0/0，和有没有这行完全一样）。
--   守卫：只有当它确实还是全 0 的空数据行时才删，万一线上那行被填过真数据就跳过。
DELETE FROM `spell_threat`
 WHERE `entry` = 25894 AND `Threat` = 0 AND `multiplier` = 0 AND `ap_bonus` = 0;
