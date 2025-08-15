; PureRGBnote: CHANGED: most of the bills pc functions were adjusted to kick you out of the menu less
; after doing something like depositing/withdrawing or viewing data of a pokemon.
; PureRGBnote: ADDED: Pressing SELECT while the cursor is on WITHDRAW lets you view the box pokemon regardless of if your party is full.
DisplayPCMainMenu::
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call SaveScreenTilesToBuffer2
	ld a, [wNumHoFTeams]
	and a
	jr nz, .leaguePCAvailable
	CheckEvent EVENT_GOT_POKEDEX
	jr z, .noOaksPC
	ld a, [wNumHoFTeams]
	and a
	jr nz, .leaguePCAvailable
	coord hl, 0, 0
	ld b, 8
	ld c, 14
	jr .next
.noOaksPC
	coord hl, 0, 0
	ld b, 6
	ld c, 14
	jr .next
.leaguePCAvailable
	; League is available before dex in NG+
	CheckEvent EVENT_GOT_POKEDEX
	jr z, .noOaksPC

	coord hl, 0, 0
	ld b, 10
	ld c, 14
.next
	call TextBoxBorder
	call UpdateSprites
	ld a, 3
	ld [wMaxMenuItem], a
	CheckEvent EVENT_MET_BILL
	jr nz, .metBill
	coord hl, 2, 2
	ld de, SomeonesPCText
	jr .next2
.metBill
	coord hl, 2, 2
	ld de, BillsPCText
.next2
	call PlaceString
	coord hl, 2, 4
	ld de, PlayersPCText
	call PlaceString
	ld l, c
	ld h, b
	ld de, wPlayerName
	call PlaceString
	CheckEvent EVENT_GOT_POKEDEX
	jr z, .noOaksPC2
	coord hl, 2, 6
	ld de, OaksPCText
	call PlaceString
	ld a, [wNumHoFTeams]
	and a
	jr z, .noLeaguePC
	ld a, 4
	ld [wMaxMenuItem], a
	coord hl, 2, 8
	ld de, PKMNLeaguePCText
	call PlaceString
	coord hl, 2, 10
	ld de, LogOffPCText
	jr .next3
.noLeaguePC
	coord hl, 2, 8
	ld de, LogOffPCText
	jr .next3
.noOaksPC2
	ld a, $2
	ld [wMaxMenuItem], a
	coord hl, 2, 6
	ld de, LogOffPCText
.next3
	call PlaceString
	ld a, A_BUTTON | B_BUTTON
	ld [wMenuWatchedKeys], a
	ld a, 2
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, 1
	ld [H_AUTOBGTRANSFERENABLED], a
	ret

SomeonesPCText:   db "PC de ???@"
BillsPCText:      db "PC de Léo@"
PlayersPCText:    db "PC de @"
OaksPCText:       db "PC de Chen@"
PKMNLeaguePCText: db "Ligue <pkmn>@"
LogOffPCText:     db "Déconnexion@"

BillsPC_::
	ld hl, wd730
	set 6, [hl]
	xor a
	ld [wParentMenuItem], a
	inc a               ; MONSTER_NAME
	ld [wNameListType], a
	call LoadHpBarAndStatusTilePatterns
	ld a, [wListScrollOffset]
	push af
	ld a, [wFlags_0xcd60]
	bit 3, a ; accessing Bill's PC through another PC?
	jr nz, BillsPCMenu
; accessing it directly
	ld a, SFX_TURN_ON_PC
	call PlaySound
	ld hl, SwitchOnText
	call PrintText

