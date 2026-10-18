; PureRGBnote: CHANGED: a lot of this file was modified for new functionalities like pressing START/SELECT to bring up map/movedex
; and new info in the data page / seeking between pokemon on the data page / showing the back sprite via SELECT on the data page

ShowPokedexMenu:
	call GBPalWhiteOut
	call ClearScreen
	call UpdateSprites
	ld a, [wListScrollOffset]
	push af
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld [wLastMenuItem], a
	inc a
	ld [wPokedexNum], a
	ldh [hJoy7], a
.setUpGraphics
	ld b, SET_PAL_GENERIC
	call RunPaletteCommand
	callfar LoadPokedexTilePatterns
;;;;;;;;;;; PureRGBnote: ADDED: load these new button prompt graphics into VRAM
	ld de, PokedexPromptGraphics
	ld hl, vChars1 tile $40
	lb bc, BANK(PokedexPromptGraphics), (PokedexPromptGraphicsEnd - PokedexPromptGraphics) / $10
	call CopyVideoData
;;;;;;;;;;
.doPokemonListMenu
	ld hl, wTopMenuItemY
	ld a, 3
	ld [hli], a ; top menu item Y
	xor a
	ld [hli], a ; top menu item X
	inc a
	ld [wMenuWatchMovingOutOfBounds], a
	inc hl
	inc hl
	ld a, 6
	ld [hli], a ; max menu item ID
	ld [hl], D_LEFT | D_RIGHT | B_BUTTON | A_BUTTON | SELECT | START ; PureRGBnote: ADDED: track the SELECT and START buttons in order to trigger new functions
	call HandlePokedexListMenu
	jr c, .goToSideMenu ; if the player chose a pokemon from the list
	cp 1
	jr z, .selectPressed
	cp 2
	jr z, .startPressed
.exitPokedex
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ldh [hJoy7], a
	ld [wOverrideSimulatedJoypadStatesMask], a
	pop af
	ld [wListScrollOffset], a
	call GBPalWhiteOutWithDelay3
	call RunDefaultPaletteCommand
.exitPokedex2
	jp ReloadMapData
.goToSideMenu
	call HandlePokedexSideMenu
	dec b
	jr z, .exitPokedex ; if the player chose Quit
	dec b
	jr z, .doPokemonListMenu ; if pokemon not seen or player pressed B button
	jp .setUpGraphics ; if pokemon data or area was shown
.selectPressed
	pop af
	ld [wListScrollOffset], a
	ld a, SFX_SWITCH
	call PlaySound
	callfar DisplayTownMap
	jr .exitPokedex2
.startPressed
	pop af
	ld [wListScrollOffset], a
	jp ShowMovedexMenu

; handles the menu on the lower right in the pokedex screen
; OUTPUT:
; b = reason for exiting menu
; 00: showed pokemon data or area
; 01: the player chose Quit
; 02: the pokemon has not been seen yet or the player pressed the B button
HandlePokedexSideMenu:
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	push af
	ld b, a
	ld a, [wLastMenuItem]
	push af
	ld a, [wListScrollOffset]
	push af
	add b
	inc a
	ld [wPokedexNum], a
	push af
	ld a, [wDexMaxSeenMon]
	push af ; this doesn't need to be preserved
	ld hl, wPokedexSeen
	call IsPokemonBitSet
	ld b, 2
	jr z, .exitSideMenu
	call PokedexToIndex
	ld hl, wTopMenuItemY
	ld a, 8
	ld [hli], a ; top menu item Y
	ld a, 15
	ld [hli], a ; top menu item X
	xor a
	ld [hli], a ; current menu item ID
	inc hl
	ld a, 4
	ld [hli], a ; max menu item ID
	ld a, A_BUTTON | B_BUTTON
	ld [hli], a ; menu watched keys (A button and B button)
	xor a
	ld [hli], a ; old menu item ID
	ld [wMenuWatchMovingOutOfBounds], a
.handleMenuInput
	call HandleMenuInput
	bit BIT_B_BUTTON, a
	ld b, 2
	jr nz, .buttonBPressed
	ld a, [wCurrentMenuItem]
	and a
	jr z, .choseData
	dec a
	jr z, .choseCry
	dec a
	jr z, .choseArea
	dec a
	jr z, .choseCapa
	dec a
	jr z, .choseCSCT
.exitSideMenu
	pop af
	ld [wDexMaxSeenMon], a
	pop af
	ld [wPokedexNum], a
	pop af
	ld [wListScrollOffset], a
	pop af
	ld [wLastMenuItem], a
	pop af
	ld [wCurrentMenuItem], a
	push bc
	coord hl, 0, 3
	ld de, 20
	lb bc, " ", 13
	call DrawTileLine ; cover up the menu cursor in the pokemon list
	pop bc
	ret

.buttonBPressed
	push bc
	coord hl, 15, 8
	ld de, 20
	lb bc, " ", 5
	call DrawTileLine ; cover up the menu cursor in the side menu
	pop bc
	jr .exitSideMenu

.choseData
	pop af
	pop af
	pop af
	ld [wListScrollOffset], a
	pop af
	pop af
	ld [wCurrentMenuItem], a
	ld a, 0
  	ld [wMoveListCounter], a
	call ShowPokedexDataInternal
	ld b, 0
	push bc
	jr .exitedData

; play pokemon cry
.choseCry
	ld a, [wPokedexNum]
	call PlayCry
	jr .handleMenuInput

.choseArea
	predef LoadTownMap_Nest ; display pokemon areas
	ld b, 0
	jr .exitSideMenu

.exitedData
	coord hl, 0, 3
	ld de, 20
	lb bc, " ", 13
	call DrawTileLine ; cover up the menu cursor in the pokemon list
	pop bc
	ret

.choseCapa ; Changed this to print learnsets
	ld a, 1
	ld [wMoveListCounter], a
	call ShowPokedexCapa
	ld b, 0
	jr .exitSideMenu

; show the list of TMs and HMs the pokemon can learn
.choseCSCT
	call ShowPokedexCSCT
	ld b, 0
	jr .exitSideMenu

; handles the list of pokemon on the left of the pokedex screen
; sets carry flag if player presses A, unsets carry flag if player presses B
HandlePokedexListMenu:
	xor a
	ldh [H_AUTOBGTRANSFERENABLED], a
;;;;;;;;;;; PureRGBnote: ADDED: If we got the town map, draw the "SELECT: MAP" prompt at the very bottom
	CheckEvent EVENT_GOT_TOWN_MAP
	jr z, .movedexPrompt
	coord hl, 1, 17
	ld a, $C0 ; tile in VRAM that this prompt starts at, it's 6 tiles horizontally across
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
.movedexPrompt
	coord hl, 7, 17
;	CheckEvent EVENT_GOT_MOVEDEX
;	jr z, .noSelectPrompt
	ld a, $C6
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
.noSelectPrompt
;;;;;;;;;;;
; draw the horizontal line separating the seen and owned amounts from the menu
	coord hl, 15, 6
	ld a, "─"
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	coord hl, 14, 0
	ld [hl], $71 ; vertical line tile
	coord hl, 14, 1
	call DrawPokedexVerticalLine
	coord hl, 14, 9
	call DrawPokedexVerticalLine
	ld hl, wPokedexSeen
	ld b, wPokedexSeenEnd - wPokedexSeen
	call CountSetBits
	ld de, wNumSetBits
	coord hl, 16, 2
	lb bc, 1, 3
	call PrintNumber ; print number of seen pokemon
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld de, wNumSetBits
	coord hl, 16, 5
	lb bc, 1, 3
	call PrintNumber ; print number of owned pokemon
	coord hl, 16, 1
	ld de, PokedexSeenText
	call PlaceString
	coord hl, 16, 4
	ld de, PokedexOwnText
	call PlaceString
	coord hl, 1, 1
	ld de, PokedexContentsText
	call PlaceString
	coord hl, 16, 8
	ld de, PokedexMenuItemsText
	call PlaceString

