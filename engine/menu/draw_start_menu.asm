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
	call FollowerCheckStartMenuOcclusion
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
	ld hl, wStatusFlags5
	set 6, [hl] ; no pauses between printing each letter
	coord hl, 12, 2
	CheckEvent EVENT_GOT_POKEDEX
; case for not having pokedex
	ld a, $08 ; edited for portablePC
	jr z, .storeMenuItemCount
; case for having pokedex
	ld de, StartMenuPokedexText
	call PrintStartMenuItem
	ld a, $08
.storeMenuItemCount
	ld [wMaxMenuItem], a ; number of menu items
	ld de, StartMenuPokemonText
	call PrintStartMenuItem
	ld de, StartMenuItemText
	call PrintStartMenuItem
	ld de, wPlayerName ; player's name
	call PrintStartMenuItem
	ld a, [wStatusFlags4]
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
	ld hl, wStatusFlags5
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
	db "Bipeur@"

PrintStartMenuItem:
	push hl
	call PlaceString
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret

; The follower sprite is drawn on top of the map's BG boxes, so it is
; latched hidden only when its 16x16 sprite actually overlaps the box
; DrawStartMenu is about to draw (cols 10-17, rows 0 to b+1). bit 2 of
; wFollowerStateFlags makes FollowerUpdate hold the image index at $ff,
; and TrySpawnFollower clears the bit when the map's sprites are reloaded
; on the way back to the overworld. The START button only registers at
; rest, so the follower is standing still and grid-aligned here.
; INPUT: b = number of middle rows in the box
FollowerCheckStartMenuOcclusion:
	push bc
	push hl
	ld a, [wSpriteStateData1 + $f0]
	and a
	jr z, .visible ; follower not spawned on this map
	ld a, [wSpriteStateData1 + $f6] ; screen X (left edge)
	cp $41 ; sprite right edge (X + 16) vs box left edge (10 * 8)
	jr c, .visible
	cp $90 ; sprite left edge vs box right edge (18 * 8)
	jr nc, .visible
	ld a, b
	add a
	add a
	add a
	add $0c ; box bottom edge (b + 2) * 8, minus the -4 bias of $f4
	ld d, a
	ld a, [wSpriteStateData1 + $f4] ; screen Y (top edge - 4)
	cp d
	jr nc, .visible ; sprite top edge below the box bottom edge
	ld hl, wFollowerStateFlags
	set 2, [hl]
	ld hl, wSpriteStateData1 + $f2
	ld [hl], $ff ; hide it right away: the boxes are drawn before the next
	             ; UpdateSprites call, and the gate only runs there
	pop hl
	pop bc
	ret
.visible
	ld hl, wFollowerStateFlags
	res 2, [hl]
	pop hl
	pop bc
	ret
