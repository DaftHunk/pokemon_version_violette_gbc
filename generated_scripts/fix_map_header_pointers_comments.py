#!/usr/bin/env python3
"""Fix stale map-ID comments in data/maps/map_header_pointers.asm.

MapHeaderPointers is indexed by map ID: the engine loads the Nth dw to get
the map header of map ID N, so the 0-based position of each dw IS its map
ID. The ;id=NN / ;NNN comments mark those positions, but they rot every
time maps are reorganized (the FORGOTTEN_PASSAGE / RUGGED_ROAD moves made
17 of them wrong). This script recomputes each commented position from the
actual 0-based index of its dw line and rewrites ONLY the existing numeric
comments -- no comment is ever added or removed.

Idempotent: run it twice, the second run reports 0 fixed.
After running: rebuild the ROM (it must stay binary identical, comments
only).
"""

import argparse
import re
import sys
from pathlib import Path


class AsmError(Exception):
    pass


def fail(msg):
    raise AsmError(msg)


REL_PATH = "data/maps/map_header_pointers.asm"
MAP_CONSTANTS = "constants/map_constants.asm"
RE_TABLE_LABEL = re.compile(r"^MapHeaderPointers::\s*$")
RE_DW = re.compile(r"^\tdw\s+([A-Za-z_]\w*)_h\s*(;.*)?$")
# position comment on a dw line: ";id=40", ";200", ";247"
RE_ID_COMMENT = re.compile(r"^(id=)?(\d+)(\s*)$")
RE_MAPCONST = re.compile(r"^\s*mapconst\s+")


def main(argv=None):
    ap = argparse.ArgumentParser(
        description="Fix stale ;id= position comments in "
                    "map_header_pointers.asm by recomputing them from the "
                    "actual 0-based table index.")
    ap.add_argument("--dry-run", action="store_true",
                    help="report the changes without writing the file")
    args = ap.parse_args(argv)

    rel = Path(REL_PATH)
    root = None
    for cand in Path(__file__).resolve().parents:
        if (cand / rel).is_file():
            root = cand
            break
    if root is None:
        fail("cannot locate the repository root (%s) in the parent "
             "directories of this script" % REL_PATH)

    path = root / rel
    data = path.read_bytes()
    # ISO-8859-1: 1 byte = 1 char round trip, byte-exact for any file
    text = data.decode("iso-8859-1")
    crlf = "\r\n" in text
    if crlf:
        text = text.replace("\r\n", "\n")
    lines = text.split("\n")

    # optional safety net: the table must have one entry per mapconst
    mc_path = root / MAP_CONSTANTS
    if mc_path.is_file():
        n_mapconst = sum(1 for l in
                         mc_path.read_bytes().decode("iso-8859-1").split("\n")
                         if RE_MAPCONST.match(l))
    else:
        n_mapconst = 0

    try:
        start = next(i for i, l in enumerate(lines)
                     if RE_TABLE_LABEL.match(l))
    except StopIteration:
        fail("MapHeaderPointers:: label not found")

    changed = []
    total = 0
    idx = -1
    for i in range(start + 1, len(lines)):
        line = lines[i]
        m = RE_DW.match(line)
        if m:
            idx += 1
            if m.group(2) is None:
                continue
            cm = RE_ID_COMMENT.match(m.group(2)[1:])
            if not cm:
                fail("%s:%d: unrecognized comment on a dw line: %s"
                     % (REL_PATH, i + 1, m.group(2).strip()[:60]))
            total += 1
            if int(cm.group(2)) == idx:
                continue
            changed.append((i + 1, m.group(1), cm.group(2), str(idx)))
            lines[i] = (line[:line.index(";")] + ";" + (cm.group(1) or "")
                        + str(idx) + cm.group(3))
            continue
        if line.strip() == "":
            for j in range(i + 1, len(lines)):
                rest = lines[j].strip()
                if rest != "" and not rest.startswith(";"):
                    fail("%s:%d: unexpected content after the table: %s"
                         % (REL_PATH, j + 1, lines[j].strip()[:60]))
            break
        fail("%s:%d: unrecognized line inside the table: %s"
             % (REL_PATH, i + 1, line.strip()[:60]))
    if idx < 0:
        fail("no dw entries found after MapHeaderPointers::")

    print("table entries: %d" % (idx + 1))
    if n_mapconst and n_mapconst != idx + 1:
        fail("table has %d entries but map_constants.asm declares %d "
             "mapconst -- fix the table order/count first, comments can "
             "wait" % (idx + 1, n_mapconst))

    print("%d/%d position comments fixed:" % (len(changed), total))
    for line_no, name, old, new in changed:
        print("  line %d: %s_h: %s -> %s" % (line_no, name, old, new))
    if not changed:
        print("nothing to fix: position comments are up to date")
        return 0

    new_text = "\n".join(lines)
    if crlf:
        new_text = new_text.replace("\n", "\r\n")
    new_data = new_text.encode("iso-8859-1")
    if args.dry_run:
        print("dry run: file left unchanged")
    else:
        path.write_bytes(new_data)
        print("wrote %s (%d -> %d bytes)" % (REL_PATH, len(data), len(new_data)))
        print("re-run to confirm idempotence (expect 0 fixed), then "
              "rebuild: the ROM must stay binary identical")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except AsmError as exc:
        sys.exit("fix_map_header_pointers_comments.py: error: %s" % exc)