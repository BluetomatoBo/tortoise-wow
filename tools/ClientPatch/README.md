# ClientPatch — 客户端覆盖补丁生成器 / Client override patch generator

把**配置项**写进一个最后加载的客户端补丁 `patch-Z.mpq`，用来覆盖汉化包或暴雪原版里写死的值。
当前用它覆盖登录界面「系统公告」的读取地址，内容由 [WowWeb](../WowWeb/) 的
`/admin/announcement` 管理。

另附 `patch_urllist.py`：把 `WoW.exe` 里写死的**可信 URL 白名单**等长覆盖成自己的域名，
让公告里的链接变成可点击（见下文「客户端能打开什么样的地址」）。

Writes **configuration values** into a client patch, `patch-Z.mpq`, that loads last and
therefore overrides whatever a translation pack or Blizzard's own files contain. Today it
points the login screen's "Server Alert" panel at [WowWeb](../WowWeb/)'s
`/admin/announcement`, and points the five sign-in failure dialogs (banned, suspended, out
of credit, e-mail unverified, server busy) at the pages that explain them.

Bundled with it, `patch_urllist.py` rewrites the **trusted-URL whitelist baked into
`WoW.exe`** (same-length overwrite) so links inside the announcement become clickable —
see "Making the links clickable" below.

---

# 中文说明

## 为什么需要这个补丁

游戏客户端登录界面左侧的「系统公告」面板，其正文来自一个 **URL**：

```
客户端绘制登录界面
  └─ 读 Lua 全局 SERVER_ALERT_URL（写死在客户端补丁里）
       └─ 抓取该地址
            └─ 用 SimpleHTML 控件渲染返回的内容
```

**服务端源码里没有这个机制**（`tortoise-wow` 全 `src/` 无任何实现），所以只能在客户端改。
而客户端的登录界面 Lua 环境**没有文件读取 API**（从 `WoW.exe` 里提取到的注册函数只有
`GetSavedAccountName` / `GetServerName` / `LaunchURL` 等二十来个，既没有 `GetCVar`
也没有 `io`），所以**客户端自己读不了配置文件**。

于是做法是：把 URL 固定成一个可配置的**接口地址**，配置放到服务端这边，由接口返回内容。
改公告不再需要碰客户端。

同一个补丁还负责**登录失败对话框**指向哪一页：封禁、暂停、余额为负、邮箱未验证、
服务器繁忙这五种情况，客户端各有一个 `AUTH_*_URL`，全部指向 WowWeb 的对应页面，
免得玩家看到一句「账号已被封禁」之后无处可去。

## 为什么必须叫 `patch-Z`

客户端只加载 `patch.MPQ` 与 `patch-?.MPQ`（**单字符**通配）。
字母顺序里 `Z` 排在最后，因此只有一个 `patch-Z.mpq` 能盖过其它所有补丁。

原本汉化包占用 `Z`，现已改名为 **`patch-X.mpq`**（`X` 在 `Z` 之前，仍然生效），
把 `Z` 让给了这个覆盖包。

自建的 `patch-A.mpq` 之类**盖不住** `patch-Z`，改 `patch-9` 等也一样无效。

## 为什么必须改 `GlueStrings.lua`

这是**实测踩过的坑**：`SERVER_ALERT_URL` 必须写在 `GlueStrings.lua` 里。

| 文件 | 谁加载 | 能否生效 |
|---|---|---|
| **`GlueStrings.lua`** | 客户端 **C++ 直接加载**（不被任何 XML 的 `<Script>` 引用） | 能 |
| `GlueLocalization.lua` | 由 `GlueLocalization.xml` 的 `<Script file=...>` 加载 | 不能，太晚 |

只把值写进 `GlueLocalization.lua` 时，客户端仍然使用汉化包 `GlueStrings.lua` 里的旧值
（一个已经无法解析的站点），登录界面公告面板**一片空白**。

旁证：所有能用的实现都把这几个键放在 `GlueStrings.lua` ——
暴雪原版、乌龟服自己的 `patch-3/4/6/7/8/9`、以及中文汉化包，无一例外。

### 代价与注意事项

要在 `GlueStrings.lua` 里覆盖，patch-Z 就必须**整份容纳**该文件
（补丁是按文件整体覆盖的）。工具的做法是读**当前生效的那一份**（汉化包里的），
只改目标行，再写进 patch-Z —— 所以除被覆盖的行外与汉化包**逐字相同**，界面字符串不会丢。
每次生成后工具都会把这份差异打印出来供核对。

