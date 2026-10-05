-- 新增的 broadcast_text 行（broadcast_text）
--
-- 只加一条：npc_text 11031 的文本载体。
--
-- 为什么需要新增而不是复用：core 的 Creature::IsTrainerOf 在
-- TRAINER_TYPE_TRADESKILLS 分支里把 npc_text 11031 写死，而该 ID 在任何
-- 数据源里都不存在（我们的库、1.17 泄露库、cmangos 1.12 官方库、AzerothCore
-- 3.3.5 全都没有），原文不可复原。105 行附近的官方 npc_text 用的是
-- 「去哪学某个专业」的引导语，与该分支「你还没掌握本行基础」的语义不符。
--
-- 故新建一条语义相符的文本。**英文与中文均为自撰，非暴雪官方文本**，
-- 用 8900001 这个自有 ID 段，避免与官方/乌龟服数据冲突。
--
-- 另外两条训练师文本（3620 / 10090）不需要新建：它们复用已有的
-- broadcast_text 8407（宠物训练师拒绝语），该条已有官方中文。

SET NAMES utf8mb4;

INSERT INTO `broadcast_text` (`entry`, `male_text`, `female_text`, `chat_type`)
VALUES (8900001, 'I can only train those who already know the trade.', '', 0)
ON DUPLICATE KEY UPDATE `male_text` = VALUES(`male_text`);

INSERT INTO `locales_broadcast_text` (`entry`, `male_text_loc4`)
VALUES (8900001, '我只能训练已经掌握本行技艺的人。')
ON DUPLICATE KEY UPDATE `male_text_loc4` = VALUES(`male_text_loc4`);
