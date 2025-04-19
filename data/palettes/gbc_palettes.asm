; palettes for overworlds, title screen, monsters
;gbcnote - add pokemon yellow GBC palettes
GBCBasePalettes:
	; PAL_ROUTE
	SGB_WHITE
	RGB 16, 31,  4
	RGB 11, 23, 31
	RGB  3,  3,  3

	; PAL_PALLET
	SGB_WHITE
	RGB 23, 17, 31
	RGB 11, 23, 31
	RGB  3,  3,  3

	; PAL_VIRIDIAN
	SGB_WHITE
	RGB 19, 31,  0
	RGB 11, 23, 31
	RGB  3,  3,  3

	; PAL_PEWTER
	SGB_WHITE
	RGB 18, 18, 15
	RGB 11, 23, 31
	RGB  3,  3,  3

	; PAL_CERULEAN
	SGB_WHITE
	RGB  5,  8, 31
	RGB 11, 23, 31
	RGB  3,  3,  3

	; PAL_LAVENDER
	SGB_WHITE
	RGB 25,  4, 31
	RGB 11, 23, 31
	RGB  3,  3,  3

	; PAL_VERMILION
	SGB_WHITE
	RGB 31, 19,  0
	RGB 11, 23, 31
	RGB  3,  3,  3

	; PAL_CELADON
	SGB_WHITE
	RGB  5, 31,  5
	RGB 11, 23, 31
	RGB  3,  3,  3

	; PAL_SAFFRON
	SGB_WHITE
	RGB 31, 31,  0
	RGB 11, 23, 31
	RGB  3,  3,  3

	; PAL_FUCHSIA
	SGB_WHITE
	RGB 31, 15, 15
	RGB 11, 23, 31
	RGB  3,  3,  3

	; PAL_CINNABAR
	SGB_WHITE
	RGB 31,  8,  8
	RGB 11, 23, 31
	RGB  3,  3,  3

	; PAL_INDIGO
	SGB_WHITE
	RGB 11,  8, 31
	RGB 11, 23, 31
	RGB  3,  3,  3

	; PAL_TOWNMAP
	SGB_WHITE
	RGB  0, 21, 31
	RGB 10, 28,  0
	RGB  1,  1,  1

	; PAL_LOGO1
	SGB_WHITE    	;white bg
	RGB 31, 31,  0	;unused yellow logo text
	RGB 21,  0,  4	;unused on title screen
	RGB 12,  1, 22	;version subtitle text color

	; PAL_LOGO2
	SGB_WHITE    	;white bg
	RGB 31, 31,  0	;yellow logo text
	RGB 12,  1, 22	;blue logo text shadow
	RGB  0,  0, 17	;blue logo text outline

	; PAL_0F
	SGB_WHITE
	RGB 13,  1, 31
	RGB  0,  9, 31
	RGB  1,  1,  1

	; PAL_MEWMON	;reworked to match red/blue tones 
	SGB_WHITE
	RGB 30, 17, 11
	RGB 11,  5, 14
	RGB  3,  3,  3

	; PAL_BLUEMON
	SGB_WHITE
	RGB 16, 18, 31
	RGB  0,  1, 25
	RGB  3,  3,  3

	; PAL_ORANGEMON
	SGB_WHITE
	RGB 31, 17,  0
	RGB 31,  0,  0
	RGB  3,  3,  3

	; PAL_CYANMON
	SGB_WHITE
	RGB 16, 26, 31
	RGB  0, 17, 31
	RGB  3,  3,  3

	; PAL_PURPLEMON
	SGB_WHITE
	RGB 25, 15, 31
	RGB  12, 1, 22
	RGB  3,  3,  3

	; PAL_BROWNMON
	SGB_WHITE
	RGB 29, 18, 10
	RGB 17,  9,  5
	RGB  3,  3,  3

	; PAL_GREENMON
	SGB_WHITE
	RGB 17, 31, 11
	RGB  1, 22,  6
	RGB  3,  3,  3

	; PAL_PINKMON
	SGB_WHITE
	RGB 31, 15, 18
	RGB 31,  0,  6
	RGB  3,  3,  3

	; PAL_YELLOWMON
	SGB_WHITE
	RGB 31, 31,  0
	RGB 28, 14,  0
	RGB  3,  3,  3

	; PAL_GREYMON
	SGB_WHITE
