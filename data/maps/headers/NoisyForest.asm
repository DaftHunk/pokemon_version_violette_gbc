NoisyForest_h:
	db HOUSE ; tileset
	db NOISY_FOREST_HEIGHT, NOISY_FOREST_WIDTH ; dimensions (y, x)
	dw 0 ;NoisyForestBlocks, NoisyForestTextPointers, NoisyForestScript ; blocks, texts, scripts
	db 0 ; connections
	dw 0 ;NoisyForestObject ; objects
