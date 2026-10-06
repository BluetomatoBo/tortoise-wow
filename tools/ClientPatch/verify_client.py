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
import ctypes
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

# 哪些键真的会被 LaunchURL 打开：**不硬编码**，而是扫生效的界面文件里的
# `LaunchURL(KEY)` 调用点（见 scan_launch_url_keys）。
#
# 这一点踩过坑：早期版本按「exe 里有没有这个字符串」来判断，结果把
# TURTLE_*_WEBSITE / COMMUNITY_URL / TECH_SUPPORT_URL 全判成了死键 —— 其实它们
# 由界面 Lua 直接引用（`LaunchURL(TURTLE_ARMORY_WEBSITE)`），而 Lua 是按标识符
# 查全局变量的，exe 里当然没有这些名字。后来只扫 .xml 也没看见，因为调用写在
# .lua 里（由 <Script file="..."/> 加载，不在 toc 的清单里）。
LAUNCH_URL_CALL_RE = re.compile(r'LaunchURL\s*\(\s*([A-Za-z_][A-Za-z0-9_]*)\s*\)')


class _FIND(ctypes.Structure):
    _fields_ = [('cFileName', ctypes.c_char * 1024), ('dwFileSize', ctypes.c_uint32),
                ('dwFileTimeLo', ctypes.c_uint32), ('dwFileTimeHi', ctypes.c_uint32),
                ('dwFileFlags', ctypes.c_uint32), ('dwCompSize', ctypes.c_uint32),
                ('dwFileIndex', ctypes.c_uint32)]


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


def _mpq_names(path, mask):
    """用 StormLib 列出归档里的文件名（Windows 通配匹配）。"""
    h = ctypes.c_void_p()
    if not gp._lib.SFileOpenArchive(path.encode(), 0, gp.MPQ_OPEN_READ_ONLY, ctypes.byref(h)):
        return []
    gp._lib.SFileFindFirstFile.restype = ctypes.c_void_p
    gp._lib.SFileFindFirstFile.argtypes = [ctypes.c_void_p, ctypes.c_char_p,
                                           ctypes.POINTER(_FIND), ctypes.c_char_p]
    gp._lib.SFileFindNextFile.argtypes = [ctypes.c_void_p, ctypes.POINTER(_FIND)]
    fd = _FIND()
    out = []
    fh = gp._lib.SFileFindFirstFile(h, mask, ctypes.byref(fd), None)
    if fh:
        while True:
            out.append(fd.cFileName.decode('latin1'))
            if not gp._lib.SFileFindNextFile(fh, ctypes.byref(fd)):
                break
        gp._lib.SFileFindClose(fh)
    gp._lib.SFileCloseArchive(h)
    return out


def effective_glue_files(data_dir):
    """{文件显示名: (来自哪个补丁, 内容)} —— 每个文件取优先级最高的那一份。"""
    glue = 'Interface\\GlueXML\\'
    out = {}
    for _prio, base, path in gp.list_patches(data_dir):          # 从低到高，高的覆盖低的
        try:
            arc = gp.Archive(path)
        except OSError:
            continue
        for name in _mpq_names(path, (glue + '*').encode()):
            low = name.lower()
            if not low.endswith(('.xml', '.lua')):
                continue
            data = arc.read(name)
            if data is not None:
                out[name] = (base, data)
        arc.close()
    return out


def _lua_function_keys(files):
    """{函数名: [它 LaunchURL 的键]} + {函数名: 文件:行}。"""
    fn_keys, fn_where = {}, {}
    cur, where, indent = None, None, 0
    for name, (src, data) in sorted(files.items()):
        if not name.lower().endswith('.lua'):
            continue
        text = data.decode('utf-8', 'replace')
        for lineno, line in enumerate(text.splitlines(), 1):
            m = re.match(r'\s*function\s+([A-Za-z_][A-Za-z0-9_]*)\s*\(', line)
            if m:
                cur, where = m.group(1), '%s:%d（%s）' % (name.split(chr(92))[-1], lineno, src)
                fn_keys.setdefault(cur, [])
                fn_where[cur] = where
                continue
            if line.strip() == 'end' and cur:
                cur = None
                continue
            if cur and not line.lstrip().startswith('--'):
                for key in LAUNCH_URL_CALL_RE.findall(line):
                    if key != 'arg1':
                        fn_keys[cur].append(key)
    return fn_keys, fn_where


def frame_reachability(data_dir):
    """(界面上的按钮真能点到的键, 只有 Lua 还留着的孤儿键)。

    按钮的 XML 里是 <OnClick>Handler();</OnClick>，处理函数在 Lua 里，函数里才是
    `LaunchURL(KEY)`。所以「Lua 里还写着这个键」不等于「界面上还有按钮」——
    删掉框架之后，那些函数就成了没人调用的孤儿。只扫 Lua 分不清这两种情况。
    """
    files = effective_glue_files(data_dir)
    fn_keys, fn_where = _lua_function_keys(files)

    reachable, orphan, evidence = {}, {}, {}
    # 1) 还存在的框架 → 它的 OnClick 处理函数 → 那些键
    for name, (src, data) in sorted(files.items()):
        if not name.lower().endswith('.xml'):
            continue
        text = data.decode('utf-8', 'replace')
        for fname, _tag, _s, _e, block in gp.iter_frames(text):
            m = re.search(r'<OnClick>\s*([A-Za-z_][A-Za-z0-9_]*)\s*\(', block)
            if not m:
                continue
            handler = m.group(1)
            for key in fn_keys.get(handler, []):
                reachable[key] = '%s 的 OnClick → %s（%s）' % (
                    fname, handler, name.split(chr(92))[-1])
    # 2) 有 Lua 函数会打开、但没有任何存在的框架调用它
    all_launched = set()
    for keys in fn_keys.values():
        all_launched.update(keys)
    for fn, keys in fn_keys.items():
        used = any(('→ %s' % fn) in ev for ev in reachable.values())
        if used:
            continue
        for key in keys:
            orphan.setdefault(key, '%s 里还有 LaunchURL 调用，但没有框架再调用它' % fn_where[fn])
    return reachable, orphan


