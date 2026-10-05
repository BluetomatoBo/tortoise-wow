# WowWeb — 账号网站 / account website for Tortoise WoW

面向 Tortoise WoW（MaNGOS 系）服务端的账号网站：**自助注册** + **玩家面板** + **管理后台**。
它**直接读写核心已经在用的那几张数据库表**，所以服务端一行代码都不用改、也不用重新编译。

A small web service that adds registration, a player panel and an administration back office to
a Tortoise WoW (MaNGOS-derived) server. It talks **directly to the game databases the core
already uses**, so nothing has to be patched or rebuilt on the server side.

---

## 中文说明

### 它解决什么问题

| 没有它 | 有了它 |
|---|---|
| 开新号要管理员手工 `INSERT`，还要算对密码哈希 | 玩家自己在网页注册，立刻能进游戏 |
| 改密码、看角色、解卡住都要找 GM | 玩家自己在面板里做 |
| 封号/改等级/查账号要开游戏或敲 SQL | 后台点几下，**每个操作都留审计记录** |

注册时写入的是核心校验用的同一个哈希
`SHA1(用户名 + ":" + 密码)`（大写十六进制），所以网页注册完**马上就能登录游戏**。

### 功能

**公开页面**

| 路径 | 作用 |
|---|---|
| `/` | 首页。**登录后**才显示实时人数、账号数、以及领域列表与地址负载 |
| `/register` | 自助注册，服务端校验 + 按 IP 限流 |
| `/login` | 用**游戏账号**登录（同一个用户名密码） |
| `/alert` | 游戏客户端登录界面「系统公告」的正文接口，匿名可访问 |
| `/api/status` | 给监控或 Discord 机器人用的 JSON 状态。**不含任何地址与端口** |
| `/healthz` | 存活探针，含数据库连通性 |
| `/lang/{en\|zh}` | 中英切换 |

**玩家面板**（登录后）

| 路径 | 作用 |
|---|---|
| `/panel` | 账号概览：等级、上次登录、封禁/禁言状态、角色列表 |
| `/panel/characters` | 角色列表（等级、种族、职业、公会、金钱、游戏时长），可**解卡住** |
| `/panel/password` | 改密码（先验证旧密码，并注销其它会话） |
| `/panel/security` | 设置/移除动态口令（2FA），管理受信任地址 |
| `/panel/sessions` | 查看并注销浏览器会话 |

**管理后台**（`account.rank ≥ ADMIN_MIN_RANK`，默认 4 = 管理员）

| 路径 | 作用 |
|---|---|
| `/admin` | 总览：各项计数、在线玩家、领域、最近操作 |
| `/admin/accounts` | 搜索筛选账号（在线/封禁/停用/等级） |
| `/admin/accounts/{id}` | 单个账号的全部信息与所有操作 |
| `/admin/characters` | 按名字、等级、在线状态搜索角色 |
| `/admin/characters/{id}` | 角色详情与角色操作 |
| `/admin/bans` | 账号封禁与 IP 封禁 |
| `/admin/announcement` | **登录界面公告**（见下） |
| `/admin/realms` | 编辑 `realmlist`：名称、地址、端口、列表标记、准入等级 |
| `/admin/audit` | 所有管理操作的日志 |

账号操作：改等级、重置密码、改邮箱、启用/停用、封禁/解封、禁言/解除、重置动态口令、删除。
角色操作：解卡住、强制改名、排队或清除 `at_login` 标记（重置法术/天赋）、设置等级。

### 前置要求

- Go 1.22+（构建用）或 Docker
- MySQL / MariaDB，且能访问游戏的核心库
- 一个能连数据库的账号（建表权限，见英文文档的 *Database privileges*）

### 配置

全部通过环境变量；本地开发可写在 `.env`（**已被 `.gitignore` 忽略，绝不提交**）。
完整清单见 `.env.example` 与英文文档。关键项：

| 变量 | 默认 | 说明 |
|---|---|---|
| `WEB_LISTEN` | `:8080` | 监听地址 |
| `WEB_BASE_URL` | 空 | 对外网址，用于邮件/链接 |
| `DB_HOST` / `DB_PORT` / `DB_USER` / `DB_PASSWORD` | — | 数据库连接 |
| `DB_LOGON_NAME` | `tw_logon` | **登录库**（`account`、`realmlist`、`web_*` 都在这里） |
| `DB_WORLD_NAME` / `DB_CHAR_NAME` / `DB_LOGS_NAME` | — | 世界库 / 角色库 / 日志库 |
| `REALM_ID` | `1` | 必须与 `mangosd.conf` 的 `RealmID` 一致 |
| `REALM_NAME` | `Tortoise WoW` | **网站标题**，同时用作验证器 app 的签发者 |
| `WORLD_ADDRESS` / `WORLD_PORT` | 空 / `8090` | 客户端连接世界服的地址与端口 |
| `REALM_PORT` | `3724` | 登录服端口 |
| `ADMIN_MIN_RANK` | `4` | 能进 `/admin` 的最低 `account.rank` |
| `ALLOW_REGISTER` | `true` | 是否开放自助注册 |
| `SESSION_SECURE` | `false` | 走 HTTPS 时设为 `true` |