; find the lowest pokedex number among the pokemon the player has seen
	ld hl, wPokedexSeen
	ld b, 0
.minSeenPokemonLoop
	ld a, [hli]
	ld c, 0
.minSeenPokemonInnerLoop
	inc b
	srl a
	jr c, .storeMinSeenPokemon
	ld d, a
	inc c
	ld a, c
	cp 8
	ld a, d
	jr nz, .minSeenPokemonInnerLoop
	jr .minSeenPokemonLoop

.storeMinSeenPokemon
	ld a, b
	ld [wDexMinSeenMon], a
; find the highest pokedex number among the pokemon the player has seen
	ld hl, wPokedexSeenEnd - 1
	ld b, (wPokedexSeenEnd - wPokedexSeen) * 8 + 1
.maxSeenPokemonLoop
	ld a, [hld]
	ld c, 8
.maxSeenPokemonInnerLoop
	dec b
	add a
	jr c, .storeMaxSeenPokemon
	dec c
	jr nz, .maxSeenPokemonInnerLoop
	jr .maxSeenPokemonLoop

.storeMaxSeenPokemon
	ld a, b
	ld [wDexMaxSeenMon], a
.loop
	xor a
	ldh [H_AUTOBGTRANSFERENABLED], a
	coord hl, 4, 2
	lb bc, 14, 10
	call ClearScreenArea
	coord hl, 1, 3
	ld a, [wListScrollOffset]
	ld [wPokedexNum], a
	ld d, 7
	ld a, [wDexMaxSeenMon]
	cp 7
	jr nc, .printPokemonLoop
	ld d, a
	dec a
	ld [wMaxMenuItem], a
; loop to print pokemon pokedex numbers and names
; if the player has owned the pokemon, it puts a pokeball beside the name
.printPokemonLoop
	ld a, [wPokedexNum]
	inc a
	ld [wPokedexNum], a
	push af
	push de
	push hl
	ld de, -SCREEN_WIDTH
	add hl, de
	ld de, wPokedexNum
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	ld de, SCREEN_WIDTH
	add hl, de
	dec hl
	push hl
	ld hl, wPokedexOwned
	call IsPokemonBitSet
	pop hl
	ld a, " "
	jr z, .writeTile
	ld a, $E4 ; pokeball tile
.writeTile
	ld [hl], a ; put a pokeball next to pokemon that the player has owned
	push hl
	ld hl, wPokedexSeen
	call IsPokemonBitSet
	jr nz, .getPokemonName ; if the player has seen the pokemon
	ld de, .dashedLine ; print a dashed line in place of the name if the player hasn't seen the pokemon
	jr .skipGettingName
.dashedLine ; for unseen pokemon in the list
	db "----------@"
.getPokemonName
	call PokedexToIndex
	call GetMonName
.skipGettingName
	pop hl
	inc hl
	call PlaceString
	pop hl
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	pop de
	pop af
	ld [wPokedexNum], a
	dec d
	jr nz, .printPokemonLoop
	ld a, 01
	ldh [H_AUTOBGTRANSFERENABLED], a
	call Delay3
	call GBPalNormal
	call HandleMenuInput
;;;;;;;;;; PureRGBnote: ADDED: track the SELECT button in order to trigger town map when able
	bit BIT_START, a
	jp nz, .startPressed
;;;;;;;;;;
;;;;;;;;;; PureRGBnote: ADDED: track the SELECT button in order to trigger town map when able
	bit BIT_SELECT, a
	jp nz, .selectPressed
;;;;;;;;;;
	bit BIT_B_BUTTON, a
	jp nz, .buttonBPressed
;;;;;;;;;; PureRGBnote: FIXED: code from yellow, avoids a bug where pressing down/up and then 
;;;;;;;;;; immediately A scrolls up/down twice instead of selecting the next pokemon
	bit BIT_A_BUTTON, a 
	jp nz, .buttonAPressed 
;;;;;;;;;;
.checkIfUpPressed
	bit BIT_D_UP, a
	jr z, .checkIfDownPressed
.upPressed ; scroll up one row
	ld a, [wListScrollOffset]
	and a
	jp z, .loop
	dec a
	ld [wListScrollOffset], a
	jp .loop
.checkIfDownPressed
	bit BIT_D_DOWN, a
	jr z, .checkIfRightPressed
.downPressed ; scroll down one row
	ld a, [wDexMaxSeenMon]
	cp 7
	jp c, .loop ; can't if the list is shorter than 7
	sub 7
	ld b, a
	ld a, [wListScrollOffset]
	cp b
	jp z, .loop
	inc a
	ld [wListScrollOffset], a
	jp .loop
.checkIfRightPressed
	bit BIT_D_RIGHT, a
	jr z, .checkIfLeftPressed
.rightPressed ; scroll down 7 rows
	ld a, [wDexMaxSeenMon]
	cp 7
	jp c, .loop ; can't if the list is shorter than 7
	sub 6
	ld b, a
	ld a, [wListScrollOffset]
	add 7
	ld [wListScrollOffset], a
	cp b
	jp c, .loop
	dec b
	ld a, b
	ld [wListScrollOffset], a
	jp .loop
.checkIfLeftPressed ; scroll up 7 rows
	bit BIT_D_LEFT, a
	jr z, .buttonAPressed
.leftPressed
	ld a, [wListScrollOffset]
	sub 7
	ld [wListScrollOffset], a
	jp nc, .loop
	xor a
	ld [wListScrollOffset], a
	jp .loop
.buttonAPressed
	scf
	ld a, 0
	ret
.buttonBPressed
	and a
	ld a, 0
	ret
;;;;;;;;;; PureRGBnote: CHANGED: SELECT button will open the town map while in the pokedex. You need the town map from rival's sister to do this.
;;;;;;;;;; Town map doesn't take up space in the bag due to this modification.
.selectPressed
	CheckEvent EVENT_GOT_TOWN_MAP
	jp z, .loop
	ld a, SFX_SWITCH
	Call PlaySound
	ld a, 1
	and a
	ret
;;;;;;;;;; PureRGBnote: CHANGED: START button will open new MoveDex.
.startPressed
;	CheckEvent EVENT_GOT_MOVEDEX
;	jp z, .loop
	ld a, SFX_SWITCH
	Call PlaySound
	ld a, 2
	and a
	ret
;;;;;;;;;;

DrawPokedexVerticalLine:
	ld c, 9 ; height of line
	ld de, SCREEN_WIDTH
	ld a, $71 ; vertical line tile
.loop
	ld [hl], a
	add hl, de
	xor 1 ; toggle between vertical line tile and box tile
	dec c
	jr nz, .loop
	ret

PokedexSeenText:
	db "Vus@"

PokedexOwnText:
	db "Pris@"

PokedexContentsText:
	db "Sommaire@"

PokedexMenuItemsText:
	db   "Info"
	next "Cri"
	next "Zone"
	next "Capa"
	next "CSCT@"

; tests if a pokemon's bit is set in the seen or owned pokemon bit fields
; INPUT:
; [wPokedexNum] = pokedex number
; hl = address of bit field
IsPokemonOwnedBitSet:
	ld hl, wPokedexOwned
