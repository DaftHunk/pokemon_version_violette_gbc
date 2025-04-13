CeruleanHouse1_h:
	db HOUSE ; tileset
	db CERULEAN_MELANIES_HOUSE_HEIGHT, CERULEAN_MELANIES_HOUSE_WIDTH ; dimensions (y, x)
	dw CeruleanHouse1Blocks, CeruleanHouse1TextPointers, CeruleanHouse1Script ; blocks, texts, scripts
	db 0 ; connections
	dw CeruleanHouse1Object ; objects
