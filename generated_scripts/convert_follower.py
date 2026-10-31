#!/usr/bin/env python3
r"""
Convert follower sprite sheets to gen1 layout PNGs + generate the ROM data file.

Run FROM THE REPO ROOT (same folder as the makefile):
  python generated_scripts/convert_follower.py <folder of the source PNGs>
e.g.
  python generated_scripts/convert_follower.py C:\pokemon\png\follower

Only the PNG folder is passed on the command line; every output path and
the ROM banks are the constants directly below (edit them if needed).

Source PNGs (one per species, named after the internal species constant in
constants/pokemon_constants.asm, lowercase with underscores:
bulbasaur.png, mr_mime.png, nidoran_m.png, hooh.png, ...):
  48x32 pixels, a 3x2 grid of exact 16x16 frames, no padding.
    row 0 (top):     standing frames, columns = down / up / left
    row 1 (bottom):  walking frames,  columns = down / up / left
  Each frame is cropped to its bounding box and placed bottom-centered
  into the 16x16 output frame (identity for full-frame art).
  Colors like NPC sprites: white (or transparent) + light gray + dark gray
  + black. White/transparent = color 0.
  Right-facing is the OAM mirror of the left frame (gen1 behavior).

Output:
  gfx/follower/<name>.png
    Indexed PNG, 16x96: the six 16x16 frames stacked vertically in gen1
    walking-NPC sheet order: down/up/left standing, then down/up/left
    walking. Scanned by rgbgfx (row-major tiles) this yields the tile order
    the engine expects: 4 tiles per frame (TL,TR,BL,BR), 24 tiles total.
    The palette is [white, light gray, dark gray, black] = indices 0-3,
    which rgbgfx 0.6.0 preserves (PLTE order).
  data/follower_sheets.asm
    FollowerSheetTable:: indexed by the internal species ID (entry 0
    unused, 4 bytes per entry: dw data, db ROM bank, db reserved) + the
    INCBINs, packed into SECTIONs across the banks listed in BANKS.
    A species without a PNG gets a null entry: no follower is displayed.

The .2bpp files are NOT written by this script: the makefile's generic
"%.2bpp: %.png" rule (rgbgfx) builds them from these PNGs, INCBIN'd by the
generated asm. Do not commit the .2bpp files ("make clean" removes them).

Requires: Pillow (pip install pillow).
"""
import argparse
import os
import sys

try:
    from PIL import Image
except ImportError:
    sys.exit("Pillow is required: pip install pillow")

# ---- edit these if needed -----------------------------------------------
GFX_DIR = "../gfx/pokemon/follower"                # 2bpp output folder (repo-root relative)
ASM_OUT = "../data/pokemons/follower_sheets.asm"    # generated asm file
BANKS = [70, 71, 72, 73, 74]            # free ROM banks for the sheets (~5 for 190)
# -------------------------------------------------------------------------

# Indexed-PNG palette: PLTE order = color index order (rgbfx 0.6.0 uses it).
# White, light gray, dark gray, black -> gen1 NPC colors 0-3.
PALETTE = [
    0xFF, 0xFF, 0xFF,
    0xAA, 0xAA, 0xAA,
    0x55, 0x55, 0x55,
    0x00, 0x00, 0x00,
]

SRC_W, SRC_H = 48, 32    # source sheet size
CELL = 16               # cell size (exact 16x16 frames, no padding)
FRAME = 16              # gen1 NPC frame size
OUT_W, OUT_H = 16, 96   # output sheet: 6 frames of 16x16 stacked vertically

