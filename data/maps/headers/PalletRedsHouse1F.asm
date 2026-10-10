RedsHouse1F_h:
	db PALLET_REDS_HOUSE ; tileset
	db PALLET_REDS_HOUSE_1F_HEIGHT, PALLET_REDS_HOUSE_1F_WIDTH ; dimensions
	dw RedsHouse1FBlocks, RedsHouse1FTextPointers, RedsHouse1FScript
	db 0 ; no connections
	dw RedsHouse1FObject
