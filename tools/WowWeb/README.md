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
| `/notice` | 公告的**网页版** —— 客户端公告里那个链接落到的页面，匿名可访问 |
| `/account/{banned,suspended,no-time,verify}` | 登录失败对话框的**说明页**，匿名可访问 |
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
| `/admin/shop` | **捐赠商城**条目（`shop_items`，见下） |
| `/admin/shop/categories` | 商城的**类别**（`shop_categories`），见下 |
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
| `SHOP_REGION` | `europe` | 本服的「区域」，对应 `mangosd.conf` 的 `NiHao`：`europe` 或 `china`。仅影响商城管理页的判定 |
| `WORLD_ADDRESS` / `WORLD_PORT` | 空 / `8090` | 客户端连接世界服的地址与端口 |
| `REALM_PORT` | `3724` | 登录服端口 |
| `ADMIN_MIN_RANK` | `4` | 能进 `/admin` 的最低 `account.rank` |
| `ALLOW_REGISTER` | `true` | 是否开放自助注册 |
| `SESSION_SECURE` | `false` | 走 HTTPS 时设为 `true` |
| `WEB_TRUST_PROXY` | `false` | 在反代后面**必须设为 `true`**，否则限流与日志只看得到反代的地址。开启后取 `X-Forwarded-For` 的**最后**一项（代理自己追加的那个），伪造的头部条目不会被采信 |

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

#### 正文里的链接

「系统公告」面板里**没有按钮** —— 正文是一个 `SimpleHTML` 控件，**链接本身就是按钮**：

```xml
<SimpleHTML name="ServerAlertText" hyperlinkFormat="|cff2f68ff|H%s|h[%s]|h|r">
  <Scripts><OnHyperlinkClick>LaunchURL(arg1);</OnHyperlinkClick></Scripts>
```

这段来自 `patch-9.mpq` 里的 `AccountLogin.xml`。`interface.MPQ` 里那份老版本确实有个
「更多信息」按钮，但优先级更低、不生效，照那份改会改错地方。

所以公告正文里**单独占一行的 `http://` 地址**会被渲染成链接，形状抄的是客户端自己的
`Data/eula.html` —— 同一个控件渲染的文件：

```html
<p>
<a href="http://twow.home.boym.me/notice">http://twow.home.boym.me/notice</a>
</p>
```

只认**独占一行**的地址。夹在句子中间的地址**不会**变成链接：客户端的 `LaunchURL` 会拒绝
带端口、下划线、问号的地址，而那种地址若被截成前半段就会指向另一个页面，不如干脆不给点。
这条规则是 `soleURL`，`TestSoleURL` 钉住了它。

> ⚠️ 链接要真的能点，还差两件事：地址必须是**域名 + 80 端口**（不能有端口号），
> 且该域名在 `WoW.exe` 的白名单里 —— 见 [`../ClientPatch/`](../ClientPatch/)。

### 客户端会把玩家送到哪里

这个客户端里能把玩家送进浏览器的只有两处（其余 `*_URL` 键在 exe 与生效界面里都没有引用，
是死代码），本站为它们各准备了一页：

| 路径 | 谁会走到这里 |
|---|---|
| `/notice` | 公告正文里的链接；登录失败对话框「服务器繁忙/会话超时」也指向它 |
| `/account/banned` | 登录被拒「账号已被封禁」（`WOW_FAIL_BANNED`） |
| `/account/suspended` | 登录被拒「账号已被暂停」，含 IP 锁定（`WOW_FAIL_SUSPENDED`） |
| `/account/no-time` | 登录被拒「余额为负」（`WOW_FAIL_NO_TIME`） |
| `/account/verify` | 登录被拒「邮箱未验证」（`WOW_FAIL_PARENTCONTROL`） |

> ⚠️ **这四页里只有 `/account/banned` 在这套 core 上真的能弹出来。** 客户端有**两套**登录
> 失败提示：**登录服**（realmd）的拒绝用 `LOGIN_*` 一族，对话框**只有「确定」、不带链接**；
> 只有**世界服**（mangosd）的拒绝用 `AUTH_*` + `AUTH_*_URL`，才有「帮助」按钮。
> 而 core 的世界服只发五种码，其中只有 `AUTH_BANNED` 命中那张 URL 表。
> 想看「帮助」按钮：先登录到**选服务器**的界面，再封掉账号/IP，然后点服务器进入。
> 细节与证据见 [`../ClientPatch/README.md`](../ClientPatch/README.md)。
>
> 📌 另外后台的「**禁用账号**」和「**封禁**」不一样：禁用写 `account.active=0`，登录服回
> `WOW_FAIL_INCORRECT_PASSWORD` —— 玩家看到的是「**密码错误**」。想给出明确理由要用**封禁**。

