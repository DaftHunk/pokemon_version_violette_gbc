CeruleanPrinter_h:
	db PRINT_HOUSE ; tileset
	db CERULEAN_PRINTER_HEIGHT, CERULEAN_PRINTER_WIDTH ; dimensions (y, x)
	dw CeruleanPrinterBlocks, CeruleanPrinterTextPointers, CeruleanPrinterScript ; blocks, texts, scripts
	db 0 ; connections
	dw CeruleanPrinterObject ; objects
