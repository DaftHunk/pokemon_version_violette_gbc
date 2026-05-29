RockTunnelPokecenterScript:
	call .markAsVisited
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

.markAsVisited
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	ld c, ROUTE_10_FLY
	ld b, FLAG_SET
	ld hl, wTownVisitedFlag   ; mark town as visited (for flying)
	predef_jump FlagActionPredef

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
