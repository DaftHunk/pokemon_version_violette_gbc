CeruleanMelanieHouseScript:
	jp EnableAutoTextBoxDrawing

CeruleanMelanieHouseTextPointers:
	dw CeruleanMelanieHouseText_Melanie
	dw CeruleanMelanieHouseText_Bulbasaur
	dw CeruleanMelanieHouseText_Oddish
	dw CeruleanMelanieHouseText_Sandshrew

CeruleanMelanieHouseText_Melanie:
	TX_FAR _CeruleanMelanieHouseText_Melanie
	db "@"

CeruleanMelanieHouseText_Bulbasaur:
	TX_FAR _CeruleanMelanieHouseText_Bulbasaur
	TX_ASM
	ld a, BULBASAUR
	call DisplayPokedex
	jp TextScriptEnd

CeruleanMelanieHouseText_Oddish:
	TX_FAR _CeruleanMelanieHouseText_Oddish
	TX_ASM
	ld a, ODDISH
	call DisplayPokedex
	jp TextScriptEnd

CeruleanMelanieHouseText_Sandshrew:
	TX_FAR _CeruleanMelanieHouseText_Sandhrew
	TX_ASM
	ld a, SANDSHREW
	call DisplayPokedex
	jp TextScriptEnd
