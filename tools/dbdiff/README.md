# dbdiff —— 仓库 base dump 与线上 world 库的差异对比

**用途**：回答「线上库是不是少了仓库里的某些内容」。上一轮启动日志里
`reference_loot_template entry 30559/30171/150112 not exist`、AI 事件引用不到脚本、
`generic_scripts` 指向不存在的生物，都是同一个现象：**仓库的 base/增量里有、线上库里没有**。
这个脚本就是用来把这类缺口一次性找出来的。

对比的「仓库侧」= `sql/base/tw_world_*.sql` 叠加 `sql/database_updates/world/*.sql`
（按文件名顺序应用 INSERT/REPLACE/DELETE/UPDATE，得到最终状态）；
「线上侧」= 直接连线上库，或读一份 `mysqldump` 文件。

只用 Python 3 标准库，**不需要** mysql-python/PyMySQL —— 连线上库时是调用 `mysql` 客户端。

## 一、在服务器上直接跑（推荐）

```bash
cd /path/to/tortoise-wow

# 1) 先逐表比行数（只跑 COUNT(*)，很快；解析仓库那侧需要一两分钟，会打印进度）
python3 tools/dbdiff/dbdiff.py --counts \
    --mysql "mysql -h127.0.0.1 -uroot -p你的密码 tw_world" \
    --sql-root sql

# 输出里「线上少 N」的表就是要查的。例如：
#   reference_loot_template   67746  67637   -109  ← 线上少 109

# 1b) 更彻底：逐表按主键全量对比（--counts 会被 upstream 的 DELETE/UPDATE 掩盖，
#     想要「一张不漏」就加 --all-tables，并把补数据脚本都写出来）
python3 tools/dbdiff/dbdiff.py --all-tables --emit-dir /tmp/dbfix \
    --mysql "mysql -h127.0.0.1 -uroot -p你的密码 tw_world" --sql-root sql
#   → /tmp/dbfix/fix_<表名>.sql，逐张确认后导入

# 2) 针对某张表逐行比主键，并生成补数据的脚本
python3 tools/dbdiff/dbdiff.py \
    --mysql "mysql -h127.0.0.1 -uroot -p你的密码 tw_world" \
    --sql-root sql \
    --table reference_loot_template \
    --emit-sql /tmp/fix_reference_loot.sql

# 3) 看一眼生成的 SQL（是 INSERT IGNORE，已存在的行会跳过），确认后导入
mysql -h127.0.0.1 -uroot -p你的密码 tw_world < /tmp/fix_reference_loot.sql
```

## 二、离线跑（把 dump 拿回来对比）

```bash
# 服务器上
mysqldump --single-transaction --skip-lock-tables tw_world > /tmp/tw_world_live.sql

# 本地/服务器上都能跑
python3 tools/dbdiff/dbdiff.py --counts --from-dump /tmp/tw_world_live.sql --sql-root sql
python3 tools/dbdiff/dbdiff.py --from-dump /tmp/tw_world_live.sql --sql-root sql \
    --table creature_ai_scripts --emit-sql /tmp/fix_ai.sql
```

## 三、读输出的注意点

* **「线上少 N」= 真正要处理的缺口**；「线上多 N」只作提示（你们自己的改动、或者仓库那侧
  有 DELETETE/UPDATE 把行改掉了）。
* 比较是按主键（`create_databases.sql` 里的 PRIMARY KEY / 第一个 UNIQUE KEY）；
  没有主键的表只能 `--counts` 比行数。
* 键在做比较前会统一去掉两端空白与引号（仓库里有的是 `12002`、有的是 `'12002'`，MySQL 里是同一个键）。
* `--counts` 只是快筛：如果 upstream 的增量里 DELETE/UPDATE 掉了别的行，行数可能看不出来缺口，
  真正「一张不漏」要看 `--all-tables`（输出里会提示有哪些语句本工具不解析，例如 `INSERT ... SELECT`，
  这些表的期望值可能偏低，需要人工看一眼）。
* 生成的补数据脚本一律 `INSERT IGNORE`，**只补不覆盖**，可以放心重复执行。
* 有些表线上「少」是因为你们的数据是有意精简过的（例如 `pet_spell_list`、`creature_equip_template`
  这种仓库里本来就没有对应 id 的表，会表现为两边都缺、不报差异）。

## 四、顺带自查：池子跨地图混用

内核规定「共用同一个母池的所有刷新点必须都在同一类地图上」（实例化地图包括副本/团队/战场）。
把下面这段贴进你的 SQL 客户端，**期望 0 行**；若某行返回非 0，说明那个母池家族也混了地图，
照 `sql/database_updates/world/20261008161000` 之后的 `*_pool_5665_split_by_map.sql` 的做法拆池即可：

```sql
SELECT pp.mother_pool,
       GROUP_CONCAT(DISTINCT (g.map IN (26,28,30,33,34,35,36,43,47,48,70,90,109,129,189,209,229,230,249,269,
                                        289,309,329,349,389,409,429,469,489,509,529,531,532,533,800,802,807,808,
                                        814,815,816,817,818,819,820,821,822))) AS 有副本有野外
  FROM pool_pool pp
  JOIN pool_gameobject pg ON pg.pool_entry = pp.pool_id
  JOIN gameobject g ON g.guid = pg.guid
 GROUP BY pp.mother_pool
HAVING COUNT(DISTINCT (g.map IN (26,28,30,33,34,35,36,43,47,48,70,90,109,129,189,209,229,230,249,269,289,309,329,349,
                                  389,409,429,469,489,509,529,531,532,533,800,802,807,808,814,815,816,817,818,819,820,821,822))) > 1;
```

（那串地图 id 就是实例化地图清单，来自客户端 `Map.dbc` 的 mapType 1/2/3。）

## 五、想让新池「一次只刷一根」（可选）

