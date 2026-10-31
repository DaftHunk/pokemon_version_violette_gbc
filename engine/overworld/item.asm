PickUpItem:
	call EnableAutoTextBoxDrawing

	ld a, [hSpriteIndexOrTextID]
	ld b, a
	ld hl, wItemBallList
.itemBallsListLoop
	ld a, [hli]
	cp $ff
	jr z, .missablesListLoop ; not an item ball -> check scripted missable balls
	cp b
	jr z, .isItemBall
	inc hl
	jr .itemBallsListLoop
 
; some item balls are shown/hidden by map scripts (SILPH_SCOPE, LIFT_KEY, M_GENE):
; they stay in the missable objects system and are hidden through HideObject
.missablesListLoop
	ld hl, wMissableObjectList
	ld a, [hli]
	cp $ff
	ret z ; not a missable object either
	cp b
	jr z, .isMissableBall
	inc hl
	jr .missablesListLoop

.isMissableBall
	ld a, [hl]
	ld [hItemToRemoveID], a
	ld hl, wMapSpriteExtraData
	ld a, [hSpriteIndexOrTextID]
	dec a
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld b, a ; item
	ld c, 1 ; quantity
	call GiveItem
	jr nc, .BagFull
	ld a, [hItemToRemoveID]
	ld [wMissableObjectIndex], a
	predef HideObject
	jr .foundItem

.isItemBall
	ld a, [hl]
	ld [hItemToRemoveID], a

	ld hl, wMapSpriteExtraData
	ld a, [hSpriteIndexOrTextID]
	dec a
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld b, a ; item
	ld c, 1 ; quantity
	call GiveItem
	jr nc, .BagFull

	callba HideItemBall
.foundItem
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, FoundItemText
	jr .print

.BagFull
	ld hl, NoMoreRoomForItemText
.print
	call PrintText
	ret

FoundItemText:
	TX_FAR _FoundItemText
	TX_SFX_ITEM_1
	db "@"

NoMoreRoomForItemText:
	TX_FAR _NoMoreRoomForItemText
	db "@"
