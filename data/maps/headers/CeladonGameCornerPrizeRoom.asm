CeladonPrizeRoom_h:
	db LOBBY ; tileset
	db CELADON_GAME_CORNER_PRIZE_ROOM_HEIGHT, CELADON_GAME_CORNER_PRIZE_ROOM_WIDTH ; dimensions (y, x)
	dw CeladonPrizeRoomBlocks, CeladonPrizeRoomTextPointers, CeladonPrizeRoomScript ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonPrizeRoomObject ; objects
