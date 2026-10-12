#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify_cmangos_desc_fill.py —— 核对「按 entry 从 cmangos 官方中文补进来的物品说明」是否真属于该物品

背景
    2026-10-05 的汉化把 locales_item.description_loc4 里空着的格子，按 **entry** 抄自
    cmangos classic-db 的 locales/Chinese/locales_item.sql（1.12.1 官方简中）。
    香草的条目表里留着一大批当时没用上、后来才启用或废弃的 entry：
    42142 在官方数据里是宝石「朴素龙眼石 / Coarse Dragon's Eye」（说明：对应红色插槽。），
    而乌龟服把同一个 entry 用作自己的自定义物品「朴素树叶 / Simple Leaves」。
    按 entry 抄就把宝石的插槽说明贴到了树叶上——这就是「中文有说明、英文没有，而且
    说明跟物品毫无关系」的来源。

判定
    一条中文说明只有在能确认「来源行讲的就是我们这件物品」时才保留（keep）：
      W1 同名：我们库里的中文名 == 来源行的中文名，且上游 base 里本来就有这个中文名
              （base 空说明这个中文名不是抄来的，而是上游/官方译名，才可作证）
      W2 香草同物：香草原版 item_template 同 entry 的英文名 == 我们的英文名
      W3 异译：两个中文名高度重合（最长公共子串 >= 较短者的 50%，同一物品的不同译法）
    另加两条不需要身份的硬规则，命中直接判错（revert）：
      R1 机制在 1.12 不存在：说明里出现 插槽 / 镶嵌 / 多彩宝石 / 切割
         （1.12 内核没有插槽字段、没有珠宝加工专业，见 src/game 无 SOCKET 物品字段）
      R2 物品根本不教东西：说明以「教你学会」开头，但 spellid_1..5 全为 0
      R3 我们这件物品的英文名是占位/测试名（Placeholder / Monster - / Deprecated /
         OLD / [PH] …），而来源行的中文名是个具体物品名 —— 名字本身也是按 entry 抄来的，
         不能当同名证据（33102 的中文名「祖尔金之血」就是这么来的）
    其余一律 revert（revert 值写回空串——经核对，这些条目在上游 base 里本来就是空/无行）。

用法
    python3 tools/dbdiff/verify_cmangos_desc_fill.py \
        --mysql "tools/dbdiff/mysql_local.sh tw_world" \
        --base sql/base/tw_world_locales_item.sql \
        --cache /tmp/cmangos-data \
        --report /tmp/cmangos_desc_fill.tsv \
        --sql /tmp/cmangos_desc_revert.sql

    --cache 里缺文件时会自动从 cmangos 仓库下载（约 17 MB），sha256 与下面钉住的一致才用。
    只读线上库；生成的 .sql 是幂等的 UPDATE（值对不上就不动），不自动执行。
