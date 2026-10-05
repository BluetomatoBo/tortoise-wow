-- 术士恶魔名字音节中文化（pet_name_generation）
--
-- 为什么需要这个：术士恶魔的名字不走 creature_template，locales_* 改不到它。
--   SpellEffects.cpp:3097 召唤 SUMMON_PET → GeneratePetName() → SetName()
--   ObjectMgr.cpp:6226   name = 随机(half=0) + 随机(half=1) 两个音节拼接
--   Pet.cpp:2364         GetNameForLocaleIdx() 对玩家召唤宠直接返回 GetName()，
--                        不做 locale 查询
-- 该表只有 word/entry/half，没有 locale 列，所以只能把音节本身换成中文。
--
-- 译法：按音节音译（音译而非另造），保留名字的对应关系；
-- 撇号（如 Grak'）是原文的音节分隔符，中文直接连写。
-- 每组都按该恶魔的性格选字，并避免不同音节塌成同一个词。
--
-- 幂等，可重复执行。
--
-- 生效方式：重启 mangosd，或 .reload pet_name_generation。
-- **但 .reload 需要本分支同时包含 src/game/ObjectMgr.cpp 的清空修复**
--（ObjectMgr::LoadPetNames 原本只 push_back、不 clear，对比 LoadGossipMenu
-- 开头的 m_GossipMenusMap.clear()）。未打该补丁时重载会把中文追加到英文后面，
-- 于是新召唤的恶魔有一半仍是英文、甚至出现「沃尔bis」这类混拼。
-- 重启则按现在的中文表重新加载，干净正确。

SET NAMES utf8mb4;

