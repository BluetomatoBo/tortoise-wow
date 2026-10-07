# I18nKit / 汉化工具

把**还缺中文的客户端可见文本**导成待翻译清单的小工具。目前覆盖任务（`quest_template`）。

Turns the client-visible text that still has **no Chinese** into a translation worklist.
Quests (`quest_template`) for now.

---

## 中文说明

### 它解决什么问题

客户端看到的任务文本由服务端发来（`quest_template` 是英文原文），中文放在
`locales_quest` 的 `*_loc4` 列里；这一列为空时，客户端**原样显示英文**。而我们能拿到的中文来源
只有三种，任务正好绕开了前两种：

1. **客户端 DBC** —— 1.12 客户端的 DBC **不存任务文本**（任务文本只在服务端），所以哪怕客户端是
   中文的也拿不到；
2. **官方 zhCN 数据**（cmangos 等）—— 只覆盖官方内容，Turtle 自定义任务（新增大陆 Balor 等）
   不在里面；
3. 库里已有的相同英文句子 / 词典拼装 —— 拼不出来的宁可留英文，也不输出病句。

结果是：**约 6700 个任务里，214 个连中文标题都没有**（其中 140 个集中在 entry 41500–41999 的
Balor/SI:7 那一包），另有约 855 条任务详情、850 条任务目标、528 条交还文本有英文没中文。

这个工具就是把这批东西按**任务链**整理出来，翻译完能直接导回去。

> **进度**：这些缺口里，「玩家现在仍能接到」的那部分**已经全部译完**，产物在
> `sql/wip_updates/` 下的 5 个任务文件（`locales_quest_extra` / `_fixes` /
> `_objectives` / `_rewards` / `_details`，共 175 + 456 + 743 + 481 + 748 条），
> 需手工导入；本工具仍可用来核对或重算清单。

### 用法

不需要任何 Python 依赖，它调用你系统里的 `mysql` / `mariadb` 客户端：

```bash
cd tools/I18nKit

# 用 ~/.my.cnf 或 MYSQL_PWD 里的凭据
./export_missing_quests.py --database tw_world -o worklist/

# 或显式指定
./export_missing_quests.py --database tw_world --user root --password 'secret' -o worklist/

# 只要那 214 个连标题都没有的
./export_missing_quests.py --titles-only -o worklist-titles/

# 只要「玩家现在还能接到」的（推荐；汉化优先做这部分）
./export_missing_quests.py --obtainable-only -o worklist-live/
```

### 「还能接到」是怎么判定的

`--obtainable-only` 要求该任务**有活着的给予者**：

```sql
EXISTS (SELECT 1 FROM creature_questrelation r JOIN creature s ON s.id = r.id WHERE r.quest = q.entry)
 OR EXISTS (SELECT 1 FROM gameobject_questrelation r JOIN gameobject s ON s.id = r.id WHERE r.quest = q.entry)
```

也就是「有关系表记录」**并且**「给予者在 `creature` / `gameobject` 里真有 spawn 行」。
只看关系表是不够的：任务可以在表里，但给予者已经被删掉或从未放置，玩家永远见不到。

这个条件把范围从 214/855/850/528 收到 **175/748/743/481**（约砍掉 12%）。

### 产出三个文件

| 文件 | 用途 |
|---|---|
| `quests-missing.md` | 可读清单：按任务链分组，每条任务给出英文原文与上下文（等级、给予者、上交对象、前后置任务） |
| `quests-missing.csv` | 同样内容，给电子表格用 |
| `quests-missing.template.sql` | **可直接填空的 SQL**：每个缺失列一条 `INSERT ... ON DUPLICATE KEY UPDATE`，英文原文放在上一行注释里 |

### 翻译完怎么导回去

1. 打开 `quests-missing.template.sql`，把每个 `TODO` 换成译文；
2. **删掉不打算翻译的那几行**（留着会原样写入游戏里的字面量 `TODO`）；
3. 导入并重载：

```bash
grep -c TODO quests-missing.template.sql    # 导入前必须是 0
mysql tw_world < quests-missing.template.sql
```

```sql
-- 在 mangosd 控制台，不需要重启
.reload locales_quest
```

> `.reload locales_quest` 会把本地化表重新读进内存。客户端看到的任务文本是**发送时**才去查
> `sObjectMgr.GetQuestLocale()`（`GossipDef.cpp`、`Player.cpp`），所以重载后新打开的任务窗口
> 立刻是中文；玩家**已经打开着**的任务窗口/任务日志要重开一次（客户端自己缓存了那几行）。
>
> 改 `quest_template` 本身的字段才需要 `.reload quest_template` —— 只补翻译的话不用。

### 只写 `*_loc4` 列

生成的语句只碰 `locales_quest` 的 `*_loc4` 列，而且只碰清单里列出的 entry；不会覆盖你已有的任何
中文（`ON DUPLICATE KEY UPDATE` 只改这一列）。

### 判定规则

某一列算作「缺失」的条件是：**英文有内容、对应 `*_loc4` 列为空**。
英文本来就是空的列不算缺失 —— 很多任务没有交还文本，把它们列进来只会淹没真正要做的工作。

### 已知边界

- **zone 只显示编号**：`ZoneOrSort` 是客户端 `AreaTable.dbc` 的 id，本工具不读 DBC，所以按原样显示
  数字而不猜名字。
