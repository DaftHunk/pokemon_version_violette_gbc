Route16WestGateScript:
	jp EnableAutoTextBoxDrawing

Route16WestGateTextPointers:
	dw Route16WestGateAquariumText
	dw Route16WestGatePCText
	dw Route16WestGateLettersText
	dw Route16WestGateSafeText

Route16WestGateAquariumText:
	TX_FAR _Route16WestGateAquariumText
	db "@"
	
Route16WestGatePCText:
	TX_FAR _Route16WestGatePCText
	db "@"
	
Route16WestGateLettersText:
	TX_FAR _Route16WestGateLettersText
	db "@"

Route16WestGateSafeText:
	TX_ASM
	CheckEvent EVENT_GIOVANNI_SAFE_CODE
	jr nz, .hasCode
	; else
	ld hl, .route16WestGateNoCodeText
	jr .endScript
.hasCode
	SetEvent EVENT_ARMORED_MEWTWO_KNOWLEDGE
	ld hl, .route16WestGateHasCodeText
	; fallthrough
.endScript
	call PrintText
	jp TextScriptEnd

.route16WestGateNoCodeText
	TX_FAR _Route16WestGateNoCodeText
	db "@"
.route16WestGateHasCodeText
	TX_FAR _Route16WestGateHasCodeText
	TX_SFX_KEY_ITEM
	TX_FAR _Route16WestGateInstructionText
	db "@"