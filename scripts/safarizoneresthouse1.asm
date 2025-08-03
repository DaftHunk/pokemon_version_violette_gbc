SafariZoneRestHouse1Script:
	jp EnableAutoTextBoxDrawing

SafariZoneRestHouse1TextPointers:
	dw SafariZoneRestHouse1Julia
	dw SafariZoneRestHouse1Text2
	dw SafariZoneRestHouse1NicoText

SafariZoneRestHouse1Julia:
	TX_ASM
	CheckEvent EVENT_JULIA_AND_NICO_REUNITED
	jr nz, .reunion
	; else
	SetEvent EVENT_JULIA_MEET
	ld hl, SafariZoneRestHouse1JuliaSearchText
	jr .endScript
.reunion
	ld hl, SafariZoneRestHouse1JuliaFoundText
	call PrintText

	ld a, DRATINI
	call DisplayPokedex

	ld hl, SafariZoneRestHouse1JuliaFound2Text
	; fallthrough
.endScript
	call PrintText
	jp TextScriptEnd

SafariZoneRestHouse1JuliaSearchText:
	TX_FAR _SafariZoneRestHouse1JuliaSearchText
	db "@"

SafariZoneRestHouse1Text2:
	TX_FAR _SafariZoneRestHouse1Text2
	db "@"

SafariZoneRestHouse1JuliaFoundText:
	TX_FAR _SafariZoneRestHouse1JuliaFoundText
	db "@"

SafariZoneRestHouse1JuliaFound2Text:
	TX_FAR _SafariZoneRestHouse1JuliaFound2Text
	db "@"
	
SafariZoneRestHouse1NicoText:
	TX_FAR _SafariZoneRestHouse1NicoText
	db "@"