> ⚠️ **汉化包更新后请重跑本工具。** patch-Z 里那份 `GlueStrings.lua` 是汉化包某个版本的
> 快照，会盖住更新后的版本；重跑即可从新版重新生成。

## 用法

```bash
# 1) 改 overrides.json（至少把 clientDataDir 改成你的客户端 Data 目录）
# 2) 生成
python3 gen_patchz.py

# 或指定别的配置文件
python3 gen_patchz.py /path/to/other.json
```

工具做的事：

1. 读 `overrides.json`
2. 对每个目标文件，从所有补丁里找出**当前生效的那一份**
   （优先级最高的一份，但**跳过本工具自己的产物**，避免自我叠加）
3. 按需替换或追加 `KEY = "value"` 行（已有的键替换那一行，没有的追加）
4. 把结果写进 `patch-Z.mpq`（每次重建，内容只含被覆盖的文件）

**以后再要覆盖别的配置项，往 `overrides.json` 里加一条即可**，不用改工具。
工具是**幂等**的：同样的配置连跑两次结果完全一致。

## 配置项

```jsonc
{
  "clientDataDir": "/path/to/client/Data",   // 客户端 Data 目录
  "outputPatch": "patch-Z.mpq",              // 产物文件名，必须是 Z
  "luaAssignments": {
    "Interface\\GlueXML\\GlueStrings.lua": {
      "SERVER_ALERT_TITLE": "系统公告",
      "SERVER_ALERT_BUTTON_TEXT": "更多信息",
      "SERVER_ALERT_URL": "http://twow.home.boym.me/alert",
      "AUTH_DB_BUSY_URL": "http://twow.home.boym.me/notice",
      "AUTH_BANNED_URL": "http://twow.home.boym.me/account/banned",
      "AUTH_SUSPENDED_URL": "http://twow.home.boym.me/account/suspended",
      "AUTH_NO_TIME_URL": "http://twow.home.boym.me/account/no-time",
      "AUTH_PARENTAL_CONTROL_URL": "http://twow.home.boym.me/account/verify"
    }
  }
}
```

这些键里，**只有 `SERVER_ALERT_URL` 可以带端口**：它由客户端自己抓取，走的是普通
HTTP，实测 `http://172.18.1.6:8080/alert` 可用。其余全部由 `LaunchURL` 打开，
必须遵守下面那一节的规则 —— 工具会在生成前拦下不合规的地址。

### 哪些键真的有人用

从 exe 与生效的界面文件里逐个查过（`strings` + 反汇编调用点），这个客户端里只有两处
能把玩家送到浏览器：

| 触发点 | 用到的键 |
|---|---|
| 登录界面「系统公告」面板正文里的链接 | 正文里的 `<a href>`，见下一节 |
| 登录失败的对话框（封禁 / 暂停 / 余额为负 / 邮箱未验证 / 服务器繁忙） | `AUTH_BANNED_URL`、`AUTH_SUSPENDED_URL`、`AUTH_NO_TIME_URL`、`AUTH_PARENTAL_CONTROL_URL`、`AUTH_DB_BUSY_URL` |

**已经死掉的键**（本客户端里没有任何代码或界面引用它们，改了也不会有反应）：
`ACCOUNT_CREATE_URL`、`COMMUNITY_URL`、`TECH_SUPPORT_URL`、`TURTLE_ARMORY_WEBSITE`、
`TURTLE_COMMUNITY_FORUM_WEBSITE`、`TURTLE_DISCORD_WEBSITE`、
`TURTLE_KNOWLEDGE_DATABASE_WEBSITE`、`TURTLE_REDDIT_WEBSITE`、`AUTH_TURTLE_WEBSITE`。
汉化包把它们指向 wuguifu，但在这个 exe 上点不到，所以不必改。

## 地址怎么选

客户端在**哪台机器上跑**，就填那台机器能访问到的地址：

| WowWeb 跑在哪 | `SERVER_ALERT_URL` 填 |
|---|---|
| 和游戏客户端同一台机器 | `http://127.0.0.1:8080/alert` |
| 局域网里的服务器 | `http://<服务器地址>:8080/alert` |
| 走 nginx 反代的域名 | `http://你的域名/alert` |

