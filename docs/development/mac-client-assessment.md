# macOS 原生客户端可行性评估（benilla × tortoise-wow）

2026-10-12 评估。背景：玩家在本机是 macOS，官方只能跑 Windows 客户端（Wine/虚拟机）；
社区出现了一个从零写的 1.12.1 客户端，问「能不能做成这台服务器的 Mac 客户端」。

## 一、评估对象：benilla

<https://github.com/samwhosung/benilla> —— **从零用 Rust + Bevy 写的完整 1.12.1 客户端**
（Apache/MIT，679★，2026-07 起持续开发，无预编译包，必须源码编译）。

* 自带全套格式读取（MPQ 补丁链、BLP、DBC、ADT/WDT/WDL、M2、WMO）、世界渲染、M2 骨骼动画、
  SRP6 认证 + 世界协议 + 对象镜像、FrameXML/Lua 界面引擎（1.12 原生 UI 与 Questie/pfUI/
  Bagnon/Bartender2 等插件可跑）、音频。
* **macOS / Linux / Windows 都支持**（macOS 只要 Xcode 命令行工具；本机实测 rustc 1.98.0 + clt ✓）。
* 运行方式：`WOW_DATA=<客户端>/Data cargo run --release -p benilla`，`WOW_HOST` 指向服务器。
* 它自己声明的边界：**要求客户端数据是英文 1.12.1(build 5875)**、**要求服务器关掉 Warden**；
  不做其它版本与 Warden；「某个服务器的改动、以及 1.12.1 从未有过的东西，属于 fork」。

## 二、四道关（都对着本仓库源码核过）

| 关卡 | 事实 | 判定 |
|---|---|---|
| 登录构建号 | `realmd/RealmList.cpp` 的 `ExpectedRealmdClientBuilds` 只有 `{7272, 1.18.1}`，规则是「≥7272 一律接受」；benilla 报 5875 → `FindBuildInfo` 返回 null → `AuthSocket.cpp:713+` 走「找 twpatch / 回一句不是有效客户端版本」的拒绝路径 | ❌ 当前进不来；fork 改**一行**：`crates/benilla-protocol/src/lib.rs:35` 的 `CLIENT_BUILD = 5875` → `7272` |
| 完整性校验 | `AuthSocket::VerifyVersion`（`AuthSocket.cpp:1528`）第一句 `if (!StrictVersionCheck) return true`（默认关）；即便开，7272 那行的 `WindowsHash/MacHash` 是空表（`{{}}, {{}}`）→ `memcmp(hash, zeros)` 直接放行 | ✅ 不拦 |
| 反作弊 Warden | `Warden.WinEnabled/OSXEnabled` 默认 0/0；`WardenMgr.cpp:48`「两个都关 → 整个 Warden 不启用」。benilla 在 macOS 上自报 `OSX`（`benilla-protocol/src/auth.rs:28` 明确写：Mac→`OSX`，其它→`Win`） | ✅ **Mac 端天然免检**；Windows 端的 Warden 可照旧开着，不必为 Mac 牺牲 |
| 客户端数据 | benilla 要**英文 1.12.1 (5875)** 的 `Data/`；本机那份是 zhCN 单语（enUS 槽空，名字会缺） | ⚠️ 正解是用 **Turtle 1.18.1 客户端**的数据（英文 + 自定义素材）；格式同代（本仓库已核过服务端 43 个 DBC 与 1.18.1 客户端字段数 43/43 一致） |

## 三、protocol 层的实测差异（本次评估的关键数据）

把本仓库 `src/game/Protocol/Opcodes_1_12_1.h` 与 vmangos（benilla 的开发目标）同名文件逐条对比：

| 指标 | 结果 |
|---|---|
| opcode 总数 | Turtle **827** / vmangos **826** |
| 同名同值 | **824** |
| **同名不同值（改号）** | **0** ← 第三方客户端不会「错位」 |
| 只有 Turtle 有 | 3 条：`CMSG_UNUSED`、`CMSG_UNUSED2`（占位）、`SMSG_ACCOUNT_DATA_TIMES`（= vmangos 里 `SMSG_ACCOUNT_DATA_MD5` 的改名） |
| 只有 vmangos 有 | 2 条：`MSG_SET_DUNGEON_DIFFICULTY`、`SMSG_ACCOUNT_DATA_MD5` |

另外：**服务端不按客户端构建号改包** —— `WorldSession::_gameBuild` 只存不用，全库没有
`if (build >= 7272)` 之类的分支；`grep -i turtle src/game` 只有 **202 处**，全是服务端逻辑
（任务旗标、缓存、ZoneScript 等），不要求客户端额外实现。

结论：**协议层不需要移植**，benilla 现成的 1.12.1 协议栈可直接用。

Turtle 自己的「插件签名」只涉及两个官方插件（`Turtle_General`/`Turtle_GroupUI`，
见 `Anticheat/AddonHandler.cpp` 的 `ALLOW_TURTLE_ADDONS` 段）—— benilla 跑 Turtle 客户端目录里的
插件时把签名原样转发即可。

## 四、工作量分层

| 层 | 要做什么 | 预估 |
|---|---|---|
| **P0 能进门** | ① `CLIENT_BUILD` 5875→7272；② 挑战包版本三元组 1.12.1→1.18.1（纯外观）；③ `WOW_DATA` 指向 Turtle 安装 | 1 小时内（不含编译） |
| **P1 能正常玩**（真实工作量） | 用 Turtle 客户端数据跑起来后逐个修「数据里有、benilla 没预期」的地方：新增/改动的 DBC 行、新模型与地图、自定义法术图标、Turtle FrameXML 里调用的 Lua API | 实测驱动；按 benilla 的成熟度估几天到两周，大头在准备数据与逐个报错 |
| **P2 功能对等** | 乌龟服自有系统（自定义面板、插件 API、特殊内容） | 按需求定，属长期 fork |
| **P3 维护** | 跟随 Turtle 客户端数据更新 + rebase benilla 上游 | 持续，每次很小 |

## 五、只能实测才知道的两件事

1. **自定义包内容**：opcode 没变，但 Turtle 打了客户端补丁，理论上可以在标准包里追加字段。
   静态判定要把两边几十个 handler 逐文件 diff —— 实测更快。
2. **新资源格式**：1.12 引擎只能读 1.12 代格式，理论上兼容；Turtle 新加的地图/模型要真跑才算数。

## 六、建议的推进顺序（先便宜后贵）

1. 本机编译 benilla（10~20 分钟，3 GB 磁盘）→ 用现成的 1.12.1 数据离屏跑通（不连服）；
2. 改 build 号连本服跑一次 → 同时验证 P0 与「自定义包内容」两个未知数；
3. 再把数据换成 Turtle 客户端（5~10 GB，需从 Windows 机拷或用 CDN 拉）→ P1 的真实工作量这时暴露。

## 附：本机已具备的条件（2026-10-12 实测）

* `rustc 1.98.0` / `cargo 1.98.0` ✓（benilla 的 `rust-toolchain.toml` 要 1.98.1，rustup 会自动补齐）
* Xcode 命令行工具 ✓（Apple clang 16 / arm64）
* 现成的 1.12.1 客户端完整安装：`~/Downloads/WoW_Classic`（5.4 GB，zhCN）
* 服务器与本机网络可达（MySQL 3306 已验证；登录服 3724 未测）