IsPokemonBitSet:
	ld a, [wPokedexNum]
	dec a
	ld c, a
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	and a
	ret

ShowPokedexDataInternal:
	ld hl, wPokedexDataFlags
	res BIT_POKEDEX_DATA_DISPLAY_TYPE, [hl]
	coord hl, 10, 16 ; where the text down arrow should end up flashing at
	ld a, h
	ld [wMenuCursorLocation], a
	ld a, l
	ld [wMenuCursorLocation+1], a
	; load pokedex data page UI tiles (left + right arrows)
	ld de, PokedexDataUI
	lb bc, BANK(PokedexDataUI), 2
	ld hl, vChars1 tile $4C
	call CopyVideoDataDouble

	ld a, B_BUTTON
	ld [wMenuWatchedKeys], a ; buttons this menu will track when displaying text (A Button used to proceed the text)

	jr ShowPokedexDataCommon

; function to display pokedex data from outside the pokedex
ShowPokedexData:
	ld hl, wPokedexDataFlags
	set BIT_POKEDEX_DATA_DISPLAY_TYPE, [hl]
	CheckEvent EVENT_GOT_POKEDEX
	ld a, B_BUTTON 
	jr nz, .loadButtons
	xor a
.loadButtons
	ld [wMenuWatchedKeys], a
	coord hl, 18, 16 ; where the text down arrow should end up flashing at
	ld a, h
	ld [wMenuCursorLocation], a
	ld a, l
	ld [wMenuCursorLocation+1], a

	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	callfar LoadPokedexTilePatterns ; load pokedex tiles

; function to display pokedex data from inside the pokedex
ShowPokedexDataCommon:
	ld hl, wStatusFlags2
	set 1, [hl]
	ld a, $33 ; 3/7 volume
	ldh [rNR50], a
	call GBPalWhiteOut ; zero all palettes
	call ClearScreen
	ld hl, wPokedexDataFlags
	set BIT_VIEWING_POKEDEX, [hl] ; flag indicates we're currently in the pokedex data page
	ldh a, [hTilesetType]
	push af
	xor a
	ldh [hTilesetType], a

	coord hl, 0, 0
	ld de, 1
	lb bc, $64, SCREEN_WIDTH
	call DrawTileLine ; draw top border

	coord hl, 0, 1
	ld de, 20
	lb bc, $66, $10
	call DrawTileLine ; draw left border

	coord hl, 19, 1
	ld b, $67
	call DrawTileLine ; draw right border

	ld a, $63 ; upper left corner tile
	Coorda 0, 0
	ld a, $65 ; upper right corner tile
	Coorda 19, 0
	ld a, $6c ; lower left corner tile
	Coorda 0, 17
	ld a, $6e ; lower right corner tile
	Coorda 19, 17

	coord hl, 2, 8
	ld a, "№"
	ld [hli], a
	ld a, "."
	ld [hli], a

	coord hl, 0, 9
	ld de, PokedexDataDividerLine
	call PlaceString ; draw horizontal divider line

	; fall through

ShowNextPokemonData:
	ld hl, wPokedexDataFlags
	res BIT_POKEDEX_WHICH_SPRITE_SHOWING, [hl]
	res BIT_POKEDEX_DATA_SHINY, [hl] ; shared with the town map area flags, clear any residue
	ld a, [wPokedexNum] ; pokemon ID
	ld [wcf91], a
	ld [wBattleMonSpecies2], a
	push af
	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand
	pop af
	ld [wPokedexNum], a

	coord hl, 9, 6
	ld de, HeightWeightText
	call PlaceString

	call GetMonName
	coord hl, 9, 2
	call PlaceString

	ld hl, PokedexEntryPointers
	ld a, [wPokedexNum]
	dec a
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl] ; de = address of pokedex entry

	coord hl, 9, 4
	call PlaceString ; print species name

	ld h, b
	ld l, c
	push de
	ld a, [wPokedexNum]
	push af
	call IndexToPokedex

	coord hl, 4, 8
	ld de, wPokedexNum
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber ; print pokedex number

	ld a, [wPokedexDataFlags]
	bit BIT_POKEDEX_DATA_DISPLAY_TYPE, a
	jr nz, .noPrevNextPrompt

	coord hl, 1, 17
	ld a, [wDexMinSeenMon]
	ld b, a
	ld a, [wPokedexNum]
	cp b
	ld a, $CC ; < prompt
	jr nz, .loadLeftPrompt
	ld a, $6f ; border tile instead
.loadLeftPrompt
	ld [hl], a

	coord hl, 18, 17
	ld a, [wDexMaxSeenMon]
	ld b, a
	ld a, [wPokedexNum]
	cp b
	ld a, $CD ; > prompt
	jr nz, .loadRightPrompt
	ld a, $6f ; border tile instead
.loadRightPrompt
	ld [hl], a

	coord hl, 2, 17
	lb bc, $6f, 16
	jr .drawBottomBorder
.noPrevNextPrompt
	coord hl, 1, 17
	lb bc, $6f, 18
.drawBottomBorder
	ld de, 1
	call DrawTileLine ; draw bottom border

.checkLeftRightButtonFunctionality
	ld a, [wPokedexDataFlags]
	bit BIT_POKEDEX_DATA_DISPLAY_TYPE, a
	jr nz, .noLeftRight ; no left or right tracking when we are displaying an external pokedex entry
	; we will add D_RIGHT and D_LEFT to the tracked buttons if going left or right to other pokedex entries is allowed
	ld a, [wMenuWatchedKeys]
	ld b, a
	ld a, [wPokedexNum]
	ld c, a
	ld a, [wDexMaxSeenMon]
	cp c
	jr z, .noRight
	ld a, D_RIGHT
	or b
	ld b, a
.noRight
	ld a, [wDexMinSeenMon]
	cp c
	jr z, .noLeft
	ld a, D_LEFT
	or b
	ld b, a
.noLeft
	ld a, b ; buttons to watch while displaying description/base stats
	ld [wMenuWatchedKeys], a
.noLeftRight

	ld hl, wPokedexOwned
	call IsPokemonBitSet
	pop af
	ld [wPokedexNum], a
	ld a, [wcf91]
	ld [wd0b5], a
	pop de

	push af
	push bc
	push de
	push hl

	call Delay3
	call GBPalNormal
	call GetMonHeader ; load pokemon picture location
	coord hl, 1, 1
	call LoadFlippedFrontSpriteByMonIndex ; draw pokemon picture
	ld a, [wcf91]
	call PlayCry

	pop hl
	pop de
	pop bc
	pop af

	ld a, c
	and a
	jp z, .seenOnly ; if the pokemon has not been owned, don't print the height or weight, but show their type


	CheckEvent EVENT_GOT_POKEDEX
	jr z, .printHeightWeight ; don't track the select button if we're showing the starter dex entries before getting the pokedex

	ld a, [wd0b5]
	cp MISSINGNO
	jr z, .printHeightWeight ; missingno's pics are not compatible with the back sprite / shiny palette preview
	ld a, [wMenuWatchedKeys]
	or SELECT | START
	ld [wMenuWatchedKeys], a ; watch SELECT and START too if the pokemon is owned (SELECT shows the back sprite, START toggles the shiny palette)

.printHeightWeight
	inc de ; de = address of feet (height)
	ld a, [de] ; reads feet, but a is overwritten without being used
	coord hl, 12, 6
	lb bc, 1, 2
	call PrintNumber ; print feet (height)
	ld [hl], ","
	inc de
	inc de ; de = address of inches (height)
	coord hl, 15, 6
	lb bc, LEADING_ZEROES | 1, 2
	call PrintNumber ; print inches (height)
	ld [hl], "m"