`20261008164000_world.sql` 把黑石塔矿脉拆出去时，新池的 `max_limit` 取的是「搬过去的成员数」，
也就是**照旧全部常驻**（和报错之前的效果一致）。想让它像同家族其它子池那样一次只刷一根：

```sql
-- 1) 把新池改成一次只刷一根（把 @new_pool 换成上一步建出来的那个池 id）
UPDATE `pool_template` SET `max_limit` = 1 WHERE `entry` = @new_pool;

-- 2) 成员概率按比例缩放到合计 100（max_limit=1 时内核要求显式概率合计为 100）
SET @sum := (SELECT COALESCE(SUM(`chance`), 0) FROM `pool_gameobject` WHERE `pool_entry` = @new_pool);
UPDATE `pool_gameobject` SET `chance` = ROUND(`chance` * 100 / @sum, 4)
 WHERE `pool_entry` = @new_pool AND @sum > 0;
```

## 六、写完更新文件之后：先过一遍更新器兼容性检查

内核的自动更新器切分语句时**只跟踪引号作用域、不剥注释**，所以 SQL 文件里有两个坑
（我自己就踩了第一个：注释里的 `doesn't` 让整份更新被拒）：

```bash
python3 tools/dbdiff/check_update_file.py sql/database_updates/world/20261008164000_world.sql
# 或者一次检查全部：
python3 tools/dbdiff/check_update_file.py
```

它检查两件事：**结尾是否还处于字符串中**（注释里有落单的英文单引号时会发生）、
**最后一个 `;` 之后是否还有纯注释内容**（更新器会把它当语句执行）。

## 七、补完 base dump 缺口之后的「善后」

把仓库里缺的行整批补进线上库（`fix_*.sql`）之后，日志里会出现一批**新**报错 —— 不是补错了，
而是把上游数据库里的历史包袱也一并搬了进来（这些行在内核里本来就是「加载时跳过」的）：

```
567  Table 'gameobject_loot_template' entry N isn't gameobject lootid and not referenced from loot, and then useless.
520  Table 'creature_loot_template' entry N isn't creature entry and not referenced from loot, and then useless.
159  Spell N listed in `spell_affect` have redundant (same with EffectItemTypeN) data ... skipped.
126  Table 'creature_loot_template' entry N group N has total chance > 100%
 94  Table 'skinning_loot_template' ... useless
 93  Table 'pickpocketing_loot_template' ... useless
 32  Table `npc_trainer` for trainer (Entry: N) has non-learning spell N, ignore
```

两条路：

**A. 让内核自己给出清理脚本（推荐）** —— 内核为这些问题准备了 `LOG_DBERRFIX` 输出，
就是一条条现成的 `DELETE FROM ... WHERE ...;`。默认关闭，在 `mangosd.conf` 里打开即可：

```ini
DBErrorFixFile = "dbfix.log"
```

重启后 `logs/dbfix.log`（或服务器目录下）就是可执行的清理脚本，人工过一遍再执行。

**B. 直接用我准备的脚本**（条件逐条照内核源码写的，只删内核本来就会跳过的行）：

```bash
mysql -h127.0.0.1 -uroot -p tw_world < tools/dbdiff/prune_imported_cruft.sql
```

脚本分两段：前半段「体检」只查不改（先看行数），后半段才是 DELETE。全是 DELETE，可重复执行。
覆盖：无人引用的战利品表条目（creature/gameobject/pickpocketing/skinning/reference）、
`npc_trainer` 的三类非法行、没人使用的 `npc_vendor_template`、内核判定为多余的 `spell_affect` 行。

注意：`has total chance > 100%` 那类是**掉落概率数据本身**的警告（仍会被使用），
清不掉也不该盲删；要处理得按「100/合计」缩放（见本文件第五节的同类做法）。

## 八、`DBErrorFixFile`（内核自己生成的清理脚本）

`mangosd.conf` 里设 `DBErrorFixFile = "dbfix.log"` 后，内核会把「这条数据该怎么写才合法」
的现成 SQL 写进这个文件，形如：

```
DELETE FROM creature_loot_template WHERE entry=1234;      -- 没有任何生物引用这条掉落表
UPDATE creature_template SET `base_attack_time`=2000 WHERE entry=7;   -- 内核运行时已经这么用了
UPDATE creature_loot_template SET ChanceOrQuestChance=ChanceOrQuestChance*0.5 WHERE groupid=1;   -- ⚠️ 缺 entry=
```

**怎么用：**

* `DELETE FROM <掉落表> WHERE entry=N;` —— 可以整批执行（我已经把等价条件写进
  `prune_imported_cruft.sql`，两者条数应当一致：567 gameobject / 520 creature / 94 skinning /
  93 pickpocketing / 18 reference）。
* `UPDATE creature_template SET base_attack_time / ranged_attack_time / equipment_id` —— 可以执行
  （内核加载时本来就把内存里的值改成这个，ObjectMgr.cpp:1339/1345/1423）。
* ⚠️ `UPDATE ... SET ChanceOrQuestChance=ChanceOrQuestChance*X WHERE groupid=N;` —— **不要直接执行**：
  内核打印时漏了 `entry=`，直接跑会把全表同 groupid 的所有行一起缩放。要修就用
  `tools/dbdiff/gen_group_chance_fix.sql`，它按 entry 逐组生成，并且与内核判定完全对齐：
  * 阈值用 **> 101**（内核 `LootMgr.cpp:1294` 就是 `chance > 101.0f`，留了 1% 容差），
    不是 100.01 —— 否则会把内核根本不报的组也一起改；
  * 分母只累加**正值**（内核 `RawTotalChance()` 只算非任务条目），也只缩放正值行，
    任务掉落（负值）是独立判定、不参与竞争，不动它。
  跑完再跑一次不会有命中（幂等）。

  **但更推荐直接从日志生成**（`gen_group_chance_from_log.py`）：内核加载时会跳过一些行
  （`condition_id` 不存在、负引用带条件、maxcount>255、IsValid 失败……），这些行不在掉落组里，
  所以 SQL 端 SUM 全表得出的组集合/分母和内核可能不一致（表现就是条数比日志里报的多）。
  日志里那行括号里的数字就是内核自己算的合计，直接拿来当分母最准：

  ```bash
  # 只喂最新那一份日志（喂多份历史日志会把早已修好的组也列进来，虽然语句自带守卫不会误伤）
  LOG=$(ls -t /data_2T/ts_wow/logs/server_*.log | head -1)
  python3 tools/dbdiff/gen_group_chance_from_log.py "$LOG" > /tmp/fix_group_chance.sql
  grep -c '^UPDATE' /tmp/fix_group_chance.sql
  mysql -h127.0.0.1 -uroot -p tw_world < /tmp/fix_group_chance.sql
  ```

  生成的每条语句都写成 `UPDATE t AS l JOIN (SELECT SUM(...) AS s ...) cur SET ... WHERE ... AND cur.s > 101;`
  —— 只有「当前合计仍然 >101」时才缩放，所以**重复执行、或拿旧日志生成的脚本都不会误伤**。

