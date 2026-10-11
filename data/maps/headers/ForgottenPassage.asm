ForgottenPassage_h:
	db ALPHA ; tileset
	db FORGOTTEN_PASSAGE_HEIGHT, FORGOTTEN_PASSAGE_WIDTH ; dimensions (y, x)
	dw ForgottenPassageBlocks, ForgottenPassageTextPointers, ForgottenPassageScript ; blocks, texts, scripts
;	db 0 ; connections
;	db SOUTH | WEST | EAST ; connections
	db WEST | EAST ; connections
;	SOUTH_MAP_CONNECTION FUCHSIA_CITY, ROUTE_19, 5, 0, Route19Blocks
	WEST_MAP_CONNECTION FORGOTTEN_PASSAGE, PALLET_TOWN, 0, 0, PalletTownBlocks
	EAST_MAP_CONNECTION FORGOTTEN_PASSAGE, ROUTE_18, 0, 0, Route18Blocks
	dw ForgottenPassageObject ; objects
