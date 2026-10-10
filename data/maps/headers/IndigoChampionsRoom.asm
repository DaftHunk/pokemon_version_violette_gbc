Rival_h:
	db GYM ;tileset
	db INDIGO_CHAMPIONS_ROOM_HEIGHT, INDIGO_CHAMPIONS_ROOM_WIDTH ; Height, Width
	dw RivalBlocks, RivalTextPointers, RivalScript
	db $0 ;No Connections
	dw RivalObject
