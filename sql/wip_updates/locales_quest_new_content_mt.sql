-- 乌龟服新任务的中文（第二阶段：人工翻译）
--
-- 同上：只写库里还没有中文的条目，带「已有汉字不覆盖」保护。
--
-- 1240 条。生效：mangosd 控制台 `.reload locales_quest`

SET NAMES utf8mb4;

-- ---- Title_loc4（14 条）----
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41152, 'DV-500' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41152) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41921, '熟悉的异动' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41921) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41923, '石梦灰谷' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41923) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41924, '石梦菲拉斯' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41924) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41925, '石梦暮色森林' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41925) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41926, '石梦辛特兰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41926) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41927, '布莱克沃尔德勋爵二世的骑乘口哨' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41927) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41928, '地穴领主的召唤' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41928) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41937, '梦魇的终结' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41937) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41950, '寄往虚空的包裹' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41950) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41955, '三色鬃皮' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41955) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 42009, 'Loktanag the Pure' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 42009) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 42035, '锁已备好' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 42035) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 42100, '追思纪念日' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 42100) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));

-- ---- Details_loc4（57 条）----
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 349, 'temp text 02 - description' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 349) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 5647, '你的种族非常强大，$N。我们很高兴能称你们为盟友。你和你们的种族每一天都向发现自己起源的目标迈进一步，而且在正确的道路上更加坚定地前行。这种成功的感觉一定非常不错。$B最近从铁炉堡传来消息说，秘法区的高阶牧师洛汉要你回到那里去找他。如果我是你的话，我可是不会让他久等的。愿伊露恩指引你的旅程。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 5647) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 7521, '我已经把我所知道的东西都告诉你了，$N。你必须找到源质，你必须毁灭拉格纳罗斯的躯体。$B快点出发吧，完成我的命令，你就将获得桑德兰的祝福。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 7521) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 7887, 'You have proven your value to our efforts in 战歌峡谷. Continue to aid the cause and bring me more talismans of merit. Do this, and you will earn even more of our trust.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 7887) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 7888, 'You have proven your value to our efforts in 战歌峡谷. Continue to aid the cause and bring me more talismans of merit. Do this, and you will earn even more of our trust.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 7888) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 7923, 'You have proven your value to our efforts in 战歌峡谷. Continue to rage against the 银翼要塞! Bring me more marks of honor!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 7923) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 7924, 'You have proven your value to our efforts in 战歌峡谷. Continue to rage against the 银翼要塞! Bring me more marks of honor!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 7924) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 7925, 'You have proven your value to our efforts in 战歌峡谷. Continue to rage against the 银翼要塞! Bring me more marks of honor!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 7925) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8081, 'War must be fought with soldiers, any soldier will tell you. They\'ll also say that a battle fought with poor gear or on an empty stomach is lost before it starts!$BThat is why 阿拉希盆地 is important. There are key areas in the basin that hold essential resources. Metals, weapons, food, lumber - all are needed, and all can be gained there.$BThat is what I want from you, $R. Enter 阿拉希盆地, win the battle by holding more bases than the enemy, and return to me with a crate of resources.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8081) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8124, '阿拉索联军 is sparing no expense in their move to retake Arathi. They, and all the races of the 联盟, now stream to this distant region, intent on expanding their hold from 避难谷地. We must stop them, and the best means to stop them is to take their supplies.$BYou can help us, $R. Enter 阿拉希盆地, known for its rich mines, fertile land and skilled craftsman. Capture and control every base you can, win the battle, and return to me with the resources you gain.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8124) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8157, 'War must be fought with soldiers, any soldier will tell you. They\'ll also say that a battle fought with poor gear or on an empty stomach is lost before it starts!$BThat is why 阿拉希盆地 is important. There are key areas in the basin that hold essential resources. Metals, weapons, food, lumber - all are needed, and all can be gained there.$BThat is what I want from you, $R. Enter 阿拉希盆地, win the battle by holding more bases than the enemy, and return to me with a crate of resources.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8157) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8158, 'War must be fought with soldiers, any soldier will tell you. They\'ll also say that a battle fought with poor gear or on an empty stomach is lost before it starts!$BThat is why 阿拉希盆地 is important. There are key areas in the basin that hold essential resources. Metals, weapons, food, lumber - all are needed, and all can be gained there.$BThat is what I want from you, $R. Enter 阿拉希盆地, win the battle by holding more bases than the enemy, and return to me with a crate of resources.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8158) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8159, 'War must be fought with soldiers, any soldier will tell you. They\'ll also say that a battle fought with poor gear or on an empty stomach is lost before it starts!$BThat is why 阿拉希盆地 is important. There are key areas in the basin that hold essential resources. Metals, weapons, food, lumber - all are needed, and all can be gained there.$BThat is what I want from you, $R. Enter 阿拉希盆地, win the battle by holding more bases than the enemy, and return to me with a crate of resources.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8159) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8163, '阿拉索联军 is sparing no expense in their move to retake Arathi. They, and all the races of the 联盟, now stream to this distant region, intent on expanding their hold from 避难谷地. We must stop them, and the best means to stop them is to take their supplies.$BYou can help us, $R. Enter 阿拉希盆地, known for its rich mines, fertile land and skilled craftsman. Capture and control every base you can, win the battle, and return to me with the resources you gain.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8163) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8164, '阿拉索联军 is sparing no expense in their move to retake Arathi. They, and all the races of the 联盟, now stream to this distant region, intent on expanding their hold from 避难谷地. We must stop them, and the best means to stop them is to take their supplies.$BYou can help us, $R. Enter 阿拉希盆地, known for its rich mines, fertile land and skilled craftsman. Capture and control every base you can, win the battle, and return to me with the resources you gain.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8164) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8165, '阿拉索联军 is sparing no expense in their move to retake Arathi. They, and all the races of the 联盟, now stream to this distant region, intent on expanding their hold from 避难谷地. We must stop them, and the best means to stop them is to take their supplies.$BYou can help us, $R. Enter 阿拉希盆地, known for its rich mines, fertile land and skilled craftsman. Capture and control every base you can, win the battle, and return to me with the resources you gain.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8165) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8266, 'I understand that it can be difficult at times to come out on top in 战歌峡谷. Still, your effort on our behalf - even when victory is not achieved - is important.$BShould you complete one of the trials inside 战歌峡谷 and not achieve victory, you will still receive a Ribbons of 牺牲. Bring it to me so that the Outriders may reward you for acting on our behalf... even if you weren\'t able to win this time.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8266) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8267, 'I understand that it can be difficult at times to come out on top in 战歌峡谷. Still, your effort on our behalf - even when victory is not achieved - is important.$BShould you complete one of the trials inside 战歌峡谷 and not achieve victory, you will still receive a Ribbons of 牺牲. Bring it to me so that the Outriders may reward you for acting on our behalf... even if you weren\'t able to win this time.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8267) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8268, 'I understand that it can be difficult at times to come out on top in 战歌峡谷. Still, your effort on our behalf - even when victory is not achieved - is important.$BShould you complete one of the trials inside 战歌峡谷 and not achieve victory, you will still receive a Ribbons of 牺牲. Bring it to me so that the Sentinels may reward you for acting on our behalf... even if you weren\'t able to win this time.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8268) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8269, 'I understand that it can be difficult at times to come out on top in 战歌峡谷. Still, your effort on our behalf - even when victory is not achieved - is important.$BShould you complete one of the trials inside 战歌峡谷 and not achieve victory, you will still receive a Ribbons of 牺牲. Bring it to me so that the Sentinels may reward you for acting on our behalf... even if you weren\'t able to win this time.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8269) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8290, '在这个通道的另一端，你会看到一片战火纷飞的土地，年轻的$N。部落不断侵入我们神圣的森林，锯断这里的苍天古树来建造他们的战争机器。$B进入战歌峡谷，帮助银翼要塞击败入侵的部落势力吧。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8290) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8295, '梣谷森林将在强大的部落面前屈服，$N。无论夜精灵们说什么做什么，都无法阻止我们的推进。卡林多属于部落，谁敢阻止我们拿取属于我们的东西，谁就要死!$B让你的心中充满荣耀之光，让那些胆敢阻止我们的敌人一个个倒下。摧毁银翼要塞中的哨兵部队，并拿到一枚战歌荣誉奖章。把这样一枚奖章拿来给我，你就可以获得奖赏。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8295) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8741, '看守者等待你的归来，$N。将绿色的权杖裂片带给时光之穴的安纳克罗斯。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8741) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8796, '你好，我很高兴你愿意听我说话。联盟需要一切可以获得的帮助来准备发动安其拉战争，这意味着，我们需要你！现在，官方的资源收集者正在收集必需的资源储备，但是如果没有你的帮助的话，我们是无法达成目标的，$N！$B你应该和负责此事的大元帅斯诺·落雪谈一谈。你觉得怎么样？你是否愿意帮助联盟做好战争的准备？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8796) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 8797, '你好，我很高兴你愿意听我说话。联盟需要一切可以获得的帮助来准备发动安其拉战争，这意味着，我们需要你！现在，官方的资源收集者正在收集必需的资源储备，但是如果没有你的帮助的话，我们是无法达成目标的，$N！$B你应该和负责此事的大元帅斯诺·落雪谈一谈。你觉得怎么样？你是否愿意帮助联盟做好战争的准备？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 8797) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 9257, '最后一个任务会是最困难的，$N。你要去迎头攻击巫妖王的将军跟上古之神，但是，你现在要面对的是萨格拉斯之手。$B带着这个法杖到斯坦索姆。你会看到圣化之地:而罗德隆最伟大的骑士就是在这里被谋杀的。把这污损的法杖放在圣化之地上，准备巨大力量由内破坏……毁灭这个支配法杖的邪恶东西，然后回到我这。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 9257) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 9269, '这个最终的任务会是最艰难的一个，$N。你已经挑战并击败了一名远古之神和巫妖王的将军，但现在你必须挑战萨格拉斯之手。$B带着这个法杖到斯坦索姆。你在那里会找到一片圣化之地:罗德隆最强大的骑士都在那里被杀害。将这个污损的法杖放在神圣的大地上，准备等着一股巨大的力量破茧而出……击败那个控制法杖的邪恶生物再回来找我。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 9269) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 9271, '这个最终的任务会是最艰难的一个，$N。你已经挑战并击败了一名远古之神和巫妖王的将军，但现在你必须挑战萨格拉斯之手。$B带着这个法杖到斯坦索姆。你在那里会找到一片圣化之地:罗德隆最强大的骑士都在那里被杀害。将这个污损的法杖放在神圣的大地上，准备等着一股巨大的力量破茧而出……击败那个控制法杖的邪恶生物再回来找我。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 9271) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 9378, '在浓密的病木林里有个入口通往纳克萨玛斯的可怕堡垒。以前，任何想尝试进入的人都被符文传送门外的魔法守卫挡下来。直到现在。$B我们设计了一个方法，透过一个永久的秘法掩护 - 肯瑞托的古老咒语加上一些我自己做的修改。说到这，那个披风是要钱的;不过，你对银色黎明的贡献不可动摇!我们会取消所有的费用。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 9378) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 40149, '＜这只箱子被污泥覆盖，还被咸涩的海水侵蚀得破烂不堪。里面有几件小物件和一本相当厚重的书，看上去保存得很好，也十分精致。再仔细查看，显然这是海盗船“堕落的名声”号的航海日志，其中记载着某些人可能用得上的情报。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 40149) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 40153, '＜这只桶看上去保存得相当完好，也十分结实。再往里翻找，你发现了一本装帧考究的书。它显然很旧了，书脊上却仍系着一根金线。封面上写着题签“圣洁之书 - 本神父”。也许它是某个人遗失的东西。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 40153) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41921, '如今我重获力量，感官也重新变得敏锐，比从前更能感受到你们这个世界的魔法。可我感知到的东西出乎意料——那感觉带着一种熟悉的气息。它来自北方，一团彼此冲突的能量漩涡：理念在碰撞，情绪游移不定，巨变正在酝酿。你也许已经见过它了——北面悬崖之外，是一片披着蓝衣的土地，蔚蓝的色调像静谧的午夜笼罩着海岸。我脑海中浮现出一座波光粼粼的大湖，那感觉在那里最为强烈。$B$B$N，等我们确保了我族人的安全之后，你愿意前往此地的北方，去寻找我感知到的那桩异象吗？我的心告诉我，它极其重要。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41921) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41927, '<你手中握着布莱克沃尔德勋爵二世的骑乘口哨——他是麦迪文麾下的遗物猎手之首。从这物件里透出的黑暗仍然浓重而强横，你找不到驱散它的办法。也许摩根墓场那些幽灵居民能帮上忙。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41927) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41928, '<地穴领主倒在你脚边，死透了。这从诺森德冰层深处爬出来的恶魔再也不能在生者之间散播恐惧。可你手里握着的东西，却让你这老练的冒险者本能地感到不安。石板触手冰寒，里面还能听见隐约的低语。单凭你一个人的力量打不碎它，也驱不散那股邪恶气息。也许一位强大的圣光使用者能在这种时候帮上你。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41928) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41929, '<你手里那块黑曜石摸上去滚烫。面前那具生物残骸裂开的缝隙里，正渗出淡紫色的能量丝。这块水晶里满溢着强横的奥术之力。能用它做成什么——无穷的可能在你脑中翻涌，随后，一个微弱的低语声钻进你的脑海。起初听不清，可你把它举得离头越近，声音就越响。等你终于听懂时，它反复念着同一个词：凄凉之地。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41929) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41935, '你找到的石板散发着古老的力量。它笼罩在令人望而生畏的气息之中，你猜想这一定是往昔岁月的遗物，不知怎么落到了管理者埃克索图斯的手中。细读其内容，可以看到上面以符文和刻记描述着一道强大的复活法术，用以复活不朽的存在。所需的只是诵出上面的词句，再加上你希望重新锚定于凡间的那个存在的精华。$B$B冒险与劫掠带来的兴奋仍未平息，你不禁琢磨，能否用这件神器为自己谋取私利……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41935) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41936, '水晶发出不祥的嗡鸣。透过它光洁无瑕的表面望进去，仿佛有一团翻涌的漩涡藏在宝石内部。它触手冰冷，重得出奇，你能感到一股阴暗可怕的力量从无尽虚空的深处向你招手。你既着迷又震惊，决定把它带去给一位强大的术士，也许他能帮上忙。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41936) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41937, '半神乌尔索尔已被杀死，你手中的坠饰就是你与盟友这一壮举的证明。奇怪的是，在这位荒野之神身上找到的这块纯净翡翠上，竟看不出丝毫梦魇影响的痕迹。$B$B你沉醉于石头的低鸣，在眼前静谧的月光林地中，看见了一个熊的剪影。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41937) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41938, '石头表面刻着一些你无法解读的文字。也许大地之环中精通这种语言的人能帮上忙。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41938) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41940, '愿众灵与你同在，朋友。我是格拉驯风者，大地之环的一员。确保这个世界的元素平衡不受扰乱是我们的职责。为此，我们大地之环的萨满会踏上遍布艾泽拉斯的朝圣之旅，去评估这份平衡。众灵把我引到了阿拉希高地的平原——这片土地承载着人类古老的历史，也充盈着原始的元素魔法。动荡正在地底酝酿，禁锢法阵的守护者们躁动不安。在对这座牢狱的警觉守望中，它们忘却了自己的本真——如今正在蹂躏这片高地的神圣之地。$B$B$C，帮我让它们重归安宁吧。摧毁它们的形躯，把完好的元素之核带给我，好让我平息它们体内狂暴的洪流。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41940) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41941, '自然本是混沌的，$N。它不遵循任何规则，没有既定之路，也没有确定的未来。在这片混沌之中，生命在元素的滋养下萌发。土为食粮，气为呼吸，水为指引，而火既是它的养育者，也是它的毁灭者。一团火焰可以令人舒适、引人亲近，甚至用它温柔的暖意把人包裹其中。可另一方面，无边无际的烈焰又冷酷无情，不断搜寻更多生命来吞噬。$B$B火元素深深织入生与死的轮回：旧物想要重生，唯有依靠那既能毁灭、又能孕育新芽的烈焰。在卡利姆多南部的安戈洛环形山深处，这样的一体两面可以在火羽山亲眼得见。火山狂暴地毁灭一切，而土壤则从灰烬中获得新的力量。采集这种火山土壤的样本，把它们带给东瘟疫之地的雷布拉特·碎地者。他会知道该怎么处理它们。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41941) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41950, '你在萨特身上找到的木箱很沉，还伴着低沉的嗡鸣。掀开箱盖，里面是你在那片洞穴周围见过的暗红色水晶——被污染的德莱尼水晶碎片，盛满了令人不安的能量。裂界者拉尔派克塔应该看看这个。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41950) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41954, '我听过许多关于你们世界工匠的传闻。他们弯折石头、熔炼矿石，编织被月光浸润的织物，打造出强力的护甲与武器。可与德莱尼工艺的传承相比，那不过是孩童的第一次搓捏。数百年智慧代代相传，由各自领域中最顶尖的人守护。$B$B如果你有热情、有兴趣，也有勇气向我求学，就把你最得意的作品拿来给我看，我会评判你的潜力。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41954) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41955, '这个世界上生活着一种叫九头蛇的三头野兽——你在旅途中肯定见过不少。它们的皮天生带有魔力，我们可以用德莱尼的古老技艺把这份魔力培育、放大。等你从那些野兽身上弄来皮革，再加上藏在你们世界的三条传说级九头蛇的皮，我就把如何用它们打造一套强力护甲的方法告诉你。把这张纸条带上，长者们不久前帮我定位了它们，可眼下这种局势，我离不开村子。$B$B祝你好运，Parash’ka。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41955) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41964, '凡戈恩 的话还在你脑中回响。泰兰达斯 上那座已成废墟的城市艾纳兰，以及它神殿下方的洞窟系统。你能感到这趟旅程的终点越来越近了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41964) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 42002, '你手中那团带刺的触须不停扭动，以一种无法解释的方式向外伸展。它越缠越紧，一圈圈裹住你的手。你被这景象迷住了，竟没察觉那团东西上长着一只眼睛——以及一根倒刺，它当即刺进你的掌心。剧痛之下你想把寄生物扯下来，它却更深地钻进你的血肉。转眼间，它与你合为一体。你又惊又怕，粗重地喘着气，听见脑子里有个声音。起初很微弱，你四下张望想找出声音的来源，却找不到。你惊恐地看向被感染的那只手——迎面而来的是一道灼热的注视，还有你刚才听见的那个声音：$B$B“容器，你的身上已被赋予使命。就像虫子听命于它的女王，你也将成为我的工具。到希利苏斯荒凉的沙丘中去，进入废墟之城安其拉。在那里你会找到一把剑。把它据为己有。”' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 42002) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 42003, '你苦苦搜寻来的东西，却平常得让人意外。没有分量，只是一块说不出材质的金属板，握在手里轻飘飘的。你想不通那寄生物究竟看上了这剑的什么，而它仿佛能读你的心思，又开口点醒你。$B$B“此刃已沉睡万古，等着苏醒的一天。它生于你那个世界的混沌，渴望重获自由。去观察。去学习。去理解。我的仆从，我感到你体内涌动着对力量的渴望。来，成为成就此刃天命的一环，我便允许你尝到它力量的一丝滋味。$B$B去寻找在你那幼稚世界上游荡的恶魔身上的符文。再取一根恐惧魔王的指甲，用它把此刃的用途刻进剑身。两样东西都能在诅咒之地的腐化之痕找到。要做到这一点，就到你们称为艾萨拉的这片土地上，到 Arkkoran 神殿东南方的深海海渊里寻找深渊祭坛。”' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 42003) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 42004, '“名字回归之后，Thil’phoral 便会踏上它被创造出来时该走的路。可它终究只是一把有目的的剑，而目的若没有实现它的力量，就什么都不是。这把剑渴求鲜血——渴求被同一种伟大力量触碰过的强大巨龙的鲜血。只有灌注了这种杂糅的精华，Thil’phoral 才会从沉眠中苏醒。去收集它们的心脏，在深渊祭坛把它们献给此刃，我的仆从。它们在索求。”$B$B那声音再次沉寂，剩下你自己拿主意。现在就看你能不能找到这些龙了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 42004) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 42005, '寂静充盈着你的脑海。有那么一瞬，你以为一切都已经结束，可手中那团搏动的东西却提醒你现实依旧。而就在这个念头刚刚掠过脑际之际，那声音便仿佛回应着你内心的声音般响起。$B$B“虚假的希望，配不上你这样前途无量的仆从。更伟大的力量可不会乐于见到你抱住自己头脑编造出的幻象不放。不，真理只有一个。一个绝对的真理，一个圆满的真理。Thil’phoral正因你的顺从而力量充盈。它的道路上还差最后一步。必须在剑与裂隙之间牵起一道联结，好让Thil’phoral得以观察、理解、宣告。$B$B进入那片被你族人称作翡翠梦境的梦境。在那里，去见索尔纽斯——更伟大的力量的一次失败实验。终结他的存在，从他的遗物中取走那块碎片。最后一步，我的仆从。”' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 42005) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 42009, '也许你自己已经感受过它，或者已经遭遇过它的某种显现，但卡利姆多的森林中正有一场侵染疯狂蔓延。它感染花草与生灵，使它们陷入疯狂，不分敌友地发起攻击。阴险的低语在自然之灵间悄然流传，号召平衡的守护者们对抗这场腐化。$B$B其中之一便是高贵纯洁的Loktanag，成长与适应的活化身。他们感应到海加尔山深处的异动，就在木喉要塞神圣的殿堂之下。Loktanag深入这熊怪的神圣家园，试图阻止瘴气的扩散，但他们的力量显然不够。如今众灵为他们腐烂的躯体哀悼，那躯体渗出有毒的淤泥，弥漫的正是他们想要阻止的腐化。$B$B$N，我请求你让Loktanag安息。像他们这样高贵的生灵理应重回轮回。平衡必须恢复。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 42009) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 42022, '你只能从那位陨落之神的尸体上抢救下乌尔索尔那张腐臭的皮。它被撕得破烂，爬满蛆虫。你决定把它带给乌索兰的熊怪，让他们净化先祖之神仅存的遗骸。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 42022) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 42029, '紫色的恶魔之血从钥匙上滴落，滴在木喉要塞污浊的地面上。洞中昏暗的光在它表面折射出无数棱彩般的反光，在你看来恍若异界景象。不过，它的工艺让你着迷——佩罗萨恩把它随身带着，必定有原因。钥匙头部布满精细纤巧的装饰，还刻着一弯新月。可除此之外再无线索，你的发现也帮不上什么忙。也许该回拉文霍德庄园，再去见见你的老主人了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 42029) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 42035, '拿去吧。一把工艺精湛、价值等重的锁。现在你想拿它做什么都随你。我一点也不关心你打算用它干什么，也不想听你说。赶紧滚出铸造厂，别烦我，听明白了吗？！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 42035) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 42056, '来，让我们试试你学到的东西。从这里往南，穿过战士们训练的图腾环，在树影与枝叶下，你会找到 勇士绿角。他受了伤，身形高大，却还守着被风险投资公司霸占的冰蹄水井。$B$B他接到的命令只是观察，可他没弄明白，反而做了相反的事——跟风险投资公司动了手，好不容易才捡回一条命。你的任务是找到他、治好他，用韧强化他的意志，让他想起自己还有可以依靠的同伴，好让他回到村里召集人手，面对眼前的敌人。$B$B办成这件事，等你回来我们就谈谈 穆莎。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 42056) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 42079, '这卷轴看上去完好无损，但上面有一道封印，你解不开。你的思绪把你引向姆乌尔夫尼格索恩——一位和你一样来自月蹄村的信徒。也许是凭你的直觉，也许是天界兄妹的示意，你的蹄子把你带向他，你知道他或许能解开这道封印。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 42079) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 42100, '$C，你也许正是我需要的人。今天是纪念日，暴风城的居民们会向王国里的弱者、老人以及其他所有不幸的人捐赠财物，以表达对大主教阿隆索斯·法奥——北郡修道院前任主教的敬意。我正从湖畔镇赶来，把镇民们无私的捐赠送往暴风城，可一群可怕的豺狼人洗劫了我的马车。所有的衣服、食物和玩具不是被他们弄坏，就是被彻底毁掉了。$B$B两手空空，我几乎绝望了。但就像法奥大主教亲自听到了我的苦楚一般，我瞥见附近闪着一道微光。我循着光亮看去，发现了一片三叶草地，这分明是法奥善意的迹象！据说沿着三叶草指引的道路走，就能走上幸运之路。$B$B也许这就是我困境的答案。你愿意为暴风城那些需要帮助的人伸出援手吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 42100) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 42101, '你好，旅行者。你或许正是能解我眼下困境的人。我们每天都感谢大地母亲的恩赐，而今天是个特别的日子。所有居住在莫高雷这片应许之地的部族都会齐聚雷霆崖，献上一场盛大的宴会，用歌声和舞蹈庆祝大地母亲赐予我们的丰饶。可遗憾的是，我原打算用来运送这批募捐物资的马车被当地的豺狼人洗劫了。所有的衣服、食物和乐器都被他们毁得一干二净，如今我们只能靠仅剩的东西勉强凑合。$B$B不过，事情还有一线希望。当我在村里四处查看还剩下些什么的时候，眼角余光瞥见一个精灵的身影朝雷霆崖跑去。可等我再看第二眼时，却只看到一片三叶草地。$C，我相信这是大地母亲给我的启示。沿着三叶草指引的道路走下去，我们或许还来得及挽救这场宴会。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 42101) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));

