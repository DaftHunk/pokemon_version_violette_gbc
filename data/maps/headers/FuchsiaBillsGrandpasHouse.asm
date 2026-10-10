FuchsiaHouse1_h:
	db HOUSE ; tileset
	db FUCHSIA_BILLS_GRANDPAS_HOUSE_HEIGHT, FUCHSIA_BILLS_GRANDPAS_HOUSE_WIDTH ; dimensions (y, x)
	dw FuchsiaHouse1Blocks, FuchsiaHouse1TextPointers, FuchsiaHouse1Script ; blocks, texts, scripts
	db 0 ; connections
	dw FuchsiaHouse1Object ; objects
