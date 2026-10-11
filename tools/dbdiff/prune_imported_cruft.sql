-- ============================================================
-- prune_imported_cruft.sql
-- 清掉「刚补进来的、内核明确判定为无用/非法」的行。
--
-- ⚠️ 运行前必读（2026-10-11 事故后补）：
--   1. 先跑 `python3 tools/dbdiff/check_delete_ids.py <本文件>`：「没有**数据**引用」不等于
--      「没有**代码**引用」——内核里常有硬编码的 id（典型：`npc_vendor_template` 的 1277702/1279202
--      被 `Player::RecallPvPGear()` 使用）。本脚本的 npc_vendor_template 规则已按此排除它们；
--      以后再加规则，先过一遍那个工具。
--   2. 本脚本的每条规则都严格照内核自己的判定写（注释里给了源码位置），只删内核加载时本来就
--      跳过、永远不会生效的行 → 游戏行为不变。
--   3. 不要修改 `sql/database_updates/` 里**已经应用**过的迁移文件：内核按「文件名 + 内容 hash」
--      判断是否已执行，改了 hash 就会被当成新迁移**重跑**（例如重跑 20261008154500 会把恢复好的
--      PvP 模板再删一次、导致登录崩溃）。要修就写新迁移。
-- 每条 DELETE 都严格照内核自己的判定条件写（注释里给出源码位置），
-- 只删内核加载时本来就跳过、永远不会生效的行 → 游戏行为完全不变，只是日志干净。
-- 全是 DELETE，可重复执行（第二次起影响 0 行）。
--
-- 用法：
--   mysql -h127.0.0.1 -uroot -p tw_world < tools/dbdiff/prune_imported_cruft.sql
-- 建议先执行「体检」段（只查不改）看行数，确认后再执行下面的清理段。
-- ============================================================

-- ============ 一、体检（只查不改） ============
SELECT 'creature_loot_template 整条没主人' AS 项目,
       COUNT(DISTINCT entry) AS 条目数, COUNT(*) AS 行数
  FROM creature_loot_template
 WHERE entry <> 0
   AND entry NOT IN (SELECT loot_id FROM creature_template WHERE loot_id <> 0);

SELECT 'gameobject_loot_template 整条没主人' AS 项目,
       COUNT(DISTINCT entry) AS 条目数, COUNT(*) AS 行数
  FROM gameobject_loot_template
 WHERE entry NOT IN (SELECT data1 FROM gameobject_template WHERE `type` IN (3, 25) AND data1 <> 0);

SELECT 'pickpocketing 整条没主人' AS 项目,
       COUNT(DISTINCT entry) AS 条目数, COUNT(*) AS 行数
  FROM pickpocketing_loot_template
 WHERE entry NOT IN (SELECT pickpocket_loot_id FROM creature_template WHERE pickpocket_loot_id <> 0);

SELECT 'skinning 整条没主人' AS 项目,
       COUNT(DISTINCT entry) AS 条目数, COUNT(*) AS 行数
  FROM skinning_loot_template
 WHERE entry NOT IN (SELECT skinning_loot_id FROM creature_template WHERE skinning_loot_id <> 0);

SELECT 'npc_trainer 问题行' AS 项目, COUNT(*) AS 行数 FROM npc_trainer t
 WHERE NOT EXISTS (SELECT 1 FROM creature_template c WHERE c.entry = t.entry)
    OR NOT EXISTS (SELECT 1 FROM spell_template s WHERE s.entry = t.spell);

SELECT 'npc_trainer 教非学习类法术' AS 项目, COUNT(*) AS 行数
  FROM npc_trainer t JOIN spell_template s ON s.entry = t.spell
 WHERE s.effect1 <> 36;

SELECT 'spell_affect 与 EffectItemType 重复' AS 项目, COUNT(*) AS 行数
  FROM spell_affect a JOIN spell_template s ON s.entry = a.entry
 WHERE (a.effectId = 0 AND s.effectItemType1 <> 0 AND s.effectItemType1 = a.SpellFamilyMask)
    OR (a.effectId = 1 AND s.effectItemType2 <> 0 AND s.effectItemType2 = a.SpellFamilyMask)
    OR (a.effectId = 2 AND s.effectItemType3 <> 0 AND s.effectItemType3 = a.SpellFamilyMask);

