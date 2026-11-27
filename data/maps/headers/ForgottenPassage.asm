ForgottenPassage_h:
	db HOUSE ; tileset
	db FORGOTTEN_PASSAGE_HEIGHT, FORGOTTEN_PASSAGE_WIDTH ; dimensions (y, x)
	dw 0 ;ForgottenPassageBlocks, ForgottenPassageTextPointers, ForgottenPassageScript ; blocks, texts, scripts
	db 0 ; connections
	dw 0 ;ForgottenPassageObject ; objects
