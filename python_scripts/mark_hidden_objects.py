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
  - <carte>.png         : capture marquée
  - legende.png         : légende des couleurs
  - hidden_objects.csv  : récapitulatif (séparateur « ; », ouvrable dans Excel)

Utilisation :
  python mark_hidden_objects.py                       # tout en automatique
  python mark_hidden_objects.py --maps CHEMIN         # dossier des PNG
  python mark_hidden_objects.py --types objets        # objets au sol uniquement
  python mark_hidden_objects.py --types tous          # + interactifs (bleus)
  python mark_hidden_objects.py --numeration global   # flags plutôt qu'ordre local

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


def dessiner_badge(draw, cx, cy, rayon, couleur, numero, font):
    draw.ellipse([cx - rayon, cy - rayon, cx + rayon, cy + rayon],
                 fill=couleur, outline=(0, 0, 0, 255), width=1)
    bbox = draw.textbbox((0, 0), str(numero), font=font)
    w, h = bbox[2] - bbox[0], bbox[3] - bbox[1]
    draw.text((cx - w / 2 - bbox[0], cy - h / 2 - bbox[1]), str(numero),
              fill=(255, 255, 255, 255), font=font)


def creer_legende(chemin, types):
    """Légende des couleurs, limitée aux types marqués."""
    ordonnes = [t for t in ("objet", "piece", "interactif") if t in types]
    img = Image.new("RGBA", (360, 40 + 30 * len(ordonnes)), (255, 255, 255, 255))
    draw = ImageDraw.Draw(img)
    font = police(14)
    draw.text((10, 8), "Légende", fill=(0, 0, 0, 255), font=font)
    for i, type_ in enumerate(ordonnes):
        y = 40 + 30 * i
        dessiner_badge(draw, 26, y, 11, COULEURS[type_], 1, police(13))
        draw.text((46, y - 8), LIBELLES[type_], fill=(0, 0, 0, 255), font=font)
    img.save(chemin)

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
    creer_legende(dossier_out / "legende.png", types)

    # ---- marquage
    lignes_csv, marquees, sans_png = [], 0, []
    for carte, marqueurs in par_carte.items():
        if carte not in info_cartes:
            print(f"! Constante de carte inconnue : {carte}")
            continue
        marqueurs = [m for m in marqueurs if m["type"] in types]
        if not marqueurs:
            continue
        stem = info_cartes[carte]["fichier"]
        source = pngs.get(stem)
        if source is None:
            sans_png.append(f"{carte} ({stem}.png)")
            for m in marqueurs:
                lignes_csv.append({"carte": carte, "png": "", "type": m["type"],
                                   "numero_carte": m["numero"], "numero_global": m["global"] or "",
                                   "y": m["y"], "x": m["x"], "detail": m["detail"],
                                   "routine": m["routine"]})
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
        for m in sorted(marqueurs, key=lambda m: (m["y"], m["x"])):
            cx = args.decalage_x + m["x"] * taille + taille // 2
            cy = args.decalage_y + m["y"] * taille + taille // 2
            lignes_csv.append({"carte": carte, "png": source.name, "type": m["type"],
                               "numero_carte": m["numero"], "numero_global": m["global"] or "",
                               "y": m["y"], "x": m["x"], "detail": m["detail"],
                               "routine": m["routine"]})
            if not (0 <= cx < img.width and 0 <= cy < img.height):
                continue  # badge en dehors de l'image (coordonnées hors limites)
            numero = (m["global"] if args.numeration == "global" and m["global"]
                      else m["numero"])
            dessiner_badge(draw, cx, cy, rayon, COULEURS[m["type"]], numero, font)
        img.save(dossier_out / source.name)
        marquees += 1

    # ---- CSV
    csv_path = dossier_out / "hidden_objects.csv"
    with open(csv_path, "w", newline="", encoding="utf-8-sig") as f:
        colonnes = ["carte", "png", "type", "numero_carte", "numero_global",
                    "y", "x", "detail", "routine"]
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