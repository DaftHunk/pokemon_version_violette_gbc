Route9Object:
	db $2c ; border block

	db 0 ; warps

	db 1 ; signs
	sign 25, 7, 12 ; Route9Text11

	db 11 ; objects
	;joenote - added a construction worker to replace the blocking cut shrub
	object SPRITE_LASS, 13, 10, STAY, LEFT, 1, OPP_JR_TRAINER_F, 4
	object SPRITE_BLACK_HAIR_BOY_1, 24, 7, STAY, LEFT, 2, OPP_JR_TRAINER_M, 5
	object SPRITE_BLACK_HAIR_BOY_1, 31, 7, STAY, RIGHT, 3, OPP_JR_TRAINER_M, 6
	object SPRITE_LASS, 48, 8, STAY, RIGHT, 4, OPP_JR_TRAINER_F, 5
	object SPRITE_HIKER, 16, 15, STAY, LEFT, 5, OPP_HIKER, 5
	object SPRITE_HIKER, 43, 3, STAY, LEFT, 6, OPP_HIKER, 6
	object SPRITE_BUG_CATCHER, 22, 2, STAY, DOWN, 7, OPP_BUG_CATCHER, 12
	object SPRITE_HIKER, 45, 15, STAY, RIGHT, 8, OPP_HIKER, 7
	object SPRITE_BUG_CATCHER, 40, 8, STAY, RIGHT, 9, OPP_BUG_CATCHER, 13
	object SPRITE_BALL, 10, 15, STAY, NONE, 10, TM30_TELEPORT
	object SPRITE_HIKER,  5,  8, STAY, NONE, 11	;non-trainer person
