-- 职业/头衔副名统一（locales_creature.subname_loc4 / 物品·物件个别条目）
--
-- 背景：同一英文副名在库里有两种以上中文写法——多数派是原版官方译法，少数派是自定义内容
-- 的机翻（例：Expert Blacksmith 既有「中级铁匠」也有「锻造训练师」「初级铁匠」）。
-- 本文件把少数派收敛到多数派，**逐条限定 entry**，不会误伤同名的其他副名。
--
-- 口径与全量清单：tools/dbdiff/review/subname_unify_review.md（76 组 / 142 行）
-- 生效：mangosd 控制台 `.reload locales_creature`（物品/物件另需 `.reload locales_item` / `locales_gameobject`）

SET NAMES utf8mb4;

UPDATE `locales_creature` SET `subname_loc4` = '商人' WHERE `entry` IN (60771) AND `subname_loc4` = '贸易供应商';  -- Trade Supplies
UPDATE `locales_creature` SET `subname_loc4` = '商人' WHERE `entry` IN (60965,61002,61107,61141,61148,61372,61444,61524,61721,91882,92020,92195) AND `subname_loc4` = '商品供应商';  -- Trade Supplies
UPDATE `locales_creature` SET `subname_loc4` = '杂货供应商' WHERE `entry` IN (92169,92177) AND `subname_loc4` = '杂货商人';  -- General Supplies
UPDATE `locales_creature` SET `subname_loc4` = '护甲商' WHERE `entry` IN (50539) AND `subname_loc4` = '盔甲师';  -- Armorer
UPDATE `locales_creature` SET `subname_loc4` = '调酒师' WHERE `entry` IN (52032,60458) AND `subname_loc4` = '酒保';  -- Bartender
UPDATE `locales_creature` SET `subname_loc4` = '女服务生' WHERE `entry` IN (81027) AND `subname_loc4` = '女侍者';  -- Waitress
UPDATE `locales_creature` SET `subname_loc4` = '造箭师' WHERE `entry` IN (91246) AND `subname_loc4` = '造剪师';  -- Fletcher
UPDATE `locales_creature` SET `subname_loc4` = '皮甲商' WHERE `entry` IN (91982,92202) AND `subname_loc4` = '皮甲商人';  -- Leather Armor Merchant
UPDATE `locales_creature` SET `subname_loc4` = '图书管理员' WHERE `entry` IN (80966) AND `subname_loc4` = '图书馆员';  -- Librarian
UPDATE `locales_creature` SET `subname_loc4` = '武器商' WHERE `entry` IN (15315) AND `subname_loc4` = '武器商人';  -- Weapon Merchant
UPDATE `locales_creature` SET `subname_loc4` = '食物和饮料' WHERE `entry` IN (3961,4181,4191,6091) AND `subname_loc4` = '食物和饮料商人';  -- Food & Drink Vendor
UPDATE `locales_creature` SET `subname_loc4` = '食物和饮料' WHERE `entry` IN (61808) AND `subname_loc4` = '食物和饮料供应商';  -- Food & Drink Vendor
UPDATE `locales_creature` SET `subname_loc4` = '魔法货物商人' WHERE `entry` IN (1257) AND `subname_loc4` = '炼金术和材料供应商';  -- Arcane Goods Vendor
UPDATE `locales_creature` SET `subname_loc4` = '商人' WHERE `entry` IN (61273) AND `subname_loc4` = '商品供应商';  -- Trade Goods
UPDATE `locales_creature` SET `subname_loc4` = '初级裁缝' WHERE `entry` IN (1103) AND `subname_loc4` = '裁缝训练师';  -- Journeyman Tailor
UPDATE `locales_creature` SET `subname_loc4` = '血色十字军使者' WHERE `entry` IN (61387) AND `subname_loc4` = '血色十字军大使';  -- Scarlet Crusade Emissary
UPDATE `locales_creature` SET `subname_loc4` = '施法材料商' WHERE `entry` IN (1275,1308,1463,1673,3562,5110,5151,62095,63023) AND `subname_loc4` = '材料商';  -- Reagent Vendor
UPDATE `locales_creature` SET `subname_loc4` = '商人' WHERE `entry` IN (52128) AND `subname_loc4` = '杂货供应商';  -- Trade Supplier
UPDATE `locales_creature` SET `subname_loc4` = '锁甲商' WHERE `entry` IN (51689) AND `subname_loc4` = '链甲商人';  -- Mail Armor Merchant
UPDATE `locales_creature` SET `subname_loc4` = '锁甲商' WHERE `entry` IN (80110) AND `subname_loc4` = '风险投资公司锁甲商人';  -- Mail Armor Merchant
UPDATE `locales_creature` SET `subname_loc4` = '锁甲商' WHERE `entry` IN (80222) AND `subname_loc4` = '锁甲商人';  -- Mail Armor Merchant
UPDATE `locales_creature` SET `subname_loc4` = '中级附魔师' WHERE `entry` IN (1317,5157,62290) AND `subname_loc4` = '附魔训练师';  -- Expert Enchanter
UPDATE `locales_creature` SET `subname_loc4` = '毒药商' WHERE `entry` IN (61877) AND `subname_loc4` = '可疑交易商';  -- Shady Dealer
UPDATE `locales_creature` SET `subname_loc4` = '招待员' WHERE `entry` IN (91888) AND `subname_loc4` = '酒吧女招待';  -- Barmaid
UPDATE `locales_creature` SET `subname_loc4` = '鞋匠' WHERE `entry` IN (1339) AND `subname_loc4` = '皮匠';  -- Cobbler
UPDATE `locales_creature` SET `subname_loc4` = '裁缝训练师' WHERE `entry` IN (4576) AND `subname_loc4` = '高级裁缝';  -- Artisan Tailor
UPDATE `locales_creature` SET `subname_loc4` = '烹饪训练师' WHERE `entry` IN (80101) AND `subname_loc4` = '风险投资公司员工';  -- Cooking Trainer
UPDATE `locales_creature` SET `subname_loc4` = '中级铁匠' WHERE `entry` IN (3136,5511) AND `subname_loc4` = '锻造训练师';  -- Expert Blacksmith
UPDATE `locales_creature` SET `subname_loc4` = '中级铁匠' WHERE `entry` IN (10276) AND `subname_loc4` = '初级铁匠';  -- Expert Blacksmith
UPDATE `locales_creature` SET `subname_loc4` = '中级制皮师' WHERE `entry` IN (3967,5127,5564) AND `subname_loc4` = '制皮训练师';  -- Expert Leatherworker
UPDATE `locales_creature` SET `subname_loc4` = '采药人' WHERE `entry` IN (61842) AND `subname_loc4` = '草药师';  -- Herbalist
UPDATE `locales_creature` SET `subname_loc4` = '皇家药剂师学会' WHERE `entry` IN (61167) AND `subname_loc4` = '皇家药剂师协会';  -- Royal Apothecary Society
UPDATE `locales_creature` SET `subname_loc4` = '渔夫' WHERE `entry` IN (1651,2367,3607,62859) AND `subname_loc4` = '钓鱼训练师';  -- Fisherman
UPDATE `locales_creature` SET `subname_loc4` = '工程学训练师' WHERE `entry` IN (3412,11031) AND `subname_loc4` = '中级工程技师';  -- Expert Engineer
UPDATE `locales_creature` SET `subname_loc4` = '工程学训练师' WHERE `entry` IN (11029) AND `subname_loc4` = '初级技师';  -- Expert Engineer
UPDATE `locales_creature` SET `subname_loc4` = '渔具供应商' WHERE `entry` IN (51654) AND `subname_loc4` = '钓鱼供应商';  -- Fishing Supplies
UPDATE `locales_creature` SET `subname_loc4` = '工程学供应商' WHERE `entry` IN (61108) AND `subname_loc4` = '工程供应商';  -- Engineering Supplies
UPDATE `locales_creature` SET `subname_loc4` = '初级工程技师' WHERE `entry` IN (11037) AND `subname_loc4` = '中级工程技师';  -- Journeyman Engineer
UPDATE `locales_creature` SET `subname_loc4` = '初级工程技师' WHERE `entry` IN (61738) AND `subname_loc4` = '初级工程师';  -- Journeyman Engineer
UPDATE `locales_creature` SET `subname_loc4` = '暴风城国王' WHERE `entry` IN (65133) AND `subname_loc4` = '风暴城国王';  -- King of Stormwind
UPDATE `locales_creature` SET `subname_loc4` = '杂货商' WHERE `entry` IN (60790,60966,60989,61058,61140) AND `subname_loc4` = '杂货店';  -- General Goods
UPDATE `locales_creature` SET `subname_loc4` = '见习造甲师' WHERE `entry` IN (2135) AND `subname_loc4` = '学徒铁匠';  -- Apprentice Armorer
UPDATE `locales_creature` SET `subname_loc4` = '战歌峡谷军官' WHERE `entry` IN (2804,3890,10360) AND `subname_loc4` = '战歌峡谷指挥官';  -- Warsong Gulch Battlemaster
UPDATE `locales_creature` SET `subname_loc4` = '食物和饮料' WHERE `entry` IN (7485,7941,8143,8150,8152) AND `subname_loc4` = '食物和饮料商人';  -- Food & Drink
UPDATE `locales_creature` SET `subname_loc4` = '中级炼金师' WHERE `entry` IN (4900,5177,5499) AND `subname_loc4` = '炼金术训练师';  -- Expert Alchemist
UPDATE `locales_creature` SET `subname_loc4` = '中级炼金师' WHERE `entry` IN (11042) AND `subname_loc4` = '初级炼金师';  -- Expert Alchemist
UPDATE `locales_creature` SET `subname_loc4` = '大师级裁缝' WHERE `entry` IN (11052) AND `subname_loc4` = '裁缝训练师';  -- Master Tailor
UPDATE `locales_creature` SET `subname_loc4` = '军队领袖' WHERE `entry` IN (91789) AND `subname_loc4` = '战队领主';  -- Warband Leader
UPDATE `locales_creature` SET `subname_loc4` = '中级裁缝' WHERE `entry` IN (5153) AND `subname_loc4` = '裁缝训练师';  -- Expert Tailor
UPDATE `locales_creature` SET `subname_loc4` = '中级裁缝' WHERE `entry` IN (5567) AND `subname_loc4` = '初级裁缝';  -- Expert Tailor
UPDATE `locales_creature` SET `subname_loc4` = '食物和饮料' WHERE `entry` IN (2832,4255,10367,12794,62033,62158) AND `subname_loc4` = '餐饮供应商';  -- Food and Drink
UPDATE `locales_creature` SET `subname_loc4` = '食物和饮料' WHERE `entry` IN (12785) AND `subname_loc4` = '护甲军需官';  -- Food and Drink
UPDATE `locales_creature` SET `subname_loc4` = '水果商' WHERE `entry` IN (61508,80460) AND `subname_loc4` = '水果商人';  -- Fruit Vendor
UPDATE `locales_creature` SET `subname_loc4` = '枪械商人' WHERE `entry` IN (5123,92217) AND `subname_loc4` = '枪械商';  -- Gun Merchant
UPDATE `locales_creature` SET `subname_loc4` = '蘑菇商' WHERE `entry` IN (92022) AND `subname_loc4` = '蘑菇商人';  -- Mushroom Seller
UPDATE `locales_creature` SET `subname_loc4` = '锻造工匠' WHERE `entry` IN (4258) AND `subname_loc4` = '锻造训练师';  -- Artisan Blacksmith
UPDATE `locales_creature` SET `subname_loc4` = '弓箭商人' WHERE `entry` IN (3410) AND `subname_loc4` = '弓箭商';  -- Bow Merchant
UPDATE `locales_creature` SET `subname_loc4` = '南海劫掠者' WHERE `entry` IN (3467) AND `subname_loc4` = '南海海盗';  -- Southsea Freebooters
UPDATE `locales_creature` SET `subname_loc4` = '面包师' WHERE `entry` IN (65134) AND `subname_loc4` = '烘焙师';  -- Baker
UPDATE `locales_creature` SET `subname_loc4` = '鱼商' WHERE `entry` IN (81025) AND `subname_loc4` = '鱼贩';  -- Fish Merchant
UPDATE `locales_creature` SET `subname_loc4` = '赛车女郎' WHERE `entry` IN (50533) AND `subname_loc4` = '赛车宝贝';  -- Race Starter Girl
UPDATE `locales_creature` SET `subname_loc4` = '材料与毒药商' WHERE `entry` IN (10364) AND `subname_loc4` = '调酒师';  -- Reagents & Poisons
UPDATE `locales_creature` SET `subname_loc4` = '铸甲师' WHERE `entry` IN (5164) AND `subname_loc4` = '护甲锻造训练师';  -- Armor Crafter
UPDATE `locales_creature` SET `subname_loc4` = '酒鬼' WHERE `entry` IN (6090) AND `subname_loc4` = '醉鬼';  -- Drunk
UPDATE `locales_creature` SET `subname_loc4` = '首席工程师' WHERE `entry` IN (7853) AND `subname_loc4` = '首席技师';  -- Chief Engineer
UPDATE `locales_creature` SET `subname_loc4` = '艾露恩的高阶女祭司' WHERE `entry` IN (15633) AND `subname_loc4` = '艾露恩的高阶祭司';  -- High Priestess of Elune
UPDATE `locales_creature` SET `subname_loc4` = '亚麻须前线' WHERE `entry` IN (8678) AND `subname_loc4` = '工程学供应商';  -- Flaxwhisker Front
UPDATE `locales_creature` SET `subname_loc4` = '亚麻须前线' WHERE `entry` IN (12957) AND `subname_loc4` = '商人';  -- Flaxwhisker Front
UPDATE `locales_creature` SET `subname_loc4` = '卡加斯远征军' WHERE `entry` IN (60495) AND `subname_loc4` = '卡加斯远征军队';  -- Kargath Expeditionary Force
UPDATE `locales_creature` SET `subname_loc4` = '黑手铸甲师' WHERE `entry` IN (15796) AND `subname_loc4` = '黑色军团护甲锻造师';  -- Blackhand Legion Armorsmith
UPDATE `locales_creature` SET `subname_loc4` = '附魔训练师' WHERE `entry` IN (11074) AND `subname_loc4` = '高级附魔师';  -- Artisan Enchanter
UPDATE `locales_creature` SET `subname_loc4` = '护甲锻造师' WHERE `entry` IN (92178) AND `subname_loc4` = '铸甲师';  -- Armorsmith
UPDATE `locales_creature` SET `subname_loc4` = '守卫队长' WHERE `entry` IN (15182) AND `subname_loc4` = '卫兵队长';  -- Captain of the Guard
UPDATE `locales_creature` SET `subname_loc4` = '烟林牧场' WHERE `entry` IN (15732) AND `subname_loc4` = '熏木牧场';  -- Smokywood Pastures
UPDATE `locales_creature` SET `subname_loc4` = '糖果礼物商人' WHERE `entry` IN (14481) AND `subname_loc4` = '好心人';  -- Sweet Treats
UPDATE `locales_creature` SET `subname_loc4` = '联盟布匹军需官' WHERE `entry` IN (80459) AND `subname_loc4` = '联盟布甲军需官';  -- Alliance Cloth Quartermaster
UPDATE `locales_creature` SET `subname_loc4` = '部落布匹军需官' WHERE `entry` IN (80807) AND `subname_loc4` = '部落布甲军需官';  -- Horde Cloth Quartermaster
UPDATE `locales_creature` SET `subname_loc4` = '铁匠' WHERE `entry` IN (60457) AND `subname_loc4` = '锻造供应商';  -- Blacksmith
UPDATE `locales_creature` SET `subname_loc4` = '深渊议会' WHERE `entry` IN (15305) AND `subname_loc4` = '高阶深渊议会';  -- Abyssal High Council
UPDATE `locales_creature` SET `subname_loc4` = '符文布绷带收集者' WHERE `entry` IN (15532) AND `subname_loc4` = '符文布收集者';  -- Runecloth Bandage Collector
UPDATE `locales_creature` SET `subname_loc4` = '生存训练师' WHERE `entry` IN (50070) AND `subname_loc4` = '生存专家';  -- Survival Trainer
UPDATE `locales_creature` SET `subname_loc4` = '战歌先锋' WHERE `entry` IN (60880) AND `subname_loc4` = '战歌氏族';  -- Warsong Outriders
UPDATE `locales_creature` SET `subname_loc4` = '码头主管' WHERE `entry` IN (91250) AND `subname_loc4` = '码头管理员';  -- Dockmaster
UPDATE `locales_creature` SET `subname_loc4` = '摄政议会' WHERE `entry` IN (80877) AND `subname_loc4` = '银月城残党';  -- Regency Council
UPDATE `locales_creature` SET `subname_loc4` = '裂隙大师' WHERE `entry` IN (91782) AND `subname_loc4` = '寻隙者';  -- Riftmaster
UPDATE `locales_creature` SET `subname_loc4` = '初级武器大师' WHERE `entry` IN (80228) AND `subname_loc4` = '初级';  -- Apprentice Weapon Master
UPDATE `locales_creature` SET `subname_loc4` = '悲痛守卫' WHERE `entry` IN (92023) AND `subname_loc4` = '悲恸守卫';  -- Sorrowguard
-- 物品/物件同类（并列 → 取更常见的官方用词）
UPDATE `locales_item` SET `name_loc4` = '煤炭' WHERE `entry` = 41022 AND `name_loc4` = '煤块';
UPDATE `locales_gameobject` SET `name_loc4` = '投石车' WHERE `entry` = 1000098 AND `name_loc4` = '弹射器';

-- ---- 补充（同批扫出的错字与两组人工覆盖）----
UPDATE `locales_creature` SET `subname_loc4` = '暴风城军需官'
 WHERE `entry` = 80954 AND `subname_loc4` = '风暴成军需官';          -- Stormwind Quartermaster（“风暴成”是错字）

UPDATE `locales_creature` SET `subname_loc4` = '暴风城国王'
 WHERE `entry` = 1747 AND `subname_loc4` = '暴风城的国王';           -- King of Stormwind（与 11699/65133 统一）

UPDATE `locales_creature` SET `subname_loc4` = '大地之环'
 WHERE `entry` = 12736 AND `subname_loc4` = '陶土议会';              -- The Earthen Ring（与库内正文及 62798/62802 统一）
