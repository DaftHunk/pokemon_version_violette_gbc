ForgottenTownHouses_h:
	db HOUSE ; tileset
	db FORGOTTEN_TOWN_HOUSES_HEIGHT, FORGOTTEN_TOWN_HOUSES_WIDTH ; dimensions (y, x)
	dw 0 ;ForgottenTownHousesBlocks, ForgottenTownHousesTextPointers, ForgottenTownHousesScript ; blocks, texts, scripts
	db 0 ; connections
	dw 0 ;ForgottenTownHousesObject ; objects