这些页面**故意不要求登录**：需要它们的人恰恰是登不进来的人，要求会话等于在最需要的时候
把它们锁掉。它们也**不透露任何服务器地址或端口**，测试会检查这一点。

原因清单是 `handlers_notice.go` 里的 `accountNoticeReasons`，与客户端补丁里的
`AUTH_*_URL` 一一对应；两边对不上会在测试里露出来。

### 用域名访问（客户端要求）

游戏客户端只肯打开 **`http://域名`** 形式的链接（冒号会让它整条拒绝），
所以要让公告里的链接可点，就得有一个走 **80 端口**的域名指到本站。仓库里带了一份
可直接用的配置：

```bash
sudo cp deploy/nginx/twow.home.boym.me.conf /etc/nginx/conf.d/
sudo nginx -t && sudo systemctl reload nginx
```

同时在 `.env` 里设这两项：

```
WEB_BASE_URL=http://twow.home.boym.me   # 后台页面上显示的对外地址
WEB_TRUST_PROXY=1                        # 否则所有玩家共用一个限流桶
```

`WEB_TRUST_PROXY=1` 不是可选项：反代后面每个请求的来源都是 nginx 自己的地址，
不开这个，**登录失败限流会按同一个 IP 计数 —— 一个人连错几次密码就把所有人挡住**。

开启后应用只认 `X-Forwarded-For` 的**最后一项**，也就是 nginx 用
`$proxy_add_x_forwarded_for` 追加进去的、它自己看到的那个对端地址；客户端塞在最前面的
值一律不采信。这一点是必须的：否则任何人在这条头里写一个假地址就能每次换一个限流桶，
按地址计的限流等于不存在。`X-Real-IP` 只在没有 `X-Forwarded-For` 时才用。

这个域名**故意只走 HTTP**：客户端根本打不开 `https://` 的链接，所以它的链接必须留在
80 端口。

要给浏览器上 TLS，注意**只有 `/alert` 不能被重定向**：

* `/alert` 是**游戏客户端自己**用它的 HTTP 栈抓的，**没有人替它跟重定向** ——
  302 过去，登录界面公告面板就静默变成空白
* 其余地址（包括公告里的链接）重定向**没问题**：链接是**浏览器**打开的，
  客户端早在写临时 Internet Shortcut 之前就校验完地址了，它看不到那个 302

还有个 nginx 陷阱：**server 级的 `return 301` 在选 location 之前执行**，
会连 `/alert` 一起重定向、绕过例外。要重定向就写在 location 里：

```nginx
location / { return 301 https://$host$request_uri; }
location = /alert { proxy_pass http://172.18.1.6:8080; }   # 精确匹配优先，留在 HTTP
```

上了 TLS 之后，再给服务设 `SESSION_SECURE=true`。

验证（在服务器上）：

```bash
curl -s  -H 'Host: twow.home.boym.me' http://172.18.1.6/healthz
curl -s  -H 'Host: twow.home.boym.me' http://172.18.1.6/alert | head -3   # 应看到 SERVERALERT:
curl -s  -H 'Host: twow.home.boym.me' http://172.18.1.6/notice | grep -o '<h1>[^<]*</h1>'
```

### 捐赠商城（`/admin/shop`）

玩家在客户端里看到的那个捐赠商城（`Turtle_shopUI`），**物品列表不在客户端**：
客户端只有界面，列表由服务端通过插件频道的 `TW_SHOP` 消息发过去。服务端读的是
世界库里的两张表：

| 表 | 作用 |
|---|---|
| `shop_categories` | 商城里的分类（ID、英文名、`_loc4` 中文名、图标） |
| `shop_items` | 每个条目：卖哪个 `item_template.entry`、价格、区域限定、展示模型与位置 |

`/admin/shop` 就是用来维护这两张表的。**改完在世界服控制台执行 `.reload shop` 即可生效，
不需要重启 mangosd**：那条命令会把两个 map 清空再重新读表（`ObjectMgr::LoadShop`，
需要 `SEC_ADMINISTRATOR`）。

#### 会「静默失败」的条件

