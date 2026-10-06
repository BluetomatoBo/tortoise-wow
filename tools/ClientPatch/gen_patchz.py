#!/usr/bin/env python3
"""按 overrides.json 生成客户端覆盖补丁 patch-Z.mpq。

为什么需要它
  客户端只加载 `patch.MPQ` 与 `patch-?.MPQ`（单字符），字母顺序里 Z 最后，
  所以 patch-Z 是唯一能盖过其它补丁（尤其汉化包）的槽位。
  汉化包已从 patch-Z.mpq 改名为 patch-X.mpq，把 Z 让了出来。

它做什么
  1. 从 overrides.json 读「文件 → 一组 Lua 全局赋值」
  2. 对每个目标文件，先解析出**当前生效的那一份**
     （所有补丁里优先级最高的一份，但排除本工具自己的产物，避免自我叠加）
  3. 按需替换/追加 `KEY = "value"` 行
  4. 把结果写进 patch-Z.mpq

为什么目标通常是 GlueStrings.lua
  SERVER_ALERT_URL 这类键必须写在 GlueStrings.lua 里：它由客户端 C++ 直接加载，
  而 GlueLocalization.lua 要等 GlueLocalization.xml 的 <Script> 才执行，太晚 -
  实测只写 GlueLocalization.lua 时客户端仍用汉化包里的旧值，公告面板空白。
  暴雪原版、乌龟服的 patch-3/4/6/7/8/9、以及中文汉化包都把这几个键放在 GlueStrings.lua。

  代价是 patch-Z 要整份容纳 GlueStrings.lua（补丁按文件整体覆盖）。
  本工具读「当前生效的那一份」并按需只改目标行，所以除被覆盖的行外内容逐字不变，
  界面字符串不会丢；每次运行都会把差异打印出来。

  注意：汉化包更新后要重跑本工具，否则 patch-Z 里的旧快照会盖住新版。
"""
import ctypes
import difflib
import glob
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_CONFIG = os.path.join(HERE, 'overrides.json')

# ---------------------------------------------------------------------------
# MPQ 读写（StormLib）
# ---------------------------------------------------------------------------
STORM_CANDIDATES = (
    '/opt/homebrew/lib/libstorm.dylib',
    '/usr/local/lib/libstorm.dylib',
    'libstorm.dylib',
    'libStorm.so',
    'StormLib.dll',
)


def load_storm():
    last = None
    for cand in STORM_CANDIDATES:
        try:
            return ctypes.CDLL(cand)
        except OSError as exc:                     # 换下一个候选路径
            last = exc
    raise SystemExit(f'找不到 StormLib（试过 {STORM_CANDIDATES}）：{last}')


_lib = load_storm()
_lib.SFileOpenArchive.argtypes = [ctypes.c_char_p, ctypes.c_uint32, ctypes.c_uint32,
                                  ctypes.POINTER(ctypes.c_void_p)]
_lib.SFileOpenArchive.restype = ctypes.c_bool
_lib.SFileCloseArchive.argtypes = [ctypes.c_void_p]
_lib.SFileHasFile.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
_lib.SFileHasFile.restype = ctypes.c_bool
_lib.SFileOpenFileEx.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_uint32,
                                 ctypes.POINTER(ctypes.c_void_p)]
_lib.SFileOpenFileEx.restype = ctypes.c_bool
_lib.SFileGetFileSize.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint32)]
_lib.SFileGetFileSize.restype = ctypes.c_uint32
_lib.SFileReadFile.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint32,
                               ctypes.POINTER(ctypes.c_uint32), ctypes.c_void_p]
_lib.SFileReadFile.restype = ctypes.c_bool
_lib.SFileCloseFile.argtypes = [ctypes.c_void_p]
_lib.SFileCreateArchive.argtypes = [ctypes.c_char_p, ctypes.c_uint32, ctypes.c_uint32,
                                    ctypes.POINTER(ctypes.c_void_p)]
