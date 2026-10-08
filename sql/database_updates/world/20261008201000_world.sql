-- ==============================================
-- FILE: cleanup_zero_chance_group_rows.sql
-- GENERATED: 20261008201000
-- ==============================================
-- 消掉最后两条 `has items with chance=0% but group total chance >= 100%` 警告。
--
-- 涉及的是 creature_loot_template entry 16042 的第 1、2 组（Lord Valthalak 那套掉落的镜像组）：
--   第 1 组：22302/22336/22339/22342 各 25%，另有 22335/22337/22340/22343 写着 0%
--   第 2 组：正好反过来（22335/22337/22340/22343 各 25%，其余 4 个写着 0%）
-- 内核的 Roll（LootMgr.cpp:1257 起）先掷「显式概率」那一半，只有**什么都没掷中**（余额仍非负）时
-- 才会去「等概率」那一半里随机取 —— 而这两组的显式概率合计正好是 100，所以那 8 行 0% 的条目
-- 实际上永远取不到（内核也是因此报这条警告）。它们的内容与**另一组**的 25% 条目完全重复，
-- 是上游生成时的复制残留。
--
-- 处理：删掉这 8 行 0% 条目（行为不变：每组仍然各掷出 1 件，4 个 25% 条目等概率）。
-- 守卫：只删「同一 entry+group 内显式概率合计 >= 100 且自身 chance=0 且 condition_id=0」的行，
--       并且该组必须至少还有一行显式概率 —— 保证不会把整组删空。
DELETE z FROM `creature_loot_template` z
  JOIN (SELECT `entry`, `groupid`,
               SUM(CASE WHEN `ChanceOrQuestChance` > 0 THEN `ChanceOrQuestChance` ELSE 0 END) AS `pos_sum`,
               SUM(CASE WHEN `ChanceOrQuestChance` > 0 THEN 1 ELSE 0 END) AS `pos_rows`
          FROM `creature_loot_template`
         WHERE `groupid` <> 0
         GROUP BY `entry`, `groupid`
        HAVING `pos_sum` >= 100 AND `pos_rows` > 0) k
    ON k.`entry` = z.`entry` AND k.`groupid` = z.`groupid`
 WHERE z.`ChanceOrQuestChance` = 0 AND z.`condition_id` = 0 AND z.`mincountOrRef` > 0;
