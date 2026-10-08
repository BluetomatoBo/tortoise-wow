-- ==============================================
-- FILE: startup_log_cleanup_f.sql
-- GENERATED: 20261008200000
-- ==============================================
-- 收尾：用户复查后剩下的三条「静默/可判定」垃圾数据。

-- 1) creature_loot_template (92113, -30595)：它引用的掉落组 30595 里只有 10 行 `chance=0 且
--    groupid=0` 的记录 —— 这类行内核在 LootStoreItem::IsValid（LootMgr.cpp:330）里直接跳过，
--    也就是说这个引用组装载后是**空的**，内核因此报
--    `Table 'reference_loot_template' entry 30595 (reference id) not exist but used as loot id in DB.`
--    （上游数据本身写坏了：等概率组必须写 groupid）。这行引用永远不掉东西 → 删。
DELETE FROM `creature_loot_template` WHERE `entry` = 92113 AND `item` = 30595 AND `mincountOrRef` = -30595;

-- 2) skill_line_ability 里 13 行教「不存在的法术」：4 个法术 id（46530/41079/30236/46848）
--    在客户端的 Spell.dbc 里也查不到，另外 9 行的 skill_id / spell_id 都是 0（空行）→ 全部删。
--    判定条件与内核查法一致：spell_template 里没有该法术。
DELETE a FROM `skill_line_ability` a LEFT JOIN `spell_template` s ON s.`entry` = a.`spell_id`
 WHERE s.`entry` IS NULL;

-- 3) npc_vendor 里 entry 80950 这个商人：生物 80950 在 creature_template 里不存在（仓库与线上都没有），
--    内核每次启动都报 `Table 'npc_vendor' has data for nonexistent creature (Entry: 80950), ignoring.`
--    → 删掉这个商人的货架（不删的话它一辈子不会被任何生物用到）。
DELETE FROM `npc_vendor` WHERE `entry` = 80950;