## 九、⚠️ 一个已经修掉的解析陷阱（`\'` 转义）

`dbdiff` 早期版本的 `split_tuples` / `split_fields` 对 **转义单引号** 处理不对：进了字符串后遇到
`\` 只把反斜杠复制一份、**没有跳过下一个字符**，于是 `'An\'telas'` 里的 `\'` 被当成
「字符串结束」，后面几行的文本会一路粘进同一个字段；同一批里另一些行则整行没被读出来。

影响面（已核对）：只有 **字符串列** 的表会受害 —— 我们导出过的 20 张表里只有
`area_template.name`、`taxi_nodes.name`、`playercreateinfo_spell.note` 是字符串，
其中 note 没有转义字符、不受影响；`area_template` / `taxi_nodes` 需要重修，
修好的脚本是 `sql/database_updates/world/20261008190000_world.sql`
（按修正后的解析把这两张表在 dump 里的全部条目删掉重插，未在 dump 里的自建条目不动）。

现在的实现是：字符串里遇到 `\` 时把「反斜杠 + 下一个字符」一起吃掉；读取时用
`unescape()` 还原真实值（`\'`→`'`、`\\`→`\`…），写出时再由 `sql_literal()` 重新转义，
并做了「原文 → 解析 → 重新生成 → 逐字段比对」的往返验证。

**教训**：任何「导出/回写」的脚本都必须做一次往返验证，光看语句能执行是不够的。

## 十、本次服务端数据清理：结果、遗留与工具（2026-10-08 ~ 09）

### 结果

| | 起始 | 现在 |
|---|---|---|
| 启动 ERROR 行数 | 1423 | 351 |
| 内核 DBErrorFix（`DBErrorFixFile`）待修清单 | 2296 条 | **0** |
| 未定性的报错类别 | 110 类 | **0** |

### 修掉的「真问题」（原本被噪声淹没）

* **131 组掉落概率合计 > 100%** —— 组内按比例竞争但实际概率被压缩，用内核自己的算法缩放回 100；
* **872 条 `creature_template` 数值**（`base_attack_time` / `ranged_attack_time` / `equipment_id`）与运行时不一致
  —— 内核加载时本就在内存里改成这些值（`ObjectMgr.cpp:1339/1345/1423`），写回库让两者一致；
* **1292 条无用掉落表条目 + 77+32 条 `npc_trainer` 非法行 + 159+9 条冗余 `spell_affect` + 16 个闲置商人模板**
  —— 内核加载时本来就会跳过，按内核同款条件清理（`prune_imported_cruft.sql`）；
* **Snowball Wars I/II 本来无法完成的任务** —— 目标写成不存在的 50319/50329/… ，实际应为 60000-60007（Turtle 改过编号）；
* **7 个「伪训练师」** —— 它们身上那 12 行是猎人训练师表被截断复制过来的残留；术士召唤恶魔是**靠任务奖励**学的
  （全库没有任何训练师教召唤），已还原成"发恶魔任务"的本来角色；
* **物品 41914「Shadowlord's Research」缺失的书页正文** —— 从 Turtle 官方 wiki 挖到原文，并补中文译文；
* **代码侧 7 处日志措辞/聚合**（`spell_proc_event` 把世界库说成 spell.dbc、`battleground_template` 打印清零后的 id、
  `creature_movement` 每个路径点各报一遍等）；
* **`area_template` / `taxi_nodes` 名字被写坏**（见第九节的 `\'` 转义坑）—— 用修正后的解析器重建这两张表。

### 剩余 351 行（全部有结论，不需要再动）

| 剩余 | 行数 | 结论 |
|---|---|---|
| `spellcategory_N` | 185 | **不是错**：Turtle 自定义的冷却分组 id |
| `pet_spell_list_id` 101 / `spell_list_id` 12 | 113 | 内容缺口：仓库、1.12 两个库、客户端 DBC 都没有对应数据 |
| `spell_affect misses ...` | 38 | 同上 |
| 拾取 / 剥皮悬空 loot id | 4 | 内容缺口；清字段会丢掉「本该有掉落」的标记，保留 |
| 5 个未落地脚本（`npc_aneka_konko` 等） | 5 | 上游注册了但内容从未落库的死脚本 |
| 奥山信标 `BattleGroundEvent ... Ryson's Beacon` ×2 | 2 | **上游误报**：信标由脚本动态召唤（`battleground_alterac.cpp`），事件只当状态开关用；`battleground_events` 全库只有一处读取（日志用），不影响玩法 |
| `at_moonwhisper_missing_caravans` | 1 | **上游误报**：该 AreaTrigger 脚本已注册，检查只查 creature 脚本注册表 |
| `spell_threat 25918 ... redundant` | 1 | 运行时技能链的重复填充提示（`prev` 与 `req` 两条边都指向它），数据本身干净 |
| `Visibility.Distance.BG` | 1 | 配置项：`mangosd.conf` 里改成 ≤ 533.33 减去 `Visibility.Distance.Grey.Unit`（默认约 532.3） |
| Anticheat 配置路径 | 1 | 与数据库无关（日志里路径是 `/data_NT/...`，疑为配置笔误） |

