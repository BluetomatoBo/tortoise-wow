-- 乌龟服新任务的中文（第一阶段：现成来源）
--
-- 只写**当前数据库里还没有中文**的那些条目：先核对了 base + database_updates + 本仓库已提交的
-- wip_updates/locales_quest_*.sql（既有译文），我的候选里 1672/1848 条其实早有中文，全部剔除。
--
-- 每条都带「该列已有汉字则跳过」的保护，重复导入或库内有更新的译文都不会被覆盖。
-- 来源：1.12 官方简中任务库 + pfQuest-turtle zhCN（后者与服务端英文逐条比对过相似度）
--
-- 176 条。生效：mangosd 控制台 `.reload locales_quest`

SET NAMES utf8mb4;

-- ---- Title_loc4（25 条）----
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 20006, '禁用战争模式' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 20006) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 39977, '携手合作' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 39977) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41316, '高级珠宝加工XI:坚如磐石' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41316) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41352, '蒂莉亚阿姨' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41352) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41528, '越界' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41528) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41531, '让箭飞一会儿' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41531) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41534, '长柄，长柄' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41534) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41540, '锤子，落下！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41540) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41553, '欢迎来到美酒节!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41553) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41554, '欢迎来到美酒节!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41554) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41556, '最热的热饮!' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41556) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41561, '洛恩塔姆朗姆酒与完美酿造' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41561) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41565, '魔法的扭曲！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41565) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41569, '闭嘴，跟我跳舞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41569) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41570, '舞池谋杀' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41570) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41574, '时尚的重担压在他们肩上' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41574) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41577, '荒芜之主' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41577) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41651, '棋子落位' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41651) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41654, '祖先荣誉' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41654) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41743, '游戏大师的恩赐' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41743) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41772, '剑龙腺体' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41772) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41784, '科赞水果蛋糕进口' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41784) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41840, '仅存之物' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41840) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41882, '龙喉战争' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41882) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 80745, '点亮月夜' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 80745) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));

