#!/usr/bin/env python3
"""Renumérote les commentaires "; $XX" de constants/map_constants.asm
à partir de la position réelle des mapconst.

Re-exécutable après toute future réorganisation des mapconst :
les IDs sont recalculés depuis zéro à chaque exécution.
"""

import re
from pathlib import Path

TARGET = Path("constants") / "map_constants.asm"
MAPCONST_RE = re.compile(r"^\s*mapconst\s")
COMMENT_RE = re.compile(r"^(?P<prefix>.*?);\s*\$[0-9A-Fa-f]{1,2}\s*$")


def find_repo_root(start: Path) -> Path:
    for directory in (start, *start.parents):
        if (directory / TARGET).is_file():
            return directory
    raise FileNotFoundError(f"Racine du dépôt introuvable depuis {start}")


def main() -> None:
    path = find_repo_root(Path(__file__).resolve().parent) / TARGET
    text = path.read_bytes().decode("ascii")

    newline = "\r\n" if "\r\n" in text else "\n"
    lines = text.split(newline)

    total = 0
    fixed = 0
    for index, line in enumerate(lines):
        if MAPCONST_RE.match(line):
            comment = COMMENT_RE.match(line)
            if comment:
                new_line = f"{comment['prefix']}; ${total:02X}"
                if new_line != line:
                    fixed += 1
                lines[index] = new_line
            total += 1

    path.write_bytes(newline.join(lines).encode("ascii"))
    print(f"mapconst comments: {fixed} fixed, {total} total ({path})")


if __name__ == "__main__":
    main()