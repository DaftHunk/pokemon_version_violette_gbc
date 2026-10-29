CeruleanPrinterObject:
	db $00 ; border block

	db 2 ; warps
	warp 2, 7, 10, -1
	warp 3, 7, 10, -1

	db 4 ; signs
	sign 7, 1, 2 ; CeruleanPrinterText_Printer
	sign 6, 0, 3 ; CeruleanPrinterSign_Poster
	sign 0, 1, 4 ; CeruleanPrinterSign_Sheves
	sign 1, 1, 4 ; CeruleanPrinterSign_Sheves

	db 1 ; objects
	object SPRITE_NERD, 2, 3, STAY, RIGHT, 1 ; CeruleanPrinterText

	; warp-to
	warp_to 2, 7, CERULEAN_PRINTER_WIDTH
	warp_to 3, 7, CERULEAN_PRINTER_WIDTH
