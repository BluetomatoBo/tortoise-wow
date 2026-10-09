-- 实体名修正（locales_creature / locales_gameobject / locales_item）
--
-- 任务文本里已经按这些译名书写，若不修正生物名，玩家会在任务目标和 NPC 头顶
-- 看到两个不同的名字。这里只改**已经确认是糟糕音译**的两条，且带原值条件，
-- 值变了就不会重复覆盖（可以安全地重复导入）。
--
--  62300  Lloyd          尔奥德           → 劳埃德        （纯音译丢字，Lloyd 通译「劳埃德」）
--  62034  Nora Steamsight 诺拉斯特伊姆西特 → 诺拉·汽望    （整名音译成一串，改为按词义译姓氏，与「风暴烈酒」一类同法）
--
-- 生效：mangosd 控制台 `.reload locales_creature`

SET NAMES utf8mb4;

UPDATE `locales_creature` SET `name_loc4` = '劳埃德'
 WHERE `entry` = 62300 AND `name_loc4` = '尔奥德';

UPDATE `locales_creature` SET `name_loc4` = '诺拉·汽望'
 WHERE `entry` = 62034 AND `name_loc4` = '诺拉斯特伊姆西特';

-- 第二批：任务文本已按这些译名书写，库内原值要么是错配、要么是一整串音译
--
-- 【2026-10-09 修正】下面这条原来把 entry 写成了 62739，而 62739 是「追踪者奥尔索尔」
-- （Orthol the Tracker，弓箭商），Narkogg the Dark 是 62740。写错 entry 的后果是：
-- 库里的 Orthol 被盖上了 Narkogg 的名字，玩家在 NPC 头顶看到 NPC 名字与任务目标对不上。
-- 现改为正确 entry，并保留一条复原语句（库内若已被误改，导入本文件即自愈）。
UPDATE `locales_creature` SET `name_loc4` = '追踪者奥尔索尔'
 WHERE `entry` = 62739 AND `name_loc4` = '黑暗者纳科格';

UPDATE `locales_creature` SET `name_loc4` = '黑暗者纳科格'
 WHERE `entry` = 62740 AND `name_loc4` = '黑暗纳尔科格';            -- Narkogg the Dark

UPDATE `locales_creature` SET `name_loc4` = '阿尔古尔·锈印'
 WHERE `entry` = 63188 AND `name_loc4` = '阿尔古尔鲁斯特布拉恩德';   -- Argur Rustbrand

UPDATE `locales_creature` SET `name_loc4` = '哨兵指挥官银痕'
 WHERE `entry` = 62901 AND `name_loc4` = '哨兵指挥官西尔维尔斯特尔伊克';  -- Sentinel Commander Silverstreak

UPDATE `locales_creature` SET `name_loc4` = '伊瑞丝·月舞者'
 WHERE `entry` = 63201 AND `name_loc4` = '伊瑞斯月舞者';            -- Moondancer

UPDATE `locales_creature` SET `name_loc4` = '大德鲁伊瑞内斯尔·月水'
 WHERE `entry` = 62900 AND `name_loc4` = '大德鲁伊瑞内斯尔阿月水';   -- Arch Druid Renethra Moonwater

UPDATE `locales_creature` SET `name_loc4` = '塞彭提亚女士'
 WHERE `entry` = 63148 AND `name_loc4` = '雷蒂塞尔彭蒂娅';          -- Lady Serpentia

UPDATE `locales_creature` SET `name_loc4` = '马甘'
 WHERE `entry` = 62994 AND `name_loc4` = '马格阿恩';               -- Maghan


-- 第三批：乌龟服自定义实体名（2026-10-09 逐条按英文原名 + 库内既有官方译法核对后修正）
-- 判定依据写在每行注释里；全部带原值条件，值变了就不再覆盖。
UPDATE `locales_creature` SET `name_loc4` = '乌达佩·阳草'
 WHERE `entry` = 62588 AND `name_loc4` = '乌达佩太阳草';            -- Udape Sungrass（保留 · 分隔，与「诺拉·汽望」同法）

UPDATE `locales_creature` SET `name_loc4` = '基尔罗格·死眼'
 WHERE `entry` = 62590 AND `name_loc4` = '基尔罗格死眼';            -- Kilrogg Deadeye（官方译名用 · 分隔）

