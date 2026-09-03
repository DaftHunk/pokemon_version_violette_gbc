PowerPlant1FObject:
	db $2e ; border block

	db 2 ; warps
	warp 0, 11, 3, ROUTE_10
	warp 16, 1, 2, POWER_PLANT

	db 0 ; signs

	db 4 ; objects
	object SPRITE_BALL,  16, 5, STAY, NONE, 1, ELECTRODE, 43 ; Electrode2Text
	object SPRITE_ZAPDOS, 4, 9, STAY, DOWN, 2, ZAPDOS, 50 ; ZapdosText
	object SPRITE_BALL,  28, 3, STAY, NONE, 3, HP_UP ; PickUpItemText
	object SPRITE_BALL,  34, 3, STAY, NONE, 4, RARE_CANDY ; PickUpItemText

	; warp-to
	warp_to 0, 11, POWER_PLANT_1F_WIDTH
	warp_to 16, 1, POWER_PLANT_1F_WIDTH
