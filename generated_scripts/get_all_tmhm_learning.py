#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
get_all_tmhm_learning.py — Pokémon Version Violette GBC

Exporte la matrice d'apprentissage TM/HM de tous les Pokémon, lue dans
data/pokemons/baseStats/*.asm (macros tmlearn du style :
    tmlearn tm01_MEGA_PUNCH, tm06_TOXIC, ..., hm05_FLASH).

La liste des Pokémon n'est plus en dur : elle est détectée
automatiquement dans le dossier — elle est donc toujours à jour avec
la branche (190 fichiers actuellement, nouvelles créatures comprises).
Les formes spéciales (*_s.asm) sont exclues par défaut
(--inclure-formes-speciales pour les garder).

Exports (écrits dans le dossier de ce script, donc python_scripts/) :
    tmhm_learning.csv   matrice Pokémon x TM/HM ("x" = appris)
    tmhm_learning.txt   même matrice en version lisible (largeur fixe)

Lancement direct :
    python get_all_tmhm_learning.py
(dépôt détecté automatiquement autour du script ; sinon :)
    python get_all_tmhm_learning.py --repo /chemin/vers/le/depot

Aucune dépendance externe (stdlib uniquement).
"""

import argparse
import csv
import re
import sys
from pathlib import Path

BASE = Path(__file__).resolve().parent

TM_RE = re.compile(r"\btm(\d{2})_[A-Za-z0-9_]+")
HM_RE = re.compile(r"\bhm(\d{2})_[A-Za-z0-9_]+")


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
    sys.exit("Dépôt introuvable : python get_all_tmhm_learning.py --repo /chemin/vers/le/depot")


def main():
    ap = argparse.ArgumentParser(
        description="Export des apprentissages TM/HM — Pokémon Version Violette GBC"
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
    print("Pokémon  :", len(fichiers), "fichiers dans", "data/pokemons/baseStats")
    if exclus:
        print("Exclus   :", len(exclus), "formes spéciales :",
              ", ".join(p.stem for p in exclus))

    donnees = {}          # nom -> ensemble des codes appris ("tm01", "hm05", ...)
    tous_tm, tous_hm = set(), set()
    for p in fichiers:
        contenu = lire(p)
        ens = set()
        for m in TM_RE.finditer(contenu):
            code = "tm" + m.group(1)
            tous_tm.add(code)
            ens.add(code)
        for m in HM_RE.finditer(contenu):
            code = "hm" + m.group(1)
            tous_hm.add(code)
            ens.add(code)
        donnees[p.stem.title()] = ens

    colonnes = sorted(tous_tm) + sorted(tous_hm)

    # --- tmhm_learning.csv (matrice complète, lisible dans un tableur)
    sortie_csv = out / "tmhm_learning.csv"
    with open(sortie_csv, "w", newline="", encoding="utf-8-sig") as f:
        w = csv.writer(f)
        w.writerow(["Pokemon"] + colonnes)
        for nom in sorted(donnees):
            w.writerow([nom] + ["x" if c in donnees[nom] else "" for c in colonnes])

    # --- tmhm_learning.txt (matrice lisible en largeur fixe)
    codes = []
    for c in colonnes:
        if c.startswith("tm"):
            codes.append(c[2:])            # tm01 -> "01"
        else:
            codes.append("h" + str(int(c[2:])))  # hm05 -> "h5"
    larg = max([len(nom) for nom in donnees] + [len("Pokemon")]) + 2
    sortie_txt = out / "tmhm_learning.txt"
    with open(sortie_txt, "w", encoding="utf-8") as f:
        entete = "Pokemon".ljust(larg) + "".join(code.ljust(3) for code in codes)
        f.write(entete + "\n")
        f.write("-" * len(entete) + "\n")
        for nom in sorted(donnees):
            cases = "".join(
                ("x".ljust(3) if c in donnees[nom] else ".".ljust(3)) for c in colonnes
            )
            f.write(nom.ljust(larg) + cases + "\n")
        f.write("\n")
        f.write("Légende : 01-%02d = TM01-TM%02d ; h1-h%d = HM01-HM%02d ; x = appris, . = non\n" % (
            len(tous_tm), len(tous_tm), len(tous_hm), len(tous_hm)
        ))

    print("TM détectés  :", len(tous_tm), "(tm01 à", sorted(tous_tm)[-1] + ")")
    print("HM détectés  :", len(tous_hm), "(hm01 à", sorted(tous_hm)[-1] + ")")
    print("Export       :", sortie_csv)
    print("Export       :", sortie_txt)


if __name__ == "__main__":
    main()