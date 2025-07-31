SaffronHouse1Script:
	jp EnableAutoTextBoxDrawing

SaffronHouse1TextPointers:
	dw SaffronHouse1Text1
	dw SaffronHouse1Text2
	dw SaffronHouse1Text3
	dw SaffronHouse1Text4
;joenote - adding text pointers for move deleter/relearner
	dw MoveDeleterText	;text 5
	dw MoveRelearnerText	;text 6

SaffronHouse1Text1:
	TX_FAR _SaffronHouse1Text1
	db "@"

SaffronHouse1Text2:
	TX_FAR _SaffronHouse1Text2
	TX_ASM
	ld a, PIDGEY
	call DisplayPokedex
	jp TextScriptEnd

SaffronHouse1Text3:
	TX_FAR _SaffronHouse1Text3
	db "@"

SaffronHouse1Text4:
	TX_FAR _SaffronHouse1Text4
	db "@"

MoveDeleterText:
	TX_FAR MoveDeleterText1
	db "@"

MoveRelearnerText:
	TX_FAR MoveRelearnerText1
	db "@"
