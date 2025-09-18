RockTunnelPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

RockTunnelPokecenterTextPointers:
	dw RockTunnelHealNurseText
	dw RockTunnelPokecenterText2
	dw RockTunnelPokecenterText3
	dw RockTunnelTradeNurseText
	dw MtMoonChanseyText

RockTunnelHealNurseText:
	db $ff

RockTunnelPokecenterText2:
	TX_FAR _RockTunnelPokecenterText2
	db "@"

RockTunnelPokecenterText3:
	TX_FAR _RockTunnelPokecenterText3
	db "@"

RockTunnelTradeNurseText:
	db $f6

RockTunnelChanseyText:
	TX_FAR _ChanseyText
	TX_ASM
	ld a, CHANSEY
	call DisplayPokedex
	jp TextScriptEnd
