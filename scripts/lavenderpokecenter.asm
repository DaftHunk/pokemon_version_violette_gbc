LavenderPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

LavenderPokecenterTextPointers:
	dw LavenderHealNurseText
	dw LavenderPokecenterText2
	dw LavenderPokecenterText3
	dw LavenderTradeNurseText
	dw LavenderChanseyText

LavenderTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST

LavenderHealNurseText:
	TX_POKECENTER_NURSE

LavenderPokecenterText2:
	TX_FAR _LavenderPokecenterText2
	db "@"

LavenderPokecenterText3:
	TX_FAR _LavenderPokecenterText3
	db "@"

LavenderChanseyText:
	TX_FAR _ChanseyText
	TX_ASM
	ld a, CHANSEY
	call DisplayPokedex
	jp TextScriptEnd
