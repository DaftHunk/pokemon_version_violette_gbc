MtMoonB2F_h:
	db CAVERN ; tileset
	db MT_MOON_B2F_HEIGHT, MT_MOON_B2F_WIDTH ; dimensions (y, x)
	dw MtMoonB2FBlocks, MtMoonB2FTextPointers, MtMoonB2FScript ; blocks, texts, scripts
	db 0 ; connections
	dw MtMoonB2FObject ; objects