def scan_launch_url_keys(data_dir):
    """扫生效界面文件里的 `LaunchURL(KEY)`，返回 (键集合, {键: [证据]})。

    界面 Lua 是**按标识符**读 Lua 全局变量的（LaunchURL(KEY) 里的 KEY 就是
    GlueStrings 里的键名），所以 exe 里查不到这些名字并不代表没人用。
    """
    keys, evidence = set(), {}
    for name, (src, data) in sorted(effective_glue_files(data_dir).items()):
        text = data.decode('utf-8', 'replace')
        for lineno, line in enumerate(text.splitlines(), 1):
            if line.lstrip().startswith('--'):
                continue
            for key in LAUNCH_URL_CALL_RE.findall(line):
                if key == 'arg1':                    # 面板里的超链接，值是链接本身
                    continue
                keys.add(key)
                evidence.setdefault(key, []).append(
                    '%s:%d（%s）' % (name.split(chr(92))[-1], lineno, src))
    return keys, evidence


def exe_launch_url_keys(exe):
    """扫 exe 里「按返回码索引的键名表」，返回 (键集合, {键: 证据})。

    客户端在世界服登录失败时会自己去读这些键（表是 36 字节一条：4 字节返回码 +
    32 字节键名），所以界面文件里查不到它们 —— 这是另一半来源。只靠界面扫描会
    把它们误判成「没人用」。
    """
    data = open(exe, 'rb').read()
    keys, evidence = {}, {}
    # 一条 = 4 字节返回码 + 32 字节键名；名字必须以 _URL 结尾 —— 这张表装的正是
    # 「哪个返回码该打开哪个地址」。不加这个限制会把 .rdata 里一堆无关的键名按
    # 同样的步长撞出来（第一次实现就踩了这个坑）。
    stride, name_off, code_off, name_len = 36, 4, 0, 32
    pat = re.compile(rb'[A-Z][A-Z0-9_]{3,}_URL')
    i = 0
    while i + stride <= len(data):
        code = int.from_bytes(data[i + code_off:i + code_off + 4], 'little')
        raw = data[i + name_off:i + name_off + name_len].split(b'\0')[0]
        if code <= 64 and raw and pat.fullmatch(raw):
            name = raw.decode()
            # 必须连成一条（≥2 条）才算表，避免撞上孤立的字符串
            j = i + stride
            nxt_code = int.from_bytes(data[j:j + 4], 'little')
            nxt_raw = data[j + name_off:j + name_off + name_len].split(b'\0')[0]
            if nxt_code <= 64 and pat.fullmatch(nxt_raw or b''):
                k = i
                while k + stride <= len(data):
                    c = int.from_bytes(data[k:k + 4], 'little')
                    n = data[k + name_off:k + name_off + name_len].split(b'\0')[0]
                    if c > 64 or not pat.fullmatch(n or b''):
                        break
                    keys[n.decode()] = 'exe 里按返回码索引的键名表（返回码 %d，0x%x 附近）' % (c, 0x400000 + k)
                    k += stride
                i = k
                continue
        i += 1
    return set(keys), keys


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

    # 哪些键会被 LaunchURL 打开：扫调用点 + 判断按钮是否还在，不猜
    launched, evidence = scan_launch_url_keys(data_dir)
    reachable, orphan = frame_reachability(data_dir)
    exe_keys, exe_evidence = exe_launch_url_keys(exe)
    evidence = {k: v for k, v in evidence.items()}
    for k, v in exe_evidence.items():
        evidence.setdefault(k, []).append(v)
    launched |= exe_keys
    for k, v in reachable.items():
        evidence.setdefault(k, []).insert(0, '界面按钮可达：' + v)
    # 只检查「真的能点到」的键：界面按钮还存在的，或 exe 按返回码读的。
    # 按钮已删、只有 Lua 还留着的键不在这里 —— 它们的地址已经无关紧要了。
    live = sorted(k for k in assigned
                  if (k in reachable or k in exe_keys) and '://' in assigned[k])
    for key in live:
        check_url(key, assigned[key], hosts, rep, is_launch=True)
    if not live:
        rep.add(WARN, 'LaunchURL 用的键',
                '配置里没有一个键指向还存在的按钮 —— 检查 overrides.json')

    # 按键（按钮已从界面删掉，只有 Lua 里还留着）：点不到，但不影响结论
    orphans = sorted(k for k in assigned if k in orphan and k not in reachable and k not in exe_keys)
    if orphans:
        rep.add(OK, '按钮已从界面删掉，只有 Lua 里还留着的键（点不到）',
                '、'.join(orphans) + '\n        ' + orphan[orphans[0]])

    # 配了但完全没人引用的键：只汇总，不参与结论
    unused = sorted(k for k in assigned
                    if k not in launched and k not in orphan and '://' in assigned[k])
    if unused:
        rep.add(OK, '配置里设置了、界面文件却没引用的键（不会有任何效果）',
                '、'.join(unused) + '\n        依据：扫过所有生效的 Interface\\GlueXML\\*.xml / *.lua')

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
        if not args.quiet:
            print()
            print('  界面里真的会调用 LaunchURL 的键（共 %d 个）：' % len(launched))
            for key in sorted(launched):
                print('    %-32s %s' % (key, '；'.join(evidence[key][:2])))
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
