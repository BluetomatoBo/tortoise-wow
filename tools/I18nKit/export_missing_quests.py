#!/usr/bin/env python3
"""Export the quest text that has no Chinese yet, as a translation worklist.

Why this exists
---------------
Two of the three sources a 1.12 client can offer for Chinese text do not cover
quests at all: the client's DBC files carry no quest text (it lives on the
server), and the official zhCN data only knows official content. So a Turtle
custom quest such as 41696 has no Chinese anywhere, and the client shows the
English from quest_template. This script finds the rows where the English is
there and the Chinese is not, and writes them out in a form that is easy to
translate and easy to put back.

It reads the database through the `mysql` (or `mariadb`) client, so nothing has
to be installed next to it - no Python database driver.

What it writes (into the output directory)
------------------------------------------
  quests-missing.md            readable sheet, grouped by quest chain, with the
                               English text and a blank line per column
  quests-missing.csv           the same rows for a spreadsheet
  quests-missing.template.sql  an INSERT ... ON DUPLICATE KEY UPDATE skeleton,
                               one statement per row and column, with the English
                               in a trailing comment. Replace the 'ZH' marker
                               with the translation and import the file - it only
                               touches the *_loc4 columns, and only for the rows
                               listed.

Usage
-----
  ./export_missing_quests.py --database tw_world -o out/
      uses the default mysql client and your ~/.my.cnf, or MYSQL_PWD

  ./export_missing_quests.py --database tw_world --user root --password secret
  ./export_missing_quests.py --titles-only        # just the 214 quests with no
                                                  # Chinese title at all
  ./export_missing_quests.py --mysql /usr/bin/mariadb

Every column it writes is a locale column of an existing table; nothing else in
the world database is touched.
"""

import argparse
import os
import shutil
import subprocess
import sys

# The columns worth translating, in the order a player meets them.
#
# locales_quest column | key in the result row (English) | key for the Chinese | heading
#
# Keeping the three names in one table is what stops the SQL, the sheet and the
# template from drifting apart.
COLUMNS = [
    ("Title", "title", "title_zh", "Title / 标题"),
    ("Details", "details", "details_zh", "Details / 任务详情"),
    ("Objectives", "objectives", "objectives_zh", "Objectives / 目标"),
    ("OfferRewardText", "offer_reward", "offer_reward_zh", "Completion text / 交还文本"),
    ("RequestItemsText", "request_items", "request_items_zh", "Progress text / 进行中文本"),
]

TSV_COLUMNS = [
    "entry", "quest_level", "min_level", "max_level", "zone", "method",
    "prev_quest", "next_quest", "req_races", "req_classes",
    "title", "details", "objectives", "offer_reward", "request_items",
    "title_zh", "details_zh", "objectives_zh", "offer_reward_zh", "request_items_zh",
    "givers", "turnins", "go_givers", "go_turnins",
]


# A quest counts as still obtainable when a giver for it exists in the world:
# a creature or game object with at least one spawn row. quest_template alone
# cannot answer this - a quest can be in the table with no one to hand it out.
OBTAINABLE = """(
    EXISTS (SELECT 1 FROM `creature_questrelation` r
              JOIN `creature` s ON s.`id` = r.`id`
             WHERE r.`quest` = q.`entry`)
 OR EXISTS (SELECT 1 FROM `gameobject_questrelation` r
              JOIN `gameobject` s ON s.`id` = r.`id`
             WHERE r.`quest` = q.`entry`)
  )"""