### 本次的迁移（`sql/database_updates/world/20261008*`）

143000 / 152000 / 153000 / 154500 / 160000 / 161000 / 162000 / 163000 / 164000 / 165000 /
170000 / 171000 / 172000 / 174000 / 180000 / 190000 / 200000 / 201000 / 203000 / 204000 /
205000 / 210000 / 211000 —— 全部**可重复执行**（跑两遍第二遍零变化），并逐份通过
`check_update_file.py`（更新器兼容性）。

> 编号 173000 曾被一条错误判断占用（想把 `spell_threat` 里「0/0/0」的行当空数据删掉），
> 已 revert —— `multiplier = 0` 的语义是「这个技能**不产生威胁**」，是真实机制。

### 数据侧的 5 个坑（按建议顺序阅读）

1. **内核自动更新器不剥注释**（`AutoUpdater.cpp`）：注释里的单数英文单引号会让整份更新被拒
   （`mid-string query at the end of SQL`）；最后一个 `;` 之后的纯注释会被当语句执行。
   写迁移后**必跑** `check_update_file.py`；
2. **`\'` 转义**：任何「导出 → 回写」都要做往返验证（见第九节）；
3. **多行 `INSERT` 撞主键会整条失败**，而更新器不看返回值 → 几千行静默丢失
   （本次 `reference_loot_template`/`skill_line_ability`/`npc_trainer` 的缺口就是这么来的）；
   用 `dbdiff.py --all-tables` 能查出这类缺口；
4. **掉落表 `item` 列的双重含义**：`mincountOrRef >= 0` 是物品 id，`< 0` 是引用组 id
   （`verify_refs.sql` 里已按此区分）；
5. **组概率缩放要按内核算法**：阈值 `> 101`（不是 100.01）、分母只累加正值（`RawTotalChance`）、
   只缩放正值行（`gen_group_chance_from_log.py` 已对齐）。

### 复核命令

```bash
# 启动日志分类（期望约 351 行且构成如上一节表格）
LOG=$(ls -t /data_2T/ts_wow/logs/server_*.log | head -1)
grep ERROR $LOG | sed 's/^[0-9-]* [0-9:.]*ERROR://; s/[0-9]\+/N/g' | sort | uniq -c | sort -rn

# 内核待修清单（期望 0）
wc -l < /data_2T/ts_wow/logs/dbfix.log

# 悬空引用体检（期望绝大多数为 0）
mysql -h127.0.0.1 -uroot -p tw_world < tools/dbdiff/verify_refs.sql
```

## 十一、汉化核对与「逐条定谁更好」的工作流（2026-10-09）

线上库与 `sql/wip_updates/` 里的汉化文件会**各自演进**：库上有后来的人工修订（如
`追踪者奥尔索尔` → `黑暗者纳科格`），文件里则保留着当时生成的版本。两边不能盲目互刷，
所以按「先审阅、再定向覆盖」走：

```bash
# 1) 核对 + 导出审阅表（只读）。TSV 列：file table column entry english repo_value live_value decision
python3 tools/dbdiff/verify_wip_locales.py --dir sql/wip_updates \
    --mysql "mysql -h127.0.0.1 -uroot -p tw_world" --review-out /tmp/locale_review.tsv

# 2) 用编辑器逐行在最后一列填决定：repo（采用仓库译文）/ live（采用线上译文，仅记录）/ skip
#    「english」列是从 creature_template/item_template/... 取来的英文原名 —— 判断谁更准时最关键的参照；
#    若两边都不理想，直接把 repo_value 改成你要的文本，并填 repo。

# 3) 生成并导入定向补丁（只覆盖 decision=repo 的行，带幂等守卫）
python3 tools/dbdiff/gen_locale_patch.py --review /tmp/locale_review.tsv --out /tmp/locale_patch.sql
mysql -h127.0.0.1 -uroot -p tw_world < /tmp/locale_patch.sql
#    生效：mangosd 控制台 `.reload locales_quest`（或对应表）

# 4) 反向（让仓库跟上线上，避免整份重导把好译文冲掉）
python3 tools/dbdiff/sync_wip_from_db.py --dir sql/wip_updates \
    --mysql "mysql -h127.0.0.1 -uroot -p tw_world" --apply    # 默认只生成 .synced，--apply 才覆盖（备份 .bak）
```

判译文的经验法则（本次实操总结）：
* 专名要带间隔号（`基尔罗格·死眼`、`诺拉·汽望`），机翻常常拼成一个词；
* 官方既有译法优先：`Draenethyst` = 德莱尼水晶、`Lifeblood` = 活力、`Orb of …` = …宝珠
  —— 用库里同词根的其它条目反查即可（本次就是靠 9641 Lifeblood Amulet = 活力护符 判定的）；
* 物品名避免「对…的…」这类口语结构，短结构更贴近官方风格；
* 明显机翻残留要覆盖：`的土堆日记`（Muddy Journal）、`隐藏生物烧焦的储物柜`（Hidden Locker）。

## 十二、本机直连数据库（`~/.my.cnf` + `mysql_local.sh`）

不用在命令行里写账号密码，也不用把 `/opt/homebrew/opt/mysql-client/bin/mysql` 加进 PATH：

* **配置文件**：`~/.my.cnf`（权限 600、在仓库之外、不会被提交）
  ```ini
  [client]
  host = 172.18.1.6
  port = 3306
  user = <账号>
  password = <密码>
  default-character-set = utf8mb4
  ```
  本机任何 mysql 客户端都会自动读取它；注意被授权的主机名（MySQL 看到的客户端 IP）。

