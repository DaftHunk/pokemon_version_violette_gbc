CeladonSchool_h:
	db HOUSE ; tileset
	db CELADON_SCHOOL_HEIGHT, CELADON_SCHOOL_WIDTH ; dimensions (y, x)
	dw CeladonSchoolBlocks, CeladonSchoolTextPointers, CeladonSchoolScript ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonSchoolObject ; objects
