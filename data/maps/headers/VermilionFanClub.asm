FanClub_h:
	db INTERIOR ; tileset
	db VERMILION_FAN_CLUB_HEIGHT, VERMILION_FAN_CLUB_WIDTH ; dimensions (y, x)
	dw FanClubBlocks, FanClubTextPointers, FanClubScript ; blocks, texts, scripts
	db 0 ; connections
	dw FanClubObject ; objects