* **包装脚本**：`tools/dbdiff/mysql_local.sh [库名] [其它参数]`
  自动找 mysql 客户端（PATH 优先，其次 Homebrew 的 mysql-client），并显式读 `~/.my.cnf`。
  所有工具的 `--mysql` 参数都可以直接用它：
  ```bash
  M="$(pwd)/tools/dbdiff/mysql_local.sh tw_world"
  python3 tools/dbdiff/dbdiff.py --counts --mysql "$M" --sql-root sql
  python3 tools/dbdiff/verify_wip_locales.py --dir sql/wip_updates --mysql "$M"
  tools/dbdiff/mysql_local.sh tw_world -e "SELECT COUNT(*) FROM creature"
  ```

* **自检**：`tools/dbdiff/db_status.sh [库名]` —— 打印服务器版本 / 当前账号 / 库列表 /
  几张关键表的行数 / 最近应用的迁移（用来确认账号可用、数据现状一眼可见）。

## 十三、汉化「逐条审译 → 定向覆盖 → 回写仓库」标准流程（2026-10-09）

两边都会演进（仓库文件是译制批次，线上库有后来的人工修订），所以**不能整份重导**，走这条路：

```bash
M="$(pwd)/tools/dbdiff/mysql_local.sh tw_world"

# 1) 导出冲突行（只列「文件与线上不同」的行，含英文原名、线上值、decision 空列）
python3 tools/dbdiff/verify_wip_locales.py --dir sql/wip_updates --mysql "$M" \
        --review-out /tmp/review.tsv

# 2) 逐条填 decision：live（保留线上）/ repo（用文件译文，可先把 repo_value 改成第三版）/ skip
#    再用「按 MD5 精确找差异」的小脚本复核：只有 md5(文件值) != MD5(列) 的行才是真差异
python3 tools/dbdiff/gen_locale_patch.py --review /tmp/review.tsv --out /tmp/patch.sql
python3 tools/dbdiff/check_update_file.py /tmp/patch.sql      # 先过引号/分号体检
tools/dbdiff/mysql_local.sh tw_world < /tmp/patch.sql          # 落库（语句都带幂等守卫）

# 3) 回写仓库：让文件 = 线上，之后重导就是幂等的
python3 tools/dbdiff/sync_wip_from_db.py --dir sql/wip_updates --mysql "$M" \
        --include "locales_quest*.sql,locales_creature.sql,locales_item.sql" --apply

# 4) 收口核对：应报 0 差异
python3 tools/dbdiff/verify_wip_locales.py --dir sql/wip_updates --mysql "$M"
```

**判定「谁更好」的经验法则**（本轮 677 条总结）

* 线上若是「人工修订版」（修掉英文残留、清空格、补标点），**用线上**；仓库文件往往是机翻批次。
* 线上若带**标点转换污染**（`雷克斯洛特—加龙省—加龙省`、`K。E。F。`）→ 用文件里的干净文本。
* **专有名词以库内既有译法为准**：同一个人/物在库里已有官方译名时，新物品名要跟它一致
  （`Kum'isha` 库内任务文本用「库米沙」、`Gulmire` 库内 NPC 是「古尔米瑞」、`Zandara` 是「赞妲拉」…）。
* 库内正文引用过某物品名时（如任务 41311 正文写「带着坦拉尔之握回去」），**以正文为准**改物品名。
* 类型能当判据：`item_template.class=12` 是钥匙/任务物品（不是护甲，`腰带` 这类译法多半是脑补）；
  `inventory_type=7` 是腿部 → `Pants` 官方译「长裤」而非「短裤」。
* 英文里成对出现的词（`Dragonbane` 已是 `巨龙杀手护肩`）→ 新条目跟同一译法。

**本轮新发现的两个坑（都写进工具了）**

1. `mysql --batch` 输出会把 `\n` / `\t` / `\\` 转义。**回写文件前必须先解密再按 MySQL 规则转义**
   （`sync_wip_from_db.py` 原来漏了这一步）：否则 `\r\n` 会被写成真换行外加一个字面 `\n`，
   看似只是排版变化，重导后值就变了。
2. 内核更新器**只数引号、不剥注释**，所以注释里的 `'` / `"` 也会破坏状态机；值里的半角 `"`
   同理（`"` 在更新器眼里是字符串定界符，MySQL 默认不是）。`sql/wip_updates/` 里 29 份文件
   已统一把注释中的引号换成 `’` `“` `”`，值里的半角双引号也换成全角（中文正文本来就该用全角）。
   改完 `check_update_file.py` 29/29 通过，且逐条确认值语义未变。
   **例外**：`locales_page_text.sql` 的值里含 HTML（`<a href="…">`），必须保留半角引号，勿套用此规则。

## 十四、仓库里有什么 / 一次性产物放哪

`tools/dbdiff/` 只放**常用工具**，一次性产物不入库：

| 文件 | 用途 |
|---|---|
| `dbdiff.py` | 仓库 base+增量 与线上库的对比（找缺失/多余行） |
| `verify_wip_locales.py` | 汉化落库核对 + 审阅表导出（MD5 逐条，只读） |
| `sync_wip_from_db.py` | 以线上为准回写 `sql/wip_updates/*.sql`（支持 INSERT 与 UPDATE 两种写法） |
| `gen_locale_patch.py` | 按审阅表生成定向覆盖补丁 |
| `check_update_file.py` | 迁移文件体检（引号/分号状态机，内核更新器同款规则） |
| `gen_group_chance_from_log.py` / `gen_group_chance_fix.sql` | 战利品组概率修正（从内核日志生成） |
| `prune_imported_cruft.sql` / `verify_refs.sql` | 导入残留清理 / 引用校验 |
| `mysql_local.sh` / `db_status.sh` | 本机连库通道与自检 |
| `review/*.md|.tsv` | **决策留档**：人名重译、副名统一、交任务文本审阅表 |
| `review/official_zhcn_extra.sql` | 官方简体对齐里 wip 文件未覆盖的那部分（重建用） |