_lib.SFileCreateArchive.restype = ctypes.c_bool
_lib.SFileAddFileEx.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_char_p,
                                ctypes.c_uint32, ctypes.c_uint32, ctypes.c_uint32]
_lib.SFileAddFileEx.restype = ctypes.c_bool
_lib.SFileFlushArchive.argtypes = [ctypes.c_void_p]

MPQ_OPEN_READ_ONLY = 0x00000100
MPQ_CREATE_LISTFILE = 0x00100000
MPQ_COMPRESSION_ZLIB = 0x02

MAX_PATH = 1024


class _FIND(ctypes.Structure):
    _fields_ = [('cFileName', ctypes.c_char * MAX_PATH), ('szPlainName', ctypes.c_char * 256),
                ('dwHashIndex', ctypes.c_uint32), ('dwBlockIndex', ctypes.c_uint32),
                ('dwFileSize', ctypes.c_uint32), ('dwCompSize', ctypes.c_uint32),
                ('dwFileTimeLo', ctypes.c_uint32), ('dwFileTimeHi', ctypes.c_uint32),
                ('lcLocale', ctypes.c_uint32)]


_lib.SFileFindFirstFile.argtypes = [ctypes.c_void_p, ctypes.c_char_p,
                                    ctypes.POINTER(_FIND), ctypes.c_char_p]
_lib.SFileFindFirstFile.restype = ctypes.c_void_p
_lib.SFileFindNextFile.argtypes = [ctypes.c_void_p, ctypes.POINTER(_FIND)]
_lib.SFileFindNextFile.restype = ctypes.c_bool
_lib.SFileFindClose.argtypes = [ctypes.c_void_p]


class Archive:
    def __init__(self, path):
        self.path = path
        self.h = ctypes.c_void_p()
        if not _lib.SFileOpenArchive(path.encode(), 0, MPQ_OPEN_READ_ONLY, ctypes.byref(self.h)):
            raise OSError(f'打不开 {path}')

    def read(self, name):
        if not _lib.SFileHasFile(self.h, name.encode()):
            return None
        hf = ctypes.c_void_p()
        if not _lib.SFileOpenFileEx(self.h, name.encode(), 0, ctypes.byref(hf)):
            return None
        try:
            hi = ctypes.c_uint32()
            size = _lib.SFileGetFileSize(hf, ctypes.byref(hi))
            if size == 0xFFFFFFFF or size == 0:
                return b''
            buf = ctypes.create_string_buffer(size)
            got = ctypes.c_uint32()
            if not _lib.SFileReadFile(hf, buf, size, ctypes.byref(got), None):
                return None
            return buf.raw[:got.value]
        finally:
            _lib.SFileCloseFile(hf)

    def close(self):
        if self.h:
            _lib.SFileCloseArchive(self.h)
            self.h = None


def archive_priority(name):
    """补丁加载优先级。数字越大越后加载（越优先）。

    客户端加载 `patch.MPQ` 与 `patch-?.MPQ`（单字符）：先数字 2-9，再字母 A-Z。
    """
    n = name.lower()
    if n == 'patch.mpq':
        return 100
    m = re.fullmatch(r'patch-(.)\.mpq', n)
    if not m:
        return 0
    c = m.group(1)
    if c.isdigit():
        return 200 + int(c)
    if c.isalpha():
        return 300 + (ord(c) - ord('a'))
    return 0


def list_patches(data_dir):
    """列出 data 目录下的补丁，按加载优先级升序。"""
    out = []
    for path in glob.glob(os.path.join(data_dir, '*')):
        base = os.path.basename(path)
        if not base.lower().startswith('patch') or not base.lower().endswith('.mpq'):
            continue
        out.append((archive_priority(base), base, path))
    return sorted(out)


# ---------------------------------------------------------------------------
# Lua 赋值替换
# ---------------------------------------------------------------------------
def lua_string(value):
    """把 Python 字符串转成 Lua 字符串字面量。"""
    escaped = (value.replace('\\', '\\\\').replace('"', '\\"')
                    .replace('\n', '\\n').replace('\r', '\\r'))
    return f'"{escaped}"'