-- ---- Details_loc4（75 条）----
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 20006, '追踪玩家是否解除了战争模式。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 20006) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 39977, '你在这里引起了不小的骚动。虽然我睡得很沉，但你那些烟花太多了，我终于注意到它了。诚然，我醒来时看到的是一个令人愉快的演出。看到大家齐声庆祝，给这个古老之灵带来了令人欣慰的温暖。也许你和我的好朋友海龟之灵谈过吗？他自己肯定很想看到这样的奇观。$B$B事实上，我也是。这种愉快的合作是罕见的，需要珍惜！如果你能多带些那些非凡的烟花和一些凉茶来放松，我会与你分享我的一些好运祝福！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 39977) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 39978, '伟大的旅行者！今年是充满冒险的一年，充满兴奋、惊喜、挑战和新朋友。你面对了许多困难，勇敢面对更多危险，并从中取得了胜利——更强大、更聪明！让我们庆祝一下，用盛大的烟花来表达我们的感激之情！$B$B然而，任何普通的烟花都嫌不足。为了适当地纪念您和您的同胞的成就，我们需要一些真正独特的东西！在艾泽拉斯危险的地下城深处，最可怕的敌人和怪物在他们的财产中保留了奢侈的烟花。战胜他们，在我面前点燃三种不同的烟花来迎接我的祝福！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 39978) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 39979, '伟大的旅行者！今年是充满冒险的一年，充满兴奋、惊喜、挑战和新朋友。你面对了许多困难，勇敢面对更多危险，并从中取得了胜利——更强大、更聪明！让我们庆祝一下，用盛大的烟花来表达我们的感激之情！$B$B然而，任何普通的烟花都嫌不足。为了适当地纪念您和您的同胞的成就，我们需要一些真正独特的东西！在艾泽拉斯危险的地下城深处，最可怕的敌人和怪物在他们的财产中保留了奢侈的烟花。战胜他们，在我面前点燃三种不同的烟花来迎接我的祝福！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 39979) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41316, '这本书再次被装订完整，原本空白的封面上神奇地出现了标题——高级珠宝加工XI：坚如磐石。你试图打开它，感到一阵剧烈灼烧的疼痛感。封住书卷的锁上出现了一个炽热的符文。也许某个珠宝匠可以帮助你破译它的秘密。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41316) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41333, '<你手里拿着的这本书虽然纤薄，却感觉非常沉重。仔细检查书页后，你意识到其中大部分内容都超出了你的理解范围。也许其他人，这方面的大师可以帮你解读这本书。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41333) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41334, '<你手里拿着的这本书虽然纤薄，却感觉非常沉重。仔细检查书页后，你意识到其中大部分内容都超出了你的理解范围。也许其他人，这方面的大师可以帮你解读这本书。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41334) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41335, '<你手里拿着的这本书虽然纤薄，却感觉非常沉重。仔细检查书页后，你意识到其中大部分内容都超出了你的理解范围。也许其他人，这方面的大师可以帮你解读这本书。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41335) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41337, '<你手里拿着的这本书虽然纤薄，却感觉非常沉重。仔细检查书页后，你意识到其中大部分内容都超出了你的理解范围。也许其他人，这方面的大师可以帮你解读这本书。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41337) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41352, '<完成工作和奖励后，你只剩下一枚昂贵的金戒指，这对你你毫无用处。鉴于这实际上是伯爵家族的财产，你思考阿基巴德是否会在他糟糕透顶的境遇中接受这个>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41352) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41353, '只需轻轻一按，紫水晶就会开始在昏暗的灯光下闪耀，很容易让您的眼睛一直沉迷的注视它。然而，吸引你心动的并不是它的美丽。一个声音在你的脑海中响起。一个不属于你的声音。它以严厉而舒缓的语气回荡着：$B$B“你得多想一想因塔苟斯。回到凯斯利尔并在我面前找到安慰。那座塔是不可预测的，它祈祷的魔网纯粹是混乱的。不要再自欺欺人了，朋友。还有别的方法！$B$B紫水晶不再闪耀。每当被触碰时，它都会简单地说出同样的信息。你偶然发现了一件多么奇怪的事情。也许探索凯斯利尔湖会为您提供某种答案。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41353) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41519, '<这本厚重的书证明了马迪亚斯大师对战争艺术的严谨奉献。仅仅试图通过翻阅概览就会让你感到畏惧。谁能想到，用法杖打斗这么简单的事情，竟然能写满整本书？最引起您兴趣的是关于熊猫人的简短部分，熊猫人是来自大洋彼岸的一个像熊一样的类人生物的神秘种族。显然，他们以无与伦比的大师级战斗能力而闻名。出于好奇，你决定把这本书带给诺拉。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41519) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41522, '这部厚重的巨著见证了马迪亚斯大师对战争艺术坚定不移的奉献。仅仅翻翻书页就能留下令人敬畏的印象，书中展示了对阿曼尼巨魔的细致描述，挥舞各种投掷武器的技术，以及投掷手套的复杂艺术。然而，仅仅了解历史并不等于精通。既然你必须把书还给诺拉，也许她能帮助你实际应用书中的教义。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41522) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41525, '这本厚重的书证明了马迪亚斯大师对战争艺术的严谨奉献。仅仅通过翻页来获得概述会让你感到畏惧。这本书大部分时间都在自相矛盾，因为它声称枪既有用又有缺陷。虽然它的破坏力得到了充分的考虑，但它的噪音和对粉尘的要求是一个相当大的缺点。作为一名研究人员，诺拉可能会提供更多的见解。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41525) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41528, '这本厚重的书证明了马迪亚斯大师对战争艺术的严谨奉献。仅仅通过翻页来获得概述会让你感到畏惧。可以从中推测出弩的发明和改进的详细历史，但你觉得它的真正本质和联系都逃避了你。不管怎样，你都需要把书还给这个诺拉，也许她能帮助你更好地理解它。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41528) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41531, '这本厚重的书证明了马赛厄斯大师对战争艺术的严谨奉献。仅仅通过翻页来获得概述会让你感到畏惧。暗夜精灵几个世纪以来的射箭宣言，阿拉希弓箭的早期制作和赞达拉巨魔使用的奇怪技术只是这些页面中包含的智慧的一小部分。感到不知所措，你想知道诺拉·萨格斯提到的这一点是否能帮助你充分利用它。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41531) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41534, '这本厚重的书证明了马迪亚斯大师对战争艺术的严谨奉献。仅仅通过翻页来获得概述会让你感到畏惧。长柄武器被描述为有效和强大。由于它们的长柄，持用者可以在没有直接近身格斗的情况下进行攻击。据说人类军队在与兽人的战斗中更喜欢使用它们，因为它们的大小不同。你觉得这种武器没有得到应有的尊重，所以你找诺拉学习更多。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41534) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41537, '这本厚重的书证明了马赛厄斯大师对战争艺术的严谨奉献。仅仅通过翻页来获得概述会让你感到畏惧。它描述了达隆郡之战以及一个决定了这场战役命运的天灾军团首领。这本书描述了他的行为是邪恶和残酷的，但没有错过描述黑衣玛杜克使用的剑的机会。对这样一个怪物的崇拜让你感到困惑，当你走向诺拉的时候，你血管里的血液开始沸腾。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41537) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41540, '这本厚重的书证明了马迪亚斯大师对战争艺术的严谨奉献。仅仅通过翻页来获得概述会让你感到畏惧。书中提到了锤子在矮人文化中的重要性。虽然你看不懂大部分内容，但这本书以一个传奇结尾。据说，矮人过去常常通过向空中投掷锤子来占领丘陵和山脉，锤子落地的地方就是他们的新家。被这个传说所吸引，你找到了诺拉。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41540) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41543, '这本厚重的书证明了马迪亚斯大师对战争艺术的严谨奉献。仅仅通过翻页来获得概述会让你感到畏惧。兽人部落对斧头之爱的研究。在书中，一个名字被多次称颂。被字里行间所描绘的深深的敬意所淹没，你发现自己急切地走向诺拉，这样你就可以了解更多。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41543) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41546, '这本厚重的书证明了马迪亚斯大师对战争艺术的严谨奉献。仅仅通过翻页来获得概述会让你感到畏惧。你开始意识到你一直都带着武器。自从艾泽拉斯第一个种族的黎明开始，进化本身就开始于拳头。不然它们是如何生存和适应的？你羡慕地盯着你的拳头——如果你就是武器，你就不需要武器。你准备好和诺拉谈谈你对拳头的新欣赏了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41546) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41549, '这本厚重的书证明了马迪亚斯大师对战争艺术的严谨奉献。仅仅通过翻页来获得概述会让你感到畏惧。这本书的大部分内容都是围绕着匕首的不同形状和长度，以及招架和刺杀技巧展开的，但书中的大部分内容都是关于解剖学的：重要器官、肌肉群、肌腱和动脉的位置。同样的好奇和不知所措，你决定和这个诺拉谈谈马迪亚斯大师的作品，希望能更多地了解它。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41549) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41553, '听着，听着！一个独特的比赛在繁忙的棘齿城展开！任何对精美麦酒、烈酒和黑啤酒的鉴赏家都不应错过这个无与伦比的机会。带上你的酒友，来帮忙酿造整个艾泽拉斯最完美的酒精饮品！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41553) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41554, '听着，听着！一个独特的比赛在繁忙的棘齿城展开！任何对精美麦酒、烈酒和黑啤酒的鉴赏家都不应错过这个无与伦比的机会。带上你的酒友，来帮忙酿造整个艾泽拉斯最完美的酒精饮品！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41554) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41555, '我一生的目标是创造出艾泽拉斯最烈、最劲的饮品：角牙酿！它浓郁的风味和独特的口感将让任何享受其泡沫和苦味的人着迷。前提是我能将配方调制成功。我不想承认，但我之前的尝试总是不成功。我缺少一些能真正将所有原料结合在一起的东西。我只需要找出它是什么！这就是我来棘齿城的原因，收集关于那缺失的成分的各种传闻和故事。$B$B显然，剃刀沼泽当地的野猪人在酿造他们自己的酒。谁能想到这些原始的野猪人能够自己酿造烈酒？我需要找出这个烈酒的真相，它是如何制作的，是否有我正在寻找的秘密成分！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41555) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41556, '我想我对这个烈酒的制作有了很好的理解。它与我之前用石南草酿造的酒不太一样，然而，他们一定使用了不同的方法。也许他们使用了更高的温度...? 是的，这一定是！在酿造石南草时使用更高的温度可以将苦味减少到令人愉悦的程度。但我仍然不知道他们是如何实现如此强烈的火焰的。他们一定使用了魔法。由于我没有魔法手段，我们必须寻找其他东西。这个世界的元素有时会留下他们本质的一丝火花。这样的一种东西可以潜在地将火焰加热到所需的水平。$N，出去从任何火元素那里带回一些元素火焰 - 我们需要它来助燃！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41556) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41557, '那边的索尔登刚刚喋喋不休地谈论发现了关于东部王国洛丹伦酒的突破性发现。我不能让这个小家伙在我面前占便宜，这就是为什么我们要更上一层楼！虽然他对自己那糟糕而乏味的洛丹伦酒感到满意，但我们的目标是神秘的血色甜酒，这是一种极少有人机会品尝的酒，据说是个传奇。$B$B我听说这是一种圣光驱动饮料，是血色十字军的一种烹饪特产，在提瑞斯法林地的修道院里酿造。如果这种酒真的有这些神奇的特性，那我需要得到它！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41557) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41558, '银松森林拥有独特的植被，能够在山区和恶劣的环境中生长。它们的风味表面上看似苦涩，因此很少被不成熟的酿酒者使用。然而，我们可以充分利用这种植物。它可能没有复制血色甜酒热辣感觉所需的特性，但结合野猪人的酿造技术，我们或许能够提炼出独特的风味，供我们的酿酒使用。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41558) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41559, '找到一种味道辛辣火热的植物可能很困难。我在酿酒冒险中遇到的许多植物都有一定的香料味，但没有一种能达到血色甜酒的水平。幸运的是，我从码头的地精那里听到了一些传言；你会惊讶于这里贸易的繁荣，他们能听到多少故事。$B$B在东部王国，荒芜之地上生长着一种鲜艳的红色蛇麻草。显然，当地的食人魔会抓起这些蛇麻草的团块并咀嚼它们——生嚼！每当我不得不与这些大块头打交道时，他们总能让我感到惊讶。把它们的蛇麻草抢过来，带给我，我们会更好地利用它。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41559) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41560, '让我们尝试一些非常规的方法。没有同样确切的配方，重现血色甜酒的热度将是一项挑战，但我相信我们可以尝试一些不同的东西。灼热峡谷是一个灼热的沙漠，几乎没有植被。尽管如此，一些植物似乎在火山土壤上生长得很出色——其中之一就是黑色蛇麻草。我推测蛇麻草从加热的土壤中吸收营养，自然赋予它们一种烟熏香料的风味。找到它的最好方法是亲自去抓一些来试试！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41560) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41561, '好的，$N。我们距离完善配方非常接近，我能感觉到！我们有银色蛇麻草，带着浓重的泥土苦味，还有红色和黑色蛇麻草的香料和烟熏质感，以及将其蒸馏成清晰而辛辣饮品所需的热度和技术！我们只需要那甜美的后味来完成这个组合；我知道完美的来源！$B$B在菲拉斯茂盛的荒野中，隐藏着厄运之槌的可怕废墟。在它那被诅咒的花园里，生长着一种根，我相信他们称之为洛恩塔姆地薯。这种薯块被认为具有强烈的甜味，即使在高温下烹饪也能存活。我们需要这个根来完成角牙珍藏！我们距离不朽只一步之遥，$N。不要浪费时间！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41561) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41562, '我一生的目标是创造出最强烈、美味和香醇的饮品，誉满艾泽拉斯：雷酒金啤！它那丰富的风味和独特的质感将吸引任何沉醉于其泡沫和苦味的人。至少我希望如此，但我之前的尝试总是以不同的方式失败。总有一些东西缺失，无法将所有的成分结合在一起。我只需要找出是什么！这就是我来棘齿城的原因，铁炉堡那些笨蛋们只会胡言乱语，根本看不出伟大是什么，直到伟大咬了他们的屁股！$B$B要酿造出真正美味的啤酒，需要多种不同类型的蛇麻草。由于常见的蛇麻草变种没有我渴望的强烈风味，我需要寻找一些不寻常的东西。我听说南方的野猪人擅长酿造艺术，他们一定有自己的蛇麻草！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41562) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41563, '酸味是每种啤酒都需要的一种味道，有些多一些，有些少一些。洛丹伦啤酒就是前者，你不会找到比这种美酒更酸的酒。个人来说，我不喜欢这种饮品，但我能欣赏不同文化所创造的多样性……即使人类酿造酒的方式只是小孩子的把戏。哈！$B$B不过，我们仍然可以同样利用他们的资源。在希尔斯布莱德的东南山丘上，生长着希尔斯布莱德蛇麻草，这是一种真正独特的蛇麻草，具有整个东部王国最浓烈的酸味。我需要这些作为我新的酿造尝试！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41563) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41564, '我可能是一个骄傲的铁炉堡矮人，但即使我也必须承认我们的蛮锤兄弟所酿造的精美麦酒和烈酒。我很少有机会享用如此极其苦涩的浓烈麦酒。仅仅一口就让我失去了平衡，真是一种无与伦比的体验！这种苦涩必须出现在我完美的麦酒中，必须如此！我一个好朋友告诉我，最苦的蛇麻草生长在辛特兰，距离鹰巢山不远。没有这种强烈的苦味，我的酿造无法完成。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41564) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41565, '你可能已经察觉到了，但那边的这个业余兽人认为他能酿出比我们矮人更好的饮品。依我看，这是个傻瓜的差事。但我并不是傻瓜，所以我们必须确保他的野心以失败告终。$B$B我无意中听到他兴奋地宣布要用元素火焰来点燃他的蒸馏火，所以我们自己也要利用元素。似乎这才公平，不是吗？我已经开始酿造你给我的蛇麻草，但它们并没有很好地融合在一起。元素之水或许正是解决这个问题的办法——而且，它可能甚至给饮品增添一丝额外的刺激！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41565) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41566, '我碰到了一个……可以说是“小”问题，关于我现在的饮品。将三种蛇麻草混合在一起是个绝妙的主意，但浓烈蛇麻草的苦味压倒了其他所有味道！如果我们保持蒸馏物不变，我不如就用浓郁蛇麻草酿造。幸运的是，我在港口听到一个传言，或许这正是解决我们问题的办法。金棘酒是一种应该非常苦涩的饮品，但它的味道却意外地顺滑柔和，正是完美的下午饮品！我怀疑那秘密成分就是金棘本身。有了几根根茎，我就可以测试我的理论是否成立。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41566) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41567, '$N！这是个灾难！我刚刚检查我的帐篷，寻找更多的材料，却发现我的“雷酒金啤”计划不见了！这一定是该死的霍尔雷·黑须，他和他的家族已经和我们家族是死敌，已经很多年了。他们无法接受我们的啤酒是优于他们那温吞的烂泥汤的事实。我们必须把它找回来。这个配方包含了完成我完美饮品的最后几个关键步骤。黑须肯定逃回了黑石深渊，找到他，给我把我的计划找回来！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41567) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41568, '我们有了蛇麻草、我们的魔法成分和金棘草来减少一切的苦味。拿回我的计划后，只剩下一件事情来完成“雷酒金啤”：金色蛇麻草。$B$B一种神话般的成分，许多矮人认为这不过是铁炉堡酒馆里醉汉讲的童话。但我知道得更清楚——我见过它！它在我喝空十桶啤酒后出现在我的梦中。一只金色的兔子，闪闪发光，宛如你见过的最上等的啤酒。它就在那里，在一片沙漠中那些巨大的骨骼间神秘地站着，仿佛一个预兆。然而我知道这真正的意义。它在召唤我去寻找它；去用金色蛇麻草创造金啤！无论它在哪里，找到这只兔子，金色蛇麻草就会是我们的！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41568) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41569, '喂，我跟你说，没有什么比不停地喝啤酒然后融入节日的节奏更令人振奋的了。来，抓起你的酒杯，开始扭动你的臀部！我想看到你完全喝醉，和这里的每个人一起跳舞。干杯！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41569) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41570, '喂，我跟你说，没有什么比不停地喝啤酒然后融入节日的节奏更令人振奋的了。来，抓起你的酒杯，开始扭动你的臀部！我想看到你完全喝醉，和这里的每个人一起跳舞。干杯！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41570) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41571, '喂，我跟你说，没有什么比不停地喝啤酒然后融入节日的节奏更令人振奋的了。来，抓起你的酒杯，开始扭动你的臀部！我想看到你完全喝醉，和这里的每个人一起跳舞。干杯！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41571) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41572, '哦，我的天哪！你想这样去见守卫吗？大胆，我必须说，但也许有点太大胆了。看在对时尚的热爱上，我不能让你穿着这身破衣服登上塔顶。虽然听起来很残酷，但这是事实！我一看你戴的头饰就浑身起鸡皮疙瘩。策划这场暴行的人应该受到审判。我可以帮你，帮你设计一个新的，更时尚的——如果你帮我处理一些我自己的用品。我们成交了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41572) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41573, '哦，我的天哪！你想这样去见卫兵吗？大胆，我必须说，但也许有点太大胆了。看在对时尚的热爱上，我不能让你穿着这身破衣服登上塔顶。虽然听起来很残酷，但这是事实！光看你穿在身上的那条护腿，我就浑身起鸡皮疙瘩。策划这场暴行的人应该受到审判。我可以帮你，帮你设计一个新的，更时尚的——如果你帮我处理一些我自己的用品。我们成交了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41573) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41574, '哦，我的天哪！你想这样去见卫兵吗？大胆，我必须说，但也许有点太大胆了。看在对时尚的热爱上，我不能让你穿着这身破衣服登上塔顶。虽然听起来很残酷，但这是事实！光看你穿的这些破布，我就浑身起鸡皮疙瘩。策划这场暴行的人应该受到审判。我可以帮你，帮你设计一个新的，更时尚的——如果你帮我处理一些我自己的用品。我们成交了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41574) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41575, '哦，我的天哪！你想这样去见卫兵吗？大胆，我必须说，但也许有点太大胆了。看在对时尚的热爱上，我不能让你穿着这身破衣服登上塔顶。虽然听起来很残酷，但这是事实！光看你穿的那件胸衣，我就浑身起鸡皮疙瘩。策划这场暴行的人应该受到审判。我可以帮你，帮你设计一个新的，更时尚的——如果你帮我处理一些我自己的用品。我们成交了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41575) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41576, '哦，我的天哪！你想这样去见卫兵吗？大胆，我必须说，但也许有点太大胆了。看在对时尚的热爱上，我不能让你穿着这身破衣服登上塔顶。虽然听起来很残酷，但这是事实！你披在身上的斗篷让我浑身起鸡皮疙瘩。策划这场暴行的人应该受到审判。我可以帮你，帮你设计一个新的，更时尚的——如果你帮我处理一些我自己的用品。我们成交了？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41576) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41577, '在你的手中，是荒芜巨岩的统治者，恐怖魔王孟菲斯托斯仍然在跳动的心脏。你和你的远征军挫败了他利用卡拉赞作为再次入侵艾泽拉斯的入口的计划。被永远驱逐到黑暗的彼方，这就是那个邪恶阴谋家的全部遗存了。为了万无一失，你应该把它交给能彻底清除它生命的人。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41577) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41651, '<翻阅日记，你会推断出那个地精的身份是比兹邦·链盒，一位来自科赞的工程师，显然在安德麦的一些原型机械上与查波合作过。从你能读到的内容来看，他一定对没有被查波的永望广播公司录用内心感到非常不满。$B$B案件已结案。有点太容易了，你不喜欢。有些事情真的说不通，但结案了就是结案了。是时候回报给永望镇的查波·查皮布拉斯了。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41651) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41652, '<在最初的几次广播后不久，节目突然被切断，取而代之的是一个奇怪且不祥的干扰。它并没有持续很长时间，因为它就像它出现的那样迅速结束。现在你能听到的只是深入你耳朵的令人麻木的静电。显然不是由查波·查皮布拉斯或他的任何客人派来的，你对刚刚目睹的事情感到困惑。对整个场景感到好奇，你决定亲自去永望镇拜访那个电台地精>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41652) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41653, '您好，旅行者，祝您农历新年快乐！每年的这个时候都会召唤着我们在未来一年努力实现的新志向、梦想和抱负。因此，倾听和思考那些在言行中蕴含智慧的人是很重要的。我的祖先走遍了 卡利姆多，遇到了许多神话中的生物和精灵。其中一位，对大多数人来说并不起眼，却拥有最深刻的洞察力。直到今天，我的部落在需要的时候寻求这种精神的指导。$B$B我 希望您去拜访它，从它的话语中学习并牢记在心。大自然在它的巢穴中低语;在尘泥沼泽的西北沼泽中，你会找到它。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41653) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41654, '农历新年是许多牛头人部落和家庭的盛宴。虽然我们到处都有习俗，但其中大多数都是他们部落独有的。我仍然记得我父亲曾经给我讲的故事，关于他在新年庆祝期间参加的第一次狩猎。那时，野猪在草原上漫步是很常见的。它们的猪群可以很远很远地看到，我们的猎人每年都会聚集在一起，为整个部落准备盛宴。$B$B 如今，野猪早已被刺背野猪人屠戮或圈养起来。$N，我想亲自准备一场盛宴来向我的祖先致敬，所以请帮助我实现这个目标。杀掉任何种类的野猪，把它们的尸体带回来十个，这应该足够月光林地这里所有快乐的旅行者吃了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41654) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41655, '祝福你的家庭， 旅行者。庆祝活动如火如荼，来自艾泽拉斯各地的游客源源不断地来到 月光林，渴望与他们的同胞一起庆祝，无论他们来自哪里。我看到你还年轻，充满精神和雄心壮志;对于那些过着冒险生活的人来说，这是令人钦佩的品质。如果这是您寻求的挑战，那么农历新年就是最佳时机。这是一个挣扎的时刻，克服依旧依附在你灵魂上的重担，这样你就可以带着不受束缚的精神进入新的时代。$B$B在世界上冒险，潜入邪恶的巢穴，直面内心的疑虑。向我展示你的胜利信物，向我证明你是如何征服自我的，我会奖励你的努力。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41655) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41657, '在祖鲁希德的尸体上发现了一封破旧的信。这封信似乎是写给他的，字迹粗糙，内容如下：$B$B<所以你终于回来了？自从我们其他人为生存而拼命战斗以来，你消失去寻找你的神器已经多久了？你为了自己愚蠢的荣耀抛弃了龙喉氏族，现在，因为你已经回来了，你还指望所有的酋长们毫无悔意或仇恨地联合起来？$B$B不要指望我和其他祖鲁希德人一样愚蠢。你可以随心所欲地躲在格瑞姆巴托的地下。我会带领我们的氏族在冷酷海岸的土地上取得辉煌而伟大的胜利，而不是像雷德和他的同伙那样躲在洞穴里。我们中的一些人知道黑石的真相，并且不想将事实隐藏在看似辉煌的所谓“黑暗部落”的概念背后……你的订单被拒绝了，老朋友。$B$B科尔拉格·末日之歌，龙喉氏族。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41657) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41713, '你能想象比意识到自己永远不死更痛苦的事情吗？被束缚在这座被诅咒的塔上直到时间的尽头？我当然不能。我们注定要永远研究奥术的奥秘，我们中的许多人已经失去了理智。谁能责怪他们呢？人们会认为这是摆脱这种孤寂的简单方法。但我不是一个屈服于捷径的人。以我作为一名学者的骄傲，我将摆脱这座尖塔的魔法束缚，而你会帮助我。$B$B搜索图书馆。这座塔的疯狂主人有一本书名很引人注目，这是一本厚重的书，我需要你找到。“奥术共鸣的解决方案”，这就是我需要的。把它带给我，我们最终将能够摆脱这个永恒的枷锁。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41713) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41714, '从这里的情况来看，需要大量的奥术能量来打破将我们束缚在塔上的约束。只要有合适的材料组合，我就能创造出一种足够强大的能量源来打破我的永恒锁链。$B$B听着，我再次需要你的帮助。收集以下能量源并将它们带给我。我会念出咒语，希望能一劳永逸地解除束缚。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41714) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41732, '<一件完美且古老的遗物展现在你眼前。它包含着复杂而古老的机制，让你无法理解。这件物品看起来是经过精心设计和制作的。你应该找一个可能对这种物品熟悉的人。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41732) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41734, '<一件完美且古老的遗物展现在你眼前。它包含着复杂而古老的机制，让你无法理解。这件物品看起来是经过精心设计和制作的。你应该找一个可能对这种物品熟悉的人。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41734) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41752, '我这辈子都是个懦夫，并非母亲希望我成为的那种战士。伟大的落锤防御者们屹立不倒，毫不留情地对抗着我们的敌人，而我却选择了一条不同的道路。砍杀敌人或许光荣而令人满足，但看到敌人仅仅因为一滴毒药就痛苦地扭动着身躯，更令人着迷。我的族人中没有多少人有这种感觉，我也不能责怪他们，但我来这里并非是为了无用。只要我能为部落贡献一己之力，就没有人能阻止我效忠我的大酋长。$B$B在我寻找新的、更丰富的毒液的过程中，我偶然发现了一条非常有趣的信息。邪恶的古代兽人——龙喉氏族——在格瑞姆巴托地下的矿井中奴役了一群蜘蛛。他们运用黑暗魔法，将这些蜘蛛的力量提升到了深不可测的程度。这些蜘蛛体内一定蕴含着无与伦比的剧毒，所以把它们母蜘蛛的毒囊带给我吧。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41752) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41769, '毫无准备就驯服并骑乘暴掠龙是愚蠢之举。它们的皮毛渗出毒液，在皮肤上覆盖一层致命的外皮；只需轻轻一碰，就可能判处你的死刑。然而，如果你想踏上这条充满艰辛的征程，让强大的暴掠龙屈服于你的意志并非不可能。我可以向你展示我的族人驯服这些充满毒素的野兽的古老方法。$B$B去丛林寻找它们的巢穴。寻找一枚即将孵化的蛋，其他任何蛋都不足以完成我们的任务。成功后就回来找我。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41769) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41770, '虽然现在幼崽还很虚弱，但它是无害的。由于它的毒皮尚未发育，无论是它的撕咬还是它的皮都无法伤害你。花时间抚养幼崽，你的身体会自然地适应它体内不断增长的毒液。等它成年后，你就能有足够的坚韧去骑着它，而不会受到任何影响。$B$B去丛林里搜寻食物，把野兽的肉喂给它。每吃一顿，它的下巴、身体和心智都会成长和变化。把它的牙齿——它在成长过程中会脱落的牙齿——送给我，以证明你对养育它的承诺。只有这样，我才能教你如何骑乘暴掠龙。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41770) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41771, '安戈洛的远古野兽拥有一种奇特的肉。光是那股味道就足以让一些人感到不适，抽搐不止。然而，你的幼崽却吃不够。暴掠龙的后代发育迅速，因此需要大量的营养。通常情况下，它们会跟随母亲外出狩猎，但现在这项任务落在了你的身上。$B$B猎杀环形山的生物，让你的幼崽茁壮成长。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41771) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41772, '在遥远的西方，有一片遍布石柱的山谷，名为“恐惧小道”。在这些石柱之中，栖息着强大的剑龙，它们摧毁着附近的一切。它们比环形山的大部分生物都高大，这要归功于它们体内厚厚的腺体，这些腺体促进了它们的肌肉生长和力量。为了确保幼年暴掠龙能够得到良好的抚养，我们需要这些腺体。$B$B前往“恐惧小道”，猎杀剑龙。小心，它们比一般的野兽更加强壮。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41772) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41773, '漫步在安戈洛的丛林中，你一定不时感受到大地的轰鸣。远处传来恐怖的咆哮声，以及树木和树枝断裂的声音。强大的魔暴龙是安戈洛的顶级掠食者，它们无与伦比的力量无人能及。猎杀一只魔暴龙本身就是一项壮举，而击倒一只则展现了非凡的实力。它们强大的心脏肌肉将成为幼龙的绝佳营养来源。哦对了,看在命运女神份上,你最好多带点朋友再去。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41773) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41784, '嘿，你来了！你看起来像个勇敢的冒险家！我打赌你肯定需要一份能让你以创纪录的速度恢复食欲的零食……是啊是啊，我从你的表情就能看出来，你现在就想要！嗯，抱歉了，老兄，我的科赞水果蛋糕很稀有，需要进口。如果你想买我的商品，你得先付钱给我。$B$B一百枚金币怎么样？毕竟我的水果蛋糕只卖给有钱的客户，我可不愿意把这么稀有的东西送给一些卑微的乞丐。你拿到金币后再回来找我，好吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41784) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41785, '<你手中握着龙喉氏族酋长祖鲁希德曾经持有的闪闪发光的碎片。看着他毫无生气的尸体，你不禁想起他曾经用这件如今在你手中的圣物——恶魔之魂碎片——所取得的成就。这件传奇神器曾被耐克鲁斯·碎颅者用来奴役红龙军团的守护巨龙女王阿莱克丝塔萨。它依然充满着很久以前曾被赋予的力量，你正在思考该如何处理它。或许你能找到一位愿意与你谈谈这件危险的道具的红龙军团的成员。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41785) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41796, '你好，亲爱的$c。你听说过北风领的盛大骑士演武吗？当地的贵族正在举办一场骑士演武大会，并邀请了包括塞拉摩在内的众多人类国家参赛！普罗德摩尔女士挑选了几个我们的卫兵作为参赛者，我的宝贝孩子们也在其中！他们必须匆匆离开，我几乎没时间跟他们道别。对了，你是不是正好要去北风领？能不能麻烦你帮我把这些围巾送给我儿子鲍里斯？就算身在塞拉摩，作为他们的父亲，我也要支持他们，这算是我的本分。$B$B我听说你可以穿过暴风城港口再往北到达北风领。祝你好运！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41796) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41811, '<扎尔苏似乎心不在焉，仿佛正试图聆听遥远的事物。他的注意力从遥远的思绪中抽离出来，只是好奇地看着你。>$B$B我感觉到你来此是有目的的，你能听到它拖着沙子，从沙丘中升起的声音吗？是的……某种邪恶之物已经出现，某种污秽之物。我从祖尔法拉克深处感知到了它，它已经污染了塔纳利斯的沙丘！远古邪恶的存在激怒了众神，我毫不怀疑，这就是泽尔杰布的回归。$B$B他，在我们的世界尚且年轻时他就已经年迈，是法拉基最位高权重的军阀之一，拥有黑暗不腐和邪恶魔法的力量。如果这片土地想要和平，他的灵魂必须被终结。在祖尔法拉克深处找到他，并带上你最信任的盟友，你需要他们的帮助来击败泽尔杰布。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41811) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41815, '西北方向有一处海盗营地——纯粹意义上的“舱底鼠”。我猜他们来这里是为了洗劫城堡。可惜城堡里鬼魂出没，被恶魔和他们的主子撵得到处跑，对吧？$B$B总之，这对我们俩来说都意味着一个工作机会。我是一名工匠，一名商人——但最重要的是，我是一个科赞的地精！我永远不会放弃免费的商品。$B$B好吧，“免费”……你知道的——你得从他们冰冷的手中抢过来。但它仍然是免费的，对吧？那就行动吧。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41815) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41840, '<在那怪物留下的水坑中，你发现了一把严重受损的木剑。它很小，而且大部分表面都被泥浆的酸液腐蚀掉了。然而，你可以辨认出玩具剑柄上“提米爵士——”的字样。也许这足以让你知道它的主人是谁。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41840) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41841, '<你手中拿着破碎的血石吊坠，它是疯狂的古加尔的弟子伊加尔弗用来召唤可憎的眼魔墨苟斯来到艾泽拉斯的。与恶魔激战所造成的伤口仍然遍布你的全身。鲜血顺着你的手臂流到手掌上。突然，吊坠剧烈地摇晃起来，发出一声扭曲的尖叫，吸入了红色的液体。不久之后，鲜血消失了——吊坠开始搏动。$B$B你还记得在塔伦米尔协助一位被遗忘者典狱长找回类似的文物；黑暗女王希尔瓦娜斯·风行者的遗物。最好把她被偷走的饰品还给她。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41841) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41854, '你发现了一个装满笔记、文物和各种垃圾的宝箱。锁上写着“格罗丹·黑炉”这个名字。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41854) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41861, '我们看到我们的消息已经传到了你那里，$N。你的事迹传遍了很远的地方，甚至传到了翡翠梦境的青翠之地。你对玛洛恩的英勇事迹引起了人们的关注。他的同胞，荒野诸神，以及他的挚友伊瑟拉都欠你很多，因为你将他从梦魇的魔爪中拯救了出来。一旦他恢复形态，我们将获得另一个强大的盟友，对抗梦魇瘴气中的黑暗存在。$B$B我们的母亲伊瑟拉派我们前往神圣的月光林地，寻找唯一一个率先对抗梦魇的德鲁伊。作为对他在海加尔山和黎明森林中行动的奖励。我们会做到的。不过，首先要进行一个测试。我们知道你的能力——你的智慧、力量和毅力无人能及。再次向我们证明你的能力，我们将赋予你更多力量，以完成守卫者赋予你的祝福。$B$B我们不会退缩；准备好面对绿龙军团的力量吧！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41861) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41873, '<这本日记用破旧不堪的皮革装订。里面的大部分内容记录着一位辛勤劳作的矮人农夫的日常生活——天气预报、种植周期、牲畜记录。然而，在最后几页，字迹开始颤抖，线条变得飘忽不定……字迹也变得更暗了。>$B$B她让我留在这里，是的。她让我留下。$B$B镇长……他们想把她从我身边带走。$B$B不会离开，不会。我会保护她的安全。是的。$B$B听到了声音。哦，我听到了。$B$B他们让我留下。$B$B必须留下。$B$B会的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41873) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41883, '在祖鲁希德的尸体上发现了一封磨损的信。这封信似乎是写给他的，字迹粗糙：$B$B<这么说你终于回来了？自从我们其他人为了生存而拼死搏斗，你消失去追寻你的神器以来，已经过去了多久？你为了自己愚蠢的荣耀抛弃了龙喉氏族，现在，因为你回来了，你就指望所有的酋长们会毫无悔意和敌意地团结起来？$B$B别指望我会像其他祖鲁希德的人一样愚蠢。你想躲在格瑞姆巴托的地下世界里就躲吧。我会带领我们氏族在冷酷海岸的土地上取得辉煌而伟大的胜利，而不是像雷德之流那样躲在洞穴里。我们当中有些人知道黑石的真相，也不想用光荣的“黑暗部落”来掩盖真相……老朋友，你的命令被否决了。$B$B科尔拉格·末日之歌，龙喉氏族。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41883) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 80745, '中秋佳节来临，象征着团圆与美好的时光。作为庆祝活动的一部分，你被邀请参与放置花灯的仪式。这不仅仅是一个简单的任务，而是传递祝福和心意的美好时刻。在这个特别的夜晚，找到指定的河边，轻轻放下你的花灯，让它随着柔和的河流漂浮，象征着你对亲朋好友的美好愿望和祝福。每一盏花灯都承载着希望与祝福，随着水流而去，照亮黑夜，温暖每一个心灵。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 80745) x
                      WHERE x.`Details_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Details_loc4` = IF(`Details_loc4` REGEXP '[一-龥]', `Details_loc4`, VALUES(`Details_loc4`));

