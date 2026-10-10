CopycatsHouse1F_h:
	db PALLET_REDS_HOUSE_1 ; tileset
	db SAFFRON_COPYCATS_HOUSE_1F_HEIGHT, SAFFRON_COPYCATS_HOUSE_1F_WIDTH ; dimensions (y, x)
	dw CopycatsHouse1FBlocks, CopycatsHouse1FTextPointers, CopycatsHouse1FScript ; blocks, texts, scripts
	db 0 ; connections
	dw CopycatsHouse1FObject ; objects
