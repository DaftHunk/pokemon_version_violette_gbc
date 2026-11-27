CeruleanMelanieHouse_h:
	db HOUSE ; tileset
	db CERULEAN_MELANIE_HOUSE_HEIGHT, CERULEAN_MELANIE_HOUSE_WIDTH ; dimensions (y, x)
	dw CeruleanMelanieHouseBlocks, CeruleanMelanieHouseTextPointers, CeruleanMelanieHouseScript ; blocks, texts, scripts
	db 0 ; connections
	dw CeruleanMelanieHouseObject ; objects
