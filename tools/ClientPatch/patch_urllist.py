#!/usr/bin/env python3
"""把 WoW.exe 内嵌的可信 URL 白名单换成自己的域名 —— 等长覆盖，零副作用。

为什么需要它
  登录页「系统公告」面板里的可点击链接由客户端 LaunchURL 打开，而它对目标主机
  有一份**写死在 exe 里的白名单**：官方那份是 *.worldofwarcraft.com、*.battle.net、
  *.blizzard.com 等；乌龟服那份额外加了 *.turtlecraft.gg，中文客户端那份加了
  *.wuguifu.com。不在名单里的域名点不动（客户端直接忽略）。

  所以「公告里放自己站点的链接」这件事，只有改 exe 可实现 —— 服务端没有任何配置项。

它做什么
  1. 解析 PE，拿到 ImageBase 与节表
  2. **结构化定位**白名单表：扫描连续 ≥3 个 DWORD，每个都等于 ImageBase+RVA、
     且指向一个以 NUL 结尾的「主机名样式」字符串，遇到空 DWORD 收尾。
     不硬编码任何域名，所以换客户端版本、换语言也能找到。
  3. 把指定槽位**等长覆盖**成长度不超过原值的域名，余下补 NUL
  4. 先备份、落盘后逐项验证

为什么等长覆盖就够了
  白名单是 .data 里的 `const char*` 数组，字符串紧跟在数组后面连续存放。
  每个字符串是独立字面量，所以「换短不换长」不需要动指针、不需要改文件长度、
  也不需要重定位 —— 整个文件只有被替换的那几十个字节会变。

为什么不需要同时处理 ChecksumExecutables
  ChecksumExecutables.cpp 只把 WoW.exe 与 4 个 DLL 的哈希算出来，而**客户端里
  没有任何期望值**（没有清单文件、没有内嵌常量），本地根本无法自我拒绝；
  服务端一侧也全都不校验：
    · realmd 的版本哈希表是空的 → AuthSocket::VerifyVersion 直接 return true
    · Warden 默认全关（WinEnabled=0 / OSXEnabled=0）
    · 世界服的 digest 是会话密钥证明 SHA1(账号‖0‖clientSeed‖serverSeed‖K)，与文件无关
    · AddonHandler 只在插件块**格式错**时踢人，且插件块是认证包最后一个字段
  所以改 exe 只需要这一处补丁。
"""
import argparse
import hashlib
import json
import os
import re
import shutil
import struct
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
OVERRIDES = os.path.join(HERE, 'overrides.json')

# 默认保护名单：这些主机客户端自己还要用（门户/补丁服务），别拿去换
PROTECT_DEFAULT = (
    'blizzard', 'worldofwarcraft', 'battle.net', 'battlenet',
    'blizzcon', 'turtlecraft', 'wow-europe',
)

# 主机名样式：要么 `*.example.com`，要么 `www.example.com`
HOSTNAME_RE = re.compile(rb'^(?:\*\.)?[A-Za-z0-9](?:[A-Za-z0-9.-]*[A-Za-z0-9])?\.[A-Za-z]{2,}$')


