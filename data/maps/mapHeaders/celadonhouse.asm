CeladonHouse_h:
	db MANSION ; tileset
	db CELADON_CHIEF_HOUSE_HEIGHT, CELADON_CHIEF_HOUSE_WIDTH ; dimensions (y, x)
	dw CeladonHouseBlocks, CeladonHouseTextPointers, CeladonHouseScript ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonHouseObject ; objects