下面每一条，世界服都只是在日志里写一行然后**跳过这一行**，游戏里没有任何提示。
所以表单会在提交时直接拦下来，而不是等你 reload 完去商城找半天：

| 条件 | 世界服日志 |
|---|---|
| `price` 为 0 | `price is 0, skipping` |
| `item`（entry）在 `item_template` 里不存在 | 跳过 |
| `category` 在 `shop_categories` 里不存在 | 跳过 |
| 同一个 `entry` 已经有一条商城条目 | `already has an entry in the shop for entry %u` |

下面两条不报错，但结果和你想的不一样，所以页面会给警告：

- **`region_locked` 与本服不匹配**（本服区域由 `SHOP_REGION` 决定，对应
  `mangosd.conf` 的 `NiHao`）→ 这一条**在别的区域永远看不到**。列表页会给这类行
  打「本服不显示」标记。
- **`scale` 为 0** → 模型看不见（想用默认值就填 1）。

#### 两个「看着像显示文字、其实不是」的列

`shop_items.description` 和 `description_loc4` 世界服会读进内存，**然后再也不使用**。
客户端显示的物品名和描述由核心从 `item_template` 取，条目字符串是核心自己拼的：

```
Entries:<cat>=<subcat>=<物品名>=<价>=<description>=<entry>=<model>=<displayid>=<x>=<y>=<z>=<rot>=…
```

关键在这两格的来源**不一样**（`ObjectMgr.cpp:9665`）：

| 字段 | 来源 |
|---|---|
| 物品名 | `NiHao=1` → `locales_item` 里放中文的那一列（**注意不是固定的 `name_loc4`**，见下）；`NiHao=0` → `item_template.name`（英文） |
| 描述 | **永远**是 `item_template.description`，**不做本地化**，两种区域都一样 |

**关于「中文在哪一列」这个坑**：核心取物品名时用的是硬编码的数组下标
（`ObjectMgr.cpp:9668` 的 `GetItemLocaleName(entry, LOCALE_zhCN)`），而那个数组是按
`ObjectMgr::m_LocalForIndex` 的位置索引的，**不是**按 `name_locN` 的 N。
本仓库自带的 `locales_item` 基础数据里，8 个 locale 列实际是：

```
name_loc1=英文  loc2=韩文  loc3=法文  loc4=德文
name_loc5=简体中文  loc6=繁体中文  loc7=西语  loc8=西语(esMX)
```

也就是说简体中文比 MaNGOS 惯例晚了一列。所以**想让商城显示中文，改哪一列要以你库里
实际的填充为准**，先用下面这条确认：

```sql
SELECT entry, name_loc4, name_loc5, name_loc6 FROM locales_item WHERE entry = <你的 item entry>;
```

想让商城里显示中文：

- **名称** → 改那列真正放简体中文的（本仓库数据是 `name_loc5`），且必须 `NiHao=1`
- **描述** → 只能改 `item_template.description`。它没有能被核心读取的 `_loc4` 版本，改了之后英文客户端也会看到中文——这是核心的限制，不是后台能解决的

在 `shop_items` 那两列里改文字**不会**改变游戏里看到的任何内容。

#### 类别：`/admin/shop/categories`

`shop_categories` 也能在后台维护（新增 / 改名换图标 / 删除）。三条约束是硬性的，前两条
表单直接拒绝，第三条只给警告：

**1. ID 只能是 1–255。** 库里是 `int unsigned`，但核心这么读：

```cpp
uint8 id = fields[0].GetUInt8();     // ObjectMgr::LoadShop
```

填 300 会被**静默截断**，页签就和指向它的那些条目对不上了。ID 还决定**页签顺序**
（客户端收到的分类表按 ID 排序），所以想让某个类别排在前面就给它小的 ID。**建好之后
不能改** —— 条目都指向它 —— 表单在编辑页不提供这一项。

**2. 名称和图标里不能有 `=` 或 `;`。** 服务端是把**整份**类别表拼成一个字符串发给
客户端的：

```cpp
categories += to_string(id) + "=0=" + Name_loc4 + "=" + Icon + ";";
```

而客户端先按 `;` 切分类、再按 `=` 切字段。所以一个 `=` 不是让一个类别出问题，
是让**它后面所有类别**错位。这条必须是拒绝，不能是警告。

**3. 图标必须是客户端里真实存在的贴图。** 客户端直接拼路径：

```lua
SetTexture("Interface\\ShopFrame\\" .. icon)      -- Turtle_ShopUI.lua:372
```