# ---------------------------------------------------------------------------
# PE 解析
# ---------------------------------------------------------------------------
class Pe:
    def __init__(self, data):
        if data[:2] != b'MZ':
            raise ValueError('不是 MZ 开头的文件，不是 PE')
        e = struct.unpack_from('<I', data, 0x3c)[0]
        if data[e:e + 4] != b'PE\0\0':
            raise ValueError('PE 签名缺失')
        nsec = struct.unpack_from('<H', data, e + 6)[0]
        opt = struct.unpack_from('<H', data, e + 20)[0]
        magic = struct.unpack_from('<H', data, e + 24)[0]
        if magic != 0x10b:
            raise ValueError('只支持 PE32（0x10b），这个文件是 0x%x' % magic)
        self.imagebase = struct.unpack_from('<I', data, e + 24 + 28)[0]
        self.sections = []
        for i in range(nsec):
            s = e + 24 + opt + i * 40
            name = data[s:s + 8].rstrip(b'\0').decode('ascii', 'replace')
            vsz, rva, rsz, roff = struct.unpack_from('<IIII', data, s + 8)
            self.sections.append((name, rva, vsz, roff, rsz))

    def off_to_rva(self, off):
        for _, rva, _, roff, rsz in self.sections:
            if roff <= off < roff + rsz:
                return rva + (off - roff)
        return None

    def rva_to_off(self, rva):
        for _, srva, vsz, roff, rsz in self.sections:
            if srva <= rva < srva + max(vsz, rsz):
                delta = rva - srva
                if delta < rsz:
                    return roff + delta
        return None


def read_cstr(data, off, limit=64):
    end = data.find(b'\0', off, off + limit)
    if end < 0:
        return None
    return data[off:end]


def is_hostname(raw):
    if not raw or len(raw) > 48:
        return False
    try:
        text = raw.decode('ascii')
    except UnicodeDecodeError:
        return False
    return bool(HOSTNAME_RE.match(text.encode()))


# ---------------------------------------------------------------------------
# 结构化定位白名单表
# ---------------------------------------------------------------------------
def find_tables(data, pe):
    """返回 [(start_off, [(slot_off, value), ...]), ...]。

    白名单是 `const char*[]`，数组元素是 VA，以空指针结尾；字符串紧跟在数组后面。
    不靠域名文本匹配，所以对任何版本都适用。
    """
    tables = []
    n = len(data)
    for base in range(0, n - 12, 4):
        run = []
        pos = base
        while pos + 4 <= n:
            va = struct.unpack_from('<I', data, pos)[0]
            if va == 0:
                break
            off = pe.rva_to_off(va - pe.imagebase)
            if off is None:
                break
            raw = read_cstr(data, off)
            if not is_hostname(raw):
                break
            run.append((off, raw.decode('ascii')))
            pos += 4
        if len(run) < 3:
            continue
        # 跳过「从表中间开始」的假起点
        if base >= 4:
            prev = struct.unpack_from('<I', data, base - 4)[0]
            if prev:
                poff = pe.rva_to_off(prev - pe.imagebase)
                if poff is not None and is_hostname(read_cstr(data, poff)):
                    continue
        tables.append((base, run))
    # 去掉与更长表完全重合的短表
    tables.sort(key=lambda t: -len(t[1]))
    kept = []
    for start, run in tables:
        if any(all(s in r for s in run) for _, r in kept):
            continue
        kept.append((start, run))
    return kept


# ---------------------------------------------------------------------------
# 校验
# ---------------------------------------------------------------------------
def sha256(data):
    return hashlib.sha256(data).hexdigest()


def recheck_table(data, pe, slots):
    """所有槽位仍指向 NUL 结尾的字符串，且相邻槽位没被冲掉。"""
    problems = []
    for off, expected in slots:
        raw = read_cstr(data, off)
        if raw is None:
            problems.append('偏移 0x%x 处不再是 NUL 结尾的字符串' % off)
        elif raw.decode('ascii', 'replace') != expected:
            problems.append('偏移 0x%x 处是 %r，期望 %r' % (off, raw.decode('ascii', 'replace'), expected))
    return problems


# ---------------------------------------------------------------------------
def load_client_exe():
    """没给 --exe 时，从 overrides.json 的 clientDataDir 推出 WoW.exe。"""
    try:
        with open(OVERRIDES, encoding='utf-8') as f:
            cfg = json.load(f)
    except (OSError, ValueError):
        return None
    data_dir = cfg.get('clientDataDir')
    if not data_dir:
        return None
    for name in ('WoW.exe', 'wow.exe'):
        cand = os.path.join(os.path.dirname(os.path.abspath(data_dir)), name)
        if os.path.isfile(cand):
            return cand
    return None