UPDATE `locales_creature` SET `name_loc4` = '巧匠'
 WHERE `entry` = 73101 AND `name_loc4` = '技师';                   -- The Artificer（同一人物在任务 41286/41290 标题里是「巧匠」）

UPDATE `locales_gameobject` SET `name_loc4` = '隐藏的储物箱'
 WHERE `entry` = 2020167 AND `name_loc4` = '隐藏生物烧焦的储物柜';   -- Hidden Locker（原值是别的物件名串了行）

UPDATE `locales_gameobject` SET `name_loc4` = '沾满泥污的日记'
 WHERE `entry` = 2020177 AND `name_loc4` = '的土堆日记';            -- Muddy Journal（原值缺了主语、句首挂着一个「的」）

UPDATE `locales_item` SET `name_loc4` = '阿勒西的艾露恩之誓'
 WHERE `entry` = 41301 AND `name_loc4` = '阿拉西娅对艾露恩的誓言';   -- Alatheas Vow To Elune（库内 NPC 92108「高阶祭司阿勒西」同名）

UPDATE `locales_item` SET `name_loc4` = '吉尔尼斯珠宝：汇编'
 WHERE `entry` = 41359 AND `name_loc4` = '吉尔尼斯珠宝饰：汇编';     -- Gilnean Jewelry: A Compendium（原值「珠宝饰」多一个字）

UPDATE `locales_item` SET `name_loc4` = '库米沙的卷轴'
 WHERE `entry` = 41363 AND `name_loc4` = '库姆伊莎的卷轴';          -- Kumishas Scroll（官方任务文本 2521/2522/41299 用「库米沙」）

UPDATE `locales_item` SET `name_loc4` = '库米沙的破碎披风'
 WHERE `entry` = 55118 AND `name_loc4` = '库姆伊莎的破碎披风';      -- Kumishas Tattered Drape（同上）

UPDATE `locales_item` SET `name_loc4` = '坦拉尔之握'
 WHERE `entry` = 41371 AND `name_loc4` = '坦拉尔之腰带';            -- Clutch of Thanlar（任务 41311 正文写「带着坦拉尔之握回去」）

UPDATE `locales_item` SET `name_loc4` = '纯净的德莱尼水晶宝石'
 WHERE `entry` = 41385 AND `name_loc4` = '纯净德莱尼水宝石';        -- Pure Draenethyst Gemstone（原值「德莱尼水」漏字）

UPDATE `locales_item` SET `name_loc4` = '沙漠探寻者的长裤'
 WHERE `entry` = 41917 AND `name_loc4` = '沙漠探寻者的短裤';        -- Desert Seekers Pants（布甲腿部，官方把 Pants 译「长裤」）

UPDATE `locales_item` SET `name_loc4` = '巨龙杀手'
 WHERE `entry` = 33876 AND `name_loc4` = '灭龙';                   -- Dragonbane（同词物品 61335 在库内是「巨龙杀手护肩」）

-- 第四批：本体与文本里的译名统一 / 明显机翻名（2026-10-09）
--  61990  Big Whiskers  大小老鼠 → 大胡须   （Whiskers 被当成“老鼠”；任务 41343/41344 正文本来就叫「大胡须」）
UPDATE `locales_creature` SET `name_loc4` = '大胡须'
 WHERE `entry` = 61990 AND `name_loc4` = '大小老鼠';

--  Uthokk 在物品里作「乌索克之坠饰」（41797/41798），任务标题却写「乌瑟克」→ 统一
UPDATE `locales_quest` SET `Title_loc4` = REPLACE(`Title_loc4`, '乌瑟克', '乌索克')
 WHERE `entry` IN (41730, 41731) AND `Title_loc4` LIKE '%乌瑟克%';
UPDATE `locales_quest` SET `Details_loc4` = REPLACE(`Details_loc4`, '乌瑟克', '乌索克')
 WHERE `entry` IN (41730, 41731) AND `Details_loc4` LIKE '%乌瑟克%';

