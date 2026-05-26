ForgottenTownObject:
	db $0f ; border block

;	db 0
	db 2 ; warps
	warp 18, 5, 0, BLUES_HOUSE
	warp 19, 5, 0, BLUES_HOUSE

	db 0 ; signs

	db 0 ; objects

	; warp-to
	warp_to 18, 5, FORGOTTEN_TOWN_WIDTH ; BLUES_HOUSE
	warp_to 19, 5, FORGOTTEN_TOWN_WIDTH ; BLUES_HOUSE
