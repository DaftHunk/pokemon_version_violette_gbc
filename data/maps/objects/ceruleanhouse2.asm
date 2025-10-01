CeruleanHouse2Object:
	db $c ; border block

	db 3 ; warps
	warp 2, 0, 9, -1
	warp 2, 7, 8, -1
	warp 3, 7, 8, -1

	db 0 ; signs

	db 3 ; objects
	object SPRITE_FAT_BALD_GUY, 5, 3, STAY, RIGHT, 1 ; CeruleanBadgeHouseMainText
	object SPRITE_CLIPBOARD, 4, 0, STAY, NONE, 2 ; CeruleanBadgeHouseText_LevelCap
	object SPRITE_CLIPBOARD, 6, 0, STAY, NONE, 3 ; CeruleanBadgeHouseText_CurrentCap

	; warp-to
	warp_to 2, 0, CERULEAN_BADGE_HOUSE_WIDTH
	warp_to 2, 7, CERULEAN_BADGE_HOUSE_WIDTH
	warp_to 3, 7, CERULEAN_BADGE_HOUSE_WIDTH
