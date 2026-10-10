SilphCo6_h:
	db FACILITY ; tileset
	db SAFFRON_SILPH_CO_6F_HEIGHT, SAFFRON_SILPH_CO_6F_WIDTH ; dimensions (y, x)
	dw SilphCo6Blocks, SilphCo6TextPointers, SilphCo6Script ; blocks, texts, scripts
	db 0 ; connections
	dw SilphCo6Object ; objects
