#!/usr/bin/env python3
"""Reading files out of the client's own installation.

`tools/dbc_verification/manifest_formatted.json` records the client's file list
with a sha256 and a CDN mirror per file, which is what makes it possible to read
the client's DBCs - and a few of its icons - without having a client installed.
Only the files that list names are here; everything icon-shaped lives in
gen_icons.py.

Used by gen_icons.py and gen_dbc_names.py.
"""

import hashlib
import json
import os
import re
import struct
import subprocess
import sys
import urllib.request

class Client:
    """The client files the manifest describes, cached and hash-checked.

    A path is looked up the way the client itself resolves one: case does not
    matter and either separator does. The manifest writes `Interface/Icons/x.blp`
    while the client's own code and its MPQs write `Interface\\Icons\\x.blp`, and
    a generator that asks with the other one has to be answered, not quietly told
    the file is missing.
    """

    def __init__(self, manifest_path, cache_dir, offline=False):
        self.offline = offline
        self.cache = cache_dir
        os.makedirs(cache_dir, exist_ok=True)
        self.entries = {}
        if not offline:
            self._collect(json.load(open(manifest_path, encoding="utf-8")))

    def _collect(self, node):
        if isinstance(node, dict):
            name = node.get("name")
            if name and node.get("type") == "file" and node.get("mirrors"):
                # The same path can be listed twice (base client and a patch);
                # the newer mtime is the one the client currently loads.
                key = client_key(name)
                old = self.entries.get(key)
                if old is None or node.get("mtime", 0) > old.get("mtime", 0):
                    self.entries[key] = node
            for value in node.values():
                self._collect(value)
        elif isinstance(node, list):
            for value in node:
                self._collect(value)

    def fetched(self, path):
        """Download one manifest entry into the cache and check its sha256.

        The hash is checked on every call, not only on the first download: a file
        left truncated by an interrupted run would otherwise be trusted forever.
        """
        entry = self.entries.get(client_key(path))
        if entry is None:
            return None
        local = os.path.join(self.cache, safe_name(client_key(path)))
        want = entry["hash"].lower()
        if os.path.exists(local) and hashlib.sha256(open(local, "rb").read()).hexdigest() == want:
            return local
        data = self._download(entry["mirrors"])
        got = hashlib.sha256(data).hexdigest()
        if got != want:
            sys.exit("sha256 mismatch for %s:\n  want %s\n  got  %s" % (path, want, got))
        with open(local, "wb") as f:
            f.write(data)
        return local

    def _download(self, mirrors):
        errors = []
        for key in ("r2", "r2eu", "tc"):
            url = mirrors.get(key)
            if not url:
                continue
            try:
                return http_get(url)
            except Exception as exc:  # noqa: BLE001 - collected and reported
                errors.append("%s: %s" % (key, exc))
        sys.exit("every mirror failed for one file:\n  " + "\n  ".join(errors))

def http_get(url):
    """Fetch a URL, falling back to curl.

    urllib is tried first because it needs nothing installed; on a Python built
    without a CA bundle (the python.org installer on macOS is one) it fails with a
    certificate error, and curl usually has a system trust store to fall back on.
    """
    try:
        with urllib.request.urlopen(url, timeout=120) as response:
            return response.read()
    except Exception as first:
        try:
            done = subprocess.run(["curl", "-sL", "--fail", url],
                                  capture_output=True, timeout=300)
        except (OSError, subprocess.SubprocessError):
            raise first
        if done.returncode != 0:
            raise first
        return done.stdout


# ---------------------------------------------------------------------------
# DBC
# ---------------------------------------------------------------------------

def read_dbc(path):
    """Return (rows, string). rows are tuples of uint32; string(offset) resolves
    a record field into the file's string block."""
    data = open(path, "rb").read()
    magic, records, fields, record_size, string_size = struct.unpack("<4sIIII", data[:20])
    if magic != b"WDBC":
        sys.exit("%s is not a DBC (%r)" % (path, magic))
    first, block = 20, 20 + records * record_size
    strings = data[block:block + string_size]

    def string(offset):
        if offset <= 0 or offset >= len(strings):
            return ""
        end = strings.find(b"\0", offset)
        return strings[offset:end].decode("utf-8", "replace")

    rows = [struct.unpack_from("<%dI" % fields, data, first + i * record_size)
            for i in range(records)]
    return rows, string


def safe_name(name):
    """A name that a file, an embed pattern and a URL all accept.

    Some of the client's icons have characters in their DBC name that cannot go
    in an embedded file name or in a URL - this client has an apostrophe
    (btnmur'gulstaff), an ampersand and a space. go:embed refuses to build with
    such a file, so the name is normalised to [a-z0-9_.-] before it is used as
    the file name. The name is only a key: what matters is that icondata.txt and
    the file agree. main() reports a collision rather than overwriting one icon
    with another.
    """
    return re.sub(r"[^a-z0-9_.-]", "_", name)


def client_key(path):
    """A path as the client compares it: separators and case do not matter.

    The manifest writes `Interface/WorldMap/Elwynn/Elwynn1.blp`, this tool's
    generators ask in the client's own notation
    (`Interface\\WorldMap\\Elwynn\\Elwynn1.blp`, the way WorldMapFrame.lua builds
    it), and an MPQ would accept either. Normalising to one form is what lets a
    single lookup answer all of them - the zone maps were missing from the CDN for
    as long as the two notations were compared as strings.
    """
    return path.replace("\\", "/").lower()


