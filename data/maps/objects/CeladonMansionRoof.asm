CeladonMansionRoofObject:
	db $9 ; border block

	db 3 ; warps
	warp 6, 1, 1, CELADON_MANSION_3F
	warp 1, 1, 2, CELADON_MANSION_3F
	warp 2, 7, 0, CELADON_MANSION_ROOF_HOUSE

	db 2 ; signs
	sign 3, 7, 1 ; CeladonMansionRoofText1
	sign 1, 4, 2 ; CeladonMansionRoofText_Graffiti

	db 0 ; objects

	; warp-to
	warp_to 6, 1, CELADON_MANSION_ROOF_WIDTH ; CELADON_MANSION_3F
	warp_to 1, 1, CELADON_MANSION_ROOF_WIDTH ; CELADON_MANSION_3F
	warp_to 2, 7, CELADON_MANSION_ROOF_WIDTH ; CELADON_MANSION_ROOF_HOUSE
