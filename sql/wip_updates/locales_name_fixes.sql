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
