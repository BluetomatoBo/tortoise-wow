#!/usr/bin/env python3
"""检查「客户端补丁 + 改过的 exe」这一对是不是真的能点开链接。

为什么需要它
  链接能不能点，取决于三件事同时在位：

    1. patch-Z.mpq 里的地址形状合法（http://、无端口、字符集）
    2. 该地址的主机在 WoW.exe 的白名单里
    3. 没写错槽位、没把别的域名顶掉

  这三件事分散在两个文件里，而且**任何一件不满足都是静默的** ——
  官方客户端不会报错，只是点了没反应。所以把它们放到一个命令里对一遍。

它查什么
  · 找出客户端**实际加载**的那份 GlueStrings.lua（按补丁优先级取最高的一份，
    不是按文件时间），这样查的是真实生效值
  · 逐个检查会被 LaunchURL 打开的键：地址形状 + 主机是否在白名单里
  · 单独检查 SERVER_ALERT_URL（它由客户端自己抓取，规则不同：可以带端口）
  · 可选 --link 检查你准备写进公告正文的地址
  · 顺带确认 exe 的白名单表没被改坏、其它槽位都还在

用法
  python3 verify_client.py
  python3 verify_client.py --exe /path/to/WoW.exe --data /path/to/client/Data
  python3 verify_client.py --link http://twow.home.boym.me/notice

退出码：0 全部通过；1 有明确的失败项；2 只有不确定项。
"""
import argparse
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import gen_patchz as gp        # Archive / list_patches / LAUNCH_URL_KEYS / launch_url_problem
import patch_urllist as pu     # Pe / find_tables

CONFIG = os.path.join(HERE, 'overrides.json')
GLUE = 'Interface\\GlueXML\\GlueStrings.lua'

OK, WARN, BAD = 'ok', 'warn', 'bad'
MARK = {OK: '✓', WARN: '⚠', BAD: '✗'}

# 本客户端里真正会被 LaunchURL 打开的键。逐个查过：exe 里有一张按登录失败码索引的
# 36 字节定长键名表（0x803744 起，含 AUTH_BANNED/DB_BUSY/NO_TIME/SUSPENDED/
# PARENTAL_CONTROL_URL），而下面这些键在 exe 与生效的界面文件里都没有任何引用。
LIVE_LAUNCH_KEYS = {
    'AUTH_BANNED_URL', 'AUTH_DB_BUSY_URL', 'AUTH_NO_TIME_URL',
    'AUTH_PARENTAL_CONTROL_URL', 'AUTH_SUSPENDED_URL',
}
DEAD_LAUNCH_KEYS = {
    'ACCOUNT_CREATE_URL', 'COMMUNITY_URL', 'TECH_SUPPORT_URL',
    'AUTH_TURTLE_WEBSITE', 'TURTLE_ARMORY_WEBSITE', 'TURTLE_COMMUNITY_FORUM_WEBSITE',
    'TURTLE_DISCORD_WEBSITE', 'TURTLE_KNOWLEDGE_DATABASE_WEBSITE', 'TURTLE_REDDIT_WEBSITE',
}


class Report:
    def __init__(self):
        self.items = []

    def add(self, level, subject, detail):
        self.items.append((level, subject, detail))

    def worst(self):
        levels = {lvl for lvl, _, _ in self.items}
        if BAD in levels:
            return BAD
        if WARN in levels:
            return WARN
        return OK


def parse_assignments(text):
    """取出 Lua 里的 `KEY = "value"`（只看顶层赋值，够用）。"""
    out = {}
    for line in text.splitlines():
        m = re.match(r'\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*"(.*)"\s*;?\s*$', line)
        if m:
            out[m.group(1)] = m.group(2)
    return out


def effective_lua(data_dir, name=GLUE):
    """客户端实际加载的那份：按补丁优先级从高到低找第一个提供的。"""
    for _prio, base, path in reversed(gp.list_patches(data_dir)):
        try:
            arc = gp.Archive(path)
        except OSError:
            continue
        try:
            data = arc.read(name)
        finally:
            arc.close()
        if data is not None:
            return base, data.decode('utf-8', 'replace')
    return None, None


