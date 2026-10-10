#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mark_hidden_objects.py — Pokémon Version Violette (GBC)

Marque sur des captures de cartes (PNG) les cases contenant un « objet caché »,
chaque case recevant un badge numéroté dans l'ordre de déclaration des objets.

Sources analysées dans le dépôt :
  - data/items/hidden_objects.asm      : HiddenObjectMaps + un bloc par carte
                                        (format d'une entrée : db Y, X, id
                                        puis la routine dbw BANK(...), Routine ;
                                        bloc terminé par db $FF)
  - data/items/hidden_item_coords.asm  : liste ordonnée des objets trouvables
                                        au sol (cet ordre = index du flag dans
                                        wObtainedHiddenItemsFlags)
  - data/items/hidden_coins.asm       : liste ordonnée des pièces cachées
  - constants/map_constants.asm       : dimensions des cartes (mapconst NOM, h, l)
  - data/maps/headers/*.asm           : association id de carte -> nom interne,
                                        celui des PNG (mansion1, unknowndungeon1,
                                        tradecenter...) via « db <NOM>_HEIGHT,
                                        <NOM>_WIDTH »
  - constants/item_constants.asm      : identifiants des objets (constantes)
  - text/item_names.asm               : noms français des objets (ItemNames)
  - text/tmhm_names.asm               : noms français des CS/CT (tmhmNames)

Trois types d'objets, distingués par la couleur du badge :
  - objet       (rouge)  : objet trouvé au sol (routine HiddenItems)
  - piece       (or)     : pièce cachée du Casino (routine HiddenCoins)
  - interactif  (bleu)   : objet interactif invisible (PC, statue de gym,
                           poubelle, machine à sous, jumelles, bibliothèque...)
Par défaut seuls les objets et les pièces sont marqués ; ajoutez
« --types interactifs » (ou « --types tous ») pour les inclure.

Convention des coordonnées (vérifiée dans le moteur : CheckForHiddenObject /
CheckIfCoordsInFrontOfPlayerMatch comparent directement ces valeurs à wYCoord /
wXCoord, les mêmes que pour les warps) : Y d'abord puis X, en tuiles de 8x8 px,
à partir du coin haut-gauche de la carte visible. La taille d'une tuile dans le
PNG est déduite automatiquement des dimensions de la carte (captures zoomées
x2 => tuile de 16 px, etc.) ; --taille-tuile sert de repli si les dimensions
sont inconnues.

Numérotation :
  - mode "carte"  (défaut) : numéro d'ordre sur la carte, par type
    (objets dans l'ordre de hidden_item_coords, pièces dans l'ordre de
    hidden_coins, interactifs dans l'ordre du bloc hidden_objects).
  - mode "global" : pour les objets et pièces, numéro global dans leur
    fichier (c'est l'index du flag de ramassement, utile pour éditer une save).

Bonus : le script recoupe les blocs de hidden_objects.asm avec les listes
hidden_item_coords / hidden_coins et signale toute incohérence
(objet sans flag => réobtensible à l'infini ; objet déclaré mais jamais
placé sur la carte => introuvable en jeu), ainsi que les coordonnées
hors des limites d'une carte (jamais déclenchables en jeu).

Exports (dans --out, défaut : <dossier du script>/hidden_objects_marques/) :
  - <carte>.png         : capture marquée, avec sous l'image la légende des
                         noms : « n° -> nom français de l'objet » (ItemNames,
                         tmhmNames pour les CT), « n° -> N jetons » pour les
                         pièces, « n° -> routine » pour les interactifs ;
                         entrées triées par numéro croissant (1, 2, 3...).
                         --sans-legende garde la capture seule.
  - hidden_objects.csv  : récapitulatif (séparateur « ; », ouvrable dans Excel)
                         — colonne « nom » = nom français résolu

Encodage des noms : les fichiers .asm sont lus en utf-8 puis latin-1 ; les
accents sont conservés si une police TTF est disponible (DejaVu, Arial,
Liberation, Noto...), sinon les noms sont automatiquement translittérés
(é -> e, û -> u...) pour éviter tout caractère cassé dans la légende.

Utilisation :
  python mark_hidden_objects.py                       # tout en automatique
  python mark_hidden_objects.py --maps CHEMIN         # dossier des PNG
  python mark_hidden_objects.py --types objets        # objets au sol uniquement
  python mark_hidden_objects.py --types tous          # + interactifs (bleus)
  python mark_hidden_objects.py --numeration global   # flags plutôt qu'ordre local
  python mark_hidden_objects.py --sans-legende         # sans bandeau de noms

Dépendance : Pillow  (pip install pillow)
"""

import argparse
import csv
import re
import sys
from pathlib import Path

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    sys.exit("Dépendance manquante : Pillow.  Installez-la avec :  pip install pillow")

REPERTOIRE_DEPOT = "data/items/hidden_objects.asm"

COULEURS = {
    "objet": (214, 48, 49, 255),
    "piece": (243, 156, 18, 255),
    "interactif": (52, 120, 220, 255),
}
LIBELLES = {
    "objet": "Objet au sol",
    "piece": "Pièce cachée",
    "interactif": "Interactif (PC, statue, poubelle...)",
}

# Translittération de repli si aucune police TTF n'est disponible (les polices
# bitmap par défaut de Pillow ne couvrent pas les accents français).
TRANSLIT = str.maketrans({
    "á": "a", "à": "a", "â": "a", "ä": "a", "ã": "a",
    "é": "e", "è": "e", "ê": "e", "ë": "e",
    "í": "i", "ì": "i", "î": "i", "ï": "i",
    "ó": "o", "ò": "o", "ô": "o", "ö": "o", "õ": "o",
    "ú": "u", "ù": "u", "û": "u", "ü": "u",
    "ç": "c", "ñ": "n", "œ": "oe", "æ": "ae",
    "Á": "A", "À": "A", "Â": "A", "Ä": "A", "Ã": "A",
    "É": "E", "È": "E", "Ê": "E", "Ë": "E",
    "Í": "I", "Ì": "I", "Î": "I", "Ï": "I",
    "Ó": "O", "Ò": "O", "Ô": "O", "Ö": "O", "Õ": "O",
    "Ú": "U", "Ù": "U", "Û": "U", "Ü": "U",
    "Ç": "C", "Ñ": "N",
})
CANDIDATS_TTF = ("DejaVuSans.ttf", "arial.ttf", "LiberationSans-Regular.ttf",
                 "NotoSans-Regular.ttf", "FreeSans.ttf", "Verdana.ttf", "tahoma.ttf")

# Ordre d'affichage des types à numéro égal dans la légende
ORDRE_TYPES = {"objet": 0, "piece": 1, "interactif": 2}

# ----------------------------------------------------------------- utilitaires

def lire(chemin: Path) -> str:
    for enc in ("utf-8", "latin-1"):
        try:
            return chemin.read_text(encoding=enc)
        except UnicodeDecodeError:
            continue
    return chemin.read_text(encoding="utf-8", errors="replace")


def val(s: str) -> int:
    """Convertit '$1a' (hexa) ou '26' (décimal) en entier."""
    return int(s[1:], 16) if s.startswith("$") else int(s)


def trouver_depot() -> Path:
    """Cherche la racine du dépôt : dossier du script, ses parents, puis cwd."""
    depart = [Path(__file__).resolve().parent, Path.cwd()]
    for base in depart:
        for candidat in [base, *base.parents]:
            if (candidat / REPERTOIRE_DEPOT).is_file():
                return candidat
    sys.exit(
        "Dépôt introuvable : placez le script dans python_scripts/ du dépôt,\n"
        "ou lancez-le depuis le dépôt, ou précisez --repo CHEMIN."
    )

# ------------------------------------------------------------------- parseurs

def parse_dimensions_cartes(txt):
    """{constante de carte: (hauteur, largeur)} en blocs, depuis les mapconst."""
    dims = {}
    for m in re.finditer(r"^\s*mapconst\s+([A-Z0-9_]+)\s*,\s*(\d+)\s*,\s*(\d+)", txt, re.M):
        dims[m.group(1)] = (int(m.group(2)), int(m.group(3)))
    return dims


def scan_entetes(dossier):
    """Parcourt data/maps/headers/ : {constante de carte: nom interne (stem PNG)}.

    Chaque en-tête contient « db <NOM>_HEIGHT, <NOM>_WIDTH » où <NOM> est la
    constante de la carte ; le nom du fichier est celui des .blk et des PNG.
    """
    mapping = {}
    for f in sorted(Path(dossier).glob("*.asm")):
        m = re.search(r"db\s+([A-Z0-9_]+)_HEIGHT\s*,\s*[A-Z0-9_]+_WIDTH", lire(f))
        if m:
            mapping[m.group(1)] = f.stem.lower()
    return mapping


def parse_liste_coords(txt):
    """Liste ordonnée de (carte, y, x) — fichiers hidden_item_coords / hidden_coins."""
    entrees = []
    for m in re.finditer(
        r"^\s*db\s+([A-Z0-9_]+)\s*,\s*(\$[0-9A-Fa-f]+|\d+)\s*,\s*(\$[0-9A-Fa-f]+|\d+)",
        txt, re.M,
    ):
        entrees.append((m.group(1), val(m.group(2)), val(m.group(3))))
    return entrees


def parse_constantes_items(txt):
    """{constante d'objet: id} depuis constants/item_constants.asm.

    Suit « const_value = N » puis les « const NOM » séquentiels (l'ordre = l'id) ;
    les alias « NOM EQU $xx » explicites sont aussi pris en compte.
    """
    ids = {}
    valeur = 1
    for ligne in txt.splitlines():
        corps = ligne.split(";")[0].strip()
        m = re.match(r"const_value\s*=\s*(\$[0-9A-Fa-f]+|\d+)$", corps)
        if m:
            valeur = val(m.group(1))
            continue
        m = re.match(r"const\s+([A-Za-z0-9_]+)$", corps)
        if m:
            ids[m.group(1)] = valeur
            valeur += 1
            continue
        m = re.match(r"([A-Za-z0-9_]+)\s+EQU\s+(\$[0-9A-Fa-f]+|\d+)$", corps)
        if m:
            ids.setdefault(m.group(1), val(m.group(2)))
    return ids


def parse_noms_items(txt):
    """Liste ordonnée des noms d'un fichier « db "NOM@" » (ItemNames/tmhmNames)."""
    return [m.group(1).rstrip("@").strip()
            for m in re.finditer(r'db\s+"([^"]*)"', txt)]


def nom_objet(detail, routine, ids_items, noms_items, noms_tmhm):
    """Nom français d'un marqueur depuis son identifiant de bloc (None sinon)."""
    detail = (detail or "").strip()
    if routine == "HiddenCoins":
        m = re.match(r"COIN\s*\+\s*(\d+)", detail)
        return f"{m.group(1)} jetons" if m else None
    if routine == "HiddenItems":
        id_ = ids_items.get(detail)
        if id_ is None:
            m = re.fullmatch(r"\$([0-9A-Fa-f]{1,2})", detail)
            if m:
                id_ = int(m.group(1), 16)
        if id_ is None:
            return None
        if 1 <= id_ <= len(noms_items):
            return noms_items[id_ - 1]
        if noms_tmhm and 0xC4 <= id_ < 0xC4 + len(noms_tmhm):
            return noms_tmhm[id_ - 0xC4]
    return None


def libelle_marqueur(marqueur, ids_items, noms_items, noms_tmhm):
    """Texte de légende d'un marqueur : nom FR, jetons, routine ou repli."""
    if marqueur["type"] == "interactif":
        return marqueur["routine"] or marqueur["detail"] or "interactif"
    nom = nom_objet(marqueur["detail"], marqueur["routine"],
                    ids_items, noms_items, noms_tmhm)
    if nom:
        return nom
    return marqueur["detail"] or LIBELLES[marqueur["type"]]


def parse_blocs_hidden_objects(txt):
    """{label: [(y, x, detail, routine), ...]} pour chaque bloc XxxHiddenObjects."""
    blocs = {}
    for m in re.finditer(r"^([A-Za-z0-9_]+HiddenObjects?)\s*:\s*(?:;.*)?$", txt, re.M):
        label = m.group(1)
        debut = m.end()
        fin = re.search(r"db\s+\$?FF", txt[debut:], re.I)
        corps = txt[debut:debut + fin.start()] if fin else txt[debut:]
        lignes = corps.split("\n")
        entrees = []
        for i, ligne in enumerate(lignes):
            em = re.match(
                r"\s*db\s+(\$[0-9A-Fa-f]+|\d+)\s*,\s*(\$[0-9A-Fa-f]+|\d+)\s*,\s*(.+?)\s*(?:;.*)?$",
                ligne,
            )
            if not em:
                continue
            y, x = val(em.group(1)), val(em.group(2))
            routine = ""
            for ligne_suite in lignes[i + 1:i + 5]:
                wm = re.search(r"dbw\s+BANK\([^)]*\)\s*,\s*([A-Za-z0-9_]+)", ligne_suite)
                dm = re.match(r"\s*dw\s+([A-Za-z0-9_]+)", ligne_suite)
                if wm:
                    routine = wm.group(1)
                    break
                if dm:
                    routine = dm.group(1)
                    break
            entrees.append((y, x, em.group(3), routine))
        blocs[label] = entrees
    return blocs


def extraire_sections(txt):
    """Retourne (liste des cartes de HiddenObjectMaps, liste des pointeurs dw)."""
    debut = txt.find("HiddenObjectMaps:")
    pivot = txt.find("HiddenObjectPointers:")
    if debut < 0 or pivot < 0:
        sys.exit("Sections HiddenObjectMaps / HiddenObjectPointers introuvables.")
    cartes = [m.group(1) for m in re.finditer(
        r"^\s*db\s+([A-Z0-9_]+)\s*(?:;.*)?$", txt[debut:pivot], re.M)]
    fin = re.search(r"\n\s*;\s*format\s*:", txt[pivot:], re.I)
    zone = txt[pivot: pivot + fin.start()] if fin else txt[pivot: pivot + 6000]
    pointeurs = [m.group(1) for m in re.finditer(r"^\s*dw\s+([A-Za-z0-9_]+)", zone, re.M)]
    return cartes, pointeurs

# ------------------------------------------------------------------ assemblage

def collecter(cartes, pointeurs, blocs, items, pieces):
    """Constitue, par carte, la liste des marqueurs à dessiner."""
    par_carte = {}
    # index global (ordre du fichier = index du flag) pour objets et pièces
    items_index = {(c, y, x): i + 1 for i, (c, y, x) in enumerate(items)}
    pieces_index = {(c, y, x): i + 1 for i, (c, y, x) in enumerate(pieces)}

    if len(cartes) != len(pointeurs):
        print(f"! Avertissement : {len(cartes)} cartes mais {len(pointeurs)} "
              "pointeurs dans hidden_objects.asm (fichier modifié ?)")

    # détail (nom de l'objet) récupéré depuis les blocs
    detail_items = {}
    detail_pieces = {}
    for carte, pointeur in zip(cartes, pointeurs):
        for y, x, detail, routine in blocs.get(pointeur, []):
            if routine == "HiddenItems":
                detail_items[(carte, y, x)] = detail
            elif routine == "HiddenCoins":
                detail_pieces[(carte, y, x)] = detail

    for carte, pointeur in zip(cartes, pointeurs):
        marqueurs = []
        # objets au sol : ordre du fichier hidden_item_coords pour cette carte
        numero = 0
        for c, y, x in items:
            if c != carte:
                continue
            numero += 1
            marqueurs.append({
                "type": "objet", "numero": numero,
                "global": items_index[(c, y, x)],
                "y": y, "x": x,
                "detail": detail_items.get((carte, y, x), ""),
                "routine": "HiddenItems",
            })
        # pièces cachées : ordre du fichier hidden_coins pour cette carte
        numero = 0
        for c, y, x in pieces:
            if c != carte:
                continue
            numero += 1
            marqueurs.append({
                "type": "piece", "numero": numero,
                "global": pieces_index[(c, y, x)],
                "y": y, "x": x,
                "detail": detail_pieces.get((carte, y, x), ""),
                "routine": "HiddenCoins",
            })
        # interactifs : ordre d'apparition dans le bloc de la carte
        numero = 0
        for y, x, detail, routine in blocs.get(pointeur, []):
            if routine in ("HiddenItems", "HiddenCoins"):
                continue
            numero += 1
            marqueurs.append({
                "type": "interactif", "numero": numero, "global": None,
                "y": y, "x": x, "detail": detail, "routine": routine,
            })
        par_carte[carte] = marqueurs
    return par_carte, detail_items, detail_pieces

# -------------------------------------------------------------------- dessin

def police(taille):
    try:
        return ImageFont.load_default(size=taille)
    except TypeError:  # Pillow < 10.1
        return ImageFont.load_default()


_POLICE_LEGENDE = None


def police_legende(taille=15):
    """Police de la légende : TTF (accents gérés) sinon police par défaut.

    Retourne (police, translitterer) : translitterer=True signifie qu'aucune
    police TTF n'a été trouvée et qu'il faut convertir les accents en ASCII
    (é -> e) pour éviter les caractères cassés.
    """
    global _POLICE_LEGENDE
    if _POLICE_LEGENDE is None:
        for nom in CANDIDATS_TTF:
            try:
                _POLICE_LEGENDE = (ImageFont.truetype(nom, taille), False)
                break
            except OSError:
                continue
        else:
            _POLICE_LEGENDE = (police(taille), True)
    return _POLICE_LEGENDE


def dessiner_badge(draw, cx, cy, rayon, couleur, numero, font):
    draw.ellipse([cx - rayon, cy - rayon, cx + rayon, cy + rayon],
                 fill=couleur, outline=(0, 0, 0, 255), width=1)
    bbox = draw.textbbox((0, 0), str(numero), font=font)
    w, h = bbox[2] - bbox[0], bbox[3] - bbox[1]
    draw.text((cx - w / 2 - bbox[0], cy - h / 2 - bbox[1]), str(numero),
              fill=(255, 255, 255, 255), font=font)


def ajouter_legende(img, entrees):
    """Ajoute sous l'image un bandeau blanc : « n° badge + nom » par entrée.

    entrees = [(numero, couleur, texte), ...] — les numéros sont les mêmes que
    ceux des badges sur la carte. Retour à la ligne automatique selon la largeur
    de l'image ; accents translittérés si aucune police TTF n'est disponible.
    """
    if not entrees:
        return img
    font, translitterer = police_legende()
    marge, ligne_h, rayon = 6, 26, 9
    if translitterer:
        entrees = [(n, c, t.translate(TRANSLIT)) for n, c, t in entrees]
    mesure = ImageDraw.Draw(Image.new("RGBA", (1, 1)))
    colonnes = [(num, coul, texte,
                 2 * rayon + 6 + mesure.textlength(texte, font=font) + 18)
                for num, coul, texte in entrees]
    # mise en page : retour à la ligne quand la largeur de l'image est dépassée
    lignes, courante, x = [], [], marge
    for col in colonnes:
        if courante and x + col[3] > img.width - marge:
            lignes.append(courante)
            courante, x = [], marge
        courante.append(col)
        x += col[3]
    if courante:
        lignes.append(courante)
    hauteur = 2 * marge + ligne_h * len(lignes)
    finale = Image.new("RGBA", (img.width, img.height + hauteur),
                      (255, 255, 255, 255))
    finale.paste(img, (0, 0))
    draw = ImageDraw.Draw(finale)
    for i, ligne in enumerate(lignes):
        cy = img.height + marge + ligne_h * i + ligne_h // 2
        x = marge
        for num, coul, texte, largeur in ligne:
            dessiner_badge(draw, x + rayon, cy, rayon, coul, num, font)
            bbox = draw.textbbox((0, 0), texte, font=font)
            h = bbox[3] - bbox[1]
            draw.text((x + 2 * rayon + 6, cy - h / 2 - bbox[1]), texte,
                      fill=(0, 0, 0, 255), font=font)
            x += largeur
    return finale

# ----------------------------------------------------------------------- main

def main():
    ap = argparse.ArgumentParser(
        description="Marque les cases des cartes contenant un objet caché, numérotées dans l'ordre.")
    ap.add_argument("--repo", help="racine du dépôt (détectée automatiquement sinon)")
    ap.add_argument("--maps", help="dossier contenant les PNG des cartes (détecté sinon)")
    ap.add_argument("--out", help="dossier d'export (défaut : hidden_objects_marques/ à côté du script)")
    ap.add_argument("--types", default="objets,pieces",
                    help="types à marquer : objets,pieces,interactifs ou tous (défaut : objets+pieces)")
    ap.add_argument("--numeration", choices=["carte", "global"], default="carte",
                    help="numéro affiché : ordre sur la carte (défaut) ou index global/flag")
    ap.add_argument("--sans-legende", action="store_true",
                    help="ne pas ajouter le bandeau de noms sous l'image")
    ap.add_argument("--taille-tuile", type=int, default=8,
                    help="taille d'une tuile en px (défaut : 8 ; détectée automatiquement "
                         "à partir des dimensions de la carte quand elles sont connues)")
    ap.add_argument("--decalage-x", type=int, default=0, help="décalage X en px (bordure éventuelle)")
    ap.add_argument("--decalage-y", type=int, default=0, help="décalage Y en px (bordure éventuelle)")
    args = ap.parse_args()

    bruts = {t.strip().lower() for t in args.types.split(",") if t.strip()}
    types = {t.rstrip("s") for t in bruts}
    if "tous" in types or "tout" in types:
        types = {"objet", "piece", "interactif"}
    inconnus = types - {"objet", "piece", "interactif"}
    if inconnus:
        sys.exit(f"Types inconnus : {', '.join(sorted(inconnus))} (attendus : objets, pieces, interactifs, tous)")

    depot = Path(args.repo).resolve() if args.repo else trouver_depot()
    print(f"Dépôt : {depot}")

    # ---- lecture des sources
    dims = parse_dimensions_cartes(lire(depot / "constants/map_constants.asm"))
    stems = scan_entetes(depot / "data/maps/headers")
    info_cartes = {nom: {"fichier": stem, "dims": dims.get(nom, (None, None))}
                   for nom, stem in stems.items()}

    txt_ho = lire(depot / "data/items/hidden_objects.asm")
    cartes_maps, pointeurs = extraire_sections(txt_ho)
    blocs = parse_blocs_hidden_objects(txt_ho)
    items = parse_liste_coords(lire(depot / "data/items/hidden_item_coords.asm"))
    pieces = parse_liste_coords(lire(depot / "data/items/hidden_coins.asm"))

    # noms français des objets (légende + colonne « nom » du CSV)
    ids_items = parse_constantes_items(lire(depot / "constants/item_constants.asm"))
    noms_items = parse_noms_items(lire(depot / "text/item_names.asm"))
    noms_tmhm = parse_noms_items(lire(depot / "text/tmhm_names.asm"))
    print(f"Noms d'objets : {len(noms_items)} noms FR (ItemNames), "
          f"{len(noms_tmhm)} noms CS/CT (tmhmNames).")
    if police_legende()[1]:
        print("i Police TTF introuvable (DejaVu, Arial, Liberation...) : les noms "
              "de la légende seront translittérés sans accents (é -> e) pour "
              "éviter tout souci d'encodage.")

    par_carte, detail_items, detail_pieces = collecter(cartes_maps, pointeurs, blocs, items, pieces)

    n_int = sum(1 for l in par_carte.values() for m in l if m["type"] == "interactif")
    print(f"Lu : {len(items)} objets au sol, {len(pieces)} pièces cachées, {n_int} interactifs, "
          f"{len(blocs)} blocs pour {len(cartes_maps)} cartes.")

    # ---- recoupement objets <-> flags (bonus)
    cles_items = {(c, y, x) for c, y, x in items}
    cles_pieces = {(c, y, x) for c, y, x in pieces}
    for carte, y, x in items:
        if (carte, y, x) not in detail_items and carte in info_cartes:
            print(f"!! {carte} : objet ({y},{x}) déclaré dans hidden_item_coords "
                  "sans entrée dans hidden_objects.asm => introuvable en jeu.")
    for (carte, y, x), detail in detail_items.items():
        if (carte, y, x) not in cles_items:
            print(f"!! {carte} : entrée bloc ({y},{x}) {detail} absente de hidden_item_coords "
                  "=> pas de flag, objet réobtensible à l'infini.")
    for (carte, y, x), detail in detail_pieces.items():
        if (carte, y, x) not in cles_pieces:
            print(f"!! {carte} : entrée bloc ({y},{x}) {detail} absente de hidden_coins "
                  "=> pas de flag, pièce réobtenable à l'infini.")

    # ---- dossier des PNG
    dossier_script = Path(__file__).resolve().parent
    candidats = []
    if args.maps:
        candidats.append(Path(args.maps))
    else:
        candidats += [depot / "screenshots/Maps",
                      dossier_script / "Maps",
                      dossier_script / "screenshots/Maps",
                      Path.cwd() / "Maps"]
    dossier_maps = next((c for c in candidats if c.is_dir()), None)
    if dossier_maps is None:
        print("\nAucun dossier de PNG trouvé : passez --maps CHEMIN "
              "(exportez d'abord vos captures).\nLe CSV récapitulatif est quand même généré.")

    pngs = {}
    if dossier_maps is not None:
        for f in dossier_maps.iterdir():
            if f.suffix.lower() == ".png":
                pngs[f.stem.lower()] = f

    dossier_out = Path(args.out) if args.out else dossier_script / "../screenshots/HiddenObjects"
    dossier_out.mkdir(parents=True, exist_ok=True)

    # ---- marquage
    lignes_csv, marquees, sans_png = [], 0, []
    for carte, marqueurs in par_carte.items():
        if carte not in info_cartes:
            print(f"! Constante de carte inconnue : {carte}")
            continue
        marqueurs = [m for m in marqueurs if m["type"] in types]
        if not marqueurs:
            continue
        for m in marqueurs:
            m["nom"] = libelle_marqueur(m, ids_items, noms_items, noms_tmhm)
        stem = info_cartes[carte]["fichier"]
        source = pngs.get(stem)
        if source is None:
            sans_png.append(f"{carte} ({stem}.png)")
            for m in marqueurs:
                lignes_csv.append({"carte": carte, "png": "", "type": m["type"],
                                   "numero_carte": m["numero"], "numero_global": m["global"] or "",
                                   "y": m["y"], "x": m["x"], "detail": m["detail"],
                                   "nom": m["nom"], "routine": m["routine"]})
            continue

        h_blocs, w_blocs = info_cartes[carte]["dims"]
        if h_blocs and w_blocs:
            for m in marqueurs:
                if m["y"] > 2 * h_blocs - 1 or m["x"] > 2 * w_blocs - 1:
                    print(f"!! {carte} : {m['type']} n°{m['numero']} ({m['detail']}) en "
                          f"({m['y']},{m['x']}) hors des limites ({h_blocs}x{w_blocs} blocs) "
                          "=> jamais déclenchable en jeu.")

        img = Image.open(source).convert("RGBA")

        # taille d'une tuile dans le PNG : déduite des dimensions de la carte
        taille = args.taille_tuile
        if w_blocs and h_blocs:
            detectee, reste = divmod(img.size[0], w_blocs * 2)
            if reste == 0 and detectee > 0 and img.size[1] == h_blocs * 2 * detectee:
                if detectee != args.taille_tuile:
                    print(f"i {stem}.png : capture à {detectee} px/tuile "
                          f"(--taille-tuile {args.taille_tuile} ignorée).")
                taille = detectee
            else:
                print(f"! {stem}.png : {img.size[0]}x{img.size[1]} px ne correspond pas "
                      f"aux {w_blocs}x{h_blocs} blocs de la carte — on garde "
                      f"--taille-tuile {args.taille_tuile} et les décalages tels quels.")

        draw = ImageDraw.Draw(img)
        font = police(max(11, round(taille * 0.9)))
        rayon = max(6, round(taille * 0.75))
        entrees_legende = []
        for m in sorted(marqueurs, key=lambda m: (m["y"], m["x"])):
            cx = args.decalage_x + m["x"] * taille + taille // 2
            cy = args.decalage_y + m["y"] * taille + taille // 2
            lignes_csv.append({"carte": carte, "png": source.name, "type": m["type"],
                               "numero_carte": m["numero"], "numero_global": m["global"] or "",
                               "y": m["y"], "x": m["x"], "detail": m["detail"],
                               "nom": m["nom"], "routine": m["routine"]})
            numero = (m["global"] if args.numeration == "global" and m["global"]
                      else m["numero"])
            entrees_legende.append((numero, COULEURS[m["type"]], m["nom"],
                                    ORDRE_TYPES[m["type"]]))
            if not (0 <= cx < img.width and 0 <= cy < img.height):
                continue  # badge en dehors de l'image (coordonnées hors limites)
            dessiner_badge(draw, cx, cy, rayon, COULEURS[m["type"]], numero, font)
        if not args.sans_legende:
            entrees_legende.sort(key=lambda e: (e[0], e[3]))
            img = ajouter_legende(img,
                                  [(n, c, t) for n, c, t, _ in entrees_legende])
        img.save(dossier_out / source.name)
        marquees += 1

    # ---- CSV
    csv_path = dossier_out / "hidden_objects.csv"
    with open(csv_path, "w", newline="", encoding="utf-8-sig") as f:
        colonnes = ["carte", "png", "type", "numero_carte", "numero_global",
                    "y", "x", "detail", "nom", "routine"]
        w = csv.DictWriter(f, fieldnames=colonnes, delimiter=";")
        w.writeheader()
        w.writerows(lignes_csv)

    print(f"\n{marquees} cartes marquées dans {dossier_out}")
    print(f"Récapitulatif : {csv_path} ({len(lignes_csv)} entrées)")
    if sans_png:
        print(f"{len(sans_png)} carte(s) sans PNG correspondant "
              "(liste dans le CSV, colonne png vide) :")
        for s in sans_png:
            print(f"   - {s}")
    print("Types marqués : " + ", ".join(sorted(types)) +
          f" — numérotation : {args.numeration}")


if __name__ == "__main__":
    main()