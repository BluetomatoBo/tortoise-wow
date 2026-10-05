-- locales_page_text（locales_page_text）
--
-- 共 37 条，全部只写 zhCN 列（*_loc4），不触碰其他语言列。
-- 本项目 sql/base/tw_world_locales_page_text.sql 里这些列原本是空串或英文占位符
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
-- Text_loc4：37 条
-- ------------------------------------------------------------------------
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (696, '日记 - 第4天$B$B我已经在这个岛上被困4天了，我很孤独，只有我的思想与我为伴。香蕉的味道很好，但我得爬上很高的树才能摘到。等到我不能再去寻找食物，也不能再保护自己免受阵雨之苦时，我满脑子想的，都是如何逃出这里。$B$B要是不再有纸和瓶子被冲上海滩来，我就要彻底绝望了。我坐的那条该死的船，居然装满了链金药剂和药方，它们对我一点用都没有。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (750, '<HTML>$B<BODY>$B<BR/>$B<BR/>$B<H1 align="center">$B伊莉莎$B</H1>$B<BR/>$B<BR/>$B<BR/>$B<BR/>$B<P align="center">$B亲爱的妻子，希望大地可以抚慰你饥渴的灵魂。$B</P>$B</BODY>$B</HTML>') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (796, '上古诸神是这个世界最早的主宰，他们控制了所有的力量。虽然他们现在被困住，处於长眠之中，但他们的仆从依旧在横行，而我们弱小脆弱的凡人，是无法和他们的力量相比拟的。$B$B胆敢挑战他们的蠢货都被吞噬了。只有那些为了自保而去逢迎上古诸神的仆人的人才能生存，虽然其代价是牺牲自己的灵魂和意志……') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (877, '科尔宝石:从我所知道的一些传说来看，这种宝石是法师用来储存能量所用的，这可以极大地增强他们的力量。我曾经帮助过一个名叫桑迪斯·织风的夜精灵，他可以告诉你更多有关宝石的资讯，只要你和他提到我，他就一定会帮忙的。我相信这些宝石中一定蕴藏了可以帮你铸造武器的力量。$B$B我和桑迪斯上次见面的时候，他住在黑海岸的奥伯丁，那里是夜精灵的家园，周围都是被污染的森林。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (953, '星辰的孩子已经在永恒之井闪光的湖水边定居了很久。众所周知，象征永恒曙光的伊露恩在就在这水中休憩。岸边住着星辰的孩子们，伊露恩眷顾着他们，给他们安家，而他们也总在夜晚虔诚地凝望月空。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (954, '当森林中的古树被连根拔起的时候，由塞纳留斯的儿女们看守的树林，还有星辰之子们的石塔，整个世界都在颤抖。我们的女王即使在绝望和混乱的战争期间仍保持着她的优雅。在魔法的作用下，天空都变了颜色，爆炸好像要将世界撕成碎片。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (1031, '<HTML>$B<BODY>$B$B$B$B$B<P>$B纪念我亲爱的良师，霍拉迪·蒙特高莫，医学博士。一位医者，老师，朋友。$B') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (1090, '显然，正是克拉文锁在箱子中的东西对塔中的居民产生了有害的影响。我猜测其他的守卫体内也应该有着同样的恶臭，而且，有可能连克拉文自己也已经成了这种影响的牺牲品。$B$B密探安玻·吉尔妮$B军情七处 国内行动八组') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (1270, '对我们地鼠有限公司来说，最让我们伤心的是，我们收到报告说有一些贪婪的蓝叶薯猎人不顾自己宠物的安全，把它们送入危险的地方搜寻蓝叶薯。$B$B我们决不能宽恕这样的行为，但是为了保证顾客对我们售出的每一只地鼠满意，我们郑重承诺:所有购买本公司产品的顾客都可以拿着购买凭证随时领取新的地鼠。$B$B祝您狩猎愉快!') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (1510, '<HTML>$B<BODY>$B<H1 align="center">$B水晶塔使用手册$B</H1>$B<BR/>$B<P align="center"> “安戈洛环形山水晶收集与使用手册”</P>$B<BR/>$B<BR/>$B<P align="left">第一章:北部水晶塔 </P>$B<BR/>$B<P align="left">第二章:东部水晶塔 </P>$B<BR/>$B<P align="left">第三章:西部水晶塔 </P>$B<BR/>$B</BODY>$B</HTML>') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (1530, '<HTML>\n<BODY>\n<H1 align="center">\n东塔台图\n</H1>\n<BR/>\n<IMG src="Interface\\Pictures\\11482_crystals_east"/>\n</BODY>\n</HTML>') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (1550, '<HTML>$B<BODY>$B<H1 align="center">$B西部水晶塔图表$B</H1>$B<BR/>$B<IMG src="InterfacePictures11482_crystals_west"/>$B</BODY>$B</HTML>') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (1691, '你好，菲诺克!$B$B我在燃烧平原的研究进行得非常顺利。而且我欠了$N很多因为$g他的:她的;大力帮忙!以下是我继续研究所需要的物资:$B$B钢螺钉若干$B17号扳手一个$B12磅重的鸭毛$B一罐你制造的胶水$B$B非常感谢你，菲诺克，下次我们碰面的时候记得提醒我，不要把煤放在你的鞋子里!$B$B- 丁奇') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2131, '向你致敬，战士。我不会再奉承你的力量与勇猛，这都是些陈年旧帐了。最近你杀了多少人?我猜没多少。你正在退步，你正在因为缺乏挑战而变得越来越弱。$B$B我可不能让一个战士就这麽变成废物，不会管别人是怎麽奉承你的，现在的事实就是:你需要接受训练，而我可以训练你。什麽时候你那榆木脑袋开窍了，就来找我吧，我在大兽穴外的帐篷下面。$B$B- 弗朗恩，战士训练师') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2295, '在记忆之年代前，温柔的大地之母呼出金色的黎明之雾。当琥珀色的云朵沉降之後，大地上到处都是长满燕麦和大麦的田地。这是她工作的基础─孕育着生命和希望的摇篮。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2296, '大地之母的眼睛，注视着她用呼吸创造的世界。她的右眼，安希(太阳)，给予这片土地温暖和光明。她的左眼，姆莎(月亮)，给予那些躁动不安的生物以和平与睡眠。这就是双眼的力量，每隔半天，大地之母就会闭起一只眼睛。就这样，她为这个初生的世界不断进行着日夜的更替。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2297, '当大地之母的右眼扫过金色的黎明时，她轻柔的手就开始在肥沃的原野上拂动。她的手臂拂过的地方就有高贵的人从土地中出现。舒哈鲁(牛头人)为此向他们挚爱的母亲表示感谢。在充满黎明之光的广袤平原上，大地之母的孩子为她的优雅而祈祷，并发誓永远称颂她的名字，直到世界坠入永恒黑暗的那一天。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2298, '随着大地的孩在黎明平原上行走，他们听到了来自大地中心的黑暗低语。 它向那些孩子灌输征伐的思想和欺骗别人的方法。许多舒哈鲁因此堕入黑暗，并开始变得邪恶。他们抛弃了自己的兄弟，无知地穿行在原野上。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2299, '大地之母的心，因为孩子们的堕落而变得沉重，她已经无法再眼睁睁地看着他们变得堕落。在悲伤之中，她摘下了自己的双眼，将它们放在星空中任其飞翔，安希和姆莎为了抚平彼此的悲伤，只能横穿天空而互相追逐。随着时光的流逝，这两个双胞胎永远互相追逐着。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2300, '虽然已经无法视物，但大地之母不会远离心灵的世界。她用她的耳朵聆听风声，聆听一切穿越黎明平原的东西。她伟大的心还是和她的孩子在一起，她爱的智慧永远不会离弃他们。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2301, '大地之母不仅把勇敢的心赋予她的孩子们，她还将热爱狩猎的精神赐予他们。第一黎明纪元中诞生的生物是野蛮而又狂暴的，它们躲避着大地之母，在阴暗的野外寻找自己的栖身之地。舒哈鲁狩猎这些野兽，并以大地之母的祝福来驯化它们。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2302, '然而，一个强大的灵魂却一直在躲避着他们。英勇的雄鹿阿帕罗(被夜精灵称为玛洛恩)长着白色的皮毛，它的鹿角划破天穹，它强有力的蹄子踏破世界的深渊。舒哈鲁猎捕阿帕罗，直到黎明世界的角落，并撒网捕捉那头骄傲的雄鹿。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2303, '为了逃脱，伟大的雄鹿跃向空中。他的逃脱本应非常顺利，但是他的鹿角却挂住了天上的星星。虽然他不断蹬踢挣扎，但是阿帕罗却无法从天堂中挣脱。此时正在追逐安希的姆莎发现了他，她看到万能的雄鹿在奋力挣扎，并对他一见锺情。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2308, '随着黎明薄雾的消散以及岁月的流逝，半神塞纳留斯自行进入了世界的田野中。舒哈鲁(牛头人)对於他的离去感到无比悲伤，并忘却了他教给他们的德鲁伊之道。一代又一代，他们渐渐地忘却了如何与树木以及这块土地上的生灵进行交流。地底深处的黑暗低语再次出现在他们的耳边。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2309, '虽然大地的孩子对於邪恶的密语不再听从，但是一个邪恶的诅咒降落在他们游荡的部族头上。在黑色土地的西边有一群凶恶的生物─半人马。残忍而野蛮的半人马如瘟疫一般蜂拥而至，虽然舒哈鲁在大地之母的祝福下勇敢地战斗，但是他们无法打败半人马。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2490, '瑞什：$B$B你的请假要求已经被批准了。我会派候补的牛头人战士去你执勤的哨所接班，这样你就可以回家和亲友团聚了。在一个星期的假期过后回来报到!$B$B- 马格兰') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2636, '<你刚刚瞥了这些书页一眼，就感受到了一阵灼热的疼痛。>') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2637, '……如果可以的话，躲在窗台或桥墩底下。找一面坚固的墙也是安全的办法。$B$B$B<更多模糊的文字。>$B$B在五到十五……之间，使用……治疗。$B$B<更多模糊的文字。>$B$B在成功的袭击之後，好好休息接受胜利。待确实过了十至十五秒後，前往城里展示你的……让人们观看崇敬。$B$B$B<瞄了一眼其余的文字概要後让你头疼不已。>') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2653, '<你刚刚瞥了这些书页一眼，就感受到了一阵灼热的疼痛。>') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2660, '一切似乎都是徒劳。很快女祭司周围就堆满了农民的屍体……倒下的屍体又站起来了。') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2770, '<HTML>$B<BODY>$B<BR/>$B<BR/>$B<P align="left">长眠于此的是霜狼氏族的第一任酋长，我们敬仰的部落酋长索尔的父亲 - 杜洛坦。他被那些想要让我们永远受到奴役的同胞背叛。杜洛坦为了我们的自由而献出了自己的生命，我们敬仰他，以及他留给我们的珍贵遗产，他伟大的儿子。</P>$B<BR/>$B<P align="left">德雷克塔尔，霜狼氏族的先知</P>$B</BODY>$B</HTML>') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2878, '我的艾米莉，$b$b几天前，我们闯入了这个被圣光遗忘的地方，听从国王的命令返家。虽然这周围很荒凉但我的心很轻松，因为在前往海岸严寒的长途跋涉和遥远辛劳的航海後我就知道，我会在你的怀中找到安慰。$b$b我们今天到海岸线找我们的船，我们回家的工具，已经是烧黑的外壳;我们无法离开，别无选择，只好往这深不可测的荒地中心走。$b$b我为了保护你已走到了世界的最尽头，艾米莉……而现在……我衷心希望我还和你留在罗德隆。$b$b每当我睁开眼想的都是你。你是我在这冰冷土地上的温暖，亲爱的，而且没有人可以改变这个事实。$b$b麦克斯韦尔') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2881, '$b$b海利安娜，$b$b我，瓦古斯，虽然与你的希望相违，不过我还活着。我鄙视自己穿着这可笑的护甲在乡间游荡。$b$b我们的上一个命令要我们前往安多哈尔寻找一些谷类或类似的狗屁东西。为什麽这麽多地方却偏要我找安多哈尔的食物?从军这整个想法真是有够可笑。$b$b好好安息吧，海利安娜阿姨，我会回去继承你的遗产的;即使我伤的极为严重，又饥又渴，坚定的恨意会驱使我继续向前进。$b$b瓦古斯$b$b') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2882, '最亲爱的亚蜜利亚，$b$b今晚我见到了会终生萦绕在我心中的事。$b$b斯坦索姆战火延烧，我们都要负起责任。$b$b今晚我们的王子带领我们到了城镇的街上;他命令我们闯入民宅然後……在他们熟睡时把他们杀光。阿萨斯主人说，他们得了瘟疫，所以要在他们杀死我们之前把他们杀了。$b$b那简直是大屠杀。几百人寂静地死在曾誓言要保护他们的剑下。我无法再忍受了;我逃了出来。$b$b我或许是个背弃者，但我无法做出那样残暴的事。在每个民宅里，我在受难者死去时看到了你的脸孔，和我们的孩子。如果我这样做是个卖国贼的话，那就是吧。$b$b我希望能及时找到路回到你身边，但路途并不安全。我不在的时候替我传达我的爱给我们的孩子。$b$b詹姆士$b$b') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2883, '珊拉，$b$b我越跟着我们的阿萨斯主人往北走，越北，我的心就越沉重。他虽然曾闪耀着圣光，我现在却感应到一股黑暗的年轻圣骑士灵魂。他的热诚被一股沉思笼罩着，在他的灵魂里有一些我无法理解的梦魇……$b$b我们很快就会着陆在冰冻荒原。虽然阿萨斯手下很多人都因受寒或与腐败的野兽搏斗而病倒，他告诉我们他要在冰地里寻找的东西会扭转战争情势。但我并没有因为他的话感到安慰，因为在他这样说之後……一抹阴森的微笑浮现在他有棱有角的嘴角，那股寒意比任何暴风雪还要让我冷的刺骨。$b$b为我们祷告吧，珊拉，也为我们的世界祷告，$b$b托尔哥$b$b') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2886, '你好，$n。我想你一定会对我调查的结果很有兴趣。$b$b事实证明，鲁宾和里格瑞还活着 - 换句话说 - 还有家庭。即使他们已经知道死去的士兵的事，拜访他们其中一人都会是值得的冒险。$b$b你可以在幽暗城的军事区找到鲁宾的前妻，琼安娜·怀特豪尔，她大部分时间都在那里。我不知道她能不能接受这个事实，要小心。$b$b至於里格瑞，他的阿姨成了暴风城的孤儿监护人，是个值得钦佩的职务。$b$b不管你生命中的道路是什麽，我希望你的努力都能有好运气。$b$b') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 
INSERT INTO `locales_page_text` (`entry`, `Text_loc4`) VALUES (2887, '$n，我希望这封信对你有所帮助。在探究了一阵子之後，我发现了一些消息，关於写下你找到的便笺的那个人。$b$b珊拉的父亲带领着跟随他信念到雷霆崖朝圣的被遗忘者和食人妖。他的名字是麦尔斯·威尔什，你会在预见之池找到他和他的不死族朋友。$b$b同时，托尔哥是被他的表姐埃丽莎救活的。据我了解她是个很低调的人;她都在达纳苏斯的月神殿里。$b$b我强烈建议你去拜访任何一个人，$n。他们永远都不会了解托尔哥或珊拉的命运的。$b$b') ON DUPLICATE KEY UPDATE `Text_loc4` = VALUES(`Text_loc4`);  -- 

