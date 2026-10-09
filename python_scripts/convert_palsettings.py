#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
convert_palsettings.py — Convertit les blocs PalSettings_ de
custom_functions/func_enhancedcolor.asm (Pokémon Version Violette) en fichiers
.asm « tilepal » à placer dans le dossier color/tilesets/ de pokered-gbc.

Source  : <dépôt>/custom_functions/func_enhancedcolor.asm
Sorties : <dossier du script>/palsettings_convertis/<cible>.asm (un par tileset
          graphique, ex. overworld.asm, reds_house.asm, reactor.asm, ...)
          + recap_palsettings.txt

Fonctionnement :
  1. Lit la table OverworldTilePalPointers (ordre des blocs PalSettings_).
  2. Extrait les valeurs (0-8) de chaque bloc. Les blocs vides héritent par
     « fall-through » ASM du bloc défini suivant dans le fichier
     (ex. PalSettings_REDS_HOUSE_1 -> PalSettings_REDS_HOUSE_2,
     PalSettings_MART -> PalSettings_POKECENTER, FOREST_GATE/MUSEUM -> GATE).
  3. Convertit chaque valeur en nom de couleur via MAPPING ci-dessous, puis
     écrit un fichier <cible>.asm au format « tilepal 0, COULEUR, ... ».
  4. Plusieurs blocs peuvent viser la même cible (MART et POKECENTER ->
     pokecenter.asm) : le contenu est identique par construction (héritage),
     sinon un avertissement est affiché.

Mapping des valeurs (moteur Violette + choix validés) :
    0 = RED      1 = TEXT      2 = ROOF     3 = GRAY
    4 = GREEN    5 = YELLOW    6 = BROWN    7 = WATER
    8 = ROOF  (joker « couleur selon la ville », cf. PalSettings_TownSpecialPal)
  -> Éditez MAPPING en tête de script si besoin.