; now print the weight (note that weight is stored in tenths of pounds internally)
	inc de
	inc de
	inc de ; de = address of upper byte of weight
	push de
; put weight in big-endian order at hDexWeight
	ld hl, hDexWeight
	ld a, [hl] ; save existing value of [hDexWeight]
	push af
	ld a, [de] ; a = upper byte of weight
	ld [hli], a ; store upper byte of weight in [hDexWeight]
	ld a, [hl] ; save existing value of [hDexWeight + 1]
	push af
	dec de
	ld a, [de] ; a = lower byte of weight
	ld [hl], a ; store lower byte of weight in [hDexWeight + 1]
	ld de, hDexWeight
	coord hl, 11, 8
	lb bc, 2, 5 ; 2 bytes, 5 digits
	call PrintNumber ; print weight
	coord hl, 14, 8
	ldh a, [hDexWeight + 1]
	sub 10
	ldh a, [hDexWeight]
	sbc 0
	jr nc, .next
	ld [hl], "0" ; if the weight is less than 10, put a 0 before the decimal point
.next
	inc hl
	ld a, [hli]
	ld [hld], a ; make space for the decimal point by moving the last digit forward one tile
	ld [hl], "." ; decimal point tile
	pop af
	ldh [hDexWeight + 1], a ; restore original value of [hDexWeight + 1]
	pop af
	ldh [hDexWeight], a ; restore original value of [hDexWeight]

.printDescription
	pop hl
	push hl
	inc hl ; hl = address of pokedex description text
	bccoord 1, 11
	ld a, %10
	ldh [hClearLetterPrintingDelayFlags], a
	call TextCommandProcessor ; print pokedex description text
	CheckEvent EVENT_GOT_POKEDEX
	jp z, .starterDisplay ; don't display additional page if we're showing the starters before getting the pokedex.
	ld a, [wMenuWatchedKeys]
	ld c, a
	ldh a, [hJoy5]
	ld b, a
	and c
	jr nz, .buttonTracking1
	callfar TextCommandPromptMultiButton
	ldh a, [hJoy5]
	ld b, a
.buttonTracking1
	bit BIT_A_BUTTON, b
	jr nz, .printBaseStats
	bit BIT_B_BUTTON, b
	jp nz, .exitDataPage
	bit BIT_D_LEFT, b
	jp nz, .prevMon
	bit BIT_D_RIGHT, b
	jp nz, .nextMon
	bit BIT_SELECT, b
	jp nz, .switchMonSprite
	bit BIT_START, b
	jp nz, .shinyPaletteFromDescription
;;;;;;;;;; PureRGBnote: ADDED: pokedex will display the pokemon's types and their base stats on a new third page.
.printBaseStats
	coord hl, 1, 10
	lb bc, 7, 18
	call ClearScreenArea
	; print mon base stats
	coord hl, 9, 10
	ld de, BaseStatsText
	call PlaceString
	coord hl, 12, 11
	ld de, HPText
	call PlaceString
	ld de, wMonHBaseHP
	coord hl, 15, 11
	lb bc, 1, 3
	call PrintNumber 
	coord hl, 11, 12
	ld de, AtkText
	call PlaceString
	ld de, wMonHBaseAttack
	coord hl, 15, 12
	lb bc, 1, 3
	call PrintNumber 
	coord hl, 11, 13
	ld de, DefText
	call PlaceString
	ld de, wMonHBaseDefense
	coord hl, 15, 13
	lb bc, 1, 3
	call PrintNumber
	coord hl, 11, 14
	ld de, SpdText
	call PlaceString
	ld de, wMonHBaseSpeed
	coord hl, 15, 14
	lb bc, 1, 3
	call PrintNumber
	coord hl, 11, 15
	ld de, SpcText
	call PlaceString
	ld de, wMonHBaseSpecial
	coord hl, 15, 15
	lb bc, 1, 3
	call PrintNumber 
	coord hl, 9, 16
	ld de, TotalText
	call PlaceString
	; calculate the base stat total to print it
	ld b, 0
	ld a, [wMonHBaseHP]
	ld hl, 0
	ld c, a
	add hl, bc
	ld a, [wMonHBaseAttack]
	ld c, a
	add hl, bc
	ld a, [wMonHBaseDefense]
	ld c, a
	add hl, bc
	ld a, [wMonHBaseSpeed]
	ld c, a
	add hl, bc
	ld a, [wMonHBaseSpecial]
	ld c, a
	add hl, bc
	ld a, h
	ld [wSum], a
	ld a, l
	ld [wSum+1], a
	ld de, wSum
	coord hl, 15, 16
	lb bc, 2, 3
	call PrintNumber
	jr .printMonTypes

.seenOnly
	push hl
;;;;;;;;;;; PureRGBnote: ADDED: code for printing the current pokemon's type(s)
.printMonTypes
	coord hl, 1, 11
	ld de, DexType1Text
	call PlaceString
	coord hl, 2, 12
	predef PrintMonType
	coord hl, 2, 14
	ld a, [hl]
	cp " "
	jr z, .waitForButtonPress2 ; don't print TYPE2/ if the pokemon has 1 type only.
	coord hl, 1, 13
	ld de, DexType2Text
	call PlaceString
	jr .waitForButtonPress2
.starterDisplay
	ld a, [wMenuWatchedKeys]
	or A_BUTTON
	ld [wMenuWatchedKeys], a
.waitForButtonPress2
;;;;;;;;;;
	call JoypadLowSensitivity
	ld a, [wMenuWatchedKeys]
	ld c, a
	ldh a, [hJoy5]
	ld b, a
	and c
	jr z, .waitForButtonPress2
.buttonTracking2
	bit BIT_B_BUTTON, b
	jp nz, .exitDataPage
	bit BIT_D_LEFT, b
	jp nz, .prevMon
	bit BIT_D_RIGHT, b
	jp nz, .nextMon
	bit BIT_SELECT, b
	jp nz, .switchMonSprite
	bit BIT_START, b
	jp nz, .shinyPaletteFromStats
	bit BIT_A_BUTTON, b
	jp nz, .exitDataPage ; only an option if in the starter pokedex display at the beginning of the game
.exitDataPage
	xor a
	ldh [hClearLetterPrintingDelayFlags], a
	ld [wPokedexDataFlags], a
	pop hl
	pop af
	ldh [hTilesetType], a
	call GBPalWhiteOut
	call ClearScreen
	call RunDefaultPaletteCommand
	call LoadTextBoxTilePatterns
	call GBPalNormal
	ld hl, wStatusFlags2
	res 1, [hl]
	ld a, $77 ; max volume
	ldh [rNR50], a
	ret
.switchMonSprite
	ld a, [wPokedexNum]
	push af
	call IndexToPokedex
	coord hl, 1, 1
	lb bc, 7, 8
	call ClearScreenArea
	ld a, [wPokedexDataFlags]
	bit BIT_POKEDEX_DATA_SHINY, a
	jr z, .noShinySymbol
	ld a, "<SHINY>"
	Coorda 8, 1 ; keep the shiny symbol displayed across sprite switches
.noShinySymbol
	ld a, [wPokedexDataFlags]
	xor %00000010 ; toggle BIT_POKEDEX_WHICH_SPRITE_SHOWING
	bit BIT_POKEDEX_WHICH_SPRITE_SHOWING, a
	ld [wPokedexDataFlags], a
	jr nz, .backSprite
