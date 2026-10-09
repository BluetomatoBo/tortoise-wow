-- 对话框菜单行（gossip_menu）
--
-- 四处独立的问题，共同点是「客户端被要求查询一个不存在的 npc_text ID」，
-- 于是服务端回 QueryHandler.cpp 里写死的英文 “Greetings $N”。
--（发送链路与判定条件见 creature_template.sql 的注释。）
--
-- 只有 loc4/内容列以外的东西在这里改；全部幂等。

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------------
-- 1) 公共问候菜单：entry 与 text_id 都指向 npc_text 8900001
--    配合 creature_template.gossip_menu_id = 8900001 使用。
--    本行**故意不建任何 gossip_menu_option**：
--    Player::PrepareGossipMenu 里当子菜单没有选项且属于「默认菜单」时，
--    会回退到 menu_id = 0 的通用选项（“I want to browse your goods.” 等 16 条），
--    再由 npc_flags 过滤。这与改动前 gossip_menu_id = 0 的行为完全一致，
--    所以只改变了问候文本，不改变玩家能点的选项。
-- ---------------------------------------------------------------------------
INSERT IGNORE INTO `gossip_menu` (`entry`, `text_id`) VALUES (8900001, 8900001);

-- ---------------------------------------------------------------------------
-- 2) 生物：gossip_menu_id 指向一个**不存在**的菜单行
--    GetGossipTextId(menuId) 找不到行时保持 DEFAULT_GOSSIP_MESSAGE(0xffffff)，
--    而生物一定会把包发出去（SendPreparedGossip 的「物件不问候」早退只对
--    gameobject 生效）→ 显示英文。
--    补一行文本映射即可，不影响这些生物原有的 vendor / trainer 等通用选项。
-- ---------------------------------------------------------------------------
INSERT IGNORE INTO `gossip_menu` (`entry`, `text_id`) VALUES
  (18983, 8900001),    -- 生物 51666 Bray Harley
  (62403, 8900001),    -- 生物 62403 Vohand Blundergate
  (62962, 8900001);    -- 生物 62962 Hellador Swiftluck

-- ---------------------------------------------------------------------------
-- 3) 物件 148498 Altar of Suntara（type=2 QUESTGIVER，data3=1282）
--    它有 gameobject_involvedrelation 记录，玩家带着对应任务点开时会发包
--    （GameObject.cpp 的 Use() 里 QUESTGIVER 分支调用
--      PrepareGossipMenu(this, GetGOInfo()->questgiver.gossipID)，
--     其中 questgiver.gossipID 对应 data3，见 GameObjectDefines.h）。
--    而 gossip_menu 里没有 1282 → textId 落回 DEFAULT → 显示英文。
--    保留 data3 原值，只补上缺失的菜单行。
-- ---------------------------------------------------------------------------
INSERT IGNORE INTO `gossip_menu` (`entry`, `text_id`) VALUES (1282, 8900001);

-- ---------------------------------------------------------------------------
-- 4) 兜底：消除所有悬空的 gossip_menu.text_id
--    GetGossipTextId(menuId) 会把 gossip_menu.text_id 原样发给客户端，
--    若该 npc_text 行不存在，客户端就问到一个不存在的 ID → 又是硬编码英文。
--    实测有 2 行（7167 → 8437、62987 → 62987）。
-- ---------------------------------------------------------------------------
UPDATE `gossip_menu` m
LEFT JOIN `npc_text` t ON t.ID = m.text_id
SET m.text_id = 8900001
WHERE t.ID IS NULL;
