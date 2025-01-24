CeladonMansion3Script:
	jp EnableAutoTextBoxDrawing

CeladonMansion3TextPointers:
	dw ProgrammerText
	dw GraphicArtistText
	dw WriterText
	dw DirectorText
	dw GameFreakPCText1
	dw GameFreakPCText2
	dw GameFreakPCText3
	dw GameFreakSignText
	dw SurfboardText
	dw SurfboardNoRoomText

ProgrammerText:
	TX_FAR _ProgrammerText
	db "@"

GraphicArtistText:
	TX_FAR _GraphicArtistText
	db "@"

WriterText:
	TX_FAR _WriterText
	db "@"

DirectorText:
	TX_ASM

	; check pokédex
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp 150
	jr nc, .CompletedDex
	ld hl, .GameDesigner
	jr .done
.CompletedDex
	ld hl, .CompletedDexText
.done
	call PrintText
	jp TextScriptEnd

.GameDesigner
	TX_FAR _GameDesignerText
	db "@"	

.CompletedDexText
	TX_FAR _CompletedDexText
	TX_BLINK	
	TX_ASM
	callab DisplayDiploma
	
	SetEvent EVENT_90B	;joenote - set event that diploma has been attained

	;dafthunk : Added award #53
	lb bc, SURFBOARD, 1
	call GiveItem
	jr nc, .BagFull
	ld a, $9
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID

	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

.BagFull
	ld a, $a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

SurfboardText:
	TX_FAR _ReceivedSurfboard
	TX_SFX_ITEM_1
	TX_FAR _SurfboardText
	db "@"

SurfboardNoRoomText:
	TX_FAR _SurfboardNoRoomText
	db "@"

GameFreakPCText1:
	TX_FAR _CeladonMansion3Text5
	db "@"

GameFreakPCText2:
	TX_FAR _CeladonMansion3Text6
	db "@"

GameFreakPCText3:
	TX_FAR _CeladonMansion3Text7
	db "@"

GameFreakSignText:
	TX_FAR _CeladonMansion3Text8
	db "@"