-- ---- Objectives_loc4（61 条）----
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 349, 'temp text 02 - log' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 349) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 5647, '与铁炉堡的高阶牧师洛汉谈话。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 5647) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 7521, '如果你想要把逐风者桑德兰从监牢里释放出来，你就必须找到左右两块逐风者禁锢之颅，10块源质锭，以及火焰之王的精华，把它们交给德米提恩。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 7521) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 7657, '只要交出 50 根瑟银锭，头盔图纸就是你的了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 7657) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 7658, '只要交出 60 根瑟银锭，腿甲图纸就是你的了。$B$B我知道，我这是在让你倾家荡产！这种话我听得多了，所以省省你那套可怜的说辞吧，弱鸡。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 7658) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 7886, 'You obtained a 银翼功勋奖章 for your last task, talk to me again, and you gain your reward.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 7886) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 7887, 'You obtained a 银翼功勋奖章 for your last task, talk to me again, and you gain your reward.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 7887) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 7888, 'You obtained a 银翼功勋奖章 for your last task, talk to me again, and you gain your reward.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 7888) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 7921, 'You obtained a 银翼功勋奖章 for your last task, talk to me again, and you gain your reward.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 7921) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 7922, 'You obtained a 战歌荣誉奖章 for your last task, talk to me again, and you gain your reward.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 7922) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 7923, 'You obtained a 战歌荣誉奖章 for your last task, talk to me again, and you gain your reward.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 7923) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 7924, 'You obtained a 战歌荣誉奖章 for your last task, talk to me again, and you gain your reward.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 7924) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 7925, 'You obtained a 战歌荣誉奖章 for your last task, talk to me again, and you gain your reward.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 7925) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8081, '获得阿拉希盆地战斗的胜利，获取一个阿拉希资源木箱，然后向避难谷地的玛克里尔中士覆命。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8081) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8124, '进入阿拉希盆地，获得一箱阿拉希资源箱，然后将它交给落锤镇的亡灵哨兵莫提斯。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8124) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8157, '获得阿拉希盆地战斗的胜利，获取一个阿拉希资源木箱，然后向避难谷地的玛克里尔中士覆命。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8157) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8158, '获得阿拉希盆地战斗的胜利，获取一个阿拉希资源木箱，然后向避难谷地的玛克里尔中士覆命。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8158) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8159, '获得阿拉希盆地战斗的胜利，获取一个阿拉希资源木箱，然后向避难谷地的玛克里尔中士覆命。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8159) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8163, '进入阿拉希盆地，获得一箱阿拉希资源箱，然后将它交给落锤镇的亡灵哨兵莫提斯。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8163) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8164, '进入阿拉希盆地，获得一箱阿拉希资源箱，然后将它交给落锤镇的亡灵哨兵莫提斯。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8164) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8165, '进入阿拉希盆地，获得一箱阿拉希资源箱，然后将它交给落锤镇的亡灵哨兵莫提斯。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8165) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8266, 'Bring the Ribbons of 牺牲 to 沙塔尔·碎颅 so that the Outriders may reward you for acting on our behalf.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8266) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8267, 'Bring the Ribbons of 牺牲 to 沙塔尔·碎颅 so that the Outriders may reward you for acting on our behalf.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8267) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8268, 'Bring the Ribbons of 牺牲 to 哨兵轻歌 so that the Sentinels may reward you for acting on our behalf.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8268) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8269, 'Bring the Ribbons of 牺牲 to 哨兵轻歌 so that the Sentinels may reward you for acting on our behalf.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8269) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8290, '进入战歌峡谷并击败部落小队，取得战歌峡谷荣誉奖章后向银翼树林哨兵轻歌回覆。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8290) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8295, '进入战歌峡谷击败联盟小队，拿到战歌峡谷荣誉奖章后向莫尔杉营地的沙塔尔·碎颅覆命。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8295) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8741, '将绿色的权杖裂片带到塔纳利斯给时光之穴的安纳克罗斯。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8741) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8796, '和铁炉堡军事区的大元帅斯诺·落雪谈一谈。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8796) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 8797, '和铁炉堡军事区的大元帅斯诺·落雪谈一谈。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 8797) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 9257, '塔纳利斯时光之穴的安纳克罗斯要你带着阿泰丝,守护者之杖前往斯坦索姆，在圣化之地上使用它。击败从法杖内被驱除的生物再回去找他。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 9257) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 9269, '塔纳利斯时光之穴的安纳克罗斯要你带着阿泰丝,守护者之杖前往斯坦索姆，在圣化之地上使用它。击败从法杖内被驱除的生物再回去找他。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 9269) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 9271, '塔纳利斯时光之穴的安纳克罗斯要你带着阿泰丝,守护者之杖前往斯坦索姆，在圣化之地上使用它。击败从法杖内被驱除的生物再回去找他。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 9271) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 9378, '东瘟疫之地圣光之愿礼拜堂的大法师安琪拉·多桑杜将免费给你秘法掩护。你一定要在银色黎明达到崇拜声望。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 9378) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41921, '前往艾萨拉以北的月语海岸，找到那座波光粼粼的湖泊。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41921) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41927, '把骑乘口哨带到逆风小径摩根墓场的幽灵那里。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41927) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41928, '把地穴领主的召唤交给一位强大的圣光使用者。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41928) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41929, '找到碎片牵引你前往的地方。你的直觉告诉你，要去找那些亵渎之地的黑暗能量。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41929) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41935, '为复活术之仪祭找到一个用途。文中所提到的不朽存在，很可能就是游荡在艾泽拉斯的那些强大巨龙。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41935) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41936, '把水晶交给一位强大的术士。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41936) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41937, '把梦之坠饰交给月光林地的巨熊之灵。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41937) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41938, '把这块石头带给石爪山脉的大地之环。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41938) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41940, '把阿拉希高地四座禁锢法阵中各类元素生物身上完好的核心带给外禁锢法阵附近的格拉驯风者。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41940) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41941, '大地之环的Firespeaker Bewali要你把安戈洛环形山火羽山一带的火山土壤带给东瘟疫之地圣光之愿礼拜堂的雷布拉特·碎地者。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41941) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41950, '带着从腐心圣所取来的水晶箱，回到莫洛加村的裂界者拉尔派克塔那里。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41950) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41954, '把制作好的皮甲交给莫洛加村的宗师工匠 T’kalpa。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41954) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41955, '收集九头蛇皮革和三条传说级九头蛇的皮。给强壮的九头蛇剥皮即可获得九头蛇皮革。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41955) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41964, '前往月语海岸，探索 泰兰达斯 岛上艾纳瑞丝神殿下方的洞窟。带着你的发现，回到月光林地以南木喉隧道里的 独眼高恩 那里。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41964) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 42002, '在安其拉废墟中找到那把剑。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 42002) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 42003, '把恶魔符文和恐惧魔王的指甲带到深渊祭坛，为此刃赋予用途。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 42003) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 42004, '收集四条龙的心脏，送到艾萨拉 Arkkoran 神殿东南方海中的深渊祭坛。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 42004) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 42005, '杀死索尔纽斯，并在翡翠圣殿内的阿尔恩之藤蔓处让Thil’phoral与他所持的那块碎片重新合一。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 42005) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 42009, '在木喉要塞内击败邪鳍洛克塔娜格，然后回到石爪山脉大地之环的Muln Earthfury那里复命。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 42009) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 42022, '把乌尔索尔之皮带给艾萨拉乌索克之喉的熊怪。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 42022) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 42029, '与奥特兰克山脉拉文霍德庄园的刺客公会首领交谈。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 42029) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 42035, '带着这把锁回到奥特兰克山脉拉文霍德庄园的乔拉齐·拉文霍德公爵那里。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 42035) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 42056, '找到 勇士绿角，用次级治疗术（等级 2）治好他的伤，然后为他施加真言术：韧，再回到莫高雷血蹄村的 帕尔甘星行者 那里。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 42056) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 42079, '把烧了一半的日志带到月语海岸月蹄村的姆乌尔夫尼格索恩那里。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 42079) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 42100, '沿着三叶草地指引的道路前进，帮Raymond摆脱困境！他在艾尔文森林的闪金镇等着你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 42100) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 42101, '沿着三叶草地指引的道路前进，帮Hehfani摆脱困境！她在莫高雷的血蹄村等着你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 42101) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 80708, '前往暴风城的大教堂广场，与克罗雷修士交谈。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 80708) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));

