-- 依据**客户端 DBC** 修正文本（2026-10-10）
--
-- 为什么用 DBC 而不是 wowhead：玩家在游戏里看到的法术名/说明、区域名、阵营名、飞行点，
-- 都是客户端从自己的 DBC 里取的。服务端 locales_* 表要与客户端**一致**才不会出现
-- 「聊天里叫一个名、法术书里叫另一个名」。
--
-- 校验前提：Spell.dbc 的英文名与库内 spell_template.name **27,915 条全部一致**，ID 对齐。
--
-- 覆盖四张表：
--   locales_spell          ← Spell.dbc     name=字段124 / rank=133 / description=142 / aura=151
--   locales_area           ← AreaTable.dbc name=字段15
--   locales_faction        ← Faction.dbc   name=字段23
--   locales_taxi_node      ← TaxiNodes.dbc name=字段9
--
-- 典型修正：
--   #1022 英文是 Hand of Protection → 应为「保护之手」（原「保护祝福」是旧译名）
--   #687  Demon Armor → 「魔甲术」（原「恶魔皮肤」是另一个法术的名字）
--   #921  Pick Pocket → 「偷窃」；#2098 Eviscerate → 「剔骨」；#1039 → 「拯救祝福」
--   #19465 毒蛇钉刺 → 官方还包含蝰蛇钉刺/毒蝎钉刺两条效果（原译文缺一半）
--   Faction 15 Defias Brotherhood → 「迪菲亚兄弟会」（原「迪菲亚盗贼」）
--   Faction 32 Trogg → 「穴居人」（原「石腭怪」）
--
-- 有意保留：DBC 里未翻译（只有英文）的开发法术（zzOLD/[PH]/DND 等）不采纳，
-- 库内中文更可读；这类约 420 条。
--
-- 带原值条件、可重复导入。生效：`.reload locales_spell` / `locales_area` /
-- `locales_faction` / `locales_taxi_node`

SET NAMES utf8mb4;

UPDATE `locales_spell` SET `name_loc4` = '熔岩爆裂' WHERE `entry` = 534 AND `name_loc4` = '熔火爆裂';

UPDATE `locales_spell` SET `name_loc4` = '熔岩爆裂' WHERE `entry` = 561 AND `name_loc4` = '熔火爆裂';

UPDATE `locales_spell` SET `name_loc4` = '魔甲术' WHERE `entry` = 687 AND `name_loc4` = '恶魔皮肤';

UPDATE `locales_spell` SET `name_loc4` = '魔甲术' WHERE `entry` = 696 AND `name_loc4` = '恶魔皮肤';

UPDATE `locales_spell` SET `name_loc4` = '魔甲术' WHERE `entry` = 722 AND `name_loc4` = '恶魔皮肤';

UPDATE `locales_spell` SET `name_loc4` = '熔岩爆裂' WHERE `entry` = 900 AND `name_loc4` = '熔火爆裂';

UPDATE `locales_spell` SET `name_loc4` = '偷窃' WHERE `entry` = 921 AND `name_loc4` = '搜索';

UPDATE `locales_spell` SET `name_loc4` = '熔岩爆裂' WHERE `entry` = 924 AND `name_loc4` = '熔火爆裂';

UPDATE `locales_spell` SET `name_loc4` = '熔岩爆裂' WHERE `entry` = 952 AND `name_loc4` = '熔火爆裂';

UPDATE `locales_spell` SET `name_loc4` = '保护之手' WHERE `entry` = 1022 AND `name_loc4` = '保护祝福';

UPDATE `locales_spell` SET `name_loc4` = '拯救祝福' WHERE `entry` = 1039 AND `name_loc4` = '拯救圣印';

UPDATE `locales_spell` SET `name_loc4` = '自由之手' WHERE `entry` = 1044 AND `name_loc4` = '自由祝福';

UPDATE `locales_spell` SET `name_loc4` = '致命一击' WHERE `entry` = 1132 AND `name_loc4` = '爆击';

UPDATE `locales_spell` SET `name_loc4` = '烹饪用火' WHERE `entry` = 1290 AND `name_loc4` = '基础营火';

UPDATE `locales_spell` SET `name_loc4` = '魔甲术' WHERE `entry` = 1383 AND `name_loc4` = '恶魔皮肤';

UPDATE `locales_spell` SET `name_loc4` = '智慧燃烧 III' WHERE `entry` = 1483 AND `name_loc4` = '智慧燃烧';

UPDATE `locales_spell` SET `name_loc4` = '智慧燃烧 IV' WHERE `entry` = 1484 AND `name_loc4` = '智慧燃烧';

UPDATE `locales_spell` SET `name_loc4` = '自由之手' WHERE `entry` = 1909 AND `name_loc4` = '自由祝福';

UPDATE `locales_spell` SET `name_loc4` = '保护之手' WHERE `entry` = 1911 AND `name_loc4` = '保护祝福';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 2098 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '配方：初级坚韧药剂' WHERE `entry` = 2363 AND `name_loc4` = '配方：坚韧药剂';

UPDATE `locales_spell` SET `name_loc4` = '护甲+8/耐力+1' WHERE `entry` = 2831 AND `name_loc4` = '护甲 +8';

UPDATE `locales_spell` SET `name_loc4` = '护甲+16/耐力+2' WHERE `entry` = 2832 AND `name_loc4` = '护甲 +16';

UPDATE `locales_spell` SET `name_loc4` = '护甲+24/耐力+3' WHERE `entry` = 2833 AND `name_loc4` = '护甲 +24';

UPDATE `locales_spell` SET `name_loc4` = '抗毒药水' WHERE `entry` = 3174 AND `name_loc4` = '抗毒药剂';

UPDATE `locales_spell` SET `name_loc4` = '配方：抗毒药水' WHERE `entry` = 3182 AND `name_loc4` = '配方：抗毒药剂';

UPDATE `locales_spell` SET `name_loc4` = '配方：坚韧药剂' WHERE `entry` = 3455 AND `name_loc4` = '配方：强力坚韧药剂';

UPDATE `locales_spell` SET `name_loc4` = '灼热箭' WHERE `entry` = 3606 AND `name_loc4` = '攻击';

UPDATE `locales_spell` SET `name_loc4` = '粗制炸药' WHERE `entry` = 3931 AND `name_loc4` = '劣质炸药';

UPDATE `locales_spell` SET `name_loc4` = '联合收割机组件' WHERE `entry` = 3963 AND `name_loc4` = '微型收割机组件';

UPDATE `locales_spell` SET `name_loc4` = '粗制炸药' WHERE `entry` = 3994 AND `name_loc4` = '劣质炸药';

UPDATE `locales_spell` SET `name_loc4` = '联合收割机组件' WHERE `entry` = 4019 AND `name_loc4` = '微型收割机组件';

UPDATE `locales_spell` SET `name_loc4` = '活动假人效果' WHERE `entry` = 4045 AND `name_loc4` = '迟钝诱饵效果';

UPDATE `locales_spell` SET `name_loc4` = '高级假人效果' WHERE `entry` = 4049 AND `name_loc4` = '闪光诱饵效果';

UPDATE `locales_spell` SET `name_loc4` = '粗制炸药' WHERE `entry` = 4061 AND `name_loc4` = '劣质炸药';

UPDATE `locales_spell` SET `name_loc4` = '单手剑掌握' WHERE `entry` = 4287 AND `name_loc4` = '剑类武器掌握';

UPDATE `locales_spell` SET `name_loc4` = '单手斧掌握' WHERE `entry` = 4289 AND `name_loc4` = '斧类武器掌握';

UPDATE `locales_spell` SET `name_loc4` = '单手斧掌握' WHERE `entry` = 4290 AND `name_loc4` = '斧类武器掌握';

UPDATE `locales_spell` SET `name_loc4` = '单手斧掌握' WHERE `entry` = 4291 AND `name_loc4` = '斧类武器掌握';

UPDATE `locales_spell` SET `name_loc4` = '单手斧掌握' WHERE `entry` = 4292 AND `name_loc4` = '斧类武器掌握';

UPDATE `locales_spell` SET `name_loc4` = '单手锤掌握' WHERE `entry` = 4293 AND `name_loc4` = '锤类武器掌握';

UPDATE `locales_spell` SET `name_loc4` = '单手锤掌握' WHERE `entry` = 4294 AND `name_loc4` = '锤类武器掌握';

UPDATE `locales_spell` SET `name_loc4` = '单手锤掌握' WHERE `entry` = 4295 AND `name_loc4` = '锤类武器掌握';

UPDATE `locales_spell` SET `name_loc4` = '单手锤掌握' WHERE `entry` = 4296 AND `name_loc4` = '锤类武器掌握';

UPDATE `locales_spell` SET `name_loc4` = '单手剑入门' WHERE `entry` = 4301 AND `name_loc4` = '剑类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手剑入门' WHERE `entry` = 4302 AND `name_loc4` = '剑类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手剑入门' WHERE `entry` = 4303 AND `name_loc4` = '剑类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手剑入门' WHERE `entry` = 4304 AND `name_loc4` = '剑类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手剑入门' WHERE `entry` = 4305 AND `name_loc4` = '剑类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手剑入门' WHERE `entry` = 4306 AND `name_loc4` = '剑类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手斧入门' WHERE `entry` = 4307 AND `name_loc4` = '斧类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手斧入门' WHERE `entry` = 4308 AND `name_loc4` = '斧类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手斧入门' WHERE `entry` = 4309 AND `name_loc4` = '斧类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手斧入门' WHERE `entry` = 4310 AND `name_loc4` = '斧类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手斧入门' WHERE `entry` = 4311 AND `name_loc4` = '斧类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手斧入门' WHERE `entry` = 4313 AND `name_loc4` = '斧类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手锤入门' WHERE `entry` = 4328 AND `name_loc4` = '锤类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手锤入门' WHERE `entry` = 4329 AND `name_loc4` = '锤类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手锤入门' WHERE `entry` = 4330 AND `name_loc4` = '锤类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手锤入门' WHERE `entry` = 4331 AND `name_loc4` = '锤类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手锤入门' WHERE `entry` = 4332 AND `name_loc4` = '锤类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手锤入门' WHERE `entry` = 4333 AND `name_loc4` = '锤类武器入门';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4334 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4335 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4336 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4337 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4338 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4339 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4340 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4341 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4342 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4343 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4344 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4345 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4346 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4347 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4348 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 4349 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4350 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4351 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4352 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4353 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4354 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4355 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4356 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4357 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4358 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4359 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4360 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4361 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4362 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4363 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4364 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 4365 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4366 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4367 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4368 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4369 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4370 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4371 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4372 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4373 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4374 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4375 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4376 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4377 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4378 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4379 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4380 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 4381 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '测试扰动' WHERE `entry` = 5025 AND `name_loc4` = 'Test Tickle';

UPDATE `locales_spell` SET `name_loc4` = '偷窃' WHERE `entry` = 5167 AND `name_loc4` = '搜索';



UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 5428 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 5429 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 5430 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 5431 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 5432 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 5433 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 5448 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 5449 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 5450 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 5451 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 5452 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 5453 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑强化' WHERE `entry` = 5481 AND `name_loc4` = '剑类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手剑强化' WHERE `entry` = 5482 AND `name_loc4` = '剑类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手剑强化' WHERE `entry` = 5483 AND `name_loc4` = '剑类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 5489 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 5490 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 5491 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 5492 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 5493 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑专精' WHERE `entry` = 5494 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手剑强化' WHERE `entry` = 5496 AND `name_loc4` = '剑类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手剑强化' WHERE `entry` = 5497 AND `name_loc4` = '剑类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手剑强化' WHERE `entry` = 5498 AND `name_loc4` = '剑类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手斧强化' WHERE `entry` = 5509 AND `name_loc4` = '斧类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手斧强化' WHERE `entry` = 5510 AND `name_loc4` = '斧类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手斧强化' WHERE `entry` = 5511 AND `name_loc4` = '斧类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 5516 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 5517 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 5518 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 5519 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 5520 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 5521 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧专精' WHERE `entry` = 5522 AND `name_loc4` = '斧专精';

UPDATE `locales_spell` SET `name_loc4` = '单手斧强化' WHERE `entry` = 5524 AND `name_loc4` = '斧类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手斧强化' WHERE `entry` = 5525 AND `name_loc4` = '斧类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手斧强化' WHERE `entry` = 5526 AND `name_loc4` = '斧类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手锤强化' WHERE `entry` = 5545 AND `name_loc4` = '锤类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手锤强化' WHERE `entry` = 5546 AND `name_loc4` = '锤类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手锤强化' WHERE `entry` = 5547 AND `name_loc4` = '锤类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 5548 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 5549 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 5550 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 5551 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 5552 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 5553 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 5554 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤强化' WHERE `entry` = 5555 AND `name_loc4` = '锤类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手锤强化' WHERE `entry` = 5556 AND `name_loc4` = '锤类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手锤强化' WHERE `entry` = 5557 AND `name_loc4` = '锤类武器强化';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 5558 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 5559 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 5560 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 5561 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 5562 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 5563 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '单手锤专精' WHERE `entry` = 5564 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '脚本测试' WHERE `entry` = 5581 AND `name_loc4` = 'Script Test';

UPDATE `locales_spell` SET `name_loc4` = '保护之手' WHERE `entry` = 5599 AND `name_loc4` = '保护祝福';

UPDATE `locales_spell` SET `name_loc4` = '保护之手' WHERE `entry` = 5600 AND `name_loc4` = '保护祝福';

UPDATE `locales_spell` SET `name_loc4` = '灼热箭' WHERE `entry` = 6350 AND `name_loc4` = '攻击';

UPDATE `locales_spell` SET `name_loc4` = '灼热箭' WHERE `entry` = 6351 AND `name_loc4` = '攻击';

UPDATE `locales_spell` SET `name_loc4` = '灼热箭' WHERE `entry` = 6352 AND `name_loc4` = '攻击';

UPDATE `locales_spell` SET `name_loc4` = '野蛮打击' WHERE `entry` = 6565 AND `name_loc4` = '野蛮痛击';

UPDATE `locales_spell` SET `name_loc4` = '野蛮打击' WHERE `entry` = 6567 AND `name_loc4` = '野蛮痛击';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 6712 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 6760 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 6761 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 6762 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 6763 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 6764 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 6765 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '牺牲之手' WHERE `entry` = 6940 AND `name_loc4` = '牺牲祝福';

UPDATE `locales_spell` SET `name_loc4` = '牺牲之手' WHERE `entry` = 6941 AND `name_loc4` = '牺牲祝福';

UPDATE `locales_spell` SET `name_loc4` = '光之辉煌' WHERE `entry` = 7001 AND `name_loc4` = '光明之泉回复';

UPDATE `locales_spell` SET `name_loc4` = '简易营火' WHERE `entry` = 7359 AND `name_loc4` = '明亮篝火';

UPDATE `locales_spell` SET `name_loc4` = '扳手' WHERE `entry` = 7430 AND `name_loc4` = '弧光扳手';

UPDATE `locales_spell` SET `name_loc4` = '扳手' WHERE `entry` = 7431 AND `name_loc4` = '弧光扳手';

UPDATE `locales_spell` SET `name_loc4` = '公式：浸魔胸甲 - 初级精神' WHERE `entry` = 7462 AND `name_loc4` = '公式：浸魔胸甲 - 次级精神';

UPDATE `locales_spell` SET `name_loc4` = '亡灵意志' WHERE `entry` = 7744 AND `name_loc4` = '被遗忘者的意志';

UPDATE `locales_spell` SET `name_loc4` = '附魔护腕 - 初级智力（旧）' WHERE `entry` = 7769 AND `name_loc4` = 'Imbue Bracers - Minor Wisdom OLD';

UPDATE `locales_spell` SET `name_loc4` = '大地震击' WHERE `entry` = 8042 AND `name_loc4` = '地震术';

UPDATE `locales_spell` SET `name_loc4` = '大地震击' WHERE `entry` = 8043 AND `name_loc4` = '地震术';

UPDATE `locales_spell` SET `name_loc4` = '大地震击' WHERE `entry` = 8044 AND `name_loc4` = '地震术';

UPDATE `locales_spell` SET `name_loc4` = '大地震击' WHERE `entry` = 8045 AND `name_loc4` = '地震术';

UPDATE `locales_spell` SET `name_loc4` = '大地震击' WHERE `entry` = 8046 AND `name_loc4` = '地震术';

UPDATE `locales_spell` SET `name_loc4` = '大地震击' WHERE `entry` = 8047 AND `name_loc4` = '地震术';

UPDATE `locales_spell` SET `name_loc4` = '大地震击' WHERE `entry` = 8048 AND `name_loc4` = '地震术';

UPDATE `locales_spell` SET `name_loc4` = '大地震击' WHERE `entry` = 8049 AND `name_loc4` = '地震术';

UPDATE `locales_spell` SET `name_loc4` = '突袭' WHERE `entry` = 8151 AND `name_loc4` = '突然攻击';

UPDATE `locales_spell` SET `name_loc4` = '粗制炸药' WHERE `entry` = 8333 AND `name_loc4` = '劣质炸药';

UPDATE `locales_spell` SET `name_loc4` = '黄色陆行鸟' WHERE `entry` = 8396 AND `name_loc4` = '召唤黄色陆行鸟';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 8623 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 8624 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 8625 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 8626 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '粗制炸药' WHERE `entry` = 9002 AND `name_loc4` = '劣质炸药';

UPDATE `locales_spell` SET `name_loc4` = '粗制炸药' WHERE `entry` = 9003 AND `name_loc4` = '劣质炸药';

UPDATE `locales_spell` SET `name_loc4` = '粗制炸药' WHERE `entry` = 9004 AND `name_loc4` = '劣质炸药';

UPDATE `locales_spell` SET `name_loc4` = '粗制炸药' WHERE `entry` = 9009 AND `name_loc4` = '劣质炸药';


UPDATE `locales_spell` SET `name_loc4` = '保护之手' WHERE `entry` = 10278 AND `name_loc4` = '保护祝福';

UPDATE `locales_spell` SET `name_loc4` = '保护之手' WHERE `entry` = 10279 AND `name_loc4` = '保护祝福';

UPDATE `locales_spell` SET `name_loc4` = '护甲+32/耐力+4' WHERE `entry` = 10344 AND `name_loc4` = '护甲 +32';

UPDATE `locales_spell` SET `name_loc4` = '大地震击' WHERE `entry` = 10412 AND `name_loc4` = '地震术';

UPDATE `locales_spell` SET `name_loc4` = '大地震击' WHERE `entry` = 10413 AND `name_loc4` = '地震术';

UPDATE `locales_spell` SET `name_loc4` = '大地震击' WHERE `entry` = 10414 AND `name_loc4` = '地震术';

UPDATE `locales_spell` SET `name_loc4` = '大地震击' WHERE `entry` = 10415 AND `name_loc4` = '地震术';

UPDATE `locales_spell` SET `name_loc4` = '大地震击' WHERE `entry` = 10416 AND `name_loc4` = '地震术';

UPDATE `locales_spell` SET `name_loc4` = '大地震击' WHERE `entry` = 10417 AND `name_loc4` = '地震术';

UPDATE `locales_spell` SET `name_loc4` = '灼热箭' WHERE `entry` = 10435 AND `name_loc4` = '攻击';

UPDATE `locales_spell` SET `name_loc4` = '灼热箭' WHERE `entry` = 10436 AND `name_loc4` = '攻击';

UPDATE `locales_spell` SET `name_loc4` = '祖利安黑豹' WHERE `entry` = 10787 AND `name_loc4` = '黑豹';

UPDATE `locales_spell` SET `name_loc4` = '丛林虎' WHERE `entry` = 10790 AND `name_loc4` = '黑纹虎';

UPDATE `locales_spell` SET `name_loc4` = '青色陆行鸟' WHERE `entry` = 10804 AND `name_loc4` = '召唤青色陆行鸟';

UPDATE `locales_spell` SET `name_loc4` = '火焰易伤' WHERE `entry` = 11095 AND `name_loc4` = '强化灼烧';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 11299 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 11300 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 11301 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 11302 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '优质治疗药水' WHERE `entry` = 11457 AND `name_loc4` = '超强治疗药水';

UPDATE `locales_spell` SET `name_loc4` = '优质治疗药水' WHERE `entry` = 11491 AND `name_loc4` = '超强治疗药水';

UPDATE `locales_spell` SET `name_loc4` = '禁令' WHERE `entry` = 12311 AND `name_loc4` = '强化盾击';

UPDATE `locales_spell` SET `name_loc4` = '强化火焰冲击' WHERE `entry` = 12343 AND `name_loc4` = 'zzOLDImproved Fire Blast';

UPDATE `locales_spell` SET `name_loc4` = '强化火焰冲击' WHERE `entry` = 12344 AND `name_loc4` = 'zzOLDImproved Fire Blast';

UPDATE `locales_spell` SET `name_loc4` = '眩晕' WHERE `entry` = 12705 AND `name_loc4` = '长时间眩晕';

UPDATE `locales_spell` SET `name_loc4` = '火焰易伤' WHERE `entry` = 12872 AND `name_loc4` = '强化灼烧';

UPDATE `locales_spell` SET `name_loc4` = '火焰易伤' WHERE `entry` = 12873 AND `name_loc4` = '强化灼烧';

UPDATE `locales_spell` SET `name_loc4` = '禁令' WHERE `entry` = 12958 AND `name_loc4` = '强化盾击';

UPDATE `locales_spell` SET `name_loc4` = '震荡打击' WHERE `entry` = 13709 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '震荡打击' WHERE `entry` = 13800 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '震荡打击' WHERE `entry` = 13801 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '震荡打击' WHERE `entry` = 13802 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '震荡打击' WHERE `entry` = 13803 AND `name_loc4` = '锤类武器专精';

UPDATE `locales_spell` SET `name_loc4` = 'NPC端口测试' WHERE `entry` = 13954 AND `name_loc4` = 'NPC PORT TEST';

UPDATE `locales_spell` SET `name_loc4` = '劈斩' WHERE `entry` = 13960 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '劈斩' WHERE `entry` = 13961 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '劈斩' WHERE `entry` = 13962 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '劈斩' WHERE `entry` = 13963 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '劈斩' WHERE `entry` = 13964 AND `name_loc4` = '剑类武器专精';

UPDATE `locales_spell` SET `name_loc4` = '底牌' WHERE `entry` = 14076 AND `name_loc4` = '强化闷棍';

UPDATE `locales_spell` SET `name_loc4` = '底牌' WHERE `entry` = 14094 AND `name_loc4` = '强化闷棍';

UPDATE `locales_spell` SET `name_loc4` = '谋杀' WHERE `entry` = 14158 AND `name_loc4` = '密谋';

UPDATE `locales_spell` SET `name_loc4` = '谋杀' WHERE `entry` = 14159 AND `name_loc4` = '密谋';

UPDATE `locales_spell` SET `name_loc4` = '强化剔骨' WHERE `entry` = 14162 AND `name_loc4` = '强化刺骨';

UPDATE `locales_spell` SET `name_loc4` = '强化剔骨' WHERE `entry` = 14163 AND `name_loc4` = '强化刺骨';

UPDATE `locales_spell` SET `name_loc4` = '强化剔骨' WHERE `entry` = 14164 AND `name_loc4` = '强化刺骨';

UPDATE `locales_spell` SET `name_loc4` = '强化刀锋战术' WHERE `entry` = 14165 AND `name_loc4` = '强化切割';

UPDATE `locales_spell` SET `name_loc4` = '强化刀锋战术' WHERE `entry` = 14166 AND `name_loc4` = '强化切割';

UPDATE `locales_spell` SET `name_loc4` = '强化刀锋战术' WHERE `entry` = 14167 AND `name_loc4` = '强化切割';

UPDATE `locales_spell` SET `name_loc4` = '血腥气息' WHERE `entry` = 14174 AND `name_loc4` = '强化肾击';

UPDATE `locales_spell` SET `name_loc4` = '血腥气息' WHERE `entry` = 14175 AND `name_loc4` = '强化肾击';

UPDATE `locales_spell` SET `name_loc4` = '血腥气息' WHERE `entry` = 14176 AND `name_loc4` = '强化肾击';

UPDATE `locales_spell` SET `name_loc4` = '无情打击' WHERE `entry` = 14181 AND `name_loc4` = '无情打击效果';

UPDATE `locales_spell` SET `name_loc4` = '释放怒爪备份' WHERE `entry` = 14804 AND `name_loc4` = 'Copy of Release Rageclaw';

UPDATE `locales_spell` SET `name_loc4` = '神圣专注' WHERE `entry` = 14913 AND `name_loc4` = '治疗专注';

UPDATE `locales_spell` SET `name_loc4` = '神圣专注' WHERE `entry` = 15012 AND `name_loc4` = '治疗专注';

UPDATE `locales_spell` SET `name_loc4` = '熔岩爆裂' WHERE `entry` = 15040 AND `name_loc4` = '熔火爆裂';

UPDATE `locales_spell` SET `name_loc4` = '炸弹宠物' WHERE `entry` = 15048 AND `name_loc4` = '召唤炸弹';

UPDATE `locales_spell` SET `name_loc4` = '发条娃娃' WHERE `entry` = 15049 AND `name_loc4` = '召唤机器人';

UPDATE `locales_spell` SET `name_loc4` = '熔岩爆裂' WHERE `entry` = 15095 AND `name_loc4` = '熔火爆裂';

UPDATE `locales_spell` SET `name_loc4` = '暗影之波' WHERE `entry` = 15258 AND `name_loc4` = '暗影易伤';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 15691 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 15692 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '香脆蝙蝠翅' WHERE `entry` = 15935 AND `name_loc4` = '香脆翅根';

UPDATE `locales_spell` SET `name_loc4` = '食谱：香脆蝙蝠翅' WHERE `entry` = 15936 AND `name_loc4` = '食谱：香脆翅根';

UPDATE `locales_spell` SET `name_loc4` = '上古夜刃豹' WHERE `entry` = 16055 AND `name_loc4` = '夜刃豹';

UPDATE `locales_spell` SET `name_loc4` = '上古霜刃豹' WHERE `entry` = 16056 AND `name_loc4` = '霜刃豹';

UPDATE `locales_spell` SET `name_loc4` = '原始猎豹' WHERE `entry` = 16058 AND `name_loc4` = '远古豹';

UPDATE `locales_spell` SET `name_loc4` = '茶色刃齿豹' WHERE `entry` = 16059 AND `name_loc4` = '茶色利刃豹';

UPDATE `locales_spell` SET `name_loc4` = '金色锋刃豹' WHERE `entry` = 16060 AND `name_loc4` = '金色猎豹';

UPDATE `locales_spell` SET `name_loc4` = '放电' WHERE `entry` = 16089 AND `name_loc4` = '元素之怒';

UPDATE `locales_spell` SET `name_loc4` = '烈焰召唤' WHERE `entry` = 16162 AND `name_loc4` = '元素浩劫';

UPDATE `locales_spell` SET `name_loc4` = '烈焰召唤' WHERE `entry` = 16163 AND `name_loc4` = '元素浩劫';

UPDATE `locales_spell` SET `name_loc4` = '先祖迅捷' WHERE `entry` = 16188 AND `name_loc4` = '自然迅捷';

UPDATE `locales_spell` SET `name_loc4` = '稳固护盾' WHERE `entry` = 16261 AND `name_loc4` = '强化闪电之盾';

UPDATE `locales_spell` SET `name_loc4` = '稳固护盾' WHERE `entry` = 16290 AND `name_loc4` = '强化闪电之盾';

UPDATE `locales_spell` SET `name_loc4` = '稳固护盾' WHERE `entry` = 16291 AND `name_loc4` = '强化闪电之盾';

UPDATE `locales_spell` SET `name_loc4` = '奥金勇士剑' WHERE `entry` = 16990 AND `name_loc4` = '奥金圣剑';

UPDATE `locales_spell` SET `name_loc4` = '屠戮' WHERE `entry` = 16998 AND `name_loc4` = '野蛮暴怒';

UPDATE `locales_spell` SET `name_loc4` = '屠戮' WHERE `entry` = 16999 AND `name_loc4` = '野蛮暴怒';

UPDATE `locales_spell` SET `name_loc4` = '野性迅捷' WHERE `entry` = 17002 AND `name_loc4` = '豹之迅捷';

UPDATE `locales_spell` SET `name_loc4` = '设计图：奥金勇士剑' WHERE `entry` = 17032 AND `name_loc4` = '设计图：奥金圣剑';

UPDATE `locales_spell` SET `name_loc4` = '起源' WHERE `entry` = 17111 AND `name_loc4` = '强化回春术';

UPDATE `locales_spell` SET `name_loc4` = '起源' WHERE `entry` = 17112 AND `name_loc4` = '强化回春术';

UPDATE `locales_spell` SET `name_loc4` = '起源' WHERE `entry` = 17113 AND `name_loc4` = '强化回春术';

UPDATE `locales_spell` SET `name_loc4` = '烫伤' WHERE `entry` = 17276 AND `name_loc4` = '斯卡尔德';

UPDATE `locales_spell` SET `name_loc4` = '瑞文戴尔的死亡战马' WHERE `entry` = 17481 AND `name_loc4` = '黑色骷髅战马';

UPDATE `locales_spell` SET `name_loc4` = '优质法力药水' WHERE `entry` = 17553 AND `name_loc4` = '超强法力药水';

UPDATE `locales_spell` SET `name_loc4` = '配方：优质法力药水' WHERE `entry` = 17583 AND `name_loc4` = '配方：超级法力药水';

UPDATE `locales_spell` SET `name_loc4` = '暗影易伤' WHERE `entry` = 17793 AND `name_loc4` = '强化暗影箭';

UPDATE `locales_spell` SET `name_loc4` = '暗影易伤' WHERE `entry` = 17796 AND `name_loc4` = '强化暗影箭';

UPDATE `locales_spell` SET `name_loc4` = '暗影易伤' WHERE `entry` = 17801 AND `name_loc4` = '强化暗影箭';

UPDATE `locales_spell` SET `name_loc4` = '暗影易伤' WHERE `entry` = 17802 AND `name_loc4` = '强化暗影箭';

UPDATE `locales_spell` SET `name_loc4` = '暗影易伤' WHERE `entry` = 17803 AND `name_loc4` = '强化暗影箭';

UPDATE `locales_spell` SET `name_loc4` = '余烬风暴' WHERE `entry` = 17954 AND `name_loc4` = '琥珀风暴';

UPDATE `locales_spell` SET `name_loc4` = '余烬风暴' WHERE `entry` = 17955 AND `name_loc4` = '琥珀风暴';

UPDATE `locales_spell` SET `name_loc4` = '余烬风暴' WHERE `entry` = 17956 AND `name_loc4` = '灰烬风暴';

UPDATE `locales_spell` SET `name_loc4` = '余烬风暴' WHERE `entry` = 17957 AND `name_loc4` = '灰烬风暴';

UPDATE `locales_spell` SET `name_loc4` = '余烬风暴' WHERE `entry` = 17958 AND `name_loc4` = '灰烬风暴';

UPDATE `locales_spell` SET `name_loc4` = '测试奥术专注' WHERE `entry` = 18189 AND `name_loc4` = 'TEST Arcane Concentration';

UPDATE `locales_spell` SET `name_loc4` = '手册：腐蚀致命毒药' WHERE `entry` = 18282 AND `name_loc4` = '假人法术';

UPDATE `locales_spell` SET `name_loc4` = '灵魂通道' WHERE `entry` = 18703 AND `name_loc4` = '强化生命通道';

UPDATE `locales_spell` SET `name_loc4` = '灵魂通道' WHERE `entry` = 18704 AND `name_loc4` = '强化生命通道';

UPDATE `locales_spell` SET `name_loc4` = '护甲+40/耐力+5' WHERE `entry` = 19057 AND `name_loc4` = '护甲 +40';

UPDATE `locales_spell` SET `name_loc4` = '图样：魔暴龙皮手套' WHERE `entry` = 19204 AND `name_loc4` = '图样：魔暴龙护手';

UPDATE `locales_spell` SET `name_loc4` = '图样：魔暴龙皮护腿' WHERE `entry` = 19216 AND `name_loc4` = '图样：魔暴龙护腿';

UPDATE `locales_spell` SET `name_loc4` = '迅捷反射' WHERE `entry` = 19295 AND `name_loc4` = '偏斜';

UPDATE `locales_spell` SET `name_loc4` = '迅捷反射' WHERE `entry` = 19297 AND `name_loc4` = '偏斜';

UPDATE `locales_spell` SET `name_loc4` = '迅捷射击' WHERE `entry` = 19454 AND `name_loc4` = '强化奥术射击';

UPDATE `locales_spell` SET `name_loc4` = '迅捷射击' WHERE `entry` = 19455 AND `name_loc4` = '强化奥术射击';

UPDATE `locales_spell` SET `name_loc4` = '迅捷射击' WHERE `entry` = 19456 AND `name_loc4` = '强化奥术射击';

UPDATE `locales_spell` SET `name_loc4` = '强化钉刺' WHERE `entry` = 19464 AND `name_loc4` = '强化毒蛇钉刺';

UPDATE `locales_spell` SET `name_loc4` = '强化钉刺' WHERE `entry` = 19465 AND `name_loc4` = '强化毒蛇钉刺';

UPDATE `locales_spell` SET `name_loc4` = '强化钉刺' WHERE `entry` = 19466 AND `name_loc4` = '强化毒蛇钉刺';

UPDATE `locales_spell` SET `name_loc4` = '强化钉刺' WHERE `entry` = 19467 AND `name_loc4` = '强化毒蛇钉刺';

UPDATE `locales_spell` SET `name_loc4` = '强化钉刺' WHERE `entry` = 19468 AND `name_loc4` = '强化毒蛇钉刺';

UPDATE `locales_spell` SET `name_loc4` = '强化原始守护' WHERE `entry` = 19549 AND `name_loc4` = '强化灵猴守护';

UPDATE `locales_spell` SET `name_loc4` = '强化原始守护' WHERE `entry` = 19550 AND `name_loc4` = '强化灵猴守护';

UPDATE `locales_spell` SET `name_loc4` = '强化原始守护' WHERE `entry` = 19551 AND `name_loc4` = '强化灵猴守护';

UPDATE `locales_spell` SET `name_loc4` = '测试附魔武器 - 强效攻击' WHERE `entry` = 19934 AND `name_loc4` = 'Test Enchant Weapon - Greater Striking';

UPDATE `locales_spell` SET `name_loc4` = '强化祝福' WHERE `entry` = 20042 AND `name_loc4` = '强化力量祝福';

UPDATE `locales_spell` SET `name_loc4` = '强化祝福' WHERE `entry` = 20045 AND `name_loc4` = '强化力量祝福';

UPDATE `locales_spell` SET `name_loc4` = '强化祝福' WHERE `entry` = 20046 AND `name_loc4` = '强化力量祝福';

UPDATE `locales_spell` SET `name_loc4` = '强化祝福' WHERE `entry` = 20047 AND `name_loc4` = '强化力量祝福';

UPDATE `locales_spell` SET `name_loc4` = '强化祝福' WHERE `entry` = 20048 AND `name_loc4` = '强化力量祝福';

UPDATE `locales_spell` SET `name_loc4` = '光明审判' WHERE `entry` = 20185 AND `name_loc4` = '圣光审判';

UPDATE `locales_spell` SET `name_loc4` = '光明审判' WHERE `entry` = 20267 AND `name_loc4` = '圣光审判';

UPDATE `locales_spell` SET `name_loc4` = '光明审判' WHERE `entry` = 20341 AND `name_loc4` = '圣光审判';

UPDATE `locales_spell` SET `name_loc4` = '光明审判' WHERE `entry` = 20342 AND `name_loc4` = '圣光审判';

UPDATE `locales_spell` SET `name_loc4` = '光明审判' WHERE `entry` = 20343 AND `name_loc4` = '圣光审判';

UPDATE `locales_spell` SET `name_loc4` = '光明审判' WHERE `entry` = 20344 AND `name_loc4` = '圣光审判';

UPDATE `locales_spell` SET `name_loc4` = '光明审判' WHERE `entry` = 20345 AND `name_loc4` = '圣光审判';

UPDATE `locales_spell` SET `name_loc4` = '光明审判' WHERE `entry` = 20346 AND `name_loc4` = '圣光审判';

UPDATE `locales_spell` SET `name_loc4` = '战场机动' WHERE `entry` = 20504 AND `name_loc4` = '强化拦截';

UPDATE `locales_spell` SET `name_loc4` = '战场机动' WHERE `entry` = 20505 AND `name_loc4` = '强化拦截';

UPDATE `locales_spell` SET `name_loc4` = '血性狂怒' WHERE `entry` = 20572 AND `name_loc4` = '血性狂暴';

UPDATE `locales_spell` SET `name_loc4` = '牺牲之手' WHERE `entry` = 20729 AND `name_loc4` = '牺牲祝福';

UPDATE `locales_spell` SET `name_loc4` = '牺牲之手' WHERE `entry` = 20730 AND `name_loc4` = '牺牲祝福';

UPDATE `locales_spell` SET `name_loc4` = '收集厄运之水' WHERE `entry` = 20814 AND `name_loc4` = '收集恐怖之水';

UPDATE `locales_spell` SET `name_loc4` = '荆棘爆炸' WHERE `entry` = 21972 AND `name_loc4` = '强化荆棘时效';

UPDATE `locales_spell` SET `name_loc4` = '测试附魔武器 - 冰霜伤害+5' WHERE `entry` = 22093 AND `name_loc4` = 'zzOLD - QAEnchant Weapon +5 Frost Damage';

UPDATE `locales_spell` SET `name_loc4` = '测试附魔盾牌 - 精神+7' WHERE `entry` = 22097 AND `name_loc4` = 'zzOLD - QAEnchant Shield +7 Spirit';

UPDATE `locales_spell` SET `name_loc4` = '命令怒吼' WHERE `entry` = 22440 AND `name_loc4` = '命令之吼';

UPDATE `locales_spell` SET `name_loc4` = '防御+5' WHERE `entry` = 22725 AND `name_loc4` = '防御 +3';

UPDATE `locales_spell` SET `name_loc4` = '致命武器+2' WHERE `entry` = 22755 AND `name_loc4` = '致命武器 +2';

UPDATE `locales_spell` SET `name_loc4` = '幽灵狼速度' WHERE `entry` = 22801 AND `name_loc4` = '幽魂之狼速度';

UPDATE `locales_spell` SET `name_loc4` = '火焰易伤' WHERE `entry` = 22959 AND `name_loc4` = '痛苦诅咒';

UPDATE `locales_spell` SET `name_loc4` = '召唤天灾步兵 DND' WHERE `entry` = 23118 AND `name_loc4` = 'Conjure Scourge Footsoldier DND';

UPDATE `locales_spell` SET `name_loc4` = '传授召唤恐惧战马' WHERE `entry` = 23160 AND `name_loc4` = '教授召唤恐惧战马';

UPDATE `locales_spell` SET `name_loc4` = '血性狂怒' WHERE `entry` = 23230 AND `name_loc4` = '血性狂暴';

UPDATE `locales_spell` SET `name_loc4` = '血性狂怒' WHERE `entry` = 23234 AND `name_loc4` = '血性狂暴';

UPDATE `locales_spell` SET `name_loc4` = '月火术' WHERE `entry` = 23380 AND `name_loc4` = '投石';

UPDATE `locales_spell` SET `name_loc4` = '治疗之触' WHERE `entry` = 23381 AND `name_loc4` = '投石';

UPDATE `locales_spell` SET `name_loc4` = '提高致命一击法术' WHERE `entry` = 23433 AND `name_loc4` = '提高爆击法术';

UPDATE `locales_spell` SET `name_loc4` = '提高致命一击法术' WHERE `entry` = 23434 AND `name_loc4` = '提高爆击法术';

UPDATE `locales_spell` SET `name_loc4` = '提高神圣致命一击' WHERE `entry` = 23435 AND `name_loc4` = '提高神圣爆击';

UPDATE `locales_spell` SET `name_loc4` = '提高暗影致命一击法术' WHERE `entry` = 23440 AND `name_loc4` = '提高暗影爆击法术';

UPDATE `locales_spell` SET `name_loc4` = '提高暗影致命一击法术' WHERE `entry` = 23443 AND `name_loc4` = '提高暗影爆击法术';

UPDATE `locales_spell` SET `name_loc4` = '降低宁静和飓风的冷却时间' WHERE `entry` = 23556 AND `name_loc4` = '降低宁静冷却时间';

UPDATE `locales_spell` SET `name_loc4` = '强化乱射和多重射击' WHERE `entry` = 23566 AND `name_loc4` = '强化箭雨和多重射击';

UPDATE `locales_spell` SET `name_loc4` = '自然法术提高致命一击几率' WHERE `entry` = 23570 AND `name_loc4` = '提高爆击自然法术';

UPDATE `locales_spell` SET `name_loc4` = '测试急速' WHERE `entry` = 23674 AND `name_loc4` = 'Test Eng Haste';

UPDATE `locales_spell` SET `name_loc4` = '闪电打击' WHERE `entry` = 23686 AND `name_loc4` = '闪电攻击';

UPDATE `locales_spell` SET `name_loc4` = '闪电打击' WHERE `entry` = 23687 AND `name_loc4` = '闪电攻击';

UPDATE `locales_spell` SET `name_loc4` = '狂暴之怒' WHERE `entry` = 23690 AND `name_loc4` = '狂暴之怒效果';

UPDATE `locales_spell` SET `name_loc4` = '狂暴之怒' WHERE `entry` = 23691 AND `name_loc4` = '狂暴之怒效果';

UPDATE `locales_spell` SET `name_loc4` = '特效抗毒药剂' WHERE `entry` = 23786 AND `name_loc4` = '强效抗毒药剂';

UPDATE `locales_spell` SET `name_loc4` = '配方：特效抗毒药剂' WHERE `entry` = 23788 AND `name_loc4` = '配方：强效抗毒药剂';

UPDATE `locales_spell` SET `name_loc4` = '石爪图腾测试' WHERE `entry` = 23789 AND `name_loc4` = 'Stoneclaw Totem TEST';

UPDATE `locales_spell` SET `name_loc4` = '附魔护腕 - 治疗能量' WHERE `entry` = 23802 AND `name_loc4` = '附魔护腕 - 治疗能力';

UPDATE `locales_spell` SET `name_loc4` = '测试致死打击W50' WHERE `entry` = 23848 AND `name_loc4` = 'Test Strike W50';

UPDATE `locales_spell` SET `name_loc4` = '测试致死打击W35' WHERE `entry` = 23850 AND `name_loc4` = 'Test Strike W35';

UPDATE `locales_spell` SET `name_loc4` = '测试背刺R50' WHERE `entry` = 23959 AND `name_loc4` = 'Test Stab R50';

UPDATE `locales_spell` SET `name_loc4` = '测试邪恶攻击R50' WHERE `entry` = 23960 AND `name_loc4` = 'Test Strike R50';

UPDATE `locales_spell` SET `name_loc4` = '测试槌击' WHERE `entry` = 24042 AND `name_loc4` = 'Test Maul';

UPDATE `locales_spell` SET `name_loc4` = '测试愤怒' WHERE `entry` = 24043 AND `name_loc4` = 'Test Fury';

UPDATE `locales_spell` SET `name_loc4` = '测试攻强加成 (猎豹)' WHERE `entry` = 24218 AND `name_loc4` = 'Test Power Bonus (Cat)';

UPDATE `locales_spell` SET `name_loc4` = '测试暴击加成' WHERE `entry` = 24219 AND `name_loc4` = 'Test Critical Bonus';

UPDATE `locales_spell` SET `name_loc4` = '凶猛撕咬' WHERE `entry` = 24248 AND `name_loc4` = 'Copy of Ferocious Bite';

UPDATE `locales_spell` SET `name_loc4` = '未使用任务 - 制作强化魔精包' WHERE `entry` = 24263 AND `name_loc4` = 'UNUSED Quest - Create Empowered Mojo Bundle';

UPDATE `locales_spell` SET `name_loc4` = '稳固' WHERE `entry` = 24286 AND `name_loc4` = 'zzOLDSurefooted';

UPDATE `locales_spell` SET `name_loc4` = '稳固' WHERE `entry` = 24287 AND `name_loc4` = 'zzOLDSurefooted';

UPDATE `locales_spell` SET `name_loc4` = '钓鱼大师备份' WHERE `entry` = 24346 AND `name_loc4` = 'Copy of Master Angler';

UPDATE `locales_spell` SET `name_loc4` = '测试攻击' WHERE `entry` = 24393 AND `name_loc4` = 'Test Strike';

UPDATE `locales_spell` SET `name_loc4` = '强化剔骨/割裂' WHERE `entry` = 24471 AND `name_loc4` = '强化刺骨/割裂';

UPDATE `locales_spell` SET `name_loc4` = '持久耐力' WHERE `entry` = 24533 AND `name_loc4` = '过人耐力';

UPDATE `locales_spell` SET `name_loc4` = '持久耐力' WHERE `entry` = 24534 AND `name_loc4` = '过人耐力';

UPDATE `locales_spell` SET `name_loc4` = '持久耐力' WHERE `entry` = 24535 AND `name_loc4` = '过人耐力';

UPDATE `locales_spell` SET `name_loc4` = '持久耐力' WHERE `entry` = 24536 AND `name_loc4` = '过人耐力';

UPDATE `locales_spell` SET `name_loc4` = '持久耐力' WHERE `entry` = 24537 AND `name_loc4` = '过人耐力';

UPDATE `locales_spell` SET `name_loc4` = '持久耐力' WHERE `entry` = 24538 AND `name_loc4` = '过人耐力';

UPDATE `locales_spell` SET `name_loc4` = '持久耐力' WHERE `entry` = 24539 AND `name_loc4` = '过人耐力';

UPDATE `locales_spell` SET `name_loc4` = '持久耐力' WHERE `entry` = 24540 AND `name_loc4` = '过人耐力';

UPDATE `locales_spell` SET `name_loc4` = '持久耐力' WHERE `entry` = 24541 AND `name_loc4` = '过人耐力';

UPDATE `locales_spell` SET `name_loc4` = '神圣威能之石' WHERE `entry` = 24833 AND `name_loc4` = '神圣力量之石';

UPDATE `locales_spell` SET `name_loc4` = '野性迅捷' WHERE `entry` = 24866 AND `name_loc4` = '豹之迅捷';

UPDATE `locales_spell` SET `name_loc4` = '奔波儿霸' WHERE `entry` = 24939 AND `name_loc4` = '召唤小鱼人';

UPDATE `locales_spell` SET `name_loc4` = '简易营火' WHERE `entry` = 25085 AND `name_loc4` = '明亮篝火';

UPDATE `locales_spell` SET `name_loc4` = '传送熔火之心DND' WHERE `entry` = 25139 AND `name_loc4` = 'Teleport to Molten Core DND';

UPDATE `locales_spell` SET `name_loc4` = '跳舞的小伙伴' WHERE `entry` = 25165 AND `name_loc4` = '小鱼人跳舞';

UPDATE `locales_spell` SET `name_loc4` = '龙尾扫击备份' WHERE `entry` = 25653 AND `name_loc4` = 'Copy of Tail Sweep';

UPDATE `locales_spell` SET `name_loc4` = '光明审判' WHERE `entry` = 25752 AND `name_loc4` = '圣光审判';

UPDATE `locales_spell` SET `name_loc4` = '光明审判' WHERE `entry` = 25753 AND `name_loc4` = '圣光审判';

UPDATE `locales_spell` SET `name_loc4` = '麻痹毒药' WHERE `entry` = 25810 AND `name_loc4` = '迟钝毒药';

UPDATE `locales_spell` SET `name_loc4` = '测试敌人暴击加成 - 10%' WHERE `entry` = 25848 AND `name_loc4` = 'Test Enemy Crit Bonus - 10%';

UPDATE `locales_spell` SET `name_loc4` = '艾露恩的灯笼' WHERE `entry` = 26265 AND `name_loc4` = '制造艾露恩之石';

UPDATE `locales_spell` SET `name_loc4` = '连击触发测试' WHERE `entry` = 26376 AND `name_loc4` = 'Combo PROC Test';

UPDATE `locales_spell` SET `name_loc4` = '召唤冬天爷爷的助手' WHERE `entry` = 26533 AND `name_loc4` = '召唤助手';

UPDATE `locales_spell` SET `name_loc4` = '召唤冬天爷爷的助手' WHERE `entry` = 26534 AND `name_loc4` = '召唤助手';

UPDATE `locales_spell` SET `name_loc4` = '召唤冬天爷爷的小助手' WHERE `entry` = 26536 AND `name_loc4` = '召唤助手';

UPDATE `locales_spell` SET `name_loc4` = '召唤冬天爷爷的小助手' WHERE `entry` = 26537 AND `name_loc4` = '召唤助手';

UPDATE `locales_spell` SET `name_loc4` = '召唤冬天爷爷的小助手' WHERE `entry` = 26541 AND `name_loc4` = '召唤助手';

UPDATE `locales_spell` SET `name_loc4` = '对话模版测试' WHERE `entry` = 26683 AND `name_loc4` = 'Get Gosssip, Test';

UPDATE `locales_spell` SET `name_loc4` = '熊猫宝宝' WHERE `entry` = 26972 AND `name_loc4` = '召唤熊猫宝宝';

UPDATE `locales_spell` SET `name_loc4` = '附魔武器 - 邪恶武器 备份' WHERE `entry` = 27098 AND `name_loc4` = 'Copy of Enchant Weapon - Unholy Weapon';

UPDATE `locales_spell` SET `name_loc4` = '附魔武器 - 邪恶武器 备份' WHERE `entry` = 27100 AND `name_loc4` = 'Copy of Enchant Weapon - Unholy Weapon';

UPDATE `locales_spell` SET `name_loc4` = '附魔武器 - 超强打击 备份' WHERE `entry` = 27106 AND `name_loc4` = 'Copy of Enchant Weapon - Superior Striking';

UPDATE `locales_spell` SET `name_loc4` = '测试附魔武器 - 伤害+5' WHERE `entry` = 27123 AND `name_loc4` = 'zzOLD - QAEnchant Weapon +5 Damage';

UPDATE `locales_spell` SET `name_loc4` = '蓝龙光环备份' WHERE `entry` = 27521 AND `name_loc4` = 'Copy of Aura of the Blue Dragon';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 27611 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '测试附魔双手武器 - 敏捷+15' WHERE `entry` = 27622 AND `name_loc4` = 'zzOLD - QAEnchant 2H Weapon +15 Agility';

UPDATE `locales_spell` SET `name_loc4` = '制造暴风城面包袋备份' WHERE `entry` = 27705 AND `name_loc4` = 'Copy of Create Stormwind Sack of Homemade Bread';

UPDATE `locales_spell` SET `name_loc4` = '制造铁炉堡酒桶备份' WHERE `entry` = 27707 AND `name_loc4` = 'Copy of Create Ironforge Case of Homebrew';

UPDATE `locales_spell` SET `name_loc4` = '强化专注光环备份' WHERE `entry` = 27736 AND `name_loc4` = 'Copy of Improved Concentration Aura';



UPDATE `locales_spell` SET `name_loc4` = '坐骑速度+DND' WHERE `entry` = 27879 AND `name_loc4` = 'Mount Speed+ DND';

UPDATE `locales_spell` SET `name_loc4` = '坐骑速度++DND' WHERE `entry` = 27881 AND `name_loc4` = 'Mount Speed++ DND';

UPDATE `locales_spell` SET `name_loc4` = '坐骑速度+++DND' WHERE `entry` = 27882 AND `name_loc4` = 'Mount Speed+++ DND';

UPDATE `locales_spell` SET `name_loc4` = '埃提耶什 牧师 伤害/治疗' WHERE `entry` = 28155 AND `name_loc4` = 'Atiesh Priest Damage/Healing';

UPDATE `locales_spell` SET `name_loc4` = '赠送友谊手镯备份' WHERE `entry` = 28180 AND `name_loc4` = 'Copy of Give Friendship Bracelet';

UPDATE `locales_spell` SET `name_loc4` = '顺劈斩备份' WHERE `entry` = 28437 AND `name_loc4` = 'Copy of Cleave';

UPDATE `locales_spell` SET `name_loc4` = '群体寒冰箭' WHERE `entry` = 28479 AND `name_loc4` = '冰霜箭';

UPDATE `locales_spell` SET `name_loc4` = '测试痛苦诅咒' WHERE `entry` = 28608 AND `name_loc4` = 'Test Curse of Agony';

UPDATE `locales_spell` SET `name_loc4` = '攻击强度-野性(+305)' WHERE `entry` = 28717 AND `name_loc4` = '攻击强度 - 野性（+305）';

UPDATE `locales_spell` SET `name_loc4` = '水之护盾加成' WHERE `entry` = 28821 AND `name_loc4` = '闪电之盾';

UPDATE `locales_spell` SET `name_loc4` = '强化次级治疗波' WHERE `entry` = 28856 AND `name_loc4` = '次级治疗波强化';

UPDATE `locales_spell` SET `name_loc4` = '召唤匹德菲特备份' WHERE `entry` = 28960 AND `name_loc4` = 'Copy of Summon Peddlefeet';

UPDATE `locales_spell` SET `name_loc4` = '黑色死亡战马' WHERE `entry` = 29059 AND `name_loc4` = '骷髅马';

UPDATE `locales_spell` SET `name_loc4` = '元素之赐' WHERE `entry` = 29082 AND `name_loc4` = '武器掌握';

UPDATE `locales_spell` SET `name_loc4` = '元素之赐' WHERE `entry` = 29084 AND `name_loc4` = '武器掌握';

UPDATE `locales_spell` SET `name_loc4` = '元素之赐' WHERE `entry` = 29086 AND `name_loc4` = '武器掌握';

UPDATE `locales_spell` SET `name_loc4` = '元素之赐' WHERE `entry` = 29087 AND `name_loc4` = '武器掌握';

UPDATE `locales_spell` SET `name_loc4` = '元素之赐' WHERE `entry` = 29088 AND `name_loc4` = '武器掌握';

UPDATE `locales_spell` SET `name_loc4` = '自然之赐' WHERE `entry` = 29187 AND `name_loc4` = '治疗之赐';

UPDATE `locales_spell` SET `name_loc4` = '自然之赐' WHERE `entry` = 29189 AND `name_loc4` = '治疗之赐';

UPDATE `locales_spell` SET `name_loc4` = '自然之赐' WHERE `entry` = 29191 AND `name_loc4` = '治疗之赐';

UPDATE `locales_spell` SET `name_loc4` = '服务器法术' WHERE `entry` = 29218 AND `name_loc4` = 'ZZOLD';

UPDATE `locales_spell` SET `name_loc4` = '测试工兵炸药' WHERE `entry` = 29324 AND `name_loc4` = 'Test Sapper Charge';

UPDATE `locales_spell` SET `name_loc4` = '测试灼烧' WHERE `entry` = 29515 AND `name_loc4` = 'TEST Scorch';

UPDATE `locales_spell` SET `name_loc4` = '调试冰霜法术' WHERE `entry` = 29607 AND `name_loc4` = 'Debug Frost Spell';

UPDATE `locales_spell` SET `name_loc4` = '紫色烟花备份' WHERE `entry` = 30163 AND `name_loc4` = 'Copy of Rocket, PURPLE';

UPDATE `locales_spell` SET `name_loc4` = '高级珠宝匠' WHERE `entry` = 30225 AND `name_loc4` = '沉默';

UPDATE `locales_spell` SET `name_loc4` = '解除诅咒' WHERE `entry` = 30281 AND `name_loc4` = '移处诅咒';

UPDATE `locales_spell` SET `name_loc4` = '提高法术命中几率' WHERE `entry` = 30440 AND `name_loc4` = '提高法术爆击率';

UPDATE `locales_spell` SET `name_loc4` = '提高法术命中几率' WHERE `entry` = 30441 AND `name_loc4` = '提高法术爆击率';

UPDATE `locales_spell` SET `name_loc4` = '致命' WHERE `entry` = 30902 AND `name_loc4` = '极致';

UPDATE `locales_spell` SET `name_loc4` = '致命' WHERE `entry` = 30903 AND `name_loc4` = '极致';

UPDATE `locales_spell` SET `name_loc4` = '致命' WHERE `entry` = 30904 AND `name_loc4` = '极致';

UPDATE `locales_spell` SET `name_loc4` = '致命' WHERE `entry` = 30905 AND `name_loc4` = '极致';

UPDATE `locales_spell` SET `name_loc4` = '致命' WHERE `entry` = 30906 AND `name_loc4` = '极致';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 31016 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '剔骨' WHERE `entry` = 31017 AND `name_loc4` = '刺骨';

UPDATE `locales_spell` SET `name_loc4` = '调试：下一个外观ID' WHERE `entry` = 56043 AND `name_loc4` = 'Debug: Next DisplayID';

UPDATE `locales_spell` SET `name_loc4` = '调试：上一个外观ID' WHERE `entry` = 56044 AND `name_loc4` = 'Debug: Previous DisplayID';

UPDATE `locales_spell` SET `name_loc4` = '调试：重置外观ID' WHERE `entry` = 56045 AND `name_loc4` = 'Debug: Reset DisplayID';

UPDATE `locales_spell` SET `name_loc4` = '切换GM飞行' WHERE `entry` = 56046 AND `name_loc4` = 'Toggle GM Flight Mode';

UPDATE `locales_spell` SET `name_loc4` = '切换GM隐形' WHERE `entry` = 56047 AND `name_loc4` = 'Toggle GM Visiblity';

UPDATE `locales_spell` SET `name_loc4` = '预留GM技能' WHERE `entry` = 56048 AND `name_loc4` = 'Placeholder Game Master Spell';

UPDATE `locales_spell` SET `name_loc4` = '切换GM无敌' WHERE `entry` = 56050 AND `name_loc4` = 'Toggle GM Immortality';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 3' WHERE `entry` = 706 AND `nameSubtext_loc4` = '等级 1';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 3' WHERE `entry` = 733 AND `nameSubtext_loc4` = '等级 1';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 4' WHERE `entry` = 1086 AND `nameSubtext_loc4` = '等级 2';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 4' WHERE `entry` = 1087 AND `nameSubtext_loc4` = '等级 2';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 3' WHERE `entry` = 1384 AND `nameSubtext_loc4` = '等级 1';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 4' WHERE `entry` = 1404 AND `nameSubtext_loc4` = '等级 2';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 5' WHERE `entry` = 11733 AND `nameSubtext_loc4` = '等级 3';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 6' WHERE `entry` = 11734 AND `nameSubtext_loc4` = '等级 4';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 7' WHERE `entry` = 11735 AND `nameSubtext_loc4` = '等级 5';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 5' WHERE `entry` = 11736 AND `nameSubtext_loc4` = '等级 3';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 6' WHERE `entry` = 11737 AND `nameSubtext_loc4` = '等级 4';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 7' WHERE `entry` = 11738 AND `nameSubtext_loc4` = '等级 5';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '目标' WHERE `entry` = 15258 AND `nameSubtext_loc4` = '等级 1';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 4' WHERE `entry` = 16162 AND `nameSubtext_loc4` = '等级 1';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 5' WHERE `entry` = 16163 AND `nameSubtext_loc4` = '等级 1';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 2' WHERE `entry` = 22568 AND `nameSubtext_loc4` = '等级 1';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 2' WHERE `entry` = 22569 AND `nameSubtext_loc4` = '等级 1';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 3' WHERE `entry` = 22827 AND `nameSubtext_loc4` = '等级 2';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 4' WHERE `entry` = 22828 AND `nameSubtext_loc4` = '等级 3';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 5' WHERE `entry` = 22829 AND `nameSubtext_loc4` = '等级 4';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 3' WHERE `entry` = 22830 AND `nameSubtext_loc4` = '等级 2';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 4' WHERE `entry` = 22831 AND `nameSubtext_loc4` = '等级 3';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 5' WHERE `entry` = 22832 AND `nameSubtext_loc4` = '等级 4';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '测试技能' WHERE `entry` = 26748 AND `nameSubtext_loc4` = '等级 1';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '被动' WHERE `entry` = 30895 AND `nameSubtext_loc4` = '等级 2';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 6' WHERE `entry` = 31018 AND `nameSubtext_loc4` = '等级 5';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '等级 6' WHERE `entry` = 31020 AND `nameSubtext_loc4` = '等级 5';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '测试' WHERE `entry` = 52250 AND `nameSubtext_loc4` = 'Test';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '测试' WHERE `entry` = 52251 AND `nameSubtext_loc4` = 'Test';

UPDATE `locales_spell` SET `nameSubtext_loc4` = '测试' WHERE `entry` = 52252 AND `nameSubtext_loc4` = 'Test';

UPDATE `locales_spell` SET `description_loc4` = '背刺目标，对其造成近战伤害的$s2%再加15点伤害，必须在目标背后发动，潜行者的主手中必须有一把武器。奖励$s3个连击点数。' WHERE `entry` = 53 AND `description_loc4` = '背刺目标，对其造成武器伤害的$s2%再加15点伤害，必须在目标背后发动，盗贼的主手中必须有一把武器。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '使用你的盾牌重击目标，对其造成$s2点伤害，并使其无法施放该系的所有法术，持续$d。' WHERE `entry` = 72 AND `description_loc4` = '使用你的盾牌重击目标，对其造成$s2点伤害，并使其无法施放法术，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出闪电箭，对其造成$s1点自然伤害。' WHERE `entry` = 403 AND `description_loc4` = '向目标射出闪电箭，对其造成$s点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '让你免受一切物理和法术攻击，持续$d，但是在这段时间内你不能攻击或者使用物理技能。在使用圣佑术之后，圣盾术、保护之手或圣佑术在$25771d之内无法作用在你身上。' WHERE `entry` = 498 AND `description_loc4` = '让你免受一切物理和法术攻击，持续$d，但是在这段时间内你不能攻击或者使用非法术类的能力。在使用圣佑术之后，圣盾术、保护祝福或圣佑术在$25771d之内无法作用在你身上。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出闪电箭，对其造成$s1点自然伤害。' WHERE `entry` = 529 AND `description_loc4` = '向目标射出闪电箭，对其造成$s点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出闪电箭，对其造成$s1点自然伤害。' WHERE `entry` = 548 AND `description_loc4` = '向目标射出闪电箭，对其造成$s点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '渐渐消失，使你的威胁值暂时降低$s1%外加$s2点，使敌人不再攻击你，持续$d。' WHERE `entry` = 586 AND `description_loc4` = '渐渐消失，使敌人不再攻击你，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '圣洁的能量充满施法者的体内，使护甲值提高$s1点，法术伤害提高$s2。牧师每受到一次近战或远程伤害，就消耗一层心灵之火效果。持续$d，或者直到消耗了$n次效果。' WHERE `entry` = 588 AND `description_loc4` = '圣洁的能量充满施法者的体内，使$g他:她;的防御值提高$s1点。每次近战或远程伤害都会使牧师消耗一次防护能量。效果可持续$d，或在$n次防护之后消失。';

UPDATE `locales_spell` SET `description_loc4` = '强大的祷言，可以治疗目标周围半径$a1码范围内的所有小队成员。' WHERE `entry` = 596 AND `description_loc4` = '强大的祷言，可以治疗附近半径$a1码范围内的所有小队成员。';

UPDATE `locales_spell` SET `description_loc4` = '圣洁的能量充满施法者的体内，使护甲值提高$s1点，法术伤害提高$s2。牧师每受到一次近战或远程伤害，就消耗一层心灵之火效果。持续$d，或者直到消耗了$n次效果。' WHERE `entry` = 602 AND `description_loc4` = '圣洁的能量充满施法者的体内，使$g他:她;的防御值提高$s1点。每次近战或远程伤害都会使牧师消耗一次防护能量。效果可持续$d，或在$n次防护之后消失。';

UPDATE `locales_spell` SET `description_loc4` = '降低施放于目标小队成员身上的魔法效果，使其受到的法术伤害降低$8451s1%，受到治疗法术所恢复生命值的效果降低$8451s2%，持续$8451d。' WHERE `entry` = 604 AND `description_loc4` = '降低施放于目标小队成员身上的魔法效果，使其受到的法术伤害降低最多$s1点，治疗法术恢复生命值的效果降低最多$s2点，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成神圣伤害，造成$s1点武器伤害加上$s2点 额外伤害，并为你和$51875a1码范围内最多$51875x1名队友恢复$51875s2点生命值和$51875s1点法力值。你自身受到的治疗效果会降低一半。' WHERE `entry` = 678 AND `description_loc4` = '将圣洁的能量灌入武器，使你的下一次攻击造成$s1点额外伤害，且所有伤害都被计为神圣属性的伤害。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成神圣伤害，造成$s1点武器伤害加上$s2点 额外伤害，并为你和$51324a1码范围内最多$51324x1名队友恢复$51324s2点生命值和$51324s1点法力值。你自身受到的治疗效果会降低一半。' WHERE `entry` = 679 AND `description_loc4` = '将圣洁的能量灌入武器，使你的下一次攻击造成$s1点额外伤害，且所有伤害都被计为神圣属性的伤害。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成神圣伤害，造成$s1点武器伤害加上$s2点 额外伤害，并为你和$51877a1码范围内最多$51877x1名队友恢复$51877s2点生命值和$51877s1点法力值。你自身受到的治疗效果会降低一半。' WHERE `entry` = 680 AND `description_loc4` = '将圣洁的能量灌入武器，使你的下一次攻击造成$s1点额外伤害，且所有伤害都被计为神圣属性的伤害。';

UPDATE `locales_spell` SET `description_loc4` = '在$d内将目标$*5;s1点生命值转移给施法者。' WHERE `entry` = 689 AND `description_loc4` = '每秒钟吸取目标$s1点生命值，并将其转移给施法者，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '在$d内将目标$*5;s1点生命值转移给施法者。' WHERE `entry` = 699 AND `description_loc4` = '每秒钟吸取目标$s1点生命值，并将其转移给施法者，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '使目标的攻击速度降低$s1%，持续$d。每个术士只能对一个目标施加一种诅咒。' WHERE `entry` = 702 AND `description_loc4` = '目标所能造成的伤害降低$s1点，持续$d。每个术士只能对一个目标施加一种诅咒，且同类诅咒不能叠加。';

UPDATE `locales_spell` SET `description_loc4` = '在$d内将目标$*5;s1点生命值转移给施法者。' WHERE `entry` = 709 AND `description_loc4` = '每秒钟吸取目标$s1点生命值，并将其转移给施法者，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会施放魔甲术（等级 2）。' WHERE `entry` = 722 AND `description_loc4` = '教你学会施放恶魔皮肤（等级 2）。';

UPDATE `locales_spell` SET `description_loc4` = '在目标位置制造一个光明之泉。每当你施放次级治疗术、快速治疗、治疗术或强效治疗术时，光明之泉会治疗$a2码范围内的友方目标，治疗量为初始治疗法术的$s2%。每个目标每$52961d只能享受一次此效果，光明之泉持续$d或治疗$n次后消失。' WHERE `entry` = 724 AND `description_loc4` = '在牧师身边制造一个光明之泉。你所属的小队或团队中的友方单位可以点击光明之泉，在$7001d内恢复$7001o1点生命值。被攻击会中断这个效果。光明之泉在$d或者在被使用5次之后消失。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会施放魔甲术（等级 3）。' WHERE `entry` = 733 AND `description_loc4` = '教你学会施放魔甲术（等级 1）。';

UPDATE `locales_spell` SET `description_loc4` = '使附近所有团队成员每秒钟恢复$s1点生命值，持续$d。德鲁伊必须不断引导能量以维持法术。' WHERE `entry` = 740 AND `description_loc4` = '使附近所有小队成员每$t1秒钟恢复$s1点生命值，持续$d。德鲁伊必须不断引导能量以维持法术。';

UPDATE `locales_spell` SET `description_loc4` = '引导此法术时，每秒将$s1点生命值转移给你的恶魔，持续$d。' WHERE `entry` = 755 AND `description_loc4` = '只要施法者保持着引导法术的状态，就会每秒钟将$s1点生命值转移给施法者的宠物，最多持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '尝试从敌人面前逃脱，降低威胁值。逃脱成功则会停止攻击。' WHERE `entry` = 781 AND `description_loc4` = '尝试从敌人面前逃脱，降低威胁值。逃脱成功则脱离战斗状态。';

UPDATE `locales_spell` SET `description_loc4` = '横扫攻击，对目标和它身边最近的一个敌人造成近战伤害再加上$s1点伤害。' WHERE `entry` = 845 AND `description_loc4` = '横扫攻击，对目标和它身边最近的一个敌人造成武器伤害再加上$s1点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '对单一亡灵或恶魔目标造成$s1点神圣伤害，这个法术产生较低的威胁值。' WHERE `entry` = 879 AND `description_loc4` = '对单一亡灵或恶魔目标造成$s1点神圣伤害。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出闪电箭，对其造成$s1点自然伤害。' WHERE `entry` = 915 AND `description_loc4` = '向目标射出闪电箭，对其造成$s点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出闪电箭，对其造成$s1点自然伤害。' WHERE `entry` = 943 AND `description_loc4` = '向目标射出闪电箭，对其造成$s点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '给目标施加痛苦的诅咒，使其在$d内受到$*12;s1点暗影伤害。这种伤害在初期会缓慢生效，但是会在作用效果期间不断加速，直到结束。每个术士只能对一个目标施加一种诅咒。' WHERE `entry` = 980 AND `description_loc4` = '给目标施加痛苦的诅咒，使其在$d内受到$o1点伤害。这种伤害在初期会缓慢生效，但是会在作用效果期间不断加速，直到结束。每个术士只能对一个目标施加一种诅咒，且同类诅咒不能叠加。';

UPDATE `locales_spell` SET `description_loc4` = '强大的祷言，可以治疗目标周围半径$a1码范围内的所有小队成员。' WHERE `entry` = 996 AND `description_loc4` = '强大的祷言，可以治疗附近半径$a1码范围内的所有小队成员。';

UPDATE `locales_spell` SET `description_loc4` = '圣洁的能量充满施法者的体内，使护甲值提高$s1点，法术伤害提高$s2。牧师每受到一次近战或远程伤害，就消耗一层心灵之火效果。持续$d，或者直到消耗了$n次效果。' WHERE `entry` = 1006 AND `description_loc4` = '圣洁的能量充满施法者的体内，使$g他:她;的防御值提高$s1点。每次近战或远程伤害都会使牧师消耗一次防护能量。效果可持续$d，或在$n次防护之后消失。';

UPDATE `locales_spell` SET `description_loc4` = '增强施放于目标小队成员身上的魔法效果，使其受到的法术伤害提高$10169s1%，受到治疗法术所恢复的生命值提高$10169s2%，持续$10169d。' WHERE `entry` = 1008 AND `description_loc4` = '增强施放于目标小队成员身上的魔法效果，使其受到的法术伤害最多提高$s1点，治疗法术所恢复的生命值最多提高$s2点，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '给目标施加痛苦的诅咒，使其在$d内受到$*12;s1点暗影伤害。这种伤害在初期会缓慢生效，但是会在作用效果期间不断加速，直到结束。每个术士只能对一个目标施加一种诅咒。' WHERE `entry` = 1014 AND `description_loc4` = '给目标施加痛苦的诅咒，使其在$d内受到$o1点伤害。这种伤害在初期会缓慢生效，但是会在作用效果期间不断加速，直到结束。每个术士只能对一个目标施加一种诅咒，且同类诅咒不能叠加。';

UPDATE `locales_spell` SET `description_loc4` = '被施加此圣手效果的队友将对一切物理攻击免疫，同时也无法攻击或使用物理技能，持续$d。每个圣骑士在同一时间内只能给目标施加一种圣手效果，同类型的圣手效果不能重叠。在被保护之后，圣盾术、保护之手或圣佑术在$25771d之内无法作用在该目标身上。' WHERE `entry` = 1022 AND `description_loc4` = '被施加此圣印的队友将对一切物理攻击免疫，同时也无法攻击或使用物理技能，持续$d。每个圣骑士在同一时间内只能给目标施加一种祝福，同类型的祝福不能重叠。在被保护之后，圣盾术、保护祝福或圣佑术在$25771d之内无法作用在该目标身上。';

UPDATE `locales_spell` SET `description_loc4` = '为友方目标施加自由之手，使其免疫任何移动限制效果，持续$d。每个圣骑士在同一时间内只能给目标施加一种圣手效果，同类型的圣手效果不能重叠。' WHERE `entry` = 1044 AND `description_loc4` = '为友方目标施加祝福，使其免疫任何减缓移动速度的法术和技能效果，持续$d。每个圣骑士在同一时间内只能给目标施加一种祝福，同类型的祝福不能重叠。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会施放魔甲术（等级 4）。' WHERE `entry` = 1087 AND `description_loc4` = '教你学会施放魔甲术（等级 2）。';

UPDATE `locales_spell` SET `description_loc4` = '奴役等级不高于$m1级的恶魔，令其听从你的命令。被奴役的恶魔的攻击间隔延长$s2%，施法速度降低$s3%，受到治疗效果降低$58184s1%。奴役效果最多持续$d。如果你反复奴役同一个恶魔，它摆脱控制的几率会越来越大。' WHERE `entry` = 1098 AND `description_loc4` = '奴役等级不高于$m1级的恶魔，令其听从你的命令。被奴役的恶魔的攻击间隔延长$s2%，施法速度降低$s3%。奴役效果最多持续$d。如果你反复奴役同一个恶魔，它摆脱控制的几率会越来越大。';

UPDATE `locales_spell` SET `description_loc4` = '目标所能造成的伤害降低$s1点，持续$d。每个术士只能对一个目标施加一种诅咒。' WHERE `entry` = 1108 AND `description_loc4` = '目标所能造成的伤害降低$s1点，持续$d。每个术士只能对一个目标施加一种诅咒，且同类诅咒不能叠加。';

UPDATE `locales_spell` SET `description_loc4` = '吸取目标的灵魂，在$d内对其造成累计$*6;s2点暗影伤害。如果目标在被吸取灵魂的过程中死亡，且施法者因此获得经验值或荣誉，则施法者可以得到一块灵魂碎片。灵魂碎片是施放其它一些法术所必需的材料。' WHERE `entry` = 1120 AND `description_loc4` = '吸取目标的灵魂，在$d内对其造成累计$o2点暗影伤害。如果目标在被吸取灵魂的过程中死亡，且施法者因此获得经验值或荣誉，则施法者可以得到一块灵魂碎片。灵魂碎片是施放其它一些法术所必需的材料。';

UPDATE `locales_spell` SET `description_loc4` = '从扭曲虚空中召来一颗流星，对其着陆区域的所有敌人造成$22699s1点火焰伤害，并使它们昏迷$20310d。一个巨大的地狱火恶魔将从着陆点出现，并被施法者控制$53222d。一旦失去控制，地狱火就会攻击施法者，直到其中一方死亡。' WHERE `entry` = 1122 AND `description_loc4` = '从扭曲虚空中召来一颗流星，对其着陆区域的所有敌人造成$22699s1点火焰伤害，并使它们昏迷$20310d。一个巨大的地狱火恶魔将从着陆点出现，并被施法者控制$20882d。如果控制失效，则施法者必须奴役地狱火才能继续指挥它。只能在户外使用。';

UPDATE `locales_spell` SET `description_loc4` = '猛击敌人，对其造成$45963s1%的武器伤害，可在移动时使用。' WHERE `entry` = 1464 AND `description_loc4` = '猛击敌人，对其造成武器伤害再加上$s1点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '立即攻击敌人，造成$s2%的武器伤害加上额外的$s1点伤害。如果你装备了双武器，现在会同时使用两把武器进行攻击。' WHERE `entry` = 1495 AND `description_loc4` = '反击敌人，对其造成$s1点伤害。只能在你成功躲闪之后使用。';

UPDATE `locales_spell` SET `description_loc4` = '增加怒气$s2，而不是进行普通攻击。' WHERE `entry` = 1635 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '使目标的攻击速度降低$s1%，持续$d。' WHERE `entry` = 1645 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '使目标的攻击速度降低$s1%，持续$d。' WHERE `entry` = 1648 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '像旋风一般挥舞手中的武器，攻击半径$a1码范围内的最多$i个敌人，对它们造成近战伤害。' WHERE `entry` = 1680 AND `description_loc4` = '像旋风一般挥舞手中的武器，攻击半径$a1码范围内的最多$i个敌人，对它们造成武器伤害。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成近战伤害再加上$s1点额外伤害，奖励$s2个连击点数。' WHERE `entry` = 1752 AND `description_loc4` = '对目标造成普通武器伤害再加上$s1点额外伤害，奖励$s2个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成近战伤害再加上$s1点额外伤害，奖励$s2个连击点数。' WHERE `entry` = 1757 AND `description_loc4` = '对目标造成普通武器伤害再加上$s1点额外伤害，奖励$s2个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成近战伤害再加上$s1点额外伤害，奖励$s2个连击点数。' WHERE `entry` = 1758 AND `description_loc4` = '对目标造成普通武器伤害再加上$s1点额外伤害，奖励$s2个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成近战伤害再加上$s1点额外伤害，奖励$s2个连击点数。' WHERE `entry` = 1759 AND `description_loc4` = '对目标造成普通武器伤害再加上$s1点额外伤害，奖励$s2个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成近战伤害再加上$s1点额外伤害，奖励$s2个连击点数。' WHERE `entry` = 1760 AND `description_loc4` = '对目标造成普通武器伤害再加上$s1点额外伤害，奖励$s2个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成$s1点伤害，并在$d内造成总计$o2点额外伤害。伤害受到你的攻击强度加成，奖励$s3个连击点数。' WHERE `entry` = 1822 AND `description_loc4` = '对目标造成$s1点伤害，并在$d内造成总计$o2点额外伤害。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成$s1点伤害，并在$d内造成总计$o2点额外伤害。伤害受到你的攻击强度加成，奖励$s3个连击点数。' WHERE `entry` = 1823 AND `description_loc4` = '对目标造成$s1点伤害，并在$d内造成总计$o2点额外伤害。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成$s1点伤害，并在$d内造成总计$o2点额外伤害。伤害受到你的攻击强度加成，奖励$s3个连击点数。' WHERE `entry` = 1824 AND `description_loc4` = '对目标造成$s1点伤害，并在$d内造成总计$o2点额外伤害。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成神圣伤害，造成$s1点武器伤害加上$s2点 额外伤害，并为你和$51876a1码范围内最多$51876x1名队友恢复$51876s2点生命值和$51876s1点法力值。你自身受到的治疗效果会降低一半。' WHERE `entry` = 1866 AND `description_loc4` = '将圣洁的能量灌入武器，使你的下一次攻击造成$s1点额外伤害，且所有伤害都被计为神圣属性的伤害。';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2229 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2234 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2238 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2242 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2246 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2254 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2258 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2267 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2268 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2276 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2277 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2281 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2282 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2285 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2286 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2289 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2290 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2297 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2298 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2301 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2302 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2305 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2306 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2309 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2310 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2317 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2318 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2321 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2322 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2325 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 2326 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '教你学会配制初级坚韧药剂。' WHERE `entry` = 2363 AND `description_loc4` = '教你学会配制坚韧药剂。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成神圣伤害，造成$s1点武器伤害加上$s2点 额外伤害，并为你和$51878a1码范围内最多$51878x1名队友恢复$51878s2点生命值和$51878s1点法力值。你自身受到的治疗效果会降低一半。' WHERE `entry` = 2495 AND `description_loc4` = '将圣洁的能量灌入武器，使你的下一次攻击造成$s1点额外伤害，且所有伤害都被计为神圣属性的伤害。';

UPDATE `locales_spell` SET `description_loc4` = '背刺目标，对其造成近战伤害的$s2%再加30点伤害，必须在目标背后发动，潜行者的主手中必须有一把武器。奖励$s3个连击点数。' WHERE `entry` = 2589 AND `description_loc4` = '背刺目标，对其造成武器伤害的$s2%再加30点伤害，必须在目标背后发动，盗贼的主手中必须有一把武器。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '背刺目标，对其造成近战伤害的$s2%再加48点伤害，必须在目标背后发动，潜行者的主手中必须有一把武器。奖励$s3个连击点数。' WHERE `entry` = 2590 AND `description_loc4` = '背刺目标，对其造成武器伤害的$s2%再加48点伤害，必须在目标背后发动，盗贼的主手中必须有一把武器。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '背刺目标，对其造成近战伤害的$s2%再加69点伤害，必须在目标背后发动，潜行者的主手中必须有一把武器。奖励$s3个连击点数。' WHERE `entry` = 2591 AND `description_loc4` = '背刺目标，对其造成武器伤害的$s2%再加69点伤害，必须在目标背后发动，盗贼的主手中必须有一把武器。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '使你受到的远程攻击伤害减少$s1，躲闪几率提高$s2%，持续$d。此效果期间成功躲避近战攻击将恢复法力值，数值等于你的敏捷值。' WHERE `entry` = 2651 AND `description_loc4` = '使你受到的远程攻击伤害减少$s1，躲闪几率提高$s2%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '驱散目标身上的$m1个诅咒。' WHERE `entry` = 2783 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '使友方目标的火焰抗性提高$s1点，持续$d。' WHERE `entry` = 2866 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '一次强力的攻击，造成$s2%的武器伤害，外加$s1的额外伤害。' WHERE `entry` = 2973 AND `description_loc4` = '强力的攻击，使近战攻击所造成的伤害提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '对敌人造成$s2点武器伤害，并使其移动速度降低$s1%，持续$d。' WHERE `entry` = 2974 AND `description_loc4` = '对敌人造成$s2点伤害，并使其移动速度降低$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '钉刺目标，使其造成的物理伤害降低$51509s1%，攻击速度降低$s2%，持续$d。每个猎人在同一时间内只能对一个目标使用一种钉刺，且同类钉刺无法叠加。' WHERE `entry` = 3043 AND `description_loc4` = '钉刺目标，使其力量和敏捷均降低$s1点，持续$d。每个猎人在同一时间内只能对一个目标使用一种钉刺，且同类钉刺无法叠加。';

UPDATE `locales_spell` SET `description_loc4` = '迅速射出一箭，对敌人造成$s2%的远程武器伤害和额外的$s1点奥术伤害。' WHERE `entry` = 3044 AND `description_loc4` = '迅速射出一箭，对敌人造成$s1点奥术伤害。';

UPDATE `locales_spell` SET `description_loc4` = '近战和远程攻击速度提高$s1%，并使瞄准射击和稳固射击的施法时间减少s2%，持续$d。' WHERE `entry` = 3045 AND `description_loc4` = '射击时间缩短$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会施放暗影箭（等级 1）。' WHERE `entry` = 3098 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '教你学会配制抗毒药水。' WHERE `entry` = 3182 AND `description_loc4` = '教你学会配制抗毒药剂。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会配制坚韧药剂。' WHERE `entry` = 3455 AND `description_loc4` = '教你学会配制强力坚韧药剂。';

UPDATE `locales_spell` SET `description_loc4` = '赋予近战攻击更高的威力，造成武器伤害和$s1点额外伤害。' WHERE `entry` = 3597 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '引导此法术时，每秒将$s1点生命值转移给你的恶魔，持续$d。' WHERE `entry` = 3698 AND `description_loc4` = '只要施法者保持着引导法术的状态，就会每秒钟将$s1点生命值转移给施法者的宠物，最多持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '引导此法术时，每秒将$s1点生命值转移给你的恶魔，持续$d。' WHERE `entry` = 3699 AND `description_loc4` = '只要施法者保持着引导法术的状态，就会每秒钟将$s1点生命值转移给施法者的宠物，最多持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '引导此法术时，每秒将$s1点生命值转移给你的恶魔，持续$d。' WHERE `entry` = 3700 AND `description_loc4` = '只要施法者保持着引导法术的状态，就会每秒钟将$s1点生命值转移给施法者的宠物，最多持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '耐力提高$5041s1点。' WHERE `entry` = 5048 AND `description_loc4` = '耐力提高$5401s1点。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出数枚奥术飞弹，对其每$7268d造成$7268s1点伤害，持续$d。' WHERE `entry` = 5143 AND `description_loc4` = '向目标射出数枚奥术飞弹，对其造成每秒$7268s1点伤害，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出数枚奥术飞弹，对其每$7269d造成$7269s1点伤害，持续$d。' WHERE `entry` = 5144 AND `description_loc4` = '向目标射出数枚奥术飞弹，对其造成每秒$7269s1点伤害，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出数枚奥术飞弹，对其每$7270d造成$7270s1点伤害，持续$d。' WHERE `entry` = 5145 AND `description_loc4` = '向目标射出数枚奥术飞弹，对其造成每秒$7270s1点伤害，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '护甲值提高$s1点，冰霜抗性提高$s2点。' WHERE `entry` = 5151 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '使你对目标造成的伤害提高$s1点，且每秒回复$t2点能量值，持续$d。' WHERE `entry` = 5217 AND `description_loc4` = '使你对目标造成的伤害提高$s1点，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '撕扯目标，对其造成武器伤害的$s2%再加上$s1点伤害，必须在目标背后发动。奖励$s3个连击点数。' WHERE `entry` = 5221 AND `description_loc4` = '撕扯目标，对其造成武器伤害的$s2%再加上54点伤害，必须在目标背后发动。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '造成致命一击的几率提高$s1%。' WHERE `entry` = 5258 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '使你的单手斧造成致命一击的几率提高2%。' WHERE `entry` = 5524 AND `description_loc4` = '使你的单手斧造成致命一击的几率提高1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的单手斧造成致命一击的几率提高2%。' WHERE `entry` = 5525 AND `description_loc4` = '使你的单手斧造成致命一击的几率提高1%。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成神圣伤害，造成$s1点武器伤害加上$s2点 额外伤害，并为你和$51879a1码范围内最多$51879x1名队友恢复$51879s2点生命值和$51879s1点法力值。你自身受到的治疗效果会降低一半。' WHERE `entry` = 5569 AND `description_loc4` = '将圣洁的能量灌入武器，使你的下一次攻击造成$s1点额外伤害，且所有伤害都被计为神圣属性的伤害。';

UPDATE `locales_spell` SET `description_loc4` = '让你免受一切物理和法术攻击，持续$d，但是在这段时间内你不能攻击或者使用物理技能。在使用圣佑术之后，圣盾术、保护之手或圣佑术在$25771d之内无法作用在你身上。' WHERE `entry` = 5573 AND `description_loc4` = '让你免受一切物理和法术攻击，持续$d，但是在这段时间内你不能攻击或者使用非法术类的能力。在使用圣佑术之后，圣盾术、保护祝福或圣佑术在$25771d之内无法作用在你身上。';

UPDATE `locales_spell` SET `description_loc4` = '对施法者应用测试脚本，非常好！' WHERE `entry` = 5581 AND `description_loc4` = 'Applies a test script to the caster.  Exciting!';

UPDATE `locales_spell` SET `description_loc4` = '被施加此圣手效果的队友将对一切物理攻击免疫，同时也无法攻击或使用物理技能，持续$d。每个圣骑士在同一时间内只能给目标施加一种圣手效果，同类型的圣手效果不能重叠。在被保护之后，圣盾术、保护之手或圣佑术在$25771d之内无法作用在该目标身上。' WHERE `entry` = 5599 AND `description_loc4` = '被施加此圣印的队友将对一切物理攻击免疫，同时也无法攻击或使用物理技能，持续$d。每个圣骑士在同一时间内只能给目标施加一种祝福，同类型的祝福不能重叠。在被保护之后，圣盾术、保护祝福或圣佑术在$25771d之内无法作用在该目标身上。';

UPDATE `locales_spell` SET `description_loc4` = '对单一亡灵或恶魔目标造成$s1点神圣伤害，这个法术产生较低的威胁值。' WHERE `entry` = 5614 AND `description_loc4` = '对单一亡灵或恶魔目标造成$s1点神圣伤害。';

UPDATE `locales_spell` SET `description_loc4` = '对单一亡灵或恶魔目标造成$s1点神圣伤害，这个法术产生较低的威胁值。' WHERE `entry` = 5615 AND `description_loc4` = '对单一亡灵或恶魔目标造成$s1点神圣伤害。';

UPDATE `locales_spell` SET `description_loc4` = '使目标感受灼热的痛苦，对其造成$s1点火焰伤害。' WHERE `entry` = 5676 AND `description_loc4` = '使目标感受灼热的痛苦，对其造成$s1点火焰伤害，并产生很高的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '使目标的移动速度降低$s1%，攻击速度降低$s2%，持续$d。' WHERE `entry` = 5737 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '以生命为代价填充空的灵魂石。' WHERE `entry` = 5739 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '使你的圣光术和圣光闪现造成致命一击的几率提高$s1%。' WHERE `entry` = 5923 AND `description_loc4` = '使你的神圣法术造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的圣光术和圣光闪现造成致命一击的几率提高$s1%。' WHERE `entry` = 5924 AND `description_loc4` = '使你的神圣法术造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的圣光术和圣光闪现造成致命一击的几率提高$s1%。' WHERE `entry` = 5925 AND `description_loc4` = '使你的神圣法术造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出闪电箭，对其造成$s1点自然伤害。' WHERE `entry` = 6041 AND `description_loc4` = '向目标射出闪电箭，对其造成$s点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '使你的魔杖造成的伤害提高$s1%，魔杖的命中几率增加$s2%。你的魔杖攻击成功造成伤害后有一定几率让你回复$51976m1法力值。' WHERE `entry` = 6057 AND `description_loc4` = '使你的魔杖造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的魔杖造成的伤害提高$s1%，魔杖的命中几率增加$s2%。你的魔杖攻击成功造成伤害后有一定几率让你回复$51976m1法力值。

UPDATE `locales_spell` SET `description_loc4` = '格挡几率提高$s1%，但施法者无法攻击，持续$d。' WHERE `entry` = 6184 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '目标所能造成的伤害降低$s1点，持续$d。每个术士只能对一个目标施加一种诅咒。' WHERE `entry` = 6205 AND `description_loc4` = '目标所能造成的伤害降低$s1点，持续$d。每个术士只能对一个目标施加一种诅咒，且同类诅咒不能叠加。';

UPDATE `locales_spell` SET `description_loc4` = '给目标施加痛苦的诅咒，使其在$d内受到$*12;s1点暗影伤害。这种伤害在初期会缓慢生效，但是会在作用效果期间不断加速，直到结束。每个术士只能对一个目标施加一种诅咒。' WHERE `entry` = 6217 AND `description_loc4` = '给目标施加痛苦的诅咒，使其在$d内受到$o1点伤害。这种伤害在初期会缓慢生效，但是会在作用效果期间不断加速，直到结束。每个术士只能对一个目标施加一种诅咒，且同类诅咒不能叠加。';

UPDATE `locales_spell` SET `description_loc4` = '以雷霆震击附近的敌人，使它们的攻击间隔延长$s2%，持续$d，并对它们造成$s1点伤害。最多可影响$i个目标。' WHERE `entry` = 6343 AND `description_loc4` = '以雷霆震击附近的敌人，使它们的攻击间隔延长$s2%，持续$d，并对它们造成$s1点自然伤害。最多可影响$i个目标。';

UPDATE `locales_spell` SET `description_loc4` = '燃烧敌人的灵魂，对其造成$s1点火焰伤害，此法术的法术伤害加成较高。' WHERE `entry` = 6353 AND `description_loc4` = '燃烧敌人的灵魂，对其造成$s1点火焰伤害。';

UPDATE `locales_spell` SET `description_loc4` = '安抚目标，使魅魔和她召唤者术士之前所产生的所有仇恨值降低$s1%。' WHERE `entry` = 6360 AND `description_loc4` = '安抚目标，提高令它不再攻击你的几率。';

UPDATE `locales_spell` SET `description_loc4` = '在21内恢复总计294点生命值，但有可能在这个过程中食物中毒。进食时必须保持坐姿。' WHERE `entry` = 6410 AND `description_loc4` = '在$d内恢复总计$o1点生命值，但有可能在这个过程中食物中毒。';

UPDATE `locales_spell` SET `description_loc4` = '击打目标，对其造成少量伤害，打断目标正在施放的法术，并使其在$d内不能施放任何该系法术。' WHERE `entry` = 6552 AND `description_loc4` = '击打目标，对其造成$s1点伤害，打断目标正在施放的法术，并使其在$d内不能施放任何该系法术。';

UPDATE `locales_spell` SET `description_loc4` = '使敌人的武器破损，使用武器每次攻击造成伤害降低10点，持续3分钟。' WHERE `entry` = 6570 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '使你对目标造成的伤害提高$s1点，且每秒回复$t2点能量值，持续$d。' WHERE `entry` = 6793 AND `description_loc4` = '使你对目标造成的伤害提高$s1点，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '撕扯目标，对其造成武器伤害的$s2%再加上$s1点伤害，必须在目标背后发动。奖励$s3个连击点数。' WHERE `entry` = 6800 AND `description_loc4` = '撕扯目标，对其造成武器伤害的$s2%再加上72点伤害，必须在目标背后发动。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '为小队成员施加牺牲之手，每次该队友被击中时，圣骑士都将分担$s1点伤害，持续$d。每个圣骑士在同一时间内只能给目标施加一种圣手效果，同类型的圣手效果不能重叠。' WHERE `entry` = 6940 AND `description_loc4` = '为小队成员施加祝福，每次该队友被击中时，圣骑士都将分担$s1点伤害，持续$d。每个圣骑士在同一时间内只能给目标施加一种祝福，同类型的祝福不能重叠。';

UPDATE `locales_spell` SET `description_loc4` = '圣洁的能量充满施法者的体内，使护甲值提高$s1点，法术伤害提高$s2。牧师每受到一次近战或远程伤害，就消耗一层心灵之火效果。持续$d，或者直到消耗了$n次效果。' WHERE `entry` = 7128 AND `description_loc4` = '圣洁的能量充满施法者的体内，使$g他:她;的防御值提高$s1点。每次近战或远程伤害都会使牧师消耗一次防护能量。效果可持续$d，或在$n次防护之后消失。';

UPDATE `locales_spell` SET `description_loc4` = '在双手剑、双手锤、双手斧、法杖或长柄武器上附加一块平衡锤，使其攻击速度提高$7217s1%。' WHERE `entry` = 7218 AND `description_loc4` = '在双手剑、双手斧或长柄武器上附加一块平衡锤，使其攻击速度提高3%。';

UPDATE `locales_spell` SET `description_loc4` = '在$d内吸取敌方和附近盟友$o1点生命值，并使施法者恢复最多相当于该数值两倍的生命值。' WHERE `entry` = 7290 AND `description_loc4` = '每秒钟吸取目标$s1点生命值，并将其转移给施法者。';

UPDATE `locales_spell` SET `description_loc4` = '横扫攻击，对目标和它身边最近的一个敌人造成近战伤害再加上$s1点伤害。' WHERE `entry` = 7369 AND `description_loc4` = '横扫攻击，对目标和它身边最近的一个敌人造成武器伤害再加上$s1点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '向敌人发起冲锋，使其在$7922d内无法移动，并使你的野猪的下一次攻击的攻击强度提高$s2点加上其本身攻击强度的35%。' WHERE `entry` = 7371 AND `description_loc4` = '向敌人发起冲锋，使其在$7922d内无法移动，并使你的野猪的下一次攻击获得$s2点近战攻击强度加成。';

UPDATE `locales_spell` SET `description_loc4` = '立刻压制敌人，对其造成近战伤害外加$s1点伤害。只能在目标躲闪之后使用。压制无法被格档、躲闪或招架。' WHERE `entry` = 7384 AND `description_loc4` = '立刻压制敌人，对其造成武器伤害外加$s1点伤害。只能在目标躲闪之后使用。压制无法被格档、躲闪或招架。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双护腕附魔，使其获得生命值+5的效果。' WHERE `entry` = 7418 AND `description_loc4` = '永久性地为一双护腕附魔，使它们获得生命值+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得生命值+5的效果。' WHERE `entry` = 7420 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得生命值+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其每次被击中时都有2%的机会吸收10点伤害。' WHERE `entry` = 7426 AND `description_loc4` = '为一件胸甲附魔，使它每次被击中时都有2%的机会吸收10点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得防御+1的效果。' WHERE `entry` = 7428 AND `description_loc4` = '永久性地为一只护腕附魔，使它获得防御+1的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得法力值+5的效果。' WHERE `entry` = 7443 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得法力值+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件胸甲永久性地附魔，使其获得+5法力值的效果。' WHERE `entry` = 7444 AND `description_loc4` = '教你学会给一件胸甲永久性地附魔，使它获得+5法力值的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得所有魔法抗性+1的效果。' WHERE `entry` = 7454 AND `description_loc4` = '永久性地为一件披风附魔，使它获得所有魔法抗性+1的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得耐力+1的效果。' WHERE `entry` = 7457 AND `description_loc4` = '永久性地为一只护腕附魔，使它获得耐力+1的效果。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 7464 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 7465 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 7466 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 7468 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 7469 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 7470 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 7471 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 7472 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 7473 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 7474 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 7475 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 7476 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 7477 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 7478 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 7479 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 7490 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 7491 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 7492 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 7493 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 7494 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 7495 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 7496 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 7497 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 7498 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 7499 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 7500 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 7501 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 7502 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 7503 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 7504 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 7505 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 7506 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 7507 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 7508 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 7509 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 7520 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 7522 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 7523 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 7524 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 7525 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 7526 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 7527 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 7530 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 7532 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 7537 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 7538 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 7539 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 7540 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 7541 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 7542 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 7543 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 7544 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 7545 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 7546 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 7547 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 7548 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '在战斗中被敌人击中之后，有1%的机会对其造成$s1点暗影伤害。' WHERE `entry` = 7601 AND `description_loc4` = '在战斗中被敌人击中之后，有10%的机会对其造成$s1点暗影伤害。';

UPDATE `locales_spell` SET `description_loc4` = '在战斗中被敌人击中之后，有$h%的机会对其造成$s1点暗影伤害。' WHERE `entry` = 7614 AND `description_loc4` = '在战斗中被敌人击中之后，有10%的机会对其造成$s1点暗影伤害。';

UPDATE `locales_spell` SET `description_loc4` = '在战斗中被敌人击中之后，有1%的机会对其造成$s1点暗影伤害。' WHERE `entry` = 7615 AND `description_loc4` = '在战斗中被敌人击中之后，有10%的机会对其造成$s1点暗影伤害。';

UPDATE `locales_spell` SET `description_loc4` = '在战斗中被敌人击中之后，有1%的机会对其造成$s1点暗影伤害。' WHERE `entry` = 7616 AND `description_loc4` = '在战斗中被敌人击中之后，有10%的机会对其造成$s1点暗影伤害。';

UPDATE `locales_spell` SET `description_loc4` = '在战斗中被敌人击中之后，有1%的机会对其造成$s1点暗影伤害。' WHERE `entry` = 7618 AND `description_loc4` = '在战斗中被敌人击中之后，有10%的机会对其造成$s1点暗影伤害。';

UPDATE `locales_spell` SET `description_loc4` = '目标所能造成的伤害降低$s1点，持续$d。每个术士只能对一个目标施加一种诅咒。' WHERE `entry` = 7646 AND `description_loc4` = '目标所能造成的伤害降低$s1点，持续$d。每个术士只能对一个目标施加一种诅咒，且同类诅咒不能叠加。';

UPDATE `locales_spell` SET `description_loc4` = '在$d内将目标$*5;s1点生命值转移给施法者。' WHERE `entry` = 7651 AND `description_loc4` = '每秒钟吸取目标$s1点生命值，并将其转移给施法者，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把双手近战武器附魔，使其获得伤害+2的效果。' WHERE `entry` = 7745 AND `description_loc4` = '永久性地为一把双手近战武器附魔，使它获得伤害+2的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得生命值+15的效果。' WHERE `entry` = 7748 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得生命值+15的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得精神+1的效果。' WHERE `entry` = 7766 AND `description_loc4` = '永久性地为一只护腕附魔，使它获得精神+1的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一副护腕永久性地附魔，使其获得+1精神的效果。' WHERE `entry` = 7767 AND `description_loc4` = '教你学会给一只护腕永久性地附魔，使它获得+1精神的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得护甲+10的效果。' WHERE `entry` = 7771 AND `description_loc4` = '为一件披风附魔，使它获得护甲+10的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件披风永久性地附魔，使其获得+10护甲的效果。' WHERE `entry` = 7772 AND `description_loc4` = '教你学会给一件披风永久性地附魔，使它获得+10护甲的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得法力值+20的效果。' WHERE `entry` = 7776 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得法力值+20的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件胸甲永久性地附魔，使其获得+20法力值的效果。' WHERE `entry` = 7777 AND `description_loc4` = '教你学会给一件胸甲永久性地附魔，使它获得+20法力值的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得敏捷+1的效果。' WHERE `entry` = 7779 AND `description_loc4` = '永久性地为一只护腕附魔，使它获得敏捷+1的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得力量+1的效果。' WHERE `entry` = 7782 AND `description_loc4` = '永久性地为一只护腕附魔，使它获得力量+1的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一副护腕永久性地附魔，使其获得+1力量的效果。' WHERE `entry` = 7783 AND `description_loc4` = '教你学会给一只护腕永久性地附魔，使它获得+1力量的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其获得对野兽伤害+2的效果。' WHERE `entry` = 7786 AND `description_loc4` = '永久性地为一把近战武器附魔，使它获得对野兽伤害+2的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件近战武器永久性地附魔，使其获得+2对野兽伤害的效果。' WHERE `entry` = 7787 AND `description_loc4` = '教你学会给一件近战武器永久性地附魔，使它获得对野兽伤害+2的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其获得伤害+1的效果。' WHERE `entry` = 7788 AND `description_loc4` = '永久性地为一把近战武器附魔，使它获得伤害+1的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把双手近战武器附魔，使其获得智力+3的效果。' WHERE `entry` = 7793 AND `description_loc4` = '永久性地为一把双手近战武器附魔，使它获得智力+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件双手武器永久性地附魔，使其获得+3智力的效果。' WHERE `entry` = 7798 AND `description_loc4` = '教你学会给一件双手武器永久性地附魔，使它获得+3智力的效果。';

UPDATE `locales_spell` SET `description_loc4` = '安抚目标，使魅魔和她召唤者术士之前所产生的所有仇恨值降低$s1%。' WHERE `entry` = 7813 AND `description_loc4` = '安抚目标，提高令它不再攻击你的几率。比安抚之吻（等级 1）更有效。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得生命值+25的效果。' WHERE `entry` = 7857 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得生命值+25的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得精神+3的效果。' WHERE `entry` = 7859 AND `description_loc4` = '永久性地为一只护腕附魔，使它获得精神+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一副护腕永久性地附魔，使其获得+3精神的效果。' WHERE `entry` = 7860 AND `description_loc4` = '教你学会给一只护腕永久性地附魔，使它获得+3精神的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得火焰抗性+5的效果。' WHERE `entry` = 7861 AND `description_loc4` = '永久性地为一件披风附魔，使它获得火焰抗性+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双靴子附魔，使其获得耐力+1的效果。' WHERE `entry` = 7863 AND `description_loc4` = '永久性地为一双靴子附魔，使它们获得耐力+1的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双靴子永久性地附魔，使其获得+1耐力的效果。' WHERE `entry` = 7864 AND `description_loc4` = '教你学会给一双靴子永久性地附魔，使它获得+1耐力的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双靴子附魔，使其获得敏捷+1的效果。' WHERE `entry` = 7867 AND `description_loc4` = '永久性地为一双靴子附魔，使它们获得敏捷+1的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双靴子永久性地附魔，使其获得+1敏捷的效果。' WHERE `entry` = 7868 AND `description_loc4` = '教你学会给一双靴子永久性地附魔，使它获得+1敏捷的效果。';

UPDATE `locales_spell` SET `description_loc4` = '立刻压制敌人，对其造成近战伤害外加$s1点伤害。只能在目标躲闪之后使用。压制无法被格档、躲闪或招架。' WHERE `entry` = 7887 AND `description_loc4` = '立刻压制敌人，对其造成武器伤害外加$s1点伤害。只能在目标躲闪之后使用。压制无法被格档、躲闪或招架。';

UPDATE `locales_spell` SET `description_loc4` = '制造3瓶抗毒抗毒药剂。' WHERE `entry` = 7934 AND `description_loc4` = '制造3瓶抗毒药剂。';

UPDATE `locales_spell` SET `description_loc4` = '强化萨满祭司的武器，使其近战攻击强度提高$10400s1点，使用该武器时所有威胁值提高$10400s2%。强化效果持续1小时。' WHERE `entry` = 8017 AND `description_loc4` = '强化萨满祭司的武器，使$g他:她;的近战攻击强度提高$10400s1点，使用该武器对敌人造成近战伤害时产生额外的威胁值。强化效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '强化萨满祭司的武器，使其近战攻击强度提高$15567s1点，使用该武器时所有威胁值提高$15567s2%。强化效果持续1小时。' WHERE `entry` = 8018 AND `description_loc4` = '强化萨满祭司的武器，使$g他:她;的近战攻击强度提高$15567s1点，使用该武器对敌人造成近战伤害时产生额外的威胁值。强化效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '强化萨满祭司的武器，使其近战攻击强度提高$15568s1点，使用该武器时所有威胁值提高$15568s2%。强化效果持续1小时。' WHERE `entry` = 8019 AND `description_loc4` = '强化萨满祭司的武器，使$g他:她;的近战攻击强度提高$15568s1点，使用该武器对敌人造成近战伤害时产生额外的威胁值。强化效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '给萨满祭司的武器附加火焰的力量。每次击中敌人都会对其造成$/77;8026m1到$/25;8026M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续1小时。' WHERE `entry` = 8024 AND `description_loc4` = '给萨满祭司的武器附加火焰的力量。每次击中敌人都会对其造成$/77;8026m1到$/25;8026M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '给萨满祭司的武器附加火焰的力量。每次击中敌人都会对其造成$/77;8028m1到$/25;8028M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续1小时。' WHERE `entry` = 8027 AND `description_loc4` = '给萨满祭司的武器附加火焰的力量。每次击中敌人都会对其造成$/77;8028m1到$/25;8028M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '给萨满祭司的武器附加火焰的力量。每次击中敌人都会对其造成$/77;8029m1到$/25;8029M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续1小时。' WHERE `entry` = 8030 AND `description_loc4` = '给萨满祭司的武器附加火焰的力量。每次击中敌人都会对其造成$/77;8029m1到$/25;8029M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '以冰霜的力量加强萨满祭司的武器，每次击中敌人都有一定几率造成$8034s2点额外的冰霜伤害，并使目标的移动速度降低$8034s1%，减速效果持续$8034d。冰封武器效果持续1小时。' WHERE `entry` = 8033 AND `description_loc4` = '以冰霜的力量加强萨满祭司的武器，每次击中敌人都有一定几率造成$8034s2点额外的冰霜伤害，并使目标的移动速度降低$8034s1%，减速效果持续$8034d。冰封武器效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '以冰霜的力量加强萨满祭司的武器，每次击中敌人都有一定几率造成$8037s2点额外的冰霜伤害，并使目标的移动速度降低$8037s1%，减速效果持续$8037d。冰封武器效果持续1小时。' WHERE `entry` = 8038 AND `description_loc4` = '以冰霜的力量加强萨满祭司的武器，每次击中敌人都有一定几率造成$8037s2点额外的冰霜伤害，并使目标的移动速度降低$8037s1%，减速效果持续$8037d。冰封武器效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '立即以震撼性的力量攻击目标，对其造成$s1点自然伤害，同时打断施法，并使其在$d内无法施放该系法术。产生中等的威胁值。' WHERE `entry` = 8042 AND `description_loc4` = '立即以震撼性的力量攻击目标，对其造成$s1点自然伤害，同时打断施法，并使其在$d内无法施放该系法术。产生大量的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '立即以震撼性的力量攻击目标，对其造成$s1点自然伤害，同时打断施法，并使其在$d内无法施放该系法术。产生中等的威胁值。' WHERE `entry` = 8044 AND `description_loc4` = '立即以震撼性的力量攻击目标，对其造成$s1点自然伤害，同时打断施法，并使其在$d内无法施放该系法术。产生大量的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '立即以震撼性的力量攻击目标，对其造成$s1点自然伤害，同时打断施法，并使其在$d内无法施放该系法术。产生中等的威胁值。' WHERE `entry` = 8045 AND `description_loc4` = '立即以震撼性的力量攻击目标，对其造成$s1点自然伤害，同时打断施法，并使其在$d内无法施放该系法术。产生大量的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '立即以震撼性的力量攻击目标，对其造成$s1点自然伤害，同时打断施法，并使其在$d内无法施放该系法术。产生中等的威胁值。' WHERE `entry` = 8046 AND `description_loc4` = '立即以震撼性的力量攻击目标，对其造成$s1点自然伤害，同时打断施法，并使其在$d内无法施放该系法术。产生大量的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '对半径8码内的目标造成$s1点伤害。' WHERE `entry` = 8079 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '装备在鱼竿上之后，可以使你的钓鱼技能提高100点，持续10分钟。' WHERE `entry` = 8089 AND `description_loc4` = '装备在鱼竿上之后，可以使你的钓鱼技能提高100点，持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '受到物理攻击时所承受的伤害提高$s1%，持续$d。' WHERE `entry` = 8137 AND `description_loc4` = '受到物理攻击时所承受的伤害提高$s1%，$d。';

UPDATE `locales_spell` SET `description_loc4` = '以雷霆震击附近的敌人，使它们的攻击间隔延长$s2%，持续$d，并对它们造成$s1点伤害。最多可影响$i个目标。' WHERE `entry` = 8198 AND `description_loc4` = '以雷霆震击附近的敌人，使它们的攻击间隔延长$s2%，持续$d，并对它们造成$s1点自然伤害。最多可影响$i个目标。';

UPDATE `locales_spell` SET `description_loc4` = '以雷霆震击附近的敌人，使它们的攻击间隔延长$s2%，持续$d，并对它们造成$s1点伤害。最多可影响$i个目标。' WHERE `entry` = 8204 AND `description_loc4` = '以雷霆震击附近的敌人，使它们的攻击间隔延长$s2%，持续$d，并对它们造成$s1点自然伤害。最多可影响$i个目标。';

UPDATE `locales_spell` SET `description_loc4` = '以雷霆震击附近的敌人，使它们的攻击间隔延长$s2%，持续$d，并对它们造成$s1点伤害。最多可影响$i个目标。' WHERE `entry` = 8205 AND `description_loc4` = '以雷霆震击附近的敌人，使它们的攻击间隔延长$s2%，持续$d，并对它们造成$s1点自然伤害。最多可影响$i个目标。';

UPDATE `locales_spell` SET `description_loc4` = '在施法者身边召唤一个生命值为$s1点的火舌图腾。图腾令半径$8230a1码范围内的所有小队成员的主手武器每次击中敌人都会对其造成$/77;8253m1到$/25;8253M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续$d。' WHERE `entry` = 8227 AND `description_loc4` = '在施法者身边召唤一个生命值为$s1点的火舌图腾。图腾令半径$8230a1码范围内的所有小队成员的主手武器都附有火焰效果，每次击中敌人都会对其造成$/77;8253m1到$/25;8253M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '以风的力量加强萨满祭司的武器，每次击中敌人都有25%的几率令你获得额外的$8233s2次近战攻击机会，并且在这几次攻击中的攻击强度提高$8233s1点。风怒效果持续1小时。' WHERE `entry` = 8232 AND `description_loc4` = '以风的力量加强萨满祭司的武器，每次击中敌人都有20%的几率令你获得额外的$8233s2次近战攻击机会，并且在这几次攻击中的攻击强度提高$8233s1点。风怒效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '以风的力量加强萨满祭司的武器，每次击中敌人都有25%的几率令你获得额外的$8236s2次近战攻击机会，并且在这几次攻击中的攻击强度提高$8236s1点。风怒效果持续1小时。' WHERE `entry` = 8235 AND `description_loc4` = '以风的力量加强萨满祭司的武器，每次击中敌人都有20%的几率令你获得额外的$8236s2次近战攻击机会，并且在这几次攻击中的攻击强度提高$8236s1点。风怒效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '在施法者身边召唤一个生命值为$s1点的火舌图腾。图腾令半径$8250a1码范围内的所有小队成员的主手武器每次击中敌人都会对其造成$/77;8248m1到$/25;8248M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续$d。' WHERE `entry` = 8249 AND `description_loc4` = '在施法者身边召唤一个生命值为$s1点的火舌图腾。图腾令半径$8250a1码范围内的所有小队成员的主手武器都附有火焰效果，每次击中敌人都会对其造成$/77;8248m1到$/25;8248M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '吸取目标的灵魂，在$d内对其造成累计$*6;s2点暗影伤害。如果目标在被吸取灵魂的过程中死亡，且施法者因此获得经验值或荣誉，则施法者可以得到一块灵魂碎片。灵魂碎片是施放其它一些法术所必需的材料。' WHERE `entry` = 8288 AND `description_loc4` = '吸取目标的灵魂，在$d内对其造成累计$o2点暗影伤害。如果目标在被吸取灵魂的过程中死亡，且施法者因此获得经验值或荣誉，则施法者可以得到一块灵魂碎片。灵魂碎片是施放其它一些法术所必需的材料。';

UPDATE `locales_spell` SET `description_loc4` = '吸取目标的灵魂，在$d内对其造成累计$*6;s2点暗影伤害。如果目标在被吸取灵魂的过程中死亡，且施法者因此获得经验值或荣誉，则施法者可以得到一块灵魂碎片。灵魂碎片是施放其它一些法术所必需的材料。' WHERE `entry` = 8289 AND `description_loc4` = '吸取目标的灵魂，在$d内对其造成累计$o2点暗影伤害。如果目标在被吸取灵魂的过程中死亡，且施法者因此获得经验值或荣誉，则施法者可以得到一块灵魂碎片。灵魂碎片是施放其它一些法术所必需的材料。';

UPDATE `locales_spell` SET `description_loc4` = '治疗目标，每$t1秒回复$s1点生命值，持续$d。' WHERE `entry` = 8362 AND `description_loc4` = '治疗目标，在$d内恢复总计$o1点生命值。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出数枚奥术飞弹，对其每$8419d造成$8419s1点伤害，持续$d。' WHERE `entry` = 8416 AND `description_loc4` = '向目标射出数枚奥术飞弹，对其造成每秒$8419s1点伤害，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出数枚奥术飞弹，对其每$8418d造成$8418s1点伤害，持续$d。' WHERE `entry` = 8417 AND `description_loc4` = '向目标射出数枚奥术飞弹，对其造成每秒$8418s1点伤害，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8430 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8431 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8432 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '不利效果' WHERE `entry` = 8450 AND `description_loc4` = '降低施放于目标小队成员身上的魔法效果，使其受到的法术伤害降低最多$s1点，治疗法术恢复生命值的效果降低最多$s2点，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '有利效果' WHERE `entry` = 8451 AND `description_loc4` = '降低施放于目标小队成员身上的魔法效果，使其受到的法术伤害降低最多$s1点，治疗法术恢复生命值的效果降低最多$s2点，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '不利效果' WHERE `entry` = 8455 AND `description_loc4` = '增强施放于目标小队成员身上的魔法效果，使其受到的法术伤害最多提高$s1点，治疗法术所恢复的生命值最多提高$s2点，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8469 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8470 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8471 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8472 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8473 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8474 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8475 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8476 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8477 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8478 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '在施法者身边召唤一个生命值为$s1点的风怒图腾，持续$d。它可以使半径$51367a1码范围内的所有小队成员的主手武器附带风怒效果，每次击中敌人都有20%的几率令攻击者获得额外的$51368s1次近战攻击机会。' WHERE `entry` = 8512 AND `description_loc4` = '在施法者身边召唤一个生命值为$s1点的风怒图腾，持续$d。它可以使半径$8514a1码范围内的所有小队成员的主手武器附带风怒效果，每次击中敌人都有20%的几率令攻击者获得额外的$8516s2次近战攻击机会，并且在这几次攻击中的攻击强度提高$8516s1点。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成近战伤害再加上$s1点额外伤害，奖励$s2个连击点数。' WHERE `entry` = 8621 AND `description_loc4` = '对目标造成普通武器伤害再加上$s1点额外伤害，奖励$s2个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '伏击目标，对其造成$s2%的近战伤害再加上70点额外伤害。必须在潜行状态下从目标背后发动。奖励$s3个连击点数。' WHERE `entry` = 8676 AND `description_loc4` = '伏击目标，对其造成$s2%的武器伤害再加上70点额外伤害。必须在潜行状态下从目标背后发动。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '背刺目标，对其造成近战伤害的$s2%再加90点伤害，必须在目标背后发动，潜行者的主手中必须有一把武器。奖励$s3个连击点数。' WHERE `entry` = 8721 AND `description_loc4` = '背刺目标，对其造成武器伤害的$s2%再加90点伤害，必须在目标背后发动，盗贼的主手中必须有一把武器。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '伏击目标，对其造成$s2%的近战伤害再加上100点额外伤害。必须在潜行状态下从目标背后发动。奖励$s3个连击点数。' WHERE `entry` = 8724 AND `description_loc4` = '伏击目标，对其造成$s2%的武器伤害再加上100点额外伤害。必须在潜行状态下从目标背后发动。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '伏击目标，对其造成$s2%的近战伤害再加上125点额外伤害。必须在潜行状态下从目标背后发动。奖励$s3个连击点数。' WHERE `entry` = 8725 AND `description_loc4` = '伏击目标，对其造成$s2%的武器伤害再加上125点额外伤害。必须在潜行状态下从目标背后发动。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '使目标昏迷，持续$d。' WHERE `entry` = 8739 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8741 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8742 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8743 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8744 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8745 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '法术伤害提高$s1点。' WHERE `entry` = 8748 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '法术伤害提高$s1点。' WHERE `entry` = 8749 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '法术伤害提高$s1点。' WHERE `entry` = 8751 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '法术伤害提高$s1点。' WHERE `entry` = 8752 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '法术伤害提高$s1点。' WHERE `entry` = 8753 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8754 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8755 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8756 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 8757 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '使你的攻击和施法速度提高$s1%。' WHERE `entry` = 8815 AND `description_loc4` = '使你的攻击速度提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '猛击敌人，对其造成$45964s1%的武器伤害，可在移动时使用。' WHERE `entry` = 8820 AND `description_loc4` = '猛击敌人，对其造成武器伤害再加上$s1点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '使附近所有团队成员每秒钟恢复$s1点生命值，持续$d。德鲁伊必须不断引导能量以维持法术。' WHERE `entry` = 8918 AND `description_loc4` = '使附近所有小队成员每$t1秒钟恢复$s1点生命值，持续$d。德鲁伊必须不断引导能量以维持法术。';

UPDATE `locales_spell` SET `description_loc4` = '撕扯目标，对其造成武器伤害的$s2%再加上$s1点伤害，必须在目标背后发动。奖励$s3个连击点数。' WHERE `entry` = 8992 AND `description_loc4` = '撕扯目标，对其造成武器伤害的$s2%再加上99点伤害，必须在目标背后发动。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9076 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 9098 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 9099 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 9100 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 9101 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 9102 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 9103 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 9104 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 9105 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 9106 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 9107 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 9108 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 9109 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 9110 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 9111 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 9112 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 9113 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 9114 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 9115 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 9117 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 9118 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 9119 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 9120 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 9121 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 9122 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 9123 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 9136 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 9137 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 9138 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 9139 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 9140 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 9141 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 9142 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 9258 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 9259 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 9260 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 9261 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 9262 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 9263 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 9264 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 9265 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 9266 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 9267 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9292 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '火焰法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9293 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '冰霜法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9299 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '冰霜法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9300 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '冰霜法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9301 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '冰霜法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9302 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '冰霜法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9303 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9309 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9310 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9311 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9312 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '神圣法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9313 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9319 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9320 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9321 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9322 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '暗影法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9323 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 9329 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 9330 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 9331 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 9332 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 9333 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 9334 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 9335 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 9336 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '法术伤害提高$s1点。' WHERE `entry` = 9337 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '法术伤害提高$s1点。' WHERE `entry` = 9338 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '法术伤害提高$s1点。' WHERE `entry` = 9339 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '法术伤害提高$s1点。' WHERE `entry` = 9340 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '法术伤害提高$s1点。' WHERE `entry` = 9341 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9348 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9349 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9350 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9351 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9352 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9353 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9354 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9355 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '自然法术和攻击造成的伤害提高$s1点。' WHERE `entry` = 9356 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '每$t1秒钟吸取敌方和附近盟友$s1点生命值，并使施法者恢复最多相当于该数值两倍的生命值。持续$d。' WHERE `entry` = 9373 AND `description_loc4` = '每秒钟吸取目标$s1点生命值，并将其转移给施法者。';

UPDATE `locales_spell` SET `description_loc4` = '使圣骑士的近战攻击有一定的几率令目标造成的伤害降低$67s1%，持续$67d，仅对$67v级或更低的敌人有效。' WHERE `entry` = 9452 AND `description_loc4` = '使圣骑士的近战攻击有一定的几率令目标的力量和敏捷降低$67s1%，持续$67d。';

UPDATE `locales_spell` SET `description_loc4` = '渐渐消失，使你的威胁值暂时降低$s1%外加$s2点，使敌人不再攻击你，持续$d。' WHERE `entry` = 9578 AND `description_loc4` = '渐渐消失，使敌人不再攻击你，持续$d。比渐隐术（等级 1）的效果更好。';

UPDATE `locales_spell` SET `description_loc4` = '渐渐消失，使你的威胁值暂时降低$s1%外加$s2点，使敌人不再攻击你，持续$d。' WHERE `entry` = 9579 AND `description_loc4` = '渐渐消失，使敌人不再攻击你，持续$d。比渐隐术（等级 2）的效果更好。';

UPDATE `locales_spell` SET `description_loc4` = '渐渐消失，使你的威胁值暂时降低$s1%外加$s2点，使敌人不再攻击你，持续$d。' WHERE `entry` = 9592 AND `description_loc4` = '渐渐消失，使敌人不再攻击你，持续$d。比渐隐术（等级 3）的效果更好。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 9760 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 9761 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 9762 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 9763 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 9764 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 9765 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 9766 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 9767 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 9768 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '每次攻击都有$h%的几率使目标被缴械。' WHERE `entry` = 9793 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '每次攻击都有$h%的几率使目标染上疾病。' WHERE `entry` = 9797 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '每次攻击都有$h%的几率使用神圣之盾保护你，并格挡$9800s1点伤害。' WHERE `entry` = 9801 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '有$h%的几率使目标的护甲值降低$9806s1点，持续$9806d。在效果持续期间，目标无法潜行或隐形。' WHERE `entry` = 9808 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '撕扯目标，对其造成武器伤害的$s2%再加上$s1点伤害，必须在目标背后发动。奖励$s3个连击点数。' WHERE `entry` = 9829 AND `description_loc4` = '撕扯目标，对其造成武器伤害的$s2%再加上144点伤害，必须在目标背后发动。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '撕扯目标，对其造成武器伤害的$s2%再加上$s1点伤害，必须在目标背后发动。奖励$s3个连击点数。' WHERE `entry` = 9830 AND `description_loc4` = '撕扯目标，对其造成武器伤害的$s2%再加上180点伤害，必须在目标背后发动。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '使你对目标造成的伤害提高$s1点，且每秒回复$t2点能量值，持续$d。' WHERE `entry` = 9845 AND `description_loc4` = '使你对目标造成的伤害提高$s1点，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '使你对目标造成的伤害提高$s1点，且每秒回复$t2点能量值，持续$d。' WHERE `entry` = 9846 AND `description_loc4` = '使你对目标造成的伤害提高$s1点，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '用爪攻击敌人，对其造成$s3%点普通伤害和$s1点额外伤害，奖励$s2个连击点数。' WHERE `entry` = 9849 AND `description_loc4` = '用爪攻击敌人，对其造成$s1点额外伤害。奖励$s2个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '用爪攻击敌人，对其造成$s3%点普通伤害和$s1点额外伤害，奖励$s2个连击点数。' WHERE `entry` = 9850 AND `description_loc4` = '用爪攻击敌人，对其造成$s1点额外伤害。奖励$s2个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '使附近所有团队成员每秒钟恢复$s1点生命值，持续$d。德鲁伊必须不断引导能量以维持法术。' WHERE `entry` = 9862 AND `description_loc4` = '使附近所有小队成员每$t1秒钟恢复$s1点生命值，持续$d。德鲁伊必须不断引导能量以维持法术。';

UPDATE `locales_spell` SET `description_loc4` = '使附近所有团队成员每秒钟恢复$s1点生命值，持续$d。德鲁伊必须不断引导能量以维持法术。' WHERE `entry` = 9863 AND `description_loc4` = '使附近所有小队成员每$t1秒钟恢复$s1点生命值，持续$d。德鲁伊必须不断引导能量以维持法术。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成$s1点伤害，并在$d内造成总计$o2点额外伤害。伤害受到你的攻击强度加成，奖励$s3个连击点数。' WHERE `entry` = 9904 AND `description_loc4` = '对目标造成$s1点伤害，并在$d内造成总计$o2点额外伤害。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '有利效果' WHERE `entry` = 10169 AND `description_loc4` = '增强施放于目标小队成员身上的魔法效果，使其受到的法术伤害最多提高$s1点，治疗法术所恢复的生命值最多提高$s2点，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出数枚奥术飞弹，对其每$10273d造成$10273s1点伤害，持续$d。' WHERE `entry` = 10211 AND `description_loc4` = '向目标射出数枚奥术飞弹，对其造成每秒$10273s1点伤害，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出数枚奥术飞弹，对其每$10274d造成$10274s1点伤害，持续$d。' WHERE `entry` = 10212 AND `description_loc4` = '向目标射出数枚奥术飞弹，对其造成每秒$10274s1点伤害，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '被施加此圣手效果的队友将对一切物理攻击免疫，同时也无法攻击或使用物理技能，持续$d。每个圣骑士在同一时间内只能给目标施加一种圣手效果，同类型的圣手效果不能重叠。在被保护之后，圣盾术、保护之手或圣佑术在$25771d之内无法作用在该目标身上。' WHERE `entry` = 10278 AND `description_loc4` = '被施加此圣印的队友将对一切物理攻击免疫，同时也无法攻击或使用物理技能，持续$d。每个圣骑士在同一时间内只能给目标施加一种祝福，同类型的祝福不能重叠。在被保护之后，圣盾术、保护祝福或圣佑术在$25771d之内无法作用在该目标身上。';

UPDATE `locales_spell` SET `description_loc4` = '对单一亡灵或恶魔目标造成$s1点神圣伤害，这个法术产生较低的威胁值。' WHERE `entry` = 10312 AND `description_loc4` = '对单一亡灵或恶魔目标造成$s1点神圣伤害。';

UPDATE `locales_spell` SET `description_loc4` = '对单一亡灵或恶魔目标造成$s1点神圣伤害，这个法术产生较低的威胁值。' WHERE `entry` = 10313 AND `description_loc4` = '对单一亡灵或恶魔目标造成$s1点神圣伤害。';

UPDATE `locales_spell` SET `description_loc4` = '对单一亡灵或恶魔目标造成$s1点神圣伤害，这个法术产生较低的威胁值。' WHERE `entry` = 10314 AND `description_loc4` = '对单一亡灵或恶魔目标造成$s1点神圣伤害。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成神圣伤害，造成$s1点武器伤害加上$s2点 额外伤害，并为你和$51880a1码范围内最多$51880x1名队友恢复$51880s2点生命值和$51880s1点法力值。你自身受到的治疗效果会降低一半。' WHERE `entry` = 10332 AND `description_loc4` = '将圣洁的能量灌入武器，使你的下一次攻击造成$s1点额外伤害，且所有伤害都被计为神圣属性的伤害。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成神圣伤害，造成$s1点武器伤害加上$s2点 额外伤害，并为你和$51881a1码范围内最多$51881x1名队友恢复$51881s2点生命值和$51881s1点法力值。你自身受到的治疗效果会降低一半。' WHERE `entry` = 10333 AND `description_loc4` = '将圣洁的能量灌入武器，使你的下一次攻击造成$s1点额外伤害，且所有伤害都被计为神圣属性的伤害。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出闪电箭，对其造成$s1点自然伤害。' WHERE `entry` = 10391 AND `description_loc4` = '向目标射出闪电箭，对其造成$s点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出闪电箭，对其造成$s1点自然伤害。' WHERE `entry` = 10392 AND `description_loc4` = '向目标射出闪电箭，对其造成$s点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '强化萨满祭司的武器，使其近战攻击强度提高$15569s1点，使用该武器时所有威胁值提高$15569s2%。强化效果持续1小时。' WHERE `entry` = 10399 AND `description_loc4` = '强化萨满祭司的武器，使$g他:她;的近战攻击强度提高$15569s1点，使用该武器对敌人造成近战伤害时产生额外的威胁值。强化效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '立即以震撼性的力量攻击目标，对其造成$s1点自然伤害，同时打断施法，并使其在$d内无法施放该系法术。产生中等的威胁值。' WHERE `entry` = 10412 AND `description_loc4` = '立即以震撼性的力量攻击目标，对其造成$s1点自然伤害，同时打断施法，并使其在$d内无法施放该系法术。产生大量的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '立即以震撼性的力量攻击目标，对其造成$s1点自然伤害，同时打断施法，并使其在$d内无法施放该系法术。产生中等的威胁值。' WHERE `entry` = 10413 AND `description_loc4` = '立即以震撼性的力量攻击目标，对其造成$s1点自然伤害，同时打断施法，并使其在$d内无法施放该系法术。产生大量的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '立即以震撼性的力量攻击目标，对其造成$s1点自然伤害，此法术还受到你的近战攻击强度加成。同时打断施法，并使其在$d内无法施放该系法术。产生中等的威胁值。' WHERE `entry` = 10414 AND `description_loc4` = '立即以震撼性的力量攻击目标，对其造成$s1点自然伤害，同时打断施法，并使其在$d内无法施放该系法术。产生大量的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '立刻用火焰燃烧目标，对其造成$s1点火焰伤害，并在随后的$d内造成总计$o2点火焰伤害。该法术还受到你的近战攻击强度加成。' WHERE `entry` = 10448 AND `description_loc4` = '立刻用火焰燃烧目标，对其造成$s1点火焰伤害，并在随后的$d内造成总计$o2点火焰伤害。';

UPDATE `locales_spell` SET `description_loc4` = '以冰霜的力量加强萨满祭司的武器，每次击中敌人都有一定几率造成$10458s2点额外的冰霜伤害，并使目标的移动速度降低$10458s1%，减速效果持续$10458d。冰封武器效果持续1小时。' WHERE `entry` = 10456 AND `description_loc4` = '以冰霜的力量加强萨满祭司的武器，每次击中敌人都有一定几率造成$10458s2点额外的冰霜伤害，并使目标的移动速度降低$10458s1%，减速效果持续$10458d。冰封武器效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '以冰霜冲击目标，对其造成$s2点伤害，并使其移动速度降低$s1%，此法术还受到你的近战攻击强度加成，持续$d。' WHERE `entry` = 10473 AND `description_loc4` = '以冰霜冲击目标，对其造成$s2点伤害，并使其移动速度降低$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '以风的力量加强萨满祭司的武器，每次击中敌人都有25%的几率令你获得额外的$10484s2次近战攻击机会，并且在这几次攻击中的攻击强度提高$10484s1点。风怒效果持续1小时。' WHERE `entry` = 10486 AND `description_loc4` = '以风的力量加强萨满祭司的武器，每次击中敌人都有20%的几率令你获得额外的$10484s2次近战攻击机会，并且在这几次攻击中的攻击强度提高$10484s1点。风怒效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '在施法者身边召唤一个生命值为$s1点的火舌图腾。图腾令半径$10521a1码范围内的所有小队成员的主手武器每次击中敌人都会对其造成$/77;10523m1到$/25;10523M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续$d。' WHERE `entry` = 10526 AND `description_loc4` = '在施法者身边召唤一个生命值为$s1点的火舌图腾。图腾令半径$10521a1码范围内的所有小队成员的主手武器都附有火焰效果，每次击中敌人都会对其造成$/77;10523m1到$/25;10523M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '测试法术-用于调试' WHERE `entry` = 10654 AND `description_loc4` = 'Test Spell - For Debugging';

UPDATE `locales_spell` SET `description_loc4` = '它敏捷而迅速，跳跃时活泼而优雅，吸引了艾泽拉斯各地冒险者的心。' WHERE `entry` = 10712 AND `description_loc4` = '右键点击以召唤或解散你的兔子。';

UPDATE `locales_spell` SET `description_loc4` = '渐渐消失，使你的威胁值暂时降低$s1%外加$s2点，使敌人不再攻击你，持续$d。' WHERE `entry` = 10941 AND `description_loc4` = '渐渐消失，使敌人不再攻击你，持续$d。比渐隐术（等级 4）的效果更好。';

UPDATE `locales_spell` SET `description_loc4` = '渐渐消失，使你的威胁值暂时降低$s1%外加$s2点，使敌人不再攻击你，持续$d。' WHERE `entry` = 10942 AND `description_loc4` = '渐渐消失，使敌人不再攻击你，持续$d。比渐隐术（等级 5）的效果更好。';

UPDATE `locales_spell` SET `description_loc4` = '圣洁的能量充满施法者的体内，使护甲值提高$s1点，法术伤害提高$s2。牧师每受到一次近战或远程伤害，就消耗一层心灵之火效果。持续$d，或者直到消耗了$n次效果。' WHERE `entry` = 10951 AND `description_loc4` = '圣洁的能量充满施法者的体内，使$g他:她;的防御值提高$s1点。每次近战或远程伤害都会使牧师消耗一次防护能量。效果可持续$d，或在$n次防护之后消失。';

UPDATE `locales_spell` SET `description_loc4` = '圣洁的能量充满施法者的体内，使护甲值提高$s1点，法术伤害提高$s2。牧师每受到一次近战或远程伤害，就消耗一层心灵之火效果。持续$d，或者直到消耗了$n次效果。' WHERE `entry` = 10952 AND `description_loc4` = '圣洁的能量充满施法者的体内，使$g他:她;的防御值提高$s1点。每次近战或远程伤害都会使牧师消耗一次防护能量。效果可持续$d，或在$n次防护之后消失。';

UPDATE `locales_spell` SET `description_loc4` = '强大的祷言，可以治疗目标周围半径$a1码范围内的所有小队成员。' WHERE `entry` = 10960 AND `description_loc4` = '强大的祷言，可以治疗附近半径$a1码范围内的所有小队成员。';

UPDATE `locales_spell` SET `description_loc4` = '强大的祷言，可以治疗目标周围半径$a1码范围内的所有小队成员。' WHERE `entry` = 10961 AND `description_loc4` = '强大的祷言，可以治疗附近半径$a1码范围内的所有小队成员。';

UPDATE `locales_spell` SET `description_loc4` = '治疗目标，每$t1秒回复$s1点生命值，持续$d。' WHERE `entry` = 11014 AND `description_loc4` = '治疗目标，在$d内恢复总计$o1点生命值。';

UPDATE `locales_spell` SET `description_loc4` = '火焰冲击的冷却时间减少$/1000;S1秒，公共冷却时间减少$/1000;S2秒。' WHERE `entry` = 11078 AND `description_loc4` = '使你的火焰冲击的冷却时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '火焰冲击的冷却时间减少$/1000;S1秒，公共冷却时间减少$/1000;S2秒。' WHERE `entry` = 11080 AND `description_loc4` = '使你的火焰冲击的冷却时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的灼烧和火焰冲击有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。' WHERE `entry` = 11095 AND `description_loc4` = '使你的灼烧法术有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。';

UPDATE `locales_spell` SET `description_loc4` = '使你的火焰法术的射程增加$s1码，冲击波的影响半径增加$s2%。' WHERE `entry` = 11100 AND `description_loc4` = '使你的火焰法术的射程增加$s1码。';

UPDATE `locales_spell` SET `description_loc4` = '使你有$h%的几率在施放任何一种伤害性法术之后进入节能施法状态。节能施法状态可以使你的下一个伤害性法术所消耗的法力值减少$/10;12536s1%。此效果每10秒可发生一次。' WHERE `entry` = 11213 AND `description_loc4` = '使你有$h%的几率在施放任何一种伤害性法术之后进入节能施法状态。节能施法状态可以使你的下一个伤害性法术所消耗的法力值减少$/10;12536s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的魔法抑制和魔法增效的效果提高$s1%。并允许对敌人施放，仅对等级62或更低的目标有效。' WHERE `entry` = 11247 AND `description_loc4` = '使你的魔法抑制和魔法增效的效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '伏击目标，对其造成$s2%的近战伤害再加上185点额外伤害。必须在潜行状态下从目标背后发动。奖励$s3个连击点数。' WHERE `entry` = 11267 AND `description_loc4` = '伏击目标，对其造成$s2%的武器伤害再加上185点额外伤害。必须在潜行状态下从目标背后发动。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '伏击目标，对其造成$s2%的近战伤害再加上230点额外伤害。必须在潜行状态下从目标背后发动。奖励$s3个连击点数。' WHERE `entry` = 11268 AND `description_loc4` = '伏击目标，对其造成$s2%的武器伤害再加上230点额外伤害。必须在潜行状态下从目标背后发动。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '伏击目标，对其造成$s2%的近战伤害再加上290点额外伤害。必须在潜行状态下从目标背后发动。奖励$s3个连击点数。' WHERE `entry` = 11269 AND `description_loc4` = '伏击目标，对其造成$s2%的武器伤害再加上290点额外伤害。必须在潜行状态下从目标背后发动。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '背刺目标，对其造成近战伤害的$s2%再加135点伤害，必须在目标背后发动，潜行者的主手中必须有一把武器。奖励$s3个连击点数。' WHERE `entry` = 11279 AND `description_loc4` = '背刺目标，对其造成武器伤害的$s2%再加135点伤害，必须在目标背后发动，盗贼的主手中必须有一把武器。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '背刺目标，对其造成近战伤害的$s2%再加165点伤害，必须在目标背后发动，潜行者的主手中必须有一把武器。奖励$s3个连击点数。' WHERE `entry` = 11280 AND `description_loc4` = '背刺目标，对其造成武器伤害的$s2%再加165点伤害，必须在目标背后发动，盗贼的主手中必须有一把武器。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '背刺目标，对其造成近战伤害的$s2%再加210点伤害，必须在目标背后发动，潜行者的主手中必须有一把武器。奖励$s3个连击点数。' WHERE `entry` = 11281 AND `description_loc4` = '背刺目标，对其造成武器伤害的$s2%再加210点伤害，必须在目标背后发动，盗贼的主手中必须有一把武器。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成近战伤害再加上$s1点额外伤害，奖励$s2个连击点数。' WHERE `entry` = 11293 AND `description_loc4` = '对目标造成普通武器伤害再加上$s1点额外伤害，奖励$s2个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成近战伤害再加上$s1点额外伤害，奖励$s2个连击点数。' WHERE `entry` = 11294 AND `description_loc4` = '对目标造成普通武器伤害再加上$s1点额外伤害，奖励$s2个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '以雷霆震击附近的敌人，使它们的攻击间隔延长$s2%，持续$d，并对它们造成$s1点伤害。最多可影响$i个目标。' WHERE `entry` = 11580 AND `description_loc4` = '以雷霆震击附近的敌人，使它们的攻击间隔延长$s2%，持续$d，并对它们造成$s1点自然伤害。最多可影响$i个目标。';

UPDATE `locales_spell` SET `description_loc4` = '以雷霆震击附近的敌人，使它们的攻击间隔延长$s2%，持续$d，并对它们造成$s1点伤害。最多可影响$i个目标。' WHERE `entry` = 11581 AND `description_loc4` = '以雷霆震击附近的敌人，使它们的攻击间隔延长$s2%，持续$d，并对它们造成$s1点自然伤害。最多可影响$i个目标。';

UPDATE `locales_spell` SET `description_loc4` = '立刻压制敌人，对其造成近战伤害外加$s1点伤害。只能在目标躲闪之后使用。压制无法被格档、躲闪或招架。' WHERE `entry` = 11584 AND `description_loc4` = '立刻压制敌人，对其造成武器伤害外加$s1点伤害。只能在目标躲闪之后使用。压制无法被格档、躲闪或招架。';

UPDATE `locales_spell` SET `description_loc4` = '立刻压制敌人，对其造成近战伤害外加$s1点伤害。只能在目标躲闪之后使用。压制无法被格档、躲闪或招架。' WHERE `entry` = 11585 AND `description_loc4` = '立刻压制敌人，对其造成武器伤害外加$s1点伤害。只能在目标躲闪之后使用。压制无法被格档、躲闪或招架。';

UPDATE `locales_spell` SET `description_loc4` = '猛击敌人，对其造成$45599s1%的武器伤害，可在移动时使用。' WHERE `entry` = 11604 AND `description_loc4` = '猛击敌人，对其造成武器伤害再加上$s1点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '猛击敌人，对其造成$45960s1%的武器伤害，可在移动时使用。' WHERE `entry` = 11605 AND `description_loc4` = '猛击敌人，对其造成武器伤害再加上$s1点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '横扫攻击，对目标和它身边最近的一个敌人造成近战伤害再加上$s1点伤害。' WHERE `entry` = 11608 AND `description_loc4` = '横扫攻击，对目标和它身边最近的一个敌人造成武器伤害再加上$s1点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '横扫攻击，对目标和它身边最近的一个敌人造成近战伤害再加上$s1点伤害。' WHERE `entry` = 11609 AND `description_loc4` = '横扫攻击，对目标和它身边最近的一个敌人造成武器伤害再加上$s1点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '召唤出苏萨斯的双刃。' WHERE `entry` = 11651 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '召唤出苏萨斯的双刃。' WHERE `entry` = 11652 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '以苏萨斯之怒攻击敌人，造成$s1点暗影伤害，并在$d内对其造成$o3点额外伤害，并使其物理伤害降低$s2点。' WHERE `entry` = 11658 AND `description_loc4` = '以苏萨斯之怒攻击敌人，使其力量降低$s2点，造成$s1点暗影伤害，并在接下来的$d内对其造成总计$o3点额外伤害。';

UPDATE `locales_spell` SET `description_loc4` = '吸取目标的灵魂，在$d内对其造成累计$*6;s2点暗影伤害。如果目标在被吸取灵魂的过程中死亡，且施法者因此获得经验值或荣誉，则施法者可以得到一块灵魂碎片。灵魂碎片是施放其它一些法术所必需的材料。' WHERE `entry` = 11675 AND `description_loc4` = '吸取目标的灵魂，在$d内对其造成累计$o2点暗影伤害。如果目标在被吸取灵魂的过程中死亡，且施法者因此获得经验值或荣誉，则施法者可以得到一块灵魂碎片。灵魂碎片是施放其它一些法术所必需的材料。';

UPDATE `locales_spell` SET `description_loc4` = '引导此法术时，每秒将$s1点生命值转移给你的恶魔，持续$d。' WHERE `entry` = 11693 AND `description_loc4` = '只要施法者保持着引导法术的状态，就会每秒钟将$s1点生命值转移给施法者的宠物，最多持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '引导此法术时，每秒将$s1点生命值转移给你的恶魔，持续$d。' WHERE `entry` = 11694 AND `description_loc4` = '只要施法者保持着引导法术的状态，就会每秒钟将$s1点生命值转移给施法者的宠物，最多持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '引导此法术时，每秒将$s1点生命值转移给你的恶魔，持续$d。' WHERE `entry` = 11695 AND `description_loc4` = '只要施法者保持着引导法术的状态，就会每秒钟将$s1点生命值转移给施法者的宠物，最多持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '在$d内将目标$*5;s1点生命值转移给施法者。' WHERE `entry` = 11699 AND `description_loc4` = '每秒钟吸取目标$s1点生命值，并将其转移给施法者，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '在$d内将目标$*5;s1点生命值转移给施法者。' WHERE `entry` = 11700 AND `description_loc4` = '每秒钟吸取目标$s1点生命值，并将其转移给施法者，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '目标所能造成的伤害降低$s1点，持续$d。每个术士只能对一个目标施加一种诅咒。' WHERE `entry` = 11707 AND `description_loc4` = '目标所能造成的伤害降低$s1点，持续$d。每个术士只能对一个目标施加一种诅咒，且同类诅咒不能叠加。';

UPDATE `locales_spell` SET `description_loc4` = '目标所能造成的伤害降低$s1点，持续$d。每个术士只能对一个目标施加一种诅咒。' WHERE `entry` = 11708 AND `description_loc4` = '目标所能造成的伤害降低$s1点，持续$d。每个术士只能对一个目标施加一种诅咒，且同类诅咒不能叠加。';

UPDATE `locales_spell` SET `description_loc4` = '给目标施加痛苦的诅咒，使其在$d内受到$*12;s1点暗影伤害。这种伤害在初期会缓慢生效，但是会在作用效果期间不断加速，直到结束。每个术士只能对一个目标施加一种诅咒。' WHERE `entry` = 11711 AND `description_loc4` = '给目标施加痛苦的诅咒，使其在$d内受到$o1点伤害。这种伤害在初期会缓慢生效，但是会在作用效果期间不断加速，直到结束。每个术士只能对一个目标施加一种诅咒，且同类诅咒不能叠加。';

UPDATE `locales_spell` SET `description_loc4` = '给目标施加痛苦的诅咒，使其在$d内受到$*12;s1点暗影伤害。这种伤害在初期会缓慢生效，但是会在作用效果期间不断加速，直到结束。每个术士只能对一个目标施加一种诅咒。' WHERE `entry` = 11712 AND `description_loc4` = '给目标施加痛苦的诅咒，使其在$d内受到$o1点伤害。这种伤害在初期会缓慢生效，但是会在作用效果期间不断加速，直到结束。每个术士只能对一个目标施加一种诅咒，且同类诅咒不能叠加。';

UPDATE `locales_spell` SET `description_loc4` = '给目标施加痛苦的诅咒，使其在$d内受到$*12;s1点暗影伤害。这种伤害在初期会缓慢生效，但是会在作用效果期间不断加速，直到结束。每个术士只能对一个目标施加一种诅咒。' WHERE `entry` = 11713 AND `description_loc4` = '给目标施加痛苦的诅咒，使其在$d内受到$o1点伤害。这种伤害在初期会缓慢生效，但是会在作用效果期间不断加速，直到结束。每个术士只能对一个目标施加一种诅咒，且同类诅咒不能叠加。';

UPDATE `locales_spell` SET `description_loc4` = '奴役等级不高于$m1级的恶魔，令其听从你的命令。被奴役的恶魔的攻击间隔延长$s2%，施法速度降低$s3%，受到治疗效果降低$58184s1%。奴役效果最多持续$d。如果你反复奴役同一个恶魔，它摆脱控制的几率会越来越大。' WHERE `entry` = 11725 AND `description_loc4` = '奴役等级不高于$m1级的恶魔，令其听从你的命令。被奴役的恶魔的攻击间隔延长$s2%，施法速度降低$s3%。奴役效果最多持续$d。如果你反复奴役同一个恶魔，它摆脱控制的几率会越来越大。';

UPDATE `locales_spell` SET `description_loc4` = '奴役等级不高于$m1级的恶魔，令其听从你的命令。被奴役的恶魔的攻击间隔延长$s2%，施法速度降低$s3%，受到治疗效果降低$58184s1%。奴役效果最多持续$d。如果你反复奴役同一个恶魔，它摆脱控制的几率会越来越大。' WHERE `entry` = 11726 AND `description_loc4` = '奴役等级不高于$m1级的恶魔，令其听从你的命令。被奴役的恶魔的攻击间隔延长$s2%，施法速度降低$s3%。奴役效果最多持续$d。如果你反复奴役同一个恶魔，它摆脱控制的几率会越来越大。';

UPDATE `locales_spell` SET `description_loc4` = '安抚目标，使魅魔和她召唤者术士之前所产生的所有仇恨值降低$s1%。' WHERE `entry` = 11784 AND `description_loc4` = '安抚目标，提高令它不再攻击你的几率。比安抚之吻（等级 2）更有效。';

UPDATE `locales_spell` SET `description_loc4` = '安抚目标，使魅魔和她召唤者术士之前所产生的所有仇恨值降低$s1%。' WHERE `entry` = 11785 AND `description_loc4` = '安抚目标，提高令它不再攻击你的几率。比安抚之吻（等级 3）更有效。';

UPDATE `locales_spell` SET `description_loc4` = '激活后，你的施法速度提高$s1%，但每秒消耗$s2%的总法力值，并使所有法力值恢复效果减少$s3%。

UPDATE `locales_spell` SET `description_loc4` = '使你的双手近战武器造成的伤害提高$s1%，所有双手武器的技能增加1点。' WHERE `entry` = 12163 AND `description_loc4` = '使你的双手近战武器造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的冲锋技能积攒的怒气值提高$/10;s1点。' WHERE `entry` = 12285 AND `description_loc4` = '使你的冲锋技能积攒的怒气值提高$/10;12695s1点。';

UPDATE `locales_spell` SET `description_loc4` = '使你的拳击技能的效果持续时间延长$/1000;s2秒，并有$s1%的几率使目标减速。' WHERE `entry` = 12288 AND `description_loc4` = '使你的拳击技能的效果持续时间延长$/1000;s2秒，并有$s1%的几率使目标眩晕。';

UPDATE `locales_spell` SET `description_loc4` = '你在接下来的$n次技能或主手近战攻击中可以攻击到一个额外的敌人。' WHERE `entry` = 12292 AND `description_loc4` = '你在接下来的$n次近战攻击中可以攻击到一个额外的敌人。';

UPDATE `locales_spell` SET `description_loc4` = '一次邪恶的攻击，对目标造成$s2%的武器伤害，并使目标受伤，任何形式的治疗对其产生的效果降低$s1%，持续$d。' WHERE `entry` = 12294 AND `description_loc4` = '一次邪恶的攻击，对目标造成武器伤害外加$s2点伤害，并使任何形式的治疗对其产生的效果降低$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '使你用盾牌格挡攻击的几率提高$s1%，并且在格档后获得$s2点怒气值。' WHERE `entry` = 12298 AND `description_loc4` = '使你用盾牌格挡攻击的几率提高$s1%，在成功格档后有$h%的几率得到1点怒气。';

UPDATE `locales_spell` SET `description_loc4` = '使你因装备而获得的护甲值提高$s1%，并且你的盾牌吸收的伤害量提高$s2%。' WHERE `entry` = 12299 AND `description_loc4` = '使你因装备而获得的护甲值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的血性狂暴技能激活瞬间所产生的怒气值增加$/10;s1点。' WHERE `entry` = 12301 AND `description_loc4` = '使你的血性狂暴技能激活时所产生的怒气值增加$/10;s1点。';

UPDATE `locales_spell` SET `description_loc4` = '使你在防御姿态下造成的威胁值提高$s1%。' WHERE `entry` = 12303 AND `description_loc4` = '使你在防御姿态下由于攻击而造成的威胁值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的盾牌猛击有$h%几率额外再驱散目标身上1个魔法效果，盾击技能有50%的几率使目标沉默$18498d。' WHERE `entry` = 12311 AND `description_loc4` = '使你的盾击技能有$h%的几率使目标沉默$18498d。';

UPDATE `locales_spell` SET `description_loc4` = '盾墙的持续时间延长$/1000;s1秒，冷却时间减少$/60000;s2分钟。' WHERE `entry` = 12312 AND `description_loc4` = '使你的盾墙技能的有效时间延长$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的缴械技能的冷却时间减少$/1000;s1秒。' WHERE `entry` = 12313 AND `description_loc4` = '使你的缴械技能的效果持续时间延长$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '受到敌人的致命一击之后，你造成的近战伤害获得$12880s1%的额外加成，持续$12880d。' WHERE `entry` = 12317 AND `description_loc4` = '使你在遭到敌人的致命一击之后所进行的最多$12880n次近战攻击都获得$12880s1%的额外伤害加值，效果持续$12880d。';

UPDATE `locales_spell` SET `description_loc4` = '在你的普通近战攻击打出致命一击之后，使你的下$12966n次近战攻击速度提高$12966s1%。' WHERE `entry` = 12319 AND `description_loc4` = '在你的普通近战攻击打出致命一击之后，使你的下3次近战攻击速度提高$12966s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有怒吼的作用范围提高$s2%，战斗怒吼和挫志怒吼的持续时间提高$s1%。' WHERE `entry` = 12321 AND `description_loc4` = '使你的战斗怒吼和挫志怒吼效果的作用范围和持续时间提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你有$h1%的几率在对敌人造成近战伤害之后获得额外的怒气值，双手武器的效果加倍。' WHERE `entry` = 12322 AND `description_loc4` = '使你有$h1%的几率在对敌人造成近战伤害之后获得1个额外的怒气点数。';

UPDATE `locales_spell` SET `description_loc4` = '使你的猛击技能的施放时间和公共冷却时间减少$/1000;S1秒。' WHERE `entry` = 12330 AND `description_loc4` = '使你的猛击技能的施放时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '火焰冲击的冷却时间减少$/1000;S1秒，公共冷却时间减少$/1000;S2秒。' WHERE `entry` = 12342 AND `description_loc4` = '使你的火焰冲击的冷却时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的火焰法术的射程增加$s1码，冲击波的影响半径增加$s2%。' WHERE `entry` = 12353 AND `description_loc4` = '使你的火焰法术的射程增加$s1码。';

UPDATE `locales_spell` SET `description_loc4` = '使你有$h%的几率在施放任何一种伤害性法术之后进入节能施法状态。节能施法状态可以使你的下一个伤害性法术所消耗的法力值减少$/10;12536s1%。此效果每10秒可发生一次。' WHERE `entry` = 12574 AND `description_loc4` = '使你有$h%的几率在施放任何一种伤害性法术之后进入节能施法状态。节能施法状态可以使你的下一个伤害性法术所消耗的法力值减少$/10;12536s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你有$h%的几率在施放任何一种伤害性法术之后进入节能施法状态。节能施法状态可以使你的下一个伤害性法术所消耗的法力值减少$/10;12536s1%。此效果每10秒可发生一次。' WHERE `entry` = 12575 AND `description_loc4` = '使你有$h%的几率在施放任何一种伤害性法术之后进入节能施法状态。节能施法状态可以使你的下一个伤害性法术所消耗的法力值减少$/10;12536s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你有$h%的几率在施放任何一种伤害性法术之后进入节能施法状态。节能施法状态可以使你的下一个伤害性法术所消耗的法力值减少$/10;12536s1%。此效果每10秒可发生一次。' WHERE `entry` = 12576 AND `description_loc4` = '使你有$h%的几率在施放任何一种伤害性法术之后进入节能施法状态。节能施法状态可以使你的下一个伤害性法术所消耗的法力值减少$/10;12536s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你有$h%的几率在施放任何一种伤害性法术之后进入节能施法状态。节能施法状态可以使你的下一个伤害性法术所消耗的法力值减少$/10;12536s1%。此效果每10秒可发生一次。' WHERE `entry` = 12577 AND `description_loc4` = '使你有$h%的几率在施放任何一种伤害性法术之后进入节能施法状态。节能施法状态可以使你的下一个伤害性法术所消耗的法力值减少$/10;12536s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的冲锋技能积攒的怒气值提高$/10;s1点。' WHERE `entry` = 12697 AND `description_loc4` = '使你的冲锋技能积攒的怒气值提高$/10;12696s1点。';

UPDATE `locales_spell` SET `description_loc4` = '使你的拳击技能的效果持续时间延长$/1000;s2秒，并有$s1%的几率使目标减速。' WHERE `entry` = 12707 AND `description_loc4` = '使你的拳击技能的效果持续时间延长$/1000;s2秒，并有$s1%的几率使目标眩晕。';

UPDATE `locales_spell` SET `description_loc4` = '使你的拳击技能有$s1%的几率使目标减速。' WHERE `entry` = 12708 AND `description_loc4` = '使你的拳击技能有$s1%的几率使目标眩晕。';

UPDATE `locales_spell` SET `description_loc4` = '使你的双手近战武器造成的伤害提高$s1%，所有双手武器的技能增加2点。' WHERE `entry` = 12711 AND `description_loc4` = '使你的双手近战武器造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的双手近战武器造成的伤害提高$s1%，所有双手武器的技能增加3点。' WHERE `entry` = 12712 AND `description_loc4` = '使你的双手近战武器造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你用盾牌格挡攻击的几率提高$s1%，并且在格档后获得$s2点怒气值。' WHERE `entry` = 12724 AND `description_loc4` = '使你用盾牌格挡攻击的几率提高$s1%，在成功格档后有$h%的几率得到1点怒气。';

UPDATE `locales_spell` SET `description_loc4` = '使你用盾牌格挡攻击的几率提高$s1%，并且在格档后获得$s2点怒气值。' WHERE `entry` = 12725 AND `description_loc4` = '使你用盾牌格挡攻击的几率提高$s1%，在成功格档后有$h%的几率得到1点怒气。';

UPDATE `locales_spell` SET `description_loc4` = '使你用盾牌格挡攻击的几率提高$s1%，并且在格档后获得$s2点怒气值。' WHERE `entry` = 12726 AND `description_loc4` = '使你用盾牌格挡攻击的几率提高$s1%，在成功格档后有$h%的几率得到1点怒气。';

UPDATE `locales_spell` SET `description_loc4` = '使你用盾牌格挡攻击的几率提高$s1%，并且在格档后获得$s2点怒气值。' WHERE `entry` = 12727 AND `description_loc4` = '使你用盾牌格挡攻击的几率提高$s1%，在成功格档后有$h%的几率得到1点怒气。';

UPDATE `locales_spell` SET `description_loc4` = '使你因装备而获得的护甲值提高$s1%，并且你的盾牌吸收的伤害量提高$s2%。' WHERE `entry` = 12761 AND `description_loc4` = '使你因装备而获得的护甲值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你因装备而获得的护甲值提高$s1%，并且你的盾牌吸收的伤害量提高$s2%。' WHERE `entry` = 12762 AND `description_loc4` = '使你因装备而获得的护甲值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你因装备而获得的护甲值提高$s1%，并且你的盾牌吸收的伤害量提高$s2%。' WHERE `entry` = 12763 AND `description_loc4` = '使你因装备而获得的护甲值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你因装备而获得的护甲值提高$s1%，并且你的盾牌吸收的伤害量提高$s2%。' WHERE `entry` = 12764 AND `description_loc4` = '使你因装备而获得的护甲值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你在防御姿态下造成的威胁值提高$s1%。' WHERE `entry` = 12788 AND `description_loc4` = '使你在防御姿态下由于攻击而造成的威胁值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你在防御姿态下造成的威胁值提高$s1%。' WHERE `entry` = 12789 AND `description_loc4` = '使你在防御姿态下由于攻击而造成的威胁值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你在防御姿态下造成的威胁值提高$s1%。' WHERE `entry` = 12791 AND `description_loc4` = '使你在防御姿态下由于攻击而造成的威胁值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你在防御姿态下造成的威胁值提高$s1%。' WHERE `entry` = 12792 AND `description_loc4` = '使你在防御姿态下由于攻击而造成的威胁值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的复仇技能有$h1%的几率令目标昏迷$12798d，并且冷却时间减少$/1000;S2秒。' WHERE `entry` = 12797 AND `description_loc4` = '使你的复仇技能有$h1%的几率令目标昏迷$12798d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的复仇技能有$h1%的几率令目标昏迷$12798d，并且冷却时间减少$/1000;S2秒。' WHERE `entry` = 12799 AND `description_loc4` = '使你的复仇技能有$h1%的几率令目标昏迷$12798d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的复仇技能有$h1%的几率令目标昏迷$12798d，并且冷却时间减少$/1000;S2秒。' WHERE `entry` = 12800 AND `description_loc4` = '使你的复仇技能有$h1%的几率令目标昏迷$12798d。';

UPDATE `locales_spell` SET `description_loc4` = '盾墙的持续时间延长$/1000;s1秒，冷却时间减少$/60000;s2分钟。' WHERE `entry` = 12803 AND `description_loc4` = '使你的盾墙技能的有效时间延长$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的缴械技能的冷却时间减少$/1000;s1秒。' WHERE `entry` = 12804 AND `description_loc4` = '使你的缴械技能的效果持续时间延长$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的缴械技能的冷却时间减少$/1000;s1秒。' WHERE `entry` = 12807 AND `description_loc4` = '使你的缴械技能的效果持续时间延长$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '立即产生$/10;s3点怒气值，对目标造成$s2点伤害，并使其昏迷$d。此技能造成大量威胁值，并可穿透敌人100%的护甲。' WHERE `entry` = 12809 AND `description_loc4` = '野蛮的攻击，令目标昏迷$d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的血性狂暴技能激活瞬间所产生的怒气值增加$/10;s1点。' WHERE `entry` = 12818 AND `description_loc4` = '使你的血性狂暴技能激活时所产生的怒气值增加$/10;s1点。';

UPDATE `locales_spell` SET `description_loc4` = '你的致命一击导致目标流血，使其在$12721d内遭受相当于你的武器平均伤害值的20%的伤害。' WHERE `entry` = 12834 AND `description_loc4` = '你的致命一击导致目标流血，使其在12秒内遭受相当于你的武器平均伤害值的20%的伤害。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有怒吼的作用范围提高$s2%，战斗怒吼和挫志怒吼的持续时间提高$s1%。' WHERE `entry` = 12835 AND `description_loc4` = '使你的战斗怒吼和挫志怒吼效果的作用范围和持续时间提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有怒吼的作用范围提高$s2%，战斗怒吼和挫志怒吼的持续时间提高$s1%。' WHERE `entry` = 12836 AND `description_loc4` = '使你的战斗怒吼和挫志怒吼效果的作用范围和持续时间提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有怒吼的作用范围提高$s2%，战斗怒吼和挫志怒吼的持续时间提高$s1%。' WHERE `entry` = 12837 AND `description_loc4` = '使你的战斗怒吼和挫志怒吼效果的作用范围和持续时间提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有怒吼的作用范围提高$s2%，战斗怒吼和挫志怒吼的持续时间提高$s1%。' WHERE `entry` = 12838 AND `description_loc4` = '使你的战斗怒吼和挫志怒吼效果的作用范围和持续时间提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的致命一击导致目标流血，使其在$12721d内遭受相当于你的武器平均伤害值的40%的伤害。' WHERE `entry` = 12849 AND `description_loc4` = '你的致命一击导致目标流血，使其在12秒内遭受相当于你的武器平均伤害值的40%的伤害。';

UPDATE `locales_spell` SET `description_loc4` = '使你的猛击技能的施放时间和公共冷却时间减少$/1000;S1秒。' WHERE `entry` = 12862 AND `description_loc4` = '使你的猛击技能的施放时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '你的致命一击导致目标流血，使其在$12721d内遭受相当于你的武器平均伤害值的60%的伤害。' WHERE `entry` = 12867 AND `description_loc4` = '你的致命一击导致目标流血，使其在12秒内遭受相当于你的武器平均伤害值的60%的伤害。';

UPDATE `locales_spell` SET `description_loc4` = '使你的灼烧和火焰冲击有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。' WHERE `entry` = 12872 AND `description_loc4` = '使你的灼烧法术有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。';

UPDATE `locales_spell` SET `description_loc4` = '使你的灼烧和火焰冲击有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。' WHERE `entry` = 12873 AND `description_loc4` = '使你的灼烧法术有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。';

UPDATE `locales_spell` SET `description_loc4` = '使你的灼烧和火焰冲击有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。' WHERE `entry` = 12874 AND `description_loc4` = '使你的灼烧法术有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。';

UPDATE `locales_spell` SET `description_loc4` = '使你的灼烧和火焰冲击有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。' WHERE `entry` = 12875 AND `description_loc4` = '使你的灼烧法术有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。';

UPDATE `locales_spell` SET `description_loc4` = '使你的盾牌猛击有$h%几率额外再驱散目标身上1个魔法效果，盾击技能有100%的几率使目标沉默$18498d。' WHERE `entry` = 12958 AND `description_loc4` = '使你的盾击技能有$h%的几率使目标沉默$18498d。';

UPDATE `locales_spell` SET `description_loc4` = '在你的普通近战攻击打出致命一击之后，使你的下$12967n次近战攻击速度提高$12967s1%。' WHERE `entry` = 12971 AND `description_loc4` = '在你的普通近战攻击打出致命一击之后，使你的下3次近战攻击速度提高$12967s1%。';

UPDATE `locales_spell` SET `description_loc4` = '在你的普通近战攻击打出致命一击之后，使你的下$12968n次近战攻击速度提高$12968s1%。' WHERE `entry` = 12972 AND `description_loc4` = '在你的普通近战攻击打出致命一击之后，使你的下3次近战攻击速度提高$12968s1%。';

UPDATE `locales_spell` SET `description_loc4` = '在你的普通近战攻击打出致命一击之后，使你的下$12969n次近战攻击速度提高$12969s1%。' WHERE `entry` = 12973 AND `description_loc4` = '在你的普通近战攻击打出致命一击之后，使你的下3次近战攻击速度提高$12969s1%。';

UPDATE `locales_spell` SET `description_loc4` = '在你的普通近战攻击打出致命一击之后，使你的下$12970n次近战攻击速度提高$12970s1%。' WHERE `entry` = 12974 AND `description_loc4` = '在你的普通近战攻击打出致命一击之后，使你的下3次近战攻击速度提高$12970s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你有$h1%的几率在对敌人造成近战伤害之后获得额外的怒气值，双手武器的效果加倍。' WHERE `entry` = 12999 AND `description_loc4` = '使你有$h1%的几率在对敌人造成近战伤害之后获得1个额外的怒气点数。';

UPDATE `locales_spell` SET `description_loc4` = '使你有$h1%的几率在对敌人造成近战伤害之后获得额外的怒气值，双手武器的效果加倍。' WHERE `entry` = 13000 AND `description_loc4` = '使你有$h1%的几率在对敌人造成近战伤害之后获得1个额外的怒气点数。';

UPDATE `locales_spell` SET `description_loc4` = '使你有$h1%的几率在对敌人造成近战伤害之后获得额外的怒气值，双手武器的效果加倍。' WHERE `entry` = 13001 AND `description_loc4` = '使你有$h1%的几率在对敌人造成近战伤害之后获得1个额外的怒气点数。';

UPDATE `locales_spell` SET `description_loc4` = '使你有$h1%的几率在对敌人造成近战伤害之后获得额外的怒气值，双手武器的效果加倍。' WHERE `entry` = 13002 AND `description_loc4` = '使你有$h1%的几率在对敌人造成近战伤害之后获得1个额外的怒气点数。';

UPDATE `locales_spell` SET `description_loc4` = '立即为你加上魔法护盾，可吸收$s1点伤害，并使你的冰霜伤害提高$52914s1%，持续$d。护盾存在期间，施法不会因受到伤害而延迟，且冰霜伤害额外提高$s2%。' WHERE `entry` = 13033 AND `description_loc4` = '立即为你加上魔法护盾，可吸收$s1点伤害，持续$d。只要护盾存在，受保护者的施法就不会被打断。';

UPDATE `locales_spell` SET `description_loc4` = '受到敌人的致命一击之后，你造成的近战伤害获得$14201s1%的额外加成，持续$14201d。' WHERE `entry` = 13045 AND `description_loc4` = '使你在遭到敌人的致命一击之后所进行的最多$14201n次近战攻击都获得$14201s1%的额外伤害加值，效果持续$14201d。';

UPDATE `locales_spell` SET `description_loc4` = '受到敌人的致命一击之后，你造成的近战伤害获得$14202s1%的额外加成，持续$14202d。' WHERE `entry` = 13046 AND `description_loc4` = '使你在遭到敌人的致命一击之后所进行的最多$14202n次近战攻击都获得$14202s1%的额外伤害加值，效果持续$14202d。';

UPDATE `locales_spell` SET `description_loc4` = '受到敌人的致命一击之后，你造成的近战伤害获得$14203s1%的额外加成，持续$14203d。' WHERE `entry` = 13047 AND `description_loc4` = '使你在遭到敌人的致命一击之后所进行的最多$14203n次近战攻击都获得$14203s1%的额外伤害加值，效果持续$14203d。';

UPDATE `locales_spell` SET `description_loc4` = '受到敌人的致命一击之后，你造成的近战伤害获得$14204s1%的额外加成，持续$14204d。' WHERE `entry` = 13048 AND `description_loc4` = '使你在遭到敌人的致命一击之后所进行的最多$14204n次近战攻击都获得$14204s1%的额外伤害加值，效果持续$14204d。';

UPDATE `locales_spell` SET `description_loc4` = '猎人和$g他:她;周围半径$a1码范围内的队友均获得豹群守护的效果，使移动速度提高$s1%。如果获得豹群守护效果的玩家受到伤害，则该玩家会眩晕$15571d。一个猎人在同一时间内只能激活一种守护。' WHERE `entry` = 13159 AND `description_loc4` = '猎人和$g他:她;周围半径$a1码范围内的队友均获得豹群守护的效果，使移动速度提高$s1%。如果任何一个队友受到伤害，则全队都会眩晕$15571d。一个猎人在同一时间内只能激活一种守护。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 13198 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一面盾牌附魔，使其获得耐力+1的效果。' WHERE `entry` = 13378 AND `description_loc4` = '永久性地为一面盾牌附魔，使它获得耐力+1的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把双手近战武器附魔，使其获得精神+3的效果。' WHERE `entry` = 13380 AND `description_loc4` = '永久性地为一把双手近战武器附魔，使它获得精神+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件双手武器永久性地附魔，使其获得+3精神的效果。' WHERE `entry` = 13393 AND `description_loc4` = '教你学会给一件双手武器永久性地附魔，使它获得+3精神的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得敏捷+1的效果。' WHERE `entry` = 13419 AND `description_loc4` = '永久性地为一件披风附魔，使它获得敏捷+1的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件披风永久性地附魔，使其获得+1敏捷的效果。' WHERE `entry` = 13420 AND `description_loc4` = '教你学会给一件披风永久性地附魔，使它获得+1敏捷的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得护甲+20的效果。' WHERE `entry` = 13421 AND `description_loc4` = '永久性地为一件披风附魔，使它获得护甲+20的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一面盾牌附魔，使其获得护甲+30的效果。' WHERE `entry` = 13464 AND `description_loc4` = '永久性地为一面盾牌附魔，使它获得护甲+30的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一面盾牌永久性地附魔，使其获得+30护甲的效果。' WHERE `entry` = 13465 AND `description_loc4` = '教你学会给一面盾牌永久性地附魔，使它获得+30护甲的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一面盾牌附魔，使其获得精神+3的效果。' WHERE `entry` = 13485 AND `description_loc4` = '永久性地为一面盾牌附魔，使它获得精神+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '为武器充能，使其攻击速度提高$s1%，持续$d1。' WHERE `entry` = 13494 AND `description_loc4` = '使你的攻击速度提高$s1%，持续$d1。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 13500 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得耐力+3的效果。' WHERE `entry` = 13501 AND `description_loc4` = '永久性地为一只护腕附魔，使它获得耐力+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其获得伤害+2的效果。' WHERE `entry` = 13503 AND `description_loc4` = '永久性地为一把近战武器附魔，使它获得伤害+2的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得暗影抗性+10的效果。' WHERE `entry` = 13522 AND `description_loc4` = '永久性地为一件披风附魔，使它获得暗影抗性+10的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件披风永久性地附魔，使其获得+10暗影抗性的效果。' WHERE `entry` = 13525 AND `description_loc4` = '教你学会给一件披风永久性地附魔，使它获得10点暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把双手近战武器附魔，使其获得伤害+3的效果。' WHERE `entry` = 13529 AND `description_loc4` = '永久性地为一把双手近战武器附魔，使它获得伤害+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得力量+3的效果。' WHERE `entry` = 13536 AND `description_loc4` = '永久性地为一只护腕附魔，使它获得力量+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一副护腕永久性地附魔，使其获得+3力量的效果。' WHERE `entry` = 13537 AND `description_loc4` = '教你学会给一只护腕永久性地附魔，使它获得+3力量的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其每次被击中时都有5%的机会吸收25点伤害。' WHERE `entry` = 13538 AND `description_loc4` = '为一件胸甲附魔，使它每次被击中时都有5%的机会吸收25点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得法力值+30的效果。' WHERE `entry` = 13607 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得法力值+30的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得采矿技能+2的效果。' WHERE `entry` = 13612 AND `description_loc4` = '永久性地为一双手套附魔， 使它们获得采矿技能+2的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双手套永久性地附魔，使其获得+2采矿技能的效果。' WHERE `entry` = 13613 AND `description_loc4` = '教你学会给一双手套永久性地附魔，使它获得+2采矿技能的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得草药学技能+2的效果。' WHERE `entry` = 13617 AND `description_loc4` = '永久性地为一双手套附魔， 使它们获得草药学技能+2的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双手套永久性地附魔，使其获得+2草药学技能的效果。' WHERE `entry` = 13618 AND `description_loc4` = '教你学会给一双手套永久性地附魔，使它获得+2草药学技能的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得钓鱼技能+2的效果。' WHERE `entry` = 13620 AND `description_loc4` = '永久性地为一双手套附魔， 使它们获得钓鱼技能+2的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双手套永久性地附魔，使其获得+2钓鱼技能的效果。' WHERE `entry` = 13621 AND `description_loc4` = '教你学会给一双手套永久性地附魔，使它获得+2钓鱼技能的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得智力+3的效果。' WHERE `entry` = 13622 AND `description_loc4` = '永久性地为一只护腕附魔，使它获得智力+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得所有属性+1的效果。' WHERE `entry` = 13626 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得所有属性+1的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一面盾牌附魔，使其获得耐力+3的效果。' WHERE `entry` = 13631 AND `description_loc4` = '永久性地为一面盾牌附魔，使它获得耐力+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得护甲+30的效果。' WHERE `entry` = 13635 AND `description_loc4` = '永久性地为一件披风附魔，使它获得护甲+30的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双靴子附魔，使其获得敏捷+3的效果。' WHERE `entry` = 13637 AND `description_loc4` = '永久性地为一双靴子附魔，使它们获得敏捷+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得生命值+35的效果。' WHERE `entry` = 13640 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得生命值+35的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得精神+5的效果。' WHERE `entry` = 13642 AND `description_loc4` = '永久性地为一副护腕附魔，使它们获得精神+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双靴子附魔，使其获得耐力+3的效果。' WHERE `entry` = 13644 AND `description_loc4` = '永久性地为一双靴子附魔，使它们获得耐力+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得防御+2的效果。' WHERE `entry` = 13646 AND `description_loc4` = '永久性地为一副护腕附魔，使它们获得防御+2的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一副护腕永久性地附魔，使其获得+2防御值的效果。' WHERE `entry` = 13647 AND `description_loc4` = '教你学会给一只护腕永久性地附魔，使它获得+2防御值的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得耐力+5的效果。' WHERE `entry` = 13648 AND `description_loc4` = '永久性地为一副护腕附魔，使它们获得耐力+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其获得对野兽伤害+6的效果。' WHERE `entry` = 13653 AND `description_loc4` = '永久性地为一把近战武器附魔，使它获得对野兽伤害+6的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件近战武器永久性地附魔，使其获得+6对野兽伤害的效果。' WHERE `entry` = 13654 AND `description_loc4` = '教你学会给一件武器永久性地附魔，使它可以对野兽的伤害+6。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其获得对元素生物伤害+6的效果。' WHERE `entry` = 13655 AND `description_loc4` = '永久性地为一把近战武器附魔，使它获得对元素生物伤害+6的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件近战武器永久性地附魔，使其获得+6对元素生物伤害的效果。' WHERE `entry` = 13656 AND `description_loc4` = '教你学会给一件武器永久性地附魔，使它可以对元素生物的伤害+6。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得火焰抗性+7的效果。' WHERE `entry` = 13657 AND `description_loc4` = '永久性地为一件披风附魔，使它获得火焰抗性+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一面盾牌附魔，使其获得精神+5的效果。' WHERE `entry` = 13659 AND `description_loc4` = '永久性地为一面盾牌附魔，使它获得精神+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得力量+5的效果。' WHERE `entry` = 13661 AND `description_loc4` = '永久性地为一副护腕附魔，使它们获得力量+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得法力值+50的效果。' WHERE `entry` = 13663 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得法力值+50的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双靴子附魔，使其获得精神+3的效果。' WHERE `entry` = 13687 AND `description_loc4` = '永久性地为一双靴子附魔，使它们获得精神+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双靴子永久性地附魔，使其获得+3精神的效果。' WHERE `entry` = 13688 AND `description_loc4` = '教你学会给一双靴子永久性地附魔，使它获得+3精神的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一面盾牌附魔，使其获得格挡几率+2%的效果。' WHERE `entry` = 13689 AND `description_loc4` = '永久性地为一面盾牌附魔，使它获得格挡几率+2%的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一面盾牌永久性地附魔，使其获得+2%的格挡几率。' WHERE `entry` = 13691 AND `description_loc4` = '教你学会给一面盾牌永久性地附魔，使它获得+2%的格挡几率。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其获得伤害+3的效果。' WHERE `entry` = 13693 AND `description_loc4` = '永久性地为一把近战武器附魔，使它获得伤害+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把双手近战武器附魔，使其获得伤害+5的效果。' WHERE `entry` = 13695 AND `description_loc4` = '永久性地为一把双手近战武器附魔，使它获得伤害+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得剥皮技能+5的效果。' WHERE `entry` = 13698 AND `description_loc4` = '永久性地为一双手套附魔， 使它们获得剥皮技能+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双手套永久性地附魔，使其获得+5剥皮技能的效果。' WHERE `entry` = 13699 AND `description_loc4` = '教你学会给一双手套永久性地附魔，使它获得+5剥皮技能的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得所有属性+2的效果。' WHERE `entry` = 13700 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得所有属性+2的效果。';

UPDATE `locales_spell` SET `description_loc4` = '使你的锤类武器击中目标时有$h%的机会将其击晕$5530d。' WHERE `entry` = 13709 AND `description_loc4` = '使你的锤类武器技能提高$s2点，用锤类武器击中目标时有$h%的机会将其击晕$5530d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的背刺技能造成致命一击的几率提高$s1%，并且背刺有$s2%的几率使你获得一个额外的连击点数。' WHERE `entry` = 13733 AND `description_loc4` = '使你的背刺技能造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 13735 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得护甲+50的效果。' WHERE `entry` = 13746 AND `description_loc4` = '永久性地为一件披风附魔，使它获得护甲+50的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得所有魔法抗性+3的效果。' WHERE `entry` = 13794 AND `description_loc4` = '永久性地为一件披风附魔，使它获得所有魔法抗性+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '使你的锤类武器击中目标时有$h%的机会将其击晕$5530d。' WHERE `entry` = 13800 AND `description_loc4` = '使你的锤类武器技能提高$s2点，用锤类武器击中目标时有$h%的机会将其击晕$5530d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的锤类武器击中目标时有$h%的机会将其击晕$5530d。' WHERE `entry` = 13801 AND `description_loc4` = '使你的锤类武器技能提高$s2点，用锤类武器击中目标时有$h%的机会将其击晕$5530d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的锤类武器击中目标时有$h%的机会将其击晕$5530d。' WHERE `entry` = 13802 AND `description_loc4` = '使你的锤类武器技能提高$s2点，用锤类武器击中目标时有$h%的机会将其击晕$5530d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的锤类武器击中目标时有$h%的机会将其击晕$5530d。' WHERE `entry` = 13803 AND `description_loc4` = '使你的锤类武器技能提高$s2点，用锤类武器击中目标时有$h%的机会将其击晕$5530d。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得敏捷+5的效果。' WHERE `entry` = 13815 AND `description_loc4` = '永久性地为一双手套附魔， 使它们获得敏捷+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一面盾牌附魔，使其获得耐力+5的效果。' WHERE `entry` = 13817 AND `description_loc4` = '永久性地为一面盾牌附魔，使它获得耐力+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一面盾牌永久性地附魔，使其获得+5耐力的效果。' WHERE `entry` = 13818 AND `description_loc4` = '教你学会给一面盾牌永久性地附魔，使它获得+5耐力的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得智力+5的效果。' WHERE `entry` = 13822 AND `description_loc4` = '永久性地为一副护腕附魔，使它们获得智力+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双靴子附魔，使其获得耐力+5的效果。' WHERE `entry` = 13836 AND `description_loc4` = '永久性地为一双靴子附魔，使它们获得耐力+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得采矿技能+5的效果。' WHERE `entry` = 13841 AND `description_loc4` = '永久性地为一双手套附魔， 使它们获得采矿技能+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双手套永久性地附魔，使其获得+5采矿技能的效果。' WHERE `entry` = 13842 AND `description_loc4` = '教你学会给一双手套永久性地附魔，使它获得+5采矿技能的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得精神+7的效果。' WHERE `entry` = 13846 AND `description_loc4` = '永久性地为一副护腕附魔，使它们获得精神+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一副护腕永久性地附魔，使其获得+7精神的效果。' WHERE `entry` = 13850 AND `description_loc4` = '教你学会给一只护腕永久性地附魔，使它获得+7精神的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得生命值+50的效果。' WHERE `entry` = 13858 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得生命值+50的效果。';

UPDATE `locales_spell` SET `description_loc4` = '使你的背刺技能造成致命一击的几率提高$s1%，并且背刺有$s2%的几率使你获得一个额外的连击点数。' WHERE `entry` = 13865 AND `description_loc4` = '使你的背刺技能造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的背刺技能造成致命一击的几率提高$s1%，并且背刺有$s2%的几率使你获得一个额外的连击点数。' WHERE `entry` = 13866 AND `description_loc4` = '使你的背刺技能造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得草药学技能+5的效果。' WHERE `entry` = 13868 AND `description_loc4` = '永久性地为一双手套附魔， 使它们获得草药学技能+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双手套永久性地附魔，使其获得+5草药学技能的效果。' WHERE `entry` = 13869 AND `description_loc4` = '教你学会给一双手套永久性地附魔，使它获得+5草药学技能的效果。';

UPDATE `locales_spell` SET `description_loc4` = '你的攻击会对附近的一个额外的敌人造成伤害。激活期间，你造成的伤害和能量回复降低$s1%。该效果持续到取消。' WHERE `entry` = 13877 AND `description_loc4` = '使你的攻击速度提高$s1%。另外还可以对附近的一个额外的敌人造成伤害。持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得敏捷+3的效果。' WHERE `entry` = 13882 AND `description_loc4` = '永久性地为一件披风附魔，使它获得敏捷+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件披风永久性地附魔，使其获得+3敏捷的效果。' WHERE `entry` = 13883 AND `description_loc4` = '教你学会给一件披风永久性地附魔，使它获得+3敏捷的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得力量+5的效果。' WHERE `entry` = 13887 AND `description_loc4` = '永久性地为一双手套附魔， 使它们获得力量+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双靴子附魔，使其获得略微提升移动速度的效果。' WHERE `entry` = 13890 AND `description_loc4` = '永久性地为一双靴子附魔，使它们获得略微提升移动速度的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其获得附加$13897s1点火焰伤害的效果。' WHERE `entry` = 13898 AND `description_loc4` = '永久性地为一把近战武器附魔，使它获得附加$13897s1点火焰伤害的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件近战武器永久性地附魔，使其可以对敌人造成火焰伤害。' WHERE `entry` = 13904 AND `description_loc4` = '教你学会给一件武器永久性地附魔，使它可以对敌人造成火焰伤害。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一面盾牌附魔，使其获得精神+7的效果。' WHERE `entry` = 13905 AND `description_loc4` = '永久性地为一面盾牌附魔，使它获得精神+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其获得有一定几率击晕恶魔并对其造成大量伤害的效果。' WHERE `entry` = 13915 AND `description_loc4` = '永久性地为一把近战武器附魔，使它获得有一定几率击晕恶魔并对其造成大量伤害的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件近战武器永久性地附魔，使其可以有一定几率击晕恶魔，并对其造成可观的伤害。' WHERE `entry` = 13916 AND `description_loc4` = '教你学会给一件武器永久性地附魔，使它可以有一定几率击晕恶魔，并对其造成可观的伤害。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得法力值+65的效果。' WHERE `entry` = 13917 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得法力值+65的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得防御+3的效果。' WHERE `entry` = 13931 AND `description_loc4` = '永久性地为一副护腕附魔，使它们获得防御+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一副护腕永久性地附魔，使其获得+3防御值的效果。' WHERE `entry` = 13932 AND `description_loc4` = '教你学会给一只护腕永久性地附魔，使它获得+3防御值的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一面盾牌附魔，使其获得冰霜抗性+8的效果。' WHERE `entry` = 13933 AND `description_loc4` = '永久性地为一面盾牌附魔，使它获得+8冰霜抗性的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一面盾牌永久性地附魔，使其获得+8冰霜抗性的效果。' WHERE `entry` = 13934 AND `description_loc4` = '教你学会给一面盾牌永久性地附魔，使它获得8点冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双靴子附魔，使其获得敏捷+5的效果。' WHERE `entry` = 13935 AND `description_loc4` = '永久性地为一双靴子附魔，使它们获得敏捷+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把双手近战武器附魔，使其获得伤害+7的效果。' WHERE `entry` = 13937 AND `description_loc4` = '永久性地为一把双手近战武器附魔，使它获得伤害+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得力量+7的效果。' WHERE `entry` = 13939 AND `description_loc4` = '永久性地为一副护腕附魔，使它们获得力量+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得所有属性+3的效果。' WHERE `entry` = 13941 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得所有属性+3的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其获得伤害+4的效果。' WHERE `entry` = 13943 AND `description_loc4` = '永久性地为一把近战武器附魔，使它获得伤害+4的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得耐力+7的效果。' WHERE `entry` = 13945 AND `description_loc4` = '永久性地为一副护腕附魔，使它们获得耐力+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一副护腕永久性地附魔，使其获得+7耐力的效果。' WHERE `entry` = 13946 AND `description_loc4` = '教你学会给一只护腕永久性地附魔，使它获得+7耐力的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得略微提升坐骑移动速度的效果。' WHERE `entry` = 13947 AND `description_loc4` = '永久性地为一双手套附魔， 使它们获得略微提升坐骑移动速度的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得攻击和施法速度+1%的效果。' WHERE `entry` = 13948 AND `description_loc4` = '永久性地为一双手套附魔， 使它们获得攻击速度+1%的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双手套永久性地附魔，使其获得略微提高骑乘速度的效果。' WHERE `entry` = 13949 AND `description_loc4` = '教你学会给一双手套永久性地附魔，使它获得略微提高骑乘速度的效果。';

UPDATE `locales_spell` SET `description_loc4` = '使你在用斧类和剑类武器击中敌人后有$h%的几率进行一次额外的攻击。' WHERE `entry` = 13960 AND `description_loc4` = '使你在用剑类武器击中敌人后有$h%的几率进行一次额外的攻击。';

UPDATE `locales_spell` SET `description_loc4` = '使你在用斧类和剑类武器击中敌人后有$h%的几率进行一次额外的攻击。' WHERE `entry` = 13961 AND `description_loc4` = '使你在用剑类武器击中敌人后有$h%的几率进行一次额外的攻击。';

UPDATE `locales_spell` SET `description_loc4` = '使你在用斧类和剑类武器击中敌人后有$h%的几率进行一次额外的攻击。' WHERE `entry` = 13962 AND `description_loc4` = '使你在用剑类武器击中敌人后有$h%的几率进行一次额外的攻击。';

UPDATE `locales_spell` SET `description_loc4` = '使你在用斧类和剑类武器击中敌人后有$h%的几率进行一次额外的攻击。' WHERE `entry` = 13963 AND `description_loc4` = '使你在用剑类武器击中敌人后有$h%的几率进行一次额外的攻击。';

UPDATE `locales_spell` SET `description_loc4` = '使你在用斧类和剑类武器击中敌人后有$h%的几率进行一次额外的攻击。' WHERE `entry` = 13964 AND `description_loc4` = '使你在用剑类武器击中敌人后有$h%的几率进行一次额外的攻击。';

UPDATE `locales_spell` SET `description_loc4` = '使你在潜行后的移动速度提高$s1%，潜行技能的冷却时间降低$/1000;s2秒。当你在潜行状态下时，降低敌人侦测到你的几率。' WHERE `entry` = 13975 AND `description_loc4` = '使你在潜行后的移动速度提高$s1%，潜行技能的冷却时间降低$/1000;s2秒。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 14027 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 14048 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 14049 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 14052 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 14056 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '使你在潜行后的移动速度提高$s1%，潜行技能的冷却时间降低$/1000;s2秒。当你在潜行状态下时，降低敌人侦测到你的几率，比等级1更有效。' WHERE `entry` = 14062 AND `description_loc4` = '使你在潜行后的移动速度提高$s1%，潜行技能的冷却时间降低$/1000;s2秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你在潜行后的移动速度提高$s1%，潜行技能的冷却时间降低$/1000;s2秒。当你在潜行状态下时，降低敌人侦测到你的几率，比等级2更有效。' WHERE `entry` = 14063 AND `description_loc4` = '使你在潜行后的移动速度提高$s1%，潜行技能的冷却时间降低$/1000;s2秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你在潜行后的移动速度提高$s1%，潜行技能的冷却时间降低$/1000;s2秒。当你在潜行状态下时，降低敌人侦测到你的几率，比等级3更有效。' WHERE `entry` = 14064 AND `description_loc4` = '使你在潜行后的移动速度提高$s1%，潜行技能的冷却时间降低$/1000;s2秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你在潜行后的移动速度提高$s1%，潜行技能的冷却时间降低$/1000;s2秒。当你在潜行状态下时，降低敌人侦测到你的几率，比等级4更有效。' WHERE `entry` = 14065 AND `description_loc4` = '使你在潜行后的移动速度提高$s1%，潜行技能的冷却时间降低$/1000;s2秒。';

UPDATE `locales_spell` SET `description_loc4` = '你的闷棍和致盲会在效果结束或未生效时，使目标造成伤害降低$52532s1%，持续$52532d。使用闷棍后有$s1%的几率继续保持潜行状态。' WHERE `entry` = 14076 AND `description_loc4` = '使你有$s1%的几率在使用闷棍技能之后重新转入潜行模式。';

UPDATE `locales_spell` SET `description_loc4` = '使伏击技能的致命一击几率提高$s2%，如果伏击技能未造成致命一击，则返还$s1能量。' WHERE `entry` = 14079 AND `description_loc4` = '使你的伏击技能造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使伏击技能的致命一击几率提高$s2%，如果伏击技能未造成致命一击，则返还$s1能量。' WHERE `entry` = 14080 AND `description_loc4` = '使你的伏击技能造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使伏击技能的致命一击几率提高$s2%，如果伏击技能未造成致命一击，则返还$s1能量。' WHERE `entry` = 14081 AND `description_loc4` = '使你的伏击技能造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 14089 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '你的闷棍和致盲会在效果结束或未生效时，使目标造成伤害降低$52533s1%，持续$52533d。使用闷棍后有$s1%的几率继续保持潜行状态。' WHERE `entry` = 14094 AND `description_loc4` = '使你有$s1%的几率在使用闷棍技能之后重新转入潜行模式。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 14121 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '产生连击点数的技能致命一击伤害加成提高$s1%。' WHERE `entry` = 14128 AND `description_loc4` = '使你的邪恶攻击、凿击、背刺、鬼魅攻击和出血技能的致命一击所造成的额外伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '产生连击点数的技能致命一击伤害加成提高$s1%。' WHERE `entry` = 14132 AND `description_loc4` = '使你的邪恶攻击、凿击、背刺、鬼魅攻击和出血技能的致命一击所造成的额外伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '产生连击点数的技能致命一击伤害加成提高$s1%。' WHERE `entry` = 14135 AND `description_loc4` = '使你的邪恶攻击、凿击、背刺、鬼魅攻击和出血技能的致命一击所造成的额外伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '产生连击点数的技能致命一击伤害加成提高$s1%。' WHERE `entry` = 14136 AND `description_loc4` = '使你的邪恶攻击、凿击、背刺、鬼魅攻击和出血技能的致命一击所造成的额外伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '产生连击点数的技能致命一击伤害加成提高$s1%。' WHERE `entry` = 14137 AND `description_loc4` = '使你的邪恶攻击、凿击、背刺、鬼魅攻击和出血技能的致命一击所造成的额外伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '在你杀死一个可为你提供经验值或荣誉值的敌人后，你的下一个产生连击点数的技能造成致命一击的几率提高$14143s1%，效果持续$14143d。' WHERE `entry` = 14144 AND `description_loc4` = '在你杀死一个可为你提供经验值的敌人后，你的下一次邪恶攻击、背刺、伏击或鬼魅攻击有$14143s1%的额外几率造成致命一击，效果持续$14143d。';

UPDATE `locales_spell` SET `description_loc4` = '在你杀死一个可为你提供经验值或荣誉值的敌人后，你的下一个产生连击点数的技能造成致命一击的几率提高$14149s1%，效果持续$14149d。' WHERE `entry` = 14148 AND `description_loc4` = '在你杀死一个可为你提供经验值的敌人后，你的下一次邪恶攻击、背刺、伏击或鬼魅攻击有$14149s1%的额外几率造成致命一击，效果持续$14149d。';

UPDATE `locales_spell` SET `description_loc4` = '在你杀死一个可为你提供经验值或荣誉值的敌人后，你的下一个产生连击点数的技能造成致命一击的几率提高$14151s1%，效果持续$14151d。' WHERE `entry` = 14150 AND `description_loc4` = '在你杀死一个可为你提供经验值的敌人后，你的下一次邪恶攻击、背刺、伏击或鬼魅攻击有$14151s1%的额外几率造成致命一击，效果持续$14151d。';

UPDATE `locales_spell` SET `description_loc4` = '在你杀死一个可为你提供经验值或荣誉值的敌人后，你的下一个产生连击点数的技能造成致命一击的几率提高$14153s1%，效果持续$14153d。' WHERE `entry` = 14152 AND `description_loc4` = '在你杀死一个可为你提供经验值的敌人后，你的下一次邪恶攻击、背刺、伏击或鬼魅攻击有$14153s1%的额外几率造成致命一击，效果持续$14153d。';

UPDATE `locales_spell` SET `description_loc4` = '在你杀死一个可为你提供经验值或荣誉值的敌人后，你的下一个产生连击点数的技能造成致命一击的几率提高$14155s1%，效果持续$14155d。' WHERE `entry` = 14154 AND `description_loc4` = '在你杀死一个可为你提供经验值的敌人后，你的下一次邪恶攻击、背刺、伏击或鬼魅攻击有$14155s1%的额外几率造成致命一击，效果持续$14155d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的切割和兴奋的效果持续时间延长$s1%。' WHERE `entry` = 14165 AND `description_loc4` = '使你的切割技能的效果持续时间延长$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的切割和兴奋的效果持续时间延长$s1%。' WHERE `entry` = 14166 AND `description_loc4` = '使你的切割技能的效果持续时间延长$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的切割和兴奋的效果持续时间延长$s1%。' WHERE `entry` = 14167 AND `description_loc4` = '使你的切割技能的效果持续时间延长$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '割裂和绞喉造成的伤害提高$s1%，并使你的攻击忽略目标$s2点护甲值。' WHERE `entry` = 14171 AND `description_loc4` = '使你的攻击忽视目标$s2点护甲，并使你的割裂技能所造成的伤害提高$s1%。削弱目标护甲的效果随着你的等级提高而提高。';

UPDATE `locales_spell` SET `description_loc4` = '割裂和绞喉造成的伤害提高$s1%，并使你的攻击忽略目标$s2点护甲值。' WHERE `entry` = 14172 AND `description_loc4` = '使你的攻击忽视目标$s2点护甲，并使你的割裂技能所造成的伤害提高$s1%。削弱目标护甲的效果随着你的等级提高而提高。';

UPDATE `locales_spell` SET `description_loc4` = '割裂和绞喉造成的伤害提高$s1%，并使你的攻击忽略目标$s2点护甲值。' WHERE `entry` = 14173 AND `description_loc4` = '使你的攻击忽视目标$s2点护甲，并使你的割裂技能所造成的伤害提高$s1%。削弱目标护甲的效果随着你的等级提高而提高。';

UPDATE `locales_spell` SET `description_loc4` = '割裂的持续时间延长$/1000;s1秒。每次使用割裂时，无论效果是否生效，你的近战伤害都会在原有持续时间内每个连击点数提高$52528b1%。' WHERE `entry` = 14174 AND `description_loc4` = '目标受到你的肾击技能影响之后，任何攻击者对其所造成的伤害量都提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '割裂的持续时间延长$/1000;s1秒。每次使用割裂时，无论效果是否生效，你的近战伤害都会在原有持续时间内每个连击点数提高$52529b1%。' WHERE `entry` = 14175 AND `description_loc4` = '目标受到你的肾击技能影响之后，任何攻击者对其所造成的伤害量都提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '割裂的持续时间延长$/1000;s1秒。每次使用割裂时，无论效果是否生效，你的近战伤害都会在原有持续时间内每个连击点数提高$52530b1%。' WHERE `entry` = 14176 AND `description_loc4` = '目标受到你的肾击技能影响之后，任何攻击者对其所造成的伤害量都提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '激活之后，你的下一次邪恶攻击、背刺、伏击、双刃毒袭或剔骨造成致命一击的几率提高$s1%。' WHERE `entry` = 14177 AND `description_loc4` = '激活之后，你的下一次邪恶攻击、背刺、伏击或剔骨造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的终结技每拥有一个连击点数就有$b1%的几率恢复$14181s1点能量值，并使你的终结技伤害在$14181d内提高$14181s2%，最多可叠加$14181u次。' WHERE `entry` = 14179 AND `description_loc4` = '你的终结技有每连击点数$b1%的几率恢复$14181s1点能量值。';

UPDATE `locales_spell` SET `description_loc4` = '一次强力的攻击，造成$s2%的武器伤害，外加$s1的额外伤害。' WHERE `entry` = 14260 AND `description_loc4` = '强力的攻击，使近战攻击所造成的伤害提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '一次强力的攻击，造成$s2%的武器伤害，外加$s1的额外伤害。' WHERE `entry` = 14261 AND `description_loc4` = '强力的攻击，使近战攻击所造成的伤害提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '一次强力的攻击，造成$s2%的武器伤害，外加$s1的额外伤害。' WHERE `entry` = 14262 AND `description_loc4` = '强力的攻击，使近战攻击所造成的伤害提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '一次强力的攻击，造成$s2%的武器伤害，外加$s1的额外伤害。' WHERE `entry` = 14263 AND `description_loc4` = '强力的攻击，使近战攻击所造成的伤害提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '一次强力的攻击，造成$s2%的武器伤害，外加$s1的额外伤害。' WHERE `entry` = 14264 AND `description_loc4` = '强力的攻击，使近战攻击所造成的伤害提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '一次强力的攻击，造成$s2%的武器伤害，外加$s1的额外伤害。' WHERE `entry` = 14265 AND `description_loc4` = '强力的攻击，使近战攻击所造成的伤害提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '一次强力的攻击，造成$s2%的武器伤害，外加$s1的额外伤害。' WHERE `entry` = 14266 AND `description_loc4` = '强力的攻击，使近战攻击所造成的伤害提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '对敌人造成$s2点武器伤害，并使其移动速度降低$s1%，持续$d。' WHERE `entry` = 14267 AND `description_loc4` = '对敌人造成$s2点伤害，并使其移动速度降低$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '对敌人造成$s2点武器伤害，并使其移动速度降低$s1%，持续$d。' WHERE `entry` = 14268 AND `description_loc4` = '对敌人造成$s2点伤害，并使其移动速度降低$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '立即攻击敌人，造成$s2%的武器伤害加上额外的$s1点伤害。如果你装备了双武器，现在会同时使用两把武器进行攻击。' WHERE `entry` = 14269 AND `description_loc4` = '反击敌人，对其造成$s1点伤害。只能在你成功躲闪之后使用。';

UPDATE `locales_spell` SET `description_loc4` = '立即攻击敌人，造成$s2%的武器伤害加上额外的$s1点伤害。如果你装备了双武器，现在会同时使用两把武器进行攻击。' WHERE `entry` = 14270 AND `description_loc4` = '反击敌人，对其造成$s1点伤害。只能在你成功躲闪之后使用。';

UPDATE `locales_spell` SET `description_loc4` = '立即攻击敌人，造成$s2%的武器伤害加上额外的$s1点伤害。如果你装备了双武器，现在会同时使用两把武器进行攻击。' WHERE `entry` = 14271 AND `description_loc4` = '反击敌人，对其造成$s1点伤害。只能在你成功躲闪之后使用。';

UPDATE `locales_spell` SET `description_loc4` = '尝试从敌人面前逃脱，降低威胁值。比逃脱（等级 1）更有效。逃脱成功则会停止攻击。' WHERE `entry` = 14272 AND `description_loc4` = '尝试从敌人面前逃脱，降低威胁值。比逃脱（等级 1）更有效。逃脱成功则脱离战斗状态。';

UPDATE `locales_spell` SET `description_loc4` = '尝试从敌人面前逃脱，降低威胁值。比逃脱（等级 2）更有效。逃脱成功则会停止攻击。' WHERE `entry` = 14273 AND `description_loc4` = '尝试从敌人面前逃脱，降低威胁值。比逃脱（等级 2）更有效。逃脱成功则脱离战斗状态。';

UPDATE `locales_spell` SET `description_loc4` = '对敌人造成$s1%的近战伤害，并使你躲闪攻击的几率提高$s2%，持续$d。奖励$s3个连击点数。' WHERE `entry` = 14278 AND `description_loc4` = '对敌人造成$s1%的武器伤害，并使你躲闪攻击的几率提高$s2%，持续$d。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '迅速射出一箭，对敌人造成$s2%的远程武器伤害和额外的$s1点奥术伤害。' WHERE `entry` = 14281 AND `description_loc4` = '迅速射出一箭，对敌人造成$s1点奥术伤害。';

UPDATE `locales_spell` SET `description_loc4` = '迅速射出一箭，对敌人造成$s2%的远程武器伤害和额外的$s1点奥术伤害。' WHERE `entry` = 14282 AND `description_loc4` = '迅速射出一箭，对敌人造成$s1点奥术伤害。';

UPDATE `locales_spell` SET `description_loc4` = '迅速射出一箭，对敌人造成$s2%的远程武器伤害和额外的$s1点奥术伤害。' WHERE `entry` = 14283 AND `description_loc4` = '迅速射出一箭，对敌人造成$s1点奥术伤害。';

UPDATE `locales_spell` SET `description_loc4` = '迅速射出一箭，对敌人造成$s2%的远程武器伤害和额外的$s1点奥术伤害。' WHERE `entry` = 14284 AND `description_loc4` = '迅速射出一箭，对敌人造成$s1点奥术伤害。';

UPDATE `locales_spell` SET `description_loc4` = '迅速射出一箭，对敌人造成$s2%的远程武器伤害和额外的$s1点奥术伤害。' WHERE `entry` = 14285 AND `description_loc4` = '迅速射出一箭，对敌人造成$s1点奥术伤害。';

UPDATE `locales_spell` SET `description_loc4` = '迅速射出一箭，对敌人造成$s2%的远程武器伤害和额外的$s1点奥术伤害。' WHERE `entry` = 14286 AND `description_loc4` = '迅速射出一箭，对敌人造成$s1点奥术伤害。';

UPDATE `locales_spell` SET `description_loc4` = '迅速射出一箭，对敌人造成$s2%的远程武器伤害和额外的$s1点奥术伤害。' WHERE `entry` = 14287 AND `description_loc4` = '迅速射出一箭，对敌人造成$s1点奥术伤害。';

UPDATE `locales_spell` SET `description_loc4` = '连续射出弹药，对$x1个目标造成额外的$s1点伤害。' WHERE `entry` = 14288 AND `description_loc4` = '连续射出弹药，对$x1个目标造成额外的$s1点奥术伤害。';

UPDATE `locales_spell` SET `description_loc4` = '连续射出弹药，对$x1个目标造成额外的$s1点伤害。' WHERE `entry` = 14289 AND `description_loc4` = '连续射出弹药，对$x1个目标造成额外的$s1点奥术伤害。';

UPDATE `locales_spell` SET `description_loc4` = '连续射出弹药，对$x1个目标造成额外的$s1点伤害。' WHERE `entry` = 14290 AND `description_loc4` = '连续射出弹药，对$x1个目标造成额外的$s1点奥术伤害。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14330 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14369 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14371 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14383 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14384 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14385 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14386 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14387 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14388 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14389 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14390 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14391 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14392 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14393 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14394 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14395 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14396 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14397 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14398 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14399 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14400 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14401 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14402 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14403 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14404 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14405 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14406 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14407 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14408 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14409 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14410 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14411 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14412 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14413 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14414 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14415 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14416 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14417 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14418 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14419 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14420 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14421 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14422 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14423 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14424 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14425 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14426 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14427 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14428 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14429 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14430 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14433 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14435 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14436 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14437 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14438 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14439 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14440 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14441 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14442 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '连续射出弹药，对最多$x1个目标造成普通伤害外加$s1点伤害。' WHERE `entry` = 14443 AND `description_loc4` = '连续射出弹药，对最多$x1个目标造成普通伤害外加$s1点奥术伤害。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14444 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14447 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14448 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14449 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14450 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14451 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14452 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14453 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14454 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14455 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14456 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14457 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14458 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14459 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14460 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14461 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14462 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14463 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14464 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14465 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14466 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14467 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14468 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14469 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14470 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14471 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14472 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14473 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14474 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14475 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14476 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14477 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14478 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14479 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14480 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14481 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14482 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14483 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14484 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14485 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14486 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14487 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14488 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14489 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14490 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14491 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14492 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14493 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14494 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14495 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14496 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14497 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14498 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14499 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14500 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14501 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14502 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14503 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14504 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14505 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14506 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14507 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14508 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14509 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14510 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14511 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14512 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成$s1点伤害，每层十字军打击都可使目标在受到神圣伤害时多承受$s2点额外神圣伤害，最多叠加5层。持续$d。' WHERE `entry` = 14517 AND `description_loc4` = '对目标造成$s1点伤害，每次十字军打击都可使目标在受到神圣伤害时多承受$s2点额外神圣伤害，共可累加5次。持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成$s1点伤害，每层十字军打击都可使目标在受到神圣伤害时多承受$s2点额外神圣伤害，最多叠加5层。持续$d。。' WHERE `entry` = 14518 AND `description_loc4` = '对目标造成$s1点伤害，每次十字军打击都可使目标在受到神圣伤害时多承受$s2点额外神圣伤害，共可累加5次。持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的瞬发法术、攻击性神圣法术和戒律法术所消耗的法力值减少$s1%。' WHERE `entry` = 14520 AND `description_loc4` = '使你的瞬发法术所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的魔杖造成的伤害提高$s1%，魔杖的命中几率增加$s2%。你的魔杖攻击成功造成伤害后有一定几率让你回复$51461m1法力值。' WHERE `entry` = 14524 AND `description_loc4` = '使你的魔杖造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '魔杖的伤害和命中几率提高$s1%，弓的伤害和命中几率提高$s2%。

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14540 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14541 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14542 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14543 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14544 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14545 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14546 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14547 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14548 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14549 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14550 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14551 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14552 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14553 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14554 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14555 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14556 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14557 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14558 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14559 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14560 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14561 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14562 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14563 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14564 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14566 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14567 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14568 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14569 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14570 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14571 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14572 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14573 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14574 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14575 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14576 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14577 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14578 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14579 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14580 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14581 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14582 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14583 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14584 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14585 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14586 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14587 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14588 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14589 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14590 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14591 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14592 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14593 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14594 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14595 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14596 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14597 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14598 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14599 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14600 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14601 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14602 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14603 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14604 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14605 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14606 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14607 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14608 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14609 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14610 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14611 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14612 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14613 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14614 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14615 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14616 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14617 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14618 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14619 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14620 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14622 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14623 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14624 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14625 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14626 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14627 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14628 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14629 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14630 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14631 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14632 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14633 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14634 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14635 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14636 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14637 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14638 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14639 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14640 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14641 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14643 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14644 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14645 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14646 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14647 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14648 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14649 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14650 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14651 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14652 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14653 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14654 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14655 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14656 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14657 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14658 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14659 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14660 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14661 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14662 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14663 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14664 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14665 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14666 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14667 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14668 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14669 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14670 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14671 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14672 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14673 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14674 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14675 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14676 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14677 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14678 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14679 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14680 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14681 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14682 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14683 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14684 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14685 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14686 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14687 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14688 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14689 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14690 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14691 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14692 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14693 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14694 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14695 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14696 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14697 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14698 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14699 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14700 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14701 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14702 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14703 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14704 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14705 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14706 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14707 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14708 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14709 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14710 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14711 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14712 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14713 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14714 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14715 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14716 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14717 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14718 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14719 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14720 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14721 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14722 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14723 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14724 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14725 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14726 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14727 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14728 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14729 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14730 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14731 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14732 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14733 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14734 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14735 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14736 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14737 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14738 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14739 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14740 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14741 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14742 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '使你的心灵之火的效果提高$s1%。' WHERE `entry` = 14747 AND `description_loc4` = '使你的心灵之火的护甲增强效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的心灵之火的效果提高$s1%。' WHERE `entry` = 14770 AND `description_loc4` = '使你的心灵之火的护甲增强效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的心灵之火的效果提高$s1%。' WHERE `entry` = 14771 AND `description_loc4` = '使你的心灵之火的护甲增强效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的瞬发法术、攻击性神圣法术和戒律法术所消耗的法力值减少$s1%。' WHERE `entry` = 14780 AND `description_loc4` = '使你的瞬发法术所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的瞬发法术、攻击性神圣法术和戒律法术所消耗的法力值减少$s1%。' WHERE `entry` = 14781 AND `description_loc4` = '使你的瞬发法术所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的瞬发法术、攻击性神圣法术和戒律法术所消耗的法力值减少$s1%。' WHERE `entry` = 14782 AND `description_loc4` = '使你的瞬发法术所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的瞬发法术、攻击性神圣法术和戒律法术所消耗的法力值减少$s1%。' WHERE `entry` = 14783 AND `description_loc4` = '使你的瞬发法术所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 14803 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其获得附加5点火焰伤害的效果。' WHERE `entry` = 14847 AND `description_loc4` = '永久性地为一把近战武器附魔，使它获得附加5点火焰伤害的效果。';

UPDATE `locales_spell` SET `description_loc4` = '使你的神圣和戒律法术造成致命一击的几率提高$s1%。' WHERE `entry` = 14889 AND `description_loc4` = '使你的神圣法术造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的次级治疗术、治疗术、强效治疗术和治疗祷言的法力值消耗降低$s1%。' WHERE `entry` = 14912 AND `description_loc4` = '使你的次级治疗术、治疗术和强效治疗术的法力值消耗降低$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你有$s1%的几率在施放任何神圣法术时不会因为受到伤害而延迟。' WHERE `entry` = 14913 AND `description_loc4` = '使你有$s1%的几率在施放任何治疗法术时不会因为受到伤害而中断施法。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14934 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14935 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14936 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14937 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14938 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14939 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1敏捷。' WHERE `entry` = 14940 AND `description_loc4` = '+$S1 敏捷。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14941 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14942 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14943 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14944 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14945 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1智力。' WHERE `entry` = 14946 AND `description_loc4` = '+$S1 智力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14947 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14948 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14949 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14950 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14951 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1精神。' WHERE `entry` = 14952 AND `description_loc4` = '+$S1 精神。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14953 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14954 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14955 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14956 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14957 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1耐力。' WHERE `entry` = 14958 AND `description_loc4` = '+$S1 耐力。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14959 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14960 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14961 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14962 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14963 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1力量。' WHERE `entry` = 14964 AND `description_loc4` = '+$S1 力量。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14965 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14966 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14967 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14968 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14969 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1奥术抗性。' WHERE `entry` = 14970 AND `description_loc4` = '+$S1 奥术抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14971 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14972 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14973 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14974 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14975 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1火焰抗性。' WHERE `entry` = 14976 AND `description_loc4` = '+$S1 火焰抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14977 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14978 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14979 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14980 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14981 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1冰霜抗性。' WHERE `entry` = 14982 AND `description_loc4` = '+$S1 冰霜抗性。';

UPDATE `locales_spell` SET `description_loc4` = '使你的能量值上限提高$s2点。每次对目标施加毒药时，你都有$s1%的几率获得$52526s1点能量值。' WHERE `entry` = 14983 AND `description_loc4` = '使你的能量值上限提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14984 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14985 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14986 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14987 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14988 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1自然抗性。' WHERE `entry` = 14989 AND `description_loc4` = '+$S1 自然抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14990 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14991 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14992 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14993 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14994 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1暗影抗性。' WHERE `entry` = 14995 AND `description_loc4` = '+$S1 暗影抗性。';

UPDATE `locales_spell` SET `description_loc4` = '使你的神圣和戒律法术造成致命一击的几率提高$s1%。' WHERE `entry` = 15008 AND `description_loc4` = '使你的神圣法术造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的神圣和戒律法术造成致命一击的几率提高$s1%。' WHERE `entry` = 15009 AND `description_loc4` = '使你的神圣法术造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的神圣和戒律法术造成致命一击的几率提高$s1%。' WHERE `entry` = 15010 AND `description_loc4` = '使你的神圣法术造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的神圣和戒律法术造成致命一击的几率提高$s1%。' WHERE `entry` = 15011 AND `description_loc4` = '使你的神圣法术造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你有$s1%的几率在施放任何神圣法术时不会因为受到伤害而延迟。' WHERE `entry` = 15012 AND `description_loc4` = '使你有$s1%的几率在施放任何治疗法术时不会因为受到伤害而中断施法。';

UPDATE `locales_spell` SET `description_loc4` = '使你的次级治疗术、治疗术、强效治疗术和治疗祷言的法力值消耗降低$s1%。' WHERE `entry` = 15013 AND `description_loc4` = '使你的次级治疗术、治疗术和强效治疗术的法力值消耗降低$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的次级治疗术、治疗术、强效治疗术和治疗祷言的法力值消耗降低$s1%。' WHERE `entry` = 15014 AND `description_loc4` = '使你的次级治疗术、治疗术和强效治疗术的法力值消耗降低$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的次级治疗术、治疗术、强效治疗术和治疗祷言的法力值消耗降低$s1%。' WHERE `entry` = 15015 AND `description_loc4` = '使你的次级治疗术、治疗术和强效治疗术的法力值消耗降低$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的次级治疗术、治疗术、强效治疗术和治疗祷言的法力值消耗降低$s1%。' WHERE `entry` = 15016 AND `description_loc4` = '使你的次级治疗术、治疗术和强效治疗术的法力值消耗降低$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的伤害性奥术法术有$h%的几率不受控制地爆发，消耗2%的基础法力值来造成$s1%的额外伤害。' WHERE `entry` = 15058 AND `description_loc4` = '使你的法术伤害和重击几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的伤害性奥术法术有$h%的几率不受控制地爆发，消耗2%的基础法力值来造成$s1%的额外伤害。' WHERE `entry` = 15059 AND `description_loc4` = '使你的法术伤害和重击几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的伤害性奥术法术有$h%的几率不受控制地爆发，消耗2%的基础法力值来造成$s1%的额外伤害。' WHERE `entry` = 15060 AND `description_loc4` = '使你的法术伤害和重击几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '在你的普通近战攻击打出致命一击之后，使你的下3次近战攻击速度提高30%。' WHERE `entry` = 15088 AND `description_loc4` = '使你在打出一次致命攻击之后接连3次攻击的攻击速度提高35%。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出闪电箭，对其造成$s1点自然伤害。' WHERE `entry` = 15207 AND `description_loc4` = '向目标射出闪电箭，对其造成$s点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出闪电箭，对其造成$s1点自然伤害。' WHERE `entry` = 15208 AND `description_loc4` = '向目标射出闪电箭，对其造成$s点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '制造一次以施法者为中心的神圣能量爆炸，对半径$a1码范围内的所有目标造成$s1点神圣伤害，并为半径$23455a1码范围内的所有小队成员恢复$23455s1点生命值。在暗影形态下使用此法术会对你造成伤害，而不是治疗，这些效果的仇恨值较低。' WHERE `entry` = 15237 AND `description_loc4` = '制造一次以施法者为中心的神圣能量爆炸，对半径$a1码范围内的所有目标造成$s1点神圣伤害，并为半径$23455a1码范围内的所有小队成员恢复$23455s1点生命值。这些效果不对怪物产生任何威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '你的暗影伤害法术有$s1%的几率使你获得暗影之波，持续$58136d。暗影之波会使你的暗影伤害法术对目标施加易伤，每层易伤使其受到暗影伤害提高$15258s1%，持续$15258d，最多叠加$15258u次。' WHERE `entry` = 15257 AND `description_loc4` = '你的暗影系伤害性法术有$s1%的机会使你的目标在受到暗影系攻击时更脆弱，受到的伤害提高$15258s1%，持续$15258d。此效果最多可叠加$15258u次。';

UPDATE `locales_spell` SET `description_loc4` = '在杀死一个敌人并因此获得经验值或心灵震爆造成致命一击后，你有$h%的几率精神提高$15271s1%。在这段时间里，你的法力值可以在施法时仍保持$15271s2%的回复速度。持续$15271d。' WHERE `entry` = 15270 AND `description_loc4` = '使你有$h%的几率在杀死一个敌人并因此获得经验值之后精神属性提高$15271s1%。在这段时间里，你的法力值可以在施法时仍保持$15271s2%的回复速度。持续$15271d。';

UPDATE `locales_spell` SET `description_loc4` = '渐隐术的冷却时间减少$/1000;s1秒，并在效果结束时返还的威胁值$s2%。' WHERE `entry` = 15274 AND `description_loc4` = '使你的渐隐术的冷却时间减少$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '渐隐术的冷却时间减少$/1000;s1秒，并在效果结束时返还的威胁值$s2%。' WHERE `entry` = 15311 AND `description_loc4` = '使你的渐隐术的冷却时间减少$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '你的暗影伤害法术有$s1%的几率使你获得暗影之波，持续$58136d。暗影之波会使你的暗影伤害法术对目标施加易伤，每层易伤使其受到暗影伤害提高$15258s1%，持续$15258d，最多叠加$15258u次。' WHERE `entry` = 15331 AND `description_loc4` = '你的暗影系伤害性法术有$s1%的机会使你的目标在受到暗影系攻击时更脆弱，受到的伤害提高$15258s1%，持续$15258d。此效果最多可叠加$15258u次。';

UPDATE `locales_spell` SET `description_loc4` = '你的暗影伤害法术有$s1%的几率使你获得暗影之波，持续$58136d。暗影之波会使你的暗影伤害法术对目标施加易伤，每层易伤使其受到暗影伤害提高$15258s1%，持续$15258d，最多叠加$15258u次。' WHERE `entry` = 15332 AND `description_loc4` = '你的暗影系伤害性法术有$s1%的机会使你的目标在受到暗影系攻击时更脆弱，受到的伤害提高$15258s1%，持续$15258d。此效果最多可叠加$15258u次。';

UPDATE `locales_spell` SET `description_loc4` = '你的暗影伤害法术有$s1%的几率使你获得暗影之波，持续$58136d。暗影之波会使你的暗影伤害法术对目标施加易伤，每层易伤使其受到暗影伤害提高$15258s1%，持续$15258d，最多叠加$15258u次。' WHERE `entry` = 15333 AND `description_loc4` = '你的暗影系伤害性法术有$s1%的机会使你的目标在受到暗影系攻击时更脆弱，受到的伤害提高$15258s1%，持续$15258d。此效果最多可叠加$15258u次。';

UPDATE `locales_spell` SET `description_loc4` = '你的暗影伤害法术有$s1%的几率使你获得暗影之波，持续$58136d。暗影之波会使你的暗影伤害法术对目标施加易伤，每层易伤使其受到暗影伤害提高$15258s1%，持续$15258d，最多叠加$15258u次。' WHERE `entry` = 15334 AND `description_loc4` = '你的暗影系伤害性法术有$s1%的机会使你的目标在受到暗影系攻击时更脆弱，受到的伤害提高$15258s1%，持续$15258d。此效果最多可叠加$15258u次。';

UPDATE `locales_spell` SET `description_loc4` = '在杀死一个敌人并因此获得经验值或心灵震爆造成致命一击后，你有$h%的几率精神提高$15271s1%。在这段时间里，你的法力值可以在施法时仍保持$15271s2%的回复速度。持续$15271d。' WHERE `entry` = 15335 AND `description_loc4` = '使你有$h%的几率在杀死一个敌人并因此获得经验值之后精神属性提高$15271s1%。在这段时间里，你的法力值可以在施法时仍保持$15271s2%的回复速度。持续$15271d。';

UPDATE `locales_spell` SET `description_loc4` = '在杀死一个敌人并因此获得经验值或心灵震爆造成致命一击后，你有$h%的几率精神提高$15271s1%。在这段时间里，你的法力值可以在施法时仍保持$15271s2%的回复速度。持续$15271d。' WHERE `entry` = 15336 AND `description_loc4` = '使你有$h%的几率在杀死一个敌人并因此获得经验值之后精神属性提高$15271s1%。在这段时间里，你的法力值可以在施法时仍保持$15271s2%的回复速度。持续$15271d。';

UPDATE `locales_spell` SET `description_loc4` = '在杀死一个敌人并因此获得经验值或心灵震爆造成致命一击后，你有$h%的几率精神提高$15271s1%。在这段时间里，你的法力值可以在施法时仍保持$15271s2%的回复速度。持续$15271d。' WHERE `entry` = 15337 AND `description_loc4` = '使你有$h%的几率在杀死一个敌人并因此获得经验值之后精神属性提高$15271s1%。在这段时间里，你的法力值可以在施法时仍保持$15271s2%的回复速度。持续$15271d。';

UPDATE `locales_spell` SET `description_loc4` = '在杀死一个敌人并因此获得经验值或心灵震爆造成致命一击后，你有$h%的几率精神提高$15271s1%。在这段时间里，你的法力值可以在施法时仍保持$15271s2%的回复速度。持续$15271d。' WHERE `entry` = 15338 AND `description_loc4` = '使你有$h%的几率在杀死一个敌人并因此获得经验值之后精神属性提高$15271s1%。在这段时间里，你的法力值可以在施法时仍保持$15271s2%的回复速度。持续$15271d。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使法力值提高150点。无法与其它同位置的附魔共存。' WHERE `entry` = 15340 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使法力值提高150点。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 15367 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使生命值提高100点。无法与其它同位置的附魔共存。' WHERE `entry` = 15389 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使生命值提高100点。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使护甲值提高125点。无法与其它同位置的附魔共存。' WHERE `entry` = 15391 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使护甲值提高125点。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使火焰抗性提高20点。无法与其它同位置的附魔共存。' WHERE `entry` = 15394 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使火焰抗性提高20点。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使力量提高8点。无法与其它同位置的附魔共存。' WHERE `entry` = 15397 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使力量提高8点。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使耐力提高8点。无法与其它同位置的附魔共存。' WHERE `entry` = 15400 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使耐力提高8点。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使敏捷提高8点。无法与其它同位置的附魔共存。' WHERE `entry` = 15402 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使敏捷提高8点。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使智力提高8点。无法与其它同位置的附魔共存。' WHERE `entry` = 15404 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使智力提高8点。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使精神提高8点。无法与其它同位置的附魔共存。' WHERE `entry` = 15406 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使精神提高8点。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '制造一次以施法者为中心的神圣能量爆炸，对半径$a1码范围内的所有目标造成$s1点神圣伤害，并为半径$23458a1码范围内的所有小队成员恢复$23458s1点生命值。在暗影形态下使用此法术会对你造成伤害，而不是治疗，这些效果的仇恨值较低。' WHERE `entry` = 15430 AND `description_loc4` = '制造一次以施法者为中心的神圣能量爆炸，对半径$a1码范围内的所有目标造成$s1点神圣伤害，并为半径$23458a1码范围内的所有小队成员恢复$23458s1点生命值。这些效果不对怪物产生任何威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '制造一次以施法者为中心的神圣能量爆炸，对半径$a1码范围内的所有目标造成$s1点神圣伤害，并为半径$23459a1码范围内的所有小队成员恢复$23459s1点生命值。在暗影形态下使用此法术会对你造成伤害，而不是治疗，这些效果的仇恨值较低。' WHERE `entry` = 15431 AND `description_loc4` = '制造一次以施法者为中心的神圣能量爆炸，对半径$a1码范围内的所有目标造成$s1点神圣伤害，并为半径$23459a1码范围内的所有小队成员恢复$23459s1点生命值。这些效果不对怪物产生任何威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 15508 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '在战斗中受到攻击时有2%的几率获得300点法力值。' WHERE `entry` = 15603 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 15666 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 15687 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 15693 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 15694 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 15758 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 15759 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 15760 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 15761 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 15762 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 15763 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 15764 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 15765 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 15805 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15806 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15807 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15808 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15809 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15810 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15811 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15812 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15813 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15814 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15815 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15816 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15817 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15818 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15819 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15820 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15821 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15823 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15824 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15825 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15826 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15827 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15828 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15829 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15830 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15831 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 15832 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 15871 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 15873 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 15874 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 15875 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 15877 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 15879 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 15880 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 15881 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 15882 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 15883 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 15884 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧技能提高$s1点。' WHERE `entry` = 15885 AND `description_loc4` = '斧类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 15886 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 15887 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 15888 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 15889 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 15890 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 15891 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 15892 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 15893 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 15894 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤技能提高$s1点。' WHERE `entry` = 15895 AND `description_loc4` = '锤类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 15896 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 15897 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 15898 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 15899 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 15900 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 15901 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 15902 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 15903 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 15904 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 15905 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 15957 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '当靠近座狼幼崽时使用。不要担心，这个装置经过了地精工程学质量监督体系的认证。' WHERE `entry` = 15998 AND `description_loc4` = '在靠近座狼幼崽的使用。不要担心，这个装置经过了地精工程学质量监督体系的认证。';

UPDATE `locales_spell` SET `description_loc4` = '火焰、冰霜和自然法术造成的伤害提高$s1%。' WHERE `entry` = 16035 AND `description_loc4` = '使你的震击、闪电箭和闪电链所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '火焰图腾和火焰法术造成的伤害提高$s1%，烈焰震击的范围增加$s3码。' WHERE `entry` = 16038 AND `description_loc4` = '使你的火焰图腾所能造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '火焰、冰霜和自然的攻击性法术消耗的法力值减少$s1%。' WHERE `entry` = 16039 AND `description_loc4` = '使你的震击、闪电箭和闪电链所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的烈焰震击效果的持续时间延长$/1000;s1秒。' WHERE `entry` = 16085 AND `description_loc4` = '使你的灼热图腾的持续时间延长$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的火焰新星图腾激活所需的延迟时间减少$/1000;s1秒，熔岩图腾所造成的威胁值降低$s3%，灼热图腾的攻击速度提高$56558s1%且攻击范围增加$56558s2码。' WHERE `entry` = 16086 AND `description_loc4` = '使你的火焰新星图腾激活所需的延迟时间减少$/1000;s1秒，熔岩图腾所造成的威胁值降低$s3%。';

UPDATE `locales_spell` SET `description_loc4` = '你的闪电箭和闪电链法术会为你注入电流，使你造成的自然伤害提高$51395s2%，并使你的攻击法术的致命一击伤害加成提高$51395s1%，持续$51395d，最多可叠加$51395u次。' WHERE `entry` = 16089 AND `description_loc4` = '使你的灼热图腾、熔岩图腾、火焰新星图腾以及你的火焰、冰霜和自然系法术的致命一击伤害加成提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '火焰、冰霜和自然法术造成的伤害提高$s1%。' WHERE `entry` = 16105 AND `description_loc4` = '使你的震击、闪电箭和闪电链所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '火焰、冰霜和自然法术造成的伤害提高$s1%。' WHERE `entry` = 16106 AND `description_loc4` = '使你的震击、闪电箭和闪电链所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '火焰、冰霜和自然法术造成的伤害提高$s1%。' WHERE `entry` = 16107 AND `description_loc4` = '使你的震击、闪电箭和闪电链所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '火焰、冰霜和自然法术造成的伤害提高$s1%。' WHERE `entry` = 16108 AND `description_loc4` = '使你的震击、闪电箭和闪电链所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '火焰、冰霜和自然的攻击性法术消耗的法力值减少$s1%。' WHERE `entry` = 16109 AND `description_loc4` = '使你的震击、闪电箭和闪电链所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '火焰、冰霜和自然的攻击性法术消耗的法力值减少$s1%。' WHERE `entry` = 16110 AND `description_loc4` = '使你的震击、闪电箭和闪电链所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '火焰、冰霜和自然的攻击性法术消耗的法力值减少$s1%。' WHERE `entry` = 16111 AND `description_loc4` = '使你的震击、闪电箭和闪电链所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '火焰、冰霜和自然的攻击性法术消耗的法力值减少$s1%。' WHERE `entry` = 16112 AND `description_loc4` = '使你的震击、闪电箭和闪电链所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '火焰图腾和火焰法术造成的伤害提高$s1%，烈焰震击的范围增加$s3码。' WHERE `entry` = 16160 AND `description_loc4` = '使你的火焰图腾所能造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '火焰图腾和火焰法术造成的伤害提高$s1%，烈焰震击的范围增加$s3码。' WHERE `entry` = 16161 AND `description_loc4` = '使你的火焰图腾所能造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的火焰图腾和火焰法术所能造成的伤害提高$s1%。' WHERE `entry` = 16162 AND `description_loc4` = '使你的攻击性法术在造成致命一击后，有$h%的几率令你的近战攻击致命一击率提高$16163s1%，持续$16163d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的火焰图腾和火焰法术所能造成的伤害提高$s1%。' WHERE `entry` = 16163 AND `description_loc4` = '使你的火焰图腾所能造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的火焰、冰霜和自然伤害提高$s1%，攻击性法术的法力消耗降低$s2%，持续$d。' WHERE `entry` = 16166 AND `description_loc4` = '激活之后，你的下一个火焰、冰霜或自然法术有$s1%的几率造成致命一击，且法力值消耗降低$s2%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗法术所消耗的法力值减少$s1%，图腾消耗的法力值减少$s2%。' WHERE `entry` = 16179 AND `description_loc4` = '使你的治疗法术所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗波的施法时间减少0.$/10;s1秒。' WHERE `entry` = 16182 AND `description_loc4` = '使你的治疗波的施法时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '对第一个目标以外的目标的治疗量增加$s1%。' WHERE `entry` = 16183 AND `description_loc4` = '使治疗链所恢复的生命值总量提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的法力之泉图腾的法力消耗降低$s2%，并使你的治疗之泉图腾的效果提高$s1%。' WHERE `entry` = 16187 AND `description_loc4` = '使你的法力之泉图腾和治疗之泉图腾的效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '激活之后，你的下一个施法时间低于10秒的自然法术会成为瞬发法术，受影响的伤害性法术效果降低$s2%。' WHERE `entry` = 16188 AND `description_loc4` = '激活之后，你的下一个施法时间低于10秒的自然法术会成为瞬发法术。';

UPDATE `locales_spell` SET `description_loc4` = '使图腾对友方目标的持续时间增加$s1%，并使图腾召回所返还的法力值额外增加$s2%。' WHERE `entry` = 16189 AND `description_loc4` = '你的图腾影响友方单位的半径增加到30码。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗法术和闪电法术的致命一击几率提高$s1%。' WHERE `entry` = 16194 AND `description_loc4` = '使你的治疗法术的极效治疗效果和闪电法术的致命一击效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的法力之泉图腾的法力消耗降低$s2%，并使你的治疗之泉图腾的效果提高$s1%。' WHERE `entry` = 16205 AND `description_loc4` = '使你的法力之泉图腾和治疗之泉图腾的效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的法力之泉图腾的法力消耗降低$s2%，并使你的治疗之泉图腾的效果提高$s1%。' WHERE `entry` = 16206 AND `description_loc4` = '使你的法力之泉图腾和治疗之泉图腾的效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的法力之泉图腾的法力消耗降低$s2%，并使你的治疗之泉图腾的效果提高$s1%。' WHERE `entry` = 16207 AND `description_loc4` = '使你的法力之泉图腾和治疗之泉图腾的效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的法力之泉图腾的法力消耗降低$s2%，并使你的治疗之泉图腾的效果提高$s1%。' WHERE `entry` = 16208 AND `description_loc4` = '使你的法力之泉图腾和治疗之泉图腾的效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗法术所消耗的法力值减少$s1%，图腾消耗的法力值减少$s2%。' WHERE `entry` = 16214 AND `description_loc4` = '使你的治疗法术所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗法术所消耗的法力值减少$s1%，图腾消耗的法力值减少$s2%。' WHERE `entry` = 16215 AND `description_loc4` = '使你的治疗法术所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗法术所消耗的法力值减少$s1%，图腾消耗的法力值减少$s2%。' WHERE `entry` = 16216 AND `description_loc4` = '使你的治疗法术所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗法术所消耗的法力值减少$s1%，图腾消耗的法力值减少$s2%。' WHERE `entry` = 16217 AND `description_loc4` = '使你的治疗法术所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗法术和闪电法术的致命一击几率提高$s1%。' WHERE `entry` = 16218 AND `description_loc4` = '使你的治疗法术的极效治疗效果和闪电法术的致命一击效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗法术和闪电法术的致命一击几率提高$s1%。' WHERE `entry` = 16219 AND `description_loc4` = '使你的治疗法术的极效治疗效果和闪电法术的致命一击效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗法术和闪电法术的致命一击几率提高$s1%。' WHERE `entry` = 16220 AND `description_loc4` = '使你的治疗法术的极效治疗效果和闪电法术的致命一击效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗法术和闪电法术的致命一击几率提高$s1%。' WHERE `entry` = 16221 AND `description_loc4` = '使你的治疗法术的极效治疗效果和闪电法术的致命一击效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗波的施法时间减少0.$/10;s1秒。' WHERE `entry` = 16227 AND `description_loc4` = '使你的治疗波的施法时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗波的施法时间减少0.$/10;s1秒。' WHERE `entry` = 16229 AND `description_loc4` = '使你的治疗波的施法时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '造成致命一击之后，你的下$16257n次攻击的攻击速度提高$16257s1%。' WHERE `entry` = 16256 AND `description_loc4` = '在你打出致命一击之后，使你的下3次近战攻击速度提高$16257s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的大地之力图腾和风之优雅图腾的效果提高$s1%。石肤图腾的伤害减免效果提高$s2%且盾牌格挡效果提高$s2%。根基图腾的冷却时间减少$/1000;s3秒。' WHERE `entry` = 16259 AND `description_loc4` = '使你的大地之力图腾和风之优雅图腾的效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的护盾法术充能次数增加$s1，但激活之间的冷却时间增加$s2秒。' WHERE `entry` = 16261 AND `description_loc4` = '使你的闪电之盾法术所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '为你的武器注入能量，带来不同的特殊效果：

UPDATE `locales_spell` SET `description_loc4` = '造成致命一击之后，你的下$16277n次攻击的攻击速度提高$16277s1%。' WHERE `entry` = 16281 AND `description_loc4` = '在你打出致命一击之后，使你的下3次近战攻击速度提高$16277s1%。';

UPDATE `locales_spell` SET `description_loc4` = '造成致命一击之后，你的下$16278n次攻击的攻击速度提高$16278s1%。' WHERE `entry` = 16282 AND `description_loc4` = '在你打出致命一击之后，使你的下3次近战攻击速度提高$16278s1%。';

UPDATE `locales_spell` SET `description_loc4` = '造成致命一击之后，你的下$16279n次攻击的攻击速度提高$16279s1%。' WHERE `entry` = 16283 AND `description_loc4` = '在你打出致命一击之后，使你的下3次近战攻击速度提高$16279s1%。';

UPDATE `locales_spell` SET `description_loc4` = '造成致命一击之后，你的下$16280n次攻击的攻击速度提高$16280s1%。' WHERE `entry` = 16284 AND `description_loc4` = '在你打出致命一击之后，使你的下3次近战攻击速度提高$16280s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的护盾法术充能次数增加$s1，但激活之间的冷却时间增加$s2秒。' WHERE `entry` = 16290 AND `description_loc4` = '使你的闪电之盾法术所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的护盾法术充能次数增加$s1，但激活之间的冷却时间增加$s2秒。' WHERE `entry` = 16291 AND `description_loc4` = '使你的闪电之盾法术所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的大地之力图腾和风之优雅图腾的效果提高$s1%。石肤图腾的伤害减免效果提高$s2%且盾牌格挡效果提高$s2%。根基图腾的冷却时间减少$/1000;s3秒。' WHERE `entry` = 16295 AND `description_loc4` = '使你的大地之力图腾和风之优雅图腾的效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '强化萨满祭司的武器，使其近战攻击强度提高$16311s1点，使用该武器时所有威胁值提高$16311s2%。强化效果持续1小时。' WHERE `entry` = 16314 AND `description_loc4` = '强化萨满祭司的武器，使$g他:她;的近战攻击强度提高$16311s1点，使用该武器对敌人造成近战伤害时产生额外的威胁值。强化效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '强化萨满祭司的武器，使其近战攻击强度提高$16312s1点，使用该武器时所有威胁值提高$16312s2%。强化效果持续1小时。' WHERE `entry` = 16315 AND `description_loc4` = '强化萨满祭司的武器，使$g他:她;的近战攻击强度提高$16312s1点，使用该武器对敌人造成近战伤害时产生额外的威胁值。强化效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '强化萨满祭司的武器，使其近战攻击强度提高$16313s1点，使用该武器时所有威胁值提高$16313s2%。强化效果持续1小时。' WHERE `entry` = 16316 AND `description_loc4` = '强化萨满祭司的武器，使$g他:她;的近战攻击强度提高$16313s1点，使用该武器对敌人造成近战伤害时产生额外的威胁值。强化效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '使目标的攻击和施法速度提高$s1%，持续$d。' WHERE `entry` = 16322 AND `description_loc4` = '使目标的攻击速度提高$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '给萨满祭司的武器附加火焰的力量。每次击中敌人都会对其造成$/77;10445m1到$/25;10445M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续1小时。' WHERE `entry` = 16339 AND `description_loc4` = '给萨满祭司的武器附加火焰的力量。每次击中敌人都会对其造成$/77;10445m1到$/25;10445M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '给萨满祭司的武器附加火焰的力量。每次击中敌人都会对其造成$/77;16343m1到$/25;16343M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续1小时。' WHERE `entry` = 16341 AND `description_loc4` = '给萨满祭司的武器附加火焰的力量。每次击中敌人都会对其造成$/77;16343m1到$/25;16343M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '给萨满祭司的武器附加火焰的力量。每次击中敌人都会对其造成$/77;16344m1到$/25;16344M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续1小时。' WHERE `entry` = 16342 AND `description_loc4` = '给萨满祭司的武器附加火焰的力量。每次击中敌人都会对其造成$/77;16344m1到$/25;16344M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '以冰霜的力量加强萨满祭司的武器，每次击中敌人都有一定几率造成$16352s2点额外的冰霜伤害，并使目标的移动速度降低$16352s1%，减速效果持续$16352d。冰封武器效果持续1小时。' WHERE `entry` = 16355 AND `description_loc4` = '以冰霜的力量加强萨满祭司的武器，每次击中敌人都有一定几率造成$16352s2点额外的冰霜伤害，并使目标的移动速度降低$16352s1%，减速效果持续$16352d。冰封武器效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '以冰霜的力量加强萨满祭司的武器，每次击中敌人都有一定几率造成$16353s2点额外的冰霜伤害，并使目标的移动速度降低$16353s1%，减速效果持续$16353d。冰封武器效果持续1小时。' WHERE `entry` = 16356 AND `description_loc4` = '以冰霜的力量加强萨满祭司的武器，每次击中敌人都有一定几率造成$16353s2点额外的冰霜伤害，并使目标的移动速度降低$16353s1%，减速效果持续$16353d。冰封武器效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '以风的力量加强萨满祭司的武器，每次击中敌人都有25%的几率令你获得额外的$16361s2次近战攻击机会，并且在这几次攻击中的攻击强度提高$16361s1点。风怒效果持续1小时。' WHERE `entry` = 16362 AND `description_loc4` = '以风的力量加强萨满祭司的武器，每次击中敌人都有20%的几率令你获得额外的$16361s2次近战攻击机会，并且在这几次攻击中的攻击强度提高$16361s1点。风怒效果持续5分钟。';

UPDATE `locales_spell` SET `description_loc4` = '在施法者身边召唤一个生命值为$s1点的火舌图腾。图腾令半径$15036a1码范围内的所有小队成员的主手武器每次击中敌人都会对其造成$/77;16389m1到$/25;16389M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续$d。' WHERE `entry` = 16387 AND `description_loc4` = '在施法者身边召唤一个生命值为$s1点的火舌图腾。图腾令半径$15036a1码范围内的所有小队成员的主手武器都附有火焰效果，每次击中敌人都会对其造成$/77;16389m1到$/25;16389M1点额外的火焰伤害，具体数值取决于武器的攻击速度，越慢的武器所附加的火焰伤害越高。持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '立即对目标造成$s1%的武器伤害，并令其流血不止，使其在受到物理攻击时所承受的伤害提高最多$s3%。可最多生效$n次，或者持续$d。奖励$s2个连击点数。' WHERE `entry` = 16511 AND `description_loc4` = '立即对目标造成伤害并令其流血不止，使其在受到物理攻击时所承受的伤害提高最多$s3点。可最多生效$n次，或者持续$d。奖励$s2个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '使你的火焰新星图腾激活所需的延迟时间减少$/1000;s1秒，熔岩图腾所造成的威胁值降低$s3%，灼热图腾的攻击速度提高$56559s1%且攻击范围增加$56559s2码。' WHERE `entry` = 16544 AND `description_loc4` = '使你的火焰新星图腾激活所需的延迟时间减少$/1000;s1秒，熔岩图腾所造成的威胁值降低$s3%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的愤怒法术的施法时间和公共冷却时间减少$/1000;S1秒。' WHERE `entry` = 16814 AND `description_loc4` = '使你的愤怒法术的施法时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的愤怒法术的施法时间和公共冷却时间减少$/1000;S1秒。' WHERE `entry` = 16815 AND `description_loc4` = '使你的愤怒法术的施法时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的愤怒法术的施法时间和公共冷却时间减少$/1000;S1秒。' WHERE `entry` = 16816 AND `description_loc4` = '使你的愤怒法术的施法时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的愤怒法术的施法时间和公共冷却时间减少$/1000;S1秒。' WHERE `entry` = 16817 AND `description_loc4` = '使你的愤怒法术的施法时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的愤怒法术的施法时间和公共冷却时间减少$/1000;S1秒。' WHERE `entry` = 16818 AND `description_loc4` = '使你的愤怒法术的施法时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的愤怒、纠缠根须、精灵之火、月火术、星火术、虫群、飓风、解除诅咒、驱毒术和消毒术的射程增加$s1%。' WHERE `entry` = 16819 AND `description_loc4` = '使你的愤怒、纠缠根须、精灵之火、月火术、星火术和飓风的射程增加$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的愤怒、纠缠根须、精灵之火、月火术、星火术、虫群、飓风、解除诅咒、驱毒术和消毒术的射程增加$s1%。' WHERE `entry` = 16820 AND `description_loc4` = '使你的愤怒、纠缠根须、精灵之火、月火术、星火术和飓风的射程增加$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的月火术、星火术、愤怒、飓风、虫群、治疗之触、愈合和回春术所消耗的法力值减少$s1%。' WHERE `entry` = 16845 AND `description_loc4` = '使你的月火术、星火术、愤怒、治疗之触、愈合和回春术所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的月火术、星火术、愤怒、飓风、虫群、治疗之触、愈合和回春术所消耗的法力值减少$s1%。' WHERE `entry` = 16846 AND `description_loc4` = '使你的月火术、星火术、愤怒、治疗之触、愈合和回春术所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的月火术、星火术、愤怒、飓风、虫群、治疗之触、愈合和回春术所消耗的法力值减少$s1%。' WHERE `entry` = 16847 AND `description_loc4` = '使你的月火术、星火术、愤怒、治疗之触、愈合和回春术所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '以自然的力量强化德鲁伊的武器，每次近战攻击或攻击性法术命中敌人都有一定几率令德鲁伊进入节能施法状态。该状态可以让你的下一个伤害法术、治疗法术或攻击技能所消耗的法力值、怒气值或能量值降低$16870s1%。' WHERE `entry` = 16864 AND `description_loc4` = '以自然的力量强化德鲁伊的武器，每次近战攻击命中敌人都有一定几率令德鲁伊进入节能施法状态。该状态可以让你的下一个伤害法术、治疗法术或攻击技能所消耗的法力值、怒气值或能量值降低$16870s1%。清晰预兆效果可持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的星火术、月火术、飓风、虫群和愤怒所能造成的伤害提高$s1%。' WHERE `entry` = 16896 AND `description_loc4` = '使你的星火术、月火术和愤怒所能造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的星火术、月火术、飓风、虫群和愤怒所能造成的伤害提高$s1%。' WHERE `entry` = 16897 AND `description_loc4` = '使你的星火术、月火术和愤怒所能造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的星火术、月火术、飓风、虫群和愤怒所能造成的伤害提高$s1%。' WHERE `entry` = 16899 AND `description_loc4` = '使你的星火术、月火术和愤怒所能造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '在指定区域制造一场强烈的风暴，对该区域中的所有敌人每$t1秒造成$s1点自然伤害，持续$d。德鲁伊必须引导法术的能量以维持此效果。' WHERE `entry` = 16914 AND `description_loc4` = '在指定区域制造一场强烈的风暴，对该区域中的所有敌人每$t1秒造成$s1点自然伤害，并使其攻击间隔延长$s2%，持续$d。德鲁伊必须引导法术的能量以维持此效果。';

UPDATE `locales_spell` SET `description_loc4` = '撕碎的伤害提高$s2%，消耗的能量值降低$s1点。' WHERE `entry` = 16966 AND `description_loc4` = '使你的撕碎技能所消耗的能量值减少$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '撕碎的伤害提高$s2%，消耗的能量值降低$s1点。' WHERE `entry` = 16968 AND `description_loc4` = '使你的撕碎技能所消耗的能量值减少$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '使你在猎豹、熊和巨熊形态下的近战攻击强度提高$s1%。你的爪击、扫击、槌击、挥击和野蛮撕咬的伤害提高$s2%。' WHERE `entry` = 16972 AND `description_loc4` = '使你在猎豹、熊和巨熊形态下的近战攻击强度加成提高，数值相当于你的当前等级的$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你在猎豹、熊和巨熊形态下的近战攻击强度提高$s1%。你的爪击、扫击、槌击、挥击和野蛮撕咬的伤害提高$s2%。' WHERE `entry` = 16974 AND `description_loc4` = '使你在猎豹、熊和巨熊形态下的近战攻击强度加成提高，数值相当于你的当前等级的$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你在猎豹、熊和巨熊形态下的近战攻击强度提高$s1%。你的爪击、扫击、槌击、挥击和野蛮撕咬的伤害提高$s2%。' WHERE `entry` = 16975 AND `description_loc4` = '使你在猎豹、熊和巨熊形态下的近战攻击强度加成提高，数值相当于你的当前等级的$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你在猎豹形态下的移动速度提高$s1%，只能在户外生效。另外，还可使你在熊、巨熊、猎豹形态下的躲闪几率提高$24867s1%。' WHERE `entry` = 17002 AND `description_loc4` = '使你在猎豹形态下的移动速度提高$s1%，只能在户外生效。另外，还可使你在猎豹形态下的躲闪几率提高$24867s1%。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会制作奥金勇士剑。' WHERE `entry` = 17032 AND `description_loc4` = '教你学会制作奥金圣剑。';

UPDATE `locales_spell` SET `description_loc4` = '使你在施放愈合、治疗之触或宁静时有$s1%的几率不因受到伤害而延迟。' WHERE `entry` = 17063 AND `description_loc4` = '使你在施放愈合、治疗之触或宁静时有$s1%的几率不因受到伤害而被打断。';

UPDATE `locales_spell` SET `description_loc4` = '使你在施放愈合、治疗之触或宁静时有$s1%的几率不因受到伤害而延迟。' WHERE `entry` = 17065 AND `description_loc4` = '使你在施放愈合、治疗之触或宁静时有$s1%的几率不因受到伤害而被打断。';

UPDATE `locales_spell` SET `description_loc4` = '使你在施放愈合、治疗之触或宁静时有$s1%的几率不因受到伤害而延迟。' WHERE `entry` = 17066 AND `description_loc4` = '使你在施放愈合、治疗之触或宁静时有$s1%的几率不因受到伤害而被打断。';

UPDATE `locales_spell` SET `description_loc4` = '使你在施放愈合、治疗之触或宁静时有$s1%的几率不因受到伤害而延迟。' WHERE `entry` = 17067 AND `description_loc4` = '使你在施放愈合、治疗之触或宁静时有$s1%的几率不因受到伤害而被打断。';

UPDATE `locales_spell` SET `description_loc4` = '使你在施放愈合、治疗之触或宁静时有$s1%的几率不因受到伤害而延迟。' WHERE `entry` = 17068 AND `description_loc4` = '使你在施放愈合、治疗之触或宁静时有$s1%的几率不因受到伤害而被打断。';

UPDATE `locales_spell` SET `description_loc4` = '使你法术技能的持续伤害效果和持续治疗效果提高$s1%。' WHERE `entry` = 17111 AND `description_loc4` = '使你的回春术的效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你法术技能的持续伤害效果和持续治疗效果提高$s1%。' WHERE `entry` = 17112 AND `description_loc4` = '使你的回春术的效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你法术技能的持续伤害效果和持续治疗效果提高$s1%。' WHERE `entry` = 17113 AND `description_loc4` = '使你的回春术的效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的宁静法术的治疗效果提高$s1%。' WHERE `entry` = 17123 AND `description_loc4` = '使你的宁静法术导致的威胁值降低$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的宁静法术的治疗效果提高$s1%。' WHERE `entry` = 17124 AND `description_loc4` = '使你的宁静法术导致的威胁值降低$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成$s1点伤害，每层十字军打击都可使目标在受到神圣伤害时多承受$s2点额外神圣伤害，最多叠加5层。持续$d。。' WHERE `entry` = 17281 AND `description_loc4` = '对目标造成$s1点伤害，每次十字军打击都可使目标在受到神圣伤害时多承受$s2点额外神圣伤害，共可累加5次。持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '在$d内对施法者面前一个锥形区域内的所有敌人造成50点火焰伤害。' WHERE `entry` = 17282 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '对半径$a1码范围内的亡灵造成$s1点伤害，此效果不产生威胁值。' WHERE `entry` = 17291 AND `description_loc4` = '对半径10码范围内的亡灵造成438-562点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '使你获得一次额外的攻击机会，造成$s1%武器伤害，并使你造成的下$52412n次自然伤害提高$52412s1%，持续$52412d。' WHERE `entry` = 17364 AND `description_loc4` = '使你获得一次额外的攻击机会，另外，你的下2次攻击对敌人造成的自然伤害提高$s2%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '在指定区域制造一场强烈的风暴，对该区域中的所有敌人每$t1秒造成$s1点自然伤害，持续$d。德鲁伊必须引导法术的能量以维持此效果。' WHERE `entry` = 17401 AND `description_loc4` = '在指定区域制造一场强烈的风暴，对该区域中的所有敌人每$t1秒造成$s1点自然伤害，并使其攻击间隔延长$s2%，持续$d。德鲁伊必须引导法术的能量以维持此效果。';

UPDATE `locales_spell` SET `description_loc4` = '在指定区域制造一场强烈的风暴，对该区域中的所有敌人每$t1秒造成$s1点自然伤害，持续$d。德鲁伊必须引导法术的能量以维持此效果。' WHERE `entry` = 17402 AND `description_loc4` = '在指定区域制造一场强烈的风暴，对该区域中的所有敌人每$t1秒造成$s1点自然伤害，并使其攻击间隔延长$s2%，持续$d。德鲁伊必须引导法术的能量以维持此效果。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有的属性总值提高$s1%。' WHERE `entry` = 17485 AND `description_loc4` = '使你的法力值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有的属性总值提高$s1%。' WHERE `entry` = 17486 AND `description_loc4` = '使你的法力值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有的属性总值提高$s1%。' WHERE `entry` = 17487 AND `description_loc4` = '使你的法力值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有的属性总值提高$s1%。' WHERE `entry` = 17488 AND `description_loc4` = '使你的法力值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有的属性总值提高$s1%。' WHERE `entry` = 17489 AND `description_loc4` = '使你的法力值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会配制优质法力药水。' WHERE `entry` = 17583 AND `description_loc4` = '教你学会配制超级法力药水。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 17617 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '使你的移动速度提高$s2%，并每$t1秒恢复$s1点生命值。$42023a1内的友方目标会获得一半的效果。' WHERE `entry` = 17625 AND `description_loc4` = '移动速度和生命值回复速度提高。';

UPDATE `locales_spell` SET `description_loc4` = '嘲讽半径$a1码范围内的所有敌人，造成$s2点暗影伤害，使它们有更高的几率转而攻击虚空行者。' WHERE `entry` = 17735 AND `description_loc4` = '嘲讽半径$a1码范围内的所有敌人，使它们有更高的几率转而攻击虚空行者。';

UPDATE `locales_spell` SET `description_loc4` = '嘲讽半径$a1码范围内的所有敌人，造成$s2点暗影伤害，使它们有更高的几率转而攻击虚空行者。比受难（等级 1）更有效。' WHERE `entry` = 17750 AND `description_loc4` = '嘲讽半径$a1码范围内的所有敌人，使它们有更高的几率转而攻击虚空行者。比受难（等级 1）更有效。';

UPDATE `locales_spell` SET `description_loc4` = '嘲讽半径$a1码范围内的所有敌人，造成$s2点暗影伤害，使它们有更高的几率转而攻击虚空行者。比受难（等级 2）更有效。' WHERE `entry` = 17751 AND `description_loc4` = '嘲讽半径$a1码范围内的所有敌人，使它们有更高的几率转而攻击虚空行者。比受难（等级 2）更有效。';

UPDATE `locales_spell` SET `description_loc4` = '嘲讽半径$a1码范围内的所有敌人，造成$s2暗影伤害，使它们有更高的几率转而攻击虚空行者。比受难（等级 3）更有效。' WHERE `entry` = 17752 AND `description_loc4` = '嘲讽半径$a1码范围内的所有敌人，使它们有更高的几率转而攻击虚空行者。比受难（等级 3）更有效。';

UPDATE `locales_spell` SET `description_loc4` = '你的痛苦法术有$s1%的几率不会因受到伤害而延迟。' WHERE `entry` = 17783 AND `description_loc4` = '使你有$s1%的几率在施放吸取生命、吸取法力或吸取灵魂法术时不会因受到伤害而被打断。';

UPDATE `locales_spell` SET `description_loc4` = '你的痛苦法术有$s1%的几率不会因受到伤害而延迟。' WHERE `entry` = 17784 AND `description_loc4` = '使你有$s1%的几率在施放吸取生命、吸取法力或吸取灵魂法术时不会因受到伤害而被打断。';

UPDATE `locales_spell` SET `description_loc4` = '使你在引导吸取生命、吸取法力、吸取灵魂和暗影收割时，有$s1%的几率不会因受到伤害而延迟。' WHERE `entry` = 17785 AND `description_loc4` = '使你有$s1%的几率在施放吸取生命、吸取法力或吸取灵魂法术时不会因受到伤害而被打断。';

UPDATE `locales_spell` SET `description_loc4` = '使你在引导吸取生命、吸取法力、吸取灵魂和暗影收割时，有$s1%的几率不会因受到伤害而延迟。' WHERE `entry` = 17786 AND `description_loc4` = '使你有$s1%的几率在施放吸取生命、吸取法力或吸取灵魂法术时不会因受到伤害而被打断。';

UPDATE `locales_spell` SET `description_loc4` = '使你在引导吸取生命、吸取法力、吸取灵魂和暗影收割时，有$s1%的几率不会因受到伤害而延迟。' WHERE `entry` = 17787 AND `description_loc4` = '使你有$s1%的几率在施放吸取生命、吸取法力或吸取灵魂法术时不会因受到伤害而被打断。';

UPDATE `locales_spell` SET `description_loc4` = '使你的暗影箭、灼热之痛和献祭的施法时间减少$/1000;S1秒，灵魂之火的施法时间减少$/1000;S2秒。' WHERE `entry` = 17788 AND `description_loc4` = '使你的暗影箭和献祭的施法时间减少$/1000;S1秒，灵魂之火的施法时间减少$/1000;S2秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的暗影箭、灼热之痛和献祭的施法时间减少$/1000;S1秒，灵魂之火的施法时间减少$/1000;S2秒。' WHERE `entry` = 17789 AND `description_loc4` = '使你的暗影箭和献祭的施法时间减少$/1000;S1秒，灵魂之火的施法时间减少$/1000;S2秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的暗影箭、灼热之痛和献祭的施法时间减少$/1000;S1秒，灵魂之火的施法时间减少$/1000;S2秒。' WHERE `entry` = 17790 AND `description_loc4` = '使你的暗影箭和献祭的施法时间减少$/1000;S1秒，灵魂之火的施法时间减少$/1000;S2秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的暗影箭、灼热之痛和献祭的施法时间减少$/1000;S1秒，灵魂之火的施法时间减少$/1000;S2秒。' WHERE `entry` = 17791 AND `description_loc4` = '使你的暗影箭和献祭的施法时间减少$/1000;S1秒，灵魂之火的施法时间减少$/1000;S2秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的暗影箭、灼热之痛和献祭的施法时间减少$/1000;S1秒，灵魂之火的施法时间减少$/1000;S2秒。' WHERE `entry` = 17792 AND `description_loc4` = '使你的暗影箭和献祭的施法时间减少$/1000;S1秒，灵魂之火的施法时间减少$/1000;S2秒。';

UPDATE `locales_spell` SET `description_loc4` = '你的暗影箭和吸取灵魂有$h%的几率触发暗影易伤，使你对目标造成的暗影伤害提高$17794s1%，持续$17794d。造成致命一击时触发几率更高。' WHERE `entry` = 17793 AND `description_loc4` = '在你的暗影箭对目标造成致命一击后，你对其造成的接连4次非持续性暗影伤害都将提高$17794s1%。效果持续最多$17794d。';

UPDATE `locales_spell` SET `description_loc4` = '你的暗影箭和吸取灵魂有$h%的几率触发暗影易伤，使你对目标造成的暗影伤害提高$17794s1%，持续$17794d。造成致命一击时触发几率更高。' WHERE `entry` = 17796 AND `description_loc4` = '在你的暗影箭对目标造成致命一击后，你对其造成的接连4次非持续性暗影伤害都将提高$17798s1%。效果持续最多$17798d。';

UPDATE `locales_spell` SET `description_loc4` = '你的暗影箭和吸取灵魂有$h%的几率触发暗影易伤，使你对目标造成的暗影伤害提高$17794s1%，持续$17794d。造成致命一击时触发几率更高。' WHERE `entry` = 17801 AND `description_loc4` = '在你的暗影箭对目标造成致命一击后，你对其造成的接连4次非持续性暗影伤害都将提高$17797s1%。效果持续最多$17797d。';

UPDATE `locales_spell` SET `description_loc4` = '你的暗影箭和吸取灵魂有$h%的几率触发暗影易伤，使你对目标造成的暗影伤害提高$17794s1%，持续$17794d。造成致命一击时触发几率更高。' WHERE `entry` = 17802 AND `description_loc4` = '在你的暗影箭对目标造成致命一击后，你对其造成的接连4次非持续性暗影伤害都将提高$17799s1%。效果持续最多$17799d。';

UPDATE `locales_spell` SET `description_loc4` = '你的暗影箭和吸取灵魂有$h%的几率触发暗影易伤，使你对目标造成的暗影伤害提高$17794s1%，持续$17794d。造成致命一击时触发几率更高。' WHERE `entry` = 17803 AND `description_loc4` = '在你的暗影箭对目标造成致命一击后，你对其造成的接连4次非持续性暗影伤害都将提高$17800s1%。效果持续最多$17800d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的献祭法术的伤害提高$s1%。' WHERE `entry` = 17815 AND `description_loc4` = '使你的献祭法术的初始伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的献祭法术的伤害提高$s1%。' WHERE `entry` = 17833 AND `description_loc4` = '使你的献祭法术的初始伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的献祭法术的伤害提高$s1%。' WHERE `entry` = 17834 AND `description_loc4` = '使你的献祭法术的初始伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的献祭法术的伤害提高$s1%。' WHERE `entry` = 17835 AND `description_loc4` = '使你的献祭法术的初始伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的献祭法术的伤害提高$s1%。' WHERE `entry` = 17836 AND `description_loc4` = '使你的献祭法术的初始伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的毁灭系法术的射程增加$s1%，地狱烈焰的影响半径增加$s2%。' WHERE `entry` = 17917 AND `description_loc4` = '使你的毁灭系法术的射程增加$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的毁灭系法术的射程增加$s1%，地狱烈焰的影响半径增加$s2%。' WHERE `entry` = 17918 AND `description_loc4` = '使你的毁灭系法术的射程增加$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使目标感受灼热的痛苦，对其造成$s1点火焰伤害。' WHERE `entry` = 17919 AND `description_loc4` = '使目标感受灼热的痛苦，对其造成$s1点火焰伤害，并产生很高的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '使目标感受灼热的痛苦，对其造成$s1点火焰伤害。' WHERE `entry` = 17920 AND `description_loc4` = '使目标感受灼热的痛苦，对其造成$s1点火焰伤害，并产生很高的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '使目标感受灼热的痛苦，对其造成$s1点火焰伤害。' WHERE `entry` = 17921 AND `description_loc4` = '使目标感受灼热的痛苦，对其造成$s1点火焰伤害，并产生很高的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '使目标感受灼热的痛苦，对其造成$s1点火焰伤害。' WHERE `entry` = 17922 AND `description_loc4` = '使目标感受灼热的痛苦，对其造成$s1点火焰伤害，并产生很高的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '使目标感受灼热的痛苦，对其造成$s1点火焰伤害。' WHERE `entry` = 17923 AND `description_loc4` = '使目标感受灼热的痛苦，对其造成$s1点火焰伤害，并产生很高的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '燃烧敌人的灵魂，对其造成$s1点火焰伤害，此法术的法术伤害加成较高。' WHERE `entry` = 17924 AND `description_loc4` = '燃烧敌人的灵魂，对其造成$s1点火焰伤害。';

UPDATE `locales_spell` SET `description_loc4` = '点燃目标，造成$s1点火焰伤害，并消耗3秒的献祭效果来造成等量的伤害。' WHERE `entry` = 17962 AND `description_loc4` = '点燃一个已经受到献祭效果影响的目标，对其造成$s1点火焰伤害，并吞噬献祭法术的效果。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 18060 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '单手剑技能提高$s1点。' WHERE `entry` = 18061 AND `description_loc4` = '剑类武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '使你的攻击和施法速度提高$s1%。' WHERE `entry` = 18065 AND `description_loc4` = '使你的攻击速度提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 18068 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 18069 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '使你的腐蚀术、暗影收割和吸取法术有$h%的几率在对敌人造成伤害之后令你进入暗影冥思状态。暗影冥思可以令你的下一个暗影箭的施法时间减少$17941s1%，且必定命中。' WHERE `entry` = 18094 AND `description_loc4` = '使你的腐蚀术和吸取生命法术有2%的几率在对敌人造成伤害之后令你进入暗影冥思状态。暗影冥思状可以令你的下一个暗影箭法术的施法时间减少$17941s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的腐蚀术、暗影收割和吸取法术有$h%的几率在对敌人造成伤害之后令你进入暗影冥思状态。暗影冥思可以令你的下一个暗影箭的施法时间减少$17941s1%，且必定命中。' WHERE `entry` = 18095 AND `description_loc4` = '使你的腐蚀术和吸取生命法术有4%的几率在对敌人造成伤害之后令你进入暗影冥思状态。暗影冥思状可以令你的下一个暗影箭法术的施法时间减少$17941s1%。';

UPDATE `locales_spell` SET `description_loc4` = '献祭的持续伤害提高$s2%，并使你的毁灭系法术有$h%的几率使目标移动速度降低50%，持续$18118d。' WHERE `entry` = 18119 AND `description_loc4` = '使你的毁灭系法术有$h%的几率令目标眩晕$18118d。';

UPDATE `locales_spell` SET `description_loc4` = '献祭的持续伤害提高$s2%，并使你的毁灭系法术有$h%的几率使目标移动速度降低50%，持续$18118d。' WHERE `entry` = 18120 AND `description_loc4` = '使你的毁灭系法术有$h%的几率令目标眩晕$18118d。';

UPDATE `locales_spell` SET `description_loc4` = '献祭的持续伤害提高$s2%，并使你的毁灭系法术有$h%的几率使目标移动速度降低50%，持续$18118d。' WHERE `entry` = 18121 AND `description_loc4` = '使你的毁灭系法术有$h%的几率令目标眩晕$18118d。';

UPDATE `locales_spell` SET `description_loc4` = '虚弱诅咒造成的攻击速度降低效果提高$s1%。' WHERE `entry` = 18179 AND `description_loc4` = '使你的虚弱诅咒的效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '虚弱诅咒造成的攻击速度降低效果提高$s1%。' WHERE `entry` = 18180 AND `description_loc4` = '使你的虚弱诅咒的效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 18188 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '测试：使你的伤害性法术击中目标后有$s2%的几率进入节能施法状态。节能施法状态可以使你的下一个伤害性法术所消耗的法力值减少$12536s1%。' WHERE `entry` = 18189 AND `description_loc4` = 'TEST: Gives you a $s2% chance of entering a Clearcasting state after any damage spell hits a target.  The Clearcasting state reduces the mana cost of your next damage spell by $12536s1%.';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 18190 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 18195 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '使目标的速度降低$s1%，持续$d。每个术士只能对一个目标施加一种诅咒。' WHERE `entry` = 18223 AND `description_loc4` = '使目标的速度降低$s1%，持续$d。每个术士只能对一个目标施加一种诅咒，且同类诅咒不能叠加。';

UPDATE `locales_spell` SET `description_loc4` = '在$d内将目标的$*10;s1点生命值转移给施法者。' WHERE `entry` = 18265 AND `description_loc4` = '每$t1秒将目标的$s1点生命值转移给施法者，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 18281 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '使你的邪恶攻击、剔骨、还击、突袭技能的伤害提高$s1%。' WHERE `entry` = 18427 AND `description_loc4` = '使你的邪恶攻击和剔骨技能的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的邪恶攻击、剔骨、还击、突袭技能的伤害提高$s1%。' WHERE `entry` = 18428 AND `description_loc4` = '使你的邪恶攻击和剔骨技能的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的邪恶攻击、剔骨、还击、突袭技能的伤害提高$s1%。' WHERE `entry` = 18429 AND `description_loc4` = '使你的邪恶攻击和剔骨技能的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你在施法时仍保持$s1%的法力回复速度。当总法力值低于$s2%时，此效果将变为原来的三倍。' WHERE `entry` = 18462 AND `description_loc4` = '使你在施法时仍保持$s1%的法力回复速度。';

UPDATE `locales_spell` SET `description_loc4` = '使你在施法时仍保持$s1%的法力回复速度。当总法力值低于$s2%时，此效果将变为原来的三倍。' WHERE `entry` = 18463 AND `description_loc4` = '使你在施法时仍保持$s1%的法力回复速度。';

UPDATE `locales_spell` SET `description_loc4` = '使你在施法时仍保持$s1%的法力回复速度。当总法力值低于$s2%时，此效果将变为原来的三倍。' WHERE `entry` = 18464 AND `description_loc4` = '使你在施法时仍保持$s1%的法力回复速度。';

UPDATE `locales_spell` SET `description_loc4` = '进入狂暴状态，对恐惧和击昏效果免疫，在受到伤害时额外产生$s3%的怒气值，持续$d。' WHERE `entry` = 18499 AND `description_loc4` = '战士进入狂暴状态，对恐惧和击昏效果免疫，在受到伤害时产生额外的怒气值，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '进行仪式，召唤出一个受施法者指挥的末日守卫，持续$53222d。一旦失去控制，末日守卫就会攻击施法者，直到其中一方死亡。需要施法者和1名队友共同进行仪式，参与者必须使用右键点击传送门，在完成仪式之前不得移动或做出其他动作。' WHERE `entry` = 18540 AND `description_loc4` = '进行祭祀仪式，随机牺牲一个参与者以召唤出一个末日守卫。你必须立即奴役末日守卫，否则它就会攻击参与仪式者。需要施法者和4个队友共同进行仪式，所有参与者都必须使用右键点击传送门，在完成仪式之前不得移动。';

UPDATE `locales_spell` SET `description_loc4` = '使你的法术伤害和攻击性法术的致命一击几率提高$s1%，并且使你的真言术：盾所吸收的伤害量提高$s3%。' WHERE `entry` = 18544 AND `description_loc4` = '使你的法术伤害提高$s1%，攻击性法术的致命一击几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的法术伤害和攻击性法术的致命一击几率提高$s1%，并且使你的真言术：盾所吸收的伤害量提高$s3%。' WHERE `entry` = 18547 AND `description_loc4` = '使你的法术伤害提高$s1%，攻击性法术的致命一击几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的法术伤害和攻击性法术的致命一击几率提高$s1%，并且使你的真言术：盾所吸收的伤害量提高$s3%。' WHERE `entry` = 18548 AND `description_loc4` = '使你的法术伤害提高$s1%，攻击性法术的致命一击几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的法术伤害和攻击性法术的致命一击几率提高$s1%，并且使你的真言术：盾所吸收的伤害量提高$s3%。' WHERE `entry` = 18549 AND `description_loc4` = '使你的法术伤害提高$s1%，攻击性法术的致命一击几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的法术伤害和攻击性法术的致命一击几率提高$s1%，并且使你的真言术：盾所吸收的伤害量提高$s3%。' WHERE `entry` = 18550 AND `description_loc4` = '使你的法术伤害提高$s1%，攻击性法术的致命一击几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的总智力提高$s1%，施法速度提高$s2%。' WHERE `entry` = 18551 AND `description_loc4` = '使你的法力值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的总智力提高$s1%，施法速度提高$s2%。' WHERE `entry` = 18552 AND `description_loc4` = '使你的法力值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的总智力提高$s1%，施法速度提高$s2%。' WHERE `entry` = 18553 AND `description_loc4` = '使你的法力值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '连续射出弹药，对最多$x1个目标造成普通伤害外加$s1点伤害。' WHERE `entry` = 18651 AND `description_loc4` = '连续射出弹药，对最多$x1个目标造成普通伤害外加$s1点奥术伤害。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18672 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18673 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18674 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18675 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18676 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18677 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18678 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18679 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18680 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18681 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18682 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18683 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18684 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18685 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18686 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18687 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18688 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18689 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18690 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1所有魔法抗性。' WHERE `entry` = 18691 AND `description_loc4` = '+$S1 所有魔法抗性。';

UPDATE `locales_spell` SET `description_loc4` = '使你的生命通道转化的生命值提高，数值相当于恶魔损失生命值的$s1%；法力通道转化的法力值提高，数值相当于恶魔损失法力值的$s1%。增加的额外数值会从你身上扣除该效果的$q1%。' WHERE `entry` = 18703 AND `description_loc4` = '使你的生命通道法术所转化的生命值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的生命通道转化的生命值提高，数值相当于恶魔损失生命值的$s1%；法力通道转化的法力值提高，数值相当于恶魔损失法力值的$s1%。增加的额外数值会从你身上扣除该效果的$q1%。' WHERE `entry` = 18704 AND `description_loc4` = '使你的生命通道法术所转化的生命值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的下一个普通恶魔召唤法术的施法时间减少$/1000;S1秒，法力消耗减少$s2%。' WHERE `entry` = 18708 AND `description_loc4` = '你的下一个召唤小鬼、虚空行者、魅魔或地狱猎犬的法术施法时间减少$/1000;S1秒，法力消耗减少$s2%。';

UPDATE `locales_spell` SET `description_loc4` = '使你召唤小鬼、虚空行者、魅魔和地狱猎犬的施法时间减少$/1000;s1秒，法力值消耗降低$s2%。地狱火、末日仪式和恶魔之门的冷却时间减少$s3%。' WHERE `entry` = 18709 AND `description_loc4` = '使你召唤小鬼、虚空行者、魅魔和地狱猎犬的施法时间减少$/1000;s1秒，法力值消耗降低$s2%。';

UPDATE `locales_spell` SET `description_loc4` = '使你召唤小鬼、虚空行者、魅魔和地狱猎犬的施法时间减少$/1000;s1秒，法力值消耗降低$s2%。地狱火、末日仪式和恶魔之门的冷却时间减少$s3%。' WHERE `entry` = 18710 AND `description_loc4` = '使你召唤小鬼、虚空行者、魅魔和地狱猎犬的施法时间减少$/1000;s1秒，法力值消耗降低$s2%。';

UPDATE `locales_spell` SET `description_loc4` = '使你当前恶魔的智力继承你自身总智力的$s1%，并允许它们在施法时继续保持$s2%的法力恢复速度。' WHERE `entry` = 18731 AND `description_loc4` = '使你的小鬼、虚空行者、魅魔和地狱猎犬的法力值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你当前恶魔的智力继承你自身总智力的$s1%，并允许它们在施法时继续保持$s2%的法力恢复速度。' WHERE `entry` = 18743 AND `description_loc4` = '使你的小鬼、虚空行者、魅魔和地狱猎犬的法力值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你当前恶魔的智力继承你自身总智力的$s1%，并允许它们在施法时继续保持$s2%的法力恢复速度。' WHERE `entry` = 18744 AND `description_loc4` = '使你的小鬼、虚空行者、魅魔和地狱猎犬的法力值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你当前恶魔的智力继承你自身总智力的$s1%，并允许它们在施法时继续保持$s2%的法力恢复速度。' WHERE `entry` = 18745 AND `description_loc4` = '使你的小鬼、虚空行者、魅魔和地狱猎犬的法力值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你当前恶魔的智力继承你自身总智力的$s1%，并允许它们在施法时继续保持$s2%的法力恢复速度。' WHERE `entry` = 18746 AND `description_loc4` = '使你的小鬼、虚空行者、魅魔和地狱猎犬的法力值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你当前恶魔的耐力继承你自身总耐力的$s1%，并使它们受到致命一击的几率降低$s2%。' WHERE `entry` = 18748 AND `description_loc4` = '使你的小鬼、虚空行者、魅魔和地狱猎犬的生命值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你当前恶魔的耐力继承你自身总耐力的$s1%，并使它们受到致命一击的几率降低$s2%。' WHERE `entry` = 18749 AND `description_loc4` = '使你的小鬼、虚空行者、魅魔和地狱猎犬的生命值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你当前恶魔的耐力继承你自身总耐力的$s1%，并使它们受到致命一击的几率降低$s2%。' WHERE `entry` = 18750 AND `description_loc4` = '使你的小鬼、虚空行者、魅魔和地狱猎犬的生命值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你当前恶魔的耐力继承你自身总耐力的$s1%，并使它们受到致命一击的几率降低$s2%。' WHERE `entry` = 18751 AND `description_loc4` = '使你的小鬼、虚空行者、魅魔和地狱猎犬的生命值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你当前恶魔的耐力继承你自身总耐力的$s1%，并使它们受到致命一击的几率降低$s2%。' WHERE `entry` = 18752 AND `description_loc4` = '使你的小鬼、虚空行者、魅魔和地狱猎犬的生命值上限提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的恶魔造成的伤害提高$s1%。' WHERE `entry` = 18769 AND `description_loc4` = '使你的虚空行者、魅魔和地狱猎犬的近战伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的恶魔造成的伤害提高$s1%。' WHERE `entry` = 18770 AND `description_loc4` = '使你的虚空行者、魅魔和地狱猎犬的近战伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的恶魔造成的伤害提高$s1%。' WHERE `entry` = 18771 AND `description_loc4` = '使你的虚空行者、魅魔和地狱猎犬的近战伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的奴役恶魔法术的攻击和施法速度惩罚减轻$s1%，恶魔抵抗奴役效果的几率降低$s3%。' WHERE `entry` = 18821 AND `description_loc4` = '使你的奴役恶魔法术的攻击速度和施法速度惩罚减轻$s1%，恶魔抵抗奴役效果的几率降低$s3%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的奴役恶魔法术的攻击和施法速度惩罚减轻$s1%，恶魔抵抗奴役效果的几率降低$s3%。' WHERE `entry` = 18822 AND `description_loc4` = '使你的奴役恶魔法术的攻击速度和施法速度惩罚减轻$s1%，恶魔抵抗奴役效果的几率降低$s3%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的奴役恶魔法术的攻击和施法速度惩罚减轻$s1%，恶魔抵抗奴役效果的几率降低$s3%。' WHERE `entry` = 18823 AND `description_loc4` = '使你的奴役恶魔法术的攻击速度和施法速度惩罚减轻$s1%，恶魔抵抗奴役效果的几率降低$s3%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的奴役恶魔法术的攻击和施法速度惩罚减轻$s1%，恶魔抵抗奴役效果的几率降低$s3%。' WHERE `entry` = 18824 AND `description_loc4` = '使你的奴役恶魔法术的攻击速度和施法速度惩罚减轻$s1%，恶魔抵抗奴役效果的几率降低$s3%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的奴役恶魔法术的攻击和施法速度惩罚减轻$s1%，恶魔抵抗奴役效果的几率降低$s3%。' WHERE `entry` = 18825 AND `description_loc4` = '使你的奴役恶魔法术的攻击速度和施法速度惩罚减轻$s1%，恶魔抵抗奴役效果的几率降低$s3%。';

UPDATE `locales_spell` SET `description_loc4` = '在$d内将目标的$*10;s1点生命值转移给施法者。' WHERE `entry` = 18879 AND `description_loc4` = '每$t1秒将目标的$s1点生命值转移给施法者，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '在$d内将目标的$*10;s1点生命值转移给施法者。' WHERE `entry` = 18880 AND `description_loc4` = '每$t1秒将目标的$s1点生命值转移给施法者，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '在$d内将目标的$*10;s1点生命值转移给施法者。' WHERE `entry` = 18881 AND `description_loc4` = '每$t1秒将目标的$s1点生命值转移给施法者，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '点燃目标，造成$s1点火焰伤害，并消耗3秒的献祭效果来造成等量的伤害。' WHERE `entry` = 18930 AND `description_loc4` = '点燃一个已经被施加献祭效果的目标，对其造成$s1点火焰伤害并吞噬掉献祭效果。';

UPDATE `locales_spell` SET `description_loc4` = '点燃目标，造成$s1点火焰伤害，并消耗3秒的献祭效果来造成等量的伤害。' WHERE `entry` = 18931 AND `description_loc4` = '点燃一个已经被施加献祭效果的目标，对其造成$s1点火焰伤害并吞噬掉献祭效果。';

UPDATE `locales_spell` SET `description_loc4` = '点燃目标，造成$s1点火焰伤害，并消耗3秒的献祭效果来造成等量的伤害。' WHERE `entry` = 18932 AND `description_loc4` = '点燃一个已经被施加献祭效果的目标，对其造成$s1点火焰伤害并吞噬掉献祭效果。';

UPDATE `locales_spell` SET `description_loc4` = '当恶魔被你控制时，你和恶魔造成的伤害提高$25228s1%，你所受伤害的$25228s2%被恶魔分担。你召唤的高级恶魔和被奴役的恶魔将不再提前脱离控制。' WHERE `entry` = 19028 AND `description_loc4` = '激活之后，施法者所承受的伤害有$18814s1%被$g他:她;的恶魔分担。另外，恶魔和其主人的任何攻击所造成的伤害都提高$25228s1%。只要恶魔保持激活状态，该效果就一直持续。';

UPDATE `locales_spell` SET `description_loc4` = '你的副手武器造成的伤害提高$s2%，并使你的割伤、猛禽一击、猫鼬撕咬、切碎和摔绊的致命一击几率提高$s1%。' WHERE `entry` = 19159 AND `description_loc4` = '使你的猛禽一击和猫鼬撕咬的致命一击几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的副手武器造成的伤害提高$s2%，并使你的割伤、猛禽一击、猫鼬撕咬、切碎和摔绊的致命一击几率提高$s1%。' WHERE `entry` = 19160 AND `description_loc4` = '使你的猛禽一击和猫鼬撕咬的致命一击几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的敏捷提高$s1%。并使你的近战攻击强度提高，数值相当于你敏捷的$s2%。' WHERE `entry` = 19168 AND `description_loc4` = '使你的敏捷提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的敏捷提高$s1%。并使你的近战攻击强度提高，数值相当于你敏捷的$s2%。' WHERE `entry` = 19180 AND `description_loc4` = '使你的敏捷提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的敏捷提高$s1%。并使你的近战攻击强度提高，数值相当于你敏捷的$s2%。' WHERE `entry` = 19181 AND `description_loc4` = '使你的敏捷提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '恢复$s1点生命值和$s2法力值。' WHERE `entry` = 19199 AND `description_loc4` = '恢复$s1点生命值和法力值。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会制作魔暴龙皮手套。' WHERE `entry` = 19204 AND `description_loc4` = '教你学会制作魔暴龙护手。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会制作魔暴龙皮护腿。' WHERE `entry` = 19216 AND `description_loc4` = '教你学会制作魔暴龙护腿。';

UPDATE `locales_spell` SET `description_loc4` = '使你受到的远程攻击伤害减少$s1，躲闪几率提高$s2%，持续$d。此效果期间成功躲避近战攻击将恢复法力值，数值等于你的敏捷值。' WHERE `entry` = 19289 AND `description_loc4` = '使你受到的远程攻击伤害减少$s1，躲闪几率提高$s2%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '命中几率提高$s3%，双持时额外提高$s3%。并使你抵抗移动限制效果的几率提高$s1%。' WHERE `entry` = 19290 AND `description_loc4` = '使你的攻击命中敌人的几率提高$s3%，并使你抵抗移动限制效果的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你受到的远程攻击伤害减少$s1，躲闪几率提高$s2%，持续$d。此效果期间成功躲避近战攻击将恢复法力值，数值等于你的敏捷值。' WHERE `entry` = 19291 AND `description_loc4` = '使你受到的远程攻击伤害减少$s1，躲闪几率提高$s2%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '使你受到的远程攻击伤害减少$s1，躲闪几率提高$s2%，持续$d。此效果期间成功躲避近战攻击将恢复法力值，数值等于你的敏捷值。' WHERE `entry` = 19292 AND `description_loc4` = '使你受到的远程攻击伤害减少$s1，躲闪几率提高$s2%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '使你受到的远程攻击伤害减少$s1，躲闪几率提高$s2%，持续$d。此效果期间成功躲避近战攻击将恢复法力值，数值等于你的敏捷值。' WHERE `entry` = 19293 AND `description_loc4` = '使你受到的远程攻击伤害减少$s1，躲闪几率提高$s2%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '命中几率提高$s3%，双持时额外提高$s3%。并使你抵抗移动限制效果的几率提高$s1%。' WHERE `entry` = 19294 AND `description_loc4` = '使你的攻击命中敌人的几率提高$s3%，并使你抵抗移动限制效果的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的招架几率和攻击速度提高$s1%。' WHERE `entry` = 19295 AND `description_loc4` = '使你的招架几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的招架几率和攻击速度提高$s1%。' WHERE `entry` = 19297 AND `description_loc4` = '使你的招架几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '在招架敌人的攻击之后可以使用的技能，对敌人造成$s1点伤害，并使其无法移动，持续$d。反击无法被格挡、躲闪或招架。' WHERE `entry` = 19306 AND `description_loc4` = '在招架敌人的攻击之后可以使用的技能，对敌人造成$s1点伤害，并使其无法行动，持续$d。反击无法被格挡、躲闪或招架。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有攻击造成致命一击的几率提高$s1%，近战致命一击伤害加成提高$s2%。' WHERE `entry` = 19370 AND `description_loc4` = '使你的所有攻击造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有攻击造成致命一击的几率提高$s1%，近战致命一击伤害加成提高$s2%。' WHERE `entry` = 19371 AND `description_loc4` = '使你的所有攻击造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有攻击造成致命一击的几率提高$s1%，近战致命一击伤害加成提高$s2%。' WHERE `entry` = 19373 AND `description_loc4` = '使你的所有攻击造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '冰霜陷阱效果的持续时间和火焰陷阱效果的伤害增加$s2%，并使敌人抵抗你的陷阱效果的几率降低$s1%。' WHERE `entry` = 19376 AND `description_loc4` = '使敌人抵抗你的陷阱效果的几率降低$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '冰霜陷阱效果的持续时间和火焰陷阱效果的伤害增加$s2%，并使敌人抵抗你的陷阱效果的几率降低$s1%。' WHERE `entry` = 19377 AND `description_loc4` = '使敌人抵抗你的陷阱效果的几率降低$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '奥术射击的冷却时间减少$/1000;S1秒，瞄准射击的冷却时间减少$/1000;S2秒。' WHERE `entry` = 19454 AND `description_loc4` = '使你的奥术射击的冷却时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '奥术射击的冷却时间减少$/1000;S1秒，瞄准射击的冷却时间减少$/1000;S2秒。' WHERE `entry` = 19455 AND `description_loc4` = '使你的奥术射击的冷却时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '奥术射击的冷却时间减少$/1000;S1秒，瞄准射击的冷却时间减少$/1000;S2秒。' WHERE `entry` = 19456 AND `description_loc4` = '使你的奥术射击的冷却时间减少$/1000;S1秒。';

UPDATE `locales_spell` SET `description_loc4` = '多重射击和乱射的伤害提高$s1%，乱射的施法时间减少$/1000;m3秒。' WHERE `entry` = 19461 AND `description_loc4` = '使你的多重射击和乱射法术的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '多重射击和乱射的伤害提高$s1%，乱射的施法时间减少$/1000;m3秒。' WHERE `entry` = 19462 AND `description_loc4` = '使你的多重射击和乱射法术的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '毒蛇钉刺所造成的伤害提高$s1%，蝰蛇钉刺抽取法力值的效果提高$s2%，毒蝎钉刺额外降低目标攻击速度$s3%。' WHERE `entry` = 19464 AND `description_loc4` = '使你的毒蛇钉刺所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '毒蛇钉刺所造成的伤害提高$s1%，蝰蛇钉刺抽取法力值的效果提高$s2%，毒蝎钉刺额外降低目标攻击速度$s3%。' WHERE `entry` = 19465 AND `description_loc4` = '使你的毒蛇钉刺所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '毒蛇钉刺所造成的伤害提高$s1%，蝰蛇钉刺抽取法力值的效果提高$s2%，毒蝎钉刺额外降低目标攻击速度$s3%。' WHERE `entry` = 19466 AND `description_loc4` = '使你的毒蛇钉刺所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '毒蛇钉刺所造成的伤害提高$s1%，蝰蛇钉刺抽取法力值的效果提高$s2%，毒蝎钉刺额外降低目标攻击速度$s3%。' WHERE `entry` = 19467 AND `description_loc4` = '使你的毒蛇钉刺所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '毒蛇钉刺所造成的伤害提高$s1%，蝰蛇钉刺抽取法力值的效果提高$s2%，毒蝎钉刺额外降低目标攻击速度$s3%。' WHERE `entry` = 19468 AND `description_loc4` = '使你的毒蛇钉刺所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '恶魔的力量玷污地狱猎犬的血液，持续$d。当地狱猎犬进行攻击时，将会使目标的近战攻击强度降低$19479s1点，持续$19479d。腐坏之血的效果可以对单一目标叠加5次。' WHERE `entry` = 19478 AND `description_loc4` = '恶魔的力量玷污地狱猎犬的血液，如果它被近战攻击打中，则攻击者会损失$19479s1点近战攻击强度，持续$19479d。腐坏之血的效果可以对单一目标叠加5次。';

UPDATE `locales_spell` SET `description_loc4` = '毒蝎钉刺额外使敌人的攻击速度降低$s1%和造成伤害降低$s2%。' WHERE `entry` = 19491 AND `description_loc4` = '使目标的力量因毒蝎钉刺的效果而降低时，其耐力也随之降低。耐力的降低值相当于力量降低值的10%。';

UPDATE `locales_spell` SET `description_loc4` = '毒蝎钉刺额外使敌人的攻击速度降低$s1%和造成伤害降低$s2%。' WHERE `entry` = 19493 AND `description_loc4` = '使目标的力量因毒蝎钉刺的效果而降低时，其耐力也随之降低。耐力的降低值相当于力量降低值的20%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的灵猴守护提供$s1%的额外躲闪几率。当孤狼守护激活时，你近战伤害的$s2%作为治疗返还。' WHERE `entry` = 19549 AND `description_loc4` = '使你的灵猴守护提供$s1%的额外躲闪几率。';

UPDATE `locales_spell` SET `description_loc4` = '使你的灵猴守护提供$s1%的额外躲闪几率。当孤狼守护激活时，你近战伤害的$s2%作为治疗返还。' WHERE `entry` = 19550 AND `description_loc4` = '使你的灵猴守护提供$s1%的额外躲闪几率。';

UPDATE `locales_spell` SET `description_loc4` = '使你的灵猴守护提供$s1%的额外躲闪几率。当孤狼守护激活时，你近战伤害的$s2%作为治疗返还。' WHERE `entry` = 19551 AND `description_loc4` = '使你的灵猴守护提供$s1%的额外躲闪几率。';

UPDATE `locales_spell` SET `description_loc4` = '使你的猎豹守护和豹群守护的速度加成效果提高$s1%。并使你的宠物的移动速度提高$s2%。' WHERE `entry` = 19559 AND `description_loc4` = '使你的猎豹守护和豹群守护的速度加成效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的猎豹守护和豹群守护的速度加成效果提高$s1%。并使你的宠物的移动速度提高$s2%。' WHERE `entry` = 19560 AND `description_loc4` = '使你的猎豹守护和豹群守护的速度加成效果提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗宠物技能的效果提高$s2%，并且每一跳都有$s1%的几率驱散宠物身上的$24406s1个诅咒、疾病、魔法或中毒效果。' WHERE `entry` = 19572 AND `description_loc4` = '使你的治疗宠物技能有$s1%的几率每一跳驱散宠物身上的$24406s1个诅咒、疾病、魔法或中毒效果。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗宠物技能的效果提高$s2%，并且每一跳都有$s1%的几率驱散宠物身上的$24406s1个诅咒、疾病、魔法或中毒效果。' WHERE `entry` = 19573 AND `description_loc4` = '使你的治疗宠物法术有$s1%的几率每一跳驱散宠物身上的$24406s1个诅咒、疾病、魔法或中毒效果。';

UPDATE `locales_spell` SET `description_loc4` = '使宠物获得血之气息效果并进入疯狂状态，持续$d。在这种状态下，宠物不会有任何恐惧或怜悯，也无法停止下来，除非被杀死。' WHERE `entry` = 19574 AND `description_loc4` = '使宠物进入疯狂状态，对目标造成的伤害提高$s2%，持续$d。在这种状态下，宠物不会有任何恐惧或怜悯，也无法停止下来，除非被杀死。';

UPDATE `locales_spell` SET `description_loc4` = '命令你的宠物在下次击中敌人时进行胁迫，使目标昏迷$24394d。并使宠物的威胁值产生速度提高$51556s1%，持续$51556d。' WHERE `entry` = 19577 AND `description_loc4` = '命令你的宠物在下次击中敌人时进行胁迫，造成大量的威胁值，并使目标昏迷$24394d。';

UPDATE `locales_spell` SET `description_loc4` = '你的宠物获得相当于你远程攻击强度$s2%的近战攻击强度，相当于你远程攻击强度$s3%的法术伤害和治疗效果。当你的宠物被激活后，你和你的宠物都会每$19579t1秒回复$19579s1%的生命值。' WHERE `entry` = 19578 AND `description_loc4` = '当你的宠物被激活后，你和你的宠物都会每$19579t1秒回复$19579s1%的生命值。';

UPDATE `locales_spell` SET `description_loc4` = '你的宠物继承你的角色耐力的$s2%，并使你的宠物的生命值提高$s1%。' WHERE `entry` = 19583 AND `description_loc4` = '使你的宠物的生命值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的宠物继承你的角色耐力的$s2%，并使你的宠物的生命值提高$s1%。' WHERE `entry` = 19584 AND `description_loc4` = '使你的宠物的生命值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的宠物继承你的角色耐力的$s2%，并使你的宠物的生命值提高$s1%。' WHERE `entry` = 19585 AND `description_loc4` = '使你的宠物的生命值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的宠物继承你的角色耐力的$s2%，并使你的宠物的生命值提高$s1%。' WHERE `entry` = 19586 AND `description_loc4` = '使你的宠物的生命值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的宠物继承你的角色耐力的$s2%，并使你的宠物的生命值提高$s1%。' WHERE `entry` = 19587 AND `description_loc4` = '使你的宠物的生命值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的宠物的集中值回复速度每一跳增加2点，宠物特殊技能的冷却时间减少$s2%。' WHERE `entry` = 19590 AND `description_loc4` = '使你的宠物的集中值回复速度提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的宠物的集中值回复速度每一跳增加5点，宠物特殊技能的冷却时间减少$s2%。' WHERE `entry` = 19592 AND `description_loc4` = '使你的宠物的集中值回复速度提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的宠物在户外的移动速度提高$s1%，攻击速度提高$s3%。并使你的猎豹守护和豹群守护的移动速度加成提高$s2%。' WHERE `entry` = 19596 AND `description_loc4` = '使你的宠物在户外的移动速度提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的宠物继承你$s2%的护甲值，并使你的宠物的护甲值提高$s1%。' WHERE `entry` = 19609 AND `description_loc4` = '使你的宠物的护甲值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的宠物继承你$s2%的护甲值，并使你的宠物的护甲值提高$s1%。' WHERE `entry` = 19610 AND `description_loc4` = '使你的宠物的护甲值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的宠物继承你$s2%的护甲值，并使你的宠物的护甲值提高$s1%。' WHERE `entry` = 19612 AND `description_loc4` = '使你的宠物的护甲值提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '在$d内对施法者面前一个锥形区域内的敌人造成$o1点火焰伤害，并使它们昏迷。' WHERE `entry` = 19641 AND `description_loc4` = '在$d内对施法者面前一个锥形区域内的敌人造成$o2点火焰伤害，并使它们昏迷。';

UPDATE `locales_spell` SET `description_loc4` = '恶魔的力量玷污地狱猎犬的血液，持续$d。当地狱猎犬进行攻击时，将会使目标的近战攻击强度降低$19652s1点，持续$19652d。腐坏之血的效果可以对单一目标叠加5次。' WHERE `entry` = 19655 AND `description_loc4` = '恶魔的力量玷污地狱猎犬的血液，如果它被近战攻击打中，则攻击者会损失$19652s1点近战攻击强度，持续$19652d。腐坏之血的效果可以对单一目标叠加5次。';

UPDATE `locales_spell` SET `description_loc4` = '恶魔的力量玷污地狱猎犬的血液，持续$d。当地狱猎犬进行攻击时，将会使目标的近战攻击强度降低$19653s1点，持续$19653d。腐坏之血的效果可以对单一目标叠加5次。' WHERE `entry` = 19656 AND `description_loc4` = '恶魔的力量玷污地狱猎犬的血液，如果它被近战攻击打中，则攻击者会损失$19653s1点近战攻击强度，持续$19653d。腐坏之血的效果可以对单一目标叠加5次。';

UPDATE `locales_spell` SET `description_loc4` = '恶魔的力量玷污地狱猎犬的血液，持续$d。当地狱猎犬进行攻击时，将会使目标的近战攻击强度降低$19654s1点，持续$19654d。腐坏之血的效果可以对单一目标叠加5次。' WHERE `entry` = 19660 AND `description_loc4` = '恶魔的力量玷污地狱猎犬的血液，如果它被近战攻击打中，则攻击者会损失$19654s1点近战攻击强度，持续$19654d。腐坏之血的效果可以对单一目标叠加5次。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1护甲。' WHERE `entry` = 19787 AND `description_loc4` = '+$S1 护甲。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其获得附加$13897s1点火焰伤害的效果。' WHERE `entry` = 19927 AND `description_loc4` = '永久性地为一把近战武器附魔，使它获得附加$13897s1点火焰伤害的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得生命值+50的效果。' WHERE `entry` = 19929 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得生命值+50的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得法力值+65的效果。' WHERE `entry` = 19930 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得法力值+65的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双靴子附魔，使其获得耐力+5的效果。' WHERE `entry` = 19931 AND `description_loc4` = '永久性地为一双靴子附魔，使它们获得耐力+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得耐力+7的效果。' WHERE `entry` = 19933 AND `description_loc4` = '永久性地为一副护腕附魔，使它们获得耐力+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得精神+7的效果。' WHERE `entry` = 19935 AND `description_loc4` = '永久性地为一副护腕附魔，使它们获得精神+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把双手近战武器附魔，使其获得伤害+7的效果。' WHERE `entry` = 19936 AND `description_loc4` = '永久性地为一把双手近战武器附魔，使它获得伤害+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '为友方目标施加祝福，使圣光术为其恢复的生命值提高$s1点，圣光闪现为其恢复的生命值提高$s2点，神圣震击为其恢复的生命值提高$s3点，持续$d。每个圣骑士在同一时间内只能给目标施加一种祝福。' WHERE `entry` = 19977 AND `description_loc4` = '为友方目标施加祝福，使圣光术为其恢复的生命值提高$s1点，圣光闪现为其恢复的生命值提高$s2点，持续$d。每个圣骑士在同一时间内只能给目标施加一种祝福，同类型的祝福不能重叠。';

UPDATE `locales_spell` SET `description_loc4` = '为友方目标施加祝福，使圣光术为其恢复的生命值提高$s1点，圣光闪现为其恢复的生命值提高$s2点，神圣震击为其恢复的生命值提高$s3点，持续$d。每个圣骑士在同一时间内只能给目标施加一种祝福。' WHERE `entry` = 19978 AND `description_loc4` = '为友方目标施加祝福，使圣光术为其恢复的生命值提高$s1点，圣光闪现为其恢复的生命值提高$s2点，持续$d。每个圣骑士在同一时间内只能给目标施加一种祝福，同类型的祝福不能重叠。';

UPDATE `locales_spell` SET `description_loc4` = '为友方目标施加祝福，使圣光术为其恢复的生命值提高$s1点，圣光闪现为其恢复的生命值提高$s2点，神圣震击为其恢复的生命值提高$s3点，持续$d。每个圣骑士在同一时间内只能给目标施加一种祝福。' WHERE `entry` = 19979 AND `description_loc4` = '为友方目标施加祝福，使圣光术为其恢复的生命值提高$s1点，圣光闪现为其恢复的生命值提高$s2点，持续$d。每个圣骑士在同一时间内只能给目标施加一种祝福，同类型的祝福不能重叠。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得智力+7的效果。' WHERE `entry` = 20008 AND `description_loc4` = '永久性地为一副护腕附魔，使它们获得智力+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得精神+9的效果。' WHERE `entry` = 20009 AND `description_loc4` = '永久性地为一副护腕附魔，使它们获得精神+9的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得力量+9的效果。' WHERE `entry` = 20010 AND `description_loc4` = '永久性地为一副护腕附魔，使它们获得力量+9的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得耐力+9的效果。' WHERE `entry` = 20011 AND `description_loc4` = '永久性地为一副护腕附魔，使它们获得耐力+9的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得敏捷+7的效果。' WHERE `entry` = 20012 AND `description_loc4` = '永久性地为一双手套附魔， 使它们获得敏捷+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得力量+7的效果。' WHERE `entry` = 20013 AND `description_loc4` = '永久性地为一双手套附魔， 使它们获得力量+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得所有魔法抗性+5的效果。' WHERE `entry` = 20014 AND `description_loc4` = '永久性地为一件披风附魔，使它获得所有魔法抗性+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得护甲+70的效果。' WHERE `entry` = 20015 AND `description_loc4` = '永久性地为一件披风附魔，使它获得护甲+70的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一面盾牌附魔，使其获得精神+9的效果。' WHERE `entry` = 20016 AND `description_loc4` = '永久性地为一面盾牌附魔，使它获得精神+9的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一面盾牌附魔，使其获得耐力+7的效果。' WHERE `entry` = 20017 AND `description_loc4` = '永久性地为一面盾牌附魔，使它获得耐力+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双靴子附魔，使其获得耐力+7的效果。' WHERE `entry` = 20020 AND `description_loc4` = '永久性地为一双靴子附魔，使它们获得耐力+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双靴子附魔，使其获得敏捷+7的效果。' WHERE `entry` = 20023 AND `description_loc4` = '永久性地为一双靴子附魔，使它们获得敏捷+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双靴子附魔，使其获得精神+5的效果。' WHERE `entry` = 20024 AND `description_loc4` = '永久性地为一双靴子附魔，使它们获得精神+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得所有属性+4的效果。' WHERE `entry` = 20025 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得所有属性+4的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得生命值+100的效果。' WHERE `entry` = 20026 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得生命值+100的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件胸甲附魔，使其获得法力值+100的效果。' WHERE `entry` = 20028 AND `description_loc4` = '永久性地为一件胸甲附魔，使它获得法力值+100的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其能释放冰寒，使目标的移动和攻击速度减慢。' WHERE `entry` = 20029 AND `description_loc4` = '永久性地为一把近战武器附魔，使它能释放冰寒，使目标的移动和攻击速度减慢。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把双手近战武器附魔，使其获得伤害+9的效果。' WHERE `entry` = 20030 AND `description_loc4` = '永久性地为一把双手近战武器附魔，使它获得伤害+9的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其获得伤害+5的效果。' WHERE `entry` = 20031 AND `description_loc4` = '永久性地为一把近战武器附魔，使它获得伤害+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其可从敌人那儿偷取生命值。' WHERE `entry` = 20032 AND `description_loc4` = '永久性地为一把近战武器附魔，使它可从敌人那儿偷取生命值。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其可诅咒目标，减少目标的近战伤害。' WHERE `entry` = 20033 AND `description_loc4` = '永久性地为一把近战武器附魔，使它可诅咒目标，减少目标的近战伤害。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其获得在攻击时经常性地为你回复$20007s2点生命值，并使你的力量提高$20007s1点，持续$20007d。' WHERE `entry` = 20034 AND `description_loc4` = '永久性地为一把近战武器附魔，使它获得在攻击时经常性地为你回复$20007s2点生命值，并使你的力量提高$20007s1点，持续$20007d。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把双手近战武器附魔，使其获得精神+9的效果。' WHERE `entry` = 20035 AND `description_loc4` = '永久性地为一把双手近战武器附魔，使它获得精神+9的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把双手近战武器附魔，使其获得智力+9的效果。' WHERE `entry` = 20036 AND `description_loc4` = '永久性地为一把双手近战武器附魔，使它获得智力+9的效果。';

UPDATE `locales_spell` SET `description_loc4` = '使你的力量祝福和智慧祝福的效果提高$s1%。' WHERE `entry` = 20042 AND `description_loc4` = '使你的力量祝福所提供的近战攻击强度加成提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的力量祝福和智慧祝福的效果提高$s1%。' WHERE `entry` = 20045 AND `description_loc4` = '使你的力量祝福所提供的近战攻击强度加成提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的力量祝福和智慧祝福的效果提高$s1%。' WHERE `entry` = 20046 AND `description_loc4` = '使你的力量祝福所提供的近战攻击强度加成提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的力量祝福和智慧祝福的效果提高$s1%。' WHERE `entry` = 20047 AND `description_loc4` = '使你的力量祝福所提供的近战攻击强度加成提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的力量祝福和智慧祝福的效果提高$s1%。' WHERE `entry` = 20048 AND `description_loc4` = '使你的力量祝福所提供的近战攻击强度加成提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '当你的武器攻击、法术或技能在对敌人造成致命一击之后，能使你获得$20050s1%的伤害加成，并使你产生的威胁值减少$20050s2%，持续$20050d。此效果最多可叠加3次。正义之怒激活时，威胁值降低效果无效。' WHERE `entry` = 20049 AND `description_loc4` = '使你的武器攻击、法术或技能在对敌人造成致命一击之后有$20050s1%的物理和神圣伤害加成，持续$20050d。';

UPDATE `locales_spell` SET `description_loc4` = '当你的武器攻击、法术或技能在对敌人造成致命一击之后，能使你获得$20052s1%的伤害加成，并使你产生的威胁值减少$20052s2%，持续$20052d。此效果最多可叠加3次。正义之怒激活时，威胁值降低效果无效。' WHERE `entry` = 20056 AND `description_loc4` = '使你的武器攻击、法术或技能在对敌人造成致命一击之后有$20052s1%的物理和神圣伤害加成，持续$20052d。';

UPDATE `locales_spell` SET `description_loc4` = '当你的武器攻击、法术或技能在对敌人造成致命一击之后，能使你获得$20053s1%的伤害加成，并使你产生的威胁值减少$20053s2%，持续$20053d。此效果最多可叠加3次。正义之怒激活时，威胁值降低效果无效。' WHERE `entry` = 20057 AND `description_loc4` = '使你的武器攻击、法术或技能在对敌人造成致命一击之后有$20053s1%的物理和神圣伤害加成，持续$20053d。';

UPDATE `locales_spell` SET `description_loc4` = '当你的武器攻击、法术或技能在对敌人造成致命一击之后，能使你获得$20054s1%的伤害加成，并使你产生的威胁值减少$20054s2%，持续$20054d。此效果最多可叠加3次。正义之怒激活时，威胁值降低效果无效。' WHERE `entry` = 20058 AND `description_loc4` = '使你的武器攻击、法术或技能在对敌人造成致命一击之后有$20054s1%的物理和神圣伤害加成，持续$20054d。';

UPDATE `locales_spell` SET `description_loc4` = '当你的武器攻击、法术或技能在对敌人造成致命一击之后，能使你获得$20055s1%的伤害加成，并使你产生的威胁值减少$20055s2%，持续$20055d。此效果最多可叠加3次。正义之怒激活时，威胁值降低效果无效。' WHERE `entry` = 20059 AND `description_loc4` = '使你的武器攻击、法术或技能在对敌人造成致命一击之后有$20055s1%的物理和神圣伤害加成，持续$20055d。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一副护腕永久性地附魔，使其获得+7智力的效果。' WHERE `entry` = 20065 AND `description_loc4` = '教你学会给一只护腕永久性地附魔，使它获得+7智力的效果。';

UPDATE `locales_spell` SET `description_loc4` = '使目标进入冥想状态，最多持续$d。任何伤害都会唤醒目标。当效果被免疫时，目标会忏悔自己的罪孽，每次近战攻击时都会受到$51361s1点神圣伤害，持续$51360d。' WHERE `entry` = 20066 AND `description_loc4` = '使目标进入冥想状态，最多持续$d。任何伤害都会唤醒目标。只对人型生物有效。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双靴子永久性地附魔，使其获得+7耐力的效果。' WHERE `entry` = 20067 AND `description_loc4` = '教你学会给一双靴子永久性地附魔，使它获得+7耐力的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件披风永久性地附魔，使其获得+5所有抗性的效果。' WHERE `entry` = 20068 AND `description_loc4` = '教你学会给一件披风永久性地附魔，使它获得所有抗性+5的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一面盾牌永久性地附魔，使其获得+7耐力的效果。' WHERE `entry` = 20069 AND `description_loc4` = '教你学会给一面盾牌永久性地附魔，使它获得+7耐力的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一副护腕永久性地附魔，使其获得+9精神的效果。' WHERE `entry` = 20070 AND `description_loc4` = '教你学会给一只护腕永久性地附魔，使它获得+9精神的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双手套永久性地附魔，使其获得+7敏捷的效果。' WHERE `entry` = 20071 AND `description_loc4` = '教你学会给一双手套永久性地附魔，使它获得+7敏捷的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双靴子永久性地附魔，使其获得+5精神的效果。' WHERE `entry` = 20072 AND `description_loc4` = '教你学会给一双靴子永久性地附魔，使它获得+5精神的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件胸甲永久性地附魔，使其获得+100生命值的效果。' WHERE `entry` = 20073 AND `description_loc4` = '教你学会给一件胸甲永久性地附魔，使它获得+100生命值的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一面盾牌永久性地附魔，使其获得+9精神的效果。' WHERE `entry` = 20074 AND `description_loc4` = '教你学会给一面盾牌永久性地附魔，使它获得+9精神的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件近战武器永久性地附魔，使其有一定几率释放冰寒效果，令目标减速。' WHERE `entry` = 20075 AND `description_loc4` = '教你学会给一件武器永久性地附魔，使它有一定几率释放冰寒效果，令目标减速。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件披风永久性地附魔，使其获得+70护甲的效果。' WHERE `entry` = 20076 AND `description_loc4` = '教你学会给一件披风永久性地附魔，使它获得70点的额外护甲。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件胸甲永久性地附魔，使其获得+100法力值的效果。' WHERE `entry` = 20077 AND `description_loc4` = '教你学会给一件胸甲永久性地附魔，使它获得+100法力值的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双手套永久性地附魔，使其获得+7力量的效果。' WHERE `entry` = 20079 AND `description_loc4` = '教你学会给一双手套永久性地附魔，使它获得+7力量的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双靴子永久性地附魔，使其获得+7敏捷的效果。' WHERE `entry` = 20080 AND `description_loc4` = '教你学会给一双靴子永久性地附魔，使它获得+7敏捷的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一副护腕永久性地附魔，使其获得+9力量的效果。' WHERE `entry` = 20081 AND `description_loc4` = '教你学会给一只护腕永久性地附魔，使它获得+9力量的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件双手武器永久性地附魔，使其获得伤害+9的效果。' WHERE `entry` = 20082 AND `description_loc4` = '教你学会给一件双手武器永久性地附魔，使它可以造成9点的额外伤害。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件近战武器永久性地附魔，使其有时可诅咒被攻击的对手。' WHERE `entry` = 20083 AND `description_loc4` = '教你学会给一件武器永久性地附魔，使它有时可诅咒被攻击的对手。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件双手武器永久性地附魔，使其获得+9智力的效果。' WHERE `entry` = 20084 AND `description_loc4` = '教你学会给一件双手武器永久性地附魔，使它获得+9智力的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件近战武器永久性地附魔，使其可以造成5点的额外伤害。' WHERE `entry` = 20085 AND `description_loc4` = '教你学会给一件武器永久性地附魔，使它可以造成5点的额外伤害。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一副护腕永久性地附魔，使其获得+9耐力的效果。' WHERE `entry` = 20086 AND `description_loc4` = '教你学会给一只护腕永久性地附魔，使它获得+9耐力的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件近战武器永久性地附魔，使其有时可赋予施法者强大的力量。' WHERE `entry` = 20087 AND `description_loc4` = '教你学会给一件武器永久性地附魔，使它有时可赋予施法者强大的力量。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件胸甲永久性地附魔，使其获得五种属性均+4的效果。' WHERE `entry` = 20088 AND `description_loc4` = '教你学会给一件胸甲永久性地附魔，使它获得五种属性均+4的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件近战武器永久性地附魔，使其有时可偷取对手的生命值给施法者。' WHERE `entry` = 20089 AND `description_loc4` = '教你学会给一件武器永久性地附魔，使它有时可偷取对手的生命值给施法者。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件双手武器永久性地附魔，使其获得+9精神的效果。' WHERE `entry` = 20090 AND `description_loc4` = '教你学会给一件双手武器永久性地附魔，使它获得+9精神的效果。';

UPDATE `locales_spell` SET `description_loc4` = '使你的自由之手的效果持续时间延长$/1000;s1秒。' WHERE `entry` = 20106 AND `description_loc4` = '使你的自由祝福的效果持续时间延长$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的自由之手的效果持续时间延长$/1000;s1秒。' WHERE `entry` = 20107 AND `description_loc4` = '使你的自由祝福的效果持续时间延长$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的自由之手的效果持续时间延长$/1000;s1秒。' WHERE `entry` = 20108 AND `description_loc4` = '使你的自由祝福的效果持续时间延长$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的自由之手的效果持续时间延长$/1000;s1秒。' WHERE `entry` = 20109 AND `description_loc4` = '使你的自由祝福的效果持续时间延长$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的自由之手的效果持续时间延长$/1000;s1秒。' WHERE `entry` = 20110 AND `description_loc4` = '使你的自由祝福的效果持续时间延长$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的双手近战武器造成的伤害提高$s1%，并使你的双手剑、双手锤和双手斧的武器技能增加$51347s1。' WHERE `entry` = 20111 AND `description_loc4` = '使你的双手近战武器造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的双手近战武器造成的伤害提高$s1%，并使你的双手剑、双手锤和双手斧的武器技能增加$51348s1。' WHERE `entry` = 20112 AND `description_loc4` = '使你的双手近战武器造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的双手近战武器造成的伤害提高$s1%，并使你的双手剑、双手锤和双手斧的武器技能增加$51349s1。' WHERE `entry` = 20113 AND `description_loc4` = '使你的双手近战武器造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '将圣洁的能量灌入圣骑士脚下的土地，在$d内对进入该区域的所有敌人造成$o1点神圣伤害。圣洁能量随着时间推移逐渐减弱，造成的伤害也会逐渐降低。' WHERE `entry` = 20116 AND `description_loc4` = '将圣洁的能量灌入圣骑士脚下的土地，在$d内对进入该区域的所有敌人造成$o1点神圣伤害。';

UPDATE `locales_spell` SET `description_loc4` = '神圣的灵魂充满圣骑士的体内，持续$d，令其每次近战攻击都能对目标造成$/87;s1到$/25;s1点额外的神圣伤害。攻击速度越慢的武器每击造成的伤害越高。圣骑士在同一时间内只能激活一种圣印。' WHERE `entry` = 20154 AND `description_loc4` = '神圣的灵魂充满圣骑士的体内，持续$d，令其近战攻击有一定几率造成$/87;s1到$/25;s1点额外的神圣伤害。攻击速度越慢的武器每击造成的伤害越高。圣骑士在同一时间内只能激活一种圣印。';

UPDATE `locales_spell` SET `description_loc4` = '使你的保护之手的冷却时间减少$/1000;s1秒，自由之手的效果持续时间延长$/1000;s2秒。' WHERE `entry` = 20174 AND `description_loc4` = '使你的保护祝福的冷却时间减少$/1000;s1秒，自由祝福的效果持续时间延长$/1000;s2秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的保护之手的冷却时间减少$/1000;s1秒，自由之手的效果持续时间延长$/1000;s2秒。' WHERE `entry` = 20175 AND `description_loc4` = '使你的保护祝福的冷却时间减少$/1000;s1秒，自由祝福的效果持续时间延长$/1000;s2秒。';

UPDATE `locales_spell` SET `description_loc4` = '使你的近战武器和技能击中目标的几率提高$s1%。' WHERE `entry` = 20189 AND `description_loc4` = '使你的近战武器击中目标的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的近战武器和技能击中目标的几率提高$s1%。' WHERE `entry` = 20192 AND `description_loc4` = '使你的近战武器击中目标的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的近战武器和技能击中目标的几率提高$s1%。' WHERE `entry` = 20193 AND `description_loc4` = '使你的近战武器击中目标的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '以神圣的能量冲击目标，造成$25912s1点神圣伤害，或为盟友恢复$25914s1点生命值。施放神圣震击有一定几率重置其冷却时间。' WHERE `entry` = 20473 AND `description_loc4` = '以神圣的能量冲击目标，造成$25912s1点神圣伤害，或为盟友恢复$25914s1点生命值。';

UPDATE `locales_spell` SET `description_loc4` = '使用狂暴之怒之后立即获得$/10;23690s1点怒气值，并在激活时有$s2%的几率解除自身的移动限制效果。' WHERE `entry` = 20500 AND `description_loc4` = '在使用狂暴之怒技能之后获得$/10;23690s1点怒气值。';

UPDATE `locales_spell` SET `description_loc4` = '使用狂暴之怒之后立即获得$/10;23691s1点怒气值，并在激活时有$s2%的几率解除自身的移动限制效果。' WHERE `entry` = 20501 AND `description_loc4` = '在使用狂暴之怒技能之后获得$/10;23691s1点怒气值。';

UPDATE `locales_spell` SET `description_loc4` = '斩杀的怒气值消耗降低$/10;s1点。' WHERE `entry` = 20502 AND `description_loc4` = '使你的斩杀技能的怒气值消耗减少$/10;s1点。';

UPDATE `locales_spell` SET `description_loc4` = '斩杀的怒气值消耗降低$/10;s1点。' WHERE `entry` = 20503 AND `description_loc4` = '使你的斩杀技能的怒气值消耗减少$/10;s1点。';

UPDATE `locales_spell` SET `description_loc4` = '拦截和援护的冷却时间减少$/1000;s1秒，冲锋的冷却时间减少$/1000;s2秒。' WHERE `entry` = 20504 AND `description_loc4` = '使你的拦截技能的冷却时间减少$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '拦截和援护的冷却时间减少$/1000;s1秒，冲锋的冷却时间减少$/1000;s2秒。' WHERE `entry` = 20505 AND `description_loc4` = '使你的拦截技能的冷却时间减少$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '横扫攻击，对目标和它身边最近的一个敌人造成近战伤害再加上$s1点伤害。' WHERE `entry` = 20569 AND `description_loc4` = '横扫攻击，对目标和它身边最近的一个敌人造成武器伤害再加上$s1点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '攻击强度提高$*2;s1点，法术伤害提高$s1点，持续$23234d，对你施放的治疗效果降低$23230s1%，持续$23230d。' WHERE `entry` = 20572 AND `description_loc4` = '激活之后使基础近战强度提高$s1%，持续$23234d，对你施放的治疗效果降低$23230s1%，持续$23230d。';

UPDATE `locales_spell` SET `description_loc4` = '受到昏迷效果的持续时间减少$s1%。' WHERE `entry` = 20573 AND `description_loc4` = '抵抗昏迷效果的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '单手斧和双手斧技能提高$s1点。' WHERE `entry` = 20574 AND `description_loc4` = '斧和双手斧技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '激活后潜入阴影中，降低敌人侦测到你的几率，持续到取消或移动为止，并在进行任何操作后的$20581d内继续保持有效。具有影遁的暗夜精灵潜行者和德鲁伊在潜行时更难被发现。' WHERE `entry` = 20580 AND `description_loc4` = '激活后潜入阴影中，降低敌人侦测到你的几率。一直持续到主动取消或进行移动。影遁可以和暗夜精灵盗贼或德鲁伊的潜行技能叠加，令其更难以侦测。';

UPDATE `locales_spell` SET `description_loc4` = '你的攻击速度、施法速度、移动速度和躲闪几率提高$s1%' WHERE `entry` = 20582 AND `description_loc4` = '躲闪几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '激活之后对流血、毒药和疾病效果免疫，并使你受到物理伤害降低$s1%，持续$d。' WHERE `entry` = 20594 AND `description_loc4` = '激活之后对流血、毒药和疾病效果免疫，护甲值提高$s1%。持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '精神提高$s1%，并使你在施法时保持5%的法力恢复速度。' WHERE `entry` = 20598 AND `description_loc4` = '精神提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '提高潜行侦测能力，并使物理和法术致命一击几率提高$s2%，持续$d。' WHERE `entry` = 20600 AND `description_loc4` = '提高潜行侦测能力，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '精神提高$s2%。在死亡时，牧师变成一个救赎之魂，持续$27827d。救赎之魂无法移动、攻击，也不会受到任何法术或效果的影响。在这个形态下，牧师可以施放任何治疗法术，不需消耗任何法力值。当救赎之魂效果结束时，牧师死亡。' WHERE `entry` = 20711 AND `description_loc4` = '在死亡时，牧师变成一个救赎之魂，持续$27827d。救赎之魂无法移动、攻击，也不会受到任何法术或效果的影响。在这个形态下，牧师可以施放任何治疗法术，不需消耗任何法力值。当救赎之魂效果结束时，牧师死亡。';

UPDATE `locales_spell` SET `description_loc4` = '为小队成员施加牺牲之手，每次该队友被击中时，圣骑士都将分担$s1点伤害，持续$d。每个圣骑士在同一时间内只能给目标施加一种圣手效果，同类型的圣手效果不能重叠。' WHERE `entry` = 20729 AND `description_loc4` = '为小队成员施加祝福，每次该队友被击中时，圣骑士都将分担$s1点伤害，持续$d。每个圣骑士在同一时间内只能给目标施加一种祝福，同类型的祝福不能重叠。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1攻击强度。' WHERE `entry` = 20732 AND `description_loc4` = '+$S1 攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '连续射出弹药，对最多$x1个目标造成普通伤害外加$s1点伤害。' WHERE `entry` = 20735 AND `description_loc4` = '连续射出弹药，对最多$x1个目标造成普通伤害外加$s1点奥术伤害。';

UPDATE `locales_spell` SET `description_loc4` = '在厄运之池中装水。' WHERE `entry` = 20814 AND `description_loc4` = '在恐怖之池中装水。';

UPDATE `locales_spell` SET `description_loc4` = '单手锤和双手锤技能提高$s1点。' WHERE `entry` = 20864 AND `description_loc4` = '锤和双手锤技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '开发者说明：效果1点=击中前每秒期望威胁值。' WHERE `entry` = 20866 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '开发者说明：效果1点=击中前每秒期望威胁值。' WHERE `entry` = 20871 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '奴役等级不高于$m1级的恶魔，强制它听从你的命令。在被奴役的状态下，恶魔的攻击间隔延长$s2%，施法速度降低$s3%，受到治疗效果降低$58184s1%。奴役效果最多持续$d。' WHERE `entry` = 20882 AND `description_loc4` = '奴役等级不高于$m1级的恶魔，强制它听从你的命令。在被奴役的状态下，恶魔的攻击间隔延长$s2%，施法速度降低$s3%。奴役效果最多持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '你的宠物获得相当于你远程攻击强度$s2%的近战攻击强度，相当于你远程攻击强度$s3%的法术伤害和治疗效果。当你的宠物被激活后，你和你的宠物都会每$24529t1秒回复$24529s1%的生命值。' WHERE `entry` = 20895 AND `description_loc4` = '当你的宠物被激活后，你和你的宠物都会每$24529t1秒回复$24529s1%的生命值。';

UPDATE `locales_spell` SET `description_loc4` = '在招架敌人的攻击之后可以使用的技能，对敌人造成$s1点伤害，并使其无法移动，持续$d。反击无法被格挡、躲闪或招架。' WHERE `entry` = 20909 AND `description_loc4` = '在招架敌人的攻击之后可以使用的技能，对敌人造成$s1点伤害，并使其无法行动，持续$d。反击无法被格挡、躲闪或招架。';

UPDATE `locales_spell` SET `description_loc4` = '在招架敌人的攻击之后可以使用的技能，对敌人造成$s1点伤害，并使其无法移动，持续$d。反击无法被格挡、躲闪或招架。' WHERE `entry` = 20910 AND `description_loc4` = '在招架敌人的攻击之后可以使用的技能，对敌人造成$s1点伤害，并使其无法行动，持续$d。反击无法被格挡、躲闪或招架。';

UPDATE `locales_spell` SET `description_loc4` = '将圣洁的能量灌入圣骑士脚下的土地，在$d内对进入该区域的所有敌人造成$o1点神圣伤害。圣洁能量随着时间推移逐渐减弱，造成的伤害也会逐渐降低。' WHERE `entry` = 20922 AND `description_loc4` = '将圣洁的能量灌入圣骑士脚下的土地，在$d内对进入该区域的所有敌人造成$o1点神圣伤害。';

UPDATE `locales_spell` SET `description_loc4` = '将圣洁的能量灌入圣骑士脚下的土地，在$d内对进入该区域的所有敌人造成$o1点神圣伤害。圣洁能量随着时间推移逐渐减弱，造成的伤害也会逐渐降低。' WHERE `entry` = 20923 AND `description_loc4` = '将圣洁的能量灌入圣骑士脚下的土地，在$d内对进入该区域的所有敌人造成$o1点神圣伤害。';

UPDATE `locales_spell` SET `description_loc4` = '将圣洁的能量灌入圣骑士脚下的土地，在$d内对进入该区域的所有敌人造成$o1点神圣伤害。圣洁能量随着时间推移逐渐减弱，造成的伤害也会逐渐降低。' WHERE `entry` = 20924 AND `description_loc4` = '将圣洁的能量灌入圣骑士脚下的土地，在$d内对进入该区域的所有敌人造成$o1点神圣伤害。';

UPDATE `locales_spell` SET `description_loc4` = '使你的格挡几率提高$s1%，持续$d。在此期间每次成功格挡都会对攻击者造成$s2点神圣伤害，这种伤害所造成的威胁值提高50%。每次成功格挡会消耗掉一次格挡机会，最多可格挡$n次。' WHERE `entry` = 20925 AND `description_loc4` = '使你的格挡几率提高$s1%，持续$d。在此期间每次成功格挡都会对攻击者造成$s2点神圣伤害，这种伤害所造成的威胁值提高20%。每次成功格挡会消耗掉一次格挡机会，最多可格挡$n次。';

UPDATE `locales_spell` SET `description_loc4` = '使你的格挡几率提高$s1%，持续$d。在此期间每次成功格挡都会对攻击者造成$s2点神圣伤害，这种伤害所造成的威胁值提高50%。每次成功格挡会消耗掉一次格挡机会，最多可格挡$n次。' WHERE `entry` = 20927 AND `description_loc4` = '使你的格挡几率提高$s1%，持续$d。在此期间每次成功格挡都会对攻击者造成$s2点神圣伤害，这种伤害所造成的威胁值提高20%。每次成功格挡会消耗掉一次格挡机会，最多可格挡$n次。';

UPDATE `locales_spell` SET `description_loc4` = '使你的格挡几率提高$s1%，持续$d。在此期间每次成功格挡都会对攻击者造成$s2点神圣伤害，这种伤害所造成的威胁值提高50%。每次成功格挡会消耗掉一次格挡机会，最多可格挡$n次。' WHERE `entry` = 20928 AND `description_loc4` = '使你的格挡几率提高$s1%，持续$d。在此期间每次成功格挡都会对攻击者造成$s2点神圣伤害，这种伤害所造成的威胁值提高20%。每次成功格挡会消耗掉一次格挡机会，最多可格挡$n次。';

UPDATE `locales_spell` SET `description_loc4` = '以神圣的能量冲击目标，造成$25911s1点神圣伤害，或为盟友恢复$25913s1点生命值。施放神圣震击有一定几率重置其冷却时间。' WHERE `entry` = 20929 AND `description_loc4` = '以神圣的能量冲击目标，造成$25911s1点神圣伤害，或为盟友恢复$25913s1点生命值。';

UPDATE `locales_spell` SET `description_loc4` = '以神圣的能量冲击目标，造成$25902s1点神圣伤害，或为盟友恢复$25903s1点生命值。施放神圣震击有一定几率重置其冷却时间。' WHERE `entry` = 20930 AND `description_loc4` = '以神圣的能量冲击目标，造成$25902s1点神圣伤害，或为盟友恢复$25903s1点生命值。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成$s1点伤害，并迫使它在$d内一直攻击你。' WHERE `entry` = 21008 AND `description_loc4` = '对目标造成$s1点额外伤害，并迫使它在$d内一直攻击你。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21013 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$s1%昏迷抗性。' WHERE `entry` = 21351 AND `description_loc4` = '+$s1% 昏迷抗性。';

UPDATE `locales_spell` SET `description_loc4` = '连续射出弹药，对最多$x1个目标造成普通伤害外加$s1点伤害。' WHERE `entry` = 21390 AND `description_loc4` = '连续射出弹药，对最多$x1个目标造成普通伤害外加$s1点奥术伤害。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21426 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21427 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21428 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21429 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21430 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21431 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21432 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21433 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21434 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21435 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21436 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21437 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21438 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21439 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21440 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21441 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21442 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21443 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21444 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21445 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21446 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21447 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21448 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21449 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21450 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21451 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21452 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21453 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21454 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21455 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21456 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21457 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21458 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21459 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21460 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21461 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '+$S1远程攻击强度。' WHERE `entry` = 21462 AND `description_loc4` = '+$S1 远程攻击强度。';

UPDATE `locales_spell` SET `description_loc4` = '一次邪恶的攻击，对目标造成$s2%的武器伤害，并使目标受伤，任何形式的治疗对其产生的效果降低$s1%，持续$d。' WHERE `entry` = 21551 AND `description_loc4` = '一次邪恶的攻击，对目标造成武器伤害外加$s2点伤害，并使任何形式的治疗对其产生的效果降低$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '一次邪恶的攻击，对目标造成$s2%的武器伤害，并使目标受伤，任何形式的治疗对其产生的效果降低$s1%，持续$d。' WHERE `entry` = 21552 AND `description_loc4` = '一次邪恶的攻击，对目标造成武器伤害外加$s2点伤害，并使任何形式的治疗对其产生的效果降低$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '一次邪恶的攻击，对目标造成$s2%的武器伤害，并使目标受伤，任何形式的治疗对其产生的效果降低$s1%，持续$d。' WHERE `entry` = 21553 AND `description_loc4` = '一次邪恶的攻击，对目标造成武器伤害外加$s2点伤害，并使任何形式的治疗对其产生的效果降低$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '在你的普通近战攻击打出致命一击之后，有$h%的几率造成$21889s1点额外的神圣伤害。' WHERE `entry` = 21882 AND `description_loc4` = '在你打出致命一击之后，有$h%的几率造成$21889s1点额外的神圣伤害。';

UPDATE `locales_spell` SET `description_loc4` = '你的图腾影响友方单位的半径增加$s1码。' WHERE `entry` = 21895 AND `description_loc4` = '你的图腾影响友方单位的半径增加到30码。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把武器附魔，使其获得令冰霜法术造成的伤害+7的效果。' WHERE `entry` = 21931 AND `description_loc4` = '永久性地为一把武器附魔，使它获得令冰霜法术造成的伤害+7的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件近战武器永久性地附魔，使你的冰霜法术所造成的冰霜伤害提高最多7点。' WHERE `entry` = 21933 AND `description_loc4` = '教你学会给一件武器永久性地附魔，使你的冰霜法术所造成的冰霜伤害提高最多7点。';

UPDATE `locales_spell` SET `description_loc4` = '你的荆棘术保护的目标受到攻击时有3%的几率对附近所有敌人造成15-20点自然伤害。' WHERE `entry` = 21972 AND `description_loc4` = '使你的荆棘术的持续时间延长$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '你的有害法术命中时，有一定几率对目标造成$27860s1点暗影伤害，并为你回复$27860s2点法力值。' WHERE `entry` = 21978 AND `description_loc4` = '有一定几率在伤害性法术命中敌人时对其造成$27860s1点暗影伤害，并为你回复$27860s2点法力值。';

UPDATE `locales_spell` SET `description_loc4` = '治疗目标，每$t1秒回复$s1点生命值，持续$d。' WHERE `entry` = 22168 AND `description_loc4` = '治疗目标，在$d内恢复总计$o1点生命值。';

UPDATE `locales_spell` SET `description_loc4` = '检测到5个以上敌人时，对自己施放这个法术。在敌人身上触发效果并立即取消。仅在允许的生物和地区使用。' WHERE `entry` = 22573 AND `description_loc4` = 'Causes a creature to cast this dummy spell on themself when they detect more than 5 enemeis. Add as a spell reaction on a mob\\\'s creature level action trigger and use a despawn action. Only use on approved mobs/zones.';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其获得法术伤害+30的效果。' WHERE `entry` = 22749 AND `description_loc4` = '永久性地为一把近战武器附魔，使它获得法术伤害提高最多30点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一把近战武器附魔，使其获得治疗能力+55的效果。' WHERE `entry` = 22750 AND `description_loc4` = '永久性地为一把近战武器附魔，使它获得治疗法术所恢复的生命值提高最多55点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件武器永久性地附魔，使其获得+30法术伤害的效果。' WHERE `entry` = 22753 AND `description_loc4` = '教你学会给一件武器永久性地附魔，使你的法术所造成的伤害提高最多30点。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件武器永久性地附魔，使其获得+55治疗能力的效果。' WHERE `entry` = 22754 AND `description_loc4` = '教你学会给一件武器永久性地附魔，使它可以达到使治疗法术所恢复的生命值最多提高55点。';

UPDATE `locales_spell` SET `description_loc4` = '在弓或枪械上加装永久性的瞄准镜，使其远程命中率提高3%。' WHERE `entry` = 22779 AND `description_loc4` = '在弓或枪械上加装永久性的瞄准镜，使其命中率提高3%。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使攻击和施法速度提高1%。无法与其它同位置的附魔共存。' WHERE `entry` = 22840 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使攻击速度提高1%。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '每秒将最多10点怒气转化为生命值，每点怒气转化的生命值相当于你的总耐力的$s1%。' WHERE `entry` = 22842 AND `description_loc4` = '每秒将最多10点怒气值转化为生命值，持续$d。每点怒气值可以转化为$s1点生命值。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使躲闪几率提高1%。无法与其它同位置的附魔共存。' WHERE `entry` = 22846 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使躲闪几率提高1%。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '每秒将最多10点怒气转化为生命值，每点怒气转化的生命值相当于你的总耐力的$s1%。' WHERE `entry` = 22895 AND `description_loc4` = '每秒将最多10点怒气值转化为生命值，持续$d。每点怒气值可以转化为$s1点生命值。';

UPDATE `locales_spell` SET `description_loc4` = '每秒将最多10点怒气转化为生命值，每点怒气转化的生命值相当于你的总耐力的$s1%。' WHERE `entry` = 22896 AND `description_loc4` = '每秒将最多10点怒气值转化为生命值，持续$d。每点怒气值可以转化为$s1点生命值。';

UPDATE `locales_spell` SET `description_loc4` = '使你的灼烧和火焰冲击有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。' WHERE `entry` = 22960 AND `description_loc4` = '使你的灼烧法术有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。';

UPDATE `locales_spell` SET `description_loc4` = '使你的灼烧和火焰冲击有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。' WHERE `entry` = 22961 AND `description_loc4` = '使你的灼烧法术有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。';

UPDATE `locales_spell` SET `description_loc4` = '使你的灼烧和火焰冲击有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。' WHERE `entry` = 22962 AND `description_loc4` = '使你的灼烧法术有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。';

UPDATE `locales_spell` SET `description_loc4` = '使你的灼烧和火焰冲击有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。' WHERE `entry` = 22963 AND `description_loc4` = '使你的灼烧法术有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。';

UPDATE `locales_spell` SET `description_loc4` = '使你的灼烧和火焰冲击有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。' WHERE `entry` = 22964 AND `description_loc4` = '使你的灼烧法术有$s1%的几率令目标更易受到火焰伤害，在其受到火焰系攻击时承受的伤害提高$22959s1%，持续$22959d。可叠加$22959u次。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会施放奥术光辉（等级 1）。' WHERE `entry` = 23029 AND `description_loc4` = '废弃技能';

UPDATE `locales_spell` SET `description_loc4` = '有$s1%的几率在施放心灵震爆、惩击和快速治疗时不会因为受到伤害而延迟。' WHERE `entry` = 23043 AND `description_loc4` = '使你有$s1%的几率在施放心灵震爆时不会因受到伤害而被干扰。';

UPDATE `locales_spell` SET `description_loc4` = '有$s1%的几率在施放灼热之痛、暗影箭和吸取灵魂时不会因为受到伤害而延迟。' WHERE `entry` = 23046 AND `description_loc4` = '使你有$s1%的几率在施放灼热之痛时不会因受到伤害而被干扰。';

UPDATE `locales_spell` SET `description_loc4` = '震荡射击的冷却时间减少$/1000;s1秒，摔绊的冷却时间减少$/1000;S2秒。' WHERE `entry` = 23158 AND `description_loc4` = '使你的震荡射击的冷却时间减少$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '对敌人造成奥术伤害，并在$d内造成额外伤害。' WHERE `entry` = 23380 AND `description_loc4` = '向敌人投掷石块，对其造成奥术伤害，并在接下来的$d内造成持续伤害。';

UPDATE `locales_spell` SET `description_loc4` = '使用自然的力量治疗盟友。' WHERE `entry` = 23381 AND `description_loc4` = '向敌人投掷石块，对其造成物理伤害。';

UPDATE `locales_spell` SET `description_loc4` = '火焰和暗影法术消耗的法力值减少$s1%。' WHERE `entry` = 23553 AND `description_loc4` = '暗影法术所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的雄鹰守护所提供的远程攻击强度加成提高$s1%，孤狼守护提供的近战攻击强度加成提高$s1%。' WHERE `entry` = 23559 AND `description_loc4` = '使你的雄鹰守护所提供的远程攻击强度加成提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '切碎、多重射击和乱射所造成的伤害提高$s1%。' WHERE `entry` = 23566 AND `description_loc4` = '多重射击和乱射所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的治疗波会跳跃并治疗额外的目标。每次跳跃后的治疗效果都会降低80%，最多治疗2个额外目标。' WHERE `entry` = 23573 AND `description_loc4` = '你的治疗波会治疗一个额外的目标。治疗波每次跳跃后的治疗效果都会降低80%，并治疗最多2个额外的目标。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成近战或远程伤害时，有一定几率使你获得破甲虚弱效果。破甲虚弱使你的攻击强度提高$23577s1点，持续$23577d。' WHERE `entry` = 23578 AND `description_loc4` = '在你对目标造成远程攻击伤害时，有一定几率使其获得破甲虚弱效果。这个效果可以令所有远程攻击对该目标的攻击强度提高$23577s1点，持续$23577d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的副手武器所造成的伤害提高$s1%，并且使你的副手武器命中率增加$s2%。' WHERE `entry` = 23584 AND `description_loc4` = '使你的副手武器所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的副手武器所造成的伤害提高$s1%，并且使你的副手武器命中率增加$s2%。' WHERE `entry` = 23585 AND `description_loc4` = '使你的副手武器所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的副手武器所造成的伤害提高$s1%，并且使你的副手武器命中率增加$s2%。' WHERE `entry` = 23586 AND `description_loc4` = '使你的副手武器所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的副手武器所造成的伤害提高$s1%，并且使你的副手武器命中率增加$s2%。' WHERE `entry` = 23587 AND `description_loc4` = '使你的副手武器所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的副手武器所造成的伤害提高$s1%，并且使你的副手武器命中率增加$s2%。' WHERE `entry` = 23588 AND `description_loc4` = '使你的副手武器所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使目标受到的法术伤害提高$s1%，持续$d。' WHERE `entry` = 23605 AND `description_loc4` = '使目标受到法术攻击时承受的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '为使用者及其宠物和恶魔治愈龙血之痛：青铜。' WHERE `entry` = 23645 AND `description_loc4` = '为使用者治愈龙血之痛：青铜。';

UPDATE `locales_spell` SET `description_loc4` = '向你灌输奥术能量，使你在$d内施放的下$n次奥术射击、猫鼬撕咬或猛禽一击在目标身上爆炸，对其身边$23722a1码内的敌人造成$23722s1点伤害。' WHERE `entry` = 23721 AND `description_loc4` = '向你灌输奥术能量，使你在$d内施放的下一次奥术射击在目标身上爆炸，对其身边的敌人造成$23722s1点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '使你的目标护甲值提高$s1点，并得到5层庇护效果，持续$d。庇护效果使其每次受到远程或近战攻击时恢复$23781s1生命值并消耗一次充能。' WHERE `entry` = 23780 AND `description_loc4` = '护甲值提高$s1点，每次受到近战或远程攻击时回复$23781s1点生命值，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会制作特效抗毒药剂。' WHERE `entry` = 23788 AND `description_loc4` = '教你学会制作强力抗毒药剂。';

UPDATE `locales_spell` SET `description_loc4` = '召唤一个测试用的石爪图腾。' WHERE `entry` = 23789 AND `description_loc4` = 'Summons a Stoneclaw Totem TEST.';

UPDATE `locales_spell` SET `description_loc4` = '使法术和魔法效果造成的治疗效果提高最多$s1点。' WHERE `entry` = 23796 AND `description_loc4` = '使法术和效果所造成的治疗效果提高最多$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件近战武器附魔，使其获得力量+15的效果。' WHERE `entry` = 23799 AND `description_loc4` = '永久性地为一件近战武器附魔，使其获得+15力量的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件近战武器附魔，使其获得敏捷+15的效果。' WHERE `entry` = 23800 AND `description_loc4` = '永久性地为一件近战武器附魔，使其获得+15敏捷的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一副护腕附魔，使其获得治疗能力+24的效果。' WHERE `entry` = 23802 AND `description_loc4` = '永久性地为一副护腕附魔，使其获得令你的治疗法术效果+24的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件近战武器附魔，使其获得精神+20的效果。' WHERE `entry` = 23803 AND `description_loc4` = '永久性地为一件近战武器附魔，使其获得+20精神的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件近战武器附魔，使其获得智力+22的效果。' WHERE `entry` = 23804 AND `description_loc4` = '永久性地为一件近战武器附魔，使其获得+22智力的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件近战武器永久性地附魔，使其获得+15力量的效果。' WHERE `entry` = 23805 AND `description_loc4` = '教你学会永久性地为一件近战武器附魔，使其获得+15力量的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件近战武器永久性地附魔，使其获得+15敏捷的效果。' WHERE `entry` = 23806 AND `description_loc4` = '教你学会永久性地为一件近战武器附魔，使其获得+15敏捷的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一副护腕永久性地附魔，使其获得每5秒回复4点法力值的效果。' WHERE `entry` = 23807 AND `description_loc4` = '教你学会永久性地为一副护腕附魔，使其获得每5秒回复4点法力值的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一副护腕永久性地附魔，使其获得+24治疗能力的效果。' WHERE `entry` = 23808 AND `description_loc4` = '教你学会永久性地为一副护腕附魔，使其获得令治疗法术效果+24的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件近战武器永久性地附魔，使其获得+20精神的效果。' WHERE `entry` = 23809 AND `description_loc4` = '教你学会永久性地为一件近战武器附魔，使其获得+20精神的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件近战武器永久性地附魔，使其获得+22智力的效果。' WHERE `entry` = 23810 AND `description_loc4` = '教你学会永久性地为一件近战武器附魔，使其获得+22智力的效果。';

UPDATE `locales_spell` SET `description_loc4` = '一次邪恶的攻击，对目标造成$s3%的武器伤害加上$/2;s2，并使目标受伤，任何形式的治疗对其产生的效果降低$s1%，持续$d。' WHERE `entry` = 23848 AND `description_loc4` = 'A vicious strike that deals $s3% weapon damage plus $/2;s2 and wounds the target, reducing the effectiveness of any healing by $s1% for $d.';

UPDATE `locales_spell` SET `description_loc4` = '近战攻击有$h%的几率回复$44068s1点能量值，并使你的躲闪几率和近战攻击速度提高$44068s2%，持续$44068d。' WHERE `entry` = 23863 AND `description_loc4` = '有2%的几率在进行近战攻击时回复$23864s点能量值。';

UPDATE `locales_spell` SET `description_loc4` = '立即进行一次攻击，对目标造成$s1点伤害加上35%攻击强度的额外伤害，并使你的移动速度提高$51670s1%，持续$51670d。' WHERE `entry` = 23881 AND `description_loc4` = '立刻攻击目标，对其造成相当于你的攻击强度$s1%的伤害。另外，你的下$23885n次成功的近战攻击每次都可令你回复$23880s1点生命值。效果持续$23885d。';

UPDATE `locales_spell` SET `description_loc4` = '立即进行一次攻击，对目标造成$s1点伤害加上35%攻击强度的额外伤害，并使你的移动速度提高$51670s1%，持续$51670d。' WHERE `entry` = 23892 AND `description_loc4` = '立刻攻击目标，对其造成相当于你的攻击强度$s1%的伤害。另外，你的下$23886n次成功的近战攻击每次都可令你回复$23889s1点生命值。效果持续$23886d。';

UPDATE `locales_spell` SET `description_loc4` = '立即进行一次攻击，对目标造成$s1点伤害加上35%攻击强度的额外伤害，并使你的移动速度提高$51670s1%，持续$51670d。' WHERE `entry` = 23893 AND `description_loc4` = '立刻攻击目标，对其造成相当于你的攻击强度$s1%的伤害。另外，你的下$23887n次成功的近战攻击每次都可令你回复$23890s1点生命值。效果持续$23887d。';

UPDATE `locales_spell` SET `description_loc4` = '立即进行一次攻击，对目标造成$s1点伤害加上35%攻击强度的额外伤害，并使你的移动速度提高$51670s1%，持续$51670d。' WHERE `entry` = 23894 AND `description_loc4` = '立刻攻击目标，对其造成相当于你的攻击强度$s1%的伤害。另外，你的下$23888n次成功的近战攻击每次都可令你回复$23891s1点生命值。效果持续$23888d。';

UPDATE `locales_spell` SET `description_loc4` = '用盾牌击打目标，对其造成$s2点伤害（此伤害数值受到盾牌格挡值和攻击强度加成影响），并有50%的几率驱散目标身上的$s1个魔法效果，同时产生大量的威胁值。' WHERE `entry` = 23922 AND `description_loc4` = '用盾牌击打目标，对其造成$s2点伤害（盾牌格档值会对伤害数值产生影响），并有50%的几率驱散目标身上的$s1个魔法效果，同时产生大量的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '用盾牌击打目标，对其造成$s2点伤害（此伤害数值受到盾牌格挡值和攻击强度加成影响），并有50%的几率驱散目标身上的$s1个魔法效果，同时产生大量的威胁值。' WHERE `entry` = 23923 AND `description_loc4` = '用盾牌击打目标，对其造成$s2点伤害（盾牌格档值会对伤害数值产生影响），并有50%的几率驱散目标身上的$s1个魔法效果，同时产生大量的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '用盾牌击打目标，对其造成$s2点伤害（此伤害数值受到盾牌格挡值和攻击强度加成影响），并有50%的几率驱散目标身上的$s1个魔法效果，同时产生大量的威胁值。' WHERE `entry` = 23924 AND `description_loc4` = '用盾牌击打目标，对其造成$s2点伤害（盾牌格档值会对伤害数值产生影响），并有50%的几率驱散目标身上的$s1个魔法效果，同时产生大量的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '用盾牌击打目标，对其造成$s2点伤害（此伤害数值受到盾牌格挡值和攻击强度加成影响），并有50%的几率驱散目标身上的$s1个魔法效果，同时产生大量的威胁值。' WHERE `entry` = 23925 AND `description_loc4` = '用盾牌击打目标，对其造成$s2点伤害（盾牌格档值会对伤害数值产生影响），并有50%的几率驱散目标身上的$s1个魔法效果，同时产生大量的威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '对目标造成近战伤害再加上$/2;s1点额外伤害，奖励$s2个连击点数。' WHERE `entry` = 23960 AND `description_loc4` = 'An instant strike that causes $/2;s1 damage in addition to your normal weapon damage.  Awards $s2 combo $lpoint:points;.';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件头部或腿部装备提供耐力10，防御+7，所有治疗法术的效果提高最多24的属性。无法与其它同位置的附魔共存。' WHERE `entry` = 24160 AND `description_loc4` = '永久性地为一件头部或腿部装备提供耐力10，防御+10，所有治疗法术的效果效果提高最多24的属性。无法与其它同位置的附魔共存。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件头部或腿部装备提供+28点攻击强度和躲闪几率+1%的属性。无法与其它同位置的附魔共存。' WHERE `entry` = 24161 AND `description_loc4` = '永久性地为一件头部或腿部装备提供+28点攻击强度和躲闪几率+1%的属性。无法与其它附魔共存。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件头部或腿部装备提供远程攻击强度+24，耐力+10，命中几率+1%的属性。无法与其它同位置的附魔共存。' WHERE `entry` = 24162 AND `description_loc4` = '永久性地为一件头部或腿部装备提供远程攻击强度+24，耐力+10，命中几率+1%的属性。无法与其它附魔共存。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件头部或腿部装备提供所有治疗和伤害法术的效果+18，法术命中率+1%的属性。无法与其它同位置的附魔共存。' WHERE `entry` = 24164 AND `description_loc4` = '永久性地为一件头部或腿部装备提供所有治疗和伤害法术的效果+18，法术命中率+1%的属性。无法与其它附魔共存。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件头部或腿部装备提供耐力+10，所有治疗和伤害法术的效果提高最多18的属性。无法与其它同位置的附魔共存。' WHERE `entry` = 24165 AND `description_loc4` = '永久性地为一件头部或腿部装备提供耐力+10，所有治疗和伤害法术的效果效果提高最多18的属性。无法与其它同位置的附魔共存。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件头部或腿部装备提供耐力+10，每5秒回复4点法力值，所有治疗法术的效果提高最多24的属性。无法与其它同位置的附魔共存。' WHERE `entry` = 24167 AND `description_loc4` = '永久性地为一件头部或腿部装备提供耐力+10，每5秒回复4点法力值，所有治疗法术的效果效果提高最多24的属性。无法与其它同位置的附魔共存。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件头部或腿部装备提供耐力+10，智力+10，所有治疗法术的效果提高最多24的属性。无法与其它同位置的附魔共存。' WHERE `entry` = 24168 AND `description_loc4` = '永久性地为一件头部或腿部装备提供耐力+10，智力+10，所有治疗法术的效果效果提高最多24的属性。无法与其它同位置的附魔共存。';

UPDATE `locales_spell` SET `description_loc4` = '使友军的攻击速度提高$s1%，持续$d。' WHERE `entry` = 24185 AND `description_loc4` = '使所有友军的攻击速度提高$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '命中几率提高$s3%，双持时额外提高$s3%。并使你抵抗移动限制效果的几率提高$s1%。' WHERE `entry` = 24283 AND `description_loc4` = '使你的攻击命中敌人的几率提高$s3%，并使你抵抗移动限制效果的几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的敏捷提高$s1%。并使你的近战攻击强度提高，数值相当于你敏捷的$s2%。' WHERE `entry` = 24296 AND `description_loc4` = '使你的敏捷提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的敏捷提高$s1%。并使你的近战攻击强度提高，数值相当于你敏捷的$s2%。' WHERE `entry` = 24297 AND `description_loc4` = '使你的敏捷提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的冰冻陷阱的持续时间增加$/1000;s1秒。' WHERE `entry` = 24298 AND `description_loc4` = 'Increases the duration of your Freezing Trap by $/1000;s1 sec.';

UPDATE `locales_spell` SET `description_loc4` = '你的冰冻陷阱的持续时间增加$/1000;s1秒。' WHERE `entry` = 24299 AND `description_loc4` = 'Increases the duration of your Freezing Trap by $/1000;s1 sec.';

UPDATE `locales_spell` SET `description_loc4` = '瘫痪，冻结，恐惧。' WHERE `entry` = 24396 AND `description_loc4` = '迷惑。';

UPDATE `locales_spell` SET `description_loc4` = '对单一目标造成$s1点伤害，并使近战范围内的所有敌人的近战攻击强度降低$s2点，效果持续$d。造成的伤害受到其攻击强度加成。' WHERE `entry` = 24423 AND `description_loc4` = '对单一目标造成$s1点伤害，并使近战范围内的所有敌人的近战攻击强度降低$s2点，效果持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的震荡射击和摔绊的冷却时间减少$/1000;s1秒。' WHERE `entry` = 24465 AND `description_loc4` = '使你的震荡射击的冷却时间减少$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使毒蛇钉刺效果的生效间隔时间和持续时间减少$s1%。' WHERE `entry` = 24467 AND `description_loc4` = '使毒蛇钉刺的效果持续时间提高$/1000;s1秒。';

UPDATE `locales_spell` SET `description_loc4` = '使用腐蚀术时立即造成相当于1.5秒腐蚀术的伤害。' WHERE `entry` = 24486 AND `description_loc4` = '使你的腐蚀术所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的灵魂之火和死亡缠绕的冷却时间减少$s1%。' WHERE `entry` = 24487 AND `description_loc4` = '使你的死亡缠绕的冷却时间减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的大地之盾、水之护盾、闪电之盾的效果提高$s1%，持续$d。' WHERE `entry` = 24499 AND `description_loc4` = '使你的闪电之盾所造成的伤害提高$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '对单一目标造成$s1点伤害，并使近战范围内的所有敌人的攻击强度降低$s2点，效果持续$d。造成的伤害受到其攻击强度加成。' WHERE `entry` = 24577 AND `description_loc4` = '对单一目标造成$s1点伤害，并使近战范围内的所有敌人的攻击强度降低$s2点，效果持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '对单一目标造成$s1点伤害，并使近战范围内的所有敌人的近战攻击强度降低$s2点，效果持续$d。造成的伤害受到其攻击强度加成。' WHERE `entry` = 24578 AND `description_loc4` = '对单一目标造成$s1点伤害，并使近战范围内的所有敌人的近战攻击强度降低$s2点，效果持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '对单一目标造成$s1点伤害，并使近战范围内的所有敌人的近战攻击强度降低$s2点，效果持续$d。造成的伤害受到其攻击强度加成。' WHERE `entry` = 24579 AND `description_loc4` = '对单一目标造成$s1点伤害，并使近战范围内的所有敌人的近战攻击强度降低$s2点，效果持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '半径$a1码范围内的队友的下一次攻击可以对敌人造成$s1点额外伤害。效果持续$d。额外伤害受到其攻击强度加成。' WHERE `entry` = 24597 AND `description_loc4` = '半径$a1码范围内的队友的下一次攻击可以对敌人造成$s1点额外伤害。效果持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '半径$a1码范围内的队友的下一次攻击可以对敌人造成$s1点额外伤害。效果持续$d。额外伤害受到其攻击强度加成。' WHERE `entry` = 24603 AND `description_loc4` = '半径$a1码范围内的队友的下一次攻击可以对敌人造成$s1点额外伤害。效果持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '半径$a1码范围内的队友的下一次攻击可以对敌人造成$s1点额外伤害。效果持续$d。额外伤害受到其攻击强度加成。' WHERE `entry` = 24604 AND `description_loc4` = '半径$a1码范围内的队友的下一次攻击可以对敌人造成$s1点额外伤害。效果持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '半径$a1码范围内的队友的下一次攻击可以对敌人造成$s1点额外伤害。效果持续$d。额外伤害受到其攻击强度加成。' WHERE `entry` = 24605 AND `description_loc4` = '半径$a1码范围内的队友的下一次攻击可以对敌人造成$s1点额外伤害。效果持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '多重射击和乱射的伤害提高$s1%，乱射的施法时间减少$/1000;m3秒。' WHERE `entry` = 24691 AND `description_loc4` = '使你的多重射击和乱射法术的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '在猎豹、熊、巨熊或枭兽形态下的攻击强度提高$s1点。' WHERE `entry` = 24694 AND `description_loc4` = '在猎豹、熊或巨熊形态下的攻击强度提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '在猎豹、熊、巨熊或枭兽形态下的攻击强度提高$s1点。' WHERE `entry` = 24697 AND `description_loc4` = '在猎豹、熊或巨熊形态下的攻击强度提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '在$d内恢复总计$o1点生命值，进食时必须保持坐姿。如果你花费至少10秒钟来进食，你的力量将提高$24799s1点，持续$24799d。' WHERE `entry` = 24800 AND `description_loc4` = '在$d内恢复$o1点生命值，持续$d。进食时必须保持坐姿。如果你花费至少10秒钟进食，还会获得$24799s1点力量的加值，持续$24799d。';

UPDATE `locales_spell` SET `description_loc4` = '击碎神圣威能之石，在对亡灵作战时获得$s1点攻击强度的加成，神圣法术伤害提高最多$s2点。持续$d。' WHERE `entry` = 24833 AND `description_loc4` = '击碎神圣力量之石，在对亡灵作战时获得$s1点攻击强度的加成，神圣法术伤害提高最多$s2点。持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '在熊、巨熊和猎豹形态下的躲闪几率提高$s1%。' WHERE `entry` = 24864 AND `description_loc4` = '使德鲁伊的躲闪几率提高$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '使你在猎豹形态下的移动速度提高$s1%，只能在户外生效。另外，还可使你在熊、巨熊、猎豹形态下的躲闪几率提高$24864s1%。' WHERE `entry` = 24866 AND `description_loc4` = '使你在猎豹形态下的移动速度提高$s1%，只能在户外生效。另外，还可使你在猎豹形态下的躲闪几率提高$24864s1%。';

UPDATE `locales_spell` SET `description_loc4` = '在熊、巨熊和猎豹形态下的躲闪几率提高$s1%。' WHERE `entry` = 24867 AND `description_loc4` = '使德鲁伊的躲闪几率提高$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '每秒恢复总生命值的$s1%，持续$d。进食时必须保持坐姿。如果你花费至少10秒钟进食，你的耐力和精神都将提高，持续$24870d。' WHERE `entry` = 24869 AND `description_loc4` = '每秒恢复总生命值的$s1%，持续$d。进食时必须保持坐姿。如果你花费至少10秒钟进食，还会获得耐力和精神加值，持续$24870d。';

UPDATE `locales_spell` SET `description_loc4` = '召唤鱼人宠物奔波尔霸陪伴施法者，直到被解散。' WHERE `entry` = 24939 AND `description_loc4` = '召唤$s1个鱼人宠物奔波尔霸陪伴施法者，直到被解散。';

UPDATE `locales_spell` SET `description_loc4` = '在成功格挡、躲闪或招架后激活。' WHERE `entry` = 24948 AND `description_loc4` = '在成功格挡、躲闪或招架后使用。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗之触、愈合和宁静所消耗的法力值减少$s1%。' WHERE `entry` = 24968 AND `description_loc4` = '使你的治疗之触和宁静所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗之触、愈合和宁静所消耗的法力值减少$s1%。' WHERE `entry` = 24969 AND `description_loc4` = '使你的治疗之触和宁静所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗之触、愈合和宁静所消耗的法力值减少$s1%。' WHERE `entry` = 24970 AND `description_loc4` = '使你的治疗之触和宁静所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗之触、愈合和宁静所消耗的法力值减少$s1%。' WHERE `entry` = 24971 AND `description_loc4` = '使你的治疗之触和宁静所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的治疗之触、愈合和宁静所消耗的法力值减少$s1%。' WHERE `entry` = 24972 AND `description_loc4` = '使你的治疗之触和宁静所消耗的法力值减少$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '在猎豹、熊、巨熊或枭兽形态下的攻击强度提高$s1点。' WHERE `entry` = 24994 AND `description_loc4` = '在猎豹、熊或巨熊形态下的攻击强度提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '提高法术所造成的治疗效果，最多$s1点。' WHERE `entry` = 25067 AND `description_loc4` = '提高法术和魔法效果所造成的治疗效果，最多$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得对怪物所造成的威胁值提高2%的效果。' WHERE `entry` = 25072 AND `description_loc4` = '给一双手套永久性地附魔，使装备它的人物获得对怪物所造成的威胁值提高2%的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得暗影伤害+20的效果。' WHERE `entry` = 25073 AND `description_loc4` = '给一双手套永久性地附魔，使装备它的人物获得暗影法术和技能所造成的伤害提高最多20点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得冰霜伤害+20的效果。' WHERE `entry` = 25074 AND `description_loc4` = '给一双手套永久性地附魔，使装备它的人物获得冰霜法术和技能所造成的伤害提高最多20点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得火焰伤害+20的效果。' WHERE `entry` = 25078 AND `description_loc4` = '给一双手套永久性地附魔，使装备它的人物获得火焰法术和技能所造成的伤害提高最多20点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得治疗能力+30的效果。' WHERE `entry` = 25079 AND `description_loc4` = '给一双手套永久性地附魔，使装备它的人物获得法术和技能所造成的治疗效果提高最多30点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一双手套附魔，使其获得敏捷+15的效果。' WHERE `entry` = 25080 AND `description_loc4` = '给一双手套永久性地附魔，使装备它的人物获得敏捷提高15点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得火焰抗性+15的效果。' WHERE `entry` = 25081 AND `description_loc4` = '给一条披风永久性地附魔，使装备它的人物获得火焰抗性提高15点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得自然抗性+15的效果。' WHERE `entry` = 25082 AND `description_loc4` = '给一条披风永久性地附魔，使装备它的人物获得自然抗性提高15点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得潜行能力提高的效果。' WHERE `entry` = 25083 AND `description_loc4` = '给一条披风永久性地附魔，使装备它的人物获得潜行能力提高的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得对怪物所造成的威胁值降低2%的效果。' WHERE `entry` = 25084 AND `description_loc4` = '给一条披风永久性地附魔，使装备它的人物获得对怪物所造成的威胁值降低2%的效果。';

UPDATE `locales_spell` SET `description_loc4` = '永久性地为一件披风附魔，使其获得躲闪几率提高1%的效果。' WHERE `entry` = 25086 AND `description_loc4` = '给一条披风永久性地附魔，使装备它的人物获得躲闪几率提高1%的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双手套永久性地附魔，使其获得对怪物所造成的威胁值提高的效果。' WHERE `entry` = 25087 AND `description_loc4` = '教你学会给一双手套永久性地附魔，使装备它的人物获得对怪物所造成的威胁值提高的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双手套永久性地附魔，使其获得+20暗影伤害的效果。' WHERE `entry` = 25088 AND `description_loc4` = '教你学会给一双手套永久性地附魔，使装备它的人物获得暗影法术和技能所造成的伤害提高最多20点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双手套永久性地附魔，使其获得+20冰霜伤害的效果。' WHERE `entry` = 25089 AND `description_loc4` = '教你学会给一双手套永久性地附魔，使装备它的人物获得冰霜法术和技能所造成的伤害提高最多20点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双手套永久性地附魔，使其获得+20火焰伤害的效果。' WHERE `entry` = 25090 AND `description_loc4` = '教你学会给一双手套永久性地附魔，使装备它的人物获得火焰法术和技能所造成的伤害提高最多20点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双手套永久性地附魔，使其获得+30治疗能力的效果。' WHERE `entry` = 25091 AND `description_loc4` = '教你学会给一双手套永久性地附魔，使装备它的人物获得法术和技能所造成的治疗效果提高最多30点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一双手套永久性地附魔，使其获得+15敏捷的效果。' WHERE `entry` = 25092 AND `description_loc4` = '教你学会给一双手套永久性地附魔，使装备它的人物获得敏捷提高15点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件披风永久性地附魔，使其获得+15火焰抗性的效果。' WHERE `entry` = 25093 AND `description_loc4` = '教你学会给一条披风永久性地附魔，使装备它的人物获得火焰抗性提高15点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件披风永久性地附魔，使其获得+15自然抗性的效果。' WHERE `entry` = 25094 AND `description_loc4` = '教你学会给一条披风永久性地附魔，使装备它的人物获得自然抗性提高15点的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件披风永久性地附魔，使其获得潜行能力提高的效果。' WHERE `entry` = 25095 AND `description_loc4` = '教你学会给一条披风永久性地附魔，使装备它的人物获得潜行能力提高的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件披风永久性地附魔，使其获得对怪物所造成的威胁值降低2%的效果。' WHERE `entry` = 25096 AND `description_loc4` = '教你学会给一条披风永久性地附魔，使装备它的人物获得对怪物所造成的威胁值降低2%的效果。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件披风永久性地附魔，使其获得+1%躲闪几率的效果。' WHERE `entry` = 25097 AND `description_loc4` = '教你学会给一条披风永久性地附魔，使装备它的人物获得躲闪几率提高1%的效果。';

UPDATE `locales_spell` SET `description_loc4` = '背刺目标，对其造成近战伤害的$s2%再加225点伤害，必须在目标背后发动，潜行者的主手中必须有一把武器。奖励$s3个连击点数。' WHERE `entry` = 25300 AND `description_loc4` = '背刺目标，对其造成武器伤害的$s2%再加225点伤害，必须在目标背后发动，盗贼的主手中必须有一把武器。奖励$s3个连击点数。';

UPDATE `locales_spell` SET `description_loc4` = '腐蚀目标，在$d内造成累计$*6;s1点伤害。' WHERE `entry` = 25311 AND `description_loc4` = '腐蚀目标，在$d内造成累计$o1点伤害。';

UPDATE `locales_spell` SET `description_loc4` = '强大的祷言，可以治疗目标周围半径$a1码范围内的所有小队成员。' WHERE `entry` = 25316 AND `description_loc4` = '强大的祷言，可以治疗附近半径$a1码范围内的所有小队成员。';

UPDATE `locales_spell` SET `description_loc4` = '向目标射出数枚奥术飞弹，对其每$25346d造成$25346s1点伤害，持续$d。' WHERE `entry` = 25345 AND `description_loc4` = '向目标射出数枚奥术飞弹，对其造成每秒$25346s1点伤害，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '在$d内恢复总计$o1点生命值，进食时必须保持坐姿。如果你花费至少10秒钟来进食，你的耐力将提高25点，持续$24799d。' WHERE `entry` = 25660 AND `description_loc4` = '在$d内恢复$o1点生命值，进食时必须保持坐姿。如果你花费至少10秒钟进食，还会获得25点耐力的加值，持续$24799d。';

UPDATE `locales_spell` SET `description_loc4` = '在$25702d内恢复总计$25702o1点生命值和$25703o1点法力值。进食时必须保持坐姿。如果你花费至少10秒钟进食，还会获得每5秒回复$25694s1点法力值的效果，持续$25694d。' WHERE `entry` = 25690 AND `description_loc4` = '在$25702d内恢复$25702o1点生命值和$25703o1点法力值。进食时必须保持坐姿。如果你花费至少10秒钟进食，还会获得每5秒回复$25694s1点法力值的效果，持续$25694d。';

UPDATE `locales_spell` SET `description_loc4` = '在$25888d内恢复总计$25888o1点生命值和$25889o1点法力值。进食时必须保持坐姿。如果你花费至少10秒钟进食，还会获得每5秒回复$25941s1点法力值的效果，持续$25941d。' WHERE `entry` = 25691 AND `description_loc4` = '在$25888d内恢复$25888o1点生命值和$25889o1点法力值。进食时必须保持坐姿。如果你花费至少10秒钟进食，还会获得每5秒回复$25941s1点法力值的效果，持续$25941d。';

UPDATE `locales_spell` SET `description_loc4` = '你的有害法术命中时，有一定几率使你的法术命中几率提高$25768s1%，持续$25768d。' WHERE `entry` = 25767 AND `description_loc4` = '你的伤害法术有一定几率在击中目标后降低其魔法抗性$25768s1点，持续$25768d。';

UPDATE `locales_spell` SET `description_loc4` = '召唤$s1个骷髅仆从为施法者作战，直到被解散。' WHERE `entry` = 25862 AND `description_loc4` = '召唤$s1个骷髅仆从为施法者作战，效果一直持续到主动取消。';

UPDATE `locales_spell` SET `description_loc4` = '使团队或小队中所有与目标职业相同的玩家都获得强效光明祝福的效果，使圣光术为其恢复的生命值提高$s1点，圣光闪现为其恢复的生命值提高$s2点，神圣震击为其恢复的生命值提高$s3点，持续$d。每个圣骑士在同一时间内只能给目标施加一种祝福，同类型的祝福不能重叠。' WHERE `entry` = 25890 AND `description_loc4` = '使团队或小队中所有与目标职业相同的玩家都获得强效光明祝福的效果，使圣光术为其恢复的生命值提高$s1点，圣光闪现为其恢复的生命值提高$s2点，持续$d。每个圣骑士在同一时间内只能给目标施加一种祝福，同类型的祝福不能重叠。';

UPDATE `locales_spell` SET `description_loc4` = '你的有害法术命中时，有一定几率使你的法术伤害提高$25907s1点，持续$25907d。' WHERE `entry` = 25906 AND `description_loc4` = '你的伤害法术有一定几率在击中目标后令你的法术和魔法效果所造成的伤害提高$25907s1点，持续$25907d。';

UPDATE `locales_spell` SET `description_loc4` = '使圣骑士的近战攻击有一定的几率令目标造成的伤害降低$26017s1%，持续$26017d，仅对$26017v级或更低的敌人有效。' WHERE `entry` = 26016 AND `description_loc4` = '使圣骑士的近战攻击有一定的几率令目标的力量和敏捷降低$26017s1%，持续$26017d。';

UPDATE `locales_spell` SET `description_loc4` = '使圣骑士的近战攻击有一定的几率令目标造成的伤害降低$26018s1%，持续$26018d，仅对$26018v级或更低的敌人有效。' WHERE `entry` = 26021 AND `description_loc4` = '使圣骑士的近战攻击有一定的几率令目标的力量和敏捷降低$26018s1%，持续$26018d。';

UPDATE `locales_spell` SET `description_loc4` = '以雷霆的力量震撼地面，对周围半径$a1码范围内的所有敌人造成$s1点自然伤害。造成中等威胁。' WHERE `entry` = 26090 AND `description_loc4` = '以雷霆的力量震撼地面，对周围半径$a1码范围内的所有敌人造成$s1点自然伤害。';

UPDATE `locales_spell` SET `description_loc4` = '在猎豹、熊、巨熊或枭兽形态下的攻击强度提高$s1点。' WHERE `entry` = 26153 AND `description_loc4` = '在猎豹、熊和巨熊形态下的攻击强度提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '你的毒蛇钉刺的伤害有$h%的几率对目标造成$51770s1自然伤害，并为你恢复$51770s2法力值。' WHERE `entry` = 26173 AND `description_loc4` = '使你的奥术射击的法力消耗降低$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '向敌人发起冲锋，使其在$7922d内无法移动，并使你的野猪的下一次攻击的攻击强度提高$s2点加上其本身攻击强度的35%。' WHERE `entry` = 26177 AND `description_loc4` = '向敌人发起冲锋，使其在$7922d内无法移动，并使你的野猪的下一次攻击获得$s2点近战攻击强度加成。';

UPDATE `locales_spell` SET `description_loc4` = '向敌人发起冲锋，使其在$7922d内无法移动，并使你的野猪的下一次攻击的攻击强度提高$s2点加上其本身攻击强度的35%。' WHERE `entry` = 26178 AND `description_loc4` = '向敌人发起冲锋，使其在$7922d内无法移动，并使你的野猪的下一次攻击获得$s2点近战攻击强度加成。';

UPDATE `locales_spell` SET `description_loc4` = '向敌人发起冲锋，使其在$7922d内无法移动，并使你的野猪的下一次攻击的攻击强度提高$s2点加上其本身攻击强度的35%。' WHERE `entry` = 26179 AND `description_loc4` = '向敌人发起冲锋，使其在$7922d内无法移动，并使你的野猪的下一次攻击获得$s2点近战攻击强度加成。';

UPDATE `locales_spell` SET `description_loc4` = '以雷霆的力量震撼地面，对周围半径$a1码范围内的所有敌人造成$s1点自然伤害。造成中等威胁。' WHERE `entry` = 26187 AND `description_loc4` = '以雷霆的力量震撼地面，对周围半径$a1码范围内的所有敌人造成$s1点自然伤害。';

UPDATE `locales_spell` SET `description_loc4` = '以雷霆的力量震撼地面，对周围半径$a1码范围内的所有敌人造成$s1点自然伤害。造成中等威胁。' WHERE `entry` = 26188 AND `description_loc4` = '以雷霆的力量震撼地面，对周围半径$a1码范围内的所有敌人造成$s1点自然伤害。';

UPDATE `locales_spell` SET `description_loc4` = '向敌人发起冲锋，使其在$7922d内无法移动，并使你的野猪的下一次攻击的攻击强度提高$s2点加上其本身攻击强度的35%。' WHERE `entry` = 26201 AND `description_loc4` = '向敌人发起冲锋，使其在$7922d内无法移动，并使你的野猪的下一次攻击获得$s2点近战攻击强度加成。';

UPDATE `locales_spell` SET `description_loc4` = '提高所有法术和魔法效果所造成的伤害和治疗效果，最多$s1点。' WHERE `entry` = 26395 AND `description_loc4` = '高所有法术和魔法效果所造成的伤害和治疗效果，最多$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '右键点击以召唤或解散你的冬季驯鹿。' WHERE `entry` = 26529 AND `description_loc4` = '右键点击以召唤或解散你的驯鹿。';

UPDATE `locales_spell` SET `description_loc4` = '右键点击以召唤或解散你的冬季驯鹿。' WHERE `entry` = 26530 AND `description_loc4` = '右键点击以召唤或解散你的驯鹿。';

UPDATE `locales_spell` SET `description_loc4` = '将圣洁的能量灌入圣骑士脚下的土地，在$d内对进入该区域的所有敌人造成$o1点神圣伤害。圣洁能量随着时间推移逐渐减弱，造成的伤害也会逐渐降低。' WHERE `entry` = 26573 AND `description_loc4` = '将圣洁的能量灌入圣骑士脚下的土地，在$d内对进入该区域的所有敌人造成$o1点神圣伤害。';

UPDATE `locales_spell` SET `description_loc4` = '有一定几率在命中目标时为你回复$s1点生命值和$/10;s2怒气值。' WHERE `entry` = 27418 AND `description_loc4` = '有一定几率在命中目标时为你回复$s1点生命值。';

UPDATE `locales_spell` SET `description_loc4` = '有一定几率在近战攻击时为你回复$27418s1点生命值和$/10;27418s2怒气值。' WHERE `entry` = 27419 AND `description_loc4` = '有一定几率在近战攻击时为你回复$27418s1点生命值。';

UPDATE `locales_spell` SET `description_loc4` = '提高所有法术和魔法效果所造成的伤害和治疗效果，最多$s1点。' WHERE `entry` = 27499 AND `description_loc4` = '使法术和魔法效果造成的伤害和治疗效果提高最多$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '当你受到非周期性法术伤害时，有$h%的几率获得一个吸收$27533s1点该系的伤害的护盾效果，持续$27533d。' WHERE `entry` = 27539 AND `description_loc4` = '当你被某个伤害性法术击中之后，有$h的几率获得一个持续$27533d秒的护盾效果，可以吸收$27533s1点该系的伤害。';

UPDATE `locales_spell` SET `description_loc4` = '一次邪恶的攻击，对目标造成近战伤害外加$s2点伤害，并使任何形式的治疗对其产生的效果降低$s1%，持续$d。' WHERE `entry` = 27580 AND `description_loc4` = '一次邪恶的攻击，对目标造成武器伤害外加$s2点伤害，并使任何形式的治疗对其产生的效果降低$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '对敌人造成$s2%武器伤害，并使其移动速度降低$s1%，持续$d。' WHERE `entry` = 27633 AND `description_loc4` = '对敌人造成$s2点伤害，并使其移动速度降低$s1%，持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '向敌人发起冲锋，使其在$7922d内无法移动，并使你的野猪的下一次攻击的攻击强度提高$s2点加上其本身攻击强度的35%。' WHERE `entry` = 27685 AND `description_loc4` = '向敌人发起冲锋，使其在$7922d内无法移动，并使你的野猪的下一次攻击获得$s2点近战攻击强度加成。';

UPDATE `locales_spell` SET `description_loc4` = '提高所有法术和魔法效果所造成的伤害和治疗效果，最多$s1点。' WHERE `entry` = 27775 AND `description_loc4` = '使法术和魔法效果造成的伤害和治疗效果提高最多$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '你的普通近战和远程攻击有4%几率为你恢复200点法力值。' WHERE `entry` = 27785 AND `description_loc4` = '你的普通远程攻击有一定几率为你恢复200点法力值。';

UPDATE `locales_spell` SET `description_loc4` = '使你的惩击、神圣之火和责罚的射程，治疗祷言和神圣新星的作用半径提高$s1%。' WHERE `entry` = 27789 AND `description_loc4` = '使你的惩击和神圣之火的射程、治疗祷言和神圣新星的作用半径提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的惩击、神圣之火和责罚的射程，治疗祷言和神圣新星的作用半径提高$s1%。' WHERE `entry` = 27790 AND `description_loc4` = '使你的惩击和神圣之火的射程、治疗祷言和神圣新星的作用半径提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '制造一次以施法者为中心的神圣能量爆炸，对半径$a1码范围内的所有目标造成$s1点神圣伤害，并为半径$27803a1码范围内的所有小队成员恢复$27803s1点生命值。在暗影形态下使用此法术会对你造成伤害，而不是治疗，这些效果的仇恨值较低。' WHERE `entry` = 27799 AND `description_loc4` = '制造一次以施法者为中心的神圣能量爆炸，对半径$a1码范围内的所有目标造成$s1点神圣伤害，并为半径$27803a1码范围内的所有小队成员恢复$27803s1点生命值。这些效果不对怪物产生任何威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '制造一次以施法者为中心的神圣能量爆炸，对半径$a1码范围内的所有目标造成$s1点神圣伤害，并为半径$27804a1码范围内的所有小队成员恢复$27804s1点生命值。在暗影形态下使用此法术会对你造成伤害，而不是治疗，这些效果的仇恨值较低。' WHERE `entry` = 27800 AND `description_loc4` = '制造一次以施法者为中心的神圣能量爆炸，对半径$a1码范围内的所有目标造成$s1点神圣伤害，并为半径$27804a1码范围内的所有小队成员恢复$27804s1点生命值。这些效果不对怪物产生任何威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '制造一次以施法者为中心的神圣能量爆炸，对半径$a1码范围内的所有目标造成$s1点神圣伤害，并为半径$27805a1码范围内的所有小队成员恢复$27805s1点生命值。在暗影形态下使用此法术会对你造成伤害，而不是治疗，这些效果的仇恨值较低。' WHERE `entry` = 27801 AND `description_loc4` = '制造一次以施法者为中心的神圣能量爆炸，对半径$a1码范围内的所有目标造成$s1点神圣伤害，并为半径$27805a1码范围内的所有小队成员恢复$27805s1点生命值。这些效果不对怪物产生任何威胁值。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会给一件双手武器永久性地附魔，使其获得+25敏捷的效果。' WHERE `entry` = 27838 AND `description_loc4` = '教你学会永久性地为一件双手武器附魔，使其获得敏捷+25的效果。';

UPDATE `locales_spell` SET `description_loc4` = '使你的虔诚光环影响下的队友受到的所有物理伤害降低$45073s1%。' WHERE `entry` = 27850 AND `description_loc4` = '使你的虔诚光环增加护甲值的效果提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '使次级治疗波的治疗效果提高$s1点。' WHERE `entry` = 27855 AND `description_loc4` = '使次级治疗波所恢复的生命值提高最多$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '使大地震击、烈焰震击和冰霜震击所造成的伤害提高最多$s1点。' WHERE `entry` = 27859 AND `description_loc4` = '使地震术、烈焰震击和冰霜震击所造成的伤害提高最多$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '在牧师身边制造一个光明之泉。你所属的小队或团队中的友方单位可以点击光明之泉，在$27873d内恢复$27873o1点生命值。光明之泉在$d或者在被使用5次之后消失。' WHERE `entry` = 27870 AND `description_loc4` = '在牧师身边制造一个光明之泉。你所属的小队或团队中的友方单位可以点击光明之泉，在$27873d内恢复$27873o1点生命值。被攻击会中断这个效果。光明之泉在$d或者在被使用5次之后消失。';

UPDATE `locales_spell` SET `description_loc4` = '在牧师身边制造一个光明之泉。你所属的小队或团队中的友方单位可以点击光明之泉，在$27874d内恢复$27874o1点生命值。光明之泉在$d或者在被使用5次之后消失。' WHERE `entry` = 27871 AND `description_loc4` = '在牧师身边制造一个光明之泉。你所属的小队或团队中的友方单位可以点击光明之泉，在$27874d内恢复$27874o1点生命值。被攻击会中断这个效果。光明之泉在$d或者在被使用5次之后消失。';

UPDATE `locales_spell` SET `description_loc4` = '使周围半径$a1码范围内的所有小队成员的攻击和施法速度提高$s1%。' WHERE `entry` = 28145 AND `description_loc4` = '使周围半径$a1码范围内的所有小队成员每5秒恢复$s1点法力值。';

UPDATE `locales_spell` SET `description_loc4` = '法术伤害提高最多$s2，治疗效果提高最多$s1。' WHERE `entry` = 28152 AND `description_loc4` = '提高法术所造成的治疗效果，最多$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '在猎豹、熊、巨熊或枭兽形态下的攻击强度提高$s1点。' WHERE `entry` = 28154 AND `description_loc4` = '在猎豹、熊和巨熊形态下的攻击强度提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '使你的法术伤害提高最多$s2点，治疗效果提高最多$s1点。' WHERE `entry` = 28155 AND `description_loc4` = '使你的法术伤害提高最多120点，治疗效果提高最多300点。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使自然抗性提高10点。无法与其它同位置的附魔共存。' WHERE `entry` = 28161 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使自然抗性提高10点。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使自然抗性提高10点。无法与其它同位置的附魔共存。' WHERE `entry` = 28162 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使自然抗性提高10点。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使冰霜抗性提高10点。无法与其它同位置的附魔共存。' WHERE `entry` = 28163 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使冰霜抗性提高10点。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使冰霜抗性提高10点。无法与其它同位置的附魔共存。' WHERE `entry` = 28164 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使冰霜抗性提高10点。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使暗影抗性提高10点。无法与其它同位置的附魔共存。' WHERE `entry` = 28165 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使暗影抗性提高10点。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '给你的头部或腿部装备附加魔法效果，使暗影抗性提高10点。无法与其它同位置的附魔共存。' WHERE `entry` = 28166 AND `description_loc4` = '给你的头部或腿部装备附加魔法效果，使暗影抗性提高10点。无法与其它附加于指定装备的魔法效果重叠。';

UPDATE `locales_spell` SET `description_loc4` = '使你的多重射击和切碎造成的伤害提高$s1%。' WHERE `entry` = 28539 AND `description_loc4` = '使你的多重射击所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '在猎豹、熊、巨熊或枭兽形态下的攻击强度提高$s1点。' WHERE `entry` = 28717 AND `description_loc4` = '在猎豹、熊和巨熊形态下的攻击强度提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '使你的猛禽一击、猫鼬撕咬、切碎、多重射击、瞄准射击、稳固射击的法力值消耗降低$s1点。' WHERE `entry` = 28751 AND `description_loc4` = '使你的多重射击和瞄准射击的法力值消耗降低$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '你的远程和近战攻击造成致命一击后，使你获得激素刺激的效果，回复$28753s1点法力值。' WHERE `entry` = 28752 AND `description_loc4` = '你的远程攻击打出致命一击后，使你获得激素刺激的效果，回复$28753s1点法力值。';

UPDATE `locales_spell` SET `description_loc4` = '使你的光明审判所恢复的生命值提高最多$s1点。' WHERE `entry` = 28775 AND `description_loc4` = '使你的圣光审判所恢复的生命值提高最多$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '使你的背刺、邪恶攻击、双刃毒袭、出血和剔骨技能所产生的威胁值降低。' WHERE `entry` = 28811 AND `description_loc4` = '使你的背刺、邪恶攻击、出血和剔骨技能所产生的威胁值降低。';

UPDATE `locales_spell` SET `description_loc4` = '你的背刺、邪恶攻击、双刃毒袭和出血技能造成致命一击之后，你可以获得$28813s1点能量值。' WHERE `entry` = 28812 AND `description_loc4` = '你的背刺、邪恶攻击和出血技能造成致命一击之后，你可以获得$28813s1点能量值。';

UPDATE `locales_spell` SET `description_loc4` = '你的剔骨技能每个连击点数有$b1%的几率找到敌人护甲上的破绽，使你的下一次背刺、邪恶攻击、双刃毒袭或出血有$28815s1%的几率造成致命一击。' WHERE `entry` = 28814 AND `description_loc4` = '你的剔骨技能有一定几率找到敌人护甲上的破绽，使你的下一次背刺、邪恶攻击或出血技能必定造成致命一击。连击点数越多，找到破绽的几率越大。';

UPDATE `locales_spell` SET `description_loc4` = '使你的下一次邪恶攻击、背刺、双刃毒袭或出血的致命一击几率提高$s1%。' WHERE `entry` = 28815 AND `description_loc4` = '使你的下一次邪恶攻击、背刺或出血的致命一击几率提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '当水之护盾处于激活状态的时候，你可以获得每5秒恢复$28820s1点法力值的效果。' WHERE `entry` = 28821 AND `description_loc4` = '当闪电之盾处于激活状态的时候，你可以获得每5秒恢复$28820s1点法力值的效果。';

UPDATE `locales_spell` SET `description_loc4` = '使圣光闪现的治疗效果提高$s1点。' WHERE `entry` = 28851 AND `description_loc4` = '使圣光闪现的治疗效果提高最多$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '使圣光闪现的治疗效果提高$s1点。' WHERE `entry` = 28853 AND `description_loc4` = '使圣光闪现的治疗效果提高最多$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '使次级治疗波的治疗效果提高$s1点。' WHERE `entry` = 28856 AND `description_loc4` = '使次级治疗波的治疗效果提高最多$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '使你有$h%的几率在受到近战或远程致命一击之后获得持续$29063d的专注施法效果，在此期间，你的元素系法术不会因为受到伤害而延长施法时间。' WHERE `entry` = 29062 AND `description_loc4` = '使你有$h%的几率在受到近战或远程致命一击之后获得持续$29063d的专注施法效果，在此期间，你不会因为受到伤害而延长施法时间。';

UPDATE `locales_spell` SET `description_loc4` = '你的元素系法术不会因为受到伤害而延长施法时间，持续$d。' WHERE `entry` = 29063 AND `description_loc4` = '施放之后，你不再因为受到伤害而延长施法时间。效果持续$d。';

UPDATE `locales_spell` SET `description_loc4` = '使你有$h%的几率在受到近战或远程致命一击之后获得持续$29063d的专注施法效果，在此期间，你的元素系法术不会因为受到伤害而延长施法时间。' WHERE `entry` = 29064 AND `description_loc4` = '使你有$h%的几率在受到近战或远程致命一击之后获得持续$29063d的专注施法效果，在此期间，你不会因为受到伤害而延长施法时间。';

UPDATE `locales_spell` SET `description_loc4` = '使你有$h%的几率在受到近战或远程致命一击之后获得持续$29063d的专注施法效果，在此期间，你的元素系法术不会因为受到伤害而延长施法时间。' WHERE `entry` = 29065 AND `description_loc4` = '使你有$h%的几率在受到近战或远程致命一击之后获得持续$29063d的专注施法效果，在此期间，你不会因为受到伤害而延长施法时间。';

UPDATE `locales_spell` SET `description_loc4` = '为你的武器注入能量，带来不同的特殊效果：

UPDATE `locales_spell` SET `description_loc4` = '为你的武器注入能量，带来不同的特殊效果：

UPDATE `locales_spell` SET `description_loc4` = '使用的所有武器、风暴打击和闪电打击造成的伤害提高$s1%，瞬发法术的致命一击几率提高$s3%。' WHERE `entry` = 29082 AND `description_loc4` = '使你用所有武器造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使用的所有武器、风暴打击和闪电打击造成的伤害提高$s1%，瞬发法术的致命一击几率提高$s3%。' WHERE `entry` = 29084 AND `description_loc4` = '使你用所有武器造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使用的所有武器、风暴打击和闪电打击造成的伤害提高$s1%，瞬发法术的致命一击几率提高$s3%。' WHERE `entry` = 29086 AND `description_loc4` = '使你用所有武器造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使用的所有武器、风暴打击和闪电打击造成的伤害提高$s1%，瞬发法术的致命一击几率提高$s3%。' WHERE `entry` = 29087 AND `description_loc4` = '使你用所有武器造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使用的所有武器、风暴打击和闪电打击造成的伤害提高$s1%，瞬发法术的致命一击几率提高$s3%。' WHERE `entry` = 29088 AND `description_loc4` = '使你用所有武器造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的近战攻击和法术命中几率提高$s2%，你的近战攻击造成致命一击后将使你的法术命中几率提高$29177s1%，持续$29177d。' WHERE `entry` = 29179 AND `description_loc4` = '使你的攻击性法术在造成致命一击后，有$h%的几率令你的近战攻击致命一击率提高$29177s1%，持续$29177d。';

UPDATE `locales_spell` SET `description_loc4` = '你的近战攻击和法术命中几率提高$s2%，你的近战攻击造成致命一击后将使你的法术命中几率提高$29178s1%，持续$29178d。' WHERE `entry` = 29180 AND `description_loc4` = '使你的攻击性法术在造成致命一击后，有$h%的几率令你的近战攻击致命一击率提高$29178s1%，持续$29178d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有自然法术所造成的威胁值降低$s1%。' WHERE `entry` = 29187 AND `description_loc4` = '使你的所有治疗法术所造成的威胁值降低$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有自然法术所造成的威胁值降低$s1%。' WHERE `entry` = 29189 AND `description_loc4` = '使你的所有治疗法术所造成的威胁值降低$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有自然法术所造成的威胁值降低$s1%。' WHERE `entry` = 29191 AND `description_loc4` = '使你的所有治疗法术所造成的威胁值降低$s1%。';

UPDATE `locales_spell` SET `description_loc4` = '你的治疗波和次级治疗波有$s1%的几率、治疗链有$s2%的几率使你下一次治疗波或治疗链对该目标的治疗效果提高$29203s1%，持续$29203d，可叠加$29203u次。' WHERE `entry` = 29202 AND `description_loc4` = '你的治疗波有$s1%的几率令你的目标由以后的治疗波获得额外的治疗效果。这个效果使目标所受到的治疗效果提高$29203s1%，持续$29203d，可叠加$29203u次。';

UPDATE `locales_spell` SET `description_loc4` = '你的治疗波和次级治疗波有$s1%的几率、治疗链有$s2%的几率使你下一次治疗波或治疗链对该目标的治疗效果提高$29203s1%，持续$29203d，可叠加$29203u次。' WHERE `entry` = 29205 AND `description_loc4` = '你的治疗波有$s1%的几率令你的目标由以后的治疗波获得额外的治疗效果。这个效果使目标所受到的治疗效果提高$29203s1%，持续$29203d，可叠加$29203u次。';

UPDATE `locales_spell` SET `description_loc4` = '你的治疗波和次级治疗波有$s1%的几率、治疗链有$s2%的几率使你下一次治疗波或治疗链对该目标的治疗效果提高$29203s1%，持续$29203d，可叠加$29203u次。' WHERE `entry` = 29206 AND `description_loc4` = '你的治疗波有$s1%的几率令你的目标由以后的治疗波获得额外的治疗效果。这个效果使目标所受到的治疗效果提高$29203s1%，持续$29203d，可叠加$29203u次。';

UPDATE `locales_spell` SET `description_loc4` = '立刻用火焰燃烧目标，对其造成$s1点火焰伤害，并在随后的$d内造成总计$o2点火焰伤害。该法术还受到你的近战攻击强度加成。' WHERE `entry` = 29228 AND `description_loc4` = '立刻用火焰燃烧目标，对其造成$s1点火焰伤害，并在随后的$d内造成总计$o2点火焰伤害。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有抗性提高$s2点，并且每当你的一个法术被部分或完全抵抗时，你都会恢复你总法力的$s1%。此效果每2秒可发生一次。' WHERE `entry` = 29441 AND `description_loc4` = '使你的所有抗性提高$s2点，你每次完全抵抗一个法术就可以恢复法力值总量的$s1%。冷却时间1秒钟。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有抗性提高$s2点，并且每当你的一个法术被部分或完全抵抗时，你都会恢复你总法力的$s1%。此效果每2秒可发生一次。' WHERE `entry` = 29444 AND `description_loc4` = '使你的所有抗性提高$s2点，你每次完全抵抗一个法术就可以恢复法力值总量的$s1%。冷却时间1秒钟。';

UPDATE `locales_spell` SET `description_loc4` = '使你的所有抗性提高$s2点，并且每当你的一个法术被部分或完全抵抗时，你都会恢复你总法力的$s1%。此效果每2秒可发生一次。' WHERE `entry` = 29445 AND `description_loc4` = '使你的所有抗性提高$s2点，你每次完全抵抗一个法术就可以恢复法力值总量的$s1%。冷却时间1秒钟。';

UPDATE `locales_spell` SET `description_loc4` = '调试，团队副本测试用。' WHERE `entry` = 29820 AND `description_loc4` = 'DEBUG

UPDATE `locales_spell` SET `description_loc4` = '你的近战攻击和法术命中几率提高$s2%，你的近战攻击造成致命一击后将使你的法术命中几率提高$30165s1%，持续$30165d。' WHERE `entry` = 30160 AND `description_loc4` = '使你的攻击性法术在造成致命一击后，有$h%的几率令你的近战攻击致命一击率提高$30165s1%，持续$30165d。';

UPDATE `locales_spell` SET `description_loc4` = '使你的潜行侦测能力提高。' WHERE `entry` = 30895 AND `description_loc4` = '使你的潜行侦测能力提高，并使你被法术和远程攻击命中的几率降低$s2%。比察觉（等级 1）更有效。';

UPDATE `locales_spell` SET `description_loc4` = '使你的单手斧、匕首、拳套、单手锤和单手剑的武器技能提高$s1点。' WHERE `entry` = 30919 AND `description_loc4` = '使你的剑、拳套和匕首的武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '使你的单手斧、匕首、拳套、单手锤和单手剑的武器技能提高$s1点。' WHERE `entry` = 30920 AND `description_loc4` = '使你的剑、拳套和匕首的武器技能提高$s1点。';

UPDATE `locales_spell` SET `description_loc4` = '教你学会凶猛撕咬（等级 6）。' WHERE `entry` = 31020 AND `description_loc4` = '教你学会凶猛撕咬（等级 5）。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '造成的伤害降低$s1%。' WHERE `entry` = 67 AND `auraDescription_loc4` = '力量和敏捷降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '威胁值降低。' WHERE `entry` = 586 AND `auraDescription_loc4` = '降低威胁等级。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '护甲值提高$s1。法术伤害增加$s2。' WHERE `entry` = 588 AND `auraDescription_loc4` = '防御值提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '护甲值提高$s1。法术伤害增加$s2。' WHERE `entry` = 602 AND `auraDescription_loc4` = '防御值提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '周期性地转移$s1点生命值给施法者。' WHERE `entry` = 689 AND `auraDescription_loc4` = '每秒吸取$s1点生命值并将其转移给施法者。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '周期性地转移$s1点生命值给施法者。' WHERE `entry` = 699 AND `auraDescription_loc4` = '每秒吸取$s1点生命值并将其转移给施法者。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '使目标的攻击速度降低$s1%。' WHERE `entry` = 702 AND `auraDescription_loc4` = '对目标造成的物理伤害降低$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '周期性地转移$s1点生命值给施法者。' WHERE `entry` = 709 AND `auraDescription_loc4` = '每秒吸取$s1点生命值并将其转移给施法者。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '每$t1秒为附近的团队成员恢复$s1点生命值。' WHERE `entry` = 740 AND `auraDescription_loc4` = '每$t1秒为附近的小队成员恢复$s1点生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 745 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '转移生命值。' WHERE `entry` = 755 AND `auraDescription_loc4` = '正在转移生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '护甲值提高$s1。法术伤害增加$s2。' WHERE `entry` = 1006 AND `auraDescription_loc4` = '防御值提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '在$d内造成$*6;s2点暗影伤害。' WHERE `entry` = 1120 AND `auraDescription_loc4` = '每$t2秒$s2点暗影伤害。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '造成的物理伤害降低$51509s1%。

UPDATE `locales_spell` SET `auraDescription_loc4` = '攻击速度提高$s1%，并使瞄准射击和稳固射击的施法时间减少s2%。' WHERE `entry` = 3045 AND `auraDescription_loc4` = '远程攻击速度提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 3542 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '转移生命值。' WHERE `entry` = 3698 AND `auraDescription_loc4` = '正在转移生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '转移生命值。' WHERE `entry` = 3699 AND `auraDescription_loc4` = '正在转移生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '转移生命值。' WHERE `entry` = 3700 AND `auraDescription_loc4` = '正在转移生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '伤害提高$s1点，每秒回复$t2点能量值。' WHERE `entry` = 5217 AND `auraDescription_loc4` = '伤害提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 5567 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 6533 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '伤害提高$s1点，每秒回复$t2点能量值。' WHERE `entry` = 6793 AND `auraDescription_loc4` = '伤害提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '护甲值提高$s1。法术伤害增加$s2。' WHERE `entry` = 7128 AND `auraDescription_loc4` = '防御值提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 7295 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '周期性地转移$s1点生命值给施法者。' WHERE `entry` = 7651 AND `auraDescription_loc4` = '每秒吸取$s1点生命值并将其转移给施法者。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 7761 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 7950 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 8142 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '在$d内造成$*6;s2点暗影伤害。' WHERE `entry` = 8288 AND `auraDescription_loc4` = '每$t2秒$s2点暗影伤害。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '在$d内造成$*6;s2点暗影伤害。' WHERE `entry` = 8289 AND `auraDescription_loc4` = '每$t2秒$s2点暗影伤害。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 8346 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 8377 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '受到法术伤害提高$s1%。

UPDATE `locales_spell` SET `auraDescription_loc4` = '每$t1秒为附近的团队成员恢复$s1点生命值。' WHERE `entry` = 8918 AND `auraDescription_loc4` = '每$t1秒为附近的小队成员恢复$s1点生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '威胁值降低。' WHERE `entry` = 9578 AND `auraDescription_loc4` = '降低威胁等级。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '威胁值降低。' WHERE `entry` = 9579 AND `auraDescription_loc4` = '降低威胁等级。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '威胁值降低。' WHERE `entry` = 9592 AND `auraDescription_loc4` = '降低威胁等级。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '伤害提高$s1点，每秒回复$t2点能量值。' WHERE `entry` = 9845 AND `auraDescription_loc4` = '伤害提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '伤害提高$s1点，每秒回复$t2点能量值。' WHERE `entry` = 9846 AND `auraDescription_loc4` = '伤害提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '每$t1秒为附近的团队成员恢复$s1点生命值。' WHERE `entry` = 9862 AND `auraDescription_loc4` = '每$t1秒为附近的小队成员恢复$s1点生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '每$t1秒为附近的团队成员恢复$s1点生命值。' WHERE `entry` = 9863 AND `auraDescription_loc4` = '每$t1秒为附近的小队成员恢复$s1点生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 9915 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '受到法术伤害提高$s1%。

UPDATE `locales_spell` SET `auraDescription_loc4` = '威胁值降低。' WHERE `entry` = 10941 AND `auraDescription_loc4` = '降低威胁等级。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '威胁值降低。' WHERE `entry` = 10942 AND `auraDescription_loc4` = '降低威胁等级。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '护甲值提高$s1。法术伤害增加$s2。' WHERE `entry` = 10951 AND `auraDescription_loc4` = '防御值提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '护甲值提高$s1。法术伤害增加$s2。' WHERE `entry` = 10952 AND `auraDescription_loc4` = '防御值提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 11264 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '吸收伤害，且冰霜伤害提高$s2%。' WHERE `entry` = 11426 AND `auraDescription_loc4` = '吸收伤害。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '物理伤害降低，每$t3秒受到$s3点暗影伤害。' WHERE `entry` = 11658 AND `auraDescription_loc4` = '力量降低，每$t3秒$s3点暗影伤害。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '在$d内造成$*6;s2点暗影伤害。' WHERE `entry` = 11675 AND `auraDescription_loc4` = '每$t2秒$s2点暗影伤害。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '转移生命值。' WHERE `entry` = 11693 AND `auraDescription_loc4` = '正在转移生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '转移生命值。' WHERE `entry` = 11694 AND `auraDescription_loc4` = '正在转移生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '转移生命值。' WHERE `entry` = 11695 AND `auraDescription_loc4` = '正在转移生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '周期性地转移$s1点生命值给施法者。' WHERE `entry` = 11699 AND `auraDescription_loc4` = '每秒吸取$s1点生命值并将其转移给施法者。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '周期性地转移$s1点生命值给施法者。' WHERE `entry` = 11700 AND `auraDescription_loc4` = '每秒吸取$s1点生命值并将其转移给施法者。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 11820 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 11831 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 12023 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 12024 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '施法速度提高$s1%，但损失法力值。' WHERE `entry` = 12042 AND `auraDescription_loc4` = '你的法术可以造成更高伤害，但是需要消耗更多法力值才能施放。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 12252 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '你在接下来的$n次技能或主手近战攻击中可以攻击到一个额外的敌人。' WHERE `entry` = 12292 AND `auraDescription_loc4` = '你在接下来的$n次近战攻击中可以攻击到一个额外的敌人。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '受到治疗效果降低$s1%。' WHERE `entry` = 12294 AND `auraDescription_loc4` = '治疗效果降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 12674 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 12748 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '吸收伤害，且冰霜伤害提高$s2%。' WHERE `entry` = 13031 AND `auraDescription_loc4` = '吸收伤害。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '吸收伤害，且冰霜伤害提高$s2%。' WHERE `entry` = 13032 AND `auraDescription_loc4` = '吸收伤害。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '吸收伤害，且冰霜伤害提高$s2%。' WHERE `entry` = 13033 AND `auraDescription_loc4` = '吸收伤害。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 13608 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '武器攻击可对附近的一个额外的敌人造成伤害，

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 14030 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '下一个产生连击点数的技能造成致命一击的几率提高$s1%。' WHERE `entry` = 14143 AND `auraDescription_loc4` = '你的下一次邪恶攻击、背刺、伏击或鬼魅攻击造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '下一个产生连击点数的技能造成致命一击的几率提高$s1%。' WHERE `entry` = 14149 AND `auraDescription_loc4` = '你的下一次邪恶攻击、背刺、伏击或鬼魅攻击造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '下一个产生连击点数的技能造成致命一击的几率提高$s1%。' WHERE `entry` = 14151 AND `auraDescription_loc4` = '你的下一次邪恶攻击、背刺、伏击或鬼魅攻击造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '下一个产生连击点数的技能造成致命一击的几率提高$s1%。' WHERE `entry` = 14153 AND `auraDescription_loc4` = '你的下一次邪恶攻击、背刺、伏击或鬼魅攻击造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '下一个产生连击点数的技能造成致命一击的几率提高$s1%。' WHERE `entry` = 14155 AND `auraDescription_loc4` = '你的下一次邪恶攻击、背刺、伏击或鬼魅攻击造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '你的下一次邪恶攻击、背刺、伏击、双刃毒袭或剔骨造成致命一击的几率提高$s1%。' WHERE `entry` = 14177 AND `auraDescription_loc4` = '你的下一次邪恶攻击、背刺、伏击或剔骨造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 14907 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 15063 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '精神提高$s1%，施法时保持$s2%的法力值回复速度。' WHERE `entry` = 15271 AND `auraDescription_loc4` = '精神提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '暗影法术伤害转为牧师所在小队的生命值。' WHERE `entry` = 15286 AND `auraDescription_loc4` = '$s1%的暗影伤害转为牧师所在小队的生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '暗影法术伤害转为施法者的生命值。' WHERE `entry` = 15290 AND `auraDescription_loc4` = '20%的暗影伤害转为施法者的生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 15474 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 15531 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 15532 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 15609 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '火焰、冰霜和自然伤害提高$s1%，攻击性法术的法力消耗降低$s2%。' WHERE `entry` = 16166 AND `auraDescription_loc4` = '你的下一个火焰、冰霜或自然法术必定造成致命一击，且法力值消耗降低$s2%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '你的下一个施法时间低于10秒的自然法术会成为瞬发法术，但造成的自然伤害会降低$s2%。' WHERE `entry` = 16188 AND `auraDescription_loc4` = '你的下一个施法时间低于10秒的自然法术会成为瞬发法术。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '使目标的攻击和施法速度提高$s1%。' WHERE `entry` = 16322 AND `auraDescription_loc4` = '使目标的攻击速度提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '受到物理攻击时所承受的伤害提高$s3%。' WHERE `entry` = 16511 AND `auraDescription_loc4` = '受到物理攻击时所承受的伤害提高$s3点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '每$t1秒$s1点伤害。' WHERE `entry` = 16914 AND `auraDescription_loc4` = '每$t1秒$s1点伤害，攻击间隔延长$s2%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '每$t1秒$s1点伤害。' WHERE `entry` = 17401 AND `auraDescription_loc4` = '每$t1秒$s1点伤害，攻击间隔延长$s2%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '每$t1秒$s1点伤害。' WHERE `entry` = 17402 AND `auraDescription_loc4` = '每$t1秒$s1点伤害，攻击间隔延长$s2%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '使你的移动速度提高$s2%，并每$t1秒恢复$s1点生命值。$42023a1内的友方目标会获得一半的效果。' WHERE `entry` = 17625 AND `auraDescription_loc4` = '移动速度和生命值回复速度提高。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '你的下一个暗影箭成为瞬发法术，且必定命中。' WHERE `entry` = 17941 AND `auraDescription_loc4` = '你的下一个暗影箭成为瞬发法术。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '力量提高$s1点。' WHERE `entry` = 18125 AND `auraDescription_loc4` = '耐力提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '召唤小鬼、虚空行者、魅魔或地狱猎犬的法术施法时间减少$/1000;S1秒，法力消耗减少$s2%。' WHERE `entry` = 18708 AND `auraDescription_loc4` = '召唤小鬼、虚空行者、魅魔或地狱猎手的法术施法时间减少$/1000;S1秒，法力消耗减少$s2%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '法术伤害提高$s1%。' WHERE `entry` = 18789 AND `auraDescription_loc4` = '火焰伤害提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '造成的威胁值降低$s1%。' WHERE `entry` = 18791 AND `auraDescription_loc4` = '暗影伤害提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '周期性地将$s1点生命值转移给施法者。' WHERE `entry` = 18879 AND `auraDescription_loc4` = '每$t1秒将$s1点生命值转移给施法者。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '周期性地将$s1点生命值转移给施法者。' WHERE `entry` = 18880 AND `auraDescription_loc4` = '每$t1秒将$s1点生命值转移给施法者。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '周期性地将$s1点生命值转移给施法者。' WHERE `entry` = 18881 AND `auraDescription_loc4` = '每$t1秒将$s1点生命值转移给施法者。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 19185 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 19229 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 19306 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '攻击会使目标的近战攻击强度降低$19479s1点，可叠加5次。' WHERE `entry` = 19478 AND `auraDescription_loc4` = '令攻击者损失$19479s1点近战攻击强度，可叠加5次。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '攻击强度提高$s1%加上额外$s2点。' WHERE `entry` = 19506 AND `auraDescription_loc4` = '攻击强度提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '攻击会使目标的近战攻击强度降低$19652s1点，可叠加5次。' WHERE `entry` = 19655 AND `auraDescription_loc4` = '令攻击者损失$19652s1点近战攻击强度，可叠加5次。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '攻击会使目标的近战攻击强度降低$19653s1点，可叠加5次。' WHERE `entry` = 19656 AND `auraDescription_loc4` = '令攻击者损失$19653s1点近战攻击强度，可叠加5次。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '攻击会使目标的近战攻击强度降低$19654s1点，可叠加5次。' WHERE `entry` = 19660 AND `auraDescription_loc4` = '令攻击者损失$19654s1点近战攻击强度，可叠加5次。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '因圣光术恢复的生命值提高$s1点，圣光闪现恢复的生命值提高$s2点，神圣震击恢复的生命值提高$s3点。' WHERE `entry` = 19977 AND `auraDescription_loc4` = '因圣光术恢复的生命值提高$s1点，因圣光闪现恢复的生命值提高$s2点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '因圣光术恢复的生命值提高$s1点，圣光闪现恢复的生命值提高$s2点，神圣震击恢复的生命值提高$s3点。' WHERE `entry` = 19978 AND `auraDescription_loc4` = '因圣光术恢复的生命值提高$s1点，因圣光闪现恢复的生命值提高$s2点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '因圣光术恢复的生命值提高$s1点，圣光闪现恢复的生命值提高$s2点，神圣震击恢复的生命值提高$s3点。' WHERE `entry` = 19979 AND `auraDescription_loc4` = '因圣光术恢复的生命值提高$s1点，因圣光闪现恢复的生命值提高$s2点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '物理和神圣伤害提高$s1%，产生的威胁值减少$s2%。' WHERE `entry` = 20050 AND `auraDescription_loc4` = '物理和神圣伤害提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '物理和神圣伤害提高$s1%，产生的威胁值减少$s2%。' WHERE `entry` = 20052 AND `auraDescription_loc4` = '物理和神圣伤害提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '物理和神圣伤害提高$s1%，产生的威胁值减少$s2%。' WHERE `entry` = 20053 AND `auraDescription_loc4` = '物理和神圣伤害提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '物理和神圣伤害提高$s1%，产生的威胁值减少$s2%。' WHERE `entry` = 20054 AND `auraDescription_loc4` = '物理和神圣伤害提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '物理和神圣伤害提高$s1%，产生的威胁值减少$s2%。' WHERE `entry` = 20055 AND `auraDescription_loc4` = '物理和神圣伤害提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '免疫流血、毒药和疾病，受到物理伤害降低$s1%。' WHERE `entry` = 20594 AND `auraDescription_loc4` = '免疫流血、毒药和疾病，护甲值提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '潜行侦测能力提高。

UPDATE `locales_spell` SET `auraDescription_loc4` = '攻击强度提高$s1%加上额外$s2点。' WHERE `entry` = 20905 AND `auraDescription_loc4` = '攻击强度提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '攻击强度提高$s1%加上额外$s2点。' WHERE `entry` = 20906 AND `auraDescription_loc4` = '攻击强度提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 20909 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 20910 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '格挡几率提高$s1%。成功格挡会对攻击者造成$s2点神圣伤害。' WHERE `entry` = 20925 AND `auraDescription_loc4` = '格挡几率提高$s1%。成功格挡会对攻击者造成$s2点神圣伤害，这种伤害所造成的威胁值提高20%。每次成功格挡会消耗掉一次格挡机会，最多可格挡$n次。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '格挡几率提高$s1%。成功格挡会对攻击者造成$s2点神圣伤害。' WHERE `entry` = 20927 AND `auraDescription_loc4` = '格挡几率提高$s1%。成功格挡会对攻击者造成$s2点神圣伤害，这种伤害所造成的威胁值提高20%。每次成功格挡会消耗掉一次格挡机会，最多可格挡$n次。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '格挡几率提高$s1%。成功格挡会对攻击者造成$s2点神圣伤害。' WHERE `entry` = 20928 AND `auraDescription_loc4` = '格挡几率提高$s1%。成功格挡会对攻击者造成$s2点神圣伤害，这种伤害所造成的威胁值提高20%。每次成功格挡会消耗掉一次格挡机会，最多可格挡$n次。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '受到治疗效果降低$s1%。' WHERE `entry` = 21551 AND `auraDescription_loc4` = '治疗效果降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '受到治疗效果降低$s1%。' WHERE `entry` = 21552 AND `auraDescription_loc4` = '治疗效果降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '受到治疗效果降低$s1%。' WHERE `entry` = 21553 AND `auraDescription_loc4` = '治疗效果降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 22519 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 22645 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法移动。' WHERE `entry` = 22924 AND `auraDescription_loc4` = '无法行动。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '根据您的骑行技能提高速度。' WHERE `entry` = 23227 AND `auraDescription_loc4` = '速度提高$s2%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '根据您的骑行技能提高速度。' WHERE `entry` = 23228 AND `auraDescription_loc4` = '速度提高$s2%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '根据您的骑行技能提高速度。' WHERE `entry` = 23229 AND `auraDescription_loc4` = '速度提高$s2%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '受到治疗效果降低$s1%。' WHERE `entry` = 23230 AND `auraDescription_loc4` = '治疗效果降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '攻击强度提高$*2;20572s1点，法术伤害提高$20572s1点。' WHERE `entry` = 23234 AND `auraDescription_loc4` = '基础近战攻击强度提高$20572s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '根据您的骑行技能提高速度。' WHERE `entry` = 23238 AND `auraDescription_loc4` = '速度提高$s2%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '根据您的骑行技能提高速度。' WHERE `entry` = 23239 AND `auraDescription_loc4` = '速度提高$s2%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '根据您的骑行技能提高速度。' WHERE `entry` = 23240 AND `auraDescription_loc4` = '速度提高$s2%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '被强制不断为队友施放祝福。' WHERE `entry` = 23418 AND `auraDescription_loc4` = '被强制不断为奈法利安施放保护祝福。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '攻击强度提高$s1。' WHERE `entry` = 23577 AND `auraDescription_loc4` = '对该目标的所有远程攻击的攻击强度都提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '受到法术伤害提高$s1%。' WHERE `entry` = 23605 AND `auraDescription_loc4` = '受到法术攻击时承受的伤害提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '你的下一次猫鼬撕咬、奥术射击或猛禽一击在目标身上爆炸。' WHERE `entry` = 23721 AND `auraDescription_loc4` = '你的下一次奥术射击在目标身上爆炸。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '法力值消耗降低$s1%。' WHERE `entry` = 23759 AND `auraDescription_loc4` = '对敌人造成的威胁降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '受到物理伤害降低$s1%。' WHERE `entry` = 23760 AND `auraDescription_loc4` = '受到物理攻击时承受的伤害降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '造成的伤害提高$s1%。' WHERE `entry` = 23761 AND `auraDescription_loc4` = '对敌人造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '所有抗性提高$s1点。' WHERE `entry` = 23762 AND `auraDescription_loc4` = '对所有魔法的抗性提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '法力值消耗降低$s1%。' WHERE `entry` = 23826 AND `auraDescription_loc4` = '对敌人造成的威胁降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '法力值消耗降低$s1%。' WHERE `entry` = 23827 AND `auraDescription_loc4` = '对敌人造成的威胁降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '法力值消耗降低$s1%。' WHERE `entry` = 23828 AND `auraDescription_loc4` = '对敌人造成的威胁降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '法力值消耗降低$s1%。' WHERE `entry` = 23829 AND `auraDescription_loc4` = '对敌人造成的威胁降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '造成的伤害提高$s1%。' WHERE `entry` = 23833 AND `auraDescription_loc4` = '对敌人造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '造成的伤害提高$s1%。' WHERE `entry` = 23834 AND `auraDescription_loc4` = '对敌人造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '造成的伤害提高$s1%。' WHERE `entry` = 23835 AND `auraDescription_loc4` = '对敌人造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '造成的伤害提高$s1%。' WHERE `entry` = 23836 AND `auraDescription_loc4` = '对敌人造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '所有抗性提高$s1点。' WHERE `entry` = 23837 AND `auraDescription_loc4` = '对所有魔法的抗性提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '所有抗性提高$s1点。' WHERE `entry` = 23838 AND `auraDescription_loc4` = '对所有魔法的抗性提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '所有抗性提高$s1点。' WHERE `entry` = 23839 AND `auraDescription_loc4` = '对所有魔法的抗性提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '所有抗性提高$s1点。' WHERE `entry` = 23840 AND `auraDescription_loc4` = '对所有魔法的抗性提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '受到物理伤害降低$s1%。' WHERE `entry` = 23841 AND `auraDescription_loc4` = '受到物理攻击时承受的伤害降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '受到物理伤害降低$s1%。' WHERE `entry` = 23842 AND `auraDescription_loc4` = '受到物理攻击时承受的伤害降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '受到物理伤害降低$s1%。' WHERE `entry` = 23843 AND `auraDescription_loc4` = '受到物理攻击时承受的伤害降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '受到物理伤害降低$s1%。' WHERE `entry` = 23844 AND `auraDescription_loc4` = '受到物理攻击时承受的伤害降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '近战攻击命中目标则回复$23880s1生命值。' WHERE `entry` = 23885 AND `auraDescription_loc4` = '近战攻击命中目标则回复$s1点生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '近战攻击命中目标则回复$23889s1生命值。' WHERE `entry` = 23886 AND `auraDescription_loc4` = '近战攻击命中目标则回复$23889s1点生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '近战攻击命中目标则回复$23890s1生命值。' WHERE `entry` = 23887 AND `auraDescription_loc4` = '近战攻击命中目标则回复$23890s1点生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '近战攻击命中目标则回复$23891s1生命值。' WHERE `entry` = 23888 AND `auraDescription_loc4` = '近战攻击命中目标则回复$23891s1点生命值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '根据您的骑行技能提高速度。' WHERE `entry` = 24252 AND `auraDescription_loc4` = '速度提高$s2%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '护盾法术的效果提高$s1%。' WHERE `entry` = 24499 AND `auraDescription_loc4` = '闪电之盾所造成的伤害提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '下一次物理攻击造成$s1点额外伤害。' WHERE `entry` = 24597 AND `auraDescription_loc4` = '下一次攻击可以对敌人造成$s1点额外伤害。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '下一次物理攻击造成$s1点额外伤害。' WHERE `entry` = 24603 AND `auraDescription_loc4` = '下一次攻击可以对敌人造成$s1点额外伤害。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '下一次物理攻击造成$s2点额外伤害。' WHERE `entry` = 24604 AND `auraDescription_loc4` = '下一次攻击可以对敌人造成$s1点额外伤害。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '下一次物理攻击造成$s3点额外伤害。' WHERE `entry` = 24605 AND `auraDescription_loc4` = '下一次攻击可以对敌人造成$s1点额外伤害。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '免疫变形效果，从装备提供的护甲值提高$24905s1%。' WHERE `entry` = 24858 AND `auraDescription_loc4` = '免疫变形效果。护甲值提高$24905s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '周期性地造成$s1点暗影伤害。' WHERE `entry` = 25311 AND `auraDescription_loc4` = '每$t1秒$s1点暗影伤害。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '护甲值降低。' WHERE `entry` = 25503 AND `auraDescription_loc4` = '每秒获得$/10;s1点怒气值。护甲值降低。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '法术命中几率提高$s1%。' WHERE `entry` = 25768 AND `auraDescription_loc4` = '你的法术目标的魔法抗性降低$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '无法被圣盾术、圣佑术或保护之手效果所保护。' WHERE `entry` = 25771 AND `auraDescription_loc4` = '无法被圣盾术、圣佑术或保护祝福效果所保护。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '近战致命一击+10%。' WHERE `entry` = 25848 AND `auraDescription_loc4` = '+10% melee crit.';

UPDATE `locales_spell` SET `auraDescription_loc4` = '因圣光术恢复的生命值提高最多$s1点，因圣光闪现恢复的生命值提高最多$s2点，因神圣震击恢复的生命值提高最多$s3点。' WHERE `entry` = 25890 AND `auraDescription_loc4` = '因圣光术恢复的生命值提高最多$s1点，因圣光闪现恢复的生命值提高最多$s2点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '法术伤害提高$s1点。' WHERE `entry` = 25907 AND `auraDescription_loc4` = '法术效果提高$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '造成的伤害降低$s1%。' WHERE `entry` = 26017 AND `auraDescription_loc4` = '力量和敏捷降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '造成的伤害降低$s1%。' WHERE `entry` = 26018 AND `auraDescription_loc4` = '力量和敏捷降低$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '使法术和魔法效果造成的伤害和治疗效果提高最多$s1点。' WHERE `entry` = 28143 AND `auraDescription_loc4` = '法术和魔法效果所造成的伤害和治疗效果提高最多$s1点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '你的攻击和施法速度提高$s1%。' WHERE `entry` = 28145 AND `auraDescription_loc4` = '每5秒恢复$s1点法力值。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '使你的法术伤害提高最多$s2点，治疗效果提高最多$s1点。' WHERE `entry` = 28155 AND `auraDescription_loc4` = '使你的法术伤害提高最多$2s点，治疗效果提高最多$1s点。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '在$d内受到总计$*12;s1点暗影伤害。' WHERE `entry` = 28608 AND `auraDescription_loc4` = '在$d内受到总计$o1点暗影伤害。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '攻击速度提高$s1%。' WHERE `entry` = 28701 AND `auraDescription_loc4` = '攻击速度提高。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '你的下一次邪恶攻击、背刺、双刃毒袭或出血的致命一击几率提高$s1%。' WHERE `entry` = 28815 AND `auraDescription_loc4` = '你的下一次邪恶攻击、背刺或出血的致命一击几率提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '攻击速度提高$s1%。' WHERE `entry` = 28866 AND `auraDescription_loc4` = '攻击速度提高。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '元素系法术不会因为受到伤害而延长施法时间。' WHERE `entry` = 29063 AND `auraDescription_loc4` = '不会因为受到伤害而延长施法时间。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '你使用法术击中目标的几率提高$s1%。' WHERE `entry` = 29177 AND `auraDescription_loc4` = '使你的近战攻击造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '你使用法术击中目标的几率提高$s1%。' WHERE `entry` = 29178 AND `auraDescription_loc4` = '使你的近战攻击造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '治疗波和治疗链的效果提高$s1%。' WHERE `entry` = 29203 AND `auraDescription_loc4` = '治疗波的效果提高最多$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '你使用法术击中目标的几率提高$s1%。' WHERE `entry` = 30165 AND `auraDescription_loc4` = '使你的近战攻击造成致命一击的几率提高$s1%。';

UPDATE `locales_spell` SET `auraDescription_loc4` = '永久标记为PvP。' WHERE `entry` = 50033 AND `auraDescription_loc4` = 'Permanently flagged for PvP。 TEST';

UPDATE `locales_area` SET `NameLoc4` = '奈杉德哨岗' WHERE `Entry` = 289 AND `NameLoc4` = '奈杉德农场';

UPDATE `locales_faction` SET `name_loc4` = '迪菲亚兄弟会' WHERE `entry` = 15 AND `name_loc4` = '迪菲亚盗贼';

UPDATE `locales_faction` SET `name_loc4` = '野兽 - 蜘蛛' WHERE `entry` = 22 AND `name_loc4` = '蜘蛛';

UPDATE `locales_faction` SET `name_loc4` = '野兽 - 野猪' WHERE `entry` = 23 AND `name_loc4` = '野猪';

UPDATE `locales_faction` SET `name_loc4` = '野兽 - 狼' WHERE `entry` = 29 AND `name_loc4` = '狼人';

UPDATE `locales_faction` SET `name_loc4` = '迪菲亚兄弟会叛徒' WHERE `entry` = 30 AND `name_loc4` = '叛变的迪菲亚盗贼(艾泽拉斯)';

UPDATE `locales_faction` SET `name_loc4` = '穴居人' WHERE `entry` = 32 AND `name_loc4` = '石腭怪';

UPDATE `locales_faction` SET `name_loc4` = '野兽 - 熊' WHERE `entry` = 37 AND `name_loc4` = '熊';

UPDATE `locales_faction` SET `name_loc4` = '库尔森的雇佣兵' WHERE `entry` = 39 AND `name_loc4` = '库森的雇佣兵';

UPDATE `locales_faction` SET `name_loc4` = '风险投资公司' WHERE `entry` = 41 AND `name_loc4` = '荆棘谷地精';

UPDATE `locales_faction` SET `name_loc4` = '野兽 - 迅猛龙' WHERE `entry` = 42 AND `name_loc4` = '迅猛龙';

UPDATE `locales_faction` SET `name_loc4` = '破烂' WHERE `entry` = 44 AND `name_loc4` = '绿龙';

UPDATE `locales_faction` SET `name_loc4` = '锻造- 护甲锻造' WHERE `entry` = 46 AND `name_loc4` = '斯通纳德兽人';

UPDATE `locales_faction` SET `name_loc4` = '废物' WHERE `entry` = 50 AND `name_loc4` = '红龙';

UPDATE `locales_faction` SET `name_loc4` = '麻疯侏儒' WHERE `entry` = 53 AND `name_loc4` = '疯狂侏儒';

UPDATE `locales_faction` SET `name_loc4` = '野兽 - 豹' WHERE `entry` = 55 AND `name_loc4` = '豹';

UPDATE `locales_faction` SET `name_loc4` = '野兽 - 猩猩' WHERE `entry` = 58 AND `name_loc4` = '猩猩';

UPDATE `locales_faction` SET `name_loc4` = '制皮 - 元素' WHERE `entry` = 83 AND `name_loc4` = '怪物 - 无组织';

UPDATE `locales_faction` SET `name_loc4` = '制皮 - 龙鳞' WHERE `entry` = 86 AND `name_loc4` = '怪物 - 有组织';

UPDATE `locales_faction` SET `name_loc4` = '玛洛迪半人马' WHERE `entry` = 94 AND `name_loc4` = '玛洛迪';

UPDATE `locales_faction` SET `name_loc4` = '亡首野猪人' WHERE `entry` = 111 AND `name_loc4` = '骷髅野猪人';

UPDATE `locales_faction` SET `name_loc4` = '守望堡商队' WHERE `entry` = 168 AND `name_loc4` = '奈瑟加德商队';

UPDATE `locales_faction` SET `name_loc4` = '热砂财团' WHERE `entry` = 169 AND `name_loc4` = '热砂港';

UPDATE `locales_faction` SET `name_loc4` = '锻造- 武器锻造' WHERE `entry` = 289 AND `name_loc4` = '黑水海盗';

UPDATE `locales_faction` SET `name_loc4` = '野兽 - 蝙蝠' WHERE `entry` = 310 AND `name_loc4` = '蝙蝠';

UPDATE `locales_faction` SET `name_loc4` = '垃圾' WHERE `entry` = 532 AND `name_loc4` = '蓝龙军团';

UPDATE `locales_faction` SET `name_loc4` = '野兽 - 食腐鸟' WHERE `entry` = 669 AND `name_loc4` = '野兽 - 秃鹫';

UPDATE `locales_faction` SET `name_loc4` = '野兽 - 土狼' WHERE `entry` = 673 AND `name_loc4` = '野兽 - 鬣狗';

UPDATE `locales_faction` SET `name_loc4` = '食人魔（克罗卡斯队长）' WHERE `entry` = 829 AND `name_loc4` = '食人魔（克罗姆克鲁什队长）';

UPDATE `locales_faction` SET `name_loc4` = '异种虫攻击者' WHERE `entry` = 916 AND `name_loc4` = '异种虫类';

UPDATE `locales_faction` SET `name_loc4` = '铁马兄弟会' WHERE `entry` = 1004 AND `name_loc4` = '半人马兄弟会';

UPDATE `locales_faction` SET `name_loc4` = '热砂血环' WHERE `entry` = 1008 AND `name_loc4` = '热砂港血环';

UPDATE `locales_faction` SET `name_loc4` = '永恒龙军团' WHERE `entry` = 1009 AND `name_loc4` = '无尽龙族';

UPDATE `locales_faction` SET `name_loc4` = '石槌部族' WHERE `entry` = 1012 AND `name_loc4` = '石槌部落';

UPDATE `locales_taxi_node` SET `name_loc4` = '藏宝海湾到棘齿城的船只' WHERE `entry` = 34 AND `name_loc4` = '棘齿城到藏宝海湾的船只';

UPDATE `locales_taxi_node` SET `name_loc4` = '南海镇码头，希尔斯布莱德' WHERE `entry` = 46 AND `name_loc4` = '南海镇渡口，希尔斯布莱德';

UPDATE `locales_taxi_node` SET `name_loc4` = '血毒岗哨，费伍德森林' WHERE `entry` = 48 AND `name_loc4` = '血毒河，费伍德森林';

UPDATE `locales_taxi_node` SET `name_loc4` = '霜狼要塞，奥特兰克山谷' WHERE `entry` = 60 AND `name_loc4` = '部落要塞，奥特兰克山谷';

UPDATE `locales_taxi_node` SET `name_loc4` = '寒风营地，西瘟疫之地' WHERE `entry` = 66 AND `name_loc4` = '冰风岗，西瘟疫之地';


-- 共 2703 条
