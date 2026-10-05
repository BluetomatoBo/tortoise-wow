# 中文客户端补丁 / Chinese Client Patch

**客户端资源（音视频、DBC 字符串）与本目录的 SQL 是两回事。**
**Client assets (audio/video, DBC strings) are separate from the SQL in this folder.**

本目录的 SQL 修的是**服务端**发出去的文本（NPC 对话、物品、法术、任务）。
另有一小部分中文只存在于**客户端**资源里，服务端改不了，只能靠客户端补丁。

The SQL in this folder fixes text the **server** sends (NPC dialogue, items,
spells, quests). A small remainder only exists in **client** assets, which no
server change can reach - that part needs a client patch.

下载 / Download:
<https://github.com/BluetomatoBo/tortoise-wow/releases/tag/client-zhcn-patch-v1.0>

生成该补丁的工具在 [`tools/ClientPatch/`](../../tools/ClientPatch/)；
公告内容的编辑界面在 [`tools/WowWeb/`](../../tools/WowWeb/) 的 `/admin/announcement`。

The tool that builds the patch lives in [`tools/ClientPatch/`](../../tools/ClientPatch/);
the announcement editor is `/admin/announcement` in [`tools/WowWeb/`](../../tools/WowWeb/).

---

## 中文说明

### 为什么需要它

乌龟服 1.18.1 客户端的 `patch-Z.mpq` 已经是一个**相当完整的中文汉化包**
（中文语音 3629/3631、界面文本、中文字体、世界地图贴图、过场旁白）。
但对照官方 1.12.1 简体中文客户端后，发现几处缺口：

| 现象 | 原因 |
|---|---|
| NPC 说中文，但**术士恶魔**下令、击杀、解散时说的是**英文** | `patch-Z.mpq` 没有恶魔 VO，于是回落到 `patch.MPQ` 里的英文版 |
| 开场动画**没有中文字幕** | `Interface\Cinematics\*.sbt` 是英文 |
| 崩溃报告 / EULA / 服务条款 是英文 | 同上 |

另外两处**不需要处理**：客户端 DBC 本身就是多语言的（`Map.dbc` 同一字段同时带
`Azeroth / Eastern Kingdoms / 东部王国` 等），中文语音与界面文本也都完整。

### 补丁内容（135 条目）

| 内容 | 条目数 |
|---|---|
| 术士恶魔中文语音（每个文件写两套路径） | 126 |
| 开场动画中文字幕 `WOW_Intro_800/1024.sbt` | 2 |
| 中文版 `eula.html` / `tos.html` / `connection-help.html` | 3 |
| `WowError_Strings.dbc` / `ItemSubClassMask.dbc` / `PetPersonality.dbc`（zhCN 填空） | 3 |
| `(listfile)` | 1 |

覆盖 `ImpVO`(12) / `SuccubusVO`(17) / `VoidWalkerVO`(17) / `DoomGuardVO`(17)。
每个文件都写了两套路径（`Sound\Creature\ImpVO\...` 与裸 `ImpVO\...`），兼容两种查找方式。

### 安装

1. **完全退出游戏客户端**
2. 把 `patch-A.mpq` 复制到客户端 `Data` 目录：`<客户端>/Data/patch-A.mpq`
3. 重新启动客户端

不用改配置，也不用动服务端。

### 验证

- **开场动画**：应显示中文字幕
- **恶魔语音**：召唤恶魔后分别触发三种回应（每种随机挑一个文件，多试几次能听全）
  - 下令：右键让它攻击敌人
  - 击杀：让它打死一个目标
  - 解散：点解散宠物
  - 另有 `*_FUNNY.wav`（长时间放置或反复点击宠物时的"不耐烦"台词）

### 已知情况

- `IMP_DISMISS05.wav` 中文族里没有，未包含。
- 地狱火与地狱犬**无需处理**：DBC 里本就没有它们的 VO 条目。
- 若日后乌龟服更新也占用了 `patch-A`，改名为任意未占用的单字符即可
  （`patch-B` ~ `patch-Y` 都空着）。客户端加载模式是 `patch.MPQ` + `patch-?.MPQ`。