def build_sql(titles_only, obtainable_only):
    """The worklist query.

    "Missing" means: the English column has text and the corresponding *_loc4
    column does not. A column that is empty in English is not a gap - plenty of
    quests have no completion text at all, and listing those would bury the real
    work in noise.

    The quest givers and turn-in creatures come along because they are what makes
    a row recognisable: "the SI:7 chain on Balor" is easier to translate
    consistently than an entry number.
    """
    wanted = [COLUMNS[0]] if titles_only else COLUMNS
    conditions = " OR ".join(
        "(COALESCE(q.`%s`, '') <> '' AND COALESCE(l.`%s_loc4`, '') = '')" % (loc, loc)
        for loc, _en, _zh, _label in wanted
    )
    locale_select = ", ".join(
        "COALESCE(l.`%s_loc4`, '')" % loc for loc, _en, _zh, _label in COLUMNS
    )
    if obtainable_only:
        conditions = "(%s) AND %s" % (conditions, OBTAINABLE)
    return """
SELECT
  q.`entry`, COALESCE(q.`QuestLevel`, 0), COALESCE(q.`MinLevel`, 0), COALESCE(q.`MaxLevel`, 0),
  COALESCE(q.`ZoneOrSort`, 0), COALESCE(q.`Method`, 0),
  COALESCE(q.`PrevQuestId`, 0), COALESCE(q.`NextQuestId`, 0),
  COALESCE(q.`RequiredRaces`, 0), COALESCE(q.`RequiredClasses`, 0),
  COALESCE(q.`Title`, ''), COALESCE(q.`Details`, ''), COALESCE(q.`Objectives`, ''),
  COALESCE(q.`OfferRewardText`, ''), COALESCE(q.`RequestItemsText`, ''),
  %s,
  COALESCE((SELECT GROUP_CONCAT(c.`name` ORDER BY c.`name` SEPARATOR '|')
              FROM `creature_questrelation` r
              JOIN `creature_template` c ON c.`entry` = r.`id`
             WHERE r.`quest` = q.`entry`), ''),
  COALESCE((SELECT GROUP_CONCAT(c.`name` ORDER BY c.`name` SEPARATOR '|')
              FROM `creature_involvedrelation` r
              JOIN `creature_template` c ON c.`entry` = r.`id`
             WHERE r.`quest` = q.`entry`), ''),
  COALESCE((SELECT GROUP_CONCAT(g.`name` ORDER BY g.`name` SEPARATOR '|')
              FROM `gameobject_questrelation` r
              JOIN `gameobject_template` g ON g.`entry` = r.`id`
             WHERE r.`quest` = q.`entry`), ''),
  COALESCE((SELECT GROUP_CONCAT(g.`name` ORDER BY g.`name` SEPARATOR '|')
              FROM `gameobject_involvedrelation` r
              JOIN `gameobject_template` g ON g.`entry` = r.`id`
             WHERE r.`quest` = q.`entry`), '')
FROM `quest_template` q
LEFT JOIN `locales_quest` l ON l.`entry` = q.`entry`
WHERE %s
ORDER BY q.`ZoneOrSort`, q.`QuestLevel`, q.`entry`
""" % (locale_select, conditions)


def run_query(mysql, args, database, sql):
    """Run the query and return the rows.

    --batch (not --raw): the client escapes tabs and newlines inside values as
    \\t and \\n, which is what makes one row fit on one line. The escaping is
    undone below.
    """
    cmd = [mysql, "--batch", "--default-character-set=utf8mb4"]
    if args.user:
        cmd += ["--user", args.user]
    if args.password:
        cmd += ["--password=" + args.password]
    if args.host:
        cmd += ["--host", args.host]
    if args.port:
        cmd += ["--port", str(args.port)]
    cmd += [database, "-e", sql]

    try:
        proc = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    except FileNotFoundError:
        sys.exit("error: %s not found; pass --mysql /path/to/mysql" % mysql)
    if proc.returncode != 0:
        sys.exit("error: mysql client failed:\n" + proc.stderr.decode("utf-8", "replace"))
    return proc.stdout.decode("utf-8", "replace")


def unescape(value):
    """Undo the escaping --batch applies inside a field."""
    out, i = [], 0
    while i < len(value):
        ch = value[i]
        if ch == "\\" and i + 1 < len(value):
            nxt = value[i + 1]
            mapping = {"t": "\t", "n": "\n", "r": "\r", "\\": "\\", "0": "\0"}
            out.append(mapping.get(nxt, nxt))
            i += 2
            continue
        out.append(ch)
        i += 1
    return "".join(out)


def parse_tsv(text):
    """Rows, plus how many lines had to be skipped.

    The count matters: a worklist that quietly drops rows is worse than one that
    refuses, because the person filling it in has no way to notice the gap.
    """
    lines = text.split("\n")
    if not lines or not lines[0]:
        return [], 0
    header = lines[0].split("\t")
    if header != TSV_COLUMNS:
        sys.exit("error: unexpected result shape; got %r" % (header[:5],))

    rows, dropped = [], 0
    for line in lines[1:]:
        if not line.strip():
            continue
        fields = [unescape(f) for f in line.split("\t")]
        if len(fields) != len(TSV_COLUMNS):
            dropped += 1
            continue
        row = dict(zip(TSV_COLUMNS, fields))
        for key in ("entry", "quest_level", "min_level", "max_level", "zone",
                    "method", "prev_quest", "next_quest", "req_races", "req_classes"):
            try:
                row[key] = int(row[key])
            except ValueError:
                row[key] = 0
        rows.append(row)
    return rows, dropped


def missing_columns(row):
    """Which columns this quest still needs, in sheet order.

    A column counts as a gap only when the English has text and the Chinese does
    not: an empty English column is not untranslated, it is unused.
    """
    return [(loc, en, zh, label) for loc, en, zh, label in COLUMNS
            if row.get(en) and not row.get(zh)]


