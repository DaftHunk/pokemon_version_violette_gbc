VolcanoB2F_h:
	db VOLCANO ; tileset
	db VOLCANO_B2F_HEIGHT, VOLCANO_B2F_WIDTH ; dimensions (y, x)
	dw VolcanoB2FBlocks, VolcanoB2FTextPointers, VolcanoB2FScript ; blocks, texts, scripts
	db 0 ; connections
	dw VolcanoB2FObject ; objects
