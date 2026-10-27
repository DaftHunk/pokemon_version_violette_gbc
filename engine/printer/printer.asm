;The diploma print hook (PrintDiploma) is intentionally NOT ported: in this
;hack, printing is accessed through the Beach House printer
;(Route19BeachHouseText_Printer in scripts/Route19BeachHouse.asm), which
;opens the printer menu (engine/printer/printer_menu.asm).
;The Pokedex entry print below (PrintPokedexEntry) is called from the
;printer-mode pokedex side menu (.chosePrint in engine/menu/pokedex.asm),
;opened through the printer menu's "Imprimer Pokédex" entry.
;This hack has the Pikachu's Beach minigame: the high score print below uses
;PrepareSurfingMinigameHighScoreScreen (engine/pikachus_beach.asm), this
;hack's own version of shin's Printer_PrepareSurfingMinigameHighScoreTileMap.
PrintSurfingMinigameHighScore:
	xor a
	ldh [hCanceledPrinting], a
	call Printer_PlayPrinterMusic
	;disable overworld tile animations during the transmission: VBlank's
	;UpdateMovingBgTiles would corrupt the printer graphics loaded at
	;vChars2 (the tile patterns are read from VRAM on the fly)
	ldh a, [hTilesetType]
	push af
	xor a
	ldh [hTilesetType], a
	callba PrepareSurfingMinigameHighScoreScreen
	ldh a, [rIE]
	push af
	xor a
	ldh [rIF], a
	ld a, $9
	ldh [rIE], a
	call StartTransmission_Send9Rows
	ld a, $13
	ld [wcae2], a
	call Printer_CopyTileMapToPrinterTileBuffer
	call Printer_ResetJoypadHRAM
.loop
	call JoypadLowSensitivity
	call Printer_CheckPressingB
	jr c, .quit
	ld a, [wPrinterSendState]
	bit 7, a
	jr nz, .quit
	call PrinterTransmissionJumptable
	call GBPrinter_CheckForErrors
	call GBPrinter_UpdateStatusMessage
	call DelayFrame
	jr .loop

.quit
	xor a
	ld [wPrinterConnectionOpen], a
	ld [wPrinterOpcode], a
	call Printer_CopyTileMapFromPrinterTileBuffer
	xor a
	ldh [rIF], a
	pop af
	ldh [rIE], a
	;give immediate feedback that the B press was registered: the restore
	;below takes a few frames, during which the screen would otherwise stay
	;frozen on the error message with no visible reaction
	call GBPalWhiteOutWithDelay3
	;restore the palettes, the map view and the tile patterns the print
	;screen replaced at vChars2 (like DisplaySurfingMinigameHighScoreScreen)
	call RunDefaultPaletteCommand
	call ReloadMapAfterPrinter
	;the print screen is still in wTileMap: redraw the map view into it
	;like the text engine's CloseTextDisplay does when a text ends, so
	;the printer menu is not redrawn over leftover print screen tiles
	xor a
	ldh [H_AUTOBGTRANSFERENABLED], a
	call LoadCurrentMapView
	;then regenerate the GBC BG map attributes from the redrawn map
	;view: RunDefaultPaletteCommand built stale ones from the print
	;screen that was in wTileMap before the redraw. CloseTextDisplay
	;normally does this on leaving a text screen; the printer menu
	;has to do it itself.
	callba MakeAndTransferOverworldBGMapAttributes_CloseText
	;the printer menu is still shown through the text window (hWY=0),
	;which uses the vBGMap1 space: the print screen's whole-screen
	;palette command replaced its attributes too, so refresh them the
	;same way DisplayTextIDInit does when opening a text box
	callba MakeAndTransferOverworldBGMapAttributes_OpenText
	call ReloadMapSpriteTilePatterns
	call ReloadTilesetTilePatterns
	call Printer_PlayMapMusic
	;undo the whiteout above: nothing else in the print flow reloads the
	;palettes on GBC (RunDefaultPaletteCommand is a no-op there). CloseTextDisplay
	;normally does this with LoadGBPal when a text ends; the printer menu
	;has to do it itself.
	call LoadGBPal
	pop af
	ldh [hTilesetType], a
	ret

