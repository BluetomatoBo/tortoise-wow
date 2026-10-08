-- ==============================================
-- FILE: startup_log_cleanup_c.sql
-- GENERATED: 20261008161000
-- ==============================================
-- 第三批：剩下这些「有数据但被内核忽略/拒绝」的行。规则是——先在其他数据源里核实它到底该是什么，
-- 能修好就修好，确认是死数据才删。核实用到的数据源：
--   * 1.12 官方 dump（vmangos classicdb.sql）：-D 里的坐标/标记/法术都是它给的依据
--   * 本仓库 base/ + database_updates/ 的全量快照（含 UPDATE/DELETE 后的最终状态）
--   * 客户端 DBC / world 库 spell_template（法术隐式目标等）
-- 每条都带原值条件，可重复执行。

-- ======================================================================
-- 1) creature_movement 有路径但移动类型不是 WAYPOINT（原日志 93 行）
-- ======================================================================
-- 判定方法：算路径第一个点与这只生物出生点的距离。对照组是 400 个「已经开启巡逻」
-- （creature.movement_type=2 且有路径）的生物：84% 距离 ≤15 码、中位数 1.9 码 —— 说明
-- 「路径起点就写在自己出生点上」是作者写法。这 85 个 guid 的路径起点都 ≤20 码，只差移动
-- 类型标记，所以恢复成巡逻（里面 4 个带对话/商人/修理标记的也一样，它们的路径同样贴在自己出生点上）。
UPDATE `creature` SET `movement_type` = 2 WHERE `movement_type` <> 2 AND `guid` IN (
    45417, 114982, 2579030, 2581568, 2583554, 2586879, 2587046, 2587047, 2587052, 2587065, 2587411, 2587416,
    2587420, 2587443, 2587446, 2587457, 2587563, 2587564, 2587566, 2587571, 2587573, 2587579, 2587581, 2587584,
    2587592, 2587629, 2587692, 2587694, 2587732, 2587733, 2587734, 2587735, 2587741, 2587782, 2587811, 2588175,
    2588331, 2588335, 2588393, 2589769, 2589774, 2589775, 2592624, 2592769, 2592783, 2593012, 2593027, 2593028,
    2593141, 2593143, 2593144, 2593146, 2593150, 2593160, 2593167, 2593168, 2593169, 2593192, 2593195, 2593198,
    2593199, 2593204, 2593451, 2593452, 2593717, 2593723, 2594230, 2594231, 2594232, 2594235, 2594236, 2594240,
    2594249, 2594251, 2594315, 2595824, 2595832, 2596678, 2596865, 2596866, 2596894, 2596928, 2597170, 2597171,
    2597774
);

-- 剩下 8 个 guid 的路径起点离出生点 33~220 码，同 entry 的出生点也没有一个落在起点上
-- （1.12 里 guid 2413/2453 的路径坐标与本库一致，但 1.12 的 creature_template.MovementType
-- 同样是 1(random)/非巡逻，说明它们在 1.12 里也没被使用）→ 无主死数据。
-- 其中 2 条正好有同 entry 的出生点就站在路径起点（0.5 / 4.4 码）→ 路径改指过去并让它巡逻，
-- 这样不是删掉而是救回来：
-- creature_movement 的主键是 (id, point)：只有目标 guid 还没有任何路径点时才改指，避免撞主键
SET @free_a := (SELECT COUNT(*) FROM `creature_movement` WHERE `id` = 2581434);
SET @free_b := (SELECT COUNT(*) FROM `creature_movement` WHERE `id` = 2700777);
UPDATE `creature_movement` SET `id` = 2581434 WHERE `id` = 2581433 AND @free_a = 0;
UPDATE `creature_movement` SET `id` = 2700777 WHERE `id` = 2593426 AND @free_b = 0;
-- 只有确实拿到路径了才把巡逻打开（否则会变成「标了巡逻却没有路径」的新报错）
UPDATE `creature` SET `movement_type` = 2
 WHERE `movement_type` <> 2 AND `guid` IN (2581434, 2700777)
   AND `guid` IN (SELECT `id` FROM `creature_movement`);
