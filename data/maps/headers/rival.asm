Rival_h:
	db GYM ;tileset
	db CHAMPIONS_ROOM_HEIGHT, CHAMPIONS_ROOM_WIDTH ; Height, Width
	dw RivalBlocks, RivalTextPointers, RivalScript
	db $0 ;No Connections
	dw RivalObject
