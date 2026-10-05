-- 聊天频道名（chat_channels）
--
-- 共 7 条，只写 name_loc4（简体中文）列，这些列原本全部为空。
-- 译文遵守魔兽官方术语（例：traveler -> 旅行者，seal -> 圣印）。

SET NAMES utf8mb4;

UPDATE `chat_channels` SET `name_loc4` = '综合 - %s', `shortcut_loc4` = '综合' WHERE `id` = 1;
UPDATE `chat_channels` SET `name_loc4` = '交易 - %s', `shortcut_loc4` = '交易' WHERE `id` = 2;
UPDATE `chat_channels` SET `name_loc4` = '本地防务 - %s', `shortcut_loc4` = '本地防务' WHERE `id` = 22;
UPDATE `chat_channels` SET `name_loc4` = '世界防务', `shortcut_loc4` = '世界防务' WHERE `id` = 23;
UPDATE `chat_channels` SET `name_loc4` = '寻求组队', `shortcut_loc4` = '寻求组队' WHERE `id` = 24;
UPDATE `chat_channels` SET `name_loc4` = '公会招募 - %s', `shortcut_loc4` = '公会招募' WHERE `id` = 25;
UPDATE `chat_channels` SET `name_loc4` = '世界', `shortcut_loc4` = '世界' WHERE `id` = 27;