> 网站名字只有 `REALM_NAME` 这一个参数（站名、页脚领域名、验证器签发者共用）。

### 运行

**本地**

```bash
cp .env.example .env      # 然后填数据库连接
set -a && . ./.env && set +a
go run ./cmd/wowweb
```

**Docker** — 仓库根的 `docker-compose.yml` 里有 `wowweb` 服务：

```yaml
wowweb:
  build: { context: ./wowweb }
  ports: ["8080:8080"]
  environment:
    DB_HOST: mysql
    REALM_NAME: ${REALM_NAME:-Tortoise WoW}
    ...
```

> **注意**：镜像里**不含 `.env`**（Dockerfile 只 COPY 二进制，`.dockerignore` 也排除了它）。
> 所以 docker 部署时环境变量来自 compose，`REALM_NAME` 取自 compose 同级目录的
> `.env` 或 shell；那里没设的话会退回默认值 `Tortoise WoW`，而不是你 `wowweb/.env` 里的值。

启动时会自动建好 `web_*` 表（`EnsureSchema`），**不需要手工建表或迁移脚本**。

### 登录界面公告

游戏客户端登录界面左侧的「系统公告」面板，正文由客户端**自己去抓一个 URL**。
那个 URL 写在一个极小的客户端补丁里（见 [`../ClientPatch/`](../ClientPatch/)），
指向本站的 `/alert`。于是公告内容就归本站管了。

- 存在 `tw_logon.web_announcement`（单行，id=1）
- 在 `/admin/announcement` 编辑：开关、标题、正文、预览
- 正文按**纯文本**存储，输出时转义 —— 客户端不是浏览器，不会跑脚本，
  但会照画拿到的标签，而输入来自管理员，所以绝不原样透传
- 返回时带 `Cache-Control: no-store`，改完下次登录界面就是新的
- **改公告既不用重启服务端，也不用改客户端**

#### 客户端对响应格式的两条硬要求

这两条都是**踩坑踩出来的**，而且**违反了不会有任何报错** —— 面板直接不出现，或把标签当文本画出来：

1. **正文必须以 `SERVERALERT:` 开头**。客户端的告警下载回调会找这个前缀
   （可带 UTF-8 BOM、大小写不敏感），找不到就**整份丢弃**。
   那个前缀正是 `WoW.exe` 里的 `SERVERALERT:` 字面量。
2. **每个标签必须独占一行**。`SimpleHTML` 是**按行解析**的：
   写成 `<html><body><p>文本</p></body></html>` 会把这串**原样当文本显示**。
   客户端自带的 `Interface\GlueXML\connection-help.html`（同一个控件渲染）
   和各家私服真实的告警页，都是每行一个标签。

另外**客户端缓冲区上限 2047 字节**，超出会被静默截断（可能切断 HTML 尾部），
所以后台在超过时会给出警告。

### 安全说明（要点）

- **游戏密码哈希本身是无盐 SHA-1** —— 这是核心的限制，本站改不了（客户端必须能用同一列认证）。
  请引导玩家用长且唯一的密码，并把游戏库当敏感数据处理。
- 会话 Cookie 32 字节随机，库里只存 SHA-256，**拖库拿不到可用会话**。
- 每个改状态请求都带 per-session CSRF token，常量时间比较。
- Cookie 为 `HttpOnly` + `SameSite=Lax`；HTTPS 下设 `SESSION_SECURE=true`。
- 登录失败不区分「用户名不存在」与「密码错误」。
- 登录后跳转限制在本站，`?next=` 不能把人弹到别的域。
- 改密码/管理员重置密码会**注销该账号的其它所有会话**。
- 注册按 IP 限流（默认 10 分钟 5 次）。
- 删号需要**手工输入账号名**确认。
- 所有管理操作写入 `web_audit`（操作者、目标、详情、来源 IP）。
- SQL 全部参数化，没有任何查询由用户输入拼接。
- **领域地址与端口绝不下发给匿名请求**：首页、页脚、`/api/status` 都只在登录后（或干脆不）提供，
  因为公开列出领域住址等于邀请人来扫描或 DDoS。
  这条规则由 `TestAnonymousVisitorSeesNoRealmDetails` 双向固定。
