SaffronHouse2Script:
	jp EnableAutoTextBoxDrawing

SaffronHouse2TextPointers:
	dw SaffronHouse2Text1

SaffronHouse2Text1:
	TX_ASM
	CheckEvent EVENT_GOT_TM46
	jr nz, .asm_9e72b
	ld hl, TM46PreReceiveText
	call PrintText
	lb bc, TM46_DARK_PULSE, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedTM46Text
	call PrintText
	SetEvent EVENT_GOT_TM46
	jr .asm_fe4e1
.BagFull
	ld hl, TM46NoRoomText
	call PrintText
	jr .asm_fe4e1
.asm_9e72b	
	ld hl, TM46ExplanationText
	call PrintText
.asm_fe4e1
	jp TextScriptEnd

TM46PreReceiveText:
	TX_FAR _TM46PreReceiveText
	db "@"

ReceivedTM46Text:
	TX_FAR _ReceivedTM46Text
	TX_SFX_ITEM_1
	db "@"

TM46ExplanationText:
	TX_FAR _TM46ExplanationText
	db "@"

TM46NoRoomText:
	TX_FAR _TM46NoRoomText
	db "@"
