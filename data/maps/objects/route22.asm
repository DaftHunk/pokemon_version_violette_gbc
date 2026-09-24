Route22Object:
	db $2c ; border block

	db 2 ; warps
	warp 8, 5, 0, ROUTE_22_GATE
	warp 9, 5, 1, ROUTE_22_GATE

	db 1 ; signs
	sign 9, 9, 3 ; Route22FrontGateText

	db 2 ; objects
	object SPRITE_BLUE, 25, 5, STAY, RIGHT, 1 ; person
	object SPRITE_BLUE, 25, 5, STAY, RIGHT, 2 ; person

	; warp-to
	warp_to 8, 5, ROUTE_22_WIDTH ; ROUTE_22_GATE
	warp_to 9, 5, ROUTE_22_WIDTH ; ROUTE_22_GATE