# Internal species order from constants/pokemon_constants.asm ($01-$BE).
# Index 0 is unused (species 0). Do not reorder: the index IS the species ID.
SPECIES = [None,
    "RHYDON", "KANGASKHAN", "NIDORAN_M", "CLEFAIRY", "SPEAROW", "VOLTORB",         # $01-$06
    "NIDOKING", "SLOWBRO", "IVYSAUR", "EXEGGUTOR", "LICKITUNG", "EXEGGCUTE",       # $07-$0C
    "GRIMER", "GENGAR", "NIDORAN_F", "NIDOQUEEN", "CUBONE", "RHYHORN",             # $0D-$12
    "LAPRAS", "ARCANINE", "MEW", "GYARADOS", "SHELLDER", "TENTACOOL", "GASTLY",    # $13-$19
    "SCYTHER", "STARYU", "BLASTOISE", "PINSIR", "TANGELA", "STEELIX", "SCIZOR",    # $1A-$20
    "GROWLITHE", "ONIX", "FEAROW", "PIDGEY", "SLOWPOKE", "KADABRA", "GRAVELER",   # $21-$27
    "CHANSEY", "MACHOKE", "MR_MIME", "HITMONLEE", "HITMONCHAN", "ARBOK",           # $28-$2D
    "PARASECT", "PSYDUCK", "DROWZEE", "GOLEM", "UMBREON", "MAGMAR", "KINGDRA",     # $2E-$34
    "ELECTABUZZ", "MAGNETON", "KOFFING", "SNEASEL", "MANKEY", "SEEL", "DIGLETT",   # $35-$3B
    "TAUROS", "MISDREAVUS", "LARVITAR", "PUPITAR", "FARFETCHD", "VENONAT",         # $3C-$41
    "DRAGONITE", "TYRANITAR", "HOOH", "MISSINGNO", "DODUO", "POLIWAG", "JYNX",     # $42-$48
    "MOLTRES", "ARTICUNO", "ZAPDOS", "DITTO", "MEOWTH", "KRABBY", "MAROWRATH",     # $49-$4F
    "HERACROSS", "CROBAT", "VULPIX", "NINETALES", "PIKACHU", "RAICHU", "HOUNDOUR", # $50-$56
    "HOUNDOOM", "DRATINI", "DRAGONAIR", "KABUTO", "KABUTOPS", "HORSEA", "SEADRA",  # $57-$5D
    "MEWTWO_ARMOR", "GOROCHU", "SANDSHREW", "SANDSLASH", "OMANYTE", "OMASTAR",     # $5E-$63
    "JIGGLYPUFF", "WIGGLYTUFF", "EEVEE", "FLAREON", "JOLTEON", "VAPOREON",        # $64-$69
    "MACHOP", "ZUBAT", "EKANS", "PARAS", "POLIWHIRL", "POLIWRATH", "WEEDLE",       # $6A-$70
    "KAKUNA", "BEEDRILL", "SLUGMA", "DODRIO", "PRIMEAPE", "DUGTRIO", "VENOMOTH",   # $71-$77
    "DEWGONG", "MAGCARGO", "SLOWKING", "CATERPIE", "METAPOD", "BUTTERFREE",        # $78-$7D
    "MACHAMP", "LICKILICKY", "GOLDUCK", "HYPNO", "GOLBAT", "MEWTWO", "SNORLAX",    # $7E-$84
    "MAGIKARP", "TANGROWTH", "MARILL", "MUK", "AZUMARILL", "KINGLER", "CLOISTER",  # $85-$8B
    "PLUX", "ELECTRODE", "CLEFABLE", "WEEZING", "PERSIAN", "MAROWAK", "ANCHORAGE", # $8C-$92
    "HAUNTER", "ABRA", "ALAKAZAM", "PIDGEOTTO", "PIDGEOT", "STARMIE", "BULBASAUR", # $93-$99
    "VENUSAUR", "TENTACRUEL", "ESPEON", "GOLDEEN", "SEAKING", "LUGIA", "WOLFMAN",  # $9A-$A0
    "WARWOLF", "ANNIHILAPE", "PONYTA", "RAPIDASH", "RATTATA", "RATICATE",          # $A1-$A6
    "NIDORINO", "NIDORINA", "GEODUDE", "PORYGON", "AERODACTYL", "BLASTOISE_S",     # $A7-$AC
    "MAGNEMITE", "MAGMAR_S", "VENUSAUR_S", "CHARMANDER", "SQUIRTLE", "CHARMELEON", # $AD-$B2
    "WARTORTLE", "CHARIZARD", "CHARIZARD_S", "ELECTABUZZ_S", "NINETALES_S",        # $B3-$B7
    "SCIZOR_S", "ODDISH", "GLOOM", "VILEPLUME", "BELLSPROUT", "WEEPINBELL",        # $B8-$BD
    "VICTREEBEL",                                                                 # $BE
]
assert len(SPECIES) == 191, "SPECIES list must have 191 entries (unused 0 + $01-$BE)"


def lum(c):
    return c[0] + c[1] + c[2]


def load_indices(img, path):
    """Return a 2D list of 2bpp color indices for the whole source image."""
    img = img.convert("RGBA")
    if img.size != (SRC_W, SRC_H):
        sys.exit("bad size %s (expected %dx%d): %s" % (img.size, SRC_W, SRC_H, path))
    counts = {}
    px = img.load()
    for y in range(SRC_H):
        for x in range(SRC_W):
            r, g, b, a = px[x, y]
            if a >= 128 and (r, g, b) != (255, 255, 255):
                counts[(r, g, b)] = counts.get((r, g, b), 0) + 1
    if len(counts) > 3:
        sys.exit("too many colors (%d) in %s: %s" % (len(counts), path, sorted(counts)))
    # luminance descending -> 1 (light gray), 2 (dark gray), 3 (black)
    pal = {c: i + 1 for i, c in enumerate(sorted(counts, key=lambda c: -lum(c)))}
    grid = [[0] * SRC_W for _ in range(SRC_H)]
    for y in range(SRC_H):
        for x in range(SRC_W):
            r, g, b, a = px[x, y]
            if a >= 128 and (r, g, b) != (255, 255, 255):
                grid[y][x] = pal[(r, g, b)]
    return grid


