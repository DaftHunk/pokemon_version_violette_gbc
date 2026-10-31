#!/usr/bin/env python3
"""
Slice a giant follower sprite sheet into one 48x32 PNG per Pokémon.

Run:
  python generated_scripts/slice_follower_sheet.py <giant_sheet.png> [output_folder]
e.g.
  python generated_scripts/slice_follower_sheet.py C:\pokemon\png\giant_sheet.png

Layout of the giant sheet (blocks glued, no gap), national Pokédex order
1-251 (Bulbasaur...Celebi), read row-major (left to right, then top to
bottom; use --by-column if it is filled column by column instead):
  each block is an exact 48x32 cell:
    row 0: standing frames, columns = down / up / left
    row 1: walking frames,  columns = down / up / left

Output files are named after the ROM's internal species constants in
lowercase (mr_mime.png, hooh.png, nidoran_m.png, cloister.png...) so
follower_gfx.py picks them up directly as its --src folder.
Pokémon absent from the ROM species list keep their standard lowercase
name; follower_gfx.py simply ignores those.

Requires: Pillow (pip install pillow).
"""
import argparse
import os
import sys

try:
    from PIL import Image
except ImportError:
    sys.exit("Pillow is required: pip install pillow")

# ---- edit this if needed -------------------------------------------------
OUT_DIR = "follower_png"    # default output folder
# ---------------------------------------------------------------------------

CELL_W, CELL_H = 48, 32    # one Pokémon block = 3x2 grid of 16x16 frames

# National dex 1-251, canonical uppercase names (forms use the ROM style:
# NIDORAN_F, NIDORAN_M, MR_MIME, FARFETCHD, HOOH).
NATIONAL = [
    # 1-50
    "BULBASAUR", "IVYSAUR", "VENUSAUR", "CHARMANDER", "CHARMELEON",
    "CHARIZARD", "SQUIRTLE", "WARTORTLE", "BLASTOISE", "CATERPIE",
    "METAPOD", "BUTTERFREE", "WEEDLE", "KAKUNA", "BEEDRILL",
    "PIDGEY", "PIDGEOTTO", "PIDGEOT", "RATTATA", "RATICATE",
    "SPEAROW", "FEAROW", "EKANS", "ARBOK", "PIKACHU",
    "RAICHU", "SANDSHREW", "SANDSLASH", "NIDORAN_F", "NIDORINA",
    "NIDOQUEEN", "NIDORAN_M", "NIDORINO", "NIDOKING", "CLEFAIRY",
    "CLEFABLE", "VULPIX", "NINETALES", "JIGGLYPUFF", "WIGGLYTUFF",
    "ZUBAT", "GOLBAT", "ODDISH", "GLOOM", "VILEPLUME",
    "PARAS", "PARASECT", "VENONAT", "VENOMOTH", "DIGLETT",
    # 51-100
    "DUGTRIO", "MEOWTH", "PERSIAN", "PSYDUCK", "GOLDUCK",
    "MANKEY", "PRIMEAPE", "GROWLITHE", "ARCANINE", "POLIWAG",
    "POLIWHIRL", "POLIWRATH", "ABRA", "KADABRA", "ALAKAZAM",
    "MACHOP", "MACHOKE", "MACHAMP", "BELLSPROUT", "WEEPINBELL",
    "VICTREEBEL", "TENTACOOL", "TENTACRUEL", "GEODUDE", "GRAVELER",
    "GOLEM", "PONYTA", "RAPIDASH", "SLOWPOKE", "SLOWBRO",
    "MAGNEMITE", "MAGNETON", "FARFETCHD", "DODUO", "DODRIO",
    "SEEL", "DEWGONG", "GRIMER", "MUK", "SHELLDER",
    "CLOYSTER", "GASTLY", "HAUNTER", "GENGAR", "ONIX",
    "DROWZEE", "HYPNO", "KRABBY", "KINGLER", "VOLTORB",
    # 101-151
    "ELECTRODE", "EXEGGCUTE", "EXEGGUTOR", "CUBONE", "MAROWAK",
    "HITMONLEE", "HITMONCHAN", "LICKITUNG", "KOFFING", "WEEZING",
    "RHYHORN", "RHYDON", "CHANSEY", "TANGELA", "KANGASKHAN",
    "HORSEA", "SEADRA", "GOLDEEN", "SEAKING", "STARYU",
    "STARMIE", "MR_MIME", "SCYTHER", "JYNX", "ELECTABUZZ",
    "MAGMAR", "PINSIR", "TAUROS", "MAGIKARP", "GYARADOS",
    "LAPRAS", "DITTO", "EEVEE", "VAPOREON", "JOLTEON",
    "FLAREON", "PORYGON", "OMANYTE", "OMASTAR", "KABUTO",
    "KABUTOPS", "AERODACTYL", "SNORLAX", "ARTICUNO", "ZAPDOS",
    "MOLTRES", "DRATINI", "DRAGONAIR", "DRAGONITE", "MEWTWO",
    "MEW",
    # 152-201 (gen 2)
    "CHIKORITA", "BAYLEEF", "MEGANIUM", "CYNDAQUIL", "QUILAVA",
    "TYPHLOSION", "TOTODILE", "CROCONAW", "FERALIGATR", "SENTRET",
    "FURRET", "HOOTHOOT", "NOCTOWL", "LEDYBA", "LEDIAN",
    "SPINARAK", "ARIADOS", "CROBAT", "CHINCHOU", "LANTURN",
    "PICHU", "CLEFFA", "IGGLYBUFF", "TOGEPI", "TOGETIC",
    "NATU", "XATU", "MAREEP", "FLAAFFY", "AMPHAROS",
    "BELLOSSOM", "MARILL", "AZUMARILL", "SUDOWOODO", "POLITOED",
    "HOPPIP", "SKIPLOOM", "JUMPLUFF", "AIPOM", "SUNKERN",
    "SUNFLORA", "YANMA", "WOOPER", "QUAGSIRE", "ESPEON",
    "UMBREON", "MURKROW", "SLOWKING", "MISDREAVUS", "UNOWN",
    "WOBBUFFET", "GIRAFARIG",
    # 202-251 (gen 2)
    "PINECO", "FORRETRESS", "DUNSPARCE", "GLIGAR", "STEELIX",
    "SNUBBULL", "GRANBULL", "QWILFISH", "SCIZOR", "SHUCKLE",
    "HERACROSS", "SNEASEL", "TEDDIURSA", "URSARING", "SLUGMA",
    "MAGCARGO", "SWINUB", "PILOSWINE", "CORSOLA", "REMORAID",
    "OCTILLERY", "DELIBIRD", "MANTINE", "SKARMORY", "HOUNDOUR",
    "HOUNDOOM", "KINGDRA", "PHANPY", "DONPHAN", "PORYGON2",
    "STANTLER", "SMEARGLE", "TYROGUE", "HITMONTOP", "SMOOCHUM",
    "ELEKID", "MAGBY", "MILTANK", "BLISSEY", "RAIKOU",
    "ENTEI", "SUICUNE", "LARVITAR", "PUPITAR", "TYRANITAR",
    "LUGIA", "HOOH", "CELEBI",
]
assert len(NATIONAL) == 251, "NATIONAL list must have exactly 251 entries"