# ---------------------------------------------------------------------------
# Chain grouping
# ---------------------------------------------------------------------------

def group_chains(rows):
    """Group quests into chains by following PrevQuestId / NextQuestId.

    A chain here is simply the connected component of those two links, so a
    branch that splits and rejoins still ends up in one group - which is what a
    translator wants: the whole arc reads consistently.

    Quests with no links end up in a group of their own.
    """
    by_entry = {r["entry"]: r for r in rows}
    parent = {e: e for e in by_entry}

    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    def union(a, b):
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[rb] = ra

    for row in rows:
        for key in ("prev_quest", "next_quest"):
            other = row.get(key, 0)
            if other in by_entry:
                union(row["entry"], other)

    groups = {}
    for row in rows:
        groups.setdefault(find(row["entry"]), []).append(row)
    for group in groups.values():
        group.sort(key=lambda r: (r["zone"], r["quest_level"], r["entry"]))
    return sorted(groups.values(), key=lambda g: (g[0]["zone"], g[0]["quest_level"], g[0]["entry"]))


def zone_label(zone):
    """ZoneOrSort is an AreaTable id, a sort/class id or a negative grouping.

    The names live in the client's DBC files, which this tool does not read, so
    the number is shown as it is rather than guessed at.
    """
    if zone == 0:
        return "no zone / class sort"
    if zone < 0:
        return "sort group %d" % zone
    return "zone %d" % zone


# ---------------------------------------------------------------------------
# Writers
# ---------------------------------------------------------------------------

def write_markdown(path, groups, rows):
    total_cells = sum(len(missing_columns(r)) for r in rows)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write("# Quest text that still has no Chinese / 仍缺中文的任务文本\n\n")
        fh.write("Quests: **%d**, text blocks: **%d**\n\n" % (len(rows), total_cells))
        fh.write("Replace every `TODO` in `quests-missing.template.sql` and import it; "
                 "it only writes the `*_loc4` columns. Lines still holding `TODO` must "
                 "be deleted first - importing them would write the word TODO into the game.\n\n")
        fh.write("English quotes below are the column from `quest_template`; "
                 "the client falls back to exactly those when `*_loc4` is empty.\n\n---\n\n")

        for i, group in enumerate(groups, 1):
            head = group[0]
            who = head["givers"] or head["go_givers"] or "?"
            fh.write("## %d. %s — level %s (from %s)\n\n" % (
                i, zone_label(head["zone"]), head["quest_level"], who))
            if len(group) > 1:
                fh.write("Chain of %d quests: %s\n\n" % (
                    len(group), ", ".join(str(r["entry"]) for r in group)))

            for row in group:
                missing = missing_columns(row)
                if not missing:
                    continue
                fh.write("### %d — %s\n\n" % (row["entry"], row["title"] or "(no title)"))
                meta = ["level %d" % row["quest_level"]]
                if row["min_level"]:
                    meta.append("requires level %d" % row["min_level"])
                if row["givers"]:
                    meta.append("given by %s" % row["givers"])
                if row["turnins"]:
                    meta.append("turned in to %s" % row["turnins"])
                if row["go_givers"]:
                    meta.append("from object %s" % row["go_givers"])
                if row["go_turnins"]:
                    meta.append("to object %s" % row["go_turnins"])
                if row["prev_quest"]:
                    meta.append("after %d" % row["prev_quest"])
                if row["next_quest"]:
                    meta.append("before %d" % row["next_quest"])
                fh.write("%s\n\n" % " · ".join(meta))

                for _loc, en, _zh, label in missing:
                    fh.write("**%s**\n\n```\n%s\n```\n\n" % (label, row[en]))
                fh.write("\n")
            fh.write("---\n\n")


def write_csv(path, rows):
    import csv
    with open(path, "w", encoding="utf-8", newline="") as fh:
        writer = csv.writer(fh)
        writer.writerow(["entry", "zone", "quest_level", "min_level", "givers", "turnins",
                         "prev_quest", "next_quest",
                         "title_en", "title_zh",
                         "details_en", "details_zh",
                         "objectives_en", "objectives_zh",
                         "offer_reward_en", "offer_reward_zh",
                         "request_items_en", "request_items_zh"])
        for row in rows:
            writer.writerow([
                row["entry"], row["zone"], row["quest_level"], row["min_level"],
                row["givers"], row["turnins"], row["prev_quest"], row["next_quest"],
                row["title"], row["title_zh"],
                row["details"], row["details_zh"],
                row["objectives"], row["objectives_zh"],
                row["offer_reward"], row["offer_reward_zh"],
                row["request_items"], row["request_items_zh"],
            ])


