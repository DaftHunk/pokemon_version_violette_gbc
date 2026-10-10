SilphCo7_h:
	db FACILITY ; tileset
	db SAFFRON_SILPH_CO_7F_HEIGHT, SAFFRON_SILPH_CO_7F_WIDTH ; dimensions (y, x)
	dw SilphCo7Blocks, SilphCo7TextPointers, SilphCo7Script ; blocks, texts, scripts
	db 0 ; connections
	dw SilphCo7Object ; objects
