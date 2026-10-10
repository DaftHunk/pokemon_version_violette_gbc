OaksLab_h:
	db GYM ; tileset
	db PALLET_OAKS_LAB_HEIGHT, PALLET_OAKS_LAB_WIDTH ; dimensions (y, x)
	dw OaksLabBlocks, OaksLabTextPointers, OaksLabScript ; blocks, texts, scripts
	db 0 ; connections
	dw OaksLabObject ; objects
