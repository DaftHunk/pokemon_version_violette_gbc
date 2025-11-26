NameRaterScript:
	jp EnableAutoTextBoxDrawing

NameRaterScript_YesNoChoice:
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ret

NameRaterScript_Rename:
	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	ld de, wPlayerName
	ld c, NAME_LENGTH
	call .nameLoop
	jr c, .endScript
	ld hl, wPartyMon1OTID
	ld bc, wPartyMon2 - wPartyMon1
	ld a, [wWhichPokemon]
	call AddNTimes
	ld de, wPlayerID
	ld c, $2
.nameLoop
	ld a, [de]
	cp [hl]
	jr nz, .endScript
	inc hl
	inc de
	dec c
	jr nz, .nameLoop
	and a
	ret
.endScript
	scf
	ret

NameRaterTextPointers:
	dw NameRaterText1

NameRaterText1:
	TX_ASM
	call SaveScreenTilesToBuffer2
	ld hl, NameRaterText_Hello
	call NameRaterScript_YesNoChoice
	jr nz, .comeLaterScript
	ld hl, NameRaterText_RenameWho
	call PrintText
	xor a
	ld [wPartyMenuTypeOrMessageID], a
	ld [wUpdateSpritesEnabled], a
	ld [wMenuItemToSwap], a
	call DisplayPartyMenu
	push af
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	pop af
	jr c, .comeLaterScript
	call GetPartyMonName2
	call NameRaterScript_Rename
;	ld hl, NameRaterText_Trade
;	jr c, .endScript
	ld hl, NameRaterText_NameRate
	call NameRaterScript_YesNoChoice
	jr nz, .comeLaterScript
	ld hl, NameRaterText_AskRename
	call PrintText
	callba DisplayNameRaterScreen
	jr c, .comeLaterScript
	ld hl, NameRaterText_Renamed
.endScript
	call PrintText
	jp TextScriptEnd
.comeLaterScript
	ld hl, NameRaterText_ComeBackLater
	jr .endScript

NameRaterText_Hello:
	TX_FAR _NameRaterText_Hello
	db "@"

NameRaterText_RenameWho:
	TX_FAR _NameRaterText_RenameWho
	db "@"

NameRaterText_NameRate:
	TX_FAR _NameRaterText_NameRate
	db "@"

NameRaterText_AskRename:
	TX_FAR _NameRaterText_AskRename
	db "@"

NameRaterText_Renamed:
	TX_FAR _NameRaterText_Renamed
	db "@"

NameRaterText_ComeBackLater:
	TX_FAR _NameRaterText_ComeBackLater
	db "@"

NameRaterText_Trade:
	TX_FAR _NameRaterText_Trade
	db "@"
