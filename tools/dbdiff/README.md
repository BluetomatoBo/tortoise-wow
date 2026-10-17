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

内核的自动更新器切分语句时**会剥 `--` 与 `/* */` 注释**（注释里的引号不参与状态机）。
真正要防的只有两件事：

1. **正文里的引号不闭合** → 整份更新被拒（`mid-string query at the end of SQL`），一条都不执行；
2. **用 `#` 当注释** → 内核**不认 `#`**（只认 `--` 和 `/* */`），那一行的引号/分号会让状态机错位。

> 2026-10-11 修正：本节早先写的是「内核不剥注释，注释里的 `doesn't` 会让整份更新被拒」，
> 与 `src/shared/Database/AutoUpdater.cpp` 的源码不符，也已用线上库反证 —— 仓库里
> **11 个注释含单引号的迁移文件全部被内核成功执行**（`migrations` 表有记录，含当天新写的
> `20261011130000_world`）。`check_update_file.py` 当时没模拟注释作用域，属**误报**，已修。

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

1. **内核自动更新器会剥注释**（`AutoUpdater.cpp` 只认 `--` 与 `/* */`）：注释里的引号无害；
   要防的是**正文里引号不闭合**（整份更新被拒：`mid-string query at the end of SQL`）
   与**用 `#` 当注释**（内核不认 `#`，那一行会被当正文）。写迁移后**必跑**
   `check_update_file.py`；
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
2. 更新器的引号状态机**只作用于正文**（`--`/`/* */` 注释会被剥掉，注释里的引号无害）：
   正文里的 `'` 必须成对，`"` 与 `'` 一样被当字符串定界符（MySQL 默认模式也是，二者一致），
   而 `#` 开头的注释内核**不认**（会被当正文，见第六节）。
   `sql/wip_updates/` 里 29 份文件统一把注释与中文正文里的半角引号换成全角 ——
   这**不是**解析要求（注释里其实无害），而是中文排版风格上的统一；
   **例外**：`locales_page_text.sql` 的值里含 HTML（`<a href="…">`），必须保留半角引号。

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
| `Item (Entry: N) has wrong (not existing) spell category in spellcategory_K (M)` | 174 个物品 | **上游缺口，换客户端 DBC 修不了**（2026-10-12 更正，见第二十二节）：服务器那份 `SpellCategory.dbc` 到 1011，客户端 1.18.1 那份只到 932（更少），而数据用到 1175 → 没有现成文件可用；该字段服务端从不读，只做存在性检查。要消掉只能**按数据生成**一份扩展文件（`tools/dbc_verification/extend_spellcategory.py`）。 |
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

## 十九、「被我清理掉的数据要不要恢复」全量复核（2026-10-11）

用户问「需要恢复的是不是都恢复了，不确定就先安全地全部还原」。用 `dbdiff.py` 把**线上库**与
**仓库 base dump + 全部增量**逐表比了一遍，结论：**需要恢复的只有一处，已恢复；其余删掉的
都是内核根本读不到的行**。

复现：

```bash
python3 tools/dbdiff/dbdiff.py --mysql "$(pwd)/tools/dbdiff/mysql_local.sh tw_world" --counts
# 需要细看某张表： --table <表名> --limit 200   （--emit-sql F 可生成 INSERT IGNORE 补数据脚本）
```

本次「线上比仓库少」的表共 15 张，逐张的判据与结论（判据都能用一条 SQL 复核，见下）：

| 表 | 线上比仓库少 | 为什么内核读不到 |
|---|---|---|
| `npc_vendor_template` | 221 行（16 个模板） | `creature_template.vendor_id` 里 0 命中这 16 个模板 → 没有商人会读它。**崩溃那对 1277702/1279202 已恢复：各 96 行，共 192 行在位**（`SELECT COUNT(*) FROM npc_vendor_template WHERE entry IN (1277702,1279202)`） |
| `creature_loot_template` | 37,197 行（521 个 loot id） | 512 个 loot id 没有被任何生物的 `loot_id` 使用；唯一被用到的 `16042` 只删了 8 行「同组显式概率已满 100% 的 0% 重复条目」（`20261008201000`，带「该组必须还剩显式概率行」守卫）→ 组的行为不变 |
| `gameobject_loot_template` | 13,177 行（567 个 loot id） | 没有 `type IN (3,25)`（CHEST/FISHINGHOLE）物件的 `data1` 指向它们（内核 `GameObjectInfo::GetLootId()` 只认这两类） |
| `pickpocketing_loot_template` | 483 行（93 个 id） | 没有被任何生物的 `pickpocket_loot_id` 使用 |
| `skinning_loot_template` | 299 行（94 个 id） | 没有被任何生物的 `skinning_loot_id` 使用 |
| `reference_loot_template` | 298 行（39 个组） | 没有被任何掉落表的 `-mincountOrRef` 引用 |
| `npc_trainer` | 109 行 | 训练师生物不存在（涉及 1410/4989/5964/5973 等）或教的法术不存在 / 不是 `SPELL_EFFECT_LEARN_SPELL` → 内核 `LoadTrainers` 跳过 |
| `skill_line_ability` | 13 行 | 4 行教库内与客户端都没有的法术（46530/41079/30236/46848），9 行 `skill_id=spell_id=0` 的空行 |
| `creature_movement` | 46 行 | guid `2581433`、`2593426` 在 `creature` 表里不存在（路径指向不存在的 spawn） |
| `creature_ai_events` | 1 行 | `899705` 挂在 `61418 Genn Greymane` 上，而它是 `script_name = genn_greymane` 的脚本生物 → EventAI 行永不执行 |
| `game_graveyard_zone` | 2 行 | 被移到父区域的**子区域重复行**（136→5179、137→406 的父行都在线上，已核） |
| `spell_affect` | 168 行 | 内核判 redundant（掩码 == `EffectItemType`）或光环类型不对，加载时跳过 |
| `spell_effect_mod` | 12 行 | **不是我们删的**：删它的是上游文件 `20260724/20260730/20260801` |
| `item_loot_template` | 56 行（物品 `92010 Holiday Cache`） | 该物品 `flags = 0`（不可拾取）→ 内核不给它建掉落 |
| `locales_area` | 276 行 | **仓库里没有任何 DELETE** → 属于「线上库从来没导入过这批行」的历史缺口，与清理无关 |

**为什么不做「无脑全还原」**：`dbdiff` 对子查询式的 `DELETE` 无法建模，它算出的「仓库有、线上没有」
里混着**上游自己删过**的行——最典型的就是 `spell_affect`：168 行里有 162 条 `DELETE` 来自上游文件
`20260815005950`（工具已提示「本工具判不了的 WHERE 条件」）。补回去等于撤销上游的清理，只会让
`dbfix.log` 重新长出「内核跳过」的噪音，玩法上零影响。真要补，按表挑着补（`--table T --emit-sql F`）
比一把梭安全。

**如果以后想补那 3 张与清理无关的历史缺口**（`item_loot_template` / `locales_area` /
`reference_loot_template` 之类），直接用同一工具生成 `INSERT IGNORE` 即可，与本次事故无关。

## 二十、38 条 `misses spell_affect` 的收口（2026-10-12）

接第十八节（先查出处、给出 A/B/C 分级），用户要求「能从**原始数据 / wowhead / turtle-wow wiki**
挖到依据能判定的都修，查不到就不动」。这轮把五个来源都翻完了，**结论是：外部没有可抄的数据，
只能按「库内已有数据的模式」判定**，最终补了 13 行，剩 8 条留白。

### 1. 又查了哪些来源（都空）

```bash
# ① 上游仓库最新 main（2026-10-12 拉取）：只比我们多两个迁移文件，都不含 spell_affect
curl -s "https://api.github.com/repos/tortoise-wow/tortoise-wow/contents/sql/database_updates/world?ref=main"
# ② 上游 base dump 与本地**字节一致**（说明上游也没填这些槽）
curl -s -o /tmp/up_spell_affect.sql \
  "https://raw.githubusercontent.com/tortoise-wow/tortoise-wow/main/sql/base/tw_world_spell_affect.sql"
md5 -q /tmp/up_spell_affect.sql sql/base/tw_world_spell_affect.sql   # 33e42c81f25ae4698e90305d9ad769d1（同一个）
# ③ 客户端 Spell.dbc 的掩码槽（DBC 103/104/105）：这 38 个法术**全是 0**
# ④ Talent.dbc：38 个里只有 7 个是天赋 rank
# ⑤ 网络：wowhead 403、turtle-wow.org / wiki / database 域名均无连接 → 外部来源不可用
```

### 2. 判定的依据从哪来（方法论）

