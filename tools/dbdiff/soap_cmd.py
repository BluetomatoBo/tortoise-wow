#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""soap_cmd.py —— 通过 MaNGOS 的 SOAP 接口执行一条 GM 命令，并打印命令的输出。

    SOAP_URL=http://172.18.1.6:7878/ SOAP_USER=soaptest SOAP_PASS=xxx \
        python3 tools/dbdiff/soap_cmd.py ".server info"

也可以把凭据写在命令行（会进 shell 历史，不建议）：--url/--user/--password。

接口来自 `src/mangosd/MaNGOSsoap.cpp`：单方法 `ns1:executeCommand`（命名空间 `urn:MaNGOS`），
用**游戏账号**做 HTTP Basic 认证，账号的 `rank` 必须 ≥ 4（SEC_ADMINISTRATOR；
注意 6/SEC_CONSOLE 会被 GetSecurityFromDatabase 判成普通玩家），命令以 SEC_CONSOLE 执行，
命令的**控制台输出**会原样返回。没有会话/目标，所以 `.aura` `.cast` 这类「对选中单位」的命令
会回一行 “You must select a character or creature!”——它们只能由游戏内的 GM 跑。
"""

import argparse
import base64
import os
import sys
import urllib.request

BODY = """<?xml version="1.0" encoding="utf-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:MaNGOS">
 <SOAP-ENV:Body>
  <ns1:executeCommand><command>%s</command></ns1:executeCommand>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>"""


def escape(text):
    return (text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;"))


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("command", help="要执行的 GM 命令，例如 \".server info\"")
    ap.add_argument("--url", default=os.environ.get("SOAP_URL", "http://127.0.0.1:7878/"))
    ap.add_argument("--user", default=os.environ.get("SOAP_USER"))
    ap.add_argument("--password", default=os.environ.get("SOAP_PASS"))
    ap.add_argument("--raw", action="store_true", help="打印原始 XML 响应")
    args = ap.parse_args()

    if not args.user or not args.password:
        sys.exit("需要 SOAP_USER / SOAP_PASS（或用 --user/--password）")

    body = (BODY % escape(args.command)).encode("utf-8")
    req = urllib.request.Request(args.url, data=body, method="POST")
    req.add_header("Content-Type", "text/xml; charset=utf-8")
    req.add_header("SOAPAction", '"urn:MaNGOS#executeCommand"')
    req.add_header("Authorization", "Basic " + base64.b64encode(
        ("%s:%s" % (args.user, args.password)).encode("utf-8")).decode("ascii"))

    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            text = resp.read().decode("utf-8", "replace")
    except urllib.error.HTTPError as exc:
        pretty = {401: "认证失败（用户名/密码或 rank < 4）",
                  403: "被拒绝",
                  503: "服务器正在关闭"}.get(exc.code, "")
        sys.exit("HTTP %d %s\n%s" % (exc.code, pretty, exc.read().decode("utf-8", "replace")[:400]))

    if args.raw:
        print(text)
        return
    start = text.find("<result")
    if start < 0:
        print(text)
        return
    value = text[text.find(">", start) + 1: text.find("</result>", start)]
    # gSoap 把换行编码成 &#10;/&#xA; 之类，还原常用的几个
    for src, dst in (("&#10;", "\n"), ("&#xA;", "\n"), ("&lt;", "<"), ("&gt;", ">"), ("&amp;", "&")):
        value = value.replace(src, dst)
    print(value.strip())


if __name__ == "__main__":
    main()
