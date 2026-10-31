Museum1FObject:
	db $a ; border block

	db 5 ; warps
	warp 10,  9, 0, -1
	warp 11,  9, 0, -1
	warp 16,  5, 1, -1
	warp 17,  5, 1, -1
	warp  7,  9, 0, PEWTER_MUSEUM_2F

	db 0 ; signs

	db 5 ; objects
	object SPRITE_OAK_AIDE,  12,  5, STAY, LEFT, 1 ; Museum1FText1
	object SPRITE_GAMBLER,    1,  4, STAY, NONE, 2 ; Museum1FText2
	object SPRITE_OAK_AIDE,  15,  2, STAY, DOWN, 3 ; Museum1FText3
	object SPRITE_OAK_AIDE,  18,  4, STAY, NONE, 4 ; Museum1FText4
	object SPRITE_OLD_AMBER, 16,  2, STAY, NONE, 5 ; Museum1FText5

	; warp-to
	warp_to 10,  9, PEWTER_MUSEUM_1F_WIDTH
	warp_to 11,  9, PEWTER_MUSEUM_1F_WIDTH
	warp_to 16,  5, PEWTER_MUSEUM_1F_WIDTH
	warp_to 17,  5, PEWTER_MUSEUM_1F_WIDTH
	warp_to  7,  9, PEWTER_MUSEUM_1F_WIDTH ; PEWTER_MUSEUM_2F
