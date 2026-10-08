-- 乌龟服任务文本：按**线上最终英文**补齐／重译（含 UPDATE 改写过的文本）
--
-- 背景：database_updates 里除了 REPLACE INTO 的整行覆盖，还有大量
--       `UPDATE quest_template SET ... WHERE entry = N`——这些后写的文本才是线上真正的英文。
--       早先的工作清单只读了 REPLACE，漏掉这批，所以 /db/quests/<id> 的「交任务文本」等仍是英文。
--
-- 第一节：库里完全没中文的 319 条，带「已有汉字不覆盖」保护。
-- 第二节：我此前按旧英文译过、线上英文已被改写的 167 条，必须强制覆盖（否则写不进去）。
--
-- 生效：mangosd 控制台 `.reload locales_quest`

SET NAMES utf8mb4;

-- ======== 第一节：缺译（319 条） ========
-- ---- OfferRewardText_loc4（314 条）----
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41393, '＜巨人的眼睛滚烫无比，可马蒂亚斯毫不在意。他端详着你带来的石头，手上发出滋滋的声响。看了个够之后，马蒂亚斯把它丢进旁边的水桶，满屋蒸汽腾腾。蒸汽散去，他焦黑的手里躺着一颗纯净无瑕的玻璃弹珠。＞$B$B多么有趣的材料。我一直想弄到一块，就为了体验它们那种炽烈的高温。干得漂亮，$N。你已经向我证明了自己。欢迎加入我们。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41393) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41394, '恐惧魔王之魂……看来一切都没问题。现在，该净化艾露恩之镰了！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41394) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41519, '熊猫人？对，我听说过他们，但很多人觉得那只是传说，或者哄孩子的童话。不过我从几个十分可靠的人那里听说，他们确实存在！$B$B这不是重点，对吧？你想深入了解法杖格斗的技艺。那可不是我最擅长的……马蒂亚斯大师能讲得更清楚，但他的时间非常宝贵，所以你得先证明自己！其实，我有个绝妙的主意，能让你赢得他的尊重！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41519) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41520, '是我看错了吗？不，绝不可能。这确实是传奇人物陈·风暴烈酒的酒杖——他既是酿酒大师、战士，也是许多人的朋友。看来那些古老的传说终究是真的。干得好，$N。$B$B如今，想到你为找回这件遗物付出的辛劳，若是把它就此搁上架子，那可就太说不过去了，你不觉得吗？那么，让我们看看它藏着什么秘密吧，好吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41520) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41522, '投掷武器精通？你在艾泽拉斯怎么会想专攻那个？$B$B＜她打量着你，既惊讶又好奇。＞$B$B好吧，我得跟你说实话。我从未花太多时间去弄懂投掷武器的门道，我总觉得那不值得费心。所以我自己帮不了你。不过，若能由明心大师亲自指点，我们很快就能让你上手！$B$B我可以为你安排一次他的私人授课，但有个条件——你得帮我们一个忙！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41522) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41523, '＜马蒂亚斯·明心仔细端详着那几把斧子。＞$B$B啊，你大概在想，这些斧子有什么特别之处。在外行眼里，它们不过是普通的投掷斧，也许大了一点。可它们远不止看上去那么简单。$B$B看它们平衡得多完美，重心正落在柄的正中。阿曼尼是个极其聪明的部族，他们把这种斧子的配重掌握得精准无比，使它在飞行中急速而不规则地旋转，几乎无法闪避或招架。无数精灵的性命都断送在这些武器之下，今后还会有更多人倒在这种致命的精准之下……$B$B不过我又扯远了。你为我找回它们，做得很好。现在仔细听好，我不会再说第二遍！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41523) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41525, '威力又大又吵——对，那就是枪。什么事让你这么好奇？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41525) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41526, '黑石山的火药，上等货。它的爆炸威力比寻常火药更具破坏性。那么，跟一个用枪的人交手，感觉如何？$B$B＜马蒂亚斯听了你的回答皱起眉头。＞$B$B他居然用斧子和猎犬作战？真让人失望，回头我得说说诺拉。无妨，来吧，徒弟，让我把你要的东西教给你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41526) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41528, '弩的精通，嗯……非常技术性的著作。你没法一眼读懂其中的学问，这怪不得你——我花了两年研读才弄明白大师那些迂回曲折的思路。不过我想你大概没那么多时间……当然！替明心大师办件事怎么样？事后再替你安排一次私下授课是完全可行的。有他亲自指点，你离掌握弩就更近一步了。$B$B回到那件差事——我猜你对血色十字军并不陌生？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41528) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41529, '加入血色十字军真是可悲的决定。像他那样的人才，用在别处会更有用得多了，不过现在说这些已无意义。我猜你已经把他处理掉了吧？哦，别用那种眼神看我。他的命运早已注定，威利自己也清楚。虽然我希望他能亲口告诉我他家族的秘密，但我还没蠢到以为他会答应。所以眼下，有这把漂亮的弩就够了——它可真是漂亮。我会好好把它研究个透彻。现在，该给你的奖赏了——我们开始吧？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41529) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41531, '哦！弓的精通——对，那一本我很熟。在远程武器里算是个大题目，毕竟弓比它年轻的同类——枪——要古老得多。许多文明，尤其是那些不以魔法见长的文明，都把这种武器深深嵌进了自己的文化。不过，在我继续深究细节之前——你是想弄懂大师某本纲要的精髓？$B$B恐怕我不是最适合帮你的人，因为我缺乏实战本领，没法把其中的学问演示给你。而大师忙得不可开交，你肯定也知道……但我想我能帮上这个忙，只要你反过来帮我们一把。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41531) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41532, '哦！你带的这件武器真漂亮。诺拉把事情都告诉我了。岁月在这件疲惫的旧物上留下了深深的痕迹，但只要稍加修补，它就能重获力量，再次被人好好握在手里。你说你是在哪儿找到它的？恐怖之槌废墟里的一位上层精灵幽灵？太刺激了，等我们授完课，你一定要跟我讲讲。$B$B那么，仔细听好。你不会有第二次被指点的机会了。你赢得了我的时间，而我很看重它——别让我失望！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41532) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41534, '你觉得长柄武器被人忽视了？呸，你越来越像大师本人了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41534) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41535, '用更短小的兵器去对抗体型庞大的对手，很可笑吗？我不觉得——毕竟，我想你现在已经看到，长柄武器正得到应有的尊重。来吧，徒弟，我给你讲讲「舞矛」的故事，之后我教你那支舞。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41535) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41537, '这瓶药很难下咽，对吧？几乎完美地一边谴责、一边赞美同一个人。它或许会让你质疑是非对错，对吧？其实不必。记住，这本书的用意与战争技艺相关——它竟把马杜克贬低到那种地步，这件事本身就已足够惹眼、格格不入。$B$B对它闭上心扉，把心留给你的下一项任务。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41537) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41538, '一件善举，我会以我的传授作为回报。达隆郡的人们得到了他们应得的公正，我衷心希望这能让他们些许安宁。符文剑由诺拉处理，你不必再操心。现在，拿起武器吧徒弟，我不会手下留情。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41538) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41540, '我们的矮人表亲对锤子确实推崇备至。不过恐怕那个传说只是传说——除非有证据证明不是。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41540) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41541, '我猜你能看出，诺拉在说到那位总工头时有些私人情绪，但如果她不愿说出自己的故事，我当然也不会说。你把「碎指」带回来，做得很好。我们开始上课吧，课后你可以告诉我，巴古尔拿着那把锤子表现如何。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41541) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41543, '我还在想你什么时候才能找到那一本。信不信由你，这本是大师的心爱之物。考虑到人类与兽人的过往，你或许会以为并非如此。唉，大师的眼光超乎种族的观念——对他来说，只有战争技艺的高下。$B$B你准备好走一趟谦卑的朝圣之旅了吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41543) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41544, '一份不祥却又充满象征的礼物。他的战斗之魂是否仍在那道峡谷中回响？啊，我常梦见与他在战场相遇。拿起武器吧徒弟，来学习。你敬重了一位往昔的战士，我也会以战士之礼敬重你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41544) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41546, '你这人挺有意思，$N。赤手空拳对抗整个世界，是吧？令人敬佩……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41546) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41547, '这是卡利姆多精灵当中一位强大的传奇。你竟敢只凭双拳去挑战它，这份气魄不小！来，我们过过招——也许我能教你些新东西。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41547) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41549, '相当古怪的一本，对吧？大师学识渊博，远超战争技艺本身。就连我也惊叹于这本书里解剖学研究的范围。不过理论固然不错，若不付诸实践又能有什么用？所幸——在这种情形下，「所幸」或许不是个恰当的词——只要你能帮我们处理一件更棘手的事，我就能确保大师把其中实用的部分教给你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41549) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41550, '你看起来精神不错，考虑到你为了拿到这东西去过什么地方。我猜这位达米安使匕首相当了得，可惜他的妄想与脆弱的头脑把他变成了一个怪物。感谢你把这颗毒疮从我们的世界上除掉。像他这样的异类绝不能被容许肆意横行，无论现在还是将来。我希望你继续出手，让艾泽拉斯变得更安全。那么，跟我来——我们看看这些好东西能做什么。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41550) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41553, '要是那该死的混蛋以为能压我一头，那他可就想错了！等我把那款完美麦酒的配方琢磨出来，他可以滚到这儿来亲我的靴子！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41553) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41554, '要是那该死的混蛋以为能压我一头，那他可就想错了！等我把那款完美麦酒的配方琢磨出来，他可以滚到这儿来亲我的靴子！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41554) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41555, '啊哈！就是它，难得一见的剃刀沼泽格罗格酒。递过来，我要好好尝尝。$B$B＜哈尔托格拔开瓶塞，深深嗅了一下酒香。他皱起脸，但很快恢复镇定。他把瓶口凑到唇边，小小地抿了一口。＞$B$B没错，当然。这肯定是用荆棘草酿的，味道一模一样。可又有点不同。也许……？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41555) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41556, '对！这些又好又烫，正适合生火。我先收着，日后再用；眼下我们有更急的事要做！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41556) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41557, '你真的找到了！一款传奇的杜松子酒，外界难得一见、也难得一尝。我们来试试！$B$B＜一大口下去，酒已去了半瓶。哈尔托格绿色的脸微微泛红。这酒劲头不小！＞$B$B哇，这酒真是够劲，我现在明白他们为什么说它能让人热血沸腾了。入口是灼烧感，回口带着甜味。要不是我懂行，我会说他们往里掺了一种特别的蛇麻草。不过要查明他们用的究竟是哪一种，恐怕不容易……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41557) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41558, '啊，我记得它们那股独特的浓烈气味。等我在足够高的温度下酿造时，那泥土般的底味会与我的其他配料完美相衬。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41558) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41559, '很好。我都有点想自己嚼一颗了，幸好我脑子里那个讲道理的声音够响，拦住了我。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41559) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41560, '说它们带烟熏味都算轻描淡写。气味如此浓烈。我告诉你，$N，这一样我们可能挖到金矿了！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41560) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41562, '哎哟！这些刺可真扎手，真稀奇。单凭它们柔软的质地和可爱的香味，我就知道味道一定很甜，太好了！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41562) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41563, '啊，刚摘下的蛇麻草那股浓郁的香气，没什么能比得上！干得好。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41563) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41564, '＜塔尔多恩深深嗅了一下拔出的蛇麻草，喜不自胜。＞$B$B简直像做梦，有了这个我就输不了了！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41564) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41565, '太好了，让我马上试试！$B$B＜塔尔多恩把魔法之水倒进蒸馏器，那深褐色的饮品顿时化作闪耀的金色酒液。＞$B$B不可思议，简直惊人！我的酒将在口感和质地上达到无人能及的高度！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41565) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41566, '样品不错，我会把它们加进我的混合料里，若有变化再告诉你。单是它们的气味就让我觉得很有戏！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41566) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41567, '我的计划全被撕碎了！黑须竟敢糟蹋我历经数年艰辛、血汗与泪水换来的成果，但愿他得到了应有的下场！所幸配方里重要的部分我还能读懂。谢谢你，$N。我知道你为了我冒险闯进那座该死的山，连身家性命都搭上了。这些东西回到我手里，我们终于走到旅程的尽头了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41567) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41569, '这才叫舞会！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41569) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41570, '这才叫舞会！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41570) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41571, '这才叫舞会！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41571) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41636, '梅莱恩先生的箱子！我前阵子为孩子们上学的事去安伯郡时见过他，他把事情都告诉了我。竟有不信光的异教徒去偷那些本已被命运苛待的人的东西，真令人震惊。好$C，圣光会以仁慈的光辉照耀你这桩义举。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41636) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41638, '哦，母亲……我很抱歉把你留在那个弃光之地。请放心，你会在暴风城——我的新家——找到新的安息之所。谢谢你——你叫$N，对吧？母亲的骨灰回来了，我会在继续随银色女士尽我的职责之前，先把它送到教堂去。再会了，善良的人。愿圣光的祝福照耀你的前路。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41638) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41641, '你的本事展现得十分精彩，$C。我看得出你已经领会了萨满教义的根本，至少在用之于战斗时是这样。谢谢你出手相助；我会把发生的事转告先知大地之怒。让元素的混乱受到约束，是我们对自然与灵魂的责任。要查明奥拉基尔的爪牙在谋划什么，需要时间，也许将来还需要你再次帮忙。无论如何，平衡必须维持。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41641) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41642, '真是悲剧，克里斯托夫是个心地真正善良的人，也是位好父亲。看到他死于这样一场无谓的祸事，我的心都碎了。可那可怜的、可怜的阿诺德怎么办？他如今成了孤儿，我很担心他。请让我来处理该怎么告诉他父亲的遭遇。安伯郡教堂里那位受尊敬的修女会知道该怎么说。$B$B谢谢你，善良的人。你今天做了一件好事。愿圣光的祝福照耀你的前路。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41642) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41643, '有意思。有了你带来的证词，再加上我自己掌握的情报，我们应该能锁定几名嫌疑人。干得好。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41643) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41644, '这消息令人不安。它不仅证实了范克里夫的图谋规模远比我们想的大，还让我们必须排除迪菲亚与这连串绑架有关的可能。我们只好去追查一条更艰难的线索……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41644) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41645, '又是一条死线索。副手，我们的选择越来越少了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41645) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41647, '＜老妇人搅动着大锅，锅里剧烈翻滚，冒着极其刺鼻的气味。＞$B$B哎呀呀。看看是谁来了？一只迷路的羊，想找个地方歇脚？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41647) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41648, '哦嚯，太好了，亲爱的。这一季的寡妇褶菌格外厚实，要不是眼下非得用它们不可，我倒想做一锅可爱的炖菜。它们相当可口，等这一切结束后你或许可以自己尝尝。还有你带来的这把梳子——是一位年轻女子的。我们别再耽搁了。那么，把这一切都调和起来……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41648) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41649, '要是这家伙没用变声器，我就能告诉你他到底是谁。我这对又大又绿的耳朵是全艾泽拉斯最好的，再了不起的精灵也比不上我的听觉辨识力！$B$B不过，再听一遍录音，说不定恰好帮我们解开了这个谜团。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41649) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41650, '＜眼前的景象只是引出更多疑问。你手上的线索不多，但有一条格外扎眼：插在侏儒胸口的血精灵匕首。你的推断是，你在这片区域西南方路上遇到的那些血精灵出于某种未知原因伏击了这名侏儒。他们似乎在寻找什么，于是带走了侏儒的随身物品，还有他们没能找到的那只储物柜的钥匙。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41650) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41652, '哦，你听到了那阵干扰声，是来帮忙的？太好了，我正需要一双能干的手！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41652) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41657, '＜阿格纳什指挥官慢条斯理地端详着那封信，显得颇有兴趣。＞$B$B看来龙喉氏族并不像我们原先以为的那样团结。这消息听起来让人宽心。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41657) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41659, '干得漂亮。萨尔加拉兹矿场蕴含着相当可观的铁矿，这正好能为我们的行动提供极大的助力。收下这个吧，作为你今天所作所为的奖赏。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41659) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41662, '卫兵撑不住的地方，就由百姓来撑。我感激你，冒险者。这点钱算是你的辛苦费。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41662) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41663, '迈克，这只狡猾的老狐狸。他这名字平庸得不能再平庸，脑子却能把任何别的聪明人比下去。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41663) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41664, '那条不知羞耻的狗。呸，谁能想到孩子们的笑料竟会干出这种事？「琥珀脸颊」爵士胆子倒不小。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41664) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41670, '有人会告诉你，这样毫无意义——日复一日地守着逝者、守着过去。可一旦逝者被遗忘，这些墓碑就只是装饰。那是一种比死亡更可悲的命运。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41670) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41672, '我由衷地感谢你。虽说我嘴上说得漂亮，能拿出来的东西却不多。没有外人从北风领来往，旅店里连一两个醉汉都难得。所以我请你吃顿热饭，楼上随便哪间房你都可以住，只要你在北风领期间，就把它当自己的家。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41672) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41673, '哇，真的跟她脑袋一样大！她会爱死它的。谢谢你，这份情我记下了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41673) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41675, '这是杰瑞想出来的？主意不坏。我对那孩子太凶了，我该去跟他谈谈。谢谢你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41675) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41679, '什么——报酬？我还以为你来这儿只是为了冒险的刺激。来，拿些钱去。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41679) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41680, '呃啊，呃——卫葛斯！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41680) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41684, '这么说果然是兽人干的；但不是黑石兽人。你描述的样子，跟我们近来遇到的任何兽人部族都对不上，至少我记忆里没有。我们把这个交给暴风城，让总部去追查。$B$B至于那个女孩……我会亲自去把她的遗体带回来；反正那个兽人营地我也得去看一趟。告诉她母亲的事就交给我吧，那种事本来也不该落到你这样的人头上。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41684) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41686, '我猜是外来的势力？我们正忙得不可开交，多一双手总是好的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41686) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41688, '马饲料！米尔登霍尔女士告诉我，有人受命去豺狼人那里找回失落的麻袋。看到它们大部分完好无损，我真是松了口气。我们的旧存货快见底了，光给这些马喂干草，可不足以让它们在比赛中应付那么耗力的运动。再次谢谢你！你替米尔登霍尔女士办完事，她会给你一些钱，请收下。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41688) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41689, '＜你动作缓慢而小心地靠近这个可怜的小家伙。手里拿着青草，你轻轻放到它喙前，看着它一点点啃着草叶。你用药草浓烈的香气与滋味引开它的注意，趁这段时间给它包扎好翅膀。伤口处理妥当，小家伙又因青草补充了力气，它用长着羽毛的脸上一双惹人怜爱的眼睛一直盯着你。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41689) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41690, '算你走运，你根本不知道给这可怜的小家伙喂了什么。你采的那种植物叫「贵族枕草」，以麻痹肌肉而臭名昭著。它们确实帮着减轻了它的疼痛，但若想救下这个小家伙，还有很多事要做。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41690) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41692, '＜你周围的情形说明这里曾爆发过一场激战，盘旋在破败营地周围的食腐鸟描出一幅凄惨的景象。你在散落的补给中找到的日记，也许能揭开这里发生过什么。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41692) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41693, '圣光保佑你前来相救。我还以为自己会像其他人一样葬身于此。再次谢谢你，等我离开这个鬼地方，我会把知道的一切都告诉你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41693) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41695, '我得说，参与这样一次载入史册的任务真让人激动。巴洛岛满是神话、传说与历史，我几乎按捺不住自己！$B$B自从我们登陆，基里安特工就一直有些不安，这也能理解，毕竟这地方实在谈不上友善。但我们的职责必须履行，为联盟效命不能被几只小鬼挡住。那么，我猜你是带了东西给我？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41695) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41696, '我看你回来了，手里还带着文稿！太好了，真的。多几句可供比对参考的话，整件事就能快得多。我发现他们编码文本的方式，和我们手中第二次大战的历史文献极为相似。这让我相信，我们面对的是那场战争的残部与幸存者。有意思，对吧？$B$B总之，请让我把翻译做完，不会太久的，朋友。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41696) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41699, '＜薇罗娜读着诺普西的报告，表情毫无变化。她细致入微的分析让你明白，为何这次行动由她挑大梁。＞$B$B$N，做好准备。我们要发动一次潜入行动。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41699) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41701, '干得漂亮，$C。这些邪物也许是超出我们理解的恐怖存在，但至少味道相当不错。靠它煮一锅上好的秋葵浓汤，我们还能撑上几天。不管怎样，看来我们和它们的账还没算完。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41701) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41704, '安静，还不算完全安静，但也差不多了。我的幽魂之心因你的仁慈而稍得安宁。你做的是一件高尚的事，真的。若不是你的善心，他们那止不住的哀号早就把我撕成疯狂的漩涡，这一点我确信无疑。巴洛的诅咒或许永久长存，但它的效力如今已略微减弱。$C，你让我欠你一份情。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41704) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41705, '＜你把碎裂的娃娃放到女人面前，她眼中迸出意想不到的狂喜，睁大到她脆弱的身体所能容许的极限。她用尽最后一丝力气抓住娃娃，边缘深深勒进手掌，却没有流出一滴血。她发出一声可怜的哀鸣，随后彻底停止了动作。$B$B你最后那一手有没有让她死得不那么痛苦，你只能猜测。至少你可以确定，她已经不再受折磨了。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41705) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41706, '多么可憎……光是靠近它们，就让我被沉重的倦怠压住。这份污秽与卡利姆多森林里那些作祟之物颇为相似，非常相似。可又足够不同，并非同一种……我无法想象，带着这样一个阴影活在体内，该有多痛苦。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41706) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41707, '＜在金里尔的单片眼镜下检视着菌丝体，她脸上蒙着一层严峻的表情；你猜那既是担忧，也是审慎的好奇。＞$B$B有意思，这些蘑菇菌株还在不断寻找肥沃的土壤扎根繁殖。正常情况下，不扎在合适的土里它们很快就会死，可这些不一样——它们扭动着、四处试探，主动寻找养分。看着真叫人毛骨悚然。为了我们特工着想，这个恶心的细节我就不上报了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41707) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41709, '这光泽、这质地……！即便是这么一小片，我也能感到潮汐在其中共鸣。而你是从祭坛上一颗巨大珍珠里取来的，还噼啪作响带着能量？跟你说实话，这听起来太让人警惕了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41709) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41710, '那老糊涂。他一向有在刀尖上过日子的本事，可他真该多在意些自己的安全。不管怎样，我很庆幸他身体还好。那么，我的书虽然有点泡水，但配方我照样能调出来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41710) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41713, '美得让人屏息。研读这部古老典籍时在我眼前展开的种种奥秘，将是我们获得自由的关键。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41713) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41716, '我看见你和阿格娜什指挥官谈过。他说的是真话。我们始终被一个远比我们强大的敌人威胁着。龙喉控制着这片区域，实力无人能及。他们的数量甚至远超丹基塔斯的矮人。$B$B若想真正在这里站稳脚跟，我们就必须在别人对我们动手之前先动手。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41716) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41717, '你把它们找回来了？$B$B＜顾问拉娜格一把从你手里夺过命令状，飞快读了起来。＞$B$B这些命令里似乎包含了在本地区进一步入侵的计划。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41717) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41718, '这么说，他们确实打算对我们下手。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41718) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41719, '＜阿格娜什指挥官爽朗地大笑。＞$B$B你今日立下大功，格什甘是个凶残的敌人，如今他倒下了。你为我们出了大力。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41719) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41720, '你做得很好，这些都没被龙喉动过手脚……现在去吧，我还有研究要做。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41720) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41722, '看看这比例！这些独行蛛腿正好能给我的食物储备添上一份好货。你帮了我大忙，也帮了镇上所有人。$B$B拿着这些钱，带着荣誉去吧，朋友。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41722) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41723, '你的所作所为充分说明了你的荣誉，$C。荒野之喉是个必须解决的威胁，你的行动无疑让我们安心了许多。$B$B收下这些钱，这是部落对你的谢意。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41723) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41725, '多么精湛的工艺，这些零件对我大有用处。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41725) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41727, '恶魔之魂的力量就蕴含在这血液之中，它的力量无可否认。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41727) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41728, '你做得很好，现在我们才能着手更艰难的任务。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41728) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41729, '如此阴暗而强大的能量，它对我大有用处。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41729) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41730, '＜先知莫萨发出一阵低沉而阴森的笑声。＞$B$B乌索克之坠饰，终于在我手里了……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41730) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41732, '哎呀，这是什么？你说这是冷酷海岸的古代科技？竟有如此复杂精巧的机关……$B$B＜塔尔韦格花了一会儿检视那装置。＞$B$B我得说，这是了不起的发现！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41732) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41734, '你带来的是什么，某种机械装置？我建议你拿去找侏儒，他们懂的比我这种人可多多了……$B$B＜加卡尔花了一会儿研究那机关。＞$B$B哎呀，这可是奥达曼的科技，不是什么侏儒小玩意儿。我在荒芜之地见过类似的东西。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41734) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41735, '托尔拉格派你来的？呸，他总爱支使随便哪个能被他说动的人替他打猎。这本该是他自己的活。$B$B来，把这些银币拿去。本来是给托尔拉格的，既然你在替他干活，那就归你了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41735) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41736, '你做得很好，这是治愈这片土地的第一步。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41736) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41737, '如此污秽、恶性的能量……这片土地上的腐化显而易见。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41737) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41738, '材料都收集齐了。你已尽到职责，现在让我来做我的事……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41738) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41739, '你打听达格恩奥斯之焰？你说约塞格派你来的？你在打听黑暗邪恶的东西，我怎么知道你不是哪个邪物的爪牙，跑来跟我撒一个大谎？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41739) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41740, '干得漂亮，你已经证明自己是个能干的冒险者！你帮我做了件好事，为此我愿意把你要的情报给你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41740) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41741, '达格恩奥斯之焰在冷酷谷？$B$B我早该猜到的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41741) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41752, '刺鼻的酸味扑鼻而来。毫无疑问，这些蜘蛛被人动过手脚，被用邪秽的仪式注入了魔法。你把它们从折磨中解脱出来，做得很好。来，收下这个，作为让你冒这份险的报酬。愿你怀着骄傲与赤诚为酋长效劳！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41752) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41754, '这些刻痕无疑是矮人的，甚至能追溯到三锤之战以前！只要给我一点时间，我应该就能译出刻在这块石板上的信息……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41754) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41756, '干得好，士兵。我知道死掉的兽人越多，夜里就睡得越安稳。用不了多久，我们就能把这些杂种彻底赶出湿地。继续战斗下去，卡兹莫丹的子孙永远会助你一臂之力。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41756) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41762, '太棒了，太棒了！只要他们重新启动那些站点，就会上演一场壮观的火力奇观！这件事搞定了，我们只要把桶搬回……——等等，你还在这儿？哦，你的报酬，当然，稍等一下……$B$B＜这地精在腰间的小挎包里翻找着，掏出一枚金币。＞$B$B拿去吧，别一次全花光，傻小子！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41762) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41763, '哦，我的心爱之物，终于回到我怀里了。我感激不尽，$N。现在我总算能好好享受这趟给自己放的钻油平台假期了——多谢啦！来，我们喝一杯，为这事庆祝一下！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41763) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41765, '对你来说肯定轻而易举，嗯？你比看上去能干。纳特跟部落结盟是对的；虽然当初他其实也没什么选择。既然这帮杂兵都清掉了，该把他们的头目揪出来了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41765) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41766, '尖鳍？固然不是什么大鱼，可他的名字在幽坑城偶尔会被人提起。从这里能读出的内容看，他们的高招是用一道自家土制的法术让水泵站过载——结果当然弄巧成拙，典型的的地精作风。反而把油本身给强化了，害得我们还得收拾这些到处流窜的油软泥。烦人得很。算了，给这事收个尾吧，我一分钟都不想再浪费在琢磨那大亨的走狗上了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41766) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41769, '＜就在你把那枚颤动的蛋递给贾马纳利时，蛋壳开始裂开。一小片一小片地，幼崽拼命挣出牢笼，大口喘着气。它发出一声尖细的鸣叫，看了你一眼，又跳回你手上，拼命对着空气乱咬。＞$B$B暴掠龙幼崽很快就能自己站稳，也同样很快就饿。要养好你的新养子，我们就得喂它。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41769) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41775, '就是它；哦，这装帧多么精美，如此繁复细致。把它捧在手里简直让人难以自持，仿佛我被抛掷在知识的潮汐之间，被卷到浪下，溺没在阿兹苏妮公主的发现之中。你做得不能再好了，$R。作为奖赏，让我把阿兹苏妮的智慧传授给你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41775) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41778, '啊，贪婪圣契。你翻过它的书页吗？在外行眼里，它不过是些互不相干的图像与晦涩文字，可在开明者看来，其中藏着难以预料的潜力。图书馆对你的持续相助感激不尽。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41778) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41779, '啊，坚韧圣契。这部厚重的典籍因藏着艰深咒文和某些人视为危险的珍贵奥术智慧而声名在外。图书馆对你的持续相助感激不尽。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41779) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41780, '啊，坚韧圣契。在志向远大的奥术师中间颇受欢迎的作品。但请当心，若你在它的书页间迷失了自己，就再也回不了头了。图书馆对你的持续相助感激不尽。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41780) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41781, '沉思圣契。一部邪恶的魔典。它的内容我最好不予公开；为了你好，我希望你没打开过它那些受诅咒的书页。图书馆对你的持续相助感激不尽。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41781) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41782, '啊，坚韧圣契。若我们的统计可信，这本书是被偷得最多的一本。我很好奇为什么……图书馆对你的持续相助感激不尽。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41782) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41784, '这么说，你也许真有那本事。那么，只要你愿意把金币交出来，我就为你——以及其他付过我费用的人——打开我的秘密商人名单。相信我，你不会后悔的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41784) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41786, '总有人会斗胆闯进来，这只是时间问题。放下武器，我对你没有恶意。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41786) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41788, '这么说……凯拉终于想起还有我这个人了？真让人感动。$B$B＜德雷萨尼斯用平静而难以捉摸的目光打量着你——没有温度，也没有感激。＞$B$B好吧。至少，你的出现或许能派上用场。这腐化比我们任何人担心的都更深。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41788) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41789, '他们的灵魂如今飘回梦境……与他们狂热崇拜的熊神乌索尔融为一体。$B$B多么讽刺。尽管他们如此盲目虔诚，连乌索尔也没能护住他们免于腐化。又或者……是他选择了不护。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41789) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41791, '挺起胸膛，士兵。贝尔戈洛姆把你派到这儿，做得很好。看看四周，这里有许多事要做。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41791) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41792, '那味道……！一定是斯拉格著名的野猪排！这味道我在哪儿都认得出来。就跟我们父亲从前做的一模一样。太感谢你了，$N。深入敌境有时真会消磨我的士气。谢谢你，也谢谢斯拉格，让我想起我们在这里是为了什么而战。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41792) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41793, 'Throm\'ka，小家伙。欢迎来到碎刃哨所。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41793) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41794, '莫克萨丁把你派来是明智的。这瓶药水对我们在这座岛上的行动至关重要。你在这儿期间，就帮我们一把吧。有多少人手我们都需要。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41794) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41795, '小家伙，我们面对的是深不见底的深渊。务必确保你的心已为接下来的一切炼成钢铁。否则你就会被这座岛上溃烂的虚空吞噬。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41795) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41796, '我们父亲送来的围巾？哎呀。这下可有点难为情了。他一向心软，可以说是个爱做梦的人。不过别误会，我非常感激。阿莱莎和我是在暴风城长大的。那时候我们还太小，对那段日子记得不多，可回到这里总让我们觉得别扭。有件来自家乡的熟悉物件，肯定能帮我们适应眼下的处境。为此，我谢谢你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41796) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41797, '艾瓦特的信？她还好吗？我听说如今的暮色森林很凶险，对普通百姓来说并不安全。$B$B＜巴尔巴拉拆开信，飞快扫了几行，忍不住轻笑了一声。＞$B$B看来我没什么好担心的，真让人宽心。太久没有她的消息，我都开始往最坏处想了。等北风领的麻烦平息，我就去看她。早就该去了。来，这些钱收下，算是我和艾瓦特的谢意。相信我，你为我们俩做的比你以为的要多。旅途中注意安全，$N。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41797) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41798, '哦，罗纳德，你的心地是好的，可你那份天真有时候实在麻烦。不管怎样，既然你来了，不妨帮我们一把。我叫薇罗娜·基里安特工，欢迎来到巴洛这个地狱。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41798) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41799, '霍恩比派你来的？那傻瓜心太软，对自己没好处。我领这份情，可这里发生的事，远比我被派到达文堡的任务严重得多。免谈。不过他说对了一点。你要是帮我做研究，我就能早些回到大陆去。那么，你说呢？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41799) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41800, '但愿你真让那些不安的灵魂得到了应有的安宁。死者就该安息，尤其是那些为族人浴血奋战过的人。$B$B不过……还是会让人琢磨，对吧？究竟是什么扭曲的东西钻进了那座墓穴，把一切都搅动了？那些迷雾里有什么黑暗的东西在作祟，我有种不好的预感——这事还没完。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41800) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41801, '我是谁？啊，你们凡人就是好奇。古往今来我有过许多名字，但你可以称我为萨尔斯伊斯鳞心。你闯进我的领地绝非偶然——不，这次相遇满是命运的痕迹。$B$B而恰好，凡人，我正需要帮助，而这种帮助只有你这样的人才给得了。龙竟要向朝生暮死之辈求助，真是奇特的时世。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41801) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41802, '黑暗仪式？受诅咒的矮人巫师？凡人，你说的是超出你理解的事。那不是普通的矮人——那是斯卡丁，一种扭曲可憎的异类，曾是矮人的亲族，却早已堕入黑暗。$B$B如果斯卡丁又一次行走在这片土地上，那只能说明一件事——格瑞姆巴托的大门再次被打开了。$B$B曾在那处受诅咒之地守夜的尊贵龙族守卫，如今已陷入疯狂，他们的心智被莫德古德残留的腐化击碎了。她的阴影再次伸展，要把世界重新染上污秽。这不只是威胁，凡人——这是灾难成型的样子。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41802) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41803, '现在你看到真相了，凡人——清楚得像冰封峰顶上的月亮。这名斯卡丁巫师必须被击倒，绝不能让他的邪术渗入这片土地的心脏更深。他出现在这里绝非偶然；他是更大黑暗的先行者，是长久被认为埋在石头与时光之下的诅咒的回响。$B$B不论是什么邪恶的目的把他带到冷酷谷，它都像一道伤口一样溃烂——若不加以制止，腐毒必将蔓延。这些本已被腐化堵塞的沼泽只是个开端。记住我的话：他编织的魔法不会止步于此。它会爬出冷酷谷……爬向丹基塔斯，甚至更远，毒害大地、天空，乃至卡兹莫丹的灵魂。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41803) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41804, '啊……果然只有红龙军团的灼热之吻才能斩断这等邪恶的巫术。$B$B斯卡丁的结界以大地与暗影那种脆弱的狡诈编织而成——对常规魔法确实坚固……可面对我那些赤红表亲原始而吞噬一切的怒火呢？$B$B我早该想到——对付钻得太深的害虫，火一向是答案。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41804) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41806, '龙火炸弹？哈——哈！这才对得上我的胃口！$B$B你找对侏儒了，朋友！奥格索普·奥布诺提斯为你效劳——化学家、工程师、兼职奥术机械理论家，以及全天候的一切「会轰的一声炸开」的东西的狂热爱好者！$B$B不——过，别急着高兴。当然，我能给你捣鼓出一枚龙火炸弹——我当然能！可眼下的情况是，我有点……这么说吧，装备不足。补给、试剂、防爆护目镜——常规的那些！$B$B所以！如果你准备搭把手，我们也许能一起创造一点小小的历史。一段非常具有爆炸性的历史。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41806) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41807, '＜奥格索普扶了扶护目镜，用夸张的精准度检视着材料。＞$B$B哦哦哦，没错！火药够劲，框架结实，那玩意儿转得也恰到好处。干得漂亮！这些完全够用——没有哑弹，没有锈迹，也没有奇怪的黏糊残留。永远是个好兆头！$B$B现在退后，朋友——退得远远的——准备见证工程学的辉煌成果吧！我这就打造……旷世之弹！$B$B……嘿。只是，呃——在我开始最后组装前问一句。你不是打算在镇上用吧？或者用在，比如说……我认识的谁身上？或者我身上？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41807) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41808, '你不在的这段时间，这里出了不少乱子。奇异的光，闪烁着不自然的色彩，从那座受诅咒的墓穴深处舞动而出。连空气都在奥术的不谐中震颤。地下那东西不管是什么……它正在变强。$B$B你回来了就好。我们没多少时间了。$B$B但愿那侏儒的装置——尽管乱来——再加上我族的神圣之火，足以镇压下面等待着的那个异类。若是不够……后果将远超这片丘陵。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41808) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41815, '这些能换不少钱。你那份在这儿。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41815) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41816, '我闻到空气里的血腥味。如今你把它穿在身上，像第二层皮。很好。把那些尾巴带来——我们拿它们开宴。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41816) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41817, '今天你的恐惧没能得胜。你的眼神变了，现在看上去平静多了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41817) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41819, '这卷轴的讽刺意味，我实在笑不出来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41819) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41821, '我会点亮一支火把，举行仪式，指引他们的灵魂前往来世。谢谢你让他们获得自由。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41821) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41823, '我谢过你——随这份谢意，还有一份报酬。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41823) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41824, '你把它的核心带来了？干得好。我现在就试着净化它。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41824) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41826, '没脑子的亡灵。有些不过是等着被砍倒的血肉；另一些则是那些曾经活着之人的残留本质——永远被困住。你完成了任务。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41826) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41827, '莫克甘的命运早已被古尔丹注定。他不是第一个，也不会是最后一个。安息吧，陌生人。我这个老流浪者与你、与你的族人无冤无仇。我是德拉克斯尔，曾是暴掠氏族的强大术士。如今我留在这里，只为确保我是我族中的最后一个。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41827) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41829, '很好。现在我要烧掉这些可憎的眼睛，让它们灵魂最后看到的东西，是他们应得的地狱火池。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41829) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41830, '我看出你身上血色，闻到你身上死气。干得好。现在，说别的事。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41830) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41831, '今天，你成了别人的报应。总有一天，属于你的报应也会找上你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41831) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41832, '你比谁都会打胜仗——我都想亲自挑战你试试。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41832) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41833, '哎呀，你瞧……一线阳光透了出来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41833) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41835, '离真正的目标又近了一步。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41835) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41836, '＜德拉克斯尔把箱子撬开。＞$B$B这是什么……？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41836) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41838, '这么说，布拉克斯比终究还是把活办成了。太好了。看你还挺精神，也许对我们有用——再说吧。到镇上转转，看看哪儿需要帮忙。但记住：什么都别碰！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41838) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41840, '什么……？这是什么？你在哪儿……？！不，不，不！提莫斯！我的小提姆，不！哦，圣光，你为何抛弃了我？！他还只是个孩子，我可爱无辜的孩子！$B$B＜朱迪丝崩溃了。此刻她能做的只有歇斯底里的哭喊。你已经尽力了。至少她现在有了确切的答案。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41840) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41843, '令人叹服。可惜你不适合做这一行。别误会，你具备所需的技艺与头脑，可我知道你那颗爱冒险的心无法被驯服，总向往着艾泽拉斯的壮阔。不过，军情七处欠你良多，让我为你的付出给出相称的报酬。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41843) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41845, '啊……从我躯体上卸下的重担正随之消散。重归完整之后，进入来世也许不再只是绝望的祈求。$C，我由衷感谢你。若不是你，我和许多其他人还会被锚定在生者的世界里。多亏了你，我的心终于能安歇了。请收下我仅存的实物之一，作为你应得的报酬。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41845) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41846, '啊，欢迎来到丹基塔斯，$N！说真的，看到新面孔出现在我们中间，我心里真是振奋。黑暗的日子无疑正在逼近，在前方的考验里，每一双手都至关重要。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41846) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41847, '瑟伦领主派你来的，是吗？$B$B＜游侠法埃莉娜仔细打量着你。＞$B$B既然他认为你配得上这项任务，那我就不该质疑他的判断。好吧。仔细听好，我接下来要说的事不能轻慢对待。这不是寻常差事，它的分量不该落在不懂其轻重的人耳里。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41847) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41848, '这么说……丹基塔斯的矮人们低声传说的那些故事终究是真的。有意思。不由得让人想，还有多少通往格瑞姆巴托的隐秘通道仍被埋在石头与时光之下……又有多少污秽之物曾从它们的阴影里爬出来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41848) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41850, '娜拉兹的宝石……等等——不对！你看它——它不应该是这样的！这只是它的一半，看见了吗？沿着这条边被干净利落地切开了！你没动过它吧？$B$B……不，不，当然没有。这切口太精准了，没有合适的工具——或者说本事——根本做不到。嗯……这下麻烦了，不过先别慌！我大致猜到另一半可能在哪儿。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41850) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41851, '铁趾……你说他被黑铁矮人袭击了？呸，我们之间争强好胜的时候多，难得有看法一致的时候，可这消息还是压得我心头沉甸甸的。但愿他找到了逃脱的路。$B$B不过现在没时间想这些了！宝石的另一半——正如古老文献里描述的那样！你干得漂亮，冒险者，真漂亮。谢谢你，谢谢你！我这就把它送到铁炉堡去。有了合适的人手和工具，它一定能恢复昔日的荣光！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41851) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41852, '逝去的同胞再也回不来了，但你让他们的牺牲没有白费。你找回来的这些遗物是无价的知识宝藏，它们必定会加深我们对土灵以及先祖遗产的理解。$B$B我谨代表探险者协会感谢你，$C。你为我们和我们的族亲出了一份大力。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41852) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41855, '以造物主之名，这消息太好了！采石场回到我们手里，我们就离夺回矿场、恢复失去的一切更近一步了！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41855) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41857, '啊！这才是干得漂亮，$R。我会知会我们的渔夫——多亏你的付出，那片水域现在该安全多了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41857) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41859, '＜你小心地在地上挖出一个小坑。把坠饰缠绕起来，你恭敬地把它放进新翻的泥土里，再覆上土，以敬逝者。艾尔文森林只静默了片刻，一阵暖风在树间低语，安宁随之降临。为维拉斯爵士、他的父母与诺特利爵士行过最后一礼，你静静伫立默哀，随后继续上路。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41859) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41860, '月语谷的今天多宁静啊，你不觉得吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41860) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41862, '又是一个联盟冒险者，是吧？$B$B很高兴知道铁炉堡没有彻底抛弃我们——不过我倒宁愿他们在事情变成这副惨状之前就派来援军。$B$B啊，别在意我这些牢骚。我不过是个身经太多战事、身边却缺少战士的老矮人罢了。$B$B我们有活要干，还要把龙喉送回土里去。别浪费时间了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41862) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41863, '哈！这下他们在露出那张丑脸之前得好好掂量掂量了。$B$B这么多龙喉横尸于地，应该能提醒他们什么叫畏惧蛮锤部族。他们人数少了，我们从丹基塔斯来的商队也许终于能喘口气。$B$B干得好。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41863) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41865, '干得漂亮！这一天的活儿干得漂亮——垂死的龙喉发出的惨叫，对我这对老耳朵来说就是音乐。$B$B他们人数锐减，堡垒也被清空，我们可以派一支像样的部队去夺回并重建了。你为冷酷海岸做的，比大多数人一辈子做的都多。$B$B斯托尔加兹城堡将再次升起蛮锤的旗帜，这全得谢你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41865) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41866, '干得好，$C！这些箱子到了我们手里，龙喉就得手忙脚乱地给他们的部队凑粮食和武器。$B$B这下谁也不能说加林·雷德布兰德没出过力了，是吧？……哪怕这份力是我借你之手出的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41866) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41867, '呃，这味道能把食人魔都熏倒！$B$B＜多萨斯皱着眉，小心地从你手里接过那些渗漏的样本。＞$B$B跟我想的一样恶心……可惜，也跟我需要的一模一样。$B$B＜他凑近细看，表情从好奇转为担忧。＞$B$B嗯。我就怕这样。这腐化比我想的更深、更复杂。我们面对的不只是生病的野兽——这背后有更大的东西。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41867) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41869, '哈！这才像话！你拿剑做成的，比那帮执法官嚷嚷好几年做的都多。$B$B你给了那些怪物应得的下场，也许——只是也许——我们又能安心走这条路了。$B$B谢谢你，朋友。我儿子会为你骄傲的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41869) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41871, '啊，好——又是一双结实的肩膀和一把锋利的刀。$B$B希望你一路顺利，在丹基塔斯过得舒心，不过恐怕这儿没什么闲工夫。有活要干，没时间浪费。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41871) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41872, '＜巡山人轻靴凑上前嗅了嗅那块肉，几乎是虔诚地叹了口气。＞$B$B以石头起誓！这味道……太美了！$B$B那个该死的锅呢？一部分炖，剩下的烤……也许再熏干了留着以后吃……啊，多少种做法！$B$R，你填饱的不只是一个肚子。你让整个哨站都振作了士气。相信我，那可比任何刀剑都值钱。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41872) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41874, '＜索尔甘双手接过那些破旧的典籍，拂去封面上积了数百年的灰尘，眼睛都睁大了。＞$B$B以造物主之名……我没想到还能再见到这些。这一本——巴戈斯的遗训！那是火望岭围城战的第一手记述！难以置信！$B$B你做的远不只是取书，$R。你帮我们找回了族人的灵魂。这些书够我啃上好几天了。$B$B谁知道我们还会重新发现多少往昔的秘密？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41874) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41875, '＜巡山人轻靴敲了敲其中一块砖，赞许地点点头。＞$B$B结实的石头……分量也足。等石匠们上手，这些一定撑得住。$B$B干得好，$R。你帮着守住了防线——眼下而已。愿这堵墙因你的付出多立些日子。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41875) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41876, '＜执法官硬掌捋着胡子叹气。＞$B$B恐怕没那么容易解决。萨尔加拉兹矿场被穴居人占了——那些肮脏的害虫——矿工都被赶了出来。$B$B没有矿石，锻炉就得熄火。而没有锻炉……这么说吧，我们的巡山人恐怕得拿着锈刀上阵了。$B$B我们得赶快想出办法。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41876) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41877, '＜纳兹戈林抱着胳膊专注地听着。片刻之后，一丝笑意冲破他严厉的表情。＞$B$B赫达姆·硬掌……这名字我有些年头没听过了。一头犟驴似的矮人——但是忠诚。我欠他的不只是几句话。$B$B再说，丹基塔斯的人们守住防线的时间比我们任何人预料的都长。要不是他们这股硬气，龙喉现在早该敲开铁炉堡的大门了。$B$B好。我会给公会传话。矿石归你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41877) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41878, '＜执法官赫达姆长长吐出一口气，多日来肩膀头一次放松下来。＞$B$B这么说他答应了……以圣光之名，可算松了口气。这能给我们争取到需要的时间。$B$B我会安排信使接第一批货。岩须的锻炉又能烧起来了，我们的守军也能拿到需要的钢材。$B$B朋友，你做的比你意识到的更多。丹基塔斯欠你一份情。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41878) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41880, '以先祖的胡须起誓，你做到了许多人以为不可能的事。$B$B他们死了那么多军官，冷酷海岸的龙喉战争机器很快就会瘫痪、坏死。$B$B为这场胜利庆祝吧，但要保持警惕——战争还没结束，还没。$B$B干得好，朋友。群山会记得。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41880) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41881, '＜巡山人轻靴撬开一只箱子，用手指捻着麦粒。＞$B$B嗯……是啊，我见过比这新鲜的麦子……不过还不赖。只有几袋发了霉。稍加处理，大部分都能用。$B$B＜他顿了顿，环顾四周，压低嗓音。＞$B$B不过……你也看到那地方变成什么样了，是吧？$B$B干得好，$R。这些麦子归我们，总比让那地方藏着的东西留着强。但要是我，就不会到处张扬你看见了什么。有些真相，埋着更好。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41881) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41883, '＜执法官赫达姆·硬掌仔细端详着那封信……＞$B$B看来龙喉氏族并不像我们原先以为的那样团结。这消息听起来让人宽心。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41883) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41885, '哈！瞧瞧你，连半口都没被啃掉！这趟清鳄鱼干得漂亮，朋友。$B$B也许我现在可以甩竿钓鱼，而不用丢脚趾、丢整条腿、或者丢掉脑袋了！$B$B……其实，最后那个当我没说。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41885) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41886, '你真的做到了？谢天谢地。眼下这该能让事情安全些——不过我还是不信外头这片安静。$B$B谢谢你的帮助。没几个人敢钻进那些蛛网里还能走出来的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41886) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41893, '＜索尔甘·握固慢条斯理地检视着那本书，猛然一拍，灰尘在图书馆里散得四处都是。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41893) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41894, '瞧瞧这小宝贝？多彩动力的涡轮增压好货！这东西能让我重新站起来。我凑了凑能拿出来的当报酬，不多，但希望够付。现在，滚吧，我还有活儿要捣鼓。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41894) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41895, '哎呀，你瞧这个，多带劲的脓液！这肯定能换不少钱。来，拿你那份……那份。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41895) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41899, '更多的腐化被净化了。每杀死一个黑根，我们就离洗净这深重诅咒的污秽更近一步。木喉感激你的付出。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41899) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41905, '你做到了！看到你平安无事，我也松了口气。有了这些东西，队伍就能继续前往他们的新家园了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41905) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41908, '粗糙原始，但无疑效力十足。$N，你今日无私的举动不会被忘记。村民们会听说的，这一点我保证。若你还能找到更多，别犹豫，带来给我。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41908) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41909, '＜赫加拉那双小眼睛睁大了，虽然只是稍稍大了一点。他张开的嘴几乎有些骇人，露出两排牙齿。＞$B$B珀雷什·托拉尔！扭曲虚空有福了！你带回来的东西令人惊叹，我找不到合适的话来表达谢意。$N，从今天起直到时间的尽头，每一个莫洛加人都会知道你的名字。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41909) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41910, '父亲派你来的？他居然把外来人交给我，真不像他。不过说实话，他最近也不太像他自己。那份背叛扎得太深了——长老在部族里深受爱戴，仅次于我的父亲。正因如此，他的所作所为才更加可鄙。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41910) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41911, '多么野蛮。图鲁，你怎么能？！他是个志向远大的猎手，心里装满高贵的抱负。对纳兰来说，他就像个弟弟……$B$B我本以为逃离垂死的故乡世界之后，我们至少能有一阵子免受危险。你也许会说，我太天真了，也许你没错。纳兰清楚自己要面对的风险——他离开村子的那晚就是这么告诉我的。他的决心令人敬佩。今天，莫洛加失去了一位伟大的猎手，和一位更伟大的朋友。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41911) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41912, '这是亵渎！他们对这块水晶做了什么？！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41912) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41913, '这些够了，即便你是个帕拉什卡，也证明了自己有用。酋长对你的信任实在奇怪得很，但我依然信任他的决定。那么，让我们揭开这块水晶上被施加了什么黑暗魔法。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41913) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41914, '堕落者被奴役了……不，他们竟与你们称作萨特的头角恶魔合作？难以置信，在我们的人民在德拉诺经历了那一切之后，布罗比怎么能这样践踏我们的传统？我认识的那位长老，绝不会容许外人巫师玷污德莱尼水晶。而如果这封信上写的是真的……那我的父亲知道的事，比他所敢承认的要多。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41914) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41915, '看来这些年我儿子成长了许多。又一件我该注意却没注意到的憾事。他比我以为的更早成了男子汉。$B$B阿尔莉亚说得对。哀悼与无所事事的日子已经结束。我们熬过了一场种族灭绝，可不能倒在自己族人发动的又一场里。举起你的手臂，$N。我们要让这个假先知闭嘴。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41915) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41918, '啊，我一直苦苦等待的丝线。现在它们到了我手里，我就能把这些绷带一同织进去，再注入一丝奥术魔法。我们的防卫者从此恢复得快多了。是哈拉内托你来取这些的？这狡猾的婆娘。别误会，她并非不可靠，只是……更机灵些。在我们德莱尼当中，她是个罕见的自由灵魂，她的聪慧与奇思总能让人耳目一新，有时更让人惊叹。我很高兴是她自愿为我们的伤员去收集丝线。$B$B你若再去南边的林子，请顺路到她营地看看。知道有人不时关心她的安危，我会安心些。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41918) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41919, '哈拉内做事周到。我们还住在德拉诺的时候，她常把各种奇特的动物和植物带回村子，其中许多后来成了美味的菜肴、强效的药方，或者祭祀用的香料。要说她借你当借口去探索这个陌生新世界的树林、满足自己的好奇，我一点也不奇怪。请别为此感到不快。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41919) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41920, '那是马甘的货？知道他平安无事，我真是松了口气。好几个时辰没他的消息，我开始担心他的安危。说来惭愧，部族已经不再团结，许多离群的族亲开始动起手来。可我们既要保命，他们又都是曾一起熬过德拉诺大迁徙的老朋友、亲爱之人。这一场灾难实在让人喘不过气，我只盼它早日结束。$B$B抱歉，我不该说这些。谢谢你帮了马甘；也请你随意些，就当在自己家。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41920) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41921, '你说什么？你是另一位德莱尼派来的，而且还是位裂隙行者？！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41921) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41922, '一块投影水晶……来自另一位德莱尼？！快，请把它交给我！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41922) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41923, '＜一股抚慰人心的低鸣从石头与神像之间传出，两者如今已同频共振。高处的坡道上，梦境传送门释放出一道能量波，随后是一声巨龙的长吼。你召来的东西，已经到了……＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41923) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41924, '＜一股抚慰人心的低鸣从石头与神像之间传出，两者如今已同频共振。高处的坡道上，梦境传送门释放出一道能量波，随后是一声巨龙的长吼。你召来的东西，已经到了……＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41924) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41925, '＜一股抚慰人心的低鸣从石头与神像之间传出，两者如今已同频共振。高处的坡道上，梦境传送门释放出一道能量波，随后是一声巨龙的长吼。你召来的东西，已经到了……＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41925) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41926, '＜一股抚慰人心的低鸣从石头与神像之间传出，两者如今已同频共振。高处的坡道上，梦境传送门释放出一道能量波，随后是一声巨龙的长吼。你召来的东西，已经到了……＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41926) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41927, '我看你回来了。是时候为卡拉赞的这一章画上句号了。黑骑士在他们可怖的统治期间夺走了足够多的性命；这一切到此为止。哨子既毁，就再没有人能取代黑林领主成为他们的下一个，他们终将消散在风中。做好准备，$N，我不知道我打碎这具恶意的化身之后会发生什么。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41927) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41928, '那些十字架，你拿到了！它们的圣光连这里都能感觉到。$C，净化这块石板刻不容缓。你也许不知道，天灾那些恶心的地穴领主正是用它们，以诱人的咒法驱使麾下成群结队的蛛魔，强化它们的能力。这东西必须立刻从世上消失。无论如何，保持警惕。我确信他们会报复，毕竟我们毁掉的是他们的一件珍贵圣物。$B$B做好准备！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41928) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41929, '＜你把所有东西摆上祭坛，诵读魔典中的咒语。随着每一句念出，空气越发沉重，闪电劈落天际。法力碎片炸裂，释放出强烈的冲击波。片刻之后，它上方裂开一道裂隙——从裂隙边界里，钻出一头可怕的虚空生物！＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41929) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41930, '你回来了，还带着卡尔什的坠饰。他的死令人痛惜，让我深感悲伤。眼看一位坚韧与力量的象征在如此短的时间内腐坏凋零，实在太可怕了。谢谢你把他从痛苦中解脱。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41930) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41931, '这些图腾比我想的更糟。它们散发的烟气令人难以忍受，光是触碰就在我的爪子上留下灼痕。我得先把它们封存起来，之后才能妥善处理。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41931) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41932, '这些物品的力量让我惊叹。有了那野兽的心脏，我们就能打破图腾周围的邪恶屏障。格拉蒙的舌头会让它们说出真话，净化之水会洗去一切污秽。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41932) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41935, '＜材料在手，你大声诵读符文。温暖仁慈的光芒笼罩了艾索雷葛斯的灵魂，随后他实体的身躯开始在那片覆满落叶的地面上显现。念完咒文之后，这条雄壮巨龙发出一声威猛的咆哮。＞$B$B你真是个轻信的傻瓜。你真以为我会把本族的强大宝物交给一个区区凡人？可笑！我的宝物只属于我，只属于我一人。作为你天真的奖赏，让我来展示一下蓝龙军团可以多么好客！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41935) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41936, '这股香气……这些瓶子里装着纯净、不掺杂质的能量。无论通过水晶裂隙被带进这个世界的会是什么，都毫无疑问是一头强大得无法估量的恶魔。$N，和你的盟友们做好准备；这绝非易事。打起精神来！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41936) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41938, '这些文字是卡利麦格语，元素的语言。懂得这门语言的人不多，更别说会说会读了。你来找我算是找对了，我确实能读懂上面的一些词。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41938) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41941, '生命的气息在这片泥土中流淌。有了它，就能滋养出丰饶的生命，也许还能恢复那些被认为永远失去的东西。贝瓦利派你去取回这些土壤，选对了人。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41941) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41948, '啊，南边的麻烦解决了。这些熊怪让我摸不着头脑。不久前他们还自顾自待着，几乎不与村子来往，直到他们开始动手、变得凶暴。时间上，大约就在那个叛徒布罗比离开村子前后。我希望这两件事没有关联……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41948) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41949, '表现精彩，帕拉什卡。你是德莱尼真正的盟友，真正的德莱尼。不过别高兴得太早。还有很多事要做。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41949) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41950, '又是那些可憎的水晶。看着我们的神圣德莱尼水晶被这样亵渎，我心中怒火难平。被污染、被破坏、被玷污。他们无论对它做了什么，都不可饶恕！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41950) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41951, '我确实对这些箱子多知道一些，不过我已经很久没见过实物的样子了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41951) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41952, '这么说，正是那些熊怪在头角恶魔与堕落者之间充当中间人。你说他们想把水晶送到山上那座通往赤褐悬崖的大洞穴去？我听说山下的隧道网络是他们的圣地藏身处。这预兆不妙。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41952) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41954, '确实是上好的皮料。这个世界的元素浸润了皮革，表面满溢着生机勃勃的能量，能让穿戴者战力大增。你在制皮之道上的造诣已经向我证明，你配得上我的传授。不过在此之前，还有一堂课与第二次试炼等着你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41954) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41955, '闪耀的鳞片、结实的皮革，还有丝滑的质感。这些多头蛇让我想起我们自己世界的野物，那是很久以前，德拉诺还蒙福有兽可猎的时代。我至今记得我们追踪一只稀有猎物的漫长狩猎，那个物种我们叫「罗鲁班」，用你们的话说就是「影迹」。我们追踪那头双头兽整整十个夜晚，最后在一片林间空地上遇上了它。它咬死了我们三名猎手，之后樊·德拉和我才将之斩杀，带着它完好无损的毛皮带回了家。酋长那里应该还留着我用那张皮做的斗篷。$B$B剥皮手艺出色，帕拉什卡。你对制皮之道的掌握绝非玩笑。如我所承诺，我会教你如何驾驭多头蛇的力量，并把它与你们世界的元素融合。再来和我说话，就开始你的课程。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41955) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41956, '绿爪已经无可救药了？而我们的同胞飞地正在为把冬泉部族从黑暗桎梏中解放出来而战？时间真的不多了。我们必须尽快行动，与其他木喉和解。$B$B$N，谢谢你为我们带来这一线希望。我会与其他人商议，但愿很快就能派一支小型使团去北边找我们的兄弟姐妹。不能让他们在这漫长黑夜里独自受苦。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41956) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41957, '好久不见，$N。我们听说了你在木喉要塞里的事迹，也永远感激你为我们族人所作的牺牲。你所做到的并非理所当然，换作别人，绝不会对一个不属于自己的种族表现出如此悲悯。现在告诉我，你来找我有什么事？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41957) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41958, '你果然来了。命运是我们无法掌握的力量；如果你还想否认自己的所作所为并非由命运注定，那我担心你要学的东西还有很多，凡人。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41958) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41959, '伊萨里奥斯这么想我吗？我感动得几乎要哭了。是什么变了，让那老傻瓜心甘情愿把凡人送到我的巢穴来？但愿他母亲不会听说这事。$B$B＜因索姆尼爆发出歇斯底里的狂笑。＞' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41959) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41960, '＜笑声在洞穴中回荡。像鬣狗一样，因索姆尼盯着贾姆瓦利的獠牙，发出不自然的咯咯笑声。＞$B$B报应不爽，贾姆瓦利。你以为在血神虚假的庇护下能保住性命，可你算错了。没有什么比得上我无人能敌的狡诈，叛徒。凡是胆敢违抗我绝对统治的，都是这个下场。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41960) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41961, '传说是真的。这么强大的遗物，本以为早已湮没在时光里。有了它，我……我确信我们能查明，究竟是什么邪恶在背后造成我族所遭受的一切苦难。$N，谢谢你一直相助，但还别歇着。我们还有很多事要做。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41961) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41962, '谈话结束，凡戈恩回到他永恒的守望中去了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41962) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41963, '干得好。既然东西都齐了，我就能从这颗橡实里提取一份祝福，让你能听懂自然本身的话语。不过要当心。法术不会永远持续，所以快点去找凡戈恩，脚步要稳。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41963) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41964, '＜听到你带来的消息，戈恩浑身发抖。他愤怒地低吼，露出尖牙，努力让自己镇定下来。＞$B$B佩洛斯阿恩。萨特领主萨维斯的副手。绝不会错。这块角碎片和枯喉的图腾有着同一种邪恶能量——恶魔精华与某种未知恐惧的恶心混合。如此压迫的存在，光是看着就已经是极度的亵渎。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41964) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41970, '那么，正如我担心的……$B$B＜智者托尔甘顿了顿，脸上满是悲伤与恐惧。＞$B$B愿他们的灵魂平安归于先祖。我但愿他们走得痛快、少受折磨。这些可怜人不过是来此地庆祝，却只遇上了暴行。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41970) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41972, '＜勇者之心展开信读了起来，先是好奇，随即脸上浮现出越来越明显的怒火与不悦，最后重重哼了一声。＞$B$B那条路一向凶险，可竟至于如此暴行？我一定会亲自与长者月蹄谈谈。这件事需要进一步调查，因为我们还不知道真正的袭击者是谁。德莱尼从没表现得如此露骨地好斗。$B$B我一定会让其他前往避难营的人都在我们防卫者的护送和看护下行动。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41972) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41973, '＜戈德纳克看着那封信，脸上露出笑容。＞$B$B扎尔万啊？有几个月没他的消息了，泰尔阿比姆那边乱成那样他还活着，真让我吃惊，难怪他想走。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41973) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41975, '啊，终于！我就知道能指望那头大块头牛头人！哦，当然也能指望你！$B$B现在我只要再等几天，就能离开这个臭水坑了，小子，你帮了我大忙。这笔钱能给我买一条全新的活法。一条不用守着水泵、不用冻裂手指的生活。轻松点吧！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41975) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41976, '太了不起了，我曾经无知地以为牛头人没有历史，只是像游牧者一样在平原上漂泊。这下彻底改变了我对他们的整体看法。$B$B你做得很好，冒险者，请收下这些钱，作为你完成这件勇敢而高尚之事的酬谢。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41976) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41979, '＜凯恩接过信，用严厉而凝重的目光读着。＞$B$B长角派你来是对的，这件事可能带来可怕的后果。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41979) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41980, '一封信，凯恩寄来的？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41980) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41981, '＜凯恩花了一会儿消化这些信息，手抚着下颌。＞$B$B风角峡谷。我确实从被驱逐的风角部族那里听说过那里出了乱子。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41981) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41983, '那是伊卡库鲁克？！我真没想到，一个陌生人才是钓上大月鱼的人。我都能想象帕努库基听到这事时的表情，多有意思！$B$B$N，你的到访真是让我高兴了一整天，也许是整整一周。我想用我的一个珍藏秘密来酬谢你。既然你是个钓鱼的行家，让我教你怎么制作属于自己的钓鱼包——在海上那些漫长日子里最完美的伙伴。这可是海象人文化中的要物！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41983) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41984, '这才叫像样的装备。多谢了，朋友。现在我可以好好放个假，做我这三十年来一直在做的事——只是换个地方做而已。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41984) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41985, '瞧瞧这漂亮玩意儿！外形流畅，上好的黑漆涂装，最重要的是——它开机的时候不会在我脸上炸开。多谢了，$N。现在应该再没什么能挡住我，去好好筹备诺格弗格的宴会了。$B$B来，这套烹饪器的图纸副本给你，多亏你及时救场。再次谢了，小子！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41985) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41987, '一阵混乱的瘴气在其中翻腾。要恢复它们的平衡需要些时间。你若还能取到更多，别犹豫，带来给我。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41987) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41988, '你好，在这儿见到一位部落成员真让人意外。是托妮兹特派你来的？我猜她那爱操心的性子倒也有意外的好处，我确实用得着你的帮忙。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41988) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41992, '即便被找了回来，最小的那个兄弟还是被排在最后。这不过是一个过于狂热、只顾追寻太阳之人一意孤行的结果。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41992) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41995, '你以更多的流血来偿还流血。别以为这就能抹去你的所作所为。但你至少还有那份决心去纠正自己的过错。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41995) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41997, '啊，我会把这个带去给旅店老板暖风。他有最完美的泡菜配方配这块肉，我敢打赌他还留着那套配方一起拿来的烈酒。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41997) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41998, '多美的蓝色，我想也是意料之中。这一整片区域似乎都偏爱这种颜色。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 41998) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42001, '退后，我要开始摆弄你连想都想象不到的力量了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42001) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42002, '闪亮的剑刃以不自然的光泽映着灼热的烈日。你越走近，掌中的寄生物几乎要把你的前臂扯断，拼命朝那柄剑伸去。你能感到滚烫的金属贴在皮肤上，触须操纵着你的手握住剑柄，发出嘶嘶声。你尖叫着，不顾一切剧痛，将剑刃从沙中拔出。疼痛很快就消失了，武器静静卧在你手中。$B$B「你把这出戏演得不错，虫子。但还有许多事要做。」' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42002) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42003, '材料在手，那个声音又一次对你说话。你已经习惯了它开口时带来的痛楚：$B$B「感觉如何，仆从？那压力。那黑暗。无尽深渊令人安心的拥抱。在广袤虚空之上投下的阴影深处，沉睡着真相与力量。等待被发掘，等待冲进你那个一无所知的世界。$B$B现在，拿起那枚钉子，把剑的名字刻进这不朽的金属：希尔弗拉尔。」' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42003) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42004, '你把四颗巨大的心脏呈上祭坛，随后用剑刃将之一一贯穿。鲜血喷涌而出，只在咸涩的海水中散开了一瞬。紧接着，龙血般的绿色黏液沿着你在剑身中刻下的符文流淌——直到渗入其中，让符文泛起病态的紫色光芒。随后，那些心脏开始扭曲变形，融入希尔弗拉尔，只留下那把脉动着的武器。$B$B「我们就要到了。」' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42004) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42006, '洞穴的严寒保住了匀矛的遗体，也止住了腐坏。可惜，你还是来晚了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42006) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42009, '一桩残酷的事已经做了。洛克塔娜格的身体会腐烂，重新与大地融为一体。我知道你所做的事让我们心情沉重，但那是必要的。假以时日，它们会再度出现，滋养自然的生长。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42009) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42010, '它们看上去像是被埋了千万年，可别被骗了。里面的水带着一种魔法特性，会让它们重新浮上地面，好再次拥抱月光。可冬泉谷的大雪太重，它们始终无法真正破土而出。你若有兴趣，我还可以告诉你，枭翼林当初叫「露拉瓦拉斯神殿」，是供奉伊露恩女神的地方。我或许已经不那么虔诚地奉行对她的信仰，但我依旧遵从她的恩典与裁决。$B$B好了，好了；我话太多了。我会修好这块符文石，作为谢礼，你可以随时用它来我这简陋的居所做客。请随意，这是我表达感激的方式。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42010) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42011, '我得承认，我错了。这块水晶不一样，肯定不是德莱尼水晶。谜团还在继续。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42011) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42013, '这么说他们真的先动了手？至少可以说是古怪。为什么偏偏是德鲁伊会不问缘由就先出手？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42013) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42016, '如此说来，我们的任务似乎到头了。你为我和我的人民做了件好事。这份善意我不会忘记。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42016) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42017, '我原本还有一半以为你会拿一颗科多兽的心脏来糊弄我，看来是我把你评判得太草率了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42017) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42020, '「我兄弟送的礼物。你走了很远的路才来到我这里；我由衷感激你。想到我兄长竟如此信任我的梦——这让我很高兴。我会让这件武器物尽其用。」' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42020) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42029, '＜乔拉齐以一丝不漏的目光检视着那把钥匙。他的手指沿钥匙齿一路抚过，年迈的男人忍不住发出一声怅然的笑。＞$B$B这若非最走运的巧合还能是什么。我相信你带来的东西能让我们做成一笔极有利可图的买卖，$N。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42029) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42030, '有意思。我此前就有所怀疑，但根据这些笔记，我们面对的东西比预想的要古老得多。看到它保存得如此完好，真是奇怪……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42030) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42031, '这么快就回来了？干得漂亮，$N。不过没时间歇息。我们已经查到重现那把古代精灵锁的图纸下落。它们被拆成两部分，各自落进一伙疯癫的狂热者手里。备好补给吧，年轻的盗贼，等着你的是更大的危险。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42031) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42032, '我谢谢你，$N。我本想再多送几个下炼狱去，可我既没有足够的人手，也没有时间去做这种私仇。眼下，这样也够了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42032) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42033, '太好了。这些图纸用的究竟是什么羊皮纸，让我百思不解。古代上层精灵文明一定辉煌得难以想象。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42033) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42034, '这才叫像样的报酬。现在等我一会儿，我好把手里的活干完。你带来的这东西可不是那么好读的……' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42034) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42035, '我很抱歉。看来我出的价钱还没能打动那位老贪财鬼。不过别发愁。就当这是一次独特的合作机会，能让我们的关系更进一步。再说，你不也为即将到手的心血回报而兴奋吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42035) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42038, '把那些巨魔都收拾掉了？多亏你的行动，铁炉堡又安全了一点点，现在我们总算能把注意力放到真正的威胁上了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42038) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42040, '＜拉尼克斯饶有兴致地盯着那块石板，眼里闪着光。＞$B$B就是这个，哇，我没想到你真能说到做到！你干得很好，既然我是这么出色又高尚的地精，我自然按你这份活的价值付钱。$B$B我很快就要离开这儿了，再次谢过。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42040) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42043, '有些看着破损得厉害，但应该都还能修复。干得好，$N。我们会确保它们安全送到夜歌谷，好让它们最终得到妥善归档。真的，谢谢你的尽心。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42043) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42044, '洛加纳收到我的口信了？真让人松了口气。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42044) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42045, '可这些离你的麻烦还远——暂时。你还只是个新手，一只被抛进这汹涌世界的小崽子。不过，你依然有你的用处。为矮人一族开启新的时代。去修习那些被禁的奥术之术，变得更强。去寻找我氏族的成员和其他强大的术士。有了他们的学识，国王不能不承认他需要我们才能拯救王国。$B$B我也许同样还在旅途的开端，但让我把自己摸索出的咒文与你分享。常回来找我，我们就彼此交换那些幽暗之术的心得。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42045) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42046, '好羽毛，你比我想的更能干。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42046) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42047, '你的活干完了，我的活开始了。我得把这地方收拾干净。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42047) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42048, '破土者雨角来抱怨？你一定是在开玩笑。我跟那位老太太解释过好几遍我们的处境。唉，我派一两头年轻公牛过去帮她就是了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42048) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42049, '大地之环的人断定月语海岸的神龛不安？还需要我去安抚它们？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42049) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42050, '我想知道公爵在你身上看到了什么。他的话语不可轻慢对待。被元素——尤其是有着那样头衔的一位——如此恭敬地对待，是极大的荣耀。去找洛特卡吧，你的下一个任务在等着。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42050) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42052, '在许多人看来，这或许毫无意义，而对许多人而言确实如此。这场猎龙并非出于某个兽人一时兴起的玩闹。这些龙原本是为守护而生，如今却要毁灭。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42052) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42054, '还要过许多个周期，你的蹄子才准备好踏上那条路，朋友。你的训练继续。等你积累了更多战斗经验，再来找我。$B$B虔诚信奉天界兄妹会让你超越部族的界限。大地母亲的眼与泪都眷顾着你。从今往后无论你走哪条路，至少他们中的一个会与你同在。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42054) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42055, '我一直在等你，年轻的血脉。$B$B来，我们谈谈。你缺一些必须学会的东西，而我教得了。但在那之前，我感觉到你心里有一股决心。努洛克可曾与你分享过他对洛修的热爱？很好。那么也让我分享我的。我偏爱安舍，也因此偏爱他们三位。安舍担起了兄长的角色。正是凭他的光，大地最初的儿女——比如我们——才得以诞生。$B$B他温润的光芒滋养我们的身体与庄稼。也正是同一道光，照亮夜空中的穆莎与洛修，因为若没有他的光，就看不见他们。不过，像任何一位兄长一样，安舍也会固执、也会评判，但他公正。他相信自己的路是对的，因为在他眼里，那是保护信徒与弟妹的路。一位既自私又仁慈的守护者，不是吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42055) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42058, '见到你真好。我们别再浪费时间了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42058) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42060, '你回来了。是时候为你的精神之旅翻开新的一章了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42060) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42061, '哦，感谢圣光。$B$B阿斯塔洛终于派人来了。好。很好。我都开始以为他……忘了。$B$B如你所见，这里一切都完全按计划进行。甚至可以说是完美。什么都没出问题。一点都没有。$B$B远征队……基本完好。其实是非常完好。我当然没有损失大半人马。那太荒谬了。$B$B就算我真的损失了——可我并没有——局面也依然完全在掌控之中。$B$B不过。你来了，这……让人安心。$B$B我在此地的任务对我们家族极为重要。事实上，至关重要。我只需要一点……协助。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42061) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42062, '你一定看到了。攥住这片土地的腐化。如今以此为家的那些扭曲生物。$B$B哨兵们不会让这份苦难继续下去。这片海岸是卡利姆多的一部分，绝不会被弃于黑暗。$B$B以誓言、以职责，我们将把正义带到这里。腐化被洗净之后，和平自会到来。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42062) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42063, '维拉娅送来的？哦……你不知道我等这个等了多久。$B$B我都开始以为她把我忘了。姑娘家能等的时间也是有限的，你知道的。$B$B＜伊瑞亚的笑容亮了起来，脸上的忧色褪去。＞$B$B真的谢谢你。这对我而言比你想象的要重要。我很快得给她回信。很快。$B$B你要是留夜，第一杯酒我请。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42063) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42065, '四十颗头颅。$B$B看着它们就这样摆着，多少让人安心了些。还不够，但总归有些。我们不过是在他们的数量上砍出一个小口，仅此而已。$B$B不过，这应该会让他们犹豫。恐惧比疼痛留存得更久，而当面对毫不留情的屠杀，他们并不是什么勇敢的生物。$B$B运气好的话，这就足以让他们在我们还驻留期间不敢试探我们的营地。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42065) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42066, '哦，这些东西效力十足。$B$B上面的魔法还活着。古老、精纯、危险。甚至可以说是异界的。而工艺……说实话，几乎让我感到怀旧。几乎。$B$B没错，这些东西很值得研究。若是问对人，或许还不止值这些钱。$B$B干得好，$C。你没白拿这份钱。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42066) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42067, '这么说……你真的找到了一块。$B$B没错。这种共鸣。隔着结界我都能感觉到。奥术纹样并不稳定，但并不混乱。这很少见。非常少见。$B$B你能活着把它带回来，做得很好。许多人做不到。$B$B有了这块碎片，德莱尼水晶也许终于会显露它的用途。或者证实我对它的担忧。两种结果都比一无所知要好。$B$B现在去歇着吧。我会立刻开始研究，小心地研究。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42067) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42068, '我们的人民经历过流放、背叛与缓慢的衰亡，却依然站立着。这一次我们也会挺过去。我相信这一点。我必须相信。$B$B话虽如此，仅凭信念无法带我们走过那处巢穴里等待的东西。傲慢已经让我们付出了足够的代价。$B$B这一次，只这一次，我承认：在这件事上，我身边需要一双稳当的手。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42068) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42070, '我明白这个请求有多紧急，也完全能体会月蹄家继承人的心情。若我处在他的位置，我想我也会这么做。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42070) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42071, '你带来了月语海岸的消息，还带着月蹄家继承人和我的一份托付？那就坐下吧，与我共享这袋烟，说说看。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42071) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42072, '这么说他们答应帮忙了。我得准备些东西答谢。等这一切结束，我会亲自去雷霆崖表达谢意。大地母亲知道，我父亲是不会去的。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42072) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42073, '你说的还不够多吗？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42073) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42074, '这么说，他已经向你说明了自己行事的缘由。他求助于你，也明白自己的过失可能以死亡收场。这些暂且够了，跟我说说这件遗物，还有你找到的那封信。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42074) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42075, '这样就好。让你的盟友靠得近些，接下来的事你一定用得上他们。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42075) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42076, '谢谢你，现在终于可以离开这该死的地方，回到我失去的家园去了。再会，部落的成员。但愿我们永不再相遇。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42076) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42078, '我明白。我不确定自己是否配得上这份宽恕，也不确定若换作是我，我会不会给出宽恕。我会接受惩罚，离开这个村子。是时候由别人来领导了。有了他新结交的盟友——包括你——他一定会做得比我好得多。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42078) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42080, '那就算两者都有吧，部落的成员。我这不合时宜的援手，该谢你什么？' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42080) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42081, '托尔甘派你来的，是吗？$B$B＜长者星行者烦躁地皱起脸。＞$B$B我想他说得对。尽管我很不喜欢把我们的处境这样公开摆出来。$B$B＜这头固执的牛头人重重哼了一声，既是不满，也不得不承认托尔甘或许说对了。＞$B$B好吧，他说得对，我们确实需要帮助。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42081) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42082, '＜长者星行者用苍老冷漠的目光审视着那些羽毛，逐一检查是否有瑕疵。＞$B$B嗯……不算完美，但也够用了。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42082) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42083, '＜星行者检查着那根法杖是否有裂痕与损伤，目光谨慎地扫过。＞$B$B看来我们躲过了一场糟蹋。那些小东西虽然粗野，倒还有点远见，不至于把落到手里的东西统统毁掉。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42083) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42084, '好久没经手过这样稀有的材料了。你做得很好，我没想到一位来到我们土地上的客人能有这份本事。$B$B看来我这个本地人得多向你们这样的外来者学学。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42084) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42086, '啊……是的。$B$B＜塔拉尼斯小心地拿起你找回来的其中一件物件，就着光缓缓转动。＞$B$B一把孩童的刻刀。看见这磨损的柄了吗？用了好些年。也许在好几个人手里传过。而这个……一枚月形吊坠。银做得粗糙，却很用心。大概是哪个正在学手艺的人做的。$B$B＜他轻轻吐出一口气。＞$B$B三十件来自一段被遗忘生活的小物件。这就是你给我带来的东西。你知道，历史不只有大战与君王。有时它就存活在普通人日复一日随身携带的物件里。谢谢你把这些寻回，$C。纳迦也许夺走了这座城镇，但他们抹不掉它的记忆。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42086) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42089, '三十片鳞。$B$B＜她戴着护手的手翻过其中一片，细看那深绿的色泽。＞$B$B这些属于久经沙场的老兵。杀掉这么多，他们的队伍里一定已经察觉。$B$B很好。$B$B不过……他们真正的首领还在。只要他们不倒，潮刃就不会放弃这些废墟。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42089) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42093, '啊，上好的羽毛。$B$B＜埃伦顿用指间捋过一根，试着它的韧度。＞$B$B看见沿羽轴的结构了吗？柔韧而坚实。这正是我们需要的。有了这些我就能做出一批像样的箭。下一次哨兵们朝林线齐射时，会感觉到这份差别。$B$C，我谢谢你。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42093) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42095, '月之林也落到他们手里了？$B$B我就怕会这样。$B$B这些夜晚森林一直躁动不安。根须该直着长的地方却扭曲起来。梦境飘进本不该有梦的林地。$B$B这腐化比单独一片林地要深得多。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42095) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42096, '你做了必须做的事。$B$B森林的呼吸已经顺畅了一些。$B$B但最初引发这腐化的德鲁伊们还在……而且他们中有一个在领头。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42096) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42097, '克罗西斯倒下了……$B$B当一位守护者死去，森林会哀悼，哪怕他迷失了方向。$B$B没有了克罗西斯的引领，那些腐化的德鲁伊会四散。有些人也许还会想起自己背弃的教义。$B$B另一些人则会跟着蛾幕陷得更深。$B$B这件事还没结束。若蛾幕真的再次行走在这片土地上，那么这些林地面临的危险，比大多数人所记得的都要古老。$B$B但眼下，森林的呼吸顺畅了一些。$B$B你做得很好。' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42097) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42098, '干得漂亮，$N。既然他们已被击退，我们就能加固阵地，防备日后的进攻！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42098) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42099, '打得漂亮，$N！既然他们已被打败，就会灰溜溜地跑回联盟的怀抱里。今天标志着我们辉煌的胜利！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 42099) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 55056, '了不起的人啊！这份欢乐究竟会释放出多大的力量，谁也说不准！' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `OfferRewardText_loc4` FROM `locales_quest` WHERE `entry` = 55056) x
                      WHERE x.`OfferRewardText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = IF(`OfferRewardText_loc4` REGEXP '[一-龥]', `OfferRewardText_loc4`, VALUES(`OfferRewardText_loc4`));

-- ---- RequestItemsText_loc4（5 条）----
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40051, '另请参见' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40051) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40052, '另请参见' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40052) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40053, '另请参见' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40053) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40054, '另请参见' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40054) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40055, '另请参见' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM (SELECT `RequestItemsText_loc4` FROM `locales_quest` WHERE `entry` = 40055) x
                      WHERE x.`RequestItemsText_loc4` REGEXP '[一-龥]')
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = IF(`RequestItemsText_loc4` REGEXP '[一-龥]', `RequestItemsText_loc4`, VALUES(`RequestItemsText_loc4`));

-- ======== 第二节：改写后重译（167 条） ========
-- ---- OfferRewardText_loc4（67 条）----
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 100, '多谢你，也多谢萨满们。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 755, '鹰风酋长派你来的？大地母亲祭仪可不是件小事……' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 773, '你在渴望通过大地母亲祭仪的过程中，展现出了十足的勤勉，$N。$B$B我们这些先祖之魂，代表着那些为建立并守护伟大雷霆崖而英勇献身的强大牛头人。我在此将守护的重任交付于你。$B$B你已通过了智慧祭仪，年轻的$C。带着骄傲走进雷霆崖吧。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 1789, '快点，$N，你若失败，等着救命的就不止一条人命。$B$B如果你没能帮上穆瑞顿和纳姆，就回来找我，我会再给你一个生命符记供旅途使用。$B$B别把我的援手当成单纯的施舍——你必须像其他任何一位$C那样证明自己的价值，接连的失败日后都可能记在你头上。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 5638, '很高兴你来了，$N。我们有很多事要谈，但更重要的是你在圣光之道上的修行。$B$B所有圣光的仆从都要学习一些课程。如果你准备好了，我们现在就来谈其中的一些。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 5647, '你有一名伟大$C的潜质，$N。继续保持！$B$B$N你已经证明自己可以上阵了。也许该教你点更多的东西了。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 5659, '啊，好极了，又来了一个。时间对我或许无关紧要，可对你而言却至关重要。你要学的东西很多，我想教给你的也不少。你只需证明自己的价值。做到了，你就会得到丰厚的回报。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 7462, '你打开箱子，看见……' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8101, '$R，这枚坠饰的框架里嵌着的石粒来自南海的卡亚罗山。卡亚罗山是一片极不稳定的区域——常有暴烈、往往还带着魔法力量的火山喷发。$B$B随着你与赞达拉巨魔的羁绊加深，这块石粒的力量也会增长。驾驭它的力量去击倒我们的敌人吧。要像那座山一样：迅疾、暴烈、致命……' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8110, '看到这些海藻了吗，老兄？它产自南海。我们只要加一点魔精和一点魔法，它就会具备最适合主人的属性。$B$B你是个$C，所以这很容易，老兄。只要把它挂在脖子上，想想大自然、松鼠，或者你们这类人喜欢的东西就行了。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8383, '你继续为联盟带来荣耀，$N。只要我们不松懈，部落很快就会被击垮。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8409, '啊，成功了！你展现了真正的万鬼节精神——应该说，是被遗忘者的精神！$B$B<黑暗召唤者雅恩卡搓着手大笑。>$B$B南海镇现在只能喝劣酒，或者干脆没酒喝，我为此乐不可支！至于你，收下这些礼物吧。我相信你会用得上！' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8678, '你的灵魂燃烧着生机，年轻的$C。我接受你的敬意，并回赠你这枚信物……' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8742, '流沙节杖重归完整，$N。$B$B使用节杖的人必须是你。为你的族人开启下一个时代的人，也必须是你。$B$B你必须等部落与联盟的军队抵达希利苏斯，才能敲响甲虫之锣。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8745, '你好，勇士。我是乔纳森，神圣之锣的看守者，也是青铜龙军团的永恒观察者。$B$B永恒之王亲自授予我权柄，让我从他永恒的宝库中挑选一件物品给你。愿它能在你对抗克苏恩的战斗中助你一臂之力。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8846, '那么，就这么定了；这是你的补给，$C。如果你想再换一次，我也可以批准。只要你说一声，我就办到。$B$B继续好好干，$N。要打赢这场仗，我们得凑齐所有能凑到的物资。只要人人都尽一份力，胜利就是我们的囊中之物！' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8850, '那么，就这么定了；这是你的补给，$C。如果你想再换一次，我也可以批准。只要你说一声，我就办到。$B$B继续好好干，$N。要打赢这场仗，我们得凑齐所有能凑到的物资。只要人人都尽一份力，胜利就是我们的囊中之物！' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8851, '那么，就这么定了；这是你的补给，$C。如果你想再换一次，我也可以批准。只要你说一声，我就办到。$B$B继续好好干，$N。要打赢这场仗，我们得凑齐所有能凑到的物资。只要人人都尽一份力，胜利就是我们的囊中之物！' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 8993, '太好了！太好了！我会把它加到其他礼物那一堆里去。$B$B没想到会有这么多！你一定是真心爱戴你的领袖。$B$B现在，让我再往总数里加上一个……' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 9238, '这是你的订单，$N。如约送达！' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 9257, '这伟大的成就绝对不能轻描淡写地过去，$N。你完成了大多数人认为不可能的事。唉，这是命中注定啊。法杖已经作出了自己的选择。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 9269, '这伟大的成就绝对不能轻描淡写地过去，$N。你完成了大多数人认为不可能的事。唉，这是命中注定啊。法杖已经作出了自己的选择。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 9270, '这伟大的成就绝对不能轻描淡写地过去，$N。你完成了大多数人认为不可能的事。唉，这是命中注定啊。法杖已经作出了自己的选择。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 9271, '这伟大的成就绝对不能轻描淡写地过去，$N。你完成了大多数人认为不可能的事。唉，这是命中注定啊。法杖已经作出了自己的选择。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 39977, '太令人欢喜了！好一股芬芳的香气……这茶一定独一无二，格外醇香。我已经等不及要看烟花再次以绚烂的光彩照亮夜空！$C，我永远感激你。为了你这份一丝不苟的用心，请接受我的祝福。珍惜此刻，也珍惜今后还有许多这样的时光——与你的朋友和所爱之人共度的时光！' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 39978, '真是壮观的景象！方才在我眼前绽放的光影表演简直美妙绝伦。你做得太好了；我由衷地、发自内心地感谢你。你已经证明自己勤勉可靠，请接受这份祝福，愿它为你过去的一年与即将到来的一年带来好运！' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 39979, '真是壮观的景象！方才在我眼前绽放的光影表演简直美妙绝伦。你做得太好了；我由衷地、发自内心地感谢你。你已经证明自己勤勉可靠，请接受这份祝福，愿它为你过去的一年与即将到来的一年带来好运！' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 40945, '我本以为会有某种解脱感，可说实话，我什么感觉也没有。你帮了我一个大忙，为此我感激你。$B$B也许不久之后，我就能从前方那些黑暗的日子里找到慰藉。请收下这个吧，我再也用不上它了。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41333, '＜瑟格雷恩饶有兴致地研究着那本书。过了一会儿，他点点头，把书放在桌上，转向你。你本能地跪下，随即感到他皮肤粗糙的质地。一股知识涌入你的脑海——切割一枚精致红宝石的技法。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41334, '＜瑟格雷恩饶有兴致地研究着那本书。过了一会儿，他点点头，把书放在桌上，转向你。你本能地跪下，随即感到他皮肤粗糙的质地。一股知识涌入你的脑海——精炼一枚帝王黄玉的技法。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41337, '不得不说，这是一本古怪的书。上面有一个古老的印记，我并不熟悉。真有意思……不管怎样，解读这本书对我而言不成问题。请稍等片刻，我会把从书页里能解出的知识告诉你。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41352, '这枚戒指……是我姑姑蒂莉亚的？不，这……不可能。姑姑从不与人分离她的首饰，只有她最珍视的人才会被赠予。难道说……？就连我从她那里偷走了她最心爱的项链之后……陌生人，你到底是怎么得到它的？！蒂莉亚几十年前去那座受诅咒的守护者之塔时就失踪了。$B$B这都不重要了。拿着你的小玩意儿走吧。对我来说反正都结束了，一枚昂贵的戒指能给我带来什么好处？卖掉它、戴着它，我都不在乎。就让我一个人待在我的痛苦里吧。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41395, '＜你把三块碎片放进那些空槽，随着一声轻响，下方弹开了一个盖子。里面是一颗普普通通的宝石。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41561, '伦恩图姆块茎！终于，我这部杰作的最后一样配料。快，给我。$B$B＜哈尔托格把根茎切碎，丢进蒸馏器。装置的高温把块茎迅速煮熟，把独特的风味融进酒液。酒液变成深金色的光泽，散发出你从未闻过的浓烈香气。＞$B$B啊哈，成功了！$N，我们做到了；我们酿出了完美的麦酒！等酒液冷却下来，你就是第一个尝到我毕生杰作的人！谢谢你，朋友。我们一起证明了，矮人并不像他们自以为的那样是所谓的麦酒大师！干杯！' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41568, '＜见到金色蛇麻草，坦多尔惊讶得睁大了眼睛。＞$B$B你找到了！你真的找到了！这是一生难遇的机缘，$N。只要撒上几小撮这种传奇蛇麻草，雷酒金色拉格就会成为终极麦酒。朋友，我感激不尽。凭着你的勇气与坚韧，我终于实现了家族百年来酿造完美麦酒的夙愿。让你第一个尝到我的毕生杰作，才算公平。等蒸馏器冷却、我打出第一杯，你就能尝到一杯配得上造物主的啤酒！' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41572, '上好的材料，真是出色。现在，拿一件这个，给自己做点不那么难看的东西吧。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41573, '上好的材料，真是出色。现在，拿一件这个，给自己做点不那么难看的东西吧。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41574, '上好的材料，真是出色。现在，拿一件这个，给自己做点不那么难看的东西吧。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41575, '上好的材料，真是出色。现在，拿一件这个，给自己做点不那么难看的东西吧。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41576, '上好的材料，真是出色。现在，拿这个，给自己做点不那么难看的东西吧。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41577, '多么可怕的景象。想想我们竟站在燃烧军团又一次入侵的边缘。$N，你和你同伴的所作所为不仅让艾泽拉斯免于又一场战争，还平息了我们所知最强大的恐惧魔王之一的威胁。他的威名仅次于七年前那场入侵的先驱提克迪奥斯，达拉然的六人议会中一直流传着他的传说。看到这样一位令人闻风丧胆的人物终于伏诛，实在难以想象。$B$B你把那颗邪恶的心脏带给我，做得对。我能够把邪能精华从它的血肉中烧尽，尽管这会让我身体极为吃力。但这只是很小的牺牲。只要能把这等污秽之物从我们的世界上除去，付出多少都不算多。剩下的东西你留着吧。当作战利品；当作你今日功业的纪念。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41651, '比兹邦·拉链匣？！这傻大个就是幕后黑手？说实话，当年在科赞，论工程学他的脑子算是灵光的一个，可我做梦也想不到他竟会这么记恨我。这比牛头人参加烧烤宴还让我摸不着头脑！更让我好奇的是你带来的那个装置。我会让技术员看看，说不定能破解那段一直响个不停的白色噪音。$B$B我得谢谢你帮了我这个忙。这里这么热闹，我几乎离不开这地方——真的是离不开。我的观众还等着我逗乐呢！来，这个当作报酬，你是我所有粉丝心目中的英雄！' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41653, '＜你跟那只青蛙说话，它的目光却飘向你身后的沼泽。要不是有人告诉你另有内情，你会以为它眼里什么都没有。可就在你快要放弃时，这具两栖的灵魂一次比一次鼓胀，随后爆发出一连串呱呱咯咯的叫声。你被震得发懵，脑海中涌满这个世界的景象，有些比另一些更为古老。等到那片「蛙鸣交响」结束，青蛙灵魂又恢复了原本的姿势，重新望向远方。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41654, '这些看上去真不错，$N！你的坚韧和身手让我佩服。真的，我以我列祖列宗之名，深深感谢你。现在，让我为所有人变出一场他们从未见过的盛宴吧！' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41655, '了不起，$N。你战胜了危险，以勇气和决心直面它们。这件信物就是你信念的凭证，也是你面对一切困难都愿意迎头上的证明。我相信，你今天已展现出机敏，你将以先祖的祝福铺就自己的前路。请收下这份对你功绩的馈赠。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41714, '＜拉尔文抓起材料放到面前。他飞快诵读书中的咒文，材料开始移动并猛烈汇聚，释放出一道强大的冲击波。留下的是一颗完美无瑕的水晶。＞$B$B该死的魔法，没起作用！恐怕我们需要更多能量才能打碎这些锁链。别发愁，我相信我们终会成功。作为你这些行动的补偿，请带上我们刚做出的那颗水晶。我确信它会在你的旅途中派上用场。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41743, '绝佳的选择。哪天你又想再来一局，我很乐意再试试你的胆识。不过现在，让我先歇一会儿。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41744, '绝佳的选择。哪天你又想再来一局，我很乐意再试试你的胆识。不过现在，让我先歇一会儿。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41770, '办成了。你已经向我证明了你的决心。你把这头如今已长成的暴掠龙照顾得多好，清楚得像天上的太阳。我相信它们也是这么想的。$B$B＜你的小家伙长得极好，如今已是一头成熟的暴掠龙。它依旧对你亲昵，用下颌蹭着你的脸，而它带毒的皮鳞却毫无反应：你已成功建立起对那致命毒液的抵抗力。＞$B$B你们的羁绊已深到极少有人能达到的地步。为这份成就自豪，并把它展现在世人面前吧。现在，让我把骑乘暴掠龙的秘诀教给你。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41771, '好一场狩猎。这应该能填饱它的肚子了——暂时而已。这些贪吃的幼崽整日都想要吃的，所以别拖太久再喂它。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41772, '厚实而沉，充满力量。我的族人素来有食用强健器官以强健体魄的习俗。你哪天也该试试，那感觉……让人亢奋。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41773, '血淋淋的，而且真够巨大。等时机到了，这些心脏能帮小家伙长成强壮结实的成年个体。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41785, '＜尼迪斯扎一看到恶魔之魂的碎片，就痛得缩起身子嘶声作响。仅仅是靠近它，就让他产生剧烈的反应。＞$B$B不可能，你居然找回了它，还敢把它带到我们面前？！我不知道你是鲁莽、残忍、轻信，还是三者兼有。但……你站在这儿……带着它……这意味着龙喉已经不在了。他们的酋长回归了轮回，他们的阴谋被挫败。而恶魔之魂回到了我们手中。即便被污染至此，我仍能感觉到女王仁慈的意志藏在其中某处，向外探触……$B$B$N，把碎片交给我，我会把它呈给我们的女王。只有她才能摧毁我们那段黑暗过往的最后残渣。作为给你的回报，我献上这些。这是你为阻止龙喉、终结恶魔之魂之恐怖而牺牲的应得奖赏。好好使用它，凡人。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41811, '终于，我好久没听过这样的寂静了，沙丘本身都安宁下来，我也一样……我的游荡到了尽头，也许是时候为自己寻找安宁了。谢谢你，旅人，你为这地方做了件大事。我献上我所能给的一点东西，愿它派得上用场。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41841, '瞧瞧猫儿拖进来什么东西。我还以为沃迪恩身子骨里至少还剩一丁点本事，看来是我大错特错。想不到我的一件器物竟逃过那些烦人的法师，落到暗影议会手里。真让人好奇……$B$B$N，坠饰回来了，我部下这帮倒霉事也就此了结。叛徒已被处理，我的遗物已收回，而你……你对该死之人的使用者的宝物给予了决定性一击，理应获得奖赏。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41854, '哈！没错，那是我的东西，石头一样千真万确！$B$B我还以为已经落到那些该死的黑铁矮人手里了——看来那帮可怜虫压根没脑子明白我这些笔记到底有多值钱！$B$B＜格罗尔丹一边翻着那堆东西，一边嘟囔着，把旧工具和杂物扔到一旁。＞$B$B我把它放哪儿了……呸，好东西总爱往破烂底下埋……啊！在这儿！$B$B来——把这些药水拿去。不算什么，但在外头应该能派上用场。就当是格罗尔丹·黑锻的一份正式谢意。可别拿去追兔子或者捅巨魔，听见没？' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41861, '＜瑞瑟乌斯喘着粗气。这场战斗让他精疲力竭。＞$B$B难以置信！关于你的传闻一点也没有夸大，你对塞纳留斯教义的掌握，清楚得像缀满星光的夜空！知道有你这样的能人站在我们这边，我们心里就踏实多了。我们向你和母亲许下的承诺，一定会兑现。来，接受绿龙军团的祝福吧。你完全配得上它。$B$B此刻，我们与你告别。母亲在翡翠梦境里等着我们，那里的战争仍在继续。我们在葱翠旷野中重逢的那一天，越早到来越好。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41873, '＜历史学家硬掌默默读着那本日记，皱着眉翻过最后几页。他缓缓吐了口气，然后重重合上书。＞$B$B嗯。我就觉得那边出了问题……可不是这种问题。$B$B布兰加曾是个骄傲的矮人。一个好农夫。不管究竟发生了什么，这都是场悲剧。$B$B＜他久久地看了你一眼。＞$B$B为了保全他的名声，我会……把最后这些记录从正式档案里略去。有些事，还是忘掉为好。$B$B谢谢你把它带来给我，$R。你为我们的历史做了件事，哪怕这件事并不光彩。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41937, '＜把坠饰呈给这位尊贵的灵魂时，一阵敬畏的颤栗顺着你的脊背而下。月语谷陷入寂静，四周暗了下来，你面前这头熊形身影在你眼中愈发清晰。就在那一刻，一个熟悉的声音在你脑海中响起：$B$B感谢你救了我的兄弟。荒野的长者们以此作为回报。$B$B在这位伟大灵魂的爪前放着几件饰物，想必是让乌索尔从痛苦中解脱的奖赏。谨慎选择吧。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 41940, '干得好，年轻人。我的直觉没错——这些核心内部藏着邪恶的能量，沸腾翻涌着怒火。只要它们的本质还绑在核心上，我就能安抚它们的心智，让它们从痛苦中解脱。它们会回到各自的元素位面，假以时日，再在艾泽拉斯苏醒。带着新的目标与洁净的灵魂。收下这些礼物中的一件，作为你为自然无私付出的报酬。请别推辞。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42005, '一手希尔弗拉尔，一手藤蔓碎片。你虽不情愿，还是把碎片放进剑面上那道凹槽。几乎立刻，那一小截木头就在剑刃中扎根，眼前的藤蔓随之向希尔弗拉尔伸来。它沿着你的前臂游走，把你拉近，同时缠住那只寄居着寄生物的手。藤蔓骤然发力，以骇人的力量把你的双手勒在一起，散出诡异的紫色烟气。你能感觉到寄生物的触须从你的脑中退去，经过手臂，从你手中钻出。$B$B这煎熬没有持续太久，藤蔓终于松开，你已然自由的手中躺着希尔弗拉尔——它与寄生物融合，泛着不自然的品红光芒。正如你掌中的声音所预言：它走完了自己的路。多亏了你。因为你的行动，它如今将去观察、去宣告自己的发现。向那个把它带进这个世界的存在。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42022, '为了你为熊怪一族所做的一切，你理应得到荣誉的奖赏：用净化过的皮毛亲手制作的一件合你心意的护甲，让你能在乌索尔的祝福下行走荒野，替他继续为他深爱的世界而战。只要你忠于我们的事业，我们的隐居地永远欢迎你。路上小心，$N。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42056, '你做得很好。为了纪念你的第一次试炼，我要把我的一件旧长袍赏给你。如我承诺的那样，让我来讲讲穆莎。我们最早的盟友之一是暗夜精灵，正如他们的名字所示，他们是黑夜的儿女，也因此是伊露恩的儿女——那是他们给穆莎起的名字。多年交往中，一些牛头人察觉到了一丝偏爱之意。若我们是大地母亲的儿女，那么暗夜精灵便是穆莎的儿女，她似乎更倾向于眷顾他们。这并不意味着她以任何方式忽视我们，但在某些信徒心中仍存着一丝嫉妒。$B$B事实上，这份关系帮助我们与暗夜精灵结下纽带、成为兄弟。可说得直白些，穆莎一向只是指路；你若愿意跟随，便跟随。你不需要任何解释；她也不会试图说服你。三者之中，她是最自由的。她的路是她自己的，你可以同行，也可以留在原地。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42079, '你是从那个以月之林为家、占据了土丘巢穴的恶魔手中夺回这个的？那么，纸上写着的东西只该由你一人去看。找个僻静的地方读吧。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42100, '这究竟是什么？！一整箱塞满的衣服、食物、玩具之类的东西？你在哪儿找到的，好心人？难道是阿隆索斯·法奥本人的奇迹，在帷幕之外看顾着他的信徒？不论是什么，我们都得感谢圣光又一次向我们证明：无私与正义之人不会被弃于黑暗。$B$B$N，我永远感谢你。现在，我不能再浪费时间了。穷人们还等着我。请从你找到的这些慷慨赠礼中拿走一份，你自己更该得到回报。愿圣光祝福你的旅程！' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 42101, '整整一箱食物、布料和器具？！这怎么可能？难道真是大地母亲的赐福？一定是！我简直不敢相信我们如此幸运。一次又一次得到证明，她供养着她的人民，也供养着终身敬爱她的人。$B$B$N，我必须由衷感谢你。有了你的帮助，我们还能筹办一场宴会，向她这份仁慈致敬。请从你为我们带来的这批丰盛之物中取走这份报酬。你完全配得上它。带着大地母亲的祝福去吧，$N。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);
INSERT INTO `locales_quest` (`entry`, `OfferRewardText_loc4`)
  SELECT 80745, '花灯已经飘远，把你的祝福带向世间。$B$B愿你在这次庆典中点起的灯光，为你和你所爱之人带来安宁与喜乐。$B$B请收下这些月饼，作为我们的谢意。' FROM DUAL
  ON DUPLICATE KEY UPDATE `OfferRewardText_loc4` = VALUES(`OfferRewardText_loc4`);

-- ---- RequestItemsText_loc4（100 条）----
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8107, '在赞达拉巨魔当中，荣誉要靠自己去赢得，$N。荣誉带来回报——友谊、同盟……$B$B把坠饰交给我，让我强化它的力量。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8108, '我随时可以为你效劳，$C。我会再次强化你的坠饰。我只要求你继续消灭哈卡和他的爪牙。$B$B把坠饰给我。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8142, '令人印象深刻，$N。你有杀戮的天赋，我多年没在别人身上感受到这种天赋了。连莫托尔都知道你为赞达拉做的事。是时候进一步强化你的坠饰了。把它给我。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8143, '我能感觉到，你已经让无数哈卡莱丧命，$N。你身上带着他们魔精的臭味。$B$B我猜那枚暗影坠饰在杀戮中出了力？把它交给我，让我强化它的力量。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8146, '即便在这里，我也能听见你的箭雨荡平敌人的声响。他们的惨叫回荡着满是痛苦。$B$B你已经在赞达拉的巨魔当中闯出了名号，$N。我们感激你所做的一切。$B$B把你的坠饰交给我，让我再织入一道。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8147, '啊，$N，能再次闻到你的气味真好。$B$B<法希尔咧嘴一笑。>$B$B请原谅我的幽默感，它有时实在粗俗。$B$B我能感觉到，你让我们的敌人痛苦万分。哈卡的军队正愤怒地呼喊着你的名字。这真是太好了。$B$B你又为你的坠饰赢得了一道编织。把它交给我。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 8742, '一千年过去了，正如命中注定，终于有人站在了我面前——一位将带领他的人民走向新时代的勇士。$B$B上古之神在颤抖，$N。是的，它畏惧你的信念。打破克苏恩的预言吧。$B$B它知道你会来，勇士——而与你同来的，还有卡利姆多的力量。你只需在准备好时告诉我，我便将流沙节杖赐予你。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9257, '我不能插手，$R。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9269, '我不能插手，$R。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9270, '我不能插手，$R。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9271, '我不能插手，$R。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 9343, '你为我们的事业出了大力，$N。如果你愿意，我可以把银色黎明的战袍交给你。有你这样的盟友，我们很骄傲。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40056, '接下那最后一桩差事，是我们的愚蠢……也是我们的劫数。要是我们当初没有无意中窃走封在护符里的瓦萨拉克领主之魂；要是我们那支佣兵团里没有那么几个贪心的人把它私自分掉。我今天还能活着，也许正仰头灌着啤酒，或者把孩子抛向空中玩。$B$B$N，别让旧日佣兵团里那些小人的贪婪也成了你的劫数。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40104, '$N？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40106, '＜那座石座看上去沉寂无声。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40114, '＜那座石座看上去沉寂无声。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40184, '＜希拉尔的残破尸身横在你眼前。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40259, '＜那铁砧的气势令人望而生畏＞。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40616, '$N。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 40974, '事情办妥了吗，$C？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41277, '＜这名石肤矮人轻易地无视了你，仿佛你不值得他浪费时间。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41278, '＜这名石肤矮人轻易地无视了你，仿佛你不值得他浪费时间。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41279, '＜瑟格雷恩继续做着他的手艺，没有理会你。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41280, '＜瑟格雷恩表情严厉地等着。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41281, '＜瑟格雷恩摆弄着几颗宝石。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41282, '＜看起来他完全停止动弹了。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41285, '＜塔尔瓦斯深深叹了口气。＞$B$B哦，我多愿意回到诺莫瑞根去啊！' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41302, '$N！怎么去了这么久？我还以为他们提前送你去来世了。那么，怎么样了？我安全了吗？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41304, '$N，你到哪儿去了？我的珠宝找到了吗？你把格里比留在哪儿了？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41305, '快点，$N！打造杰作急不得，可下一场拍卖只剩几天了！' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41307, '＜这侏儒似乎没在注意你。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41311, '小心行事，$N。如果这个恶魔从第三次大战中活了下来，那就绝不能小瞧他。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41326, '$N，你坐立不安。说吧，找到阿克·扎多尔了吗？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41333, '＜瑟格雷恩看到你，石头般的表情似乎变得欣喜起来。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41334, '＜瑟格雷恩看到你，石头般的表情似乎变得欣喜起来。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41335, '哦，$N！很高兴又见到你。说吧，这些日子过得可好？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41337, '哦，$N！很高兴又见到你。说吧，这些日子过得可好？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41340, '$N！大德鲁伊梦风告诉了我海加尔山发生的事。梦境碎片你带在身上了吗？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41349, '＜那堆泥土看着很可疑，几乎与周围格格不入。一件往昔的遗物，被岁月掩藏，从未被凡人之手触碰过。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41351, '$N！很高兴见到你。说说看，你的搜寻有收获吗？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41352, '＜比起上次见面，他看起来清醒了一些。＞$B$B谁在那儿？！我认识你吗？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41395, '＜上面有三个菱形凹槽。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41398, '＜那头巨大的雄鹿注视着你，让你心中充满敬畏。你正站在一位半神面前。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41451, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41452, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41453, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41454, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41455, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41456, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41457, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41458, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41459, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41460, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41461, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41462, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41463, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41464, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41465, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41466, '这些衣装似乎更契合你的本性。要小心你所拥有的力量，$C。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41567, '＜坦多尔正对着胡子嘟囔着含混的咒骂。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41577, '这股恶臭！$N，你带来了什么东西？！' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41642, '＜米拉贝尔沉在深深的祈祷中。＞$B$B哦，蒙福的圣光，请指引这只迷途的羔羊回到你的羊群。愿他的儿子不必承受孤独之苦，愿他与亲人和同伴重逢。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41643, '＜特工霍桑正在日记里记着什么。他表情严峻，陷入沉思之中。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41650, '＜眼前的景象只是引出更多疑问。你手上的线索不多，但有一条格外扎眼：插在侏儒胸口的血精灵匕首。你的推断是，你在这片区域西方路上遇到的那些血精灵出于某种未知原因伏击了这名侏儒。他们似乎在寻找什么，于是带走了侏儒的随身物品，还有他们没能找到的那只储物柜的钥匙。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41653, '＜那只青蛙专注地盯着你。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41659, '你的进展如何，$C？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41684, '$N？什么事让你来找我？你找到凶手了？！快说！' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41689, '＜那双圆圆的纽扣眼盯着你。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41694, '$N，你回来了？特工德里尔比你早到没多久，浑身上下都是重伤。我们已经送他回暴风城养伤。不过说说看，你查到什么了吗？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41705, '＜她嘴里逸出微弱的呜咽。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41707, '＜金里尔没怎么理会你。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41714, '快些，$N。我们不能再等了。自由只差一次召唤！' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41727, '我的仪式需要这些血液，拿到了吗，$C？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41731, '＜先知莫萨沉浸在共鸣之中。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41774, '＜合一之座完好无损，没有受到严重破坏。它因年岁而风化，覆满尘土。表面刻着古老的矮人符文，还有两个插着某种方形物件的槽位。一眼就能看出，某种古代机关需要放入特定的物品才能激活其中的魔法。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41777, '在她的论文里，阿兹苏妮推测奥术能量经过一段时间会自然聚合。不过，这个过程可以用一种不那么自然的方式加速。她写道：如果把两件倾向相同的法器调校到同一波能量上，它们最终会融合，生出全新的东西。我太想亲手试试了，这种心情难以形容。我们先从简单的东西开始；谁知道我们的举动会带来怎样危险的后果。按照这些咒文，我会试着把两枚璀璨的碎片凝聚起来，造出某种了不起的东西。$N，如果你能把这两枚碎片带来给我，我将不胜感激。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41790, '当心，$C。他是个可怕的敌人。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41840, '＜朱迪丝仍在抽泣。＞$B$B哦，萨拉，我亲爱的天使……以圣光之名，请保佑我的提莫斯平安……！' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41859, '＜这座坟早已被荒草覆盖，但十字架还大致完好。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41894, '我能为你做什么，$C？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41915, '＜酋长带着忧郁的神情望向地平线。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41922, '$N，很高兴在避难营又见到你。有什么我能帮你的吗？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41923, '＜这块石头与你手中的神像产生共鸣。它渴望与之同频，却无法独自做到。你越靠近那块覆满苔藓的石头，它试图刻进你脑海的字句就越清晰：莱索恩。也许某种梦境能量能提供所需的效力。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41924, '＜这块石头与你手中的神像产生共鸣。它渴望与之同频，却无法独自做到。你越靠近那块覆满苔藓的石头，它试图刻进你脑海的字句就越清晰：伊森德雷。也许某种梦境能量能提供所需的效力。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41925, '＜这块石头与你手中的神像产生共鸣。它渴望与之同频，却无法独自做到。你越靠近那块覆满苔藓的石头，它试图刻进你脑海的字句就越清晰：泰拉尔。也许某种梦境能量能提供所需的效力。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41926, '＜这块石头与你手中的神像产生共鸣。它渴望与之同频，却无法独自做到。你越靠近那块覆满苔藓的石头，它试图刻进你脑海的字句就越清晰：艾莫莉丝。也许某种梦境能量能提供所需的效力。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41928, '以圣光之名！你身上那股腐朽的瘴气是什么？$C，不管你身上带着什么，快交出来！$B$B＜石板被交给提里昂，他立刻对着那覆满蛛网的表面施了一道神圣法术。＞$B$B正如我担心的，这块石板上的防护诅咒太强，无法破除。我们需要以神圣之力为其祝圣。为此，来自狂热的血色十字军的圣十字架应该足够。反正这些圣物也不该落在他们那些污秽之手。$N，尽快把它们交给我！' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41929, '＜你在祭坛上发现的那本书里记着许多仪式与咒文。其中一个——想必就是教徒们眼下正在施行的法术——讲的是召唤：从扭曲虚空之外，召唤某种黑暗实体。所需之物是一件具备强大魔法特性的传导物，以及一些法器。你的思绪立刻回到那块法力碎片上。也许这才是它真正的用途？＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41932, '我的封印撑不了多久，$N。请你动作快些。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41934, '＜纳科格保持着祈祷的姿势。从他喉间粗重的低语中，你能听出他在唱一首仪式之歌。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41937, '＜这位伟大的灵魂以庄严的目光看着你。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 41964, '欢迎回来，$N。老凡戈恩那边有收获吗？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42005, '＜藤蔓正以不规则的节奏脉动着。它那令人作呕的外形在这片梦境中格格不入。＞' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42007, '$N！你回来了。请告诉我，匀矛在哪里？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42008, '快一点，$C。我的主上可不是以耐心著称的。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42021, '$N，我听说你一直在打击木喉要塞里的黑暗。看来我给你配的药膏不足以压制那股瘴气。别担心，我可以用几样材料重新配出药膏。把它们带给我，我们就继续对抗邪恶。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42034, '你是谁，为什么打断我的工作？你要是专程来烦我的，我就让你看看我的炉子到底有多热……$B$B＜你说明来意，并把材料和钱袋递给他。＞$B$B哦嚯，原来是这样。算是加急送货吧。我或许能帮上你，不过你要想尽快办成，这点金子可不够。若想在最短时间内完工，再给我一百金币，我会考虑考虑。成交吗？' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42039, '做好万全准备，$C，霜鬃巨魔是狡猾的敌人。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 42054, '是天界兄妹指引你迈出最初的一步来到我面前，$N。你在这里、在红云台地完成训练期间，将由我照看你，尽我所能教你。$B$B我相信你渴望亲眼看看这个世界，甚至想踏上前往月语海岸的朝圣之旅。月蹄村存有三卷祈祷卷轴，每一卷献给兄妹中的一位。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);
INSERT INTO `locales_quest` (`entry`, `RequestItemsText_loc4`)
  SELECT 55039, '这本典籍至关重要，请尽快行动，$R大师。' FROM DUAL
  ON DUPLICATE KEY UPDATE `RequestItemsText_loc4` = VALUES(`RequestItemsText_loc4`);

