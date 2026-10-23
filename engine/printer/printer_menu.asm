;adding GB_PRINTER
;GB Printer menu, adapted from jojobear13/shinpokered (engine/printer/printer_pc_menu.asm)
;The Pokedex entry (PRINT #DEX) and diploma (PRINT DIPLOMA) menu entries are
;intentionally NOT ported: in this hack, printing is accessed through a
;dedicated printer NPC instead of the Pokedex/diploma menus.
;Opened with `callba OpenPrinterMenu` from the Beach House printer's script
;(Route19BeachHouseText_Printer in scripts/Route19BeachHouse.asm), which
;redraws the map view after the menu returns.

OpenPrinterMenu::
	ld hl, wStatusFlags5
	set 6, [hl]		;set instant text
	xor a
	ld [wParentMenuItem], a
	ld a, [wListScrollOffset]
	push af
	ld a, [wParentMenuItem]
	ld [wCurrentMenuItem], a

	;size of menu text box
	coord hl, 0, 0
	ld b, 10
	ld c, 15
	call TextBoxBorder
	coord hl, 2, 2
	ld de, PrinterMenuText
	call PlaceString

	ld hl, wTopMenuItemY
	ld a, 2
	ld [hli], a ; wTopMenuItemY
	dec a
	ld [hli], a ; wTopMenuItemX
	inc hl
	inc hl

	ld a, 4	;number of non-cancel menu items (last one, RETOUR, exits)
	ld [hli], a ; wMaxMenuItem

	ld a, A_BUTTON | B_BUTTON
	ld [hli], a ; wMenuWatchedKeys
	xor a
	ld [hli], a ; wLastMenuItem
	ld [hli], a ; wPartyAndBillsPCSavedMenuItem
	ld hl, wListScrollOffset
	ld [hli], a ; wListScrollOffset
	ld [hl], a ; wMenuWatchMovingOutOfBounds
	ld [wPlayerMonNumber], a

;now handle the text box giving the current box number
	coord hl, 9, 14
	ld b, 2
	ld c, 9
	call TextBoxBorder
	ld a, [wCurrentBoxNum]
	and $7f
	cp 9
	jr c, .singleDigitBoxNum
; two digit box num
	sub 9
	coord hl, 17, 16
	ld [hl], "1"
	add "0"
	jr .next
.singleDigitBoxNum
	add "1"
.next
	Coorda 18, 16
	coord hl, 10, 16
	ld de, PrinterMenuBoxText
	call PlaceString

;now do menu controls
	ld a, 1
	ld [H_AUTOBGTRANSFERENABLED], a
	call Delay3
	call HandleMenuInput
	bit 1, a
	jp nz, ExitPrinterMenu ; b button
	call PlaceUnfilledArrowMenuCursor

	ld a, [wCurrentMenuItem]
	ld [wParentMenuItem], a
	and a
	jp z, PCPrintSettings
	cp $1
	jp z, PCPrintScore
	cp $2
	jp z, PCPrintMon
	cp $3
	jp z, PCPrintBox
	;fall through for exiting (RETOUR)
ExitPrinterMenu:
	pop af
	ld [wListScrollOffset], a
	ld hl, wStatusFlags5
	res 6, [hl]
	ret
LoopPrinterMenu:
	pop af
	ld [wListScrollOffset], a
	ld hl, wStatusFlags5
	res 6, [hl]
	jp OpenPrinterMenu

PrinterMenuText:
	db   "Réglages"
	next "Imprimer score"
	next "Imprimer <pkmn>"
	next "Imprimer boîte"
	next "Retour"
	db "@"
;max 7 chars: the box number digits are placed at columns 17-18
PrinterMenuBoxText:
	db "Boîte №@"



;This is a menu for setting how dark to make the prints
PCPrintSettings:
	xor a
	ld [wParentMenuItem], a
	ld [wCurrentMenuItem], a
	ld a, [wListScrollOffset]
	push af

	;size of menu text box
	coord hl, 0, 0
	ld b, 12
	ld c, 15
	call TextBoxBorder
	coord hl, 2, 2
	ld de, PrinterSettingsMenuText
	call PlaceString

	ld hl, wTopMenuItemY
	ld a, 2
	ld [hli], a ; wTopMenuItemY
	dec a
	ld [hli], a ; wTopMenuItemX
	inc hl
	inc hl

	ld a, 5	;number of non-cancel menu items
	ld [hli], a ; wMaxMenuItem

	ld a, A_BUTTON | B_BUTTON
	ld [hli], a ; wMenuWatchedKeys
	xor a
	ld [hli], a ; wLastMenuItem
	ld [hli], a ; wPartyAndBillsPCSavedMenuItem
	ld hl, wListScrollOffset
	ld [hli], a ; wListScrollOffset
	ld [hl], a ; wMenuWatchMovingOutOfBounds
	ld [wPlayerMonNumber], a

;now handle the text box giving the current setting
	coord hl, 9, 14
	ld b, 2
	ld c, 9
	call TextBoxBorder
	call PCPrinterCurrentSettingDisplay

;now do menu controls
	call HandleMenuInput
	bit 1, a
	jr nz, .exitPrinterSettings ; b button
	call PlaceUnfilledArrowMenuCursor

	ld a, [wCurrentMenuItem]
	ld [wParentMenuItem], a
	and a
	jr z, .lightest
	cp $1
	jr z, .lighter
	cp $2
	jr z, .normal
	cp $3
	jr z, .darker
	cp $4
	jr z, .darkest
	jr .exitPrinterSettings
.affirmSettings
	call PCPrinterCurrentSettingDisplay
	ld a, SFX_ENTER_PC
	call PlaySound
	call WaitForSoundToFinish
.exitPrinterSettings
	pop af
	ld [wListScrollOffset], a
	jp LoopPrinterMenu
.lightest
	ld a, $00
	ld [wPrinterSettings], a
	jr .affirmSettings
.lighter
	ld a, $20
	ld [wPrinterSettings], a
	jr .affirmSettings
.normal
	ld a, $40
	ld [wPrinterSettings], a
	jr .affirmSettings
.darker
	ld a, $60
	ld [wPrinterSettings], a
	jr .affirmSettings
.darkest
	ld a, $7F
	ld [wPrinterSettings], a
	jr .affirmSettings

PrinterSettingsMenuText:
	db   "Très clair"
	next "Clair"
	next "Normal"
	next "Foncé"
	next "Très foncé"
	next "Retour"
	db "@"
PrinterSettingsMenuTextSingle00:
	db "Tr.clair@"
PrinterSettingsMenuTextSingle20:
	db "Clair   @"
PrinterSettingsMenuTextSingle40:
	db "Normal  @"
PrinterSettingsMenuTextSingle60:
	db "Foncé   @"
PrinterSettingsMenuTextSingle7F:
	db "Tr.foncé@"

PCPrinterCurrentSettingDisplay:
	ld a, [wPrinterSettings]
	ld de, PrinterSettingsMenuTextSingle00
	and a
	jr z, .next
	ld de, PrinterSettingsMenuTextSingle20
	cp $20
	jr z, .next
	ld de, PrinterSettingsMenuTextSingle40
	cp $40
	jr z, .next
	ld de, PrinterSettingsMenuTextSingle60
	cp $60
	jr z, .next
	ld de, PrinterSettingsMenuTextSingle7F
.next
	coord hl, 10, 16
	call PlaceString
	ret

;TODO: a "Imprimer diplôme" entry (this hack's custom Champion/Maître diploma)
;can be added here once the printer NPC design calls for it.


PCPrintMon:
.select_mon_to_print
	call GBPalWhiteOutWithDelay3
	call LoadCurrentMapView
	call SaveScreenTilesToBuffer2
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	ld a, $00
	ld [wTempTilesetNumTiles], a
	call DisplayPartyMenu
	jp nc, .print
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	jr .exiting
.print
	xor a
	ld [wUpdateSpritesEnabled], a
	callab PrintFanClubPortrait
	call GBPalWhiteOutWithDelay3
	call ReloadTilesetTilePatterns
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadScreenTilesFromBuffer2
	call Delay3
	call GBPalNormal
.exiting
	call LoadGBPal
	jp ExitPrinterMenu


PCPrintBox:
	callba PrintPCBox
	jp LoopPrinterMenu

PCPrintScore:
	;print the Pikachu's Beach high score (engine/printer/printer.asm)
	callba PrintSurfingMinigameHighScore
	jp LoopPrinterMenu
