HallofFameRoom_h:
	db GYM ; tileset
	db INDIGO_HALL_OF_FAME_HEIGHT, INDIGO_HALL_OF_FAME_WIDTH ; dimensions (y, x)
	dw HallofFameRoomBlocks, HallofFameRoomTextPointers, HallofFameRoomScript ; blocks, texts, scripts
	db 0 ; connections
	dw HallofFameRoomObject ; objects
