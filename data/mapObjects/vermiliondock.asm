VermilionDockObject:
	db $f ; border block

	db 2 ; warps
	warp 14, 0, 5, -1
	warp 14, 2, 1, SS_ANNE_1F

	db 0 ; signs

	db 1 ; objects
	object SPRITE_GIRL, 22, 0, WALK, 2, 2, OPP_JR_TRAINER_F, 24	;joenote - adding Seiga, the orange leage champ, special battle 
	
	; warp-to
	warp_to 14, 0, VERMILION_DOCK_WIDTH
	warp_to 14, 2, VERMILION_DOCK_WIDTH ; SS_ANNE_1F
