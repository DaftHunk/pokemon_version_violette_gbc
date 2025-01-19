MtMoon2_h:
	db CAVERN ; tileset
	db MT_MOON_B1F_HEIGHT, MT_MOON_B1F_WIDTH ; dimensions (y, x)
	dw MtMoon2Blocks, MtMoon2TextPointers, MtMoon2Script ; blocks, texts, scripts
	db 0 ; connections
	dw MtMoon2Object ; objects
