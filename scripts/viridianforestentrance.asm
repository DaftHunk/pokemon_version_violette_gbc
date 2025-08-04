ViridianForestEntranceScript:
	jp EnableAutoTextBoxDrawing

ViridianForestEntranceTextPointers:
	dw ViridianForestEntranceText1
	dw ViridianForestEntranceText2

ViridianForestEntranceText1:
	TX_FAR _ViridianForestEntranceText1
	db "@"

ViridianForestEntranceText2:
	TX_ASM
	ld hl, ViridianForestEntranceAskMonText
	; Check if already done
	CheckEvent EVENT_VIRIDIAN_FOREST_ENTRANCE
	jr nz, .afterShow
	; Check if not right mon in first position
	ld a, [wPartyMon1Species]
	cp RATTATA
	jr nz, .endScript
	; Else show your mon
	ld hl, ViridianForestEntranceShowedMonText
	call PrintText
	; Give reward
	lb bc, POKE_BALL, 5
	call GiveItem
	jr nc, .noSpace
	; If reward given
	SetEvent EVENT_VIRIDIAN_FOREST_ENTRANCE
	ld hl, ViridianForestEntranceFoundItemText
	; fallthrough	
.endScript
	call PrintText
	jp TextScriptEnd
.afterShow
	ld hl, ViridianForestEntranceAfterMonText
	jr .endScript
.noSpace
	ld hl, ViridianForestEntranceNoMoreRoomForItemText
	jr .endScript

ViridianForestEntranceAskMonText:
	TX_FAR _ViridianForestEntranceAskMonText
	db "@"

ViridianForestEntranceShowedMonText:
	TX_FAR _ViridianForestEntranceShowedMonText
	db "@"

ViridianForestEntranceFoundItemText:
	TX_FAR _ViridianForestEntranceItemText
	TX_SFX_ITEM_1
	db "@"

ViridianForestEntranceNoMoreRoomForItemText:
	TX_FAR _NoMoreRoomForItemText
	db "@"

ViridianForestEntranceAfterMonText:
	TX_FAR _ViridianForestEntranceAfterMonText
	db "@"