**要让公告里的链接能点，就得用域名**，而且那个域名要走 80 端口 ——
见下面「客户端能打开什么样的地址」。

## 客户端能打开什么样的地址

**这一节决定了公告里的链接能不能点。** 先看清客户端那两处是怎么工作的。

登录界面左侧的面板（`ServerAlertFrame`）里**没有按钮** —— 这点很容易看错，因为
`interface.MPQ` 里那份老版本 `AccountLogin.xml` 里确实有一个「更多信息」按钮，
但实际生效的是优先级更高的 **`patch-9.mpq` 里那一份**：正文是一个 `SimpleHTML` 控件：

```xml
<SimpleHTML name="ServerAlertText" hyperlinkFormat="|cff2f68ff|H%s|h[%s]|h|r">
  <Scripts><OnHyperlinkClick>LaunchURL(arg1);</OnHyperlinkClick></Scripts>
```

也就是说 **正文里的链接本身就是按钮**，点它调 `LaunchURL(arg1)`。服务器端
（tools/WowWeb）已经配合好了：公告正文里**单独占一行的地址**会被渲染成链接，
形状抄的是客户端自己的 `Data/eula.html` —— 同一个控件渲染的文件：

```html
<p>
<a href="http://twow.home.boym.me/notice">http://twow.home.boym.me/notice</a>
</p>
```

`LaunchURL` 是**唯一**的出口：5 个 `AUTH_*_URL` 对话框也是通过 Lua 调它。
它在打开之前做两道校验，**任意一道不过就静默什么都不做**（界面上看着能点，点了没反应，
没有任何错误提示）：

**第一道：地址本身的形状**（反汇编自 `WoW.exe` 0x5abc10）

| 规则 | 说明 |
|---|---|
| 必须 `http://` 开头 | `https://` 会被拒 |
| 不允许冒号出现在 `http://` 之后 | **带端口的地址整条作废**，`172.18.1.6:8080` 不行 |
| 只允许字母、数字、`.`、`-`、`/` | 下划线、`?`、`#`、中文标点都不行 |

所以一个能用的链接长这样：`http://twow.home.boym.me/notice` —— 域名、80 端口、无参数。
`gen_patchz.py` 会按这些规则检查 `overrides.json`，不合格就直接中止。

**第二道：主机名必须在白名单里**

白名单**写死在 `WoW.exe` 里**：官方的 `*.worldofwarcraft.com`、`*.battle.net` 等，
乌龟服加了 `*.turtlecraft.gg`，中文客户端加了 `*.wuguifu.com`。服务端没有任何配置项能放宽它。

白名单是 `.data` 段里的 `const char*` 数组，匹配逻辑也是反汇编出来的：
普通项与主机名**整串相等**，`*.x` 项则要求主机名恰好是「一个标签 + `.x`」
（`www.wuguifu.com` 命中 `*.wuguifu.com`，但 `a.b.wuguifu.com` **不**命中）。
所以最稳的做法是放**完整主机名**，它在两种判定下都成立。

`patch_urllist.py` 把某个槽位**等长覆盖**成你自己的域名：

```bash
# 看有哪些槽位（带可用长度，保护中的会标出来）
python3 patch_urllist.py --list

# 换一项（长度不能超过原值），先 dry-run 看校验结果
python3 patch_urllist.py --set '*.wowtaiwan.com.tw=twow.home.boym.me' --dry-run
python3 patch_urllist.py --set '*.wowtaiwan.com.tw=twow.home.boym.me'

# 从备份还原
python3 patch_urllist.py --restore
```

白名单是 `.data` 段里的 `const char*` 数组，字符串紧跟在数组后面连续存放 —— 所以
**换短不换长**就不需要动指针、不需要改文件长度、也不需要重定位：整个 4.9 MB 的 exe 里
只有被替换的那几十个字节会变（工具落盘前会逐字节核对这一点，不符就中止且不写文件）。

表是**结构化定位**的：连续 ≥3 个 DWORD 都等于 `ImageBase+RVA`、且指向主机名样式的
NUL 结尾字符串，遇空指针收尾。**不硬编码任何域名**，所以换客户端版本也适用。
`--list` 会列出这样找到的全部三张表：MPQ 归档名、可信 URL 白名单、
以及 `ChecksumExecutables` 要校验的文件清单（`WoW.exe` + `unicows/dbghelp/ijl15/fmod.dll`）。

