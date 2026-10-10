Bruno_h:
	db GYM ; tileset
	db INDIGO_BRUNOS_ROOM_HEIGHT, INDIGO_BRUNOS_ROOM_WIDTH ; dimensions (y, x)
	dw BrunoBlocks, BrunoTextPointers, BrunoScript ; blocks, texts, scripts
	db 0 ; connections
	dw BrunoObject ; objects