def print_tables(tables, pe, protect):
    for start, run in tables:
        print('白名单表：文件偏移 0x%x（VA 0x%x），%d 项' % (start, pe.imagebase + pe.off_to_rva(start), len(run)))
        for off, value in run:
            mark = '  [保护]' if any(p in value for p in protect) else ''
            print('  0x%06x  %-24s 可用长度 %d%s' % (off, value, len(value), mark))
        print()


def main():
    ap = argparse.ArgumentParser(
        description='等长覆盖 WoW.exe 里内嵌的可信 URL 白名单。',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''示例：
  %(prog)s --list
  %(prog)s --set '*.wuguifu.com=*.example.com'
  %(prog)s --set '*.wowtaiwan.com.tw=*.mydomain.net' --dry-run
  %(prog)s --restore

VERIFY（落盘前逐项检查，任一项不过就中止且不写文件）：
  1. 目标槽位在表中唯一存在，且新域名长度 ≤ 原值
  2. 新域名仍是合法主机名样式
  3. 写完后所有槽位仍是 NUL 结尾的字符串、值符合预期
  4. 文件长度不变，且**所有变化的字节都落在被替换的槽位内**

被保护的主机（含 blizzard / battle.net / turtlecraft 等）要明确用 --force 才允许替换 ——
它们是客户端门户/补丁服务还在用的地址，换掉可能连带破坏其它功能。
''')
    ap.add_argument('--exe', help='WoW.exe 路径，默认从 overrides.json 的 clientDataDir 推导')
    ap.add_argument('--list', action='store_true', help='只打印白名单表，不修改')
    ap.add_argument('--set', action='append', default=[], metavar='旧域名=新域名',
                    help='替换一项，可重复；长度不能超过原值')
    ap.add_argument('--dry-run', action='store_true', help='跑完整校验但不落盘')
    ap.add_argument('--force', action='store_true', help='允许替换被保护的主机')
    ap.add_argument('--restore', action='store_true', help='从备份还原')
    ap.add_argument('--backup', metavar='路径', help='备份路径，默认 <exe>.bak')
    args = ap.parse_args()

    exe = args.exe or load_client_exe()
    if not exe:
        print('错误：没找到 WoW.exe，请用 --exe 指定', file=sys.stderr)
        return 1
    if not os.path.isfile(exe):
        print('错误：文件不存在 %s' % exe, file=sys.stderr)
        return 1
    backup = args.backup or exe + '.bak'

    if args.restore:
        if not os.path.isfile(backup):
            print('错误：没有备份可还原（%s）' % backup, file=sys.stderr)
            return 1
        shutil.copyfile(backup, exe)
        print('已从 %s 还原 %s' % (backup, exe))
        return 0

    data = bytearray(open(exe, 'rb').read())
    try:
        pe = Pe(data)
    except ValueError as exc:
        print('错误：%s' % exc, file=sys.stderr)
        return 1

    protect = list(PROTECT_DEFAULT)
    tables = find_tables(data, pe)
    if not tables:
        print('错误：没找到可信 URL 白名单表（不是乌龟服/暴雪 1.12 客户端？）', file=sys.stderr)
        return 1

    if args.list or not args.set:
        print('%s  (%d 字节, sha256 %s)\n' % (exe, len(data), sha256(bytes(data))[:16]))
        print_tables(tables, pe, protect)
        if not args.set:
            print('没有 --set，未做任何修改。')
        return 0

    # 所有槽位：找一张包含全部待替换项的唯一的表
    targets = []
    for spec in args.set:
        if '=' not in spec:
            print('错误：--set 要写成 旧域名=新域名（收到 %r）' % spec, file=sys.stderr)
            return 1
        old, new = spec.split('=', 1)
        old, new = old.strip(), new.strip()
        if not is_hostname(new.encode()):
            print('错误：%r 不像主机名（要么 *.example.com，要么 www.example.com）' % new, file=sys.stderr)
            return 1
        hits = [(start, off, val) for start, run in tables for off, val in run if val == old]
        already = [(start, off, val) for start, run in tables for off, val in run if val == new]
        if not hits:
            if already:
                # 上一次已经打过了 —— 幂等跳过，不然重跑就没法用
                print('跳过 %s → %s：目标域名已在位（槽位 0x%x）' % (old, new, already[0][1]))
                continue
            print('错误：白名单里既没有 %r（旧）也没有 %r（新）；用 --list 看可用槽位'
                  % (old, new), file=sys.stderr)
            return 1
        if already:
            print('注意：%r 已在位（槽位 0x%x），这次会再换一个槽位' % (new, already[0][1]), file=sys.stderr)
        if len(hits) > 1:
            print('错误：%r 出现在 %d 张表里，无法确定改哪个' % (old, len(hits)), file=sys.stderr)
            return 1
        start, off, val = hits[0]
        if len(new) > len(val):
            room = max((len(v) for s, r in tables for o, v in r if s == start and not any(
                p in v for p in protect) and v != old), default=0)
            print('错误：%r 有 %d 字符，放不进 %d 字符的槽位 %r。'
                  % (new, len(new), len(val), old), file=sys.stderr)
            if room:
                print('      这张表里还有 %d 字符的槽位（用 --list 看）' % room, file=sys.stderr)
            return 1
        if any(p in old for p in protect) and not args.force:
            print('错误：%r 在保护名单里（客户端门户/补丁服务要用）。确认要换就加 --force' % old, file=sys.stderr)
            return 1
        targets.append((start, off, val, new))

    # 幂等：目标值已经在位就跳过
    todo = []
    for start, off, val, new in targets:
        if read_cstr(data, off).decode('ascii') == new:
            print('跳过 %s：已经是 %r' % (val, new))
        else:
            todo.append((start, off, val, new))
    if not todo:
        print('无需修改。')
        return 0

    before = bytes(data)
    for start, off, val, new in todo:
        data[off:off + len(val)] = new.encode() + b'\0' * (len(val) - len(new))
        print('0x%06x  %s → %s（补 %d 个 NUL）' % (off, val, new, len(val) - len(new)), flush=True)

    # --- 落盘前验证 ---
    problems = []
    if len(data) != len(before):
        problems.append('文件长度变了：%d → %d' % (len(before), len(data)))
    spans = [(off, off + len(val)) for _, off, val, _ in todo]
    for i, (a, b) in enumerate(zip(before, data)):
        if a != b and not any(lo <= i < hi for lo, hi in spans):
            problems.append('偏移 0x%x 的变化落在槽位之外' % i)
            break
    expected = {off: val for _, run in tables for off, val in run}
    for _, off, _, new in todo:
        expected[off] = new
    for start, run in tables:
        problems += recheck_table(data, pe, [(off, expected[off]) for off, _ in run])
    if problems:
        print('\n验证失败，未写文件：', file=sys.stderr)
        for p in problems:
            print('  · %s' % p, file=sys.stderr)
        return 2

    print('\n验证通过：文件长度 %d 字节不变，改动只在 %d 个槽位内，表内 %d 项全部完好。'
          % (len(data), len(todo), sum(len(r) for _, r in tables)))

    if args.dry_run:
        print('--dry-run：未写文件。')
        return 0

    if not os.path.isfile(backup):
        shutil.copyfile(exe, backup)
        print('备份：%s' % backup)
    else:
        print('备份已存在，保留原样：%s（还原用 --restore）' % backup)
    with open(exe, 'wb') as f:
        f.write(data)
    print('已写入 %s\n  sha256 %s → %s' % (exe, sha256(before)[:16], sha256(bytes(data))[:16]))
    return 0


if __name__ == '__main__':
    sys.exit(main())
