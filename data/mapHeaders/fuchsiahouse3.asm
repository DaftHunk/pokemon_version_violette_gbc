FuchsiaHouse3_h:
	db SHIP ; tileset
	db FUCHSIA_GOOD_ROD_HOUSE_HEIGHT, FUCHSIA_GOOD_ROD_HOUSE_WIDTH ; dimensions (y, x)
	dw FuchsiaHouse3Blocks, FuchsiaHouse3TextPointers, FuchsiaHouse3Script ; blocks, texts, scripts
	db 0 ; connections
	dw FuchsiaHouse3Object ; objects
