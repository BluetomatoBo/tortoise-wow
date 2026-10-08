-- ==============================================
-- FILE: gameobject_template_transport_and_focus_fixes.sql
-- GENERATED: 20261008152000
-- ==============================================
-- 启动时三条 gameobject 报错里的两条，都是模板里的「引用字段」指错了东西。
--
-- 1) 181056 'Naxxramas'（type 15，MO_TRANSPORT）的 data0 = 436 是个**过期的路径号**。
--    436 是当年（1.12 官方 dump 里同一行就是这个值）的编号；这份客户端的数据表重新编号过：
--    TaxiPath.dbc 只有 1..360，436 在任何客户端里都不存在。而客户端自己有一条 Naxxramas
--    的运输路线——TaxiPath 240（cost 0，端点正是 TaxiNode 78，名字就叫 "Naxxramas"），
--    路径节点 13 个、就绕在这座浮空城所在的那片区域上空（z≈232）。
--    改成 240 后模板与客户端一致，报错消失；因为 `transports` 表里没有这一条，
--    服务端不会给它建 Transport 对象，游戏内的表现与现在完全相同（它只是 `gameobject`
--    里刷出的那个静态浮空城）。哪天真想让它飞起来，再往 `transports` 里加一行即可。
--
-- 2) 944 'Place centrale de DarrowShire'（type 8，SPELL_FOCUS）的 data2（linkedTrap）= 1，
--    指向的却是 `gameobject_template` 里那个开发用的 ' ONGOING ROLEPLAY EVENT' 占位物体
--    （type 5），而不是陷阱。官方数据里这个字段的用法很明确：1.12 的 2836 个 spell focus 中
--    2060 个填了它，全都指向真正的陷阱（最典型的是 2061 'Campfire'）；而这处坐标周围 200 码
--    内一个陷阱都没有，也没有任何法术会召唤 944 或物体 1——所以这个 1 是残留，清成 0
--    （= 没有连接陷阱）。另外 15 个 spell focus 也留着指向不存在物体的链接，那些只在
--    DB.Strict 模式下记录，这里不动。
--
-- 生效：mangosd 控制台 `.reload gameobject_template`（或重启）

UPDATE `gameobject_template` SET `data0` = 240
 WHERE `entry` = 181056 AND `type` = 15 AND `data0` = 436;

UPDATE `gameobject_template` SET `data2` = 0
 WHERE `entry` = 944 AND `type` = 8 AND `data2` = 1;