Options utiles :
    --repo CHEMIN        Dépôt Violette (auto-détecté sinon).
    --out DOSSIER        Dossier de sortie (défaut : palsettings_convertis
                         à côté du script).
    --nb-tuiles SPEC     Compléter avec GRAY jusqu'à N tuiles. SPEC = « auto »
                         (défaut : nombre de tuiles lu depuis les gfx du dépôt),
                         « 96 » (tous les fichiers) ou « overworld=158,gym=128 »
                         (par cible, mélange global/par-cible permis).
    --gfx-dir DOSSIER    Dossier des gfx des tilesets (défaut :
                         <dépôt>/gfx/tilesets).
    --sans-remplissage   S'arrêter aux valeurs PalSettings (aucun GRAY).
    --par-ligne N        Entrées par ligne tilepal (défaut : 16 ; les fichiers
                         d'origine de pokered-gbc utilisent 8).
    --seulement a,b,c    Limiter aux cibles données (ex. --seulement overworld).

Exemples :
    python convert_palsettings.py                       # auto : GRAY jusqu'au nb de tuiles des gfx
    python convert_palsettings.py --seulement overworld --nb-tuiles overworld=158
    python convert_palsettings.py --nb-tuiles 96 --par-ligne 8
    python convert_palsettings.py --sans-remplissage

Remarque : dans le moteur Violette, l'overworld force GRAY pour les tuiles
>= $79 (END_OF_OVERWORLD_TILES) ; le remplissage GRAY est cohérent avec ce
comportement. En mode « auto », le nombre de tuiles est lu depuis
gfx/tilesets/<cible>.2bpp (16 octets/tuile) ou, à défaut, <cible>.png
(en-tête IHDR : dimensions en pixels, 8 px par tuile).
"""

import argparse
import re
import sys
from pathlib import Path

# ---------------------------------------------------------------------------
# Configuration éditable
# ---------------------------------------------------------------------------

# Valeur PalSettings -> nom de couleur pokered-gbc
MAPPING = {
    0: "RED",
    1: "TEXT",
    2: "ROOF",
    3: "GRAY",
    4: "GREEN",
    5: "YELLOW",
    6: "BROWN",
    7: "WATER",
    8: "ROOF",  # joker ville
}

# Bloc PalSettings_XXX -> fichier cible color/tilesets/<cible>.asm
# (table de pointeurs du fichier source ; REACTOR/VOLCANO/ALPHA sont les
#  tilesets absents de pokered-gbc d'origine)
CIBLES = {
    "OVERWORLD": "overworld",
    "REDS_HOUSE_1": "reds_house",
    "MART": "pokecenter",
    "FOREST": "forest",
    "REDS_HOUSE_2": "reds_house",
    "DOJO": "gym",
    "POKECENTER": "pokecenter",
    "GYM": "gym",
    "HOUSE": "house",
    "FOREST_GATE": "gate",
    "MUSEUM": "gate",
    "UNDERGROUND": "underground",
    "GATE": "gate",
    "SHIP": "ship",
    "SHIP_PORT": "ship_port",
    "CEMETERY": "cemetery",
    "INTERIOR": "interior",
    "CAVERN": "cavern",
    "LOBBY": "lobby",
    "MANSION": "mansion",
    "LAB": "lab",
    "CLUB": "club",
    "FACILITY": "facility",
    "REACTOR": "reactor",
    "VOLCANO": "volcano",
    "PLATEAU": "plateau",
    "ALPHA": "alpha",
}

FICHIER_SOURCE = Path("custom_functions") / "func_enhancedcolor.asm"
DOSSIER_DEFAUT = "../color/tilesets"
GRIS = 3  # valeur GRAY pour le remplissage

# ---------------------------------------------------------------------------
# Lecture / localisation
# ---------------------------------------------------------------------------


def lire_texte(chemin):
    """Lit un fichier en tolérant utf-8 et latin-1."""
    for enc in ("utf-8", "latin-1"):
        try:
            return chemin.read_text(encoding=enc), enc
        except UnicodeDecodeError:
            continue
    return chemin.read_text(encoding="utf-8", errors="replace"), "utf-8(remplacé)"


def trouver_depot(base):
    """Cherche le dépôt Violette depuis le dossier du script, ses parents et cwd."""
    for candidat in [base, *base.parents, Path.cwd()]:
        if (candidat / FICHIER_SOURCE).is_file():
            return candidat
    return None


# ---------------------------------------------------------------------------
# Analyse du fichier source
# ---------------------------------------------------------------------------


def parser_pointeurs(texte):
    """Retourne la liste ordonnée des blocs pointés par OverworldTilePalPointers."""
    lignes = texte.splitlines()
    i = 0
    while i < len(lignes) and "OverworldTilePalPointers:" not in lignes[i]:
        i += 1
    if i == len(lignes):
        sys.exit("Erreur : table OverworldTilePalPointers introuvable.")
    pointeurs = []
    motif = re.compile(r"^\s*dw\s+(PalSettings_[A-Za-z0-9_]+)")
    i += 1
    while i < len(lignes):
        m = motif.match(lignes[i])
        if not m:
            break
        pointeurs.append(m.group(1))
        i += 1
    if not pointeurs:
        sys.exit("Erreur : aucun pointeur PalSettings_ trouvé dans la table.")
    return pointeurs


def parser_blocs(texte, noms_attendus):
    """Extrait les valeurs (0-8) de chaque bloc PalSettings_, dans l'ordre du fichier.

    Seuls les blocs pointés par la table sont retenus (PalSettings_TownSpecialPal
    est ignoré). Retourne (blocs, ordre, alertes).
    """
    blocs = {}
    ordre = []
    alertes = []
    courant = None
    motif_label = re.compile(r"^(PalSettings_[A-Za-z0-9_]+):")
    for ligne in texte.splitlines():
        m = motif_label.match(ligne)
        if m:
            courant = m.group(1)
            if courant in noms_attendus and courant not in blocs:
                ordre.append(courant)
                blocs[courant] = []
            continue
        if courant is None or courant not in noms_attendus:
            continue
        if re.match(r"^\s*db\b", ligne):
            corps = ligne.split(";")[0]
            corps = re.sub(r"^\s*db\s*", "", corps).strip()
            if not corps:
                continue
            for jeton in corps.split(","):
                jeton = jeton.strip()
                if not jeton:
                    continue
                if jeton.startswith("$"):
                    try:
                        val = int(jeton[1:], 16)
                    except ValueError:
                        alertes.append(f"{courant} : jeton illisible ignoré {jeton!r}")
                        continue
                else:
                    try:
                        val = int(jeton)
                    except ValueError:
                        alertes.append(f"{courant} : jeton illisible ignoré {jeton!r}")
                        continue
                if val not in MAPPING:
                    alertes.append(
                        f"{courant} : valeur {val} hors table (tuile "
                        f"${len(blocs[courant]):02X}) -> GRAY"
                    )
                    val = GRIS
                blocs[courant].append(val)
    return blocs, ordre, alertes


def heriter_vides(blocs, ordre):
    """Les blocs vides héritent du bloc suivant qui contient des données (fall-through)."""
    heritages = {}
    for i, nom in enumerate(ordre):
        if blocs[nom]:
            continue
        for suivant in ordre[i + 1:]:
            if blocs[suivant]:
                blocs[nom] = list(blocs[suivant])
                heritages[nom] = suivant
                break
    return heritages


def parser_nb_tuiles(spec):
    """Analyse --nb-tuiles : « 96 » -> (96, {}) ; « overworld=158 » -> (None, {...})."""
    global_ = None
    par_fichier = {}
    for jeton in spec.split(","):
        jeton = jeton.strip()
        if not jeton:
            continue
        if "=" in jeton:
            nom, val = jeton.split("=", 1)
            try:
                par_fichier[nom.strip().lower()] = int(val)
            except ValueError:
                sys.exit(f"Erreur : --nb-tuiles invalide ({jeton!r}).")
        else:
            try:
                global_ = int(jeton)
            except ValueError:
                sys.exit(f"Erreur : --nb-tuiles invalide ({jeton!r}).")
    return global_, par_fichier


def nb_tuiles_gfx(cible, gfx_dir):
    """Nombre de tuiles d'un tileset gfx : <cible>.2bpp (16 octets/tuile), sinon
    <cible>.png (en-tête IHDR, 8 px par tuile). Retourne (nb, description) ou
    (None, motif) si indéterminable."""
    p2bpp = gfx_dir / f"{cible}.2bpp"
    if p2bpp.is_file():
        taille = p2bpp.stat().st_size
        return taille // 16, f"{cible}.2bpp ({taille} octets)"
    ppng = gfx_dir / f"{cible}.png"
    if ppng.is_file():
        try:
            avec = ppng.open("rb").read(33)
        except OSError:
            return None, f"{cible}.png illisible"
        if len(avec) >= 24 and avec[:8] == b"\x89PNG\r\n\x1a\n" and avec[12:16] == b"IHDR":
            largeur = int.from_bytes(avec[16:20], "big")
            hauteur = int.from_bytes(avec[20:24], "big")
            if largeur % 8 or hauteur % 8:
                return None, f"{cible}.png {largeur}x{hauteur} px non multiple de 8"
            return (largeur // 8) * (hauteur // 8), f"{cible}.png {largeur}x{hauteur} px"
        return None, f"{cible}.png sans IHDR lisible"
    return None, "aucun fichier gfx trouvé"


# ---------------------------------------------------------------------------
# Génération des fichiers
# ---------------------------------------------------------------------------


def lignes_tilepal(valeurs, par_ligne):
    lignes = []
    for i in range(0, len(valeurs), par_ligne):
        noms = [MAPPING[v] for v in valeurs[i:i + par_ligne]]
        lignes.append("\ttilepal 0, " + ", ".join(noms))
    return lignes


def main(argv=None):
    base = Path(__file__).resolve().parent
    ap = argparse.ArgumentParser(
        description="Convertit les PalSettings_ de func_enhancedcolor.asm en "
                    "fichiers tilepal pour pokered-gbc."
    )
    ap.add_argument("--repo", help="Chemin du dépôt Violette (auto-détecté sinon).")
    ap.add_argument("--out", help="Dossier de sortie (défaut : %s à côté du script)."
                    % DOSSIER_DEFAUT)
    ap.add_argument("--nb-tuiles", default="auto",
                    help="Remplissage GRAY jusqu'à N tuiles : « auto » (défaut, "
                         "nb de tuiles lu depuis les gfx), « 96 » ou "
                         "« overworld=158,gym=128 ».")
    ap.add_argument("--gfx-dir",
                    help="Dossier des gfx des tilesets (défaut : <dépôt>/gfx/tilesets).")
    ap.add_argument("--sans-remplissage", action="store_true",
                    help="S'arrêter aux valeurs PalSettings (aucun GRAY).")
    ap.add_argument("--par-ligne", type=int, default=16,
                    help="Entrées par ligne tilepal (défaut : 16).")
    ap.add_argument("--seulement", default="",
                    help="Cibles à traiter, séparées par des virgules "
                         "(ex. overworld,alpha).")
    args = ap.parse_args(argv)

    if args.par_ligne < 1:
        sys.exit("Erreur : --par-ligne doit être >= 1.")

    # Localisation du dépôt
    if args.repo:
        depot = Path(args.repo).resolve()
        if not (depot / FICHIER_SOURCE).is_file():
            sys.exit(f"Erreur : {FICHIER_SOURCE} introuvable dans {depot}.")
    else:
        depot = trouver_depot(base)
        if depot is None:
            sys.exit(f"Erreur : dépôt Violette introuvable ({FICHIER_SOURCE}). "
                     "Placez le script dans python_scripts/ du dépôt ou utilisez --repo.")

    chemin = depot / FICHIER_SOURCE
    texte, enc = lire_texte(chemin)
    print(f"Dépôt détecté : {depot}")
    print(f"Source        : {chemin} (encodage {enc})")

    # Analyse
    pointeurs = parser_pointeurs(texte)
    blocs, ordre, alertes = parser_blocs(texte, set(pointeurs))
    heritages = heriter_vides(blocs, ordre)
    PREFIXE = "PalSettings_"
    cibles_uniques = {CIBLES[p[len(PREFIXE):]] for p in pointeurs
                      if p.startswith(PREFIXE) and p[len(PREFIXE):] in CIBLES}
    print(f"Blocs pointés : {len(pointeurs)} ; cibles uniques : {len(cibles_uniques)}")

    for nom in pointeurs:
        if nom not in blocs or not blocs[nom]:
            print(f"  ATTENTION : bloc {nom} vide ou introuvable — fichier ignoré.")
    for nom, source in heritages.items():
        print(f"  Héritage fall-through : {nom} -> {source}")
    for a in alertes:
        print("  " + a)

    # Cible -> valeurs (premier bloc pointé ; contrôle de cohérence des doublons)
    par_cible = {}
    sources = {}
    conflits = []
    for nom in pointeurs:
        nom_sec = nom[len(PREFIXE):] if nom.startswith(PREFIXE) else nom
        if nom_sec not in CIBLES:
            print(f"  ATTENTION : bloc {nom} sans cible connue (ignoré).")
            continue
        cible = CIBLES[nom_sec]
        if not blocs.get(nom):
            continue
        if cible in par_cible:
            if par_cible[cible] != blocs[nom]:
                conflits.append((cible, sources[cible], nom))
        else:
            par_cible[cible] = blocs[nom]
            sources[cible] = nom
    for cible, premier, autre in conflits:
        print(f"  ATTENTION : {cible}.asm — {premier} et {autre} diffèrent ; "
              f"la version de {premier} est conservée.")

    # Filtre --seulement
    demande = [s.strip().lower() for s in args.seulement.split(",") if s.strip()]
    if demande:
        inconnues = [c for c in demande if c not in par_cible]
        for c in inconnues:
            print(f"  ATTENTION : cible demandée inconnue « {c} » (ignorée).")
        par_cible = {c: v for c, v in par_cible.items() if c in demande}
    if not par_cible:
        sys.exit("Erreur : aucune cible à traiter.")

    # Remplissage GRAY jusqu'au nombre de tuiles (auto par défaut)
    mode_auto = not args.sans_remplissage and args.nb_tuiles.strip().lower() == "auto"
    gfx_dir = (Path(args.gfx_dir).resolve() if args.gfx_dir
               else depot / "gfx" / "tilesets")
    if mode_auto and not gfx_dir.is_dir():
        print(f"  ATTENTION : dossier gfx introuvable : {gfx_dir} "
              "(l'auto-détection échouera).")
    if args.sans_remplissage:
        global_nb, par_fichier_nb = None, {}
    elif mode_auto:
        global_nb, par_fichier_nb = None, {}
    else:
        global_nb, par_fichier_nb = parser_nb_tuiles(args.nb_tuiles)
    remplissage = {}
    provenance_nb = {}
    for cible, valeurs in par_cible.items():
        if args.sans_remplissage:
            continue
        if cible in par_fichier_nb:
            cible_nb = par_fichier_nb[cible]
        elif global_nb is not None:
            cible_nb = global_nb
        elif mode_auto:
            cible_nb, detail = nb_tuiles_gfx(cible, gfx_dir)
            if cible_nb is None:
                print(f"  ATTENTION : {cible}.asm — {detail} ; pas de remplissage.")
                continue
            provenance_nb[cible] = detail
        else:
            continue
        if cible_nb < len(valeurs):
            print(f"  ATTENTION : {cible}.asm — {cible_nb} tuiles "
                  f"({provenance_nb.get(cible, 'demandé')}) mais {len(valeurs)} "
                  f"valeurs PalSettings ; rien n'est tronqué.")
        elif cible_nb > len(valeurs):
            remplissage[cible] = cible_nb - len(valeurs)
            provenance_nb.setdefault(cible, "demandé")
            par_cible[cible] = list(valeurs) + [GRIS] * (cible_nb - len(valeurs))

    # Écriture
    sortie = Path(args.out).resolve() if args.out else base / DOSSIER_DEFAUT
    sortie.mkdir(parents=True, exist_ok=True)
    recap = ["cible ; bloc(s) source(s) ; valeurs PalSettings ; +GRAY ; total ; "
             "lignes ; source nb tuiles"]
    nb_fichiers = 0
    for cible, valeurs in par_cible.items():
        lignes = lignes_tilepal(valeurs, args.par_ligne)
        chemin_out = sortie / f"{cible}.asm"
        chemin_out.write_text("\n".join(lignes) + "\n", encoding="utf-8")
        nb_fichiers += 1
        nb_gris = remplissage.get(cible, 0)
        recap.append(
            f"{cible}.asm ; {sources[cible]} ; "
            f"{len(valeurs) - nb_gris} ; {nb_gris} ; {len(valeurs)} ; {len(lignes)} ; "
            f"{provenance_nb.get(cible, '-')}"
        )
        print(f"  Écrit : {chemin_out} ({len(valeurs)} tuiles, {len(lignes)} lignes)")

    chemin_recap = sortie / "recap_palsettings.txt"
    chemin_recap.write_text("\n".join(recap) + "\n", encoding="utf-8")
    print(f"Récapitulatif : {chemin_recap}")
    print(f"Terminé : {nb_fichiers} fichier(s) généré(s) dans {sortie}")


if __name__ == "__main__":
    main()