.frontSprite
	coord hl, 1, 1
	call LoadFlippedFrontSpriteByMonIndex ; draw front sprite
	jr .reloadwPokedexNum
.backSprite
	; the mon header is still loaded from ShowNextPokemonData
	ld hl, wMonHBackSprite - wMonHeader
	call UncompressMonSprite
	callba LoadUncompressedBackPics ; interlace the 48x48 back sprite into vBackPic ($9310)
	ld a, $31 ; back pic tiles start at tile ID $31 (vBackPic), same as in battle
	ldh [hStartTileID], a
	coord hl, 1, 1
	predef CopyUncompressedPicToTilemap
	jr .reloadwPokedexNum
; START toggles the shiny palette on the currently displayed sprite (front or back)
.shinyPaletteFromDescription ; START pressed on the description page
	callba ToggleShinyPalettePokedex
	jp .reprintDescription
.shinyPaletteFromStats ; START pressed on the base stats page
	callba ToggleShinyPalettePokedex
	jp .waitForButtonPress2
.nextMon
	ld a, [wPokedexNum]
	push af
	call IndexToPokedex
	ld hl, wPokedexSeen
	call SeekToNextMon
	jr c, .reloadwPokedexNum
	pop af
	call ChangeMonListPosition
	call PokedexToIndex
	jr .showNextPokemon
.prevMon
	ld a, [wPokedexNum]
	push af
	call IndexToPokedex
	ld hl, wPokedexSeen
	call SeekToPreviousMon
	jr c, .reloadwPokedexNum
	pop af
	call ChangeMonListPosition
	call PokedexToIndex
	jr .showNextPokemon
.reloadwPokedexNum
	pop af
	ld [wPokedexNum], a
.reprintDescription
	; clear the description box in case we're not on page 1
	coord hl, 1, 10
	lb bc, 6, 18
	call ClearScreenArea
	coord hl, 9, 16
	lb bc, 1, 9
	call ClearScreenArea
	jp .printDescription
.showNextPokemon
	; clear the variable portions of the on-screen data so they don't overlap
	; clear pokemon sprite box
	coord hl, 1, 1
	lb bc, 7, 8
	call ClearScreenArea
	; clear bottom text window
	coord hl, 1, 10
	lb bc, 6, 18
	call ClearScreenArea
	coord hl, 3, 16
	lb bc, 1, 15
	call ClearScreenArea
	; clear pokemon name + class
	coord hl, 9, 2
	lb bc, 3, 10
	call ClearScreenArea

	ld a, B_BUTTON
	ld [wMenuWatchedKeys], a ; reset the default watched buttons for internal entries

	call Delay3

	pop hl
	jp ShowNextPokemonData

; function to display pokedex capa from inside the pokedex
ShowPokedexCapa:
	ld hl, wStatusFlags2
	set 1, [hl]
	ld a, $33 ; 3/7 volume
	ld [rNR50], a
	ld a, [hTilesetType]
	push af
	xor a
	ld [hTilesetType], a
	call GBPalWhiteOut ; zero all palettes
	; load pokedex data page UI tiles (left + right arrows)
	ld de, PokedexDataUI
	lb bc, BANK(PokedexDataUI), 2
	ld hl, vChars1 tile $4C
	call CopyVideoDataDouble
	ld a, [wPokedexNum] ; pokemon ID
	ld [wcf91], a
	ld hl, wPokedexDataFlags
	res BIT_POKEDEX_DATA_SHINY, [hl] ; never show the shiny palette on the capa page
	set BIT_VIEWING_POKEDEX, [hl] ; the seek functions are shared with the movedex, tell them 
	push af
	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand
 	ld a, [wMoveListCounter] ; using this as a temp variable
 	cp 1
 	jp z, .PrintMoves
	pop af
	ld [wPokedexNum], a

	call DrawDexEntryOnScreen
	call c, Pokedex_PrintFlavorTextAtRow11
	call DrawCapaLeftRightPrompts ; draw the seek prompts and update the watched keys
	jr .waitForButtonPress
.PrintMoves
	pop af
	ld [wPokedexNum], a
	call DrawDexEntryOnScreen
	jp nc, .capaNoMovesText
	call DrawCapaLeftRightPrompts ; draw the seek prompts before the moves list, so that seeking works during its page turns
	call Pokedex_PrintMovesText
	jp c, .capaSeekRequested ; the player seeked while the moves list was waiting for a page turn
 .waitForButtonPress
	call JoypadLowSensitivity
	ld a, [wMenuWatchedKeys]
	ld c, a
	ldh a, [hJoy5]
	and c
	jr z, .waitForButtonPress
	bit BIT_D_LEFT, a
	jr nz, .capaPrevMon
	bit BIT_D_RIGHT, a
	jr nz, .capaNextMon
.capaQuitPage ; exit the capa page
	pop af
	ldh [hTilesetType], a
	call GBPalWhiteOut
	call ClearScreen
	call RunDefaultPaletteCommand
	call LoadTextBoxTilePatterns
	call GBPalNormal
	ld hl, wStatusFlags2
	res 1, [hl]
	xor a
	ld [wPokedexDataFlags], a ; clear BIT_VIEWING_POKEDEX (shared with the movedex seek functions)
	ld a, $77 ; max volume
	ld [rNR50], a
	ret

; LEFT / RIGHT seek to the previous / next seen pokemon, like on the data page
.capaPrevMon
	ld a, [wcf91] ; the moves text printing clobbers wPokedexNum, but wcf91 always holds the current mon
	ld [wPokedexNum], a
	push af
	call IndexToPokedex
	ld hl, wPokedexSeen
	call SeekToPreviousMon
	jr c, .reloadCapaMon
	pop af
	call ChangeMonListPosition
	call PokedexToIndex
	jr .capaShowMon
.capaNextMon
	ld a, [wcf91]
	ld [wPokedexNum], a
	push af
	call IndexToPokedex
	ld hl, wPokedexSeen
	call SeekToNextMon
	jr c, .reloadCapaMon
	pop af
	call ChangeMonListPosition
	call PokedexToIndex
	jr .capaShowMon
.reloadCapaMon
	pop af
	ld [wPokedexNum], a
	jr .waitForButtonPress
.capaShowMon
	ld a, [wPokedexNum] ; internal index of the new mon
	ld [wcf91], a
	push af
	; erase the old mon's sprite and wait for the transfer before applying
	; the new palette, or the old mon briefly renders in the new palette
	coord hl, 1, 1
	lb bc, 7, 8
	call ClearScreenArea
	call Delay3
	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand
	pop af
	ld [wPokedexNum], a
	call DrawDexEntryOnScreen
	jp nc, .capaNoMovesText
	call DrawCapaLeftRightPrompts ; draw the seek prompts before the moves list, so that seeking works during its page turns
	call Pokedex_PrintMovesText
	jr c, .capaSeekRequested ; the player seeked while the moves list was waiting for a page turn
	jp .waitForButtonPress
.capaSeekRequested ; a = the seek direction pressed while the moves list was waiting for a page turn, or 0 when the player quit with B
	and a
	jp z, .capaQuitPage
	bit BIT_D_LEFT, a
	jp nz, .capaPrevMon
	jp .capaNextMon
.capaNoMovesText
	; the mon is not owned: no learnset to print, just redraw the seek prompts
	call DrawCapaLeftRightPrompts
	jp .waitForButtonPress