- 结果行数不对时（字段数不等于 24）会**打印警告**并跳过该行，且「全部行都异常」时直接失败退出 ——
  一个漏行的清单比一个报错的工具更糟。
- 目前只做任务。物品/法术/生物名的缺口可以后续按同样方式加，但那几张表的缺口小得多（见
  `sql/wip_updates/` 里的说明）。

---

## English

### What it is for

Quest text a player sees is sent by the server (`quest_template` holds the English), and the
Chinese lives in the `*_loc4` columns of `locales_quest`. When that column is empty the client
shows the English verbatim. Of the three sources of Chinese available to this project, quests
fall outside the first two:

1. **The client's DBC files** — a 1.12 client keeps no quest text at all (it is server-side only),
   so a Chinese client cannot supply it;
2. **Official zhCN data** (cmangos and friends) — covers official content only; Turtle's custom
   quests (the Balor continent and friends) are not in it;
3. Sentences already translated elsewhere in the database, or assembled from a dictionary —
   and where neither produces something acceptable, English is left in place rather than
   shipping gibberish.

The result: of roughly 6700 quests, **214 have no Chinese title at all** (140 of them in the
41500–41999 Balor/SI:7 pack), and about 855 detail blocks, 850 objectives and 528 completion
texts have English without Chinese.

This tool groups that work by **quest chain** so the translation is consistent, and makes it
easy to put back.

> **Status**: for the part a player can **still pick up**, that gap is now **fully
> translated** — see the five quest files in `sql/wip_updates/` (`locales_quest_extra`,
> `_fixes`, `_objectives`, `_rewards`, `_details`; 175 + 456 + 743 + 481 + 748 rows).
> They are imported by hand. This tool remains useful for auditing or recomputing the list.

### Usage

No Python dependencies: it drives the `mysql` / `mariadb` client you already have.

```bash
cd tools/I18nKit

# credentials from ~/.my.cnf or MYSQL_PWD
./export_missing_quests.py --database tw_world -o worklist/

# or spelled out
./export_missing_quests.py --database tw_world --user root --password 'secret' -o worklist/

# only the 214 with no Chinese title at all
./export_missing_quests.py --titles-only -o worklist-titles/

# only quests a player can still pick up (recommended; translate these first)
./export_missing_quests.py --obtainable-only -o worklist-live/
```

### How "still obtainable" is decided

`--obtainable-only` requires the quest to have a **live giver**:

```sql
EXISTS (SELECT 1 FROM creature_questrelation r JOIN creature s ON s.id = r.id WHERE r.quest = q.entry)
 OR EXISTS (SELECT 1 FROM gameobject_questrelation r JOIN gameobject s ON s.id = r.id WHERE r.quest = q.entry)
```

That is: a relation row **and** a spawn row for the giver in `creature` / `gameobject`.
The relation table alone is not enough - a quest can be listed while its giver has been
removed or was never placed, in which case no player will ever see it.

The condition narrows the work from 214/855/850/528 to **175/748/743/481** (about 12% less).

### What you get

| File | Use |
|---|---|
| `quests-missing.md` | A readable sheet, grouped by quest chain, each quest with its English text and its context (level, giver, turn-in, previous and next quest) |
| `quests-missing.csv` | The same rows for a spreadsheet |
| `quests-missing.template.sql` | **A ready-to-fill SQL file**: one `INSERT ... ON DUPLICATE KEY UPDATE` per missing column, with the English in the comment above it |

### Putting the translations back

1. Open `quests-missing.template.sql` and replace every `TODO` with the translation.
2. **Delete the lines you are not translating** — a line still holding `TODO` writes that
   literal word into the game.
3. Import it, then reload:

```bash
grep -c TODO quests-missing.template.sql    # must be 0 before importing
mysql tw_world < quests-missing.template.sql
```

```sql
-- in the mangosd console; no restart needed
.reload locales_quest
```

> `.reload locales_quest` reads the locale table back into memory. The text a player sees is
> looked up **when it is sent**, through `sObjectMgr.GetQuestLocale()` (`GossipDef.cpp`,
> `Player.cpp`), so a quest window opened after the reload is already Chinese; a window or quest
> log the player **already has open** needs reopening, because the client caches those lines.
>
> `.reload quest_template` is only for changes to the `quest_template` rows themselves - a
> translation-only edit does not need it.

### It only writes `*_loc4`

The generated statements touch the `*_loc4` columns of `locales_quest` and only the entries in
the list. `ON DUPLICATE KEY UPDATE` rewrites that one column, so nothing already translated is
overwritten.

### What counts as missing

A column is listed when the **English has text and the `*_loc4` column does not**. A column
that is empty in English is not untranslated, it is unused — and listing those would bury the
real work.

### Known limits

- **Zones are numbers**: `ZoneOrSort` is an id from the client's `AreaTable.dbc`, which this tool
  does not read, so it prints the number rather than guessing a name.
- A result row whose field count is not 24 is **reported on stderr** and skipped, and the run
  fails outright if every row is malformed: a worklist that quietly loses rows is worse than a
  tool that stops.
- Quests only, for now. Items, spells and creatures have the same shape of gap but far smaller
  ones; see the notes in `sql/wip_updates/`.