PrintPCBox::
	ld a, [wBoxDataStart]
	and a
	jp z, Func_e8df4
	ld a, [wUpdateSpritesEnabled]
	push af
	xor a
	ld [wUpdateSpritesEnabled], a
	ldh [hCanceledPrinting], a
	call Printer_PlayPrinterMusic
	ldh a, [rIE]
	push af
	xor a
	ldh [rIF], a
	ld a, $9
	ldh [rIE], a
	call SaveScreenTilesToBuffer1
	xor a
	ldh [H_AUTOBGTRANSFERENABLED], a
	call PrintPCBox_DrawPage1
	ld a, $10
	call Printer_SendPageOrWait
	jr c, .asm_e8ddc
	xor a
	ld [wPrinterConnectionOpen], a
	ld [wPrinterOpcode], a
	ld c, 12
	call DelayFrames
	xor a
	ldh [H_AUTOBGTRANSFERENABLED], a
	call PrintPCBox_DrawPage2
	ld a, $0
	call Printer_SendPageOrWait
	jr c, .asm_e8ddc
	xor a
	ld [wPrinterConnectionOpen], a
	ld [wPrinterOpcode], a
	ld c, 12
	call DelayFrames
	xor a
	ldh [H_AUTOBGTRANSFERENABLED], a
	call PrintPCBox_DrawPage3
	ld a, $0
	call Printer_SendPageOrWait
	jr c, .asm_e8ddc
	xor a
	ld [wPrinterConnectionOpen], a
	ld [wPrinterOpcode], a
	ld c, 12
	call DelayFrames
	xor a
	ldh [H_AUTOBGTRANSFERENABLED], a
	call PrintPCBox_DrawPage4
	ld a, $3
	call Printer_SendPageOrWait
.asm_e8ddc
	xor a
	ld [wPrinterConnectionOpen], a
	ld [wPrinterOpcode], a
	xor a
	ldh [rIF], a
	pop af
	ldh [rIE], a
	;give immediate feedback that the B press was registered: the restore
	;below takes a few frames, during which the screen would otherwise stay
	;frozen on the error message with no visible reaction
	call GBPalWhiteOutWithDelay3
	call ReloadMapAfterPrinter
	call Printer_PlayMapMusic
	;undo the whiteout above (the text engine's CloseTextDisplay normally
	;does this with LoadGBPal when a text ends)
	call LoadGBPal
	pop af
	ld [wUpdateSpritesEnabled], a
	ret

Func_e8df4:
	ld hl, String_e8e1f
	call PrintText
	ret

Func_e8dfb:
	call Printer_ResetJoypadHRAM
.asm_e8dfe
	call JoypadLowSensitivity
	call Printer_CheckPressingB
	jr c, .asm_e8e1d
	ld a, [wPrinterSendState]
	bit 7, a
	jr nz, .asm_e8e1b
	call PrinterTransmissionJumptable
	call GBPrinter_CheckForErrors
	call GBPrinter_UpdateStatusMessage
	call DelayFrame
	jr .asm_e8dfe

.asm_e8e1b
	and a
	ret

.asm_e8e1d
	scf
	ret

String_e8e1f:
	TX_FAR _NoMonText
	db "@"

PrintFanClubPortrait:
	xor a
	ldh [hCanceledPrinting], a
	call Printer_PlayPrinterMusic
	call Printer_GetMonStats
	ldh a, [rIE]
	push af
	xor a
	ldh [rIF], a
	ld a, $9
	ldh [rIE], a
	call StartTransmission_Send9Rows
	ld a, $13
	ld [wcae2], a
	call Printer_CopyTileMapToPrinterTileBuffer
	call Printer_ResetJoypadHRAM
.asm_e8e45
	call JoypadLowSensitivity
	call Printer_CheckPressingB
	jr c, .asm_e8e62
	ld a, [wPrinterSendState]
	bit 7, a
	jr nz, .asm_e8e62
	call PrinterTransmissionJumptable
	call GBPrinter_CheckForErrors
	call GBPrinter_UpdateStatusMessage
	call DelayFrame
	jr .asm_e8e45