SELECT 'spell_affect 光环类型不对' AS 项目, COUNT(*) AS 行数
  FROM spell_affect a JOIN spell_template s ON s.entry = a.entry
 WHERE NOT ((a.effectId = 0 AND s.effect1 = 6  AND s.effectApplyAuraName1 IN (107,108,109,112))
         OR (a.effectId = 1 AND s.effect2 = 6  AND s.effectApplyAuraName2 IN (107,108,109,112))
         OR (a.effectId = 2 AND s.effect3 = 6  AND s.effectApplyAuraName3 IN (107,108,109,112)));

SELECT '掉落表里 chance=0 且 groupid=0 的行（内核跳过）' AS 项目, COUNT(*) AS 行数
  FROM reference_loot_template
 WHERE groupid = 0 AND ChanceOrQuestChance = 0 AND mincountOrRef > 0;

SELECT 'item_loot_template 里不是可拾取物品的条目' AS 项目,
       COUNT(DISTINCT entry) AS 条目数, COUNT(*) AS 行数
  FROM item_loot_template l
 WHERE NOT EXISTS (SELECT 1 FROM item_template i WHERE i.entry = l.entry AND (i.Flags & 4) <> 0)
   AND l.entry NOT IN (
     SELECT DISTINCT -mincountOrRef FROM creature_loot_template      WHERE mincountOrRef < 0
     UNION SELECT DISTINCT -mincountOrRef FROM reference_loot_template WHERE mincountOrRef < 0);

SELECT 'npc_vendor_template 没商人使用' AS 项目,
       COUNT(DISTINCT entry) AS 条目数, COUNT(*) AS 行数
  FROM npc_vendor_template v
 WHERE NOT EXISTS (SELECT 1 FROM creature_template c WHERE c.vendor_id = v.entry)
   -- 内核硬编码引用的两个 PvP 模板（Player::RecallPvPGear）绝不可删：
   -- 删了每次玩家登录都会 SIGSEGV，见 tools/dbdiff/README.md 第十五节
   AND v.entry NOT IN (1277702, 1279202);

-- ============ 二、清理 ============

-- 1) 战利品：整条 entry 没有任何主人 —— 内核 ReportUnusedIds()（LootMgr.cpp:257）会把它整条判为 useless
DELETE cl FROM creature_loot_template cl
 WHERE cl.entry <> 0
   AND cl.entry NOT IN (SELECT loot_id FROM creature_template WHERE loot_id <> 0);

DELETE gl FROM gameobject_loot_template gl
 WHERE gl.entry NOT IN (SELECT data1 FROM gameobject_template WHERE `type` IN (3, 25) AND data1 <> 0);

DELETE p FROM pickpocketing_loot_template p
 WHERE p.entry NOT IN (SELECT pickpocket_loot_id FROM creature_template WHERE pickpocket_loot_id <> 0);

DELETE sk FROM skinning_loot_template sk
 WHERE sk.entry NOT IN (SELECT skinning_loot_id FROM creature_template WHERE skinning_loot_id <> 0);

-- 2) 引用掉落组：没有被任何表的负 mincountOrRef 指向（LootTemplate::CheckLootRefs，LootMgr.cpp:1463）
--    自身那张表用派生表包一层，避免 MySQL 的 "can't specify target table for update in FROM clause"
DELETE r FROM reference_loot_template r
 WHERE r.entry NOT IN (
   SELECT DISTINCT -mincountOrRef FROM creature_loot_template         WHERE mincountOrRef < 0
   UNION SELECT DISTINCT -mincountOrRef FROM gameobject_loot_template  WHERE mincountOrRef < 0
   UNION SELECT DISTINCT -mincountOrRef FROM item_loot_template        WHERE mincountOrRef < 0
   UNION SELECT DISTINCT -mincountOrRef FROM pickpocketing_loot_template WHERE mincountOrRef < 0
   UNION SELECT DISTINCT -mincountOrRef FROM skinning_loot_template    WHERE mincountOrRef < 0
   UNION SELECT DISTINCT -mincountOrRef FROM fishing_loot_template     WHERE mincountOrRef < 0
   UNION SELECT DISTINCT -mincountOrRef FROM disenchant_loot_template  WHERE mincountOrRef < 0
   UNION SELECT DISTINCT -mincountOrRef FROM mail_loot_template        WHERE mincountOrRef < 0
   UNION SELECT DISTINCT -mincountOrRef FROM (SELECT -mincountOrRef AS ref FROM reference_loot_template WHERE mincountOrRef < 0) self_ref
   UNION SELECT `player_loot_id` FROM `battleground_template` WHERE `player_loot_id` <> 0);

