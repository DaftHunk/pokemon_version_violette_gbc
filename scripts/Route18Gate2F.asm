Route18GateUpstairsScript:
	jp DisableAutoTextBoxDrawing

Route18GateUpstairsTextPointers:
	dw Route18GateUpstairsText1
	dw Route18GateUpstairsText

Route18GateUpstairsText1:
	TX_ASM
	ld a, $5
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	jp TextScriptEnd

Route18GateUpstairsText:
	TX_ASM
	ld hl, Route18GateUpstairsText_49993
	jp GateUpstairsScript_PrintIfFacingUp

Route18GateUpstairsText_49993:
	TX_FAR _Route18GateUpstairsText_49993
	db "@"
