-- ==============================================
-- FILE: fix_pool_chance_sums.sql
-- GENERATED: 20261008210000
-- ==============================================
-- 修掉 20261008164000（5665 矿石池按地图拆分）留下的副作用：
--   Pool Id (N) has all creatures or gameobjects with explicit chance sum <>100 and no equal chance
--   defined. The pool system cannot pick one to spawn.
--
-- 原因：把「黑石塔那根矿脉」从原来的子池里搬走之后，源池与新建池里剩下的成员**概率合计不再是 100**。
-- 内核的 PoolGroup::CheckPool（PoolManager.cpp:168）判定规则是：
--   「池内没有等概率成员（即所有成员都写了非 0 概率）时，概率合计必须正好 100，否则该池自动刷新被关闭」；
-- 而池子的 max_limit = 1 时，成员才会被当作「显式概率」参与抽取（AddEntry，PoolManager.cpp:158）。
-- 合计不等于 100 的后果：每抽一次矿脉有 (100-合计)% 的概率**什么都刷不出来** —— 是真的会丢刷新。
--
-- 处理：把所有「max_limit = 1 且成员全为显式概率、合计 <> 100」的池子，按比例把概率缩放到合计 100。
-- 只缩放相对权重、不改变谁是稀有谁常见；这类池子在内核眼里本来就是坏的（会被关闭自动刷新）。
-- 幂等：缩放后合计 = 100，再跑不再命中。
--
-- 自查（应为 0）：
--   SELECT COUNT(*) FROM (SELECT pg.pool_entry FROM pool_gameobject pg JOIN pool_template t ON t.entry=pg.pool_entry
--     WHERE t.max_limit=1 GROUP BY pg.pool_entry HAVING SUM(pg.chance)=0 OR
--     (SUM(CASE WHEN pg.chance=0 THEN 1 ELSE 0 END)=0 AND SUM(pg.chance) <> 100)) x；
-- 幂等：缩放后合计 = 100，再跑不再命中。

-- pool_gameobject
UPDATE `pool_gameobject` pg
  JOIN (SELECT `pool_entry`, SUM(`chance`) AS s,
               SUM(CASE WHEN `chance` = 0 THEN 1 ELSE 0 END) AS zeros,
               SUM(CASE WHEN `chance` < 0 THEN 1 ELSE 0 END) AS neg
          FROM `pool_gameobject` GROUP BY `pool_entry`) k ON k.`pool_entry` = pg.`pool_entry`
  JOIN `pool_template` t ON t.`entry` = pg.`pool_entry` AND t.`max_limit` = 1
   SET pg.`chance` = ROUND(pg.`chance` * 100 / k.s, 4)
 WHERE k.zeros = 0 AND k.neg = 0 AND k.s > 0 AND k.s <> 100;

-- pool_creature
UPDATE `pool_creature` pg
  JOIN (SELECT `pool_entry`, SUM(`chance`) AS s,
               SUM(CASE WHEN `chance` = 0 THEN 1 ELSE 0 END) AS zeros,
               SUM(CASE WHEN `chance` < 0 THEN 1 ELSE 0 END) AS neg
          FROM `pool_creature` GROUP BY `pool_entry`) k ON k.`pool_entry` = pg.`pool_entry`
  JOIN `pool_template` t ON t.`entry` = pg.`pool_entry` AND t.`max_limit` = 1
   SET pg.`chance` = ROUND(pg.`chance` * 100 / k.s, 4)
 WHERE k.zeros = 0 AND k.neg = 0 AND k.s > 0 AND k.s <> 100;