def apply_assignments(text, values):
    """把 `KEY = "..."` 写进 Lua 源码：已有该键就替换那一行，否则追加。

    返回 (新文本, [动作说明])。保留原文件的行尾风格。
    """
    eol = '\r\n' if '\r\n' in text else '\n'
    lines = text.split(eol)
    actions = []
    for key, value in values.items():
        assignment = f'{key} = {lua_string(value)}'
        # 只匹配「行首就是 KEY」的赋值；KEY 可能在 Lua 里是全局，也可能在函数体里缩进
        pattern = re.compile(r'^(\s*)' + re.escape(key) + r'\s*=\s*.*?;?\s*$')
        hit = None
        for i, line in enumerate(lines):
            if pattern.match(line):
                hit = i
        if hit is None:
            lines.append(assignment)
            actions.append(f'{key} 追加')
        else:
            indent = pattern.match(lines[hit]).group(1)
            lines[hit] = f'{indent}{assignment};'
            actions.append(f'{key} 替换（第 {hit + 1} 行）')
    body = eol.join(lines)
    if not body.endswith(eol):
        body += eol
    return body, actions


# ---------------------------------------------------------------------------
# XML：删掉具名框架
# ---------------------------------------------------------------------------
# 界面上的按钮是**链式锚定**的：后一个 relativeTo 前一个。所以"只删不补"会在原位
# 留一个空档。做法分两遍：先整块删掉，再把「锚向被删框架」的引用改嫁到它的前一个
# （前一个也被删就继续往前追）。链上每个框架只被它的下一个引用，所以改嫁就够了。
FRAME_TAGS = ('Frame', 'Button', 'CheckButton', 'SimpleHTML', 'ScrollFrame', 'Slider',
              'EditBox', 'StatusBar', 'MessageFrame', 'ColorSelect', 'Cooldown', 'Model',
              'PlayerModel', 'DressUpModel', 'Minimap', 'GameTooltip')
FRAME_OPEN_RE = re.compile(r'<(%s)\b[^>]*?\bname="([A-Za-z0-9_]+)"' % '|'.join(FRAME_TAGS))


def iter_frames(text):
    """逐个产出 (name, tag, 起点, 终点, 块内容)，按出现顺序。"""
    for m in FRAME_OPEN_RE.finditer(text):
        tag, name = m.group(1), m.group(2)
        open_re = re.compile(r'<%s\b' % tag)
        close_re = re.compile(r'</%s>' % tag)
        depth, i = 1, m.end()
        while depth:
            o = open_re.search(text, i)
            c = close_re.search(text, i)
            if not c:
                break
            if o and o.start() < c.start():
                depth += 1
                i = o.end()
            else:
                depth -= 1
                i = c.end()
        if depth:
            continue                      # 闭合标签找不到，跳过这个
        yield (name, tag, m.start(), i, text[m.start():i])


def find_frame(text, name):
    """定位一个具名框架的完整块，返回 (起点, 终点, 它锚定的对象或 None)。"""
    for fname, _tag, start, end, block in iter_frames(text):
        if fname != name:
            continue
        rel = re.search(r'relativeTo="([A-Za-z0-9_]+)"', block)
        return (start, end, rel.group(1) if rel else None)
    return None


def remove_frames(text, names):
    """删掉这些具名框架并把锚定引用改嫁，返回 (新文本, [动作说明])。"""
    actions = []
    blocks = []
    for name in names:
        found = find_frame(text, name)
        if not found:
            actions.append(f'{name} 在这个文件里找不到（跳过 —— 也许已经删掉了）')
            continue
        blocks.append((name, found[2], found[0], found[1]))
    if not blocks:
        return text, actions

    prev_of = {name: rel for name, rel, _s, _e in blocks}
    doomed = set(prev_of)

    def resolve(prev):
        seen = set()
        while prev in doomed and prev not in seen:
            seen.add(prev)
            prev = prev_of.get(prev)
        return prev

    # 先删（从后往前，前面的偏移才不受影响），再按名字改嫁引用
    for name, _rel, start, end in sorted(blocks, key=lambda b: -b[2]):
        text = text[:start] + text[end:]
        actions.append(f'{name} 已删除')

    for name in sorted(doomed):
        target = resolve(name)
        if target:
            text, n = re.subn(r'relativeTo="%s"' % re.escape(name),
                              'relativeTo="%s"' % target, text)
            if n:
                actions.append(f'  {n} 处锚定从 {name} 改嫁到 {target}')
        else:
            text, n = re.subn(r'\s*relativeTo="%s"' % re.escape(name), '', text)
            if n:
                actions.append(f'  {n} 处锚定去掉了 relativeTo="{name}"（回落到父框架）')
    return text, actions


