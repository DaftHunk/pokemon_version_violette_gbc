LighthouseScript:
	jp EnableAutoTextBoxDrawing

LighthouseTextPointers:
	dw LighthouseText_Keeper
	dw LighthouseText_Trade

LighthouseText_Keeper:
	TX_ASM
	ld hl, LighthouseText_KeeperQuest
	; Check if already done
	CheckEvent EVENT_LIGHTHOUSE_KEEPER
	jr nz, .afterShow
	; Check if not right mon in first position
	ld a, [wPartyMon1Species]
	cp DRATINI
	jr nz, .endScript
	; Else show your mon
	ld hl, LighthouseText_KeeperSeeDraco
	call PrintText
	; Give reward
	lb bc, SURFBOARD, 1
	call GiveItem
	jr nc, .noSpace
	; If reward given
	SetEvent EVENT_LIGHTHOUSE_KEEPER
	ld hl, LighthouseText_ReceivedSurfboard
	call PrintText

	ld hl, LighthouseText_Surfboard
	; fallthrough
.endScript
	call PrintText
	jp TextScriptEnd
.afterShow
	ld hl, LighthouseText_Surfboard
	jr .endScript
.noSpace
	ld hl, LighthouseText_NoRoom
	jr .endScript

LighthouseText_KeeperQuest:
	TX_FAR _LighthouseText_KeeperQuest
	db "@"

LighthouseText_KeeperSeeDraco:
	TX_FAR _LighthouseText_KeeperSeeDraco
	db "@"

LighthouseText_ReceivedSurfboard:
	TX_FAR _LighthouseText_ReceivedSurfboard
	TX_SFX_ITEM_1
	db "@"

LighthouseText_Surfboard:
	TX_FAR _LighthouseText_Surfboard
	db "@"

LighthouseText_NoRoom:
	TX_FAR _LighthouseText_NoRoom
	db "@"

LighthouseText_Trade:
	TX_ASM
	ld a, $a
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	jp TextScriptEnd