* `sql/wip_updates/` 是**导入集**：`locales_*.sql` 为常态文件；`locales_name_fixes.sql` 集中放
  所有「带原值条件的修正」（生物/物件/物品名、副名、任务译名），可直接重复导入而不覆盖人工修订。
* 一次性补丁（对官方简体对齐、交任务文本重译、人名重译的正/反 SQL）与一次性分析脚本
  **不进仓库**：它们在 git 历史里可查，同时归档在本机
  `~/.copilot/session-state/<session>/files/dbdiff_archive/`（README 里有清单）。


## 十五、删数据前先跑 `check_delete_ids.py`（2026-10-11 事故）

2026-10-11 服务端**每次玩家登录都 SIGSEGV**：

```
Received SIGSEGV
./mangosd(_ZN6Player13RecallPvPGearEv+0x194)   ← Player::RecallPvPGear()
./mangosd(_ZN12WorldSession17HandlePlayerLoginEP16LoginQueryHolder+0xfa2)
```

根因是 2026-10-08 那次日志清理：`20261008154500_world.sql` 把 `npc_vendor_template` 的
`1277702` / `1279202` 当「没有任何生物的 vendor_id 指向它的孤儿」删掉了 —— 但内核**硬编码**用它们：
`Player::RecallPvPGear()` 在每次登录时用这两份清单回收「非法获得的 PvP 装备」，
模板不在 → `GetNpcVendorTemplateItemList()` 返回 `nullptr` → `vendorList->m_items` 解引用空指针。
（乌龟服自己也踩过：官方更新 `20260509055406_world.sql` 里专门写了一段
"Reinstate the old PvP npc_vendor_template entries to satisfy the RecallPvPGear function"。）

**判据教训**：「没有**数据**引用」不等于「没有**代码**引用」。这类字段（商人物品模板、脚本 id、
区域 id……）常有只给代码用的模板，数据侧当然查不到引用。

所以加了 `tools/dbdiff/check_delete_ids.py`：**写删除类迁移之前跑一遍**，
它把迁移里 `DELETE ... WHERE col IN (...)` 的数字抽出来，去 `src/`（与 `sql/base`）
里找「像在引用一个 id」的地方（命名常量、`case`、比较、查表调用；毫秒/坐标那种普通数字会被过滤）：

```bash
python3 tools/dbdiff/check_delete_ids.py sql/database_updates/world/20261008154500_world.sql
python3 tools/dbdiff/check_delete_ids.py --dir 'sql/database_updates/world/20261008*.sql'
```

输出很短（每个 id 几行上下文），人工判断是不是真能删；有可疑引用时退出码 1。
拿肇事那条迁移跑，它会明确指出：

```
  1279202（来自 npc_vendor_template）
      src/game/Objects/Player.cpp:3262  const uint32 hordeTemplate = 1279202;
```

修复：`20261011090000_world.sql` 重新 `REPLACE INTO` 这两个模板（192 行，取自官方同一段），
`Player::RecallPvPGear()` 同时加了空指针保护（列表缺失只记日志并跳过，不再崩）。


## 十六、两条运维铁律（2026-10-11 事故后补）

### 1. 已应用过的迁移文件**不要改**

内核的自动更新器按「文件名 + **内容 hash**」判断一个迁移是否执行过
（`src/shared/Database/AutoUpdater.cpp`，表 `migrations` 里存 hash）。所以：

* 改任何一个**已经应用**的 `sql/database_updates/world/*.sql`，它的 hash 就变了 →
  下次启动内核会把它当作**新迁移重跑**。
* 重跑 `20261008154500_world.sql` 会把刚恢复的 PvP 商人物品模板**再删一次** → 玩家登录必崩。
* 要修正历史迁移的后果，**写一个新迁移**（`20261011090000_world.sql` 就是这么做的：重新
  `REPLACE INTO` 那两个模板）。
* 同理：**新迁移一旦被内核执行过，也不要再改它**（要改就再写一条新的）。

### 2. 任何「没有数据引用」的删除规则，先排除「代码硬编码引用」

`20261008154500` 的 `npc_vendor_template` 与 `prune_imported_cruft.sql` 里同名规则都写着
`NOT EXISTS (SELECT 1 FROM creature_template WHERE vendor_id = ...)` —— 数据侧看确实没人用，
但内核硬编码用它们，删了就崩。

所以：

* 写删除类 SQL 之前跑 `python3 tools/dbdiff/check_delete_ids.py <文件>`（见第十五节）。
* 子查询式的删除（`DELETE ... WHERE NOT EXISTS (...)`）工具抽不出 id，要**人工逐条对着内核源码过**。
  `prune_imported_cruft.sql` 就是这么过完的，每条规则都注了内核源码位置：
  | 规则 | 内核依据 |
  |---|---|
  | `creature_loot_template` 等「整条没主人」 | 掉落表按 owner 的 loot_id 查（`ObjectMgr.cpp` / `LootMgr.cpp`） |
  | `npc_trainer` 无生物 / 教不存在法术 / 教非学习类法术 | `ObjectMgr::LoadTrainers`：`GetCreatureTemplate` 为空跳过、`Effect[0] != SPELL_EFFECT_LEARN_SPELL` 跳过 |
  | `npc_vendor_template` 没商人使用 | **例外**：1277702/1279202 被 `Player::RecallPvPGear()` 硬编码使用 → 已排除 |
  | `reference_loot_template` 组 0 零概率 | `LootMgr.cpp`：「Zero chance is allowed for grouped entries only … skipped」 |
  | `spell_affect` 两条 | `SpellMgr.cpp`：光环类型不符跳过、与 `EffectItemType` 重复内核判定 redundant 跳过 |
  | `item_loot_template` 非可拾取 | 物品战利品只在物品带 `ITEM_FLAG_LOOTABLE` 时创建 |
  | `areatrigger_tavern` / `spell_script_target` | 对照客户端 DBC / 内核支持的目标类型 |