-- ------------------------------------------------------------------------
-- Imp 小鬼（entry 416）
-- ------------------------------------------------------------------------
UPDATE `pet_name_generation` SET `word` = '阿巴' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Aba';  -- 首 Aba
UPDATE `pet_name_generation` SET `word` = '阿兹' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Az';  -- 首 Az
UPDATE `pet_name_generation` SET `word` = '贝尔' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Bel';  -- 首 Bel
UPDATE `pet_name_generation` SET `word` = '比兹' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Biz';  -- 首 Biz
UPDATE `pet_name_generation` SET `word` = '乔' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Cho';  -- 首 Cho
UPDATE `pet_name_generation` SET `word` = '达格' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Dag';  -- 首 Dag
UPDATE `pet_name_generation` SET `word` = '加克' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Gak';  -- 首 Gak
UPDATE `pet_name_generation` SET `word` = '加尔' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Gar';  -- 首 Gar
UPDATE `pet_name_generation` SET `word` = '格尔' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Gel';  -- 首 Gel
UPDATE `pet_name_generation` SET `word` = '戈' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Gho';  -- 首 Gho
UPDATE `pet_name_generation` SET `word` = '戈布' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Gob';  -- 首 Gob
UPDATE `pet_name_generation` SET `word` = '格拉' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Gra';  -- 首 Gra
UPDATE `pet_name_generation` SET `word` = '贾克' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Jak';  -- 首 Jak
UPDATE `pet_name_generation` SET `word` = '朱布' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Jub';  -- 首 Jub
UPDATE `pet_name_generation` SET `word` = '卡尔' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Kar';  -- 首 Kar
UPDATE `pet_name_generation` SET `word` = '库普' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Kup';  -- 首 Kup
UPDATE `pet_name_generation` SET `word` = '拉兹' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Laz';  -- 首 Laz
UPDATE `pet_name_generation` SET `word` = '纳尔' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Nal';  -- 首 Nal
UPDATE `pet_name_generation` SET `word` = '诺克' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Nok';  -- 首 Nok
UPDATE `pet_name_generation` SET `word` = '帕格' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Pag';  -- 首 Pag
UPDATE `pet_name_generation` SET `word` = '皮格' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Pig';  -- 首 Pig
UPDATE `pet_name_generation` SET `word` = '皮普' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Pip';  -- 首 Pip
UPDATE `pet_name_generation` SET `word` = '皮兹' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Piz';  -- 首 Piz
UPDATE `pet_name_generation` SET `word` = '库兹' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Quz';  -- 首 Quz
UPDATE `pet_name_generation` SET `word` = '鲁伊' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Rui';  -- 首 Rui
UPDATE `pet_name_generation` SET `word` = '鲁尔' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Rul';  -- 首 Rul
UPDATE `pet_name_generation` SET `word` = '鲁普' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Rup';  -- 首 Rup
UPDATE `pet_name_generation` SET `word` = '塔尔' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Tar';  -- 首 Tar
UPDATE `pet_name_generation` SET `word` = '沃尔' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Vol';  -- 首 Vol
UPDATE `pet_name_generation` SET `word` = '亚兹' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Yaz';  -- 首 Yaz
UPDATE `pet_name_generation` SET `word` = '泽普' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Zep';  -- 首 Zep
UPDATE `pet_name_generation` SET `word` = '齐格' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Zig';  -- 首 Zig
UPDATE `pet_name_generation` SET `word` = '齐尔' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Zil';  -- 首 Zil
UPDATE `pet_name_generation` SET `word` = '佐尔' WHERE `entry` = 416 AND `half` = 0 AND `word` = 'Zor';  -- 首 Zor
UPDATE `pet_name_generation` SET `word` = '比斯' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'bis';  -- 尾 bis
UPDATE `pet_name_generation` SET `word` = '菲普' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'fip';  -- 尾 fip
UPDATE `pet_name_generation` SET `word` = '古普' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'gup';  -- 尾 gup
UPDATE `pet_name_generation` SET `word` = '哈姆' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'ham';  -- 尾 ham
UPDATE `pet_name_generation` SET `word` = '朱布' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'jub';  -- 尾 jub
UPDATE `pet_name_generation` SET `word` = '金' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'kin';  -- 尾 kin
UPDATE `pet_name_generation` SET `word` = '科尔' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'kol';  -- 尾 kol
UPDATE `pet_name_generation` SET `word` = '洛普' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'lop';  -- 尾 lop
UPDATE `pet_name_generation` SET `word` = '洛兹' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'loz';  -- 尾 loz
UPDATE `pet_name_generation` SET `word` = '马特' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'mat';  -- 尾 mat
UPDATE `pet_name_generation` SET `word` = '米尔' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'mir';  -- 尾 mir
UPDATE `pet_name_generation` SET `word` = '纳姆' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'nam';  -- 尾 nam
UPDATE `pet_name_generation` SET `word` = '纳尔' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'nar';  -- 尾 nar
UPDATE `pet_name_generation` SET `word` = '尼克' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'nik';  -- 尾 nik
UPDATE `pet_name_generation` SET `word` = '尼普' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'nip';  -- 尾 nip
UPDATE `pet_name_generation` SET `word` = '帕德' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'pad';  -- 尾 pad
UPDATE `pet_name_generation` SET `word` = '佩普' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'pep';  -- 尾 pep
UPDATE `pet_name_generation` SET `word` = '皮特' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'pit';  -- 尾 pit
UPDATE `pet_name_generation` SET `word` = '夸' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'qua';  -- 尾 qua
UPDATE `pet_name_generation` SET `word` = '莱' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'rai';  -- 尾 rai
UPDATE `pet_name_generation` SET `word` = '林' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'rin';  -- 尾 rin
UPDATE `pet_name_generation` SET `word` = '罗特' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'rot';  -- 尾 rot
UPDATE `pet_name_generation` SET `word` = '泰' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'tai';  -- 尾 tai
UPDATE `pet_name_generation` SET `word` = '塔尔' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'tal';  -- 尾 tal
UPDATE `pet_name_generation` SET `word` = '提克' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'tik';  -- 尾 tik
UPDATE `pet_name_generation` SET `word` = '提普' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'tip';  -- 尾 tip
UPDATE `pet_name_generation` SET `word` = '托格' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'tog';  -- 尾 tog
UPDATE `pet_name_generation` SET `word` = '图克' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'tuk';  -- 尾 tuk
UPDATE `pet_name_generation` SET `word` = '乌里' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'uri';  -- 尾 uri
UPDATE `pet_name_generation` SET `word` = '亚尔' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'yal';  -- 尾 yal
UPDATE `pet_name_generation` SET `word` = '亚普' WHERE `entry` = 416 AND `half` = 1 AND `word` = 'yap';  -- 尾 yap
-- ------------------------------------------------------------------------
-- Felhunter 地狱犬（entry 417）
-- ------------------------------------------------------------------------
UPDATE `pet_name_generation` SET `word` = '比' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Bhee';  -- 首 Bhee
UPDATE `pet_name_generation` SET `word` = '布鲁' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Bruu';  -- 首 Bruu
UPDATE `pet_name_generation` SET `word` = '兹拉' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Czaa';  -- 首 Czaa
UPDATE `pet_name_generation` SET `word` = '德鲁' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Droo';  -- 首 Droo
UPDATE `pet_name_generation` SET `word` = '弗拉' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Flaa';  -- 首 Flaa
UPDATE `pet_name_generation` SET `word` = '祖' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Fzuu';  -- 首 Fzuu
UPDATE `pet_name_generation` SET `word` = '嘎' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Ghaa';  -- 首 Ghaa
UPDATE `pet_name_generation` SET `word` = '格利' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Gree';  -- 首 Gree
UPDATE `pet_name_generation` SET `word` = '格扎' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Gzaa';  -- 首 Gzaa
UPDATE `pet_name_generation` SET `word` = '哈' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Haa';  -- 首 Haa
UPDATE `pet_name_generation` SET `word` = '哈德' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Haad';  -- 首 Haad
UPDATE `pet_name_generation` SET `word` = '哈格' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Haag';  -- 首 Haag
UPDATE `pet_name_generation` SET `word` = '哈普' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Haap';  -- 首 Haap
UPDATE `pet_name_generation` SET `word` = '伽' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Jhaa';  -- 首 Jhaa
UPDATE `pet_name_generation` SET `word` = '朱' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Jhuu';  -- 首 Jhuu
UPDATE `pet_name_generation` SET `word` = '卡' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Khaa';  -- 首 Khaa
UPDATE `pet_name_generation` SET `word` = '基' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Khii';  -- 首 Khii
UPDATE `pet_name_generation` SET `word` = '库' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Khuu';  -- 首 Khuu
UPDATE `pet_name_generation` SET `word` = '克瑞' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Kree';  -- 首 Kree
UPDATE `pet_name_generation` SET `word` = '卢' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Luu';  -- 首 Luu
UPDATE `pet_name_generation` SET `word` = '玛' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Maa';  -- 首 Maa
UPDATE `pet_name_generation` SET `word` = '尼' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Nhee';  -- 首 Nhee
UPDATE `pet_name_generation` SET `word` = '普' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Phuu';  -- 首 Phuu
UPDATE `pet_name_generation` SET `word` = '普瑞' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Pryy';  -- 首 Pryy
UPDATE `pet_name_generation` SET `word` = '鲁' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Rhuu';  -- 首 Rhuu
UPDATE `pet_name_generation` SET `word` = '沙' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Shaa';  -- 首 Shaa
UPDATE `pet_name_generation` SET `word` = '斯洛' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Sloo';  -- 首 Sloo
UPDATE `pet_name_generation` SET `word` = '斯鲁' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Sruu';  -- 首 Sruu
UPDATE `pet_name_generation` SET `word` = '苏' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Thoo';  -- 首 Thoo
UPDATE `pet_name_generation` SET `word` = '特拉' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Traa';  -- 首 Traa
UPDATE `pet_name_generation` SET `word` = '瓦拉' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Wraa';  -- 首 Wraa
UPDATE `pet_name_generation` SET `word` = '扎' WHERE `entry` = 417 AND `half` = 0 AND `word` = 'Zhaa';  -- 首 Zhaa
UPDATE `pet_name_generation` SET `word` = '东' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'dhon';  -- 尾 dhon
UPDATE `pet_name_generation` SET `word` = '杜姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'dhum';  -- 尾 dhum
UPDATE `pet_name_generation` SET `word` = '敦' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'dhun';  -- 尾 dhun
UPDATE `pet_name_generation` SET `word` = '多姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'dom';  -- 尾 dom
UPDATE `pet_name_generation` SET `word` = '顿' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'don';  -- 尾 don
UPDATE `pet_name_generation` SET `word` = '德罗姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'drom';  -- 尾 drom
UPDATE `pet_name_generation` SET `word` = '迪姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'dym';  -- 尾 dym
UPDATE `pet_name_generation` SET `word` = '芬' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'fenn';  -- 尾 fenn
UPDATE `pet_name_generation` SET `word` = '弗姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'fum';  -- 尾 fum
UPDATE `pet_name_generation` SET `word` = '丰' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'fun';  -- 尾 fun
UPDATE `pet_name_generation` SET `word` = '贡' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'ghon';  -- 尾 ghon
UPDATE `pet_name_generation` SET `word` = '古恩' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'ghun';  -- 尾 ghun
UPDATE `pet_name_generation` SET `word` = '格罗姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'grom';  -- 尾 grom
UPDATE `pet_name_generation` SET `word` = '格瑞姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'grym';  -- 尾 grym
UPDATE `pet_name_generation` SET `word` = '霍姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'hom';  -- 尾 hom
UPDATE `pet_name_generation` SET `word` = '洪' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'hon';  -- 尾 hon
UPDATE `pet_name_generation` SET `word` = '胡恩' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'hun';  -- 尾 hun
UPDATE `pet_name_generation` SET `word` = '乔姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'jhom';  -- 尾 jhom
UPDATE `pet_name_generation` SET `word` = '昆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'kun';  -- 尾 kun
UPDATE `pet_name_generation` SET `word` = '鲁姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'lum';  -- 尾 lum
UPDATE `pet_name_generation` SET `word` = '蒙' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'mmon';  -- 尾 mmon
UPDATE `pet_name_generation` SET `word` = '蒙' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'mon';  -- 尾 mon
UPDATE `pet_name_generation` SET `word` = '敏' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'myn';  -- 尾 myn
UPDATE `pet_name_generation` SET `word` = '纳姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'nam';  -- 尾 nam
UPDATE `pet_name_generation` SET `word` = '内姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'nem';  -- 尾 nem
UPDATE `pet_name_generation` SET `word` = '尼姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'nhym';  -- 尾 nhym
UPDATE `pet_name_generation` SET `word` = '诺姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'nom';  -- 尾 nom
UPDATE `pet_name_generation` SET `word` = '努姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'num';  -- 尾 num
UPDATE `pet_name_generation` SET `word` = '福姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'phom';  -- 尾 phom
UPDATE `pet_name_generation` SET `word` = '隆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'roon';  -- 尾 roon
UPDATE `pet_name_generation` SET `word` = '瑞姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'rym';  -- 尾 rym
UPDATE `pet_name_generation` SET `word` = '尚' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'shon';  -- 尾 shon
UPDATE `pet_name_generation` SET `word` = '苏恩' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'thun';  -- 尾 thun
UPDATE `pet_name_generation` SET `word` = '托姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'tom';  -- 尾 tom
UPDATE `pet_name_generation` SET `word` = '泽姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'zhem';  -- 尾 zhem
UPDATE `pet_name_generation` SET `word` = '祖姆' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'zhum';  -- 尾 zhum
UPDATE `pet_name_generation` SET `word` = '尊' WHERE `entry` = 417 AND `half` = 1 AND `word` = 'zun';  -- 尾 zun
-- ------------------------------------------------------------------------
-- Voidwalker 虚空行者（entry 1860）
-- ------------------------------------------------------------------------
UPDATE `pet_name_generation` SET `word` = '巴尔' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Bar';  -- 首 Bar
UPDATE `pet_name_generation` SET `word` = '贝尔' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Bel';  -- 首 Bel
UPDATE `pet_name_generation` SET `word` = '查尔' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Char';  -- 首 Char
UPDATE `pet_name_generation` SET `word` = '格拉克' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Grak''';  -- 首 Grak'
UPDATE `pet_name_generation` SET `word` = '格拉兹' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Graz''';  -- 首 Graz'
UPDATE `pet_name_generation` SET `word` = '格里姆' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Grim';  -- 首 Grim
UPDATE `pet_name_generation` SET `word` = '哈斯' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Hath';  -- 首 Hath
UPDATE `pet_name_generation` SET `word` = '赫尔' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Hel';  -- 首 Hel
UPDATE `pet_name_generation` SET `word` = '霍克' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Hok';  -- 首 Hok
UPDATE `pet_name_generation` SET `word` = '胡克' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Huk';  -- 首 Huk
UPDATE `pet_name_generation` SET `word` = '贾兹' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Jhaz';  -- 首 Jhaz
UPDATE `pet_name_generation` SET `word` = '乔姆' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Jhom';  -- 首 Jhom
UPDATE `pet_name_generation` SET `word` = '朱克' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Juk''';  -- 首 Juk'
UPDATE `pet_name_generation` SET `word` = '卡尔' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Kal''';  -- 首 Kal'
UPDATE `pet_name_generation` SET `word` = '克拉' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Klath';  -- 首 Klath
UPDATE `pet_name_generation` SET `word` = '孔' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Kon';  -- 首 Kon
UPDATE `pet_name_generation` SET `word` = '克拉格' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Krag';  -- 首 Krag
UPDATE `pet_name_generation` SET `word` = '克拉克' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Krak';  -- 首 Krak
UPDATE `pet_name_generation` SET `word` = '马克' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Mak';  -- 首 Mak
UPDATE `pet_name_generation` SET `word` = '梅兹' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Mezz';  -- 首 Mezz
UPDATE `pet_name_generation` SET `word` = '奥姆' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Orm';  -- 首 Orm
UPDATE `pet_name_generation` SET `word` = '凡' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Phan';  -- 首 Phan
UPDATE `pet_name_generation` SET `word` = '萨尔' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Sar';  -- 首 Sar
UPDATE `pet_name_generation` SET `word` = '坦格' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Tang';  -- 首 Tang
UPDATE `pet_name_generation` SET `word` = '桑' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Than';  -- 首 Than
UPDATE `pet_name_generation` SET `word` = '索格' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Thog';  -- 首 Thog
UPDATE `pet_name_generation` SET `word` = '索克' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Thok';  -- 首 Thok
UPDATE `pet_name_generation` SET `word` = '苏尔' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Thul';  -- 首 Thul
UPDATE `pet_name_generation` SET `word` = '扎格' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Zag''';  -- 首 Zag'
UPDATE `pet_name_generation` SET `word` = '赞格' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Zang';  -- 首 Zang
UPDATE `pet_name_generation` SET `word` = '扎尔' WHERE `entry` = 1860 AND `half` = 0 AND `word` = 'Zhar''';  -- 首 Zhar'
UPDATE `pet_name_generation` SET `word` = '卡斯' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'kath';  -- 尾 kath
UPDATE `pet_name_generation` SET `word` = '多克' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'doc';  -- 尾 doc
UPDATE `pet_name_generation` SET `word` = '多克' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'dok';  -- 尾 dok
UPDATE `pet_name_generation` SET `word` = '加克' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'gak';  -- 尾 gak
UPDATE `pet_name_generation` SET `word` = '加斯' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'garth';  -- 尾 garth
UPDATE `pet_name_generation` SET `word` = '戈尔' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'gore';  -- 尾 gore
UPDATE `pet_name_generation` SET `word` = '戈格' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'gorg';  -- 尾 gorg
UPDATE `pet_name_generation` SET `word` = '格雷夫' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'grave';  -- 尾 grave
UPDATE `pet_name_generation` SET `word` = '格隆' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'gron';  -- 尾 gron
UPDATE `pet_name_generation` SET `word` = '朱克' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'juk';  -- 尾 juk
UPDATE `pet_name_generation` SET `word` = '克拉斯' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'krast';  -- 尾 krast
UPDATE `pet_name_generation` SET `word` = '克雷什' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'kresh';  -- 尾 kresh
UPDATE `pet_name_generation` SET `word` = '克里特' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'krit';  -- 尾 krit
UPDATE `pet_name_generation` SET `word` = '洛斯' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'los';  -- 尾 los
UPDATE `pet_name_generation` SET `word` = '蒙' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'mon';  -- 尾 mon
UPDATE `pet_name_generation` SET `word` = '莫斯' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'mos';  -- 尾 mos
UPDATE `pet_name_generation` SET `word` = '莫斯' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'moth';  -- 尾 moth
UPDATE `pet_name_generation` SET `word` = '纳格马' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'nagma';  -- 尾 nagma
UPDATE `pet_name_generation` SET `word` = '纳克' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'nak';  -- 尾 nak
UPDATE `pet_name_generation` SET `word` = '纳尔' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'nar';  -- 尾 nar
UPDATE `pet_name_generation` SET `word` = '诺斯' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'nos';  -- 尾 nos
UPDATE `pet_name_generation` SET `word` = '努兹' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'nuz';  -- 尾 nuz
UPDATE `pet_name_generation` SET `word` = '福格' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'phog';  -- 尾 phog
UPDATE `pet_name_generation` SET `word` = '拉斯' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'rath';  -- 尾 rath
UPDATE `pet_name_generation` SET `word` = '塔斯特' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'tast';  -- 尾 tast
UPDATE `pet_name_generation` SET `word` = '塔兹' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'taz';  -- 尾 taz
UPDATE `pet_name_generation` SET `word` = '萨克' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'thak';  -- 尾 thak
UPDATE `pet_name_generation` SET `word` = '桑格' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'thang';  -- 尾 thang
UPDATE `pet_name_generation` SET `word` = '西克' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'thyk';  -- 尾 thyk
UPDATE `pet_name_generation` SET `word` = '沃格' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'vhug';  -- 尾 vhug
UPDATE `pet_name_generation` SET `word` = '扎兹特' WHERE `entry` = 1860 AND `half` = 1 AND `word` = 'zazt';  -- 尾 zazt
-- ------------------------------------------------------------------------
-- Succubus 魅魔（entry 1863）
-- ------------------------------------------------------------------------
UPDATE `pet_name_generation` SET `word` = '艾尔' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Ael';  -- 首 Ael
UPDATE `pet_name_generation` SET `word` = '艾兹' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Aez';  -- 首 Aez
UPDATE `pet_name_generation` SET `word` = '安' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Ang';  -- 首 Ang
UPDATE `pet_name_generation` SET `word` = '班' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Ban';  -- 首 Ban
UPDATE `pet_name_generation` SET `word` = '贝特' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Bet';  -- 首 Bet
UPDATE `pet_name_generation` SET `word` = '布罗' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Bro';  -- 首 Bro
UPDATE `pet_name_generation` SET `word` = '布瑞' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Bry';  -- 首 Bry
UPDATE `pet_name_generation` SET `word` = '卡特' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Cat';  -- 首 Cat
UPDATE `pet_name_generation` SET `word` = '迪尔' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Dir';  -- 首 Dir
UPDATE `pet_name_generation` SET `word` = '迪丝' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Dis';  -- 首 Dis
UPDATE `pet_name_generation` SET `word` = '多姆' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Dom';  -- 首 Dom
UPDATE `pet_name_generation` SET `word` = '德鲁丝' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Drus';  -- 首 Drus
UPDATE `pet_name_generation` SET `word` = '菲' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Fie';  -- 首 Fie
UPDATE `pet_name_generation` SET `word` = '菲儿' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Fier';  -- 首 Fier
UPDATE `pet_name_generation` SET `word` = '格莉' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Gly';  -- 首 Gly
UPDATE `pet_name_generation` SET `word` = '赫尔' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Hel';  -- 首 Hel
UPDATE `pet_name_generation` SET `word` = '赫丝' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Hes';  -- 首 Hes
UPDATE `pet_name_generation` SET `word` = '卡尔' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Kal';  -- 首 Kal
UPDATE `pet_name_generation` SET `word` = '琳' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Lyn';  -- 首 Lyn
UPDATE `pet_name_generation` SET `word` = '米尔' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Mir';  -- 首 Mir
UPDATE `pet_name_generation` SET `word` = '妮姆' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Nim';  -- 首 Nim
UPDATE `pet_name_generation` SET `word` = '萨尔' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Sar';  -- 首 Sar
UPDATE `pet_name_generation` SET `word` = '赛尔' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Sel';  -- 首 Sel
UPDATE `pet_name_generation` SET `word` = '薇尔' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Vil';  -- 首 Vil
UPDATE `pet_name_generation` SET `word` = '扎' WHERE `entry` = 1863 AND `half` = 0 AND `word` = 'Zah';  -- 首 Zah
UPDATE `pet_name_generation` SET `word` = '艾丝' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'aith';  -- 尾 aith
UPDATE `pet_name_generation` SET `word` = '安达' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'anda';  -- 尾 anda
UPDATE `pet_name_generation` SET `word` = '安蒂娅' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'antia';  -- 尾 antia
UPDATE `pet_name_generation` SET `word` = '艾薇' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'evere';  -- 尾 evere
UPDATE `pet_name_generation` SET `word` = '莉娅' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'lia';  -- 尾 lia
UPDATE `pet_name_generation` SET `word` = '莉莎' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'lissa';  -- 尾 lissa
UPDATE `pet_name_generation` SET `word` = '妮瑞' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'neri';  -- 尾 neri
UPDATE `pet_name_generation` SET `word` = '妮丝' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'neth';  -- 尾 neth
UPDATE `pet_name_generation` SET `word` = '妮娅' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'nia';  -- 尾 nia
UPDATE `pet_name_generation` SET `word` = '恩莉莎' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'nlissa';  -- 尾 nlissa
UPDATE `pet_name_generation` SET `word` = '诺拉' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'nora';  -- 尾 nora
UPDATE `pet_name_generation` SET `word` = '恩薇' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'nva';  -- 尾 nva
UPDATE `pet_name_generation` SET `word` = '妮丝' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'nys';  -- 尾 nys
UPDATE `pet_name_generation` SET `word` = '奥拉' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'ola';  -- 尾 ola
UPDATE `pet_name_generation` SET `word` = '奥娜' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'ona';  -- 尾 ona
UPDATE `pet_name_generation` SET `word` = '奥拉' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'ora';  -- 尾 ora
UPDATE `pet_name_generation` SET `word` = '拉' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'rah';  -- 尾 rah
UPDATE `pet_name_generation` SET `word` = '瑞安娜' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'riana';  -- 尾 riana
UPDATE `pet_name_generation` SET `word` = '瑞尔' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'riel';  -- 尾 riel
UPDATE `pet_name_generation` SET `word` = '罗娜' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'rona';  -- 尾 rona
UPDATE `pet_name_generation` SET `word` = '泰' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'tai';  -- 尾 tai
UPDATE `pet_name_generation` SET `word` = '泰薇' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'tevere';  -- 尾 tevere
UPDATE `pet_name_generation` SET `word` = '西娅' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'thea';  -- 尾 thea
UPDATE `pet_name_generation` SET `word` = '薇娜' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'vina';  -- 尾 vina
UPDATE `pet_name_generation` SET `word` = '薇娜' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'wena';  -- 尾 wena
UPDATE `pet_name_generation` SET `word` = '薇恩' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'wyn';  -- 尾 wyn
UPDATE `pet_name_generation` SET `word` = '希娅' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'xia';  -- 尾 xia
UPDATE `pet_name_generation` SET `word` = '伊拉' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'yla';  -- 尾 yla
UPDATE `pet_name_generation` SET `word` = '伊莎' WHERE `entry` = 1863 AND `half` = 1 AND `word` = 'yssa';  -- 尾 yssa
-- ------------------------------------------------------------------------
-- Felguard 恶魔卫士（entry 17252）
-- ------------------------------------------------------------------------
UPDATE `pet_name_generation` SET `word` = '弗拉' WHERE `entry` = 17252 AND `half` = 0 AND `word` = 'Flaa';  -- 首 Flaa
UPDATE `pet_name_generation` SET `word` = '哈' WHERE `entry` = 17252 AND `half` = 0 AND `word` = 'Haa';  -- 首 Haa
UPDATE `pet_name_generation` SET `word` = '朱' WHERE `entry` = 17252 AND `half` = 0 AND `word` = 'Jhuu';  -- 首 Jhuu
UPDATE `pet_name_generation` SET `word` = '沙' WHERE `entry` = 17252 AND `half` = 0 AND `word` = 'Shaa';  -- 首 Shaa
UPDATE `pet_name_generation` SET `word` = '苏' WHERE `entry` = 17252 AND `half` = 0 AND `word` = 'Thoo';  -- 首 Thoo
UPDATE `pet_name_generation` SET `word` = '敦' WHERE `entry` = 17252 AND `half` = 1 AND `word` = 'dhun';  -- 尾 dhun
UPDATE `pet_name_generation` SET `word` = '古恩' WHERE `entry` = 17252 AND `half` = 1 AND `word` = 'ghun';  -- 尾 ghun
UPDATE `pet_name_generation` SET `word` = '隆' WHERE `entry` = 17252 AND `half` = 1 AND `word` = 'roon';  -- 尾 roon
UPDATE `pet_name_generation` SET `word` = '苏恩' WHERE `entry` = 17252 AND `half` = 1 AND `word` = 'thun';  -- 尾 thun
UPDATE `pet_name_generation` SET `word` = '托姆' WHERE `entry` = 17252 AND `half` = 1 AND `word` = 'tom';  -- 尾 tom

