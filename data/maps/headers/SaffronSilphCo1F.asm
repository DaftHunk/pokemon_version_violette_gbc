SilphCo1_h:
	db FACILITY ; tileset
	db SAFFRON_SILPH_CO_1F_HEIGHT, SAFFRON_SILPH_CO_1F_WIDTH ; dimensions (y, x)
	dw SilphCo1Blocks, SilphCo1TextPointers, SilphCo1Script ; blocks, texts, scripts
	db 0 ; connections
	dw SilphCo1Object ; objects