# ROM internal species constants (order of constants/pokemon_constants.asm),
# used to name the output files so follower_gfx.py finds them.
HACK_SPECIES = [
    "RHYDON", "KANGASKHAN", "NIDORAN_M", "CLEFAIRY", "SPEAROW", "VOLTORB",
    "NIDOKING", "SLOWBRO", "IVYSAUR", "EXEGGUTOR", "LICKITUNG", "EXEGGCUTE",
    "GRIMER", "GENGAR", "NIDORAN_F", "NIDOQUEEN", "CUBONE", "RHYHORN",
    "LAPRAS", "ARCANINE", "MEW", "GYARADOS", "SHELLDER", "TENTACOOL", "GASTLY",
    "SCYTHER", "STARYU", "BLASTOISE", "PINSIR", "TANGELA", "STEELIX", "SCIZOR",
    "GROWLITHE", "ONIX", "FEAROW", "PIDGEY", "SLOWPOKE", "KADABRA", "GRAVELER",
    "CHANSEY", "MACHOKE", "MR_MIME", "HITMONLEE", "HITMONCHAN", "ARBOK",
    "PARASECT", "PSYDUCK", "DROWZEE", "GOLEM", "UMBREON", "MAGMAR", "KINGDRA",
    "ELECTABUZZ", "MAGNETON", "KOFFING", "SNEASEL", "MANKEY", "SEEL", "DIGLETT",
    "TAUROS", "MISDREAVUS", "LARVITAR", "PUPITAR", "FARFETCHD", "VENONAT",
    "DRAGONITE", "TYRANITAR", "HOOH", "MISSINGNO", "DODUO", "POLIWAG", "JYNX",
    "MOLTRES", "ARTICUNO", "ZAPDOS", "DITTO", "MEOWTH", "KRABBY", "MAROWRATH",
    "HERACROSS", "CROBAT", "VULPIX", "NINETALES", "PIKACHU", "RAICHU", "HOUNDOUR",
    "HOUNDOOM", "DRATINI", "DRAGONAIR", "KABUTO", "KABUTOPS", "HORSEA", "SEADRA",
    "MEWTWO_ARMOR", "GOROCHU", "SANDSHREW", "SANDSLASH", "OMANYTE", "OMASTAR",
    "JIGGLYPUFF", "WIGGLYTUFF", "EEVEE", "FLAREON", "JOLTEON", "VAPOREON",
    "MACHOP", "ZUBAT", "EKANS", "PARAS", "POLIWHIRL", "POLIWRATH", "WEEDLE",
    "KAKUNA", "BEEDRILL", "SLUGMA", "DODRIO", "PRIMEAPE", "DUGTRIO", "VENOMOTH",
    "DEWGONG", "MAGCARGO", "SLOWKING", "CATERPIE", "METAPOD", "BUTTERFREE",
    "MACHAMP", "LICKILICKY", "GOLDUCK", "HYPNO", "GOLBAT", "MEWTWO", "SNORLAX",
    "MAGIKARP", "TANGROWTH", "MARILL", "MUK", "AZUMARILL", "KINGLER", "CLOISTER",
    "PLUX", "ELECTRODE", "CLEFABLE", "WEEZING", "PERSIAN", "MAROWAK", "ANCHORAGE",
    "HAUNTER", "ABRA", "ALAKAZAM", "PIDGEOTTO", "PIDGEOT", "STARMIE", "BULBASAUR",
    "VENUSAUR", "TENTACRUEL", "ESPEON", "GOLDEEN", "SEAKING", "LUGIA", "WOLFMAN",
    "WARWOLF", "ANNIHILAPE", "PONYTA", "RAPIDASH", "RATTATA", "RATICATE",
    "NIDORINO", "NIDORINA", "GEODUDE", "PORYGON", "AERODACTYL", "BLASTOISE_S",
    "MAGNEMITE", "MAGMAR_S", "VENUSAUR_S", "CHARMANDER", "SQUIRTLE", "CHARMELEON",
    "WARTORTLE", "CHARIZARD", "CHARIZARD_S", "ELECTABUZZ_S", "NINETALES_S",
    "SCIZOR_S", "ODDISH", "GLOOM", "VILEPLUME", "BELLSPROUT", "WEEPINBELL",
    "VICTREEBEL",
]
HACK_SET = set(HACK_SPECIES)

