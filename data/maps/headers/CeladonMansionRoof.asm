CeladonMansionRoof_h:
	db MANSION ; tileset
	db CELADON_MANSION_ROOF_HEIGHT, CELADON_MANSION_ROOF_WIDTH ; dimensions (y, x)
	dw CeladonMansionRoofBlocks, CeladonMansionRoofTextPointers, CeladonMansionRoofScript ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonMansionRoofObject ; objects
