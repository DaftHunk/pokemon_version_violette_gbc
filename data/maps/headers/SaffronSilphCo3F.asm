SilphCo3_h:
	db FACILITY ; tileset
	db SAFFRON_SILPH_CO_3F_HEIGHT, SAFFRON_SILPH_CO_3F_WIDTH ; dimensions (y, x)
	dw SilphCo3Blocks, SilphCo3TextPointers, SilphCo3Script ; blocks, texts, scripts
	db 0 ; connections
	dw SilphCo3Object ; objects
