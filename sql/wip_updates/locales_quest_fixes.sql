-- 任务标题缺陷修复（locales_quest）—— 替换词典拼装产生的病句
--
-- 背景：早前那轮自动翻译对 40xxx–42xxx 段（乌龟服自定义内容）大量使用「按英文单词
-- 逐个查词典再拼接」的做法，产生了大量不成句、甚至意思错误的标题，例如：
--   Lost In Ratchet        → 棘齿城之迷失       （“迷失棘齿城” 才是人话）
--   Mastering Goldsmithing → 控制金饰加工       （master = 精通，不是控制）
--   The Collector          → 收货人             （collector = 收藏家，不是收货人）
--   Drones In Westfall     → 西部荒野之雄蝎      （drone = 雄蜂，不是蝎）
--   A Cause Of Concern     → 任务之导致         （完全不成句）
--   Earlwake No More       → 伯爵守夜无更多的    （完全不成句）
-- 这类错误“读起来像话、其实是错的”，玩家一眼就能看到，所以整段重审重译，
-- 而不是逐条打补丁。
--
-- 范围：游戏中仍可接取、且此前已有中文的自定义任务标题，共 566 条。
--       其中 456 条本次实际改写，110 条复查后认为原译可用，未改动（因此不在本文件里）。
--
-- 每条语句上方给出 英文原文 / 原译文 / 新译文，便于逐条复核。
--
-- 重译标准（与既有汉化一致）：
--   * 官方既成译名优先：冰斧（Winterax）、蛮锤（Wildhammer）、艾斯卡达尔（Eskhandar）、
--     多彩（Chromatic）、灵契（Sapta）、誓日（Sunsworn）、厄尔威克（Earlwake）、
--     孤峰（Gowlfang）、加贝（Jabbey）、螺熔（Screwfuse）、源质（Elementium）。
--   * 职业套装（T1/T2/T3 兑换任务）按库内官方物品名逐件对齐，槽位用词取自
--     item_template：怒风头饰/护肩/胸甲/护腕/手套/腰带/腿甲/战靴、恶魔之心角饰、
--     灵风头冠、审判头冠、秩序之源肩铠、复仇骨帽……（原译用了“头颅/腰部/脚部”等身体部位）
--   * 双关与口语按中文语感处理：Tide-ying Up→收拾潮水、To Look A Gift Horse In The
--     Mouth→馈赠莫挑剔、It Cant Rain All the Time→雨不会一直下、Lady Who?→哪位女士？
--   * 不增删数字与符号；原文的省略号、感叹号一律保留。
--   * 80109 的 “Zug-zug” 是兽人语拟声问候，库内无既成译法，保留原拼写（下方值中的 ASCII
--     仅此一处，是有意为之）。
--
-- 导入：mysql tw_world < locales_quest_fixes.sql
-- 生效：mangosd 控制台执行 `.reload locales_quest`（无需重启）

SET NAMES utf8mb4;

