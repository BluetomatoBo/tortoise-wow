-- 乌龟服新任务的中文（第二阶段：人工翻译）
--
-- 同上：只写库里还没有中文的条目，带「已有汉字不覆盖」保护。
--
-- 158 条。生效：mangosd 控制台 `.reload locales_quest`

SET NAMES utf8mb4;

-- ---- Title_loc4（3 条）----
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 41928, '地穴领主的召唤' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 41928) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 42009, 'Loktanag the Pure' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 42009) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));
INSERT INTO `locales_quest` (`entry`, `Title_loc4`)
  SELECT 42100, '追思纪念日' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Title_loc4` FROM `locales_quest` WHERE `entry` = 42100) x
                      WHERE x.`Title_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `Title_loc4` = IF(`Title_loc4` REGEXP '[一-龥]', `Title_loc4`, VALUES(`Title_loc4`));

-- ---- Details_loc4（12 条）----
INSERT INTO `locales_quest` (`entry`, `Details_loc4`)
  SELECT 41928, '<地穴领主倒在你脚边，死透了。这从诺森德冰层深处爬出来的恶魔再也不能在生者之间散播恐惧。可你手里握着的东西，却让你这老练的冒险者本能地感到不安。石板触手冰寒，里面还能听见隐约的低语。单凭你一个人的力量打不碎它，也驱不散那股邪恶气息。也许一位强大的圣光使用者能在这种时候帮上你。>' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 41928) x
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
  SELECT 42056, '来，让我们试试你学到的东西。从这里往南，穿过战士们训练的图腾环，在树影与枝叶下，你会找到 勇士绿角。他受了伤，身形高大，却还守着被风险投资公司霸占的冰蹄水井。$B$B他接到的命令只是观察，可他没弄明白，反而做了相反的事——跟风险投资公司动了手，好不容易才捡回一条命。你的任务是找到他、治好他，用韧强化他的意志，让他想起自己还有可以依靠的同伴，好让他回到村里召集人手，面对眼前的敌人。$B$B办成这件事，等你回来我们就谈谈 穆莎。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Details_loc4` FROM `locales_quest` WHERE `entry` = 42056) x
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

-- ---- Objectives_loc4（12 条）----
INSERT INTO `locales_quest` (`entry`, `Objectives_loc4`)
  SELECT 41928, '把地穴领主的召唤交给一位强大的圣光使用者。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 41928) x
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
  SELECT 42056, '找到 勇士绿角，用次级治疗术（等级 2）治好他的伤，然后为他施加真言术：韧，再回到莫高雷血蹄村的 帕尔甘星行者 那里。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `Objectives_loc4` FROM `locales_quest` WHERE `entry` = 42056) x
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

-- ---- OfferRewardText_loc4（6 条）----
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41577, '你可以从这些奖励中选择一件：Felforged Nathrezan Veil、Felforged Nathrezan Circlet、Felforged Nathrezan Aureole' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41577) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41940, '你可以从以下奖励中选择一件：优质治疗药水、强效法力药水' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41940) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42005, '你将获得：Thilphoral，Aln的预兆' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42005) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42056, '你会获得：Celestial Garments' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42056) x
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