-- ---- Objectives_loc4（76 条）----
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 39977, '获得三种奢华的烟花，以及一些诺达纳尔草药茶给和谐之灵。他在藏宝海湾等待着。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 39977) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 39978, '在大海龟之灵前发射三种奢华烟花三遍。您可以在地下城中最强的生物上找到它们。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 39978) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 39979, '在大海龟之灵前发射三种奢华烟花三遍。您可以在地下城中最强的生物上找到它们。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 39979) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41316, '把这本书带给精通珠宝加工的人。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41316) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41333, '将这本宝石学的书籍带给这个领域古老的大师。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41333) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41334, '将这本宝石学的书籍带给这个领域古老的大师。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41334) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41335, '将这本宝石学的书籍带给这个领域古老的大师。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41335) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41337, '将这本宝石学的书籍带给这个领域古老的大师。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41337) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41352, '将这个金戒指带给暴风城码头的阿基巴德·厄尔威克。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41352) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41353, '调查魔法紫水晶的奥秘。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41353) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41519, '将《法杖精通》一书带给勇士岛的诺拉·汽视。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41519) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41522, '将《投掷精通》一书带给勇士岛的诺拉·汽视。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41522) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41525, '将《枪械精通》一书带给勇士岛的诺拉·汽视。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41525) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41528, '将《弩箭精通》一书带给勇士岛的诺拉·汽视。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41528) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41531, '将《弓箭精通》一书带给勇士岛的诺拉·汽视。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41531) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41534, '将《长柄精通》一书带给勇士岛的诺拉·汽视。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41534) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41537, '将《剑类精通》一书带给勇士岛的诺拉·汽视。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41537) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41540, '将《锤类精通》一书带给勇士岛的诺拉·汽视。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41540) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41543, '将《斧类精通》一书带给勇士岛的诺拉·汽视。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41543) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41546, '将《拳套精通》一书带给勇士岛的诺拉·汽视。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41546) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41549, '将《匕首精通》一书带给勇士岛的诺拉·汽视。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41549) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41553, '前往棘齿城并参加美酒节活动！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41553) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41554, '前往棘齿城并参加美酒节活动！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41554) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41555, '将一份剃刀烈酒样品带给棘齿城的哈尔托格·角牙。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41555) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41556, '带着六个元素火焰回到棘齿城的哈尔托格·角牙那里。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41556) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41557, '找一瓶血色甜酒并带回给棘齿城的哈尔托格·角牙。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41557) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41558, '棘齿城的哈尔托格·角牙需要十捆银色蛇麻草。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41558) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41559, '棘齿城的哈尔托格·角牙需要十五捆红色蛇麻草。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41559) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41560, '为棘齿城的哈尔托格·角牙收集十二份黑色蛇麻草。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41560) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41561, '为了完成角牙珍藏，将二十个洛恩塔姆地薯交给棘齿城的哈尔托格·角牙。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41561) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41562, '棘齿城的索尔登·雷酒需要十二捆黄色蛇麻草。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41562) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41563, '棘齿城的索尔登·雷酒需要十二捆希尔斯布莱德蛇麻草。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41563) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41564, '棘齿城的索尔登·雷酒需要十捆\'浓郁蛇麻草。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41564) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41565, '带着六个元素之水回到棘齿城找索尔登·雷酒。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41565) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41566, '带着十根金棘草回到拉特奇找索尔登·雷酒。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41566) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41567, '为棘齿城的索尔登·雷酒取回“雷酒金啤”计划。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41567) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41568, '找到神话中的蛇麻草兔，并为棘齿城的索尔登·雷酒获取金色蛇麻草。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41568) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41569, '在完全喝醉的状态下和部落与联盟的成员跳舞！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41569) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41570, '在完全喝醉的状态下和部落与联盟的成员跳舞！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41570) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41571, '在完全醉酒的状态下和部落与联盟的成员跳舞！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41571) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41572, '给皮特罗·帕拉维诺带来所需的物资，他在卡拉赞之塔等着。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41572) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41573, '给皮特罗·帕拉维诺带来所需的物资，他在卡拉赞之塔等着。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41573) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41574, '给皮特罗·帕拉维诺带来所需的物资，他在卡拉赞之塔等着。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41574) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41575, '给皮特罗·帕拉维诺带来所需的物资，他在卡拉赞之塔等着。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41575) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41576, '给皮特罗·帕拉维诺带来所需的物资，他在卡拉赞之塔等着。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41576) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41577, '把孟菲斯托斯之心交给一个强大到足以摧毁它的巫师。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41577) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41632, '交出您当前持有的套装部件来换取你需要的装备。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41632) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41633, '交出您当前持有的套装部件来换取你需要的装备。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41633) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41651, '把你找到的日志和设备带给查波·查皮布拉斯。他在冬泉谷永望镇等你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41651) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41652, '前往冬泉谷永望镇的永望广播公司。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41652) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41653, '在尘泥沼泽寻找智慧之灵。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41653) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41654, '将十份野猪尸体带给月光林地的虎凡·地弓。艾泽拉斯的任何野猪都适用于此任务' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41654) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41655, '从艾泽拉斯地下城中最强大的敌人那里取回春节代币，并交给丽珊卓·翔天。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41655) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41657, '把这封信带给冷酷海岸的某位掌权者。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41657) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41713, '把《奥术共鸣的解决方案》这本书交给拉尔文·伊冯。你可以在卡拉赞之塔的隐藏储藏室里找到他。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41713) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41714, '拉尔文·伊冯需要以下材料来施展法术，希望能够释放他。你可以在卡拉赞之塔的隐藏储藏室找到他。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41714) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41732, '找到一个可能了解你手中的遗物的人。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41732) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41734, '找到一个可能了解你手中的遗物的人。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41734) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41752, '在龙喉居所击杀穴织女王，并将她的毒囊交给落锤镇的奥库尔。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41752) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41769, '将一颗即将孵化的暴掠龙蛋交给安戈洛环形山东面入口的贾马纳利。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41769) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41770, '在安戈洛环形山的东南入口处为贾马纳利收集足够的暴掠龙牙齿。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41770) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41771, '收集安戈洛低等野兽的肉，并将其带给环形山东南入口处的贾马纳利。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41771) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41772, '收集剑龙腺体，并将其带给安戈洛环形山东南入口处的贾马纳利。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41772) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41773, '将魔暴龙之心交给安戈洛环形山东南入口处的贾马纳利。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41773) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41784, '向尼兹尔支付100金币，好奢侈的买下他的水果蛋糕。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41784) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41785, '在湿地中寻找一条愿意倾听你的话的红龙。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41785) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41796, '将法温德的围巾交给北风领演武场的鲍里斯·法温德。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41796) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41811, '前往祖尔法拉克，击杀年迈的泽尔杰布，然后回到祖尔法拉克南部的流浪者扎尔苏身边。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41811) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41815, '从舱底鼠营地的海盗那里收集20件舱底鼠武器，并将其交给碎风哨站的格雷克斯。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41815) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41840, '把这把木制玩具剑交给认识它主人的人。你可能会在北风领——这一切的起源地——碰碰运气。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41840) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41841, '把血石吊坠交给幽暗城的希尔瓦娜斯·风行者女士。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41841) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41854, '把宝藏带给格罗丹·黑炉。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41854) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41861, '接受雷瑟维斯给你的挑战！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41861) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41873, '在丹基塔斯寻找任何对这本日志感兴趣的人。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41873) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41883, '将信交给冷酷海岸的一位高级官员。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41883) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 80745, '前往河岸，（在角色处于游泳状态时）将花灯放入水中。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 80745) x
                      WHERE x.`Objectives_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Objectives_loc4` = IF(`Objectives_loc4` REGEXP '[一-龥]', `Objectives_loc4`, VALUES(`Objectives_loc4`));