掩码语义 = 「命中哪些法术的 familyFlags」（官方 250 行里 186 行恰好等于客户端同法术的
`EffectItemType`，可作反证）。于是判定靠**库内同类行的写法**：

| 场景 | 用了哪条库内数据 |
|---|---|
| 同一法术的兄弟槽已有行 | 直接沿用（58238/58239 的 eff1 用 eff0 的 bit；58241 的 eff1 用 eff0 的 bit） |
| 同系列法术有行 | 借位图（58243 用 Hex 自身的位，与兄弟 58240 的写法同源） |
| 同批天赋有掩码 | 照抄（51888 用「Improved Shocks」51851 的 `EffectItemType`） |
| 同类天赋多职业版本 | 找规律（Faster Bleeds 四兄弟 → 「该职业的流血法术」） |
| 「哪个版本的技能才是玩家能放的」 | 用**学习包装法术**判定（`effect 36 LEARN_SPELL` 指向谁，谁就是可施放版本） |

最后一条是本轮的关键：`51341-51345` 的靶子「十字军打击」在库里有两代（bit35 的 2537 系、
bit29 的 45409 系），**47314-47318 这五个学习包装教的是 2537 系**，45409 系没有任何包装
→ 只有 bit35 是玩家真正会施放的版本；这也与乌龟服自己写的
`(51242,0) = bit32|bit35`（「Holy Strike Crusader Strike Cooldown Reduction」）、
`(51355-51359,1) = bit35`（「Vengeful Strikes」）完全吻合。

### 3. 落库结果

`sql/database_updates/world/20261012140000_world.sql`（13 行，REPLACE 幂等）：

| entry | eff | 掩码 | 靶子（反查命中） |
|---|---|---|---|
| 51341-51345 | 0 | 34359738368 | Crusader Strike（bit35，唯一命中） |
| 58238 / 58239 | 1 | 1099511627776 | Earth Shield |
| 58241 | 1 | 9007199254740992 | Totemic Slam / Feral Spirit / Hex（共用 bit53，同一件物品给出） |
| 58242 | 0 | 9007199254743040 | Feral Spirit / Ghost Wolf / Hex / Totemic Slam |
| 58243 | 0 | 9007267974217728 | Hex / Feral Spirit / Totemic Slam |
| 51888 | 1 | 2416967680 | Earth/Flame/Frost Shock（+ 共位的 Molten Blast / Rekindled Flame） |
| 52402 | 0/1 | 274877906944 | Lacerate（猎人唯一的玩家流血技能） |

复验：`spell_affect` **280 → 293** 行；内核判据复算的 misses **21 → 8**；
全表 293 行静态体检（法术存在 / effectId ≤ 2 / 该槽 Effect==6 / aura∈{107,108,109,112}）**0 行有问题**。

### 4. 留白的 8 条（已核明原因，不再尝试）

| entry | 法术 | 留白原因 |
|---|---|---|
| 45405 | [Deprecated] Arcane Potency | 废弃法术，`effectBasePoints = 0`（写行也无效） |
| 45985 | Counterattack | **家族不匹配**：自身 GENERIC(0)，靶子「猫鼬撕咬」是 HUNTER(9) → `isAffectedOnSpell` 第一步就返回 false，写什么掩码都没用 |
| 51369-51371 | Improved Water Shield | op 31（CUSTOM_VALUE_1）**内核没有消费者**；且靶子有两个候选 bit，描述无法定唯一答案 |
| 52603 | Improved Swift Aspects | 靶子 Swift Aspects（#19552-56）`familyFlags = 0` → 任何掩码都选不中 |
| 52690 | Crystal Infusion | 靶子「使用法力宝石」（Replenish Mana #5405）家族 GENERIC、`familyFlags = 0` → 同上 |
| 52701 | Purge Haste Passive | **找不到授予者**（非天赋 rank、不在 item 的 spellid_1..5、无触发链、不在 spell_learn_spell/skill_line_ability；`itemset` 表为空 —— 邻居 52698/52699 是「T2.5 Set Bonus」，疑似客户端套装奖励）；且 bit47 与 Bloodlust/Calm Elements 共用，授予者不明时无法确认是否有害 |

这 8 条会继续在 `dbfix.log` 里各留一行 —— **属于已核明的上游缺口**，不是本地配置错误。
要真正消掉它们，得动内核（实现 op 31/32 的消费者、给 spellmod 加家族例外）或改客户端位图，
都不属于「补数据」范围。

完整记录（含每条掩码的证据链与复现命令）：`sql/wip_updates/spell_affect_missing38.sql`。

## 二十一、宠物法术表缺口：按客户端 `CreatureSpellData.dbc` 补齐（2026-10-12）

dbfix 里 `Creature (Entry: N) has nonexistent pet_spell_list_id (M)` 与
`has nonexistent spell list id (M)` 是**两张不同的表**，这轮只把能查到原始数据的那部分修了。

### 1. 哪张表由谁说话

| 报错 | 查的表 | 原始数据在哪 |
|---|---|---|
| `nonexistent pet_spell_list_id` | `pet_spell_data`（id + 4 个技能） | **客户端 `CreatureSpellData.dbc`**（内核注释：`fill data from DBC as more correct source if available`；同一 id 还会随 `CMSG_CREATURE_QUERY` 发给客户端显示宠物技能） |
| `nonexistent spell list id` | `creature_spells`（8 槽 + 概率/目标/延迟） | 服务端自有的旧社区数据，**客户端里没有对应文件** |

### 2. 新增工具 `tools/WowWeb/gen_pet_spell_data.py`

```bash
# 客户端文件按清单下载 + sha256 校验（与其它生成器同一套缓存），逐行对比线上表
python3 tools/WowWeb/gen_pet_spell_data.py \
    --mysql "tools/dbdiff/mysql_local.sh tw_world" --emit-sql /tmp/pet.sql
# 可选：--vanilla-client ~/Downloads/WoW_Classic  用原版 1.12.1 的同名 DBC 做三方对照
```

结论分三类：**只有客户端有 → 该补**；**两侧都有但客户端多技能 → 该更新**；
**客户端清成 0 / 只有服务端有 → 默认不动**（这是矛盾或乌龟服自己的增删，需人工判断）。

### 3. 本轮判定与落库

`sql/database_updates/world/20261012150000_world.sql`：

* **补 33 行**（9486–9518，客户端 1.18.1 的 CreatureSpellData.dbc 有、线上没有）——
  其中 32 行被 **99 只生物**引用；填上后 `pet_spell_list_id` 解析不了的数量
  从 **34 个 id / 101 只生物**降到 **2 个 id / 2 只生物**。
* **更新 35 行**（线上只有 1 个技能、客户端有 2 个）—— 被 **44 只生物**引用。规律很清楚：
  客户端给每个宠物家族都配了第二个技能（熊 Roar of Fortitude、蟹/龟 Bubble Barrier、
  鳄鱼 Death Roll、蜘蛛 Web、陆行鸟 Strider Presence、狼 Packleader、蝎 Scorpid Poison、
  迅猛龙 Savage Rend……），而且这些技能在库里**都有学习包装**（`effect 36 LEARN_SPELL`
  + trigger = 该技能，内核 `LoadPetCreateSpells` 就是这样把「宠物用的技能」换成
  「可学习的技能」）→ 驯服后宠物会正常学会。乌龟服自己的服务端表停在旧版，客户端更新了。
* 复跑生成器：`两侧一致 354 行`，该补 / 该更新都是 0。

### 4. 没动的部分（查不到可判定的原始数据）

| 对象 | 情况 |
|---|---|
| `pet_spell_data` #9091（Rotting Agam'ar） | **新旧客户端说法相反**：旧版 12,621 字节的 DBC 里是 `(26178 Charge)`（与线上一致），新版 12,765 字节是 `(0,0,0,0)`。单点矛盾，不动。 |
| `pet_spell_data` #61975（Blackwind Villager） | 只有服务端有（客户端两个版本都没有）→ 乌龟服服务端自造，保留。 |
| `pet_spell_data` #503（Crimson Guard Olbreg）、#627600（Blackwind Villager） | 客户端里根本没有这两个 id → 无处可查，保持原样（各留一行日志）。 |
| `creature_spells`：7 只生物（59967 King、62051/62210/62263 Dragonmaw ⋯、62226/62227 Stonehide Boar） `spell_list_id` 指向**不存在的行** | 官方 1.12 的 `creature_spells` 里也没有这些 id → 无出处。 |
| `creature_spells`：5 只生物（61244 Brol'ok Mauler、62321 Rotting Resident、62335 Blistering Remains、62341 Slavering Crag Coyote、62361 Stormreaver Drone）指向 **8 槽全 0 的行** | 其中 4 行的 `probability_1 = 100` 但技能空着 —— 上游写了行忘了填技能；没有出处可抄（同族兄弟的写法只能算推测，不算原始数据），不动。 |

