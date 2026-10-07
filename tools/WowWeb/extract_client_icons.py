#!/usr/bin/env python3
"""Pull the icon BLPs the site is still missing out of a WoW client's MPQs.

Some of the icons the client's own ItemDisplayInfo.dbc and SpellIcon.dbc name do
not exist in the two public mirror sets gen_icons.py uses, because Turtle ships
them in its own patch archives. Those have to come from an installed client.

This reads the list of names gen_icons.py could not find artwork for, looks each
one up as `Interface\\Icons\\<name>.blp` across the client's `Data/*.MPQ`, and
writes what it finds into a directory that gen_icons.py takes as `--blp-dir`.

The archives are searched from the highest patch priority down, so the file that
comes out is the one the client itself would load (`patch.MPQ` and `patch-?.MPQ`
override the base archives; `ClientPatch/gen_patchz.py` documents the same rule).

Needs StormLib, the library the client patch tool already uses:

    apt install libstorm-dev          # or: brew install stormlib

Usage:

    # 1. find out what is missing (writes the list into its cache)
    python3 tools/WowWeb/gen_icons.py --dump ... --sql ...
    # 2. pull those from a client
    python3 tools/WowWeb/extract_client_icons.py --client /path/to/wow-client
    # 3. run gen_icons.py again; it picks the extracted BLPs up automatically
    python3 tools/WowWeb/gen_icons.py --dump ... --sql ...
"""

import argparse
import ctypes
import glob
import os
import re
import sys

CACHE = os.path.join(os.path.expanduser("~"), ".cache", "tw-icons")
DEFAULT_NAMES = os.path.join(CACHE, "needed-icons.txt")
DEFAULT_OUT = os.path.join(CACHE, "blps")

STORM_CANDIDATES = (
    "/opt/homebrew/lib/libstorm.dylib",
    "/usr/local/lib/libstorm.dylib",
    "libstorm.dylib",
    "libStorm.so",
    "libstorm.so",
    "StormLib.dll",
)

MPQ_OPEN_READ_ONLY = 0x00000100


def load_storm():
    last = None
    for candidate in STORM_CANDIDATES:
        try:
            return ctypes.CDLL(candidate)
        except OSError as exc:
            last = exc
    sys.exit("StormLib not found (tried %s): %s" % (", ".join(STORM_CANDIDATES), last))


lib = load_storm()
lib.SFileOpenArchive.argtypes = [ctypes.c_char_p, ctypes.c_uint32, ctypes.c_uint32,
                                 ctypes.POINTER(ctypes.c_void_p)]
lib.SFileOpenArchive.restype = ctypes.c_bool
lib.SFileCloseArchive.argtypes = [ctypes.c_void_p]
lib.SFileHasFile.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
lib.SFileHasFile.restype = ctypes.c_bool
lib.SFileOpenFileEx.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_uint32,
                                ctypes.POINTER(ctypes.c_void_p)]
lib.SFileOpenFileEx.restype = ctypes.c_bool
lib.SFileGetFileSize.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint32)]
lib.SFileGetFileSize.restype = ctypes.c_uint32
lib.SFileReadFile.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint32,
                              ctypes.POINTER(ctypes.c_uint32), ctypes.c_void_p]
lib.SFileReadFile.restype = ctypes.c_bool
lib.SFileCloseFile.argtypes = [ctypes.c_void_p]


def patch_priority(name):
    """How late the client loads an archive. Higher wins.

    `patch.MPQ` and `patch-?.MPQ`, where ? is one digit then one letter - the
    ordering the client documents and the one gen_patchz.py relies on.
    """
    lower = name.lower()
    if lower == "patch.mpq":
        return 100
    match = re.fullmatch(r"patch-(.)\.mpq", lower)
    if not match:
        return 0
    char = match.group(1)
    if char.isdigit():
        return 10 + int(char)
    return 40 + ord(char) - ord("a")


