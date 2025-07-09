; palettes for overworlds, title screen, monsters
MACRO SGB_WHITE
	dw (31 << 10 | 29 << 5 | 31)
ENDM

SuperPalettes:
	; PAL_ROUTE
	SGB_WHITE 
	RGB 21, 28, 11
	RGB 20, 26, 31
	RGB  3,  2,  2
	
	; PAL_PALLET
	SGB_WHITE 
	RGB 25, 28, 27
	RGB 20, 26, 31
	RGB  3,  2,  2
	
	; PAL_VIRIDIAN
	SGB_WHITE 
	RGB 17, 26,  3
	RGB 20, 26, 31
	RGB  3,  2,  2
	
	; PAL_PEWTER
	SGB_WHITE 
	RGB 23, 25, 16
	RGB 20, 26, 31
	RGB  3,  2,  2
	
	; PAL_CERULEAN
	SGB_WHITE 
	RGB 17, 20, 30
	RGB 20, 26, 31
	RGB  3,  2,  2
	
	; PAL_LAVENDER
	SGB_WHITE 
	RGB 27, 20, 27
	RGB 20, 26, 31
	RGB  3,  2,  2
	
	; PAL_VERMILION
	SGB_WHITE 
	RGB 30, 18,  0
	RGB 20, 26, 31
	RGB  3,  2,  2
	
	; PAL_CELADON
	SGB_WHITE 
	RGB 16, 30, 22
	RGB 20, 26, 31
	RGB  3,  2,  2
	
	; PAL_SAFFRON
	SGB_WHITE 
	RGB 27, 27,  3
	RGB 20, 26, 31
	RGB  3,  2,  2
	
	; PAL_FUCHSIA
	SGB_WHITE 
	RGB 31, 15, 22
	RGB 20, 26, 31
	RGB  3,  2,  2
	
	; PAL_CINNABAR
	SGB_WHITE 
	RGB 26, 10,  6
	RGB 20, 26, 31
	RGB  3,  2,  2
	
	; PAL_INDIGO
	SGB_WHITE 
	RGB 22, 14, 24
	RGB 20, 26, 31
	RGB  3,  2,  2
	
	; PAL_TOWNMAP
	SGB_WHITE 
	RGB 20, 26, 31
	RGB 17, 23, 10
	RGB  3,  2,  2
	
	; PAL_LOGO1
	SGB_WHITE	;white bg
	RGB 30, 30, 17	;yellow logo text
	RGB 21,  0,  4	;unused on title screen
	RGB 14, 19, 29	;version subtitle text color

	; PAL_LOGO2
	SGB_WHITE 	;white bg
	RGB 30, 30, 17	;unused on title screen
	RGB 18, 18, 24	;blue logo text shadow
	RGB  7,  7, 16	;blue logo text outline

	; PAL_0F
	SGB_WHITE 
	RGB 24, 20, 30
	RGB 11, 20, 30
	RGB  3,  2,  2
	
	; PAL_MEWMON
	SGB_WHITE 
	RGB 30, 22, 17
	RGB 16, 14, 19
	RGB  3,  2,  2
	
	; PAL_BLUEMON
	SGB_WHITE 
	RGB 18, 20, 27
	RGB 11, 15, 23
	RGB  3,  2,  2
	
	; PAL_ORANGEMON
	SGB_WHITE 
	RGB 31, 20, 10
	RGB 26, 10,  6
	RGB  3,  2,  2
	
	; PAL_CYANMON
	SGB_WHITE 
	RGB 21, 25, 29
	RGB 14, 19, 25
	RGB  3,  2,  2
	
	; PAL_PURPLEMON
	SGB_WHITE 
	RGB 27, 22, 24
	RGB 21, 15, 23
	RGB  3,  2,  2
	
	; PAL_BROWNMON
	SGB_WHITE 
	RGB 28, 20, 15
	RGB 21, 14,  9
	RGB  3,  2,  2
	
	; PAL_GREENMON
	SGB_WHITE 
	RGB 20, 26, 16
	RGB  9, 20, 11
	RGB  3,  2,  2
	
	; PAL_PINKMON
	SGB_WHITE 
	RGB 30, 22, 24
	RGB 28, 15, 21
	RGB  3,  2,  2
	
	; PAL_YELLOWMON
	SGB_WHITE 
	RGB 31, 28, 14
	RGB 26, 20,  0
	RGB  3,  2,  2
	
	; PAL_GREYMON
	SGB_WHITE 
	RGB 26, 21, 22
	RGB 15, 15, 18
	RGB  3,  2,  2
	
	; PAL_SLOTS1
	SGB_WHITE 
	RGB 26, 21, 22
	RGB 27, 20,  6
	RGB  3,  2,  2
	
	; PAL_SLOTS2	
	SGB_WHITE 
	RGB 31, 31, 17
	RGB 16, 19, 29
	RGB  3,  2,  2

	; PAL_SLOTS3
	SGB_WHITE 
	RGB 22, 31, 16
	RGB 16, 19, 29
	RGB  3,  2,  2
	
	; PAL_SLOTS4
	SGB_WHITE 
	RGB 25, 17, 21
	RGB 16, 19, 29
	RGB  3,  2,  2
	
	; PAL_BLACK
	SGB_WHITE 
	RGB  7,  7,  7
	RGB  2,  3,  3
	RGB  3,  2,  2
	
	; PAL_GREENBAR
	SGB_WHITE 
	RGB 30, 26, 15
	RGB  9, 20, 11
	RGB  3,  2,  2
	
	; PAL_YELLOWBAR
	SGB_WHITE 
	RGB 30, 26, 15
	RGB 26, 20,  0
	RGB  3,  2,  2
	
	; PAL_REDBAR
	SGB_WHITE 
	RGB 30, 26, 15
	RGB 26, 10,  6
	RGB  3,  2,  2
	
	; PAL_BADGE
	SGB_WHITE 
	RGB 30, 22, 17
	RGB 11, 15, 23
	RGB  3,  2,  2
	
	; PAL_CAVE
	SGB_WHITE 
	RGB 21, 14,  9
	RGB 18, 24, 22
	RGB  3,  2,  2
	
	; PAL_GAMEFREAK
	SGB_WHITE 
	RGB 31, 28, 14
	RGB 24, 20, 10
	RGB  3,  2,  2
	
;gbcnote - added from yellow
	; PAL_25
	SGB_WHITE
	RGB 31, 30, 22
	RGB 23, 27, 31
	RGB  6,  6,  6

	; PAL_26
	SGB_WHITE
	RGB 28, 23,  9
	RGB 18, 14, 10
	RGB  6,  6,  6

	; PAL_27
	SGB_WHITE
	RGB 16, 16, 16
	RGB 31, 25,  9
	RGB  6,  6,  6

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
	RGB 10, 10, 10
	RGB  3,  3,  3

	; PAL_REDBLUEMON
	SGB_WHITE 
	RGB 31,  8,  0
	RGB  5,  5, 23
	RGB  3,  3,  3

	; PAL_VOLCANO
	SGB_WHITE
	RGB 29,  4,  0
	RGB 10, 11, 11
	RGB  3,  3,  3

	; PAL_LIGHTDARK
	SGB_WHITE
	RGB 7, 7, 7
	RGB 7, 7, 7
	RGB 7, 7, 7
