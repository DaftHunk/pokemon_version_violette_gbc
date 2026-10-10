CopycatsHouse2F_h:
	db PALLET_REDS_HOUSE ; tileset
	db SAFFRON_COPYCATS_HOUSE_2F_HEIGHT, SAFFRON_COPYCATS_HOUSE_2F_WIDTH ; dimensions (y, x)
	dw CopycatsHouse2FBlocks, CopycatsHouse2FTextPointers, CopycatsHouse2FScript ; blocks, texts, scripts
	db 0 ; connections
	dw CopycatsHouse2FObject ; objects
