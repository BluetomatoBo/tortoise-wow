-- 生物名修正（locales_creature）
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
