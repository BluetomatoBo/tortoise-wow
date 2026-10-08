-- ============================================================
-- verify_refs.sql —— 用线上库的实际数据检查「指向不存在目标」的行（只读，不修改任何数据）
--
-- 用法： mysql -h127.0.0.1 -uroot -p tw_world < tools/dbdiff/verify_refs.sql
-- 输出里每行 = 一张表 + 悬空引用的行数；非 0 表示内核启动时会报这些行并跳过。
-- 需要清理时，把对应查询下面的 DELETE 模板取消注释即可（这些行内核本来就跳过，行为不变）。
--
-- ⚠️ 关键语义（第一版脚本就是在这里错的）：
--   掉落表的 `item` 列有两种含义 ——
--     * `mincountOrRef >= 0`：item 是**物品 id**（要和 item_template 比）；
--     * `mincountOrRef <  0`：这一行是**引用**，item 是**引用组 id**（要和 reference_loot_template 比，
--       真正的引用 id 是 -mincountOrRef，两者相等）。
--   不区分这两种情况就会把几万行引用当成「物品不存在」。
-- ============================================================

-- ---------- 1) 物品类引用：只看非引用行 ----------
SELECT 'creature_loot_template(item)' AS tbl, COUNT(*) AS dangling
  FROM creature_loot_template l
  LEFT JOIN item_template i ON i.entry = l.item
 WHERE l.mincountOrRef >= 0 AND l.item > 0 AND i.entry IS NULL;
-- DELETE l FROM creature_loot_template l LEFT JOIN item_template i ON i.entry = l.item
--  WHERE l.mincountOrRef >= 0 AND l.item > 0 AND i.entry IS NULL;

SELECT 'gameobject_loot_template(item)' AS tbl, COUNT(*) AS dangling
  FROM gameobject_loot_template l
  LEFT JOIN item_template i ON i.entry = l.item
 WHERE l.mincountOrRef >= 0 AND l.item > 0 AND i.entry IS NULL;

SELECT 'item_loot_template(item)' AS tbl, COUNT(*) AS dangling
  FROM item_loot_template l
  LEFT JOIN item_template i ON i.entry = l.item
 WHERE l.mincountOrRef >= 0 AND l.item > 0 AND i.entry IS NULL;

SELECT 'reference_loot_template(item)' AS tbl, COUNT(*) AS dangling
  FROM reference_loot_template l
  LEFT JOIN item_template i ON i.entry = l.item
 WHERE l.mincountOrRef >= 0 AND l.item > 0 AND i.entry IS NULL;

SELECT 'pickpocketing_loot_template(item)' AS tbl, COUNT(*) AS dangling
  FROM pickpocketing_loot_template l
  LEFT JOIN item_template i ON i.entry = l.item
 WHERE l.mincountOrRef >= 0 AND l.item > 0 AND i.entry IS NULL;

SELECT 'skinning_loot_template(item)' AS tbl, COUNT(*) AS dangling
  FROM skinning_loot_template l
  LEFT JOIN item_template i ON i.entry = l.item
 WHERE l.mincountOrRef >= 0 AND l.item > 0 AND i.entry IS NULL;

-- ---------- 2) 引用类：引用组是否存在 ----------
SELECT 'creature_loot_template(ref)' AS tbl, COUNT(*) AS dangling
  FROM creature_loot_template l
 WHERE l.mincountOrRef < 0
   AND NOT EXISTS (SELECT 1 FROM reference_loot_template r WHERE r.entry = -l.mincountOrRef);

SELECT 'gameobject_loot_template(ref)' AS tbl, COUNT(*) AS dangling
  FROM gameobject_loot_template l
 WHERE l.mincountOrRef < 0
   AND NOT EXISTS (SELECT 1 FROM reference_loot_template r WHERE r.entry = -l.mincountOrRef);

SELECT 'item_loot_template(ref)' AS tbl, COUNT(*) AS dangling
  FROM item_loot_template l
 WHERE l.mincountOrRef < 0
   AND NOT EXISTS (SELECT 1 FROM reference_loot_template r WHERE r.entry = -l.mincountOrRef);

SELECT 'pickpocketing_loot_template(ref)' AS tbl, COUNT(*) AS dangling
  FROM pickpocketing_loot_template l
 WHERE l.mincountOrRef < 0
   AND NOT EXISTS (SELECT 1 FROM reference_loot_template r WHERE r.entry = -l.mincountOrRef);

