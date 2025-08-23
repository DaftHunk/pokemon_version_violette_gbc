Route16WestGateScript:
	jp EnableAutoTextBoxDrawing

Route16WestGateTextPointers:
	dw Route16WestGateAquariumText
	dw Route16WestGatePCText
	dw Route16WestGateLettersText

Route16WestGateAquariumText:
	TX_FAR _Route16WestGateAquariumText
	db "@"
	
Route16WestGatePCText:
	TX_FAR _Route16WestGatePCText
	db "@"
	
Route16WestGateLettersText:
	TX_FAR _Route16WestGateLettersText
	db "@"