def changed_line_count(before, after):
    """两个版本相差几行。

    一个补丁文件可能整份携带（GlobalStrings.lua 有 5900 行），把「实际改了哪几行」
    说清楚，是唯一能让「其余部分与基准逐字节相同」这个保证看得见的方式。
    """
    n = 0
    for line in difflib.unified_diff(before.splitlines(), after.splitlines(),
                                     n=0, lineterm=''):
        if line.startswith(('+++', '---', '@@')):
            continue
        if line[:1] in ('+', '-'):
            n += 1
    return n


# ---------------------------------------------------------------------------
# Lua：整段文本替换
# ---------------------------------------------------------------------------
def apply_rewrites(text, edits):
    """按配置做逐字替换，返回 (新文本, [动作说明])。

    给「不是 KEY = "值" 的改动」用 —— 修客户端的逻辑 bug 时，要改的是表达式，
    luaAssignments 那种按赋值行匹配的写法够不着。

    找不到要找的文本时**直接失败**，不静默跳过：这类改动是为了修一个具体问题，
    悄悄不生效等于补丁看着装了、毛病还在。真遇到上游自己修好了（文本不存在了），
    把 overrides.json 里对应那一条删掉即可 —— 报错信息里会说明。
    """
    actions = []
    for i, edit in enumerate(edits):
        find = edit['find']
        repl = edit['replace']
        where = edit.get('why') or f'第 {i + 1} 条'
        n = text.count(find)
        if n == 0:
            raise SystemExit(
                f'找不到要替换的文本（{where}）：\n\n{find}\n\n'
                '上游可能已经自己修好了 —— 那就把 overrides.json 里这一条删掉；\n'
                '否则说明它改成了别的写法，需要重新对一下。')
        text = text.replace(find, repl)
        actions.append(f'{where} —— 替换 {n} 处')
    return text, actions


def stamp(text, name=''):
    """在文件头插入「本文件由工具生成」的说明，避免以后被手工改乱。

    Lua 与 XML 的注释语法不同，按扩展名选。
    """
    if name.lower().endswith('.xml'):
        marker = '<!-- [gen_patchz] 由 overrides.json 生成'
        if marker in text:
            return text
        note = (f'{marker} -->\n'
                '<!-- [gen_patchz] 这里删掉了配置里点名的界面框架。 -->\n'
                '<!-- [gen_patchz] 改配置请编辑 overrides.json 后重跑 gen_patchz.py， -->\n'
                '<!-- [gen_patchz] 不要直接改这个文件（下次生成会被覆盖）。 -->\n')
        return note + text
    marker = '-- [gen_patchz] 由 overrides.json 生成'
    if marker in text:
        return text
    note = (f'{marker}\n'
            '-- [gen_patchz] 这里覆盖的是界面上的字符串（登录界面「系统公告」、\n'
            '-- [gen_patchz] 商城窗口标题与「关于」正文等由配置驱动的值）。\n'
            '-- [gen_patchz] 改配置请编辑 overrides.json 后重跑 gen_patchz.py，\n'
            '-- [gen_patchz] 不要直接改这个文件（下次生成会被覆盖）。\n')
    return note + text


