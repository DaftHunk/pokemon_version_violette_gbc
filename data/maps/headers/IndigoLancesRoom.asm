Lance_h:
	db GYM ; tileset
	db INDIGO_LANCES_ROOM_HEIGHT, INDIGO_LANCES_ROOM_WIDTH ; dimensions (y, x)
	dw LanceBlocks, LanceTextPointers, LanceScript ; blocks, texts, scripts
	db 0 ; connections
	dw LanceObject ; objects
