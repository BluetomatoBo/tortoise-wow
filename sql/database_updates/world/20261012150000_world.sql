-- 按客户端 CreatureSpellData.dbc 补齐/更新 pet_spell_data（宠物法术表缺口）
--
-- 背景：dbfix.log 里 `Creature (Entry: N) has nonexistent pet_spell_list_id (M)` 共 34 个 id
-- 影响 101 只生物。`pet_spell_list_id` 指向的表是 `pet_spell_data`，而它就是客户端
-- `CreatureSpellData.dbc` 的镜像：内核自己的注释写着「fill data from DBC as more correct
-- source if available」（`ObjectMgr::LoadPetCreateSpells`）——驯服宠物时先用
-- `petcreateinfo_spell`，再用本表覆盖；需要「教技能」时把技能换成它的学习包装
-- （`effect 36 LEARN_SPELL` 且 trigger = 该技能）。同一个 id 还会随
-- `CMSG_CREATURE_QUERY` 发给客户端（第 12 个字段），客户端拿自己的 DBC 显示宠物技能。
--
-- 权威来源 = **客户端 1.18.1 的 CreatureSpellData.dbc**（仓库客户端清单
-- tools/dbc_verification/manifest_formatted.json 里 `DBFilesClient/CreatureSpellData.dbc`
-- 的较新版本，12,765 字节 / 354 行，下载时按 sha256 校验；旧版 12,621 字节用于对照，
-- 两者的差别只在 9515-9518 这四行）。本机原版 1.12.1 客户端的同名文件（315 行）只用于三方对照。
--
-- 核对工具（可复现）：python3 tools/WowWeb/gen_pet_spell_data.py \
--                      --mysql "tools/dbdiff/mysql_local.sh tw_world" --emit-sql <文件>
-- 结论分三类：
--   ① 只有客户端有 → 补（缺行 = 内核报错 + 宠物完全没有技能）
--   ② 两侧都有但客户端多技能 → 更新（宠物少了客户端已经显示的那个技能：
--      熊的 Roar of Fortitude、螃蟹/龟的 Bubble Barrier、鳄鱼的 Death Roll、蜘蛛的 Web、
--      陆行鸟的 Strider Presence、狼的 Packleader、蝎子的 Scorpid Poison、Savage Rend 等，
--      这些技能在库里都有对应的学习包装 → 驯服后宠物会正常学会）
--   ③ 客户端清成 0（9091 Rotting Agam'ar）与只有服务端有（61975 Blackwind Villager）
--      → 两边说法矛盾 / 是乌龟服服务端自己的增删，**本迁移不动**，只在文档里记录
--
-- 本次只动 ① 与 ②：33 行新增（其中 32 行被 99 只生物引用）+ 35 行补第二个技能
-- （被 44 只生物引用）。补完后仍有 2 个 id 无处可查：503（Crimson Guard Olbreg）与
-- 627600（Blackwind Villager）—— 客户端里根本没有这两个 id，属乌龟服服务端自造 → 保持原样。
--
-- 复验：
--   SELECT COUNT(*) FROM pet_spell_data;                                    -- 322 → 355
--   -- 仍无法解析的 pet_spell_list_id（应只剩 503 / 627600 两个 id、2 只生物）
--   SELECT c.pet_spell_list_id, COUNT(*) FROM creature_template c
--     LEFT JOIN (SELECT DISTINCT entry AS id FROM pet_spell_data) p ON p.id = c.pet_spell_list_id
--    WHERE c.pet_spell_list_id <> 0 AND p.id IS NULL GROUP BY c.pet_spell_list_id;

INSERT IGNORE INTO `pet_spell_data` (`entry`, `spell_id1`, `spell_id2`, `spell_id3`, `spell_id4`) VALUES
  (9486,46271,0,0,0),
  (9487,46272,0,0,0),
  (9488,46272,17260,0,0),
  (9489,46272,17261,0,0),
  (9490,46273,0,0,0),
  (9491,46296,17259,0,0),
  (9492,46296,17260,0,0),
  (9493,24423,16828,0,0),
  (9494,36533,0,0,0),
  (9495,36548,0,0,0),
  (9496,36549,0,0,0),
  (9497,17256,36549,0,0),
  (9498,36550,0,0,0),
  (9499,36553,0,0,0),
  (9500,36536,0,0,0),
  (9501,36537,0,0,0),
  (9502,36538,0,0,0),
  (9503,36539,0,0,0),
  (9504,36540,0,0,0),
  (9505,36541,0,0,0),
  (9506,36535,0,0,0),
  (9507,36531,0,0,0),
  (9508,36532,0,0,0),
  (9509,36523,0,0,0),
  (9510,36524,0,0,0),
  (9511,36525,0,0,0),
  (9512,3009,36526,0,0),
  (9513,36552,0,0,0),
  (9514,24587,0,0,0),
  (9515,17260,42051,0,0),
  (9516,17260,36535,0,0),
  (9517,17260,36531,0,0),
  (9518,17260,1756,0,0);
UPDATE `pet_spell_data` SET `spell_id2` = 36535 WHERE `entry` = 5806 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36525 WHERE `entry` = 5807 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36535 WHERE `entry` = 5808 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36535 WHERE `entry` = 5810 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36535 WHERE `entry` = 5811 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36535 WHERE `entry` = 5813 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36524 WHERE `entry` = 5843 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36524 WHERE `entry` = 5844 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36525 WHERE `entry` = 5845 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36525 WHERE `entry` = 5846 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36548 WHERE `entry` = 5847 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36548 WHERE `entry` = 5848 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36549 WHERE `entry` = 5849 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36550 WHERE `entry` = 5851 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36550 WHERE `entry` = 5853 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36551 WHERE `entry` = 5854 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36551 WHERE `entry` = 5855 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36552 WHERE `entry` = 5857 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36551 WHERE `entry` = 5858 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36533 WHERE `entry` = 5892 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36533 WHERE `entry` = 5893 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36533 WHERE `entry` = 5894 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36533 WHERE `entry` = 5895 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36533 WHERE `entry` = 5897 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36533 WHERE `entry` = 5898 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 2565 WHERE `entry` = 5900 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36533 WHERE `entry` = 5905 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36533 WHERE `entry` = 5909 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36533 WHERE `entry` = 5910 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36533 WHERE `entry` = 5911 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36531 WHERE `entry` = 5916 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36531 WHERE `entry` = 5917 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36531 WHERE `entry` = 5918 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36531 WHERE `entry` = 5919 AND `spell_id2` = 0;
UPDATE `pet_spell_data` SET `spell_id2` = 36532 WHERE `entry` = 8280 AND `spell_id2` = 0;
