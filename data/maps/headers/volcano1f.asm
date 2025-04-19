Volcano1F_h:
	db VOLCANO ; tileset
	db VOLCANO_1F_HEIGHT, VOLCANO_1F_WIDTH ; dimensions (y, x)
	dw Volcano1FBlocks, Volcano1FTextPointers, Volcano1FScript ; blocks, texts, scripts
	db 0 ; connections
	dw Volcano1FObject ; objects