; draws the left/right seek prompts at the bottom of the capa page
; and updates wMenuWatchedKeys with the buttons the page watches (A, B, and D_LEFT/D_RIGHT when seeking is possible)
DrawCapaLeftRightPrompts:
	ld a, [wcf91] ; the moves text printing clobbers wPokedexNum, but wcf91 always holds the current mon
	ld [wPokedexNum], a
	push af
	call IndexToPokedex
	ld a, A_BUTTON | B_BUTTON
	ld b, a ; buttons the capa page watches

	coord hl, 1, 17
	ld a, [wDexMinSeenMon]
	ld c, a
	ld a, [wPokedexNum] ; pokedex number
	cp c
	jr z, .noLeftPrompt
	ld a, $CC ; < prompt
	ld [hl], a
	ld a, D_LEFT
	or b
	ld b, a
	jr .checkRightPrompt
.noLeftPrompt
	ld a, $6f ; border tile instead
	ld [hl], a
.checkRightPrompt
	coord hl, 18, 17
	ld a, [wDexMaxSeenMon]
	ld c, a
	ld a, [wPokedexNum] ; pokedex number
	cp c
	jr z, .noRightPrompt
	ld a, $CD ; > prompt
	ld [hl], a
	ld a, D_RIGHT
	or b
	ld b, a
	jr .storeWatchedKeys
.noRightPrompt
	ld a, $6f ; border tile instead
	ld [hl], a
.storeWatchedKeys
	ld a, b
	ld [wMenuWatchedKeys], a
	pop af
	ld [wPokedexNum], a ; restore the internal index
	ret

; function to display the pokedex TM/HM page from inside the pokedex
ShowPokedexCSCT:
	ld hl, wStatusFlags2
	set 1, [hl]
	ld a, $33 ; 3/7 volume
	ldh [rNR50], a
	ld a, [hTilesetType]
	push af
	xor a
	ldh [hTilesetType], a
	call GBPalWhiteOut ; zero all palettes
	; load pokedex data page UI tiles (left + right arrows)
	ld de, PokedexDataUI
	lb bc, BANK(PokedexDataUI), 2
	ld hl, vChars1 tile $4C
	call CopyVideoDataDouble
	ld a, [wPokedexNum] ; pokemon ID
	ld [wcf91], a
	ld hl, wPokedexDataFlags
	res BIT_POKEDEX_DATA_SHINY, [hl] ; never show the shiny palette on the CSCT page
	set BIT_VIEWING_POKEDEX, [hl] ; the seek functions are shared with the movedex, tell them
	push af
	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand
	pop af
	ld [wPokedexNum], a

	call DrawDexEntryOnScreen
	jp nc, .csctNoCSCTText
	call DrawCapaLeftRightPrompts ; draw the seek prompts before the machine list, so that seeking works during its page turns
	call Pokedex_PrintTMHMText
	jp c, .csctSeekRequested ; the player seeked while the machine list was waiting for a page turn
	jr .waitForButtonPress
.waitForButtonPress
	call JoypadLowSensitivity
	ld a, [wMenuWatchedKeys]
	ld c, a
	ldh a, [hJoy5]
	and c
	jr z, .waitForButtonPress
	bit BIT_D_LEFT, a
	jr nz, .csctPrevMon
	bit BIT_D_RIGHT, a
	jr nz, .csctNextMon
.csctQuitPage ; exit the CSCT page
	pop af
	ldh [hTilesetType], a
	call GBPalWhiteOut
	call ClearScreen
	call RunDefaultPaletteCommand
	call LoadTextBoxTilePatterns
	call GBPalNormal
	ld hl, wStatusFlags2
	res 1, [hl]
	xor a
	ld [wPokedexDataFlags], a ; clear BIT_VIEWING_POKEDEX (shared with the movedex seek functions)
	ld a, $77 ; max volume
	ldh [rNR50], a
	ret

; LEFT / RIGHT seek to the previous / next seen pokemon, like on the data page
.csctPrevMon
	ld a, [wcf91] ; the machine text printing clobbers wPokedexNum, but wcf91 always holds the current mon
	ld [wPokedexNum], a
	push af
	call IndexToPokedex
	ld hl, wPokedexSeen
	call SeekToPreviousMon
	jr c, .reloadCSCTMon
	pop af
	call ChangeMonListPosition
	call PokedexToIndex
	jr .csctShowMon
.csctNextMon
	ld a, [wcf91]
	ld [wPokedexNum], a
	push af
	call IndexToPokedex
	ld hl, wPokedexSeen
	call SeekToNextMon
	jr c, .reloadCSCTMon
	pop af
	call ChangeMonListPosition
	call PokedexToIndex
	jr .csctShowMon
.reloadCSCTMon
	pop af
	ld [wPokedexNum], a
	jr .waitForButtonPress
.csctShowMon
	ld a, [wPokedexNum] ; internal index of the new mon
	ld [wcf91], a
	push af
	; erase the old mon's sprite and wait for the transfer before applying
	; the new palette, or the old mon briefly renders in the new palette
	coord hl, 2, 2
	lb bc, 7, 8
	call ClearScreenArea
	call Delay3
	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand
	pop af
	ld [wPokedexNum], a
	call DrawDexEntryOnScreen
	jp nc, .csctNoCSCTText
	call DrawCapaLeftRightPrompts ; draw the seek prompts before the machine list, so that seeking works during its page turns
	call Pokedex_PrintTMHMText
	jr c, .csctSeekRequested ; the player seeked while the machine list was waiting for a page turn
	jp .waitForButtonPress
.csctSeekRequested ; a = the seek direction pressed while the machine list was waiting for a page turn, or 0 when the player quit with B
	and a
	jp z, .csctQuitPage
	bit BIT_D_LEFT, a
	jp nz, .csctPrevMon
	jp .csctNextMon
.csctNoCSCTText
	; the mon is not owned: no machine list to print, just redraw the seek prompts
	call DrawCapaLeftRightPrompts
	jp .waitForButtonPress

; prints the list of TMs and HMs the current pokemon can learn, in item constant order (HMs, then TMs)
; the mon's learnset must be loaded in wMonHLearnset (done by DrawDexEntryOnScreen via GetMonHeader)
; 5 machines per page (rows 12-16), header at row 10
; pressing A on the last page cycles back to the first page
; returns carry set + a = the seek direction when the player seeks during a page turn or on the last page
; returns carry set + a = 0 when the player quits the page with B
Pokedex_PrintTMHMText:
	ld de, TMHMMovesText
	coord hl, 1, 10
	call PlaceString
	ld b, HM01_CUT ; the item ID of the machine currently checked
	ld c, 0 ; machines printed on the current page
	coord hl, 1, 12 ; row cursor, advanced by SCREEN_WIDTH after each print
.checkMachineLoop
	; test the machine's bit in the learnset
	push hl ; save the row cursor: the flag test below needs hl
	push bc
	ld a, b
	sub HM01_CUT ; a = machine index in item constant order (0 = HM01 ... 54 = TM50)
	cp TM01_MEGA_PUNCH - HM01_CUT ; machine indexes below TM01 are HMs
	jr c, .hmBit
	sub TM01_MEGA_PUNCH - HM01_CUT ; TM bits come first in the learnset: bit = machine index - 5
	jr .haveBit
.hmBit
	add hm01_CUT - 1 ; HM bits come after the 50 TM bits: bit = 50 + machine index