# National canonical name -> ROM constant, where the two differ.
# (Cloyster's constant in the ROM is CLOISTER.)
RENAMES = {
    "CLOYSTER": "CLOISTER",
}


def count_colors(block):
    """Distinct non-transparent, non-white colors (NPC sprites allow 3)."""
    img = block.convert("RGBA")
    px = img.load()
    colors = set()
    for y in range(img.height):
        for x in range(img.width):
            r, g, b, a = px[x, y]
            if a >= 128 and (r, g, b) != (255, 255, 255):
                colors.add((r, g, b))
    return colors


def main():
    ap = argparse.ArgumentParser(
        description="Slice a giant national-order sheet (1-251) into 48x32 PNGs "
                    "named after the ROM's internal species constants.")
    ap.add_argument("src", help="the giant sprite sheet PNG")
    ap.add_argument("out", nargs="?", default=OUT_DIR,
                    help="output folder (default: %s)" % OUT_DIR)
    ap.add_argument("--by-column", action="store_true",
                    help="read the blocks column by column instead of row by row")
    args = ap.parse_args()

    img = Image.open(args.src)
    w, h = img.size
    if w % CELL_W or h % CELL_H:
        sys.exit("bad size %dx%d: not a multiple of %dx%d (glued blocks, no gap)"
                 % (w, h, CELL_W, CELL_H))
    cols, rows = w // CELL_W, h // CELL_H
    blocks = cols * rows
    if blocks < len(NATIONAL):
        sys.exit("found only %d blocks (%dx%d), need %d" % (blocks, cols, rows, len(NATIONAL)))
    if blocks > len(NATIONAL):
        print("warning: %d blocks found, only the first %d are used"
              % (blocks, len(NATIONAL)))

    os.makedirs(args.out, exist_ok=True)
    matched, extra, color_warnings = [], [], []

    for dex, name in enumerate(NATIONAL, start=1):
        if args.by_column:
            bx = (dex - 1) // rows
            by = (dex - 1) % rows
        else:
            bx = (dex - 1) % cols
            by = (dex - 1) // cols
        block = img.crop((bx * CELL_W, by * CELL_H,
                          (bx + 1) * CELL_W, (by + 1) * CELL_H))
        internal = RENAMES.get(name) or (name if name in HACK_SET else None)
        fname = (internal if internal else name).lower() + ".png"
        block.save(os.path.join(args.out, fname))
        if internal:
            matched.append(internal)
        else:
            extra.append(name)
        if len(count_colors(block)) > 3:
            color_warnings.append(fname)

    missing = sorted(HACK_SET - set(matched))
    print("wrote %d PNGs to %s" % (len(NATIONAL), args.out))
    print("%d match the ROM species list (used by follower_gfx.py)"
          % len(matched))
    print("%d are NOT in the ROM species list (ignored by follower_gfx.py): %s"
          % (len(extra), ", ".join(extra) or "none"))
    print("ROM species not covered by this sheet (no follower until you add "
          "their PNGs yourself): %s" % (", ".join(missing) or "none"))
    if color_warnings:
        print("warning: more than 3 colors (follower_gfx.py will reject them): %s"
              % ", ".join(color_warnings))


if __name__ == "__main__":
    main()