#!/usr/bin/env python3
"""Pull the client files the site is still missing out of a WoW client's MPQs.

Some of the icons the client's own ItemDisplayInfo.dbc and SpellIcon.dbc name do
not exist in the two public mirror sets gen_icons.py uses, because Turtle ships
them in its own patch archives. Those have to come from an installed client.

Each generator writes the list of files it could not find on the CDN into the
shared cache as `needed-*.txt`; this reads those lists, looks each entry up across
the client's `Data/*.MPQ`, and writes what it finds into a directory the
generators take as their input.

A line in those lists is one of two things:

  * a bare icon name (`inv_sword_39`), looked up as `Interface\\Icons\\<name>.blp`
    and written as `<name>.blp` - that is what gen_icons.py expects
  * a full client path (`Interface\\WorldMap\\Elwynn\\Elwynn1.blp`), looked up as
    written and saved with the separators flattened, which is what gen_maps.py
    expects

The archives are searched from the highest patch priority down, so the file that
comes out is the one the client itself would load (`patch.MPQ` and `patch-?.MPQ`
override the base archives; `ClientPatch/gen_patchz.py` documents the same rule).

Needs StormLib, the library the client patch tool already uses:

    apt install libstorm-dev          # or: brew install stormlib

Usage:

    # gen_maps.py can also read a client directly, which is what decides the map
    # labels' language; this tool is the offline/step-by-step route.
    python3 tools/WowWeb/gen_maps.py --client /path/to/wow-client

    # 1. find out what is missing (each generator writes its own list)
    python3 tools/WowWeb/gen_icons.py --dump ... --sql ...
    python3 tools/WowWeb/gen_maps.py
    # 2. pull all of it out of a client
    python3 tools/WowWeb/extract_client_files.py --client /path/to/wow-client
    # 3. run the generators again; they pick up what was extracted
    python3 tools/WowWeb/gen_icons.py --dump ... --sql ...
    python3 tools/WowWeb/gen_maps.py
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


def client_path(line):
    """A list entry as a client path. A bare name is an icon; anything with a
    separator is already a path."""
    if "\\" in line or "/" in line:
        return line.replace("/", "\\")
    return "Interface\\Icons\\%s.blp" % line


def output_file(path):
    """Where an extracted file goes.

    Icons keep their plain name, lowercased, because gen_icons.py looks them up by
    it. Everything else is flattened to one name with the separators as
    underscores, so two files that share a base name in different directories
    cannot collide in the cache.
    """
    if path.lower().startswith("interface\\icons\\"):
        return re.sub(r"\.blp$", "", path.rsplit("\\", 1)[-1].lower()) + ".blp"
    return re.sub(r"[^a-z0-9_.-]", "_", path.replace("\\", "_").lower())


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
    ap.add_argument("--names", nargs="*", default=None,
                    help="name lists to read (default: every needed-*.txt in the cache)")
    ap.add_argument("--out", default=DEFAULT_OUT,
                    help="where the .blp files go (default: the shared cache)")
    ap.add_argument("--force", action="store_true",
                    help="re-read names whose .blp is already there")
    args = ap.parse_args()

    if not os.path.isdir(args.client):
        sys.exit("no such client directory: %s" % args.client)
    lists = args.names
    if not lists:
        lists = sorted(glob.glob(os.path.join(CACHE, "needed-*.txt")))
    lists = [p for p in lists if os.path.isfile(p)]
    if not lists:
        sys.exit("no name list found (%s) - run a generator first, or pass --names"
                 % os.path.join(CACHE, "needed-*.txt"))

    wanted = {}
    for path in lists:
        for line in open(path, encoding="utf-8"):
            line = line.strip()
            if line and not line.startswith("#"):
                wanted[client_path(line)] = None
    names = sorted(wanted)
    if not names:
        sys.exit("the name lists are empty: nothing to extract")
    print("从 %s 读到 %d 个待抽取的文件" % (", ".join(os.path.basename(p) for p in lists), len(names)))

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
    print("打开 %d 个 MPQ（按补丁优先级降序），需要 %d 个文件" % (len(archives), len(names)))

    os.makedirs(args.out, exist_ok=True)
    found, skipped, missing = 0, 0, []
    for path in names:
        dest = os.path.join(args.out, output_file(path))
        if os.path.exists(dest) and not args.force:
            skipped += 1
            continue
        data = None
        for archive in archives:
            data = archive.read(path)
            if data:
                break
        if not data:
            missing.append(path)
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
