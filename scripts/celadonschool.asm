CeladonSchoolScript:
	jp EnableAutoTextBoxDrawing

CeladonSchoolTextPointers:
	dw MoveDeleterText
	dw MoveRelearnerText

MoveDeleterText:
	TX_FAR MoveDeleterText1
	db "@"

MoveRelearnerText:
	TX_FAR MoveRelearnerText1
	db "@"