客户端这个目录里有 332 个文件，但**能当类别图标用的只有 11 个具名文件**，表单会作为
候选项列出来：

```
about   bag   default   free   mount   pet   scroll   service   tabard   ticket   toys
```

填别的名字**只给警告不拒绝** —— 你自己往 patch 里加 `Interface\ShopFrame\<名字>.blp`
是合法的 —— 但文件名不存在时页签图标是空白的，所以页面上会标出来。

**删除会被拒绝，只要还有条目指向它。** 核心会跳过指向不存在类别的条目，直接删就等于
让这些条目从商城里消失（而且只有日志里有一行）。表单在这种情况下不显示删除按钮，改了
URL 硬提交也一样会被拒（handler 再查一次条目数），并提示你先去
`/admin/shop?category=<id>` 把它们改到别的类别。

**4. 本服区域要用的那个名字必须填。** 核心只会发**一个**名字，没有回退：

```cpp
categories += to_string(id) + "=0=" + (NiHao ? Name_loc4 : Name) + "=" + Icon + ";";
```

而客户端用 `(.+)=(%d+)=(.+)=(.+)` 解析，`(.+)` 要求至少一个字符 —— 所以那个名字**为空
不是显示成空白，而是整条匹配失败、这个分类在游戏里完全不出现**。中文服（`NiHao=1`）
必须填中文名，欧洲服必须填英文名，表单会拒绝填错的那一边。另一边为空只给警告：现在没事，
但把本服区域切过去之后这个分类就会消失。

**5.（顺带）ASCII 冒号 `:` 也不能出现。** 客户端拿整份串做一次
`gsub(arg, ":", ":0=0=关于=about;")` 来插入它自己的「关于」页签，而 `gsub` 会替换**所有**
冒号 —— 名字里的一个 `:` 会在该分类中间再插一个关于页签，名字变成
`玩:0=0=关于`、图标也串位。全角 `：` 不受影响（客户端找的是 ASCII 冒号）。

**⚠️ 改完类别要 `/reload` 或重登才会看到。** `.reload shop` 只更新**服务端**内存，而客户端的
分类列表**每个 UI 会话只请求一次**：

```lua
-- Turtle_ShopUI.lua:215 —— 启动后 0.5 秒发一次，之后 ready=true 永不再发
Send("Balance"); Send("Categories"); this.ready = true
```

`Shop_RefreshEntries()` 只重取**它已经知道的**分类的条目
（`for k in pairs(ShopEntries)`），从不重新请求分类列表。所以：

| 改了什么 | 客户端要怎么刷新 |
|---|---|
| 类别本身（新增/改名/换图标/删除） | **`/reload`**（或重登） |
| 条目的内容（价格、区域、模型…） | 打开商城就行（`Shop_RefreshEntries`） |
| 另一种语言的名字 | 不用（切换区域时才用） |

> 「关于」那个页签**不在这张表里** —— 它是客户端自己插进类别列表的
> （`Turtle_ShopUI.lua:339` 拼 `:0=0=关于=about;`）。要改它的文字见
> `tools/ClientPatch/README.md` 的「改商城的界面文字」。

#### 物品图标的一个限制（和新增物品有关）

- **非外观类别**：物品图标来自 `GetItemInfo(entry).texture`（客户端自己的物品数据），
  能装备的还会显示 3D 模型 —— **新增任何真实物品都有图**
- **类别 2（外观/Skins）**：格子贴图是按物品 entry 命名的定制图
  `Interface\ShopFrame\entries\<item_template.entry>[_1|_2].blp` —— 你新增的物品没有
  这张图，**格子会是空白的**，需要另外做图

改条目需要数据库账号对 `tw_world.shop_items` 有写权限——见英文文档的
*Database privileges*（默认那份授权里 `tw_world` 是只读的）。

#### 上机自检

`deploy/verify_shop.sql` 可以拿真库把上面这些都验一遍：它跑的就是
`internal/store/shop.go` 里那几条查询（列名、JOIN、分页、重复检测），最后在
**一个事务里**做 INSERT/UPDATE/DELETE 再 `ROLLBACK`，所以顺带验证了授权是否够用，
且**不会留下任何数据**：

```bash
mysql -u wowweb -p tw_world < deploy/verify_shop.sql
```