-- ---- OfferRewardText_loc4（111 条）----
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 85, '你不见了什么?喔，我可没拿什么项炼，因为我不是小偷!$B我可能知道是谁干的……<奸笑>……不过我太饿了，想不起来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 85) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 100, '谢谢你，萨满。$B堕落已经褪去，然而生命依然衰弱，我们需要萨满的力量来保护所有的生灵。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 100) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 458, '我知道你在找我，年轻的$R。麦利萨尔派你来证明了他的睿智。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 458) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 650, '啊，那么说来你认识玛尔顿?他是我的老酒友了。你也看到了，我已经找到了超越那些人为定制的条约和联盟关系的东西─那就是酒。如果我们刚刚都畅饮了这种美味的饮料，那我们现在都会精神焕发。$B唉，看来你找我并不是为了学习酒类的价值，那我们现在就开始说说你的问题吧。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 650) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 755, '是鹰风酋长派你来的?大地之母祭仪可不是件小事……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 755) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 773, '你在通过大地之母祭仪的过程中已经显示了你的勤奋和努力，$N。$B我们是先祖之魂，我们代表了那些为保卫雷霆崖而付出生命的勇敢的牛头人。现在，我把保卫这里的神圣职责交给你。$B你已经通过了智慧祭仪，年轻的{class}。你可以骄傲地走进雷霆崖了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 773) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 960, '发现暮光之锤的信徒在那里活动真是件糟糕的事情。我必须仔细想想他们要干什么……$B如果你有更多的消息，就用占卜之碗和我交谈。如果你还需要更多的占卜之瓶来制造占卜之碗的话……我这里还有一瓶。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 960) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 1152, '天气越来越冷，哥布尔越来越倡狂地肆虐在我们的土地上，夜精灵对新生的种族表现出了他们一贯的高傲自大。被遗忘者和兽人并不是造成世界创伤累累的唯一原因，许多智慧的种族都对此负有责任。多恩知道这一点，他派你来找我，因为你也拥有足以认识到这一点的智慧。$B我是布劳格。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 1152) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 1301, '詹姆士?哦，他很久以前就走了。$B我看他被狂热的情绪冲昏了头。当时整个罗德隆都疯了，很多人加入珍娜·普劳德摩尔的军队横渡大海到卡林多去了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 1301) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 1685, '我很高兴有人找到你了，$N。我正在担心呢。我们为你付出了这么多时间，失去你会很可惜的。$B不过这些问题我们可以晚点再谈，现在继续对你进行训练才是最重要的事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 1685) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 1717, '我很高兴有人找到你了，$N。我正在担心呢。我们为你付出了这么多时间，失去你会很可惜的。$B不过这些问题我们可以晚点再谈，现在继续对你进行训练才是最重要的事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 1717) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 1789, '快点，$N，你的成功与否关系着不止一条人命。$B如果因为某些原因让你无法帮助杰生和亨兹，就赶快回来找我，我会再给你一个生命符记。$B别以为我的帮助仅仅是简单的恩惠，你必须证明自己具备和其它圣骑士一样的价值,在今后的日子里，你还会不断遇到挫折。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 1789) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 2985, '地平线吹来的风轻拂着你，脚下的大地是如此坚实，火焰温暖了你的灵魂，而现在我想让你体味水的纯洁。$B你已经达到了一定的境界，你的精神将赐予你走得更远的力量。不过，你先得迈出至关重要的第一步。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 2985) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 3631, '那么说来，你又决定要回应我的召唤，很好。$B我的侍僧还在怀疑你会不会出现呢。我告诉他们这一点是毫无疑问的:当你想要获得更强大的力量时，你就会像飞蛾扑火一般急切地来我这里。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 3631) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 5638, '很高兴你来了，$N。我们有很多要谈的，但是最重要的是你在圣光之道上的修行情况。$B有些课程是所有圣光的追随者都需要学习的，如果你准备好了，我们现在就来讨论一些相关的内容吧。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 5638) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 5647, '你终于来了，很好，$N。我们的种族是光荣而又强大的，关于这一点，你不仅要自己清晰地认识到这一点，还应该让别人也有这样的感觉。你准备好了吗，$G小伙子:小姑娘;?' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 5647) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 5659, '啊，好极了，又来了一个。时间对我来说不成问题，但是对你而言就至关重要了。你要学习的东西还很多，而我想传授给你的也很多。你必须证明自己的价值，以此来赢得丰厚的回报。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 5659) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 6606, '啊，是哈鲁让你来的?好吧，那么，你是谁呢?你是来找我帮忙的吧?' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 6606) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 6721, '是时候了，猎人。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 6721) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 7424, '<德尔克把蹄子丢到他身后的一堆蹄子里面去。>$B继续好好做，$N。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 7424) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 7462, '你打开了箱子，发现了……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 7462) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 7638, '很高兴见到你，$N。我知道你急切地想要知道如何才能获得你的战骑，现在这个时刻终于来临了。$B你需要经过许多试炼，但是最重要的是，你的信念将通过克服这些困难得到最大程度的提升。这些并不是教课书式的试炼─你必须全身心地投入，才能克服即将到来的挑战。在拯救你未来的伙伴之前，你必须与无数邪恶的力量抗衡。$B现在，我们开始吧!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 7638) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 7886, '谢谢你，$N。你在战歌峡谷中的威名已经传遍了梣谷森林。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 7886) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 7887, '谢谢你，$N。你在战歌峡谷中的威名已经传遍了梣谷森林。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 7887) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 7888, '谢谢你，$N。你在战歌峡谷中的威名已经传遍了梣谷森林。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 7888) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 7921, '谢谢你，$N。你在战歌峡谷中的威名已经传遍了梣谷森林。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 7921) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 7922, '夜精灵和他们的盟友听到你的名字就会吓得发抖!为部落而战!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 7922) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 7923, '夜精灵和他们的盟友听到你的名字就会吓得发抖!为部落而战!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 7923) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 7924, '夜精灵和他们的盟友听到你的名字就会吓得发抖!为部落而战!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 7924) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 7925, '夜精灵和他们的盟友听到你的名字就会吓得发抖!为部落而战!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 7925) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8101, '{class}，这块坠饰上镶嵌的卡亚罗之石来自南海的卡亚罗山脉。卡亚罗山脉地带分布着许多活火山，那里的地质地形不断发生剧烈的变动。$B随着你与赞达拉食人妖的关系日益密切，卡亚罗之石的力量也会增强。利用这块石头的力量打败我们的敌人吧。就像卡亚罗山脉那样:迅速、致命、富有爆炸力……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8101) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8110, '看到这些海藻了吗?它们产自南海。我们往其中添加了一点魔精和魔法，它就成为一件非常有用的饰品。$B你是个德鲁伊，这对你来说相当容易。把它戴在你的脖子上，想像一下大自然、松鼠或是所有你们会喜欢的东西。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8110) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8266, '好吧，在面对失败的时候你没有选择逃跑。你坚守阵地，$N，当你继续坚持的时候，一名真正的英雄就这样出现了。无疑你将在下一次中获胜……但是我们一样要对你表示感谢。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8266) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8267, '好吧，在面对失败的时候你没有选择逃跑。你坚守阵地，$N，当你继续坚持的时候，一名真正的英雄就这样出现了。无疑你将在下一次中获胜……但是我们一样要对你表示感谢。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8267) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8268, '好吧，在面对失败的时候你没有选择逃跑。你坚守阵地，$N，当你继续坚持的时候，一名真正的英雄就这样出现了。无疑你将在下一次中获胜……但是我们一样要对你表示感谢。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8268) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8269, '好吧，在面对失败的时候你没有选择逃跑。你坚守阵地，$N，当你继续坚持的时候，一名真正的英雄就这样出现了。无疑你将在下一次中获胜……但是我们一样要对你表示感谢。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8269) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8290, '银翼哨兵部队感谢你的贡献，{class}。我们和战歌先遣骑的战斗远未结束，但是你的胜利一定可以减缓他们建造战争机器的速度─即使只是减缓一小会儿。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8290) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8292, '谢谢你，$N。你在战歌峡谷中的威名已经传遍了梣谷森林。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8292) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8293, '夜精灵和他们的盟友听到你的名字就会吓得发抖!为部落而战!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8293) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8295, '<沙塔尔.碎颅发出兴奋的怒吼。>$B他们还能支撑多久?还要牺牲多少联盟的渣滓才能让他们退却?只有时间可以说明一切，$R……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8295) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8383, '你为联盟不断带来荣耀，$N。如果我们继续努力的话，部落迟早会被我们击垮的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8383) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8409, '啊，你成功了!我要说的是，你展现了万鬼节的精神─被遗忘者的精神!$B<黑暗召唤者雅恩卡搓着手大笑着。>$B现在南海镇没有美味的麦芽酒喝了，我为此要庆祝一番!至于你，收下这些礼物。你会发现其中必定有有用的东西!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8409) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8678, '你的灵魂生气蓬勃，年轻的{class}。我接受你的致敬并回敬你这个硬币……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8678) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8742, '一千年过去了，正如命中注定的那样，一位勇士站在了我的面前。这位勇士将会带领他的人民走向新的纪元。$B上古之神在颤抖，$N。是的，它在你坚定的信念面前恐惧地颤抖着。打破克苏恩的预言吧。$B它知道你会到来的，勇士─它还知道卡林多的力量与你同在。当你做好准备之后，请通知我，我将把流沙权杖赐予你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8742) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8745, '你好，勇士。我是神圣之锣和青铜龙军团的永恒观察者，乔纳森。$B永恒之王授权我让你从他永恒的宝物箱里选择一样物品。愿它能在你对抗克苏恩的战役中帮助你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8745) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8796, '嗨 $G小夥子:小姑娘;!很高兴看到这么多像你一样的联盟成员，$R，伸出援手为安其拉之战打好基础。这样的努力一定会让我们胜过异种生物和他们藏在安其拉里面的邪恶主人。$B既然你在这里，记得去和不同的收集者谈谈并提供你的协助，收集你能取得的材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8796) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8797, '嗨 $G小夥子:小姑娘;!很高兴看到这么多像你一样的联盟成员，$R，伸出援手为安其拉之战打好基础。这样的努力一定会让我们胜过异种生物和他们藏在安其拉里面的邪恶主人。$B既然你在这里，记得去和不同的收集者谈谈并提供你的协助，收集你能取得的材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8797) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8846, '很好，这里是你要的补给品，{class}。如果你还想要更多的话，请随时来找我，别客气。$B继续努力吧，$N。我们必须不惜一切代价地赢得这场战争。如果每个人都尽忠职守，那么胜利必将是我们的!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8846) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8850, '很好，这里是你要的补给品，{class}。如果你还想要更多的话，请随时来找我，别客气。$B继续努力吧，$N。我们必须不惜一切代价地赢得这场战争。如果每个人都尽忠职守，那么胜利必将是我们的!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8850) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8851, '很好，这里是你要的补给品，{class}。如果你还想要更多的话，请随时来找我，别客气。$B继续努力吧，$N。我们必须不惜一切代价地赢得这场战争。如果每个人都尽忠职守，那么胜利必将是我们的!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8851) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8993, '太好了!太好了!我会把这个跟其他礼物堆放在一起。$B我没想到会有这么多!你一定很爱你的领导者。$B现在，让我在清单上再加一笔……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 8993) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 9238, '这是你要求的东西，$N。依约抵达!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 9238) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 9257, '这伟大的成就绝对不能就这样让它轻描淡写过去，$N。你完成了不可能的任务。哎，这是命中注定啊。法杖已经作出了自己的选择……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 9257) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 9269, '这伟大的成就绝对不能就这样让它轻描淡写过去，$N。你完成了不可能的任务。哎，这是命中注定啊。法杖已经作出了自己的选择……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 9269) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 9270, '这伟大的成就绝对不能就这样让它轻描淡写过去，$N。你完成了不可能的任务。哎，这是命中注定啊。法杖已经作出了自己的选择……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 9270) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 9271, '这伟大的成就绝对不能就这样让它轻描淡写过去，$N。你完成了不可能的任务。哎，这是命中注定啊。法杖已经作出了自己的选择……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 9271) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 39977, '你将获得：冒险者幸运战袍 旅行者密封的宝箱' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 39977) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 39978, '你将获得：圣诞布袋 旅行者密封的宝箱' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 39978) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 39979, '你将获得：圣诞布袋 旅行者密封的宝箱' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 39979) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 40051, '＜翻查箱中的物品，你找到了一条线索。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 40051) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 40052, '＜在那堆泥泞中搜寻，你又找到了一条线索。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 40052) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 40054, '＜在这只神秘的沉箱里搜寻，你又找到了一条线索。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 40054) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 40055, '＜在神秘焦黑的储物柜里，你发现了一卷隐秘的卷轴。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 40055) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 40106, '＜我该做准备了。一旦我激活那座石座，谁也不知道里面等着的是什么。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 40106) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 40114, '＜我该做准备了。一旦我激活那座石座，谁也不知道里面等着的是什么。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 40114) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 40944, '外来者来了？看来格雷迈恩之墙的开放确实为我们带来了新的盟友。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 40944) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 40945, '你将获得：瑞文伍德之盾 空心丝织裤' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 40945) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41316, '这本书……！我听说过它！它是一整套精巧设计与图纸中的最后一本，用于打造你能想象到的最繁复的珠宝！这一本尤其收录了用艾泽拉斯的钻石制作极强饰品的详细指南。$B$B现在只剩一个问题：我们该怎么打开这鬼东西？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41316) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41333, '你将获得：设计图：艾泽拉斯红玉' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41333) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41334, '你将获得：设计图：惊艳帝王石' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41334) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41335, '不得不说，这是一本古怪的书。上面有一个古老的印记，我并不熟悉。真有意思……不管怎样，解读这本书对我而言不成问题。请稍等片刻，我会把从书页里能解出的知识告诉你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41335) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41337, '你将获得：设计图：蓝玉指环' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41337) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41352, '你将获得：昂贵的金色指环' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41352) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41353, '以艾露恩之名。我想，那件东西落到你手里绝非偶然。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41353) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41395, '你将获得：赞之宝石' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41395) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41561, '你将获得：角牙特制酒杯' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41561) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41568, '你将获得：雷酒特种甲商人酒杯' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41568) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41572, '你可以从这些奖励中选择其一：图样：宇宙头饰 图样：虚灵头饰 设计图：超凡罩帽 设计图：炫光头盔' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41572) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41573, '你可以从这些奖励中选择其一：图样：宇宙护腿 图样：虚灵护腿 设计图：超凡护腿 设计图：炫光护腿' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41573) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41574, '你可以从这些奖励中选择其一：图样：宇宙衬肩 图样：虚灵护肩 设计图：超凡肩甲 设计图：炫光肩铠' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41574) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41575, '你可以从这些奖励中选择其一：图样：宇宙外衣 图样：虚灵外套 设计图：超凡胸甲 设计图：炫光胸甲' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41575) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41576, '你将获得：图样：魔网亲和披风' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41576) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41577, '你可以从这些奖励中选择其一：魔铸纳斯雷兹面纱、魔铸纳斯雷兹头饰、魔铸纳斯雷兹光环' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41577) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41651, '你将获得：扎波·扎布拉斯特的签名、永望镇广播公司背包' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41651) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41653, '你可以从这些奖励中选择其一：智力卷轴 III 敏捷卷轴 III 力量卷轴 III 你将获得：春节烟花包' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41653) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41654, '你可以从这些奖励中选择其一：收获节猪肉 廉价啤酒 你将获得：春节烟花包' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41654) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41655, '你将获得：春节礼物宝盒' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41655) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41714, '你将获得：原始地脉水晶' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41714) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41743, '你可以从这些奖励中选择其一：暗影抗性符印 强化体质符印 贪婪之欲符印' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41743) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41744, '你可以从这些奖励中选择其一：伪装秘典：主教 伪装秘典：大王 伪装秘典：尔乌克 玩具骑士' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41744) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41770, '你将获得：黑曜野性迅猛龙' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41770) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41771, '你将获得：暴掠龙牙' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41771) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41772, '你将获得：暴掠龙牙' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41772) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41773, '你将获得：暴掠龙牙' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41773) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41785, '你可以从这些奖励中选择其一：烬火血之坠饰 烬火祝福之坠饰 烬火憎恨坠饰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41785) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41811, '你可以从这些奖励中选择其一：沙丘天使锁甲、沙漠探寻者长裤' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41811) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41841, '你可以从这些奖励中选择其一：雷蒂召唤触 审判之指环' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41841) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41854, '你将获得：次级石盾药水' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41854) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41861, '你将获得：野生的飞往之书' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41861) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41873, '你将获得：布兰加之愚' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41873) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41937, '你可以从这些奖励中选择其一：翡翠旷野树枝 鬼火织环 梦皮护符' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41937) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41940, '你可以从以下奖励中选择一件：优质治疗药水、强效法力药水' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41940) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42005, '你将获得：希尔弗拉尔，阿尔恩的预兆' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42005) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42022, '你可以从这些奖励中选择其一：野生神之胸甲 自然仁慈头盔 狂野力量护腿' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42022) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42056, '你将获得：天界光之衣' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42056) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42079, '你将获得：半焦的卷轴' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42079) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42100, '你将获得：三叶草、一大桶微光酒、幸运高顶帽、绿色焰火' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42100) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42101, '你将获得：三叶草、一大桶微光酒、幸运高顶帽、绿色焰火' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42101) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 60009, '将对你施放以下法术：神圣打击' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 60009) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 60013, '你将获得：冬幕节驯鹿' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 60013) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 80745, '你将获得：美味月饼' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 80745) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));

