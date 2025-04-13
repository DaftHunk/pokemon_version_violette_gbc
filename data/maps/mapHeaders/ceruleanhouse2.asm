CeruleanHouse2_h:
	db SHIP ; tileset
	db CERULEAN_BADGE_HOUSE_HEIGHT, CERULEAN_BADGE_HOUSE_WIDTH ; dimensions (y, x)
	dw CeruleanHouse2Blocks, CeruleanHouse2TextPointers, CeruleanHouse2Script ; blocks, texts, scripts
	db 0 ; connections
	dw CeruleanHouse2Object ; objects
