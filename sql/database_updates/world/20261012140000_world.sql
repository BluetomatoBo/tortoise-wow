-- 补 13 条 spell_affect（38 条 misses 里的第二批：能从**原始数据**判定的那些）
--
-- 背景与第一批（20261011130000，A 级 17 行）相同：光环 107/108/109 的作用范围掩码只能存在
-- 客户端 Spell.dbc 的 EffectItemType（= 库内 spell_template.effectItemType1/2/3）与数据库表
-- `spell_affect` 两处；下面这些法术在客户端里的掩码槽**全是 0**（已逐条从 1.18.1 客户端
-- Spell.dbc 复读确认），所以只能在库里补。
--
-- 「原始数据」查过哪些地方（都不含这批行，故只能从**数据自身的模式**判定）：
--   ① 客户端 Spell.dbc / Talent.dbc（1.18.1）：这 38 个法术的掩码槽全 0；
--   ② 官方 1.12.1 的 spell_affect（205 法术 / 250 行）：一个都没有；
--   ③ 上游仓库 tortoise-wow/tortoise-wow（2026-10-12 拉了最新 main）：比我们多两个迁移文件
--      （20261007161727 / 20261008075941），**都不含 spell_affect**；其 base dump
--      `tw_world_spell_affect.sql` 与本仓库字节一致（md5 33e42c81…）→ 上游也没填；
--   ④ 乌龟服自己的增量（20260504214035 等）：只有 8 个法术的部分槽；
--   ⑤ wowhead / turtle-wow wiki：本机网络不可达（wowhead 403、turtle-wow.org 无连接）。
--
-- 判定依据 = 库内已有的同类行（乌龟服自己的写法）与客户端位图，逐条列在下面。
-- 全部 13 行已按内核加载条件（该槽 Effect==6、aura∈{107,108,109,112}、mask≠EffectItemType）
-- 复算通过；掩码反查命中的法术清单也与描述逐条对应。
--
-- 复验：
--   SELECT COUNT(*) FROM spell_affect;                       -- 280 → 293
--   -- 内核判据复算的 misses 应从 21 条降到 8 条（只剩 45405/45985/51369-51371/52603/52690/52701）
--   -- 全表静态体检（见 sql/wip_updates/spell_affect_missing38.sql 第四节）应仍为 0 行