-- ---- RequestItemsText_loc4（855 条）----
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 4261, '在这片被腐化的土地上，你看到了什么？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 4261) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 5126, '……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 5126) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8107, 'Honor is earned amongst the Zandalar trolls, $R. With honor comes reward - friendship, alliance...$BHand me the talisman so that I may enhance its power.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8107) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8108, 'I am ready for you, $R. Once more I will enhance your talisman. I only ask that you continue in your destruction of 哈卡 and his minions.$BGive me the talisman.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8108) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8111, 'Hey mon! It be good to see you again. The tribe be talking about your killin\' of the Hakkari and all that. 莫托尔 gave me the word to be adding more mojo to your talisman. Just give it here and Maywiki make it better.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8111) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8112, 'How be that talisman, mon? It look like it be time to add a little more magic and mojo to its leaves. It need a little bloom in its wilt. Give it here and Maywiki fix it right up.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8112) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8142, 'Impressive, $R. You have a gift for killing that I have not sensed in another in many years. Even 莫托尔 is aware of the work that you have done for Zandalar. It is time to enhance your talisman further. Give it to me.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8142) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8143, 'I sense that you have dealt countless fatalities to the Hakkari, $R. You carry the stink of their mojo.$BI assume the 黑影 talisman has assisted in the culling? Give it to me and allow me to enhance its power.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8143) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8146, 'Even from here I can hear the sound of your volleys laying waste to our enemies. Their cries echo in agony.$BYou have made quite a name for yourself among the trolls of Zandalar, $R. We are grateful for all that you have done.$BHand me your talisman so that I may add another weave.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8146) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8147, 'Ah, $R, it is good to smell you again.$B<Falthir grins.>$BYou\'ll have to excuse my sense of humor. It can be most foul at times.$BI sense that you have caused great anguish to our enemies. The forces of 哈卡 cry out your name in anger. This is most excellent.$BYou have earned another weave on your talisman. Hand it to me.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8147) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8271, '警告你，士兵：霜狼也在猎杀科尔拉克。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8271) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8272, '警告你，士兵：雷矛也在猎杀科尔拉克。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8272) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8289, '你已经证明了自己在战歌峡谷中的价值!继续帮助我们作战，并给我带来更多的功勋奖章。我们会因此而更加信任你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8289) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8290, '银翼要塞那边有什么消息吗?你有没有击败战歌氏族的部队?' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8290) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8292, '你已经证明了自己在战歌峡谷中的价值!继续帮助我们作战，并给我带来更多的功勋奖章。我们会因此而更加信任你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8292) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8293, '你已经证明了自己在战歌峡谷中的价值!继续攻打银翼要塞的哨兵部队，给我带来更多的功勋奖章!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8293) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8295, '敌人的鲜血就是我们的荣耀，你干得很出色。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8295) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8296, '你已经证明了自己在战歌峡谷中的价值!继续攻打银翼要塞的哨兵部队，给我带来更多的功勋奖章!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8296) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8742, '一千年过去了，正如命中注定，有一个人站在我面前。他将带领自己的人民走向新的时代。上古之神在颤抖，$N。是的，它畏惧你的信念。去粉碎克苏恩的预言吧。它知道你要来，勇士——与你同来的，还有卡利姆多的力量。你只需在准备好时告诉我，我便将流沙节杖授予你。奖励 你将获得：流沙节杖 完成 流沙节杖重归完整，$N。使用节杖的人必须是你。为你的族人开启下一个时代的人，也必须是你。你必须等待部落与联盟的军队抵达希利苏斯，才能敲响甲虫之锣。奖励 完成任务后可获得：9950 点经验值，诺兹多姆的子嗣 500 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8742) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8846, '啊，又来给自己领取补给品了吗?好吧，我当然理解你需要更多物资的想法……不信你可以看看周围。$B我可以给你一些补给品，但是你必须给我几枚荣誉徽章作为交换。你不会因此获得任何声望的提升，但当战斗来临时，这些物资也许可以保住你的性命。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8846) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8850, '啊，又来给自己领取补给品了吗?好吧，我当然理解你需要更多物资的想法……不信你可以看看周围。$B我可以给你一些补给品，但是你必须给我几枚荣誉徽章作为交换。你不会因此获得任何声望的提升，但当战斗来临时，这些物资也许可以保住你的性命。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8850) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8851, '啊，又来给自己领取补给品了吗?好吧，我当然理解你需要更多物资的想法……不信你可以看看周围。$B我可以给你一些补给品，但是你必须给我几枚荣誉徽章作为交换。你不会因此获得任何声望的提升，但当战斗来临时，这些物资也许可以保住你的性命。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8851) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8993, '你是来送仰慕之情礼物给你最喜爱的领导者吗?' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 8993) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9257, '遵命，$R。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 9257) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9269, '遵命，$R。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 9269) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9270, '遵命，$R。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 9270) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9271, '遵命，$R。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 9271) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9321, '除了我们其他的补给外，我们还有很多很有用的极效治疗药水。你拿十五个亡域符文来我就会给你一瓶。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 9321) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9333, '如果你给我带来30个亡域符文，我就会给你一套护手做为回礼。这些东西在我们对抗不死族天灾军团时很有用。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 9333) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9334, '如果你拿天灾军团入侵者的亡域符文来交换，银色黎明就会给你一瓶受祝福的巫师之油。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 9334) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9335, '如果你帮我带来八个天灾军团入侵者的亡域符文，我就能给你一个圣化磨刀石。它们在你对付巫妖王的爪牙时会很有帮助。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 9335) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9336, '除了我们其它的补给外，我们还有很多很有用的极效治疗药水。你拿十五个亡域符文来我就会给你一瓶。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 9336) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9337, '除了我们其它的补给外，我们还有很多很有用的极效法力药水。你拿十五个亡域符文来我就会给你一瓶。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 9337) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9343, '你对我们的目标提供了非常大的帮助，$N。如果你想的话，我可以给你一件银色黎明外袍。有你这样的盟友我们深感荣幸。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 9343) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 39977, '东西都备齐了吗？这点小事，我相信你的本事不会让你失手。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 39977) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 39978, '召集你的朋友们，一起来享受庆典吧！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 39978) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 39979, '召集你的朋友们，一起来享受庆典吧！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 39979) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 39980, '办妥了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 39980) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 39981, '办妥了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 39981) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40056, '魔纹布快见底了，我们需要你帮忙补充库存！只要依靠整个社区的力量，你这边只需捐出 60 块魔纹布，我们就能达成目标。我可以向你保证，奥格瑞玛绝不会忘记这份慷慨！如果你身上正带着那六十块魔纹布，也愿意捐出来，我现在就可以收下。魔纹布（60）' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40056) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40104, '$N？完成 我们……我们正想和部落就那些石板达成协议，那些怪物就扑了上来。他们轻而易举地杀死了我们的同胞和部落的人。奖励 完成任务后可获得：660 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40104) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40106, '完成 奖励 完成任务后可获得：660 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40106) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40114, '完成 奖励 完成任务后可获得：660 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40114) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40184, '完成 奖励 完成任务后可获得：500 点经验值，辛德拉 -100 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40184) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40259, '$N。完成 奖励 完成任务后可获得：8500 点经验值，银色黎明 -500 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40259) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40514, 'Bala dash.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40514) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40616, '$N。完成 从今往后，你就是无畏者！带着骄傲与我们同行吧。我们从此与你共享一切。奖励 完成任务后可获得：4000 点经验值，玛格拉姆半人马部族 1500 点声望，吉尔吉斯半人马部族 -7500 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40616) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40619, '如果说这场战争教会了我们什么，那就是：食物比最致命的武器还重要。没有力气就打不了仗。在这样一片荒芜贫瘠的土地上，我们离真正的抱负还差得远。我要求你来解决这个问题。整个凄凉之地都能见到强壮的科多兽，肉厚实、肥美、量足，对任何战士来说都是完美的一餐。骑马出去，为玛格拉姆部族收集这些科多兽肉。别让我失望。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40619) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40631, '我们格尔基斯部族与许多部族不同：我们与元素的联系强大，而且深植于文化之中。这份联系是我们在这世上最珍视的东西。可我们过去对这份天赋的不敬与粗暴滥用，让我们与元素之灵的关系变得紧张。要想为部族谋一个未来、修复我们给自身精神力量造成的损伤，就必须与元素沟通，陈明我们的诉求，向它们表示敬意。为此，我们需要大量元素能量。这一带到处都盘旋着风与大气的漩涡。从那里给我收集 12 份元素空气。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40631) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40968, '我以前没在这儿见过你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40968) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40974, '事情办妥了吗，$c？完成 干得好，你的付出值得称赞。你击败了那头诅咒我永世不得安息的野兽。收下其中一件，作为我的谢意。奖励 完成任务后可获得：4100 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40974) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40978, '夜里要提高警惕。黑暗之物总在四周徘徊。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40978) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40991, '去荒芜之地的路很远。动身吧。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40991) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40993, '据传克西索斯之眼落入了凄凉之地暗影议会的手中。我听到过一些阴暗的低语，其中提到了一个名字……破影。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40993) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41097, '是的，孩子，我能帮你吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41097) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41274, '你回来了，脸上满是欢畅！告诉我，你看到了什么？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41274) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41277, '完成 奖励 完成任务后可获得：1900 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41277) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41278, '完成 奖励 完成任务后可获得：1900 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41278) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41279, '完成 当他把手掌再次按在你身上时，你眼前的一切清晰了许多，尽管这个过程仍让你吃力。三颗宝石在内视中浮现。幸好你认得出它们：一颗烬石、一颗红宝石和一颗黄水晶。接着你看见同样的宝石被切磨成一种你从未见过的刻面。你凝神细看，把每一个动作都记在心里。这份智慧已刻进你的脑海。> 奖励 完成任务后可获得：4200 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41279) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41280, '完成 下一步在等着你。奖励 完成任务后可获得：3200 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41280) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41281, '完成 瑟格雷恩转向你，赞许地点了点头。最后一步就在眼前了。奖励 完成任务后可获得：4700 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41281) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41282, '完成 你通过了试炼！瑟格雷恩把你引到他的桌旁，迫不及待地想把自己的知识传授给这名新徒弟。奖励 完成任务后可获得：3400 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41282) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41283, '要是没有，就去找来！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41283) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41284, '这些东西可不会长在树上，你懂吧？也不会长在地下，更不会长在任何地方。算了，你就赶紧交上来吧！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41284) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41285, '哦，我多愿意回到诺莫瑞根啊！完成 血迹斑斑，湿淋淋，满是泥浆。唉，看到自己一件上乘之作落到这般不堪的地步，我这心都碎了。不过，还是谢谢你把它找回来。告诉我，你是在他那具被打烂的尸体上找到的，还是被谁的脏手从他身上摸走的？算了，别说了，我宁愿不知道。为酬谢你的高尚之举，我教你亲手打造这条项圈。奖励 完成任务后可获得：4200 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41285) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41287, '小心外面游荡的食人魔，对我来说它们实在太多了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41287) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41288, '这种珍珠常常能在艾泽拉斯各地厚壳的蛤蜊里找到。许多水栖生物身上也带着它们。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41288) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41289, '我相信弄到这些宝石对你不成问题。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41289) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41291, '但愿我的仪器没被潮水损坏。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41291) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41292, '坚持下去。那些愿意一次次经历失败的人，早已反复证明自己正朝着这门手艺的行家迈进。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41292) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41293, '别想用速度来打动我。我一向敬重那些肯花时间细细琢磨的人。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41293) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41294, '我们的作品是用来造福他人还是危害他人，并不归我们管。工匠打造自己的作品时不会去想谁是使用者，只想着它的用途。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41294) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41295, '有时一想到她的下落，我就会变得多愁善感。可为 她 担忧终究毫无用处，尽管这念头很难压下去。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41295) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41296, '有事吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41296) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41297, '你的本事都丢了吗？没用的渣滓，我当初就不该在你身上浪费时间。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41297) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41298, '把德莱尼水晶搬到德拉诺去，就意味着困在这个凄凉而令人作呕的世界里的所有德莱尼都会死。库米沙不能允许这种事发生。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41298) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41299, '你从那片受诅咒的荒野回来了，而且只有你一个人。请告诉我发生了什么。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41299) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41300, '什么事？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41300) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41301, '这些东西你自己做也好，去别处买也好，我都不管。只要保证品质上乘就行，我们的资助人讲究水准。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41301) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41302, '$N！怎么去了这么久？我还以为他们提前送你去来世了。怎么样，说吧？我安全了吗？完成 什么？！这才是我被承诺的一半！这个该死的刽子手、油滑的鼻涕虫，还有他那帮吓人的保镖都不得好死！嗯，至少我还没死，对吧？这得谢谢你——真的，我很感激！你毫不犹豫地为我出头，这年头可不常见。希望这些混混不会再来找我麻烦。不过说真的：你替我把珠宝送过去，难道你是个珠宝匠？如果是，请让我把一件专利设计分享给你，酬谢你的英勇！奖励 完成任务后可获得：800 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41302) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41304, '$N，你到哪儿去了？我的珠宝找到了吗？你把Grizzby留在哪儿了？完成 噢，那些背后捅刀、啃痂皮的穴居怪！离开风险投资公司是Nert这辈子做过最正确的决定，我早就受够他们那些见不得人的手段了。我不仅丢了所有珍贵的珠宝，还失去了最好的承包商，要找个替代的人得花上好久！噢，Grizzby，你这老混蛋，你本该有更好的下场，好得多……奖励 完成任务后可获得：2300 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41304) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41305, '快点，$N！打造杰作急不得，可下一场拍卖只剩几天了！完成 哦，哇！这东西几乎跟我的鼻子一样大！那些冒险者没吹牛，一点没吹。还有你带来的项链，工艺精细得惊人，真是让人佩服。我就说你有珠宝加工的天分。真的，你帮了我大忙。等那些靴子湾的牛人看见这件美物，准得流口水，你等着瞧！为答谢你的辛苦与相助，让我把一件自己最中意的设计分享给你。奖励 完成任务后可获得：3700 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41305) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41307, '完成 这是什么？特拉西斯的货？我等这个等了好久！那地精和他那一塌糊涂的服务到底在搞什么？不管怎样，谢谢你替他完成了活。要不是他有那么独家的货源，这就是我最后一次在他那儿订货了。奖励 完成任务后可获得：4300 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41307) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41308, '你想要什么，陆地行者？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41308) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41309, '这么快就回来了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41309) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41310, '你回来了，你需要什么？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41310) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41311, '小心行事，$N。如果这个恶魔从第三次大战中活了下来，那就绝不能小瞧他。完成 那件握物又回到了我手里，简直像个诅咒。你居然毫发无伤地回来了，令我十分佩服——你的实力已可与大英雄比肩。现在说说那件握物……奖励 完成任务后可获得：6200 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41311) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41312, '有人或许会说这是不可能完成的事。但你展现出的本事，已经足够让我看清你和你的耐力。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41312) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41313, '门纳尔湖是一处奥术能量的汇聚点，蓝龙军团聚集在那里并不令人费解。不过血精灵究竟在这里做什么，我就想不通了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41313) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41314, '我要找的东西有进展了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41314) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41315, '聚焦宝珠能确保魔法能量不会使水晶过载。所以不必担心它们会突然在你身边猛烈爆开。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41315) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41316, '哦，一张熟面孔。又回来受训了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41316) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41317, '说真的，我已经等不及要拿到这本书里那份美滋滋的图纸了！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41317) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41318, '别小看我侏儒的头脑。我很快就能破解这密码！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41318) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41319, '我最初为这台增幅器设想的镜片，根本承受不住那样的高温。不过，有了山脉之血和黑铁外壳，我们或许就大有机会成功。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41319) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41320, '请，一定要坐下，随意些。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41320) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41321, '我已经很久没尝过脑子的味道了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41321) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41322, '尽管我知道很多我们族人的食谱，我的厨艺却并不好。避难营里随便问谁都行——连诺布罗都被认为比我更会做饭！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41322) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41323, '我不会天真到以为逃到艾泽拉斯就能让我们免受世间一切邪恶的侵扰，可一想到这处堕落的温床就盘踞在我们新家园的正中央，我又怎能不感到沮丧。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41323) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41325, '谨慎行事。我们不知道有什么异界的恐怖之物在等着我们。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41325) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41326, '$N，你坐立不安。说吧，找到 Akh Zador 了吗？完成 我悲痛欲绝。哪怕在最荒唐的梦里，我也想不到会发生这种事。桑维·塔斯达尔，曾是我的导师、我们部族的酋长与高贵的领袖，竟然屈服于燃烧军团甜蜜的谎言。若不是你和 Akh Zador，我和我的族人早就跟着他回到德拉诺，余生都当军团阴谋的棋子了。避难所永远欠你一份情。言语无法表达我对你这份无私的感激有多深，所以，请收下这件所有德莱尼赠予你的谢礼。奖励 完成任务后可获得：8300 点经验值，1000 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41326) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41328, '你需要我时，我随时都在。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41328) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41329, '啊嘿，船长！偷看到我的新配方了吧，是不是？你知道麦芽酒更合我心意，兄弟们想喝我随时乐意张罗，我信你也是。可真正的问题来了，船长。你瞧，酒是好的，可兄弟们开始坐不住了。外头这么热，整天只灌麦芽酒哪行！要让海巫婆诅咒我们吧，不喝醉谁肯干活？所以，身为这伙人的船长，你得担起责任来！呸，我这舌头在嘴里转得太多了。我们需要朗姆酒，船长。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41329) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41330, '啊嘿，船长！偷看到我的新配方了吧，是不是？你知道麦芽酒更合我心意，兄弟们想喝我随时乐意张罗，我信你也是。可真正的问题来了，船长。你瞧，酒是好的，可兄弟们开始坐不住了。外头这么热，整天只灌麦芽酒哪行！要让海巫婆诅咒我们吧，不喝醉谁肯干活？所以，身为这伙人的船长，你得担起责任来！呸，我这舌头在嘴里转得太多了。我们需要朗姆酒，船长。 黑暗美味朗姆酒（10）' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41330) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41331, '啊嘿，船长！偷看到我的新配方了吧，是不是？你知道麦芽酒更合我心意，兄弟们想喝我随时乐意张罗，我信你也是。可真正的问题来了，船长。你瞧，酒是好的，可兄弟们开始坐不住了。外头这么热，整天只灌麦芽酒哪行！要让海巫婆诅咒我们吧，不喝醉谁肯干活？所以，身为这伙人的船长，你得担起责任来！呸，我这舌头在嘴里转得太多了。我们需要朗姆酒，船长。 黑标美味朗姆酒（10）' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41331) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41332, '啊嘿，船长！偷看到我的新配方了吧，是不是？你知道麦芽酒更合我心意，兄弟们想喝我随时乐意张罗，我信你也是。可真正的问题来了，船长。你瞧，酒是好的，可兄弟们开始坐不住了。外头这么热，整天只灌麦芽酒哪行！要让海巫婆诅咒我们吧，不喝醉谁肯干活？所以，身为这伙人的船长，你得担起责任来！呸，我这舌头在嘴里转得太多了。我们需要朗姆酒，船长。 烈性朗姆酒（5）' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41332) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41333, '完成 奖励 完成任务后可获得：3750 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41333) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41334, '完成 奖励 完成任务后可获得：3750 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41334) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41335, '哦，$N！很高兴又见到你。说吧，这些日子过得可好？完成 不得不说，这是一本古怪的书。上面有一个古老的印记，我并不熟悉。真有意思……不管怎样，解读这本书对我而言不成问题。请稍等片刻，我会把从书页里能解出的知识告诉你。奖励 完成任务后可获得：3750 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41335) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41336, '别担心。符文的力量取决于它被用在什么场合。它不会让那本书召出什么可怕的恶灵来，朋友。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41336) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41337, '哦，$N！很高兴又见到你。说吧，这些日子过得可好？完成 不得不说，这是一本古怪的书。上面有一个古老的印记，我并不熟悉。真有意思……不管怎样，解读这本书对我而言不成问题。请稍等片刻，我会把从书页里能解出的知识告诉你。奖励 完成任务后可获得：3750 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41337) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41338, '你好，冒险者。为了确保我们的世界得以延续，任何愿意出手相助的人我们都欢迎。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41338) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41339, '这片山丘潜藏的力量，即使是不通自然之道的人也能感受到。它会引来恶徒，这一点我们不能视而不见。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41339) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41340, '$N！大德鲁伊梦风告诉了我海加尔山发生的事。梦境碎片你带在身上了吗？完成 干得好，$N。看到你这么迅速就完成了任务，我就更不必担心接下来要请你做的事了。你或许不知道，我和我的同胞都是玛洛恩的后裔。正是他与月神伊露恩的结合，孕育了我们的父神塞纳留斯——而他又创造了我们。这件事不仅关乎海加尔山的安危，关乎我的家族，更关乎整个艾泽拉斯。奖励 完成任务后可获得：6600 点经验值，塞纳里奥议会 100 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41340) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41341, '像玛洛恩这样高贵的存在，他对自然的爱与关怀远超我们所知的任何事物，必须受到保护。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41341) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41342, '别发愁，竭尽全力消灭梦魇的影响。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41342) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41343, '什么事，法师？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41343) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41344, '大蜡烛在哪儿？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41344) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41345, '这座简陋的祭坛散发着一股原始而不祥的气息。躺在它旁边的巨魔，或许就是它所蕴含力量的不祥征兆。不过，看起来仍然可以在它粗糙的表面上献上一些供品……克拉科拉的远古神像 元素之水（10） 电鳗（5）' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41345) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41346, '这只旧箱子几乎与洞穴内壁融成一体。锁上刻着一个字母“G”。旁边是一本破烂的书，或者说它的残骸。你匆匆翻了翻，猜测这只箱子属于曾住在岛上的某个人。最后一段还能辨认的内容提到要去弄些鱼当今天的饭。藤壶覆盖的钥匙' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41346) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41349, '完成 奖励 完成任务后可获得：3200 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41349) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41350, '你是想让我为你打造一把好剑吗？恐怕要让你失望了，我打铁的日子已经结束了。如今的我，不过是这处早已被人遗忘之地的一段记忆罢了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41350) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41351, '$N！很高兴见到你。说说看，你的搜寻有收获吗？完成 难以置信，简直惊人！你是个了不起的侦探，这么短时间就查清了这桩陈年谜案。要是我还在自己的庄园里，我一定让我兄弟把你封进我们的私人随从。可惜啊，我相信这世界的惊奇才是你向往之物，而我的不死之身把我困在这里。不过别担心——项链回来了，我就能带着鄙夷忍受这无尽的游魂日子了。按约定，这件东西归你：塔楼之主、守护者麦迪文亲手打造的珍贵红宝石戒指。奖励 完成任务后可获得：8200 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41351) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41352, '谁在那儿？！我认识你吗？完成 这枚戒指……是我姑姑 Tillia 的？不，这……不可能。姑姑从不与自己的首饰分开，只有她最珍视的人才会被赠予。难道说……？哪怕在我偷走了她最爱的那条项链之后……陌生人，你到底是怎么弄到它的？！Tillia 几十年前在前往那座受诅咒的守护者之塔的旅途中失踪了。反正都一样。拿着你的玩意儿走吧。对我来说都结束了，一枚昂贵的戒指能给我带来什么好处？卖了它，戴着它，我都不在乎。就让我一个人待在痛苦里吧。奖励 完成任务后可获得：3200 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41352) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41353, '让我一个人待着。这里没有你要的东西。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41353) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41354, '无论是受难者还是痛苦者，你都必须引导他们。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41354) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41355, '你的任务有收获了吗？还是说尚未完成？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41355) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41356, '我能感觉到，你曾面对过比这些巨人更强的敌人。我想你不需要更多的指点了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41356) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41357, '那东西还是毁掉为好。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41357) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41358, '什么风把你吹来了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41358) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41359, '有什么消息？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41359) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41360, '但愿我们能在更好的情形下相识。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41360) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41361, '陌生人，你最好是有正当理由才来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41361) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41362, '黑铁矮人向来以能驾驭山脉的身躯而自豪。在支配黑铁矿石以及地壳中那些数不清的奇特宝石方面，很少有别人能展现出这样的造诣。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41362) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41363, '小心。这处噩梦之巢极其危险，而你途经部落领地的旅途同样凶险。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41363) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41364, '我们只是遵从我女主人的吩咐。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41364) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41365, '有话就说。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41365) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41366, '悲惨的命运。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41366) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41367, '一场梦魇接着一场。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41367) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41368, '别为达格埃尔姆的死操心，他现在多半已经成了个疯狂的狂信徒。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41368) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41369, '卡拉赞建在魔网的交汇点上。塔里的生物依靠这层联结汲取力量，从中获得难以战胜的伟力。务必小心。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41369) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41370, '我们正站在一个历史性的关键时刻。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41370) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41371, '想想我在幻象中看到的那个地方。也许你听到的东西，让你想起了旅途上已经见过的某事或某人。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41371) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41372, '别让我们等太久。我们可不想让这些魔法一直处于失控状态。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41372) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41373, '一切还合你心意吗，尊贵的客人？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41373) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41374, '你要找的东西，找到了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41374) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41375, '你似乎带着什么吸引了你的东西。让我看看。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41375) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41376, '一种怀旧之情流过我的骨骼。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41376) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41377, '什么事？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41377) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41378, '必须净化这柄镰刀。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41378) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41379, '你回来了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41379) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41380, '是的，孩子？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41380) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41381, '必须净化穆沙之镰。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41381) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41382, '你回来了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41382) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41383, '时间紧迫。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41383) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41384, '别犹豫。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41384) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41385, '我不能离开诺达希尔，现在还不行。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41385) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41386, '办妥了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41386) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41387, '这番考验会让我看清你是否真有本事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41387) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41388, '没有哪一堂课是相同的。弄清它们之间的联系以及其中的过错，你才能领会其中的智慧。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41388) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41389, '上面到底发生了什么？那里闻起来像是烧焦的血肉。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41389) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41391, '这么快就回来了？希望你不是空着手……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41391) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41392, '别浪费时间。我可没有肖尔大师那么有耐心。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41392) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41393, '现在可不能动摇。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41393) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41394, '需要的材料找到了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41394) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41395, '帕拉丁内特碎片 深蓝碎片 枢机碎片 奖励 你将获得：赞之宝石 完成 奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41395) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41396, '我或许有能力窥视翡翠梦境，但那些恩惠只对我自己有效——遗憾的是，它没法用在别人身上。不过别发愁，我会尽力帮你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41396) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41397, '这么久没听到维瑟库斯的消息，我很担忧。但愿他平安无事，梦境已不再是昔日那片庇护之地了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41397) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41398, '完成 你抬起目光，与半神的目光相接，一股力量感涌遍全身。那种感觉无可比拟：成长、感激与爱。来得快去得也快。你仿佛重生，向这位守路人致意，然后让他继续履行职责。> 奖励 完成任务后可获得：7200 点经验值，塞纳里奥议会 200 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41398) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41399, '我们必须看护好这枚戒指。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41399) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41400, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41400) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41401, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41401) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41402, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41402) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41403, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41403) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41404, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41404) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41405, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41405) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41406, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41406) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41407, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41407) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41408, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41408) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41409, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41409) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41410, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41410) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41411, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41411) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41412, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41412) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41413, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41413) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41414, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41414) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41415, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41415) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41416, '浪荡的老鼠回来了！你找到了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41416) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41417, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41417) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41418, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41418) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41419, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41419) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41420, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41420) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41421, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41421) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41422, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41422) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41423, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41423) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41424, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41424) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41425, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41425) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41426, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41426) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41427, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41427) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41428, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41428) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41429, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41429) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41430, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41430) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41431, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41431) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41432, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41432) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41433, '柯菲斯知道自己在做什么。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41433) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41434, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41434) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41435, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41435) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41436, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41436) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41437, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41437) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41438, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41438) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41439, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41439) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41440, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41440) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41441, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41441) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41442, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41442) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41443, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41443) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41444, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41444) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41445, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41445) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41446, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41446) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41447, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41447) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41448, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41448) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41449, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41449) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41450, '这枚戒指会为你的灵魂带来平衡，孩子。是惩击还是鞭笞，全凭你自己。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41450) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41451, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41451) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41452, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41452) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41453, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41453) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41454, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41454) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41455, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41455) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41456, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41456) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41457, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41457) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41458, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41458) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41459, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41459) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41460, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41460) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41461, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41461) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41462, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41462) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41463, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41463) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41464, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41464) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41465, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41465) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41466, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$N。完成 谨慎选择，你的决定不可更改。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41466) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41467, '我们开始吧！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41467) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41468, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41468) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41469, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41469) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41470, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41470) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41471, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41471) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41472, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41472) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41473, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41473) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41474, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41474) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41475, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41475) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41476, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41476) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41477, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41477) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41478, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41478) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41479, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41479) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41480, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41480) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41481, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41481) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41482, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41482) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41483, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41483) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41484, '希望你选对了，另一枚戒指我不会收回。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41484) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41485, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41485) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41486, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41486) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41487, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41487) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41488, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41488) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41489, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41489) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41490, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41490) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41491, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41491) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41492, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41492) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41493, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41493) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41494, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41494) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41495, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41495) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41496, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41496) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41497, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41497) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41498, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41498) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41499, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41499) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41500, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41500) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41501, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41501) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41502, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41502) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41503, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41503) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41504, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41504) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41505, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41505) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41506, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41506) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41507, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41507) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41508, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41508) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41509, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41509) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41510, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41510) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41511, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41511) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41512, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41512) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41513, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41513) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41514, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41514) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41515, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41515) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41516, '谨慎选择，你的决定不可更改。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41516) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41517, '我要的东西，你带来了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41517) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41518, '这世上没有白得的东西。你的成长得靠自己去挣。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41518) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41519, '你好！我平时都在忙着解读 Sakgoth 带给我的这些旧文献，不过这会儿还有点空。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41519) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41520, '徒弟，看到你如此用功，我很高兴。诺拉把事情都告诉了我。她派你去做的事，你完成了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41520) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41521, '这世上没有白得的东西。你的成长得靠自己去挣。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41521) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41522, '你好！我平时都在忙着解读 Sakgoth 带给我的这些旧文献，不过这会儿还有点空。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41522) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41523, '徒弟，看到你如此用功，我很高兴。诺拉把事情都告诉了我。她派你去做的事，你完成了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41523) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41524, '这世上没有白得的东西。你的成长得靠自己去挣。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41524) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41525, '你好！我平时都在忙着解读 Sakgoth 带给我的这些旧文献，不过这会儿还有点空。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41525) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41526, '徒弟，看到你如此用功，我很高兴。诺拉把事情都告诉了我。她派你去做的事，你完成了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41526) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41527, '这世上没有白得的东西。你的成长得靠自己去挣。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41527) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41528, '你好！我平时都在忙着解读 Sakgoth 带给我的这些旧文献，不过这会儿还有点空。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41528) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41529, '徒弟，看到你如此用功，我很高兴。诺拉把事情都告诉了我。她派你去做的事，你完成了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41529) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41530, '这世上没有白得的东西。你的成长得靠自己去挣。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41530) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41531, '你好！我平时都在忙着解读 Sakgoth 带给我的这些旧文献，不过这会儿还有点空。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41531) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41532, '徒弟，看到你如此用功，我很高兴。诺拉把事情都告诉了我。她派你去做的事，你完成了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41532) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41533, '这世上没有白得的东西。你的成长得靠自己去挣。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41533) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41534, '你好！我平时都在忙着解读 Sakgoth 带给我的这些旧文献，不过这会儿还有点空。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41534) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41535, '徒弟，看到你如此用功，我很高兴。诺拉把事情都告诉了我。她派你去做的事，你完成了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41535) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41536, '这世上没有白得的东西。你的成长得靠自己去挣。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41536) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41537, '你好！我平时都在忙着解读 Sakgoth 带给我的这些旧文献，不过这会儿还有点空。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41537) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41538, '徒弟，看到你如此用功，我很高兴。诺拉把事情都告诉了我。她派你去做的事，你完成了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41538) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41539, '这世上没有白得的东西。你的成长得靠自己去挣。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41539) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41540, '你好！我平时都在忙着解读 Sakgoth 带给我的这些旧文献，不过这会儿还有点空。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41540) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41541, '徒弟，看到你如此用功，我很高兴。诺拉把事情都告诉了我。她派你去做的事，你完成了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41541) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41542, '这世上没有白得的东西。你的成长得靠自己去挣。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41542) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41543, '你好！我平时都在忙着解读 Sakgoth 带给我的这些旧文献，不过这会儿还有点空。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41543) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41544, '徒弟，看到你如此用功，我很高兴。诺拉把事情都告诉了我。她派你去做的事，你完成了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41544) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41545, '这世上没有白得的东西。你的成长得靠自己去挣。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41545) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41546, '你好！我平时都在忙着解读 Sakgoth 带给我的这些旧文献，不过这会儿还有点空。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41546) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41547, '徒弟，看到你如此用功，我很高兴。诺拉把事情都告诉了我。她派你去做的事，你完成了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41547) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41548, '这世上没有白得的东西。你的成长得靠自己去挣。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41548) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41549, '你好！我平时都在忙着解读 Sakgoth 带给我的这些旧文献，不过这会儿还有点空。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41549) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41550, '徒弟，看到你如此用功，我很高兴。诺拉把事情都告诉了我。她派你去做的事，你完成了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41550) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41555, '但愿他们不是用荆棘草酿的；我自己试过一次，那味道简直糟透了！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41555) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41556, '我居然会从野猪人那里学酿酒，今天真是想不到。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41556) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41557, '这些狂热之徒拼命守护他们的秘密，可我们在追求终极麦芽酒的路上比他们更狠。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41557) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41558, '银色蛇麻草有着落了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41558) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41559, '嚼蛇麻草。呃。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41559) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41560, '它们的生存环境可能让它们变得脆硬，处理时小心点。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41560) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41561, '我按捺不住激动。我一年的心血终于要结果了！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41561) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41562, '黄色蛇麻草有收获吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41562) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41563, '我尝过一次洛丹伦麦酒。老天，跟你说吧，那之后打的那一架可真够呛。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41563) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41564, '辛特兰的土壤很肥沃，长出来的植物结实耐用。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41564) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41565, '有人也许会骂我把元素之水掺进麦芽酒是异端，对这种人我只想说：你缺乏想象力！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41565) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41566, '阿拉希高地长着大片金棘草。如果你是个熟练的草药师，可以在那片辽阔的田野和丘陵里自己采。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41566) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41567, '完成 我的计划，全被撕碎了！黑须竟敢糟蹋我历经数年艰辛、血汗与泪水换来的成果，但愿他得到了应有的下场！所幸配方里重要的部分我还能读懂。谢谢你，$N。我知道你为了我冒险闯进那座该死的山，连身家性命都搭上了。这些东西回到我手里，我们终于走到旅程的尽头了。奖励 完成任务后可获得：2200 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41567) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41568, '我们离成就一件极为重大的事只差这么一点了！我将作为那款传奇、终极麦酒的创造者载入史册！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41568) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41569, '你最好开始活动脚底了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41569) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41570, '你最好开始活动脚底了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41570) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41571, '你最好开始活动脚底了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41571) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41572, '拜托，快一点。再多盯着这身难看的行头一会儿，我就要吐了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41572) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41573, '拜托，快一点。再多盯着这身难看的行头一会儿，我就要吐了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41573) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41574, '拜托，快一点。再多盯着这身难看的行头一会儿，我就要吐了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41574) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41575, '拜托，快一点。再多盯着这身难看的行头一会儿，我就要吐了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41575) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41576, '拜托，快一点。再多盯着这身难看的行头一会儿，我就要吐了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41576) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41577, '好臭的味道！$N，你带回来的是什么鬼东西？！完成 多么可怕的局面。想想看，我们差点又站在燃烧军团入侵的边缘。$N，你和你同伴的所作所为不仅让艾泽拉斯免于又一场战争，还除掉了我们所知最强大的恐惧魔王之一。他的威名仅次于七年前军团入侵的先锋提克迪奥斯，连达拉然的六人议会里都流传着他的传说。这样一位叱咤风云的人物就此殒命，简直难以想象。你把他那颗邪恶的心脏带来给我，做得对。我能把它血肉中的邪能精华烧尽，虽然这对我的身体负担极大。但那只是小小的牺牲。只要能把这个污秽的存在从世上除掉，付出多少都不算什么。剩下的东西你留着吧，当作战利品——记住你今日的壮举。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41577) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41578, '收集这些材料可不是件容易事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41578) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41579, '你若想驾驭这件物品的力量，就必须拿到所需的材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41579) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41580, '无论付出什么代价，都是值得的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41580) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41581, '相信你自己能找到那些材料；你若想让我们继续下去，就必须做到。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41581) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41582, '记住，没有这些材料，我们也许就无法继续。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41582) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41583, '你若想看到这件物品恢复如初，就必须收集那些材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41583) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41584, '收集这些材料可不是件容易事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41584) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41585, '你若想驾驭这件物品的力量，就必须拿到所需的材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41585) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41586, '无论付出什么代价，都是值得的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41586) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41587, '相信你自己能找到那些材料；你若想让我们继续下去，就必须做到。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41587) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41588, '记住，没有这些材料，我们也许就无法继续。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41588) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41589, '你若想看到这件物品恢复如初，就必须收集那些材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41589) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41590, '收集这些材料可不是件容易事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41590) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41591, '你若想驾驭这件物品的力量，就必须拿到所需的材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41591) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41592, '无论付出什么代价，都是值得的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41592) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41593, '相信你自己能找到那些材料；你若想让我们继续下去，就必须做到。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41593) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41594, '记住，没有这些材料，我们也许就无法继续。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41594) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41595, '你若想看到这件物品恢复如初，就必须收集那些材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41595) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41596, '收集这些材料可不是件容易事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41596) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41597, '你若想驾驭这件物品的力量，就必须拿到所需的材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41597) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41598, '无论付出什么代价，都是值得的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41598) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41599, '相信你自己能找到那些材料；你若想让我们继续下去，就必须做到。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41599) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41600, '记住，没有这些材料，我们也许就无法继续。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41600) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41601, '你若想看到这件物品恢复如初，就必须收集那些材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41601) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41602, '收集这些材料可不是件容易事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41602) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41603, '你若想驾驭这件物品的力量，就必须拿到所需的材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41603) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41604, '无论付出什么代价，都是值得的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41604) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41605, '相信你自己能找到那些材料；你若想让我们继续下去，就必须做到。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41605) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41606, '记住，没有这些材料，我们也许就无法继续。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41606) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41607, '你若想看到这件物品恢复如初，就必须收集那些材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41607) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41608, '收集这些材料可不是件容易事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41608) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41609, '你若想驾驭这件物品的力量，就必须拿到所需的材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41609) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41610, '无论付出什么代价，都是值得的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41610) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41611, '相信你自己能找到那些材料；你若想让我们继续下去，就必须做到。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41611) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41612, '记住，没有这些材料，我们也许就无法继续。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41612) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41613, '你若想看到这件物品恢复如初，就必须收集那些材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41613) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41614, '收集这些材料可不是件容易事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41614) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41615, '你若想驾驭这件物品的力量，就必须拿到所需的材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41615) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41616, '无论付出什么代价，都是值得的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41616) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41617, '相信你自己能找到那些材料；你若想让我们继续下去，就必须做到。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41617) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41618, '记住，没有这些材料，我们也许就无法继续。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41618) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41619, '你若想看到这件物品恢复如初，就必须收集那些材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41619) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41620, '收集这些材料可不是件容易事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41620) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41621, '你若想驾驭这件物品的力量，就必须拿到所需的材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41621) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41622, '无论付出什么代价，都是值得的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41622) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41623, '相信你自己能找到那些材料；你若想让我们继续下去，就必须做到。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41623) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41624, '记住，没有这些材料，我们也许就无法继续。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41624) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41625, '你若想看到这件物品恢复如初，就必须收集那些材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41625) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41626, '收集这些材料可不是件容易事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41626) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41627, '你若想驾驭这件物品的力量，就必须拿到所需的材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41627) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41628, '无论付出什么代价，都是值得的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41628) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41629, '相信你自己能找到那些材料；你若想让我们继续下去，就必须做到。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41629) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41630, '记住，没有这些材料，我们也许就无法继续。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41630) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41631, '你若想看到这件物品恢复如初，就必须收集那些材料。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41631) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41632, '带着你狩猎的战利品回来。亵渎徽记' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41632) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41633, '但愿你的口袋别显得太松。亵渎之戒' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41633) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41634, '你与我那座塔的交涉进行得如何了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41634) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41635, '注意安全，冒险者。北风领的山丘不该被无辜者的鲜血浸透。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41635) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41636, '欢迎来到我们这座简陋的教堂。你是来探望某位逝者，还是想来安静地祈祷？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41636) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41637, '你那边情况如何？希望那些小家伙不至于太难对付。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41637) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41638, '战争结束了，我本以为北风领终于能回归它宁静的本来面目。也许是我太天真了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41638) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41639, '你最好别问我拿这些做什么。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41639) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41640, '你成功了吗？拜托，小心一点，别为了我而鲁莽行事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41640) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41641, '它们的敌意毫无道理。我在想，它们究竟有什么目的？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41641) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41642, '哦，蒙福的圣光，请把这只迷途的羔羊引回你的羊群。愿他的儿子不必忍受孤独之苦，愿他与亲人同伴重聚。完成 多么悲惨的事，克里斯托夫是个真正善良的人，也是个好父亲。看他死于这样一场毫无意义的死亡，我心都碎了。可可怜的、可怜的 阿诺德 呢？他成了孤儿，我为他担忧。请让我来处理该怎么把他的父亲的事告诉他吧。琥珀郡教堂那位可敬的修女知道该怎么说。谢谢你，善良的人。你今天做了一件好事。愿圣光的祝福照在你前行的路上。奖励 完成任务后可获得：2150 点经验值，暴风城 100 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41642) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41643, '完成 有意思。有了你带来的证词，再加上我自己掌握的情报，我们应该能锁定几名嫌疑人。干得好。奖励 完成任务后可获得：850 点经验值，暴风城 100 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41643) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41644, '北风领的人很有钱。到目前为止我们还没有收到任何赎金要求，但我不排除这种事很快就会发生。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41644) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41645, '说得轻一点，我们与黑铁矮人的关系相当紧张。铁炉堡的铜须矮人对这段关系有一套更……有创意的说法。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41645) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41646, '如果你也想帮忙把主力部队赶出北风领，当地的一位执法官正在“丰满的南瓜”里筹划自己的行动。它在东南方的格里门湖边上。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41646) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41648, '好了，好了。别让我等太久。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41648) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41649, '记住：绿色，滑杆向下，然后把旋钮往左拧！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41649) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41650, '完成 奖励 完成任务后可获得：6300 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41650) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41651, '嘿，伙计！你回来了——找到隐身爵士了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41651) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41652, '我很忙！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41652) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41653, '完成 奖励 完成任务后可获得：1200 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41653) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41654, '我的父亲和祖父不会是最后一代恪守这一传统的人。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41654) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41655, '别犹豫。这项任务你早已准备好，我确信。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41655) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41656, '我能为你做什么，$C？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41656) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41657, '你带来的是什么？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41657) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41658, '若想在接下来的战斗中取胜，你必须做好准备。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41658) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41659, '你的进展如何，$N？完成 干得漂亮。萨尔加拉兹矿场蕴含着相当可观的铁矿，这正好能为我们的行动提供极大的助力。收下这个吧，作为你今天所作所为的奖赏。奖励 完成任务后可获得：2650 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41659) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41660, '带着徽记回来了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41660) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41661, '我真怀念握着画笔的日子……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41661) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41662, '泥土和豺狼人的口水——我得把这身衣服烧掉。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41662) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41663, '还有更多卷轴要读。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41663) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41664, '我的肩膀沉甸甸的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41664) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41665, '上前来，信使，把你带的东西交给我。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41665) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41666, '人们为了甜甜圈简直要闹翻天了……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41666) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41667, '我要把她脸上的笑容抹掉。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41667) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41668, '唉，我可怜的安度因。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41668) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41669, '你应该去和卡特拉娜女士或伯瓦尔谈谈，我不便多说。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41669) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41670, '不是什么轻松差事，但终究是件该做的事。愿圣光与你同行。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41670) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41671, '那场火又是一次对信仰的考验。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41671) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41672, '我就指望你了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41672) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41673, '她看到那颗珍珠时显得非常兴奋。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41673) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41674, '但愿他们永远没有一天安宁。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41674) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41675, '兽人，该死的兽人。兽人！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41675) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41676, '办妥了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41676) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41677, '需要燧石和火石吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41677) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41678, '圣杯在你那儿吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41678) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41679, '我说的是烧焦的骨头，不是煤块。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41679) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41680, '呃？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41680) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41681, '卫葛斯听到了！呜咻——咚——砰！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41681) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41682, '矮人都是恶心的猪猡。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41682) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41683, '一刻也别浪费。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41683) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41684, '$N？什么事让你来找我？你找到凶手了？！快说！完成 这么说，果然是兽人干的；但不是黑石兽人。你描述的样子，跟我们近来遇到的任何兽人部族都对不上，至少我记忆里没有。我们把这个交给暴风城，让总部去追查。至于那个女孩……我会亲自去把她的遗体带回来，反正那个兽人营地我也得去看一趟。告诉她母亲的事就交给我吧，那种事本来也不该落到你这样的人头上。奖励 完成任务后可获得：2100 点经验值，暴风城 100 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41684) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41685, '你找军情七处有什么事？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41685) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41687, '你要是没浑身沾满灰烬和鲜血，就别回来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41687) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41688, '哦，你好。抱歉，我实在没时间闲聊。好多参赛者的马都等着我准备好去训练呢。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41688) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41689, '完成 奖励 完成任务后可获得：2650 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41689) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41690, '今天忙得不可开交，你说是吧？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41690) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41691, '别耽搁太久，它这状态撑不了永远。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41691) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41692, '＜你四周的情形说明这里曾爆发过一场激战，盘旋在破败营地周围的食腐鸟描出一幅凄惨的景象。你在散落的补给中找到的日记，也许能揭开这里发生过什么。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41692) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41693, '哦，见到另一位$R真是太好了！求你了，你得把我救出去！他们的头目在最上面几层，那家伙身材魁梧、手段铁腕！钥匙在她手里；快点，我们没多少时间了！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41693) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41694, '$N，你回来了？特工德里尔比你早到没多久，浑身上下都是重伤。我们已经送他回暴风城养伤。不过说说看，你查到什么了吗？完成 可惜了，今天我们折损了几名宝贵的特工。我会给他们的家人去信，他们为王国效力的事不会被忘记。现在，说说这份卷轴……奖励 完成任务后可获得：3400 点经验值，暴风城 100 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41694) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41695, '你好，朋友，我能帮你什么？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41695) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41696, '盖尔罗尔？不，不，不……加尔博？不对，也不是这个……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41696) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41697, '在任何威胁真正成形之前就将其清除，这很重要。永远比敌人快两步，是每个军情七处成员都刻进骨子里的信条。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41697) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41698, '可惜这么浓的雾，我是看不到那些漂亮的爆炸了。眼下听听响动也就够了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41698) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41699, '诺普西翻译完了吗？你查出什么了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41699) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41700, '维瑞克斯的贪婪让我失去了我那艘漂亮的飞艇，他必须为自己的罪行付出代价！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41700) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41701, '用它们黏糊糊的血把海面染红吧，不过要留意在这片水域游荡的鲨鱼。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41701) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41702, '看它们的举动，你会以为这里有什么它们想要的东西，可我想破头也想不出那究竟是什么。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41702) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41703, '修理可占不了我们太多时间，这里的潮湿可不能小看。我可不想飞艇的船壳半路在荆棘谷上散架，所以快点，行吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41703) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41704, '他们的哀号萦绕在我这具不死的躯体上，那片嘈杂在控诉我身为领主却如此无能。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41704) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41705, '完成 你最后那一手有没有让她死得不那么痛苦，你只能猜测。至少你可以确定，她已经不再受折磨了。奖励 完成任务后可获得：2400 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41705) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41706, '尚多·鹿盔掌握着揭开这个谜团的学识。帮他阻止这片黑暗蔓延，是我们的职责。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41706) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41707, '完成 有意思，这些蘑菇菌株还在不断寻找肥沃的土壤扎根繁殖。正常情况下，不扎在合适的土里它们很快就会死，可这些不一样——它们扭动着、四处试探，主动寻找养分。看着真叫人毛骨悚然。为了我们特工着想，这个恶心的细节我就不上报了。奖励 完成任务后可获得：2800 点经验值，暴风城 100 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41707) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41708, '你也许会觉得，一名军医竟然钻研毒药蒸馏，这很不寻常；但在军情七处，不管你的职务是什么，这都是一项必备的本事。尤其是我对身体和解剖的了解，让我能看到一些别人看不到的东西。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41708) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41709, '若不是几十年前他们的商船来到我们这个新生的国度，库尔提拉斯与巴洛便谈不上有什么渊源。正因如此，我总觉得与这个地方有着一份遥远的亲近，哪怕它如此微弱。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41709) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41710, '根据我们收集到的情报，我猜鱼人正在收集破碎珍珠的碎片，想把它重新拼合起来。它们确实有一定智力，足以施放法术，可就算这样，对普通鱼人来说也还是太反常了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41710) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41711, '这一切都让人困惑不解，但眼下需要的是行动，不是猜测。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41711) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41712, '有什么我能帮你的吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41712) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41713, '你靠近它就会知道是哪一本魔典。即便过了几十年，它强大的能量仍从书页间涌出。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41713) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41714, '快些，$N。我们不能再等了。自由只差一次召唤！完成 该死的魔法，没起作用！恐怕我们需要更多能量才能打碎这些锁链。别发愁，我相信我们终会成功。作为你这些行动的补偿，请带上我们刚做出的那颗水晶。我确信它会在你的旅途中派上用场。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41714) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41716, '有事吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41716) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41717, '你每浪费一分钟，我们的安全就多一分危险。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41717) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41718, '有事吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41718) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41719, '格什甘·黑谷是个狡猾的对手，别放松警惕。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41719) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41720, '文件取回来了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41720) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41721, '胜利就在眼前，向扎姆格斯要塞进发！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41721) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41722, '你找到那些肥美的独行蛛腿了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41722) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41723, '我能为你做什么，$C？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41723) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41724, '你找到叛徒了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41724) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41725, '黑铁零件取回来了吗？还是说，你只是顺路来打个招呼？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41725) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41726, '你找到那些残骸了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41726) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41727, '我的仪式需要这些血液，你拿到了吗，$N？完成 恶魔之魂的力量就蕴含在这血液之中，它的力量无可否认。奖励 完成任务后可获得：1850 点经验值，奥格瑞玛 300 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41727) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41728, '我要你收集的东西，都齐了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41728) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41729, '我交办的任务完成了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41729) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41730, '你为部落夺回乌索克之坠饰了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41730) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41731, '完成 Uthokk 宝石的力量正流经我的血脉……这样的力量令人狂喜！我重生了，这全得谢你替我做完了所有苦活。Uthokk 的坠饰已经被抽干了力量，但我相信你还能派上点用场。再会，$N。奖励 完成任务后可获得：300 点经验值，奥格瑞玛 300 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41731) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41732, '有事吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41732) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41733, '所需的材料到手了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41733) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41734, '有事吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41734) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41735, '我能帮你什么吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41735) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41736, '深根收集齐了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41736) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41737, '你的任务完成了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41737) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41738, '大地渴望安宁，而让它得偿所愿是我们的责任。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41738) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41739, '有事吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41739) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41740, '鳞片拿到了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41740) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41741, '有事吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41741) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41742, '我恳请你带上同伴，这份邪恶或许大得不是一个人能应付的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41742) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41743, '精彩，简直妙极了！我已经很久没有在掌门游戏里被逼到这一步了。衷心感谢你给了我这样尽兴的机会。胜利者不该没有战利品，就让我为你的雄才大略奉上一份相称的奖赏吧。落风之神恩' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41743) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41744, '精彩，简直妙极了！我已经很久没有在掌门游戏里被逼到这一步了。衷心感谢你给了我这样尽兴的机会。胜利者不该没有战利品，就让我为你的雄才大略奉上一份相称的奖赏吧。落风之神恩' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41744) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41745, '已经办好了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41745) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41746, '我们正在设法确保这样的事不会再发生。等你取回那些残余物，我们就能把残留的能量重新引回塔里去。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41746) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41747, '是的，我能帮你什么？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41747) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41748, '拉尔萨斯泄露了许多阿祖拉之塔珍视的秘密，还帮助过迪菲亚兄弟会……这样的罪行不能不予追究。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41748) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41749, '别让我干等着，伙计。我已经派了五个冒险者去找这块该死的石头了，你是第五个。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41749) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41750, '头呢？！背叛者的头颅呢？！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41750) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41751, '即便多年过去，恶魔之魂那邪恶的阴影仍萦绕在我们的族群之上。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41751) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41752, '龙喉兽人是些疯狂的残渣，死死抱着我们过去那份正在消逝、已被扭曲的荣光不放。趁你还在他们那处可鄙的巢穴里，把这些蠢货消灭干净。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41752) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41753, '这些蠢货根本不明白自己在摆弄什么样的力量。一旦它落入我们手中，就能真正发挥出全部潜能。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41753) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41754, '欢迎来到我们的盛大展览！如果你对我们的展品有任何疑问，别客气，尽管问。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41754) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41755, '你好，什么风把你吹到尊贵的雷德布兰德庄园来了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41755) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41756, '让他们看看联盟还没老掉牙。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41756) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41757, '别小看他。他那样的野兽能活下来，可不是全靠运气。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41757) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41758, '剃刀沼泽的巢穴是一片荆棘丛生的扭曲之地。我建议你为这趟行程做好准备。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41758) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41759, '当自然秩序受到威胁时，我们必须尽力相助，恢复平衡。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41759) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41760, '巴洛的历史仍在书写，它会走向何方，我不知道。但它的过去这一章必须做个了结，这一点我很确定。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41760) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41761, '别独自前往。这些野兽难以预料，而且什么事都做得出来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41761) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41762, '你办完了吗？别让我干等，小子！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41762) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41763, '如果你找到了它，千万别打开！你还没准备好欣赏它们那种……独特的美。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41763) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41764, '怎么样，水泵站那边有进展了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41764) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41765, '除虫的事办完了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41765) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41766, '我的工人们开始把休息时间过得太舒坦了。我们得把这事了结，让产量回到正轨。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41766) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41767, '要么是好消息，要么就别来烦我，伙计。再来一趟糟糕的差事，我可真受不了！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41767) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41768, '＜普瑞斯托女士没有理会你。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41768) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41769, '那些野兽会拼命护住自己的幼崽。掉以轻心，你的旅程可能提前结束。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41769) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41770, '这将是一段漫长而艰苦的旅程，但到最后，你们之间的羁绊会比以往任何时候都牢固。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41770) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41771, '别去猎杀 暴掠龙，这么早喂它毒肉会把它害死！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41771) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41772, '这些腺体能分泌强效的生长激素。别担心，我们的小朋友吃了不会有事的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41772) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41773, '它们骇人的咆哮和巨爪，能轻易把毫无防备的猎人撕成碎片。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41773) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41774, '阿尔戈隆碎片 达斯罗纳格碎片 奖励 你将获得：下储备钥匙 完成 奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41774) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41775, '阿兹苏妮公主在上层精灵社会里是个名声不佳的人物：一位强大的女巫，毕生研究从扭曲虚空的星界位面汲取力量，常使用连她那些同僚星象师都不敢涉足的危险手段。大分裂之后，关于她的一切痕迹都被抹去，连我们辛德拉也不知道她后来怎样了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41775) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41776, '连结水晶是扭曲虚空中渗入艾泽拉斯兵器与神器的浓缩奥术精华。它们蕴藏着巨大的力量与潜能，被用于许多能极大强化受术者的魔法附魔。通常这些水晶密实到连最强的法术或武器都打不开，硬来只会引发剧烈而致命的爆炸。不过 Aszune 设法造出了一种方法，能把连结水晶一分为二、变成两块较小的魔法碎片，同时保持它的稳定与能量。我很想照着 Aszune 宣言里找到的说明做实验。给我带一块这样的水晶来，我们就来看看她的话有几分真。连结水晶' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41776) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41777, '在她的论文里，Aszune 推测奥术能量经过一段时间会自然聚合。不过，这个过程可以用一种不那么自然的方式加速。她写道：如果把两件倾向相同的法器调校到同一波能量上，它们最终会融合，生出全新的东西。我太想亲手试试了，这种心情没法形容。我们先从简单的开始吧；谁知道我们的举动会带来什么样危险的连锁反应。照着这些咒文，我会尝试把两块大块魔光碎片凝聚起来，造出了不起的东西。$N，要是你能把碎片给我送来，我不胜感激。大块魔光碎片（2）奖励 你会获得：连结水晶 完成 太棒了，亲眼看着它在我眼前成形，这一幕我会永远记得。想想看，我们今天能做到这一步，全靠一万年前的知识——我族人珍藏了千年的智慧，正是我们韧性的证明。别担心，年轻的，没有你的帮助，这一切都不可能实现。这块水晶就当作报酬收下吧。我坚信我们还能把这套流程改进得更精，所以要是你愿意再收集一次所需的材料，我会很高兴。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41777) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41778, '雅典娜神庙里藏着近乎无穷的典籍与书籍，塞满了数千年的古老知识。这自然会引来一些居心叵测之徒，想偷走我们珍视的藏书谋私利。令我们痛心的是，这种事几乎天天发生，我的同僚们却早已见怪不怪。拜托，如果你在厄运之槌内外发现我们遗失的圣契，请把它们还给我。贪婪圣契' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41778) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41779, '雅典娜神庙里藏着近乎无穷的典籍与书籍，塞满了数千年的古老知识。这自然会引来一些居心叵测之徒，想偷走我们珍视的藏书谋私利。令我们痛心的是，这种事几乎天天发生，我的同僚们却早已见怪不怪。拜托，如果你在厄运之槌内外发现我们遗失的圣契，请把它们还给我。体质圣契' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41779) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41780, '雅典娜神庙里藏着近乎无穷的典籍与书籍，塞满了数千年的古老知识。这自然会引来一些居心叵测之徒，想偷走我们珍视的藏书谋私利。令我们痛心的是，这种事几乎天天发生，我的同僚们却早已见怪不怪。拜托，如果你在厄运之槌内外发现我们遗失的圣契，请把它们还给我。恢复圣契' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41780) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41781, '雅典娜神庙里藏着近乎无穷的典籍与书籍，塞满了数千年的古老知识。这自然会引来一些居心叵测之徒，想偷走我们珍视的藏书谋私利。令我们痛心的是，这种事几乎天天发生，我的同僚们却早已见怪不怪。拜托，如果你在厄运之槌内外发现我们遗失的圣契，请把它们还给我。沉思圣契' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41781) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41782, '雅典娜神庙里藏着近乎无穷的典籍与书籍，塞满了数千年的古老知识。这自然会引来一些居心叵测之徒，想偷走我们珍视的藏书谋私利。令我们痛心的是，这种事几乎天天发生，我的同僚们却早已见怪不怪。拜托，如果你在厄运之槌内外发现我们遗失的圣契，请把它们还给我。坚韧圣契' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41782) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41783, '巴洛曾是一片饱经艰辛、磨难与悲剧的土地。它诞生于对独立与财富的渴望，很快就成了王国各地乃至境外商人的乐土。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41783) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41784, '硬币拿到了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41784) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41785, '这股气息……！不可能！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41785) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41787, '这也许对你要求太高了，但到了这一步，我们已经没有半点余裕了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41787) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41788, '终于。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41788) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41789, '时间紧迫——别浪费它。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41789) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41790, '当心，$N。他是个可怕的敌人。完成 那么……结束了。一件必要的事，办得也够妥当。可……我的思绪里仍有一道阴影。万一乌尔索尔自己也已经堕落了呢？万一那份沉默不是出于不屑，而是出于疯狂……腐化？这个念头太危险，我不敢轻易深想。大德鲁伊必须知道这件事。感谢你的……协助。愿风把你带离这片受诅咒的地方。奖励 完成任务后可获得：1150 点经验值，达纳苏斯 200 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41790) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41792, '别在这儿惹麻烦，我们的事已经够多了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41792) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41794, '萨尔 hall，小家伙。什么风把你吹到碎风哨站来了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41794) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41796, '有什么我能帮你的？我得为锦标赛做准备，我们的对手可不好对付。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41796) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41797, '需要我做什么？要补充箭袋吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41797) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41798, '罗纳德·吉里安要你去巴洛与他的妻子会合，协助她的工作。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41798) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41799, '与巴洛军情七处哨站的水法师芬尼根交谈。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41799) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41800, '在外头可要当心——冷酷谷可不是随便散步的地方。雾气浓得化不开，那些阴影也……不对劲，像是在盯着你。不少胆大的家伙进去时都觉得自己没事——大多数再也没回来。要是你没帮上他们，反倒和蛮锤的死者一起埋在那儿，那可就太让人难过了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41800) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41801, '一个凡人？来这里？有话快说。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41801) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41802, '我说不清先祖之墓穴深处等着你的是什么样的恐怖。那里滋生的腐化古老而强大，远超大多数凡人所能想象。出发前务必做好准备，也要记住这句警告——别让愚蠢的逞英雄牵着你的行动。谨慎与智慧，远比鲁莽的勇敢更有用。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41802) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41803, '确实是艰难的日子。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41803) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41804, '在你探寻他们的知识时，我会去联络我的巨龙军团。或许在我们古老的卷轴和隐秘的记忆中，我们能找出某些被遗忘的真相。但要快。暗影正变得愈发猖狂，时间并非我们的盟友。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41804) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41805, '幼龙对我们没用——你必须找到成年的同族。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41805) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41806, '什么事？我正忙着呢！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41806) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41807, '材料拿到了吗？快点！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41807) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41808, '你终于回来了，凡人。但愿你带来的是好消息。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41808) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41809, '时间紧迫。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41809) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41810, '符文石恢复之后，我们就能利用它们的梦境能量，帮助我们对抗梦魇的战争。在远古时代，荒野的守护者与他们的保卫者使用强大的符文，就跟你刚复活的那种符文石很像。他们能借此把灵魂调谐到某个地点，通过翡翠梦境瞬息抵达。如果你愿意，我可以把这样一道符文刻进一小块梦境碎片里，这样无论你在艾泽拉斯的哪里，都能听见我们的求援。小型梦境碎片' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41810) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41811, '安静，你打扰到风了……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41811) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41812, '小心前行，黑暗深渊的深处爬满了邪恶之物。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41812) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41813, '但愿这麻烦是值得的，嗯？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41813) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41814, '你想出办法了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41814) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41815, '没有胆量，就没有荣耀。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41815) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41816, '到外面去，向自己证明你是猎手，而不是猎物。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41816) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41817, '人生就是一场战斗，一场与你自身无法完全掌控的部分之间的战斗。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41817) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41818, '最后的任务在等着你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41818) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41819, '那些蠕动的蛇类，自封的海洋与湖泊的统治者——真是让人头疼。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41819) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41820, '没什么时间可浪费。说吧。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41820) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41821, '太吵了……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41821) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41822, '终有一日，安舍会回到这片土地。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41822) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41823, '这件事可以等，但我更希望你能尽快办完。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41823) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41824, '大地母亲会指引你找到答案。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41824) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41825, '说吧。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41825) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41826, '没有人该遭这样的残酷命运。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41826) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41827, '今天可不是游泳的好日子。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41827) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41828, '完成了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41828) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41829, '我已准备好把它们付之一炬。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41829) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41830, '我们不欠任何人道歉。把我们带到这里来的不是罪责——而是荣誉。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41830) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41831, '傲慢与自信之间的界线竟如此之细。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41831) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41832, '巢穴的女王就在附近。保持冷静，继续前进。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41832) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41833, '尘归尘，土归土，渣滓归渣滓。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41833) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41834, 'Loktar ogar.' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41834) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41835, '不管是不是燃烧军团，该做的事就得做。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41835) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41836, '我很好奇她手里握着什么样黑暗而邪异的器物，竟能让她拥有一份钥匙的副本。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41836) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41837, '那只锁箱里不过装着第一块碎片。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41837) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41838, '你又是谁？我们可不需要马屁精来浪费老大的时间！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41838) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41840, '哦，Sara，我亲爱的天使……以圣光之名，请保佑我的 Timothy 平安……！完成 什么……？这是什么？你从哪儿……？！不，不，不！Timothy！我的小 Timmy，不！哦，圣光啊，你为什么抛弃了我？！他还是个孩子，我亲爱的、天真的孩子！奖励 完成任务后可获得：1200 点经验值，暴风城 100 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41840) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41841, '快说。我可不想把时间浪费在鼠辈身上。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41841) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41842, '暴风城一直羡慕巴洛人——他们不仅与暴风城，还与另外好几个国家一道，把成功的贸易之术练到了炉火纯青。要是这份知识随岁月湮没，那可就太可惜了，你说是不是？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41842) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41843, '我相信你在那儿一定能碰到足够多的合适人选。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41843) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41844, '你能独自来到这个受诅咒的地方，说明你够强——或者说够蠢——所以我确信你进去之后再毫发无伤地出来不成问题——至少大体上不成问题。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41844) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41845, '她是个以折磨灵魂取乐的怪物。对她的惩罚，来得越早越好。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41845) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41846, '丹基塔斯来了个新面孔！欢迎，欢迎。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41846) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41847, '别害羞。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41847) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41848, '小心。这片土地上到处都是龙喉兽人。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41848) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41849, '我们的族人真的没有希望了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41849) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41850, '我一定要得到它！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41850) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41851, '铁趾多半在苦痛堡垒附近扎了营。至少换作我会这么做。那地方以古代遗物而闻名。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41851) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41852, '求你了，冒险者！时间紧迫。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41852) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41853, '复仇！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41853) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41854, '什么事？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41854) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41855, '我对执法官并无怨恨。我明白龙喉的威胁比矿场更重要。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41855) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41856, '我们挖得太深……太贪婪了。如今正为当初的愚蠢付出代价。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41856) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41857, '那些鱼人到底是从哪儿来的……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41857) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41858, '想想吧，我从前可是很爱吃鱼的……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41858) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41859, '完成 奖励 完成任务后可获得：1550 点经验值，暴风城 100 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41859) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41861, '失败并非软弱，只是成长即将到来的征兆。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41861) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41862, '嗯？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41862) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41863, '我派了一支规模不小的巡逻队去查探斯托尔加兹城堡的残迹……可从那以后就一点消息都没有了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41863) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41864, '那面旗帜回到它该在的地方之前，我都无法安心。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41864) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41865, '斯托尔加兹城堡是以我祖父的名字命名的。我绝不会看着它在兽人的皮靴下烂掉。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41865) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41866, '小心——格什卡尔的防线极其坚固。我可不是在开玩笑！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41866) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41867, '在外头小心点。软泥怪看着不起眼，但潜伏在黑暗中的扭曲之物可不止它们。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41867) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41868, '真希望能和你一起去，不过……唉，我吃过苦头才明白，我拿书比拿刀顺手。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41868) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41869, '我的小伙子们的血在呼喊正义。不让那些畜生付出代价，就别回来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41869) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41870, '恶心的畜生。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41870) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41871, '欢迎！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41871) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41872, '只要能吃上一顿像样的盛宴，我什么都愿意做。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41872) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41873, '怎么了？你是在 Brangar 的旧农庄找到的？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41873) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41874, '你到斯托尔加兹了吗？有档案的踪迹吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41874) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41875, '外头到处都是碎石和废墟。我们只要够聪明，就能把它们用起来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41875) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41876, '你是从岩须的锻炉来的，对吧？我就怕会有这一天。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41876) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41877, '什么事让你从丹基塔斯过来的？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41877) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41878, '你和纳兹戈林谈过了吗？请告诉我他答应了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41878) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41879, '水晶找到了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41879) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41880, '扎姆格斯不是独狼该去的地方。召集你的盟友，让那些兽人尝尝联盟的怒火！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41880) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41881, '在外头小心点……斥候说，如今布兰加之愚里盘踞的东西比兽人更黑暗。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41881) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41882, '你帮上钢风的忙了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41882) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41883, '你带来的是什么？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41883) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41884, '若想在接下来的战斗中取胜，你必须做好准备。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41884) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41885, '你还活着？还是也被鳄鱼拖下去了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41885) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41886, '还活着？我是说——啊，你已经回来了？没有？那就睁大眼睛，别让靴子湿着……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41886) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41887, '那么，你做好选择了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41887) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41888, '不必留情。带着纹章回来——我们的盟友指望着你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41888) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41889, '火焰正在升腾。别空着手回来——除非你想和它们一起化作灰烬。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41889) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41890, '你每拖延一刻，敌人就更大胆一分。向我证明部落依然令人畏惧。把纹章带回来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41890) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41891, '部落要的是结果，不是借口。撕开那片腐化，把纹章给我带回来，让我们的敌人重新想起他们为何畏惧我们。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41891) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41892, '火焰正在升腾。别空着手回来——除非你想和它们一起化作灰烬。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41892) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41893, '你带来的是什么？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41893) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41894, '我能为你做什么，$N？完成 瞧瞧这小宝贝？多彩动力的涡轮增压好货！这东西能让我重新站起来。我凑了凑能拿出来的当报酬，不多，但希望够付。现在，滚吧，我还有活儿要捣鼓。奖励 完成任务后可获得：1850 点经验值，300 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41894) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41895, '嘘！你弄到那东西了吗？……就是那种脓液？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41895) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41896, '你带回来的是好消息，还是坏消息？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41896) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41897, '我们没有时间可以挥霍。那些怪物每多喘一口气，就会更强一分。让我看看你确实与它们交过手。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41897) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41898, '腐化已经根除了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41898) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41899, '和黑根之间不可能有和平，自从他们陷入疯狂，就一直想要毁灭我们。如果你想得到木喉的赏识，或许可以替我们去和他们交战。收集十根他们奉为圣物的图腾，我就以此记下你的功绩。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41899) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41900, '你已经证明自己值得我关注，为此，我将允许你接触我最珍视的配方。把所需的材料带来，我会给你相应的回报。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41900) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41901, '你已经证明自己值得我关注，为此，我将允许你接触我最珍视的配方。把所需的材料带来，我会给你相应的回报。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41901) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41902, '你已经证明自己值得我关注，为此，我将允许你接触我最珍视的配方。把所需的材料带来，我会给你相应的回报。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41902) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41903, '你已经证明自己值得我关注，为此，我将允许你接触我最珍视的配方。把所需的材料带来，我会给你相应的回报。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41903) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41904, '你已经证明自己值得我关注，为此，我将允许你接触我最珍视的配方。把所需的材料带来，我会给你相应的回报。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41904) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41905, '以前我不理解铜须家对黑铁矮人的憎恨。可亲眼见到他们如何蔑视道德与性命之后，我明白了那份轻蔑从何而来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41905) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41906, '这样的结局并不是我们当初答应给他们的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41906) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41907, '我族人的传承必须延续下去，哪怕他们的灵魂如今已与先祖同行。我们的历史不能就此失传。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41907) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41908, '我们对德拉诺斯水晶的需求一直很大。我的部族还保留着许多来自德拉诺的灵性传统，我们为此深感自豪。但这也得付出代价。古老仪式所需的德拉诺斯水晶十分稀少，我们几乎每次出村都得冒极大的风险。在你听来，这或许既自私又难以为继，可要是没了传统，我们还算什么？$N，海岸边的生物也被这些外来的水晶吸引，与我们无异。它们的力量如此诱人，就像飞蛾扑火，纷纷被这股诱人的能量吸过去。你每找到一块德拉诺斯水晶，我都会向族人讲述你的功绩，我向你保证。原生德拉诺斯晶簇 完成 粗劣而原始，但无疑蕴含着力量。$N，你今日无私的举动不会被遗忘。村民们会知道的，我一定让他们知道。如果你还能找到更多，尽管拿来给我。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41908) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41909, '海岸上散落着巨大的水晶矿脉。它们的力量大多已被抽干，只剩下在朝阳里闪着光的美丽镜子。但德莱尼水晶仍在生成——在整个月语海岸结成一小簇一小簇发光的晶簇。它们很罕见，可也因此更强大。如果你碰巧遇上这些晶簇，把它们带回村子，我的族人将感激不尽。发光的德莱尼水晶晶簇' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41909) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41910, '欢迎来到莫洛加村，我能帮你什么？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41910) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41911, '我们不清楚他们的动机，而从父亲告诉我的那些缘由来看，有些事情根本说不通。如果只是对我们生活方式不满，他们不会诉诸如此暴力的手段。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41911) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41912, '什么事，帕拉什卡？别用你那些幼稚的好奇心浪费我宝贵的时间。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41912) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41913, '快点，小傻瓜。这个谜团的答案不能再拖了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41913) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41914, '你去了这么久。Master Ralpekta究竟查出了什么？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41914) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41915, '完成 看来这些年我儿子成长了许多。又一件我该注意却没注意到的憾事。他比我以为的更早成了男子汉。Ar’lia 说得对。哀悼与无所事事的日子已经结束。我们熬过了一场种族灭绝，可不能倒在自己族人发动的又一场里。举起你的手臂，$N。我们要让这个假先知闭嘴。奖励 完成任务后可获得：850 点经验值和 50 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41915) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41916, 'Bhurobi加诸于我们族人身上的恐惧阴影必须终结，否则他就与德拉诺的兽人部落毫无区别了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41916) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41918, 'Harane 出去太久了。这个鲁莽的女人到底在干什么？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41918) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41919, '又是你？什么风把你吹来了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41919) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41920, '你好，Parashka。你看上去一路奔波，很疲惫。这片海岸地处荒野深处，除了附近的牛头人邻居，几乎没人来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41920) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41922, '$N，很高兴在避难营又见到你。有什么我能帮你的吗？完成 一块投影水晶……来自另一位德莱尼？！快，请把它交给我！奖励 完成任务后可获得：1200 点经验值，100 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41922) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41923, '伊瑟拉之哀嚎 明亮梦境碎片（10）完成 奖励 完成任务后可获得：2300 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41923) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41924, '伊瑟拉之哀嚎 明亮梦境碎片（10）完成 奖励 完成任务后可获得：2300 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41924) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41925, '伊瑟拉之哀嚎 明亮梦境碎片（10）完成 奖励 完成任务后可获得：2300 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41925) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41926, '伊瑟拉之哀嚎 明亮梦境碎片（10）完成 奖励 完成任务后可获得：2300 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41926) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41927, '布莱克沃尔德勋爵的骑乘口哨？这么说，他们的暴政结束了。黑暗骑士原本是商人，被麦迪文诅咒，要为他搜寻遗物直到时间尽头。看到他们的首领被击倒，我松了一口气；不过，我们无法确定世上是否还有别的黑暗骑士在残害无辜。眼下我能拆解这只口哨，但还需要额外的助力。把这个世界不死生物身上的精华带给我，也许我就能毁掉这污秽的东西。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41927) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41928, '以圣光之名！你身上那股腐臭的瘴气是怎么回事？$N，不管你身上带着什么，赶紧交出来！果然如我所料，这石板上的防护诅咒太强，破不开。我们得用神圣之力把它圣化。为此，狂热的血色十字军手里的圣十字应该够用。那些圣物本来也不该留在他们肮脏的手里。$N，尽快把它们送到我这儿来！完成 十字架，你拿到了！隔这么远都能感到它们的神圣光辉。$N，我们必须净化这块石板。你也许不知道，天灾的邪恶地穴领主正是用它们催动惑人心神的法术，号令蛛怪大军、强化它们的力量。必须把它从这个世界清除掉，立刻。总之，保持警惕。我们毁掉的是他们珍视的圣物，他们必定会报复。做好准备！奖励 完成任务后可获得：2300 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41928) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41929, '完成 奖励 完成任务后可获得：2300 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41929) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41930, '我们逃出木喉要塞也许还没过多久，但里面的怪物进化得极快。谁知道你会在里面碰上什么可憎的东西？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41930) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41931, '枯萎之喉内部积聚了意料之外的力量；这新得的力量超出了他们肉体的承受极限，令他们的躯体崩裂。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41931) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41932, '我的封印撑不了多久，$N。请你动作快些。完成 这些物品的力量让我惊叹。有了那野兽的心脏，我们就能打破图腾周围的邪恶屏障。Grammon 的舌头会让它们说出真话，净化之水会洗去一切污秽。奖励 完成任务后可获得：8400 点经验值，木喉要塞 1000 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41932) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41933, 'Timbermaw Village戒备森严。做好万全准备吧，枯萎之喉早已抛弃了一切道德。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41933) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41934, '完成：在我们古老的教义中，有一则传说将所有的熊怪部族联系在一起。它讲述了我族的诞生——据说在世界尚且年轻之时，双子神将我们带到了这个世上。那时他们还是幼崽，在卡利姆多未经触碰的荒野中嬉戏，在清晨沾满露水的草地上打滚。笑声弥漫在空气中，他们无拘无束的活力在四周飘荡。随着他们的力量满溢而出，湿草上的露珠落向巨树的根须，渗过树皮，与大地融为一体。日积月累，这些露珠逐渐生长，化作了那两位年轻熊神的模样。对我们熊怪来说，没有什么比协助始祖守护荒野更为重要。看着乌索尔第二次死去，让我的心充满痛苦与悲恸；像他这般高贵的存在，不该落得这样的下场。木喉部族将永远欠你一份恩情。请收下这剂强效药膏，净化木喉要塞中残存的腐化。完成任务后可获得：8400经验值、木喉要塞2000点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41934) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41935, '什么事，凡人？你为何要来打扰我这安享清静、在此地悠然游荡的幽灵？省省吧，答案我早就知道；财宝与玩意儿，就是蠢人唯一会跑的差事。那你来得太晚了，对于你那荒唐的寻宝之旅，我不会帮你，也帮不上忙。一个幽灵要怎么帮你做那种事，白痴？哦，你说的是复活圣物？也许你终究没那么蠢。听仔细了，凡人！我可不会说第二遍。我给你一桩交易：用那件神器把我复活，你拼命渴求的财宝就归你所有。去收集我那些卑微同族的精华，大局需要他们高贵的牺牲。这牺牲或许不小，但我愿意去做。只有这样，你才能激发那卷轴潜藏的力量。完成：你真是个轻信的蠢货。你真以为我会把本族强大的财宝交给一个区区凡人？可笑！我的财宝只属于我，也只归我一个人。作为对你天真的奖赏，就让我来让你见识一下蓝龙军团有多好客吧！完成任务后可获得：2300经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41935) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41936, '什么风把你吹来了，$N？我明白了……你身上的气场已经把话说清楚了。你手上有件不寻常的东西，对吧？天啊！我从没见过这么完美的裂隙水晶。$N，你难道知道手里捧着的是什么吗？有这么大一块裂隙水晶，谁知道我能召唤出多强大的恶魔……$N，仔细听好，强大恶魔的血液里浸满了虚空能量。给我带十瓶它们的血来。在腐化之痕、暗语峡谷和海加尔山顶游荡的最强恶魔身上就带着这样的能量。有了它，我们就能撕开一道足够大的裂隙，把一头浑身是劲的恶魔引出来，任我们宰割！完成 这香气……这些瓶子里装着纯净无瑕的能量。无论通过水晶裂隙把什么东西带进这个世界，都必定是一头强大到难以估量的恶魔。$N，带上你的盟友，做好你自己；这可不是轻松的活。准备好！奖励 完成任务后可获得：2300 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41936) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41937, '完成 感谢你救了我的兄弟。荒野的长者们以此相赠。在巨熊之灵的爪边放着几件饰品，想必是让乌尔索尔从痛苦中解脱的奖赏。明智地选吧。> 奖励 完成任务后可获得：5400 点经验值，木喉要塞 2000 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41937) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41938, '有什么我能帮你的吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41938) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41939, '我们的先知和祭司都为周围沸腾的元素躁动感到不安。连学徒和新人都能感觉到那份不安。这就更说明我们得把事情的根源查个水落石出。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41939) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41940, '元素的蛮力可能压得人喘不过气。保持专注，守住内在的灵魂，你就没什么好怕的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41940) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41941, '你好，勇敢的旅行者。是什么风把你吹到这片多灾多难的土地上来了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41941) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41942, '一旦凑齐了我们还缺少的那些东西，莱茵和我就能在更实际的层面上开展研究了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41942) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41943, '萨特是艾泽拉斯身上的瘟疫。他们为黑暗主子设下的阴谋，已经不止一次打破了平衡。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41943) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41944, '登法尔的农场经营得艰难，菲什也已经两天没能钓上一条鱼了！再这样下去，我们连自己都保卫不了了……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41944) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41945, '你那样瞪着我干什么？快去！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41945) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41946, '它们还在涌来！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41946) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41947, '我得协调防守的人手，所以你的事快点办。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41947) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41948, '什么事？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41948) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41949, '我要用他们的血把这片海岸染成深红。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41949) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41950, '你回来了。在那道红色峡谷里找到什么了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41950) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41951, '这外面不安全。如果你不熟悉这片林子，我建议你去北边的村子找个落脚处。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41951) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41952, '如果布罗比的阴谋牵涉到两方以上，那说明他的立场如何——更进一步说，他的野心又如何？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41952) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41953, '我们对这些熊怪知之甚少，他们大多时候都独来独往。至于原因，我们只能猜测。他们一直都想密谋对付莫洛加一族吗？德拉诺水晶的力量真的就是他们想要的全部吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41953) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41954, '让我见识一下你的族人能做出什么了不起的东西。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41954) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41955, '别小看它们。真正的匠人都是亲手去备料，所以要准备好迎接它们的凶猛怒火。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41955) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41956, '我们熊怪曾在卡利姆多的魔法森林中漫游，照料飞禽走兽与花草树木，维持它们的平衡。可自燃烧军团第二次入侵以来，几乎所有的族人都听从了那些恶魔留在我们神圣星辰之地上、至今仍在溃烂的黑暗召唤。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41956) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41960, '那蠢货要为他的傲慢流血。我要你确保这一点。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41960) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41961, '我一直在等你及时回来。告诉我，绿龙军团帮上你的忙了吗，事情进行得如何？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41961) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41962, '那位远古守护者一动不动，如同一块无法撼动的巨石，只是凝视着地平线。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41962) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41963, '你好。我看得出你的任务十分紧急。凡戈恩在上古之战时曾是我们族人的盟友，他强大的魔法与智慧是战胜那些上层精灵叛徒的关键。大分裂之后，他一直在Kalidar岛上沉眠至今，却始终警醒地影响着周遭的世界。那熊怪说得没错，他所说的是一种早已被遗忘的语言，就连月光林地的德鲁伊们如今也几乎无人能说了。教你学会它得花上好几年，但我能帮你听懂它，哪怕只是一小段时间。从世界之树的根部为我带来一颗诺达希尔的橡果、灰谷艾森娜神殿的树液，以及五瓶梦境药剂。把这些材料带给我，你就能在我的帮助下继续你的任务了。诺达希尔的橡果 艾森娜的树液 梦境药剂（5）完成 干得好。既然东西都齐了，我就能从橡果中提炼出一份祝福，让你听懂自然本身的言语。不过要小心，法术不会永远持续，所以请一路稳当地赶去凡戈恩那里。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41963) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41964, '欢迎回来，$N。凡戈恩那边有收获吗？完成 佩罗萨恩。萨特领主萨维斯的副手。绝不会错。这块角碎片和 Withermaw 的图腾有着同一种邪恶能量——恶魔精华与某种未知恐惧的恶心混合。如此压迫的存在，光是看着就已经是极度的亵渎。奖励 完成任务后可获得：7900 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41964) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41965, '请务必保持谨慎。熔火之心十分凶险，里面的危险无论你的同伴做多少准备都不为过。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41965) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41966, '你回来了！快告诉我！我们的计划成功了吗？我的族人终于自由了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41966) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41967, '我们的人已经所剩不多，我必须确保已经饱受折磨的同胞不会再有一个死于非命。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41967) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41968, '我可不想浪费时间。你要是弄不到那些角，我就另找别人。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41968) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41969, '毛皮弄到了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41969) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41970, '有消息带回来吗？无论好坏。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41970) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41972, '有什么我能帮你的吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41972) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41973, '你需要什么吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41973) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41974, '我劝你谨慎些，那些巨大的野兽力大无穷。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41974) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41975, '这么快就回来了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41975) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41976, '记住，峡谷位于千针石林深处，你得跑到卡利姆多的偏远角落才能找到它。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41976) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41977, '行事小心些，恐怖图腾已经加固了风角峡谷，并把它据为己有。那些高耸陡峭的崖壁是绝佳的防御工事。如果你想帮忙，我建议你带上同伴。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41977) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41978, '让他们体会我所承受的一切，只是时间问题。他们会为自己的所作所为付出代价，而我必将复仇。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41978) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41979, '什么风把你吹到雷霆崖来了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41979) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41980, '你有什么事？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41980) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41981, '有事吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41981) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41982, '鼓起勇气，行动时要多加小心。我确信死亡图腾有黑暗魔法相助。尽量多带些同伴，动作要快。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41982) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41983, '又来听故事了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41983) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41984, '我不管你从哪儿弄来的这些东西，只要我钓上大鱼的时候它们别散架就行！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41984) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41985, '那个锅你到底有没有？！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41985) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41986, '迪尔格 催着要立刻做好他的炉子？这地精还真有胆。他最初来找我就够让人意外的了；不过话说回来，侏儒工程学本就远胜这些绿皮业余爱好者的幼稚机器把戏。迪尔格 最后想必自己也明白了。你想知道为什么？去问他为什么只剩三根手指吧——在他之前还有别人给他造过炉子，就这么说吧。总之，他想要那东西完工，我就需要燃料。我说的可不是油之类粗糙玩意儿。不，我要的是食物形式的脑力燃料！我的突触渴求怪物煎蛋卷那美妙的滋味——那是用巨型鸟蛋做的佳肴。给我带十份来，我马上就能把他的炉子完工。怪物煎蛋卷（10）' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41986) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41987, '元素是抽象之物，能化出许多形态。它可以像我们蹄下的大地、顺流而下的清水那样自然；也可以是更具体、更危险的东西，比如纯粹元素能量的化身。这些化身可以说是来自各自元素位面的访客，要在这个世界行动，就需要一个锚点。它们被镣铐束缚，靠着由狂暴元素之力塑成的躯体核心拴在艾泽拉斯上。这些暴走的元素必须以平静的状态回到它们的元素位面；只要安抚好那些核心里的躁动，我们就能做到。把它们带给我，大地之环会记你的情。元素核心（20）' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41987) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41988, '你是来帮忙的吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41988) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41989, '据说海神之水神像对水元素拥有巨大的掌控力，能让使用者召唤漩涡、涌起的潮水以及其他危险现象。我们绝不能让它们落入邪恶之手。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41989) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41990, '我知道这样很丢人，可我就是忍不住。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41990) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41991, '要做的事太多了。时间从不等人。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41991) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41992, '别把这件事告诉村里任何人。我们绝不能招来长者的注意。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41992) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41993, '他的沉默震耳欲聋。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41993) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41994, '我们必须让先祖们得以安息。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41994) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41995, '我的话和怒火都用在你身上了，凶手。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41995) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41996, '我的眼睛越来越累了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41996) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41997, '我对你期望很高，别让我失望，冒险者。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41997) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41998, '你回来之前，我会把一些工具准备好，再配几味药剂来试试这块水晶。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41998) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41999, '不知道我该先缝制什么好。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41999) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42000, '你这是在帮一个大忙。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42000) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42001, '别小看熊怪。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42001) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42002, '岁月没有在这把剑上留下任何痕迹。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42002) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42003, '那座祭坛已被遗弃，沉在大海深处。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42003) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42004, '那座祭坛比以往更强烈地吸引着你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42004) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42005, '完成：Thil’phoral握在一只手中，碎片握在另一只手里。你极不情愿地把碎片按进剑身上的凹槽。几乎就在同时，那小片木头便开始在剑刃中扎根，这引得你面前的藤蔓向Thil’phoral伸来。它沿着你的小臂蜿蜒爬行，一面把你拉近，一面也缠住了握着寄生物的那只手。接着，藤蔓猛地收紧，以不可思议的力量把你的双手死死缠在一起，同时散发出骇人的紫色烟雾。你能感觉到寄生物的卷须正从你的脑中退去，穿过手臂，离开手掌。折磨没有持续太久，藤蔓终于松开了束缚，你重获自由的手中躺着的正是Thil’phoral，它与寄生物融为一体，泛着不自然的品红色光芒。正如你手中的那个声音所预言：它走完了自己的道路。多亏了你。因为你的行动，它如今得以观察，并向那个将它带入此世的力量宣告自己的发现。完成任务后可获得：8000经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42005) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42007, '$N！你回来了。请问，Evenpike 呢？完成 以创造者之名，他说得没错。唉，Odum，你这个疯子！拿命去打这种赌，太不值了！$N，我的朋友一直在找一件古物，他认为那属于泰坦——那些曾造访艾泽拉斯的永生存在。在我们伟大的铁炉堡里，许多学者和教授都推测矮人的起源与那些神明般的生命有关。他以为你手里那东西能让矮人离真相更近一步，但看样子它并不完整。不管怎么说，Evenpike 用性命换来了这个惊人的发现，我会自豪地尊崇他的牺牲。等我处理完暴风城这边的事，就把它呈给铁炉堡大图书馆的资深探险家麦格拉斯作进一步研究。至于你，英雄气概与考古贡献都该有回报，我为你备了一份应得的奖赏。旅途平安，旅行者。奖励 完成任务后可获得：850 点经验值，铁炉堡 125 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42007) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42008, '动作快些。我的主人可不是以耐心著称的。完成 传闻果然不假，我还很少见过如此柔滑如丝的毛皮。我简直等不及要开始处理它了。按照约定，也给你一份报酬。我相信你一定会用得上它。奖励 完成任务后可获得：1250 点经验值，银月幸存者 250 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42008) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42009, '我无法告诉你木喉要塞里等着你的是什么。众灵不敢提及那个地方，也不肯给我任何启示。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42009) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42010, '你觉得是谁害得符文石失灵的？要我说，肯定是湖边那些蓝皮肤的捣蛋鬼干的好事。他们的魔法太过原始粗糙，早晚要闹出乱子来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42010) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42011, '我对德拉诺水晶的实验还没全部做完，不过我已经迫不及待想看看另一块了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42011) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42012, '说吧，旅行者。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42012) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42013, '为了生存下去，代价总是很高的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42013) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42014, '代安瑟赐予他们正义。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42014) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42015, '她过去常对我低声念诵星辰的名字。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42015) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42016, '鼓起勇气，朋友。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42016) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42017, '别担心，村里认定她是敌人。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42017) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42018, '我并没有召唤你们这些部落的小崽子，你为何凑上前来？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42018) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42019, '我正好想歇口气。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42019) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42020, '朋友，有什么我能帮你的吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42020) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42021, '$N，我听说你一直在打击木喉要塞里的黑暗。看来我给你配的药膏不足以压制那股瘴气。别担心，我可以用几样材料重新配出药膏。把它们带给我，我们就继续对抗邪恶。木喉树液 大地精华（2）生命精华（2）奖励 你将获得：净化精华 完成 成了。虽然不如原来那副强劲，但这份精华足以浇灭那些在神圣隧道里散播枯萎之喉腐化的火盆。如果还需要更多，你知道上哪儿找我，勇敢的冒险者。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42021) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42022, '这就是他们对我们伟大的神做的事？从内到外把他蛀空，玷污他华美的皮毛与躯体？我不敢去想他受折磨时经历了怎样的痛苦。听说你已经处置了那些叛徒、给了他们应有的惩罚，我松了一口气。乌尔索尔的皮毛也许已被污染，但用 Narkogg 正在调配的净化药膏，我们可以洗去那些污秽。把它带给我，这事就能办成。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42022) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42023, '你所作的贡献将得到十倍的回报。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42023) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42024, '你所作的贡献将得到十倍的回报。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42024) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42025, '你的付出会得到十倍的回报。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42025) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42026, '你的付出会得到十倍的回报。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42026) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42027, '你所作的贡献将得到十倍的回报。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42027) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42028, '你所作的贡献将得到十倍的回报。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42028) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42029, '欢迎回来，特工。是什么龌龊差事把你带回了寒舍？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42029) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42030, '虽说我对他们弄到的情报极感兴趣，但若只是把他们除掉，最终失去这样一口知识之泉，那可就太可惜了。老派的勒索手段总能促成良好的工作关系，这可真让人感到耳目一新。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42030) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42031, '祝你在黑翼之巢里玩得尽兴。你不在的这段时间，我的探员和线人会继续研究那把锁的图纸。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42031) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42032, '卡妮莉亚是我这阴暗人生中的一道光。我绝不会让他这种异教徒玷污她的光芒而不受惩罚。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42032) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42033, '旧暗炉城那破败的废墟中盘踞着强大的昔日幽灵。相信你自己的实力，就能在对敌时占得上风。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42033) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42034, '你是谁，为什么要来打扰我干活？要是你只是来烦我的，那我就让你见识见识我的熔炉到底有多热……哦嚯，原来如此。算是加急送货，是吧。我或许就是你要找的人，可你要是想让我尽快办成，这点少得可怜的金币可不够。想在最短时间内弄完，就再给我一百金币，我会考虑考虑的。成交？完成：这才叫像样的报酬。现在稍等一下，我马上就弄好。你带来的这些东西，读起来可一点都不轻松……完成任务后可获得：6500经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42034) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42035, '你回来了，希望是好消息？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42035) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42036, '乔拉齐没有说谎。你很少见到工艺如此精湛的箱子。细小的饰件与花纹点缀其上，一股神秘而魔幻的气息从中散发出来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42036) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42037, '如果你真的愿意帮我这个忙，那意义可就大了。不过要小心，货丢了已经够糟了，我可不想再搭上一条人命。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42037) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42038, '在那些该死的巨魔身边千万别放松警惕。他们毫无荣誉可言，就算你背过身去也会动手。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42038) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42039, '做好万全准备，霜鬃巨魔是狡猾的敌人。完成 这么说，Ubukaz被干掉了？我简直不敢相信自己的耳朵。我毫不怀疑还会有另一个巨魔站出来当上酋长，但接下来的这些日子里，丹莫罗总算能太平了。趁他们内斗还没结束，我们还有时间庆祝一番！奖励 完成任务后可获得：1200 点经验值，铁炉堡 300 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42039) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42040, '那么……你运气怎么样？要不是没办法，我可不想在这底下多待了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42040) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42041, '哦嚯嚯！看来我小看你了，$N。这些割藤刀几乎能切开空气；这些口粮又顶饱又好吃！我真是服了，你这几下子把我彻底镇住了。按说好的，我教你几手小窍门——那些能让你在最凶险的荒野里也活下来的窍门。完成 别磨蹭了！年轻人，时间可不等人。奖励 完成任务后可获得：4800 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42041) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42042, '无论是什么东西，竟比我的父神塞纳留斯更受他们尊崇，那一定强大得无法想象。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42042) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42043, '当心，你的对手身上残留着看不见的力量。还是小心为妙。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42043) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42045, '你读过那道符文了？太好了！你站在我面前，就说明你有足够的意愿与热忱，去走上那条只有少数人能掌握、并能活着回来的旅程。我的部族看见了折磨我们古老家园的病根——那些在冰原与黑山穴之间乱窜的害虫。如果我们的人民不肯用一切必要手段消灭伤害我们的人，铁炉堡注定要灭亡。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42045) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42046, '这任务是不是比你原先预想的更棘手一些？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42046) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42047, '在这片土地上，这地方与其说是安息之所，倒更像是托儿所。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42047) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42048, '你为什么来烦我？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42048) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42049, '你倒是胆大，竟敢前来求见。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42049) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42050, '你完好无损地回来了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42050) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42051, '我在听。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42051) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42052, '鼓起你的勇气。能走上荣耀之路的人从来不多。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42052) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42053, '告诉我，你究竟为何而战？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42053) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42054, '是天界兄妹指引你迈出最初的一步来到我面前，$N。你在这里、在红云台地完成训练期间，将由我照看你，尽我所能教你。我相信你渴望亲眼看看这个世界，甚至想踏上前往月语海岸的朝圣之旅。月蹄村存有三卷祈祷卷轴，每一卷献给兄妹中的一位。完成 朋友，还要过许多个周期，你的蹄子才准备好踏上那条路。你的训练继续。等你积累了更多战斗经验，再来找我。虔诚信奉天界兄妹会让你超越部族的界限。大地母亲的眼与泪都眷顾着你。从今往后无论你走哪条路，至少他们中的一个会与你同在。奖励 完成任务后可获得：40 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42054) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42056, '你可以把治疗与强化同伴看作 安瑟 与 穆莎 的延伸。安瑟 的光芒温暖地抚平伤口，而 穆莎 每一轮循环中夜空里的白花，则是指引你走出黑暗的路标。洛修 能安抚，却不能治疗。他赐予你的天赋弯折、修补的是心智，而非躯体。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42056) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42061, '友善的面孔？在这儿？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42061) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42062, '欢迎来到纳瓦利斯哨站。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42062) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42063, '你好，朋友。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42063) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42064, '他们一直在看着。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42064) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42065, '当心他们的匕首。刀刃上涂的毒不属于这个世界。它会在血里烧得冰寒。我见过强壮的战士被划出一道不比荆棘更深的伤口，就跪倒在地。别指望护甲能救你。也别指望治疗者能及时救你——连他们对付那种毒都很吃力。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42065) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42066, '上层精灵的幽灵仍以为自己还活着。他们盘踞在废墟里，巡逻着早已不存在的街道，守卫着几百年前就覆灭的城市。在他们心里，一切都没有变。他们不会心甘情愿交出秘密，也不会交出神器。做好动手的准备。他们会凶狠、顽固，而且对你敢打扰他们的幻梦感到极其愤怒。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42066) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42067, '小心行事。堕落者不可小看。他们莽撞，却不愚蠢，出手时带着绝望催生的残忍。别掉以轻心。很多人就是这样死的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42067) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42068, '有事吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42068) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42069, '别走得太远。再往北，在一处德鲁伊林地中还有另一座古墓穴。那里的德鲁伊已经非常清楚地表明了他们对我们的态度，可谈不上欢迎。他们守护的东西并非为我们准备，而我们已经捉襟见肘，我不会让你再去招惹另一个敌人。离那个地方远一点。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42069) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42070, '欢迎来到血蹄村。你有什么想告诉我的吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42070) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42071, '上前来吧。这位长者愿意听你说。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42071) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42072, '你是来报好消息的吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42072) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42074, '你见我父亲花的时间比我预想的多。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42074) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42075, '还活着？是靠胜利，还是靠胆怯？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42075) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42076, '你收集到多少了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42076) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42077, '每次派你出去办事，你总会比我想的多花些时间。说说看，你找到 Moondancer 了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42077) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42078, '我已经感觉到他的死了。我的死是不是也快到了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42078) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42079, '又回来受训了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42079) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42080, '你是朋友还是敌人？看来两者兼有，部落的一员。我何德何能，让你在这时候来搭救我？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42080) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42081, '是的，我能帮你什么？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42081) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42082, '我必须提醒你，取到羽毛时务必轻柔，它们很脆弱！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42082) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42083, '当心德莱尼，他们是很狡猾的对手。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42083) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42084, '我建议你先做好准备，这绝非易事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42084) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42085, '有事吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42085) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42086, '搜查废墟时要当心。哪怕最微不足道的遗物，也可能藏着值得铭记的故事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42086) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42087, '如今，那些发狂的德鲁伊和他们的爪牙游荡在这些曾经神圣的殿堂之中。务必当心。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42087) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42088, '牛头人是可怕的对手。单凭他们的力量就足以震碎盾牌和骨头。别被他们的体型骗了，以为他们行动迟缓。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42088) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42089, '留心水面。纳迦最爱伏击。他们会潜在水底，等你靠岸太近时再动手。已经不止一支巡逻队吃过这个教训了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42089) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42090, '别小看他们。这两个人在伊利丹的战役中统领过军队，从屠杀数百人的战斗里活了下来。这种家伙可没那么容易倒下。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42090) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42091, '有事吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42091) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42092, '召星者不会像你熟悉的那些生物那样打架。蓝龙运用奥术就像大多数人呼吸一样轻松。小心法术。小心那些突然爆发的能量——它们会让空气本身与你为敌。而如果那块陨石真的强化了它……那这场仗会比我想象的更有意思。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42092) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42093, '接近角鹰兽时要小心。它们本性并不敌对，但会拼命守护自己的巢。要是有一只从你头顶飞起，睁大眼睛——它们从空中扑击的速度比多数人预想的快得多。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42093) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42094, '与那些背弃平衡的德鲁伊打交道时要当心。他们依然掌握着与我们相同的力量。梦境依然回应他们……尽管它不该如此。仅凭这一点，他们就够危险了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42094) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42095, '有事吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42095) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42096, '别在艾纳兰待太久。那里的森林已不再安宁入梦。有更黑暗的东西正透过它的根系注视着。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42096) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42097, 'Krothis 曾是林地的守护者。那样的生物不会轻易倒下，而追随 Mothshroud 的人也很少单独作战。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42097) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42098, '挺起胸膛，士兵。磨利你的头脑，鼓起你的勇气，这场战斗很快就会结束。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42098) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42099, '矮人及其盟友为了保证任务成功，用起阴招来从不手软。别让他们占了上风！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42099) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42100, '愿圣光指引你，让那些贫苦之人沐浴在它的仁爱之中。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42100) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42101, '据说大自然的精灵是幸运与富足的使者。我确信我看到的就是它。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42101) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 50322, '和平从来都不是选项' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 50322) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 50323, '和平从来都不是选项' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 50323) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 50331, '和平从来都不是选项' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 50331) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 50332, '和平从来都不是选项' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 50332) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 55038, '欢迎回到怒水港。踏洛的事处理了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 55038) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 55039, '这本典籍至关重要，请尽快行动，$R大师。完成 达拉然非常感谢你的努力，正是像你这样的冒险家的努力才让这个世界不再走向迷失。奖励 完成任务后可获得：2675 点经验值，达拉然 150 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 55039) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 55046, '那矿石应该是深黑色的，去找吧！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 55046) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 55056, '$N，这个冬幕节，我最诚挚的心愿就是给每个人带来欢乐与幸福！可我现在既没有腿也没有能活动的肢体，而且考虑到我这种……雪花般的天性，到处乱跑也相当危险。我需要你和你所有的朋友一起动手，用魔雪的力量砸我！借着你们雪球能量汇聚的欢乐，我会茁壮成长，然后为大家放出点特别的东西！雪球 完成 太棒了！这些欢乐会释放出多大的力量，谁也说不准！奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 55056) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 60012, '圣骑士！护佑弱者、向邪恶降下正义，是一份沉甸甸的责任。要看清敌人的弱点、伸张正义，你必须拿出全部的本事。而最重要的是，你要比以往任何时候都更加笃信圣光，圣光必将赐予你力量。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 60012) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 80745, '多美的月夜啊！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 80745) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));

