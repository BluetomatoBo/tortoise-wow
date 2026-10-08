-- ==============================================
-- FILE: pool_5665_split_by_map.sql
-- GENERATED: 20261008164000
-- ==============================================
-- 启动日志里的池子报错（原日志 12 行）：
--   `pool_pool` / `pool_gameobject` has ... spawned at map 0 when one or several other spawned at
--   different instanceable map 229 in pool id 5665 / 5004, skipped.
--
-- 原因：内核要求「共用同一个母池的所有刷新点必须都在同一类地图上——要么全是非实例化地图，要么全落在
-- 同一个实例化地图里」（PoolManager.cpp 的 CheckAndRemember）。5665「Thorium Veins in Eastern
-- Kingdoms Instance 2」这个矿石池家族里混进了黑石塔（map 229）的矿脉，于是内核每次启动都把不匹配的
-- 子池/成员逐个摘掉：池子既没起到轮换作用，又每次刷 12 条报错。
--
-- 处理方式（完全按你库里 pool_gameobject / pool_creature / gameobject / creature 的实际数据 join 出来，
-- 不写死任何 guid；重复执行无副作用）：
--   1) 新建一个**不带母池**的独立池，专门装实例化地图里的矿脉；
--   2) 把 5665 家族里落在实例化地图上的物件/生物成员搬进新池；
--   3) 兜底保证新池不挂在 5665 下面。
--
-- 新池的 max_limit = 搬过去的成员数，也就是「这些矿脉照旧全部常驻」——和你现在看到的效果一致
-- （它们本来就没被池子管住）。内核用 max_limit 表示「这个池最多同时刷几个成员」。
-- 如果你想让它和家族里其它 10 个子池一样「一次只刷一根、按概率轮换」：把下面第 1 步 INSERT 里的 @cnt 改成 1，
-- 再把成员概率按比例缩放到合计 100（做法见 tools/dbdiff/README.md 的「想让新池一次只刷一根」一节）。
--
-- 实例化地图清单来自客户端 patch-9 的 Map.dbc（mapType 1 副本 / 2 团队 / 3 战场，共 47 个）。
--
-- 跑完后的自查（期望：第一句 0 行，第二句显示新池和它的成员数）：
--   SELECT pp.mother_pool FROM pool_pool pp JOIN pool_gameobject pg ON pg.pool_entry = pp.pool_id
--     JOIN gameobject g ON g.guid = pg.guid WHERE pp.mother_pool = 5665 AND g.map IN (<实例化地图清单>)
--     LIMIT 1
--   SELECT pool_entry, COUNT(*), SUM(chance) FROM pool_gameobject WHERE pool_entry = @new_pool GROUP BY pool_entry

-- 新池 id 取「pool_template / pool_gameobject / pool_creature / pool_pool 里出现过的最大 id + 1」，
-- 保证不会撞上已经有人引用、但 pool_template 里没有的 id。
SET @new_pool := (SELECT MAX(e) + 1 FROM (
        SELECT MAX(`entry`) AS e FROM `pool_template`
        UNION ALL SELECT MAX(`pool_entry`) FROM `pool_gameobject`
        UNION ALL SELECT MAX(`pool_entry`) FROM `pool_creature`
        UNION ALL SELECT MAX(`pool_id`) FROM `pool_pool`) AS x);
SET @cnt := (SELECT COUNT(*) FROM `pool_gameobject` pg JOIN `gameobject` g ON g.`guid` = pg.`guid`
        WHERE pg.`pool_entry` IN (
        SELECT `pool_id` FROM `pool_pool` WHERE `mother_pool` = 5665
        UNION SELECT pp2.pool_id FROM `pool_pool` pp2 JOIN `pool_pool` pp3 ON pp2.mother_pool = pp3.pool_id WHERE pp3.mother_pool = 5665
        ) AND g.`map` IN (
        26, 28, 30, 33, 34, 35, 36, 43, 47, 48, 70, 90,
        109, 129, 189, 209, 229, 230, 249, 269, 289, 309, 329, 349,
        389, 409, 429, 469, 489, 509, 529, 531, 532, 533, 800, 802,
        807, 808, 814, 815, 816, 817, 818, 819, 820, 821, 822
        )) + (SELECT COUNT(*) FROM `pool_creature` pc JOIN `creature` c ON c.`guid` = pc.`guid`
        WHERE pc.`pool_entry` IN (
        SELECT `pool_id` FROM `pool_pool` WHERE `mother_pool` = 5665
        UNION SELECT pp2.pool_id FROM `pool_pool` pp2 JOIN `pool_pool` pp3 ON pp2.mother_pool = pp3.pool_id WHERE pp3.mother_pool = 5665
        ) AND c.`map` IN (
        26, 28, 30, 33, 34, 35, 36, 43, 47, 48, 70, 90,
        109, 129, 189, 209, 229, 230, 249, 269, 289, 309, 329, 349,
        389, 409, 429, 469, 489, 509, 529, 531, 532, 533, 800, 802,
        807, 808, 814, 815, 816, 817, 818, 819, 820, 821, 822
        ));

-- 1) 只有确实需要拆（@cnt > 0）才建新池
INSERT INTO `pool_template` (`entry`, `max_limit`, `description`, `flags`, `instance`)
SELECT @new_pool, @cnt, 'Thorium Veins (Blackrock Spire) - split out of pool 5665 by map', 0, 0
FROM DUAL WHERE @cnt > 0;

-- 2) 物件成员搬到新池（落在实例化地图上的那些）
UPDATE `pool_gameobject` SET `pool_entry` = @new_pool
WHERE `pool_entry` IN (
        SELECT `pool_id` FROM `pool_pool` WHERE `mother_pool` = 5665
        UNION SELECT pp2.pool_id FROM `pool_pool` pp2 JOIN `pool_pool` pp3 ON pp2.mother_pool = pp3.pool_id WHERE pp3.mother_pool = 5665
) AND `guid` IN (SELECT `guid` FROM `gameobject` WHERE `map` IN (
        26, 28, 30, 33, 34, 35, 36, 43, 47, 48, 70, 90,
        109, 129, 189, 209, 229, 230, 249, 269, 289, 309, 329, 349,
        389, 409, 429, 469, 489, 509, 529, 531, 532, 533, 800, 802,
        807, 808, 814, 815, 816, 817, 818, 819, 820, 821, 822
));

-- 3) 生物成员同理（这个家族目前只有物件，写上是防以后有人往池里塞生物）
UPDATE `pool_creature` SET `pool_entry` = @new_pool
WHERE `pool_entry` IN (
        SELECT `pool_id` FROM `pool_pool` WHERE `mother_pool` = 5665
        UNION SELECT pp2.pool_id FROM `pool_pool` pp2 JOIN `pool_pool` pp3 ON pp2.mother_pool = pp3.pool_id WHERE pp3.mother_pool = 5665
) AND `guid` IN (SELECT `guid` FROM `creature` WHERE `map` IN (
        26, 28, 30, 33, 34, 35, 36, 43, 47, 48, 70, 90,
        109, 129, 189, 209, 229, 230, 249, 269, 289, 309, 329, 349,
        389, 409, 429, 469, 489, 509, 529, 531, 532, 533, 800, 802,
        807, 808, 814, 815, 816, 817, 818, 819, 820, 821, 822
));

-- 4) 兜底：新池不能挂在 5665 下面（带了母池就又会和 5665 家族混在一起）
DELETE FROM `pool_pool` WHERE `pool_id` = @new_pool AND `mother_pool` = 5665;
