#!/usr/bin/env python3
"""Build the id -> name tables the pages use to label raw numbers.

The database stores ids where the player expects a name: a quest has a
`ZoneOrSort`, a creature a `faction`, an item a class/subclass pair and sometimes
a `set_id`. The names behind those ids live in the client's DBC files, which the
server never loads. This reads them out of the client - the same verified way
gen_icons.py does - and writes them into `internal/web/dbcnames.txt`.

The client's DBCs carry all their locales in one record, so both languages come
from the same file and the site can pick per request. In this client the English
name sits at `field`, and the Chinese name is exactly four fields later; each
table below was checked against an independently parsed copy of the same DBCs and
agreed row for row.

Usage:

    python3 tools/WowWeb/gen_dbc_names.py
    python3 tools/WowWeb/gen_dbc_names.py --out /tmp/names.txt   # somewhere else

Needs no arguments and no client installation: the files come from the CDN the
manifest in tools/dbc_verification/ names, each one checked against its sha256.
"""

import argparse
import os
import sys

from clientfiles import Client, read_dbc

HERE = os.path.dirname(os.path.abspath(__file__))
MANIFEST = os.path.normpath(os.path.join(HERE, "..", "dbc_verification", "manifest_formatted.json"))
DEFAULT_OUT = os.path.join(HERE, "internal", "web", "dbcnames.txt")

# Each table: the DBC, the field holding the English name, and how to key a row.
#
#   "id"     key on field 0 (the DBC's own id)
#   "pair"   key on fields 0 and 1, which for ItemSubClass are the class and the
#            subclass an item stores - its own id column is not unique across them
#
# The Chinese name is taken from `field + 4` in every one of these: the client
# keeps eight locale slots in a row and zhCN is the fifth.
TABLES = [
    ("AREA", "AreaTable", 11, "id"),
    ("FACTION", "Faction", 19, "id"),
    ("MAP", "Map", 4, "id"),
    ("QSORT", "QuestSort", 1, "id"),
    ("SUBCLASS", "ItemSubClass", 10, "pair"),
    ("ITEMSET", "ItemSet", 1, "id"),
]

ZH_OFFSET = 4

# ItemSet.dbc: the set's name and then three parallel field blocks - 17 item
# slots, 8 bonus spells and the 8 piece counts that switch each bonus on.
ITEM_SLOTS = range(10, 27)
BONUS_SPELLS = range(27, 35)
BONUS_THRESHOLDS = range(35, 43)
MAX_KEY = 4294967295


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--manifest", default=MANIFEST, help="the client's file list with hashes")
    ap.add_argument("--cache", default=os.path.join(os.path.expanduser("~"), ".cache", "tw-icons"),
                    help="where downloaded client files are kept between runs")
    ap.add_argument("--out", default=DEFAULT_OUT, help="where to write the tables")
    args = ap.parse_args()

    client = Client(args.manifest, args.cache)

    lines = []
    item_lines = bonus_lines = 0
    for marker, dbc, field, keying in TABLES:
        local = client.fetched("DBFilesClient/%s.dbc" % dbc)
        if local is None:
            sys.exit("the manifest has no %s.dbc" % dbc)
        rows, string = read_dbc(local)

        seen = set()
        written = 0
        with_zh = 0
        for row in rows:
            if field + ZH_OFFSET >= len(row):
                continue
            english = string(row[field]).strip()
            if not english:
                continue
            chinese = string(row[field + ZH_OFFSET]).strip()
            if keying == "pair":
                keys = [str(row[0]), str(row[1])]
            else:
                keys = [str(row[0])]
            # The sentinel row some DBCs end on (0xFFFFFFFF everywhere) has no
            # name worth carrying.
            if all(k == str(MAX_KEY) for k in keys):
                continue
            pair = tuple(keys)
            if pair in seen:
                sys.exit("%s has two rows keyed %s" % (dbc, pair))
            seen.add(pair)
            if chinese:
                with_zh += 1
            lines.append("\t".join([marker] + keys + [english, chinese]))
            written += 1

        print("%-10s %-14s %4d 行 → 写入 %4d 条（%d 条有中文名）"
              % (marker, dbc, len(rows), written, with_zh))

        if dbc == "ItemSet":
            # A set also says what is in it and what it grants, and an item page
            # wants both: the names alone leave "套装 #1" as unhelpful as the id.
            for row in rows:
                if row[0] == MAX_KEY:
                    continue
                for slot in ITEM_SLOTS:
                    item = row[slot] if slot < len(row) else 0
                    if item:
                        lines.append("\t".join(["SETITEM", str(row[0]), str(item)]))
                        item_lines += 1
                for index, slot in enumerate(BONUS_SPELLS):
                    spell = row[slot] if slot < len(row) else 0
                    threshold = row[BONUS_THRESHOLDS[index]] if BONUS_THRESHOLDS[index] < len(row) else 0
                    if spell and threshold:
                        lines.append("\t".join(["SETBONUS", str(row[0]),
                                                 str(threshold), str(spell)]))
                        bonus_lines += 1
            print("%-10s 其中 %d 条部件、%d 条奖励" % ("", item_lines, bonus_lines))

    with open(args.out, "w", encoding="utf-8") as f:
        f.write("# id -> name, generated by tools/WowWeb/gen_dbc_names.py\n")
        f.write("# from the client's own DBCs; the Chinese name is the client's zhCN slot\n")
        f.write("# AREA/FACTION/MAP/QSORT/ITEMSET: <kind> <id> <en> <zh>\n")
        f.write("# SUBCLASS: <kind> <class> <subclass> <en> <zh>\n")
        f.write("# SETITEM: <kind> <set> <item>   SETBONUS: <kind> <set> <pieces> <spell>\n")
        f.write("\n".join(lines) + "\n")

    print("\n写出 %s（%.1f KB，%d 条）" % (args.out, os.path.getsize(args.out) / 1024, len(lines)))


if __name__ == "__main__":
    main()