复现口径：

```sql
-- 宠物表缺口（应只剩 503 / 627600 两个 id、2 只生物）
SELECT c.pet_spell_list_id, COUNT(*) FROM creature_template c
  LEFT JOIN (SELECT DISTINCT entry AS id FROM pet_spell_data) p ON p.id = c.pet_spell_list_id
 WHERE c.pet_spell_list_id <> 0 AND p.id IS NULL GROUP BY c.pet_spell_list_id;

-- 生物技能表缺口（7 条不存在 + 5 条全 0，共 12 只生物；无出处）
SELECT c.entry, c.name, c.spell_list_id FROM creature_template c
  LEFT JOIN creature_spells s ON s.entry = c.spell_list_id
 WHERE c.spell_list_id <> 0 AND s.entry IS NULL;
```

## 二十二、服务端 DBC 体检：`SpellCategory.dbc` 的真相与更新包（2026-10-12）

用户要「把服务端要更新的 DBC 放一个文件夹」时做的体检。结论：**43 个服务端会加载的 DBC 里，
只有 `SpellCategory.dbc` 有明确问题，而它恰恰不能靠客户端那份修**。

### 1. 哪些 DBC 是服务端读的

`src/game/Database/DBCStores.cpp` 里 44 处 `LoadDBC(...)`，去重后 **43 个文件名**；格式串在
`DBCfmt.h`（`Spell.dbc` **不**在其中 —— 法术数据走数据库 `spell_template`）。逐个把客户端 1.18.1
的文件取来（客户端清单 sha256 校验），读 DBC 头比字段数：**42/43 与服务端格式串一致**
（第 43 个 `SpellVisual.dbc` 也对得上，只是格式常量写作 `char const SpellVisualfmt[]`，
解析时容易漏掉）。所在键值：

| 客户端来源 | 文件数 | 说明 |
|---|---|---|
| 客户端清单里的 patch 覆盖层（`DBFilesClient/*.dbc`） | 29 | 乌龟服改过的，优先级最高 |
| 客户端 `Data/dbc.MPQ`（4.2 MB，sha256 校验） | 14 | 清单没单列的那些（Emotes、SpellCastTimes、SpellDuration、**SpellCategory** 等） |

### 2. SpellCategory 的四份文件对比

| 来源 | 行数 | 最大 id |
|---|---|---|
| 原版 1.12.1 客户端 | 137 | 1011 |
| 服务器 `DataDir/dbc`（报错来源） | 137 | 1011 |
| 乌龟服 1.18.1 客户端（dbc.MPQ） | 133 | **932** |
| 数据库实际用到 | — | **1176**（物品 1175 / 法术 1176） |

所以「把客户端 DBC 刷新过去」是**降级**，而数据里那 45 个缺号（含 3、5、1031、1051、1071、1091、
1111、1131…1176）在四份文件里都不存在 → 属上游缺口。

### 3. 为什么补 `flags = 0` 是行为等价的

* 服务端只调 `sSpellCategoryStore.LookupEntry(...)` 做**存在性检查**（`ObjectMgr.cpp:2534`），
  `SpellCategoryEntry::Flags` 全源码无人读；也没有 `SPELL_CATEGORY_FLAG_*` 常量。
* 客户端自带的 `Spell.dbc` 用到 1176 分组而随身 SpellCategory 只到 932
  → 客户端对这些分组本来就走「查不到 → 默认」，补 0 与查不到等价。

### 4. 交付物

* 工具：`tools/dbc_verification/extend_spellcategory.py`（并集三份底稿 + 数据里用到的 id，升序输出，
  自带加载校验）。
* 生成文件与更新包（不进仓库）：`~/Desktop/tw-dbc-1.18.1/`
  —— `SpellCategory.dbc`（188 行，最大 1176）、`check_server_dbc.sh`（服务器上只读体检）、
  `client-reference-sha256.txt`（43 个文件的参考哈希）、`README.md`（换法/回滚/判读规矩）。

### 5. 服务器实测收口（2026-10-12）

在 server6 上跑 `check_server_dbc.sh` / `inspect_dbc.sh` 的结果：

* 43 个文件里 **33 个与客户端参考 sha256 相同**，`SpellCategory.dbc` 已换成生成版（1525 字节）；
* 另 **10 个「不一致」的，服务器那份全都更大**（`inspect_dbc.sh` 给出行数/最大 id）：
  SpellCastTimes 52 行/max 191（客户端 50/171）、SpellDuration 86/557（70/427）、
  DurabilityCosts 300/300（100/100）、Emotes 124/428（73/333）、EmotesText 171/366（166/329）、
  NamesProfanity 1538/6382（943/5153）、NamesReserved 2288/5628（1556/4610）、
  SkillRaceClassInfo 204/1009（199/862）、SkillTiers 26/223（25/222）、StableSlotPrices 4/4（2/2）。
  其中 `SpellCastTimes` 的 191 ≥ 数据用到的 190、`SpellDuration` 的 557 = 数据用到的 557
  —— 换成客户端那两份（171/427）会**盖不住**数据 → **这 10 个一律不动**。

**因此结论修正为**：服务端 DataDir 里这套 DBC 是**为服务端扩过的版本**（客户端那份更小），
「从客户端刷新 DBC」不仅修不了 spellcategory，还会让 `castingTimeIndex`/`durationIndex` 的
解析范围倒退。需要动的只有 `SpellCategory.dbc` 一个（按数据生成，见上）。

**语言（locale）说明**：线上是从**纯英文客户端**解出来的，而参考件取自客户端清单（英欧镜像）
—— 带文字的表（ChrRaces/SkillLine/ItemSet/TalentTab/SpellShapeshiftForm…）与线上 **sha256 完全相同**，
说明两边同为 enUS。生成的 `SpellCategory.dbc` 只有 `id + flags` 两个数字字段（字符串块 1 字节），
**与语言无关**。

## 二十三、启动日志收口（2026-10-12 14:51 重启后）

`server_2026-10-12_14-51-14.log` 里与本文相关的行数从 **336 → 319 → 22**（10-11 13:01 那次是 A 级
17 行生效后的 319）。现在这 22 行**逐条都能对上数据库侧的算法**，没有一条意外：

| 日志里的报错 | 行数 | 与数据库对账 |
|---|---|---|
| `Spell N (...) misses spell_affect for effect M` | **8** | 内核判据（Effect==6、aura∈{107,108,109}、EffectItemType==0、无对应行）复算 = 8：45405 / 45985 / 51369 / 51370 / 51371 / 52603 / 52690 / 52701 —— 已核明无出处（见 `sql/wip_updates/spell_affect_missing38.sql` 第五节） |
| `Creature (Entry: N) has nonexistent pet_spell_list_id (M)` | **2** | #503（Crimson Guard Olbreg）、#627600（Blackwind Villager）—— 客户端 `CreatureSpellData.dbc` 里没有这两个 id |
| `Creature (Entry: N) has nonexistent spell list id (M)` | **12** | 7 只指向不存在的 `creature_spells` 行 + 5 只指向「8 槽全 0」的行（内核 `if (!spellsList.empty())` 不登记空行 → 视同不存在）—— 官方 1.12 与客户端都没有这些 id |
| `Item (Entry: N) has wrong (not existing) spell category ...` | **0** | ✅ 换 `SpellCategory.dbc`（生成版 188 行）后归零 —— 本次唯一需要换 DBC 的一项 |

**读日志的两个坑（写下来避免误读）**：

1. `grep -c ... *.log` 会把**历史**全算进去 —— 每个旧 `server_*.log` 各留一份当年的 336/319 行，
   而 `errors.log` 是 `a+` 追加的（当前累计 5047 行）。看当前状态只认**最新那个** `server_<日期>.log`。
2. `logs/dbfix.log` 是 `LOG_DBERRFIX` 通道（`Log.cpp:335` 绑 `DBErrorFixFile`），里面写的是内核
   给的**修复语句**（`UPDATE ...`），不是错误清单；它为空 = 没有「能自动给出修法」的数据问题，
   不等于「所有 DB 检查都过了」。`outErrorDb()` 的正文去 `DBErrorLogFile`（`Log.cpp:322`）与主日志。

**剩余 22 行 = 已核明、无原始数据可依的上游缺口**，不再处理；要真正消掉得改内核（给
`SPELLMOD_CUSTOM_VALUE_*` 加消费者、给 spellmod 放宽 family 判定）或补客户端 DBC 的位图。

### 剩余 22 行的精确清单（2026-10-12 14:51 启动实测，与上表逐条吻合）

`misses spell_affect`（8 条，全是「没有出处」的那些）：