-- 3) 训练师：挂在不存在的生物上 / 教不存在的法术 / 教的不是学习类法术
--    （ObjectMgr::LoadTrainers，ObjectMgr.cpp:8072 起；SPELL_EFFECT_LEARN_SPELL = 36）
DELETE t FROM npc_trainer t
 WHERE NOT EXISTS (SELECT 1 FROM creature_template c WHERE c.entry = t.entry);

DELETE t FROM npc_trainer t
 WHERE NOT EXISTS (SELECT 1 FROM spell_template s WHERE s.entry = t.spell);

DELETE t FROM npc_trainer t
  JOIN spell_template s ON s.entry = t.spell
 WHERE s.effect1 <> 36;

-- 4) 没被任何商人使用的商人物品模板（ObjectMgr.cpp:8281）
DELETE v FROM npc_vendor_template v
 WHERE NOT EXISTS (SELECT 1 FROM creature_template c WHERE c.vendor_id = v.entry)
   -- 同上：这两个模板是内核硬编码用的（RecallPvPGear），删掉会崩服
   AND v.entry NOT IN (1277702, 1279202);

-- 5) 行级：chance=0 但没写 groupid 的组内条目（LootStoreItem::IsValid，LootMgr.cpp:330）
DELETE l FROM reference_loot_template l
 WHERE l.groupid = 0 AND l.ChanceOrQuestChance = 0 AND l.mincountOrRef > 0;

-- 6) item_loot_template：整条 entry 既不是「可拾取物品」、也没被别的掉落表引用
--    （LoadLootTemplates_Item，LootMgr.cpp:1588；ITEM_FLAG_LOOTABLE = 4）
DELETE l FROM item_loot_template l
 WHERE NOT EXISTS (SELECT 1 FROM item_template i WHERE i.entry = l.entry AND (i.Flags & 4) <> 0)
   AND l.entry NOT IN (
     SELECT DISTINCT -mincountOrRef FROM creature_loot_template      WHERE mincountOrRef < 0
     UNION SELECT DISTINCT -mincountOrRef FROM reference_loot_template WHERE mincountOrRef < 0);

-- 7) spell_affect：内核明确跳过的两类行（SpellMgr::LoadSpellAffects，SpellMgr.cpp:3115/3130）
--    5a. 光环类型不对（不是「以法术修饰」类）—— 注意 effect = 6 是 SPELL_EFFECT_APPLY_AURA
DELETE a FROM spell_affect a JOIN spell_template s ON s.entry = a.entry
 WHERE NOT ((a.effectId = 0 AND s.effect1 = 6 AND s.effectApplyAuraName1 IN (107,108,109,112))
         OR (a.effectId = 1 AND s.effect2 = 6 AND s.effectApplyAuraName2 IN (107,108,109,112))
         OR (a.effectId = 2 AND s.effect3 = 6 AND s.effectApplyAuraName3 IN (107,108,109,112)));

--    5b. 与 Spell.dbc 自带的 EffectItemType 完全重复（等于没写）
DELETE a FROM spell_affect a JOIN spell_template s ON s.entry = a.entry
 WHERE (a.effectId = 0 AND s.effectItemType1 <> 0 AND s.effectItemType1 = a.SpellFamilyMask)
    OR (a.effectId = 1 AND s.effectItemType2 <> 0 AND s.effectItemType2 = a.SpellFamilyMask)
    OR (a.effectId = 2 AND s.effectItemType3 <> 0 AND s.effectItemType3 = a.SpellFamilyMask);
