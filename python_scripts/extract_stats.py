#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
extract_stats.py — Pokémon Version Violette GBC

Exporte les stats de base de tous les Pokémon depuis
data/pokemons/baseStats/*.asm vers pokemon_stats.txt
(écrit dans le dossier de ce script, donc python_scripts/).

Les formes spéciales (*_s.asm) sont exclues par défaut
(--inclure-formes-speciales pour les garder).

Lancement direct :
    python extract_stats.py
(dépôt détecté automatiquement autour du script ; sinon :)
    python extract_stats.py --repo /chemin/vers/le/depot

Format de sortie inchangé (compatible avec l'existant) :
    ID|hp|attack|defense|speed|special

Aucune dépendance externe (stdlib uniquement).
"""

import argparse
import re
import sys
from pathlib import Path

BASE = Path(__file__).resolve().parent

STAT_COMMENTS = {
    "base hp": "hp",
    "base attack": "attack",
    "base defense": "defense",
    "base speed": "speed",
    "base special": "special",
}
DB_LIGNE = re.compile(r"^\s*db\s+([^;]+?)\s*;\s*(.*)$")


def lire(p):
    """Lit un fichier .asm en tolérant utf-8 (avec/sans BOM) et latin-1."""
    brut = p.read_bytes()
    for enc in ("utf-8-sig", "utf-8", "latin-1"):
        try:
            return brut.decode(enc)
        except UnicodeDecodeError:
            continue
    return brut.decode("utf-8", errors="replace")


def trouver_depot(explicite):
    """Cherche la racine du dépôt : argument --repo > autour du script > CWD."""
    if explicite:
        c = Path(explicite).expanduser().resolve()
        if (c / "data" / "pokemons" / "baseStats").is_dir():
            return c
        sys.exit("--repo invalide (pas de data/pokemons/baseStats/) : " + str(c))
    for depart in (BASE, BASE.parent, Path.cwd()):
        d = depart
        for _ in range(8):
            if (d / "data" / "pokemons" / "baseStats").is_dir():
                return d
            d = d.parent
    sys.exit("Dépôt introuvable : python extract_stats.py --repo /chemin/vers/le/depot")


def extraire_stats(contenu):
    stats = {"hp": "", "attack": "", "defense": "", "speed": "", "special": ""}
    for l in contenu.splitlines():
        m = DB_LIGNE.match(l)
        if not m:
            continue
        commentaire = m.group(2).strip().lower()
        for cle, champ in STAT_COMMENTS.items():
            if commentaire.startswith(cle):
                stats[champ] = m.group(1).strip()
    return stats


def main():
    ap = argparse.ArgumentParser(
        description="Export des stats de base — Pokémon Version Violette GBC"
    )
    ap.add_argument("--repo", help="chemin du clone du dépôt (auto-détecté sinon)")
    ap.add_argument("--out", default=str(BASE), help="dossier de sortie (défaut : dossier du script)")
    ap.add_argument("--inclure-formes-speciales", action="store_true",
                    help="inclure aussi les fichiers *_s.asm (formes spéciales)")
    args = ap.parse_args()

    repo = trouver_depot(args.repo)
    out = Path(args.out).expanduser().resolve()
    out.mkdir(parents=True, exist_ok=True)
    dossier = repo / "data" / "pokemons" / "baseStats"
    tous = sorted(dossier.glob("*.asm"))
    if args.inclure_formes_speciales:
        fichiers, exclus = tous, []
    else:
        fichiers = [p for p in tous if not p.stem.lower().endswith("_s")]
        exclus = [p for p in tous if p.stem.lower().endswith("_s")]
    print("Dépôt    :", repo)
    print("Fichiers :", len(fichiers), "Pokémon dans", "data/pokemons/baseStats")
    if exclus:
        print("Exclus   :", len(exclus), "formes spéciales :",
              ", ".join(p.stem for p in exclus))

    tableau = []
    for p in fichiers:
        nom = p.stem.title()
        s = extraire_stats(lire(p))
        if not s["hp"]:
            print("  ! pas de stats de base trouvées dans", p.name)
        tableau.append([nom, s["hp"], s["attack"], s["defense"], s["speed"], s["special"]])

    sortie = out / "pokemon_stats.txt"
    with open(sortie, "w", encoding="utf-8") as f:
        f.write("ID|hp|attack|defense|speed|special\n")
        for ligne in tableau:
            f.write("|".join(ligne) + "\n")

    print("Export   :", sortie, "(" + str(len(tableau)) + " Pokémon)")


if __name__ == "__main__":
    main()