## 十七、`dbfix.log` 剩余报错的分类（2026-10-11 复核）

崩溃修复后逐类核对了 `dbfix.log` 里的报错，确认**没有一条来自那次清理**，并给出各自的来历：

| 报错 | 数量 | 来历与处置 |
|---|---|---|
| `Table npc_vendor_template has vendor template 1277702/1279202 not used by any vendors` | 2 | **设计如此**：这两个模板只给代码用（`Player::RecallPvPGear`）。**永远不要删**（第十五节的事故）——留着这条日志即可。 |
| `Item (Entry: N) has wrong (not existing) spell category in spellcategory_K (M)` | 174 个物品 | **服务器 DBC 旧**：`DataDir/dbc/SpellCategory.dbc` 只到 1011，而数据用到 1091+（乌龟服新增类别）。修法：把当前乌龟服客户端的 `DBFilesClient/*.dbc` 刷新到 `DataDir/dbc/`。 |
| `Creature (Entry: N) has nonexistent spell list id / pet_spell_list_id (M)` | 14 | 引用的 id 在 **`creature_spells`** 里没有（base dump 里也没有，共 2648 条）→ 上游数据缺口，与本仓库无关。 |
| `Spell N (…) misses spell_affect for effect M` | 38 个法术 | 上游缺口（需要一个 `spell_affect` 行而没有）。**核对过：20261008154500 删掉的 8 个法术一个都不在这 38 个里** —— 删掉的那些都是 mask 与 `EffectItemType` 相同的 redundant 行，内核本来就跳过（见 SpelMgr 的加载检查）。 |
| `Table 'pickpocketing_loot_template' entry 1183 … not exist but used as loot id` / `skinning_loot_template` 61393 | 4 | base dump 里从来没有这些行 → 上游缺口。 |
| `BattleGroundEvent: missing db-data for map:30 …` | 2 | 上游缺口（战场事件的 DB 数据没配）。 |

**核对方法**（可复现）：把内核的校验条件抄成 SQL 再跑一遍，例如 spell_affect 的 misses 判据是
`Effect==6 && aura IN (107,108,109) && EffectItemType==0 && 没有对应行`；用这个精确条件算出的 38 条
与日志逐条对得上，我删的 8 个一个不在其中。

**补充定案（2026-10-11，回答「补的 17 行和那次清理有没有关系」）**：没有关系，三层证据——

1. **集合**：`20261008154500` 删的是 8 个法术的 14 行（12042 eff0/1/2、16166 eff0/1、
   29187/29189/29191 eff0、52507/52508 eff0/1、52845 eff0/1，掩码见 base dump）；
   20261011130000 新补的 17 行涉及 16 个法术 —— **与那 8 个零重叠**，与全部 38 条也零重叠。
2. **存在性**：那 38 条 (entry, effectId) 在**上游 base dump（2026-05-03）+ 全部增量**共 453 条
   `spell_affect` 行里**一条都不存在** → 不是被谁删掉的，是上游从未生成；所以任何「清理造成
   misses」的说法都不成立（要造成 misses，那一行必须曾经存在过）。
3. **机制**：把删掉的 14 行**放回去也不会改变 misses 数量**——其中 12042/29187/29189/29191/
   52507/52508 的槽位光环是 65/64/214/10/138/217，内核第一条判据（必须是 «ADD_FLAT/PCT_MODIFIER、
   ADD_TARGET_TRIGGER、OVERRIDE_CLASS_SCRIPTS»）就跳过；16166 eff1 与 52845 eff0/eff1 虽是修饰型
   光环，但 `EffectItemType` = 2416967683 / 1 / 4 ≠ 0，而 misses 判据要求 `EffectItemType == 0`
   （它们当时是「掩码与 EffectItemType 相同」的 redundant 行）。14 行全部是内核会跳过的死行，
   删掉只让 dbfix.log 少两类噪音；将来若上游把那几个效果改成修饰型光环，按本条列出的
   entry/effectId 从 base dump 里恢复即可。

## 十八、38 条 `misses spell_affect` 与宠物法术表缺口的出处核查（2026-10-12）

「能不能从官方 1.12 库里把这 38 条补出来」——**查证结论：官方库没有，客户端也没有，四个来源都空**。
明细与可执行的分级方案落在 `sql/wip_updates/spell_affect_missing38.sql`（不会被内核自动执行）。

### 1. 掩码到底存在哪（决定「有没有得抄」）

光环 107/108/109 的作用范围是一个 64 位掩码，只有两个存放处：

| 存放处 | 说明 |
|---|---|
| 客户端 Spell.dbc 的 `EffectItemType[effect]` | 库内就是 `spell_template.effectItemType1/2/3`（DB 列 106/107/108 ↔ DBC 索引 103/104/105，这段固定差 3，用 `#11070`=32、`#421 Chain Lightning` 的链目标 3 校验过） |
| 数据库表 `spell_affect` | 内核 `SpellMgr::LoadSpellAffects` 读；若掩码与 `EffectItemType` 相同则判 redundant 并**跳过** |

`misses spell_affect` 的判据是「该效果 `EffectItemType == 0` **且** `spell_affect` 里没有行」——
也就是说这 38 条的效果，**客户端自己没写掩码**，只能在数据库里补。反过来说：
官方 250 行里有 **186 行**的掩码恰好等于客户端同法术的 `EffectItemType` 字段
（135 行在第 1 槽、39 行第 2 槽、12 行第 3 槽）→ 官方那张表本质是**客户端字段的镜像**，
客户端没写的，官方表里必然也没有。

### 2. 四个来源逐个查（复现命令）

