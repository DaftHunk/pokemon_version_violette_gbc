MoveRelearnerText1:
	TX_ASM
; Display the list of moves to the player.
	ld hl, MoveRelearnerGreetingText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .exit
	xor a
	;charge 1000 money
	ld [hMoney], a	
	ld [hMoney + 2], a	
	ld a, $0A
	ld [hMoney + 1], a  
	call HasEnoughMoney
	jr nc, .enoughMoney
	; not enough money
	ld hl, MoveRelearnerNotEnoughMoneyText
	call PrintText
	jp TextScriptEnd
.enoughMoney
	ld hl, MoveRelearnerSaidYesText
	call PrintText
	; Select pokemon from party.
	call SaveScreenTilesToBuffer2
	xor a
	ld [wListScrollOffset], a
	ld [wPartyMenuTypeOrMessageID], a
	ld [wUpdateSpritesEnabled], a
	ld [wMenuItemToSwap], a
	call DisplayPartyMenu
	push af
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	pop af
	jp c, .exit
	ld a, [wWhichPokemon]
	ld b, a
	push bc
	ld hl, PrepareRelearnableMoveList
	ld b, Bank(PrepareRelearnableMoveList)
	call Bankswitch
	ld a, [wMoveBuffer]
	and a
	jr nz, .chooseMove
	pop bc
	ld hl, MoveRelearnerNoMovesText
	call PrintText
	jp TextScriptEnd
.chooseMove
	ld hl, MoveRelearnerWhichMoveText
	call PrintText
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, MOVESLISTMENU
	ld [wListMenuID], a
	ld de, wMoveBuffer
	ld hl, wListPointer
	ld [hl], e
	inc hl
	ld [hl], d
	xor a
	ld [wPrintItemPrices], a ; don't print prices
	call DisplayListMenuID
	pop bc
	jr c, .exit  ; exit if player chose cancel
	push bc
	; Save the selected move id.
	ld a, [wcf91]
	ld [wMoveNum], a
	ld [wPokedexNum],a
	call GetMoveName
	call CopyStringToCF4B ; copy name to wcf4b
	pop bc
	ld a, b
	ld [wWhichPokemon], a
	ld a, [wLetterPrintingDelayFlags]
	push af
	xor a
	ld [wLetterPrintingDelayFlags], a
	predef LearnMove
	pop af
	ld [wLetterPrintingDelayFlags], a
	ld a, b
	and a
	jr z, .exit
	; Charge 1000 money
	xor a
	ld [wPriceTemp], a
	ld [wPriceTemp + 2], a	
	ld a, $0A
	ld [wPriceTemp + 1], a	
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	ld hl, MoveRelearnerByeText
	call PrintText
	jp TextScriptEnd
.exit
	ld hl, MoveRelearnerByeText
	call PrintText
	jp TextScriptEnd


MoveRelearnerGreetingText:
	TX_FAR _MoveRelearnerGreetingText
	db "@"

MoveRelearnerSaidYesText:
	TX_FAR _MoveRelearnerSaidYesText
	db "@"

MoveRelearnerNotEnoughMoneyText:
	TX_FAR _MoveRelearnerNotEnoughMoneyText
	db "@"

MoveRelearnerWhichMoveText:
	TX_FAR _MoveRelearnerWhichMoveText
	db "@"

MoveRelearnerByeText:
	TX_FAR _MoveRelearnerByeText
	db "@"

MoveRelearnerNoMovesText:
	TX_FAR _MoveRelearnerNoMovesText
	db "@"

