Museum2FScript:
	jp EnableAutoTextBoxDrawing

Museum2FTextPointers:
	dw Museum2FText1
	dw Museum2FText2
	dw Museum2FText3
	dw Museum2FPikachuGirlText
	dw Museum2FPikachuGirlDadText
	dw PickUpItemText	;joenote - moved tm12 here
	dw Museum2FText6
	dw Museum2FText7

Museum2FText1:
	TX_FAR _Museum2FText1
	db "@"

Museum2FText2:
	TX_FAR _Museum2FText2
	db "@"

Museum2FText3:
	TX_FAR _Museum2FText3
	db "@"

Museum2FPikachuGirlText:
	TX_ASM
	ld hl, Museum2FAskMonText
	; Check if already done
	CheckEvent EVENT_MUSEUM_2F_SHOWED_PIKACHU
	jr nz, .endScript
	; Check if not right mon in first position
	ld a, [wPartyMon1Species]
	cp PIKACHU
	jr nz, .endScript
	; Else show your mon
	ld hl, Museum2FShowedMonText
	call PrintText
	; Give reward
	lb bc, RARE_CANDY, 1
	call GiveItem
	jr nc, .noSpace
	; If reward given
	SetEvent EVENT_MUSEUM_2F_SHOWED_PIKACHU
	ld hl, Museum2FFoundItemText
	; fallthrough
.endScript
	call PrintText
	jp TextScriptEnd
.noSpace
	ld hl, Museum2FNoMoreRoomForItemText
	jr .endScript

Museum2FAskMonText:
	TX_FAR _Museum2FAskMonText
	db "@"

Museum2FShowedMonText:
	TX_FAR _Museum2FShowedMonText
	db "@"

Museum2FFoundItemText:
	TX_FAR _FoundItemText
	TX_SFX_ITEM_1
	db "@"

Museum2FNoMoreRoomForItemText:
	TX_FAR _NoMoreRoomForItemText
	db "@"

Museum2FPikachuGirlDadText:
	TX_FAR _Museum2FPikachuGirlDadText
	db "@"

Museum2FText6:
	TX_FAR _Museum2FText6
	db "@"

Museum2FText7:
	TX_FAR _Museum2FText7
	db "@"