```bash
# ① 官方 1.12.1：205 法术 / 250 行，这 38 个 entry 一个都没有；按法术名交叉也没有
grep -cE "\((19491|51341|58238)," /tmp/ref12/off_spell_affect.sql          # → 0

# ② 乌龟服自己的 base dump + 增量：只有 8 个法术的部分槽
grep -oE "\((5134[1-5]|5823[89]|58241),[^)]*\)" sql/base/tw_world_spell_affect.sql
grep -rn "spell_affect" sql/database_updates/world/20260504214035_world.sql | head

# ③ 镜像仓库 TuringKi/turtle-wow-custom：文件字节数/内容与官方一致，无额外信息

# ④ 客户端 Spell.dbc 的掩码槽：这 38 个效果全是 0（= 内核报 misses 的原因）
python3 tools/WowWeb/... # 见 sql/wip_updates/spell_affect_missing38.sql 第二节
```

顺带得到一条**可复用的核对法**：掩码语义 = 「命中哪些法术的 familyFlags」。
乌龟服自己写的 `(58241, 0, 9007199254740992)` 正好等于 Totemic Slam `#45500` 的 familyFlags，
官方 250 行也全部满足该语义。所以「补一条掩码」可以这样自查：

```sql
-- 掩码反查命中清单，必须与天赋描述点名的法术吻合
SELECT name, COUNT(*) FROM spell_template
 WHERE spellFamilyName = <家族> AND (spellFamilyFlags & <掩码>) <> 0 GROUP BY name;
```

### 3. 38 条的三级分类（详见 wip 文件）

| 级 | 条数 | 内容 | 处置 |
|---|---|---|---|
| A | 17 | 描述点名的法术能被掩码**精确**选中（19491/19493 的 32768、29082-29088 的 Stormstrike+Lightning Strike、51486-51488/51798/52977 的 Lightwell 位、51859 的 Lightning Strike、52326 的 Owlkin Frenzy、52364 的两种熊形态、52546 的三个诅咒） | **已落库**：`sql/database_updates/world/20261011130000_world.sql`（spell_affect 263 → 280 行，misses 38 → 21 条） |
| B | 12 | 客户端里这些法术**共用 bit**，掩码会多带出描述之外的法术（51341-51345 会带上 Judgement of the Crusader；51888 会带上 Molten Blast/Rekindled Flame；52701 会带上 Bloodlust/Calm Elements；58238/58239 是「全部伤害法术」的范围问题；58241-58243 三个 Ancient Rites 互相带出） | 掩码已给出，建议上游戏验证后再定 |
| C | 9 | 推不出来：点名的法术 `familyFlags = 0`（Swift Aspects #19552-56、Conjure Mana Gem #3724）、家族是 GENERIC（Counterattack）、描述为空（Faster Bleeds (Hunter)）、废弃法术（45405）、操作数语义未知（Improved Water Shield 的回蓝） | 要么先给目标法术补 familyFlags（另一类改动），要么写 0 掩码行只消日志 |

### 4. 宠物法术表的缺口（同一批 dbfix 报错）

| 报错 | 数量 | 核查结论 |
|---|---|---|
| `Creature (Entry: N) has nonexistent pet_spell_list_id (M)` | 34 个 id / **101 只生物** | 引用的 id 在 `pet_spell_data` 里没有。34 个 id 里 **33 个是连续段 9486–9518（缺 9514）**，另有 503、627600 —— 一整段连号说明是上游**从未生成**这批行，不是被谁删掉。内核 `ObjectMgr.cpp:1375` 查不到就报错、宠物拿不到法术表。官方 1.12 的 `pet_spell_data` 里也没有这个号段。 |
| `Creature (Entry: N) has nonexistent spell list id / pet_spell_list_id (M)` | 5 只生物 | 61244 Brol'ok Mauler、62321 Rotting Resident、62335 Blistering Remains、62341 Slavering Crag Coyote、62361 Stormreaver Drone：`spell_list_id` 指向的 `creature_spells` 行**8 个槽全 0**，内核视为未配置。这三张表都是上游缺口，不是本地清理造成的。 |

```sql
-- 复现：缺失的 pet_spell_list_id（34 个 id，其中 9486-9518 是连续段）
SELECT c.pet_spell_list_id, COUNT(*) FROM creature_template c
 LEFT JOIN (SELECT DISTINCT entry AS id FROM pet_spell_data) p ON p.id = c.pet_spell_list_id
 WHERE c.pet_spell_list_id <> 0 AND p.id IS NULL GROUP BY c.pet_spell_list_id ORDER BY 1;

-- 复现：指向空 creature_spells 行的生物（5 只）
SELECT c.entry, c.name, c.spell_list_id FROM creature_template c
 JOIN creature_spells s ON s.entry = c.spell_list_id
 WHERE c.spell_list_id <> 0 AND s.spellId_1 = 0 AND s.spellId_2 = 0 AND s.spellId_3 = 0 AND s.spellId_4 = 0
   AND s.spellId_5 = 0 AND s.spellId_6 = 0 AND s.spellId_7 = 0 AND s.spellId_8 = 0;
```

### 5. 落库后的复验（2026-10-11）

```sql
-- ① 条数：应 280（= 原 263 + A 级 17）
SELECT COUNT(*) FROM spell_affect;
-- ② 新行是否满足内核加载条件：LEFT JOIN spell_template，检查「法术存在 / effectId ≤ 2 /
--    该槽 Effect = 6 / 该槽 aura ∈ {107,108,109,112}」→ 全表 280 行跑出 0 行
--    （语句见 sql/wip_updates/spell_affect_missing38.sql 第四节）
-- ③ misses 复算：README 第十七节那条判据 SQL 从 38 行降到 21 行（= B 级 12 + C 级 9）
```
生效方式：重启服务端，或控制台 `.reload spell_affect`。

**处置建议**：这两类都是「上游没给数据」，本地能做的只有——① 接受现状（日志留着，如第十七节的
PvP 模板那样「设计如此」）；② 由我们按生物类型补 `pet_spell_data`（需要策划决定每只野兽会什么技能）；
③ 写 0 掩码行/空行把日志消掉（会掩盖真实缺口，不建议）。**目前不做任何改动。**
