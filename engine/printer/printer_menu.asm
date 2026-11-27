;adding GB_PRINTER
;The diploma print is launched from this menu's "Imprimer diplôme" entry
;(PCPrintDiploma): OUI prints the Champion/Master diploma (PrintDiploma in
;engine/printer/printer.asm), NON displays the in-game diploma screen
;(DisplayDiploma in engine/menu/diploma.asm) without transmitting.
;The Pokedex entry print is accessed through the "Imprimer Pokédex" menu
;entry (PCPrintDex opens the pokedex in printer mode).
;Two menu variants share this code, chosen from the current map:
;- full menu at the Cerulean printer house (scripts/CeruleanPrinter.asm):
;  everything except the score, plus the box number text box
;- Beach House menu on route 19 (scripts/Route19BeachHouse.asm):
;  Réglages, score and Retour only
;Both scripts open the menu with `callba OpenPrinterMenu` and redraw the
;map view after the menu returns.
OpenPrinterMenu::
	;the text engine drew an empty dialogue box when the text started:
	;erase it, so the menu opens over a clean map view. This also gives
	;the print handlers a clean base to redraw over when they come back
	;through LoopPrinterMenu
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call LoadCurrentMapView
	;opening the dialogue box also replaced the GBC BG map attributes
	;of its rows (the gray text box palette): regenerate them from the
	;redrawn map view like the text engine's CloseTextDisplay does, and
	;refresh the open text window copy the menu is shown through (the
	;same pair PCPrintScore uses after its display screen)
	callba MakeAndTransferOverworldBGMapAttributes_CloseText
	callba MakeAndTransferOverworldBGMapAttributes_OpenText
	ld hl, wStatusFlags5
	set 6, [hl]		;set instant text
	xor a
	ld [wParentMenuItem], a
	ld a, [wListScrollOffset]
	push af
	ld a, [wParentMenuItem]
	ld [wCurrentMenuItem], a

	;size of menu text box
	ld a, [wCurMap]
	cp ROUTE_19_BEACH_HOUSE
	jr z, .beachMenu
;full menu: 6 items now that the score is Beach House only,
;sized to the longest item ("Réglages") and flush against the right
;edge of the screen, RETOUR sits at row 12
	coord hl, 8, 0
	ld b, 12
	ld c, 10
	call TextBoxBorder
	coord hl, 10, 2
	ld de, PrinterMenuText
	call PlaceString
	jr .menuVars
.beachMenu
;Beach House menu: 3 items, right aligned and sized to the longest
;item ("Réglages"): one blank column between the text and the right
;border, RETOUR sits at row 6
	coord hl, 8, 0
	ld b, 6
	ld c, 10
	call TextBoxBorder
	coord hl, 10, 2
	ld de, PrinterMenuTextBeach
	call PlaceString

.menuVars
	ld hl, wTopMenuItemY
	ld a, 2
	ld [hli], a ; wTopMenuItemY
	ld a, 9 ;both menus are right aligned: cursor sits at column 7
	ld [hli], a ; wTopMenuItemX
	inc hl
	inc hl

	ld a, [wCurMap]
	cp ROUTE_19_BEACH_HOUSE
	ld a, 5	;number of non-cancel menu items (last one, RETOUR, exits)
	jr nz, .setMaxMenuItem
	ld a, 2	;Beach House menu: Réglages and score
.setMaxMenuItem
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
;full menu only: the Beach House menu has no "Imprimer boîte" entry
	ld a, [wCurMap]
	cp ROUTE_19_BEACH_HOUSE
	jr z, .menuControls
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

.menuControls
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
	ld a, [wCurMap]
	cp ROUTE_19_BEACH_HOUSE
	jr nz, .fullMenu
;Beach House menu: Réglages, score, Retour
	ld a, [wCurrentMenuItem]
	and a
	jp z, PCPrintSettings
	cp $1
	jp z, PCPrintScore
	jp ExitPrinterMenu
.fullMenu
;full menu: Réglages, <pkmn>, boîte, Pokédex, diplôme, Retour
	ld a, [wCurrentMenuItem]
	and a
	jp z, PCPrintSettings
	cp $1
	jp z, PCPrintMon
	cp $2
	jp z, PCPrintBox
	cp $3
	jp z, PCPrintDex
	cp $4
	jp z, PCPrintDiploma
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
	next "<pkmn>"
	next "Boîte"
	next "Pokédex"
	next "Diplôme"
	next "Retour"
	db "@"
;Beach House variant
PrinterMenuTextBeach:
	db   "Réglages"
	next "Score"
	next "Retour"
	db "@"
;max 8 chars: the box number digits are placed at columns 16-17
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
	;right aligned and sized to the longest item ("Très foncé")
	coord hl, 6, 0
	ld b, 12
	ld c, 12
	call TextBoxBorder
	coord hl, 8, 2
	ld de, PrinterSettingsMenuText
	call PlaceString

	ld hl, wTopMenuItemY
	ld a, 2
	ld [hli], a ; wTopMenuItemY
	ld a, 7 ;right aligned: cursor sits at column 5
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
	coord hl, 6, 14
	ld b, 2
	ld c, 12
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
	coord hl, 8, 16
	call PlaceString
	ret

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
	text "Imprimer? Sinon"
	line "ça sera affiché."
	prompt
	db "@"

;shown by PCPrintDiploma when EVENT_GOT_DIPLOMA is not set yet
PCPrintDiplomaLockedText:
	text "Seuls les"
	line "Champions"
	cont "peuvent imprimer"
	cont "leur Diplôme!"
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

;print or display the Champion/Master diploma
PCPrintDiploma:
	;only players who received the dex diploma from the director (proof
	;they are champions) may print their diploma: others get a message
	CheckEvent EVENT_GOT_DIPLOMA
	jr nz, .gotDexDiploma
	ld hl, PCPrintDiplomaLockedText
	call PrintText
	jp LoopPrinterMenu
.gotDexDiploma
	ld hl, PCPrint_ConfirmText
	call PrinterMenu_AskPrintConfirm
	jr z, .printDiploma
	;display only: show the diploma screen without transmitting it
	;(DisplayDiploma waits for a button press and restores the saved
	;screen itself). Play the printer music while it is shown, like the
	;print path and PCPrintScore's display path do.
	callba Printer_PlayPrinterMusic
	callba DisplayDiploma
	callba Printer_PlayMapMusic
	;DisplayDiploma ran its own whole-screen palette command
	;(SET_PAL_GENERIC) and re-enabled the overworld sprites on restore:
	;like PCPrintMon after the portrait screen, regenerate the GBC BG map
	;attributes of the menu's text window and hide the sprites again (the
	;script hides them around the printer menu)
	callba MakeAndTransferOverworldBGMapAttributes_CloseText
	callba MakeAndTransferOverworldBGMapAttributes_OpenText
	call ClearSprites
	xor a
	ld [wUpdateSpritesEnabled], a
	call LoadGBPal
	jp LoopPrinterMenu
.printDiploma
	callba PrintDiploma
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
