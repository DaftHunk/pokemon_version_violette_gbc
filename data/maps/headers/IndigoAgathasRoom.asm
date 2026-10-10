Agatha_h:
	db CEMETERY ; tileset
	db INDIGO_AGATHAS_ROOM_HEIGHT, INDIGO_AGATHAS_ROOM_WIDTH ; dimensions (y, x)
	dw AgathaBlocks, AgathaTextPointers, AgathaScript ; blocks, texts, scripts
	db 0 ; connections
	dw AgathaObject ; objects