# ---------------------------------------------------------------------------
# 客户端能打开什么样的地址
# ---------------------------------------------------------------------------
# 除 SERVER_ALERT_URL（客户端自己抓取，比较宽松）以外，这些键的值都会被
# Lua 的 LaunchURL 打开。它先校验整条地址再交给系统，不合格就**静默什么都不做**
# —— 界面上看起来是个能点的链接，点下去毫无反应。
#
# 规则是从 WoW.exe 里反汇编出来的（0x5abc10）：跳过 "http://" 之后逐字符检查，
# 只允许字母、数字、'.'、'-'、'/'。所以：
#   · https:// 会被拒（第 5 个字符就对不上）
#   · 任何冒号都会被拒 —— **带端口的地址整条作废**，包括 172.18.1.6:8080
#   · 下划线、问号、# 同样被拒
# 通过之后才取主机名比对内置白名单（用 patch_urllist.py 加自己的域名）。
LAUNCH_URL_RE = re.compile(r'^http://[A-Za-z0-9][A-Za-z0-9./-]*$')

# 会被 LaunchURL 打开的键。SERVER_ALERT_URL 故意不在其中：客户端用另一条
# HTTP 路径抓它，可以带端口，实测 http://172.18.1.6:8080/alert 是好的。
LAUNCH_URL_KEYS = frozenset({
    # exe 按返回码读的那 5 个（世界服登录失败对话框）
    'AUTH_BANNED_URL', 'AUTH_DB_BUSY_URL', 'AUTH_NO_TIME_URL',
    'AUTH_PARENTAL_CONTROL_URL', 'AUTH_SUSPENDED_URL',
    # 界面 Lua 直接调 LaunchURL 的那些（登录界面 / 角色选择界面的按钮）。
    # 权威来源是 verify_client.py 的扫描，这里只是给生成器一个静态清单。
    'ACCOUNT_CREATE_URL', 'AUTH_TURTLE_WEBSITE', 'COMMUNITY_URL', 'TECH_SUPPORT_URL',
    'TURTLE_ARMORY_WEBSITE', 'TURTLE_COMMUNITY_FORUM_WEBSITE', 'TURTLE_DISCORD_WEBSITE',
    'TURTLE_KNOWLEDGE_DATABASE_WEBSITE', 'TURTLE_REDDIT_WEBSITE',
})


def launch_url_problem(value):
    """地址不符合 LaunchURL 规则时返回原因，没问题返回 None。"""
    if not value.startswith('http://'):
        why = 'https:// 会被客户端拒绝' if value.startswith('https://') else '客户端只认 http://'
        return f'必须以 http:// 开头（{why}）'
    rest = value[len('http://'):]
    bad = sorted({c for c in rest if not re.match(r'[A-Za-z0-9./-]', c)})
    if bad:
        shown = '、'.join(repr(c) for c in bad)
        if ':' in bad:
            return f'不能包含 {shown} —— 带端口的地址会被整条拒绝（冒号只允许出现在 http:// 里）'
        return f'不能包含 {shown}：只允许字母、数字、点、连字符和斜杠'
    return None


