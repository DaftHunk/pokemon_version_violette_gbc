Lorelei_h:
	db GYM ; tileset
	db INDIGO_LORELEIS_ROOM_HEIGHT, INDIGO_LORELEIS_ROOM_WIDTH ; dimensions (y, x)
	dw LoreleiBlocks, LoreleiTextPointers, LoreleiScript ; blocks, texts, scripts
	db 0 ; connections
	dw LoreleiObject ; objects
