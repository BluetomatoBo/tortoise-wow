# SOAP 接入配置（一次性 · 测完就关）

接口来自 `src/mangosd/MaNGOSsoap.cpp`：单方法 `ns1:executeCommand`（命名空间 `urn:MaNGOS`），
用**游戏账号**做 HTTP Basic 认证，命令以 `SEC_CONSOLE` 执行，**命令的控制台输出原样返回**。

## 1. 建一个一次性账号（认证库 `tw_logon`）

```sql
INSERT INTO `account` (`username`, `sha_pass_hash`, `rank`)
VALUES ('soaptest', SHA1('soaptest:换成你的密码'), 4);
```

* `rank` 取 **4**（SEC_ADMINISTRATOR）或 5 —— SOAP 的最低要求是 4；
  **填 6 反而会变成普通玩家**：`AccountMgr::GetSecurityFromDatabase` 只认 1..5，其它值一律 SEC_PLAYER。
* 哈希 = `SHA1(用户名:密码)`（`AccountMgr::CalculateShaPassHash`），用户名要与库里完全一致
  （我发请求时用全小写，别写成 `SoapTest`）。

## 2. 改 `mangosd.conf`

```
SOAP.Enabled = 1
SOAP.IP = 172.18.1.6        # 只在本网段可用，别写 0.0.0.0
SOAP.Port = 7878
LogFilter_SpellCast = 1     # 顺手开：日志里会出现「Aura: construct Spellid : …」（数值级证据）
```

## 3. 重启服务端，然后把用户名/密码发我（我会先跑 `.server info` 验连通）

## 4. 测完关掉

```
SOAP.Enabled = 0            # 重启生效
DELETE FROM tw_logon.account WHERE username = 'soaptest';
```

## 我能用 SOAP 做什么、不能做什么

| 能做（命令 + 输出会回给我） | 不能做 |
|---|---|
| `.server info`、`.server list` 之类服务器级命令 | **`.aura` / `.cast` / `.learn` 对自己** —— SOAP **没有会话、没有选中目标**，`GetSelectedUnit()` 返回空 → 只会回 `You must select a character or creature!` |
| `.reload spell_affect`：看内核是否干净地接受这 293 行 | 读日志文件（我没有文件系统访问） |
| `.send items <角色> "GM" "测试" 33091`：把图腾/披风寄给测试角色 | 看客户端画面（图标、模型） |
| `.character hasitem <角色> <物品>`、`.character itemlog` 等按名字操作的命令 | 驯服宠物（必须客户端） |

**所以：效果类验证仍然要你在游戏里点几下**，或者把日志发我核对：
`grep "Aura: construct Spellid" /data_2T/ts_wow/logs/server_<最新>.log | tail -40`

## 我拿到访问后的动作顺序（先说明再执行）

1. `.server info` —— 确认连通与核心版本。
2. `.reload spell_affect` —— 确认 293 行被内核干净加载。
3. `.send items <你的测试角色> "GM 验证" "古仪图腾" 33091`、`… 55095` —— 你用邮件收。
4. 其余等你游戏内跑完，把观察结果或日志发我，我逐条核对。

**安全**：密码会留在我们的对话记录里 → 一次性账号 + 测完即删；`SOAP.IP` 不要写 `0.0.0.0`；
不放心随时把 `SOAP.Enabled` 改回 0（重启生效）。
