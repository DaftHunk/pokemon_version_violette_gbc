ViridianForestExit_h:
	db GATE ; tileset
	db VIRIDIAN_FOREST_NORTH_GATE_HEIGHT, VIRIDIAN_FOREST_NORTH_GATE_WIDTH ; dimensions (y, x)
	dw ViridianForestExitBlocks, ViridianForestExitTextPointers, ViridianForestExitScript ; blocks, texts, scripts
	db 0 ; connections
	dw ViridianForestExitObject ; objects