-- ---- EndText_loc4（36 条）----
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 5721, '接受雷德帕斯的宽恕' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 5721) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 6847, '取回了赖森大师的全视之眼' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 6847) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 6848, '取回了赖森大师的全视之眼' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 6848) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 7629, '羊皮纸已制成' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 7629) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 8358, '对卡利·雷米克做出「/train」表情' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 8358) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 8359, '向旅店老板格雷什卡展示肌肉' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 8359) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 9260, '调查一处法阵' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 9260) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 9261, '调查一处法阵' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 9261) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 9262, '调查一处法阵' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 9262) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 9263, '调查一处法阵' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 9263) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 9264, '调查一处法阵' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 9264) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 9265, '调查一处法阵' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 9265) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 39980, '击杀过去一天中获得最多非荣誉击杀的玩家。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 39980) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 39981, '击杀过去一天中获得最多荣誉击杀的玩家。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 39981) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 40248, '驯服衰老的黑暗犬' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 40248) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 40249, '驯服巨型夜行蝙蝠' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 40249) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 40250, '驯服提瑞斯法瘟疫熊' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 40250) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 41569, '在醉酒状态下与一名人类、兽人、巨魔或矮人玩家共舞。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 41569) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 41570, '在醉酒状态下与一名暗夜精灵、牛头人、亡灵或侏儒玩家共舞。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 41570) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 41571, '在醉酒状态下与一名高等精灵或地精玩家共舞。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 41571) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 41802, '探索了古墓深处' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 41802) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 41848, '发现了隐藏通道' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 41848) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 41946, '保护了农夫登法尔' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 41946) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 42085, '看哪，月蹄庆典。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 42085) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 42098, '荆棘峡谷之战获胜。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 42098) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 42099, '荆棘峡谷之战获胜。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 42099) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 50310, '完成试跑' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 50310) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 50312, '完成试跑' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 50312) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 50316, '完成比赛' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 50316) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 80331, '驯服可怕的杂斑野猪' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 80331) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 80332, '驯服海浪蟹' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 80332) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 80333, '驯服硬甲蝎' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 80333) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 80340, '驯服大峭壁野猪' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 80340) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 80341, '驯服雪豹' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 80341) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 80342, '驯服冰爪熊' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 80342) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));
INSERT INTO `locales_quest` (`entry`, `EndText_loc4`)
  SELECT 80745, '在水里使用提灯' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `EndText_loc4` FROM `locales_quest` WHERE `entry` = 80745) x
                      WHERE x.`EndText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `EndText_loc4` = IF(`EndText_loc4` REGEXP '[一-龥]', `EndText_loc4`, VALUES(`EndText_loc4`));

-- ---- ObjectiveText1_loc4（60 条）----
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 7481, '找到了卡里尔·温萨鲁斯大师' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 7481) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 7482, '找到了卡里尔·温萨鲁斯大师' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 7482) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 9257, '净化埃提耶什' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 9257) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 9269, '净化埃提耶什' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 9269) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 9270, '净化埃提耶什' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 9270) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 9271, '净化埃提耶什' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 9271) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 9322, '艾萨拉烈焰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 9322) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 9323, '诅咒之地烈焰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 9323) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 9367, '暴风城烈焰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 9367) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 9368, '奥格瑞玛烈焰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 9368) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 39978, '奢华红色焰火' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 39978) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 39979, '奢华红色焰火' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 39979) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 40829, '重铸了上层卡拉赞塔之匙' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 40829) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 40957, '聆听拉拉修斯的故事' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 40957) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 40961, '等待仪式完成' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 40961) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 40972, '聆听达瑞斯·鸦林的故事' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 40972) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 40982, '把黑心项链放到富兰克林的墓前' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 40982) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 40985, '等待布托克·云角完成他的仪式' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 40985) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41014, '仪式完成后与帕纳布斯交谈。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41014) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41030, '等待巨豹之灵将洛雷什从痛苦中解脱' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41030) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41339, '调查暗谷小径附近的骚动' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41339) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41372, '等待仪式结束' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41372) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41383, '聆听了大德鲁伊梦风' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41383) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41388, '通过了试炼' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41388) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41637, '与劳埃德交谈' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41637) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41643, '审讯伊格纳兹' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41643) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41649, '聆听了广播录音' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41649) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41677, '火药桶已引爆' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41677) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41682, '火药桶已引爆' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41682) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41684, '找到了行凶者' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41684) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41694, '找到了密探弗林' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41694) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41698, '在熔炉安置炸药' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41698) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41711, '平息了珍珠的怒火' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41711) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41731, '等待先知莫萨完成他的仪式' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41731) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41745, '净化了艾露恩之镰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41745) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41803, '聆听萨尔斯伊斯' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41803) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41861, '通过了瑞瑟乌斯的挑战' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41861) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41911, '已找到Narlan' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41911) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41915, '质问过 Morogai Kla' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41915) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41956, '找到了冬泉部族' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41956) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41962, '从凡戈恩口中得知了真相' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41962) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 41970, '已调查第一支商队' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 41970) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 42051, '旋风神殿' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 42051) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 42056, '治疗并强化 勇士绿角' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 42056) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 42068, '聆听了阿恩达尼尔·逐日者' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 42068) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 42073, '聆听了长者月蹄' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 42073) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 50002, '完好的人类头颅' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 50002) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 50004, '完好的兽人头颅' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 50004) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 50319, '向术士扔雪球' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 50319) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 50320, '向德鲁伊扔雪球' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 50320) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 50321, '向加兹鲁维扔雪球' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 50321) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 50328, '还得喝个烂醉' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 50328) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 50330, '击败雪球' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 50330) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 55030, '获取情报' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 55030) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 55048, '找到巴克希尔，死活不论' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 55048) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 55211, '等待巴斯罗斯·雷霆震裂完成他的伟大发明' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 55211) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 60036, '把正义宝珠和无暇的德莱尼水晶球交给时尚达人学徒，作为报酬获得 3 枚幻化币。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 60036) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 60050, '把特蕾莎的铜币扔进喷泉' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 60050) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 60104, '测试便携式虫洞发生器' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 60104) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 60134, '瞪羚已接种疫苗' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 60134) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));

-- ---- ObjectiveText2_loc4（20 条）----
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 9322, '希利苏斯烈焰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 9322) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 9323, '瘟疫之地烈焰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 9323) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 9367, '铁炉堡烈焰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 9367) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 9368, '雷霆崖烈焰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 9368) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 39978, '奢华绿色焰火' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 39978) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 39979, '奢华绿色焰火' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 39979) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 40801, '听听星风指挥官和铁林地修士要说的话' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 40801) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 40807, '听听星风指挥官和布罗森·铁林地要说的话' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 40807) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 41388, '聆听了萨克戈斯' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 41388) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 41637, '与埃莉交谈' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 41637) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 41643, '审讯法警兰卡斯特' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 41643) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 41694, '找到了密探切丽斯' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 41694) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 41698, '在瞭望塔安置炸药' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 41698) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 41956, '找到了木喉营地' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 41956) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 41970, '已调查第二支商队' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 41970) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 42051, '炽火神殿' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 42051) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 50328, '醉酒状态下与霍莉·云鬓跳舞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 50328) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 60036, '收集一个无暇的德莱尼水晶球' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 60036) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 60108, '0' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 60108) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 60124, '纳拉雷克斯获释' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 60124) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));

-- ---- ObjectiveText3_loc4（17 条）----
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 9322, '安戈洛烈焰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 9322) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 9323, '辛特兰烈焰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 9323) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 9367, '达纳苏斯烈焰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 9367) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 9368, '幽暗城烈焰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 9368) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 39978, '奢华黄色焰火' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 39978) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 39979, '奢华黄色焰火' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 39979) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 41388, '聆听了克兰诺克' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 41388) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 41637, '与拉多夫交谈' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 41637) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 41643, '审讯朱迪丝弗莱宁' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 41643) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 41694, '找到了密探埃尔罗伊' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 41694) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 41698, '在外墙安置炸药' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 41698) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 41956, '找到了绿爪部族' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 41956) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 41970, '已调查第三支商队' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 41970) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 42051, '峭岩神殿' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 42051) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 50321, '向老泥眼扔雪球' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 50321) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 60072, '0' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 60072) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 60074, '0' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 60074) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));

-- ---- ObjectiveText4_loc4（9 条）----
INSERT INTO `locales_quest` (`entry`, `ObjectiveText4_loc4`)
  SELECT 8105, '农场遭袭' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText4_loc4` FROM `locales_quest` WHERE `entry` = 8105) x
                      WHERE x.`ObjectiveText4_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText4_loc4` = IF(`ObjectiveText4_loc4` REGEXP '[一-龥]', `ObjectiveText4_loc4`, VALUES(`ObjectiveText4_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText4_loc4`)
  SELECT 9322, '冬泉谷烈焰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText4_loc4` FROM `locales_quest` WHERE `entry` = 9322) x
                      WHERE x.`ObjectiveText4_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText4_loc4` = IF(`ObjectiveText4_loc4` REGEXP '[一-龥]', `ObjectiveText4_loc4`, VALUES(`ObjectiveText4_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText4_loc4`)
  SELECT 9323, '灼热峡谷烈焰' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText4_loc4` FROM `locales_quest` WHERE `entry` = 9323) x
                      WHERE x.`ObjectiveText4_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText4_loc4` = IF(`ObjectiveText4_loc4` REGEXP '[一-龥]', `ObjectiveText4_loc4`, VALUES(`ObjectiveText4_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText4_loc4`)
  SELECT 41388, '聆听了卡夫艾' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText4_loc4` FROM `locales_quest` WHERE `entry` = 41388) x
                      WHERE x.`ObjectiveText4_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText4_loc4` = IF(`ObjectiveText4_loc4` REGEXP '[一-龥]', `ObjectiveText4_loc4`, VALUES(`ObjectiveText4_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText4_loc4`)
  SELECT 41637, '与特伊奥交谈' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText4_loc4` FROM `locales_quest` WHERE `entry` = 41637) x
                      WHERE x.`ObjectiveText4_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText4_loc4` = IF(`ObjectiveText4_loc4` REGEXP '[一-龥]', `ObjectiveText4_loc4`, VALUES(`ObjectiveText4_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText4_loc4`)
  SELECT 50321, '向阿鲁高之子扔雪球' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText4_loc4` FROM `locales_quest` WHERE `entry` = 50321) x
                      WHERE x.`ObjectiveText4_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText4_loc4` = IF(`ObjectiveText4_loc4` REGEXP '[一-龥]', `ObjectiveText4_loc4`, VALUES(`ObjectiveText4_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText4_loc4`)
  SELECT 60007, '0' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText4_loc4` FROM `locales_quest` WHERE `entry` = 60007) x
                      WHERE x.`ObjectiveText4_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText4_loc4` = IF(`ObjectiveText4_loc4` REGEXP '[一-龥]', `ObjectiveText4_loc4`, VALUES(`ObjectiveText4_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText4_loc4`)
  SELECT 60072, '0' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText4_loc4` FROM `locales_quest` WHERE `entry` = 60072) x
                      WHERE x.`ObjectiveText4_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText4_loc4` = IF(`ObjectiveText4_loc4` REGEXP '[一-龥]', `ObjectiveText4_loc4`, VALUES(`ObjectiveText4_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText4_loc4`)
  SELECT 60074, '0' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText4_loc4` FROM `locales_quest` WHERE `entry` = 60074) x
                      WHERE x.`ObjectiveText4_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText4_loc4` = IF(`ObjectiveText4_loc4` REGEXP '[一-龥]', `ObjectiveText4_loc4`, VALUES(`ObjectiveText4_loc4`));

