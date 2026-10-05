# ClientPatch — 客户端覆盖补丁生成器 / Client override patch generator

把**配置项**写进一个最后加载的客户端补丁 `patch-Z.mpq`，用来覆盖汉化包或暴雪原版里写死的值。
当前用它覆盖登录界面「系统公告」的读取地址，内容由 [WowWeb](../WowWeb/) 的
`/admin/announcement` 管理。

另附 `patch_urllist.py`：把 `WoW.exe` 里写死的**可信 URL 白名单**等长覆盖成自己的域名，
让公告里的链接变成可点击（见下文「让公告里的链接可点击」）。

Writes **configuration values** into a client patch, `patch-Z.mpq`, that loads last and
therefore overrides whatever a translation pack or Blizzard's own files contain. Today it
points the login screen's "Server Alert" panel at [WowWeb](../WowWeb/)'s
`/admin/announcement`.

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
    "Interface\\GlueXML\\GlueLocalization.lua": {
      "SERVER_ALERT_URL": "http://127.0.0.1:8080/alert",
      "SERVER_ALERT_TITLE": "系统公告",
      "SERVER_ALERT_BUTTON_TEXT": "更多信息"
    }
  }
}
```

## 地址怎么选

客户端在**哪台机器上跑**，就填那台机器能访问到的地址：

| WowWeb 跑在哪 | `SERVER_ALERT_URL` 填 |
|---|---|
| 和游戏客户端同一台机器 | `http://127.0.0.1:8080/alert` |
| 局域网里的服务器 | `http://<服务器地址>:8080/alert` |
| 走 nginx 反代的域名 | `http://你的域名/alert` |

## 让公告里的链接可点击：`patch_urllist.py`

公告正文里写成 `<a href="...">` 的链接，点下去走客户端的 `LaunchURL`，而它对目标主机有一份
**写死在 `WoW.exe` 里的白名单**：官方的 `*.worldofwarcraft.com`、`*.battle.net` 等，
乌龟服额外加了 `*.turtlecraft.gg`，中文客户端加了 `*.wuguifu.com`。不在名单里的域名**点不动**，
服务端也没有任何配置项可以放宽。

`patch_urllist.py` 把某个槽位**等长覆盖**成你自己的域名：

```bash
# 看有哪些槽位（带可用长度，保护中的会标出来）
python3 patch_urllist.py --list

# 换一项（长度不能超过原值），先 dry-run 看校验结果
python3 patch_urllist.py --set '*.wowtaiwan.com.tw=*.mydomain.net' --dry-run
python3 patch_urllist.py --set '*.wowtaiwan.com.tw=*.mydomain.net'

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

## 改动生效

| 改什么 | 怎么生效 |
|---|---|
| `overrides.json` 里的**值** | 重跑 `gen_patchz.py`，然后**完全重启游戏客户端**（MPQ 在启动时挂载） |
| 公告**正文** | 不用跑这个工具 —— 在 WowWeb 的 `/admin/announcement` 改，下次登录界面即生效 |

## 依赖

StormLib。macOS 上 `brew install stormlib`，默认路径
`/opt/homebrew/lib/libstorm.dylib`（脚本里有候选列表，也支持 Linux 的
`libStorm.so` 与 Windows 的 `StormLib.dll`）。

## 验证生成结果

用任意 MPQ 工具打开 `patch-Z.mpq`，确认
`Interface\GlueXML\GlueLocalization.lua` 里的 `SERVER_ALERT_URL` 指向你的地址；
并确认汉化包的 `GlueStrings.lua` **仍在 `patch-X.mpq` 里、未被改动**。

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
    "Interface\\GlueXML\\GlueLocalization.lua": {
      "SERVER_ALERT_URL": "http://127.0.0.1:8080/alert",
      "SERVER_ALERT_TITLE": "系统公告",
      "SERVER_ALERT_BUTTON_TEXT": "更多信息"
    }
  }
}
```

## Choosing the address

Fill in an address reachable **from the machine the game client runs on**:

| WowWeb runs on | set `SERVER_ALERT_URL` to |
|---|---|
| the same machine as the client | `http://127.0.0.1:8080/alert` |
| a machine on the LAN | `http://<server host>:8080/alert` |
| behind an nginx reverse proxy | `http://your-domain/alert` |

## Making the links clickable: `patch_urllist.py`

A link written as `<a href="...">` in the announcement body goes through the client's
`LaunchURL`, which checks the target host against a **whitelist baked into `WoW.exe`**:
Blizzard's `*.worldofwarcraft.com`, `*.battle.net`, etc., plus `*.turtlecraft.gg` on the
Turtle client and `*.wuguifu.com` on the Chinese one. A host outside that list simply
**does nothing when clicked**, and no server-side setting can relax it.

`patch_urllist.py` overwrites one slot with your own domain, **same length or shorter**:

```bash
# list the slots (with usable length; protected ones are marked)
python3 patch_urllist.py --list

# replace one entry (may not be longer than the original), dry-run first
python3 patch_urllist.py --set '*.wowtaiwan.com.tw=*.mydomain.net' --dry-run
python3 patch_urllist.py --set '*.wowtaiwan.com.tw=*.mydomain.net'

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

## What takes effect when

| change | how it applies |
|---|---|
| a **value** in `overrides.json` | re-run `gen_patchz.py`, then **fully restart the game client** (MPQs are mounted at startup) |
| the announcement **text** | this tool is not involved — edit it in WowWeb at `/admin/announcement` and it shows on the next login screen |

## Requirements

StormLib. On macOS `brew install stormlib` puts it at
`/opt/homebrew/lib/libstorm.dylib`. The script carries a candidate list and also handles
Linux (`libStorm.so`) and Windows (`StormLib.dll`).

## Verifying the output

Open `patch-Z.mpq` with any MPQ tool and confirm that `SERVER_ALERT_URL` in
`Interface\GlueXML\GlueLocalization.lua` points at your address, and that the translation
pack's `GlueStrings.lua` is **still intact in `patch-X.mpq`**.
