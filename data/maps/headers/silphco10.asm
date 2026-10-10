SilphCo10_h:
	db FACILITY ; tileset
	db SAFFRON_SILPH_CO_10F_HEIGHT, SAFFRON_SILPH_CO_10F_WIDTH ; dimensions (y, x)
	dw SilphCo10Blocks, SilphCo10TextPointers, SilphCo10Script ; blocks, texts, scripts
	db 0 ; connections
	dw SilphCo10Object ; objects
