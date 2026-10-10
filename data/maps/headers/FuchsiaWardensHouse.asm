FuchsiaHouse2_h:
	db LAB ; tileset
	db FUCHSIA_WARDENS_HOUSE_HEIGHT, FUCHSIA_WARDENS_HOUSE_WIDTH ; dimensions (y, x)
	dw FuchsiaHouse2Blocks, FuchsiaHouse2TextPointers, FuchsiaHouse2Script ; blocks, texts, scripts
	db 0 ; connections
	dw FuchsiaHouse2Object ; objects
