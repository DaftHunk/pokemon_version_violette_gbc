;adding GB_PRINTER
;The diploma (PRINT DIPLOMA) menu entry is intentionally NOT ported: in
;this hack, printing is accessed through a dedicated printer NPC instead
;of the diploma menu.
;The Pokedex entry print is accessed through the "Imprimer Pokédex" menu
;entry (PCPrintDex opens the pokedex in printer mode).
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
	ld b, 12
	ld c, 17
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

	ld a, 5	;number of non-cancel menu items (last one, RETOUR, exits)
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
	coord hl, 8, 14
	ld b, 2
	ld c, 10
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
	coord hl, 9, 16
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
	cp $4
	jp z, PCPrintDex
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
	next "Imprimer Pokédex"
	next "Retour"
	db "@"
;max 7 chars: the box number digits are placed at columns 17-18
PrinterMenuBoxText:
	db "Boîte n.@"



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
	coord hl, 8, 14
	ld b, 2
	ld c, 10
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
	coord hl, 9, 16
	call PlaceString
	ret

;TODO: a "Imprimer diplôme" entry (this hack's custom Champion/Maître diploma)
;can be added here once the printer NPC design calls for it.

;adding GB_PRINTER
;Shared print confirmation prompt: OUI = print, NON = display the print
;screen without transmitting it (sets wPrinterDisplayOnly, checked by
;PrintPCBox and this menu's print handlers).
;Input: hl = the confirmation text. Returns z for OUI, nz for NON.
PrinterMenu_AskPrintConfirm:
	xor a
	ld [wPrinterDisplayOnly], a
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ret z
	ld a, $1
	ld [wPrinterDisplayOnly], a
	ret

PCPrint_ConfirmText:
	text "Imprimer?"
	prompt
	db "@"

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
	ld hl, PCPrint_ConfirmText
	call PrinterMenu_AskPrintConfirm
	jr z, .printMon
	;display only: show the portrait screen without transmitting it
	callab DisplayFanClubPortrait
	jr .afterPrint
.printMon
	callab PrintFanClubPortrait
.afterPrint
	call GBPalWhiteOutWithDelay3
	call ReloadTilesetTilePatterns
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadScreenTilesFromBuffer2
	call Delay3
	call GBPalNormal
.exiting
	;the party menu and the portrait screen run palette commands whose
	;GBC packets replace the BG map attributes of the text window space
	;(vBGMap1) that displays the printer menu: regenerate them from the
	;restored map view like the text engine's CloseTextDisplay and
	;DisplayTextIDInit do
	callba MakeAndTransferOverworldBGMapAttributes_CloseText
	callba MakeAndTransferOverworldBGMapAttributes_OpenText
	;RestoreScreenTilesAndReloadTilePatterns re-enables the overworld
	;sprites, but the script hides them around the printer menu: clear
	;the OAM buffer and disable sprite updates again the same way
	call ClearSprites
	xor a
	ld [wUpdateSpritesEnabled], a
	call LoadGBPal
	jp LoopPrinterMenu


PCPrintBox:
	ld hl, PCPrint_ConfirmText
	call PrinterMenu_AskPrintConfirm
	;OUI prints the box, NON displays the pages without transmitting
	;(PrintPCBox checks wPrinterDisplayOnly)
	callba PrintPCBox
	;PrintPCBox leaves the last printed page in wTileMap: redraw the
	;map view into it like the text engine's CloseTextDisplay does
	;when a text ends, so the menu is not redrawn over leftover page
	;tiles
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call LoadCurrentMapView
	jp LoopPrinterMenu

PCPrintScore:
	;print or display the Pikachu's Beach high score
	ld hl, PCPrint_ConfirmText
	call PrinterMenu_AskPrintConfirm
	jr z, .printScore
	;display only: show the high score screen without transmitting it
	;play the printer music while the screen is shown, like the print
	;path does, and restore the map music as soon as the screen closes
	callba Printer_PlayPrinterMusic
	callba DisplaySurfingMinigameHighScoreScreen
	callba Printer_PlayMapMusic
	;DisplaySurfingMinigameHighScoreScreen leaves the print screen in
	;wTileMap: redraw the map view into it like the text engine's
	;CloseTextDisplay does when a text ends, so the menu is not redrawn
	;over leftover print screen tiles
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call LoadCurrentMapView
	;then regenerate the GBC BG map attributes from the redrawn map
	;view (normally done by the text engine's CloseTextDisplay)
	callba MakeAndTransferOverworldBGMapAttributes_CloseText
	;the menu is still shown through the text window (hWY=0), which
	;uses the vBGMap1 space: the print screen's whole-screen palette
	;command replaced its attributes too, so refresh them the same way
	;DisplayTextIDInit does when opening a text box
	callba MakeAndTransferOverworldBGMapAttributes_OpenText
	;DisplaySurfingMinigameHighScoreScreen ends with a palette whiteout,
	;which the text engine's CloseTextDisplay undoes with LoadGBPal when
	;a text ends: restore the palettes the same way here
	call LoadGBPal
	jp LoopPrinterMenu
.printScore
	callba PrintSurfingMinigameHighScore
	jp LoopPrinterMenu

;opens the pokedex in printer mode: its side menu offers printing the
;selected pokedex entry (no print confirmation prompt, choosing Prnt in
;the side menu is the confirmation step)
PCPrintDex:
	call GBPalWhiteOutWithDelay3
	call LoadCurrentMapView
	call SaveScreenTilesToBuffer2
;set the flag that switches the pokedex side menu to its printer variant
	ld a, $1
	ld [wPrinterPokedexMode], a
	callba ShowPokedexMenu
	xor a
	ld [wPrinterPokedexMode], a
;the pokedex replaced the whole screen and ran its own palette commands
;(like the party menu does in PCPrintMon): restore the printer menu
;screen the same way PCPrintMon does after the portrait screen
	call GBPalWhiteOutWithDelay3
	call ReloadTilesetTilePatterns
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadScreenTilesFromBuffer2
	call Delay3
	call GBPalNormal
	callba MakeAndTransferOverworldBGMapAttributes_CloseText
	callba MakeAndTransferOverworldBGMapAttributes_OpenText
	call ClearSprites
	xor a
	ld [wUpdateSpritesEnabled], a
	call LoadGBPal
	jp LoopPrinterMenu
