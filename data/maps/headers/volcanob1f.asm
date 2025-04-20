VolcanoB1F_h:
	db VOLCANO ; tileset
	db VOLCANO_B1F_HEIGHT, VOLCANO_B1F_WIDTH ; dimensions (y, x)
	dw VolcanoB1FBlocks, VolcanoB1FTextPointers, VolcanoB1FScript ; blocks, texts, scripts
	db 0 ; connections
	dw VolcanoB1FObject ; objects