-- 第五批：同一专名的两种写法收敛（2026-10-09，全库逐条核对后择一）
-- 判定口径：优先「多数处出现 / 官方译名 / 更贴合英文原名」，并在正文里一并替换（见迁移）
UPDATE `locales_creature` SET `name_loc4` = '安纳克罗斯'
 WHERE `entry` = 50550 AND `name_loc4` = '阿纳克洛斯';  -- Anachronos 官方译名（另一条 15410 也一并改为「安纳克罗斯巨龙形态」）
UPDATE `locales_creature` SET `name_loc4` = '安特诺米'
 WHERE `entry` = 65125 AND `name_loc4` = '安蒂诺米';  -- Antnormi：生物 81265 与任务文本均为「安特诺米」
UPDATE `locales_creature` SET `name_loc4` = '埃洛迪娅'
 WHERE `entry` = 80999 AND `name_loc4` = '艾劳迪亚';  -- Elodia：与 80911 统一
UPDATE `locales_creature` SET `name_loc4` = '埃博斯塔夫'
 WHERE `entry` = 10321 AND `name_loc4` = '艾博斯塔夫';  -- Emberstrife：以任务 6570 的译名统一
UPDATE `locales_creature` SET `name_loc4` = '戈马'
 WHERE `entry` = 5606 AND `name_loc4` = '高玛';  -- Goma：两条同英文统一
UPDATE `locales_creature` SET `name_loc4` = '伊奴夸克'
 WHERE `entry` = 81046 AND `name_loc4` = '伊楠夸克';  -- Inunquaq：与 60611 统一
UPDATE `locales_creature` SET `name_loc4` = '卡古隆'
 WHERE `entry` = 61056 AND `name_loc4` = '科格罗';  -- Kagoro：与 4972 统一
UPDATE `locales_creature` SET `name_loc4` = '克罗格鲁尔'
 WHERE `entry` = 8977 AND `name_loc4` = '克罗格卢尔';  -- Krom Grul：任务 3822 三处均为「克罗格鲁尔」
UPDATE `locales_creature` SET `name_loc4` = '坦格莫斯'
 WHERE `entry` = 92204 AND `name_loc4` = '苔藓';  -- Tanglemoss：任务 40200 用「坦格莫斯」，原名是意译错位
UPDATE `locales_creature` SET `name_loc4` = '泽艾克'
 WHERE `entry` = 80910 AND `name_loc4` = '赞克';  -- Xecc：与 80998 统一
UPDATE `locales_creature` SET `name_loc4` = '扎拉赞恩'
 WHERE `entry` = 3205 AND `name_loc4` = '札拉赞恩';  -- Zalazane 官方译名（任务 826 已是）
UPDATE `locales_creature` SET `name_loc4` = '憎恶'
 WHERE `entry` = 8545 AND `name_loc4` = '缝合傀儡';  -- Abomination：与 60655 统一为官方译名
UPDATE `locales_creature` SET `name_loc4` = '地狱犬'
 WHERE `entry` = 6010 AND `name_loc4` = '地狱巨犬';  -- Felhound：与 2000017 统一为官方译名
UPDATE `locales_creature` SET `name_loc4` = '食尸鬼'
 WHERE `entry` = 846 AND `name_loc4` = '腐烂的食尸鬼';  -- Ghoul：与 60654 统一为官方译名
UPDATE `locales_creature` SET `name_loc4` = '烈焰震击者'
 WHERE `entry` = 20100 AND `name_loc4` = '火焰震荡者';  -- Flameshocker：与 16383 统一
UPDATE `locales_creature` SET `name_loc4` = '阿拉萨拉斯公民'
 WHERE `entry` = 80235 AND `name_loc4` = '阿拉萨拉斯平民';  -- Alah Thalas Citizen：与 60436-60439 统一
UPDATE `locales_creature` SET `name_loc4` = '安纳克罗斯巨龙形态'
 WHERE `entry` = 15410 AND `name_loc4` = '阿纳克洛斯巨龙形态';  -- Anachronos Dragon Form
UPDATE `locales_item` SET `name_loc4` = '阿洛雷尔'
 WHERE `entry` = 60918 AND `name_loc4` = '艾洛尔';  -- Alor el：以物件名统一（更贴合原文）
UPDATE `locales_item` SET `name_loc4` = '蛇根草'
 WHERE `entry` = 61744 AND `name_loc4` = '蛇根';  -- Serpentroot：与任务 41045 统一
