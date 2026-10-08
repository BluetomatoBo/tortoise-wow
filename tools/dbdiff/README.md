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
  `tools/dbdiff/gen_group_chance_fix.sql`（它会按 entry 逐组生成、只缩放合计 >100 的那几组）。
