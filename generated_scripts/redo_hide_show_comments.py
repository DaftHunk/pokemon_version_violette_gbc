#!/usr/bin/env python3
"""Renumérote les commentaires "; XX" de constants/hide_show_constants.asm
à partir de la position réelle des `const HS_*`.

L'index global d'un objet missable est sa position dans le flux de
data/maps/hide_show_data.asm (calculée à l'exécution par
LoadMissableObjects), et les consts HS_* sont auto-numérotées via
`const_value = 0` : le commentaire hexa d'une ligne const doit donc
toujours valoir sa position 0-based dans la liste. Ces commentaires
pourrissent à chaque retrait/insertion (extraction item balls du 25/10,
migration des 7 balls pures du 31/10).

- réécrit UNIQUEMENT l'hexa des commentaires existants : aucun
  commentaire n'est ajouté ni supprimé ; suffixes `;joenote - ...` et
  espacement d'origine (y compris les noms trop longs collés au `;`)
  préservés à l'octet près ;
- refuse explicitement une ligne const sans commentaire hexa, un
  commentaire non reconnu, un const hors du namespace HS_ ou hors d'un
  bloc const_value/const_def (dérive manuelle à corriger d'abord) ;
- garde-fou : le nombre de consts HS_* doit être égal au nombre
  d'entrées `db` réelles de data/maps/hide_show_data.asm (terminateurs
  $FF exclus) -- sinon les tables sont désynchronisées et on ne retouche
  pas les commentaires avant de les avoir corrigées.

Re-exécutable après toute future réorganisation des HS : les index
sont recalculés depuis zéro à chaque exécution.
ISO-8859-1 : 1 octet = 1 char, round-trip byte-exact.

Idempotent : relancer -> 0 fixed. Rebuild -> ROM binairement identique
(commentaires seuls).
"""

import argparse
import re
import sys
from pathlib import Path


class AsmError(Exception):
    pass


def fail(msg):
    raise AsmError(msg)


REL_PATH = "constants/hide_show_constants.asm"
DATA_PATH = "data/maps/hide_show_data.asm"
ANCHOR_RE = re.compile(r"^\s*(?:const_value\s*=\s*(\$?[0-9A-Fa-f]+)|const_def\b)")
CONST_RE = re.compile(r"^\s*const\s+(HS_[A-Z0-9_]+)\s*(?:,\s*\$?([0-9A-Fa-f]+))?\s*(;.*)?$")
OTHER_CONST_RE = re.compile(r"^\s*const\b")
# hex comment: "; 4E", "; 4E ;joenote - ..." -- separator and suffix preserved
HEX_COMMENT_RE = re.compile(r"^;(\s*)([0-9A-Fa-f]{1,2})(.*)$")
# real hide_show_data entries: "\tdb MAP_ID,..." ($FF terminators excluded)
RE_DATA_ENTRY = re.compile(r"^\tdb\s+[A-Z][A-Z0-9_]*\s*,")


def parse_int(value):
    return int(value[1:], 16) if value.startswith("$") else int(value, 10)


def main(argv=None):
    ap = argparse.ArgumentParser(
        description="Fix stale ;XX index comments in hide_show_constants.asm "
                    "by recomputing them from the actual const position.")
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
    newline = "\r\n" if "\r\n" in text else "\n"
    lines = text.split(newline)

    # pass 1: assign each const its rgbasm value from the anchors
    consts = []  # (line index, name, value, comment or None)
    counter = None
    for i, line in enumerate(lines):
        anchor = ANCHOR_RE.match(line)
        if anchor:
            counter = 0 if anchor.group(1) is None else parse_int(anchor.group(1))
            continue
        m = CONST_RE.match(line)
        if m:
            name, explicit, comment = m.group(1), m.group(2), m.group(3)
            if explicit is not None:
                value = int(explicit, 16)
            elif counter is not None:
                value = counter
            else:
                fail("%s:%d: %s is outside any const_value/const_def block"
                     % (REL_PATH, i + 1, name))
            counter = value + 1
            consts.append((i, name, value, comment))
        elif OTHER_CONST_RE.match(line):
            fail("%s:%d: const outside the HS_ namespace is not supported "
                 "(it would shift the HS indexes): %s"
                 % (REL_PATH, i + 1, line.strip()[:60]))

    # safety net: consts and data entries must stay one-to-one
    data_file = root / DATA_PATH
    if data_file.is_file():
        n_entries = sum(1 for l
                        in data_file.read_bytes().decode("iso-8859-1").split("\n")
                        if RE_DATA_ENTRY.match(l))
        if n_entries != len(consts):
            fail("%s has %d entries but %s declares %d const HS_* -- fix "
                 "the tables first, the comments can wait"
                 % (DATA_PATH, n_entries, REL_PATH, len(consts)))

    # pass 2: rewrite only the existing hex comments
    changed = []
    for i, name, value, comment in consts:
        if comment is None:
            fail("%s:%d: %s has no index comment at all -- add a \"; XX\" "
                 "one first" % (REL_PATH, i + 1, name))
        hm = HEX_COMMENT_RE.match(comment)
        if not hm:
            fail("%s:%d: unrecognized comment on %s: %s"
                 % (REL_PATH, i + 1, name, comment[:60]))
        if len(hm.group(2)) != 2:
            fail("%s:%d: 1-digit hex comment on %s -- fix it manually first"
                 % (REL_PATH, i + 1, name))
        if int(hm.group(2), 16) == value:
            continue
        prefix = lines[i][:len(lines[i]) - len(comment)]
        lines[i] = "%s;%s%02X%s" % (prefix, hm.group(1), value, hm.group(3))
        changed.append((i + 1, name, hm.group(2).upper(), "%02X" % value))

    print("hide show const comments: %d/%d fixed" % (len(changed), len(consts)))
    for line_no, name, old, new in changed:
        print("  line %d: %s: %s -> %s" % (line_no, name, old, new))
    if not changed:
        print("nothing to fix: hide show index comments are up to date")
        return 0

    new_text = newline.join(lines)
    new_data = new_text.encode("iso-8859-1")
    if len(new_data) != len(data):
        fail("internal error: size changed (%d -> %d bytes) -- nothing written"
             % (len(data), len(new_data)))
    if args.dry_run:
        print("dry run: file left unchanged")
    else:
        path.write_bytes(new_data)
        print("wrote %s (%d bytes)" % (REL_PATH, len(new_data)))
        print("re-run to confirm idempotence (expect 0 fixed), then rebuild:"
              " the ROM must stay binary identical")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except AsmError as exc:
        sys.exit("redo_hide_show_constants_comments.py: error: %s" % exc)