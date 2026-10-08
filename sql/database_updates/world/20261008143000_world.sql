-- ==============================================
-- FILE: sound_entries_client_sync.sql
-- GENERATED: 20261008143000
-- ==============================================
-- 把 `sound_entries` 补齐到当前客户端 SoundEntries.dbc 的水平。
--
-- 这张表是客户端 DBC 的镜像（ObjectMgr::LoadSoundEntries 读的就是它，
-- 并据此校验 broadcast_text.sound_id / script_texts.sound）。服务端这套 DBC 数据
-- 比客户端旧：客户端 8803 条，表里只有 8559 条，差的 244 条全是 Turtle 后加的 60xxx
-- 音效（最高到 60769）。于是 broadcast_text 30237/30238 引用的 60443(Dukedread1)、
-- 60444(Dukedread2) 在启动时报 "has SoundId ... but sound does not exist"。
--
-- 名字取自客户端 `DBFilesClient/SoundEntries.dbc` 的 name 列（第 3 列）。
-- ON DUPLICATE KEY UPDATE 让这份更新可重复导入。

INSERT INTO `sound_entries` (`id`, `name`) VALUES
    (60423, 'radio_relay_2'), (60424, 'radio_static'), (60425, 'Zone-ThalassianHighElf'), (60427, 'Zone-ThalassianAutumn'), (60428, 'Zone-ThalassianRunestone'), (60430, 'Zone-ThalassianBloodElf'), (60431, 'Intro-ThalassianHighlands'), (60432, 'Zone-Blackstone'),
    (60433, 'Zone-Rustgate'), (60434, 'Intro-Blackstone'), (60435, 'Ambience-Blackstone'), (60436, 'Ambience-GrimBatol'), (60437, 'GrimBatol'), (60438, 'Intro-GrimBatol'), (60439, 'Intro-Karaoutland'), (60440, 'Karaoutland'),
    (60441, 'Daghelm1'), (60442, 'Daghelm2'), (60443, 'Dukedread1'), (60444, 'Dukedread2'), (60445, 'Harvesterboss1'), (60446, 'Harvesterboss2.mp3'), (60447, 'Ironmane1'), (60448, 'Ironmane2'),
    (60449, 'Jaredvoss1'), (60450, 'Jaredvoss2'), (60451, 'Wystan1'), (60452, 'Wystan2'), (60453, 'Zendara1'), (60454, 'Zendara2'), (60455, 'Earthshaker Slam'), (60456, 'SanvTasDal_Aggro'),
    (60457, 'SanvTasDal_Death'), (60458, 'SanvTasDal_Hatred'), (60459, 'Rupturan_Aggro'), (60460, 'Rupturan_Death'), (60461, 'Rupturan_Half'), (60462, 'Krull_CastSpell'), (60463, 'Krull_Half'), (60464, 'Krull_KillPlayer'),
    (60465, 'Krull_Aggro'), (60466, 'Krull_Death'), (60467, 'Anomalous_Death.mp3'), (60468, 'Anomalous_Half.mp3'), (60469, 'Anomalous_Aggro.mp3'), (60470, 'Zone-BalorDungeon'), (60471, 'Intro-BalorDungeon'), (60472, 'Zone-Northwind'),
    (60473, 'Intro-Northwind'), (60474, 'MephistrothAggro'), (60475, 'MephistrothAbility'), (60476, 'MephistrothDeath'), (60477, 'GnarlmoonAggro'), (60478, 'GnarlmoonHalf'), (60479, 'GnarlMoonChange'), (60480, 'GnarlmoonDeath'),
    (60481, 'IncantagosAggro'), (60482, 'IncantagosAbility'), (60483, 'IncantagosDeath'), (60484, 'Zone-Lapidis'), (60485, 'Zone-Gilijim'), (60486, 'Spirit Link Cast'), (60487, 'Enlighten Cast'), (60489, 'Eclipse Trigger'),
    (60490, 'Power Overwhelming Cast'), (60491, 'Endless Quiver Missile'), (60508, 'Zone-GrimReaches'), (60509, 'Intro-GrimReaches'), (60510, 'Zone-DragonmawRetreat'), (60511, 'Intro-Dragonmaw'), (60530, 'Lycan_aggro'), (60531, 'Lycan_Half'),
    (60532, 'Lycan_Death'), (60533, 'Lycan_transmute'), (60534, 'Lycan_doom'), (60535, 'Karanetherspace'), (60536, 'Kara40Walk'), (60537, 'Karazhan40Intro'), (60538, 'Karazhan40Chess'), (60539, 'Karazhan40Mephi'),
    (60540, 'Sargeras1'), (60541, 'Sargeras2'), (60542, 'Sargeras3'), (60543, 'Sargeras4'), (60544, 'Medivhalive1'), (60545, 'Medivhalive2'), (60546, 'Medivhalive3'), (60547, 'Medivhalive4'),
    (60548, 'LlaneWrynnline1'), (60549, 'LlaneWrynnline2'), (60550, 'LlaneWrynnline3'), (60551, 'LlaneWrynnline4'), (60552, 'LlaneWrynnline5'), (60553, 'LlaneWrynnline6'), (60554, 'EchoofKhadgarLine1'), (60555, 'EchoofKhadgarLine2'),
    (60556, 'EchoofKhadgarLine3'), (60557, 'EchoofKhadgarLine4'), (60558, 'EchoofAranLine2'), (60559, 'EchoofAranLine3'), (60560, 'EchoofAranLine4'), (60561, 'DysfunctionalCurator'), (60562, 'EchoofMedivhLine1'), (60563, 'EchoofMedivhLine2'),
    (60564, 'EchoofMedivhLine3'), (60565, 'EchoofMedivhLine4'), (60566, 'EchoofMedivhLine5'), (60567, 'EchoofMedivhLine6'), (60568, 'EchoofMedivhLine7'), (60569, 'AnduinLotharLine1'), (60570, 'AnduinLotharLine2'), (60571, 'AnduinLotharLine3'),
    (60572, 'AnduinLotharLine4'), (60573, 'AnduinLotharLine5'), (60574, 'Karazhan40Mephi2'), (60575, 'Chess1'), (60576, 'Chess2'), (60577, 'Chess3'), (60578, 'Chess4'), (60579, 'Chess5'),
    (60580, 'Chessintro'), (60581, 'DuckLoop'), (60582, 'DuckDeath'), (60585, 'Zone-DragonmawDanger'), (60604, 'Ighal_Death'), (60611, 'Korlag_Aggro'), (60612, 'Korlag_Half'), (60613, 'Korlag_Death'),
    (60614, 'Aggnash_Greeting'), (60624, 'Shadow Of Death'), (60625, 'Zone_Balor'), (60626, 'Zone-StormwroughtCastle'), (60627, 'Zone-StormwroughtDescent'), (60628, 'Intro-StormwroughtCastle'), (60629, 'IntroSunstriderCourt'), (60630, 'Zone-SunstriderCourt'),
    (60632, 'Vel_Half'), (60637, 'Earthquake'), (60638, 'Kill Command'), (60639, 'Master Strike'), (60642, 'Dentarg1'), (60643, 'Dentarg2'), (60644, 'Dentarg3'), (60645, 'Dentarg4'),
    (60646, 'Dentarg5'), (60647, 'Dentarg6'), (60648, 'Dentarg7'), (60649, 'Dentarg8'), (60650, 'Dentarg9'), (60651, 'Dentarg10'), (60652, 'Drakthul_Greeting'), (60653, 'Drakthul_Farewell'),
    (60654, 'Drakthul_Annoyed'), (60655, 'Killrog_Greeting'), (60656, 'Killrog_Farewell'), (60657, 'Killrog_Annoyed'), (60658, 'Amber_Greeting'), (60659, 'Amber_Farewell'), (60660, 'Amber_Annoyed'), (60661, 'Zone-Rugford'),
    (60662, 'Croak Cannon'), (60672, 'Rotag_summon'), (60682, 'Intro-WindhornCanyon'), (60683, 'Zone-WindhornCanyon'), (60684, 'Zone-WindhornCanyonEvil'), (60685, 'Zone-WindhornEntrance'), (60686, 'Ambience-TimbermawHold'), (60687, 'Zone-TimbermawHold'),
    (60688, 'Zone-TimbermawHoldEvil'), (60689, 'Zone-TimbermawHoldUrsol'), (60690, 'Intro-TimbermawHold'), (60691, 'BarberShop_Haicut1'), (60692, 'BarberShop_Haicut2'), (60693, 'BarberShop_Haicut3'), (60694, 'BarberShop_Haicut4'), (60695, 'BarberShop_Haicut5'),
    (60696, 'BarberShop_Haicut6'), (60697, 'BarberShop_Sit1'), (60698, 'BarberShop_Sit2'), (60699, 'BarberShop_Sit3'), (60700, 'Zone-Moonwhisper'), (60701, 'Zone-MoonwhisperTauren'), (60702, 'Zone-Tyrandas'), (60703, 'Intro-Moonwhisper'),
    (60704, 'Intro-FrostmaneHollow'), (60705, 'Zone-FrostmaneHollow'), (60712, 'Karrsh_Pull'), (60713, 'Karrsh_Playerkill'), (60714, 'Karrsh_Phasestart'), (60715, 'Karrsh_Phaseend'), (60716, 'Karrsh_Playerkill2'), (60717, 'Karrsh_10%'),
    (60718, 'Karrsh_Death'), (60719, 'Kronn_pull'), (60720, 'Kronn_50%'), (60721, 'Kronn_Death'), (60722, 'Kronn_Dream1'), (60723, 'Kronn_Dream2'), (60724, 'Selenaxx_Pull'), (60725, 'Selenaxx_50%'),
    (60726, 'Selenaxx_Death'), (60727, 'Rotgrowl_Aggro'), (60728, 'Rotgrowl_Kodiak'), (60729, 'Rotgrowl_Death'), (60730, 'Ormanos_Aggro'), (60731, 'Ormanos_Charge'), (60732, 'Ormanos_Death'), (60733, 'Ursol_Enter'),
    (60734, 'Ursol_Aggro'), (60735, 'Ursol_Summon'), (60736, 'Ursol_Playerkill'), (60737, 'Ursol_Phase2'), (60738, 'Ursol_Terror'), (60739, 'Ursol_Talk1'), (60740, 'Ursol_Talk2'), (60741, 'Ursol_Talk3'),
    (60742, 'Ursol_DEATH'), (60743, 'Ursoc_Talk1'), (60744, 'Ursoc_Talk2'), (60745, 'Ursoc_Talk3'), (60746, 'Perotharn_SPAWN'), (60747, 'Perotharn_spawn2'), (60748, 'Perotharn_Spawn3'), (60749, 'Perotharn_PLAYERKILL'),
    (60750, 'Perotharn_Miasma'), (60751, 'Perotharn_Phasestart'), (60752, 'Perotharn_PhaseEND'), (60753, 'Perotharn_DEATH'), (60754, 'Axelus_Aggro'), (60755, 'Axelus_Glaive'), (60756, 'Axelus_Chains'), (60757, 'Axelus_Banner'),
    (60758, 'Axelus_Death'), (60759, 'Ezzel_Aggro'), (60760, 'Ezzel_Playerkill'), (60761, 'Ezzel_Acid'), (60762, 'Ezzel_Rage'), (60763, 'Ezzel_Transmute'), (60764, 'Ezzel_Death'), (60765, 'Partath_Aggro'),
    (60766, 'Partath_Immune'), (60767, 'Partath_50%'), (60768, 'Partath_Death'), (60769, 'Partath_Leeching')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- ==============================================
-- FILE: broadcast_text_emote_fix.sql
-- GENERATED: 20261008143000
-- ==============================================
-- `broadcast_text` 92031（"I'm not crazy, I swear. These shells are worth a lot of money."）
-- 的 emote_id1 = 55 在客户端 Emotes.dbc 里不存在（该表 id 从 54 直接跳到 60，核心的
-- EMOTE_* 枚举也一样），1.12 官方数据也从不使用未定义的 emote——所以这是个笔误。
-- 内核加载时本来就把它当成 0（先报错再清零），因此写 0 不改变任何游戏内表现，只是不再报错。
-- 想让它有动作的话，把它换成 Emotes.dbc 里确实存在的 id（例如 5 = 感叹、20 = 恳求）。
UPDATE `broadcast_text` SET `emote_id1` = 0 WHERE `entry` = 92031 AND `emote_id1` = 55;
