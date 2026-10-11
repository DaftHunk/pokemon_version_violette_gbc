ForgottenTown_h:
	db ALPHA ; tileset
	db FORGOTTEN_TOWN_HEIGHT, FORGOTTEN_TOWN_WIDTH ; dimensions (y, x)
	dw ForgottenTownBlocks, ForgottenTownTextPointers, ForgottenTownScript ; blocks, texts, scripts
	db 0 ; connections
	dw ForgottenTownObject ; objects