BillsPCMenu:
	ld a, [wParentMenuItem]
	ld [wCurrentMenuItem], a
	ResetFlag EVENT_VIEW_PC_PKMN
	callab LoadBillsPCExtraTiles
	call LoadScreenTilesFromBuffer2DisableBGTransfer
	coord hl, 0, 0
	ld b, 10
	ld c, 14
	call TextBoxBorder
	coord hl, 2, 2
	ld de, BillsPCMenuText
	call PlaceString
	ld hl, wTopMenuItemY
	ld a, 2
	ld [hli], a ; wTopMenuItemY
	dec a
	ld [hli], a ; wTopMenuItemX
	inc hl
	inc hl
	ld a, 4
	ld [hli], a ; wMaxMenuItem
	ld a, A_BUTTON | B_BUTTON | SELECT
	ld [hli], a ; wMenuWatchedKeys
	xor a
	ld [hli], a ; wLastMenuItem
	ld [hli], a ; wPartyAndBillsPCSavedMenuItem
	ld hl, wListScrollOffset
	ld [hli], a ; wListScrollOffset
	ld [hl], a ; wMenuWatchMovingOutOfBounds
	ld [wPlayerMonNumber], a
	ld hl, WhatText
	call PrintText
	decoord 13, 13
	callab DrawCurrentBoxPrompt
	ld a, 1
	ld [H_AUTOBGTRANSFERENABLED], a
	call Delay3
.handleMenuInput
	call HandleMenuInput
	bit BIT_SELECT, a
	jr z, .notSelect
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .handleMenuInput
	ld [wParentMenuItem], a
	SetFlag EVENT_VIEW_PC_PKMN
	jp BillsPCWithdraw
.notSelect
	bit BIT_B_BUTTON, a
	jp nz, ExitBillsPC
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	ld [wParentMenuItem], a
	and a
	jp z, BillsPCWithdraw ; withdraw
	cp $1
	jp z, BillsPCDeposit ; deposit
	cp $2
	jp z, BillsPCRelease ; release
	cp $3
	jp z, BillsPCChangeBox ; change box

ExitBillsPC:
	ld a, [wFlags_0xcd60]
	bit 3, a ; accessing Bill's PC through another PC?
	jr nz, .next
; accessing it directly
	call LoadTextBoxTilePatterns
	ld a, SFX_TURN_OFF_PC
	call PlaySound
	call WaitForSoundToFinish
.next
	ld hl, wFlags_0xcd60
	res 5, [hl]
	call LoadScreenTilesFromBuffer2
	pop af
	ld [wListScrollOffset], a
	ld hl, wd730
	res 6, [hl]
	ret

BillsPCDeposit:
	ld a, [wPartyCount]
	dec a
	jr nz, .partyLargeEnough
	ld hl, wd730
	res 6, [hl] ; turn on letter printing delay so we don't get instant text
	ld hl, CantDepositLastMonText
	call PrintText
	jp BillsPCMenu
.partyLargeEnough
	ld a, [wNumInBox]
	cp MONS_PER_BOX
	jr nz, .boxNotFull
	ld hl, wd730
	res 6, [hl] ; turn on letter printing delay so we don't get instant text
	ld hl, BoxFullText
	call PrintText
	jp BillsPCMenu
.boxNotFull
	ld hl, wPartyCount
	call DisplayMonListMenu
	jp c, BillsPCMenu
	call BillsPCBackupListIndex
	call DisplayDepositWithdrawMenu
	jp nc, .doneDepositDialogBox
	call WaitForSoundToFinish
	ld a, [wcf91]
	call PlayCry
	ld a, PARTY_TO_BOX
	ld [wMoveMonType], a
	call MoveMon
	xor a
	ld [wRemoveMonFromBox], a
	call RemovePokemon
	call WaitForSoundToFinish
	ld hl, wBoxNumString
	ld a, [wCurrentBoxNum]
	and $7f
	cp 9
	jr c, .singleDigitBoxNum
	sub 9
	ld [hl], "1"
	inc hl
	add "0"
	jr .next
.singleDigitBoxNum
	add "1"
.next
	ld [hli], a
	ld [hl], "@"
	ld hl, MonWasStoredText
	call PrintText
	;jp BillsPCMenu