class Archive:
    def __init__(self, path):
        self.path = path
        self.handle = ctypes.c_void_p()
        if not lib.SFileOpenArchive(path.encode(), 0, MPQ_OPEN_READ_ONLY,
                                    ctypes.byref(self.handle)):
            raise OSError("cannot open %s" % path)

    def read(self, name):
        if not lib.SFileHasFile(self.handle, name.encode()):
            return None
        handle = ctypes.c_void_p()
        if not lib.SFileOpenFileEx(self.handle, name.encode(), 0, ctypes.byref(handle)):
            return None
        try:
            high = ctypes.c_uint32()
            size = lib.SFileGetFileSize(handle, ctypes.byref(high))
            if size in (0, 0xFFFFFFFF):
                return b""
            buffer = ctypes.create_string_buffer(size)
            got = ctypes.c_uint32()
            if not lib.SFileReadFile(handle, buffer, size, ctypes.byref(got), None):
                return None
            return buffer.raw[:got.value]
        finally:
            lib.SFileCloseFile(handle)

    def close(self):
        if self.handle:
            lib.SFileCloseArchive(self.handle)
            self.handle = None


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--client", required=True,
                    help="the client's root directory (the one holding Data/)")
    ap.add_argument("--names", default=DEFAULT_NAMES,
                    help="one icon name per line (default: the list gen_icons.py wrote)")
    ap.add_argument("--out", default=DEFAULT_OUT,
                    help="where the .blp files go (default: the shared cache)")
    ap.add_argument("--force", action="store_true",
                    help="re-read names whose .blp is already there")
    args = ap.parse_args()

    if not os.path.isdir(args.client):
        sys.exit("no such client directory: %s" % args.client)
    if not os.path.isfile(args.names):
        sys.exit("no name list at %s - run gen_icons.py first, or pass --names" % args.names)

    names = [line.strip().lower() for line in open(args.names, encoding="utf-8")
             if line.strip() and not line.startswith("#")]
    if not names:
        sys.exit("the name list is empty: nothing to extract")

    data_dir = None
    for candidate in ("Data", "data"):
        if os.path.isdir(os.path.join(args.client, candidate)):
            data_dir = os.path.join(args.client, candidate)
            break
    if data_dir is None:
        sys.exit("no Data directory below %s" % args.client)

    archives = []
    for path in sorted(glob.glob(os.path.join(data_dir, "*"))):
        if not path.lower().endswith(".mpq"):
            continue
        try:
            archives.append(Archive(path))
        except OSError as exc:
            print("跳过 %s（%s）" % (os.path.basename(path), exc))
    if not archives:
        sys.exit("no readable MPQ archives in %s" % data_dir)
    # Highest priority first, so the first hit is the file the client loads.
    archives.sort(key=lambda a: patch_priority(os.path.basename(a.path)), reverse=True)
    print("打开 %d 个 MPQ（按补丁优先级降序），需要 %d 个图标" % (len(archives), len(names)))

    os.makedirs(args.out, exist_ok=True)
    found, skipped, missing = 0, 0, []
    for name in names:
        dest = os.path.join(args.out, name + ".blp")
        if os.path.exists(dest) and not args.force:
            skipped += 1
            continue
        data = None
        for archive in archives:
            data = archive.read("Interface\\Icons\\%s.blp" % name)
            if data:
                break
        if not data:
            missing.append(name)
            continue
        with open(dest, "wb") as f:
            f.write(data)
        found += 1
    for archive in archives:
        archive.close()

    print("写出 %d 个（跳过已存在 %d 个），客户端里没有 %d 个" % (found, skipped, len(missing)))
    if missing:
        print("  没有的样例: %s" % ", ".join(missing[:8]))
        print("  （这些是 DBC 里登记、但客户端本身没有的图：那些 id 不会画图标）")
    print("\n下一步：重跑 gen_icons.py，它会自动用上 %s" % args.out)


if __name__ == "__main__":
    main()
