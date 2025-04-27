
MACRO lb ; r, hi, lo
	ld \1, ((\2) & $ff) << 8 + ((\3) & $ff) ;avoid left shift compiler warning ld \1, (\2) << 8 + ((\3) & $ff)
ENDM

MACRO homecall
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, BANK(\1)
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	call \1
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
ENDM

MACRO callbs	;joenote - added from pokeyellow
	ld a, BANK(\1)
	call BankswitchCommon
	call \1
	ENDM

farcall EQUS "callba"
MACRO callba
	ld b, BANK(\1)
	ld hl, \1
	rst _Bankswitch
ENDM

callfar EQUS "callab"
MACRO callab
	ld hl, \1
	ld b, BANK(\1)
	rst _Bankswitch
ENDM

farjp EQUS "jpba"
MACRO jpba
	ld b, BANK(\1)
	ld hl, \1
	jp Bankswitch
ENDM

jpfar EQUS "jpab"
MACRO jpab
	ld hl, \1
	ld b, BANK(\1)
	jp Bankswitch
ENDM

MACRO validateCoords
	IF \1 >= SCREEN_WIDTH
		fail "x coord out of range"
	ENDC
	IF \2 >= SCREEN_HEIGHT
		fail "y coord out of range"
	ENDC
ENDM

DEF hlcoord EQUS "coord hl,"
DEF bccoord EQUS "coord bc,"
DEF decoord EQUS "coord de,"

;\1 = r
;\2 = X
;\3 = Y
;\4 = which tilemap (optional)
MACRO coord
	validateCoords \2, \3
	IF _NARG >= 4
		ld \1, \4 + SCREEN_WIDTH * \3 + \2
	ELSE
		ld \1, wTileMap + SCREEN_WIDTH * \3 + \2
	ENDC
ENDM

DEF hlbgcoord EQUS "bgcoord hl,"
DEF bcbgcoord EQUS "bgcoord bc,"
DEF debgcoord EQUS "bgcoord de,"

MACRO bgcoord
; register, x, y[, origin]
	validate_coords \2, \3, BG_MAP_WIDTH, BG_MAP_HEIGHT
	IF _NARG >= 4
		ld \1, (\3) * BG_MAP_WIDTH + (\2) + \4
	ELSE
		ld \1, (\3) * BG_MAP_WIDTH + (\2) + vBGMap0
	ENDC
ENDM

DEF hlowcoord EQUS "overworldMapCoord hl,"
DEF bcowcoord EQUS "overworldMapCoord bc,"
DEF deowcoord EQUS "overworldMapCoord de,"

MACRO event_displacement
; map width, x blocks, y blocks
	dw (wOverworldMap + 7 + (\1) + ((\1) + 6) * ((\3) >> 1) + ((\2) >> 1))
	db \3, \2
ENDM

MACRO dbmapcoord
; x, y
	db \2, \1
ENDM

MACRO inc_hl_ycoord
	lb de, 0, SCREEN_WIDTH
	add hl, de
ENDM

;\1 = X
;\2 = Y
;\3 = which tilemap (optional)
MACRO aCoord ; lda_coord
	validateCoords \1, \2
	IF _NARG >= 3
		ld a, [\3 + SCREEN_WIDTH * \2 + \1]
	ELSE
		ld a, [wTileMap + SCREEN_WIDTH * \2 + \1]
	ENDC
ENDM

;\1 = X
;\2 = Y
;\3 = which tilemap (optional)
MACRO Coorda ; ldcoord_a
	validateCoords \1, \2
	IF _NARG >= 3
		ld [\3 + SCREEN_WIDTH * \2 + \1], a
	ELSE
		ld [wTileMap + SCREEN_WIDTH * \2 + \1], a
	ENDC
ENDM

;\1 = X
;\2 = Y
;\3 = which tilemap (optional)
MACRO dwCoord
	validateCoords \1, \2
	IF _NARG >= 3
		dw \3 + SCREEN_WIDTH * \2 + \1
	ELSE
		dw wTileMap + SCREEN_WIDTH * \2 + \1
	ENDC