```
Spell 45405 ([Deprecated] Arcane Potency)      effect 0
Spell 45985 (Counterattack)                    effect 0
Spell 51369 / 51370 / 51371 (Improved Water Shield)  effect 0
Spell 52603 (Improved Swift Aspects)           effect 0
Spell 52690 (Crystal Infusion)                 effect 0
Spell 52701 (Purge Haste Passive)              effect 0
```

`has nonexistent spell list id`（12 条 = 7 条指向不存在的行 + 5 条指向「8 槽全 0」的行）：

```
不存在：59967 King / 62051 Dragonmaw Veteran / 62177 Blackrock Conjurer /
        62210 Dragonmaw Pillager / 62226 Stonehide Boar / 62227 Elder Stonehide Boar /
        62263 Dragonmaw Marauder
8 槽全 0：61244 Brol'ok Mauler / 62321 Rotting Resident / 62335 Blistering Remains /
        62341 Slavering Crag Coyote / 62361 Stormreaver Drone
```

`has nonexistent pet_spell_list_id`（2 条）：

```
62760 Blackwind Villager    → pet_spell_list_id 627600（客户端 CreatureSpellData.dbc 里没有）
63187 Crimson Guard Olbreg  → pet_spell_list_id 503（同上；503 只在服务端出现过）
```

**这 22 行的处置：不动**（每条都查过官方 1.12、客户端 1.18.1、上游仓库与客户端 dbc.MPQ，
都没有出处）。日志里保留它们反而是有用的信号：哪天乌龟服补上了数据，这几行会自己消失。

## 二十四、物品说明按 entry 误配（2026-10-12 复核，撤 453 条）

### 现象

`/db/items/42142`（Simple Leaves / 朴素树叶）中文有说明「对应红色插槽。」，英文没有，
而且这条说明和物品名毫无关系 —— 玩家报的就是这个。

### 溯源：不是「放错了格子」，是**按 entry 抄了另一件物品的中文**

