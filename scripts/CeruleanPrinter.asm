CeruleanPrinterScript:
	jp EnableAutoTextBoxDrawing

CeruleanPrinterTextPointers:
	dw CeruleanPrinterText
	dw CeruleanPrinterText_Printer
	dw CeruleanPrinterPoster

CeruleanPrinterText:
	TX_FAR _CeruleanPrinterText
	db "@"

CeruleanPrinterText_Printer:
	TX_ASM
	; open the GB Printer menu, then redraw the map view
	xor a
	ld [wUpdateSpritesEnabled], a
	callba OpenPrinterMenu
	callba ReloadMapAfterPrinter
	ld a, $1
	ld [wUpdateSpritesEnabled], a
	;the menu is the whole interaction: close the dialogue box right
	;away instead of waiting for one more button press (mirrors the
	;NON branch above)
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

CeruleanPrinterPoster:
	TX_FAR _CeruleanPrinterPoster
	db "@"