.doneDepositDialogBox
	call BillsPCRestoreListIndex
	ld a, [wNumInBox]
	cp MONS_PER_BOX
	jp z, BillsPCMenu ; if no space left to deposit, exit the menu automatically
	ld a, [wPartyCount]
	dec a
	jp z, BillsPCMenu ; if 1 pokemon left in party, exit the menu automatically
	ld hl, wd730
	set 6, [hl] ; turn off letter printing delay so we get instant text
	ld hl, WhatText
	call PrintText
	; in case we displayed the status menu, need to reload these
	call RedrawCurrentBoxPrompt
	jp BillsPCDeposit

BillsPCWithdraw:
	ld a, [wNumInBox]
	and a
	jr nz, .boxNotEmpty
	ld hl, wd730
	res 6, [hl] ; turn on letter printing delay so we don't get instant text
	ld hl, NoMonText
	call PrintText
	jp BillsPCMenu
.boxNotEmpty
	CheckEvent EVENT_VIEW_PC_PKMN
	jr nz, .viewStart
	ld a, [wPartyCount]
	cp PARTY_LENGTH
	jr nz, .partyNotFull
	ld hl, wd730
	res 6, [hl] ; turn on letter printing delay so we don't get instant text
	ld hl, CantTakeMonText
	call PrintText
	jp BillsPCMenu
.viewStart
	ld hl, ViewMode
	call .redrawTextBoxAndCurrentBox
.partyNotFull
	ld hl, wNumInBox
	call DisplayMonListMenu
	jp c, BillsPCMenu
	CheckEvent EVENT_VIEW_PC_PKMN
	jr nz, .viewPkmn
	call BillsPCBackupListIndex
	call DisplayDepositWithdrawMenu
	jr nc, .doneWithdrawDialogBox
	ld a, [wWhichPokemon]
	ld hl, wBoxMonNicks
	call GetPartyMonName
	call WaitForSoundToFinish
	ld a, [wcf91]
	call PlayCry
	xor a ; BOX_TO_PARTY
	ld [wMoveMonType], a
	call MoveMon
	ld a, 1
	ld [wRemoveMonFromBox], a
	call RemovePokemon
	call WaitForSoundToFinish
	ld hl, MonIsTakenOutText
	call PrintText
	;jp BillsPCMenu
