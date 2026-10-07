# 本 fork 相对上游的改动与新增 / What this fork changes and adds

- **基准 / Baseline**：上游 [`tortoise-wow/tortoise-wow`](https://github.com/tortoise-wow/tortoise-wow) 的 `1181dev` 分支，共同祖先 `187af78`
- **分支 / Branch**：[`BluetomatoBo/tortoise-wow`](https://github.com/BluetomatoBo/tortoise-wow) 的 `1181-zhcn-localization`
- **规模 / Size**（截至 `40df267`，下面的命令给出的才是当前值 / measured at `40df267`; the commands below print the current numbers）：本分支自己的提交 43 个，合计 120 个文件（104 新增 / 16 修改），+54549 / −18
- **上游同步 / Upstream sync**：已并入上游 `main` 的最新提交 `d94947b`（见第 10 节）

这条清单可以自己复现 / Reproduce this list:

```bash
git fetch origin
# 本分支独有的提交（43 个，不含上游的合并提交）
git log --oneline --reverse --no-merges 1181dev..1181-zhcn-localization
# 文件级差异（新增 vs 修改）
git diff --name-status 1181dev...1181-zhcn-localization
# 只看服务端核心代码
git diff --stat 1181dev...1181-zhcn-localization -- src/
```

**目录 / Contents**

| 方向 | 内容 | 落点 |
|---|---|---|
| 中文本地化（数据） | 18 个 SQL + 1 篇说明 | `sql/wip_updates/` |
| 中文本地化（代码） | 3 处修复 | `src/game/`、`src/scripts/` |
| 服务端缺陷修复 | 3 处 | `src/game/` |
| 新增功能 | 1 个 | `src/game/LootMgr.*` 等 |
| 配置模板补文档 | 2 个键 | `src/mangosd/mangosd.conf.dist.in` |
| 新增工具 | 3 套 | `tools/WowWeb/`、`tools/ClientPatch/`、`tools/I18nKit/` |

> 上游的东西**一个都没删**：120 个文件里 104 个是新增、16 个是修改，全部 18 行删除都是
> 被替换掉的旧代码，没有删掉任何文件或功能。
>
> **Nothing upstream was deleted**: of the 120 files, 104 are additions and 16 are
> modifications, and all 18 deleted lines are old code that was replaced. No file and no
> feature was removed.

---

## 中文说明

### 1. 中文本地化：数据（`sql/wip_updates/`，23 个 SQL + 1 篇说明）

把官方的 zhCN 文本灌进核心库的 `locales_*` 表与几张文本表。文件名就是目标表名：

| 文件 | 表 | 说明 |
|---|---|---|
| `locales_item.sql` | `locales_item` | 物品名与描述 |
| `locales_spell.sql` | `locales_spell` | 法术名与描述 |
| `locales_creature.sql` | `locales_creature` | 生物名与副名 |
| `locales_quest.sql` | `locales_quest` | 任务标题与说明（官方 zhCN 那部分） |
| `locales_quest_extra.sql` | `locales_quest` | 任务标题补译：官方 zhCN 没覆盖、但玩家**现在还能接到**的英文任务标题（178 条） |
| `locales_quest_fixes.sql` | `locales_quest` | 任务标题病句修复：改写既有中文标题里的错译与病句（456 条改写、110 条复核后保留原样） |
| `locales_quest_objectives.sql` | `locales_quest` | 任务目标文本 `Objectives_loc4`（750 条，可接取任务全覆盖） |
| `locales_quest_rewards.sql` | `locales_quest` | 任务交还文本 `OfferRewardText_loc4`（483 条，可接取任务全覆盖） |
| `locales_quest_details.sql` | `locales_quest` | 任务详情文本 `Details_loc4`（755 条，可接取任务全覆盖） |
| `locales_broadcast_text.sql` | `locales_broadcast_text` | 广播文本 |
| `locales_gameobject.sql` | `locales_gameobject` | 游戏对象名 |
| `locales_page_text.sql` | `locales_page_text` | 书页正文 |
| `locales_points_of_interest.sql` | `locales_points_of_interest` | 兴趣点 |
| `mangos_string.sql` | `mangos_string` | 服务端系统消息 |
| `creature_template.sql` | `creature_template` | 生物名/副名（中文） |
| `npc_text.sql` | `npc_text` | NPC 对话 |
| `quest_greeting.sql` | `quest_greeting` | 任务问候语 |
| `npc_trainer_greeting.sql` | `npc_trainer_greeting` | 训练师问候 |
| `gossip_menu.sql` | `gossip_menu` | 对话菜单 |
| `broadcast_text.sql` | `broadcast_text` | 广播文本 |
| `chat_channels.sql` | `chat_channels` | 聊天频道名 |
| `script_texts.sql` | `script_texts` | 脚本台词 |
| `pet_name_generation.sql` | `pet_name_generation` | 术士宠物名字音节（中文化） |
| `README-client-patch.md` | — | 说明「只存在于客户端资源里的那部分中文」及其补丁 |

（`ls sql/wip_updates/` 还会列出 `create_update.sh` 和 `what-are-these.txt` —— 这两个是
上游自带的，不在本分支的改动里。本分支新增的是上面 23 个 SQL 加 1 个说明文件。）

其中 `locales_quest_extra/fixes/objectives/rewards/details` 这 5 个文件是针对**官方 zhCN
没覆盖到的任务文本**做的补译与校对 —— 范围限定为「玩家现在仍能接到」的任务（在
`creature_questrelation` / `gameobject_questrelation` 里有给予者，且该给予者在
`creature` / `gameobject` 里有实际 spawn，重算工具见 `tools/I18nKit/`）。翻译时按
**文本去重**处理（755 条详情实际只有 568 条不同文本），并对每条逐字校验 `$B`/`$N`/`$C`
等占位符与英文原文完全一致、译文无残留英文。这 5 个文件同样**不会自动导入**，需手工执行。

**⚠️ 这些 SQL 不会自动应用。** `CONTRIBUTING.md` 把 `sql/wip_updates/` 定义为
**待合并**的更新暂存区，而 `Database.AutoUpdate.Path` 只扫 `sql/database_updates/`
下的 `Logon` / `character` / `world` 三个目录 —— 全仓库没有任何代码或脚本引用
`wip_updates`。所以要手动导入：

```bash
for f in sql/wip_updates/*.sql; do mysql -uroot -p tw_world < "$f"; done
```

（`mangos_string.sql` 也是导入世界库 —— 核心把 `mangos_string` 放在 world 库里。
导入前先备份，这些是 `REPLACE`/`UPDATE` 语句。）

### 2. 中文本地化：代码（3 处）

**2.1 脚本 NPC 的对话窗口总是英文**（`00712d2`、`c05197b`、`1aa8875`）

`Player::GetGossipTextId(WorldObject*)` 以前只看 `npc_gossip` 表，**不看生物自己的
gossip menu**。脚本用这个重载问「这个 NPC 用哪套问候语」（23 个脚本文件里 39 处调用，
全部传的是 `WorldObject*`），拿不到就返回 `DEFAULT_GOSSIP_MESSAGE` —— 而那个 id 在
`npc_text` 里不存在，客户端于是拿到硬编码的 `Greetings $N`。

- 增加了回退：没有 `npc_gossip` 覆盖时改用 `pSource->GetDefaultGossipMenuId()`
  （与 `SendPreparedGossip` 一致）
- 因此该重载**不能再是 `static`**（menu 行可能带条件，需要 `Player`）
- 3 个脚本跟着改成用生物自己的问候语：`searing_gorge.cpp`（垂死的考古学家）、
  `npc_captain_blackanvil.cpp`、`npc_janela_stouthammer.cpp`

**2.2 术士宠物名重载后中英混杂**（`df4b7dd`）

`ObjectMgr::LoadPetNames()` 重载时**没有先清空**两个 map，于是新音节**追加**在旧音节
后面：同一个槽位既有中文又有英文，`GeneratePetName` 随机取 half0+half1 时大约一半概率
拼出英文名；重复词还会让分布倾斜，删掉的行也永远删不掉。现在照 `LoadGossipMenu` 的做法
先 `clear()`。

### 3. 服务端缺陷修复（3 处）

**3.1 新建角色后角色列表不刷新**（`6702f81`、`4cb409b`）

`pNewChar->SaveToDB(false, true, false)` 的 `direct=false` 只把事务丢进 DB worker 队列
就返回 true，而客户端收到 `CHAR_CREATE_SUCCESS` 后**立刻**要新角色列表
（`AsyncPQuery` 走的是另一条队列）—— 两条队列之间没有顺序保证，于是新建的角色要重登
才出现，动作条/邮件也可能在进世界时还没落库。

- `MasterPlayer::SaveToDB(bool direct = false)`，内部按需用
  `CommitTransactionDirect()`
- 建角路径改为 `SaveToDB(false, true, true)` 与 `masterPlayer.SaveToDB(true)`

**3.2 商城物品名显示错（一直显示英文）**（`5be51ae`）

`ObjectMgr::LoadShop` 取中文名时把 **`LocaleConstant` 当成了数组下标**：

```cpp
GetItemLocaleName(Entry.Item, LOCALE_zhCN)   // 4
```

而 `ItemLocale::Name` 是按 `m_LocalForIndex` 的**位置**索引的，两者只偶然相等。中文库里
zhCN 落在下标 0，`Name[4]` 不存在 → 静默退回英文根基名。现在先问
`GetIndexForLocale(LOCALE_zhCN)`（客户端自己的物品查询就是这么做的），locale 没加载
（返回 -1）时直接走英文分支。

同时修掉 `GetItemLocaleName` 里的越界：`size() < loc_idx` 允许 `size() == loc_idx`，
那会读到 `operator[]` 的尾后位置。

**3.3 服务器起不来：荣誉维护里少一张表**

`ObjectMgr::BackupCharacterInventory()`（由启动时的荣誉维护调用，开关
`BackupCharacterInventory` 在默认配置模板里就是 **1**）开头就
`TRUNCATE \`character_inventory_copy\``，**却从不创建这张表**；而 `sql/` 里也从没有任何文件
定义过它（全仓库只有两处 C++ 引用它：这个函数和一个 GM 指令）。于是从公开 schema 建起来的
库里，第一次周维护就会：

```
[1146] Table 'tw_char.character_inventory_copy' doesn't exist
Your database structure is not up to date. ...
Assertion in HandleMySQLError failed: false   →   Aborted (core dumped)
```

更糟的是崩溃点在 `ToggleMaintenanceMarker()`（把标记翻回 0）**之前**，所以
`saved_variables.honorMaintenanceMarker` 会一直是 1 —— **之后每次启动都崩在同一处，服务器
再也起不来**。

修法（三处，互相独立）：

- 核心：`BackupCharacterInventory()` 先 `CREATE TABLE IF NOT EXISTS ... LIKE
  \`character_inventory\``（`LIKE` 才能保证列/索引/引擎跟着源表走，代码灌数据用的是
  `INSERT ... SELECT *`，而 `DISABLE KEYS` 只对 MyISAM 有效）
- `sql/create_databases.sql`：补上这张表（新装的库直接完整）
- `sql/database_updates/character/20261007114500_character.sql`：给已有库用
  （`CREATE TABLE IF NOT EXISTS ... LIKE ...`）

顺带修掉 `sql/setup_databases.sh` 的一个同类问题：它只 glob
`database_updates/*.sql`（顶层），而 149 个更新文件全在 `character/`、`world/` 子目录里，所以
它**一个都没导入**，还打印 "No SQL update files found" 后成功退出。现在按目录映射到对应的库
（`character`→`tw_char`、`world`→`tw_world`、`logon`→`tw_logon`、`logs`→`tw_logs`）逐个导入，
未知目录名会提示并跳过。

### 4. 新增功能：`Loot.RetryEmptyDrops`（`a720440`、`8fecf9d`）

**干什么**：掉落判定**一件普通物品都没出**时，重新判到出东西为止，让尸体不再是空的。

**为什么需要**：一个模板所有条目的概率都落空时，尸体上什么都没有 —— 这跟「打不开的
尸体」是同一回事：`gold == 0` 且 `unlootedCount == 0` → `isLooted()` 为真 → 客户端
**连可拾取标记都收不到**。例：`creature_loot_template` 80117（Haywire Battlechicken）
两件垃圾各自成组（30% / 70%），`0.7 × 0.3 = 21%` 的击杀是空的。

**用法**：

```ini
Loot.RetryEmptyDrops = 1     # 默认 0 = 保持原配置的概率，可用 .reload config 即时切换
```

**三个安全设计**（都是不这么写就会出 bug 的地方）：

1. **不会重复收集任务物品**：出空的那一次 pass 已经把任务掉落放进 `m_questItems` 了，
   而每个 pass 产出的任务物品都一样 —— 直接重投会把 80117 变成掉两个机械鸡腿。
   重投期间用 `Loot::m_suppressQuestItems` 屏蔽。
2. **不会死循环**：模板永远出不了普通物品时（整张表只有任务掉落），`items` 永远是空的。
   `LootTemplate::CanDropNonQuestItem()`（加载表时记录）直接跳过这类模板，
   另外重投次数硬上限 10 次（`0.21^10 ≈ 1e-7`，靠运气碰不到）。
3. **已经掉了钱的尸体不动**：`Unit::Kill` 改成了**先生成金钱再填掉落**，条件为
   `items.empty() && gold == 0`。判断依据是**这次真的掉了钱**，不是「模板里配了钱」——
   所以 `gold_max = 1` 而这次投出 0 金币的怪仍然会被补一件（那具尸体确实点不开）。

**作用范围**：只有生物掉落。宝箱、钓鱼、偷窃、剥皮、分解、邮件都不受影响
（`LootStore` 构造第 4 个参数按 store opt-in）。

**代价**：单件物品的实际掉率会上升，因为空手那部分被重新分配了。以 80117 为例，
打开后 Loose Cog 从 30% 升到约 38%、Rusty Screw 从 70% 升到约 88.6%
（条件概率 `0.30/0.79`、`0.70/0.79`）—— 这是「重投到出东西为止」的数学必然，
不是 bug，也是它默认关闭的原因。

### 5. 配置模板补文档（`c518f2e`，`mangosd.conf.dist.in`）

上游有两个键**在代码里存在但没写进配置模板**，所以 `grep` 不到：

- **`NiHao`**（默认 0，代码里的名字是 `CONFIG_BOOL_SEA_NETWORK`）：中国区模式总开关，
  全代码 12 处判定，例如商城取 `_loc4` 名字（`ObjectMgr`/`ChatHandler` 各一处）、
  中国区商城条目是否发出（`ObjectMgr` 的区域判定）、插件指纹查重是否跳过
  （`AddonHandler`）、公会名是否按宽字符校验（`Commands`，开了才允许中文公会名）、
  删角时 CN 专属返还物品（`Player`）、`char_transfer_names` 保留名（`ObjectMgr`）、
  非 CN 时公共频道对某个刷屏插件的限速（`ChatHandler`）、CN 风物掉率补一件物品
  （`random_scripts_3`）
- **`EnforceEnglish`**（默认 0）：公共频道禁非 ASCII，是 EU 服的 `NiHao` 反面

本分支把它们按默认值写进模板并逐条注释，另加一条前置说明：开 `NiHao=1` 之前必须先建
`char_transfer_names`（`sql/tools/tool_sea_add_char_transfer_names.sql`），否则启动时
报 SQL 错。

### 6. 新增工具（`76ae40a` 起，共 84 个文件）

**6.1 `tools/WowWeb/` —— 账号网站（Go，78 个文件）**

一套独立服务，只读写核心库、不需要改核心：

- **公开**：注册（限流）、登录（用**游戏账号密码**）、`/alert`（客户端登录界面公告）、
  `/notice`、`/account/{banned,suspended,no-time,verify}`、`/api/status`、`/healthz`、
  中英切换
- **玩家面板**：账号概览、角色列表与**解卡住**、改密码、**2FA（TOTP）**、会话管理
- **管理后台**：账号/角色查询与操作、封禁与 IP 封禁、禁言、领域编辑、
  **登录界面公告**（`/admin/announcement`）、**捐赠商城**（`/admin/shop` 条目 +
  `/admin/shop/categories` 类别）、审计日志
- **数据库浏览器**（`/db`，公开）：物品/法术/任务/生物的搜索、列表与详情页，直读核心自己的
  内容表（不复制 AoWoW 的 `aowow_*` 库）；中文读者取 `*_loc4` 列、其它语言取基列，
  名称来自核心的枚举头文件

细节见 [`tools/WowWeb/README.md`](tools/WowWeb/README.md)（中英双语，含配置项、权限、
反代、限流、以及每个「静默失败」条件的说明）。两个额外的运维文件：

- `deploy/verify_shop.sql` —— 用**服务自己的数据库账号**把商城 SQL 跑一遍，
  写入的部分放在会回滚的事务里，不留数据
- `deploy/nginx/twow.home.boym.me.conf` —— 80 端口反代（客户端只肯打开 80 端口的
  `http://域名` 链接，且 `/alert` 不能被重定向）

**6.2 `tools/I18nKit/` —— 汉化缺口清单工具（Python）**

把还缺中文的客户端可见文本导成待翻译清单。为什么需要它：任务文本只在服务端（1.12 客户端的
DBC 不存任务文本），官方 zhCN 又只覆盖官方内容，所以 Turtle 自定义任务（Balor 等）**哪儿都没有
中文可参考** —— 约 6700 个任务里 214 个连标题都没有中文。

`export_missing_quests.py` 调系统里的 `mysql` 客户端（无需 Python 依赖），产出三份文件：

- `quests-missing.md` —— 按**任务链**分组的可读清单，带等级、给予者、上交对象、前后置任务
- `quests-missing.csv` —— 给电子表格
- `quests-missing.template.sql` —— 可直接填空的 `INSERT ... ON DUPLICATE KEY UPDATE`，
  英文原文放在注释里，填完导入即生效（**只写 `*_loc4` 列**）

判定规则是「**英文有内容、`*_loc4` 为空**」—— 英文本来就空的列不算缺口。结果行数异常时会
**报警并统计**，全部异常时直接失败退出（清单漏行比工具报错更糟）。

**6.3 `tools/ClientPatch/` —— 客户端补丁生成器（Python，6 个文件）**

按补丁优先级解析客户端 MPQ，从**当前生效**的那份基准生成 `patch-Z.mpq`：

- `gen_patchz.py` —— 生成器：`luaAssignments`（改 `KEY = "值"`）、`luaRewrites`
  （整段替换，找不到就**失败**而不是静默跳过）、`frameEdits`（删界面框架并**自动改嫁
  锚定链**）
- `patch_urllist.py` —— 等长覆盖 exe 内置的 URL 白名单（不能改长度）
- `verify_client.py` —— 校验补丁与 exe 是否配套（地址形状、白名单、键可达性、
  界面文字来源），退出码 0/1/2
- `overrides.json` —— 配置：公告与失败对话框的地址、要删的按钮、
  商城窗口标题与「关于」正文

细节见 [`tools/ClientPatch/README.md`](tools/ClientPatch/README.md)。它同时记录了从
`WoW.exe` 反汇编出来的 `LaunchURL` 硬规则（必须 `http://`、**不能带端口**、
字符集受限、主机要过白名单）、公告面板的 `SERVERALERT:` 协议、以及「哪些键真的有人
调用」的扫描结论。

### 7. 本分支新增的配置项一览

| 名称 | 位置 | 默认 | 说明 |
|---|---|---|---|
| `Loot.RetryEmptyDrops` | `mangosd.conf` | `0` | 掉落一件不出时重投（第 4 节） |
| `NiHao` | `mangosd.conf` | `0` | 中国区模式；本分支补进模板并注释 |
| `EnforceEnglish` | `mangosd.conf` | `0` | EU 服公共频道禁非 ASCII |
| `SHOP_REGION` | 网站环境变量 | `europe` | 商城的区域判定，对齐核心的 `NiHao` |

### 8. 验证状态（如实）

| 部分 | 验证方式 |
|---|---|
| 本地化 SQL | 已在你的服务器导入并生效（商城、NPC 对话等显示中文） |
| `tools/WowWeb` | `gofmt` / `go build` / `go vet` / `go test ./...` 全过；商城 SQL 用 `deploy/verify_shop.sql` 在真库上验过 |
| `tools/ClientPatch` | `verify_client.py` 对打过白名单的 `WoW.exe` 退出码 0；生成的 `patch-Z.mpq` 逐字节回读比对过 |
| 服务端核心改动 | **写这些改动的机器上没有 ACE，无法本地编译** —— 都由你在服务器上构建。商城中文名（3.2）你已实测确认；建角同步落库（3.1）与 gossip 回退（2.1）是纯顺序/取值修复，逻辑上无副作用但未收到单独回报；宠物名清空（2.2）要重载后才会体现 |
| `Loot.RetryEmptyDrops` | **尚未在任何真实构建里运行过**。只做了「原样抽出代码 + 桩编译（`-Wall -Wextra` 零警告）+ 20 万次模拟」：关闭时空手 20.97%、打开后 0.00%、任务物品数量恒为 1、平均 1.264 次 Process/击杀；掉钱的怪平均 1.000 次（被跳过）；全任务物品的模板重投 0 次 |

### 9. 部署与升级须知

1. **本地化 SQL 要手动导入**（第 1 节），`wip_updates/` 不会被自动应用
2. **服务端改动要重新编译** mangosd；改完 `Loot.RetryEmptyDrops` 或 `NiHao` 可以
   `.reload config` 即时生效，但掉落表/商城表的**内容**改动需要
   `.reload creature_loot_template` / `.reload shop`
3. **客户端补丁**：把 `patch-Z.mpq` 拷进客户端 `Data/` 并**完全重启客户端**；
   注意它会整份携带 `GlobalStrings.lua`，汉化包更新后要重跑 `gen_patchz.py`
4. **上游合并**：本分支基点 `187af78`，上述所有改动都集中在少数文件里
   （`git diff --stat 1181dev...1181-zhcn-localization -- src/` 只有 16 个文件、
   `+206 −18`；全部 18 行删除都在这 16 个文件里），方便跟着上游 rebase；上游 `main`
   现在已是本分支的祖先（第 10 节），以后再合 `main` 不会带进历史包袱

### 10. 上游同步状态

上游 [`main`](https://github.com/tortoise-wow/tortoise-wow) 的最新提交 `d94947b`
（2026-09-29，「Merging SOAP Interface, Windows build/deploy fixes, and creature HP
clamping」）已并入本分支，合并提交 `ad4ff55`。

它是一次**纯同步合并，一个文件都没改**：

- `d94947b` 的两个父是 `4f4fcaa`（`main` 的旧头，9-16）和 `187af78`（`1181dev`，9-24，
  **也就是本分支的基点**），而 `4f4fcaa` 本身是 `187af78` 的祖先 —— 上游只是把 `main`
  追平到 `1181dev` 这条线上来
- `git diff 187af78 d94947b` **为空**，两个提交树哈希相同（`679b28d`），因此这次合并既
  不改动任何文件，也不可能有冲突

所以它标题里那三项**早就在我们的基点里**：

| 它声称合并的 | 在我们基点里的位置 |
|---|---|
| SOAP 接口 | `src/mangosd/MaNGOSsoap.{cpp,h}`、`src/mangosd/soap/`、`dep/src/gsoap/`、`docs/management/soap-remote-command-interface.md` |
| Windows 构建/部署文档修复 | PR #519（提交 `4f4fcaa`） |
| 生物零血量钳制（HP clamping） | PR #525 —— 基点 `187af78` **本身就是**这个 PR 的合并提交 |

自己确认：

```bash
git merge-base --is-ancestor main HEAD && echo "main 已是本分支的祖先"
git diff --stat 187af78 d94947b        # 空
git rev-parse 187af78^{tree} d94947b^{tree}   # 两行相同
```

---

## English

### 1. Chinese localisation: the data (`sql/wip_updates/`, 23 SQL files + 1 note)

Official zhCN text loaded into the core's `locales_*` tables and a few text tables. Each
file is named after the table it fills: `locales_item`, `locales_spell`,
`locales_creature`, `locales_quest`, `locales_broadcast_text`, `locales_gameobject`,
`locales_page_text`, `locales_points_of_interest`, `mangos_string`, `creature_template`,
`npc_text`, `quest_greeting`, `npc_trainer_greeting`, `gossip_menu`, `broadcast_text`,
`chat_channels`, `script_texts`, `pet_name_generation`, plus
`README-client-patch.md` (the part of the translation that only exists in client
assets, and the patch that carries it).

Five of those fill quest text that the official zhCN data never covered, for quests a
player can **still pick up** today (one with a giver in `creature_questrelation` /
`gameobject_questrelation` that actually spawns in `creature` / `gameobject`; the
recomputation tool is `tools/I18nKit/`):
`locales_quest_extra.sql` (178 missing titles), `locales_quest_fixes.sql` (456 titles
rewritten for mistranslation/awkward phrasing, 110 reviewed and kept),
`locales_quest_objectives.sql` (750 objectives), `locales_quest_rewards.sql` (483
completion texts) and `locales_quest_details.sql` (755 details — 568 distinct texts
after deduplication). Every row was checked to mirror its English source's `$B`/`$N`/`$C`
placeholders exactly and to contain no leftover English.

(`ls sql/wip_updates/` also lists `create_update.sh` and `what-are-these.txt` — both are
upstream's own files, not part of this branch. This branch adds the 23 SQL files above
plus the one note.)

**⚠️ This SQL is not applied automatically.** `CONTRIBUTING.md` defines
`sql/wip_updates/` as the holding area for updates **pending** a proper merge, and
`Database.AutoUpdate.Path` only scans `Logon` / `character` / `world` under
`sql/database_updates/` — nothing in the repository references `wip_updates`. Import it
by hand:

```bash
for f in sql/wip_updates/*.sql; do mysql -uroot -p tw_world < "$f"; done
```

(`mangos_string.sql` goes to the world database too — that is where the core keeps the
table. Back up first: these are `REPLACE`/`UPDATE` statements.)

### 2. Chinese localisation: the code (3 fixes)

**2.1 A scripted NPC's gossip window is always English** (`00712d2`, `c05197b`, `1aa8875`)

`Player::GetGossipTextId(WorldObject*)` only consulted the `npc_gossip` table and never
the creature's own gossip menu. Scripts use that overload to ask "which greeting does
this NPC use" (39 call sites in 23 script files, every one of them passing a
`WorldObject*`); when it found nothing it returned `DEFAULT_GOSSIP_MESSAGE`, an id that
does not exist in `npc_text`, so the client was shown the hardcoded `Greetings $N`.

* Added the fallback: with no `npc_gossip` override, use
  `pSource->GetDefaultGossipMenuId()`, the same way `SendPreparedGossip` does.
* The overload therefore **cannot stay `static`** (menu rows can carry conditions and
  so need the `Player`).
* Three scripts were changed to ask the creature for its own greeting:
  `searing_gorge.cpp` (the dying archaeologist, whose window still passed
  `DEFAULT_GOSSIP_MESSAGE` by hand), `npc_captain_blackanvil.cpp` and
  `npc_janela_stouthammer.cpp`.

**2.2 Warlock pet names mix languages after a reload** (`df4b7dd`)

`ObjectMgr::LoadPetNames()` did not clear its two maps, so a reload **appended** the new
syllables to the ones already in memory: one slot held both the Chinese and the English
word, `GeneratePetName` picks half0 + half1 at random, and roughly half the freshly
summoned demons still came out English. Duplicates also skew the distribution and a
deleted row can never be removed. It now clears first, like `LoadGossipMenu` does.

### 3. Server bug fixes (3)

**3.1 A new character is missing until the player relogs** (`6702f81`, `4cb409b`)

`pNewChar->SaveToDB(false, true, false)` queues the transaction for a DB worker and
returns true; the client reacts to `CHAR_CREATE_SUCCESS` by immediately asking for a
fresh character list, and `AsyncPQuery` reads go to a **different** queue. Two queues
give no ordering, so the new character was absent until a reconnect and the action bars
or mail could still be missing when the player entered the world.

* `MasterPlayer::SaveToDB(bool direct = false)`, using `CommitTransactionDirect()` when
  asked to.
* The create-character path now passes `true` for both saves.

**3.2 Shop items always showed their English name** (`5be51ae`)

`ObjectMgr::LoadShop` looked the Chinese name up with a **`LocaleConstant` used as an
array index**:

```cpp
GetItemLocaleName(Entry.Item, LOCALE_zhCN)   // 4
```

`ItemLocale::Name` is keyed by `m_LocalForIndex` **positions**, which coincide with the
constants only by accident. On a database that carries Chinese alone, zhCN sits at 0,
`Name[4]` does not exist, and the lookup silently fell back to the English base name.
It now asks `GetIndexForLocale(LOCALE_zhCN)` first — what the client's own item query
does — and takes the English branch when the answer is -1.

`GetItemLocaleName` also had an off-by-one: `size() < loc_idx` admits
`size() == loc_idx`, which reaches `operator[]` one past the end.

**3.3 The server would not start: a table the honor maintenance needs**

`ObjectMgr::BackupCharacterInventory()` - called by the honor maintenance that runs
at startup, behind `BackupCharacterInventory`, which the shipped configuration sets
to **1** - begins with `TRUNCATE \`character_inventory_copy\`` and **never creates
that table**. No file in `sql/` defined it either (the whole repository mentions it
in exactly two places, both C++: that function and one GM command). So on a database
built from the published schema the first weekly maintenance hit:

```
[1146] Table 'tw_char.character_inventory_copy' doesn't exist
Your database structure is not up to date. ...
Assertion in HandleMySQLError failed: false   →   Aborted (core dumped)
```

Worse, the abort happens *before* `ToggleMaintenanceMarker()` flips
`saved_variables.honorMaintenanceMarker` back to 0, so the marker stays 1 and
**every later startup crashes in the same place - the realm cannot come back up**.

Three independent fixes:

* core: `BackupCharacterInventory()` now starts with `CREATE TABLE IF NOT EXISTS ...
  LIKE \`character_inventory\``; `LIKE` is what keeps the columns, indexes and
  engine following the source table (the fill is `INSERT ... SELECT *`, and
  `DISABLE KEYS` only means anything on MyISAM).
* `sql/create_databases.sql`: the table is part of the schema now, so a fresh
  installation is complete.
* `sql/database_updates/character/20261007114500_character.sql`: for databases that
  are updated without a rebuild.

While there, `sql/setup_databases.sh` had the same shape of problem: it globbed only
`database_updates/*.sql` at the top level, while all 149 update files live in the
`character/` and `world/` subfolders - so it imported **none** of them and exited
successfully after printing "No SQL update files found". It now maps each folder to
its database (`character`→`tw_char`, `world`→`tw_world`, `logon`→`tw_logon`,
`logs`→`tw_logs`) and says so when it meets an unknown one.

### 4. New feature: `Loot.RetryEmptyDrops` (`a720440`, `8fecf9d`)

**What**: when a loot roll produces **no normal item at all**, roll again until something
drops, so a corpse is never empty.

**Why**: a template whose every chance missed leaves a corpse with nothing on it — which
is the same thing as an unopenable corpse, because `gold == 0` and `unlootedCount == 0`
make `isLooted()` true and the client is never even sent the lootable flag. For
`creature_loot_template` 80117 (Haywire Battlechicken), two single-entry groups at 30%
and 70% miss together on `0.7 × 0.3 = 21%` of kills.

**Use**:

```ini
Loot.RetryEmptyDrops = 1     # default 0 = keep the configured chances; .reload config applies it live
```

**Three safety properties**, each of which is a bug if left out:

1. **Quest drops are not collected twice.** The pass that produced no item did produce
   the quest drops, and every pass yields the same ones, so a plain re-roll would stack
   them — 80117 would hand out two Mechanical Drumsticks. `Loot::m_suppressQuestItems`
   suppresses them while re-rolling.
2. **It cannot loop forever.** A template that can never yield a non-quest item (one
   that is only quest drops) keeps `items` empty.
   `LootTemplate::CanDropNonQuestItem()`, recorded while the table loads, skips those
   outright, and the attempts are capped at 10 anyway (`0.21^10 ≈ 1e-7`).
3. **A corpse that already has coin is left alone.** `Unit::Kill` now generates the
   money *before* filling the loot, and the condition is
   `items.empty() && gold == 0`. The test is on the coin the kill actually produced, not
   on whether the creature is configured to drop any, so a creature with `gold_max = 1`
   whose roll came out zero still gets the guaranteed item — that corpse is genuinely
   unopenable.

**Scope**: creature loot only. Chests, fishing, pickpocketing, skinning, disenchanting
and mail are untouched (the store opts in through `LootStore`'s fourth constructor
argument).

**Cost**: the effective drop rate of each individual item rises, because the empty
outcome is redistributed. For 80117, Loose Cog goes from 30% to about 38% and Rusty
Screw from 70% to about 88.6% (the conditional probabilities `0.30/0.79`, `0.70/0.79`).
That is arithmetic, not a bug — and it is why the switch defaults to off.

### 5. Two config keys documented (`c518f2e`, `mangosd.conf.dist.in`)

Upstream has two keys that exist in the code but were never added to the configuration
template, so `grep NiHao mangosd.conf` finds nothing:

* **`NiHao`** (default 0, known in the code as `CONFIG_BOOL_SEA_NETWORK`) — the
  China-region switch, tested in 12 places: the shop reads `_loc4` names (`ObjectMgr` and
  `ChatHandler`), whether the China-region shop rows are sent at all (`ObjectMgr`'s region
  test), whether the addon fingerprint duplicate check is skipped (`AddonHandler`),
  whether guild names are validated as wide characters (`Commands` — Chinese guild names
  only work with it on), the China-specific items refunded on character deletion
  (`Player`), the reserved names from `char_transfer_names` (`ObjectMgr`), a public-channel
  throttle against one spamming addon (`ChatHandler`), and an extra cosmetic drop
  (`random_scripts_3`).
* **`EnforceEnglish`** (default 0) — blocks non-ASCII in public chat; the EU counterpart
  to `NiHao`.

Both are written into the template at their default value with a comment per behaviour,
plus the prerequisite for turning `NiHao` on: `char_transfer_names` has to exist
(`sql/tools/tool_sea_add_char_transfer_names.sql`) or the world server logs a SQL error at
startup.

### 6. New tools (from `76ae40a`, 84 files)

**6.1 `tools/WowWeb/` — the account website (Go, 78 files)**

A separate service that only reads and writes the game's databases; no core changes.

* **Public**: registration (rate limited), sign-in with the **game** account and
  password, `/alert` (the login-screen notice the client fetches), `/notice`,
  `/account/{banned,suspended,no-time,verify}`, `/api/status`, `/healthz`, language
  switching.
* **Player panel**: account overview, characters with an **unstick**, password change,
  **two-factor authentication (TOTP)**, browser session management.
* **Administration**: account and character search and actions, bans and IP bans, mutes,
  realm editing, the **login announcement** (`/admin/announcement`), the **donation shop**
  (`/admin/shop` for items, `/admin/shop/categories` for categories), and an audit log.
* **Database browser** (`/db`, public): search, lists and detail pages for items, spells,
  quests and creatures, read straight from the core's own content tables (no AoWoW
  `aowow_*` copy); a Chinese reader gets the `*_loc4` columns, everyone else the base
  ones, and the names come from the core's own enum headers.

See [`tools/WowWeb/README.md`](tools/WowWeb/README.md) for configuration, database
privileges, reverse proxying, brute-force limits and every "silently fails" condition it
guards against. Two operational files come with it:

* `deploy/verify_shop.sql` — runs the shop's own queries against your database as the
  account the service uses, wrapping the writes in a transaction it rolls back.
* `deploy/nginx/twow.home.boym.me.conf` — the port-80 reverse proxy the client needs
  (it only opens `http://domain` links on port 80, and `/alert` must not be redirected).

**6.2 `tools/I18nKit/` — the translation-gap worklist tool (Python)**

Turns client-visible text that has no Chinese yet into a worklist. It exists because quests
fall outside both real sources: a 1.12 client keeps no quest text (it is server-side only) and
official zhCN covers official content only, so a Turtle custom quest such as the Balor chains
has **no Chinese anywhere to copy from** - 214 of roughly 6700 quests have no Chinese title at
all.

`export_missing_quests.py` drives the `mysql` client (no Python dependencies) and writes:

* `quests-missing.md` - a readable sheet grouped by **quest chain**, with level, giver,
  turn-in, and the previous and next quest
* `quests-missing.csv` - the same rows for a spreadsheet
* `quests-missing.template.sql` - ready-to-fill `INSERT ... ON DUPLICATE KEY UPDATE`
  statements with the English in the comments; import it and the text is live (it only writes
  the `*_loc4` columns)

A column counts as a gap when the **English has text and `*_loc4` is empty**; columns that are
empty in English are not gaps. Malformed result rows are **counted and reported**, and the run
fails if every row is malformed - a worklist that quietly loses rows is worse than a tool that
stops.

**6.3 `tools/ClientPatch/` — the client patch builder (Python, 6 files)**

Resolves the client's MPQ priority order and builds `patch-Z.mpq` from the currently
effective base:

* `gen_patchz.py` — `luaAssignments` (rewrite `KEY = "value"`), `luaRewrites` (literal
  text replacement that **fails** rather than silently skipping), `frameEdits` (delete
  interface frames and **re-anchor the chain**).
* `patch_urllist.py` — equal-length rewrite of the executable's built-in URL whitelist
  (the length cannot change).
* `verify_client.py` — checks that the patch and the executable agree (address shape,
  whitelist, key reachability, where each string comes from), exit code 0/1/2.
* `overrides.json` — the addresses for the notice and the failure dialogs, the buttons to
  remove, the shop window title and About text.

See [`tools/ClientPatch/README.md`](tools/ClientPatch/README.md), which also documents
the `LaunchURL` rules recovered from `WoW.exe` by disassembly (`http://` only, **no
port**, a restricted character set, host must be whitelisted), the `SERVERALERT:`
protocol the notice panel speaks, and the scan results for which keys anything actually
calls.

### 7. Configuration keys this branch adds

| Name | Where | Default | Meaning |
|---|---|---|---|
| `Loot.RetryEmptyDrops` | `mangosd.conf` | `0` | Re-roll a drop that produced nothing (section 4) |
| `NiHao` | `mangosd.conf` | `0` | China-region mode; documented in the template by this branch |
| `EnforceEnglish` | `mangosd.conf` | `0` | Blocks non-ASCII in public chat on an EU realm |
| `SHOP_REGION` | website environment | `europe` | The shop's region, mirroring the core's `NiHao` |

### 8. Verification status (honestly)

| Part | How it was verified |
|---|---|
| Localisation SQL | Imported on your server and in use (the shop, NPC dialogue and more are Chinese) |
| `tools/WowWeb` | `gofmt`, `go build`, `go vet`, `go test ./...` all pass; the shop's SQL ran against the real database through `deploy/verify_shop.sql` |
| `tools/ClientPatch` | `verify_client.py` exits 0 against the patched `WoW.exe`; the generated `patch-Z.mpq` was read back and compared byte for byte |
| Core changes | **The machine they were written on has no ACE and cannot build the server** — you build them. The shop name fix (3.2) is confirmed working on your realm; the synchronous character save (3.1) and the gossip fallback (2.1) are ordering/value fixes that are side-effect free in principle but were never reported back on individually; the pet-name clear (2.2) only shows on a reload |
| `Loot.RetryEmptyDrops` | **Has never run in a real build.** Verified by extracting the added code verbatim into a harness, compiling it (`-Wall -Wextra`, no warnings) and running 200k simulated kills: 20.97% empty with the switch off, 0.00% with it on, exactly one quest item per corpse, 1.264 Process calls per kill; a coin-dropping creature 1.000 (skipped); a quest-only template re-rolled 0 times |

### 9. Deploying and upgrading

1. **Import the localisation SQL by hand** (section 1); `wip_updates/` is not applied
   automatically.
2. **Rebuild mangosd** for the core changes. `Loot.RetryEmptyDrops` and `NiHao` apply
   with `.reload config`, but the *contents* of the loot and shop tables need
   `.reload creature_loot_template` and `.reload shop`.
3. **Client patch**: copy `patch-Z.mpq` into the client's `Data/` folder and **fully
   restart the client**. It carries `GlobalStrings.lua` wholesale, so re-run
   `gen_patchz.py` after the localisation pack updates.
4. **Merging upstream**: this branch is based on `187af78` and all of the above lives in a
   small number of files (`git diff --stat 1181dev...1181-zhcn-localization -- src/` is
   16 files, `+206 −18`; those same 16 files hold every one of the 18 deleted lines),
   which keeps rebasing cheap. Upstream `main` is now an ancestor of this branch
   (section 10), so later merges of `main` carry no historical baggage.

### 10. Upstream sync status

Upstream `main`'s latest commit, `d94947b` (2026-09-29, "Merging SOAP Interface, Windows
build/deploy fixes, and creature HP clamping"), is merged into this branch as `ad4ff55`.

It is a **pure catch-up merge that changes no files at all**:

* `d94947b`'s two parents are `4f4fcaa` (`main`'s old tip, Sep 16) and `187af78`
  (`1181dev`, Sep 24 — **this branch's own base**), and `4f4fcaa` is itself an ancestor of
  `187af78`: upstream simply brought `main` up to the `1181dev` line.
* `git diff 187af78 d94947b` is **empty** and the two commits share a tree hash
  (`679b28d`), so merging it cannot change a file or conflict with anything.

So all three things in its title were **already in our base**:

| What it says it merges | Where it lives in our base |
|---|---|
| The SOAP interface | `src/mangosd/MaNGOSsoap.{cpp,h}`, `src/mangosd/soap/`, `dep/src/gsoap/`, `docs/management/soap-remote-command-interface.md` |
| Windows build/deploy documentation fixes | PR #519 (commit `4f4fcaa`) |
| Creature HP clamping | PR #525 — the base `187af78` **is** that pull request's merge commit |

To check it yourself:

```bash
git merge-base --is-ancestor main HEAD && echo "main is an ancestor of this branch"
git diff --stat 187af78 d94947b        # empty
git rev-parse 187af78^{tree} d94947b^{tree}   # both lines identical
```