UPDATE `locales_gameobject` SET `name_loc4` = '青石'
 WHERE `entry` = 2010798 AND `name_loc4` = '蔚蓝之石';  -- The Azurestone：任务 40338 正文用「青石」
UPDATE `locales_gameobject` SET `name_loc4` = '死帽菇'
 WHERE `entry` = 2020164 AND `name_loc4` = '德伊斯卡普';  -- Deathcap：与物品 41693 统一
UPDATE `locales_gameobject` SET `name_loc4` = '蛇根草'
 WHERE `entry` = 2020046 AND `name_loc4` = '蛇的根源';  -- Serpentroot：原名是字面误解
UPDATE `locales_gameobject` SET `name_loc4` = '海加尔根'
 WHERE `entry` = 2020023 AND `name_loc4` = '海加尔鲁特';  -- Hyjalroot：任务 40870/40871 用「海加尔根」

-- 第六批：自定义 NPC 人名重译（2026-10-09，按审阅表 tools/dbdiff/review/name_style_review.md）
-- 口径：英文是可读复合词 → 「名·意译姓」；不可读 → 保持音译（顺带修误译/错字/断字）
UPDATE `locales_creature` SET `name_loc4` = '游侠菲亚琳娜·迅步'
 WHERE `entry` = 62734 AND `name_loc4` = '游侠夫埃利娜斯维夫特斯特尔伊德';  -- Ranger Faellina Swiftstride
UPDATE `locales_creature` SET `name_loc4` = '姆乌尔夫·夜角'
 WHERE `entry` = 62976 AND `name_loc4` = '姆乌尔夫尼格索恩';  -- Mhulf Nighthorn
UPDATE `locales_creature` SET `name_loc4` = '地方法官胡尔达姆·硬手'
 WHERE `entry` = 62395 AND `name_loc4` = '地方法官胡尔达姆特奥哈恩德';  -- Magistrate Hurdam Toughhand
UPDATE `locales_creature` SET `name_loc4` = '泰尔德拉斯·踏海'
 WHERE `entry` = 62097 AND `name_loc4` = '特埃尔德拉斯伊斯特尔伊德尔';  -- Taeldras Seastrider
UPDATE `locales_creature` SET `name_loc4` = '大长老斯凯·踏云'
 WHERE `entry` = 62837 AND `name_loc4` = '豪华长者斯克伊斯特尔伊德尔';  -- Grand Elder Skystrider
UPDATE `locales_creature` SET `name_loc4` = '凡兹·星泉'
 WHERE `entry` = 61913 AND `name_loc4` = '凡兹斯帕尔克斯普尔伊恩格';  -- Fanzy Sparkspring
UPDATE `locales_creature` SET `name_loc4` = '克兰戈什·雷风'
 WHERE `entry` = 62415 AND `name_loc4` = '克拉恩戈什苏恩德尔维恩德';  -- Krangosh Thunderwind
UPDATE `locales_creature` SET `name_loc4` = '凡多尔·劲风之回响'
 WHERE `entry` = 62599 AND `name_loc4` = '之回响凡多尔布拉塞维恩德';  -- Echo of Vandol Bracewind
UPDATE `locales_creature` SET `name_loc4` = '托尔瓦格·雷手'
 WHERE `entry` = 61911 AND `name_loc4` = '托尔瓦格苏恩德尔哈恩德';  -- Torvag Thunderhand
UPDATE `locales_creature` SET `name_loc4` = '莱索尔·晨叶'
 WHERE `entry` = 62088 AND `name_loc4` = '尔艾索尔莫尔宁格尔伊夫';  -- Laithor Morningleaf
UPDATE `locales_creature` SET `name_loc4` = '佩妮·素钢'
 WHERE `entry` = 62519 AND `name_loc4` = '佩恩伊普尔艾恩斯特伊尔';  -- Penny Plainsteel
UPDATE `locales_creature` SET `name_loc4` = '泽格·闪爆'
 WHERE `entry` = 63060 AND `name_loc4` = '泽格斯帕尔克莱布拉斯特';  -- Zegh Sparkleblast
UPDATE `locales_creature` SET `name_loc4` = '拉奈留斯·纯心'
 WHERE `entry` = 61916 AND `name_loc4` = '拉内尔尤斯普瑞伊尔特';  -- Ranellius Pureheart
