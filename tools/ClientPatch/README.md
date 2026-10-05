# ClientPatch — 客户端覆盖补丁生成器 / Client override patch generator

把**配置项**写进一个最后加载的客户端补丁 `patch-Z.mpq`，用来覆盖汉化包或暴雪原版里写死的值。
当前用它覆盖登录界面「系统公告」的读取地址，内容由 [WowWeb](../WowWeb/) 的
`/admin/announcement` 管理。

Writes **configuration values** into a client patch, `patch-Z.mpq`, that loads last and
therefore overrides whatever a translation pack or Blizzard's own files contain. Today it
points the login screen's "Server Alert" panel at [WowWeb](../WowWeb/)'s
`/admin/announcement`.

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

## 为什么改 `GlueLocalization.lua` 而不是 `GlueStrings.lua`

`Interface\GlueXML\GlueXML.toc` 的加载顺序是：

```
GlueConstants.lua → GlueStrings.lua → GlueFonts.xml → GlueLocalization.xml(→ .lua) → …
```

而 `AccountLogin.xml`（创建 `ServerAlertFrame` 的地方）排在 `GlueLocalization.xml` **之后**，
所以写在 `GlueLocalization.lua` 里的赋值一定生效。

关键是：**整份替换 `GlueStrings.lua` 会把汉化包里几千条界面字符串一起冲掉**
（补丁是按文件整体覆盖的）。所以在 `GlueLocalization.lua` 里追加几行赋值是
唯一既生效又不误伤的做法。

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

## Why `GlueLocalization.lua` and not `GlueStrings.lua`

`Interface\GlueXML\GlueXML.toc` loads in this order:

```
GlueConstants.lua → GlueStrings.lua → GlueFonts.xml → GlueLocalization.xml(→ .lua) → …
```

and `AccountLogin.xml` (which creates `ServerAlertFrame`) comes **after**
`GlueLocalization.xml`. An assignment in `GlueLocalization.lua` therefore always takes effect.

The important part: **replacing `GlueStrings.lua` wholesale would wipe the several thousand
UI strings a translation pack puts there**, because a patch overrides a file as a whole.
Appending a few assignments to `GlueLocalization.lua` is the only way to take effect without
that collateral damage.

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
