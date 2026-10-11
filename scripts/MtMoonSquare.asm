MtMoonSquareScript:
	jp EnableAutoTextBoxDrawing

MtMoonSquareTextPointers:
	dw MtMoonSquareText_Clefairy
	dw MtMoonSquareText_Clefairy
	dw MtMoonSquareText_Sign

MtMoonSquareText_Clefairy:
	TX_FAR _MtMoonSquareText_Clefairy
	TX_ASM
	ld a, CLEFAIRY
	call DisplayPokedex
	jp TextScriptEnd

MtMoonSquareText_Sign:
	TX_FAR _MtMoonSquareText_Sign
	db "@"
