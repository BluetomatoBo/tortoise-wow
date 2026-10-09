-- NPC 问候文本载体（npc_text）
--
-- 背景：core 在 src/game/Handlers/QueryHandler.cpp 的
-- HandleNpcTextQueryOpcode() 里把 “Greetings $N” 写死在 C++ 字面量中。
-- 客户端打开对话框时会用 CMSG_NPC_TEXT_QUERY 查询一个 npc_text ID，
-- **只要该 ID 在 npc_text 表里不存在，服务端就回那段英文**。
-- 因此单改 locales_* 列对这种情况完全无效。
--
-- 这里新建一条真实存在的问候文本，引用 Turtle 官方已有的
-- broadcast_text 10783（’Greetings, $n.’ / ’你好，$n。’）。
-- 复用官方条目意味着**不需要新增 broadcast_text**，
-- 从而可以用 .reload npc_text 生效，不需要重启。
--
-- 配套改动见 creature_template.sql / gossip_menu.sql。

SET NAMES utf8mb4;

INSERT IGNORE INTO `npc_text` (`ID`, `BroadcastTextID0`, `Probability0`)
VALUES (8900001, 10783, 1);

-- ---------------------------------------------------------------------------
-- 训练师「不能教你」的三条文本（Creature::IsTrainerOf 里的字面量 ID）
-- ---------------------------------------------------------------------------
-- core 在这三个分支里直接把 npc_text ID 写死：
--   TRAINER_TYPE_PETS        -> 3620
--   TRAINER_TYPE_PETS        -> 10090
--   TRAINER_TYPE_TRADESKILLS -> 11031
-- 这三个 ID 在任何数据库里都不存在（我们的库、1.17 泄露库、cmangos 1.12 官方库、
-- AzerothCore 3.3.5 全都没有），所以玩家看到的是 QueryHandler.cpp 里写死的
-- “Greetings $N”。这里按 ID 语义补上对应文本。
--
-- 关键线索：这三个 ID 恰好等于三个真实 NPC 的 entry，且 NPC 类型与使用它们的分支
-- 完全吻合 —— 暴雪当年就是用「代表该训练师类型的 NPC entry」当 npc_text ID：
--   3620  = Harruk 哈鲁克（宠物训练师，杜隆塔尔剃刀岭）
--   10090 = Belia Thundergranite 贝莉亚·雷岩（宠物训练师）
--   11031 = Franklin Lloyd 弗兰克林·洛伊德（工程学训练师）
--
-- 前两条**精确复原**：Harruk 的 gossip_menu 4783 用条件行表达了同一句拒绝语
--   condition 97 -> npc_text 5839 -> broadcast_text 8407
-- 该条已有官方中文，因此直接复用（不新增任何文本）：
--   broadcast_text 8407 = “Ah friend, I only help hunters and their pets.”
--                        = 啊朋友，我只帮助猎人和他们的宠物。
--
-- 第三条（11031）的原文在所有数据源中都不存在，无法复原。
-- 该分支的语义是「商业技能训练师要求玩家已掌握本行基础」，
-- 因此新建一条语义相符的文本（英文与中文均为自撰，非官方）。
INSERT IGNORE INTO `npc_text` (`ID`, `BroadcastTextID0`, `Probability0`) VALUES
  (3620,  8407,    1),    -- 宠物训练师、非猎人：复用官方拒绝语
  (10090, 8407,    1),    -- 同上（另一位宠物训练师）
  (11031, 8900001, 1);    -- 商业技能缺前置：原文不可复原，见 broadcast_text.sql
