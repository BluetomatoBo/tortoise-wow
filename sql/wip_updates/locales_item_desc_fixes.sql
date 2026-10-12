-- 物品说明误配的定向回滚（locales_item.description_loc4，453 条）
--
-- 问题：2026-10-05 的汉化把空着的 description_loc4 按 **entry** 抄自 cmangos classic-db 的
--   官方中文（locales/Chinese/locales_item.sql）。香草条目表里留着一批当时没用上、
--   后来才启用/废弃的 entry，而乌龟服把这些 entry 用作自己的自定义内容：
--     42142 官方数据是宝石「朴素龙眼石」（说明：对应红色插槽。），乌龟服是「朴素树叶」，
--     于是宝石的插槽说明贴到了树叶上（/db/items/42142 的现状）。
--   同类误配共 453 条：
--     机制在 1.12 不存在                 236 条
--     来源行是另一件物品                    160 条
--     物品五个法术槽全 0，不可能教人             40 条
--     我们这件是占位/测试名，来源行讲的是另一件物品      17 条
--
-- 判据（可复现）：tools/dbdiff/verify_cmangos_desc_fill.py —— 只有能确认来源行讲的就是
--   我们这件物品时才保留（上游中文同名 / 香草原版同 entry 英文名一致 / 两个中文名高度重合），
--   否则撤掉。复现：
--     python3 tools/dbdiff/verify_cmangos_desc_fill.py \
--         --mysql "tools/dbdiff/mysql_local.sh tw_world" \
--         --base sql/base/tw_world_locales_item.sql --cache /tmp/cmangos-data \
--         --report /tmp/cmangos_desc_fill.tsv --sql /tmp/cmangos_desc_revert.sql
--
-- 安全性（逐条核过）：
--   * 453 条全部是「上游 base 里没有中文说明」（444 条上游无此条目、9 条上游说明为空），
--     所以撤成空串＝回到上游状态，不会删掉任何上游/官方中文。
--   * 453 条在上游 item_template / 线上库里英文说明也都是空的，撤掉后中英一致（都没有说明行）。
--   * 幂等：值对不上（后来被人修订过）就整行不动。
--   * 与 sql/wip_updates/locales_item.sql 已同步：那 453 行已从导入集删除，重跑导入不会再写回来。
--
-- 应用：mysql tw_world < sql/wip_updates/locales_item_desc_fixes.sql

SET NAMES utf8mb4;

