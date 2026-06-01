HiddenItemNear:
	ld hl, HiddenItemCoords
	ld b, 0
.loop
	ld de, 3
	ld a, [wCurMap]
	call IsInRestOfArray
	ret nc ; return if current map has no hidden items
	push bc
	push hl
	ld hl, wObtainedHiddenItemsFlags
	ld c, b
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	pop hl
	pop bc
	inc b
	and a
	inc hl
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl
	jr nz, .loop ; if the item has already been obtained
; check if the item is within 4-5 tiles (depending on the direction of item)
;joenote - there is a bug here. if an item has an x or y coord at 0, the carry bit will not be set and it will not be detected
;        - adding z-flag checks check to account for this  
	ld a, [wYCoord]
	call Sub5ClampTo0
	cp d
	jr z, .y_zflag
	jr nc, .loop
.y_zflag
	ld a, [wYCoord]
	add 4	
	cp d
	jr c, .loop
	ld a, [wXCoord]
	call Sub5ClampTo0
	cp e
	jr z, .x_zflag
	jr nc, .loop
.x_zflag
	ld a, [wXCoord]
	add 5	;joenote - the game displays your character slightly off-center to the left, so add 5 for x direction to the right
	cp e
	jr c, .loop
	scf
	ret

Sub5ClampTo0:
; subtract 5 but clamp to 0
	sub 4	;joenote - zeros are now included so subtract 4 instead
	cp $f0
	ret c
	xor a
	ret

	
	
	
	
	
	
	
;joenote - Writing a new version to allow for more function.
;This will detect the first listed hidden item that has not been obtained and is on the screen.
;If detected, it will play 1 to 3 chimes depending on how close it is (more chimes means closer to the item).
;Lines will point in the direction of the item and flash with the chimes.
;If the player is right on top of the item, no lines will show and the chime till play four times.
HiddenItemNear_Improved:
	call CheckIfLookingForCoins
	ld hl, HiddenItemCoords
	jr nc, .gotCoordList
	; PureRGBnote: ADDED: detect hidden coins in game corner.
	ld hl, HiddenCoinCoords
.gotCoordList
	ld b, 0
.loop
	ld de, 3
	ld a, [wCurMap]
	call IsInRestOfArray
	ret nc ; return if current map has no hidden items
	push bc
	push hl
	; PureRGBnote: ADDED: detect hidden coins in game corner.
	call CheckIfLookingForCoins
	ld hl, wObtainedHiddenItemsFlags
	jr nc, .gotFlagArray
	ld hl, wObtainedHiddenCoinsFlags
.gotFlagArray
	ld c, b
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	pop hl
	pop bc
	inc b
	and a
	inc hl
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl
	jr nz, .loop ; if the item has already been obtained
	
	ld c, 0		;use C for adding up the distance
	push hl
.check_above
	;check if item is above and add the distance
	ld a, [wYCoord]
	sub d
	jr c, .check_below	;if carry is set, then the item is not above the player
	jr z, .check_below	;if z is set, then item is at the player
	;item is above player
	cp 5
	jr nc, .popHLloop	;if carry not set, then the item is off the top of the screen
	;item is on screen and above or at the player
	add c
	ld c, a
	ld hl, wItemFinderAttributes
	set 0, [hl]
	ld a, [wYCoord]
	sub d
	jr nz, .check_left	;do not proceed to checking below if the item is not at the player
	
.check_below
	;if at this line, then the item is already known to be below or at the player
	ld a, [wYCoord]
	ld h, a
	ld a, d
	sub h
	jr z, .check_left	;if z is set, then item is at the player
	cp 5
	jr nc, .popHLloop	;if carry not set, then the item is off the bottom of the screen
	add c
	ld c, a
	ld hl, wItemFinderAttributes
	set 1, [hl]

.check_left
	;check if item is to the left and add the distance
	ld a, [wXCoord]
	sub e
	jr c, .check_right	;if carry is set, then the item is not left of the player
	jr z, .check_right 	;if z is set, then item is at the player
	;item is left of player
	cp 5
	jr nc, .popHLloop	;if carry not set, then the item is off the left of the screen
	;item is on screen and left of the player
	add c
	ld c, a
	ld hl, wItemFinderAttributes
	set 2, [hl]
	ld a, [wXCoord]
	sub e
	jr nz, .item_detected	;do not proceed to checking to the right if the item is not at the player

.check_right
	;if at this line, then the item is already known to be right of or at the player
	ld a, [wXCoord]
	ld h, a
	ld a, e
	sub h
	jr z, .item_detected 	;if z is set, then item is at the player
	cp 6	;note that the player is off-center on the screen
	jr nc, .popHLloop	;if carry not set, then the item is off the right of the screen
	add c
	ld c, a
	ld hl, wItemFinderAttributes
	set 3, [hl]	
	
	jr .item_detected
	
.popHLloop
	pop hl
	xor a
	ld [wItemFinderAttributes ], a	;reset the attributes because the item is off the screen
	jp .loop
	
.item_detected
	pop hl
.loop2	;play fewer chimes if the item is farther away

	coord hl, 9, 7
	ld a, [hl]
	push af
	coord hl, 8, 10
	ld a, [hl]
	push af
	coord hl, 7, 8
	ld a, [hl]
	push af
	coord hl, 10, 8
	ld a, [hl]
	push af

	push de
	ld hl, wItemFinderAttributes
	bit 0, [hl]
	call nz, .printabove
	bit 1, [hl]
	call nz, .printbelow
	bit 2, [hl]
	call nz, .printleft
	bit 3, [hl]
	call nz, .printright
	pop de
	
	
	ld a, SFX_HEALING_MACHINE
	call PlaySoundWaitForCurrent

	coord hl, 10, 8
	pop af
	ld [hl], a
	coord hl, 7, 8
	pop af
	ld [hl], a
	coord hl, 8, 10
	pop af
	ld [hl], a
	coord hl, 9, 7
	pop af
	ld [hl], a

	ld a, SFX_PURCHASE
	call PlaySoundWaitForCurrent

	inc c
	inc c
	inc c
	ld a, c
	cp 10
	jr c, .loop2
.return_carry
	scf
	ret

.printabove
	coord de, 9, 7
	ld a, "l"
	ld [de], a
	ret
.printbelow
	coord de, 8, 10
	ld a, "l"
	ld [de], a
	ret
.printleft
	coord de, 7, 8
	ld a, "-"
	ld [de], a
	ret
.printright
	coord de, 10, 8
	ld a, "-"
	ld [de], a
	ret

CheckIfLookingForCoins:
	CheckEvent EVENT_GOT_COIN_CASE
	jr z, .no
	ld a, [wCurMap]
	cp GAME_CORNER
	jr nz, .no
	scf
	ret
.no
	and a
	ret
