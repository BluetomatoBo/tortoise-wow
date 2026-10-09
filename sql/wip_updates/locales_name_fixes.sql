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
