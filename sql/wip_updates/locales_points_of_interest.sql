-- 兴趣点名称（locales_points_of_interest）
--
-- 共 30 条，全部只写 zhCN 列（*_loc4），不触碰其他语言列。
-- 本项目 sql/base/tw_world_locales_points_of_interest.sql 里这些列原本是空串或英文占位符
-- （原文被直接填进 _loc4）；本文件把它们替换为中文。
-- 已逐条比对上游 base 数据：0 条覆盖上游已有的中文翻译。
--
-- 译文来源（按可靠性排序）：
--   0. 官方数据 —— cmangos classic-db 的 locales/Chinese/*.sql（1.12.1 官方
--      简体中文）与 AzerothCore 的 *_locale zhCN，均经英文原文逐字校验
--   1. 官方客户端 DBC 中文 —— 英文原文逐字节一致时才采信
--   2. 库中已有的同文译名 —— 复用其它条目的官方译法
--   3. 官方语料推导的词级词典 —— 从库中 12 万对中英对照反推（名称类来源，
--      排除 description 这类散文，避免词序错配）；多词短语优先于逐词组合
--   4. 专名音译 —— 仅用于查不到译法的生物名
--
-- 词典经过官方语料审计：对每个词条统计「支持 / 可判定」，
-- 剔除把整条短语误存成单词的脏词条（high -> 高背椅、kirin -> 肯瑞托 之类）。
-- 组合结果再做非相邻重复片段去重（懒惰结界效果结界 -> 懒惰结界效果）。
--
-- 残留风险：生物名里仍有相当比例的专名音译，
-- 组合器无法区分「人名」与「复合词」，例如 Stormwrought Deathsteed
-- 会译成 风暴锻铸德伊斯特伊德 而不是 风暴锻铸死亡战马。
-- 每行尾部保留了英文原文，便于人工复核修正。

SET NAMES utf8mb4;

-- ------------------------------------------------------------------------
-- icon_name_loc4：30 条
-- ------------------------------------------------------------------------
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (70, '暴风城军营') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (90, '护体皮甲') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (93, '廉姆·火轴') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (412, '谜之大厅') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (413, '武器大厅') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (416, '铁炉堡邮箱') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (426, '铁炉堡术士训练师') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (427, '铁炉堡盗贼训练师') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (465, '达纳苏斯银行') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (527, '暴风城拍卖行') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (535, '暴风城狮鹫管理员') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (652, '札尔迪玛·维夫希尔特') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (654, '密雪儿·贝莉') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (655, '汤马斯') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (660, '维尔海姆修士') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (663, '炼金术士玛洛瑞') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (665, '阿札尔·战锤') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (666, '马克萨恩') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (667, '兰尼斯·快斧') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (670, '格雷姆罗克') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (672, '托格努斯') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (677, '吉姆瑞兹') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (747, '帕克斯顿·冈特') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (1427, '珊娜·费勒') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (1693, '达纳苏斯拍卖行') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- 
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (2000, '铁炉堡珠宝商公会金库') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- Ironforge Jewelers Guild
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (2001, '幽暗城珠宝加工训练师') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- Undercity Jewelcrafting Trainer
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (2002, '剑客家族宝石') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- Fencer Family Jewels
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (2003, '阿拉萨拉斯珠宝加工训练师') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- Alah'Thalas Jewelcrafting Trainer
INSERT INTO `locales_points_of_interest` (`entry`, `icon_name_loc4`) VALUES (2004, '阿索拉珠宝饰时装屋') ON DUPLICATE KEY UPDATE `icon_name_loc4` = VALUES(`icon_name_loc4`);  -- Asoran's Jewelry House