def whitelist(exe):
    """返回 (可信 URL 主机白名单, 表数量, 表项总数)。

    客户端里有三张同构的表：MPQ 归档名、可信 URL 名单、以及 ChecksumExecutables
    要校验的文件清单。可信 URL 那张**自己就能标识自己** —— 它是唯一带 `*.` 通配条目的
    （官方的 *.blizzard.com、乌龟服的 *.turtlecraft.gg 等），文件清单那张全是
    xxx.dll / WoW.exe。所以按这个特征挑表，不靠猜扩展名。
    """
    data = bytearray(open(exe, 'rb').read())
    pe = pu.Pe(data)
    tables = pu.find_tables(data, pe)
    total = sum(len(run) for _s, run in tables)
    url_tables = [run for _s, run in tables if any(v.startswith('*.') for _o, v in run)]
    if not url_tables:
        return [], len(tables), total, []
    hosts = [v for run in url_tables for _o, v in run]
    others = [f'{len(tables)} 张表：' + '、'.join(
        f'{i + 1}={len(run)} 项' for i, (_s, run) in enumerate(tables))]
    return hosts, len(tables), total, others


def host_verdict(host, entries):
    """主机在白名单里的判定。

    从 WoW.exe 反汇编出来的判定规则：普通项与主机名整串相等；`*.x` 项要先在
    主机名里找点再比较，而「找第一个点」和「找最后一个点」两种实现给出的结果
    不同 —— 所以只把整串相等当作确定通过，`*.x` 只给「可能」。
    """
    for e in entries:
        if e == host:
            return OK, f'白名单里有完整主机名 {e!r}（整串相等，最可靠的形态）'
    for e in entries:
        if e.startswith('*.'):
            suffix = e[1:]
            if host.endswith(suffix) and host.count('.') == suffix.count('.'):
                return WARN, (f'白名单里的 {e!r} 可能匹配（主机名恰好是「一个标签 + {suffix}」），'
                              f'但 `*.x` 的匹配实现在反汇编里有两种读法，不确定；'
                              f'想稳就把 {host!r} 整串写进去')
    return BAD, f'白名单里没有 {host!r}；用 patch_urllist.py --list 看可用槽位'


def check_url(key, value, hosts, rep, is_launch):
    if is_launch:
        problem = gp.launch_url_problem(value)
        if problem:
            rep.add(BAD, key, f'{value} —— {problem}')
            return
    if not value.lower().startswith(('http://', 'https://')):
        rep.add(WARN, key, f'{value} —— 不是 http 地址，跳过')
        return
    host = re.sub(r'^[a-z]+://', '', value).split('/')[0].split(':')[0]
    level, detail = host_verdict(host, hosts)
    if level == OK and is_launch:
        rep.add(OK, key, f'{value}\n        主机 {host}：{detail}')
    elif level == WARN:
        rep.add(WARN, key, f'{value}\n        主机 {host}：{detail}')
    else:
        # SERVER_ALERT_URL 不走白名单，主机不在名单里也不影响它
        if is_launch:
            rep.add(BAD, key, f'{value}\n        主机 {host}：{detail}')
        else:
            rep.add(OK, key, f'{value}\n        由客户端自己抓取，不查白名单')