def extract_frame(grid, row, col):
    """Crop one 16x16 cell to its bounding box and place it bottom-centered
    into a 16x16 output frame."""
    x0, y0 = col * CELL, row * CELL
    cell = [r[x0:x0 + CELL] for r in grid[y0:y0 + CELL]]
    xs = [x for y, r in enumerate(cell) for x, v in enumerate(r) if v]
    ys = [y for y, r in enumerate(cell) for x, v in enumerate(r) if v]
    frame = [[0] * FRAME for _ in range(FRAME)]
    if not xs:
        return frame, False
    bx0, bx1, by0, by1 = min(xs), max(xs), min(ys), max(ys)
    w, h = bx1 - bx0 + 1, by1 - by0 + 1
    if w > FRAME or h > FRAME:
        sys.exit("cell drawing is %dx%d, exceeds 16x16" % (w, h))
    ox, oy = (FRAME - w) // 2, FRAME - h  # bottom-aligned, horizontally centered
    for y in range(h):
        for x in range(w):
            frame[oy + y][ox + x] = cell[by0 + y][bx0 + x]
    return frame, True


def label_for(name):
    return "".join(p.capitalize() for p in name.split("_")) + "FollowerSheet"


def main():
    ap = argparse.ArgumentParser(
        description="Convert follower PNGs (48x32) to gen1 layout PNGs (16x96, indexed) "
                    "+ the ROM data file. Run from the repo root; outputs go to %s and %s."
                    % (GFX_DIR, ASM_OUT))
    ap.add_argument("src", help="folder containing the 48x32 source PNGs")
    args = ap.parse_args()

    os.makedirs(GFX_DIR, exist_ok=True)
    # (species id, name, label or None for "no sheet")
    entries = [(0, None, None)]
    converted, missing = [], []

    for sid, name in enumerate(SPECIES):
        if sid == 0:
            continue
        path = os.path.join(args.src, name.lower() + ".png")
        if not os.path.exists(path):
            missing.append(name)
            entries.append((sid, name, None))
            continue
        grid = load_indices(Image.open(path), path)
        # standing row 0, walking row 1; columns down / up / left
        # output frame order (gen1 sheet): down/up/left standing, down/up/left walking
        frames = [(0, 0), (0, 1), (0, 2), (1, 0), (1, 1), (1, 2)]
        sheet = [[0] * OUT_W for _ in range(OUT_H)]
        ok = True
        for i, (row, col) in enumerate(frames):
            frame, drawn = extract_frame(grid, row, col)
            ok = ok and drawn
            for y in range(FRAME):
                sheet[i * FRAME + y] = frame[y][:]
        if not ok:
            print("warning: %s has empty frames" % name)
        img = Image.new("P", (OUT_W, OUT_H))
        img.putdata([v for row in sheet for v in row])
        img.putpalette(PALETTE)
        img.save(os.path.join(GFX_DIR, name.lower() + ".png"))
        converted.append(name)
        entries.append((sid, name, label_for(name)))

    # ---- generate the asm file ----
    BANK_SIZE = 0x4000
    # One sheet = 24 tiles x 16 bytes = 384 bytes (2bpp packs 4 pixels per byte).
    SHEET_BYTES = OUT_W * OUT_H // 4
    sheets_here = [e for e in entries if e[2]]
    caps = [(BANK_SIZE - 191 * 4) // SHEET_BYTES] + \
           [BANK_SIZE // SHEET_BYTES] * (len(BANKS) - 1)
    if len(sheets_here) > sum(caps):
        sys.exit("not enough banks: %d sheets, given banks hold %d"
                 % (len(sheets_here), sum(caps)))
    lines = [
        "; Follower sprite sheets - generated by generated_scripts/follower_gfx.py, do not edit.",
        "; Indexed by the internal species ID (entry 0 = species 0, unused).",
        "; Entry: dw sheet data, db ROM bank, db reserved (future use, e.g. GBC palette).",
        "; A null entry (dw 0 / db 0) means the species has no follower sheet:",
        "; nothing is displayed until a PNG is added and the script is re-run.",
        "; The INCBIN'd .2bpp files are built by make from gfx/follower/*.png (rgbgfx).",
        "",
    ]
    si = 0
    for bi, bank in enumerate(BANKS):
        lines.append('SECTION "Follower sheets %d", ROMX[$4000], BANK[%d]' % (bi + 1, bank))
        if bi == 0:
            lines.append("FollowerSheetTable::")
            for sid, name, label in entries:
                if label:
                    lines.append("\tdw %s" % label)
                    lines.append("\tdb BANK(%s)" % label)
                    lines.append("\tdb $00 ; reserved")
                else:
                    comment = "; %s: no sheet" % name if name else "; species 0 (unused)"
                    lines.append("\tdw $0000 %s" % comment)
                    lines.append("\tdb $00")
                    lines.append("\tdb $00")
            lines.append("FollowerSheetTableEnd::")
            lines.append("")
        for _ in range(caps[bi]):
            if si >= len(sheets_here):
                break
            sid, name, label = sheets_here[si]
            lines.append('%s:: INCBIN "gfx/pokemon/follower/%s.2bpp"' % (label, name.lower()))
            si += 1
        lines.append("")
    with open(ASM_OUT, "w", newline="\n") as f:
        f.write("\n".join(lines) + "\n")

    print("converted %d sheets, %d species without sheet: %s"
          % (len(converted), len(missing), ", ".join(missing) or "none"))
    print("wrote %s and %s (the .2bpp files are generated by make)" % (ASM_OUT, GFX_DIR))


if __name__ == "__main__":
    main()