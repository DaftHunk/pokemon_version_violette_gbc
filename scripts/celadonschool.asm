CeladonSchoolScript:
	jp EnableAutoTextBoxDrawing

CeladonSchoolTextPointers:
	dw CeladonSchoolText_MoveDeleter
	dw CeladonSchoolText_MoveRelearner
	dw CeladonSchoolText_PogKid

CeladonSchoolText_MoveDeleter:
	TX_FAR MoveDeleterText1
	db "@"

CeladonSchoolText_MoveRelearner:
	TX_FAR MoveRelearnerText1
	db "@"

CeladonSchoolText_PogKid:
	TX_ASM
	ld hl, .celadonSchoolText_PogKid
	call PrintText
	jp TextScriptEnd

.celadonSchoolText_PogKid
	text "Quoi #mon?"
	line "M'en fiche des"
	cont "#mon!"

	para "Moi j'ai une"
	line "collec' de Pog!"
	done
	db "@"