每一行结果显示 `PASS` / `FAIL`。用它自己的账号跑，验证的才是线上那套权限。

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
internal/store/        全部 SQL：账号、角色、封禁、领域、会话、公告、商城
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
| `/alert` | The login-screen notice the **game client** fetches; public on purpose |
| `/notice` | The notice as a **web page** - where the link inside the client's panel lands |
| `/account/{banned,suspended,no-time,verify}` | What a sign-in failure dialog's link opens |
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
| `/admin/shop` | The **donation shop** items (`shop_items`) |
| `/admin/shop/categories` | The shop **categories** (`shop_categories`) |
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
| `WEB_TRUST_PROXY` | `false` | Trust the proxy's forwarding headers. Must be `true` behind a reverse proxy, or every request is attributed to the proxy. The **last** `X-Forwarded-For` entry - the one the proxy appends - is the one used; `X-Real-IP` is the fallback |
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
| `SHOP_REGION` | `europe` | Which region this realm is, mirroring the core's `NiHao` key: `europe` or `china`. Only used by the shop admin page |
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

-- Only for the shop admin pages. The world database is otherwise read-only to
-- this service, so the write access is granted per table rather than for the
-- whole schema. Skip both lines if you do not use /admin/shop.
GRANT SELECT, INSERT, UPDATE, DELETE ON `tw_world`.`shop_items`      TO 'wowweb'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON `tw_world`.`shop_categories` TO 'wowweb'@'%';
```

The shop also reads `item_template` to resolve an entry into the item name and
description the client will actually show, and to refuse an entry that does not
exist — both covered by the `SELECT ON tw_world.*` grant above.

`/admin/shop/categories` writes `shop_categories`, so that table needs the write
grants too; both lines are listed together because editing either page needs its
own table. If you granted only `SELECT` on `shop_categories` from an earlier
version of this document, re-grant it as above or the category editor will fail
with an access-denied error.

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
HTTPS. With it on, the app reads the **last** `X-Forwarded-For` entry - the one
the proxy appended, which is the peer it actually saw - and ignores whatever the
client wrote to the left of it, so a made-up header cannot pick its own
rate-limit bucket. `X-Real-IP` is only consulted when there is no
`X-Forwarded-For` at all. (For the plain-HTTP name the game client needs, with a
ready config file, see
[Reaching the site by name](#reaching-the-site-by-name-what-the-client-needs)
below.)

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

#### Links in the body

The "Server Alert" panel has **no button**: its body is a `SimpleHTML` widget, so a
**link in the body is the button**:

```xml
<SimpleHTML name="ServerAlertText" hyperlinkFormat="|cff2f68ff|H%s|h[%s]|h|r">
  <Scripts><OnHyperlinkClick>LaunchURL(arg1);</OnHyperlinkClick></Scripts>
```

That comes from `AccountLogin.xml` inside `patch-9.mpq`. The older copy in
`interface.MPQ` does carry a "more information" button, but it has a lower priority and
never loads - editing against it would change the wrong thing.

So an `http://` address **alone on a line** of the body is rendered as a link, in the shape
copied from the client's own `Data/eula.html`, a file the same widget renders:

```html
<p>
<a href="http://twow.home.boym.me/notice">http://twow.home.boym.me/notice</a>
</p>
```

Only an address alone on its line qualifies. One buried in a sentence stays text: the
client's `LaunchURL` refuses addresses with a port, an underscore or a query, and such an
address truncated to its first half would point somewhere nobody asked for. That rule is
`soleURL`, pinned by `TestSoleURL`.

> ⚠️ For the click to do anything, two more things have to be true: the address must be a
> **name on port 80** (no port number), and that name must be in the executable's
> whitelist - see [`../ClientPatch/`](../ClientPatch/).

### Where the client sends a player

Only two things on this client can open a browser (every other `*_URL` key is referenced by
neither the executable nor any active interface file, so it is dead code), and there is a
page for each:

| Page | What sends someone here |
| --- | --- |
| `/notice` | the link in the announcement body; the "server busy / session expired" dialog points here too |
| `/account/banned` | sign-in refused: **account banned** (`WOW_FAIL_BANNED`) |
| `/account/suspended` | sign-in refused: **suspended**, including an IP lock (`WOW_FAIL_SUSPENDED`) |
| `/account/no-time` | sign-in refused: **negative balance** (`WOW_FAIL_NO_TIME`) |
| `/account/verify` | sign-in refused: **e-mail unverified** (`WOW_FAIL_PARENTCONTROL`) |