-- ---- RequestItemsText_loc4（115 条）----
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41304, '，你到哪儿去了？我的珠宝找到了吗？你把Grizzby留在哪儿了？完成 噢，那些背后捅刀、啃痂皮的穴居怪！离开风险投资公司是Nert这辈子做过最正确的决定，我早就受够他们那些见不得人的手段了。我不仅丢了所有珍贵的珠宝，还失去了最好的承包商，要找个替代的人得花上好久！噢，Grizzby，你这老混蛋，你本该有更好的下场，好得多……获得 完成任务后，可获得：2300经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41304) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41340, '！大德鲁伊梦风告诉了我海加尔山发生的事。梦境碎片你带在身上了吗？完成 干得好，。看到你这么迅速就完成了任务，我就更不必担心接下来要请你做的事了。你或许不知道，我和我的同胞都是玛洛恩的后裔。正是他与月神伊露恩的结合，孕育了我们的父神塞纳留斯——而他又创造了我们。这件事不仅关乎海加尔山的安危，关乎我的家族，更关乎整个艾泽拉斯。获得 完成任务后，可获得：6600点经验值 塞纳里奥议会声望100' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41340) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41577, '好臭的味道！，你带回来的是什么鬼东西？！完成 多么可怕的局面。想想看，我们差点又站在燃烧军团入侵的边缘。，你和你同伴的所作所为不仅让艾泽拉斯免于又一场战争，还除掉了我们所知最强大的恐惧魔王之一。他的威名仅次于七年前军团入侵的先锋提克迪奥斯，连达拉然的六人议会里都流传着他的传说。这样一位叱咤风云的人物就此殒命，简直难以想象。你把他那颗邪恶的心脏带来给我，做得对。我能把它血肉中的邪能精华烧尽，虽然这对我的身体负担极大。但那只是小小的牺牲。只要能把这个污秽的存在从世上除掉，付出多少都不算什么。剩下的东西你留着吧，当作战利品——记住你今日的壮举。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41577) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41641, '它们的敌意毫无道理。我在想，它们究竟有什么目的？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41641) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41662, '泥土和豺狼人的口水——我得把这身衣服烧掉。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41662) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41777, '在她的论文里，Aszune 推测奥术能量经过一段时间会自然聚合。不过，这个过程可以用一种不那么自然的方式加速。她写道：如果把两件倾向相同的法器调校到同一波能量上，它们最终会融合，生出全新的东西。我太想亲手试试了，这种心情没法形容。我们先从简单的开始吧；谁知道我们的举动会带来什么样危险的连锁反应。照着这些咒文，我会尝试把两块大块魔光碎片凝聚起来，造出了不起的东西。，要是你能把碎片给我送来，我不胜感激。大块魔光碎片（2）奖励 你会获得：连结水晶 完成 太棒了，亲眼看着它在我眼前成形，这一幕我会永远记得。想想看，我们今天能做到这一步，全靠一万年前的知识——我族人珍藏了千年的智慧，正是我们韧性的证明。别担心，年轻的，没有你的帮助，这一切都不可能实现。这块水晶就当作报酬收下吧。我坚信我们还能把这套流程改进得更精，所以要是你愿意再收集一次所需的材料，我会很高兴。奖励 完成任务后可获得：0 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41777) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41804, '在你探寻他们的知识时，我会去联络我的巨龙军团。或许在我们古老的卷轴和隐秘的记忆中，我们能找出某些被遗忘的真相。但要快。暗影正变得愈发猖狂，时间并非我们的盟友。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41804) x
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
  SELECT 41908, '我们对德拉诺斯水晶的需求一直很大。我的部族还保留着许多来自德拉诺的灵性传统，我们为此深感自豪。但这也得付出代价。古老仪式所需的德拉诺斯水晶十分稀少，我们几乎每次出村都得冒极大的风险。在你听来，这或许既自私又难以为继，可要是没了传统，我们还算什么？，海岸边的生物也被这些外来的水晶吸引，与我们无异。它们的力量如此诱人，就像飞蛾扑火，纷纷被这股诱人的能量吸过去。你每找到一块德拉诺斯水晶，我都会向族人讲述你的功绩，我向你保证。原生德拉诺斯晶簇 完成 粗劣而原始，但无疑蕴含着力量。，你今日无私的举动不会被遗忘。村民们会知道的，我一定让他们知道。如果你还能找到更多，尽管拿来给我。获得 完成任务后，可获得：0点经验值 与……声望100' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41908) x
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
  SELECT 41914, '你去了这么久。Master Ralpekta究竟查出了什么？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41914) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41915, '完成 看来这些年我儿子成长了许多。又一件我该注意却没注意到的憾事。他比我以为的更早成了男子汉。Ar’lia 说得对。哀悼与无所事事的日子已经结束。我们熬过了一场种族灭绝，可不能倒在自己族人发动的又一场里。举起你的手臂，。我们要让这个假先知闭嘴。奖励 完成任务后可获得：850 点经验值和 50 点声望' FROM DUAL
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
  SELECT 41920, '你好，Parashka。你看上去一路奔波，很疲惫。这片海岸地处荒野深处，除了附近的牛头人邻居，几乎没人来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41920) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41928, '以圣光之名！你身上那股腐臭的瘴气是怎么回事？，不管你身上带着什么，赶紧交出来！果然如我所料，这石板上的防护诅咒太强，破不开。我们得用神圣之力把它圣化。为此，狂热的血色十字军手里的圣十字应该够用。那些圣物本来也不该留在他们肮脏的手里。，尽快把它们送到我这儿来！完成 十字架，你拿到了！隔这么远都能感到它们的神圣光辉。，我们必须净化这块石板。你也许不知道，天灾的邪恶地穴领主正是用它们催动惑人心神的法术，号令蛛怪大军、强化它们的力量。必须把它从这个世界清除掉，立刻。总之，保持警惕。我们毁掉的是他们珍视的圣物，他们必定会报复。做好准备！奖励 完成任务后可获得：2300 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41928) x
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
  SELECT 41932, '我的封印撑不了多久，。请你动作快些。完成 这些物品的力量让我惊叹。有了那野兽的心脏，我们就能打破图腾周围的邪恶屏障。Grammon 的舌头会让它们说出真话，净化之水会洗去一切污秽。奖励 完成任务后可获得：8400 点经验值，木喉要塞 1000 点声望' FROM DUAL
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
  SELECT 41936, '什么风把你吹来了，？我明白了……你身上的气场已经把话说清楚了。你手上有件不寻常的东西，对吧？天啊！我从没见过这么完美的裂隙水晶。，你难道知道手里捧着的是什么吗？有这么大一块裂隙水晶，谁知道我能召唤出多强大的恶魔……，仔细听好，强大恶魔的血液里浸满了虚空能量。给我带十瓶它们的血来。在腐化之痕、暗语峡谷和海加尔山顶游荡的最强恶魔身上就带着这样的能量。有了它，我们就能撕开一道足够大的裂隙，把一头浑身是劲的恶魔引出来，任我们宰割！完成 这香气……这些瓶子里装着纯净无瑕的能量。无论通过水晶裂隙把什么东西带进这个世界，都必定是一头强大到难以估量的恶魔。，带上你的盟友，做好你自己；这可不是轻松的活。准备好！奖励 完成任务后可获得：2300 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41936) x
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
  SELECT 41945, '你那样瞪着我干什么？快去！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41945) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41951, '这外面不安全。如果你不熟悉这片林子，我建议你去北边的村子找个落脚处。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41951) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41953, '我们对这些熊怪知之甚少，他们大多时候都独来独往。至于原因，我们只能猜测。他们一直都想密谋对付莫洛加一族吗？德拉诺水晶的力量真的就是他们想要的全部吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41953) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41956, '我们熊怪曾在卡利姆多的魔法森林中漫游，照料飞禽走兽与花草树木，维持它们的平衡。可自燃烧军团第二次入侵以来，几乎所有的族人都听从了那些恶魔留在我们神圣星辰之地上、至今仍在溃烂的黑暗召唤。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41956) x
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
  SELECT 41963, '你好。我看得出你的任务十分紧急。凡戈恩在上古之战时曾是我们族人的盟友，他强大的魔法与智慧是战胜那些上层精灵叛徒的关键。大分裂之后，他一直在Kalidar岛上沉眠至今，却始终警醒地影响着周遭的世界。那熊怪说得没错，他所说的是一种早已被遗忘的语言，就连月光林地的德鲁伊们如今也几乎无人能说了。教你学会它得花上好几年，但我能帮你听懂它，哪怕只是一小段时间。从世界之树的根部为我带来一颗诺达希尔的橡果、灰谷艾森娜神殿的树液，以及五瓶梦境药剂。把这些材料带给我，你就能在我的帮助下继续你的任务了。诺达希尔的橡果 艾森娜的树液 梦境药剂（5）完成 干得好。既然东西都齐了，我就能从橡果中提炼出一份祝福，让你听懂自然本身的言语。不过要小心，法术不会永远持续，所以请一路稳当地赶去凡戈恩那里。奖励 完成任务后，获得：0点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41963) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41965, '请务必保持谨慎。熔火之心十分凶险，里面的危险无论你的同伴做多少准备都不为过。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 41965) x
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
  SELECT 42005, '完成：Thil’phoral握在一只手中，碎片握在另一只手里。你极不情愿地把碎片按进剑身上的凹槽。几乎就在同时，那小片木头便开始在剑刃中扎根，这引得你面前的藤蔓向Thil’phoral伸来。它沿着你的小臂蜿蜒爬行，一面把你拉近，一面也缠住了握着寄生物的那只手。接着，藤蔓猛地收紧，以不可思议的力量把你的双手死死缠在一起，同时散发出骇人的紫色烟雾。你能感觉到寄生物的卷须正从你的脑中退去，穿过手臂，离开手掌。折磨没有持续太久，藤蔓终于松开了束缚，你重获自由的手中躺着的正是Thil’phoral，它与寄生物融为一体，泛着不自然的品红色光芒。正如你手中的那个声音所预言：它走完了自己的道路。多亏了你。因为你的行动，它如今得以观察，并向那个将它带入此世的力量宣告自己的发现。完成任务后可获得：8000经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42005) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42007, '！你回来了。请问，Evenpike 呢？完成 以创造者之名，他说得没错。唉，Odum，你这个疯子！拿命去打这种赌，太不值了！，我的朋友一直在找一件古物，他认为那属于泰坦——那些曾造访艾泽拉斯的永生存在。在我们伟大的铁炉堡里，许多学者和教授都推测矮人的起源与那些神明般的生命有关。他以为你手里那东西能让矮人离真相更近一步，但看样子它并不完整。不管怎么说，Evenpike 用性命换来了这个惊人的发现，我会自豪地尊崇他的牺牲。等我处理完暴风城这边的事，就把它呈给铁炉堡大图书馆的资深探险家麦格拉斯作进一步研究。至于你，英雄气概与考古贡献都该有回报，我为你备了一份应得的奖赏。旅途平安，旅行者。奖励 完成任务后可获得：850 点经验值，铁炉堡 125 点声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42007) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42008, '动作快些。我的主人可不是以耐心著称的。完成 传闻果然不假，我还很少见过如此柔滑如丝的毛皮。我简直等不及要开始处理它了。按照约定，也给你一份报酬。我相信你一定会用得上它。奖励 完成任务后，获得：1250点经验值，250点银月幸存者声望' FROM DUAL
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
  SELECT 42034, '你是谁，为什么要来打扰我干活？要是你只是来烦我的，那我就让你见识见识我的熔炉到底有多热……哦嚯，原来如此。算是加急送货，是吧。我或许就是你要找的人，可你要是想让我尽快办成，这点少得可怜的金币可不够。想在最短时间内弄完，就再给我一百金币，我会考虑考虑的。成交？完成：这才叫像样的报酬。现在稍等一下，我马上就弄好。你带来的这些东西，读起来可一点都不轻松……完成任务后可获得：6500经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42034) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42039, '做好万全准备，霜鬃巨魔是狡猾的敌人。完成 这么说，Ubukaz被干掉了？我简直不敢相信自己的耳朵。我毫不怀疑还会有另一个巨魔站出来当上酋长，但接下来的这些日子里，丹莫罗总算能太平了。趁他们内斗还没结束，我们还有时间庆祝一番！奖励 完成任务后，获得：1200点经验值，300点铁炉堡声望' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42039) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42040, '那么……你运气怎么样？要不是没办法，我可不想在这底下多待了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42040) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42041, '哦嚯嚯！看来我小看你了，。这些割藤刀几乎能切开空气；这些口粮又顶饱又好吃！我真是服了，你这几下子把我彻底镇住了。按说好的，我教你几手小窍门——那些能让你在最凶险的荒野里也活下来的窍门。完成 别磨蹭了！年轻人，时间可不等人。奖励 完成任务后可获得：4800 点经验值' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42041) x
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
  SELECT 42054, '是天界兄妹指引你迈出最初的一步来到我面前，。你在这里、在红云台地完成训练期间，将由我照看你，尽我所能教你。我相信你渴望亲眼看看这个世界，甚至想踏上前往月语海岸的朝圣之旅。月蹄村存有三卷祈祷卷轴，每一卷献给兄妹中的一位。完成 朋友，还要过许多个周期，你的蹄子才准备好踏上那条路。你的训练继续。等你积累了更多战斗经验，再来找我。虔诚信奉天界兄妹会让你超越部族的界限。大地母亲的眼与泪都眷顾着你。从今往后无论你走哪条路，至少他们中的一个会与你同在。奖励 完成任务后可获得：40 点经验值' FROM DUAL
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
  SELECT 42080, '你是朋友还是敌人？看来两者兼有，部落的一员。我何德何能，让你在这时候来搭救我？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42080) x
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
  SELECT 42090, '别小看他们。这两个人在伊利丹的战役中统领过军队，从屠杀数百人的战斗里活了下来。这种家伙可没那么容易倒下。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42090) x
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
  SELECT 42100, '愿圣光指引你，让那些贫苦之人沐浴在它的仁爱之中。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42100) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42101, '据说大自然的精灵是幸运与富足的使者。我确信我看到的就是它。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 42101) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));