`locales_item.description_loc4` 里空着的格子，2026-10-05 是用会话产物
`files/i18n-zh/p5/upstream-data/fill_from_cmangos.py` 按 **entry** 从
[cmangos classic-db](https://github.com/cmangos/classic-db) 的官方简中填的
（`locales/Chinese/locales_item.sql`）。这个脚本**没有**核对「来源行讲的是不是同一件物品」，
而香草的条目表里留着一大批当时没用上、后来才启用/废弃的 entry：

```
cmangos:    INSERT INTO `locales_item` VALUES (42142, '朴素龙眼石', '对应红色插槽。');
我们的库:   item_template 42142 = Simple Leaves（朴素树叶）
            ← 乌龟服自定义内容，见 sql/database_updates/world/20260505222630_world.sql
```

名字列逃过一劫纯属侥幸：名字先被本项目自己的译名管道填好了（fill 只填空格子），
**说明列是空的，于是宝石的插槽说明被抄了进来**。

### 三组证据

1. **插槽机制在 1.12 根本不存在**：`grep -rn "SOCKET_" src/game/` 只命中网络 socket；
   1.12 客户端没有插槽 UI，物品表也没有插槽字段。而 108 条插槽说明的来源行，
   在 cmangos 里**清一色是宝石**（龙眼石 / 天焰钻石 / 大地侵攻钻石 / 茶晶石 / 血玉石…），
   我们的物品却是护甲、武器、食物、任务杂物（`Idol of Fluidity` ← 反光德拉诺影钻、
   `Delicious Pizza` ← 闪光血玉石、`Black Tie Plum Waistcoat` ← 混乱之天焰钻石）。
2. **物品根本不教东西，说明却说「教你学会…」**：`spellid_1..5` 全 0 的物品不可能是
   配方 / 图鉴 / 坐骑 / 宠物（这些东西必须挂一个法术）。上游 base 的 2089 条说明里
   这种自相矛盾只有 5 条，本次补进来的有 213 条。
3. **来源行是另一件物品**：例如 `Crown of Transcendence`（头冠）抄到了
   「叛逃者传单」的风味文案「这只箱子里满是传单…」；`Mossbloom Coating`（涂料）
   抄到了「金色龙鹰卵」的「教你学会召唤这种小伙伴。」。

### 判据（可复现）

`tools/dbdiff/verify_cmangos_desc_fill.py`：**只有能确认来源行讲的就是我们这件物品时才保留** ——

| 判据 | 含义 |
|---|---|
| W1 同名 | 我们库里的中文名 == 来源行的中文名，**且上游 base 里本来就有这个中文名**（base 空说明这中文不是抄来的，才可作证） |
| W2 香草同物 | 香草原版 `item_template` 同 entry 的英文名 == 我们的英文名 |
| W3 异译 | 两个中文名高度重合（最长公共子串 ≥ 较短者的 50%），即同一物品的不同译法（`配方：自由行动药剂` vs `配方：自由行动药水`） |
| R1 机制不存在 | 说明含 插槽 / 镶嵌 / 多彩宝石 / 切割 |
| R2 不可能教人 | 说明以「教你学会」开头但五个法术槽全 0 |
| R3 我方是占位名 | 我们这件是 Placeholder / Monster - / Deprecated / OLD / [PH]，而来源行是具体物品名 |

W1/W2/W3 任一成立 → keep；R1/R2/R3 命中 → revert；都不沾 → revert。

### 结果

库里 3866 条中文说明：**keep 3413 / revert 453**

```
机制在 1.12 不存在                 236
来源行是另一件物品                  160
物品五个法术槽全 0，不可能教人          40
我们这件是占位/测试名，来源行讲的是另一件物品    17
```

### 安全性（逐条核过）

* 453 条**在上游 base 里本来就没有中文说明**（444 条上游无此条目、9 条上游说明为空）
  → 撤成空串 = 回到上游状态，不会删掉任何上游/官方中文。
* 453 条在上游 `item_template` 与**线上库**里的英文说明也都是空的
  → 撤掉后中英一致（两边都没有说明行），不是「英文有中文删了」。
* **幂等**：`WHERE entry=… AND description_loc4='原文'`，值被人改过就整行不动。
* 用 `START TRANSACTION … ROLLBACK` 在线上库试跑过：453 条全部命中、无报错、回滚后原样。

### 交付

| 文件 | 作用 |
|---|---|
| `tools/dbdiff/verify_cmangos_desc_fill.py` | 复核器：自动拉 cmangos 源（sha256 钉住）、读线上库与上游 base、输出明细 TSV 与回滚 SQL |
| `sql/wip_updates/locales_item_desc_fixes.sql` | 453 条幂等回滚（应用：`mysql tw_world < …`） |
| `sql/wip_updates/locales_item.sql` | 同步删除那 453 行（6584 → 6131 条；description 段 1516 → 1063 条），重跑导入不会再写回来 |

复现：

```sh
python3 tools/dbdiff/verify_cmangos_desc_fill.py \
    --mysql "$(pwd)/tools/dbdiff/mysql_local.sh tw_world" \
    --base sql/base/tw_world_locales_item.sql --cache /tmp/cmangos-data \
    --report /tmp/cmangos_desc_fill.tsv --sql /tmp/cmangos_desc_revert.sql
```

### 应用记录（2026-10-12）

已在线上库执行 `sql/wip_updates/locales_item_desc_fixes.sql`：

| 指标 | 前 | 后 |
|---|---|---|
| `locales_item` 带中文说明的行 | 3867 | **3414** |
| 其中谈插槽的说明 | 108 | **0** |
| 复核器判定要撤的 | 453 | **0**（keep 3413，剩下每条都过了身份判据） |

内核 `ObjectMgr::LoadItemLocales`（`src/game/ObjectMgr.cpp:2636`）把空串当作「没有译文」，
所以撤成空串＝回落英文（这批的英文本来也是空）→ 与英文客户端一致；
Web 侧 `db_item.html` 只在说明非空时才渲染那一行 → 中英两版都不再显示说明。

### 没动的

* **上游 base 自带的 2089 条中文说明**（含 798 条「教你学会…」配方说明）：那是官方本地化
  数据，koKR / frFR / zhTW 列有同样的文本，与本次误配无关，一个字都没动。
* **名字列同样的误配**：`fill_from_cmangos.py` 也填 `name_loc4`（空格子时）。
  已核出 27 条英文名是占位名、中文名却是具体物品名（33102 中文名「祖尔金之血」= 官方同
  entry 的废弃条目）。这些是乌龟服尚未启用的 Placeholder 物品，玩家见不到，名字侧没动 ——
  如要清另开一轮。
* **本批 453 条的「正确中文」**：这些物品的英文说明本来就是空的（上游与乌龟服都没写），
  所以正确状态就是没有说明行，不需要补译。

## 二十五、刷怪点「新旧两代」重复：布瑞尔有两个卡洛琳娜克洛文（2026-10-16）

### 现象

布瑞尔（提瑞斯法林地）站着两个一模一样的 **卡洛琳娜克洛文**（62966），相距 0.77 码。
查下去发现不止她：**11 个生存训练师都各有一份重复**，分布在 11 个营地/城镇。

### 成因：上游那次「搬家」的 DELETE 没删到行

| 时间 | 文件 | 干了什么 |
|---|---|---|
| 2026-05-12 | `20260512130432_world.sql` | 初版：把 18 个生存训练师放进 `creature`，guid **2583700–2583717** |
| 2026-06-25 | `20260625083947_world.sql` | 把 62953/62954 从 2583706/2583707 搬到 2594011/2594012（这份的删除**生效了**） |
| 2026-08-21 | `20260821154713_world.sql`（上游提交 `1ce85cf`「Updating survival trainers」） | "a_trainer_cleanup"：**先 DELETE 旧 guid、再在新 guid 重建** |

那份 cleanup 的 DELETE 名单（11 个）与它重建的 11 个 entry **完全对应**（62950–62959、62966、
63071、63072），说明作者的意图就是「搬家」；而 `20260821154713_world.sql` 的 15 条 INSERT 全部
生效、DELETE 却一个都没删到 —— 于是新旧两代并存：

```
62966 Karolina Cloven   2583715（旧，还在）  ↔  2594047（新，20260821 建的）  0.77 码
62950 Nallaeth          2583714            ↔  2594015                     2.63 码
62951 Krennan Wildberry 2583704            ↔  2594006                     2.08 码
62952 Tabetha Wildberry 2583705            ↔  2594008                     1.46 码
62955 Marlarin          2583713            ↔  2594013                     5.26 码
62956 Brakan            2583710            ↔  2594017                    12.40 码
62957 Rishu             2583711            ↔  2594018                    32.0 码
62958 Ammi Summerpelt   2583708            ↔  2594024                     1.97 码
62959 Nasnan Hillcreek  2583709            ↔  2594023                     2.40 码
63071 Swampwalker Krug  2583712            ↔  2595984                     0.46 码
63072 Nerean Stagtree   2583701            ↔  2595980                     4.03 码
```

（其余 5 个——62960/62961/62964/62965/62967——不在删除名单里，因为没有新一代刷怪点，
它们是唯一那份，**不能删**。）

### 证据链

1. **没有任何文件重新插入这 11 个 guid**：全库 177 个迁移 + `sql/base` 转储逐个 grep，
   只有 3 处提到它们——`20260512130432`（插入）、`20260821154713`（删除名单）、
   `20260625083947`（只提 2583706/2583707）。而 2583706/2583707 至今**不在库里**，
   说明「删除」这个动作本身是有效的。
2. **线上行的内容与 `20260512130432` 逐字段一致**（float 存储精度内），确认就是它插进去的那批。
3. **线上 88813 行刷怪点，逐 guid 比对后 0 行「来历不明」**：要么在 base 转储里，
   要么在某个迁移文件的 INSERT 里 —— 排除「从别处导进来」的可能。
4. **两条记录的 hash 与仓库文件逐字节一致**，`AppliedAt` 为 2026-09-30 21:29:15 / 22:27:57。
5. 内核侧逐行读代码：`AutoUpdater::ExecuteUpdate` 把整份文件放进**一个事务**
   （`SqlTransaction::Execute` 里任何一条失败就 ROLLBACK 并返回 false，此时不会写
   `migrations` 记录）⇒ **记录在 = 事务提交 = 那条 DELETE 执行成功了**。所以只能是
   「执行 DELETE 的那一刻，表里没有这些行」。

### 为什么会「执行时没有这些行」：那天导库与迁移是同时进行的

`information_schema.TABLES.CREATE_TIME` 把 2026-09-30 那天的实际顺序还原出来了
（都是从 dump 里 DROP+CREATE 建的表）：

```
21:20:53              migrations（mangosd 启动，AutoUpdater 自己建的）
21:21:00–21:29:16     第一次跑迁移（16 个文件 → 含 20260512130432，训练师进 2583xxx）
21:29:14              cartographer 建表（导入开始）
21:54:56–21:57:04     导入 sql/base 的第一大批（area_template … creature 21:55:05 …
                      quest_template … warden_scans）—— creature 表被 DROP 重建
22:10:24–22:10:28     又一批（skill_line_ability、taxi_nodes）+ 第二次跑迁移开始
22:19:35–22:21:54     又一批（areatrigger_*、creature_movement、gameobject、item_template）
22:27:24              20260625083947 应用（删掉 2583706/2583707）
22:27:57              20260821154713 应用 ← DELETE 执行时这 11 行不在表里
22:27:59              又一批建表（lft_user_groups/spell_template/gossip_menu/…）
```

也就是说：**服务端 21:21 就开始跑迁移了，而世界数据是 21:54 起才一批批导进来的**，
中间还夹着 DROP TABLE 的重建与第二次重启。在这样一个「边导边跑」的窗口里，迁移对
`creature` 的判断自然会与最终数据对不上（那次 DELETE 显然是在这些行被写进表之前执行的；
至于具体是哪一步把它们写进来的，需要看当天的启动日志——见下）。

**教训**：导库（尤其带 DROP TABLE 的整表重建）必须在**服务端停止**的状态下做，
否则 `migrations` 会被写进一堆「在当时的数据快照上成立」的操作，导完之后就对不上了。

### 修复

`sql/database_updates/world/20261016205000_world.sql`：删掉那 11 个旧 guid，
保留上游那次更新的新 guid（位置也是更新过的）。幂等。

* 删除前核对过：tw_world 里**除 `creature` 外没有任何表**引用这 11 个 guid
  （166 张含 `guid`/`id` 列的表逐张查过），不留悬挂引用。
* `tools/dbdiff/check_delete_ids.py` 通过（它列出的都是 entry 62950/… 与
  vendor_id 1500024 的引用，不是 guid）。
* 线上事务内试跑：删 11 行、新 guid 11 行仍在、布瑞尔 62966 从 2 个变 1 个，ROLLBACK 后原样。
* 反向回滚（要保留旧那一份的话）：`sql/wip_updates/2026-10-16_survival_trainer_duplicate_rollback.sql`
  （已用「先删后插」在事务里验证过）。

验证：

```sql
SELECT id, COUNT(*) FROM creature WHERE id IN
  (62950,62951,62952,62955,62956,62957,62958,62959,62966,63071,63072) GROUP BY id;  -- 每个都是 1
SELECT COUNT(*) FROM creature WHERE id=62966;                                       -- 1
```

### 顺带发现：两台 MySQL 是「双主」，而且自增偏移配重了

```
172.18.1.6 (server6, server_id 1006)  ⇄  172.18.1.7 (server7, server_id 1007)
两边都是 auto_increment_increment = 2、auto_increment_offset = 1   ← 都配成 1 了
migrations 表 Id 全是奇数、每个文件占两个号（633,635,637,…）就是这个原因
```

双主的正确配法是**一台 offset=1、另一台 offset=2**，否则两台会生成**相同的自增主键**：
同一时刻各自插入（比如两边都在启动时应用迁移），第二台回放时就会撞主键 → 复制中断
（`Last_SQL_Error`），跳过事务又会造成两边数据不一致。现在只有 server6 跑服务端
（server7 上没有任何 tw_* 连接），暂时不容易撞上。

**2026-10-16 21:15 已修正**：server7 配置改成 `auto-increment-increment = 2`,
`auto-increment-offset = 2` 并重启（uptime 与运行值都确认是从配置文件读的）。修正后核对：

| 项目 | 结果 |
|---|---|
| 自增实测（临时表，不落复制） | server6 生成 `1,3,5`（奇）／server7 生成 `2,4,6`（偶）→ 主键空间互不重叠 |
| 复制方向 1（7 → 6） | IO/SQL 均 Yes、延迟 0 秒；`gtid_executed` 里 `c93ef2a1…:1-1272808` 两台一致 = 6 号已应用 7 号**全部**事务 |
| 复制方向 2（6 → 7） | IO/SQL 均 Yes、延迟 0 秒、`Last_IO_Error` 为空 |
| 重启窗口的小插曲 | 7 号重启时 6 号报过一次 `error 111`（端口没在监听），IO 线程按 60 秒重试已自动重连，无需处理 |
| 数据一致性 | `creature` / `gameobject` / `creature_template` / `item_template` / `migrations` / `account` 六张表 `CHECKSUM TABLE` 两台完全相同 |

运维提醒：**若把一台的备份恢复到另一台**，恢复后要重启一次 MySQL —— 计数器会按
恢复进来的最大值重算，重启后才会带上各自 offset 的奇偶性。另外 offset 只保护
「自增主键」，业务自然键（账号名、角色名等）两边同时插仍会冲突。

#### 「我没从 server7 写过数据」——对 tw_* 是对的，但 server7 并不是只读的（2026-10-16 复核）

疑问：既然没人在 server7 上写，偏移配错又有什么关系、会不会已经有脏数据？

用 binlog 把「谁在写哪个库」实测了一遍（`mysqlbinlog --read-from-remote-server`，
按每个事务的 `SET @@SESSION.GTID_NEXT` 判断它由哪台发起）：

| 库 | 写入方 | 实测（事务数） |
|---|---|---|
| `tw_world` / `tw_char` / `tw_logon` / `ref_mangos` | **只有 server6** | 6 号自发起 86240 / 10608 / 635 / 5；7 号自发起 **0** |
| `zabbix` | **只有 server6** | 6 号 99053；7 号 0 |
| `weiwei`（Joomla：`fw8db_session` / `fw8db_content`） | **只有 server7** | 7 号 550+2141+298；6 号自发起里没有，只有「同步自 7 号」的 461 条 |
| `bosbio` | **只有 server7** | 7 号 3430（10-08~10-10 的一次批量写入）；6 号只有同步来的 2448 条 |

* 6 号侧：binlog `000413`（10-09 00:56 起，1 GB，171 万个事务）
* 7 号侧：binlog `000180`–`000184`（10-08 17:35 起，共约 3.8 GB）

结论：

1. **每一个库都只有一个写入方**，没有任何一张表是两边都写的 —— 所以这次偏移配错
   **没有产生过冲突，tw_* 里没有脏数据**（`tw_world` 两张表的 `CHECKSUM TABLE`
   两台完全相同，`migrations` 178 行全是奇数 Id）。
2. 但「没有第二个人写」不代表「只有你在写」：server7 上一直在写 `weiwei`（网站）与
   `bosbio`，只是不写 tw_*。这些库不在 6 号的 `Replicate_Ignore_DB` 里，变更会同步回 6 号
   —— 也就是说双主的两半都是活的，只是分工不同。
3. 偏移错开的价值在**将来**：一旦出现「同一个库两边都写」，比如在 7 号上启动一次
   worldserver（AutoUpdater 会写 `migrations`、游戏会写 `tw_char`/`tw_logs`）、
   在 7 号上跑一次导入/改数据脚本、或者做一次主备切换，两台就会各自生成**同一个自增号**：
   后到的那条在对面回放时主键冲突 → 复制中断（`Last_SQL_Error`），强行跳过就成了
   两边不一致（这才是「脏数据」）。现在 6 号只用奇数、7 号只用偶数，这类撞车不可能发生。
4. 另一个副产品：7 号自 **2026-10-13 15:00** 起就没有再发起过任何本地事务
   （`weiwei` 也停了），说明那之后它处于纯备机状态。

顺手复核：

```sql
-- 两台 tw_* 一致性
CHECKSUM TABLE tw_world.creature, tw_world.migrations;        -- 两台输出相同
-- 唯一的写入者是不是 6 号（offset=1 → 奇数）
SELECT COUNT(*) 行数, SUM(Id%2) 奇数, SUM(Id%2=0) 偶数 FROM migrations;   -- 178 / 178 / 0
```

复现 binlog 侧的判断（`/tmp/mb.cnf` 放 `[client]` 的 host/user/password）：

```sh
mysqlbinlog --defaults-file=/tmp/mb.cnf --read-from-remote-server --host=172.18.1.7 \
  mysql-bin.000182 | grep -E "GTID_NEXT|^\s*use \`"
# GTID_NEXT 里的 UUID 决定「谁发起」：c93ef2a1…=7 号，ea8e0964…=6 号
```

旁注：`migrations` 里 **645 号是空的** —— 09-30 那次有一次迁移失败回滚
（自增号在回滚时也会被消耗，`20260507184157_world` 后来在 22:17 才应用成功），
不是数据问题。

另外，`creature` 里同类「新旧两代贴身重复」还有 3 组，但来历不同、看起来是有意设计的
（如 `62269 Twitching Corpse` 2585551↔2592350、`62266 Burnt Monk` 2585554↔2592346、
`62329 Bilgerat Corsair` 2586749↔2592110），本次没有动。

## 二十六、为什么迁移里的 DELETE 会「执行成功却没删到行」（2026-10-16 首版）

> ⚠️ **更正（同日晚些时候）**：本节把重复 NPC 归因于「导库与迁移同时跑 ⇒ 那条 DELETE 命中 0 行」。
> 拿到服务器上的物证（`/tmp/dbfix/fix_creature.sql`、10-08 的备份、`history`）后确认**这个归因是错的**：
> 那 11 行在 10-08 17:29 时就已经不在库里，**是 10-08 21:14 的补数据脚本把它们插回来的**。
> 真正的原因是 `dbdiff.py` 看不见 `DELETE from\`creature\``（少一个空格）。**请以第二十七节为准。**
> 本节保留作记录，其中「MySQL 把匹配 0 行的 DELETE 当成功、迁移记为已应用后不会重跑」这条机制仍然成立，
> 只是**不是本案的原因**。

承接第二十五节的 11 个生存训练师重复刷怪点（布瑞尔两个卡洛琳娜克洛文）。

### 结论先说

那条 `DELETE from\`creature\` WHERE \`guid\` IN (…)` **执行了、也提交了**，只是执行的那一刻
表里没有这些行 —— MySQL 对「匹配 0 行」的 DELETE 返回成功，所以整份迁移被记为「已应用」，
以后再也不会重跑。**不是执行失败，也不是权限/语法问题。**

### 为什么能断定「执行成功但 0 行」

| 事实 | 说明 |
|---|---|
| 内核把整份迁移文件放进**一个事务**（`AutoUpdater::ExecuteUpdate` → `CommitTransactionDirect` → `SqlTransaction::Execute`） | 任何一条语句失败就 `ROLLBACK` 并返回 false，此时**不会**写 `migrations` 记录 |
| `migrations` 里有 `20260821154713`，其 Hash 与仓库文件**逐字节一致** | ⇒ 事务提交 ⇒ 那条 DELETE 执行成功 |
| 同一份文件的其它语句全部落地 | `creature_addon` 2594024 ✓、`broadcast_text`/`npc_text` 6295001… ✓、`gossip_menu` 62966 ✓、15 个新刷怪点（2594006…2595984）✓ |
| MySQL 语义 | `DELETE` 匹配 0 行既不是错误也不影响事务 |

### 为什么那一刻没有这些行：导库与迁移同时在跑

2026-09-30 世界库是**边导库边跑迁移**搭起来的，`information_schema.TABLES.CREATE_TIME`
把顺序还原得很清楚：

```
21:20:53   migrations 表建立（mangosd 启动）
21:21:00   开始应用迁移（第一批到 21:29:16）
21:29:15   ★ 20260512130432 应用 —— 18 个生存训练师（guid 2583700–2583717）插进 creature
21:29:14   cartographer 建表（导库开始）
21:54:56   …一批基础表…
21:55:05   ★ creature 表被 DROP+CREATE 重建（导库）—— 21:29 插进去的那批行就此消失
22:10–22:13 继续应用迁移
22:19:35   继续导库（areatrigger/auctionhousebot/conditions…）
22:27:21–25 ★ 4 个「整图删除」迁移（map 820/822/816/818）—— 同样命中 0 行
22:27:24   20260625083947 应用（删 2583706/2583707）
22:27:57   ★ 20260821154713 应用 —— 删那 11 个旧 guid，命中 0 行
22:27:59   又一批建表（gossip_menu 等）
```

### 那 11 行后来是怎么回来的

它们**不是**迁移重新插入的，证据三条：

1. 线上那 11 行的每个字段与 `20260512130432` 插入的值**逐字段一致**（float 存储精度内）。
2. 全仓 178 个迁移文件里，只有三个文件提到这些 guid：`20260512130432`（插入）、
   `20260625083947`（删 2583706/2583707）、`20260821154713`（删除名单）。
   **没有任何文件重新插入它们。**
3. 反证「手工重跑 05-12 文件」也不可能：那份文件的 18 行是**一条 INSERT 语句**，
   重跑会连 2583706/2583707 一起插回来，而唯一删这两个 guid 的是 22:27:24 的迁移
   （早于 22:27:57 的删除）—— 但它们至今不在库里。

⇒ 只能是**迁移系统之外的一次数据导入**把旧行带了回来。旁证是表计数器：

```
线上 tw_world.creature      AUTO_INCREMENT = 12,585,178
仓库 base 转储的建表子句     AUTO_INCREMENT = 2,583,684
所有迁移插过的最大 creature guid               2,902,655
```

在测试库实测（`335_w_test`，用完即删）：显式插入高 id **会**把计数器抬上去
（插 12,585,176 后计数器 = 12,585,177），插低 id 不会把它降下来。
⇒ 这张表收到过**另一个 creature 计数器约 1258 万的库**的数据，不是只有仓库 base 转储。

### 同类签名：4 张自定义地图共 1,452 行

同一现象在地图级删除上规模更大（这些行「插入时间早于整图清理、之后没有任何迁移再插入」，
却还活着）：map 816 **462 行**、map 818 **564 行**、map 820 **278 行**、map 822 **148 行**。
**注意**：这不一定都是错（相邻 guid 成对出现往往代表同一批正常内容），要不要清理需要人工判断；
真正确定是错的只有那 11 个训练师（新旧两代 guid 指向同一 location + 同一 entry）。

### 交付

`tools/dbdiff/verify_migration_deletes.py` —— 把这次的对账固化：按
（迁移应用时间, 文件内语句位置）还原每一行 guid 的操作序列（含 guid 列表删除、小范围
`BETWEEN`、整图 `WHERE map =` 删除），然后报告：

* **①** 最后一次操作是删除、行却还在（= 应删未删，数据被导回来了）
* **②** 最后一次操作是插入、行却不在（= 该在不在，通常是被整表重建冲掉）
* **③** 整图删除后仍存在的行（按地图分组，供人工判断）

```sh
python3 tools/dbdiff/verify_migration_deletes.py \
    --mysql "$(pwd)/tools/dbdiff/mysql_local.sh tw_world" \
    --dir sql/database_updates/world --table creature --table gameobject \
    --report /tmp/migration_delete_audit.tsv
```

2026-10-16 跑出来的结果：① **0**（11 个训练师已由 `20261016205000_world.sql` 修掉）、
② 1 行、③ 1,452 行（即上面 4 张地图）。

### 教训

**导库（尤其带 DROP TABLE 的整表重建）必须在服务端停止时做。** 否则：

1. 迁移会基于一个稍后就不存在的数据快照执行 —— 于是写入行的 DELETE 变成空操作；
2. 迁移被记为「已应用」，**永远不会重跑**，缺失只会在玩家那边（重复 NPC）暴露出来；
3. 之后再导入的数据会把已删的行带回来，且没有任何日志提示。

搭好库之后，用上面这个脚本对一遍账；①② 里出现的都值得逐条看。

### 补：那 11 行是被 `dbdiff.py` 的补数据脚本带回来的（2026-10-16 二次定位）

上一节说到「迁移之外的一次数据导入把它们带回来」。定位到具体是谁了：

1. 上游那条删除写成 **`DELETE from\`creature\``** —— `FROM` 与表名之间**没有空格**。
2. `dbdiff.py` 的两条正则都要求 `DELETE\s+FROM\s+\``（`\s+`）：
   * 索引语句那条（`_stmts`）：`\s*(DELETE\s+FROM|UPDATE)\s+\`([^\`]+)\``
   * 执行删除那条（`expected`）：`DELETE\s+FROM\s+\`%s\``
   ⇒ **这条删除根本没进它的模型**（本地实测：`re.match(...)` 两条都不匹配）。
3. 于是它的「仓库应有状态」里**一直留着这 11 行**（实测：把今天的新迁移排除后，模型里 11/11 都在）。
4. 而 `dbdiff.py --table creature --emit-sql` 生成的正是「仓库有、线上没有」的 `INSERT IGNORE`。
5. 服务器上 2026-10-11 那轮修复（`history` 669–670 行）：
   `dbdiff.py --table $t --emit-sql /tmp/dbfix/fix_$t.sql` → `mysql … tw_world < /tmp/dbfix/fix_$t.sql`，
   名单里就有 `creature` ⇒ 这 11 行被补回线上 ⇒ 布瑞尔出现两个卡洛琳娜克洛文。

**修好的东西**

| 改动 | 内容 |
|---|---|
| `dbdiff.py` 索引正则 | `(DELETE\s+FROM|UPDATE)\s*`` —— 允许 `FROM` 与表名之间没有空格 |
| `dbdiff.py` 执行正则 | `DELETE\s+FROM\s*`%s`\s*(?:WHERE\s+(.*?))?;?$` —— 同上，并容忍语句末尾分号 |
| 新增 `--self-test` | 4 个用例的回归自检，含 `DELETE from\`creature\`` 这种写法；`python3 tools/dbdiff/dbdiff.py --self-test` |

**改完再验**

* 把今天的新迁移（`20261016205000`）排除后，模型里的旧训练师只剩 5 个单一训练师
  （`2583700/2583702/2583703/2583716/2583717`），11 个重复的已被正确删除 ✓
* 对线上跑 `dbdiff.py --table creature`：**仓库 88802 行 / 线上 88802 行 / 缺 0 / 多 0** ✓

**留一条旁证待解释**

`creature` 的 `AUTO_INCREMENT = 12,585,178`，而仓库 base 转储**唯一版本**（`e1a48b4`，2026-05-03
起）的建表子句是 2,583,684，所有迁移插过的最大 guid 是 2,902,655。也就是说：
**当时建 `creature` 表用的那份 creature 转储并不是仓库里这份** —— 另有来源（很可能是一份旧服的
dump）。若那份 dump 还在服务器上：

```sh
grep -m1 "AUTO_INCREMENT=" <那份 dump> | head -1     # 看是不是 12585178
grep -c "2583715\|2583704" <那份 dump>               # 看它是否也带着旧训练师
```

值得查一下 —— 它意味着当时还导进了一份「别处来的」creature 数据。

## 二十七、重复 NPC 的真正原因：`dbdiff` 看不见上游那条少空格的 DELETE（2026-10-16 结案·更正版）

### 物证（都在服务器上）

| 物证 | 内容 |
|---|---|
| `/tmp/dbfix/fix_creature.sql`（2026-10-08 21:14，2379 字节） | 第一行写着「**表 creature，缺失 11 行**」，下面一条 `INSERT IGNORE`，11 行的 guid 正是 `2583701, 2583704, 2583705, 2583708, 2583709, 2583710, 2583711, 2583712, 2583713, 2583714, 2583715`，坐标与 `20260512130432` 完全一致 |
| `tw_world_before_20261008.sql`（2026-10-08 17:29，`history` 608 行 `mysqldump --single-transaction tw_world`） | `grep -c 2583715` = **0**、`grep -c 2583704` = **0** ⇒ 补数据脚本**跑之前**这些行不在库里 |
| `history` 669–670 行 | `dbdiff.py --table $t --emit-sql /tmp/dbfix/fix_$t.sql` → `mysql … tw_world < /tmp/dbfix/fix_$t.sql`，名单里含 `creature` ⇒ 那 11 行被补回线上 |

### 因果链（收紧了）

1. 上游 `20260821154713_world.sql` 把删除写成 **`DELETE from\`creature\``** —— `FROM` 与表名之间**没有空格**。
2. `dbdiff.py` 的两条正则都要求 `DELETE\s+FROM\s+\``（`_stmts` 的索引正则、`expected()` 的执行正则）
   ⇒ **这条删除根本没进它的模型**（实测两条都不匹配），模型里那 11 行一直是"应该有"。
3. 2026-10-08 21:08–21:14 那轮修复：`--emit-sql` 用「仓库应有状态 − 线上」生成补数据 SQL ⇒
   `fix_creature.sql` = 那 11 行；紧接着被应用 ⇒ **重复刷怪点出现**（布瑞尔两个卡洛琳娜克洛文）。
4. 另外 5 个没有新一代刷怪点的训练师（`2583700/2583702/2583703/2583716/2583717`）本来就没被删，
   所以修复脚本里没有它们 —— 与 `fix_creature.sql` 只有 11 行完全吻合。

### 修复与验证

* `dbdiff.py`：索引正则改 `(DELETE\s+FROM|UPDATE)\s*``、执行正则改 `DELETE\s+FROM\s*`T`\s*(?:WHERE\s+(.*?))?;?$`
  （允许无空格、容忍末尾分号）；新增 `--self-test` 回归自检（含 `DELETE from\`creature\`` 用例）。
* 把今天的新迁移排除后重跑模型：旧训练师只剩 5 个单一训练师，11 个重复的已被正确删除 ✓
* 对线上跑 `dbdiff.py --table creature`：**仓库 88802 / 线上 88802 / 缺 0 / 多 0** ✓

### 顺带查清的两件事

1. **09-30 建 `creature` 表用的不是仓库那份 base 转储**：10-08 备份里 `creature` 的建表子句是
   `AUTO_INCREMENT=12585178`，而仓库 `sql/base/tw_world_creature.sql`（唯一版本，2026-05-03 起）是
   `2583684`、所有迁移插过的最大 guid 是 2,902,655 ⇒ 当时导入的 creature 数据来自**另一个库**
   （很可能是一份旧服务器的 dump；旧服跑的是较早的版本，因此那批行当时还在）。
   这不是错误——如果是有意保留旧服进度就没问题，但**要知道它不是仓库快照**，对账时要留意。
2. 第二十六节里 `verify_migration_deletes.py` 报的 ③「整图删除后残留 1,452 行」**是误报**：
   该工具按**迁移应用时间**排序，而 09-30 那晚因反复重启，应用顺序与文件名顺序并不一致；
   dbdiff 按**文件名顺序**建模，结果显示这 1,452 行都是"应有的内容"（插入它们的文件在名称上晚于整图删除）。
   ⇒ 以后看 ③ 先用 `dbdiff.py --table` 复核一遍再决定要不要动。

### 教训（替换第二十六节那条）

1. **对账/补数据工具的正则必须覆盖上游的写法**。上游有 `DELETE from\`x\``、`DELETE  FROM`、末尾带分号
   等各种写法；工具"看不见"某条删除时不会报错，只会默默把已删除的行当成"缺失"补回去 —— 这次就是这么发生的。
2. **任何 `--emit-sql` 生成的补数据脚本，应用前先过一遍 `verify_migration_deletes.py`**（① 类就是
   "迁移删过、现在要补回来"的行，逐条确认）。有疑问的行一律先不补。
3. 工具改完立刻补 `--self-test`（`python3 tools/dbdiff/dbdiff.py --self-test`），别等下次事故。

## 二十八、模块迁移把服务器搞崩：MariaDB 语法 vs MySQL（2026-10-17）

### 现象

加了 `modules/TortoiseBots`（`Sagiroth/TortoiseBots` v1.3.0）后重启，mangosd 起不来：

```
[DB Auto-Updater] Attempting to execute update 20260824090002_char for module TortoiseBots …
SQL:  ALTER TABLE ai_playerbot_item_info_cache
        ADD COLUMN IF NOT EXISTS scale_1 mediumint NOT NULL DEFAULT 0, …
[1064] You have an error in your SQL syntax; … near 'IF NOT EXISTS scale_1 …'
Error while parsing SQL. Core fix required.
/root/.../DatabaseMysql.cpp:196: Error: Assertion in HandleMySQLError failed: false
terminate called after throwing an instance of 'std::runtime_error'
```

### 原因（两层）

1. **语法层**：`ALTER TABLE … ADD COLUMN IF NOT EXISTS` 是 **MariaDB 专有**语法，MySQL 直接 1064。
   本机库是 **MySQL 8.4.11**（`SELECT @@version`），不支持；`DROP COLUMN IF EXISTS`、
   `ADD INDEX IF NOT EXISTS`、`DROP INDEX IF EXISTS`、`CREATE OR REPLACE TABLE`、`ALTER IGNORE`
   等同理。模块作者显然是在 MariaDB 上测的。
2. **内核层**：迁移里的 SQL 出错不是"跳过并记录"，而是 `DatabaseMysql.cpp:196`
   `HandleMySQLError` 的 `assert(false)` → 整个进程 terminate。
   **一份语法错误的迁移 = 服务器启动即崩**，而且发生在 `World::SetInitialWorldSettings` 阶段。

### 修法：保留幂等语义，换成 MySQL 能懂的写法

这 3 个文件用 `IF NOT EXISTS` 是**刻意要幂等**（作者注释：给「已经应用过早期版本」的安装补齐列）。
所以不能简单删掉 `IF NOT EXISTS` —— 那样一旦某个文件重复执行（hash 变了会重跑整个文件）就会
撞 `Duplicate column name` 1060，同样崩。取代方案是按 `information_schema` 动态拼 ALTER：

```sql
SET SESSION group_concat_max_len = 65535;
SET @missing := (
  SELECT GROUP_CONCAT(CONCAT('ADD COLUMN `', w.col, '` mediumint NOT NULL DEFAULT 0') SEPARATOR ', ')
  FROM ( SELECT 'scale_1' AS col UNION ALL SELECT 'scale_2' AS col /* … */ ) w
  WHERE NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS c
                    WHERE c.TABLE_SCHEMA = DATABASE() AND c.TABLE_NAME = 'ai_playerbot_item_info_cache'
                      AND c.COLUMN_NAME = w.col));
SET @sql := IF(@missing IS NULL, 'DO 0', CONCAT('ALTER TABLE `ai_playerbot_item_info_cache` ', @missing));
PREPARE migrate_item_info_scale FROM @sql; EXECUTE migrate_item_info_scale; DEALLOCATE PREPARE migrate_item_info_scale;
```

* `DO 0` 是「什么都没缺」时的空操作 —— 故意不用 `SELECT`，因为 `Database::Execute` 不回收结果集
* 三条语句（SET / PREPARE / EXECUTE / DEALLOCATE）在**同一个连接**上跑，会话变量有效
* 内核的切分器不认 `;` 之外的语法，这段没有任何存储过程/DELIMITER，可以安全切分

改的是模块的 3 个文件（`data/sql/character/20260824090002_char.sql` 32 列、
`…/20260925140000_char.sql` 3 列、`data/sql/world/20260824090002_world.sql` 1 列），
其余 39 个文件本来就是 MySQL 兼容的。

### 验证（全部在 MySQL 8.4.11 上真跑）

| 验证 | 结果 |
|---|---|
| 在复制忽略的 `335_w_test` 里建同结构表 → 跑改好的语句 | 列数 9 → **41**（+32）→ **44**（+3）；world 侧 `help_texts` 2 → 3 列、`zone_level` 建表 ✓ |
| 同样的语句**再跑一遍**（幂等） | 列数仍是 44，无报错 ✓ |
| 模拟"装了一半"（`DROP COLUMN scale_5, scale_17, source_tier`）再跑 | 恰好补回 3 列，44 ✓ |
| 补丁在**干净克隆**上 `git apply --check` | 通过，应用后全量预检 0 问题 ✓ |
| 内核切分器切出来的语句数 | char 6/6 条、world 7 条，逐条在真库上通过 ✓ |
| 命令行测试数据清理 | 测试表已 DROP ✓ |

### 新增工具：`tools/dbdiff/dryrun_migration_sql.py`（零写入预检）

以后**加模块/写迁移前先跑它**：

```sh
# 模块（按 character/world 子目录自动选库）
python3 tools/dbdiff/dryrun_migration_sql.py \
    --mysql "$(pwd)/tools/dbdiff/mysql_local.sh" \
    --module-root modules/TortoiseBots/data/sql --char-db tw_char --world-db tw_world

# 核心迁移（只预检 DDL，几万条 INSERT 不逐条跑）
python3 tools/dbdiff/dryrun_migration_sql.py \
    --mysql "$(pwd)/tools/dbdiff/mysql_local.sh" \
    --dir 'sql/database_updates/world/*.sql' --db tw_world --ddl-only
```

原理与边界：

* 用 `PREPARE <名> FROM <语句文本>` —— **只解析、不执行**，所以 DDL/DML 都能安全预检；
  语句文本用十六进制字面量（`SET @s := CONVERT(0x… USING utf8mb4)`）传入，绕开所有引号转义
* 静态检查会先**剥掉字符串字面量**再匹配 MariaDB 关键词（否则任务文本里的 "RETURNING" 会误报
  —— 第一次跑就是这么被自己抓出来的）
* `1146 表不存在`：如果那张表在**本次运行里更早的文件**中 `CREATE` 过，就不算问题
  （按内核的应用顺序预先扫一遍"谁创建了什么"）
* 局限：`PREPARE` 对 `ALTER` 不做对象解析（表不存在也会通过），所以它主要保**语法**；
  对象存在性靠 `--check-objects` 粗查
* 退出码 0/1，可直接挂在重启前

三个已验证结果：**核心 177 个迁移全绿**（静态 + DDL 预检）、**模块 42 个文件修好后全绿**、
**未修的原文件被准确抓出**（3 个文件 3/6 条语句）。

### 教训

1. **MariaDB 与 MySQL 的 DDL 方言不同**，第三方模块很可能只测过 MariaDB；`IF NOT EXISTS`
   系列是重灾区。核心与模块都跑 `dryrun_migration_sql.py` 再重启。
2. 内核的失败模式是**直接崩**（`HandleMySQLError` 断言），所以这类错误没有"带病运行"的余地 ——
   预检不是保险，是必需。
3. 交付：`~/Desktop/tortoisebots-mysql-fix/mysql-compat.patch`（对着模块 `911adca` 生成）
   + 三个改好的文件 + 应用说明；上游修复可以走 PR（`Sagiroth/TortoiseBots`）。