-- 余下 6 个 guid 的路径（起点离出生点很远、也没有可归属的出生点；1.12 里同 guid 的路径同样没被使用）：
DELETE FROM `creature_movement` WHERE `id` IN (
    2413, 2453, 2470, 2562216, 2593727, 2593728
);

-- ======================================================================
-- 2) npc_trainer 挂了训练表但生物没有训练师标记（原日志 66 行）
-- ======================================================================
-- 2a) 本来就是训练师的 13 个：子名里就写着 X Trainer（Demon Trainer / Wintersaber Trainer /
--     Warrior Trainer / Priest Trainer / Druid Trainer），其中
--     * 2264 Hillsbrad Tailor：1.12 里 NpcFlags=21（含 UNIT_NPC_FLAG_TRAINER），教 3917/12118；
--     * 5753/5815/6027/6382/10618/11696：1.12 里 TrainerType=3(TRAINER_TYPE_PETS)、TrainerClass=3，
--       它们这份法术表和 1.12 的猎人训练师完全相同（1.12 的猎人训练师 NpcFlags 都是 17/19，含 TRAINER）
--     → 给这些补上 TRAINER 标记（用 |= 只加这一位，不动它们已有的商人/对话标记）
UPDATE `creature_template` SET `npc_flags` = `npc_flags` | 0x10 WHERE NOT (`npc_flags` & 0x10) AND `entry` IN (
    2264, 5753, 5815, 6027, 6382, 10618, 11696, 61637, 62428, 62976, 63075, 63084,
    63097
);

-- 2b) 剩下 53 个是「整份猎人宠训法术表被误挂上来」：同一份 12 条法术（20931-20935/47319-47323/47338/1563）
--     同时挂在 60 个毫不相关的条目上——鹿（Misthoof Stag）、软泥怪（Repulsing Ooze）、
--     普通供应商（Arayna Softwind / General Goods）、剧情魂灵（Shade of Medivh）……
--     这些条目 npc_flags 都没有 TRAINER、trainer_type=0，1.12 里也没有它们 → 是被忽略的死数据，删掉。
DELETE FROM `npc_trainer` WHERE `entry` IN (
    59994, 59995, 61064, 61113, 61149, 61155, 61332, 61333, 61334, 61335, 61336, 61337,
    61339, 61340, 61341, 61343, 61344, 61345, 61346, 61347, 61349, 61350, 61351, 61354,
    61367, 61374, 61375, 61468, 61470, 61471, 61472, 61473, 61474, 61475, 61476, 61477,
    61483, 61484, 61561, 61562, 61563, 61594, 61595, 61797, 61843, 62107, 62108, 62109,
    62513, 62518, 62519, 62520, 62521
);

-- ======================================================================
-- 3) creature_groups 队长 guid 失效（原日志 24 行）
-- ======================================================================
-- 逐 guid 追了一遍 base + 全部增量：这 9 个队长都是被 upstream 自己的清理补丁删掉的
-- （20260626153218 的 a_small_cleaup 删了 81613~81636 里的 8 个；190214~190231 等被批量 guid
-- 区间清理删掉，之后没再插入）。组内成员也跟着消失，唯一还活着的成员 81624 已经没有同组伙伴，
-- 留着的 24 行只会让内核每次都把它们当「坏队长」跳过（队长无效时整组本来就不会生效）。
DELETE FROM `creature_groups` WHERE `leader_guid` IN (
    26, 81616, 81617, 190214, 190218, 190222, 190230, 348245, 1068616
);

-- ======================================================================
-- 4) spell_script_target 的法术没有对应隐式目标（原日志 3 行）
-- ======================================================================
-- spell 4170（Cannon Ball）在 world 库 spell_template 里 effectImplicitTargetA1=17、B1=16，
-- 没有 38/40/46 任何一种「施法者附近」目标，内核加载时直接跳过这些行；1.12 里也没有 4170 的记录。
DELETE FROM `spell_script_target` WHERE `entry` = 4170 AND `targetEntry` IN (2595, 2596, 11054);