.haveBit
	ld c, a
	ld b, FLAG_TEST
	ld hl, wMonHLearnset
	predef FlagActionPredef
	ld a, c
	pop bc
	pop hl ; restore the row cursor before printing
	and a
	jr z, .nextMachine
	ld a, c
	cp 5 ; machines per page (rows 12-16)
	jr c, .printMachine
	; the page is full: wait for the player to turn the page, seek or quit
	push bc
	call CapaPageTurnButtonCheck ; A turns the page, B quits, LEFT/RIGHT seeks to another 
	jr c, .seekRequested
	coord hl, 1, 10
	lb bc, 7, 18
	call ClearScreenArea ; clobbers de, and lb bc clobbers b: keep the pop AFTER
	ld de, TMHMMovesText
	coord hl, 1, 10
	call PlaceString ; also clobbers bc (returns hl in bc): keep the pop AFTER this too
	pop bc
	xor a
	ld c, a ; reset the count of machines printed on this page
	coord hl, 1, 12 ; reset the row cursor
.printMachine
	ld a, b
	ld [wPokedexNum], a
	push hl
	push bc
	call GetItemName ; de = wcd6d ("CSxx "/"CTxx " + a truncated move name), preserves hl and bc
	ld a, "@"
	ld [wcd6d + 5], a ; the "CSxx "/"CTxx " prefix is always 5 chars: cut the truncated name after it
	call PlaceString ; print the prefix, it returns the position after it in bc (hl is preserved)
	ld h, b
	ld l, c ; hl = the position right after the prefix
	pop bc ; restore the item ID and counter (PlaceString clobbers bc)
	push bc ; re-save them for after the prints
	push hl ; save the position after the prefix (the predef below clobbers hl)
	ld a, b
	sub TM01_MEGA_PUNCH ; machine indexes: TMs are 1-50, HMs are 51-55
	jr nc, .gotMachineIndex
	add 55
.gotMachineIndex
	inc a
	ld [wPokedexNum], a
	predef TMToMove ; [wPokedexNum] = the move ID taught by this machine
	call GetMoveName ; de = wcd6d (the full move name in French), preserves hl
	pop hl
	call PlaceString ; print the move name after the prefix
	pop bc
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	inc c
.nextMachine
	inc b
	ld a, TM50_SUBSTITUTE
	cp b
	jr nc, .checkMachineLoop
.done
	; the whole list has been printed: wait for the player to cycle, seek or quit
	call CapaPageTurnButtonCheck ; A cycles back to the first page, B quits, LEFT/RIGHT seeks to another pokemon
	jr c, .doneButtonRequested ; a = the seek direction, or 0 when the player pressed B
	coord hl, 1, 10
	lb bc, 7, 18
	call ClearScreenArea ; clobbers de, and lb bc clobbers b: they are re-initialized below
	ld de, TMHMMovesText
	coord hl, 1, 10
	call PlaceString ; also clobbers bc (returns hl in bc): they are re-initialized below
	ld b, HM01_CUT ; restart the list from the first machine
	ld c, 0 ; reset the count of machines printed on this page
	coord hl, 1, 12 ; reset the row cursor
	jp .checkMachineLoop
.doneButtonRequested ; return the seek or the quit (carry set, a = direction, or 0 for B) to the caller
	ret
.seekRequested ; let the caller handle the seek or the quit (carry set, a = direction, or 0 for B)
	pop bc
	ret

DrawDexEntryOnScreen:
	call ClearScreen

	coord hl, 0, 0
	ld de, 1
	lb bc, $64, SCREEN_WIDTH
	call DrawTileLine ; draw top border

	coord hl, 0, 17
	ld b, $6f
	call DrawTileLine ; draw bottom border

	coord hl, 0, 1
	ld de, 20
	lb bc, $66, $10
	call DrawTileLine ; draw left border

	coord hl, 19, 1
	ld b, $67
	call DrawTileLine ; draw right border

	ld a, $63 ; upper left corner tile
	Coorda 0, 0
	ld a, $65 ; upper right corner tile
	Coorda 19, 0
	ld a, $6c ; lower left corner tile
	Coorda 0, 17
	ld a, $6e ; lower right corner tile
	Coorda 19, 17

	coord hl, 0, 9
	ld de, PokedexDataDividerLine
	call PlaceString ; draw horizontal divider line

	coord hl, 9, 6
	ld de, HeightWeightText
	call PlaceString

	call GetMonName
	coord hl, 9, 2
	call PlaceString

	ld hl, PokedexEntryPointers
	ld a, [wPokedexNum]
	dec a
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl] ; de = address of pokedex entry

	coord hl, 9, 4
	call PlaceString ; print species name

	ld h, b
	ld l, c
	push de
	ld a, [wPokedexNum]
	push af
	call IndexToPokedex

	coord hl, 2, 8
	ld a, "№"
	ld [hli], a
	ld a, "⠄"
	ld [hli], a
	ld de, wPokedexNum
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber ; print pokedex number

	ld hl, wPokedexOwned
	call IsPokemonBitSet
	pop af
	ld [wPokedexNum], a
	ld a, [wcf91]
	ld [wd0b5], a
	pop de

	push af
	push bc
	push de
	push hl

	call Delay3
	call GBPalNormal
	call GetMonHeader ; load pokemon picture location
	coord hl, 1, 1
	call LoadFlippedFrontSpriteByMonIndex ; draw pokemon picture

	pop hl
	pop de
	pop bc
	pop af

	ld a, c
	and a
	ret z ; if the pokemon has not been owned, don't print the height, weight, or description
	inc de ; de = address of feet (height)
	ld a, [de] ; reads feet, but a is overwritten without being used
	coord hl, 12, 6
	lb bc, 1, 2
	call PrintNumber ; print feet (height)
	ld a, "."
	ld [hl], a
	inc de
	inc de ; de = address of inches (height)
	coord hl, 15, 6
	lb bc, LEADING_ZEROES | 1, 2
	call PrintNumber ; print inches (height)
	ld a, "m"
	ld [hl], a
; now print the weight (note that weight is stored in tenths of pounds internally)
	inc de
	inc de
	inc de ; de = address of upper byte of weight
	push de
; put weight in big-endian order at hDexWeight
	ld hl, hDexWeight
	ld a, [hl] ; save existing value of [hDexWeight]
	push af
	ld a, [de] ; a = upper byte of weight
	ld [hli], a ; store upper byte of weight in [hDexWeight]
	ld a, [hl] ; save existing value of [hDexWeight + 1]
	push af
	dec de
	ld a, [de] ; a = lower byte of weight
	ld [hl], a ; store lower byte of weight in [hDexWeight + 1]
	ld de, hDexWeight
	coord hl, 11, 8
	lb bc, 2, 5 ; 2 bytes, 5 digits
	call PrintNumber ; print weight
	coord hl, 14, 8
	ld a, [hDexWeight + 1]
	sub 10
	ld a, [hDexWeight]
	sbc 0
	jr nc, .next
	ld [hl], "0" ; if the weight is less than 10, put a 0 before the decimal point
.next
	inc hl
	ld a, [hli]
	ld [hld], a ; make space for the decimal point by moving the last digit forward one tile
	ld [hl], "⠄" ; decimal point tile
	pop af
	ld [hDexWeight + 1], a ; restore original value of [hDexWeight + 1]
	pop af
	ld [hDexWeight], a ; restore original value of [hDexWeight]
	pop hl
	inc hl ; hl = address of pokedex description text
	scf
	ret

Pokedex_PrintFlavorTextAtRow11:
	coord bc, 1, 11
Pokedex_PrintFlavorTextAtBC:
	ld a, %10
	ldh [hClearLetterPrintingDelayFlags], a
	call TextCommandProcessor ; print pokedex description text
	xor a
	ldh [hClearLetterPrintingDelayFlags], a
	ret

HeightWeightText:
	db   "Tai ?",",","??","m"
	next "Pds  ???kg@"