> ⚠️ **On this core, only `/account/banned` can actually be reached.** The client carries two
> families of sign-in failure text: refusals from the **login server** (realmd) render from the
> `LOGIN_*` family, whose dialog has **only an "OK" button and never a link**; only refusals
> from the **world server** (mangosd) use `AUTH_*` plus `AUTH_*_URL`, which is what grows the
> "help" button. The core's world server sends five codes in total and only `AUTH_BANNED` hits
> that table. To see it: sign in and stop at the **realm list**, ban the account or IP, then
> click the realm. See [`../ClientPatch/README.md`](../ClientPatch/README.md) for the evidence.
>
> 📌 In the admin, "**disable account**" is not "**ban**": disabling writes
> `account.active = 0` and the login server answers `WOW_FAIL_INCORRECT_PASSWORD` - the player
> is told the **password is wrong**. Use a ban to give a real reason.

They are **public on purpose**: the people who need them are the ones who cannot sign in, so
requiring a session would lock them out exactly when they matter. They also disclose
**nothing about the realm** - no address, no port - which a test checks.

The list of reasons is `accountNoticeReasons` in `handlers_notice.go`, matched one for one
with the `AUTH_*_URL` values in the client patch; a mismatch shows up in the tests.

### Reaching the site by name (what the client needs)

The game client only opens `http://name` addresses - a colon makes it refuse the whole
thing - so a clickable link needs a **name served on port 80**. The repository carries a
ready configuration:

```bash
sudo cp deploy/nginx/twow.home.boym.me.conf /etc/nginx/conf.d/
sudo nginx -t && sudo systemctl reload nginx
```

and two settings in `.env`:

```
WEB_BASE_URL=http://twow.home.boym.me   # what the admin pages show as the public address
WEB_TRUST_PROXY=1                        # otherwise every player shares one throttle bucket
```

`WEB_TRUST_PROXY=1` is not optional: behind a proxy every request arrives from nginx's own
address, so without it **the sign-in throttle counts everyone as one visitor - a single
person mistyping their password locks the whole server out**. That the app then reads the
last `X-Forwarded-For` entry rather than the first is just as load-bearing: the entries on
the left are whatever the client sent, so believing them would let one visitor rotate
through a new throttle bucket on every attempt.

This name is deliberately **plain HTTP**: the client cannot follow an `https://` link at all,
so its links have to stay on port 80.

If browsers should get TLS, remember that **only `/alert` must not be redirected**:

* `/alert` is fetched by the **game client itself** through its own HTTP stack. Nobody
  follows a redirect on its behalf, so a 302 there leaves the login-screen panel silently
  blank.
* everything else may redirect, the announcement's links included: those are opened by the
  **browser**, long after the client validated the address and wrote it into a temporary
  Internet Shortcut. The client never sees the redirect.

And one nginx trap: a **server-level `return 301` runs before a location is chosen**, so it
would redirect `/alert` too and bypass the exception. Scope the redirect to a location:

```nginx
location / { return 301 https://$host$request_uri; }
location = /alert { proxy_pass http://172.18.1.6:8080; }   # exact match wins, stays HTTP
```

With TLS in place, also set `SESSION_SECURE=true` for the service.

To check it, on the server:

```bash
curl -s  -H 'Host: twow.home.boym.me' http://172.18.1.6/healthz
curl -s  -H 'Host: twow.home.boym.me' http://172.18.1.6/alert | head -3   # expect SERVERALERT:
curl -s  -H 'Host: twow.home.boym.me' http://172.18.1.6/notice | grep -o '<h1>[^<]*</h1>'
```

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

### The donation shop

The shop the player sees in the client (`Turtle_shopUI`) has **no item list of its
own**: the interface is in the client, but the entries arrive from the world
server over the addon channel as `TW_SHOP` messages. The server holds two tables
from the world database into an in-memory copy (`ObjectMgr::LoadShop`), and answers
the client from that:

| Table | Holds |
| --- | --- |
| `shop_categories` | The shop's categories: id, English name, `_loc4` name, icon |
| `shop_items` | One listing: which `item_template.entry` it sells, price, region lock, display model and placement |

`/admin/shop` edits those rows. **A change reaches the game through
`.reload shop`** — the command clears both maps and reads them again, so no
restart is needed. It requires `SEC_ADMINISTRATOR`.

#### Conditions that fail silently

Each one of these makes the world server log a single line and **skip the row**,
with nothing shown in game. The form therefore refuses them at submit time
instead of letting you find out by reloading and hunting through the shop:

