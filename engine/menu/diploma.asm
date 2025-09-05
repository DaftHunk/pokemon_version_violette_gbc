DisplayDiploma:
	call SaveScreenTilesToBuffer2
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	xor a
	ld [wUpdateSpritesEnabled], a
	ld hl, wd730
	set 6, [hl]
	call DisableLCD
	call DelayFrame	;joenote - the overworld sprite wobble fix makes the player sprites hidden unless a delay is added
	ld hl, CircleTile
	ld de, vChars2 + $700
	ld bc, $0010
	ld a, BANK(CircleTile)
	call FarCopyData2
	coord hl, 0, 0
	lb bc, 16, 18
	predef Diploma_TextBoxBorder
	
	ld hl, DiplomaTextPointersAndCoords
	ld c, $4

.asm_56715
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call PlaceString
	pop hl
	inc hl
	pop bc
	dec c
	jr nz, .asm_56715

	CheckEvent EVENT_GYM_LEADERS_REMATCH_BEATEN
	call nz, .markGymLeaders
	
	CheckEvent EVENT_ELITE_4_REMATCH_BEATEN
	call nz, .markElite4

	CheckEvent EVENT_SS_ANNE_TOURNAMENT_BEATEN
	call nz, .markSSAnneTournament

	CheckEvent EVENT_GOT_MIST_STONE
	call nz, .markMistStone

	CheckEvent EVENT_SPECIAL_4_BEATEN
	call nz, .markSpecial4

	CheckEvent EVENT_MOVEDEX_COMPLETED
	call nz, .markMovedex

	CheckEvent EVENT_POKEDEX_COMPLETED
	call nz, .markPokedex

	CheckEvent EVENT_MASTER_POKEMON
	jp z, .notMaster

	coord hl, 1, 1
	ld de, MasterText
	call PlaceString

.notMaster
;joenote - support female player character
	ld a, [wGameplayOptions]
	bit 0, a	;check if girl
	jr nz, .is_fplayer
	callba DrawPlayerCharacter
	jr .fplayer_end

.markGymLeaders
	coord hl, 2, 4
	jr .addMark
.markElite4
	coord hl, 2, 6
	jr .addMark
.markSSAnneTournament
	coord hl, 2, 8
	jr .addMark
.markMistStone
	coord hl, 2, 10
	jr .addMark
.markSpecial4
	coord hl, 2, 12
	jr .addMark
.markMovedex
	coord hl, 2, 14
	jr .addMark
.markPokedex
	coord hl, 2, 16
	jr .addMark
.addMark
	ld de, DiplomaMark
	call PlaceString
	ret
.is_fplayer
	callba DrawPlayerCharacter_F
.fplayer_end
; Move the player 33 pixels right and set the priority bit so he appears
; behind the background layer.
	ld hl, wOAMBuffer + $01
	lb bc, $80, $28
.adjustPlayerGfxLoop
	ld a, [hl] ; X
	add 33
	ld [hli], a
	inc hl
	ld a, b
	ld [hli], a ; attributes
	inc hl
	dec c
	jr nz, .adjustPlayerGfxLoop

	call EnableLCD
	callba LoadTrainerInfoTextBoxTiles
	ld b, SET_PAL_GENERIC
	call RunPaletteCommand
	call Delay3
	call GBPalNormal
	ld a, $90
	ld [rOBP0], a
	call UpdateGBCPal_OBP0
	call WaitForTextScrollButtonPress
	ld hl, wd730
	res 6, [hl]
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadTextBoxTilePatterns
	call Delay3
	jp GBPalNormal

UnusedPlayerNameLengthFunc:
; Unused function that does a calculation involving the length of the player's
; name.
	ld hl, wPlayerName
	ld bc, $ff00
.loop
	ld a, [hli]
	cp "@"
	ret z
	dec c
	jr .loop

DiplomaTextPointersAndCoords:
	dw ChampionText
	dwCoord 1, 1
	dw DiplomaText
	dwCoord 1, 2
	dw DiplomaEmptyText
	dwCoord 3, 4
	dw DiplomaCongrats
	dwCoord 2, 4

ChampionText:
	db $70,"Diplôme Champion",$70,"@"

MasterText:
	db "<SHINY>",$70,"Diplôme Maître",$70,"<SHINY>@"

DiplomaText:
	db "Décerné à <PLAYER>@"

DiplomaMark:
	db "<BALL>@"

DiplomaEmptyText:
	db "@"

DiplomaCongrats:
	db   "×Revanche des 8"
	next "×Revanche Ligue"
	next "×Tournoi Océane"
	next "×Pierre Brume"
	next "×4 dresseurs"
	next "×Capadex 100%"
	next "×#dex 100%@"