.asm_e8e62
	xor a
	ld [wPrinterConnectionOpen], a
	ld [wPrinterOpcode], a
	call Printer_CopyTileMapFromPrinterTileBuffer
	xor a
	ldh [rIF], a
	pop af
	ldh [rIE], a
	;give immediate feedback that the B press was registered: the caller
	;(PCPrintMon's .afterPrint in engine/printer/printer_menu.asm) handles
	;the full screen restore, including the palette reload
	call GBPalWhiteOutWithDelay3
	call ReloadMapAfterPrinter
	call Printer_PlayMapMusic
	ret

;Print the pokedex entry of the pokemon in [wPokedexNum] to the GB Printer,
;like the pokedex print in Pokemon Yellow: the data page is printed once
;with BOTH description pages stacked below it (no blank row between
;them), then the base stats page (the Info screen's third page) as a
;second sheet. Seen-only pokemon have no description or stats: their
;data page is printed alone. Called from the printer-mode pokedex side
;menu (.chosePrint in engine/menu/pokedex.asm).
PrintPokedexEntry:
	xor a
	ldh [hCanceledPrinting], a
	call Printer_PlayPrinterMusic
	;disable overworld tile animations during the transmission: VBlank's
	;UpdateMovingBgTiles would corrupt the print graphics (the tile
	;patterns are read from VRAM on the fly)
	ldh a, [hTilesetType]
	push af
	xor a
	ldh [hTilesetType], a
	;draw the data page on screen (the same setup ShowPokedexCapa does
	;before calling DrawDexEntryOnScreen: wcf91 must hold the mon, the
	;shiny dex palette flag must be cleared and the POKEDEX palette
	;command must have run, or the GBC colors are wrong)
	ld a, [wPokedexNum]
	ld [wcf91], a
	ld hl, wPokedexDataFlags
	res BIT_POKEDEX_DATA_SHINY, [hl] ; never use the shiny dex palette on the print screen
	push af
	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand
	pop af
	ld [wPokedexNum], a
	callba DrawDexEntryOnScreen
	jr nc, .notOwned
	;owned: the printout continues with the stats sheet, so keep the
	;frame open: replace the data page's bottom border line with plain
	;side border tiles, the frame closes on the stats sheet after the
	;stats block
	;hl must survive this fixup: it holds the description pointer that
	;DrawDexEntryOnScreen returned and PrintDexFlavorTextSilent takes
	;as input (clobbering it makes the silent reader copy the text from
	;a garbage far address)
	push hl
	coord hl, 1, 17
	ld bc, SCREEN_WIDTH - 2
	ld a, " "
	call FillMemory
	ld a, $66
	Coorda 0, 17
	ld a, $67
	Coorda 19, 17
	pop hl
	;draw the data page once with both description pages stacked below it
	;(see PrintDexFlavorTextSilent)
	call PrintDexFlavorTextSilent
	ldh a, [rIE]
	push af
	xor a
	ldh [rIF], a
	ld a, $9
	ldh [rIE], a
	;sheet 1: data page + both description pages. The stats sheet always
	;follows, so feed the paper before only (like PrintPCBox's first page)
	ld a, $10
	ld c, 9 ;full 18-row sheet
	call Printer_SendDexSheet
	jr c, .quit
	;sheet 2: the base stats page continues the printout below the
	;description, and the frame closes around it (the data page is not
	;redrawn: it was printed once, above). The stats block is drawn at
	;the top of the sheet: the first sheet's blank last row separates
	;the description from the stats
	call Printer_ResetForNextDexSheet
	ld a, [wPokedexNum]
	ld [wd0b5], a
	call GetMonHeader ;reload the mon header: DrawDexEntryOnScreen is not called again
	call ClearScreen
	;continue the frame's side borders, then close it under the stats
	;block (same tiles as the data page)
	coord hl, 0, 0
	ld de, SCREEN_WIDTH
	lb bc, $66, 7
	call DrawTileLine
	coord hl, 19, 0
	ld de, SCREEN_WIDTH
	lb bc, $67, 7
	call DrawTileLine
	coord hl, 0, 7
	ld de, 1 ;step right: DrawTileLine draws the closing line horizontally
	lb bc, $6f, SCREEN_WIDTH
	call DrawTileLine
	ld a, $6c
	Coorda 0, 7
	ld a, $6e
	Coorda 19, 7
	callba DrawDexEntryStatsOnScreen
	;the sheet uses exactly rows 0-7 (stats block + closing frame
	;line): transmit those 8 rows instead of a full 18-row sheet, so
	;the printout ends right after the frame and the next printout
	;follows on the paper without a blank gap (packets are 2 rows, so
	;a partial sheet's row count must be even)
	ld c, 4
	ld a, $3 ;last sheet: feed the paper out (like PrintPCBox's last page)
	call Printer_SendDexSheet
	jr .quit
.notOwned
	;seen only: no description or base stats, print the data page alone
	ldh a, [rIE]
	push af
	xor a
	ldh [rIF], a
	ld a, $9
	ldh [rIE], a
	ld a, $13
	ld c, 9 ;full 18-row sheet
	call Printer_SendDexSheet

.quit
	xor a
	ld [wPrinterConnectionOpen], a
	ld [wPrinterOpcode], a
	call Printer_CopyTileMapFromPrinterTileBuffer
	xor a
	ldh [rIF], a
	pop af
	ldh [rIE], a
	;the transmission clobbers the overworld map: rebuild it like the
	;other print routines do
	call ReloadMapAfterPrinter
	;leave the screen cleared like ShowPokedexCapa does when it exits, so
	;the pokedex redraw that follows starts from a clean screen (the
	;printer status message box may have been drawn over the data page)
	call GBPalWhiteOut
	call ClearScreen
	call RunDefaultPaletteCommand
	call LoadTextBoxTilePatterns
	call GBPalNormal
	pop af
	ldh [hTilesetType], a
	call Printer_PlayMapMusic
	ret

;Draw the first page of the pokedex description at row 11 without the
;interactive text commands. The FR descriptions contain a "bage" command
;that waits for a button press: normal on the Info screen, but it has no
;place on a print screen, and running the full text engine from the print
;path (never exercised before this port) leaves garbage sounds or crashes.
;Like the Pokemon Yellow print, the two description pages are stacked on
;the same sheet below the data page with no blank row between them
;(rows 11-16: 3 rows + 3 rows), so the sheet's last row stays blank as
;the separator line before the stats sheet.
;hl = the description pointer returned by DrawDexEntryOnScreen (a TX_FAR
;in the pokedex code bank).
PrintDexFlavorTextSilent:
	;Fetch the description data through a far call. The TX_FAR bytes and
	;the text data live in other banks, and the bank switches must run
	;from the home bank: this routine is banked code, and writing
	;MBC1RomBank here would remap the $4000-$7FFF window under the CPU's
	;feet, so the next instruction would be fetched from the newly mapped
	;bank (garbage) - the original implementation crashed exactly here.
	;callba clobbers hl and bc, so the TX_FAR address is passed in de.
	ld d, h
	ld e, l
	callba Pokedex_CopyDexEntryTextToBuffer
	;process the WRAM copy: no bank is switched while the loop runs
	ld hl, wPrinterTileBuffer
	coord de, 1, 11 ;de = start of row 11 in the tilemap
	ld c, e
	ld b, d ;bc = current destination
.loop
	ld a, [hli]
	cp "@"
	jr z, .done ;end of text
	cp $5F
	jr z, .dexEnd ;"dex": end of entry, draw the period
	cp $48
	jr z, .skipRow ;"bage": the second description page continues on the next row
	cp $4E
	jr z, .nextRow ;"next": move to the next row
	cp $00
	jr z, .loop ;"text" command byte, skip
	cp $54
	jr z, .poke ;"#": dictionary code expanded to "Poké" (see below)
	ld [bc], a ;draw the character
	inc bc
	jr .loop
.nextRow
	ld a, e
	add SCREEN_WIDTH
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	ld c, e
	ld b, d
	jr .loop
.skipRow
	;"bage" only marks the second description page: stack it right
	;below the first page with no blank row between them, so advance
	;to the next row like the "next" code does (the description then
	;ends one row earlier, and the first sheet's last row stays blank
	;as the separator before the stats sheet)
	ld a, e
	add SCREEN_WIDTH
	ld e, a
	jr nc, .skipRowNoCarry
	inc d
.skipRowNoCarry
	ld c, e
	ld b, d
	jr .loop
.dexEnd
	ld a, "."
	ld [bc], a
.done
	ret
.poke
	;"#" is a text engine dictionary code (dict $54, PokeChar in
	;home/text.asm): the Info screen's text engine expands it to
	;"Poké", the printout must show the same thing
	ld a, "P"
	ld [bc], a
	inc bc
	ld a, "o"
	ld [bc], a
	inc bc
	ld a, "k"
	ld [bc], a
	inc bc
	ld a, "é"
	ld [bc], a
	inc bc
	jr .loop

;Send the current wTileMap to the printer as one dex print sheet.
;a = the paper feed byte for wcae2: $10 feed before (first sheet), $00 no
;feed (middle sheets), $03/$13 feed after (last/only sheet), like the
;PrintPCBox pages. c = the number of 2-row packets to transmit: 9 for a
;full 18-row sheet, fewer for a short sheet (the stats sheet prints only
;the rows it uses, so the next printout follows on the paper without a
;large blank gap). Returns carry if the player cancelled with B.
Printer_SendDexSheet:
	ld [wcae2], a
	ld a, c
	call Printer_StartTransmission
	call Printer_CopyTileMapToPrinterTileBuffer
	call Func_e8dfb
	ret

;Reset the printer connection between two dex print sheets, and let the
;printer breathe for a moment (the same reset PrintPCBox does between its
;pages). Stop the automatic BG transfer too, so the next sheet is not
;shown half-drawn while it is being redrawn; the status message box drawn
;during the next transmission re-enables it.
Printer_ResetForNextDexSheet:
	xor a
	ld [wPrinterConnectionOpen], a
	ld [wPrinterOpcode], a
	ld c, 12
	call DelayFrames
	xor a
	ldh [H_AUTOBGTRANSFERENABLED], a
	ret

;Show the Fan Club portrait print screen without transmitting it to the
;printer (display-only mode, NON at the print confirmation prompt).
;Like PrintFanClubPortrait, the caller handles the screen restore.
;Play the printer music while the portrait is on screen, and restore
;the map music when the player closes it, like the print path does.
DisplayFanClubPortrait:
	xor a
	ldh [hCanceledPrinting], a
	call Printer_PlayPrinterMusic
	call Printer_GetMonStats
	call Printer_WaitForAB
	call Printer_PlayMapMusic
	ret

PrinterDebug:
	push af
	push bc
	push de
	push hl
	call StopAllMusic
	ldh a, [rIE]
	push af
	xor a
	ldh [rIF], a
	ld a, $9
	ldh [rIE], a
	call StartTransmission_Send9Rows
	ld a, $13
	ld [wcae2], a
	ld a, $1
	ldh [H_AUTOBGTRANSFERENABLED], a
	call Printer_CopyTileMapToPrinterTileBuffer
	call PrinterDebug_LoadGFX
.loop
	ld a, [wPrinterSendState]
	bit 7, a
	jr nz, .quit
	call PrinterDebug_DoFunction
	call PrinterDebug_ConvertStatusFlagsToTiles
	call DelayFrame
	jr .loop

.quit
	xor a
	ld [wPrinterConnectionOpen], a
	ld [wPrinterOpcode], a
	ld hl, wOAMBuffer + 32 * 4
	ld bc, 8 * 4
	xor a
	call FillMemory
	xor a
	ldh [rIF], a
	pop af
	ldh [rIE], a
	pop hl
	pop de
	pop bc
	pop af
	ret

Printer_CheckPressingB:
	ldh a, [hJoyHeld]
	and B_BUTTON
	jr nz, .quit
	and a
	ret

.quit
	ld a, [wPrinterSendState]
	cp $c
	jr nz, .already_done
.wait_current_task
	ld a, [wPrinterOpcode]
	and a
	jr nz, .wait_current_task
	ld a, $16
	ld [wPrinterOpcode], a
	ld a, $88
	ldh [rSB], a
	ld a, $1
	ldh [rSC], a
	ld a, $81
	ldh [rSC], a
.wait_send_cancel
	ld a, [wPrinterOpcode]
	and a
	jr nz, .wait_send_cancel
.already_done
	ld a, $1
	ldh [hCanceledPrinting], a
	scf
	ret

Printer_CopyTileMapToPrinterTileBuffer:
	coord hl, 0, 0
	coord de, 0, 0, wPrinterTileBuffer
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call CopyData
	ret

Printer_CopyTileMapFromPrinterTileBuffer:
	coord hl, 0, 0, wPrinterTileBuffer
	coord de, 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call CopyData
	ret

Printer_ResetJoypadHRAM:
	xor a
	ldh [hJoyLast], a
	ldh [hJoyReleased], a
	ldh [hJoyPressed], a
	ldh [hJoyHeld], a
	ldh [hJoy5], a
	ldh [hJoy6], a
	ret

;adding GB_PRINTER display-only mode
;Send the drawn tilemap page to the printer (print mode), or just display it
;and wait for a button (display-only mode, NON at the print confirmation
;prompt - see PrinterMenu_AskPrintConfirm in engine/printer/printer_menu.asm).
;In print mode, a = the value for wcae2; returns carry if cancelled with B.
Printer_SendPageOrWait:
	ld [wcae2], a
	ld a, [wPrinterDisplayOnly]
	and a
	jr nz, .display
	call StartTransmission_Send9Rows
	call Printer_CopyTileMapToPrinterTileBuffer
	call LoadScreenTilesFromBuffer1
	call Func_e8dfb
	ret
.display
	ld a, $1
	ldh [H_AUTOBGTRANSFERENABLED], a
	call Printer_WaitForAB
	xor a
	ldh [H_AUTOBGTRANSFERENABLED], a
	call LoadScreenTilesFromBuffer1
	and a ;no cancel in display-only mode
	ret

;Wait for the A or B button: release first, then press, then release again,
;so the press does not leak into the caller's input (same pattern as
;DisplaySurfingMinigameHighScoreScreen in engine/pikachus_beach.asm)
Printer_WaitForAB:
	call Printer_ResetJoypadHRAM
.waitRelease
	call Joypad
	ldh a, [hJoyHeld]
	and PAD_A | PAD_B
	jr nz, .waitRelease
.waitPress
	call Joypad
	ldh a, [hJoyPressed]
	and PAD_A | PAD_B
	jr z, .waitPress
.waitReleaseAfterPress
	call Joypad
	ldh a, [hJoyHeld]
	and PAD_A | PAD_B
	jr nz, .waitReleaseAfterPress
	call Printer_ResetJoypadHRAM
	ret

Printer_PlayPrinterMusic:
	call Printer_FadeOutMusicAndWait
	ld a, [wAudioROMBank]
	ld [wAudioSavedROMBank], a
	ld a, BANK(Music_GBPrinter)
	ld [wAudioROMBank], a
	ld a, MUSIC_GB_PRINTER
	ld [wNewSoundID], a
	call PlaySound
	ret

Printer_PlayMapMusic:
;The printer music is still playing when quitting. Fading it out would
;block the quit path for ~35 frames (7 NR50 steps at a 5-frame interval),
;leaving the screen frozen with no reaction to the B press. Stop it
;instantly instead: the whiteout covers the abrupt music switch.
	call StopAllMusic
	call PlayDefaultMusic
	ret

Printer_FadeOutMusicAndWait:
	ld a, $4
	ld [wAudioFadeOutControl], a
	call StopAllMusic
.wait_music_stop
	ld a, [wAudioFadeOutControl]
	and a
	jr nz, .wait_music_stop
	ret

GBPrinter_CheckForErrors:
	ld a, [wPrinterHandshake]
	cp $81
	jr z, .check_other_errors
	ld a, [wPrinterStatusFlags]
	cp $ff
	jr z, .error2
	xor a
	jr .load_status

.check_other_errors
	ld a, [wPrinterStatusFlags]
	and %11100000
	ret z
	bit 7, a
	jr nz, .error1
	bit 6, a
	jr nz, .error4
	; error 3
	ld a, PRINTER_ERROR_3
	jr .load_status

.error4
	ld a, PRINTER_ERROR_4
	jr .load_status

.error1
	ld a, PRINTER_ERROR_1
	jr .load_status

.error2
	ld a, PRINTER_ERROR_2
.load_status
	ld [wPrinterStatusIndicator], a
	ret

GBPrinter_UpdateStatusMessage:
	ld a, [wPrinterStatusIndicator]
	and a
	ret z
	push af
	xor a
	ldh [H_AUTOBGTRANSFERENABLED], a
	coord hl, 0, 5
	lb bc, 10, 18
	call TextBoxBorder
	pop af
	ld e, a
	ld d, $0
	ld hl, .PrinterStatusMessages
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	;force instant text while (re)drawing the status box: the Yes/No
	;confirmation prompt (DisplayTwoOptionMenu) clears wStatusFlags5 bit 6
	;on exit, so these PlaceString calls would otherwise go through
	;PrintLetterDelay_ and stall ~1 frame per letter. In error mode this
	;routine redraws the whole box every frame, which slowed the print
	;loop down to one B check per ~60 frames and swallowed short B
	;presses (fix 7)
	ld a, [wStatusFlags5]
	push af
	set 6, a
	ld [wStatusFlags5], a
	coord hl, 1, 7
	call PlaceString
	coord hl, 2, 15
	ld de, .PressBToCancel
	call PlaceString
	pop af
	ld [wStatusFlags5], a
	ld a, $1
	ldh [H_AUTOBGTRANSFERENABLED], a
	xor a
	ld [wPrinterStatusIndicator], a
	ret

.PressBToCancel:
	db "B pour annuler@"

.PrinterStatusMessages:
	dw .Blank
	dw .CheckingLink
	dw .Transmitting
	dw .Printing
	dw .Error1
	dw .Error2
	dw .Error3
	dw .Error4
	dw .WrongDevice

.Blank:
	db   "@"
.CheckingLink:
	db   ""
	next "  Vérif. lien...@"
.Transmitting:
	db   ""
	next "     Envoi...@"
.Printing:
	db   ""
	next "   Impression...@"
;joenote - changed the error messages to actually describe what they mean.
;Far more useful than telling the player to check the manual.
.Error1:
	db   "     Erreur 1"
	next " La batterie de"
	next " l'imprimante est"
	next " trop faible.@"
.Error2:
	db   "     Erreur 2"
	next " Le câble Link"
	next " n'est pas"
	next " connecté.@"
.Error3:
	db   "     Erreur 3"
	next ""
	next "  Voir le manuel"
	next "  du GB Printer.@"
.Error4:
	db   "     Erreur 4"
	next " L'imprimante est"
	next " trop chaude ou"
	next " trop froide.@"
.WrongDevice:
	db   "     Erreur 5"
	next ""
	next "  Ce n'est pas le"
	next "  GB Printer !@"

;This is used for the diploma as well as the Pikachu's Beach high score screen
Diploma_Surfing_CopyBox:
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

PrintPCBox_DrawPage1:
	xor a
	ld [wBoxNumString], a
	call ClearScreen
	call PrintPCBox_PlaceHorizontalLines
	coord hl, 0, 0
	ld bc, 11 * SCREEN_WIDTH
	ld a, " "
	call FillMemory
	call PrintPCBox_DrawLeftAndRightBorders
	call PrintPCBox_DrawTopBorder
	coord hl, 4, 4
	ld de, .PokemonListString
	call PlaceString
	coord hl, 7, 6
	ld de, .BoxString
	call PlaceString
	coord hl, 13, 6
	ld a, [wCurrentBoxNum]
	and $7f
	cp 9
	jr c, .less_than_9
	sub 9
	ld [hl], "1"
	inc hl
	add "0"
	jr .placed_box_number

.less_than_9
	add "1"
.placed_box_number
	ld [hl], a
	coord hl, 4, 9
	ld de, wBoxSpecies
	ld c, $3
	call PrintPCBox_PlaceBoxMonInfo
	ret

.PokemonListString: db "Liste <pkmn>@"
.BoxString: db "Boîte@"

PrintPCBox_DrawPage2:
	call ClearScreen
	call PrintPCBox_PlaceHorizontalLines
	call PrintPCBox_DrawLeftAndRightBorders
	ld a, [wBoxDataStart]
	cp 4
	ret c
	coord hl, 4, 0
	ld de, wBoxSpecies + 3
	ld c, 6
	call PrintPCBox_PlaceBoxMonInfo
	ret

PrintPCBox_DrawPage3:
	call ClearScreen
	call PrintPCBox_PlaceHorizontalLines
	call PrintPCBox_DrawLeftAndRightBorders
	ld a, [wBoxDataStart]
	cp 10
	ret c
	coord hl, 4, 0
	ld de, wBoxSpecies + 9
	ld c, 6
	call PrintPCBox_PlaceBoxMonInfo
	ret

PrintPCBox_DrawPage4:
	call ClearScreen
	call PrintPCBox_PlaceHorizontalLines
	call PrintPCBox_DrawLeftAndRightBorders
	coord hl, 0, 15
	call PrintPCBox_DrawBottomBorderAtHL
	coord hl, 0, 16
	ld bc, 2 * SCREEN_WIDTH
	ld a, " "
	call FillMemory
	ld a, [wBoxDataStart]
	cp 16
	ret c
	coord hl, 4, 0
	ld de, wBoxSpecies + 15
	ld c, 5
	call PrintPCBox_PlaceBoxMonInfo
	ret

PrintPCBox_PlaceBoxMonInfo:
.loop
	ld a, c
	and a
	jr z, .done
	dec c
	ld a, [de]
	cp $ff
	jr z, .done
	ld [wPokeBallAnimData], a
	push bc
	push hl
	push de
	push hl
	ld bc, 12
	ld a, " "
	call FillMemory
	pop hl
	push hl
	ld de, SCREEN_WIDTH
	add hl, de
	ld bc, 12
	ld a, " "
	call FillMemory
	pop hl
	push hl
	call GetMonName
	pop hl
	call PlaceString
	push hl
	ld hl, wBoxMonNicks
	ld bc, NAME_LENGTH
	ld a, [wBoxNumString]
	call AddNTimes
	ld e, l
	ld d, h
	pop hl
	ld bc, SCREEN_WIDTH + 1
	add hl, bc
	ld [hl], " "
	inc hl
	call PlaceString
	ld hl, wBoxNumString
	inc [hl]
	pop de
	pop hl
	ld bc, 3 * SCREEN_WIDTH
	add hl, bc
	pop bc
	inc de
	jr .loop

.done
	ret

PrintPCBox_DrawTopBorder:
	coord hl, 0, 0
	ld a, $79
	ld [hli], a
	ld a, $7a
	ld c, SCREEN_WIDTH - 2
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ld a, $7b
	ld [hl], a
	ret

PrintPCBox_DrawLeftAndRightBorders:
	coord hl, 0, 0
	ld de, SCREEN_WIDTH - 1
	ld c, SCREEN_HEIGHT
.loop
	ld a, $7c
	ld [hl], a
	add hl, de
	ld a, $7c
	ld [hli], a
	dec c
	jr nz, .loop
	ret

PrintPCBox_DrawBottomBorder:
	coord hl, 0, 17
PrintPCBox_DrawBottomBorderAtHL:
	ld a, $7d
	ld [hli], a
	ld a, $7a
	ld c, SCREEN_WIDTH - 2
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ld a, $7e
	ld [hl], a
	ret

PrintPCBox_PlaceHorizontalLines:
	coord hl, 4, 0
	ld c, 6
	call .PlaceHorizontalLine
	coord hl, 6, 1
	ld c, 6
.PlaceHorizontalLine:
.loop
	push bc
	push hl
	ld de, .HorizontalLineString
	call PlaceString
	pop hl
	ld bc, 3 * SCREEN_WIDTH
	add hl, bc
	pop bc
	dec c
	jr nz, .loop
	ret

.HorizontalLineString:
	db "----------@"
