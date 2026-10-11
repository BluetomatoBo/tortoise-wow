-- 补 17 条 spell_affect（dbfix.log 里 38 条「misses spell_affect」中可精确推导的那批）
--
-- 背景：光环 107/108/109 的「作用法术范围」掩码只有两个存放处 —— 客户端 Spell.dbc 的
-- EffectItemType[effect]（= 库内 spell_template.effectItemType1/2/3）与数据库表 spell_affect。
-- 这 38 个效果在客户端里的槽位**全是 0**，所以掩码只能在 DB 侧补；而官方 1.12 的
-- spell_affect（205 法术 / 250 行）里这 38 个 entry 一个都没有，乌龟服自己写的 base dump
-- 也只填了 8 个法术的部分槽 —— 出处核查的完整过程见 tools/dbdiff/README.md 第十八节、
-- 候选清单与分级见 sql/wip_updates/spell_affect_missing38.sql。
--
-- 本次只落「A 级」17 条：掩码 = 天赋描述点名的法术（全部等级）的 spellFamilyFlags 按位或，
-- 且用掩码反查命中清单**只**命中那些法术（查询见文件末尾）。B 级 12 条（掩码会多带出同家族
-- 法术，如 51341-51345 会带上 Judgement of the Crusader）与 C 级 9 条（点名法术 familyFlags = 0）
-- 暂不落库，等游戏内验证/策划决定。
--
-- 每条的依据（家族 → 反查命中）：
--   19491/19493 eff1  9  → Scorpid Sting ×5（客户端同法术 effect0 本来就写着 32768，
--                        effect1 的光环/操作数（107/8）与 effect0 完全相同）；
--   29082-29088 eff1  11 → Stormstrike + Lightning Strike（描述点名两者）；
--   51486-51488 eff0  6  → Lightwell（Reservoir of Light：Lightwell's Splendor of Light；
--                        Splendor of Light #7001 自身 familyFlags = 0 选不中，真正能选中的是 Lightwell）；
--   51798 eff0/eff1   6  → Lightwell；
--   51859 eff0        11 → Lightning Strike ×6；
--   52326 eff0        7  → Owlkin Frenzy ×3；
--   52364 eff0        7  → Bear Form + Dire Bear Form；
--   52546 eff1        5  → Curse of Recklessness + Curse of Shadow + Curse of the Elements
--                        （0x10000000000 不含 Curse of Doom，与描述「except Curse of Doom」一致）；
--   52977 eff0        6  → Lightwell（Light Infusion Passive：Casting Lightwell grants ...）。
--
-- 这 17 条都通过了内核的加载条件（SpellMgr::LoadSpellAffects）：
-- Effect[eff] == 6 (APPLY_AURA)、aura ∈ {107,108,109,112}、mask != EffectItemType[eff]
-- （否则会被判 redundant 跳过），复算脚本见 README 第十八节末尾。
-- REPLACE 幂等，重跑无副作用。生效需要重启（或控制台 `.reload spell_affect`）。
--
-- 复核：SELECT COUNT(*) FROM spell_affect;                        -- 263 → 280
--       SELECT entry, effectId, SpellFamilyMask FROM spell_affect WHERE entry IN
--              (19491,19493,29082,29084,29086,29087,29088,51486,51487,51488,51798,51859,52326,52364,52546,52977);

REPLACE INTO `spell_affect`
(
    `entry`,
    `effectId`,
    `SpellFamilyMask`
)
VALUES
    (19491,1,32768),
    (19493,1,32768),
    (29082,1,6597069766656),
    (29084,1,6597069766656),
    (29086,1,6597069766656),
    (29087,1,6597069766656),
    (29088,1,6597069766656),
    (51486,0,17179869184),
    (51487,0,17179869184),
    (51488,0,17179869184),
    (51798,0,17179869184),
    (51798,1,17179869184),
    (51859,0,4398046511104),
    (52326,0,549755813888),
    (52364,0,1073741824),
    (52546,1,1099511627776),
    (52977,0,17179869184);