-- ======================================================================
-- 5) 战利品分组概率合计 > 100%（原日志 3 行）
-- ======================================================================
-- 内核自己给的修法就是按 100/合计 缩放（LootMgr.cpp:1297 会打印 `SET ChanceOrQuestChance=ChanceOrQuestChance*X`）。
-- 这三组的数就是这么错的：65020 第二组 11 行各 11.11（=100/9，把 11 个项目按 9 个来分），
-- 57642 第三组同理，20469 第一组是把 1.12 里那 8 个 Twilight 文本的概率归一化后又多乘了 1.136。
-- 缩放回去后组内相对权重不变、合计正好 100%，即作者本意。
-- 用会话变量取「现在的合计」，只在合计还是原始的错误值时缩放一次（重复执行不会二次缩放）
SET @sum_a := (SELECT SUM(`ChanceOrQuestChance`) FROM `creature_loot_template` WHERE `entry` = 65020 AND `groupid` = 2);
SET @sum_b := (SELECT SUM(`ChanceOrQuestChance`) FROM `creature_loot_template` WHERE `entry` = 57642 AND `groupid` = 3);
SET @sum_c := (SELECT SUM(`ChanceOrQuestChance`) FROM `item_loot_template`     WHERE `entry` = 20469 AND `groupid` = 1);
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = ROUND(`ChanceOrQuestChance` * 100 / @sum_a, 4)
 WHERE `entry` = 65020 AND `groupid` = 2 AND @sum_a BETWEEN 100.01 AND 1000;
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = ROUND(`ChanceOrQuestChance` * 100 / @sum_b, 4)
 WHERE `entry` = 57642 AND `groupid` = 3 AND @sum_b BETWEEN 100.01 AND 1000;
UPDATE `item_loot_template`     SET `ChanceOrQuestChance` = ROUND(`ChanceOrQuestChance` * 100 / @sum_c, 4)
 WHERE `entry` = 20469 AND `groupid` = 1 AND @sum_c BETWEEN 100.01 AND 1000;

-- ======================================================================
-- 6) 生物血/蓝百分比为 0（原日志 2 行）
-- ======================================================================
-- 内核已经把修法打在日志里（ObjectMgr.cpp:1912/1919），而且运行期它本来就已经按 100% 处理，
-- 所以这是纯数据修正、游戏表现不变。（5091 Guard Kahil 在 1.12 里就是同一个 guid，不该是 0 蓝。）
UPDATE `creature` SET `mana_percent` = 100 WHERE `guid` = 30663 AND `id` = 5091 AND `mana_percent` < 100;
UPDATE `creature` SET `health_percent` = 100 WHERE `guid` = 2578194 AND `id` = 61606 AND `health_percent` < 100;

-- ======================================================================
-- 7) 标了巡逻却没有路径（原日志 1 行）
-- ======================================================================
-- entry 15184（Cenarion Hold Infantry）一共 32 个刷新点：28 个 idle、3 个巡逻且都有路径，
-- 只有 60006 标着 movement_type=2 却没有路径（creature_template 也是 0，本库/1.12 的 creature_movement
-- 里都没有 60006）→ 它的移动类型是写错了，按同一个 entry 的多数写法改回 idle。
UPDATE `creature` SET `movement_type` = 0 WHERE `guid` = 60006 AND `id` = 15184 AND `movement_type` = 2;

-- ======================================================================
-- 8) generic_scripts 指向不存在的生物 guid（原日志 9 行）
-- ======================================================================
-- 目标 guid 68761-68763、377715、377716 在本仓库 base+全部增量里都不存在，1.12 里也没有；
-- 没有可改指的对象（同 id 脚本的其它行都指向存在的 guid），这些行永远不会生效 → 删掉这些行。
DELETE FROM `generic_scripts` WHERE `target_type` = 9 AND `id` IN (51246, 5123601) AND `target_param1` IN (68761, 68762, 68763, 377715, 377716);

