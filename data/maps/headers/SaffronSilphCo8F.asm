SilphCo8_h:
	db FACILITY ; tileset
	db SAFFRON_SILPH_CO_8F_HEIGHT, SAFFRON_SILPH_CO_8F_WIDTH ; dimensions (y, x)
	dw SilphCo8Blocks, SilphCo8TextPointers, SilphCo8Script ; blocks, texts, scripts
	db 0 ; connections
	dw SilphCo8Object ; objects