UPDATE `locales_creature` SET `name_loc4` = '赛尔多·晨星'
 WHERE `entry` = 62083 AND `name_loc4` = '斯埃尔多尔达斯帕尔克';  -- Saeldor Dawnspark
UPDATE `locales_creature` SET `name_loc4` = '梅尔多·迅矛'
 WHERE `entry` = 62086 AND `name_loc4` = '梅尔多尔斯维夫特兰塞';  -- Meldor Swiftlance
UPDATE `locales_creature` SET `name_loc4` = '巴韦格·磁石'
 WHERE `entry` = 62410 AND `name_loc4` = '巴尔韦格尔奥德斯托内';  -- Barwegg Loadstone
UPDATE `locales_creature` SET `name_loc4` = '安东纳斯·裂视'
 WHERE `entry` = 62634 AND `name_loc4` = '阿恩托纳斯瑞夫特加泽';  -- Antonas Riftgaze
UPDATE `locales_creature` SET `name_loc4` = '德雷萨尼斯·哀影'
 WHERE `entry` = 62718 AND `name_loc4` = '德雷萨尼斯姆奥恩沙德';  -- Drethanis Mournshade
UPDATE `locales_creature` SET `name_loc4` = '格鲁尔·曲木'
 WHERE `entry` = 63027 AND `name_loc4` = '格尔乌尔特尔伊本德尔';  -- Grool Treebender
UPDATE `locales_creature` SET `name_loc4` = '内瑞安·鹿木'
 WHERE `entry` = 63072 AND `name_loc4` = '内尔伊恩斯塔格特尔伊';  -- Nerean Stagtree
UPDATE `locales_creature` SET `name_loc4` = '埃泽尔·暗酿'
 WHERE `entry` = 65148 AND `name_loc4` = '埃泽尔达尔克布雷韦尔';  -- Ezzel Darkbrewer
UPDATE `locales_creature` SET `name_loc4` = '阿科格·牙血'
 WHERE `entry` = 91021 AND `name_loc4` = '阿科格图斯克布尔乌德';  -- Akogg Tuskblood
UPDATE `locales_creature` SET `name_loc4` = '格尔潘·火花'
 WHERE `entry` = 61925 AND `name_loc4` = '格尔潘瑞兹斯帕尔克';  -- Gelpan Rizspark
UPDATE `locales_creature` SET `name_loc4` = '瑟萨莉娅·晨星'
 WHERE `entry` = 62084 AND `name_loc4` = '瑟萨莉娅达斯帕尔克';  -- Thessalia Dawnspark
UPDATE `locales_creature` SET `name_loc4` = '希尔加·雪酿'
 WHERE `entry` = 62407 AND `name_loc4` = '希尔加斯诺瓦布雷瓦';  -- Hilga Snowbrew
UPDATE `locales_creature` SET `name_loc4` = '拉格丹·锤炉'
 WHERE `entry` = 62420 AND `name_loc4` = '拉格丹哈梅尔伊尔斯';  -- Ragdan Hammerhearth
UPDATE `locales_creature` SET `name_loc4` = '工程师煤须'
 WHERE `entry` = 62756 AND `name_loc4` = '工程师斯乌特比尔德';  -- Engineer Sootbeard
UPDATE `locales_creature` SET `name_loc4` = '预言者风暴蹄'
 WHERE `entry` = 62781 AND `name_loc4` = '预言者斯托尔姆乌夫';  -- Prophet Stormhoof
UPDATE `locales_creature` SET `name_loc4` = '扎拉扎尔·贤风'
 WHERE `entry` = 62902 AND `name_loc4` = '扎拉扎尔萨格维恩德';  -- Zarazar Sagewind
UPDATE `locales_creature` SET `name_loc4` = '乌尔夫·石图腾'
 WHERE `entry` = 63056 AND `name_loc4` = '乌尔夫斯托内托泰姆';  -- Ulf Stonetotem
UPDATE `locales_creature` SET `name_loc4` = '萨泽克莱·噬矢'
 WHERE `entry` = 90150 AND `name_loc4` = '萨泽克莱博尔特比泰';  -- Saxekle Boltbite
