-- 让「无子菜单」的生物也能显示中文问候（creature_template）
--
-- 问题
--   打开一个 NPC 对话框时客户端会发 CMSG_NPC_TEXT_QUERY 查询一个 npc_text ID。
--   core 在 src/game/Handlers/QueryHandler.cpp 的 HandleNpcTextQueryOpcode()
--   里把英文写死在 C++ 字面量中：
--       if (!pGossip) { ... data << "Greetings $N"; ... }
--   只要被查询的 ID 不在 npc_text 表里，玩家看到的就是这段英文，
--   改 locales_* 列无论如何都不会生效。
--
--   而 gossip_menu_id = 0 的生物，core 走的是「无子菜单」这条路：
--       Player.cpp:14312 GetGossipTextId(WorldObject*)
--           非生物 → DEFAULT_GOSSIP_MESSAGE (0xffffff)
--           生物   → npc_gossip[guidLow]，没有则同样是 DEFAULT
--       DEFAULT 这个 ID 不在 npc_text 表里 → 必然命中硬编码英文。
--
-- 修法
--   给这些模板一个真实的默认菜单，让 core 用
--   Player.cpp:14323 GetGossipTextId(menuId, WorldObject*) 这条路径
--   去 gossip_menu 查 text_id，从而查到我们新建的中文问候。
--   Creature::GetDefaultGossipMenuId() 返回的正是
--   Creature.cpp:569 从本列复制的 m_gossipMenuId，
--   而 NPCHandler.cpp:400 用它作为 menuId，
--   所以只改这一列就能让问候变成中文。
--
-- 为什么不会改变玩家能点的选项
--   8900001 这个菜单**故意没有任何 gossip_menu_option**。
--   Player::PrepareGossipMenu (Player.cpp:13991) 里：
--       if (pMenuItemBounds.first == pMenuItemBounds.second && defaultMenu)
--           pMenuItemBounds = sObjectMgr.GetGossipMenuItemsMapBounds(0);
--   即子菜单没有选项时回退到 menu_id = 0 的通用选项，
--   再由 npc_flags 过滤 —— 与改动前 gossip_menu_id = 0 的结果完全相同。
--   GuildBank.cpp:143-148 也自带同样的 menu 0 回退，因此公会银行行为不变。
--
-- 附带效果（可接受）
--   Player.cpp:14471 在「多个任务时显示任务列表」的分支里，
--   原本因为 textId == DEFAULT_GOSSIP_MESSAGE 而不设标题，现在会用
--   broadcast_text 10783 当标题（你好，$n。），即任务列表上多一句问候 ——
--   这是正式服的正常表现。
--
-- 只改 gossip_menu_id = 0 的模板；npc_flags = 0 的模板玩家根本无法交互，
-- 不纳入本次改动。

SET NAMES utf8mb4;

UPDATE `creature_template`
SET `gossip_menu_id` = 8900001
WHERE `gossip_menu_id` = 0
  AND `npc_flags` <> 0;
