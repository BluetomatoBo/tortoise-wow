-- 任务文本补译与清理（locales_quest）—— 中文槽里装着英文原文、占位符或未替换变量
--
-- 背景：库里有一批任务的中文槽（*_loc4）里放的不是中文，而是：
--   1) 英文原文——这些任务的 1.12.1 原生英文栏本来就是空的（官方 mangos-zero 库同样为空、
--      也没有官方中文），属后加内容，故按人工翻译处理；术语一律取库内既有译名；
--   2) 英文占位符/垃圾——「The details about this quest are missing」「Missing details」「TODO」，
--      以及被当成字符串写进去的 "NULL"（字面量，非 SQL NULL）。这些列在英文端本来就是空的，
--      清空后与英文端一致；
--   3) 未替换的变量——<Name>/<Class>/(NAME) 这类占位符（客户端只认 $N/$C）；
--   4) 中英混排——专名没译（Smokywood Pastures、Zend-Azshari…）、词尾粘连（Bristelfur开始闻…）、
--      误译（战利品海湾 = Booty Bay 应为藏宝海湾）。
--
-- 有意保留（不是缺陷）：
--   * 斜杠命令：/wave /soothe /cheer /dance（玩家要照着输入）
--   * 虚构语言短语：Ishnu-alah、Throm'ka、Lok-regar no'gal、Ande'thoras-ethil、Bwonsamdi
--     （库内惯例，与 Zug-zug 同类）
--   * 罗马数字：作战/后勤/战术任务简报 VIII（与物品名一致）
--   * 官方中文同样带 "DND FLAG" 前缀的标题（9378）
--
-- 全部语句带原值条件、可重复导入；生效：mangosd 控制台 `.reload locales_quest`

SET NAMES utf8mb4;