- **登录与注册都有防爆破限流**：计数器存在数据库里，所以**重启不会重置攻击者的进度**，
  多进程也共享。登录有两条规则 —— 按来源地址（挡单机猜密码）与按账号名（挡分布式猜同一账号）；
  注册按来源地址，**每一次提交都计数**（含校验失败的，因为探测哪些用户名可用与批量注册是同一类滥用）。
  检查发生在**密码校验之前**，被拦的请求根本走不到哈希比较；而且**对不存在的账号同样计数**，
  所以这个机制不能被用来枚举用户名。见 [防爆破](#防爆破)。

### 防爆破

游戏密码哈希是无盐 SHA-1，所以**离线**破解很快；网站能做的是拖慢**在线**猜测。

| 规则 | 默认 | 作用 |
|---|---|---|
| `LOGIN_MAX_ATTEMPTS` / `LOGIN_WINDOW_MINUTES` | 10 次 / 15 分钟 | 单个来源地址的失败登录次数 |
| `LOGIN_ACCOUNT_MAX_ATTEMPTS` / `LOGIN_ACCOUNT_WINDOW_MINUTES` | 20 次 / 30 分钟 | 单个账号名的失败登录次数（不限来源） |
| `REGISTER_MAX_ATTEMPTS` / `REGISTER_WINDOW_MINUTES` | 10 次 / 60 分钟 | 单个来源地址的注册提交次数 |

设计要点：

- **计数器在数据库里**（`web_throttle` 表），不在内存 map 里 —— 重启不会重置攻击者的进度，
  多进程/负载均衡也共享同一份。
- **检查在密码校验之前**，被拦的请求只花两次 `COUNT`，到不了哈希比较；
  这个接口在被攻击时也要保持廉价。
- **对不存在的账号同样计数**：桶以「提交的用户名」为键，而不是账号 id，
  所以这条机制无法用来判断哪些账号是真的。
- **成功登录清账号计数、不清地址计数**：证明拥有账号才能清掉针对该账号的计数；
  如果成功也清地址计数，那持有任意一个有效账号的攻击者就能无限重置自己的失败数。
- **账号阈值刻意比地址阈值宽松**，因为过于严格的账号级锁定会让人用某个玩家的名字连错几次，
  就把那个玩家锁在网站外面。想彻底关掉这条规则就把上限设为 `0`。

#### 与游戏端的关系

游戏客户端走 realmd，那边有独立的一套：`WrongPass.MaxCount`（默认 10）、
`WrongPass.BanTime`（默认 300 秒）、`WrongPass.BanType`（默认 0 = 封 **IP**，1 = 封账号）。

两点值得注意：

1. **两边共用同一个计数器** —— realmd 在密码错误时给 `account.failed_logins` 加一，
   本站在 `VerifyLogin` 里也是同一列。所以**在网页上猜密码同样会累加到游戏端的封禁阈值**，
   等于多了一层防护。反过来说，玩家在网页上连错 10 次，可能连带把自己的 IP 从游戏里
   封 5 分钟（realmd 的计数是**累计值，只在成功登录时清零**，没有时间窗口）。
   共用 IP 的场景（同一个 NAT、宿舍）下，一个人手滑会影响其他人。
2. 代码里的 `GetIntDefault("WrongPass.MaxCount", 0)` 默认是**关**的，但
   `realmd.conf.dist` 里写的是 `10`，而 docker 的 entrypoint 是**原样拷贝** `.dist` ——
   所以除非你手工改过，部署后它是**开着**的。想确认就查一下容器里
   `/etc/.../realmd.conf` 的 `WrongPass.MaxCount`。

### 目录结构

```
cmd/wowweb/            入口、装配、优雅关闭
internal/config/       环境变量配置（.env 加载器）
internal/i18n/         文案目录与语言探测
internal/gamepwd/      与核心兼容的密码哈希、TOTP
internal/store/        全部 SQL：账号、角色、封禁、领域、会话、公告
internal/web/          HTTP 层：路由、中间件、handler
internal/i18n/locales/ en.json、zh.json（编译进二进制）
internal/web/templates HTML（html/template，自动转义）
internal/web/assets/   样式表
```

加一个页面 = 在 `internal/web/handlers_*.go` 加 handler、在 `server.go` 加路由、
再加一个定义 `content` 块的模板。`render_test.go` 会用一份代表性数据渲染**每个**模板，
所以字段名写错会在测试里失败，而不是在线上页面里。

### 已知限制

见英文文档的 [Limitations](#limitations)。最主要的两条：删号不会动公会（先转交会长），
以及无盐 SHA-1 密码哈希带来的固有风险。

---

# wowweb — account website for Tortoise WoW

*(English)*


A small Go web service that adds a registration page and an administration
back office to a Tortoise WoW (MaNGOS-derived) server.

It talks **directly to the game databases the core already uses**, so nothing
has to be patched or rebuilt on the server side:

* registration writes the exact `SHA1(username + ":" + password)` hash in
  `account.sha_pass_hash` that the game client authenticates with, so a new
  player can log into the game immediately;
* every administrative action reuses the columns the core reads
  (`account.rank`, `account_banned`, `realmlist`, `character_homebind`, ...),
  using the same SQL shapes as the in-game commands.

---

## Contents

- [Features](#features)
- [Requirements](#requirements)
- [Configuration](#configuration)
- [Running it](#running-it)
- [Docker](#docker)
- [How it maps onto the game database](#how-it-maps-onto-the-game-database)
- [Login announcement](#login-announcement)
- [Security notes](#security-notes)
- [Limitations](#limitations)
- [Development](#development)

---

## Features

### Public

| Page | What it does |
| --- | --- |
| `/` | Landing page. Signed-in players also get live counts and the realm list with addresses and load; anonymous visitors get neither |
| `/register` | Self-registration with server-side validation and per-IP throttling |
| `/login` | Sign in with the **game** account name and password |
| `/api/status` | JSON status for monitoring or a Discord bot. Carries counts and load, but **never an address or port** |
| `/healthz` | Liveness/readiness probe including database connectivity |
| `/lang/{en\|zh}` | Language switcher (also sets the `tw_lang` cookie) |

The interface is available in **English and Chinese**; see
[Languages](#languages) below.

### Player area

| Page | What it does |
| --- | --- |
| `/panel` | Account overview: rank, last login, ban/mute state, characters |
| `/panel/characters` | Character list (level, race, class, guild, money, playtime) |
| `/panel/password` | Change the password (re-authenticates first, signs out other sessions) |
| `/panel/security` | Set up / remove the authenticator, manage trusted addresses |
| `/panel/sessions` | See and revoke browser sessions |

**Unstick** moves one of your own characters back to its homebind (inn)
position. It is refused while the character is online, because the world server
would save its in-memory position again on logout.

### Administration (rank ≥ `ADMIN_MIN_RANK`, default 4 = Administrator)

| Page | What it does |
| --- | --- |
| `/admin` | Dashboard: counts, online players, realms, recent actions |
| `/admin/accounts` | Search and filter accounts (online / banned / disabled / rank) |
| `/admin/accounts/{id}` | Everything about one account, with every action |
| `/admin/characters` | Search characters by name, level, online state |
| `/admin/characters/{id}` | Character detail and character actions |
| `/admin/bans` | Account bans and IP bans |
| `/admin/announcement` | The notice the game client shows on its login screen |
| `/admin/realms` | Edit `realmlist`: name, address, port, list flags, access level |
| `/admin/audit` | Log of every administrative action |

Account actions: set rank, reset password, set email, enable/disable, ban /
unban, mute / unmute, reset the authenticator, delete.

Character actions: unstick, force rename, queue or clear the `at_login` flags
(reset spells / talents), set level.

The web service also gets in the way of a few things the core does, and this is
deliberate:

* **Rank changes** refuse to touch your own account and refuse to grant a rank
  above your own — the same two rules the in-game `account set gmlevel` follows.
* **Banning and deleting** refuse targets whose rank is equal to or higher than
  yours, so an administrator cannot remove a peer.
* **Deleting an account** refuses if any character is online, or if a character
  leads a guild (hand that over first — see [Limitations](#limitations)).

---

## Requirements

* Go 1.22 or newer to build (only one dependency: `github.com/go-sql-driver/mysql`)
* MySQL 5.7+/8.0 or MariaDB 10.x with the game databases imported
* The databases created by `sql/create_databases.sql` plus `sql/base/*.sql`

The service creates three of its own tables inside the logon database
(`web_sessions`, `web_audit`, `web_register_attempts`, `web_totp_setup`). It
never modifies a core table's structure — the core ignores tables it does not
know about, and the auto-updater only ever runs its own migration files.

> **Use a dedicated database user.** Grant it access to the four game databases
> and nothing else. See [Security notes](#security-notes).

---

## Configuration

Everything is read from the environment.

| Variable | Default | Meaning |
| --- | --- | --- |
| `WEB_LISTEN` | `:8080` | Listen address |
| `WEB_BASE_URL` | *(empty)* | Public URL, used for links |
| `WEB_TRUST_PROXY` | `false` | Trust `X-Forwarded-For` / `X-Real-IP` |
| `DB_HOST` / `DB_PORT` | `127.0.0.1` / `3306` | Database server |
| `DB_USER` / `DB_PASSWORD` | `mangos` / `mangos` | Database credentials (**required**) |
| `DB_LOGON_NAME` | `tw_logon` | Login database |
| `DB_WORLD_NAME` | `tw_world` | World database |
| `DB_CHAR_NAME` | `tw_char` | Character database |
| `DB_LOGS_NAME` | `tw_logs` | Logs database |
| `REALM_ID` | `1` | Realm row to manage; must match `RealmID` in mangosd.conf |
| `REALM_NAME` | `Tortoise WoW` | Site title and the issuer shown in authenticator apps |
| `WORLD_ADDRESS` / `WORLD_PORT` | *(empty)* / `8090` | Address advertised on the home page |
| `REALM_PORT` | `3724` | realmd login port, shown on the home page |
| `DEFAULT_LANG` | `en` | UI language when the visitor has no preference: `en` or `zh` |
| `ADMIN_MIN_RANK` | `4` | `account.rank` required for `/admin` |
| `ALLOW_REGISTER` | `true` | Allow public self-registration |
| `REQUIRE_EMAIL` | `false` | Require an email address at registration |
| `MAX_ACCOUNTS` | `0` | Registration cap, `0` = unlimited |
| `PASSWORD_MIN_LEN` | `6` | Minimum password length for the web forms |
| `SESSION_TTL_HOURS` | `168` | Browser session lifetime |
| `SESSION_SECURE` | `false` | Set the cookie `Secure` flag (enable behind HTTPS) |

### Database privileges

```sql
CREATE USER 'wowweb'@'%' IDENTIFIED BY 'a-long-random-password';
GRANT SELECT, INSERT, UPDATE, DELETE ON `tw_logon`.* TO 'wowweb'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON `tw_char`.*  TO 'wowweb'@'%';
GRANT SELECT ON `tw_world`.* TO 'wowweb'@'%';
GRANT SELECT ON `tw_logs`.*  TO 'wowweb'@'%';
```

`CREATE` is only needed on `tw_logon` if you want the service to create its own
`web_*` tables on first start; grant it and revoke it afterwards if you prefer
to create them by hand.

---

## Running it

```bash
cd wowweb
go build -o wowweb ./cmd/wowweb

export DB_HOST=127.0.0.1
export DB_USER=wowweb
export DB_PASSWORD='a-long-random-password'
export REALM_NAME='My Server'
export WORLD_ADDRESS='wow.example.com'
export SESSION_SECURE=true          # when serving over HTTPS

./wowweb
```

Then open `http://127.0.0.1:8080/` and register the first account. To get into
the admin area, give that account a rank:

```sql
UPDATE `tw_logon`.`account` SET `rank` = 4 WHERE `username` = 'YOURACCOUNT';
```

(or `account set gmlevel YOURACCOUNT 4` in the mangosd console).

### Behind a reverse proxy

Terminate TLS in nginx/Caddy and forward to the service. Set
`WEB_TRUST_PROXY=true` so rate limiting and the audit log see the real client
address, and `SESSION_SECURE=true` so the session cookie is only sent over
HTTPS.

```nginx
location / {
    proxy_pass         http://127.0.0.1:8080;
    proxy_set_header   Host              $host;
    proxy_set_header   X-Real-IP         $remote_addr;
    proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header   X-Forwarded-Proto $scheme;
}
```

---

## Docker

A `Dockerfile` and a service definition for `docker-compose.yml` are included.
They expect the compose file from the server image in this repository, so
`wowweb` can reach the `mysql` service by name.

```bash
docker compose build wowweb
docker compose up -d wowweb
```

---

## Languages

The interface ships in English and Chinese, including the messages returned by
the HTTP handlers (flash banners, form errors), the rank/race/class names and
the ban/at-login labels.

### Choosing a language

The language is resolved per request, in this order:

1. the `tw_lang` cookie, set when a visitor uses the switcher in the header;
2. the `Accept-Language` request header (`zh`, `zh-CN`, `zh-Hans-CN`, `zh_TW`,
   `en-US`, … are all understood, with `q` values honoured);
3. `DEFAULT_LANG`.

Nothing is stored on the account: two people sharing an account can use
different languages at the same time, and concurrent requests in different
languages cannot interfere because the translator is carried in the request's
page data rather than in a package-level variable.

### Adding a translation

1. Add an entry to `i18n.Supported` in `internal/i18n/i18n.go`:
   `{Code: "de", Name: "Deutsch", HTMLLang: "de"}`.
2. Copy `internal/i18n/locales/en.json` to `de.json` and translate the values,
   keeping the keys unchanged.
3. Run `go test ./internal/i18n/`.

The catalogue embeds the JSON, so no restructuring is needed. `i18n.Load()`
compares every language against English and **refuses to start** when a key is
missing — a half-finished translation cannot reach production. The test suite
adds three more guards: no empty values, no keys that English does not define,
and a full page render in every language (which catches a translation that
breaks a template, for example a stray `%` in a string passed to `printf`, or a
quote that would break an inline `confirm()`).

Strings that must stay in English:

* values coming out of the database — account and character names, realm names,
  ban reasons;
* the audit log, which records *what happened* in a fixed language so it stays
  searchable regardless of who performed the action;
* low-level `http.Error` responses (CSRF mismatch, bad form), which are
  diagnostics rather than user-facing pages.

## Login announcement

The game client draws a "Server Alert" panel on the left of its login screen,
before anyone signs in. What it shows comes from a URL, and this service can
serve that URL.

**How it works.** The panel is `ServerAlertFrame` in the client's
`Interface\GlueXML\AccountLogin.xml`. The client fetches the address held in
the Lua global `SERVER_ALERT_URL` and hands the response to a cut-down HTML
widget, `SimpleHTML`. That address is baked into a small client patch
(`patch-Z.mpq`, generated by `client-patch/gen_patchz.py`), which overrides the
value the translation pack ships. Point it here once and this service owns the
wording from then on.

**On the server side**, the notice lives in `tw_logon.web_announcement`
(single row, id 1) and is edited at `/admin/announcement`. `GET /alert` serves
it:

| Request | Response |
| --- | --- |
| `GET /alert` | The notice as a minimal HTML document |

Things worth knowing about that endpoint:

* it sits **outside the session middleware** on purpose — the game client has
  no cookie jar and sends nothing this service could key a session on, so it
  must be reachable anonymously;
* the body is **stored as plain text and escaped** before it is served. The
  client is not a browser and does not run scripts, but it will draw whatever
  markup it is given, and the text comes from an administrator, so it is never
  passed through as HTML;
* `Cache-Control: no-store` is sent, so an edit shows up on the next login
  screen rather than whenever the client's cache expires;
* switching the announcement off serves an empty document, which is the
  closest the panel gets to "hidden".

#### Two hard requirements of the response format

Both were learned the hard way, and **breaking either produces no error at all** -
the panel simply does not appear, or the markup is drawn as text:

1. **The body must begin with `SERVERALERT:`.** The client's alert download
   callback looks for that prefix (case-insensitively, optionally after a UTF-8
   BOM) and **discards the entire response** when it is missing. The prefix is
   the `SERVERALERT:` literal in `WoW.exe`.
2. **Each tag must sit on its own line.** `SimpleHTML` parses **line by line**:
   writing `<html><body><p>text</p></body></html>` makes the client render that
   string verbatim. The client's own
   `Interface\GlueXML\connection-help.html` - rendered by the same widget -
   and the alert pages real servers shipped both put one tag per line.

The client's buffer for this response is **2047 bytes** and it truncates
silently, which can cut the closing tags off, so the admin page warns when the
rendered document outgrows it.

Editing needs neither a server restart nor a client patch. Only moving the site
itself means regenerating `patch-Z.mpq`.

---

## How it maps onto the game database

This is the part worth reading before changing anything. Everything below was
verified against core revision `4f4fcaa1`.

### Passwords

`AccountMgr::CreateAccount` / `CalculateShaPassHash`
(`src/game/AccountMgr.cpp`):

```
sha_pass_hash = UPPER_HEX( SHA1( normalize(username) + ":" + normalize(password) ) )
```

`normalize` uppercases **only** the basic Latin letters `a`–`z`
(`wcharToUpperOnlyLatin`) and rejects anything longer than 16 characters.
Accented Latin, Cyrillic and CJK pass through untouched. `internal/gamepwd`
reproduces this and is covered by tests with independently computed hashes.

Changing a password also clears `v`, `s` and `sessionkey`, which is what
`AccountMgr::ChangePassword` does, so a client that is already running cannot
keep using the old credentials.

### Registration

`CreateAccount` additionally mirrors the core by inserting a zeroed
`realmcharacters` row per realm — without it the client shows no character
slots for the realm. Both statements run in one transaction.

### Ranks

`account.rank`, described by `enum AccountTypes`
(`src/shared/Common.h`): 0 Player, 1 Observer, 2 Moderator, 3 Developer,
4 Administrator, 5 SigmaChad, 6 Console.

### Bans

Exactly the row `World::BanAccount` writes:

```sql
INSERT INTO account_banned (id, bandate, unbandate, bannedby, banreason, active, realm)
VALUES (?, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + <seconds>, ?, ?, 1, ?)
```

A duration of `0` produces `unbandate = bandate`, which is the core's marker
for a **permanent** ban. The effective-ban predicate is copied verbatim from
`AccountMgr::LoadAccountBanList`:

```sql
active = 1 AND (unbandate > UNIX_TIMESTAMP() OR bandate = unbandate)
```

Unbanning sets `active = 0` for the account, like `World::UnBanAccount`.

### Mutes

`account.mutetime` holds **unix seconds** (the core computes
`m_muteTime - time(nullptr)`), plus `mutereason` and `muteby`.

### Disabling an account

`account.active = 0`. realmd refuses the login
(`AuthSocket.cpp`: `if (!active) -> WOW_FAIL_INCORRECT_PASSWORD`). This is the
reversible alternative to deleting.

### Two-factor authentication

The core's second factor is plain RFC 6238 TOTP — HMAC-SHA1, 30 second step,
6 digits — validated with one step of drift (`GenerateToken` / `ValidateToken`
in `src/realmd/AuthSocket.cpp`). So any authenticator app works.

* the secret lives in `account.security` as unpadded Base32;
* the `locked` bitmask needs `0x02` (`FIXED_PIN`) for realmd to actually ask
  for a code;
* a successful check lets realmd remember the address for 30 days in
  `account_twofactor_allowed`.

A newly generated secret is parked in `web_totp_setup` until the user proves
their app produces valid codes for it. Only then is it written to
`account.security` — otherwise a mis-scanned QR code would lock the account out
of the game completely.

### Realms

`realmlist` fields, and which side owns them:

| Column | Who writes it |
| --- | --- |
| `id`, `name`, `address`, `port` | **You** — must match `RealmID` and `WorldServerPort` in mangosd.conf |
| `realmflags` | You; bit `0x2` (offline) is written by mangosd |
| `allowedSecurityLevel` | You (or mangosd from `PlayerLimit`) |
| `icon`, `timezone` | **mangosd only** — overwritten from `GameType`/`RealmZone` on every start |
| `population` | **The world server only** |
| `realmbuilds` | mangosd writes it; nothing ever reads it back |

Because `icon` and `timezone` are overwritten on every world server start, the
panel does not offer them for editing. Edit `GameType`/`RealmZone` in
`mangosd.conf` instead.

### Character actions

* **Unstick** copies the position from `character_homebind` into `characters`,
  guarded by `AND online = 0`.
* **Force rename**, **reset spells**, **reset talents** set bits in
  `characters.at_login` (`enum AtLoginFlags`): `0x01` rename, `0x02` reset
  spells, `0x04` reset talents. The world server acts on them at next login.
* **Delete account** runs the same table list as `Player::DeleteFromDB`, kept in
  `internal/store/delete.go`. A missed table would leave rows that a future
  character could inherit if the GUID were reused.

---

## Security notes

**The game's password hash is unsalted SHA-1.** That is a property of the core,
not of this service, and it cannot be fixed here: the game client must be able
to authenticate against the same column. Practically this means an attacker who
obtains a database dump can crack weak passwords quickly. Encourage players to
use a long, unique password, and treat the game database as sensitive.

What this service does about the things it *can* control:

* **Session cookies** carry 32 bytes of randomness; only their SHA-256 is
  stored, so a database dump does not hand over live sessions.
* **CSRF**: every state-changing request carries a per-session token, checked
  with a constant-time comparison.
* **Cookies** are `HttpOnly` and `SameSite=Lax`. Set `SESSION_SECURE=true` on
  HTTPS so they are never sent in the clear.
* **Login failures** do not reveal whether a username exists.
* **Redirects** after login are restricted to this site, so `?next=` cannot be
  used to bounce a user to another host.
* **Password changes and admin password resets** drop every other session and
  clear `v`/`s`/`sessionkey`.
* **Registration** is throttled per IP (5 attempts per 10 minutes by default).
* **Deleting an account** requires typing the account name.
* **Every administrative action is written to `web_audit`** with the actor, the
  target, the detail and the source address.
* **SQL** is fully parameterised; no query is built from user input. The only
  string interpolation used is for identifiers, and those come from constants.
* **The realm's address and port are never served to an anonymous request.**
  The home page, the footer and `/api/status` all omit them and show the live
  counts only to a signed-in player, because a public page that lists where the
  realm lives is an invitation to scan or flood it. `TestAnonymousVisitorSeesNoRealmDetails`
  pins both halves of that rule.
* **Sign-in and sign-up are rate limited** with counters in the database, so an
  attacker's progress survives a restart and is shared by every process. See
  [Brute-force limits](#brute-force-limits).

The service has no `SELECT` on passwords, never logs a password, and never
returns a hash to a template.

---

## Brute-force limits

The game's password hash is unsalted SHA-1, so an attacker who obtains it can
crack it offline quickly. What this service can slow down is *online* guessing.

| Setting | Default | What it caps |
| --- | --- | --- |
| `LOGIN_MAX_ATTEMPTS` / `LOGIN_WINDOW_MINUTES` | 10 per 15 min | failed sign-ins from one address |
| `LOGIN_ACCOUNT_MAX_ATTEMPTS` / `LOGIN_ACCOUNT_WINDOW_MINUTES` | 20 per 30 min | failed sign-ins against one account name, from any address |
| `REGISTER_MAX_ATTEMPTS` / `REGISTER_WINDOW_MINUTES` | 10 per 60 min | sign-up submissions from one address |

How it is built:

* **Counters live in the database** (`web_throttle`), not in a map in memory, so
  a restart does not hand an attacker a clean slate and every process behind the
  load balancer sees the same numbers.
* **The check runs before the password is verified.** A blocked request costs
  two `COUNT` queries and never reaches the hash comparison; the endpoint has to
  stay cheap while it is being hammered.
* **A name that does not exist is counted too.** Buckets are keyed by the
  submitted name rather than by an account id, so nothing here reveals which
  accounts are real.
* **A successful sign-in clears the account counter and leaves the address
  counter standing.** Proving ownership of the account is what clears its
  counter; if a success also cleared the address counter, anyone holding one
  valid account could reset their own failures at will.
* **The account limit is looser than the address limit on purpose.** A tight
  one would let a stranger lock a known player out of the website by failing a
  few sign-ins with that player's name. Setting a limit to `0` disables that
  rule.

#### How this relates to the game side

The game client signs in through realmd, which has its own settings:
`WrongPass.MaxCount` (default 10), `WrongPass.BanTime` (default 300 seconds) and
`WrongPass.BanType` (default 0 = ban the **IP**, 1 = ban the account).

Two things are worth knowing:

1. **Both sides share one counter.** realmd increments `account.failed_logins`
   on a bad password, and this service does the same in `VerifyLogin`. So
   guessing on the website also counts towards the game's ban threshold, which
   is free defence in depth. The flip side: a player who fumbles their password
   ten times on the website can get their own address banned from the game for
   five minutes. realmd's counter is cumulative and only resets on a successful
   sign-in, with no window, so on a shared address (a NAT, a dorm) one person's
   mistakes reach everyone.
2. The code default is `GetIntDefault("WrongPass.MaxCount", 0)`, i.e. **off**,
   but `realmd.conf.dist` ships `10` and the Docker entrypoint copies that file
   verbatim - so it is **on** unless you edited it by hand. Check
   `WrongPass.MaxCount` in the container's `realmd.conf` to be sure.

## Limitations

Worth knowing before you promise these features to anyone:

1. **No live server control.** This core has no RA/SOAP endpoint (the
   `RASocket` mention in the source is a leftover comment), and the service only
   touches the database. Consequences:
   * a ban, mute or disable applies from the **next login**; a player already in
     the world keeps playing until they disconnect;
   * unstick, rename and `at_login` changes need the character to be **offline**.
   If you need immediate action, use the `mangosd` console.

2. **Guild leadership blocks deletion.** A character that leads a guild is
   refused, because disbanding or reassigning a guild from outside the running
   server would desynchronise its in-memory state. Handle the guild first.

3. **No email delivery.** Registration can require an email address and stores
   it, but the service does not send verification mail or password-reset links.
   `account.email_verif` is surfaced, not managed. If realmd has
   `ReqEmailVerification = 1`, new accounts will be unable to log in until that
   column is set — either turn the option off, or add the mail step.

4. **No character transfers, auctions, mail or shop integration.** The Turtle
   shop tables (`shop_coins`, `shop_logs`) are left alone, so deleting a
   character here does **not** refund shop purchases the way the in-game delete
   does.

5. **GDPR-ish deletion is out of scope.** "Delete account" removes the account
   and its characters; log tables that reference them are not touched.

---

## Development

```bash
cd wowweb
go test ./...        # unit tests: hashing, TOTP, template rendering
go vet ./...
gofmt -l .
```

### Database integration test

The store layer has an integration test that builds its fixture from the real
`create_databases.sql`, so it always reflects the current game schema. It is
skipped unless you point it at a scratch database — it creates and drops that
database itself, so **do not point it at your live one**:

```bash
export TW_TEST_DSN='root:root@tcp(127.0.0.1:3306)/tw_web_test?parseTime=true'
export TW_TEST_SCHEMA=/path/to/tortoise-wow/sql/create_databases.sql
go test ./internal/store/ -run Integration -v
```

It exercises registration, password verification and change, listing and
filtering, bans (temporary and permanent), IP bans, mutes, two-factor setup and
recovery, session handling, realm editing (including that the `offline` flag is
preserved), character lookups, unstick, `at_login` flags, account deletion and
the audit log.

### Layout

```
cmd/wowweb/            entry point, wiring, graceful shutdown
internal/config/       environment configuration (.env loader)
internal/i18n/         message catalogues and language detection
internal/gamepwd/      core-compatible password hash and TOTP
internal/store/        all SQL: accounts, characters, bans, realms, sessions, announcement
internal/web/          HTTP layer: routes, middleware, handlers
internal/i18n/locales/ en.json, zh.json (embedded)
internal/web/templates HTML (html/template, auto-escaped)
internal/web/assets/   stylesheet
```

Adding a page means adding a handler in `internal/web/handlers_*.go`, a route in
`server.go`, and a template that defines the `content` block. `render_test.go`
walks every template with a representative payload, so a typo in a field name
fails the test suite rather than a page in production.