;Use Yellow's version of gray if using yellow sprites
	RGB 20, 23, 10
	RGB 11, 11,  5
	RGB  3,  3,  3

;gbcnote - retouched all the slot palettes to match the red/blue coloring
	; PAL_SLOTS1
	SGB_WHITE    	;reel background
	RGB 21, 12, 15	;reel accents
	RGB 21, 14,  0	;"7" fill color
	RGB  3,  3,  3	;reel outline

	; PAL_SLOTS2
	SGB_WHITE   	;"3" icon fill
	RGB 31, 31,  0	;"3" icon shape color
	RGB  9,  5, 30	;"3" icon background color
	RGB  3,  3,  3	;"3" icon outline

	; PAL_SLOTS3
	SGB_WHITE	    ;"2" icon fill
	RGB  3, 31,  9	;"2" icon shape color
	RGB  9,  5, 30	;"2" icon background color
	RGB  3,  3,  3	;"2" icon outline

	; PAL_SLOTS4
	SGB_WHITE    	;"1" icon fill
	RGB 20,  8, 15	;"1" icon shape color
	RGB  9,  5, 30	;"1" icon background color
	RGB  3,  3,  3	;"1" icon outline

	; PAL_BLACK
	SGB_WHITE
	RGB  3,  3,  3
	RGB  3,  3,  3
	RGB  3,  3,  3

	; PAL_GREENBAR
	SGB_WHITE
	RGB 31, 31,  0
	RGB  0, 31,  0
	RGB  3,  3,  3

	; PAL_YELLOWBAR
	SGB_WHITE
	RGB 31, 31,  0
	RGB 31, 18,  0
	RGB  3,  3,  3

	; PAL_REDBAR
	SGB_WHITE
	RGB 31, 31,  0
	RGB 31,  0,  0
	RGB  3,  3,  3

	; PAL_BADGE	
	;re-toned to a nice teal for the cascade and earth badges
	SGB_WHITE
	RGB  3, 11,  6
	RGB  3, 17, 11
	RGB  3,  3,  3

	; PAL_CAVE
	SGB_WHITE
	RGB 23,  8,  0
	RGB 17, 14, 11
	RGB  3,  3,  3

	; PAL_GAMEFREAK
	SGB_WHITE
	RGB 31, 19,  0
	RGB 19, 19,  0
	RGB  3,  3,  3

	; PAL_25
	SGB_WHITE
	RGB 31, 31,  0
	RGB 11, 23, 31
	RGB  3,  3,  3

	; PAL_26
	SGB_WHITE
	RGB 31, 18,  0
	RGB 19,  7,  1
	RGB  3,  3,  3

	; PAL_27
	SGB_WHITE
	RGB  9,  9,  9
	RGB 31, 21,  0
	RGB  3,  3,  3

	; PAL_BW	;joenote - adding a black & white palette just for GBC
	SGB_WHITE
	RGB 31, 31, 31
	RGB  3,  3,  3
	RGB  3,  3,  3

	; PAL_UBALL	;joenote - adding a pal just for ultra balls on GBC
	SGB_WHITE
	RGB 24, 24, 24
	RGB  8,  8,  8
	RGB  3,  3,  3
	
	; PAL_REDMON
	SGB_WHITE 
	RGB 31,  8,  0
	RGB 31,  0,  0
	RGB  3,  3,  3

	; PAL_GREYBLUEMON
	SGB_WHITE 
	RGB 15, 18, 20
	RGB 15, 18, 20
	RGB  3,  3,  3
	
	; PAL_REDBLUEMON
	SGB_WHITE 
	RGB  5,  5, 13
	RGB 31,  5,  5
	RGB  3,  3,  3

	; PAL_VOLCANO
	SGB_WHITE
	RGB 29,  4,  0
	RGB 10, 11, 11
	RGB  3,  3,  3
