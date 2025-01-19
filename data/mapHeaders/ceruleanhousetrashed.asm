CeruleanHouseTrashed_h:
	db HOUSE ; tileset
	db CERULEAN_TRASHED_HOUSE_HEIGHT, CERULEAN_TRASHED_HOUSE_WIDTH ; dimensions (y, x)
	dw CeruleanHouseTrashedBlocks, CeruleanHouseTrashedTextPointers, CeruleanHouseTrashedScript ; blocks, texts, scripts
	db 0 ; connections
	dw CeruleanHouseTrashedObject ; objects
