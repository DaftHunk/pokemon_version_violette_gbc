SaffronPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

SaffronPokecenterTextPointers:
	dw SaffronHealNurseText
	dw SaffronPokecenterText2
	dw SaffronPokecenterText3
	dw SaffronTradeNurseText
	dw SaffronChanseyText

SaffronHealNurseText:
	TX_POKECENTER_NURSE

SaffronPokecenterText2:
	TX_FAR _SaffronPokecenterText2
	db "@"

SaffronPokecenterText3:
	TX_FAR _SaffronPokecenterText3
	db "@"

SaffronTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST

SaffronChanseyText:
	TX_FAR _ChanseyText
	TX_ASM
	ld a, CHANSEY
	call DisplayPokedex
	jp TextScriptEnd