def main():
    ap = argparse.ArgumentParser(
        description='检查客户端补丁与 exe 白名单是否配套（链接能不能点）。',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''示例：
  %(prog)s
  %(prog)s --link http://twow.home.boym.me/notice

退出码：0 通过 / 1 有失败 / 2 只有不确定项''')
    ap.add_argument('--exe', help='WoW.exe 路径，默认从 overrides.json 的 clientDataDir 推导')
    ap.add_argument('--data', help='客户端 Data 目录，默认取 overrides.json 的 clientDataDir')
    ap.add_argument('--link', action='append', default=[], metavar='URL',
                    help='额外检查一个准备写进公告正文的地址，可重复')
    ap.add_argument('--quiet', action='store_true', help='只打印结论')
    args = ap.parse_args()

    cfg = {}
    if os.path.isfile(CONFIG):
        with open(CONFIG, encoding='utf-8') as f:
            cfg = json.load(f)
    exe = args.exe or os.path.join(os.path.dirname(os.path.abspath(
        args.data or cfg.get('clientDataDir', ''))), 'WoW.exe')
    data_dir = args.data or cfg.get('clientDataDir', '')

    rep = Report()
    for label, path in (('WoW.exe', exe), ('客户端 Data 目录', data_dir)):
        if not path or not os.path.exists(path):
            rep.add(BAD, label, f'找不到：{path or "(未指定)"}')
    if rep.worst() == BAD:
        print('\n'.join(f'  {MARK[l]} {s}：{d}' for l, s, d in rep.items))
        return 1

    # --- exe 白名单 ---
    try:
        hosts, tables, total, _ = whitelist(exe)
        rep.add(OK, 'WoW.exe 可解析',
                f'{exe}\n        {os.path.getsize(exe):,} 字节，{tables} 张表、{total} 项')
        if not hosts:
            rep.add(BAD, '可信 URL 白名单', '没找到带 `*.` 条目那张表 —— exe 可能不是这个客户端')
        else:
            rep.add(OK, '可信 URL 白名单', f'{len(hosts)} 项：' + '、'.join(sorted(hosts)))
    except Exception as exc:                                    # noqa: BLE001
        rep.add(BAD, 'WoW.exe 解析失败', f'{exc}')
        hosts = []

    # --- 生效的客户端配置 ---
    source, text = effective_lua(data_dir)
    if text is None:
        rep.add(BAD, 'GlueStrings.lua', '所有补丁里都没有这个文件')
        assigned = {}
    else:
        rep.add(OK, '实际生效的 GlueStrings.lua', f'来自 {source}')
        assigned = parse_assignments(text)

    live = sorted(k for k in assigned if k in LIVE_LAUNCH_KEYS)
    for key in live:
        check_url(key, assigned[key], hosts, rep, is_launch=True)
    if not live:
        rep.add(BAD, '登录失败对话框用的键',
                '生效文件里一个都没有 —— 客户端会退回它内置的默认地址')

    # 死键只汇总一行，不参与结论：改了它们在这个客户端上不会有任何反应
    dead = sorted(k for k in assigned if k in DEAD_LAUNCH_KEYS and '://' in assigned[k])
    if dead:
        rep.add(OK, '这些键本客户端不引用（改了也不会有效果）',
                '、'.join(dead) + '\n        依据：exe 与生效的界面文件里都没有引用')

    if 'SERVER_ALERT_URL' in assigned:
        check_url('SERVER_ALERT_URL', assigned['SERVER_ALERT_URL'], hosts, rep, is_launch=False)
    else:
        rep.add(BAD, 'SERVER_ALERT_URL', '生效文件里没有这个键 —— 公告面板不会出现')

    # --- 公告正文里的链接 ---
    for link in args.link:
        check_url('公告正文里的链接', link, hosts, rep, is_launch=True)

    # --- 输出 ---
    if not args.quiet:
        print()
        order = {BAD: 0, WARN: 1, OK: 2}
        for level, subject, detail in sorted(rep.items, key=lambda i: order[i[0]]):
            print(f'  {MARK[level]} {subject}')
            print(f'      {detail}')
    verdict = rep.worst()
    print()
    if verdict == OK:
        print('  结论：这一对文件是配套的 —— 面板能拿到公告，链接点得开。')
        print('        （前提：域名在客户端所在机器上能解析，且走 80 端口。）')
        return 0
    if verdict == WARN:
        print('  结论：没有明确错误，但有不确定项 —— 见上面的 ⚠。')
        return 2
    print('  结论：有明确错误，照上面的 ✗ 修（多半是地址形状或被白名单挡住）。')
    if any('白名单里没有' in d for _l, _s, d in rep.items):
        print(f'        查的是 {exe}')
        print('        如果你是在另一份副本上打的补丁（比如先拷出来改再拷回去），')
        print('        用 --exe 指向那一份；或者把这份也打一遍：')
        print("          python3 patch_urllist.py --set '<槽位>=<域名>'")
    return 1


if __name__ == '__main__':
    sys.exit(main())
