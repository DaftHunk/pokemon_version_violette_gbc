#!/usr/bin/env python3
"""Renumérote les commentaires "; $XX" de constants/sprite_constants.asm
à partir de la position réelle des `const SPRITE_*`.

- Corrige les commentaires périmés (vestiges retail / décalages FR)
  et ajoute le commentaire manquant sur les lignes qui n'en ont pas.
- Le compteur repart de chaque ancre `const_value = N` / `const_def`,
  donc le bloc ICON_* n'est pas renuméroté.
- Les commentaires de section (`; NPC`, `; Pokemons`, ...) sont préservés,
  ainsi que d'éventuelles valeurs explicites `const NAME, $XX`.

Re-exécutable après toute future réorganisation des sprites :
les IDs sont recalculés depuis zéro à chaque exécution.

Note : le fichier contient de l'accentué (é) -> latin-1 au lieu d'ascii.
"""

import re
from pathlib import Path

TARGET = Path("constants") / "sprite_constants.asm"
ANCHOR_RE = re.compile(r"^\s*(?:const_value\s*=\s*(\$?[0-9A-Fa-f]+)|const_def\b)")
CONST_RE = re.compile(r"^\s*const\s+(SPRITE_[A-Z0-9_]+)\s*(?:,\s*\$([0-9A-Fa-f]+))?\s*(?:;.*)?$")
COMMENT_RE = re.compile(r";\s*\$[0-9A-Fa-f]{1,2}\s*$")


def find_repo_root(start: Path) -> Path:
    for directory in (start, *start.parents):
        if (directory / TARGET).is_file():
            return directory
    raise FileNotFoundError(f"Racine du dépôt introuvable depuis {start}")


def parse_int(value: str) -> int:
    return int(value[1:], 16) if value.startswith("$") else int(value, 10)


def main() -> None:
    path = find_repo_root(Path(__file__).resolve().parent) / TARGET
    text = path.read_bytes().decode("latin-1")

    newline = "\r\n" if "\r\n" in text else "\n"
    lines = text.split(newline)

    sprites = []  # (index, nom, valeur) dans l'ordre du fichier
    counter = None
    for index, line in enumerate(lines):
        anchor = ANCHOR_RE.match(line)
        if anchor:
            counter = 0 if anchor.group(1) is None else parse_int(anchor.group(1))
            continue
        const = CONST_RE.match(line)
        if const:
            name, explicit = const.group(1), const.group(2)
            if explicit is not None:
                value = int(explicit, 16)
            elif counter is not None:
                value = counter
            else:
                raise RuntimeError(f"{path.name}:{index + 1}: SPRITE hors d'un bloc const_value")
            counter = value + 1
            sprites.append((index, name, value))

    width = max(len(name) for _, name, _ in sprites)
    fixed = added = 0
    for index, name, value in sprites:
        if COMMENT_RE.search(lines[index]):
            if not (new_line := f"\tconst {name:<{width + 1}}; ${value:02X}") == lines[index]:
                fixed += 1
        else:
            new_line = f"\tconst {name:<{width + 1}}; ${value:02X}"
            added += 1
        lines[index] = new_line

    path.write_bytes(newline.join(lines).encode("latin-1"))
    print(f"sprite const comments: {fixed} fixed, {added} added, {len(sprites)} total ({path})")


if __name__ == "__main__":
    main()