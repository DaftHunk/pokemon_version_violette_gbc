CeladonDinerScript:
	call EnableAutoTextBoxDrawing
	ret

CeladonDinerTextPointers:
	dw CeladonDinerText1
	dw CeladonDinerText2
	dw CeladonDinerText3
	dw CeladonDinerText4
	dw CeladonDinerText5
	dw CeladonDinerText6	;joenote - for catch-up exp boost

CeladonDinerText1:
	TX_FAR _CeladonDinerText1
	db "@"

CeladonDinerText2:
	TX_FAR _CeladonDinerText2
	db "@"

CeladonDinerText3:
	TX_FAR _CeladonDinerText3
	db "@"

CeladonDinerText4:
	TX_FAR _CeladonDinerText4
	db "@"

CeladonDinerText5:
	TX_ASM
	CheckEvent EVENT_GOT_COIN_CASE
	jr nz, .asm_eb14d
	ld hl, CeladonDinerText_491a7
	call PrintText
	lb bc, COIN_CASE, 1
	call GiveItem
	jr nc, .BagFull
	SetEvent EVENT_GOT_COIN_CASE
	ld hl, ReceivedCoinCaseText
	call PrintText
	jr .asm_68b61
.BagFull
	ld hl, CoinCaseNoRoomText
	call PrintText
	jr .asm_68b61
.asm_eb14d
	ld hl, CeladonDinerText_491b7
	call PrintText
.asm_68b61
	jp TextScriptEnd

CeladonDinerText_491a7:
	TX_FAR _CeladonDinerText_491a7
	db "@"

ReceivedCoinCaseText:
	TX_FAR _ReceivedCoinCaseText
	TX_SFX_KEY_ITEM
	db "@"

CoinCaseNoRoomText:
	TX_FAR _CoinCaseNoRoomText
	db "@"

CeladonDinerText_491b7:
	TX_FAR _CeladonDinerText_491b7
	db "@"

;;;;;;;;;;;;;;;;;;;;;;;;;joenote - add text for catch-up exp boost
CeladonDinerText6:
	TX_ASM
	CheckEvent EVENT_ENABLE_CATCH_UP_BOOST
	jr z, .RegRandON
	ld hl, CeladonDiner_EXPCatchUpOFF 
	call PrintText
	call .choose
	ld hl, CeladonDiner_AideQ_reject
	jr z, .end
	ResetEvent EVENT_ENABLE_CATCH_UP_BOOST
	jr .print_done
.RegRandON
	ld hl, CeladonDiner_EXPCatchUpON
	call PrintText
	call .choose
	ld hl, CeladonDiner_AideQ_reject
	jr z, .end
	SetEvent EVENT_ENABLE_CATCH_UP_BOOST
.print_done
	ld hl, CeladonDiner_AideQ_done
.end
	call PrintText
	jp TextScriptEnd
.choose
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	ret

CeladonDiner_EXPCatchUpON:
	TX_FAR _CeladonDiner_EXPCatchUpON
	db "@"
CeladonDiner_EXPCatchUpOFF:
	TX_FAR _CeladonDiner_EXPCatchUpOFF
	db "@"

CeladonDiner_AideQ_done:
	TX_FAR _CeladonDiner_AideQ_done
	db "@"
CeladonDiner_AideQ_reject:
	TX_FAR _CeladonDiner_AideQ_reject
	db "@"
