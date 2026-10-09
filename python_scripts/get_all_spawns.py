#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
get_all_spawns.py — Pokémon Version Violette GBC

Exporte toutes les rencontres sauvages depuis
data/wildPokemons/maps/*.asm vers all_spawns.txt
(écrit dans le dossier de ce script, donc python_scripts/).

Lancement direct :
    python get_all_spawns.py
(dépôt détecté automatiquement autour du script ; sinon :)
    python get_all_spawns.py --repo /chemin/vers/le/depot

Même sortie que l'ancien script :
  - les cartes sans rencontres (2e ligne « db $00 ») sont ignorées ;
  - la première ligne est remplacée par le nom de la carte ;
  - les préfixes tabulés « db » sont retirés.

Aucune dépendance externe (stdlib uniquement).
"""

import argparse
import sys
from pathlib import Path

BASE = Path(__file__).resolve().parent


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
        if (c / "data" / "wildPokemons" / "maps").is_dir():
            return c
        sys.exit("--repo invalide (pas de data/wildPokemons/maps/) : " + str(c))
    for depart in (BASE, BASE.parent, Path.cwd()):
        d = depart
        for _ in range(8):
            if (d / "data" / "wildPokemons" / "maps").is_dir():
                return d
            d = d.parent
    sys.exit("Dépôt introuvable : python get_all_spawns.py --repo /chemin/vers/le/depot")


def main():
    ap = argparse.ArgumentParser(
        description="Export des rencontres sauvages — Pokémon Version Violette GBC"
    )
    ap.add_argument("--repo", help="chemin du clone du dépôt (auto-détecté sinon)")
    ap.add_argument("--out", default=str(BASE), help="dossier de sortie (défaut : dossier du script)")
    args = ap.parse_args()

    repo = trouver_depot(args.repo)
    out = Path(args.out).expanduser().resolve()
    out.mkdir(parents=True, exist_ok=True)
    dossier = repo / "data" / "wildPokemons" / "maps"
    fichiers = sorted(dossier.glob("*.asm"))
    print("Dépôt    :", repo)
    print("Fichiers :", len(fichiers), "cartes dans", "data/wildPokemons/maps")

    sortie = out / "all_spawns.txt"
    cartes_avec_rencontres = 0
    with open(sortie, "w", encoding="utf-8") as f:
        for p in fichiers:
            lignes = lire(p).splitlines()
            # Carte sans rencontres sauvages (taux $00) -> ignorée
            if len(lignes) < 2 or lignes[1].strip() == "db $00":
                continue
            cartes_avec_rencontres += 1
            f.write("\n")
            # Première ligne remplacée par le nom de la carte
            f.write(p.stem + "\n")
            for l in lignes[1:]:
                if l.startswith("\tdb "):
                    l = l.replace("\tdb ", "", 1)
                f.write(l + "\n")
            f.write("\n\n")

    print("Export   :", sortie,
          "(" + str(cartes_avec_rencontres) + " cartes avec rencontres sur " + str(len(fichiers)) + ")")


if __name__ == "__main__":
    main()