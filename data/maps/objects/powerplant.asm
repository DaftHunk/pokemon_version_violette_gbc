PowerPlantObject:
	db $2e ; border block

	db 3 ; warps
	warp  4, 23, 3, -1
	warp  5, 23, 3, -1
	warp  23, 1, 1, POWER_PLANT_1F

	db 0 ; signs

	db 11 ; objects
	object SPRITE_BALL,  9,  8, STAY, NONE, 1, VOLTORB, 40 ; Voltorb0Text
	object SPRITE_BALL, 32,  6, STAY, NONE, 2, VOLTORB, 40 ; Voltorb1Text
	object SPRITE_BALL, 21, 13, STAY, NONE, 3, VOLTORB, 40 ; Voltorb2Text
	object SPRITE_BALL, 25,  6, STAY, NONE, 4, ELECTRODE, 43 ; Electrode1Text
	object SPRITE_BALL, 23, 22, STAY, NONE, 5, VOLTORB, 40 ; Voltorb4Text
	object SPRITE_BALL, 26, 16, STAY, NONE, 6, VOLTORB, 40 ; Voltorb5Text
	object SPRITE_BALL, 37, 20, STAY, NONE, 7, VOLTORB, 40 ; Voltorb6Text
	object SPRITE_BALL,  7, 13, STAY, NONE, 8, CARBOS
	object SPRITE_BALL, 26, 20, STAY, NONE, 9, TM25_THUNDER
	object SPRITE_BALL, 20, 20, STAY, NONE, 10, TM33_REFLECT
	object SPRITE_BALL, 21,  2, STAY, NONE, 11, METAL_COAT

	; warp-to
	warp_to  4, 23, POWER_PLANT_WIDTH
	warp_to  5, 23, POWER_PLANT_WIDTH
	warp_to  23, 1, POWER_PLANT_WIDTH
