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

为什么默认改 GlueLocalization.lua 而不是 GlueStrings.lua
  GlueXML.toc 的顺序是 GlueStrings.lua → GlueFonts.xml → GlueLocalization.xml(→ .lua)，
  且 AccountLogin.xml（创建 ServerAlertFrame 的地方）在 GlueLocalization.xml 之后。
  所以写在 GlueLocalization.lua 的赋值一定生效；
  而整份替换 GlueStrings.lua 会连带冲掉中文包里几千条界面字符串。
"""
import ctypes
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


def stamp(text):
    """在文件头插入「本文件由工具生成」的说明，避免以后被手工改乱。"""
    marker = '-- [gen_patchz] 由 overrides.json 生成'
    if marker in text:
        return text
    note = (f'{marker}\n'
            '-- [gen_patchz] 这里覆盖的是登录界面「系统公告」等由配置驱动的值。\n'
            '-- [gen_patchz] 改配置请编辑 overrides.json 后重跑 gen_patchz.py，\n'
            '-- [gen_patchz] 不要直接改这个文件（下次生成会被覆盖）。\n')
    return note + text


# ---------------------------------------------------------------------------
def main():
    cfg_path = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_CONFIG
    cfg = json.load(open(cfg_path, encoding='utf-8'))

    data_dir = cfg['clientDataDir']
    out_name = cfg['outputPatch']
    out_path = os.path.join(data_dir, out_name)
    assignments = cfg.get('luaAssignments', {})

    if not os.path.isdir(data_dir):
        raise SystemExit(f'客户端 Data 目录不存在：{data_dir}')
    if not assignments:
        raise SystemExit('配置里没有任何 luaAssignments，什么都不用做')

    patches = list_patches(data_dir)
    print(f'客户端：{data_dir}')
    print(f'补丁 {len(patches)} 个（按加载优先级）：')
    for prio, name, _ in patches:
        tag = ' <- 本工具的产物，会被跳过' if name.lower() == out_name.lower() else ''
        print(f'   {prio:>4}  {name}{tag}')

    # 解析每个目标文件的「当前生效版本」——跳过本工具的产物，避免自我叠加
    staged = []
    for arch_name, values in assignments.items():
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
        text = base.decode('utf-8', 'replace')
        new_text, actions = apply_assignments(text, values)
        for a in actions:
            print(f'   {a}')
        staged.append((arch_name, stamp(new_text).encode('utf-8')))

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