-- 23100（Idol of Fluidity ← 来源行「反光德拉诺影钻」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=23100 AND `description_loc4`='对应红色或蓝色插槽。';
-- 29953（Mossbloom Coating ← 来源行「金色龙鹰卵」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=29953 AND `description_loc4`='教你学会召唤这种小伙伴。';
-- 29956（Rosepetal Varnish ← 来源行「红色龙鹰卵」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=29956 AND `description_loc4`='教你学会召唤这种小伙伴。';
-- 29957（Twilight Enamel ← 来源行「银色龙鹰卵」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=29957 AND `description_loc4`='教你学会召唤这种小伙伴。';
-- 29958（Crimson Kiss Stain ← 来源行「蓝色龙鹰卵」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=29958 AND `description_loc4`='教你学会召唤这种小伙伴。';
-- 29960（Sunstone Sheen ← 来源行「被捕获的萤火虫」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=29960 AND `description_loc4`='教你学会召唤这种小伙伴。';
-- 31830（Sea Creature Bones ← 来源行「蓝色骑乘塔布羊缰绳」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=31830 AND `description_loc4`='教你学会召唤这种坐骑。';
-- 31831（Sea Creature Bones ← 来源行「银色骑乘塔布羊缰绳」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=31831 AND `description_loc4`='教你学会召唤这种坐骑。';
-- 31832（Sea Creature Bones ← 来源行「银色骑乘塔布羊缰绳」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=31832 AND `description_loc4`='教你学会召唤这种坐骑。';
-- 31833（Sea Turtle Remains ← 来源行「褐色骑乘塔布羊缰绳」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=31833 AND `description_loc4`='教你学会召唤这种坐骑。';
-- 31834（Sea Turtle Remains ← 来源行「褐色骑乘塔布羊缰绳」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=31834 AND `description_loc4`='教你学会召唤这种坐骑。';
-- 31835（Strangely Marked Box ← 来源行「白色骑乘塔布羊缰绳」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=31835 AND `description_loc4`='教你学会召唤这种坐骑。';
-- 33008（Crown of Transcendence ← 来源行「叛逃者传单」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33008 AND `description_loc4`='这只箱子里满是传单，上面写着了抨击吉安娜女士、并且教唆塞拉摩卫兵加入叛逃者行列的文章。';
-- 33009（Epaulets of Transcendence ← 来源行「鲜嫩的陆行鸟肉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33009 AND `description_loc4`='要是能咬一口这么美味多汁的肉，凯雷该有多高兴呀！';
-- 33010（Vestments of Transcendence ← 来源行「格里伏塔的便笺」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33010 AND `description_loc4`='似乎不用拆封就可以偷看……';
-- 33012（Handwraps of Transcendence ← 来源行「泰罗卡丁香花」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33012 AND `description_loc4`='高贵典雅……就像其它东西一样。';
-- 33013（Cord of Transcendence ← 来源行「巴德的祖阿曼地图」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33013 AND `description_loc4`='这张地图充其量也只能说是草图……';
-- 33014（Trousers of Transcendence ← 来源行「优质棍子」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33014 AND `description_loc4`='由大自然的鬼斧神工历经百年制成！';
-- 33015（Slippers of Transcendence ← 来源行「修改过的传单」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33015 AND `description_loc4`='这些传单上的文字被修改过，意在羞辱塞拉摩叛逃者。';
-- 33017（Shoulderpads of the Oracle ← 来源行「盛满的蓝色美酒节酒杯」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33017 AND `description_loc4`='麦酒，你最好的选择。';
-- 33018（Robes of the Oracle ← 来源行「盛满的蓝色美酒节酒杯」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33018 AND `description_loc4`='你召唤了雷霆！';
-- 33019（Leggings of the Oracle ← 来源行「盛满的蓝色美酒节酒杯」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33019 AND `description_loc4`='戈多克烈酒，棒极了。';
-- 33020（Sandals of the Oracle ← 来源行「盛满的蓝色美酒节酒杯」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33020 AND `description_loc4`='德罗恩的酿酒厂，明智的选择。';
-- 33021（Sacred Windhorn Gloves ← 来源行「盛满的蓝色美酒节酒杯」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33021 AND `description_loc4`='塔卡里的巫毒酒蕴含着你不想去了解的魔法力量。';
-- 33037（Sacred Windhorn Robe ← 来源行「迪菲亚命令书」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33037 AND `description_loc4`='这些命令书的字体非常优雅，而且用的是上好的纸张。';
-- 33038（Bonespeaker Cane ← 来源行「损坏的潜水设备」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33038 AND `description_loc4`='用它去潜水，基本上就是死路一条。';
-- 33039（Fleshrender ← 来源行「工具包」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33039 AND `description_loc4`='锈迹斑斑、肮脏不堪的工具，只有陷入绝境的人才会想去使用它。';
-- 33040（Reedwoven Epaulets ← 来源行「修好的潜水设备」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33040 AND `description_loc4`='雷恩修理了一番，但是说不准这玩意什么时候就失灵了。';
-- 33041（Deathtotem Relic ← 来源行「打捞上来的保险箱」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33041 AND `description_loc4`='箱子里的东西似乎并没有在海难中损坏。';
-- 33042（Sacred Windhorn Headdress ← 来源行「黑咖啡」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33042 AND `description_loc4`='杯子边上写着一行字：非常热！不要洒在自己或者别人身上。';
-- 33045（The Blackwind Pillar ← 来源行「雷恩的补给品」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33045 AND `description_loc4`='内含潜水设备和打捞用具。';
-- 33047（Ar'pora, the Chieftain's Judgement ← 来源行「贝尔比的电眼浪漫护目镜」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33047 AND `description_loc4`='贝尔比品质保证：让每个人看起来都魅力四射！';
-- 33054（Vanguard's Amulet ← 来源行「丹扎拉尔徽记」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33054 AND `description_loc4`='它在你的脚下吞噬着一切……';
-- 33060（Vanguard's Brooch ← 来源行「Soulbound Test Gem」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33060 AND `description_loc4`='对应红色、蓝色或黄色插槽。';
-- 33069（Vanguard's Girdle ← 来源行「结实的绳子」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33069 AND `description_loc4`='结实、坚韧的绳子，可以用来捕捉大型生物。';
-- 33070（Vanguard's Belt ← 来源行「迅猛龙诱饵」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33070 AND `description_loc4`='这块在最近一次捕猎行动中获得的肉块现在已经几乎全部腐烂了。';
-- 33071（Placeholder 1.18.1 Item ← 来源行「黑蹄军备」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33071 AND `description_loc4`='这些武器和护甲的样式与你在林荫旅店找到的那些相同，但是没有在实战中使用过。';
-- 33083（Elementium Sharpening Stone ← 来源行「兽人烈酒」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33083 AND `description_loc4`='喝多了对身体不好……';
-- 33084（Pristine Chromatic Scale ← 来源行「暗爪蝙蝠的粪便」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33084 AND `description_loc4`='氨水、尿酸、磷、浆草汁、碳酸。嗯……都是好东西！';
-- 33095（Spellpower Goggles Xtreme Plus+ ← 来源行「石槌战旗」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33095 AND `description_loc4`='这面旗帜已经相当破旧了，还散发着恶臭，但它仍然代表着石槌氏族的荣耀。';
-- 33096（Shimmering Chromatic Cloak ← 来源行「免费美酒节取样器」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33096 AND `description_loc4`='免费的美酒，装在可以扔着玩的杯子中！';
-- 33098（Idol of Equilibrium ← 来源行「匹特洛夫的集束炸弹」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33098 AND `description_loc4`='感受蝙蝠粪的威力吧！';
-- 33099（Idol of Brambleskin ← 来源行「完整的药剂容器」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33099 AND `description_loc4`='容器上的标签写有未穿戴防护服切勿触摸的警告。';
-- 33102（Placeholder 1.18.1 Item ← 来源行「祖尔金之血」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33102 AND `description_loc4`='透过玻璃瓶壁，你可以感觉到祖尔金的血液在翻腾。';
-- 33105（Placeholder 1.18.1 Item ← 来源行「巴德的祖阿曼伪装」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33105 AND `description_loc4`='为了逼真起见，你必须努力把自己想象成一个野蛮的巨魔……';
-- 33107（Placeholder 1.18.1 Item ← 来源行「破烂的巫毒人偶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33107 AND `description_loc4`='一个破碎、肮脏的巫毒人偶。';
-- 33108（Placeholder 1.18.1 Item ← 来源行「软泥怪毁灭者」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33108 AND `description_loc4`='轰杀讨厌的软泥怪！品质保证！';
-- 33109（Placeholder 1.18.1 Item ← 来源行「钢铁之门古器」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33109 AND `description_loc4`='又大又易碎。你究竟怎样才能搬动这么多东西呢？';
-- 33110（Placeholder 1.18.1 Item ← 来源行「刺脊的剑」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33110 AND `description_loc4`='某个疯狂的鱼人随身携带的剑，粗糙而且锈迹斑斑。';
-- 33111（Placeholder 1.18.1 Item ← 来源行「原始雾刃豹的肠线」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33111 AND `description_loc4`='芬雷要用这东西制作弩弓？真恶心！';
-- 33119（Placeholder 1.18.1 Item ← 来源行「玛利斯特的冰霜魔杖」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33119 AND `description_loc4`='不要把舌头冻在上面！';
-- 33121（Placeholder 1.18.1 Item ← 来源行「失去光泽的情侣戒指」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33121 AND `description_loc4`='稍微擦一下，这枚戒指就可以变得光亮如新。';
-- 33123（Loop of Shattered Earth ← 来源行「西部卫戍要塞炮弹」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33123 AND `description_loc4`='你怎么可能一次搬运10颗炮弹？！';
-- 33124（Warden's Bracers ← 来源行「图样：黑暗披风」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33124 AND `description_loc4`='教你学会制作黑暗披风。';
-- 33127（Wraps of the Spirit Guide ← 来源行「深海中的卑劣生物」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33127 AND `description_loc4`='古老的水手传说集，描述了各种巨型海怪。';
-- 33129（Drape of the Far Seer ← 来源行「菲纳特的爆竹」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33129 AND `description_loc4`='既不安全，也不理智！';
-- 33131（Ragefury Stompers ← 来源行「血色残阳」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33131 AND `description_loc4`='对应红色插槽。镶嵌此宝石将使其变为绑定物品。';
-- 33132（Totem of Calm Cascades ← 来源行「精致焰红石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33132 AND `description_loc4`='对应红色插槽。';
-- 33133（Earthen Ring Tabard ← 来源行「胡里奥之心」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33133 AND `description_loc4`='对应红色插槽。镶嵌此宝石将使其变为绑定物品。';
-- 33134（Plans: Bulwark of Unshaken Earth ← 来源行「凯蕾的玫瑰」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33134 AND `description_loc4`='对应红色插槽。镶嵌此宝石将使其变为绑定物品。';
-- 33135（Bulwark of Unshaken Earth ← 来源行「坠星石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33135 AND `description_loc4`='对应蓝色插槽。镶嵌此宝石将使其变为绑定物品。';
-- 33137（Narak'la Padded Breastplate ← 来源行「火花坠星石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33137 AND `description_loc4`='对应蓝色插槽。';
-- 33138（Draenethyst Kris ← 来源行「秘法刀石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33138 AND `description_loc4`='对应黄色插槽。';
-- 33139（Draenethyst Blade ← 来源行「闪耀刀石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33139 AND `description_loc4`='对应红色插槽。';
-- 33140（Draenethyst Juggernaut ← 来源行「琥珀之血」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33140 AND `description_loc4`='对应黄色插槽。镶嵌此宝石将使其变为绑定物品。';
-- 33141（Draenethyst Longbow ← 来源行「刚硬刀石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33141 AND `description_loc4`='对应蓝色插槽。';
-- 33142（Draenethyst Scepter ← 来源行「刚硬刀石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33142 AND `description_loc4`='对应黄色插槽。';
-- 33143（Draenethyst Necklace ← 来源行「刀锋之石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33143 AND `description_loc4`='对应黄色插槽。镶嵌此宝石将使其变为绑定物品。';
-- 33144（Formula: Rift Tear ← 来源行「永恒之钻」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33144 AND `description_loc4`='对应黄色插槽。镶嵌此宝石将使其变为绑定物品。';
-- 33148（Alar'tar, Born from Hope ← 来源行「公式：附魔披风 - 躲闪」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33148 AND `description_loc4`='教你学会永久性地为一件披风附魔，使其获得躲闪等级+12的效果。该装备等级不得低于35级。';
-- 33149（Battle Standard of the Broodcommander ← 来源行「公式：附魔披风 - 潜行」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33149 AND `description_loc4`='教你学会永久性地为一件披风附魔，使其获得敏捷和躲闪等级各提高8点的效果。';
-- 33150（Yoxtez, Black Breath of the Dragonflight ← 来源行「公式：附魔披风 - 狡诈」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33150 AND `description_loc4`='教你学会永久性地为一件披风附魔，使其获得对怪物造成的威胁值降低2%的效果。';
-- 33151（Onyxian Brood Egg ← 来源行「公式：附魔披风 - 狡诈」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33151 AND `description_loc4`='教你学会永久性地为一件披风附魔，使其获得对怪物造成的威胁值降低2%的效果。';
-- 33153（Ignited Obsidian Scale ← 来源行「公式：附魔手套 - 威胁」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33153 AND `description_loc4`='教你学会永久性地为一双手套附魔，使其获得对怪物造成的威胁值提高2%的效果。';
-- 33154（Ring of Burning Talons ← 来源行「邪恶的南瓜娃娃」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33154 AND `description_loc4`='教你学会召唤这种小伙伴。';
-- 33155（Scaleshield of Obsidian Flight ← 来源行「图鉴：凯蕾的玫瑰」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33155 AND `description_loc4`='教你学会切割凯蕾的玫瑰。';
-- 33157（Broodwarden's Bulwarkblade ← 来源行「图鉴：坠星石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33157 AND `description_loc4`='教你学会切割坠星石。';
-- 33158（Placeholder 1.18.1 Item ← 来源行「图鉴：刀锋之石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33158 AND `description_loc4`='教你学会切割刀锋之石。';
-- 33159（Placeholder 1.18.1 Item ← 来源行「图鉴：琥珀之血」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33159 AND `description_loc4`='教你学会切割琥珀之血。';
-- 33160（Placeholder 1.18.1 Item ← 来源行「图鉴：永恒之钻」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33160 AND `description_loc4`='教你学会切割永恒之钻。';
-- 33163（Epaulets of Faith ← 来源行「飞艇上的货物」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33163 AND `description_loc4`='它似乎没有在坠毁事故中受到任何损伤……几乎没有。';
-- 33164（Vestments of Faith ← 来源行「永燃火炬」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33164 AND `description_loc4`='这些东西是如何保持一直燃烧的？肯定是魔法！';
-- 33165（Wristbands of Faith ← 来源行「公式：附魔武器 - 强效敏捷」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33165 AND `description_loc4`='教你学会永久性地为一件近战武器附魔，使其获得敏捷+20的效果。该装备等级不得低于35级。';
-- 33166（Handwraps of Faith ← 来源行「帕格的超粘稠鱼肉酱」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33166 AND `description_loc4`='一罐你所见过的最粘稠的鱼肉酱。';
-- 33174（Trousers of Pestilence ← 来源行「设计图：怒钢护肩」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33174 AND `description_loc4`='教你学会制作怒钢护肩。';
-- 33186（Spices of the Lost World ← 来源行「设计图：精金武器链」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33186 AND `description_loc4`='教你学会制作精金武器链。';
-- 33187（Fallen One Shackles ← 来源行「低语峡谷宝石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33187 AND `description_loc4`='未经切割，具备一定价值。';
-- 33188（Pan of Po'rool ← 来源行「低语峡谷矿石碎块」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33188 AND `description_loc4`='看起来非常诡异的矿石。';
-- 33205（Skull of Larnaea ← 来源行「图样：阴影徘徊者胸甲」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33205 AND `description_loc4`='教你学会制作阴影徘徊者胸甲。';
-- 33209（Cloak of the Veteran ← 来源行「配方：多彩奇迹合剂」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33209 AND `description_loc4`='教你学会制作多彩奇迹合剂。';
-- 33211（Smuggled First War Insignia ← 来源行「刀锋天使的钱币腰带」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33211 AND `description_loc4`='接受募捐。';
-- 33224（Subterfuge Epaulets ← 来源行「幽灵虎缰绳」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33224 AND `description_loc4`='教你学会召唤这种坐骑。';
-- 33225（Assassins’ Hood ← 来源行「迅捷幽灵虎缰绳」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33225 AND `description_loc4`='教你学会召唤这种坐骑。';
-- 33234（Slippers of Cold Calculations ← 来源行「草莓冰沙」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33234 AND `description_loc4`='好冷！';
-- 33236（Skirmisher's Cache ← 来源行「“经典款”马戏团泡沫饮料」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33236 AND `description_loc4`='说真的，要是给它起名叫“新款马戏团泡沫饮料”是不是太傻了点？';
-- 33254（Shield of Wailing Souls ← 来源行「森林陆行鸟腿」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33254 AND `description_loc4`='好大！';
-- 33289（Digested Slayer's Pauldrons ← 来源行「亚勒伯龙攻击计划」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33289 AND `description_loc4`='详细描述了乘坐冰霜巨龙格拉希恩突袭西部卫戍要塞的攻击计划。';
-- 33292（Elberetha's Scepter of Agitation ← 来源行「万圣节头盔」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33292 AND `description_loc4`='这个洞是留给你的脑袋的……';
-- 33305（Vor’ethil, the Broken Shadow ← 来源行「图鉴：胡里奥之心」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33305 AND `description_loc4`='教你学会切割胡里奥之心。';
-- 33306（Cloak of Unwavering Will ← 来源行「赛羊缰绳」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33306 AND `description_loc4`='羊儿，你快些跑！';
-- 33307（Choker of Endless Insomnia ← 来源行「公式：附魔武器 - 斩杀」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33307 AND `description_loc4`='教你学会永久性地为一把近战武器附魔，使其获得有一定几率爆击等级+120的效果。该装备等级不得低于60级。';
-- 33314（Eyes of the Sightless ← 来源行「维库升华卷轴」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33314 AND `description_loc4`='一张龙皮卷轴，上面描绘着某种神秘的维库人仪式。';
-- 33316（Kilt of Futile Sacrifices ← 来源行「奥术光辉宝典」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33316 AND `description_loc4`='看来元素的力量破坏了这样物品，上面的文字已无法辨识。';
-- 33330（Ephanel, Dawn of Ruination ← 来源行「因格瓦尔的徽记」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33330 AND `description_loc4`='你在考虑怎样才能在拿着东西的时候显得不那么失礼……';
-- 33333（Furbolg Medicine Wristwraps ← 来源行「卡尔玛的希望披风」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33333 AND `description_loc4`='万事有果必有因';
-- 33339（Ritualistic Leggings ← 来源行「维库升华卷轴」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33339 AND `description_loc4`='一张龙皮卷轴，上面描绘着某种神秘的维库人仪式。';
-- 33345（Treads of the Pathfinder ← 来源行「维库升华卷轴」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33345 AND `description_loc4`='一张龙皮卷轴，上面描绘着某种神秘的维库人仪式。';
-- 33346（Ursa's Rampage ← 来源行「维库升华卷轴」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33346 AND `description_loc4`='一张龙皮卷轴，上面描绘着某种神秘的维库人仪式。';
-- 33347（Belt of Unclouded Guidance ← 来源行「亚勒伯龙攻击计划」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33347 AND `description_loc4`='驾驶冰霜巨龙格拉希恩袭击冬蹄村的计划书。';
-- 33352（Elder Wand ← 来源行「硬羊肉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33352 AND `description_loc4`='对雪怪来说只能算是点心。';
-- 33355（Moonwhisper Berry Bush ← 来源行「龙颅石板」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33355 AND `description_loc4`='石板表面上写满了奇怪的符文和记号。';
-- 33387（Burden of the Ursa ← 来源行「格罗菲尔德的包裹」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33387 AND `description_loc4`='包裹里装着密码表和石板。';
-- 33420（Veteran's Plate Legguards ← 来源行「被感染的始祖龙崽样本」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33420 AND `description_loc4`='嗯，它是绿色的。当然，有可能只是试剂颜色的关系……';
-- 33450（Partisan's Chain Legguards ← 来源行「雕刻过的号角」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33450 AND `description_loc4`='一只巨大的羊角，已经雕刻成了可以吹奏的乐器，但是还没有加上装饰品。';
-- 33471（Executor's Dreadweave Shoulders ← 来源行「双趾拖鞋」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33471 AND `description_loc4`='不是巨魔的话穿上它会感到有些不舒服。';
-- 33477（Combatant's Mail Spaulders ← 来源行「雪怪的午餐」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33477 AND `description_loc4`='可以喂饱一只巨型雪怪的午餐。';
-- 33484（Partisan's Mail Armor ← 来源行「多莉的拥抱」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33484 AND `description_loc4`='简直是无价之宝。';
-- 33487（Partisan's Mail Boots ← 来源行「被陷阱捕获的猎物」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33487 AND `description_loc4`='一只小动物的尸体。当它迈出那错误的一步时，噩运就已经注定了。';
-- 33492（Veteran's Mail Leggings ← 来源行「托尔贝恩」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33492 AND `description_loc4`='你认得这把斧头……';
-- 33541（Partisan's Dragonhide Boots ← 来源行「矮人酒桶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33541 AND `description_loc4`='什么？疯掉的矮人怎么能品味美酒呢？';
-- 33605（Corpsman's Lamellar Gloves ← 来源行「冰冷核心」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33605 AND `description_loc4`='一小块冰元素的晶莹剔透的核心。';
-- 33614（Field Medic's Lamellar Faceguard ← 来源行「药剂师的空瓶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33614 AND `description_loc4`='你的尝试失败了，不过瓶子还完整无损。再试一次应该不会有事吧？会吗？不会吧？';
-- 33617（Field Medic's Lamellar Gloves ← 来源行「均衡的溶液」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33617 AND `description_loc4`='成功啦！';
-- 33620（Tactician's Headdress ← 来源行「药剂师的包裹」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33620 AND `description_loc4`='看看里面这些东西！被遗忘者为何如此邪恶？！';
-- 33621（Tactician's Satin Mantle ← 来源行「药剂喷雾」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33621 AND `description_loc4`='最新款的喷雾型天灾！';
-- 33622（Tactician's Satin Vestments ← 来源行「图鉴：残酷之大地风暴钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33622 AND `description_loc4`='教你学会切割残酷之大地风暴钻石。';
-- 33782（Executor's Dragonhide Helmet ← 来源行「稳固水玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33782 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 33783（Executor's Dragonhide Epaulets ← 来源行「图鉴：稳固水玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33783 AND `description_loc4`='教你学会切割稳固水玉。';
-- 33784（Executor's Dragonhide Hauberk ← 来源行「黑暗符印碎块」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33784 AND `description_loc4`='这块符印裂成了五片。';
-- 33792（Corpsman's Dragonhide Leggings ← 来源行「设计图：铜质重剑」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33792 AND `description_loc4`='教你学会制作铜质重剑。';
-- 33804（Field Medic's Dragonhide Leggings ← 来源行「被毁掉的结构图」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33804 AND `description_loc4`='这张结构图已经被元素彻底毁掉了。';
-- 33809（Tactician's Satin Gloves ← 来源行「阿曼尼战熊」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33809 AND `description_loc4`='教你学会召唤这种坐骑。';
-- 33814（Strategist's Satin Vestments ← 来源行「克里丹的羽饰法杖」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33814 AND `description_loc4`='经过一场激烈的战斗之后，法杖上的羽毛有些凌乱，但无伤大雅。';
-- 33815（Strategist's Satin Gloves ← 来源行「刃拳的印记」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33815 AND `description_loc4`='这个印记是使用最坚硬的金属熔铸而成的，上面刻着刃拳酋长的徽记。';
-- 33816（Strategist's Satin Pants ← 来源行「牙牙的小桶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33816 AND `description_loc4`='教你学会召唤这种小伙伴。';
-- 33818（Executor's Headdress ← 来源行「毒皮的小桶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33818 AND `description_loc4`='教你学会召唤这种小伙伴。';
-- 33819（Executor's Satin Mantle ← 来源行「符文样本」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33819 AND `description_loc4`='从一名石巨人身上凿下来的、刻满符文的石块。';
-- 33821（Executor's Satin Gloves ← 来源行「夸格米拉之心」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33821 AND `description_loc4`='三颗心中的一颗，看起来有点像洋葱。';
-- 33826（Corpsman's Satin Vestments ← 来源行「黑色阔步者的卵」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33826 AND `description_loc4`='它散发出生命的脉动。';
-- 33827（Corpsman's Satin Gloves ← 来源行「督军的论文」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33827 AND `description_loc4`='这篇洋洋洒洒数千页长的文章经过防水处理，上面写满了纳迦的文字。';
-- 33833（Physician's Satin Gloves ← 来源行「纳杉的骑鞭」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33833 AND `description_loc4`='被它抽一下想必很疼。';
-- 33834（Physician's Satin Pants ← 来源行「艾吉斯的冠羽」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33834 AND `description_loc4`='这些羽毛看起来非常鲜艳美丽。';
-- 33835（Physician's Satin Sandals ← 来源行「沙法尔的精致饰物」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33835 AND `description_loc4`='这是节点亲王沙法尔的魔法能量来源。真可惜，你根本不知道该如何使用它。';
-- 33836（Field Medic's Headdress ← 来源行「主教的灵魂宝钻」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33836 AND `description_loc4`='很难相信这颗宝石中居然装着许多牺牲者的灵魂。不过，你的确可以感觉到从里面传来的躁动。';
-- 33839（Field Medic's Satin Gloves ← 来源行「炖卡利鸟」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33839 AND `description_loc4`='终于可以复仇了！美味多汁的卡利鸟肉，啃起来果然是大快人心。';
-- 33840（Field Medic's Satin Pants ← 来源行「摩摩尔的低语」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33840 AND `description_loc4`='教授说得对，摩摩尔的“低语”真的有物质形态！';
-- 33844（Combatant's Leather Chestpiece ← 来源行「一桶鱼」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33844 AND `description_loc4`='贴着一个警告标签，上面写着：不要开枪。';
-- 33847（Combatant's Leather Footguards ← 来源行「时空猎手的徽记」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33847 AND `description_loc4`='只要那位客户的墙面空间够大，这枚徽记看起来就不会太突兀。';
-- 33848（Partisan's Leather Mask ← 来源行「恶魔烧烤」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33848 AND `description_loc4`='闻起来很香！';
-- 33850（Partisan's Leather Chestpiece ← 来源行「灵魂之汤」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33850 AND `description_loc4`='这不是什么心灵鸡汤，但肯定对你的灵魂大有好处！';
-- 33851（Partisan's Leather Handgrips ← 来源行「烹饪锅」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33851 AND `description_loc4`='只能在纳格兰的先祖之地使用。';
-- 33852（Partisan's Leather Leggings ← 来源行「烹饪锅」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33852 AND `description_loc4`='需要深渊烈焰使者的炽热尸体。';
-- 33854（Veteran's Leather Mask ← 来源行「来历不明的眼球」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33854 AND `description_loc4`='也许它曾属于某只动物，也许不是。';
-- 33855（Veteran's Leather Epaulets ← 来源行「失去光泽的银戒指」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33855 AND `description_loc4`='这枚戒指也曾光鲜过。';
-- 33856（Veteran's Leather Chestpiece ← 来源行「货物列表」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33856 AND `description_loc4`='水和血迹令这张清单模糊不清，无法阅读。';
-- 33857（Veteran's Leather Handgrips ← 来源行「一箱肉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33857 AND `description_loc4`='主要是肉类，还有一些杂七杂八的东西。';
-- 33858（Veteran's Leather Leggings ← 来源行「埃欧努斯的沙漏」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33858 AND `description_loc4`='这里面的沙粒在向上流！';
-- 33859（Veteran's Leather Footguards ← 来源行「扭木碎片」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33859 AND `description_loc4`='很难想象那些德鲁伊们居然认为他们可以从这么小的一块木片上培育出一个巨大的古树。';
-- 33860（Pendant of Reborn Vigor ← 来源行「帕萨雷恩的投影仪」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33860 AND `description_loc4`='原来这就是他可以到处出现的秘密！';
-- 33861（Rootbark Treads ← 来源行「斯克瑞斯的卷轴」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33861 AND `description_loc4`='你完全看不懂卷轴上所写的字。事实上，即便只是看一眼，你也觉得头痛！';
-- 33865（Tempestria's Crown ← 来源行「阿曼尼妖术之杖」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33865 AND `description_loc4`='这是可靠的反妖术手段，伙计！';
-- 33869（Shalandis Staff ← 来源行「食谱：烤血鳞鱼」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33869 AND `description_loc4`='教你学会烹制烤血鳞鱼。';
-- 33870（Blackroot Wraps ← 来源行「食谱：骨鱼汤」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33870 AND `description_loc4`='教你学会烹制骨鱼汤。';
-- 33871（Shield of Alah'thalas ← 来源行「食谱：风暴牛排」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33871 AND `description_loc4`='教你学会烹制风暴牛排。';
-- 33873（Starglass Monocle ← 来源行「食谱：热辣塔布羊排」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33873 AND `description_loc4`='教你学会烹制热辣塔布羊排。';
-- 33874（Moonstride Leggings ← 来源行「金布勒宠物食品」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33874 AND `description_loc4`='爱宠佳肴，猎人认证。';
-- 33875（Hope of Nendis ← 来源行「食谱：金布勒宠物食品」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33875 AND `description_loc4`='教你学会烹制金布勒宠物食品。';
-- 33925（Placeholder 1.18.1 Item ← 来源行「食谱：美味巧克力蛋糕」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33925 AND `description_loc4`='教你学会烘焙美味巧克力蛋糕。';
-- 33926（Placeholder 1.18.1 Item ← 来源行「密封的卷轴盒」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33926 AND `description_loc4`='密封的小盒子。';
-- 33928（Placeholder 1.18.1 Item ← 来源行「空骨瓶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33928 AND `description_loc4`='象牙制成的容器——确实是象牙没错吧？';
-- 33954（Placeholder 1.18.1 Item ← 来源行「设计图：正义力量之锤」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33954 AND `description_loc4`='教你学会制作正义力量之锤。';
-- 33955（Placeholder 1.18.1 Item ← 来源行「美酒节礼品券」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33955 AND `description_loc4`='兑换一只免费的美酒节酒杯';
-- 33956（Placeholder 1.18.1 Item ← 来源行「回音群岛自酿酒」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33956 AND `description_loc4`='不到一品脱！';
-- 33961（Placeholder 1.18.1 Item ← 来源行「天灾设备」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33961 AND `description_loc4`='看起来真奇怪。也许探险者亚伦会对此感兴趣？';
-- 33962（Placeholder 1.18.1 Item ← 来源行「天灾设备」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33962 AND `description_loc4`='看起来真奇怪。也许药剂师安娜斯塔西娅会对此感兴趣？';
-- 33976（Placeholder 1.18.1 Item ← 来源行「美酒节赛羊」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33976 AND `description_loc4`='教你学会召唤这种坐骑。';
-- 33977（Placeholder 1.18.1 Item ← 来源行「迅捷美酒节赛羊」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33977 AND `description_loc4`='教你学会召唤这种坐骑。';
-- 33978（Placeholder 1.18.1 Item ← 来源行「“荣誉酿酒商”戳印」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33978 AND `description_loc4`='可以凭此证明在赛羊会学徒处购买美酒节赛羊。';
-- 33987（Placeholder 1.18.1 Item ← 来源行「Indalamar's Ring of 」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33987 AND `description_loc4`='我X！太猛了！';
-- 33993（Placeholder 1.18.1 Item ← 来源行「魔汁」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33993 AND `description_loc4`='教你学会召唤这种小伙伴。';
-- 33997（Placeholder 1.18.1 Item ← 来源行「Indalamar's Ring of 」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33997 AND `description_loc4`='我[马赛克]，太猛了！';
-- 33999（Placeholder 1.18.1 Item ← 来源行「塞纳里奥作战角鹰兽」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=33999 AND `description_loc4`='教你学会召唤这种坐骑。这是一种飞行坐骑。';
-- 40000（Tomato ← 来源行「诡秘秋色石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=40000 AND `description_loc4`='对应黄色插槽。';
-- 40001（Delicious Pizza ← 来源行「闪光血玉石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=40001 AND `description_loc4`='对应红色插槽。';
-- 40003（Vault's Defender ← 来源行「精准血玉石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=40003 AND `description_loc4`='对应红色插槽。';
-- 41120（Lynx Steak ← 来源行「设计图：强化钴质腿铠」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41120 AND `description_loc4`='教你学会制作强化钴质腿铠。';
-- 41122（Feltouched Letter ← 来源行「设计图：强化钴质胸甲」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41122 AND `description_loc4`='教你学会制作强化钴质胸甲。';
-- 41123（Charged Arcane Crystal ← 来源行「设计图：强化钴质头盔」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41123 AND `description_loc4`='教你学会制作强化钴质头盔。';
-- 41124（Wildhammer Supply Package ← 来源行「设计图：强化钴质护肩」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41124 AND `description_loc4`='教你学会制作强化钴质护肩。';
-- 41133（Mudpaw Hammer ← 来源行「企鹅小叽」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41133 AND `description_loc4`='教你学会召唤企鹅宝宝小叽。';
-- 41285（Black Tie Plum Waistcoat ← 来源行「混乱之天焰钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41285 AND `description_loc4`='只能镶嵌在多彩宝石插槽中。';
-- 41359（Gilnean Jewelry: A Compendium ← 来源行「教徒的魔棒」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41359 AND `description_loc4`='表面上刻有极端邪恶的图画！';
-- 41361（Rummaged Chest ← 来源行「憎恶的弯钩」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41361 AND `description_loc4`='锈迹斑斑，沾满血液。';
-- 41362（Head of Mato'gar ← 来源行「恶鬼的绳子」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41362 AND `description_loc4`='当然，它的外形像是一条绞索。';
-- 41363（Kum'isha's Scroll ← 来源行「天灾精华」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41363 AND `description_loc4`='你不会想要知道的。';
-- 41373（Draconic Focus ← 来源行「巫毒汁」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41373 AND `description_loc4`='真正的力量之源';
-- 41375（Vermillion Crystal ← 来源行「持久之天焰钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41375 AND `description_loc4`='只能镶嵌在多彩宝石插槽中。';
-- 41376（Xylem's Focus Orb ← 来源行「复苏之天焰钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41376 AND `description_loc4`='只能镶嵌在多彩宝石插槽中。';
-- 41377（Drained Crystal Remains ← 来源行「庇护之天焰钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41377 AND `description_loc4`='只能镶嵌在多彩宝石插槽中。';
-- 41378（Glimmering Shard ← 来源行「遗忘之天焰钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41378 AND `description_loc4`='只能镶嵌在多彩宝石插槽中。';
-- 41379（Dark Iron Prospecting Lens ← 来源行「冷酷之天焰钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41379 AND `description_loc4`='只能镶嵌在多彩宝石插槽中。';
-- 41380（Siren Brain ← 来源行「质朴之大地侵攻钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41380 AND `description_loc4`='只能镶嵌在多彩宝石插槽中。';
-- 41381（Zesty Makrura Claw ← 来源行「稳固之大地侵攻钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41381 AND `description_loc4`='只能镶嵌在多彩宝石插槽中。';
-- 41382（Timbermaw Herb Bundle ← 来源行「锋利之大地侵攻钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41382 AND `description_loc4`='只能镶嵌在多彩宝石插槽中。';
-- 41385（Pure Draenethyst Gemstone ← 来源行「充沛之大地侵攻钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41385 AND `description_loc4`='只能镶嵌在多彩宝石插槽中。';
-- 41389（Crystalline Ray of Moonlight ← 来源行「明亮之大地侵攻钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41389 AND `description_loc4`='只能镶嵌在多彩宝石插槽中。';
-- 41396（Jeweled Ruby Ring ← 来源行「永恒之大地侵攻钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41396 AND `description_loc4`='只能镶嵌在多彩宝石插槽中。';
-- 41397（Gemstone of Kara ← 来源行「强能之大地侵攻钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41397 AND `description_loc4`='只能镶嵌在多彩宝石插槽中。';
-- 41398（Expensive Gold Ring ← 来源行「残酷之大地侵攻钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41398 AND `description_loc4`='只能镶嵌在多彩宝石插槽中。';
-- 41400（Ramblings of Ol' Gazeno ← 来源行「雷鸣之天焰钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41400 AND `description_loc4`='只能镶嵌在多彩宝石插槽中。';
-- 41429（Voss' Sizzling Brew ← 来源行「完美致命茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41429 AND `description_loc4`='对应红色或黄色插槽。';
-- 41433（Palatinate Shard ← 来源行「完美精致血石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41433 AND `description_loc4`='对应红色插槽。';
-- 41439（Cobalt Shard ← 来源行「完美诡秘太阳水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41439 AND `description_loc4`='对应黄色插槽。';
-- 41444（Cardinal Shard ← 来源行「完美闪耀血石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41444 AND `description_loc4`='对应红色插槽。';
-- 41445（Gemstone of Zhan ← 来源行「完美秘法太阳水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41445 AND `description_loc4`='对应黄色插槽。';
-- 41446（Dreamwind's Box ← 来源行「完美迅捷太阳水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41446 AND `description_loc4`='对应黄色插槽。';
-- 41447（Soul of the Dreadlord ← 来源行「完美刚硬玉髓石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41447 AND `description_loc4`='对应蓝色插槽。';
-- 41448（Viridian Mushroom ← 来源行「完美圆润太阳水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41448 AND `description_loc4`='对应黄色插槽。';
-- 41449（Flickering Emerald Stone ← 来源行「完美诡秘太阳水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41449 AND `description_loc4`='对应黄色插槽。';
-- 41450（Viridian Incense ← 来源行「完美狡诈暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41450 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41453（Staff of Chen ← 来源行「完美守护者的暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41453 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41454（Throwing Axes of the Amani ← 来源行「完美反光暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41454 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41455（Blackrock Powder ← 来源行「完美神秘暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41455 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41456（Willey Family Crossbow ← 来源行「完美裂纹黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41456 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41457（Bow of Oaks ← 来源行「完美纯净暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41457 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41458（Time-Worn Spear ← 来源行「完美华丽黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41458 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41459（Mournblade ← 来源行「完美纯净暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41459 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41460（Fingerbreaker ← 来源行「完美狡诈暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41460 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41461（Jar of Dirt ← 来源行「完美统御暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41461 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41462（Branch of Eskhandar ← 来源行「完美反光暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41462 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41463（Pouch of Surgical Daggers ← 来源行「完美纯净暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41463 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41464（Hornfang Specialty Mug ← 来源行「完美华丽黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41464 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41465（Thunderbrew Specialty Mug ← 来源行「完美活跃黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41465 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41466（Goldthorn Grog ← 来源行「完美坚强黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41466 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41467（Hornbeard Reserve ← 来源行「完美活跃黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41467 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41468（Thundercrest Lager ← 来源行「完美裂纹黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41468 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41470（Scarlet Schnapps ← 来源行「完美迷雾黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41470 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41471（Silver Hops ← 来源行「完美混沌黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41471 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41472（Red Hops ← 来源行「完美辐光黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41472 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41473（Black Hops ← 来源行「完美纯净暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41473 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41474（Yellow Hops ← 来源行「完美破碎黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41474 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41475（Hillsbrad Hops ← 来源行「完美闪电黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41475 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41476（Stout Hops ← 来源行「完美稳固黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41476 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41477（Upper Half of the Thunderbrew Golden Lag ← 来源行「完美迷雾黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41477 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41478（Lower Half of the Thunderbrew Golden Lag ← 来源行「完美辐光黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41478 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41479（The Golden Hops ← 来源行「完美永恒暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41479 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41480（The Nobles of Northwind ← 来源行「完美混沌黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41480 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41481（The Greatest Minds of Azeroth - Gnomish  ← 来源行「完美轻盈黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41481 AND `description_loc4`='对应黄色或蓝色插槽。';
-- 41482（The Hag of the Woods ← 来源行「完美精确暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41482 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41483（Monster - Sword2H ← 来源行「完美勇士的茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41483 AND `description_loc4`='对应红色或黄色插槽。';
-- 41484（Razorfen Grog ← 来源行「完美致命茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41484 AND `description_loc4`='对应红色或黄色插槽。';
-- 41485（Pristine Ley Crystal ← 来源行「完美轻巧茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41485 AND `description_loc4`='对应红色或黄色插槽。';
-- 41486（Cerement of the Black Rose ← 来源行「完美肆意茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41486 AND `description_loc4`='对应红色或黄色插槽。';
-- 41487（Pall of the Black Rose ← 来源行「完美透明茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41487 AND `description_loc4`='对应红色或黄色插槽。';
-- 41488（Tread of the Black Rose ← 来源行「完美蚀刻暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41488 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41489（Grip of the Black Rose ← 来源行「完美凶猛茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41489 AND `description_loc4`='对应红色或黄色插槽。';
-- 41490（Bands of the Black Rose ← 来源行「完美坚韧茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41490 AND `description_loc4`='对应红色或黄色插槽。';
-- 41491（Black Widow's Guise ← 来源行「完美反光暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41491 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41492（Black Widow's Treads ← 来源行「完美铭文茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41492 AND `description_loc4`='对应红色或黄色插槽。';
-- 41493（Black Widow's Clutch ← 来源行「完美透明茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41493 AND `description_loc4`='对应红色或黄色插槽。';
-- 41494（Mantle of the Night Lord ← 来源行「完美纯净暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41494 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41495（Tortoise-shell Tint ← 来源行「完美高能茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41495 AND `description_loc4`='对应红色或黄色插槽。';
-- 41496（Mid-Autumn Festival Hanfu ← 来源行「完美反光暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41496 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41497（Brown Top Hat ← 来源行「完美鲁莽茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41497 AND `description_loc4`='对应红色或黄色插槽。';
-- 41498（Navy Top Hat ← 来源行「完美坚毅茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41498 AND `description_loc4`='对应红色或黄色插槽。';
-- 41499（Cordovan Top Hat ← 来源行「完美灿烂茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41499 AND `description_loc4`='对应红色或黄色插槽。';
-- 41501（Brown Banded Top Hat ← 来源行「完美轻巧茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41501 AND `description_loc4`='对应红色或黄色插槽。';
-- 41502（Green Banded Top Hat ← 来源行「完美隐秘暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41502 AND `description_loc4`='对应红色或蓝色插槽。';
-- 41503（Black Banded Top Hat ← 来源行「硅藻土」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41503 AND `description_loc4`='非常柔软，在你手中就已经变成了粉末。';
-- 41506（Lady Cavatica's Clutch ← 来源行「花岗岩石块」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41506 AND `description_loc4`='你最多只能拿一块……';
-- 41507（Frock of Thirty-Two Fouettes ← 来源行「巨型爆盐炸弹」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41507 AND `description_loc4`='超超超大号尺码。';
-- 41508（Thirty-Two Fouette Pointe Shoes ← 来源行「机械路霸」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41508 AND `description_loc4`='教你学会驾驶这种超酷的摩托车。';
-- 41557（Curative Animal Salve ← 来源行「精炼闪光矿石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41557 AND `description_loc4`='这块金属在放出恒定的光芒。';
-- 41558（The Slagbinder ← 来源行「狂怒火花」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41558 AND `description_loc4`='这堆灰烬散发出炽热的仇恨。';
-- 41559（Rock Carver ← 来源行「图鉴：秘法太阳水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41559 AND `description_loc4`='教你学会切割秘法太阳水晶。';
-- 41560（Shalestone Amulet ← 来源行「图鉴：风暴玉髓石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41560 AND `description_loc4`='教你学会切割风暴玉髓石。';
-- 41561（Flame of Eternal Searing ← 来源行「图鉴：鲁莽茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41561 AND `description_loc4`='教你学会切割鲁莽茶晶石。';
-- 41562（Flamescale Pike ← 来源行「图鉴：致命茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41562 AND `description_loc4`='教你学会切割致命茶晶石。';
-- 41563（Flamelash Boots ← 来源行「图鉴：肆意茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41563 AND `description_loc4`='教你学会切割肆意茶晶石。';
-- 41564（Emberclaw ← 来源行「图鉴：透明茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41564 AND `description_loc4`='教你学会切割透明茶晶石。';
-- 41565（Cloak of Draconic Madness ← 来源行「图鉴：透明茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41565 AND `description_loc4`='教你学会切割透明茶晶石。';
-- 41566（Webmaster's Ring ← 来源行「图鉴：灿烂茶晶石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41566 AND `description_loc4`='教你学会切割灿烂茶晶石。';
-- 41567（Cavernrock Stompers ← 来源行「图鉴：轻盈黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41567 AND `description_loc4`='教你学会切割轻盈黑玉。';
-- 41568（Torkon's Belt ← 来源行「图鉴：纯净暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41568 AND `description_loc4`='教你学会切割纯净暗影水晶。';
-- 41569（Tattered Orcish Shawl ← 来源行「图鉴：破碎黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41569 AND `description_loc4`='教你学会切割破碎黑玉。';
-- 41570（Idol of Nethalakk ← 来源行「图鉴：辐光黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41570 AND `description_loc4`='教你学会切割辐光黑玉。';
-- 41571（Snickerclaw ← 来源行「图鉴：混沌黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41571 AND `description_loc4`='教你学会切割混沌黑玉。';
-- 41572（Gowlfang's Collar ← 来源行「图鉴：稳固黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41572 AND `description_loc4`='教你学会切割稳固黑玉。';
-- 41573（Mosshide Trousers ← 来源行「图鉴：混沌黑玉」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41573 AND `description_loc4`='教你学会切割混沌黑玉。';
-- 41574（Gnoll Battle Gloves ← 来源行「图鉴：防御者的暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41574 AND `description_loc4`='教你学会切割防御者的暗影水晶。';
-- 41575（Gnoll Hide Cuffs ← 来源行「图鉴：神秘暗影水晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41575 AND `description_loc4`='教你学会切割神秘暗影水晶。';
-- 41576（Dragonmaw Relic ← 来源行「图鉴：朴素血玉石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41576 AND `description_loc4`='教你学会切割朴素血玉石。';
-- 41577（Orcish War Trophy ← 来源行「图鉴：精致血玉石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41577 AND `description_loc4`='教你学会切割精致血玉石。';
-- 41578（Flamekeeper's Robe ← 来源行「图鉴：闪光血玉石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41578 AND `description_loc4`='教你学会切割闪光血玉石。';
-- 41579（Sash of Flamebinding ← 来源行「图鉴：迅捷秋色石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41579 AND `description_loc4`='教你学会切割迅捷秋色石。';
-- 41580（Udor's Pendant ← 来源行「图鉴：刚硬天蓝石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41580 AND `description_loc4`='教你学会切割刚硬天蓝石。';
-- 41686（Durmir's Belongings ← 来源行「图鉴：高能帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41686 AND `description_loc4`='教你学会切割高能帝黄晶。';
-- 41688（Inconspicuous Documents ← 来源行「图鉴：隐秘曙光猫眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41688 AND `description_loc4`='教你学会切割隐秘曙光猫眼石。';
-- 41689（VanCleef's Orders ← 来源行「图鉴：鲁莽帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41689 AND `description_loc4`='教你学会切割鲁莽帝黄晶。';
-- 41690（Maltorius' Missive ← 来源行「图鉴：鲁莽帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41690 AND `description_loc4`='教你学会切割鲁莽帝黄晶。';
-- 41692（Blackrock Coffer Key ← 来源行「图鉴：活跃森林翡翠」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41692 AND `description_loc4`='教你学会切割活跃森林翡翠。';
-- 41693（Deathcap ← 来源行「图鉴：坚强森林翡翠」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41693 AND `description_loc4`='教你学会切割坚强森林翡翠。';
-- 41694（Widow's Frill ← 来源行「图鉴：活跃森林翡翠」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41694 AND `description_loc4`='教你学会切割活跃森林翡翠。';
-- 41697（Bizzbang's Journal ← 来源行「图鉴：华丽森林翡翠」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41697 AND `description_loc4`='教你学会切割华丽森林翡翠。';
-- 41699（Boar Carcass ← 来源行「图鉴：纯净曙光猫眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41699 AND `description_loc4`='教你学会切割纯净曙光猫眼石。';
-- 41701（Elune's Gift ← 来源行「图鉴：纯净曙光猫眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41701 AND `description_loc4`='教你学会切割纯净曙光猫眼石。';
-- 41702（Dress of Lunar Blessing ← 来源行「图鉴：裂纹森林翡翠」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41702 AND `description_loc4`='教你学会切割裂纹森林翡翠。';
-- 41703（Robes of Lunar Eve ← 来源行「图鉴：华丽森林翡翠」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41703 AND `description_loc4`='教你学会切割华丽森林翡翠。';
-- 41704（Lunar Festival Gift Box ← 来源行「图鉴：混乱之天焰钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41704 AND `description_loc4`='教你学会切割混乱之天焰钻石。';
-- 41707（Satchel of Lunar Giving ← 来源行「图鉴：复苏之天焰钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41707 AND `description_loc4`='教你学会切割复苏之天焰钻石。';
-- 41708（Dragonmaw Medallion ← 来源行「图鉴：洞察之大地侵攻钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41708 AND `description_loc4`='教你学会切割洞察之大地侵攻钻石。';
-- 41709（Shatterblade Gauntlets ← 来源行「图鉴：充沛之大地侵攻钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41709 AND `description_loc4`='教你学会切割充沛之大地侵攻钻石。';
-- 41711（Letter from Korlag Doomsong ← 来源行「图鉴：锋利之大地侵攻钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41711 AND `description_loc4`='教你学会切割锋利之大地侵攻钻石。';
-- 41718（Drape of Groldan ← 来源行「图鉴：闪耀血玉石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41718 AND `description_loc4`='教你学会切割闪耀血玉石。';
-- 41719（Stonelink Leggings ← 来源行「图鉴：诡秘秋色石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41719 AND `description_loc4`='教你学会切割诡秘秋色石。';
-- 41720（Earthweaver Kilt ← 来源行「图鉴：圆润秋色石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41720 AND `description_loc4`='教你学会切割圆润秋色石。';
-- 41721（Bulwark of the Old Horde ← 来源行「图鉴：致命帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41721 AND `description_loc4`='教你学会切割致命帝黄晶。';
-- 41722（Rockspeaker Bracers ← 来源行「图鉴：坚韧帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41722 AND `description_loc4`='教你学会切割坚韧帝黄晶。';
-- 41723（Cudgel of Binding ← 来源行「图鉴：裂纹森林翡翠」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41723 AND `description_loc4`='教你学会切割裂纹森林翡翠。';
-- 41724（Dragonmaw Shoulders ← 来源行「图鉴：迷雾森林翡翠」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41724 AND `description_loc4`='教你学会切割迷雾森林翡翠。';
-- 41725（Dragonmaw Battle Bow ← 来源行「图鉴：永恒曙光猫眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41725 AND `description_loc4`='教你学会切割永恒曙光猫眼石。';
-- 41726（Slaver's Gauntlets ← 来源行「图鉴：守护者的曙光猫眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41726 AND `description_loc4`='教你学会切割守护者的曙光猫眼石。';
-- 41727（Blackheart Armor ← 来源行「图鉴：秘法秋色石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41727 AND `description_loc4`='教你学会切割秘法秋色石。';
-- 41728（Leon's Ring ← 来源行「图鉴：风暴天蓝石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41728 AND `description_loc4`='教你学会切割风暴天蓝石。';
-- 41730（Damning Document ← 来源行「图鉴：肆意帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41730 AND `description_loc4`='教你学会切割肆意帝黄晶。';
-- 41732（Yeast ← 来源行「图鉴：透明帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41732 AND `description_loc4`='教你学会切割透明帝黄晶。';
-- 41733（Honey ← 来源行「图鉴：透明帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41733 AND `description_loc4`='教你学会切割透明帝黄晶。';
-- 41734（Sparkling Water ← 来源行「图鉴：灿烂帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41734 AND `description_loc4`='教你学会切割灿烂帝黄晶。';
-- 41735（Enchanted Horse Shoes ← 来源行「图鉴：破碎森林翡翠」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41735 AND `description_loc4`='教你学会切割破碎森林翡翠。';
-- 41736（Pack of Amberglaze Donuts ← 来源行「图鉴：辐光森林翡翠」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41736 AND `description_loc4`='教你学会切割焦虑森林翡翠。';
-- 41737（Bundle of Apples ← 来源行「图鉴：混沌森林翡翠」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41737 AND `description_loc4`='教你学会切割混沌森林翡翠。';
-- 41738（Ingvild's Pie ← 来源行「图鉴：稳固森林翡翠」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41738 AND `description_loc4`='教你学会切割稳固森林翡翠。';
-- 41739（Goody Bag ← 来源行「图鉴：混沌森林翡翠」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41739 AND `description_loc4`='教你学会切割混沌森林翡翠。';
-- 41740（Amber Candle ← 来源行「图鉴：神秘曙光猫眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41740 AND `description_loc4`='教你学会切割神秘曙光猫眼石。';
-- 41741（Northwind Necrology ← 来源行「钴棒」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41741 AND `description_loc4`='附魔师必备的工具。';
-- 41742（Amber Pearl ← 来源行「图鉴：神秘之天焰钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41742 AND `description_loc4`='教你学会切割神秘之天焰钻石。';
-- 41743（Northwind Amber ← 来源行「图鉴：遗忘之天焰钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41743 AND `description_loc4`='教你学会切割遗忘之天焰钻石。';
-- 41744（Chalice of Light ← 来源行「图鉴：冷酷之天焰钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41744 AND `description_loc4`='教你学会切割冷酷之天焰钻石。';
-- 41745（Charred Bone ← 来源行「泰坦神铁棒」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41745 AND `description_loc4`='附魔师必备的工具。';
-- 41747（Tattered Missive ← 来源行「图鉴：狡诈曙光猫眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41747 AND `description_loc4`='教你学会切割狡诈曙光猫眼石。';
-- 41755（Stormreaver Scroll ← 来源行「灭火器」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41755 AND `description_loc4`='保证可以灭掉火焰，以及其它东西。';
-- 41777（Groceries List ← 来源行「图鉴：蚀刻曙光猫眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41777 AND `description_loc4`='教你学会切割蚀刻曙光猫眼石。';
-- 41778（Sir Edrin Vellas, the Gallant Knight - B ← 来源行「图鉴：坚毅帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41778 AND `description_loc4`='教你学会切割坚毅帝黄晶。';
-- 41779（Sir Edrin Vellas, the Gallant Knight - T ← 来源行「图鉴：坚韧帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41779 AND `description_loc4`='教你学会切割坚韧帝黄晶。';
-- 41780（Sir Edrin Vellas, the Gallant Knight - L ← 来源行「图鉴：勇士的帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41780 AND `description_loc4`='教你学会切割勇士的帝黄晶。';
-- 41782（Dragonmaw Orders ← 来源行「图鉴：闪电森林翡翠」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41782 AND `description_loc4`='教你学会切割闪电森林翡翠。';
-- 41783（Head of Geshgan ← 来源行「图鉴：纯净曙光猫眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41783 AND `description_loc4`='教你学会切割纯净曙光猫眼石。';
-- 41784（Stolgaz Documents ← 来源行「图鉴：统御曙光猫眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41784 AND `description_loc4`='教你学会切割统御曙光猫眼石。';
-- 41785（Reachhide Harness ← 来源行「图鉴：反光曙光猫眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41785 AND `description_loc4`='教你学会切割反光曙光猫眼石。';
-- 41786（Scarweave Leggings ← 来源行「图鉴：毁灭之天焰钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41786 AND `description_loc4`='教你学会切割毁灭之天焰钻石。';
-- 41787（Shatterblade Pauldrons ← 来源行「图鉴：雷鸣之天焰钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41787 AND `description_loc4`='教你学会切割雷鸣之天焰钻石。';
-- 41788（Recluse Leg ← 来源行「图鉴：明亮之大地侵攻钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41788 AND `description_loc4`='教你学会切割明亮之大地侵攻钻石。';
-- 41789（Renegade Battle Boots ← 来源行「图鉴：铭文帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41789 AND `description_loc4`='教你学会切割铭文帝黄晶。';
-- 41790（Mirefang Staff ← 来源行「图鉴：精准血玉石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41790 AND `description_loc4`='教你学会切割精准血玉石。';
-- 41791（Dark Iron Component ← 来源行「图鉴：诡秘秋色石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41791 AND `description_loc4`='教你学会切割诡秘秋色石。';
-- 41792（Intricate Part ← 来源行「图鉴：轻巧帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41792 AND `description_loc4`='教你学会切割轻巧帝黄晶。';
-- 41793（Harlekk's Battle Wrench ← 来源行「图鉴：凶猛帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41793 AND `description_loc4`='教你学会切割凶猛帝黄晶。';
-- 41794（Siege Engineer Goggles ← 来源行「图鉴：致命帝黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41794 AND `description_loc4`='教你学会切割致命帝黄晶。';
-- 41795（Vial of Entranced Blood ← 来源行「图鉴：永恒曙光猫眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41795 AND `description_loc4`='教你学会切割永恒曙光猫眼石。';
-- 41796（Dark Essence ← 来源行「图鉴：反光曙光猫眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41796 AND `description_loc4`='教你学会切割反光曙光猫眼石。';
-- 41797（The Pendant of Uth'okk ← 来源行「图鉴：质朴之大地侵攻钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41797 AND `description_loc4`='教你学会切割质朴之大地侵攻钻石。';
-- 41798（The Pendant of Uth'okk ← 来源行「图鉴：鼓舞之大地侵攻钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41798 AND `description_loc4`='教你学会切割鼓舞之大地侵攻钻石。';
-- 41799（Damaged Relic Mechanism ← 来源行「图鉴：永恒之大地侵攻钻石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41799 AND `description_loc4`='教你学会切割永恒之大地侵攻钻石。';
-- 41815（Farseer's Loop ← 来源行「高级冰刺长矛」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41815 AND `description_loc4`='100%更加冰冷！';
-- 41817（Hood of Foresight ← 来源行「图鉴：圆润秋色石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41817 AND `description_loc4`='教你学会切割圆润秋色石。';
-- 41818（Scepter of Yor'thegg ← 来源行「图鉴：精确曙光猫眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41818 AND `description_loc4`='教你学会切割精确曙光猫眼石。';
-- 41820（Favor of Fallwind ← 来源行「图鉴：防御者的曙光猫眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41820 AND `description_loc4`='教你学会切割防御者的曙光猫眼石。';
-- 41843（Stoutheart Shawl ← 来源行「维林的锁链钥匙」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=41843 AND `description_loc4`='维库人的尺寸。';
-- 42138（Elder's Missive ← 来源行「图鉴：致密天蓝石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42138 AND `description_loc4`='教你学会切割致密天蓝石。';
-- 42142（Simple Leaves ← 来源行「朴素龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42142 AND `description_loc4`='对应红色插槽。';
-- 42143（Shade Leaves ← 来源行「精致龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42143 AND `description_loc4`='对应红色插槽。';
-- 42144（Slithering Worm ← 来源行「闪耀龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42144 AND `description_loc4`='对应红色插槽。';
-- 42145（Tropical Leaves ← 来源行「火花龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42145 AND `description_loc4`='对应蓝色插槽。';
-- 42146（Star Leaves ← 来源行「火花龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42146 AND `description_loc4`='对应蓝色插槽。';
-- 42148（Dead Leaves ← 来源行「闪耀龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42148 AND `description_loc4`='对应红色插槽。';
-- 42149（Bundle of Simple Sticks ← 来源行「圆润龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42149 AND `description_loc4`='对应黄色插槽。';
-- 42150（Bundle of Bright Wood Sticks ← 来源行「迅捷龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42150 AND `description_loc4`='对应黄色插槽。';
-- 42151（Bundle of Shade Wood Sticks ← 来源行「诡秘龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42151 AND `description_loc4`='对应黄色插槽。';
-- 42152（Bundle of Tropical Sticks ← 来源行「闪光龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42152 AND `description_loc4`='对应红色插槽。';
-- 42153（Bundle of Star Wood Sticks ← 来源行「圆润龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42153 AND `description_loc4`='对应黄色插槽。';
-- 42154（Sturdy Net ← 来源行「精准龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42154 AND `description_loc4`='对应红色插槽。';
-- 42155（Nutritious Rations ← 来源行「风暴龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42155 AND `description_loc4`='对应蓝色插槽。';
-- 42156（Emergency Parachute ← 来源行「刚硬龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42156 AND `description_loc4`='对应蓝色插槽。';
-- 42157（Sour Northwind Grapes ← 来源行「诡秘龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42157 AND `description_loc4`='对应黄色插槽。';
-- 42158（Sweet Northwind Grapes ← 来源行「秘法龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42158 AND `description_loc4`='对应黄色插槽。';
-- 42159（Sweet Wildhammer Yam ← 来源行「风暴之锤」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42159 AND `description_loc4`='我的小兄弟，愿它陪伴你赢得更多的战斗。';
-- 42172（Heart of Rotvine ← 来源行「图样：红色伐木工衬衫」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42172 AND `description_loc4`='教你学会制作红色伐木工衬衫。';
-- 42173（Grammon’s Tongue ← 来源行「图样：蓝色伐木工衬衫」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42173 AND `description_loc4`='教你学会制作蓝色伐木工衬衫。';
-- 42174（Vial of Purification ← 来源行「图样：黄色伐木工衬衫」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42174 AND `description_loc4`='教你学会制作黄色伐木工衬衫。';
-- 42175（Narkogg’s Medicine Pouch ← 来源行「图样：绿色伐木工衬衫」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42175 AND `description_loc4`='教你学会制作绿色伐木工衬衫。';
-- 42176（Putrid Flower ← 来源行「图样：蓝色工匠衬衫」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42176 AND `description_loc4`='教你学会制作蓝色工匠衬衫。';
-- 42177（Pendant of Dreams ← 来源行「图样：红色工匠衬衫」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42177 AND `description_loc4`='教你学会制作红色工匠衬衫。';
-- 42178（Rite of Resurrection ← 来源行「图样：粗糙工匠衬衫」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42178 AND `description_loc4`='教你学会制作粗糙工匠衬衫。';
-- 42179（Blue Dragon Essence ← 来源行「图样：绿色工匠衬衫」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42179 AND `description_loc4`='教你学会制作绿色工匠衬衫。';
-- 42180（Twisting Rift Crystal ← 来源行「图样：乌纹布」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42180 AND `description_loc4`='教你学会制作乌纹布。';
-- 42181（Netherrich Demon Blood ← 来源行「图样：月影布」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42181 AND `description_loc4`='教你学会制作月影布。';
-- 42182（Saproot Remedy ← 来源行「图样：法纹布」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42182 AND `description_loc4`='教你学会制作法纹布。';
-- 42183（Denwatcher ← 来源行「图样：深渊背包」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42183 AND `description_loc4`='教你学会制作深渊背包。';
-- 42184（Mixologist Stone ← 来源行「图样：冰川背包」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42184 AND `description_loc4`='教你学会制作冰川背包。';
-- 42185（Elixir of Mind's Reach ← 来源行「图样：神秘背包」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42185 AND `description_loc4`='教你学会制作神秘背包。';
-- 42186（Honeycomb Delight ← 来源行「图样：霜纹包」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42186 AND `description_loc4`='教你学会制作霜纹包。';
-- 42187（Formula: Enchant Cloak - Agility ← 来源行「图样：辉煌魔线」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42187 AND `description_loc4`='教你学会制作辉煌魔线。';
-- 42188（Formula: Enchant Cloak - Greater Shadow  ← 来源行「图样：天蓝魔线」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42188 AND `description_loc4`='教你学会制作天蓝魔线。';
-- 42189（Formula: Enchant 2H Weapon - Nature Dama ← 来源行「图样：精魂披风」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42189 AND `description_loc4`='教你学会制作精魂披风。';
-- 42190（Formula: Enchant 2H Weapon - Shadow Dama ← 来源行「图样：死寒披风」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42190 AND `description_loc4`='教你学会制作死寒披风。';
-- 42191（Crystalized Topaz Gemstone ← 来源行「图样：寒冬末日之帽」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42191 AND `description_loc4`='教你学会制作寒冬末日之帽。';
-- 42192（Witherhide Gloves ← 来源行「图样：丝绸碎冰长靴」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42192 AND `description_loc4`='教你学会制作丝绸碎冰长靴。';
-- 42193（Timberclaw Bracers ← 来源行「图样：冰川腰带」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42193 AND `description_loc4`='教你学会制作冰川腰带。';
-- 42194（Deeproot Sash ← 来源行「图样：霜月短裤」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42194 AND `description_loc4`='教你学会制作霜月短裤。';
-- 42195（Ceremonial Furbolg Pendant ← 来源行「图样：光明赐福手套」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42195 AND `description_loc4`='教你学会制作光明赐福手套。';
-- 42196（Timberheart Dreamcatcher ← 来源行「图样：极光便鞋」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42196 AND `description_loc4`='教你学会制作极光便鞋。';
-- 42197（Plans: Elegant Emerald Gemstone ← 来源行「图样：月影长袍」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42197 AND `description_loc4`='教你学会制作月影长袍。';
-- 42198（Bright Wood Arrows ← 来源行「图样：月影手套」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42198 AND `description_loc4`='教你学会制作月影手套。';
-- 42199（Shade Wood Arrows ← 来源行「图样：乌纹长袍」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42199 AND `description_loc4`='教你学会制作乌纹长袍。';
-- 42200（Smooth Ironfeather Arrows ← 来源行「图样：乌纹手套」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42200 AND `description_loc4`='教你学会制作乌纹手套。';
-- 42201（Starfeather Arrows ← 来源行「图样：法纹长袍」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42201 AND `description_loc4`='教你学会制作法纹长袍。';
-- 42202（Enchanted Thorium Shells ← 来源行「图样：法纹手套」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42202 AND `description_loc4`='教你学会制作法纹手套。';
-- 42299（Shattered Platinum Disc ← 来源行「图鉴：精致龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42299 AND `description_loc4`='教你学会切割精致龙眼石。';
-- 42300（Flawless Leopard Pelt ← 来源行「图鉴：闪耀龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42300 AND `description_loc4`='教你学会切割闪耀龙眼石。';
-- 42302（Starshard ← 来源行「图鉴：闪光龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42302 AND `description_loc4`='教你学会切割闪光龙眼石。';
-- 42303（Thobias’s Satchel ← 来源行「图鉴：圆润龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42303 AND `description_loc4`='教你学会切割圆润龙眼石。';
-- 42304（Heart of Ohanzee ← 来源行「图鉴：火花龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42304 AND `description_loc4`='教你学会切割异彩龙眼石。';
-- 42305（Elekk Tusk ← 来源行「图鉴：秘法龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42305 AND `description_loc4`='教你学会切割秘法龙眼石。';
-- 42306（Corrupted Hide of Ursol ← 来源行「图鉴：精准龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42306 AND `description_loc4`='教你学会切割精准龙眼石。';
-- 42307（Runed Elementium Key ← 来源行「图鉴：迅捷龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42307 AND `description_loc4`='教你学会切割迅捷龙眼石。';
-- 42308（Finwald’s Information ← 来源行「图鉴：刚硬龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42308 AND `description_loc4`='教你学会切割刚硬龙眼石。';
-- 42309（Dregheap’s Information ← 来源行「图鉴：闪耀龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42309 AND `description_loc4`='教你学会切割闪耀龙眼石。';
-- 42311（Transmutation Alloy ← 来源行「图鉴：致密龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42311 AND `description_loc4`='教你学会切割致密龙眼石。';
-- 42312（Top Half of the Elementium Lock Blueprin ← 来源行「图鉴：火花龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42312 AND `description_loc4`='教你学会切割火花龙眼石。';
-- 42313（Bottom Half of the Elementium Lock Bluep ← 来源行「图鉴：风暴龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42313 AND `description_loc4`='教你学会切割风暴龙眼石。';
-- 42314（Assembled Lock Materials ← 来源行「图鉴：诡秘龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42314 AND `description_loc4`='教你学会切割诡秘龙眼石。';
-- 42315（Sack of Ravenholdt Gold ← 来源行「图鉴：诡秘龙眼石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42315 AND `description_loc4`='教你学会切割诡秘龙眼石。';
-- 42381（Moonlit Charm ← 来源行「痛苦啤酒」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=42381 AND `description_loc4`='祖达克最好的免费啤酒。';
-- 47007（Lawbringer Greaves ← 来源行「图鉴：鲁莽紫黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47007 AND `description_loc4`='教你学会切割鲁莽紫黄晶。';
-- 47008（Lawbringer Crown ← 来源行「图鉴：反光恐惧石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47008 AND `description_loc4`='教你学会切割反光恐惧石。';
-- 47010（Lawbringer Chestplate ← 来源行「图鉴：精确恐惧石」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47010 AND `description_loc4`='教你学会切割精确恐惧石。';
-- 47011（Lawbringer Bindings ← 来源行「图鉴：致命紫黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47011 AND `description_loc4`='教你学会切割致命紫黄晶。';
-- 47012（Lawbringer Gauntlets ← 来源行「图鉴：坚韧紫黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47012 AND `description_loc4`='教你学会切割坚韧紫黄晶。';
-- 47015（Lawbringer Sabatons ← 来源行「图鉴：勇士的紫黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47015 AND `description_loc4`='教你学会切割勇士的紫黄晶。';
-- 47016（Judgement Helmet ← 来源行「图鉴：透明紫黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47016 AND `description_loc4`='教你学会切割透明紫黄晶。';
-- 47017（Judgement Shoulderguards ← 来源行「图鉴：坚韧紫黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47017 AND `description_loc4`='教你学会切割坚韧紫黄晶。';
-- 47018（Judgement Chestguard ← 来源行「图鉴：灿烂紫黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47018 AND `description_loc4`='教你学会切割灿烂紫黄晶。';
-- 47019（Judgement Wristguards ← 来源行「图鉴：凶猛紫黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47019 AND `description_loc4`='教你学会切割凶猛紫黄晶。';
-- 47020（Judgement Handguards ← 来源行「图鉴：轻巧紫黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47020 AND `description_loc4`='教你学会切割轻巧紫黄晶。';
-- 47021（Judgement Waistguard ← 来源行「图鉴：透明紫黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47021 AND `description_loc4`='教你学会切割透明紫黄晶。';
-- 47022（Judgement Legguards ← 来源行「图鉴：坚毅紫黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47022 AND `description_loc4`='教你学会切割坚毅紫黄晶。';
-- 47023（Judgement Greaves ← 来源行「图鉴：轻巧紫黄晶」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47023 AND `description_loc4`='教你学会切割轻巧紫黄晶。';
-- 47100（Frostfire Epaulets ← 来源行「条纹晨刃豹的缰绳」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47100 AND `description_loc4`='教你学会召唤这种坐骑。';
-- 47101（Frostfire Vestments ← 来源行「赭色白骨战马」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47101 AND `description_loc4`='教你学会召唤这种坐骑。';
-- 47179（Loop of the Earthshatterer ← 来源行「银色军马」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47179 AND `description_loc4`='教你学会召唤这种坐骑。';
-- 47180（Stormhowl Crown ← 来源行「银色战马」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47180 AND `description_loc4`='教你学会召唤这种坐骑。';
-- 47196（Stormhowl Boots ← 来源行「毒皮暴掠幼龙的牙齿」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47196 AND `description_loc4`='迅猛龙换掉的乳牙。莫维克说当换掉20颗乳牙时，就可以骑它上路了。';
-- 47395（Amulet of the Talon ← 来源行「征服之岛荣誉奖章」）
UPDATE `locales_item` SET `description_loc4`='' WHERE `entry`=47395 AND `description_loc4`='为表彰在征服之岛中作战而颁发的奖章';