ENDM

;\1 = r
;\2 = X
;\3 = Y
;\4 = map width
MACRO overworldMapCoord
	ld \1, wOverworldMap + ((\2) + 3) + (((\3) + 3) * ((\4) + (3 * 2)))
ENDM

; macro for two nibbles
MACRO dn
	db (\1 << 4 | \2)
ENDM

; macro for putting a byte then a word
MACRO dbw
	db \1
	dw \2
ENDM

MACRO dba
	dbw BANK(\1), \1
ENDM

MACRO dwb
	dw \1
	db \2
ENDM

MACRO dab
	dwb \1, BANK(\1)
ENDM

MACRO dbbw
	db \1, \2
	dw \3
ENDM

; Predef macro.
MACRO predef_const
	const \1PredefID
ENDM

MACRO add_predef
\1Predef::
	db BANK(\1)
	dw \1
ENDM

MACRO predef_id
	ld a, (\1Predef - PredefPointers) / 3
ENDM

MACRO predef
	predef_id \1
	call Predef
ENDM

MACRO predef_jump
	predef_id \1
	jp Predef
ENDM

MACRO tx_pre_const
	const \1_id
ENDM

MACRO add_tx_pre
\1_id:: dw \1
ENDM

MACRO db_tx_pre
	db (\1_id - TextPredefs) / 2 + 1
ENDM

MACRO tx_pre_id
	ld a, (\1_id - TextPredefs) / 2 + 1
ENDM

MACRO tx_pre
	tx_pre_id \1
	call PrintPredefTextID
ENDM

MACRO tx_pre_jump
	tx_pre_id \1
	jp PrintPredefTextID
ENDM

MACRO ldPal
	ld \1, \2 << 6 | \3 << 4 | \4 << 2 | \5
ENDM

; dereference the pointer argument into hl, if no argument just pull reference from hl
MACRO hl_deref
	IF _NARG > 0
		ld hl, \1
	ENDC
	ld a, [hli]
	ld h, [hl]
	ld l, a
ENDM

MACRO hl_deref_reverse
	IF _NARG > 0
		ld hl, \1 + 1
	ENDC
	ld a, [hld]
	ld h, [hl]
	ld l, a
ENDM

DEF tiles EQUS "* LEN_2BPP_TILE"
DEF tile  EQUS "+ LEN_2BPP_TILE *"

MACRO _redef_current_label
	IF DEF(\1)
		PURGE \1
	ENDC
	IF _NARG == 3 + (\3)
		DEF \1 EQUS "\<_NARG>"
	ELIF DEF(..)
		IF .. - @ == 0
			DEF \1 EQUS "{..}"
		ENDC
	ELIF DEF(.)
		if . - @ == 0
			DEF \1 EQUS "{.}"
		ENDC
	ENDC
	if !DEF(\1)
		DEF \1 EQUS \2
		{\1}:
	ENDC
ENDM

MACRO table_width
	DEF CURRENT_TABLE_WIDTH = \1
	_redef_current_label CURRENT_TABLE_START, "._table_width\@", 2, \#
ENDM

MACRO assert_table_length
	DEF x = \1
	ASSERT x * CURRENT_TABLE_WIDTH == @ - {CURRENT_TABLE_START}, \
		"{CURRENT_TABLE_START}: expected {d:x} entries, each {d:CURRENT_TABLE_WIDTH} bytes"
ENDM

MACRO assert_max_table_length
	DEF x = \1
	ASSERT x * CURRENT_TABLE_WIDTH >= @ - {CURRENT_TABLE_START}, \
		"{CURRENT_TABLE_START}: expected a maximum of {d:x} entries, each {d:CURRENT_TABLE_WIDTH} bytes"
ENDM

MACRO vc_hook
	.VC_\1::
ENDM
