#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""simulate_fix_effects.py —— 把内核那几段判定照字面重写，在**线上库**上跑一遍，
给出「这批 spell_affect / pet_spell_data 修复之后，服务器一定会算出什么」。

不能替代上游戏（服务器的完整运行环境跑不起来），但能把「数据 → 判定 → 数值」这条链
逐段复算，用它决定该测什么、预期值是多少，以及哪些本来就不该有变化。

覆盖三段内核代码：

  1. `SpellMgr::LoadSpellAffects`（SpellMgr.cpp:3083）—— 行的准入条件：
     Effect[eff]==6 且 aura∈{107,108,109,112} 且 mask≠EffectItemType（否则 redundant 跳过）。
  2. `SpellModifier::isAffectedOnSpell`（Player.cpp:462）—— 生效判定：
     先比 `SpellFamilyName`，再比 `spell->SpellFamilyFlags & mask`；
     `Aura::isAffectedOnSpell`（SpellAuras.cpp:950）同理，供 aura 109（ADD_TARGET_TRIGGER）用。
  3. `SpellAuraHolder` 的 `ApplySpellMod(GetId(), SPELLMOD_CHARGES, m_procCharges)`
     （SpellAuras.cpp:6787）—— 地盾/水盾的「层数」就是这么被天赋改的；
     抗打断（aura 149）走 `Spell.cpp:7657` 的 `GetTotalAuraModifier(...) - 100`。

用法：
    python3 tools/dbdiff/simulate_fix_effects.py --mysql "tools/dbdiff/mysql_local.sh tw_world"