UPDATE `locales_creature` SET `name_loc4` = '姆埃瓦·托格维'
 WHERE `entry` = 61912 AND `name_loc4` = '姆埃瓦托格夫伊瓦';  -- Mayva Togview
UPDATE `locales_creature` SET `name_loc4` = '菲登特·苔怒'
 WHERE `entry` = 62464 AND `name_loc4` = '菲德恩特莫斯拉格';  -- Fydent Mossrage
UPDATE `locales_creature` SET `name_loc4` = '奥罗诺克·裂心'
 WHERE `entry` = 62548 AND `name_loc4` = '奥罗诺克托伊尔特';  -- Oronok Torn-Heart
UPDATE `locales_creature` SET `name_loc4` = '老加泽诺'
 WHERE `entry` = 62080 AND `name_loc4` = '奥尔苏迪加泽诺';  -- Ol' Gazeno
UPDATE `locales_creature` SET `name_loc4` = '奥尔米尔·半角'
 WHERE `entry` = 62470 AND `name_loc4` = '奥尔米尔哈霍恩';  -- Olmir Halfhorn
UPDATE `locales_creature` SET `name_loc4` = '沙尼·丝蹄'
 WHERE `entry` = 62978 AND `name_loc4` = '沙尼西尔克乌夫';  -- Shanni Silkhoof
UPDATE `locales_creature` SET `name_loc4` = '伐木工鲁兹·螺栓'
 WHERE `entry` = 91219 AND `name_loc4` = '伐木工鲁兹波特';  -- Lumberworker Ruzbolt
UPDATE `locales_creature` SET `name_loc4` = '卡利娜·高翼'
 WHERE `entry` = 62095 AND `name_loc4` = '卡利娜希格维';  -- Calina Highwing
UPDATE `locales_creature` SET `name_loc4` = '拉娜·远行者'
 WHERE `entry` = 61654 AND `name_loc4` = '长途行者拉娜';  -- Rahna Longstrider
UPDATE `locales_creature` SET `name_loc4` = '伊瑞娅·唤晨'
 WHERE `entry` = 62904 AND `name_loc4` = '伊尔伊唤晓者';  -- Irea Dawncaller
UPDATE `locales_creature` SET `name_loc4` = '失落者捕猎者'
 WHERE `entry` = 62929 AND `name_loc4` = '坠落者捕猎者';  -- Fallen One Stalker
UPDATE `locales_creature` SET `name_loc4` = '先知格里姆·灰眼'
 WHERE `entry` = 70027 AND `name_loc4` = '先知格里姆艾';  -- Farseer Grimeye
UPDATE `locales_creature` SET `name_loc4` = '恶鳍招潮者'
 WHERE `entry` = 61085 AND `name_loc4` = '恶鳍唤嘲鱼人';  -- Spitefin Tidecaller
UPDATE `locales_creature` SET `name_loc4` = '阿拉萨拉斯研究员'
 WHERE `entry` = 61885 AND `name_loc4` = '阿尔萨拉斯研究员';  -- Alah'Thalas Researcher
UPDATE `locales_creature` SET `name_loc4` = '斯隆达'
 WHERE `entry` = 62291 AND `name_loc4` = '斯尔奥恩达';  -- Thronda
UPDATE `locales_creature` SET `name_loc4` = '戈德纳克'
 WHERE `entry` = 63095 AND `name_loc4` = '戈尔德娜克';  -- Gordnak
UPDATE `locales_creature` SET `name_loc4` = '安达尼尔·逐日'
 WHERE `entry` = 63119 AND `name_loc4` = '阿恩达尼尔逐日者';  -- Andanil Sunsworn
UPDATE `locales_creature` SET `name_loc4` = '赛瑞斯塔兹'
 WHERE `entry` = 62072 AND `name_loc4` = '斯伊瑞斯特尔阿斯兹';  -- Searistrasz
UPDATE `locales_creature` SET `name_loc4` = '里基·费兹'
 WHERE `entry` = 62520 AND `name_loc4` = '瑞克基菲兹马斯克';  -- Rikki Fizmask
UPDATE `locales_creature` SET `name_loc4` = '尤妮·快手'
 WHERE `entry` = 62521 AND `name_loc4` = '阿恩伊快手';  -- Yunie Quicktrigger
