-- ==============================================
-- FILE: revert_bogus_demon_trainer_lists.sql
-- GENERATED: 20261008203000
-- ==============================================
-- 还原 7 个「伪训练师」：它们身上那 12 行是别的训练师表被截断复制过来的残留，
-- 而它们真正的职责是发术士恶魔相关任务（例如 5753/5815/6382 发布 7562 Morzul Bloodbringer
-- → 7563 → 7564，即恐惧战马那条链）。
--
-- 事实依据：
--   * 术士召唤恶魔全部靠**任务奖励**学（Summon Imp ← 1470/1485/1598…、Voidwalker ← 1471/1504/1689、
--     Succubus ← 1474/1513/1739、Felhunter ← 1795、Felsteed ← 4490、Dreadsteed ← 7631），
--     全库没有任何训练师教它们（Teach Summon Imp 7763 / Voidwalker 11520 / Succubus 11519 /
--     Felhunter 1373 / Felsteed 5785 / Dreadsteed 23160 都不在 npc_trainer 里）；
--   * 1.12 里 14 个 Demon Trainer 的训练表全是 0 行；仓库里 13 个恶魔训练师中 11 个也是 0 行；
--   * 真·猎人训练师 127 行、真·宠物训练师 94 行，而这几个只有 12 行、且全是猎人技能
--     （瞄准射击/稳固射击/强击光环/蝰蛇守护）→ 复制残留。
--
-- 需要还原的 NPC（上一批 20261008161000 给它们加过 TRAINER 标记，现一并撤回）：
--   5753 Martha Strain / 5815 Kurgul / 6027 Kitha / 6382 Jubahl Corpseseeker /
--   61637 Kazinka / 10618 Rivern Frostwind / 11696 Chal Fairwind
--
-- 1) 删掉那 12 行（只删这一组法术，不动它们可能有的其它行）
DELETE FROM `npc_trainer`
 WHERE `entry` IN (5753, 5815, 6027, 6382, 10618, 11696, 61637)
   AND `spell` IN (1563, 20931, 20932, 20933, 20934, 20935,
                   47319, 47320, 47321, 47322, 47323, 47338);

-- 2) 撤回 TRAINER 标记（守卫：该 NPC 现在确实一条训练行都不剩，才清这一位；
--    这样不会把仍有合法训练表的训练师误改成非训练师）
UPDATE `creature_template`
   SET `npc_flags` = `npc_flags` & ~16
 WHERE `entry` IN (5753, 5815, 6027, 6382, 10618, 11696, 61637)
   AND (`npc_flags` & 16)
   AND NOT EXISTS (SELECT 1 FROM (SELECT `entry` FROM `npc_trainer` GROUP BY `entry`) x
                    WHERE x.`entry` = `creature_template`.`entry`);