UPDATE `locales_quest` SET `EndText_loc4` = '拆弹剂沉入桶中，酒桶发出轻微的嘶嘶声。' WHERE `entry` = 280 AND `EndText_loc4` = 'The keg fizzles slightly as the Disarming Mixture settles in.';
UPDATE `locales_quest` SET `Objectives_loc4` = '在铁炉堡与贝尔杜克·凝眉交谈！' WHERE `entry` = 1794 AND `Objectives_loc4` = 'Speak to Beldruk Doombrow here in Ironforge!';
UPDATE `locales_quest` SET `Details_loc4` = '魔法物品被分解后，其力量就留存在它产生的精华之中。我摸索出了一种办法，能把附魔师用剩的原始精华转化成制作塞纳里奥植物药膏所需的材料。这用不着塞纳里奥信标；任何能分解出次级虚空精华的物品都可以。$b$b我只需要一份次级虚空精华，作为交换，我会给你塞纳里奥植物药膏。这种精华效力极强——一点点就管大用！' WHERE `entry` = 4107 AND `Details_loc4` = 'The power of a disenchanted magical item is felt by the essence it creates. I\'ve devised a way to turn raw essence used by enchanters into a suitable reagent for creating Cenarion plant salve. You don\'t need a Cenarion beacon for this; any suitably disenchanted item that yields lesser nether essences will work.$b$bI just need a single lesser nether essence; in exchange, I will give you Cenarion plant salves. The essence is extremely potent - a little definitely goes a long way!';
UPDATE `locales_quest` SET `Objectives_loc4` = '将1份次级虚空精华带给莫高雷的阿拉珊蒂丝·银空。' WHERE `entry` = 4107 AND `Objectives_loc4` = 'Bring 1 Lesser Nether Essence to Arathandris Silversky in Mulgore.';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = '你好，$R。有什么我能为你效劳的吗？' WHERE `entry` = 5623 AND `RequestItemsText_loc4` = 'Hello, $R. What can I do for you?';
UPDATE `locales_quest` SET `Details_loc4` = '我的部队补给已毕，随时可以出击。只等诺雷格·雷矛的命令，我就把他们投入战场！' WHERE `entry` = 6846 AND `Details_loc4` = 'My troops are supplied and ready to assault. We just need orders from Noreg Stormpike and I\'ll sent them into the fray!';
UPDATE `locales_quest` SET `Objectives_loc4` = '从诺雷格·雷矛中尉那里取得雷矛突击令，带回给特拉瓦雷元帅。' WHERE `entry` = 6846 AND `Objectives_loc4` = 'Get the Stormpike Assault Orders from Corporal Noreg Stormpike and bring it back to Field Marshal Teravaine.';
UPDATE `locales_quest` SET `Details_loc4` = '我的战士们急着要进攻！我只差突击令了……' WHERE `entry` = 6901 AND `Details_loc4` = 'My warriors are eager to attack! All I need are the assault orders...';
UPDATE `locales_quest` SET `Objectives_loc4` = '从亚斯拉·血矛那里取得霜狼突击令，带回给突击队长加瑞克。' WHERE `entry` = 6901 AND `Objectives_loc4` = 'Get the Frostwolf Assault Orders from Sergeant Yazra Bloodsnarl and bring it back to Warmaster Garrick.';
UPDATE `locales_quest` SET `Details_loc4` = '要当上世上最强壮的女人可得下大功夫！我的配重越来越轻了，想保持身材就得再加些重量！$B$B你能不能给我弄些平衡石来？弄来了，我就给你一张暗月马戏团奖券。' WHERE `entry` = 7889 AND `Details_loc4` = 'It takes a lot of work to be the strongest woman alive! My weight set is getting too light and if I\'m too stay fit then I\'ll need more weights!$B$BDo you think you could bring me to some weight stones? If you do, then I\'ll give you a Darkmoon Faire ticket.';
UPDATE `locales_quest` SET `Objectives_loc4` = '带给克莉·希克斯10块粗制平衡石。' WHERE `entry` = 7889 AND `Objectives_loc4` = 'Bring to Kerri Hicks 10 Coarse Weightstone.';
UPDATE `locales_quest` SET `Details_loc4` = '为了锻炼，我喜欢把一根长棍架在两块重砂轮之间，再把棍子举过头顶。这可不轻松，但像我这样当上世界最强女人，可不是坐着就能得来的！' WHERE `entry` = 7890 AND `Details_loc4` = 'To help with my workout, I like to fit a staff between heavy grinding stones, then lift the staff over my head. It isn\'t easy, but being the strongest woman in the world, like I am, can\'t be earned sitting down!';
UPDATE `locales_quest` SET `Objectives_loc4` = '你能帮帮我吗？我还需要更多砂轮——带些来，我就用暗月马戏团奖券跟你换。' WHERE `entry` = 7890 AND `Objectives_loc4` = 'Can you help me? I need more grinding stones - bring me some and I\'ll trade Darkmoon Faire tickets for them.';
UPDATE `locales_quest` SET `Details_loc4` = '我在做一套新行头，等我当上世界最强女人、有了自己的展台时穿！眼下我在找几副能戴的护腕。它们不能遮太多，因为大家想看我的肌肉，但我还是想露点颜色出来，你懂吧？' WHERE `entry` = 7891 AND `Details_loc4` = 'I\'m working on a new costume, for when I have my own booth as the strongest woman alive! Right now I\'m looking for some bracers I can wear. They can\'t cover much because people want to see my muscles, but I still want to flash a little color, you know?';
UPDATE `locales_quest` SET `Objectives_loc4` = '带给克莉3副绿铁护腕。' WHERE `entry` = 7891 AND `Objectives_loc4` = 'Bring 3 Iron Bracers to Kerri.';
UPDATE `locales_quest` SET `Details_loc4` = '为了表演世界最强女人的绝活，我打算收下观众递来的东西，再用一把巨型黑色锤把它们砸个稀烂！$B$B$N，你能给我做一把巨型黑色锤吗？' WHERE `entry` = 7892 AND `Details_loc4` = 'For my act as the strongest woman alive, I plan to accept items from the audience and smash them with a big, black mace!$B$BCan you make me a big black mace, $N?';
UPDATE `locales_quest` SET `Objectives_loc4` = '带给克莉·希克斯一把巨型黑色锤。' WHERE `entry` = 7892 AND `Objectives_loc4` = 'Bring to Kerri Hicks a big black mace.';
UPDATE `locales_quest` SET `Details_loc4` = '那些熊皮可以从灰谷或希尔斯布莱德的熊身上弄到。给我带一大堆来，就能挣一大把暗月马戏团奖券！' WHERE `entry` = 7900 AND `Details_loc4` = 'You can get those pelts from the bears of Ashenvale or Hillsbrad. Bring me a heap of them and earn yourself a heap of Darkmoon Faire tickets!';
UPDATE `locales_quest` SET `Objectives_loc4` = '孩子们都爱玩具！我发现，不管什么种族的孩子，都喜欢用破损的熊皮做成的毛绒玩具！' WHERE `entry` = 7900 AND `Objectives_loc4` = 'Children love toys! And now matter what race, I\'ve found that all children love furry, plushy toys made from torn bear pelts!';
UPDATE `locales_quest` SET `Details_loc4` = '靠过来，靠过来！如果你有暗月马戏团的奖券想要兑换，尽管开口吧！不同面值的奖券可以换到各式奇妙又精彩的奖品。不要害羞了，来试试看吧！' WHERE `entry` = 7932 AND `Details_loc4` = 'Step right up, step right up! If you have tickets from the Darkmoon Faire you\'d like redeemed, then just say so! You can redeem tickets in various denominations for wondrous and fantastic prizes. Don\'t be shy, give it a try!';
UPDATE `locales_quest` SET `Objectives_loc4` = '用12张暗月马戏团奖券兑换一份中级暗月奖品。' WHERE `entry` = 7932 AND `Objectives_loc4` = 'Redeem 12 Darkmoon Faire Prize Tickets for a Lesser Darkmoon Prize.';
UPDATE `locales_quest` SET `Details_loc4` = '靠过来，靠过来！如果你有暗月马戏团的奖券想要兑换，尽管开口吧！不同面值的奖券可以换到各式奇妙又精彩的奖品。不要害羞了，来试试看吧！' WHERE `entry` = 7936 AND `Details_loc4` = 'Step right up, step right up! If you have tickets from the Darkmoon Faire you\'d like redeemed, then just say so! You can redeem tickets in various denominations for wondrous and fantastic prizes. Don\'t be shy, give it a try!';
UPDATE `locales_quest` SET `Objectives_loc4` = '用50张暗月马戏团奖券兑换去年的羊肉。' WHERE `entry` = 7936 AND `Objectives_loc4` = 'Redeem 50 Darkmoon Faire Prize Tickets for Last Year\'s Mutton.';
UPDATE `locales_quest` SET `Details_loc4` = '我也不需要别的了，不过……如果你能从东瘟疫之地的蝙蝠身上再弄些邪恶的蝙蝠眼给我……我这儿也许还有更多暗月马戏团奖券。' WHERE `entry` = 7943 AND `Details_loc4` = 'I don\'t need much else, but... if you bring me more evil bat eyes from the bats of the Eastern Plaguelands... I might have more Darkmoon Faire tickets for you.';
UPDATE `locales_quest` SET `Objectives_loc4` = '$N，我正在设计的展项会是自诺莫瑞根陷落以来最吓人的玩意儿！这多亏了你，还有你给我带来的这一个个小玩意。太感谢你了，非常感谢！' WHERE `entry` = 7943 AND `Objectives_loc4` = '$N, the attraction I\'m designing will be the scariest event since Gnomeragan was overrun! And it\'s largely thanks to you and all the baubles you\'ve brought me. Many, many thanks!';
UPDATE `locales_quest` SET `Details_loc4` = '靠过来，靠过来！如果你有暗月马戏团的奖券想要兑换，尽管开口吧！不同面值的奖券可以换到各式奇妙又精彩的奖品。不要害羞了，来试试看吧！' WHERE `entry` = 7981 AND `Details_loc4` = 'Step right up, step right up! If you have tickets from the Darkmoon Faire you\'d like redeemed, then just say so! You can redeem tickets in various denominations for wondrous and fantastic prizes. Don\'t be shy, give it a try!';
UPDATE `locales_quest` SET `Objectives_loc4` = '用1200张暗月马戏团奖券兑换暗月护符。' WHERE `entry` = 7981 AND `Objectives_loc4` = 'Redeem 1200 Darkmoon Faire Prize Tickets for an Amulet of the Darkmoon.';
UPDATE `locales_quest` SET `Details_loc4` = '召唤你的恶魔吧，术士。让它们沐浴在科赞玷污的能量之中。在战场上指挥它们！歼灭敌人！$B$B没错……是时候给科赞的玷污施加最后的强化了。把护符给我。' WHERE `entry` = 8109 AND `Details_loc4` = 'Call forth your demons, warlock. Let them bask in the energy of Kezan\'s Taint. Command them on the field of battle! Decimate the enemy!$B$BYes... The time has come to apply the final enhancement to Kezan\'s Taint. Give me the talisman.';
UPDATE `locales_quest` SET `Objectives_loc4` = '把科赞的玷污交给全知者阿塔比姆。' WHERE `entry` = 8109 AND `Objectives_loc4` = 'Give Kezan\'s Taint to Al\'tabim the All-Seeing';
UPDATE `locales_quest` SET `Objectives_loc4` = '再与祖达萨的梅维克谈一次。' WHERE `entry` = 8116 AND `Objectives_loc4` = 'Talk again to Maywiki of Zuldazar.';
UPDATE `locales_quest` SET `Details_loc4` = '沙蒙！梅维克开个玩笑！$B$B<梅维克大笑。>$B$B这么说，你一直在用圣灵和元素对付我们在祖尔格拉布的敌人，是吧？赞美圣灵！$B$B梅维克要让你的宝珠亮起来。拿来吧，雷夫斯。' WHERE `entry` = 8117 AND `Details_loc4` = 'Sha-mon! Maywiki make a joke!$B$B<Maywiki laughs.>$B$BSo, you been using the spirits and elements against our enemies in Zul\'Gurub, eh? Spirits be praised!$B$BMaywiki gonna brighten your orb. Give it here, Leifs.';
UPDATE `locales_quest` SET `Objectives_loc4` = '把巫毒幻象交给祖达萨的梅维克。' WHERE `entry` = 8117 AND `Objectives_loc4` = 'Give the Vision of Voodress to Maywiki of Zuldazar.';
UPDATE `locales_quest` SET `Details_loc4` = '那蠍血可真好用，$N！只要一点闪光发亮的东西，就能把一件废品变成抢手的小玩意，真是奇妙。客人们都爱这口，而爱才是一切的根本，你不觉得吗……$B$B你可帮了我大忙，$N，虽说我并不太需要更多发光的蠍血，但你要是再带来，我照样用奖券跟你换。' WHERE `entry` = 8223 AND `Details_loc4` = 'That scorpid blood is working out great, $N!  It\'s amazing how a little sparkle and shine can create a prized bauble out of an otherwise piece of junk.  The patrons love the stuff, and love is what it\'s all about, don\'t you think...$B$BYou\'ve been a big help to me, $N, and although I don\'t have a great need for more glowing scorpid blood, if you bring me more then I\'ll still trade you some tickets.';
UPDATE `locales_quest` SET `Details_loc4` = '你已经证明自己完全有能力对付深渊公爵了，$N。我一向乐意鼓励好习惯。再给我带些徽记来，我就给你一份奖励。' WHERE `entry` = 8363 AND `Details_loc4` = 'You\'ve shown you\'re more than capable of taking on an Abyssal Duke, $N.  I\'m always one to promote good habits.  Bring me more signets and I\'ll give you a reward.';
UPDATE `locales_quest` SET `Details_loc4` = '勇士。如果你决定另走一条路，就带着你的徽记之戒，以及一大堆从安其拉敌人身上取得的甲虫来见我。' WHERE `entry` = 8764 AND `Details_loc4` = 'Champion. should you decide to walk another path, present me with your signet ring and a mountain of scarabs from our enemies in Ahn\'Qiraj.';
UPDATE `locales_quest` SET `Details_loc4` = '勇士。如果你决定另走一条路，就带着你的徽记之戒，以及一大堆从安其拉敌人身上取得的甲虫来见我。' WHERE `entry` = 8766 AND `Details_loc4` = 'Champion, should you decide to walk another path, present me with your signet ring and a mountain of scarabs from our enemies in Ahn\'Qiraj.';
UPDATE `locales_quest` SET `Details_loc4` = '你一定是做了什么很对不起我们或我们朋友的事，$N。不管怎样，我这儿有条路子，能让你重新讨得我们的欢心。$B$B你也知道，冬泉谷冷得很。我们这么多哥布林都是从别的城市来的，正缺人帮忙取暖。给我带些符文布和煤块来，我就替你说句好话。不过先提醒你，我们的敌人可不会乐意看到你帮我们。' WHERE `entry` = 9266 AND `Details_loc4` = 'You must\'ve done something really bad to us or our friends, $N.  At any rate, I\'m here to offer you a way to get our good graces back.$B$BAs you know, Winterspring is quite cold.  With so many of us goblins coming from other cities, we could use a hand keeping warm. Bring me some runecloth and coal and I\'ll put in the good word for ya.  Be warned though, our enemies are not going to take kindly to your helping us.';
UPDATE `locales_quest` SET `Details_loc4` = '你想重新跟塔纳利斯的哥布林交朋友吗，$N？我们正缺做船帆和火炮的材料，好对付我们的老对头——血帆海盗。给我带些魔纹布和强效助熔剂来，我们就开始考虑赦免你的过失。' WHERE `entry` = 9268 AND `Details_loc4` = 'You seek to befriend the goblins of Tanaris once again, <name>?  We\'re in need of materials for sails and guns to fight off our old enemies, the Bloodsail Buccaneers.  Bring me mageweave and strong flux and we\'ll be on our way to pardoning your trespasses.';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = '巴拉达什。' WHERE `entry` = 40514 AND `RequestItemsText_loc4` = 'Bala dash.';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = 'Lok\'tar ogar！' WHERE `entry` = 41834 AND `RequestItemsText_loc4` = 'Loktar ogar.';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 1709 AND `Details_loc4` = 'TODO';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 1711 AND `Details_loc4` = 'TODO';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 7421 AND `Details_loc4` = 'The details about this quest are missing';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 7422 AND `Details_loc4` = 'The details about this quest are missing';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 7423 AND `Details_loc4` = 'The details about this quest are missing';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 7425 AND `Details_loc4` = 'The details about this quest are missing';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 7426 AND `Details_loc4` = 'The details about this quest are missing';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 7493 AND `Details_loc4` = 'Missing details';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 7497 AND `Details_loc4` = 'Missing details';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 7657 AND `Details_loc4` = 'The details about this quest are missing';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 7658 AND `Details_loc4` = 'The details about this quest are missing';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 7884 AND `Details_loc4` = 'The details about this quest are missing';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 7896 AND `Details_loc4` = 'The details about this quest are missing';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 7941 AND `Details_loc4` = 'The details about this quest are missing';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 7942 AND `Details_loc4` = 'The details about this quest are missing';
UPDATE `locales_quest` SET `Details_loc4` = NULL WHERE `entry` = 8116 AND `Details_loc4` = 'NULL';
UPDATE `locales_quest` SET `Objectives_loc4` = NULL WHERE `entry` = 1709 AND `Objectives_loc4` = 'TODO';
UPDATE `locales_quest` SET `Objectives_loc4` = NULL WHERE `entry` = 1711 AND `Objectives_loc4` = 'TODO';
UPDATE `locales_quest` SET `Objectives_loc4` = NULL WHERE `entry` = 7421 AND `Objectives_loc4` = 'The description of this quest is missing';
UPDATE `locales_quest` SET `Objectives_loc4` = NULL WHERE `entry` = 7422 AND `Objectives_loc4` = 'The description of this quest is missing';
UPDATE `locales_quest` SET `Objectives_loc4` = NULL WHERE `entry` = 7423 AND `Objectives_loc4` = 'The description of this quest is missing';
UPDATE `locales_quest` SET `Objectives_loc4` = NULL WHERE `entry` = 7425 AND `Objectives_loc4` = 'The description of this quest is missing';
UPDATE `locales_quest` SET `Objectives_loc4` = NULL WHERE `entry` = 7426 AND `Objectives_loc4` = 'The description of this quest is missing';
UPDATE `locales_quest` SET `Objectives_loc4` = NULL WHERE `entry` = 7493 AND `Objectives_loc4` = 'Missing details';
UPDATE `locales_quest` SET `Objectives_loc4` = NULL WHERE `entry` = 7497 AND `Objectives_loc4` = 'Missing details';
UPDATE `locales_quest` SET `Objectives_loc4` = NULL WHERE `entry` = 7884 AND `Objectives_loc4` = 'The description of this quest is missing';
UPDATE `locales_quest` SET `Objectives_loc4` = NULL WHERE `entry` = 7896 AND `Objectives_loc4` = 'The description of this quest is missing';
UPDATE `locales_quest` SET `Objectives_loc4` = NULL WHERE `entry` = 7941 AND `Objectives_loc4` = 'The description of this quest is missing';
UPDATE `locales_quest` SET `Objectives_loc4` = NULL WHERE `entry` = 7942 AND `Objectives_loc4` = 'The description of this quest is missing';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 1191 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 1271 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 1559 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 1682 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 1693 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 1709 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 1711 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 1793 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 1794 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 5261 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 7886 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 7887 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 7888 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 7921 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 7922 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 7923 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 7924 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 7925 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8101 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8110 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8266 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8267 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8268 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8269 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8273 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8316 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8376 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8377 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8378 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8379 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8380 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8381 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8382 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8741 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = NULL WHERE `entry` = 8745 AND `RequestItemsText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 972 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 1191 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 4110 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 4112 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 5889 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8192 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8196 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8222 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8223 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8243 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8246 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8249 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8271 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8272 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8273 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8316 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8324 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8333 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8342 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8363 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8364 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8376 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8377 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8378 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8379 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8380 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8381 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8382 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8741 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8742 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8743 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8745 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8751 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8756 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8764 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8765 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8766 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8846 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8850 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8851 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 8853 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 9032 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 9142 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 9259 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 9266 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 9268 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 9269 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 9271 AND `EndText_loc4` = 'NULL';
UPDATE `locales_quest` SET `EndText_loc4` = NULL WHERE `entry` = 9338 AND `EndText_loc4` = 'NULL';
UPDATE `locales_creature` SET `subname_loc4` = '兽人，男性' WHERE `entry` = 10783 AND `subname_loc4` = 'Orc, Male';
UPDATE `locales_item` SET `description_loc4` = NULL WHERE `entry` = 5949 AND `description_loc4` = 'NYI';
UPDATE `locales_broadcast_text` SET `male_text_loc4` = NULL WHERE `entry` = 10116 AND `male_text_loc4` = 'asdasd';
UPDATE `locales_quest` SET `Details_loc4` = '几周前，我派出了守夜人考拉哈恩和其他一些人到暮色森林北部边境，以应对狼的侵袭。我已经有一段时间没有听到他的消息了。如果他按照我的指示去做，他将在夜色镇以北的道路上扎营。如果你正好路过，去看看他，转告他我在等他的进度报告。' WHERE `entry` = 236 AND `Details_loc4` = '几周前，我派出了看守卡拉汉（Watcher Callahan）和其他一些人到黄昏森林北部边境，以应对狼的侵袭。我已经有一段时间没有听到他的消息了。如果他按照我的指示去做，他将在黑暗郡（Darkshire）以北的道路上扎营。如果您正在途中，请检查他并通知他我正在等待他的进度报告。';
UPDATE `locales_quest` SET `EndText_loc4` = '带领图加前往托尔塔' WHERE `entry` = 1560 AND `EndText_loc4` = '带领Tooga前往Torta';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = '啊，这些对研究来说已经足够了。干得好，$N!
UPDATE `locales_quest` SET `RequestItemsText_loc4` = '你好，$C。以银色黎明的名义，我在冰风营地这里保护你的安全。我也许有些工作要让你去做……' WHERE `entry` = 6028 AND `RequestItemsText_loc4` = '你好，<Class>。以银色黎明的名义，我在冰风营地这里保护你的安全。我也许有些工作要让你去做……';
UPDATE `locales_quest` SET `Details_loc4` = '冬幕节快乐，我的朋友！你一定要去冬天爷爷打个招呼！如果你今年表现的不错的话，你会在冬幕节那天收到一份很棒的礼物。你一定要告诉冬天爷爷你今年想要什么！$B$B另外，记得多买些好东西来给那些今年表现得好的人。我们这里货物齐全。各种货物一应俱全——这是烟林牧场精心为您准备的货物！' WHERE `entry` = 6961 AND `Details_loc4` = '冬幕节快乐，我的朋友！你一定要去冬天爷爷打个招呼！如果你今年表现的不错的话，你会在冬幕节那天收到一份很棒的礼物。你一定要告诉冬天爷爷你今年想要什么！$B$B另外，记得多买些好东西来给那些今年表现得好的人。我们这里货物齐全。各种货物一应俱全——这是Smokywood Pastures精心为您准备的货物！';
UPDATE `locales_quest` SET `Objectives_loc4` = '和冬天爷爷谈谈；他在奥格瑞玛烟林牧场商人区旁边。' WHERE `entry` = 6961 AND `Objectives_loc4` = '和冬天爷爷谈谈；他在奥格瑞玛Smokywood Pastures商人区旁边。';
UPDATE `locales_quest` SET `Objectives_loc4` = '和冬天爷爷谈谈；他在奥格瑞玛烟林牧场商人区旁边。' WHERE `entry` = 7021 AND `Objectives_loc4` = '和冬天爷爷谈谈；他在奥格瑞玛Smokywood Pastures商人区旁边。';
UPDATE `locales_quest` SET `Details_loc4` = '冬幕节快乐，我的朋友！你一定要去冬天爷爷打个招呼！如果你今年表现的不错的话，你会在冬幕节那天收到一份很棒的礼物。你一定要告诉冬天爷爷你今年想要什么！$B$B另外，记得多买些好东西来给那些今年表现得好的人。我们这里货物齐全。各种货物一应俱全——这是烟林牧场精心为您准备的货物！' WHERE `entry` = 7022 AND `Details_loc4` = '冬幕节快乐，我的朋友！你一定要去冬天爷爷打个招呼！如果你今年表现的不错的话，你会在冬幕节那天收到一份很棒的礼物。你一定要告诉冬天爷爷你今年想要什么！$B$B另外，记得多买些好东西来给那些今年表现得好的人。我们这里货物齐全。各种货物一应俱全——这是Smokywood Pastures精心为您准备的货物！';
UPDATE `locales_quest` SET `Objectives_loc4` = '和冬天爷爷谈谈；他在奥格瑞玛烟林牧场商人区旁边。' WHERE `entry` = 7024 AND `Objectives_loc4` = '和冬天爷爷谈谈；他在奥格瑞玛Smokywood Pastures商人区旁边。';
UPDATE `locales_quest` SET `Details_loc4` = '<督军拉格隆德向您致敬。>许多人都没有活到摆脱平庸的那一天。$B$B你已经证明了自己是一个勇士的楷模，$N。现在是提升你的军阶的时候了。这是你的新徽记。' WHERE `entry` = 7163 AND `Details_loc4` = '<Warmaster 拉格隆德向您致敬。>许多人都没有活到摆脱平庸的那一天。$B$B你已经证明了自己是一个勇士的楷模，$N。现在是提升你的军阶的时候了。这是你的新徽记。';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = '哈，$N，又闻到你的味道真好。$B$B<法希尔笑了>。请原谅我的幽默感。好像有时不太妙。$B$B我知道你给我们的敌人造成了巨大的痛苦。哈卡的军队在愤怒中呼喊着你的名字。这很厉害。$B$B 你在护身符上又多了一个铭文。把它给我。' WHERE `entry` = 8147 AND `RequestItemsText_loc4` = '哈，$N，又闻到你的味道真好。$B$B<Falthir笑了>。请原谅我的幽默感。好像有时不太妙。$B$B我知道你给我们的敌人造成了巨大的痛苦。哈卡的军队在愤怒中呼喊着你的名字。这很厉害。$B$B 你在护身符上又多了一个铭文。把它给我。';
UPDATE `locales_quest` SET `Details_loc4` = '勇士，是你吗？我受命保管这个碎片已经一千年了，在我最黑暗的时候，应该有人站出来替我把它拿回来……但是一切都是任重道远的。$B$B<瓦拉斯塔兹轻轻地咳嗽着。>$B$B耐……奈法利安现在掌握着节杖碎片。$B$B时间是最关键的。奈法利安将要摧毁这柄节杖。你必须赶快！' WHERE `entry` = 8730 AND `Details_loc4` = '勇士，是你吗？我受命保管这个碎片已经一千年了，在我最黑暗的时候，应该有人站出来替我把它拿回来……但是一切都是任重道远的。$B$B<瓦拉斯塔兹轻轻地咳嗽着。>$B$B耐……耐法里奥斯现在掌握着scepter shard。$B$B时间是最关键的。耐法里奥斯将要摧毁这个scepter。你必须赶快！';
UPDATE `locales_quest` SET `Objectives_loc4` = '击败奈法利安并拿到红色节杖碎片，把它带给塔纳利斯时光之穴门口的安纳克罗斯。你必须在5小时之内完成这个任务。' WHERE `entry` = 8730 AND `Objectives_loc4` = '干掉奈法利安并拿到Red Scepter Shard。把Red Scepter Shard带给塔纳利斯时光之穴门口的阿纳克洛斯。你必须在5小时之内完成这个任务。';
UPDATE `locales_quest` SET `Details_loc4` = '许多幕光之锤的骑兵教徒经常在我们塞纳里奥要塞守卫范围之外的区域游荡，并伺机袭击我们巡逻和商旅小队。$B$B找到并击败暮光掠夺者，以及他们的首领——一个名叫莫娜的恐怖战士。当任务完成之后向唤风者梅恩·长角报告。' WHERE `entry` = 8740 AND `Details_loc4` = '许多幕光之锤的骑兵教徒经常在我们塞纳里奥要塞守卫范围之外的区域游荡，并伺机袭击我们巡逻和商旅小队。$B$B找到并击败twilight marauders和他们的领袖，一个叫做Morna的恐怖战士。当任务完成之后向唤风者梅恩·长角报告。';
UPDATE `locales_quest` SET `Objectives_loc4` = '击败暮光掠夺者莫娜和5个暮光掠夺者。当任务完成之后向唤风者梅恩·长角报告。' WHERE `entry` = 8740 AND `Objectives_loc4` = '干掉Twilight Marauder Morna和5个Twilight Marauders。当任务完成之后向唤风者梅恩·长角报告。';
UPDATE `locales_quest` SET `Details_loc4` = '从暴风城中心偷来的烈焰令你感到异常的温暖。你对这种罕见的力量一无所知，但是节日博学者或许知道些什么……' WHERE `entry` = 9339 AND `Details_loc4` = '从暴风城中心偷来的烈焰令你感到异常的温暖。你对这种罕见的力量一无所知，但是(NAME)或许知道些什么……';
UPDATE `locales_quest` SET `Objectives_loc4` = '将暴风城烈焰交给节日博学者。' WHERE `entry` = 9339 AND `Objectives_loc4` = '将暴风城烈焰交给(NAME)。';
UPDATE `locales_quest` SET `Details_loc4` = '从暴风城中心偷来的烈焰令你感到异常的温暖。你对这种罕见的力量一无所知，但是节日博学者或许知道些什么……' WHERE `entry` = 9365 AND `Details_loc4` = '从暴风城中心偷来的烈焰令你感到异常的温暖。你对这种罕见的力量一无所知，但是(NAME)或许知道些什么……';
UPDATE `locales_quest` SET `Objectives_loc4` = '将暴风城烈焰交给节日博学者。' WHERE `entry` = 9365 AND `Objectives_loc4` = '将暴风城烈焰交给(NAME)。';
UPDATE `locales_quest` SET `ObjectiveText1_loc4` = '探索古博拉采掘场的洞穴' WHERE `entry` = 39001 AND `ObjectiveText1_loc4` = '探索Gol bolar采石场的洞穴';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = '“你给我带来了这些？哎呀，你怎么知道我喜欢朗姆酒呢！你真是太贴心了。不过我们还是保密吧，好吗，$n？最近大祭司出台了一些愚蠢的规定，说什么要避免诱惑、不可纵酒之类的，巴拉巴拉巴拉。”' WHERE `entry` = 39987 AND `OfferRewardText_loc4` = '“你给我带来了这些？哎呀，你怎么知道我喜欢朗姆酒呢！你真是太贴心了。不过我们还是保密吧，好吗，$n？最近大祭司出台了一些愚蠢的规定，说什么要避免诱惑、不可纵酒之类的，blah blah blah。”';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = '大开眼界，不是吗，$N？$B$B你现在感觉比以往任何时候都更接近地球母亲。$B$B欢呼吧，与自然融为一体！' WHERE `entry` = 40003 AND `OfferRewardText_loc4` = '大开眼界，不是吗，$N？$B$B你现在感觉比以往任何时候都更接近地球母亲。$B$Brejoice，与自然融为一体！';
UPDATE `locales_quest` SET `Objectives_loc4` = '为吉格诺·麻须获得一个雾翼号角，以证明您的忠诚。' WHERE `entry` = 40041 AND `Objectives_loc4` = '为吉格诺·麻须获得一个Mistwing喇叭，以证明您的忠诚。';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = '分析师53G已损坏？.. 我会非常想念他，但我们将来会创造一个更好的。分析师54G将从灰烬中重生，就像——我忘乎所以了。谢谢你拿到分析芯片。你帮我们省了几个月的工作！' WHERE `entry` = 40044 AND `OfferRewardText_loc4` = '分析仪53G已损坏？.. 我会非常想念他，但我们将来会创造一个更好的。Analysor 54G将从灰烬中重生，就像——我忘乎所以了。谢谢你拿到分析芯片。你帮我们省了几个月的工作！';
UPDATE `locales_quest` SET `Title_loc4` = '修复起泡盘' WHERE `entry` = 40066 AND `Title_loc4` = '修复Fizz磁盘';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = '原来是这么回事。我应该更认真地对待维斯的警告。$B$B以穆拉丁的胡子起誓，我希望你把他们都杀了。但是盘子呢？告诉我格伦吉斯的牺牲和他手下的牺牲不是毫无意义的。' WHERE `entry` = 40105 AND `OfferRewardText_loc4` = '原来是这么回事。我应该更认真地对待维斯的警告。$B$Bby Muradin的胡子，我希望你把他们都杀了。但是盘子呢？告诉我格伦吉斯的牺牲和他手下的牺牲不是毫无意义的。';
UPDATE `locales_quest` SET `Details_loc4` = '哈哈哈，这不是我认为我会结束的死亡，但Bwonsamdi似乎对我有其他的计划。$B$B   $B$bi过着没有遗憾的生活，$n—直到现在。我问你这个，朋友。去北边追那些混蛋，让他们知道，如果他们想要战争，部落就会反抗他们。$B$bLok\'tar ogar。 ' WHERE `entry` = 40113 AND `Details_loc4` = '哈哈哈，这不是我认为我会结束的死亡，但Bwonsamdi似乎对我有其他的计划。$B$B   $B$bi过着没有遗憾的生活，$n—直到现在。我问你这个，朋友。去北边追那些混蛋，让他们知道，如果他们想要战争，部落就会反抗他们。$B$blok tar.. 奥加尔。 ';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = '分析仪X-51啊？存储体受到限制。我得想办法打开它们。想象一下它可能拥有的秘密！泰坦的秘密！不过，他很合作，所以我得说我们已经取得了一些进展。$B$BI将继续与分析师 X-51合作，看看他现在是否能帮助挖掘现场。一旦我得到关于记忆库的提示，我会打电话给你。同时，我有东西给你。我已经把分析仪X-51的旧能量核心改造成了你可以佩戴的护身符。$B$B虽然内在的能量只是核心曾经拥有的一小部分，但如果你使用魔法，它仍然可以维持你的魔法能量……如果没有，我打赌我们可以卖给感兴趣的人。' WHERE `entry` = 40132 AND `OfferRewardText_loc4` = '分析仪X-51啊？存储体受到限制。我得想办法打开它们。想象一下它可能拥有的秘密！泰坦的秘密！不过，他很合作，所以我得说我们已经取得了一些进展。$B$BI将继续与Analyzer X-51合作，看看他现在是否能帮助挖掘现场。一旦我得到关于记忆库的提示，我会打电话给你。同时，我有东西给你。我已经把分析仪X-51的旧能量核心改造成了你可以佩戴的护身符。$B$B虽然内在的能量只是核心曾经拥有的一小部分，但如果你使用魔法，它仍然可以维持你的魔法能量……如果没有，我打赌我们可以卖给感兴趣的人。';
UPDATE `locales_quest` SET `Objectives_loc4` = '收集6条多汁的爬虫腿和一小撮盐，作为卡兰之墓的“斯利姆”。' WHERE `entry` = 40142 AND `Objectives_loc4` = '收集6条多汁的爬虫腿和一小撮盐，作为卡兰之墓的“Slim”。';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = '你今天为卡多雷做出了巨大的贡献，$N。虽然我为我们以前的盟友的命运而哭泣，但悲伤不能让位于软弱。$B$B愿艾露恩引导你的手保卫我们人民的土地，并执行她的意志，你将得到奖励。' WHERE `entry` = 40205 AND `OfferRewardText_loc4` = '你今天为卡多雷做出了巨大的贡献，$N。虽然我为我们以前的盟友的命运而哭泣，但悲伤不能让位于软弱。$B$Belune引导你的手保卫我们人民的土地，并执行她的意志，你将得到奖励。';
UPDATE `locales_quest` SET `Objectives_loc4` = '在藏宝海湾为“脚滑”收集“精炼宝石货物”。' WHERE `entry` = 40222 AND `Objectives_loc4` = '在战利品海湾收集“Slip”的“精炼宝石货物”。';
UPDATE `locales_quest` SET `Objectives_loc4` = '收集神秘的货物，并把它交给藏宝海湾的“脚滑”。' WHERE `entry` = 40223 AND `Objectives_loc4` = '收集神秘的货物，并将其归还给“Slip”。';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = '这个幻象给我们的问题多于答案。这座城市一定是辛艾萨莉，那些垂死的人一定是古老的上层生物。波浪代表着分裂。这是个警告。一个警告，这一切都可能再次发生。' WHERE `entry` = 40293 AND `OfferRewardText_loc4` = '这个幻象给我们的问题多于答案。这座城市一定是Zin-Azshari，那些垂死的人一定是古老的上层生物。波浪代表着分裂。这是个警告。一个警告，这一切都可能再次发生。';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = '你已经做到了！$B$B化学处理膜已被回收。 看到这一幕我无法表达我的感激之情！ 我已经开始担心我们需要做的大量工作才能制造一个新的。$B$B现在，我们可以开始与 修补匠 一起开发 XV-82，使其更能处理化学问题并具有弹性 神秘干扰。$B$B 在此，以此表示感谢。 没有你，我仍然会绞尽脑汁想办法！' WHERE `entry` = 40865 AND `OfferRewardText_loc4` = '你已经做到了！$B$B化学处理膜已被回收。 看到这一幕我无法表达我的感激之情！ 我已经开始担心我们需要做的大量工作才能制造一个新的。$B$B现在，我们可以开始与 Tinkers 一起开发 XV-82，使其更能处理化学问题并具有弹性 神秘干扰。$B$B 在此，以此表示感谢。 没有你，我仍然会绞尽脑汁想办法！';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = '埃伦尼乌斯之爪。$B$B看到一位曾经高贵的英雄在我们的事业中倒下，我感到很痛苦。 看来即使是伟大的埃伦尼乌斯也无法免受觉醒的诱惑和吸引。 我认为腐败已经深深地渗入了他的内心，并将他变成了邪恶的代理人。$B$B埃伦纽斯 现在已经安息了，免受折磨。 我必须感谢你所做的一切。 拿走其中一件遗物，作为对你英雄主义的致敬。' WHERE `entry` = 41038 AND `OfferRewardText_loc4` = '埃伦尼乌斯之爪。$B$B看到一位曾经高贵的英雄在我们的事业中倒下，我感到很痛苦。 看来即使是伟大的埃伦尼乌斯也无法免受觉醒的诱惑和吸引。 我认为腐败已经深深地渗入了他的内心，并将他变成了邪恶的代理人。$B$BErennius 现在已经安息了，免受折磨。 我必须感谢你所做的一切。 拿走其中一件遗物，作为对你英雄主义的致敬。';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = '那么，你寻求我的智慧，是吗？ 很少有人敢冒险进入我的领域，更不用说寻求我的接见了。 说出你的目的，但要注意你的用词，因为我对闲聊没有耐心。$B$B<赛纳隆 的目光变得更加强烈，他的原始本能随时准备扑向最轻微的欺骗或不尊重的迹象。 他的狼群隐藏在阴影中，躁动不安，空气中弥漫着野性的能量。>$B$B记住，凡人，人与自然之间的联系是微妙的。 只要稍有失误，我的狼群就会毫不犹豫地向你释放愤怒。 现在，说出你的意图。' WHERE `entry` = 41047 AND `OfferRewardText_loc4` = '那么，你寻求我的智慧，是吗？ 很少有人敢冒险进入我的领域，更不用说寻求我的接见了。 说出你的目的，但要注意你的用词，因为我对闲聊没有耐心。$B$B<Cenerron 的目光变得更加强烈，他的原始本能随时准备扑向最轻微的欺骗或不尊重的迹象。 他的狼群隐藏在阴影中，躁动不安，空气中弥漫着野性的能量。>$B$B记住，凡人，人与自然之间的联系是微妙的。 只要稍有失误，我的狼群就会毫不犹豫地向你释放愤怒。 现在，说出你的意图。';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = '艾露恩之镰……一件被诅咒的具有深奥力量的神器，被一位黑暗骑士——一个被时间和阴影束缚的存在——带到了卡拉赞的这片圣地。 他们到来的记忆虽然感觉既新又古老，但却是模糊的，因为时间编织了一幅让我的思绪混乱的挂毯。$B$B布莱克沃尔德，那个沉迷于获得镰刀的可怜虫。 他的恶毒无边无际，以拥有如此强大的圣物为乐。 卡拉赞的大厅与他扭曲的满足感产生了共鸣。$B$B现在根本不敢想使用它。 它已经拥有黑暗力量太久了，我担心它只会带来更多的破坏，即使你的意图是正义的。' WHERE `entry` = 41062 AND `OfferRewardText_loc4` = '艾露恩之镰……一件被诅咒的具有深奥力量的神器，被一位黑暗骑士——一个被时间和阴影束缚的存在——带到了卡拉赞的这片圣地。 他们到来的记忆虽然感觉既新又古老，但却是模糊的，因为时间编织了一幅让我的思绪混乱的挂毯。$B$BBlackwald，那个沉迷于获得镰刀的可怜虫。 他的恶毒无边无际，以拥有如此强大的圣物为乐。 卡拉赞的大厅与他扭曲的满足感产生了共鸣。$B$B现在根本不敢想使用它。 它已经拥有黑暗力量太久了，我担心它只会带来更多的破坏，即使你的意图是正义的。';
UPDATE `locales_quest` SET `Details_loc4` = '哦不，你也来找梅松·幸运的冬幕节服装吗？唉，有点尴尬，但是...我现在完全卖光了！你看，那本《胭脂》杂志刚刚刊登了一篇关于我们的文章，我们没想到会有这么多人涌来。$B$B我需要把消息传回商店，告诉他们我需要新的货物，但我真的不应该离开我的岗位。你知道的，根据你的装束，你似乎是一个经验丰富的旅行者。你能不能回到暴风城，让他们给我送更多的产品？时装店位于公园，靠近入口。只要找到阿利克斯·格雷斯，告诉她情况，她会处理好的！' WHERE `entry` = 41268 AND `Details_loc4` = '哦不，你也来找梅松·幸运的冬幕节服装吗？唉，有点尴尬，但是...我现在完全卖光了！你看，那本《Rouge》杂志刚刚刊登了一篇关于我们的文章，我们没想到会有这么多人涌来。$B$B我需要把消息传回商店，告诉他们我需要新的货物，但我真的不应该离开我的岗位。你知道的，根据你的装束，你似乎是一个经验丰富的旅行者。你能不能回到暴风城，让他们给我送更多的产品？时装店位于公园，靠近入口。只要找到阿利克斯·格雷斯，告诉她情况，她会处理好的！';
UPDATE `locales_quest` SET `Details_loc4` = '呃，你也来找梅松·幸运的冬幕节服装吗？唉，很抱歉，但你来得有点晚了。我现在完全卖光了。那本《胭脂》杂志刚刚刊登了一篇关于我们的文章，我没想到会有这么多人涌来。$B$B我需要把消息传回商店，告诉他们我需要新的货物，但我不能离开我的岗位。嘿，根据你的装束，你似乎是一个经验丰富的旅行者。如果你能回到幽暗城，帮我向他们发送更多的产品？时装店位于药剂区，靠近附魔店。只要找到可可，告诉她情况，她会解决这个麻烦！' WHERE `entry` = 41271 AND `Details_loc4` = '呃，你也来找梅松·幸运的冬幕节服装吗？唉，很抱歉，但你来得有点晚了。我现在完全卖光了。那本《Rouge》杂志刚刚刊登了一篇关于我们的文章，我没想到会有这么多人涌来。$B$B我需要把消息传回商店，告诉他们我需要新的货物，但我不能离开我的岗位。嘿，根据你的装束，你似乎是一个经验丰富的旅行者。如果你能回到幽暗城，帮我向他们发送更多的产品？时装店位于药剂区，靠近附魔店。只要找到可可，告诉她情况，她会解决这个麻烦！';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = '从来没听过 马丁·科林斯，但我好像对哈勒斯·阿什巴克尔这个名字有印象。怎么了？' WHERE `entry` = 55222 AND `OfferRewardText_loc4` = '从来没听过 马丁柯林斯 before,但是我好像对哈勒斯·阿什巴克尔这个名字有印象, 怎么了吗?';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = '我感谢你帮助佩吉。 她已经在那个营地呆了很长时间了。$B$B唉，眼下的情况我们也无能为力。' WHERE `entry` = 70056 AND `OfferRewardText_loc4` = '我感谢你帮助佩吉。 她已经在那个营地呆了很长时间了。$B$BAlas，在我们所处的情况下我们无能为力。';
UPDATE `locales_quest` SET `Details_loc4` = '欢迎来到我的寒舍，我在这个塔尖上履行了我的职责，并将继续这样做。现在路石已经重建，我们可以开始让我们在该地区的存在更加广为人知。$B$B西南方向是辛玛洛神殿，坐落在埃达拉斯废墟中，目前居住着扭曲的纳迦。在辛玛洛神殿里，隐藏着他们永远不会发现的秘密，而我需要你去揭开。$B$B在神殿深处，你会发现一块独特的石头，上面刻着一种更古老语言的明亮符文。这块石头，被称为阿山石，当你看到它时，说出下面的“Tizah Ashan Dal\'asha”。这个魔法将再一次削弱延伸穿过艾萨拉的长而不活跃的魔网线。' WHERE `entry` = 40253 AND `Details_loc4` = '欢迎来到我的寒舍，我在这个塔尖上履行了我的职责，并将继续这样做。现在路石已经重建，我们可以开始让我们在该地区的存在更加广为人知。$B$B西南方向是辛玛洛神殿，坐落在埃达拉斯废墟中，目前居住着扭曲的纳迦。在辛玛洛神殿里，隐藏着他们永远不会发现的秘密，而我需要你去揭开。$B$B在神殿深处，你会发现一块独特的石头，上面刻着一种更古老语言的明亮符文。这块石头，被称为阿山石，当你看到它时，说出下面的“TizahAshanDal\'Asha”。这个魔法将再一次削弱延伸穿过艾萨拉的长而不活跃的魔网线。';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = '刺毛开始闻你的背包，兴奋地等待着你给她带来的款待。吃完饭，享受了一会儿她的玩具，在等你骑上马鞍的时候，她似乎几乎无法控制自己不飞走。' WHERE `entry` = 40298 AND `OfferRewardText_loc4` = 'Bristelfur开始闻你的背包，兴奋地等待着你给她带来的款待。吃完饭，享受了一会儿她的玩具，在等你骑上马鞍的时候，她似乎几乎无法控制自己不飞走。';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = 'Throm\'ka，小家伙。什么风把你吹到碎风哨站来了？' WHERE `entry` = 41794 AND `RequestItemsText_loc4` = 'Thrall hall，小家伙。什么风把你吹到碎风哨站来了？';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = '要是能有几位法师来配合我们的研究就好了，而不是整天摆弄那些小玩意——他们简直像哥布林见了金子一样挪不开眼！$B$B唉……光着急也没用，对吧？所以……你忙完了，记得歇一歇。' WHERE `entry` = 39001 AND `RequestItemsText_loc4` = '如果我们有一些法师与我们的研究合作，而不是摆弄所有那些小饰品，他们似乎像小妖精一样粘在黄金上！$B$bbah…挫折不会给我们带来任何东西，对吗？所以……一旦你完成了，一定要休息一下。';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = REPLACE(`OfferRewardText_loc4`, '<Name>', '$N') WHERE `entry` = 5220 AND `OfferRewardText_loc4` LIKE '%<Name>%';

-- 共 202 条

-- ---- 专名统一（同名异译收敛）----
-- Anachronos 库内作「安纳克罗斯」、Booty Bay 作「藏宝海湾」、Ratchet 作「棘齿城」；
-- Slip（NPC 60502）作「脚滑」、Wally Wisecrack（NPC 60506）作「沃利·怀斯克拉克」。
UPDATE `locales_quest` SET `Title_loc4` = REPLACE(`Title_loc4`, '阿纳克洛斯', '安纳克罗斯') WHERE `Title_loc4` LIKE '%阿纳克洛斯%';
UPDATE `locales_quest` SET `Details_loc4` = REPLACE(`Details_loc4`, '阿纳克洛斯', '安纳克罗斯') WHERE `Details_loc4` LIKE '%阿纳克洛斯%';
UPDATE `locales_quest` SET `Objectives_loc4` = REPLACE(`Objectives_loc4`, '阿纳克洛斯', '安纳克罗斯') WHERE `Objectives_loc4` LIKE '%阿纳克洛斯%';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = REPLACE(`OfferRewardText_loc4`, '阿纳克洛斯', '安纳克罗斯') WHERE `OfferRewardText_loc4` LIKE '%阿纳克洛斯%';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = REPLACE(`RequestItemsText_loc4`, '阿纳克洛斯', '安纳克罗斯') WHERE `RequestItemsText_loc4` LIKE '%阿纳克洛斯%';
UPDATE `locales_quest` SET `EndText_loc4` = REPLACE(`EndText_loc4`, '阿纳克洛斯', '安纳克罗斯') WHERE `EndText_loc4` LIKE '%阿纳克洛斯%';
UPDATE `locales_quest` SET `ObjectiveText1_loc4` = REPLACE(`ObjectiveText1_loc4`, '阿纳克洛斯', '安纳克罗斯') WHERE `ObjectiveText1_loc4` LIKE '%阿纳克洛斯%';
UPDATE `locales_quest` SET `ObjectiveText2_loc4` = REPLACE(`ObjectiveText2_loc4`, '阿纳克洛斯', '安纳克罗斯') WHERE `ObjectiveText2_loc4` LIKE '%阿纳克洛斯%';
UPDATE `locales_quest` SET `Title_loc4` = REPLACE(`Title_loc4`, '战利品海湾', '藏宝海湾') WHERE `Title_loc4` LIKE '%战利品海湾%';
UPDATE `locales_quest` SET `Details_loc4` = REPLACE(`Details_loc4`, '战利品海湾', '藏宝海湾') WHERE `Details_loc4` LIKE '%战利品海湾%';
UPDATE `locales_quest` SET `Objectives_loc4` = REPLACE(`Objectives_loc4`, '战利品海湾', '藏宝海湾') WHERE `Objectives_loc4` LIKE '%战利品海湾%';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = REPLACE(`OfferRewardText_loc4`, '战利品海湾', '藏宝海湾') WHERE `OfferRewardText_loc4` LIKE '%战利品海湾%';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = REPLACE(`RequestItemsText_loc4`, '战利品海湾', '藏宝海湾') WHERE `RequestItemsText_loc4` LIKE '%战利品海湾%';
UPDATE `locales_quest` SET `EndText_loc4` = REPLACE(`EndText_loc4`, '战利品海湾', '藏宝海湾') WHERE `EndText_loc4` LIKE '%战利品海湾%';
UPDATE `locales_quest` SET `ObjectiveText1_loc4` = REPLACE(`ObjectiveText1_loc4`, '战利品海湾', '藏宝海湾') WHERE `ObjectiveText1_loc4` LIKE '%战利品海湾%';
UPDATE `locales_quest` SET `ObjectiveText2_loc4` = REPLACE(`ObjectiveText2_loc4`, '战利品海湾', '藏宝海湾') WHERE `ObjectiveText2_loc4` LIKE '%战利品海湾%';
UPDATE `locales_quest` SET `Title_loc4` = REPLACE(`Title_loc4`, '棘轮', '棘齿城') WHERE `Title_loc4` LIKE '%棘轮%';
UPDATE `locales_quest` SET `Details_loc4` = REPLACE(`Details_loc4`, '棘轮', '棘齿城') WHERE `Details_loc4` LIKE '%棘轮%';
UPDATE `locales_quest` SET `Objectives_loc4` = REPLACE(`Objectives_loc4`, '棘轮', '棘齿城') WHERE `Objectives_loc4` LIKE '%棘轮%';
UPDATE `locales_quest` SET `OfferRewardText_loc4` = REPLACE(`OfferRewardText_loc4`, '棘轮', '棘齿城') WHERE `OfferRewardText_loc4` LIKE '%棘轮%';
UPDATE `locales_quest` SET `RequestItemsText_loc4` = REPLACE(`RequestItemsText_loc4`, '棘轮', '棘齿城') WHERE `RequestItemsText_loc4` LIKE '%棘轮%';
UPDATE `locales_quest` SET `EndText_loc4` = REPLACE(`EndText_loc4`, '棘轮', '棘齿城') WHERE `EndText_loc4` LIKE '%棘轮%';
UPDATE `locales_quest` SET `ObjectiveText1_loc4` = REPLACE(`ObjectiveText1_loc4`, '棘轮', '棘齿城') WHERE `ObjectiveText1_loc4` LIKE '%棘轮%';
UPDATE `locales_quest` SET `ObjectiveText2_loc4` = REPLACE(`ObjectiveText2_loc4`, '棘轮', '棘齿城') WHERE `ObjectiveText2_loc4` LIKE '%棘轮%';
UPDATE `locales_quest` SET `Objectives_loc4` = REPLACE(`Objectives_loc4`, '看守卡拉汉', '守夜人考拉哈恩') WHERE `entry` = 236 AND `Objectives_loc4` LIKE '%看守卡拉汉%';
UPDATE `locales_quest` SET `Objectives_loc4` = REPLACE(`Objectives_loc4`, '“滑道”', '“脚滑”') WHERE `entry` = 40225 AND `Objectives_loc4` LIKE '%“滑道”%';
UPDATE `locales_quest` SET `Objectives_loc4` = REPLACE(`Objectives_loc4`, '沃利的俏皮话', '沃利·怀斯克拉克') WHERE `entry` = 40226 AND `Objectives_loc4` LIKE '%沃利的俏皮话%';
UPDATE `locales_quest` SET `Objectives_loc4` = REPLACE(`Objectives_loc4`, '“溜走”', '“脚滑”') WHERE `entry` = 40226 AND `Objectives_loc4` LIKE '%“溜走”%';
UPDATE `locales_quest` SET `Details_loc4` = REPLACE(`Details_loc4`, '‘俏皮话’维利', '“俏皮话”沃利·怀斯克拉克') WHERE `entry` = 40226 AND INSTR(`Details_loc4`, '‘俏皮话’维利') > 0;
