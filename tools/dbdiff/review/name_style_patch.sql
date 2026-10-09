-- 自定义 NPC 人名重译（2026-10-09，51 条）——按审阅表统一为「名·意译姓」风格
SET NAMES utf8mb4;

UPDATE `locales_creature` SET `name_loc4` = '游侠菲亚琳娜·迅步' WHERE `entry` = 62734 AND `name_loc4` = '游侠夫埃利娜斯维夫特斯特尔伊德';  -- Ranger Faellina Swiftstride
UPDATE `locales_creature` SET `name_loc4` = '姆乌尔夫·夜角' WHERE `entry` = 62976 AND `name_loc4` = '姆乌尔夫尼格索恩';  -- Mhulf Nighthorn
UPDATE `locales_quest` SET `Details_loc4` = REPLACE(`Details_loc4`, '姆乌尔夫尼格索恩', '姆乌尔夫·夜角') WHERE `Details_loc4` LIKE '%姆乌尔夫尼格索恩%';
UPDATE `locales_quest` SET `Objectives_loc4` = REPLACE(`Objectives_loc4`, '姆乌尔夫尼格索恩', '姆乌尔夫·夜角') WHERE `Objectives_loc4` LIKE '%姆乌尔夫尼格索恩%';
UPDATE `locales_creature` SET `name_loc4` = '地方法官胡尔达姆·硬手' WHERE `entry` = 62395 AND `name_loc4` = '地方法官胡尔达姆特奥哈恩德';  -- Magistrate Hurdam Toughhand
UPDATE `locales_creature` SET `name_loc4` = '泰尔德拉斯·踏海' WHERE `entry` = 62097 AND `name_loc4` = '特埃尔德拉斯伊斯特尔伊德尔';  -- Taeldras Seastrider
UPDATE `locales_creature` SET `name_loc4` = '大长老斯凯·踏云' WHERE `entry` = 62837 AND `name_loc4` = '豪华长者斯克伊斯特尔伊德尔';  -- Grand Elder Skystrider
UPDATE `locales_creature` SET `name_loc4` = '凡兹·星泉' WHERE `entry` = 61913 AND `name_loc4` = '凡兹斯帕尔克斯普尔伊恩格';  -- Fanzy Sparkspring
UPDATE `locales_creature` SET `name_loc4` = '克兰戈什·雷风' WHERE `entry` = 62415 AND `name_loc4` = '克拉恩戈什苏恩德尔维恩德';  -- Krangosh Thunderwind
UPDATE `locales_creature` SET `name_loc4` = '凡多尔·劲风之回响' WHERE `entry` = 62599 AND `name_loc4` = '之回响凡多尔布拉塞维恩德';  -- Echo of Vandol Bracewind
UPDATE `locales_creature` SET `name_loc4` = '托尔瓦格·雷手' WHERE `entry` = 61911 AND `name_loc4` = '托尔瓦格苏恩德尔哈恩德';  -- Torvag Thunderhand
UPDATE `locales_creature` SET `name_loc4` = '莱索尔·晨叶' WHERE `entry` = 62088 AND `name_loc4` = '尔艾索尔莫尔宁格尔伊夫';  -- Laithor Morningleaf
UPDATE `locales_creature` SET `name_loc4` = '佩妮·素钢' WHERE `entry` = 62519 AND `name_loc4` = '佩恩伊普尔艾恩斯特伊尔';  -- Penny Plainsteel
UPDATE `locales_creature` SET `name_loc4` = '泽格·闪爆' WHERE `entry` = 63060 AND `name_loc4` = '泽格斯帕尔克莱布拉斯特';  -- Zegh Sparkleblast
UPDATE `locales_creature` SET `name_loc4` = '拉奈留斯·纯心' WHERE `entry` = 61916 AND `name_loc4` = '拉内尔尤斯普瑞伊尔特';  -- Ranellius Pureheart
UPDATE `locales_creature` SET `name_loc4` = '赛尔多·晨星' WHERE `entry` = 62083 AND `name_loc4` = '斯埃尔多尔达斯帕尔克';  -- Saeldor Dawnspark
UPDATE `locales_creature` SET `name_loc4` = '梅尔多·迅矛' WHERE `entry` = 62086 AND `name_loc4` = '梅尔多尔斯维夫特兰塞';  -- Meldor Swiftlance
UPDATE `locales_creature` SET `name_loc4` = '巴韦格·磁石' WHERE `entry` = 62410 AND `name_loc4` = '巴尔韦格尔奥德斯托内';  -- Barwegg Loadstone
UPDATE `locales_creature` SET `name_loc4` = '安东纳斯·裂视' WHERE `entry` = 62634 AND `name_loc4` = '阿恩托纳斯瑞夫特加泽';  -- Antonas Riftgaze
UPDATE `locales_creature` SET `name_loc4` = '德雷萨尼斯·哀影' WHERE `entry` = 62718 AND `name_loc4` = '德雷萨尼斯姆奥恩沙德';  -- Drethanis Mournshade
UPDATE `locales_creature` SET `name_loc4` = '格鲁尔·曲木' WHERE `entry` = 63027 AND `name_loc4` = '格尔乌尔特尔伊本德尔';  -- Grool Treebender
UPDATE `locales_creature` SET `name_loc4` = '内瑞安·鹿木' WHERE `entry` = 63072 AND `name_loc4` = '内尔伊恩斯塔格特尔伊';  -- Nerean Stagtree
UPDATE `locales_creature` SET `name_loc4` = '埃泽尔·暗酿' WHERE `entry` = 65148 AND `name_loc4` = '埃泽尔达尔克布雷韦尔';  -- Ezzel Darkbrewer
UPDATE `locales_creature` SET `name_loc4` = '阿科格·牙血' WHERE `entry` = 91021 AND `name_loc4` = '阿科格图斯克布尔乌德';  -- Akogg Tuskblood
UPDATE `locales_creature` SET `name_loc4` = '格尔潘·火花' WHERE `entry` = 61925 AND `name_loc4` = '格尔潘瑞兹斯帕尔克';  -- Gelpan Rizspark
UPDATE `locales_creature` SET `name_loc4` = '瑟萨莉娅·晨星' WHERE `entry` = 62084 AND `name_loc4` = '瑟萨莉娅达斯帕尔克';  -- Thessalia Dawnspark
UPDATE `locales_creature` SET `name_loc4` = '希尔加·雪酿' WHERE `entry` = 62407 AND `name_loc4` = '希尔加斯诺瓦布雷瓦';  -- Hilga Snowbrew
UPDATE `locales_creature` SET `name_loc4` = '拉格丹·锤炉' WHERE `entry` = 62420 AND `name_loc4` = '拉格丹哈梅尔伊尔斯';  -- Ragdan Hammerhearth
UPDATE `locales_creature` SET `name_loc4` = '工程师煤须' WHERE `entry` = 62756 AND `name_loc4` = '工程师斯乌特比尔德';  -- Engineer Sootbeard
UPDATE `locales_creature` SET `name_loc4` = '预言者风暴蹄' WHERE `entry` = 62781 AND `name_loc4` = '预言者斯托尔姆乌夫';  -- Prophet Stormhoof
UPDATE `locales_creature` SET `name_loc4` = '扎拉扎尔·贤风' WHERE `entry` = 62902 AND `name_loc4` = '扎拉扎尔萨格维恩德';  -- Zarazar Sagewind
UPDATE `locales_creature` SET `name_loc4` = '乌尔夫·石图腾' WHERE `entry` = 63056 AND `name_loc4` = '乌尔夫斯托内托泰姆';  -- Ulf Stonetotem
UPDATE `locales_creature` SET `name_loc4` = '萨泽克莱·噬矢' WHERE `entry` = 90150 AND `name_loc4` = '萨泽克莱博尔特比泰';  -- Saxekle Boltbite
UPDATE `locales_creature` SET `name_loc4` = '姆埃瓦·托格维' WHERE `entry` = 61912 AND `name_loc4` = '姆埃瓦托格夫伊瓦';  -- Mayva Togview
UPDATE `locales_creature` SET `name_loc4` = '菲登特·苔怒' WHERE `entry` = 62464 AND `name_loc4` = '菲德恩特莫斯拉格';  -- Fydent Mossrage
UPDATE `locales_creature` SET `name_loc4` = '奥罗诺克·裂心' WHERE `entry` = 62548 AND `name_loc4` = '奥罗诺克托伊尔特';  -- Oronok Torn-Heart
UPDATE `locales_creature` SET `name_loc4` = '老加泽诺' WHERE `entry` = 62080 AND `name_loc4` = '奥尔苏迪加泽诺';  -- Ol' Gazeno
UPDATE `locales_creature` SET `name_loc4` = '奥尔米尔·半角' WHERE `entry` = 62470 AND `name_loc4` = '奥尔米尔哈霍恩';  -- Olmir Halfhorn
UPDATE `locales_creature` SET `name_loc4` = '沙尼·丝蹄' WHERE `entry` = 62978 AND `name_loc4` = '沙尼西尔克乌夫';  -- Shanni Silkhoof
UPDATE `locales_creature` SET `name_loc4` = '伐木工鲁兹·螺栓' WHERE `entry` = 91219 AND `name_loc4` = '伐木工鲁兹波特';  -- Lumberworker Ruzbolt
UPDATE `locales_creature` SET `name_loc4` = '卡利娜·高翼' WHERE `entry` = 62095 AND `name_loc4` = '卡利娜希格维';  -- Calina Highwing
UPDATE `locales_creature` SET `name_loc4` = '拉娜·远行者' WHERE `entry` = 61654 AND `name_loc4` = '长途行者拉娜';  -- Rahna Longstrider
UPDATE `locales_creature` SET `name_loc4` = '伊瑞娅·唤晨' WHERE `entry` = 62904 AND `name_loc4` = '伊尔伊唤晓者';  -- Irea Dawncaller
UPDATE `locales_creature` SET `name_loc4` = '失落者捕猎者' WHERE `entry` = 62929 AND `name_loc4` = '坠落者捕猎者';  -- Fallen One Stalker
UPDATE `locales_creature` SET `name_loc4` = '先知格里姆·灰眼' WHERE `entry` = 70027 AND `name_loc4` = '先知格里姆艾';  -- Farseer Grimeye
UPDATE `locales_creature` SET `name_loc4` = '恶鳍招潮者' WHERE `entry` = 61085 AND `name_loc4` = '恶鳍唤嘲鱼人';  -- Spitefin Tidecaller
UPDATE `locales_creature` SET `name_loc4` = '阿拉萨拉斯研究员' WHERE `entry` = 61885 AND `name_loc4` = '阿尔萨拉斯研究员';  -- Alah'Thalas Researcher
UPDATE `locales_creature` SET `name_loc4` = '斯隆达' WHERE `entry` = 62291 AND `name_loc4` = '斯尔奥恩达';  -- Thronda
UPDATE `locales_quest` SET `OfferRewardText_loc4` = REPLACE(`OfferRewardText_loc4`, '斯尔奥恩达', '斯隆达') WHERE `OfferRewardText_loc4` LIKE '%斯尔奥恩达%';
UPDATE `locales_creature` SET `name_loc4` = '戈德纳克' WHERE `entry` = 63095 AND `name_loc4` = '戈尔德娜克';  -- Gordnak
UPDATE `locales_quest` SET `OfferRewardText_loc4` = REPLACE(`OfferRewardText_loc4`, '戈尔德娜克', '戈德纳克') WHERE `OfferRewardText_loc4` LIKE '%戈尔德娜克%';
UPDATE `locales_creature` SET `name_loc4` = '安达尼尔·逐日' WHERE `entry` = 63119 AND `name_loc4` = '阿恩达尼尔逐日者';  -- Andanil Sunsworn
UPDATE `locales_creature` SET `name_loc4` = '赛瑞斯塔兹' WHERE `entry` = 62072 AND `name_loc4` = '斯伊瑞斯特尔阿斯兹';  -- Searistrasz
UPDATE `locales_quest` SET `OfferRewardText_loc4` = REPLACE(`OfferRewardText_loc4`, '斯伊瑞斯特尔阿斯兹', '赛瑞斯塔兹') WHERE `OfferRewardText_loc4` LIKE '%斯伊瑞斯特尔阿斯兹%';
UPDATE `locales_creature` SET `name_loc4` = '里基·费兹' WHERE `entry` = 62520 AND `name_loc4` = '瑞克基菲兹马斯克';  -- Rikki Fizmask
UPDATE `locales_creature` SET `name_loc4` = '尤妮·快手' WHERE `entry` = 62521 AND `name_loc4` = '阿恩伊快手';  -- Yunie Quicktrigger
