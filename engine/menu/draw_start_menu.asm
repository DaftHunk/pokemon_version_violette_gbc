; function that displays the start menu
DrawStartMenu:
	CheckEvent EVENT_GOT_SS_TICKET
	jr nz, .hasMeetBill

	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .hasPokedex

	; shorter menu if the player doesn't have the pokedex and portablePC
	coord hl, 10, 0
	lb bc, 12, 8
	jr .drawTextBoxBorder
.hasPokedex
	; menu with pokedex
	coord hl, 10, 0
	lb bc, 14, 8
	jr .drawTextBoxBorder
.hasMeetBill
	; menu with pokedex + portablePC
	coord hl, 10, 0
	lb bc, 16, 8
	jr .drawTextBoxBorder
.drawTextBoxBorder
	call TextBoxBorder
	ld a, D_DOWN | D_UP | START | B_BUTTON | A_BUTTON
	ld [wMenuWatchedKeys], a
	ld a, $02
	ld [wTopMenuItemY], a ; Y position of first menu choice
	ld a, $0b
	ld [wTopMenuItemX], a ; X position of first menu choice
	ld a, [wBattleAndStartSavedMenuItem] ; remembered menu selection from last time
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld hl, wd730
	set 6, [hl] ; no pauses between printing each letter
	coord hl, 12, 2
	CheckEvent EVENT_GOT_POKEDEX
; case for not having pokedex
	ld a, $08 ; edited for portablePC
	jr z, .storeMenuItemCount
; case for having pokedex
	ld de, StartMenuPokedexText
	call PrintStartMenuItem
	ld a, $07
.storeMenuItemCount
	ld [wMaxMenuItem], a ; number of menu items
	ld de, StartMenuPokemonText
	call PrintStartMenuItem
	ld de, StartMenuItemText
	call PrintStartMenuItem
	ld de, wPlayerName ; player's name
	call PrintStartMenuItem
	ld a, [wd72e]
	bit 6, a ; is the player using the link feature?
; case for not using link feature
	ld de, StartMenuSaveText
	jr z, .printSaveOrResetText
; case for using link feature
	ld de, StartMenuResetText
.printSaveOrResetText
	call PrintStartMenuItem
	ld de, StartMenuOptionText
	call PrintStartMenuItem
;;; Portable PC in the START menu
	CheckEvent EVENT_GOT_SS_TICKET
	jr z, .dontPrintPortablePC
	ld de, StartMenuPortablePCText
	call PrintStartMenuItem
.dontPrintPortablePC
	ld de, StartMenuExitText
;;;;;;;;;;;;;;;
	call PlaceString
	ld hl, wd730
	res 6, [hl] ; turn pauses between printing letters back on
	ret

StartMenuPokedexText:
	db "#dex@"

StartMenuPokemonText:
	db "#mon@"

StartMenuItemText:
	db "Objet@"

StartMenuSaveText:
	db "Sauver@"

StartMenuResetText:
	db "Quitter@"

StartMenuExitText:
	db "Retour@"

StartMenuOptionText:
	db "Option@"

StartMenuPortablePCText: ; new
	db "Box PC@"

PrintStartMenuItem:
	push hl
	call PlaceString
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret
