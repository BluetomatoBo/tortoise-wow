-- 乌龟服新内容的实体中文名（locales_creature / locales_gameobject / locales_item）
--
-- 先查过现有数据：base + database_updates + 本仓库已提交的 wip_updates/locales_*.sql，
-- 绝大多数新内容的名字早就有中文；只有下面这些在任何来源里都没有中文名，才需要补。
-- （`quest_*_dummy_triger` 这类玩家看不到的任务触发标记不在其中，故意不译。）
--
-- 保护：只在该列**当前没有汉字**时才写入，绝不覆盖已有的官方/既有译文。
-- 生效：mangosd 控制台 `.reload locales_creature` / `.reload locales_gameobject` / `.reload locales_item`

SET NAMES utf8mb4;

-- ---- locales_creature（7 条）----
INSERT INTO `locales_creature` (`entry`, `name_loc4`)
  SELECT 61987, '阿克资阿多' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_creature` WHERE `entry` = 61987) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_creature` (`entry`, `name_loc4`)
  SELECT 62031, '马蒂亚斯·明心' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_creature` WHERE `entry` = 62031) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_creature` (`entry`, `name_loc4`)
  SELECT 62525, '军情七处斥候' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_creature` WHERE `entry` = 62525) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_creature` (`entry`, `name_loc4`)
  SELECT 62588, '乌达佩·阳草' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_creature` WHERE `entry` = 62588) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_creature` (`entry`, `name_loc4`)
  SELECT 62590, '基尔罗格·死眼' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_creature` WHERE `entry` = 62590) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_creature` (`entry`, `name_loc4`)
  SELECT 62752, '巡山人麦冠' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_creature` WHERE `entry` = 62752) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_creature` (`entry`, `name_loc4`)
  SELECT 73101, '工匠' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_creature` WHERE `entry` = 73101) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));

-- ---- locales_gameobject（2 条）----
INSERT INTO `locales_gameobject` (`entry`, `name_loc4`)
  SELECT 2020167, '隐藏的储物箱' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_gameobject` WHERE `entry` = 2020167) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_gameobject` (`entry`, `name_loc4`)
  SELECT 2020177, '沾满泥污的日记' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_gameobject` WHERE `entry` = 2020177) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));

-- ---- locales_item（10 条）----
INSERT INTO `locales_item` (`entry`, `name_loc4`)
  SELECT 41301, '阿蕾西亚的艾露恩之誓' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_item` WHERE `entry` = 41301) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_item` (`entry`, `name_loc4`)
  SELECT 41354, '古尔迈尔的水晶' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_item` WHERE `entry` = 41354) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_item` (`entry`, `name_loc4`)
  SELECT 41359, '吉尔尼斯珠宝：图鉴' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_item` WHERE `entry` = 41359) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_item` (`entry`, `name_loc4`)
  SELECT 41363, '库米莎的卷轴' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_item` WHERE `entry` = 41363) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_item` (`entry`, `name_loc4`)
  SELECT 41371, '坦拉尔之握' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_item` WHERE `entry` = 41371) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_item` (`entry`, `name_loc4`)
  SELECT 41385, '纯净的德莱尼水晶宝石' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_item` WHERE `entry` = 41385) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_item` (`entry`, `name_loc4`)
  SELECT 41410, '赞达拉的头颅' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_item` WHERE `entry` = 41410) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_item` (`entry`, `name_loc4`)
  SELECT 41424, '沃根多之球' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_item` WHERE `entry` = 41424) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_item` (`entry`, `name_loc4`)
  SELECT 55505, '艾露恩之镰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_item` WHERE `entry` = 55505) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));
INSERT INTO `locales_item` (`entry`, `name_loc4`)
  SELECT 56082, '完美的生命之血宝石' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `name_loc4` FROM `locales_item` WHERE `entry` = 56082) x
                      WHERE x.`name_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `name_loc4` = IF(`name_loc4` REGEXP '[一-龥]', `name_loc4`, VALUES(`name_loc4`));