| Condition | What the world server logs |
| --- | --- |
| `price` of 0 | `price is 0, skipping` |
| `item` (the entry) missing from `item_template` | the row is skipped |
| `category` missing from `shop_categories` | the row is skipped |
| the same `entry` listed twice | `already has an entry in the shop for entry %u` |

Two more do not error but do not do what you expect, so the page warns about
them:

* **A `region_locked` that does not match this realm** (the realm's region comes
  from `SHOP_REGION`, i.e. the core's `NiHao` key) means the row is **never
  visible on the other region**. The list marks those rows.
* **A `scale` of 0** makes the model invisible; use 1 for the default.

#### Two columns that look like display text but are not

`shop_items.description` and `description_loc4` are read into memory by the world
server and then **never used again**. The name and description the client shows
come from `item_template`, assembled by the core into:

```
Entries:<cat>=<subcat>=<name>=<price>=<description>=<entry>=<model>=<displayid>=<x>=<y>=<z>=<rot>=…
```

The two fields are not sourced the same way (`ObjectMgr.cpp:9665`), and that
difference decides what you have to translate:

| Field | Source |
| --- | --- |
| Name | `NiHao=1` → whichever `locales_item` column holds the Chinese name (see the warning below — it is **not** fixed at `name_loc4`); `NiHao=0` → `item_template.name` |
| Description | **always** `item_template.description` — no locale lookup, on either region |

**Which column holds the Chinese name is a trap.** The core looks the name up by a
hardcoded array index (`GetItemLocaleName(entry, LOCALE_zhCN)` at
`ObjectMgr.cpp:9668`), and that array is indexed by
`ObjectMgr::m_LocalForIndex` positions, **not** by the `N` in `name_locN`. The
`locales_item` data shipped in this repository lays its eight locale columns out
like this:

```
name_loc1=English  loc2=Korean  loc3=French  loc4=German
name_loc5=Simplified Chinese  loc6=Traditional Chinese  loc7=Spanish  loc8=Spanish (esMX)
```

So Simplified Chinese sits one column later than the MaNGOS convention. Check
your own data before editing a name:

```sql
SELECT entry, name_loc4, name_loc5, name_loc6 FROM locales_item WHERE entry = <your item entry>;
```

Chinese text in the shop therefore means translating the column that actually
holds the Simplified Chinese name (in this repository's data, `name_loc5`) for the
name — and only with `NiHao=1` — and `item_template.description` for the
description. The latter has no `_loc4` counterpart the core will use, so a
translated description also shows to English clients — a core limitation, not
something this page can fix.

Editing the `shop_items` columns **changes nothing** in game.

#### Categories: `/admin/shop/categories`

`shop_categories` is maintained from the admin area too (create, rename / change
icon, delete). Three constraints are hard; the form refuses the first two and only
warns about the third:

**1. The id has to be 1–255.** The column is `int unsigned`, but the core reads it
like this:

```cpp
uint8 id = fields[0].GetUInt8();     // ObjectMgr::LoadShop
```

300 is silently truncated and the tab no longer matches the rows pointing at it.
The id also sets the **tab order** (the client receives the categories sorted by
it), so a smaller id moves a category earlier. It **cannot be changed later** — the
items point at it — and the edit form does not offer it.

**2. A name or an icon cannot contain `=` or `;`.** The world server builds the
**whole** category list for the client as one string:

```cpp
categories += to_string(id) + "=0=" + Name_loc4 + "=" + Icon + ";";
```

and the client splits it on `;` and then on `=`. One `=` does not break one
category, it shifts every category after it. This has to be a refusal, not a
warning.

**3. The icon has to be a texture the client really has.** The client builds the
path itself:

```lua
SetTexture("Interface\\ShopFrame\\" .. icon)      -- Turtle_ShopUI.lua:372
```

That folder holds 332 files, but only 11 named ones work as category icons, and the
form suggests exactly those:

```
about   bag   default   free   mount   pet   scroll   service   tabard   ticket   toys
```

Anything else is **warned about, not refused** — adding your own
`Interface\ShopFrame\<name>.blp` to a patch is legitimate — but without the file
the tab has no icon, so the page says so.

**Deleting is refused while items still point at the category.** The core skips
every item whose category is missing, so deleting one makes those items disappear
from the shop with a single line in the log to show for it. The form does not show
a delete button in that case, and a hand-made POST is refused too (the handler
recounts) with a pointer to `/admin/shop?category=<id>` to move them first.

**4. The name this realm sends has to be filled in.** The core sends exactly one
name and has no fallback:

```cpp
categories += to_string(id) + "=0=" + (NiHao ? Name_loc4 : Name) + "=" + Icon + ";";
```

The client parses that with `(%d+)=(%d+)=(.+)=(.+)`, and `(.+)` needs at least one
character — so an empty name is **not shown blank, it fails to match and the whole
category never appears in game**. A Chinese realm (`NiHao=1`) needs the Chinese
name, a European one needs the English name, and the form refuses the wrong side.
An empty name on the *other* side is only a warning: fine now, but that category
would disappear if the realm's region were flipped.

**5. An ASCII colon `:` is not allowed either.** The client runs
`gsub(arg, ":", ":0=0=" .. about .. "=about;")` over the whole payload to insert
its own About tab, and gsub replaces **every** colon — so a `:` inside a name injects
a second About tab into the middle of that category, leaving the name as
`玩:0=0=关于` and the icon wrong. A full-width `：` is unaffected (the client looks
for the ASCII colon).

**⚠️ A category change needs `/reload` or a relog to show up.** `.reload shop` only
refreshes the **server's** copy, and the client asks for the category list **once per
UI session**:

```lua
-- Turtle_ShopUI.lua:215 - sent 0.5s after load, then ready=true and never again
Send("Balance"); Send("Categories"); this.ready = true
```

`Shop_RefreshEntries()` re-requests the entries of the categories it **already
knows** (`for k in pairs(ShopEntries)`) and never asks for the list itself. So:

| What changed | What the client needs |
| --- | --- |
| A category (added, renamed, re-iconed, deleted) | **`/reload`** (or a relog) |
| An entry's contents (price, region, model, ...) | Opening the shop is enough |
| The name in the other language | Nothing until the region is flipped |

> The About tab is **not a row in this table** — the client inserts it itself
> (`Turtle_ShopUI.lua:339`, `:0=0=关于=about;`). See
> `tools/ClientPatch/README.md` for changing its text.

#### A limitation on item icons (relevant when adding one)

* **Every category except Skins**: an item's icon comes from
  `GetItemInfo(entry).texture` — the client's own item data — and an equippable one
  shows a 3D model, so **any real item has an icon**.
* **Category 2 (Skins)**: the tile is custom artwork named after the item entry,
  `Interface\ShopFrame\entries\<item_template.entry>[_1|_2].blp`. A new item has no
  such file, so **its tile will be blank** until you make one.

Editing an entry needs write access to `tw_world.shop_items`, and the category
editor needs it on `shop_categories`; see
[Database privileges](#database-privileges), where those two tables are granted
explicitly because the rest of the world database stays read-only.

#### Checking it against a real database

`deploy/verify_shop.sql` runs all of the above against your own database: the
same queries `internal/store/shop.go` issues (column names, joins, pagination,
the duplicate check), then an INSERT / UPDATE / DELETE inside a transaction that
it **rolls back**, so it also proves the grant is sufficient and leaves nothing
behind:

```bash
mysql -u wowweb -p tw_world < deploy/verify_shop.sql
```

Each line reports `PASS` or `FAIL`. Run it as the account the service uses — that
is what makes it a test of the live privileges rather than of `root`'s.

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

4. **No coins, refunds, or shop history.** The shop **catalogue**
   (`shop_items` / `shop_categories`) is editable — see
   [The donation shop](#the-donation-shop) — but nothing touches balances or
   history: `shop_coins` and `shop_logs` are left alone. So deleting a character
   here does **not** refund its shop purchases the way the in-game delete does,
   and there is no way to grant or inspect coins from this service. That
   catalogue is also **not live on its own**: the world server answers from an
   in-memory copy, so an edit needs `.reload shop` (see
   [The donation shop](#the-donation-shop)).

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
internal/store/        all SQL: accounts, characters, bans, realms, sessions, announcement, shop
internal/web/          HTTP layer: routes, middleware, handlers
internal/i18n/locales/ en.json, zh.json (embedded)
internal/web/templates HTML (html/template, auto-escaped)
internal/web/assets/   stylesheet
```

Adding a page means adding a handler in `internal/web/handlers_*.go`, a route in
`server.go`, and a template that defines the `content` block. `render_test.go`
walks every template with a representative payload, so a typo in a field name
fails the test suite rather than a page in production.