### 不需要额外处理 `ChecksumExecutables`

那张文件清单只是**算哈希**：客户端里**没有任何期望值**（没有清单文件、没有内嵌常量），
所以本地无法自我拒绝。服务端一侧也全都不校验：

| 可能的校验点 | 结论 |
|---|---|
| `realmd` 版本哈希（`RealmList.cpp:37`） | 哈希表是空的 → `VerifyVersion` 直接 `return true` |
| Warden | 默认全关（`WinEnabled=0` / `OSXEnabled=0`） |
| 世界服 digest（`WorldSocket.cpp:286`） | 是会话密钥证明 `SHA1(账号‖0‖clientSeed‖serverSeed‖K)`，与文件字节无关 |
| `AddonHandler` 插件指纹 | 只在插件块**格式错**时踢人，且不涉及 exe |

**所以改 exe 只需要这一处补丁。**

> ⚠️ **必须改乌龟服客户端那份 `WoW.exe`。** 官方 1.12.1/1.12.3 客户端会走另一条
> **独立的** `GlueXML` 签名检查（`SSignature`）—— 混用官方客户端时那条会提示「登录页面
> 已被修改，请重新下载客户端」，与上面的校验和无关。

> ℹ️ 白名单只认 `*.域名` 形式，**纯 IP（如 `http://172.18.1.6:8080/alert`）能否通过尚未实测**；
> 想让它可点击，建议用域名而不是 IP。完全不想动 exe 也行：公告里把地址当**纯文本**显示，
> 用户手输即可。

被保护的主机（含 `blizzard` / `battle.net` / `turtlecraft` 等）要显式加 `--force` 才允许替换 ——
它们是客户端门户/补丁服务还在用的地址，换掉可能连带破坏其它功能。

## 怎么验证真的生效

链接能不能点，取决于**两个文件**同时正确：`patch-Z.mpq` 里的地址形状合法，
且该地址的主机在 `WoW.exe` 的白名单里。分开在两个文件里，而且**任何一件不满足都是静默的**
（不报错，只是点了没反应），所以有一个自检工具把两者对起来查：

```bash
python3 verify_client.py                      # 查客户端自己的那一份
python3 verify_client.py --exe /path/to/你改过的那份/WoW.exe
python3 verify_client.py --link http://twow.home.boym.me/notice   # 查准备写进公告的地址
```

它会：

* 按**补丁优先级**找出客户端**实际加载**的那份 `GlueStrings.lua`（不是按文件时间），
  这样查的是真实生效值 —— 顺手也能看出 patch-Z 到底有没有在生效
* 逐个检查会被 `LaunchURL` 打开的键：地址形状 + 主机是否在白名单里
* 单独检查 `SERVER_ALERT_URL`（它由客户端自己抓取，可以带端口，不查白名单）
* 用 `--link` 检查你打算写进公告正文的地址
* 把「本客户端不引用的死键」单独汇总一行，不参与结论，免得噪声盖住真问题

退出码 `0` 通过 / `1` 有明确失败 / `2` 只有不确定项，可以直接放进脚本。

### 三层验证

| 层 | 在哪做 | 查什么 |
|---|---|---|
| 静态 | 本机（上面的工具） | 两个文件是否配套、地址形状、白名单、`patch-Z` 是否真的最高优先级 |
| 服务端 | 服务器上 `curl` | `/alert` 是否以 `SERVERALERT:` 开头、有没有 `<a href>`、`/notice` 与 `/account/*` 是否 200 |
| 客户端 | Windows 上跑游戏 | 面板有没有公告（证明 `patch-Z` 生效）、点链接浏览器有没有打开（证明白名单生效） |

**几个能快速定位问题的信号**：

| 现象 | 说明什么 |
|---|---|
| 面板完全没有公告 | `patch-Z` 没生效（或 `SERVER_ALERT_URL` 指错、服务端没起）。查服务端访问日志有没有那一次抓取 —— 这是区分「没来取」和「取了但不喜欢」的唯一办法 |
| 面板有公告，链接显示成蓝色带方括号 | 正文那行被正确渲染成链接了（`hyperlinkFormat` 生效），形状没问题 |
| 链接看着能点，点了没反应 | 地址形状或**白名单**没过 —— 用上面的工具查 |
| 链接点开浏览器是 404 | 白名单和形状都对，问题在服务端（页面不存在）—— 这次就轮到 web 那边了 |