REPLACE INTO `spell_affect`
(
    `entry`,
    `effectId`,
    `SpellFamilyMask`
)
VALUES
    -- ── 正义打击（天赋 #475，51341-51345 五个 rank）eff0 ─────────────────────────────────
    -- 效果：aura 109 ADD_TARGET_TRIGGER → 触发 51336「虔诚防御」（aura 224 格挡减伤，内核已实现）。
    -- 掩码 = bit35 = 十字军打击。依据（三条**库内原始数据**互证）：
    --   ① 乌龟服自己的 (51242,0)「Holy Strike Crusader Strike Cooldown Reduction」= bit32|bit35
    --      —— 描述点名「Holy Strike 和 Crusader Strike」，而 Holy Strike 正是 bit32
    --      （51341 自己的 eff1/eff2 也写 4294967296 = bit32）；
    --   ② (51355-51359,1)「Vengeful Strikes」eff1 = bit35，描述「Crusader Strike deals an
    --      additional $s2% damage」；
    --   ③ 玩家真正能放的十字军打击是 2537/8823/8824/10336/10337（bit35）—— 有学习包装法术
    --      47314-47318（effect 36 LEARN_SPELL）逐级教它们；而 45409-45413（bit29）那一组
    --      **没有任何学习包装**，是废弃版本（bit29 还与 Judgement of the Crusader 共用，
    --      故绝不能用作掩码）。
    -- 反查：家族 10 里 bit35 只命中 Crusader Strike。
    (51341,0,34359738368),
    (51342,0,34359738368),
    (51343,0,34359738368),
    (51344,0,34359738368),
    (51345,0,34359738368),

    -- ── 大地的召唤（天赋 #228，58238/58239 两个 rank）eff1 ────────────────────────────────
    -- 效果：aura 107 ADD_FLAT_MODIFIER，op 8 ALL_EFFECTS +25/+50（bp 24/49 + baseDice 1）
    --       —— 作用在**施放地盾**时取的效果值上。
    -- 机制：地盾自带 aura 149 RESIST_PUSHBACK（bp 30、baseDice 0 → 取值 30），内核
    --       Spell.cpp:7657/7689 读 `GetTotalAuraModifier(SPELL_AURA_RESIST_PUSHBACK) - 100`
    --       → 抗打断 30% → **55% / 80%**。
    -- 掩码 = bit40 = Earth Shield。依据：**同一法术的 eff0**（增加地盾层数）乌龟服写的就是
    --   1099511627776；eff1 作用于同一目标的同一数值，没有理由换 bit。反查只命中 Earth Shield。
    (58238,1,1099511627776),
    (58239,1,1099511627776),

    -- ── 古仪图腾（物品 33091，同时给 58240/58241/58242/58243 四个光环）────────────────────
    -- 58241 eff1：效果 aura 109 → 触发 58244（aura 12 STUN，内核已实现）。
    --   掩码 = bit53（图腾打击自身的位，与 eff0 一致）。反查命中 Totemic Slam/Feral Spirit/Hex
    --   —— 三者都带 bit53（古仪系列的共同标记位），且都由同一件物品给出，互相带出不构成问题。
    (58241,1,9007199254740992),
    -- 58242 eff0：效果 aura 109 → 触发 58246（见下「留白」说明）。
    --   掩码 = 野性之魂自身的位 = bit53|bit11（9007199254743040）。bit11 与 Ghost Wolf 共用，
    --   属于客户端位图本身的划分；反查即 Feral Spirit/Ghost Wolf/Hex/Totemic Slam。
    (58242,0,9007199254743040),
    -- 58243 eff0：效果 aura 109 → 触发 58245（效果 42 SUMMON_GUARDIAN，creature 872 三只，内核已实现）。
    --   掩码 = 妖术自身的位 = bit53|bit36（9007267974217728）；与兄弟行 58240 的写法同源
    --   （58240 = 9007267974219776 = 本掩码 | bit11）。
    (58243,0,9007267974217728),

    -- ── 电气化（51888「Shocks Electrify Trigger」）eff1 ──────────────────────────────────
    -- 效果：aura 107 ADD_FLAT_MODIFIER，op 32（SPELLMOD_CUSTOM_VALUE_2）+9。
    -- 掩码 = 三系震击（2416967680 = Earth/Flame/Frost Shock + 共位的 Molten Blast/Rekindled Flame）。
    -- 依据：同批天赋 51851「Improved Shocks」的 EffectItemType 就是这个值（增强震击暴击），
    --   51888 的描述「increasing their damage by $s2%」目标与之相同。
    -- ⚠ 注意：op 32 在本内核里**没有任何消费者**（全源码 ApplySpellMod 调用点里没有
    --   CUSTOM_VALUE_*），所以这一行落地后效果仍然不生效 —— 补它只是让数据与乌龟服的意图一致、
    --   消掉 dbfix 的 misses；哪天内核实现了 op 32 就自然生效。
    (51888,1,2416967680),

    -- ── Faster Bleeds（物品 55095 给的 4 个职业版本之一）────────────────────────────────
    -- 52402「Faster Bleeds 5 (Hunter)」eff0/eff1：aura 108 ADD_PCT_MODIFIER，
    --   op 19（DOT，缩短跳动间隔）+ op 1（DURATION）各 -6%。
    -- 掩码 = bit38 = **撕裂 Lacerate**（48049/48050，skill_line_ability 里挂在猎人技能线 51，
    --   描述「Bleeds the target for $s1% of the damage over $d」）。
    -- 依据（同类三兄弟的写法）：本天赋每个职业都指向「该职业的流血法术」——
    --   德鲁伊 8392704 = Rake/Pounce Bleed（bit12）+ Rip（bit23）；
    --   盗贼 1048832 = Garrote（bit8）+ Rupture（bit20）；
    --   战士 32 = Rend + Deep Wound（bit5）；
    --   只有猎人版在客户端里是 0（漏配）。猎人的玩家流血技能只有 Lacerate
    --   （Savage Rend 是宠物技能 bit39|40，毒蛇钉刺是毒不是流血，故都不含）。
    (52402,0,274877906944),
    (52402,1,274877906944);
