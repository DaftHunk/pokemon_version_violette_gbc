MansionB1F_h:
	db FACILITY ; tileset
	db CINNABAR_MANSION_B1F_HEIGHT, CINNABAR_MANSION_B1F_WIDTH ; dimensions (y, x)
	dw MansionB1FBlocks, MansionB1FTextPointers, MansionB1FScript ; blocks, texts, scripts
	db 0 ; connections
	dw MansionB1FObject ; objects