# ---------------------------------------------------------------------------
def main():
    cfg_path = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_CONFIG
    cfg = json.load(open(cfg_path, encoding='utf-8'))

    data_dir = cfg['clientDataDir']
    out_name = cfg['outputPatch']
    out_path = os.path.join(data_dir, out_name)
    assignments = cfg.get('luaAssignments', {})
    rewrites = cfg.get('luaRewrites', {})
    frame_edits = cfg.get('frameEdits', {})

    if not os.path.isdir(data_dir):
        raise SystemExit(f'客户端 Data 目录不存在：{data_dir}')
    if not assignments and not rewrites and not frame_edits:
        raise SystemExit('配置里 luaAssignments / luaRewrites / frameEdits 都没有，'
                         '什么都不用做')

    # 先拦住客户端打不开的地址：这类错误没有任何反馈，客户端只是点了不动。
    # 宁可让生成失败，也不要产出一个装上去才发现点了没反应的补丁。
    problems = []
    for arch_name, values in assignments.items():
        for key, value in values.items():
            if key not in LAUNCH_URL_KEYS:
                continue
            why = launch_url_problem(value)
            if why:
                problems.append(f'{key} = {value}\n      {why}')
    if problems:
        raise SystemExit('这些地址客户端打不开，请改 overrides.json：\n\n  '
                         + '\n  '.join(problems)
                         + '\n\n  规则见 README 的「客户端能打开什么样的地址」。')

    patches = list_patches(data_dir)
    print(f'客户端：{data_dir}')
    print(f'补丁 {len(patches)} 个（按加载优先级）：')
    for prio, name, _ in patches:
        tag = ' <- 本工具的产物，会被跳过' if name.lower() == out_name.lower() else ''
        print(f'   {prio:>4}  {name}{tag}')

    # 解析每个目标文件的「当前生效版本」——跳过本工具的产物，避免自我叠加
    targets = list(assignments)
    targets += [n for n in rewrites if n not in assignments]
    targets += [n for n in frame_edits if n not in assignments and n not in rewrites]
    staged = []
    for arch_name in targets:
        base = None
        source = None
        for prio, name, path in reversed(patches):          # 从最高优先级往下找
            if name.lower() == out_name.lower():
                continue
            try:
                ar = Archive(path)
            except OSError:
                continue
            try:
                data = ar.read(arch_name)
            finally:
                ar.close()
            if data is not None:
                base, source = data, name
                break
        if base is None:
            print(f'\n{arch_name}: 所有补丁里都没有这个文件 —— 按新建处理')
            base, source = b'', '(新建)'
        else:
            print(f'\n{arch_name}\n   基准来自：{source}（{len(base)} 字节）')
        base_text = base.decode('utf-8', 'replace')
        new_text = base_text

        if arch_name in assignments:
            new_text, actions = apply_assignments(new_text, assignments[arch_name])
            for a in actions:
                print(f'   {a}')

        if arch_name in rewrites:
            new_text, actions = apply_rewrites(new_text, rewrites[arch_name])
            for a in actions:
                print(f'   {a}')

        if arch_name in frame_edits:
            spec = frame_edits[arch_name] or {}
            names = spec.get('remove', []) if isinstance(spec, dict) else list(spec)
            new_text, actions = remove_frames(new_text, names)
            for a in actions:
                print(f'   {a}')

        # 统计放在加戳之前：戳记是工具自己加的 4 行，不该算进「改了什么」。
        n_changed = changed_line_count(base_text, new_text)
        total = len(base_text.splitlines())
        print(f'   与基准相比：{n_changed} 行不同（共 {total} 行）')
        if base and n_changed == 0:
            print('   ↑ 逐字节相同 —— 这个文件的值与基准当前完全一致，'
                  '装上去不会有任何变化。')

        staged.append((arch_name, stamp(new_text, arch_name).encode('utf-8')))

    # 写出补丁
    if os.path.exists(out_path):
        os.remove(out_path)
    h = ctypes.c_void_p()
    if not _lib.SFileCreateArchive(out_path.encode(), MPQ_CREATE_LISTFILE,
                                   len(staged) + 4, ctypes.byref(h)):
        raise SystemExit(f'创建 {out_path} 失败')
    ok = 0
    for arch_name, data in staged:
        tmp = os.path.join('/tmp', '_gen_patchz.tmp')
        open(tmp, 'wb').write(data)
        if _lib.SFileAddFileEx(h, tmp.encode(), arch_name.encode(), 0,
                               MPQ_COMPRESSION_ZLIB, 0):
            ok += 1
            print(f'\n写入 {arch_name}（{len(data)} 字节）')
        else:
            print(f'\n!! 写入失败 {arch_name}')
        os.remove(tmp)
    _lib.SFileFlushArchive(h)
    _lib.SFileCloseArchive(h)
    print(f'\n{out_path} 已生成：{ok}/{len(staged)} 个文件，'
          f'{os.path.getsize(out_path)} 字节')
    return 0 if ok == len(staged) else 1


if __name__ == '__main__':
    sys.exit(main())