-- ---- ObjectiveText1_loc4（6 条）----
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
  SELECT 42051, '旋风神殿' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 42051) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText1_loc4`)
  SELECT 42056, '治疗并强化 勇士绿角' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText1_loc4` FROM `locales_quest` WHERE `entry` = 42056) x
                      WHERE x.`ObjectiveText1_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText1_loc4` = IF(`ObjectiveText1_loc4` REGEXP '[一-龥]', `ObjectiveText1_loc4`, VALUES(`ObjectiveText1_loc4`));

-- ---- ObjectiveText2_loc4（2 条）----
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 41956, '找到了木喉营地' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 41956) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText2_loc4`)
  SELECT 42051, '炽火神殿' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText2_loc4` FROM `locales_quest` WHERE `entry` = 42051) x
                      WHERE x.`ObjectiveText2_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText2_loc4` = IF(`ObjectiveText2_loc4` REGEXP '[一-龥]', `ObjectiveText2_loc4`, VALUES(`ObjectiveText2_loc4`));

-- ---- ObjectiveText3_loc4（2 条）----
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 41956, '找到了绿爪部族' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 41956) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));
INSERT INTO `locales_quest` (`entry`, `ObjectiveText3_loc4`)
  SELECT 42051, '峭岩神殿' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `ObjectiveText3_loc4` FROM `locales_quest` WHERE `entry` = 42051) x
                      WHERE x.`ObjectiveText3_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `ObjectiveText3_loc4` = IF(`ObjectiveText3_loc4` REGEXP '[一-龥]', `ObjectiveText3_loc4`, VALUES(`ObjectiveText3_loc4`));

