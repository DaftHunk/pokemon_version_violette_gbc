CeladonMansion2F_h:
	db MANSION ; tileset
	db CELADON_MANSION_2F_HEIGHT, CELADON_MANSION_2F_WIDTH ; dimensions (y, x)
	dw CeladonMansion2FBlocks, CeladonMansion2FTextPointers, CeladonMansion2FScript ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonMansion2FObject ; objects