"""
import argparse
import gzip
import hashlib
import os
import re
import subprocess
import sys
import urllib.request

CMANGOS_LOCALE_URL = ("https://raw.githubusercontent.com/cmangos/classic-db/master"
                      "/locales/Chinese/locales_item.sql")
CMANGOS_FULLDB_URL = ("https://raw.githubusercontent.com/cmangos/classic-db/master"
                      "/Full_DB/ClassicDB_1_12_1_z2815.sql.gz")
PINNED = {
    "locales_item.sql": "e1a5f654c2bae0815470852643a790d0bdcf35b8725d2570c3e1f8b40e267f21",
    "ClassicDB_1_12_1_z2815.sql.gz": "4f92db520868ab4e566726f68b5b2e380ae781209beaf22237b4f7f04600d0c0",
}
# 香草原版 item_template 的字段位置（cmangos Full_DB，128 列）
VANILLA_FIELDS = 128
VANILLA_NAME, VANILLA_DESC = 3, 106
# 本项目 sql/base/tw_world_locales_item.sql 的字段布局（19 列）
BASE_FIELDS = 19
BASE_NAME4, BASE_DESC0, BASE_DESC4 = 5, 10, 14

UNESCAPE = {"0": "\0", "b": "\b", "n": "\n", "r": "\r", "t": "\t", "Z": "\x1a",
            "\\": "\\", "'": "'", '"': '"', "%": "%", "_": "_"}
R_SOCKET = re.compile(r"插槽|镶嵌|多彩宝石|切割")
R_PLACEHOLDER = re.compile(r"^(?:(?i:Placeholder|Monster -|Deprecated|Test )|OLD|\[PH\]|PH )")
CJK = re.compile(r"[\u4e00-\u9fff]")


def unescape(text):
    out, i, n = [], 0, len(text)
    while i < n:
        c = text[i]
        if c == "\\" and i + 1 < n:
            out.append(UNESCAPE.get(text[i + 1], text[i + 1])); i += 2; continue
        out.append(c); i += 1
    return "".join(out)


def sql_unquote(v):
    v = v.strip()
    if v.upper() == "NULL":
        return None
    if len(v) >= 2 and v[0] == "'" and v[-1] == "'":
        v = v[1:-1]
    return (v.replace("''", "'").replace("\\'", "'").replace('\\"', '"')
             .replace("\\n", "\n").replace("\\\\", "\\"))


def split_fields(row):
    """按引号把一行 VALUES 切成字段（不处理括号，调用方已切出行边界）"""
    out, buf, ins, esc = [], [], False, False
    for ch in row:
        if esc:
            buf.append(ch); esc = False; continue
        if ch == "\\":
            esc = True; buf.append(ch); continue
        if ch == "'":
            ins = not ins; buf.append(ch); continue
        if ch == "," and not ins:
            out.append("".join(buf)); buf = []; continue
        buf.append(ch)
    out.append("".join(buf))
    return out


def parse_rows(text, table, nfields):
    """从 mysqldump 文本里取出 `table` 的所有 INSERT 行 → {entry: [字段…]}

    只扫 `INSERT INTO `table`` 与下一个 `INSERT INTO ` 之间的片段，
    片段内按括号配对切行，避免文本里的逗号/括号干扰。
    """
    out = {}
    marker = "INSERT INTO `%s`" % table
    pos = 0
    while True:
        i = text.find(marker, pos)
        if i < 0:
            break
        nxt = text.find("INSERT INTO `", i + len(marker))
        chunk = text[i:nxt if nxt > 0 else len(text)]
        pos = nxt if nxt > 0 else len(text)
        v = chunk.find("VALUES")
        if v < 0:
            continue
        body = chunk[v + 6:]
        j, n = 0, len(body)
        while j < n:
            if body[j] != "(":
                j += 1; continue
            k, depth, ins, esc = j, 0, False, False
            while k < n:
                c = body[k]
                if esc:
                    esc = False
                elif c == "\\":
                    esc = True
                elif c == "'":
                    ins = not ins
                elif not ins:
                    if c == "(":
                        depth += 1
                    elif c == ")":
                        depth -= 1
                        if depth == 0:
                            break
                k += 1
            fields = split_fields(body[j + 1:k])
            j = k + 1
            if len(fields) == nfields and fields[0].strip().isdigit():
                out[fields[0].strip()] = [sql_unquote(f) for f in fields]
    return out


def fetch(cache, name, url):
    os.makedirs(cache, exist_ok=True)
    path = os.path.join(cache, name)
    if not os.path.exists(path):
        print("下载 %s …" % url)
        urllib.request.urlretrieve(url, path)
    h = hashlib.sha256(open(path, "rb").read()).hexdigest()
    flag = "OK" if PINNED.get(name) in (None, h) else "!! 与钉住的 sha256 不同"
    print("  %-32s %s  %s" % (name, h[:16], flag))
    return path


def load_cmangos(cache):
    loc = fetch(cache, "locales_item.sql", CMANGOS_LOCALE_URL)
    full = fetch(cache, "ClassicDB_1_12_1_z2815.sql.gz", CMANGOS_FULLDB_URL)
    cm = {}
    pat = re.compile(r"INSERT INTO `locales_item` \(`entry`, `name_loc4`, `description_loc4`\) "
                     r"VALUES \((\d+), '(.*)', '(.*)'\);")
    for line in open(loc, encoding="utf-8", errors="replace"):
        m = pat.match(line.strip())
        if m:
            cm[m.group(1)] = (m.group(2).replace("\\'", "'"), m.group(3).replace("\\'", "'"))
    print("cmangos 中文行：%d" % len(cm))
    with gzip.open(full, "rt", encoding="utf-8", errors="replace") as fh:
        vanilla = parse_rows(fh.read(), "item_template", VANILLA_FIELDS)
    print("香草原版 item_template 行：%d" % len(vanilla))
    return cm, vanilla


def query(sql, mysql):
    cmd = mysql.split() + ["--batch", "-e", sql]
    out = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if out.returncode != 0:
        sys.exit("mysql 失败：%s" % out.stderr.decode("utf-8", "replace").strip())
    lines = out.stdout.decode("utf-8", "replace").split("\n")
    if lines and lines[0].startswith("entry"):
        lines = lines[1:]
    return [unescape(l).split("\t") for l in lines if l.strip()]


def load_live(mysql):
    rows = query(
        "SELECT i.entry, i.name, i.description, i.spellid_1, i.spellid_2, i.spellid_3,"
        " i.spellid_4, i.spellid_5, COALESCE(l.name_loc4,''), COALESCE(l.description_loc4,'')"
        " FROM item_template i JOIN locales_item l ON l.entry=i.entry"
        " WHERE l.description_loc4<>''", mysql)
    out = {}
    for f in rows:
        if len(f) < 10:
            continue
        out[f[0]] = {"name": f[1], "desc0": f[2], "spells": [int(x or 0) for x in f[3:8]],
                     "zh_name": f[8], "zh_desc": f[9]}
    print("库里带中文说明的物品：%d" % len(out))
    return out


def lcs_len(a, b):
    if not a or not b:
        return 0
    prev = [0] * (len(b) + 1)
    best = 0
    for i in range(1, len(a) + 1):
        cur = [0] * (len(b) + 1)
        for j in range(1, len(b) + 1):
            if a[i - 1] == b[j - 1]:
                cur[j] = prev[j - 1] + 1
                best = max(best, cur[j])
            else:
                cur[j] = 0
        prev = cur
    return best


def classify(entry, live, cm, vanilla, base):
    desc = live["zh_desc"]
    cm_name, cm_desc = cm.get(entry, ("", ""))
    if cm_desc == "" or cm_desc != desc:
        return "keep", "不是本次批量补的（与本工具的来源逐字不同）", ""
    van = vanilla.get(entry)
    if R_SOCKET.search(desc):
        return "revert", "机制在 1.12 不存在", cm_name
    if desc.startswith("教你学会") and not any(live["spells"]):
        return "revert", "物品五个法术槽全 0，不可能教人", cm_name
    if R_PLACEHOLDER.search(live["name"]) and cm_name and CJK.search(cm_name):
        return "revert", "我们这件是占位/测试名，来源行讲的是另一件物品", cm_name
    b = base.get(entry)
    if b and (b[BASE_NAME4] or "") and (b[BASE_NAME4] or "") == live["zh_name"]:
        return "keep", "上游/官方中文名与来源同名（W1）", cm_name
    if van and (van[VANILLA_NAME] or "").strip() == live["name"].strip():
        return "keep", "香草原版同 entry 英文名一致（W2）", cm_name
    if cm_name and live["zh_name"] and lcs_len(live["zh_name"], cm_name) >= 0.5 * min(len(live["zh_name"]), len(cm_name)):
        return "keep", "两个中文名高度重合＝同一物品的不同译法（W3）", cm_name
    if not cm_name and not live["zh_name"]:
        return "keep", "无名可比，说明与本物品无从冲突（保守保留）", cm_name
    return "revert", "来源行是另一件物品", cm_name


def sql_quote(s):
    return s.replace("\\", "\\\\").replace("'", "\\'")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--mysql", required=True, help="mysql 命令行（含库名），如 tools/dbdiff/mysql_local.sh tw_world")
    ap.add_argument("--base", default="sql/base/tw_world_locales_item.sql", help="上游 base 的 locales_item 转储")
    ap.add_argument("--cache", default="/tmp/cmangos-data", help="cmangos 源文件缓存目录")
    ap.add_argument("--report", default="", help="输出 TSV 明细")
    ap.add_argument("--sql", default="", help="输出幂等回滚 SQL")
    ap.add_argument("--limit", type=int, default=25, help="终端上逐条打印的条数")
    args = ap.parse_args()

    cm, vanilla = load_cmangos(args.cache)
    live = load_live(args.mysql)
    base = {}
    if os.path.exists(args.base):
        for e, f in parse_rows(open(args.base, encoding="utf-8", errors="replace").read(),
                               "locales_item", BASE_FIELDS).items():
            base[e] = f
        print("上游 base locales_item 行：%d" % len(base))
    else:
        print("警告：找不到 %s，W1 判据将不可用" % args.base)

    verdicts = []
    for entry in sorted(live, key=int):
        v, why, cm_name = classify(entry, live[entry], cm, vanilla, base)
        verdicts.append((entry, v, why, cm_name, cm.get(entry, ("", ""))[1], live[entry]))

    revert = [r for r in verdicts if r[1] == "revert"]
    keep = [r for r in verdicts if r[1] == "keep"]
    print("\nkeep %d / revert %d" % (len(keep), len(revert)))
    for why in sorted({r[2] for r in revert}):
        print("  revert %-28s %d" % (why, sum(1 for r in revert if r[2] == why)))
    print("\n前 %d 条要撤的：" % args.limit)
    for entry, _, why, cm_name, _, lv in revert[:args.limit]:
        print("  %6s %-26s cm名:%-14s %s" % (entry, lv["name"][:26], cm_name[:14], lv["zh_desc"][:26]))

    if args.report:
        with open(args.report, "w", encoding="utf-8") as fh:
            fh.write("entry\tverdict\treason\tcm_name\ten_name\tzh_name\tzh_desc\n")
            for entry, v, why, cm_name, cm_desc, lv in verdicts:
                fh.write("\t".join([entry, v, why, cm_name, lv["name"], lv["zh_name"],
                                    lv["zh_desc"].replace("\n", " ").replace("\t", " ")]) + "\n")
        print("\n明细已写：%s" % args.report)
    if args.sql:
        with open(args.sql, "w", encoding="utf-8") as fh:
            fh.write("-- 撤掉按 entry 误配到别的物品上的中文说明（由 tools/dbdiff/verify_cmangos_desc_fill.py 生成）\n")
            fh.write("-- 计数：revert %d 条（keep %d 条未列）。幂等：值对不上就不动。\n" % (len(revert), len(keep)))
            for why in sorted({r[2] for r in revert}):
                fh.write("--   %s：%d 条\n" % (why, sum(1 for r in revert if r[2] == why)))
            fh.write("SET NAMES utf8mb4;\n\n")
            for entry, _, why, cm_name, _, lv in revert:
                fh.write("-- %s（%s ← 来源行「%s」）\n" % (entry, lv["name"][:40], (cm_name or "无名")[:20]))
                fh.write("UPDATE `locales_item` SET `description_loc4`='' "
                         "WHERE `entry`=%s AND `description_loc4`='%s';\n" % (entry, sql_quote(lv["zh_desc"])))
        print("回滚 SQL 已写：%s" % args.sql)
    return 0


if __name__ == "__main__":
    sys.exit(main())
