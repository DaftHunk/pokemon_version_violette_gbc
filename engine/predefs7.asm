AlreadyOnThatFloor:
	ld hl, AlreadyOnThatFloorText
	call PrintText
	jr DisplayElevatorFloorMenu.menuDisplayLoop

DisplayElevatorFloorMenu::
	ld a, [wListScrollOffset]
	push af ; preserve the list scroll offset so our item list offset is remembered
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld [wPrintItemPrices], a
.menuDisplayLoop:
	ld hl, WhichFloorText
	call PrintText
	ld hl, wItemList
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	ld a, [wListScrollOffset]
	push af
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld [wPrintItemPrices], a
	ld a, SPECIALLISTMENU
	ld [wListMenuID], a
	call DisplayListMenuID
	jr c, .done ; if cancel was selected
	pop bc
	ld a, b
	ld [wListScrollOffset], a
	ret c
	ld hl, wCurrentMapScriptFlags
	set 7, [hl]
	ld hl, wElevatorWarpMaps
	ld a, [wWhichPokemon]
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
;;;;;;;;;; PureRGBnote: CHANGED: elevators will tell you if you selected the floor you are currently on and will track how far you will travel
	ld a, [wWarpedFromWhichMap] ; map you were on before entering the elevator
	cp c
	jr z, AlreadyOnThatFloor
;;;;;;;;;;
	ld hl, wWarpEntries
	call .UpdateWarp ; update first warp
	call .UpdateWarp ; update second warp
	; destination map ID still loaded
	; PureRGBnote: ADDED: update the "map ID we came from" variable so the above usage of this variable thinks are now on the new floor
	ld [wWarpedFromWhichMap], a
	ld a, b ; destination warp id
	ld [wWarpedFromWhichWarp], a
.done
	xor a
	ld [wCurrentMenuItem], a
	pop af
	ld [wListScrollOffset], a ; restore list scroll offset so item list index is remembered
	ret
	; fall through
.UpdateWarp
	inc hl
	inc hl
	ld a, b
	ld [hli], a ; destination warp ID
	ld a, c
	ld [hli], a ; destination map ID
	ret

WhichFloorText:
	TX_FAR _WhichFloorText
	db "@"

AlreadyOnThatFloorText:
	TX_FAR _AlreadyOnThatFloor
	db "@"
