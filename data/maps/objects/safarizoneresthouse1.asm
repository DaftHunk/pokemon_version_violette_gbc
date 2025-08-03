SafariZoneRestHouse1Object:
	db $a ; border block

	db 2 ; warps
	warp 2, 7, 8, SAFARI_ZONE_CENTER
	warp 3, 7, 8, SAFARI_ZONE_CENTER

	db 0 ; signs

	db 3 ; objects
	object SPRITE_GIRL, 3, 2, STAY, DOWN, 1 ; Julia
	object SPRITE_OAK_AIDE, 1, 4, WALK, 1, 2 ; person
	object SPRITE_FISHER2, 4, 2, STAY, DOWN, 3 ; Nico

	; warp-to
	warp_to 2, 7, SAFARI_ZONE_CENTER_REST_HOUSE_WIDTH ; SAFARI_ZONE_CENTER
	warp_to 3, 7, SAFARI_ZONE_CENTER_REST_HOUSE_WIDTH ; SAFARI_ZONE_CENTER
