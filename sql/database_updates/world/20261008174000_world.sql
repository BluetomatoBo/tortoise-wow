-- ==============================================
-- FILE: cleanup_after_basedump_merge.sql
-- GENERATED: 20261008174000
-- ==============================================
-- 补完 base dump 缺口的善后（两件事）：
--
-- 1) creature_movement：补数据脚本把仓库里那两条「孤儿路径」又插回来了，而且我的 161000
--    当时把 2581433 那一条改指成了 2581434（同一出生点对，路径起点离 2581434 只有 0.46 码、离 2581433 有 136 码），
--    于是现在同一个出生点对有两份路径。处理：
--      * 删掉旧的 2581433 那行（保留 2581434，并把它的巡逻打开）；
--      * 2593426 那 45 点路径本来属于出生点 2700777（起点就在它脚下 4.35 码）：如果 2700777 现在存在，
--        就把路径改指过去并让它巡逻（这样是把数据救回来）；不存在就删掉这条无主路径。
DELETE FROM `creature_movement` WHERE `id` = 2581433
  AND EXISTS (SELECT 1 FROM (SELECT `id` FROM `creature_movement` WHERE `id` = 2581434) x);
UPDATE `creature` SET `movement_type` = 2
 WHERE `guid` = 2581434 AND `movement_type` <> 2
   AND EXISTS (SELECT 1 FROM (SELECT `id` FROM `creature_movement` WHERE `id` = 2581434) y);

UPDATE `creature_movement` SET `id` = 2700777
 WHERE `id` = 2593426
   AND EXISTS (SELECT 1 FROM (SELECT `guid` FROM `creature` WHERE `guid` = 2700777) x)
   AND NOT EXISTS (SELECT 1 FROM (SELECT `id` FROM `creature_movement` WHERE `id` = 2700777) y);
UPDATE `creature` SET `movement_type` = 2
 WHERE `guid` = 2700777 AND `movement_type` <> 2
   AND EXISTS (SELECT 1 FROM (SELECT `id` FROM `creature_movement` WHERE `id` = 2700777) z);
-- 目标出生点不存在 → 这条路径没有主人，删掉（否则会每只都报「path for creature guid ... does not exist」）
DELETE FROM `creature_movement` WHERE `id` = 2593426
  AND NOT EXISTS (SELECT 1 FROM (SELECT `guid` FROM `creature` WHERE `guid` = 2700777) x);

-- 2) 刚补进来的两条物件任务关系指向的任务在你库和仓库里都不存在（quest 40751 / 40750），
--    内核加载时会报 `Quest 40751 listed for entry 2010969 does not exist.` 并跳过 —— 这两行永远不会生效，删掉。
DELETE FROM `gameobject_questrelation`   WHERE `id` = 2010969 AND `quest` = 40751;
DELETE FROM `gameobject_involvedrelation` WHERE `id` = 2010969 AND `quest` = 40750;