## 改动生效

| 改什么 | 怎么生效 |
|---|---|
| `overrides.json` 里的**值** | 重跑 `gen_patchz.py`，然后**完全重启游戏客户端**（MPQ 在启动时挂载） |
| 公告**正文** | 不用跑这个工具 —— 在 WowWeb 的 `/admin/announcement` 改，下次登录界面即生效 |
| `WoW.exe` 里的**白名单** | 用 `patch_urllist.py` 打一次即可，之后只要域名不变就不用再动 |

> 📌 正文里**单独占一行**的 `http://` 地址会变成可点击的链接。要让它真的能点，
> 两件事缺一不可：地址用**域名 + 80 端口**（不能带端口号），且该域名在 exe 白名单里。

## 依赖

StormLib。macOS 上 `brew install stormlib`，默认路径
`/opt/homebrew/lib/libstorm.dylib`（脚本里有候选列表，也支持 Linux 的
`libStorm.so` 与 Windows 的 `StormLib.dll`）。

## 验证生成结果

用任意 MPQ 工具打开 `patch-Z.mpq`，确认 `Interface\GlueXML\GlueStrings.lua` 里：

* `SERVER_ALERT_URL` 指向你的 `/alert`
* 5 个 `AUTH_*_URL` 指向 `/notice` 与 `/account/...`
* 其余几千行与汉化包**逐字相同**（工具只改这几行，运行时会打印改了哪几行）

再确认汉化包的 `GlueStrings.lua` **仍在 `patch-X.mpq` 里、未被改动**。
`patch-Z.mpq` 现在只装这一个文件 —— 里面不再有 `GlueLocalization.lua`，
因为那是汉化包里的空壳，没必要整份覆盖。

---

# English

## Why this patch exists

The panel on the left of the game client's login screen (the "Server Alert" box) takes its
text from a **URL**:

```
client draws the login screen
  └─ reads the Lua global SERVER_ALERT_URL (baked into a client patch)
       └─ fetches that address
            └─ renders the response with the SimpleHTML widget
```

**No part of the server implements this** — there is nothing for it in `tortoise-wow`'s
`src/` — so the only place to change it is the client. And the client's login-screen Lua
environment **has no file-reading API**: the functions registered there (recovered from
`WoW.exe`) number about twenty and include `GetSavedAccountName`, `GetServerName` and
`LaunchURL`, with no `GetCVar` and no `io`. **The client therefore cannot read a config file
of its own.**

The approach is to pin the URL to a configurable **service endpoint** and keep the actual
configuration server-side, where the endpoint reads it. Changing the announcement then never
touches the client again.

## Why it must be named `patch-Z`

The client loads `patch.MPQ` and `patch-?.MPQ` — a **single character**. `Z` sorts last, so
only a `patch-Z.mpq` can override every other patch.

The Chinese pack used to own `Z`; it has been renamed to **`patch-X.mpq`** (`X` sorts before
`Z`, so it still applies) to free the slot for this override pack.

A `patch-A.mpq` of your own **cannot** override `patch-Z`, and neither can edits to
`patch-9` and friends: they all load earlier.

## Why `GlueStrings.lua` is the file to change

This is a trap that was hit in practice: `SERVER_ALERT_URL` has to live in
`GlueStrings.lua`.

| File | Loaded by | Works? |
| --- | --- | --- |
| **`GlueStrings.lua`** | the client's **C++ directly** (no XML `<Script>` references it) | yes |
| `GlueLocalization.lua` | `<Script file=...>` inside `GlueLocalization.xml` | no, too late |

With the value in `GlueLocalization.lua` only, the client kept using the old one
from the translation pack's `GlueStrings.lua` (a site that no longer resolves)
and the login-screen panel stayed empty.

Corroboration: every working implementation keeps these keys in
`GlueStrings.lua` - Blizzard's own files, Turtle's `patch-3/4/6/7/8/9`, and the
Chinese translation pack alike.

### The cost, and what to remember