def write_template(path, rows):
    """A ready-to-fill SQL file: one statement per row and column.

    ON DUPLICATE KEY UPDATE is what makes it safe to import twice, and it is the
    same shape sql/wip_updates/locales_quest.sql already uses. Rows whose
    English is empty are skipped: those are not gaps.
    """
    with open(path, "w", encoding="utf-8") as fh:
        fh.write("-- Translation worklist template / 待翻译模板\n")
        fh.write("--\n")
        fh.write("-- Replace every 'TODO' with the translation, then import:\n")
        fh.write("--   mysql tw_world < quests-missing.template.sql\n")
        fh.write("--\n")
        fh.write("-- WARNING: a statement still holding 'TODO' is NOT skipped - importing it\n")
        fh.write("-- writes the literal word TODO into the game. Delete the lines you are not\n")
        fh.write("-- translating:\n")
        fh.write("--   grep -c TODO quests-missing.template.sql   # must be 0 before importing\n")
        fh.write("--\n")
        fh.write("-- Only the *_loc4 columns are written, and only for the rows listed here.\n\n")
        fh.write("SET NAMES utf8mb4;\n\n")

        for row in rows:
            wrote_entry = False
            for loc, en, _zh, _label in COLUMNS:
                if not row.get(en) or row.get("_zh_" + loc):
                    continue
                if not wrote_entry:
                    fh.write("-- %d  %s\n" % (row["entry"], (row["title"] or "")[:70]))
                    wrote_entry = True
                original = " ".join(row[en].split())
                if len(original) > 120:
                    original = original[:117] + "..."
                fh.write("-- EN %s: %s\n" % (loc, original))
                fh.write("INSERT INTO `locales_quest` (`entry`, `%s_loc4`) VALUES (%d, 'TODO')\n"
                         "  ON DUPLICATE KEY UPDATE `%s_loc4` = VALUES(`%s_loc4`);\n"
                         % (loc, row["entry"], loc, loc))
                row["_zh_" + loc] = True
            if wrote_entry:
                fh.write("\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--database", default="tw_world",
                        help="world database name (default: tw_world)")
    parser.add_argument("--user", default=os.environ.get("MYSQL_USER", ""))
    parser.add_argument("--password", default=os.environ.get("MYSQL_PWD", ""))
    parser.add_argument("--host", default=os.environ.get("MYSQL_HOST", ""))
    parser.add_argument("--port", default=os.environ.get("MYSQL_TCP_PORT", ""))
    parser.add_argument("--mysql", default="",
                        help="path to the mysql/mariadb client (default: whichever is on PATH)")
    parser.add_argument("-o", "--output", default="worklist",
                        help="directory to write the three files into (default: worklist)")
    parser.add_argument("--titles-only", action="store_true",
                        help="only quests with no Chinese title at all (the 214)")
    parser.add_argument("--obtainable-only", action="store_true",
                        help="only quests a player can still pick up: the quest must have a "
                             "creature or game object giver that actually spawns in the world")
    args = parser.parse_args()

    mysql = args.mysql
    if not mysql:
        for candidate in ("mysql", "mariadb"):
            if shutil.which(candidate):
                mysql = candidate
                break
    if not mysql:
        sys.exit("error: neither mysql nor mariadb is on PATH; pass --mysql")

    sql = build_sql(args.titles_only, args.obtainable_only)
    rows, dropped = parse_tsv(run_query(mysql, args, args.database, sql))
    if dropped:
        print("warning: %d row(s) did not have %d fields and were skipped - "
              "the worklist is incomplete, please report this"
              % (dropped, len(TSV_COLUMNS)), file=sys.stderr)
    if not rows:
        if dropped:
            sys.exit("error: every row was malformed; nothing written.")
        print("nothing to translate: every listed quest already has Chinese.")
        return

    os.makedirs(args.output, exist_ok=True)
    groups = group_chains(rows)
    write_markdown(os.path.join(args.output, "quests-missing.md"), groups, rows)
    write_csv(os.path.join(args.output, "quests-missing.csv"), rows)
    write_template(os.path.join(args.output, "quests-missing.template.sql"), rows)

    cells = sum(len(missing_columns(r)) for r in rows)
    print("quests: %d, text blocks: %d, chains: %d" % (len(rows), cells, len(groups)))
    print("wrote %s/{quests-missing.md,quests-missing.csv,quests-missing.template.sql}" % args.output)
    print("the SQL template starts with %d 'TODO' placeholder(s); fill or delete them before importing"
          % cells)


if __name__ == "__main__":
    main()
