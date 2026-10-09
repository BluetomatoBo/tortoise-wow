-- 任务文本补译（locales_quest）—— 游戏中仍可接取、且仍是英文的任务
--
-- 与 locales_quest.sql 的区别：那份是「按来源能补的」，这份是「玩家真能碰到的」。
-- 筛选条件（可在库里复现）：
--   1. 该任务在 creature_questrelation / gameobject_questrelation 里有给予者，
--      且该给予者在 creature / gameobject 表里真有 spawn 记录（即玩家能见到、能接）；
--   2. 对应列的英文非空，而 locales_quest 的 *_loc4 列为空或整行不存在。
-- 只写 *_loc4 列；已有中文的行一律不动（ON DUPLICATE KEY UPDATE 只改这一列）。
--
-- 本轮：Title_loc4，共 175 条。
--
-- 译文来源与标准（与之前的人工翻译一致）：
--   * 官方既成译名优先，直接沿用库内已有中文：卫葛斯（Mr. Wiggles）、布莱特考坡弗
--     （Father Brightcopf）、永望镇（Everlook）、海加尔山（Mount Hyjal）、
--     提瑞斯法（Tirisfal）、德莱尼水晶（Draenethyst）、伊露恩（Elune）、
--     风暴掠夺者（Stormreaver）、制奴者（Slavemaker）、裂隙行者（Riftwalker）。
--   * 自定义专名库内没有中文的，按音译/意译拟定并保持全篇统一，例如：
--     巴洛（Balor）、博瓦凯兹（Bovarkez）、多萨斯/约尔瑟格/达格诺斯等兽人地名、
--     云蹄（Cloudhoof）、雨角（Rainhorn）、月蹄（Moonhoof）、蛾幕（Mothshroud）、
--     月语海岸（Moonwhisper Coast）、伊露纳兰（Elun’aran）、安舍（An’she）。
--   * 保留原文语气：双关（Its All Ogre Now）、台词体（Theyre Eating It!）、
--     名句（I Am Become Death…）都按中文语感处理，不做逐字硬译。
--   * 不添加英文里没有的数字或符号；破折号、省略号与原文一致。
--
-- 生效方式：导入后执行 `.reload locales_quest`（不需要重启；已开着的任务窗口需重开一次）。
--
-- 导入：mysql tw_world < locales_quest_extra.sql

SET NAMES utf8mb4;

INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (39980, '诛杀无义者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Slay the Dishonorable
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (39981, '诛杀荣耀者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Slay the Honorable
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41283, '饰品教人情更深') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Trinkets Make The Heart Grow Fonder
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41284, '该给它戴上戒指了') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- You Should Put A Ring On It
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41297, '找寻追寻者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Seeking Seekers
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41299, '库米沙的谢意') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Gratitude Of Kumisha
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41300, '好言相求便是') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Just Ask Them Nicely
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41302, '谈成的休战') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Negotiated Truce
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41306, '如今全是食人魔') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Its All Ogre Now
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41307, '他们在吃它！') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Theyre Eating It!
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41308, '腥腻的勾当') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Fishy Practices
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41311, '博瓦克兹') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Bovarkez
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41323, '裂隙行者的手杖') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Riftwalkers Cane
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41326, '避难所的命运') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Fate Of The Harborage
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41327, '显形的异象') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Manifested Oddities
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41328, '一个不情之请') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- A Favor Asked
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41329, '一醉方休·淡朗姆') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- To Rum it All - Light
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41330, '一醉方休·黑朗姆') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- To Rum it All - Dark
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41331, '一醉方休·黑标') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- To Rum it All - Black Label
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41332, '一醉方休·烈性') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- To Rum it All - Volatile
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41336, '看不见的障碍') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- An Unseen Obstacle
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41338, '海加尔山陷入动荡') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Mount Hyjal In Turmoil
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41343, '我不是老鼠') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- I Am No Rat
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41354, '月之拥抱') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Embraced by the Moon
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41358, '日出时分醒来') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Awoke at Sun Rise
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41365, '驰援布莱特考坡弗') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- To Aid Brightcopf
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41366, '主教已迟') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Too Late to Prelate
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41370, '提瑞斯法的残迹') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Tirisfals Vestige
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41372, '开启的路径') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- A Pathway Opened
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41374, '厨师之间无信义') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- No Honor Among Chefs
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41375, '魔法树木研究') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- A Study of Magical Trees
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41381, '野狼、老妪与长镰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Wolf, the Crone and the Scythe
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41383, '乌尔的教诲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Wisdom of Ur
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41384, '普里科利希·怒月') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Pricolich Gnarlmoon
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41386, '普里科利希·狼人') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Pricolich Lycan
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41392, '关掉龙头') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Turning Off The Tap
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41541, '断指者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Fingerbreaker
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41552, '重新的教诲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Renewed Teachings
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41634, '马吉勒斯的魔法事故') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Magilous Magical Mishap
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41636, '谁来替孩子们着想？') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Who Will Think Of The Children?
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41638, '感恩的亡者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Grateful Dead
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41639, '森林已变') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Woods Have Changed
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41642, '孤独的阿诺德') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Lonesome Arnold
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41643, '空屋') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Empty Houses
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41644, '逆势而为') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Defying Odds
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41645, '制奴者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Slavemakers
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41647, '非常手段') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Unconventional Means
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41648, '死帽菇与寡妇褶边') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Deathcap And Widows Frill
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41649, '永望镇广播劫持案') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Everlook Broadcast Hijacking
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41650, '惊涛拍岸，雷声刺耳') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Crashing Waves, Screeching Thunder
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41662, '绿叶的恩赐') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Leafs Bounty
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41663, '比武骑士之间') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Among the Jousters
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41666, '琥珀釉甜甜圈') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Amberglaze Donuts
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41668, '礼品袋') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Goody Bag
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41669, '配得上王子！') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Fit for a Prince!
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41670, '照亮来世') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- To Light the Afterlife
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41676, '边境上的兽人') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Orcs by Our Borders
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41677, '比铁更暗') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Darker than Iron
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41680, '卫葛斯在哪？') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Where is Wiggles?
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41681, '卫葛斯识途') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Wiggles Knows the Way
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41682, '卑劣的矮人猪') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Vile Dwarven Pigs
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41683, '渣滓就该待在渣滓里') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Scum Should Stay Scum
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41687, '舍伍德采石场的苦难') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Misery At Sherwood Quarry
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41690, '还是不够') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Still Not Enough
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41691, '有人会说这是骗术') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Some May Call It Quackery
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41692, '评估局势') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Assessing The Situation
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41694, '深入至暗之地') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- To The Darkest Places
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41696, '你大可以称之为作弊……') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- You May Call This Cheating...
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41698, '炸药令我心跳砰然！') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Explosives Make My Heart Go BOOM!
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41700, '黄金体验') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Gold Experience
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41701, '地精式的钓鱼法') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Goblin Way Of Fishing
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41704, '让他们安息') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Put Them To Rest
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41705, '可怜的瓷娃娃') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Poor Porcelain Doll
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41708, '刺痛的摇篮曲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Stinging Lullaby
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41709, '无尽的风暴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Ceaseless Storms
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41710, '大局中的一角') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Piece Of A Bigger Picture
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41719, '格什甘必须死') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Death to Geshgan
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41724, '雷斯卡格的背叛') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Betrayal of Rethkag
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41726, '打捞残骸') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Scavenging the Wrecks
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41733, '重铸圣物') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Rebuilding the Relic
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41736, '危难之地') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- A Land in Peril
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41737, '腐化的征兆') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Signs of Corruption
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41739, '达格诺斯之焰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Flame of Dagnoth
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41740, '多萨斯的契约') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Deed for Dorthas
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41741, '回到约尔瑟格') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Return to Yorthegg
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41742, '驱除邪恶') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Expelling Evil
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41746, '奥术散发') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Arcane Emanations
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41761, '直捣蜂巢') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Into The Hornets Nest
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41775, '被遗忘的仪式') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Forgotten Practices
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41783, '被遗忘的故事') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Forgotten Stories
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41786, '来自海上的疑云') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Suspicions From Sea
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41792, '给莫尔坎的猪') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Hog For Morkan
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41798, '我亲爱的妻子') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- My Darling Wife
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41799, '水占师的好奇心') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- A Hydromancers Curiosity
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41805, '沐浴龙火') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Bathed in Dragonfire
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41806, '龙火炸弹！') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Dragonfire Bombs!
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41807, '我即死亡……') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- I Am Become Death...
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41809, '龙火的气味') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Smell of Dragonfire
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41813, '巴洛自酿月光酒') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Balors Own Moonshine
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41814, '已故的巴洛公爵') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Late Duke Balor
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41817, '恐惧是你的对手') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Fear is Your Rival
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41818, '我们生而不平等') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- We are not Born Equal
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41820, '致我的父亲，沃金') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- To My Father, Voljin
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41822, '惨淡的阳光') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Grim Sunlight
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41825, '主母会知道的') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Matron Will Know
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41826, '留下来的人') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Those That Remain
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41831, '不过一念') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Mere Thoughts
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41832, '蚁群') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Colony of Ants
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41834, '风暴之终') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Storms End
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41835, '管它是不是军团，我来了') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Legion or Not, Here I Come
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41837, '风暴、暮光与战锤') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Storm, Twilight and Hammer
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41844, '死人不会抱怨') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Dead Can’t Complain
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41847, '敬奉旧日同盟') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Honoring Old Alliances
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41853, '格罗尔丹的怨念') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Groldans Grudge
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41855, '夺回萨尔加拉兹') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Reclaiming SalGalaz
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41856, '夺回萨尔加拉兹') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Reclaiming SalGalaz
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41858, '屠夫加吉尔') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Gargill the Butcher
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41874, '失落的档案') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Lost Archives
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41875, '修补巴戈斯之墙') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Repairing Baggoths Wall
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41885, '水中的噬咬者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Chompers in the Water
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41912, '凶兆') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- An Ill Omen
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41914, '赤装蹄角') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Hooves and Horns, Clad in Red
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41915, '父亲的答案') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Answers from Father
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41917, '学生的决心') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- A Students Determination
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41939, '沃塔卢斯的敕令') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Vortalus’ Edict
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41945, '敬重长者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Respect the Elderly
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41947, '通缉：无情者塔玛安') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Wanted: Tama’an the Ruthless
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41948, '通缉：咆哮之爪') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Wanted: Growlpaw
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41949, '盟友的号角') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Horns of their Allies
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41951, '商人的见识') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Merchant’s Knowledge
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41960, '善有善报') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- One Good Turn Deserves Another
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41962, '范戈恩，永恒之主') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Fangorn, Lord of Eternity
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41966, '佩罗萨恩，梦魇先驱') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Peroth’arn, Nightmare’s Herald
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41968, '配得上云蹄') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Worthy of Cloudhoof
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41973, '月语海岸的契约') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Contracts in Moonwhisper Coast
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41981, '给凯恩的情报') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Information for Cairne
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41983, '伟大的伊卡库鲁克') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Great Iqa’quluk
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41984, '为假期补货') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Restocking for Vacation
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41985, '别告诉其他人') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Don’t tell the Others
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41986, '奥格索布的求知欲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Oglethorbe’s Scientific Hunger
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41988, '可怕的忧虑') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Dreadful Worries
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41989, '蜿蜒的蛇群') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Slithering Snakes
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41992, '最小的孩子，总是垫底') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Youngest Sibling, Always Last
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41996, '海妖之歌') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Siren’s Song
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42001, '是什么搅扰了元素？') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- What Upsets the Elements?
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42008, '最好的毛皮') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Finest Pelt
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42010, '失去力量的符文石') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Powerless Runestone
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42011, '德莱尼水晶收藏者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Collectors of Draenethyst
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42018, '献给主母的礼物') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Gifting the Matron
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42020, '兄弟的责任') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Brother’s Duty
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42030, '盗窃与勒索') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Larceny and Extortion
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42036, '万年的秘密') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Secrets of Ten Thousand Years
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42039, '酋长乌布卡兹') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Chieftain Ubukaz
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42042, '误入歧途') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Led Astray
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42043, '迟来的保存') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Belated Preservation
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42048, '雨角的挫败') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Rainhorn’s Frustration
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42050, '水中方见清明') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- In Water, Clarity
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42065, '让倒下者倒下') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Falling the Fallen
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42066, '玛拉斯希尔的幽魂') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Ghosts of Maras’ethil
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42067, '天塌地陷') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Heaven Falling Down
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42068, '出错的远征') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Expedition Gone Wrong
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42070, '代代相传') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- One Heir to Another
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42071, '父亲会听的') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Father Will Listen
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42073, '面见长者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Facing the Elder
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42077, '蛾幕瀑布') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Mothshroud Falls
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42078, '月蹄安息') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Moonhoof Rests
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42080, '月舞还活着吗？') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Moondancer Lives?
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42081, '恰逢其时的到访') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- An Opportune Arrival
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42085, '月蹄庆典') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Moonhoof Celebration
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42088, '安舍的休憩') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- An’she’s Respite
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42090, '无头之蛇') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Serpents Without Heads
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42092, '回应的星辰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- A Star That Calls Back
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42094, '飞蛾的异端') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Moth’s Heresy
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42095, '树妖的忠告') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- A Dryad’s Counsel
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42096, '伊露纳兰的腐烂') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- The Rot of Elun’aran

-- ---- 补充：早前工作清单漏算的杜隆塔尔劳工联盟任务链（标题，7 条）----
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41763, '精巧的画作') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Intricate Artwork
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41764, '石油味的牢骚') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Oil-Based Grievances
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41766, '尖鳍提前退休') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);  -- Shrillflukes Early Retirement