Overriding inside `GlueStrings.lua` means patch-Z has to carry a whole copy of
it, because a patch overrides a file as a whole. The tool reads the **currently
effective copy** (the translation pack's), changes only the target lines and
writes the result into patch-Z, so apart from those lines it is byte-identical
to the pack and no UI string is lost. Each run prints that diff for inspection.

> **Re-run this tool after updating the translation pack.** The copy inside
> patch-Z is a snapshot of its `GlueStrings.lua` and would otherwise shadow the
> newer one.

## Usage

```bash
# 1) edit overrides.json (at minimum set clientDataDir to your client's Data folder)
# 2) generate
python3 gen_patchz.py

# or point it at a different config file
python3 gen_patchz.py /path/to/other.json
```

What it does:

1. reads `overrides.json`;
2. for each target file, resolves the **currently effective copy** — the highest-priority
   patch that has it, **skipping this tool's own output** so runs cannot stack;
3. replaces or appends `KEY = "value"` lines (an existing key is replaced in place, a new one
   is appended);
4. writes the result into `patch-Z.mpq`, rebuilt from scratch and containing only the
   overridden files.

**To override another setting later, add an entry to `overrides.json`** — the tool itself does
not change. It is **idempotent**: the same config twice produces byte-identical output.

## Configuration

```jsonc
{
  "clientDataDir": "/path/to/client/Data",   // the client's Data folder
  "outputPatch": "patch-Z.mpq",              // must be Z
  "luaAssignments": {
    "Interface\\GlueXML\\GlueStrings.lua": {
      "SERVER_ALERT_TITLE": "系统公告",
      "SERVER_ALERT_BUTTON_TEXT": "更多信息",
      "SERVER_ALERT_URL": "http://twow.home.boym.me/alert",
      "AUTH_DB_BUSY_URL": "http://twow.home.boym.me/notice",
      "AUTH_BANNED_URL": "http://twow.home.boym.me/account/banned",
      "AUTH_SUSPENDED_URL": "http://twow.home.boym.me/account/suspended",
      "AUTH_NO_TIME_URL": "http://twow.home.boym.me/account/no-time",
      "AUTH_PARENTAL_CONTROL_URL": "http://twow.home.boym.me/account/verify"
    }
  }
}
```

Of these, **only `SERVER_ALERT_URL` may carry a port**: the client fetches it over plain
HTTP, and `http://172.18.1.6:8080/alert` is known to work. Every other key is opened by
`LaunchURL` and has to obey the rules in the next section - the generator refuses to
build a patch containing an address the client would refuse.

### Which keys are actually used

Checked one by one, with `strings` and by looking at the call sites in the executable;
only two things on this client can send a player to a browser:

| trigger | key |
|---|---|
| a link in the login screen's "Server Alert" panel | the `<a href>` in the body, see below |
| a sign-in failure dialog (banned / suspended / out of credit / e-mail unverified / server busy) | `AUTH_BANNED_URL`, `AUTH_SUSPENDED_URL`, `AUTH_NO_TIME_URL`, `AUTH_PARENTAL_CONTROL_URL`, `AUTH_DB_BUSY_URL` |

**Dead keys** - nothing in this client reads them, so changing them does nothing:
`ACCOUNT_CREATE_URL`, `COMMUNITY_URL`, `TECH_SUPPORT_URL`, `TURTLE_ARMORY_WEBSITE`,
`TURTLE_COMMUNITY_FORUM_WEBSITE`, `TURTLE_DISCORD_WEBSITE`,
`TURTLE_KNOWLEDGE_DATABASE_WEBSITE`, `TURTLE_REDDIT_WEBSITE`, `AUTH_TURTLE_WEBSITE`.
The translation pack points them at wuguifu, but they cannot be reached on this executable.

## Choosing the address

Fill in an address reachable **from the machine the game client runs on**:

| WowWeb runs on | set `SERVER_ALERT_URL` to |
|---|---|
| the same machine as the client | `http://127.0.0.1:8080/alert` |
| a machine on the LAN | `http://<server host>:8080/alert` |
| behind an nginx reverse proxy | `http://your-domain/alert` |

**A link inside the announcement only works by name**, and that name has to be served on
port 80 - see "What the client will open" below.

## What the client will open

**This section decides whether a link in the announcement is clickable at all.**

The panel on the left of the login screen (`ServerAlertFrame`) has **no button**. That is
easy to get wrong: the copy of `AccountLogin.xml` inside `interface.MPQ` does have a "more
information" button, but the file that actually loads is the one in **`patch-9.mpq`**,
which has a higher priority, and there the body is a `SimpleHTML` widget:

```xml
<SimpleHTML name="ServerAlertText" hyperlinkFormat="|cff2f68ff|H%s|h[%s]|h|r">
  <Scripts><OnHyperlinkClick>LaunchURL(arg1);</OnHyperlinkClick></Scripts>
```

So **a link in the body is the button**. The server side (tools/WowWeb) already cooperates:
an address alone on a line of the announcement is rendered as a link, in the shape copied
from the client's own `Data/eula.html` - a file the same widget renders:

```html
<p>
<a href="http://twow.home.boym.me/notice">http://twow.home.boym.me/notice</a>
</p>
```

`LaunchURL` is the **only** way out of the client: the five `AUTH_*_URL` dialogs go through
it as well, by evaluating a Lua call. Before opening anything it runs two checks, and
**failing either one is silent** - the link still looks clickable, and nothing happens.

**First: the shape of the address** (disassembled from `WoW.exe` at 0x5abc10)

| rule | why |
|---|---|
| must start with `http://` | `https://` is refused |
| no colon after the scheme | **any port invalidates the whole address**, so `172.18.1.6:8080` is out |
| only letters, digits, `.`, `-`, `/` | underscores, `?`, `#` and non-ASCII punctuation are refused |

So a usable link looks like `http://twow.home.boym.me/notice`: a name, port 80, no query.
`gen_patchz.py` checks `overrides.json` against these rules and stops on a violation.

**Second: the host has to be in a whitelist compiled into `WoW.exe`**

Blizzard's `*.worldofwarcraft.com`, `*.battle.net` and friends, plus `*.turtlecraft.gg` on
the Turtle client and `*.wuguifu.com` on the Chinese one. No server-side setting can relax
it.

The whitelist is a `const char*` array in `.data`, and the matching logic was disassembled
too: a plain entry is compared against the whole host, while a `*.x` entry requires the
host to be exactly one label plus `.x` (`www.wuguifu.com` matches `*.wuguifu.com`, but
`a.b.wuguifu.com` does not). So the safe thing to install is the **full hostname**, which
holds under both readings.

`patch_urllist.py` overwrites one slot with your own domain, **same length or shorter**:

```bash
# list the slots (with usable length; protected ones are marked)
python3 patch_urllist.py --list

# replace one entry (may not be longer than the original), dry-run first
python3 patch_urllist.py --set '*.wowtaiwan.com.tw=twow.home.boym.me' --dry-run
python3 patch_urllist.py --set '*.wowtaiwan.com.tw=twow.home.boym.me'

# restore from the backup
python3 patch_urllist.py --restore
```

The whitelist is a `const char*` array in `.data` with the strings stored right behind it, so
a **shorter or equal replacement** needs no pointer fixups, no size change and no relocation:
out of the whole 4.9 MB executable only those few dozen bytes change. The tool verifies that
byte for byte before writing, and aborts without touching the file if anything is off.

Tables are found **structurally** — a run of ≥3 consecutive DWORDs, each equal to
`ImageBase+RVA` and pointing at a hostname-shaped, NUL-terminated string, terminated by a null
pointer. No domain name is hardcoded, so this keeps working across client versions.
`--list` also shows two similarly-shaped tables: the MPQ archive names, and the file list
`ChecksumExecutables` hashes (`WoW.exe` + `unicows/dbghelp/ijl15/fmod.dll`).

### `ChecksumExecutables` needs no extra work

That file list only *computes* hashes: there is **no expected value anywhere in the client**
(no manifest, no embedded constants), so it cannot reject itself locally. Nothing on the
server checks it either:

| possible check | verdict |
|---|---|
| `realmd` version hashes (`RealmList.cpp:37`) | the hash table is empty → `VerifyVersion` just `return true` |
| Warden | off by default (`WinEnabled=0` / `OSXEnabled=0`) |
| world-server digest (`WorldSocket.cpp:286`) | it is the session-key proof `SHA1(account‖0‖clientSeed‖serverSeed‖K)`, unrelated to file bytes |
| `AddonHandler` fingerprinting | only kicks on **malformed** addon data, and never looks at the exe |

**So one patch is all it takes.**

> ⚠️ **Patch the Turtle client's `WoW.exe`.** The official 1.12.1/1.12.3 client goes through
> a separate `GlueXML` signature check (`SSignature`), which is what reports "your login
> screen has been modified, please download the client again" when you mix it with a
> modified interface. That check is unrelated to the checksums above.

> ℹ️ The whitelist only holds `*.domain` patterns; whether a **bare IP** (such as
> `http://172.18.1.6:8080/alert`) passes **is not yet tested**. Use a domain if you want it
> clickable. Or skip the executable entirely: show the address as **plain text** and let
> people type it.

Entries matching `blizzard`, `battle.net`, `turtlecraft` and friends are protected and need an
explicit `--force` — the client's portal/patch services still use them.

## Checking that it actually works

A clickable link needs **two files** to agree: the address in `patch-Z.mpq` has to be a shape
the client accepts, and its host has to be in `WoW.exe`'s whitelist. They live in different
files, and **failing either one is silent** - nothing is reported, the click simply does
nothing - so a checker compares them for you:

```bash
python3 verify_client.py                      # the client's own copy
python3 verify_client.py --exe /path/to/the/copy/you/patched/WoW.exe
python3 verify_client.py --link http://twow.home.boym.me/notice   # an address for the body
```

It works out which `GlueStrings.lua` the client **actually loads** by walking the patches in
priority order (not by file date), so it checks the effective values - and tells you whether
`patch-Z` is in effect at all. Then it validates each key `LaunchURL` opens (shape and
whitelist), checks `SERVER_ALERT_URL` separately (the client fetches that one itself), checks
any `--link` you pass, and summarises the keys this client never reads in one line so they
cannot drown out a real problem.

Exit codes: `0` pass, `1` a definite failure, `2` only uncertain.

### Three layers

| Layer | Where | What it proves |
|---|---|---|
| static | on your machine, with the tool above | the two files are in step, addresses are the right shape, `patch-Z` really is the highest-priority patch |
| server | `curl` on the server | `/alert` starts with `SERVERALERT:` and carries an `<a href>`, `/notice` and `/account/*` return 200 |
| client | the game on Windows | the panel shows the notice (so `patch-Z` loaded) and clicking the link opens a browser (so the whitelist works) |

**Signals worth knowing:**

| What you see | What it means |
|---|---|
| no notice at all | `patch-Z` is not in effect, `SERVER_ALERT_URL` is wrong, or the service is down. Check the server's access log for the fetch - that is the only way to tell "never asked" from "asked and disliked the answer" |
| the notice appears, the link is blue and bracketed | the line was parsed as a link (`hyperlinkFormat` worked), so its shape is fine |
| the link looks clickable and does nothing | shape or **whitelist** - run the tool above |
| the browser opens and shows a 404 | shape and whitelist are fine; the problem is on the web side |

## What takes effect when

| change | how it applies |
|---|---|
| a **value** in `overrides.json` | re-run `gen_patchz.py`, then **fully restart the game client** (MPQs are mounted at startup) |
| the announcement **text** | this tool is not involved — edit it in WowWeb at `/admin/announcement` and it shows on the next login screen |
| the **whitelist** inside `WoW.exe` | run `patch_urllist.py` once; after that it only changes if the domain does |

> 📌 An `http://` address **alone on a line** of the announcement becomes a clickable
> link. Two things have to be true for the click to do anything: the address must be a
> **name on port 80** (no port number), and that name must be in the executable's
> whitelist.

## Requirements

StormLib. On macOS `brew install stormlib` puts it at
`/opt/homebrew/lib/libstorm.dylib`. The script carries a candidate list and also handles
Linux (`libStorm.so`) and Windows (`StormLib.dll`).

## Verifying the output

Open `patch-Z.mpq` with any MPQ tool. In `Interface\GlueXML\GlueStrings.lua`, confirm
that:

* `SERVER_ALERT_URL` points at your `/alert`
* the five `AUTH_*_URL` values point at `/notice` and `/account/...`
* the other few thousand lines are **byte for byte** the translation pack's (the tool only
  rewrites those lines, and prints which ones on every run)

Then confirm the translation pack's `GlueStrings.lua` is **still intact in `patch-X.mpq`**.
`patch-Z.mpq` now carries that one file only — the `GlueLocalization.lua` copy is gone,
because the translation pack's own copy is an empty stub not worth overriding.