SELECT 'skinning_loot_template(ref)' AS tbl, COUNT(*) AS dangling
  FROM skinning_loot_template l
 WHERE l.mincountOrRef < 0
   AND NOT EXISTS (SELECT 1 FROM reference_loot_template r WHERE r.entry = -l.mincountOrRef);

-- ---------- 3) 商人 / 训练师 ----------
SELECT 'npc_vendor' AS tbl, COUNT(*) AS dangling
  FROM npc_vendor v LEFT JOIN item_template i ON i.entry = v.item
 WHERE v.item <> 0 AND i.entry IS NULL;
-- DELETE v FROM npc_vendor v LEFT JOIN item_template i ON i.entry = v.item WHERE v.item <> 0 AND i.entry IS NULL;

SELECT 'npc_vendor_template' AS tbl, COUNT(*) AS dangling
  FROM npc_vendor_template v LEFT JOIN item_template i ON i.entry = v.item
 WHERE v.item <> 0 AND i.entry IS NULL;

SELECT 'npc_trainer(法术)' AS tbl, COUNT(*) AS dangling
  FROM npc_trainer t LEFT JOIN spell_template s ON s.entry = t.spell
 WHERE s.entry IS NULL;

-- ---------- 4) 技能 / 法术 / 起始 ----------
SELECT 'skill_line_ability(法术)' AS tbl, COUNT(*) AS dangling
  FROM skill_line_ability a LEFT JOIN spell_template s ON s.entry = a.spell_id
 WHERE s.entry IS NULL;

SELECT 'spell_affect' AS tbl, COUNT(*) AS dangling
  FROM spell_affect a LEFT JOIN spell_template s ON s.entry = a.entry
 WHERE s.entry IS NULL;

SELECT 'spell_learn_spell' AS tbl, COUNT(*) AS dangling
  FROM spell_learn_spell a LEFT JOIN spell_template s ON s.entry = a.entry
 WHERE s.entry IS NULL;

SELECT 'playercreateinfo_spell' AS tbl, COUNT(*) AS dangling
  FROM playercreateinfo_spell a LEFT JOIN spell_template s ON s.entry = a.Spell
 WHERE s.entry IS NULL;

-- ---------- 5) 任务关系（内核会报 `Quest N listed for entry M does not exist.` 并跳过） ----------
SELECT 'gameobject_questrelation' AS tbl, COUNT(*) AS dangling
  FROM gameobject_questrelation r LEFT JOIN quest_template q ON q.entry = r.quest
 WHERE q.entry IS NULL;
-- DELETE r FROM gameobject_questrelation r LEFT JOIN quest_template q ON q.entry = r.quest
--  WHERE q.entry IS NULL;

SELECT 'gameobject_involvedrelation' AS tbl, COUNT(*) AS dangling
  FROM gameobject_involvedrelation r LEFT JOIN quest_template q ON q.entry = r.quest
 WHERE q.entry IS NULL;

-- ---------- 6) 世界：区域 / 飞行点 / 尸体朝向 ----------
SELECT 'area_template(父区域)' AS tbl, COUNT(*) AS dangling
  FROM area_template a LEFT JOIN area_template p ON p.entry = a.zone_id
 WHERE a.zone_id <> 0 AND p.entry IS NULL;

SELECT 'taxi_nodes(生物)' AS tbl, COUNT(*) AS dangling
  FROM taxi_nodes t LEFT JOIN creature_template c ON c.entry = t.creature_entry
 WHERE t.creature_entry <> 0 AND c.entry IS NULL;

-- ---------- 7) 组概率：SQL 视角合计仍 >101 的组（内核可能不报，见 README） ----------
SELECT l.entry, l.groupid,
       COUNT(*) AS 组内行数,
       ROUND(SUM(CASE WHEN l.ChanceOrQuestChance > 0 THEN l.ChanceOrQuestChance ELSE 0 END), 4) AS 正值合计,
       SUM(l.condition_id <> 0) AS 带条件的行,
       SUM(l.mincountOrRef < 0) AS 引用行
  FROM creature_loot_template l
 WHERE l.groupid <> 0
 GROUP BY l.entry, l.groupid
HAVING 正值合计 > 101
 ORDER BY 正值合计 DESC
 LIMIT 40;
