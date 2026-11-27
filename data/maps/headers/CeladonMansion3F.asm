CeladonMansion3F_h:
	db MANSION ; tileset
	db CELADON_MANSION_3F_HEIGHT, CELADON_MANSION_3F_WIDTH ; dimensions (y, x)
	dw CeladonMansion3FBlocks, CeladonMansion3FTextPointers, CeladonMansion3FScript ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonMansion3FObject ; objects