-- 40004 | Winterax Champion
--   旧: 温特莱克斯冠军
--   新: 冰斧勇士
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (40004, '冰斧勇士') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 40114 | Uldum Awaits
--   旧: 奥丹姆在等着
--   新: 奥丹姆在等待
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (40114, '奥丹姆在等待') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 40115 | Guardian of the Gate
--   旧: 大门守护者
--   新: 守门者
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (40115, '守门者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 40120 | Aggressive Wildlife
--   旧: 好斗的野生动物
--   新: 好斗的野兽
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (40120, '好斗的野兽') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 40121 | Alpha Aggression
--   旧: 阿尔法攻击
--   新: 头领的进犯
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (40121, '头领的进犯') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 40122 | The Azshara Dampening
--   旧: 艾萨拉减弱了
--   新: 艾萨拉的沉寂
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (40122, '艾萨拉的沉寂') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 40123 | The Dampening Mystery
--   旧: 令人沮丧的神秘
--   新: 沉寂之谜
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (40123, '沉寂之谜') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 40175 | The Bet
--   旧: 那个赌注
--   新: 赌约
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (40175, '赌约') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 40756 | Operation FIX Screwfuse 1000
--   旧: 行动：修复螺栓熔化器1000
--   新: 行动：修好螺熔1000型
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (40756, '行动：修好螺熔1000型') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 40758 | Operation Help Jabbey 2
--   旧: 行动：帮助杰比2
--   新: 行动：援助加贝 2
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (40758, '行动：援助加贝 2') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 40782 | The Legend Comes To Life!
--   旧: 传说变为现实！
--   新: 传说成真！
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (40782, '传说成真！') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41069 | Black Lotus Collection
--   旧: 黑莲花系列
--   新: 黑莲花收集
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41069, '黑莲花收集') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41070 | Unhallowed Branches
--   旧: 不神圣的树枝
--   新: 亵渎的枝干
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41070, '亵渎的枝干') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41149 | Fly High, Little Dulin
--   旧: 飞翔吧，小杜林
--   新: 高飞吧，小杜林
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41149, '高飞吧，小杜林') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41168 | Maritime Gumbo
--   旧: 海鲜浓汤
--   新: 海味浓汤
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41168, '海味浓汤') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41274 | Testaments Of True Love
--   旧: 真实爱情遗训
--   新: 真爱遗言
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41274, '真爱遗言') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41275 | Mastering Goldsmithing
--   旧: 控制金饰加工
--   新: 精通金饰加工
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41275, '精通金饰加工') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41276 | Mastering Goldsmithing
--   旧: 控制金饰加工
--   新: 精通金饰加工
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41276, '精通金饰加工') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41277 | Mastering Gemology
--   旧: 控制宝石学
--   新: 精通宝石学
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41277, '精通宝石学') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41278 | Mastering Gemology
--   旧: 控制宝石学
--   新: 精通宝石学
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41278, '精通宝石学') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41279 | The Lifeblood
--   旧: 活力
--   新: 命脉
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41279, '命脉') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41281 | Preparation
--   旧: 伺机待发
--   新: 准备
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41281, '准备') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41282 | The Final Cut
--   旧: 最终切割
--   新: 最后一刀
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41282, '最后一刀') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41285 | Left In Bad Faith
--   旧: 坏掉的信仰左
--   新: 失信弃之
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41285, '失信弃之') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41286 | The Artificer
--   旧: 技师
--   新: 巧匠
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41286, '巧匠') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41287 | Sand In The Cracks
--   旧: 裂隙之沙
--   新: 裂隙中的沙
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41287, '裂隙中的沙') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41288 | Stones Of Radiance
--   旧: 光辉之能量石
--   新: 光辉之石
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41288, '光辉之石') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41289 | Foreign Knowledge
--   旧: 海外知识
--   新: 异域的学识
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41289, '异域的学识') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41290 | The Artificer
--   旧: 技师
--   新: 巧匠
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41290, '巧匠') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41291 | Unfortunate Circumstances
--   旧: 不幸的境况
--   新: 时运不济
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41291, '时运不济') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41292 | The Art Of Goldsmithing
--   旧: 金饰加工之艺术
--   新: 金饰加工的艺术
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41292, '金饰加工的艺术') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41293 | Elaborate Golden Bracelets
--   旧: 精致的金手镯
--   新: 精美的金手镯
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41293, '精美的金手镯') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41294 | Observations
--   旧: 观察站
--   新: 观察所见
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41294, '观察所见') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41295 | Dearest Gallitrea
--   旧: 最亲爱的加莉特蕾娅
--   新: 亲爱的加莉特蕾娅
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41295, '亲爱的加莉特蕾娅') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41296 | The Collector
--   旧: 收货人
--   新: 收藏家
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41296, '收藏家') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41298 | Envoy Of Draenor
--   旧: 德拉诺之使者
--   新: 德拉诺的使者
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41298, '德拉诺的使者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41301 | Undermarket Offer
--   旧: 黑市在处奉上祭品
--   新: 黑市献礼
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41301, '黑市献礼') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41303 | Lost In Ratchet
--   旧: 棘齿城之迷失
--   新: 迷失棘齿城
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41303, '迷失棘齿城') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41304 | A Friend Of A Friend?
--   旧: 朋友?之朋友
--   新: 朋友的朋友？
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41304, '朋友的朋友？') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41305 | Gold Is The Goblins Heart
--   旧: 金色使你的地精燃心
--   新: 黄金是地精的心头肉
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41305, '黄金是地精的心头肉') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41309 | Brittle Gnome More
--   旧: 脆弱侏儒更多的
--   新: 脆弱的侏儒
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41309, '脆弱的侏儒') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41310 | Clutch of Thanlar
--   旧: 坦拉尔之腰带
--   新: 坦拉尔之握
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41310, '坦拉尔之握') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41312 | Restoration
--   旧: 恢复
--   新: 修复
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41312, '修复') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41313 | Leyline Investigation
--   旧: 地脉调查岭
--   新: 地脉调查
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41313, '地脉调查') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41314 | A Cause Of Concern
--   旧: 任务之导致
--   新: 令人忧心的事由
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41314, '令人忧心的事由') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41315 | Unveiling The Mystery
--   旧: 揭幕神秘
--   新: 揭开谜团
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41315, '揭开谜团') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41317 | The Rune of Blaz
--   旧: 布拉兹之符文
--   新: 布拉兹的符文
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41317, '布拉兹的符文') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41318 | Mastercrafted Diamond Crown
--   旧: 精致钻石宝冠
--   新: 大师级钻石王冠
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41318, '大师级钻石王冠') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41319 | Mastercrafted Diamond Bangles
--   旧: 精制钻石手镯
--   新: 大师级钻石手镯
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41319, '大师级钻石手镯') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41320 | Learn Of My Past
--   旧: 我的往日的学习
--   新: 了解我的过去
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41320, '了解我的过去') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41321 | Rift Fatigue: Mind
--   旧: 裂隙行者疲惫：心灵震爆
--   新: 裂隙疲劳：心智
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41321, '裂隙疲劳：心智') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41322 | Rift Fatigue: Body
--   旧: 裂隙行者疲惫：躯体转换
--   新: 裂隙疲劳：躯体
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41322, '裂隙疲劳：躯体') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41324 | Novice In A Barren Land
--   旧: 荒芜暗雷新
--   新: 荒芜之地的新手
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41324, '荒芜之地的新手') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41325 | An Echo From Beyond
--   旧: 跨越之门之回响
--   新: 彼岸的回响
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41325, '彼岸的回响') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41339 | Shadowed Spectre
--   旧: 阴影笼罩的鬼魂
--   新: 幽影
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41339, '幽影') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41341 | Tethered Memories
--   旧: 被束缚的哀思
--   新: 萦绕的回忆
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41341, '萦绕的回忆') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41344 | Comically Large Candle
--   旧: 滑稽的大型蜡烛
--   新: 大得滑稽的蜡烛
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41344, '大得滑稽的蜡烛') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41345 | Altar of an Ancient Evil
--   旧: 古老邪恶祭坛
--   新: 上古邪物的祭坛
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41345, '上古邪物的祭坛') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41346 | A Mossy Mystery
--   旧: 生苔的神秘
--   新: 苔藓之谜
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41346, '苔藓之谜') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41347 | Lost In Time
--   旧: 时间之迷失
--   新: 迷失时光
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41347, '迷失时光') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41348 | Earlwake No More
--   旧: 伯爵守夜无更多的
--   新: 再无厄尔威克
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41348, '再无厄尔威克') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41349 | The Loss At Lordaeron
--   旧: 洛丹伦之损失
--   新: 洛丹伦的损失
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41349, '洛丹伦的损失') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41350 | The Sword Master
--   旧: 剑类大师
--   新: 剑术大师
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41350, '剑术大师') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41351 | Death In One Strike
--   旧: 一打击死亡
--   新: 一击毙命
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41351, '一击毙命') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41355 | And Lost to the Stars
--   旧: 群星之迷失
--   新: 迷失于群星
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41355, '迷失于群星') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41356 | Asleep Under Snow
--   旧: 雪之沉睡
--   新: 雪下长眠
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41356, '雪下长眠') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41357 | The Enemy Lays
--   旧: 敌人静卧
--   新: 敌人潜伏
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41357, '敌人潜伏') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41359 | Through a Glimmering Light
--   旧: 贯穿微光轻型
--   新: 穿过微光
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41359, '穿过微光') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41360 | Warm is the Day
--   旧: 温暖的焰使你的日间交易
--   新: 温暖的日子
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41360, '温暖的日子') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41361 | Gleaming Blood
--   旧: 微光血
--   新: 闪耀之血
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41361, '闪耀之血') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41362 | To Cut A Heart
--   旧: 切割心
--   新: 剖心
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41362, '剖心') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41363 | Rampant Weeds
--   旧: 猛烈生长杂草
--   新: 蔓生的杂草
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41363, '蔓生的杂草') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41364 | To Guard the Undead
--   旧: 卫兵亡灵
--   新: 守护亡者
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41364, '守护亡者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41367 | Against the Kolkar Dream
--   旧: 纳迦之战科卡尔梦境
--   新: 抵抗科卡尔之梦
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41367, '抵抗科卡尔之梦') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41368 | Reminiscent of Steel
--   旧: 钢铁之追忆
--   新: 钢铁的追忆
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41368, '钢铁的追忆') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41369 | The Scepter Rod of Medivh
--   旧: 麦迪文之节杖魔棒
--   新: 麦迪文之杖
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41369, '麦迪文之杖') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41371 | The Otherwordly Scepter of Medivh
--   旧: 麦迪文之异界的节杖
--   新: 麦迪文的异界之杖
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41371, '麦迪文的异界之杖') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41373 | A Chefs Majesty
--   旧: 厨师威严
--   新: 厨师的威严
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41373, '厨师的威严') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41376 | Wrapping Warpwood
--   旧: 条纹包装扭木茧
--   新: 包裹扭木
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41376, '包裹扭木') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41385 | Gilnean Pricolich
--   旧: 吉尔尼斯普里科利奇
--   新: 吉尔尼斯普里科利希
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41385, '吉尔尼斯普里科利希') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41387 | Iron Determination
--   旧: 铁信念
--   新: 钢铁般的决心
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41387, '钢铁般的决心') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41388 | Wisdom From Failure
--   旧: 失败之智慧
--   新: 失败中的智慧
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41388, '失败中的智慧') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41389 | Proof
--   旧: 证明
--   新: 证据
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41389, '证据') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41390 | Drones In Westfall
--   旧: 西部荒野之雄蝎
--   新: 西部荒野的雄蜂
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41390, '西部荒野的雄蜂') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41391 | Venture Delivery
--   旧: 风险投资便携短
--   新: 风险投资公司的货件
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41391, '风险投资公司的货件') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41393 | The Strength To Move Mountains
--   旧: 行动山脉力量
--   新: 移山之力
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41393, '移山之力') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41396 | Woven Dreams
--   旧: 机织布梦
--   新: 编织的梦境
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41396, '编织的梦境') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41397 | The Eternal Sleeper
--   旧: 永恒沉睡者
--   新: 永恒的沉眠者
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41397, '永恒的沉眠者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41398 | Under The Vibrant Moonlight
--   旧: 活力月光
--   新: 在明媚月光下
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41398, '在明媚月光下') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41399 | Ring of the Dreamwalker
--   旧: 梦游者之戒
--   新: 梦游者指环
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41399, '梦游者指环') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41400 | Stormrage Head
--   旧: 怒风头颅
--   新: 怒风头饰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41400, '怒风头饰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41404 | Stormrage Hands
--   旧: 怒风手
--   新: 怒风手套
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41404, '怒风手套') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41405 | Stormrage Waist
--   旧: 怒风腰部
--   新: 怒风腰带
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41405, '怒风腰带') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41406 | Stormrage Legs
--   旧: 怒风护腿
--   新: 怒风腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41406, '怒风腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41407 | Stormrage Boots
--   旧: 怒风长靴
--   新: 怒风战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41407, '怒风战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41408 | Cenarion Head
--   旧: 塞纳里奥头颅
--   新: 塞纳里奥头饰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41408, '塞纳里奥头饰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41412 | Cenarion Hands
--   旧: 塞纳里奥手
--   新: 塞纳里奥手套
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41412, '塞纳里奥手套') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41413 | Cenarion Waist
--   旧: 塞纳里奥腰部
--   新: 塞纳里奥腰带
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41413, '塞纳里奥腰带') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41414 | Cenarion Legs
--   旧: 塞纳里奥护腿
--   新: 塞纳里奥腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41414, '塞纳里奥腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41415 | Cenarion Boots
--   旧: 塞纳里奥长靴
--   新: 塞纳里奥战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41415, '塞纳里奥战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41417 | Nemesis Head
--   旧: 复仇头颅
--   新: 复仇头饰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41417, '复仇头饰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41423 | Nemesis Legs
--   旧: 复仇护腿
--   新: 复仇腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41423, '复仇腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41425 | Felheart Head
--   旧: 魔心头颅
--   新: 恶魔之心头饰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41425, '恶魔之心头饰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41426 | Felheart Shoulders
--   旧: 魔心护肩
--   新: 恶魔之心护肩
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41426, '恶魔之心护肩') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41427 | Felheart Chest
--   旧: 魔心胸甲
--   新: 恶魔之心胸甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41427, '恶魔之心胸甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41428 | Felheart Wrists
--   旧: 魔心护腕
--   新: 恶魔之心护腕
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41428, '恶魔之心护腕') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41429 | Felheart Hands
--   旧: 魔心手
--   新: 恶魔之心手套
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41429, '恶魔之心手套') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41431 | Felheart Legs
--   旧: 魔心护腿
--   新: 恶魔之心腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41431, '恶魔之心腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41432 | Felheart Boots
--   旧: 魔心长靴
--   新: 恶魔之心战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41432, '恶魔之心战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41433 | Ring of the Dreadnaught
--   旧: 无畏之戒
--   新: 无畏指环
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41433, '无畏指环') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41434 | Head of Wrath
--   旧: 愤怒之头颅
--   新: 愤怒头饰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41434, '愤怒头饰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41435 | Shoulders of Wrath
--   旧: 愤怒之护肩
--   新: 愤怒护肩
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41435, '愤怒护肩') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41436 | Chest of Wrath
--   旧: 愤怒之胸甲
--   新: 愤怒胸甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41436, '愤怒胸甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41437 | Wrists of Wrath
--   旧: 愤怒之护腕
--   新: 愤怒护腕
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41437, '愤怒护腕') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41438 | Hands of Wrath
--   旧: 愤怒之手
--   新: 愤怒手套
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41438, '愤怒手套') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41439 | Waist of Wrath
--   旧: 愤怒之腰部
--   新: 愤怒腰带
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41439, '愤怒腰带') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41440 | Legs of Wrath
--   旧: 愤怒之护腿
--   新: 愤怒腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41440, '愤怒腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41441 | Boots of Wrath
--   旧: 愤怒之长靴
--   新: 愤怒战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41441, '愤怒战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41442 | Head of Might
--   旧: 力量之头颅
--   新: 力量头饰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41442, '力量头饰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41443 | Shoulders of Might
--   旧: 力量之护肩
--   新: 力量护肩
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41443, '力量护肩') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41444 | Chest of Might
--   旧: 力量之胸甲
--   新: 力量胸甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41444, '力量胸甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41445 | Wrists of Might
--   旧: 力量之护腕
--   新: 力量护腕
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41445, '力量护腕') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41446 | Hands of Might
--   旧: 力量之手
--   新: 力量手套
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41446, '力量手套') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41447 | Waist of Might
--   旧: 力量之腰部
--   新: 力量腰带
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41447, '力量腰带') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41448 | Legs of Might
--   旧: 力量之护腿
--   新: 力量腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41448, '力量腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41449 | Boots of Might
--   旧: 力量之长靴
--   新: 力量战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41449, '力量战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41450 | Ring of Faith
--   旧: 信仰之戒
--   新: 信仰指环
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41450, '信仰指环') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41451 | Head of Transcendence
--   旧: 超然之头颅
--   新: 卓越头饰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41451, '卓越头饰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41452 | Shoulders of Transcendence
--   旧: 超然之护肩
--   新: 卓越护肩
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41452, '卓越护肩') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41453 | Chest of Transcendence
--   旧: 超然之胸甲
--   新: 卓越胸甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41453, '卓越胸甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41454 | Wrists of Transcendence
--   旧: 超然之护腕
--   新: 卓越护腕
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41454, '卓越护腕') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41455 | Hands of Transcendence
--   旧: 超然之手
--   新: 卓越手套
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41455, '卓越手套') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41456 | Waist of Transcendence
--   旧: 超然之腰部
--   新: 卓越腰带
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41456, '卓越腰带') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41457 | Legs of Transcendence
--   旧: 超然之护腿
--   新: 卓越腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41457, '卓越腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41458 | Boots of Transcendence
--   旧: 卓越长靴
--   新: 卓越战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41458, '卓越战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41459 | Head of Prophecy
--   旧: 预言之头颅
--   新: 预言头饰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41459, '预言头饰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41460 | Shoulder of Prophecy
--   旧: 预言之肩
--   新: 预言护肩
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41460, '预言护肩') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41461 | Chest of Prophecy
--   旧: 预言之胸甲
--   新: 预言胸甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41461, '预言胸甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41462 | Wrists of Prophecy
--   旧: 预言之护腕
--   新: 预言护腕
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41462, '预言护腕') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41463 | Hands of Prophecy
--   旧: 预言之手
--   新: 预言手套
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41463, '预言手套') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41464 | Waist of Prophecy
--   旧: 预言之腰部
--   新: 预言腰带
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41464, '预言腰带') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41465 | Legs of Prophecy
--   旧: 预言之护腿
--   新: 预言腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41465, '预言腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41466 | Boots of Prophecy
--   旧: 预言之靴
--   新: 预言战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41466, '预言战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41467 | Frostfire Ring
--   旧: 霜火之戒
--   新: 霜火指环
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41467, '霜火指环') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41471 | Netherwind Hands
--   旧: 灵风手
--   新: 灵风手套
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41471, '灵风手套') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41472 | Netherwind Waist
--   旧: 灵风腰部
--   新: 灵风腰带
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41472, '灵风腰带') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41473 | Netherwind Legs
--   旧: 灵风护腿
--   新: 灵风腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41473, '灵风腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41474 | Netherwind Feet
--   旧: 灵风脚部
--   新: 灵风战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41474, '灵风战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41475 | Netherwind Head
--   旧: 灵风头颅
--   新: 灵风头饰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41475, '灵风头饰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41476 | Arcanists Head
--   旧: 奥术师的头颅
--   新: 奥术师头饰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41476, '奥术师头饰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41477 | Arcanists Shoulders
--   旧: 奥术师的护肩
--   新: 奥术师护肩
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41477, '奥术师护肩') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41478 | Arcanists Chest
--   旧: 奥术师的胸甲
--   新: 奥术师胸甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41478, '奥术师胸甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41479 | Arcanists Wrists
--   旧: 奥术师的护腕
--   新: 奥术师护腕
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41479, '奥术师护腕') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41480 | Arcanists Hands
--   旧: 奥术师的手
--   新: 奥术师手套
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41480, '奥术师手套') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41481 | Arcanists Waist
--   旧: 奥术师的腰部
--   新: 奥术师腰带
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41481, '奥术师腰带') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41482 | Arcanists Legs
--   旧: 奥术师的护腿
--   新: 奥术师腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41482, '奥术师腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41483 | Arcanists Feet
--   旧: 奥术师的脚部
--   新: 奥术师战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41483, '奥术师战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41484 | Ring of Redemption
--   旧: 救赎之戒
--   新: 救赎指环
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41484, '救赎指环') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41485 | Judgements Head
--   旧: 审判的头颅
--   新: 审判头饰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41485, '审判头饰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41486 | Judgements Shoulders
--   旧: 审判的护肩
--   新: 审判护肩
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41486, '审判护肩') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41487 | Judgements Chest
--   旧: 审判的胸甲
--   新: 审判胸甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41487, '审判胸甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41488 | Judgements Wrists
--   旧: 审判的护腕
--   新: 审判护腕
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41488, '审判护腕') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41489 | Judgements Hands
--   旧: 审判的手
--   新: 审判手套
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41489, '审判手套') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41490 | Judgements Waist
--   旧: 审判的腰部
--   新: 审判腰带
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41490, '审判腰带') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41491 | Judgements Legs
--   旧: 审判的护腿
--   新: 审判腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41491, '审判腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41492 | Judgements Feet
--   旧: 审判的脚部
--   新: 审判战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41492, '审判战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41493 | Lawbringers Head
--   旧: 秩序之源的头颅
--   新: 秩序之源头饰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41493, '秩序之源头饰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41494 | Lawbringers Shoulders
--   旧: 秩序之源的护肩
--   新: 秩序之源护肩
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41494, '秩序之源护肩') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41495 | Lawbringers Chest
--   旧: 秩序之源的胸甲
--   新: 秩序之源胸甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41495, '秩序之源胸甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41496 | Lawbringers Wrists
--   旧: 秩序之源的护腕
--   新: 秩序之源护腕
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41496, '秩序之源护腕') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41497 | Lawbringers Hands
--   旧: 秩序之源的手
--   新: 秩序之源手套
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41497, '秩序之源手套') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41498 | Lawbringers Waist
--   旧: 秩序之源的腰部
--   新: 秩序之源腰带
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41498, '秩序之源腰带') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41499 | Lawbringers Legs
--   旧: 秩序之源的护腿
--   新: 秩序之源腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41499, '秩序之源腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41500 | Lawbringers Feet
--   旧: 秩序之源的脚部
--   新: 秩序之源战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41500, '秩序之源战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41501 | Head of Ten Storms
--   旧: 无尽风暴头颅
--   新: 无尽风暴头饰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41501, '无尽风暴头饰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41505 | Hands of Ten Storms
--   旧: 无尽风暴手
--   新: 无尽风暴手套
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41505, '无尽风暴手套') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41506 | Waist of Ten Storms
--   旧: 无尽风暴腰部
--   新: 无尽风暴腰带
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41506, '无尽风暴腰带') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41507 | Legs of Ten Storms
--   旧: 无尽风暴护腿
--   新: 无尽风暴腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41507, '无尽风暴腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41508 | Boots of Ten Storms
--   旧: 无尽风暴长靴
--   新: 无尽风暴战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41508, '无尽风暴战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41509 | Earthfury Head
--   旧: 大地之怒头颅
--   新: 大地之怒头饰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41509, '大地之怒头饰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41510 | Earthfury Shoulder
--   旧: 大地之怒肩
--   新: 大地之怒护肩
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41510, '大地之怒护肩') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41513 | Earthfury Hands
--   旧: 大地之怒手
--   新: 大地之怒手套
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41513, '大地之怒手套') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41514 | Earthfury Waist
--   旧: 大地之怒腰部
--   新: 大地之怒腰带
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41514, '大地之怒腰带') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41515 | Earthfury Legs
--   旧: 大地之怒护腿
--   新: 大地之怒腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41515, '大地之怒腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41516 | Earthfury Boots
--   旧: 大地之怒长靴
--   新: 大地之怒战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41516, '大地之怒战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41517 | Ring of the Earthshatterer
--   旧: 碎地者之戒
--   新: 碎地者指环
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41517, '碎地者指环') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41521 | Mastery of Thrown
--   旧: 投掷精通
--   新: 投掷武器精通
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41521, '投掷武器精通') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41523 | Throwing Axes of the Amani
--   旧: 阿曼尼箱之投掷斧
--   新: 阿曼尼投掷斧
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41523, '阿曼尼投掷斧') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41526 | Blackrock Powder
--   旧: 黑石火药粉
--   新: 黑石火药
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41526, '黑石火药') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41527 | Mastery of Crossbows
--   旧: 弩类精通
--   新: 弩精通
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41527, '弩精通') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41529 | A Crimson Stake Through Their Heart
--   旧: 深红树桩贯穿他们的心
--   新: 以赤红木桩穿其心
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41529, '以赤红木桩穿其心') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41530 | Mastery of Bows
--   旧: 弓箭精通
--   新: 弓精通
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41530, '弓精通') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41532 | The Bow of Oaks
--   旧: 橡树之弓
--   新: 橡木之弓
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41532, '橡木之弓') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41533 | Mastery of Polearms
--   旧: 长柄精通
--   新: 长柄武器精通
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41533, '长柄武器精通') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41535 | Appreciated in Time
--   旧: 时间之感激
--   新: 及时赏识
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41535, '及时赏识') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41536 | Mastery of Swords
--   旧: 剑类精通
--   新: 剑精通
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41536, '剑精通') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41538 | Mourning Blade
--   旧: 哀悼剑刃
--   新: 哀悼之刃
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41538, '哀悼之刃') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41539 | Mastery of Hammers
--   旧: 锤类精通
--   新: 锤精通
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41539, '锤精通') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41542 | Mastery of Axes
--   旧: 斧类精通
--   新: 斧精通
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41542, '斧精通') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41544 | Honoring the Warrior
--   旧: 缅怀战士
--   新: 悼念战士
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41544, '悼念战士') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41547 | Legend of Eskhandar
--   旧: 艾斯卡达尔传说
--   新: 艾斯卡达尔的传说
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41547, '艾斯卡达尔的传说') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41550 | The Ripper
--   旧: 开膛手
--   新: 开膛者
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41550, '开膛者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41551 | Pupil Once More
--   旧: 门生又一次更多的
--   新: 再为学徒
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41551, '再为学徒') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41578 | Helm of the Talon
--   旧: 爪之头盔
--   新: 利爪头盔
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41578, '利爪头盔') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41579 | Shoulderguards of the Talon
--   旧: 爪之护肩
--   新: 利爪护肩
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41579, '利爪护肩') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41580 | Robes of the Talon
--   旧: 爪之长袍
--   新: 利爪长袍
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41580, '利爪长袍') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41581 | Pants of the Talon
--   旧: 爪之短裤
--   新: 利爪腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41581, '利爪腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41582 | Boots of the Talon
--   旧: 爪之长靴
--   新: 利爪战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41582, '利爪战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41583 | Amulet of the Talon
--   旧: 爪之护符
--   新: 利爪护符
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41583, '利爪护符') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41587 | Nathrezim Pants
--   旧: 纳斯雷兹姆短裤
--   新: 纳斯雷兹姆腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41587, '纳斯雷兹姆腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41588 | Nathrezim Boots
--   旧: 纳斯雷兹姆长靴
--   新: 纳斯雷兹姆战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41588, '纳斯雷兹姆战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41590 | Helm of the Brotherhood
--   旧: 兄弟会之头盔
--   新: 兄弟会头盔
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41590, '兄弟会头盔') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41591 | Shoulderguards of the Brotherhood
--   旧: 兄弟会之护肩
--   新: 兄弟会护肩
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41591, '兄弟会护肩') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41592 | Chest of the Brotherhood
--   旧: 兄弟会之胸甲
--   新: 兄弟会胸甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41592, '兄弟会胸甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41593 | Pants of the Brotherhood
--   旧: 兄弟会之短裤
--   新: 兄弟会腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41593, '兄弟会腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41594 | Boots of the Brotherhood
--   旧: 兄弟会之长靴
--   新: 兄弟会战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41594, '兄弟会战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41595 | Amulet of the Brotherhood
--   旧: 兄弟会之护符
--   新: 兄弟会护符
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41595, '兄弟会护符') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41596 | Helm of Pestilence
--   旧: 瘟疫之头盔
--   新: 瘟疫头盔
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41596, '瘟疫头盔') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41597 | Shoulderguards of Pestilence
--   旧: 瘟疫之护肩
--   新: 瘟疫护肩
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41597, '瘟疫护肩') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41598 | Robes of Pestilence
--   旧: 瘟疫之长袍
--   新: 瘟疫长袍
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41598, '瘟疫长袍') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41599 | Pants of Pestilence
--   旧: 瘟疫之短裤
--   新: 瘟疫腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41599, '瘟疫腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41600 | Boots of Pestilence
--   旧: 瘟疫之长靴
--   新: 瘟疫战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41600, '瘟疫战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41601 | Amulet of Pestilence
--   旧: 瘟疫之护符
--   新: 瘟疫护符
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41601, '瘟疫护符') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41602 | Trickster Helm
--   旧: 欺诈者头盔
--   新: 狡诈头盔
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41602, '狡诈头盔') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41603 | Trickster Shoulderguards
--   旧: 欺诈者护肩
--   新: 狡诈护肩
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41603, '狡诈护肩') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41604 | Trickster Chest
--   旧: 欺诈者胸甲
--   新: 狡诈胸甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41604, '狡诈胸甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41605 | Trickster Pants
--   旧: 欺诈者短裤
--   新: 狡诈腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41605, '狡诈腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41606 | Trickster Boots
--   旧: 欺诈者长靴
--   新: 狡诈战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41606, '狡诈战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41607 | Trickster Amulet
--   旧: 欺诈者护符
--   新: 狡诈护符
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41607, '狡诈护符') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41611 | Ravenstalker Legs
--   旧: 猎鸦者护腿
--   新: 猎鸦者腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41611, '猎鸦者腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41612 | Ravenstalker Boots
--   旧: 猎鸦者长靴
--   新: 猎鸦者战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41612, '猎鸦者战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41618 | Stormhowl Boots
--   旧: 风暴咆哮长靴
--   新: 风暴咆哮战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41618, '风暴咆哮战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41620 | Helm of the Guardian
--   旧: 守护者之头盔
--   新: 守护者头盔
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41620, '守护者头盔') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41621 | Shoulders of the Guardian
--   旧: 守护者之护肩
--   新: 守护者护肩
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41621, '守护者护肩') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41622 | Robes of the Guardian
--   旧: 守护者之长袍
--   新: 守护者长袍
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41622, '守护者长袍') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41623 | Legs of the Guardian
--   旧: 守护者之护腿
--   新: 守护者腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41623, '守护者腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41624 | Boots of the Guardian
--   旧: 守护者之长靴
--   新: 守护者战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41624, '守护者战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41625 | Amulet of the Guardian
--   旧: 守护者之护符
--   新: 守护者护符
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41625, '守护者护符') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41629 | Lionheart Legs
--   旧: 狮心护腿
--   新: 狮心腿甲
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41629, '狮心腿甲') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41630 | Lionheart Boots
--   旧: 狮心长靴
--   新: 狮心战靴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41630, '狮心战靴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41633 | Bonescythe Ring
--   旧: 骨镰之戒
--   新: 骨镰指环
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41633, '骨镰指环') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41635 | Chopping Defias
--   旧: 砍伐迪菲亚
--   新: 痛击迪菲亚
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41635, '痛击迪菲亚') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41637 | School Assistance
--   旧: 群帮助
--   新: 学院的援手
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41637, '学院的援手') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41640 | Restless
--   旧: 不安的
--   新: 不得安宁
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41640, '不得安宁') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41641 | Gone With The Wind
--   旧: 风之消失
--   新: 随风而逝
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41641, '随风而逝') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41646 | Covering All Possibilities
--   旧: 覆盖全无限未来
--   新: 有备无患
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41646, '有备无患') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41656 | Bounty on Dragonmaw
--   旧: 龙喉之赏金
--   新: 悬赏：龙喉
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41656, '悬赏：龙喉') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41658 | Destruction of the Dragonmaw
--   旧: 龙喉之毁灭
--   新: 消灭龙喉
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41658, '消灭龙喉') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41659 | The SalGalaz Mines
--   旧: 塞尔加拉兹矿井
--   新: 萨尔加拉兹矿场
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41659, '萨尔加拉兹矿场') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41660 | Shadowforge Incursions
--   旧: 暗炉入侵
--   新: 暗炉城的进犯
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41660, '暗炉城的进犯') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41661 | Amberpaw Bounty
--   旧: 琥珀爪赏金
--   新: 悬赏：琥珀爪
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41661, '悬赏：琥珀爪') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41665 | In Amber Disgust
--   旧: 在琥珀厌恶
--   新: 琥珀色的厌恶
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41665, '琥珀色的厌恶') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41667 | In Need of Shoes
--   旧: 鞋之在需求
--   新: 需要鞋子
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41667, '需要鞋子') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41671 | Remember the Dead
--   旧: 铭记奥特复活死者
--   新: 铭记亡者
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41671, '铭记亡者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41672 | Amberfin Bounty
--   旧: 琥珀鳍赏金
--   新: 悬赏：琥珀鳍
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41672, '悬赏：琥珀鳍') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41674 | Wine Avenger
--   旧: 酒复仇者
--   新: 葡萄酒复仇者
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41674, '葡萄酒复仇者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41678 | An Amber Light
--   旧: 琥珀轻型
--   新: 琥珀色的光
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41678, '琥珀色的光') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41679 | Charred Bones
--   旧: 焦黑骸骨
--   新: 焦黑的骸骨
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41679, '焦黑的骸骨') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41684 | Shadows Vision
--   旧: 暗影心灵视界
--   新: 暗影视界
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41684, '暗影视界') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41685 | A Veiled Threat
--   旧: 笼罩阴影威胁
--   新: 隐晦的威胁
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41685, '隐晦的威胁') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41686 | Into The Tortured Past
--   旧: 进入被折磨的往日的
--   新: 走进饱受折磨的往昔
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41686, '走进饱受折磨的往昔') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41688 | To Look A Gift Horse In The Mouth
--   旧: 老礼物马口齿
--   新: 馈赠莫挑剔
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41688, '馈赠莫挑剔') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41689 | A Good Samaritan
--   旧: 好善人
--   新: 好心人
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41689, '好心人') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41693 | The Last Lines
--   旧: 最后的切断线
--   新: 最后的遗言
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41693, '最后的遗言') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41695 | Noppsy Spickerspan
--   旧: 诺普西刺距
--   新: 诺普西·刺距
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41695, '诺普西·刺距') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41697 | Demons Galore
--   旧: 恶魔丰盛
--   新: 恶魔遍地
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41697, '恶魔遍地') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41699 | Harrowing News
--   旧: 痛心疾首的消息
--   新: 痛心的消息
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41699, '痛心的消息') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41702 | Tide-ying Up
--   旧: 潮汐唤醒
--   新: 收拾潮水
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41702, '收拾潮水') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41703 | Favor For Spare Parts
--   旧: 箱车零件神恩
--   新: 以零件换人情
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41703, '以零件换人情') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41706 | Foul Essences
--   旧: 邪恶的精华
--   新: 污秽精华
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41706, '污秽精华') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41707 | Fungal Fever
--   旧: 菌类热病
--   新: 真菌热
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41707, '真菌热') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41711 | Calming The Tempest
--   旧: 平静暴雨
--   新: 平息风暴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41711, '平息风暴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41712 | Letter Far From Home
--   旧: 家之信件术
--   新: 远方家书
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41712, '远方家书') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41715 | Again Into the Great Ossuary
--   旧: 重回尸骨储藏所
--   新: 再入大骨库
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41715, '再入大骨库') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41717 | The Dragonmaw Threat
--   旧: 龙喉威胁
--   新: 龙喉的威胁
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41717, '龙喉的威胁') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41718 | The Dragonmaw Orders
--   旧: 龙喉计划书
--   新: 龙喉的指令
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41718, '龙喉的指令') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41720 | Stolgaz Documents
--   旧: 斯托尔加兹文件
--   新: 斯托尔加兹的文件
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41720, '斯托尔加兹的文件') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41722 | Shatterblade Stew
--   旧: 裂刃炖
--   新: 裂刃炖菜
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41722, '裂刃炖菜') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41723 | Bounty on Wild Maw
--   旧: 野生巨口赏金
--   新: 悬赏：荒野巨口
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41723, '悬赏：荒野巨口') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41725 | Dark Iron Components
--   旧: 黑铁零件
--   新: 黑铁部件
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41725, '黑铁部件') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41730 | The Power of Uthokk
--   旧: 乌索克之力量
--   新: 乌瑟克之力
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41730, '乌索克之力') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41731 | The Ritual of Uthokk
--   旧: 乌索克之仪式
--   新: 乌瑟克的仪式
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41731, '乌索克的仪式') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41738 | Yortheggs Ritual
--   旧: 约尔塞格的仪式
--   新: 约尔瑟格的仪式
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41738, '约尔瑟格的仪式') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41745 | The Power of the Goddess
--   旧: 月神之力量
--   新: 女神之力
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41745, '女神之力') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41748 | The Master and the Student
--   旧: 大师学员
--   新: 师徒
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41748, '师徒') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41749 | Stone Golem Salvage
--   旧: 石傀儡和珠宝
--   新: 石傀儡的残骸
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41749, '石傀儡的残骸') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41750 | Gowlfangs Defeat
--   旧: 高牙的击败
--   新: 击败孤峰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41750, '击败孤峰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41751 | The Dragonmaw Brood
--   旧: 龙喉雏龙之语
--   新: 龙喉的幼崽
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41751, '龙喉的幼崽') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41753 | A Blaze Unending
--   旧: 光辉不灭
--   新: 不灭之焰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41753, '不灭之焰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41754 | The Redbrand Lie
--   旧: 红印谎言
--   新: 红印的谎言
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41754, '红印的谎言') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41755 | The Redbrand Lie
--   旧: 红印谎言
--   新: 红印的谎言
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41755, '红印的谎言') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41758 | Tainted Brambleheart
--   旧: 污染荆棘之心
--   新: 污染的荆棘之心
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41758, '污染的荆棘之心') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41760 | Skull And Bones
--   旧: 颅骨骸骨
--   新: 颅骨与骸骨
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41760, '颅骨与骸骨') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41768 | The Messenger Of Northwind
--   旧: 北风之信使
--   新: 北风的信使
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41768, '北风的信使') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41774 | Pedestal of Unity
--   旧: 团结之底座
--   新: 团结之基
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41774, '团结之基') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41788 | Ursan Heights
--   旧: 乌萨高地
--   新: 熊怪高地
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41788, '熊怪高地') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41790 | Reclaiming the Moonwell
--   旧: 夺回焦炭月亮井哨
--   新: 夺回月亮井
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41790, '夺回月亮井') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41793 | Scars of the Past
--   旧: 过去的SCARMS
--   新: 往日的伤痕
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41793, '往日的伤痕') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41794 | The Storms of Balor
--   旧: 巴罗之风暴
--   新: 巴洛的风暴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41794, '巴洛的风暴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41795 | A Unknown Letter
--   旧: 未知信件
--   新: 一封陌生的信
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41795, '一封陌生的信') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41797 | A Dear Friend
--   旧: 亲爱的朋友
--   新: 一位挚友
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41797, '一位挚友') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41800 | The Grim Hollow
--   旧: 冷酷谷
--   新: 阴森谷
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41800, '阴森谷') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41801 | The Blue Dragonkin
--   旧: 蓝色龙类
--   新: 蓝色龙裔
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41801, '蓝色龙裔') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41802 | Tomb of Ancestors
--   旧: 先祖之墓穴
--   新: 先祖之墓
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41802, '先祖之墓') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41804 | Memories of Dark Iron
--   旧: 黑铁哀思
--   新: 黑铁的记忆
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41804, '黑铁的记忆') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41808 | The Destroyer of Skardyn
--   旧: 斯卡丁之毁灭者
--   新: 斯卡丁的毁灭者
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41808, '斯卡丁的毁灭者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41810 | Verdant Rune
--   旧: 绿色符文
--   新: 翠绿符文
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41810, '翠绿符文') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41816 | The First of Many
--   旧: 众多之第一
--   新: 众多中的第一个
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41816, '众多中的第一个') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41819 | A Dark Tide Will Rise
--   旧: 黑暗潮意志高地
--   新: 黑暗之潮将起
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41819, '黑暗之潮将起') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41821 | Innocence Lost
--   旧: 无辜迷失
--   新: 逝去的纯真
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41821, '逝去的纯真') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41823 | Living Fungus
--   旧: 活性蘑菇
--   新: 活体真菌
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41823, '活体真菌') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41827 | Old Friend
--   旧: 旧朋友
--   新: 老朋友
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41827, '老朋友') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41828 | Bugs on My Island
--   旧: 我的岛屿虫子
--   新: 我岛上的虫子
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41828, '我岛上的虫子') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41829 | Eyes of Stormreaver
--   旧: 风暴掠夺者之双眼
--   新: 风暴掠夺者之眼
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41829, '风暴掠夺者之眼') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41830 | Deep in the Mines
--   旧: 矿场之深渊
--   新: 矿洞深处
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41830, '矿洞深处') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41833 | It Cant Rain All the Time
--   旧: 它不能施放雨全时间
--   新: 雨不会一直下
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41833, '雨不会一直下') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41836 | Lady Who?
--   旧: 雷蒂何人？
--   新: 哪位女士？
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41836, '哪位女士？') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41843 | Assassin In Training
--   旧: 训练之刺客
--   新: 受训的刺客
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41843, '受训的刺客') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41845 | The Will of Balor
--   旧: 巴罗之意志
--   新: 巴洛的意志
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41845, '巴洛的意志') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41848 | To Cure the Withered
--   旧: 术枯萎
--   新: 治愈枯萎者
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41848, '治愈枯萎者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41849 | To Cure the Withered
--   旧: 术枯萎
--   新: 治愈枯萎者
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41849, '治愈枯萎者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41850 | The Gemstone of Naraz
--   旧: 纳拉兹之宝石
--   新: 纳拉兹的宝石
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41850, '纳拉兹的宝石') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41851 | The Gemstone of Naraz
--   旧: 纳拉兹之宝石
--   新: 纳拉兹的宝石
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41851, '纳拉兹的宝石') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41857 | Miregill Distraction
--   旧: 沼鳃干扰
--   新: 沼鳃的骚扰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41857, '沼鳃的骚扰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41859 | After All This Time
--   旧: 阵亡后全这个时间
--   新: 时隔多年
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41859, '时隔多年') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41866 | Assault on Gethkar
--   旧: 盖斯卡尔之突袭
--   新: 突袭盖斯卡尔
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41866, '突袭盖斯卡尔') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41867 | Blemishes on the Land
--   旧: 暗雷之瑕疵
--   新: 大地上的污痕
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41867, '大地上的污痕') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41868 | Shadow Curse
--   旧: 黑影诅咒
--   新: 暗影诅咒
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41868, '暗影诅咒') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41869 | Death to Grimscale
--   旧: 铜鳞之死亡
--   新: 格里姆斯凯尔必须死
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41869, '格里姆斯凯尔必须死') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41870 | Grimscale Revenge
--   旧: 铜鳞复仇
--   新: 格里姆斯凯尔的复仇
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41870, '格里姆斯凯尔的复仇') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41871 | Preparations for War
--   旧: 战争之准备
--   新: 备战
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41871, '备战') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41872 | Provisions for War
--   旧: 战争之补给品
--   新: 战备补给
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41872, '战备补给') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41876 | Ore Must Flow
--   旧: 矿石除掉喷涌
--   新: 矿石不能停
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41876, '矿石不能停') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41877 | Ore Must Flow
--   旧: 矿石除掉喷涌
--   新: 矿石不能停
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41877, '矿石不能停') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41878 | Ore Must Flow
--   旧: 矿石除掉喷涌
--   新: 矿石不能停
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41878, '矿石不能停') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41879 | Crystal Clear Impression
--   旧: 水晶透明印象
--   新: 一目了然
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41879, '一目了然') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41881 | Brangars Folly
--   旧: 布兰加之愚
--   新: 布兰加的愚行
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41881, '布兰加的愚行') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41884 | Destruction of the Dragonmaw
--   旧: 龙喉之毁灭
--   新: 消灭龙喉
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41884, '消灭龙喉') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41886 | Creeping Trouble
--   旧: 慢性苦毒药港口麻烦
--   新: 蔓延的麻烦
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41886, '蔓延的麻烦') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41887 | The Recipe of Concoction of the Emerald M
--   旧: 调和物翡翠猫鼬配方
--   新: 翡翠猫鼬药剂配方
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41887, '翡翠猫鼬药剂配方') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41888 | Call to Arms: Cleansing the Corruption
--   旧: 武器之使用召唤：净化烈焰腐蚀术
--   新: 应召而战：净化腐蚀
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41888, '应召而战：净化腐蚀') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41889 | Call to Arms: Molten Assault
--   旧: 武器之使用召唤：熔岩突袭
--   新: 应召而战：熔岩突袭
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41889, '应召而战：熔岩突袭') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41890 | Call to Arms: Dungeon Delving
--   旧: 武器之使用召唤：地下城探索
--   新: 应召而战：深入地下城
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41890, '应召而战：深入地下城') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41891 | Call to Arms: Cleansing the Corruption
--   旧: 武器之使用召唤：净化烈焰腐蚀术
--   新: 应召而战：净化腐蚀
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41891, '应召而战：净化腐蚀') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41892 | Call to Arms: Molten Assault
--   旧: 武器之使用召唤：熔岩突袭
--   新: 应召而战：熔岩突袭
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41892, '应召而战：熔岩突袭') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41893 | The Ancient Wildhammer Tome
--   旧: 古老蛮锤秘典
--   新: 古老的蛮锤秘典
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41893, '古老的蛮锤秘典') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41896 | The Shadowed Hollow
--   旧: 阴影笼罩的谷
--   新: 幽影谷
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41896, '幽影谷') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41897 | Call to Arms: Dungeon Delving
--   旧: 武器之使用召唤：地下城探索
--   新: 应召而战：深入地下城
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41897, '应召而战：深入地下城') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41898 | Twisted Relations
--   旧: 扭曲关系
--   新: 扭曲的关系
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41898, '扭曲的关系') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41900 | Sapta of Tranquility
--   旧: 宁静灵药
--   新: 宁静灵契
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41900, '宁静灵契') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41901 | Sapta of Communion
--   旧: 神性灵药
--   新: 共心灵契
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41901, '共心灵契') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41902 | Sapta of Harmony
--   旧: 和谐灵药
--   新: 和谐灵契
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41902, '和谐灵契') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41903 | Sapta of Kinship
--   旧: 亲源灵药
--   新: 亲缘灵契
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41903, '亲缘灵契') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41904 | Sapta of Reslilence
--   旧: 复原之萨普塔
--   新: 坚韧灵契
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41904, '坚韧灵契') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41905 | Dark Iron Aggression
--   旧: 黑铁侵略
--   新: 黑铁的进犯
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41905, '黑铁的进犯') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41906 | No Mercy For The Wicked
--   旧: 邪恶之无仁慈
--   新: 对恶徒绝不姑息
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41906, '对恶徒绝不姑息') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41908 | Raw Draenethyst Formation
--   旧: 新鲜的德莱尼水泛光
--   新: 原生的德莱尼水晶矿脉
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41908, '原生的德莱尼水晶矿脉') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41909 | Glowing Draenethyst Cluster
--   旧: 发光的德莱尼水簇
--   新: 发光的德莱尼水晶簇
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41909, '发光的德莱尼水晶簇') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41910 | Arlia of the Morogai
--   旧: 摩洛盖之阿里亚
--   新: 摩洛盖的阿尔莉亚
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41910, '摩洛盖的阿尔莉亚') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41911 | Wolf in Sheeps Clothing
--   旧: 绵羊的衣物狼骑兵
--   新: 披着羊皮的狼
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41911, '披着羊皮的狼') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41913 | Draenei Divination
--   旧: 德莱尼预言水晶球
--   新: 德莱尼占卜
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41913, '德莱尼占卜') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41916 | The Elders End
--   旧: 长者境之末
--   新: 长者的末路
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41916, '长者的末路') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41918 | Silken Song
--   旧: 丝质森歌
--   新: 丝歌
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41918, '丝歌') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41919 | More Silk for the Wounded
--   旧: 受伤的更多的丝质
--   新: 为伤员讨要更多丝绸
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41919, '为伤员讨要更多丝绸') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41920 | Fallen One Cargo
--   旧: 坠落者走的货物
--   新: 坠落者的货物
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41920, '坠落者的货物') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41922 | Homecoming
--   旧: 孤的归来
--   新: 归乡
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41922, '归乡') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41930 | Proof of Conviction
--   旧: 定罪之证明
--   新: 信念的明证
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41930, '信念的明证') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41931 | The Corruption of Timbermaw Hold
--   旧: 木喉要塞腐蚀术
--   新: 木喉要塞的腐化
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41931, '木喉要塞的腐化') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41932 | Ancient Furbolg Remedies
--   旧: 古老熊怪疗法
--   新: 古老的熊怪药方
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41932, '古老的熊怪药方') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41933 | Unbridled Darkness
--   旧: 放肆黑暗
--   新: 无羁的黑暗
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41933, '无羁的黑暗') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41934 | What Remains
--   旧: 什么遗骸
--   新: 残留之物
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41934, '残留之物') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41942 | The Plaguewood
--   旧: 病木林
--   新: 瘟疫林
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41942, '病木林') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41943 | Foul Waters
--   旧: 邪恶的法袍
--   新: 污浊之水
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41943, '污浊之水') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41944 | The Long Hunt
--   旧: 长狩猎
--   新: 漫长的狩猎
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41944, '漫长的狩猎') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41946 | Farm Raiders
--   旧: 农场掠夺者
--   新: 农场劫掠者
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41946, '农场劫掠者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41952 | Out of the Moonlight
--   旧: 月光之根除
--   新: 走出月光
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41952, '走出月光') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41953 | Draenethyst Recovery
--   旧: 德莱尼水恢复
--   新: 夺回德莱尼水晶
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41953, '夺回德莱尼水晶') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41956 | Not Alone
--   旧: 夜未尽独自
--   新: 并不孤单
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41956, '并不孤单') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41957 | The Root of it All
--   旧: 它全定身
--   新: 万恶之源
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41957, '万恶之源') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41959 | The Flute of Spirits
--   旧: 灵魂之长笛
--   新: 灵魂长笛
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41959, '灵魂长笛') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41961 | Hidden in Plain Sight
--   旧: 普通视界隐藏生物
--   新: 藏于明处
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41961, '藏于明处') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41963 | Wisdom of Ten Thousand Years
--   旧: 恒古智慧
--   新: 万年的智慧
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41963, '万年的智慧') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41965 | Purging Flames
--   旧: 净化烈焰
--   新: 涤罪之焰
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41965, '涤罪之焰') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41967 | The Need to Survive
--   旧: 生存之需求
--   新: 求生的需要
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41967, '求生的需要') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41969 | Raiments of Ritual
--   旧: 仪式之法衣
--   新: 仪式法衣
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41969, '仪式法衣') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41970 | The Missing Caravans
--   旧: 浓于水商队
--   新: 失踪的商队
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41970, '失踪的商队') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41972 | Report to Moonhoof Village
--   旧: 月蹄村报告
--   新: 向月蹄村汇报
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41972, '向月蹄村汇报') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41975 | Zalwans Cut
--   旧: 扎尔万的切割
--   新: 扎尔万的伤口
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41975, '扎尔万的伤口') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41976 | In Search of Tauren Relics
--   旧: 牛头人遗物在寻找
--   新: 寻找牛头人遗物
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41976, '寻找牛头人遗物') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41977 | Relics of the Windhorn Tribe
--   旧: 风角部族遗物
--   新: 风角部族的遗物
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41977, '风角部族的遗物') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41978 | The Wrath of Malgan
--   旧: 马尔甘之愤怒
--   新: 马尔甘之怒
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41978, '马尔甘之怒') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41979 | Rumors of the Deathtotem
--   旧: 死亡图腾之地精的谣言
--   新: 死亡图腾的传闻
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41979, '死亡图腾的传闻') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41980 | Uncovering the Rumors
--   旧: 揭露地精的谣言
--   新: 查证传闻
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41980, '查证传闻') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41991 | Preparation for Hibernation
--   旧: 休眠之伺机待发
--   新: 为冬眠做准备
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41991, '为冬眠做准备') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41993 | Hiding in the Shade
--   旧: 暗影之躲藏
--   新: 藏身暗影
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41993, '藏身暗影') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41994 | Shade Mother
--   旧: 暗影母亲
--   新: 暗影之母
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41994, '暗影之母') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41995 | Mindless Monster
--   旧: 无脑的怪物
--   新: 无智的怪物
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41995, '无智的怪物') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41997 | Taste for Hydra
--   旧: 多头蛇之精华
--   新: 多头蛇的滋味
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41997, '多头蛇的滋味') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41998 | Collecting Draenethyst
--   旧: 收集德莱尼水
--   新: 收集德莱尼水晶
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41998, '收集德莱尼水晶') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 41999 | Before They Hatch
--   旧: 从前他们来自方孵卵
--   新: 趁它们孵化之前
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (41999, '趁它们孵化之前') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42000 | Highborne Burden
--   旧: 上层精灵重担
--   新: 上层精灵的重担
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42000, '上层精灵的重担') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42006 | Searching for Archaeologist Evenpike
--   旧: 考古学家匀矛寻找
--   新: 寻找考古学家伊文派克
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42006, '寻找考古学家伊文派克') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42007 | The Shattered Disc
--   旧: 碎裂圆盘
--   新: 碎裂的圆盘
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42007, '碎裂的圆盘') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42012 | Actual Collector of Draenethyst
--   旧: 德莱尼水之实际的收集者
--   新: 真正的德莱尼水晶收藏者
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42012, '真正的德莱尼水晶收藏者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42013 | The Windhorn Burden
--   旧: 风角重担
--   新: 风角的重担
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42013, '风角的重担') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42014 | Roots of the Grove
--   旧: 树林之根须
--   新: 树林之根
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42014, '树林之根') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42015 | Lady Stargazer
--   旧: 雷蒂星眼
--   新: 星眼女士
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42015, '星眼女士') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42016 | In Lucid Dreams
--   旧: 在清醒的梦
--   新: 清明梦中
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42016, '清明梦中') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42017 | Heart Full of Shadows
--   旧: 吞噬暗影之心完全成长
--   新: 充满暗影的心
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42017, '充满暗影的心') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42019 | The Mighty Elekk
--   旧: 强力雷象
--   新: 强壮的雷象
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42019, '强壮的雷象') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42023 | Guile of Nature
--   旧: 自然之狡诈
--   新: 自然的狡黠
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42023, '自然的狡黠') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42024 | Burden of Nature
--   旧: 自然之重担
--   新: 自然的重担
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42024, '自然的重担') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42025 | Embrace of Nature
--   旧: 自然之拥抱
--   新: 自然的拥抱
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42025, '自然的拥抱') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42026 | Grasp of Nature
--   旧: 自然之握
--   新: 自然的掌控
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42026, '自然的掌控') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42027 | Vigor of Nature
--   旧: 自然之精力
--   新: 自然的活力
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42027, '自然的活力') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42028 | Path of Nature
--   旧: 自然之道路
--   新: 自然之道
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42028, '自然之道') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42031 | Elementium Lock
--   旧: 元素锁具
--   新: 源质锁具
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42031, '源质锁具') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42032 | Lock Blueprints: Crimson Friar Freidhelm
--   旧: 锁具钻探蓝图：深红修士弗雷德海姆
--   新: 锁具蓝图：深红修士弗雷德海姆
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42032, '锁具蓝图：深红修士弗雷德海姆') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42033 | Lock Blueprints: Sorcerer-Thane Thaurissa
--   旧: 锁具钻探蓝图：巫师领主索瑞森
--   新: 锁具蓝图：巫师领主索瑞森
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42033, '锁具蓝图：巫师领主索瑞森') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42034 | To Fit a Mold
--   旧: 返回店模具
--   新: 适配模具
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42034, '适配模具') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42037 | Airfield Supplies
--   旧: 机场补给品
--   新: 机场补给
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42037, '机场补给') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42040 | A Grave Misunderstanding!
--   旧: 严重的误会！
--   新: 天大的误会！
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42040, '天大的误会！') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42041 | To Survive in the Jungle
--   旧: 丛林之返回生存
--   新: 在丛林中求生
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42041, '在丛林中求生') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42044 | A Plea for Help
--   旧: 帮助之恳求
--   新: 求助的请托
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42044, '求助的请托') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42045 | Tainted Rune
--   旧: 污染符文
--   新: 受污染的符文
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42045, '受污染的符文') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42046 | Ritual Ready
--   旧: 仪式准备就绪
--   新: 仪式就绪
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42046, '仪式就绪') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42049 | In Need of Water
--   旧: 水之在需求
--   新: 需要水
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42049, '需要水') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42051 | Bound in Stone
--   旧: 石之束缚
--   新: 困于石中
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42051, '困于石中') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42052 | In Blue Defiance
--   旧: 在蓝色挑衅
--   新: 蓝色的抗争
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42052, '蓝色的抗争') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42055 | In Favor of the Three Siblings
--   旧: 表面上有兄弟姐妹在神恩
--   新: 三兄妹的嘱托
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42055, '三兄妹的嘱托') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42057 | Light of Anshe
--   旧: 太阳神之光
--   新: 安舍之光
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42057, '安舍之光') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42058 | Light of Anshe
--   旧: 太阳神之光
--   新: 安舍之光
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42058, '安舍之光') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42061 | Sunsworn Expedition
--   旧: 逐日者远征队
--   新: 誓日远征队
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42061, '誓日远征队') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42062 | Endless Vigil
--   旧: 无尽堡垒
--   新: 无尽的守望
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42062, '无尽的守望') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42063 | Delivery from Talendris
--   旧: 塔伦德里斯之便携短
--   新: 塔伦德里斯的货件
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42063, '塔伦德里斯的货件') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42069 | The Withered Den
--   旧: 枯萎守卫
--   新: 枯萎者巢穴
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42069, '枯萎者巢穴') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42072 | Bloodhoof Stands with Moonhoof
--   旧: 月蹄之血蹄屹立
--   新: 血蹄与月蹄同在
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42072, '血蹄与月蹄同在') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42074 | Seeking the Truth
--   旧: 寻找科尔真言
--   新: 追寻真相
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42074, '追寻真相') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42075 | Price of Betrayal
--   旧: 的背叛之昂贵的
--   新: 背叛的代价
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42075, '背叛的代价') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42076 | Return to the Dream
--   旧: 梦境之返回
--   新: 重返梦境
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42076, '重返梦境') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42083 | The Rod of Preservation
--   旧: 者之魔棒
--   新: 守护之杖
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42083, '守护之杖') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42084 | A Tale of Scales
--   旧: 鳞片之故事
--   新: 鳞片的故事
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42084, '鳞片的故事') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42086 | Echoes of Nendis
--   旧: 南迪斯之回响
--   新: 南迪斯的回响
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42086, '南迪斯的回响') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42087 | The Light of Elunaris
--   旧: 艾露娜瑞斯之轻型
--   新: 艾露娜瑞斯之光
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42087, '艾露娜瑞斯之光') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42089 | Scales of the Tideblade
--   旧: 潮刃之鳞片
--   新: 潮刃之鳞
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42089, '潮刃之鳞') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42091 | Word to the High Priestess
--   旧: 高阶女祭司话语
--   新: 禀告高阶女祭司
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42091, '禀告高阶女祭司') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42093 | Feathers on Point
--   旧: 点之羽毛
--   新: 送往前哨的羽毛
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42093, '送往前哨的羽毛') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42097 | Keeper of the Broken Grove
--   旧: 损坏的树林看守者
--   新: 残破树林的看守者
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42097, '残破树林的看守者') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42098 | The Thorn Gorge Frontier
--   旧: 荆棘峡谷边疆
--   新: 荆棘峡谷边境
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42098, '荆棘峡谷边境') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 42099 | The Thorn Gorge Defense
--   旧: 荆棘峡谷防御
--   新: 荆棘峡谷防线
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (42099, '荆棘峡谷防线') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 50310 | Goblin Engineering At Its Finest!
--   旧: 地精工程，震撼人心！
--   新: 地精工程的极致！
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (50310, '地精工程的极致！') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 50326 | Grizzlore Wants Thunder
--   旧: 格里兹罗想要更多雷酒
--   新: 格里兹罗想要雷霆麦酒
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (50326, '格里兹罗想要雷霆麦酒') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 50328 | Jolly Holly Dances Prolly
--   旧: 跳支欢乐的舞
--   新: 荷莉大概想跳舞
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (50328, '荷莉大概想跳舞') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 55028 | The “Hidden” Crew
--   旧: “消失”的船员
--   新: “隐藏”的船员
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (55028, '“隐藏”的船员') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 55043 | The Brightwater Logs
--   旧: 亮水的航海日志
--   新: 亮水号的航海日志
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (55043, '亮水号的航海日志') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

-- 80109 | Zug-zug Or Somethin
--   旧: Zug-zug或某某\’
--   新: Zug-zug 之类的
INSERT INTO `locales_quest` (`entry`, `Title_loc4`) VALUES (80109, 'Zug-zug 之类的') ON DUPLICATE KEY UPDATE `Title_loc4` = VALUES(`Title_loc4`);