"""

import argparse
import shlex
import subprocess
import sys


def mysql(cmd, sql):
    out = subprocess.run(shlex.split(cmd) + ["-N", "-B", "--raw", "-e", sql],
                         capture_output=True, text=True)
    if out.returncode:
        sys.exit(out.stderr.strip())
    return [l.split("\t") for l in out.stdout.splitlines() if l]


def load_spells(cmd):
    """spell_template 的关键字段：家族、位图、三个槽的 Effect/aura/itemType/bp/dice/misc/trigger。"""
    rows = mysql(cmd, """SELECT entry, name, spellFamilyName, spellFamilyFlags, procCharges, StackAmount,
        effect1, effectApplyAuraName1, effectItemType1, effectBasePoints1, effectBaseDice1, effectMiscValue1, effectTriggerSpell1,
        effect2, effectApplyAuraName2, effectItemType2, effectBasePoints2, effectBaseDice2, effectMiscValue2, effectTriggerSpell2,
        effect3, effectApplyAuraName3, effectItemType3, effectBasePoints3, effectBaseDice3, effectMiscValue3, effectTriggerSpell3
        FROM spell_template""")
    spells = {}
    for r in rows:
        # name 之后：family, flags, procCharges, stack，然后每个槽 7 列
        # (Effect, aura, itemType, bp, dice, misc, triggerSpell)
        v = [int(x) if x.strip() else 0 for x in r[2:]]
        slots = []
        for i in range(3):
            base = 4 + i * 7
            slots.append((v[base], v[base + 1], v[base + 2], v[base + 3], v[base + 4],
                          v[base + 5], v[base + 6]))
        spells[int(r[0])] = {"name": r[1], "family": v[0], "flags": v[1],
                             "procCharges": v[2], "stack": v[3], "eff": slots}
    return spells


def simple_value(bp, dice):
    """SpellEntry::CalculateSimpleValue = EffectBasePoints + EffectBaseDice。"""
    return bp + dice


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--mysql", required=True)
    args = ap.parse_args()
    cmd = args.mysql
    spells = load_spells(cmd)
    affects = {}
    for r in mysql(cmd, "SELECT entry, effectId, SpellFamilyMask FROM spell_affect"):
        affects[(int(r[0]), int(r[1]))] = int(r[2])

    # ---- ① 准入条件复算（内核 LoadSpellAffects）----
    print("=" * 100)
    print("① 内核准入条件复算（SpellMgr.cpp:3083）：Effect=6 且 aura∈{107,108,109,112} 且 mask≠EffectItemType")
    print("-" * 100)
    bad = []
    for (entry, eff), mask in sorted(affects.items()):
        sp = spells.get(entry)
        if not sp:
            bad.append((entry, eff, "法术不存在")); continue
        e, aura, item = sp["eff"][eff][0], sp["eff"][eff][1], sp["eff"][eff][2]
        if e != 6 or aura not in (107, 108, 109, 112) or (item and item == mask):
            bad.append((entry, eff, "Effect=%d aura=%s itemType=%s" % (e, aura, item)))
    print("spell_affect 共 %d 行；会被内核跳过的：%d 行 %s" % (len(affects), len(bad), bad if bad else "（无 → 全部加载）"))

    # ---- ② 生效判定 + 数值推演（挑能测的几条逐个算）----
    print()
    print("=" * 100)
    print("② 生效判定与预期数值（Player.cpp:462 / SpellAuras.cpp:6787 / Spell.cpp:7657）")
    print("-" * 100)
    print("%-26s %-22s %-28s %s" % ("天赋/物品法术", "靶子法术", "判定（家族 + 位图）", "服务器会算出"))

    def verdict(affect_entry, eff, target_entry, family_ok_note=""):
        sp, tg = spells.get(affect_entry), spells.get(target_entry)
        if not sp or not tg:
            return "法术缺失", ""
        mask = affects.get((affect_entry, eff), 0)
        fam_ok = sp["family"] == tg["family"]
        bit_ok = bool(tg["flags"] & mask)
        txt = "家族 %d==%d %s；位图 0x%X & 0x%X %s" % (
            sp["family"], tg["family"], "✓" if fam_ok else "✗（isAffectedOnSpell 直接 false）",
            tg["flags"], mask, "✓" if bit_ok else "✗")
        return txt, ("命中" if (fam_ok and bit_ok) else "不命中")

    tests = []

    # 正义打击 → 十字军打击（aura 109 ADD_TARGET_TRIGGER → 51336）
    v, hit = verdict(51341, 0, 10337)
    trg = spells[51336]
    tests.append(("Righteous Strikes 51341-45", "Crusader Strike 10337", v,
                  "%s；触发 51336「虔诚防御」= aura %d，值 %d%%（格挡减伤）"
                  % (hit, trg["eff"][0][1], abs(simple_value(trg["eff"][0][3], trg["eff"][0][4])))))
    # 大地的召唤 → 地盾（aura 107 op 4 充能 / op 8 ALL_EFFECTS）
    for rank, (a, mod) in (("Rank1 58238", (58238, 2)), ("Rank2 58239", (58239, 4))):
        v, hit = verdict(a, 0, 45525)
        es = spells[45525]
        pushback = simple_value(es["eff"][1][3], es["eff"][1][4])
        tests.append(("%s（充能 op4）" % rank, "Earth Shield 45525", v,
                      "%s；地盾层数 %d → %d" % (hit, es["procCharges"], es["procCharges"] + mod)))
        v, hit = verdict(a, 1, 45525)
        mod8 = simple_value(spells[a]["eff"][1][3], spells[a]["eff"][1][4])   # op 8 的值 bp+dice
        tests.append(("%s（抗打断 op8）" % rank, "Earth Shield 45525", v,
                      "%s；aura 149 抗打断 %d%% → %d%%（+%d）" % (hit, pushback, pushback + mod8, mod8)))
    # 古仪图腾三件套
    for a, eff, target, what in ((58241, 1, 45500, "图腾打击"),
                                 (58243, 0, 45504, "妖术"),
                                 (58242, 0, 45505, "野性之魂")):
        v, hit = verdict(a, eff, target)
        sp = spells[a]
        trig = sp["eff"][eff][6]
        tname = spells.get(trig, {}).get("name", "无")
        extra = {"图腾打击": "触发 %d（%s）= aura 12 击倒" % (trig, tname),
                 "妖术": "触发 %d（%s）= 效果 42 召唤" % (trig, tname),
                 "野性之魂": "触发 %d（%s）= DUMMY 空壳（内核无实现）" % (trig, tname)}[what]
        tests.append(("Ancient Rites %s" % a, "%s %d" % (what, target), v, "%s；%s" % (hit, extra)))
    # 猎人流血披风
    v, hit = verdict(52402, 0, 48049)
    tests.append(("Faster Bleeds 52402", "Lacerate 48049", v,
                  "%s；op19(DOT)/op1(DURATION) 各 %d%%" % (hit, simple_value(spells[52402]["eff"][0][3], spells[52402]["eff"][0][4]))))
    # 电气化（补了但不生效）
    v, hit = verdict(51888, 1, 8042)
    tests.append(("Shocks Electrify 51888", "Earth Shock 8042", v,
                  "%s；op=%d（CUSTOM_VALUE_2）—— 全源码没有消费者 → 数值上依旧不变"
                  % (hit, spells[51888]["eff"][1][5])))

    for a, b, c, d in tests:
        print("%-26s %-22s %-28s %s" % (a, b, c, d))

    # ---- ③ 宠物路径：受影响生物驯服后学到的技能 ----
    print()
    print("=" * 100)
    print("③ 宠物路径（ObjectMgr.cpp:4553「fill data from DBC as more correct source」+ 学习包装转换）")
    print("-" * 100)
    learn = {}
    for r in mysql(cmd, "SELECT entry, effectTriggerSpell1 FROM spell_template WHERE effect1=36 AND effectTriggerSpell1<>0"):
        learn[int(r[1])] = int(r[0])          # 技能 → 教它的那个「学习法术」
    rows = mysql(cmd, """SELECT c.entry, c.name, c.level_min, c.pet_spell_list_id,
                                 p.spell_id1, p.spell_id2, p.spell_id3, p.spell_id4
                          FROM creature_template c JOIN pet_spell_data p ON p.entry = c.pet_spell_list_id
                          WHERE c.pet_spell_list_id BETWEEN 9486 AND 9518 AND c.type = 1
                          ORDER BY c.level_min LIMIT 6""")
    print("%-7s %-26s %-5s %-8s %s" % ("生物", "名字", "等级", "宠物表", "驯服后学到的技能"))
    for r in rows:
        e, name, lvl, plist = r[0], r[1], r[2], r[3]
        got = []
        for sid in r[4:8]:
            if not sid or sid == "0":
                continue
            s = int(sid)
            got.append("%s(%d)%s" % (spells.get(s, {}).get("name", "?"), s,
                                     "→学习法术%d" % learn[s] if s in learn else ""))
        print("%-7s %-26s %-5s %-8s %s" % (e, name[:26], lvl, plist, " + ".join(got) or "（无）"))

    # ---- ④ 仍然不生效的（数据层就注定）----
    print()
    print("=" * 100)
    print("④ 复核「留白/无效」的那几条：不是没修，是数据或内核注定")
    print("-" * 100)
    for entry, eff, why in ((51888, 1, "op=CUSTOM_VALUE_2，内核无消费者"),
                            (51369, 0, "op=CUSTOM_VALUE_1，内核无消费者"),
                            (52603, 0, "靶子 Swift Aspects 19552 位图 = 0 → 任何掩码都选不中"),
                            (52690, 0, "靶子 Replenish Mana 5405 家族 GENERIC、位图 = 0"),
                            (45985, 0, "自身家族 GENERIC，靶子 Mongoose Bite 1495 家族 HUNTER → isAffectedOnSpell 第一步即 false")):
        sp = spells.get(entry)
        tgt = None
        if entry == 52603: tgt = 19552
        if entry == 52690: tgt = 5405
        if entry == 45985: tgt = 1495
        extra = ""
        if tgt and tgt in spells:
            extra = "（靶子 %s 家族 %d 位图 0x%X）" % (spells[tgt]["name"], spells[tgt]["family"], spells[tgt]["flags"])
        print("  #%-7d eff%d  %s%s" % (entry, eff, why, extra))


if __name__ == "__main__":
    main()