.doneWithdrawDialogBox
	call BillsPCRestoreListIndex
	ld a, [wNumInBox]
	and a
	jp z, BillsPCMenu ; if no pokemon left to withdraw, exit the menu automatically
	ld a, [wPartyCount]
	cp PARTY_LENGTH
	jp z, BillsPCMenu ; if party is full (can't withdraw more), exit the menu automatically
	ld hl, WhatText
	call .redrawTextBoxAndCurrentBox
	jp BillsPCWithdraw ; otherwise go back to the menu
.redrawTextBoxAndCurrentBox
	push hl
	ld hl, wd730
	set 6, [hl] ; turn off letter printing delay so we get instant text
	pop hl
	call PrintText
	jp RedrawCurrentBoxPrompt
.viewPkmn
	call DisplayDepositWithdrawMenu.viewStats
	ld hl, ViewMode
	call .redrawTextBoxAndCurrentBox
	jp BillsPCWithdraw

	

BillsPCRelease:
	ld a, [wNumInBox]
	and a
	jr nz, .loop
	ld hl, wd730
	res 6, [hl] ; turn on letter printing delay so we don't get instant text
	ld hl, NoMonText
	call PrintText
	jp BillsPCMenu
.loop
	ld hl, wd730
	set 6, [hl] ; turn off letter printing delay so we get instant text
	ld hl, ReleaseWhichMonText
	call PrintText
	ld hl, wNumInBox
	call DisplayMonListMenu
	jp c, BillsPCMenu
	call BillsPCBackupListIndex
	ld hl, wd730
	res 6, [hl] ; turn on letter printing delay so we don't get instant text
	ld hl, OnceReleasedText
	call PrintText
	xor a
	ld [wCurrentMenuItem], a
	ld a, A_BUTTON | B_BUTTON
	ld [wMenuWatchedKeys], a
.loopYesNo
	ld hl, YesNoSmall
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	callab DisplayMultiChoiceMenu
	ldh a, [hJoy5]
	bit BIT_B_BUTTON, a
	jr nz, .doneReleaseDialogBox
	bit BIT_START, a
	ld a, [wCurrentMenuItem]
	jr nz, .continue
	and a
	jr nz, .doneReleaseDialogBox
	; a button was pressed, tell the player to press START
	ld hl, PressStartToReleaseText
	call PrintText
	ld a, [wMenuWatchedKeys]
	or START
	ld [wMenuWatchedKeys], a
	jr .loopYesNo
.continue
	and a
	jr nz, .loopYesNo
	inc a
	ld [wRemoveMonFromBox], a
	call RemovePokemon
	call WaitForSoundToFinish
	ld a, [wcf91]
	call PlayCry
	ld hl, MonWasReleasedText
	call PrintText
.doneReleaseDialogBox
	call BillsPCRestoreListIndex
	ld a, [wNumInBox]
	and a
	jp z, BillsPCMenu ; if no pokemon left to release, exit the menu automatically
	jp .loop ; otherwise go back to the menu

BillsPCChangeBox:
	callba ChangeBox
	jp BillsPCMenu

DisplayMonListMenu:
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	xor a
	ld [wPrintItemPrices], a
	ld [wListMenuID], a
	inc a                ; MONSTER_NAME
	ld [wNameListType], a
	ld a, [wPartyAndBillsPCSavedMenuItem]
	ld [wCurrentMenuItem], a
	call DisplayListMenuID
	ld a, [wCurrentMenuItem]
	ld [wPartyAndBillsPCSavedMenuItem], a
	ret

BillsPCMenuText:
	db   "Retirer <PKMN>"
	next "Stocker <PKMN>"
	next "Relacher <PKMN>"
	next "Changer boîte"
	next "Salut!"
	db "@"
	
; PureRGBnote: FIXED: pokemon are never considered to have HMs, allows them to be stored in daycare no matter what
;KnowsHMMove::
; returns whether mon with party index [wWhichPokemon] knows an HM move
;	ld hl, wPartyMon1Moves
;	ld bc, wPartyMon2 - wPartyMon1
;	jr .next
; unreachable
	;ld hl, wBoxMon1Moves
	;ld bc, wBoxMon2 - wBoxMon1
;.next
;	ld a, [wWhichPokemon]
;	call AddNTimes
;	ld b, NUM_MOVES
;.loop
;	ld a, [hli]
	;push hl 
	;push bc
	;ld hl, HMMoveArray
	;ld de, 1
	;call IsInArray
	;pop bc
	;pop hl
	;ret c
;	dec b
;	jr nz, .loop
;	and a
;	ret

;HMMoveArray:
;INCLUDE "data/moves/hm_moves.asm"

DisplayDepositWithdrawMenu:
	coord hl, 9, 10
	ld b, 6
	ld c, 9
	call TextBoxBorder
	ld a, [wParentMenuItem]
	and a ; was the Deposit or Withdraw item selected in the parent menu?
	ld de, DepositPCText
	jr nz, .next
	ld de, WithdrawPCText
.next
	coord hl, 11, 12
	call PlaceString
	coord hl, 11, 14
	ld de, StatsCancelPCText
	call PlaceString
	ld hl, wTopMenuItemY
	ld a, 12
	ld [hli], a ; wTopMenuItemY
	ld a, 10
	ld [hli], a ; wTopMenuItemX
	xor a
	ld [hli], a ; wCurrentMenuItem
	inc hl
	ld a, 2
	ld [hli], a ; wMaxMenuItem
	ld a, A_BUTTON | B_BUTTON
	ld [hli], a ; wMenuWatchedKeys
	xor a
	ld [hl], a ; wLastMenuItem
	ld hl, wListScrollOffset
	ld [hli], a ; wListScrollOffset
	ld [hl], a ; wMenuWatchMovingOutOfBounds
	ld [wPlayerMonNumber], a
.loop
	call HandleMenuInput
	bit BIT_B_BUTTON, a
	jr nz, .exit
	ld a, [wCurrentMenuItem]
	and a
	jr z, .choseDepositWithdraw
	dec a
	jr z, .viewStats
.exit
	and a
	ret
.choseDepositWithdraw
	scf
	ret
.viewStats
	call SaveScreenTilesToBuffer1
	ld a, [wParentMenuItem]
	and a
	ld a, PLAYER_PARTY_DATA
	jr nz, .next2
	ld a, BOX_DATA
.next2
	ld [wMonDataLocation], a

	predef StatusScreenOriginal

	call LoadScreenTilesFromBuffer1
	call ReloadTilesetTilePatterns
	call RunDefaultPaletteCommand
	call LoadGBPal
	CheckEvent EVENT_VIEW_PC_PKMN
	jr nz, .exit
	jr .loop

DepositPCText:  db "Stocker@"
WithdrawPCText: db "Retirer@"
StatsCancelPCText:
	db   "Stats"
	next "Retour@"

SwitchOnText:
	TX_FAR _SwitchOnText
	text_end

WhatText:
	TX_FAR _WhatText
	text_end

ViewMode:
	TX_FAR _ViewModeText
	text_end

DepositWhichMonText:
	TX_FAR _DepositWhichMonText
	text_end

MonWasStoredText:
	TX_FAR _MonWasStoredText
	text_end

CantDepositLastMonText:
	TX_FAR _CantDepositLastMonText
	text_end

BoxFullText:
	TX_FAR _BoxFullText
	text_end

MonIsTakenOutText:
	TX_FAR _MonIsTakenOutText
	text_end

NoMonText:
	TX_FAR _NoMonText
	text_end

CantTakeMonText:
	TX_FAR _CantTakeMonText
	text_end

ReleaseWhichMonText:
	TX_FAR _ReleaseWhichMonText
	text_end

OnceReleasedText:
	TX_FAR _OnceReleasedText
	text_end

MonWasReleasedText:
	TX_FAR _MonWasReleasedText
	text_end

PressStartToReleaseText:
	TX_FAR _PressStartToReleaseText
	text_end

CableClubLeftGameboy::
	ld a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	ret z
	ld a, [wSpriteStateData1 + 9] ; player's sprite facing direction
	cp SPRITE_FACING_RIGHT
	ret nz
	ld a, [wCurMap]
	cp TRADE_CENTER
	ld a, LINK_STATE_START_TRADE
	jr z, .next
	inc a ; LINK_STATE_START_BATTLE
.next
	ld [wLinkState], a
	call EnableAutoTextBoxDrawing
	tx_pre_jump JustAMomentText

CableClubRightGameboy::
	ld a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	ret z
	ld a, [wSpriteStateData1 + 9] ; player's sprite facing direction
	cp SPRITE_FACING_LEFT
	ret nz
	ld a, [wCurMap]
	cp TRADE_CENTER
	ld a, LINK_STATE_START_TRADE
	jr z, .next
	inc a ; LINK_STATE_START_BATTLE
.next
	ld [wLinkState], a
	call EnableAutoTextBoxDrawing
	tx_pre_jump JustAMomentText

JustAMomentText::
	TX_FAR _JustAMomentText
	text_end

	ld a, [wSpriteStateData1 + 9] ; player's sprite facing direction
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	tx_pre_jump OpenBillsPCText

OpenBillsPCText::
	TX_BILLS_PC

BillsPCBackupListIndex:
	ld a, [wListScrollOffset]
	ld [wSavedListScrollOffset], a
	ret

BillsPCRestoreListIndex:
	ld a, [wSavedListScrollOffset]
	ld [wListScrollOffset], a
	ld a, [wPartyAndBillsPCSavedMenuItem]
	ld [wCurrentMenuItem], a
	ret

RedrawCurrentBoxPrompt:
	callab LoadBillsPCExtraTiles ; in the case of displaying pokemon status menu, this needs to be reloaded
	decoord 13, 13
	jpab DrawCurrentBoxPrompt ; redraw current box prompt since it probably changed