### 数据来源与验证方法

- 来源：官方 1.12.1 简体中文客户端 `patch-2.MPQ` 的 `speech2\` 一族
- **判定该族是中文的方法**：与**英文原版**（乌龟服客户端 `patch.MPQ`）逐一比对 ——
  `speech2\` 族从不等于英文族，而裸路径族 100% 逐字节等于英文族，故 `speech2\` 为中文
- 打包后逐条回读：63 个规范路径条目**逐字节等于中文源**

---

## English

### Why it is needed

The Turtle WoW 1.18.1 client ships `patch-Z.mpq`, already a **thorough Chinese
localisation pack** (voice lines 3629/3631, UI text, Chinese fonts, world map
art, cinematic narration). Comparing it against the official 1.12.1 Simplified
Chinese client turned up a few gaps:

| Symptom | Cause |
|---|---|
| NPCs speak Chinese, but **warlock demons** answer orders, kills and dismissals **in English** | `patch-Z.mpq` has no demon VO, so it falls back to the English copy in `patch.MPQ` |
| The intro cinematic has **no Chinese subtitles** | `Interface\Cinematics\*.sbt` is English |
| Crash reporter / EULA / Terms of Service are English | same |

Two other areas need **no work**: the client DBCs are already multilingual
(a single `Map.dbc` field carries `Azeroth / Eastern Kingdoms / 东部王国` and
so on), and both the Chinese voice set and the UI text are complete.

### Contents (135 entries)

| Item | Entries |
|---|---|
| Warlock demon voice lines in Chinese (each file under two paths) | 126 |
| Chinese subtitles for the intro cinematic `WOW_Intro_800/1024.sbt` | 2 |
| Chinese `eula.html` / `tos.html` / `connection-help.html` | 3 |
| `WowError_Strings.dbc` / `ItemSubClassMask.dbc` / `PetPersonality.dbc` (zhCN cells filled) | 3 |
| `(listfile)` | 1 |

Covers `ImpVO` (12) / `SuccubusVO` (17) / `VoidWalkerVO` (17) / `DoomGuardVO` (17).
Every file is stored under two paths (`Sound\Creature\ImpVO\...` and a bare
`ImpVO\...`) so either lookup style resolves.

### Installation

1. **Fully exit the game client**
2. Copy `patch-A.mpq` into the client's `Data` folder: `<client>/Data/patch-A.mpq`
3. Start the client again

No configuration changes and no server-side changes needed.

### How to verify

- **Intro cinematic**: should show Chinese subtitles
- **Demon voices**: summon a demon and trigger each of the three kinds of
  response (each plays a random file from its set, so repeat a few times)
  - Order: right-click and send it to attack something
  - Kill: let it kill a target
  - Dismiss: dismiss the pet
  - `*_FUNNY.wav` lines play when the pet is left idle or clicked repeatedly

### Known points

- `IMP_DISMISS05.wav` does not exist in the Chinese family, so it is not included.
- Infernal and Felhunter need **nothing**: there are no `*VO` entries for them
  in the DBC at all.
- If a future Turtle WoW update also uses `patch-A`, rename this file to any
  unused single character (`patch-B` through `patch-Y` are free). The client's
  load pattern is `patch.MPQ` plus `patch-?.MPQ`.

### Source and how it was verified

- Source: the `speech2\` family inside `patch-2.MPQ` of the official 1.12.1
  Simplified Chinese client
- **How that family was identified as Chinese**: compared file by file against
  the English original (the Turtle client's `patch.MPQ`) - the `speech2\` family
  never matches it, while the bare-path family matches byte for byte, so
  `speech2\` is the Chinese set
- After packaging every entry was read back: the 63 canonical-path entries are
  **byte-identical to the Chinese source**
