-- ==============================================
-- FILE: restore_page_text_50880.sql
-- GENERATED: 20261008211000
-- ==============================================
-- 补回物品 41914「Shadowlord’s Research」（暗影领主的研究）缺失的书页正文。
--
-- 背景：该物品的 page_text = 50880，但 page_text 表里没有这一行（仓库 dump 里 50700~50944 是
-- 连续的一整段 Turtle 文本，只缺 50880；1.12 的两个库、客户端 DBC 也都没有）。内核因此报
-- `Item (Entry: 41914) has non existing first page (Id:50880)`，右键阅读无任何反应。
--
-- 正文来源：Turtle WoW 官方 wiki（turtle-wow.fandom.com/wiki/Shadowlord%27s_Research），
-- 1.18.0 加入的内容；wiki 同时说明该物品由 Noppsy Spickerspan 在完成 Harrowing News 后给予，
-- 内容是 Shadowlord Ar’kor 身上「Stormreaver Scroll」的译本。正文按 wiki 原文逐字录入。
--
-- 同时补上中文（locales_page_text.Text_loc4），专有名词与本库既有译名保持一致：
--   Nagaz → 纳伽兹（本库 locales_creature 2320 已有此译名）
--   Stormreaver → 风暴掠夺者；Bloodstone → 血石；Mergothid the All-Seeing → 全视者梅尔戈提德
--   物品名 Shadowlord’s Research → 暗影领主的研究（写入 locales_item.name_loc4）

-- 1) 英文正文（page_text）——已存在则跳过
INSERT INTO `page_text` (`entry`, `text`, `next_page`)
SELECT 50880, 'Our progress is undeniable. The essence drained from these spineless vermin grows with each successful experiment. Soon we will have enough to usher in a new age for the Stormreaver. Our masters in the ordained halls will open the rift and allow the true overlords to enter this rotten world. All thanks to the Bloodstone. Nagaz did excellent in securing it from these foolish human mages, like hapless whelps did they try understanding the great power of this almighty relic.\\r\\n\\r\\nSoon Mergothid the All-Seeing will grace us with his presence. We will bask in his glory and eradicate the non-believers in the name of the Master!', 0 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM (SELECT `entry` FROM `page_text` WHERE `entry` = 50880) x);

-- 2) 本地化行（locales_page_text）：Text_loc0 = 英文原文，Text_loc4 = 简体中文
INSERT INTO `locales_page_text` (`entry`, `Text_loc0`, `Text_loc4`)
SELECT 50880, 'Our progress is undeniable. The essence drained from these spineless vermin grows with each successful experiment. Soon we will have enough to usher in a new age for the Stormreaver. Our masters in the ordained halls will open the rift and allow the true overlords to enter this rotten world. All thanks to the Bloodstone. Nagaz did excellent in securing it from these foolish human mages, like hapless whelps did they try understanding the great power of this almighty relic.\\r\\n\\r\\nSoon Mergothid the All-Seeing will grace us with his presence. We will bask in his glory and eradicate the non-believers in the name of the Master!', '我们的进展无可辩驳。每一次成功的实验，都让从这些毫无骨气的害虫身上榨取的精华愈发充盈。很快，我们就能为风暴掠夺者开启一个崭新的时代。安坐于圣职之殿的主人们将打开裂隙，让真正的霸主踏入这个腐朽的世界。这一切都要归功于血石。纳伽兹干得漂亮——他从那些愚蠢的人类法师手中夺得此物，那些可怜虫竟妄想参透这件全能圣物的伟大力量。$B$B很快，全视者梅尔戈提德就将降临于此。我们将沐浴在他的荣光之中，以主人之名铲除所有不信者！' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM (SELECT `entry` FROM `locales_page_text` WHERE `entry` = 50880) y);

-- 若该行已存在（例如你们后来自己补过），只在中文列为空时补中文，不覆盖已有译文
UPDATE `locales_page_text`
   SET `Text_loc4` = '我们的进展无可辩驳。每一次成功的实验，都让从这些毫无骨气的害虫身上榨取的精华愈发充盈。很快，我们就能为风暴掠夺者开启一个崭新的时代。安坐于圣职之殿的主人们将打开裂隙，让真正的霸主踏入这个腐朽的世界。这一切都要归功于血石。纳伽兹干得漂亮——他从那些愚蠢的人类法师手中夺得此物，那些可怜虫竟妄想参透这件全能圣物的伟大力量。$B$B很快，全视者梅尔戈提德就将降临于此。我们将沐浴在他的荣光之中，以主人之名铲除所有不信者！'
 WHERE `entry` = 50880 AND (`Text_loc4` IS NULL OR `Text_loc4` = '' OR `Text_loc4` = 'NULL');

-- 3) 物品的中文名（只在尚无中文名时写入）
INSERT INTO `locales_item` (`entry`, `name_loc4`)
SELECT 41914, '暗影领主的研究' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM (SELECT `entry` FROM `locales_item` WHERE `entry` = 41914) z);