; horizontal line that divides the pokedex text description from the rest of the data
PokedexDataDividerLine:
	db $68, $69, $6B, $69, $6B, $69, $6B, $69, $6B, $6B
	db $6B, $6B, $69, $6B, $69, $6B, $69, $6B, $69, $6A
	db "@"

INCLUDE "data/pokemons/pokedex_entries.asm"

PokedexToIndex:
	; converts the Pokédex number at [wPokedexNum] to an index
	push bc
	push hl
	ld a, [wPokedexNum]
	ld b, a
	ld c, 0
	ld hl, PokedexOrder

.loop ; go through the list until we find an entry with a matching dex number
	inc c
	ld a, [hli]
	cp b
	jr nz, .loop

	ld a, c
	ld [wPokedexNum], a
	pop hl
	pop bc
	ret

IndexToPokedex:
	; converts the index number at [wPokedexNum] to a Pokédex number
	push bc
	push hl
	ld a, [wPokedexNum]
	dec a
	ld hl, PokedexOrder
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wPokedexNum], a
	pop hl
	pop bc
	ret

Pokedex_PrintMovesText:
	ld a, [wPokedexNum]
	ld [wWhichPokemon], a
	ld [wcf91], a

	farcall PrepareLevelUpMoveList
	ld de, wMoveBuffer

	ld b, 0 ; counter

	ld a, [wMoveListCounter]
	cp 0
	jp z, .done

.PrintLevelUpMovesLoop
	push de
	push bc
	ld de, LevelUpMovesText
	coord hl, 1, 10
	call PlaceString
	pop bc
	pop de

	push bc
	coord hl, 1, 12
	call PrintLearnLevel ; print the learn level (START logo for level 1)
	inc de
	ld a, [de]
	push de
	ld [wPokedexNum], a
	call GetMoveName
	coord hl, 5, 12
	call PlaceString
	pop de
	inc de ; de = next entry's level byte
	pop bc

	inc b
	ld a, [wMoveListCounter]
	cp b
	jp z, .done

	push bc
	coord hl, 1, 13
	call PrintLearnLevel ; print the learn level (START logo for level 1)
	inc de
	ld a, [de]
	push de
	ld [wPokedexNum], a
	call GetMoveName
	coord hl, 5, 13
	call PlaceString
	pop de
	inc de ; de = next entry's level byte
	pop bc

	inc b
	ld a, [wMoveListCounter]
	cp b
	jp z, .done

	push bc
	coord hl, 1, 14
	call PrintLearnLevel ; print the learn level (START logo for level 1)
	inc de
	ld a, [de]
	push de
	ld [wPokedexNum], a
	call GetMoveName
	coord hl, 5, 14
	call PlaceString
	pop de
	inc de ; de = next entry's level byte
	pop bc

	inc b
	ld a, [wMoveListCounter]
	cp b
	jr z, .done

	push bc
	coord hl, 1, 15
	call PrintLearnLevel ; print the learn level (START logo for level 1)
	inc de
	ld a, [de]
	push de
	ld [wPokedexNum], a
	call GetMoveName
	coord hl, 5, 15
	call PlaceString
	pop de
	inc de ; de = next entry's level byte
	pop bc

	inc b
	ld a, [wMoveListCounter]
	cp b
	jr z, .done

	push bc
	coord hl, 1, 16
	call PrintLearnLevel ; print the learn level (START logo for level 1)
	inc de
	ld a, [de]
	push de
	ld [wPokedexNum], a
	call GetMoveName
	coord hl, 5, 16
	call PlaceString
	pop de
	inc de ; de = next entry's level byte
	pop bc

	inc b
	ld a, [wMoveListCounter]
	cp b
	jr z, .done

	push de
	push bc
	call CapaPageTurnButtonCheck ; A turns the page, B quits, LEFT/RIGHT seeks to another pokemon
	jr c, .seekRequested ; a = the seek direction, or 0 when the player pressed B
	coord hl, 1, 10
	lb bc, 7, 18
	call ClearScreenArea
	pop bc
	pop de ; keep the pops AFTER ClearScreenArea: it clobbers de, and lb bc clobbers b
	jp .PrintLevelUpMovesLoop
.seekRequested ; let the caller handle the seek or the quit (carry set, a = direction, or 0 for B)
	pop bc
	pop de ; discard the saved registers, everything is reloaded for the new mon
	ret
.done
	; the whole list has been printed: wait for the player to cycle, seek or quit
	call CapaPageTurnButtonCheck ; A cycles back to the first page, B quits, LEFT/RIGHT seeks to another pokemon
	jr c, .doneButtonRequested ; a = the seek direction, or 0 when the player pressed B
	coord hl, 1, 10
	lb bc, 7, 18
	call ClearScreenArea ; clobbers de, and lb bc clobbers b: everything is reloaded below
	ld a, [wcf91] ; the printing clobbered wPokedexNum: restore the current mon before re-reading its move list
	ld [wPokedexNum], a
	jp Pokedex_PrintMovesText
.doneButtonRequested ; return the seek or the quit (carry set, a = direction, or 0 for B) to the caller
	ret

; prints the level a move is learned at
; level 1 entries are moves the pokemon starts with, print the START logo tiles for them
; INPUT: de = pointer to the level byte, hl = coordinates to print at
PrintLearnLevel:
	push de
	ld a, [de]
	cp 1
	jr z, .startingMove
	lb bc, 1, 3
	call PrintNumber ; print the learn level
	jr .done
.startingMove
	ld a, $C6 ; START logo tiles (PokedexPromptGraphics)
	ld [hli], a
	ld a, $C7
	ld [hli], a
	ld a, $C8
	ld [hl], a
.done
	pop de ; PrintNumber returns with de decremented, keep the caller's pointer intact
	ret

; waits for the player to let go of the page turn buttons, then waits for a press
; A turns the page
; B quits the page
; D_LEFT / D_RIGHT aborts the moves list and seeks to another pokemon (only when the direction is watched, i.e. not at the list bounds)
; returns carry set and the seek direction in a when a seek is requested
; returns carry set and a = 0 when the player quits the page with B
CapaPageTurnButtonCheck:
.waitForButtonPressLetGo
	call Joypad
	ldh a, [hJoyHeld]
	and A_BUTTON | B_BUTTON
	jr nz, .waitForButtonPressLetGo
.waitForButtonPress
	call Joypad
	ldh a, [hJoyHeld]
	ld b, a
	and D_LEFT | D_RIGHT
	jr z, .checkPageButton
	ld c, a ; the held directions
	ld a, [wMenuWatchedKeys]
	and c
	jr z, .checkPageButton ; the direction is not watched (at the list bounds), ignore it
	ld a, c
	scf
	ret
.checkPageButton
	ld a, b
	and A_BUTTON | B_BUTTON
	jr z, .waitForButtonPress
	bit BIT_B_BUTTON, b
	jr nz, .buttonBPressed
	xor a ; carry clear: A was pressed, turn the page
	ret
.buttonBPressed
	xor a
	scf ; carry set + a = 0: B was pressed, quit the page (the seek directions are never 0)
	ret

LevelUpMovesText:
	db "Capacités:@"

TMHMMovesText:
	db "CS/CT:@"

DexType1Text:
	db "Type1/@"

DexType2Text:
	db "Type2/@"

BaseStatsText:
	db "Stats base@"

HPText:
	db "PV@"

AtkText:
	db "Atq@"

DefText:
	db "Déf@"

SpdText:
	db "Vit@"

SpcText:
	db "Spé@"

TotalText:
	db "Total@"

INCLUDE "data/pokemons/pokedex_order.asm"
