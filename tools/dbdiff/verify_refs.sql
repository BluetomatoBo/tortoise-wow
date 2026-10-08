-- ============================================================
-- 校验：刚补进来的数据里有没有「指向不存在目标」的行（用你线上库的实际数据判断）
-- 用法： mysql -h127.0.0.1 -uroot -p tw_world < tools/dbdiff/verify_refs.sql
-- 输出里每一行 = 一张表 + 悬空引用的行数。非 0 的行内核会在启动日志里报出来并跳过。
-- 想直接清掉这些悬空行，把对应 SELECT 换成注释里的 DELETE 即可（只在确认报错后执行）。
-- ============================================================

-- 1) 战利品：item 正数指向 item_template，负数指向 reference_loot_template
SELECT 'creature_loot_template' AS tbl, COUNT(*) AS dangling
  FROM creature_loot_template l
  LEFT JOIN item_template i ON i.entry = l.item
 WHERE l.item > 0 AND i.entry IS NULL;
-- DELETE l FROM creature_loot_template l LEFT JOIN item_template i ON i.entry = l.item WHERE l.item > 0 AND i.entry IS NULL;

SELECT 'creature_loot_template(ref)' AS tbl, COUNT(*) AS dangling
  FROM creature_loot_template l
  LEFT JOIN reference_loot_template r ON r.entry = -l.item
 WHERE l.item < 0 AND r.entry IS NULL;

SELECT 'gameobject_loot_template' AS tbl, COUNT(*) AS dangling
  FROM gameobject_loot_template l
  LEFT JOIN item_template i ON i.entry = l.item
 WHERE l.item > 0 AND i.entry IS NULL;

SELECT 'reference_loot_template' AS tbl, COUNT(*) AS dangling
  FROM reference_loot_template l
  LEFT JOIN item_template i ON i.entry = l.item
 WHERE l.item > 0 AND i.entry IS NULL;

SELECT 'pickpocketing_loot_template' AS tbl, COUNT(*) AS dangling
  FROM pickpocketing_loot_template l
  LEFT JOIN item_template i ON i.entry = l.item
 WHERE l.item > 0 AND i.entry IS NULL;

SELECT 'skinning_loot_template' AS tbl, COUNT(*) AS dangling
  FROM skinning_loot_template l
  LEFT JOIN item_template i ON i.entry = l.item
 WHERE l.item > 0 AND i.entry IS NULL;

SELECT 'item_loot_template' AS tbl, COUNT(*) AS dangling
  FROM item_loot_template l
  LEFT JOIN item_template i ON i.entry = l.item
 WHERE l.item > 0 AND i.entry IS NULL;

-- 2) 商人 / 训练师
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

-- 3) 技能 / 法术 / 起始
SELECT 'skill_line_ability(技能)' AS tbl, COUNT(*) AS dangling
  FROM skill_line_ability a LEFT JOIN skill_line s ON s.id = a.skill_id
 WHERE s.id IS NULL;

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

-- 4) 任务关系：指向不存在的任务（内核会报 `Quest N listed for entry M does not exist.` 并跳过）
SELECT 'gameobject_questrelation' AS tbl, COUNT(*) AS dangling
  FROM gameobject_questrelation r LEFT JOIN quest_template q ON q.entry = r.quest
 WHERE q.entry IS NULL;
-- DELETE r FROM gameobject_questrelation r LEFT JOIN quest_template q ON q.entry = r.quest WHERE q.entry IS NULL;

SELECT 'gameobject_involvedrelation' AS tbl, COUNT(*) AS dangling
  FROM gameobject_involvedrelation r LEFT JOIN quest_template q ON q.entry = r.quest
 WHERE q.entry IS NULL;

-- 5) 世界：区域 / 飞行点 / 尸体朝向
SELECT 'area_template(父区域)' AS tbl, COUNT(*) AS dangling
  FROM area_template a LEFT JOIN area_template p ON p.entry = a.zone_id
 WHERE a.zone_id <> 0 AND p.entry IS NULL;

SELECT 'taxi_nodes' AS tbl, COUNT(*) AS dangling
  FROM taxi_nodes t LEFT JOIN creature_template c ON c.entry = t.creature_entry
 WHERE t.creature_entry <> 0 AND c.entry IS NULL;

SELECT 'world_safe_locs_facing' AS tbl, COUNT(*) AS dangling
  FROM world_safe_locs_facing f LEFT JOIN game_graveyard_zone g ON g.id = f.id
 WHERE g.id IS NULL;
