DisplayDiploma::
	call SaveScreenTilesToBuffer2
	call GBPalWhiteOutWithDelay3
	call PrepareDiplomaScreen
;joenote - support female player character
	ld a, [wGraphicOptions]
	bit BIT_GRAPHIC_FEMALE, a	;check if girl
	jr nz, .is_fplayer
	callba DrawPlayerCharacter
	jr .fplayer_end

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
	;the Yellow diploma gfx are already loaded at vChars2 by
	;PrepareDiplomaScreen: reloading the trainer info tiles here would
	;clobber them
	ld b, SET_PAL_GENERIC
	call RunPaletteCommand
	call Delay3
	call GBPalNormal
	ld a, $90
	ld [rOBP0], a
	call UpdateGBCPal_OBP0
	call WaitForTextScrollButtonPress
	ld hl, wStatusFlags5
	res 6, [hl]
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadTextBoxTilePatterns
	call Delay3
	jp GBPalNormal

;adding GB_PRINTER
;Draw the diploma top page into wTileMap and load the Yellow diploma
;gfx (gfx/diploma/diploma.2bpp) at vChars2: the decorative border
;(tiles $00-$04), the circle tile ($10) and the Pikachu/Mew art tiles.
;Shared by the in-game DisplayDiploma above and the GB Printer's
;PrintDiploma (engine/printer/printer.asm). Like the Yellow diploma,
;the top page's frame stays open at the bottom: the print's second
;sheet closes it (the in-game screen shows the top page alone, like
;the Yellow DisplayDiploma). The LCD is left off (the gfx load must
;not race the display): the callers re-enable it. wStatusFlags5 bit 6
;(instant text) is set here: the callers clear it. Only the tilemap is
;drawn: the player character is a sprite, and the printer only
;receives the tilemap anyway.
PrepareDiplomaScreen::
	call ClearScreen
	xor a
	ld [wUpdateSpritesEnabled], a
	ld hl, wStatusFlags5
	set 6, [hl]
	call DisableLCD
	call DelayFrame	;joenote - the overworld sprite wobble fix makes the player sprites hidden unless a delay is added
	ld hl, DiplomaGraphics
	ld de, vChars2
	ld bc, DiplomaGraphicsEnd - DiplomaGraphics
	ld a, BANK(DiplomaGraphics)
	call FarCopyData2
	;the Yellow diploma border
	coord hl, 0, 0
	call DiplomaDrawHorizontalBorder
	coord hl, 0, 0
	call DiplomaDrawVerticalBorder
	coord hl, 19, 0
	call DiplomaDrawVerticalBorder
	ld a, $00
	Coorda 0, 0
	ld a, $00
	Coorda 19, 0

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

	CheckEvent EVENT_GOT_BERSERK_ADN
	call nz, .markBerserkADN

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
	ret
.markGymLeaders
	coord hl, 2, 4
	jr .addMark
.markElite4
	coord hl, 2, 6
	jr .addMark
.markSSAnneTournament
	coord hl, 2, 8
	jr .addMark
.markBerserkADN
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

;adding GB_PRINTER
;Draw the diploma bottom page (print only, like the Yellow diploma
;print: the in-game DisplayDiploma shows the top page alone). The
;diploma gfx are already loaded at vChars2 by PrepareDiplomaScreen.
;Pikachu with its camera, the CONGRATULATIONS! tiles, the play time,
;and Mew if the Master diploma is earned (EVENT_MASTER_POKEMON: the
;same event that swaps the top page's title to "Diplôme Maître").
PrepareDiplomaBottomScreen::
	call ClearScreen
	coord hl, 0, 17
	call DiplomaDrawHorizontalBorder
	coord hl, 0, 0
	call DiplomaDrawVerticalBorder
	coord hl, 19, 0
	call DiplomaDrawVerticalBorder
	ld a, $00
	Coorda 0, 17
	ld a, $00
	Coorda 19, 17

	ld de, DiplomaPikachuTiles
	coord hl, 6, 2
	lb bc, 10, 12
	call DiplomaCopyBox

	ld de, CongratulationsTiles
	coord hl, 7, 13
	lb bc, 1, 6
	call DiplomaCopyBox

	ld de, DiplomaPlayTime
	coord hl, 2, 15
	call PlaceString
	coord hl, 12, 15
	ld de, wPlayTimeHours
	lb bc, LEFT_ALIGN | 1, 3
	call PrintNumber
	ld [hl], $16 ; colon
	inc hl
	ld de, wPlayTimeMinutes
	lb bc, LEADING_ZEROES | 1, 2
	call PrintNumber

	CheckEvent EVENT_MASTER_POKEMON
	ret z
	ld de, DiplomaMewTiles
	coord hl, 2, 0
	lb bc, 4, 5
	call DiplomaCopyBox
	ret

;local copy of Diploma_Surfing_CopyBox (engine/printer/printer.asm):
;the Pikachu, CONGRATULATIONS! and Mew tilemaps live in this bank, and a
;far call would remap the $4000-$7FFF window under the data pointer's
;feet (the box copy reads through the currently mapped bank)
DiplomaCopyBox:
.y
	push bc
	push hl
.x
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .x
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .y
	ret

;the Yellow diploma border drawing (from pokeyellow's engine/events/
;diploma2.asm): $00 = corner, $01/$02 = horizontal sides, $03/$04 =
;vertical sides
DiplomaDrawHorizontalBorder:
	ld c, SCREEN_WIDTH / 2
.loop
	ld [hl], $02
	inc hl
	ld [hl], $01
	inc hl
	dec c
	jr nz, .loop
	ret

DiplomaDrawVerticalBorder:
	ld c, SCREEN_HEIGHT / 2
	ld de, SCREEN_WIDTH
.loop
	ld [hl], $04
	add hl, de
	ld [hl], $03
	add hl, de
	dec c
	jr nz, .loop
	ret

DiplomaGraphics: INCBIN "gfx/diploma/diploma.2bpp"
DiplomaGraphicsEnd:

DiplomaPikachuTiles: INCBIN "gfx/diploma/diploma_pikachu.tilemap"

CongratulationsTiles:
	db $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f ; CONGRATULATIONS!

DiplomaMewTiles: INCBIN "gfx/diploma/diploma_mew.tilemap"

DiplomaPlayTime:
	db "Durée jeu@"

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
	db $10,"Diplôme Champion",$10,"@" ;$10 = the circle tile of the Yellow diploma gfx

MasterText:
	db "<SHINY>",$10,"Diplôme Maître",$10,"<SHINY>@"

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
	next "×Ville oubliée"
	next "×6 dresseurs"
	next "×Capadex 100%"
	next "×#dex 100%@"
