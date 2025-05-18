BillsGardenScript:
	call EnableAutoTextBoxDrawing
	ld a, [wBillsGardenCurScript]
	ld hl, BillsGardenScriptPointers
	jp CallFunctionInTable

BillsGardenScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw BillGarden_ResetLegendaries

BillsGardenTextPointers:
    dw BillGardenText_Sacha
	dw BillsGarden_SachaCongrat
	dw BillsGarden_SachaBagFull
	dw BillsGarden_SachaStoneExplain

;joenote - text for red battle
BillGardenText_Sacha:
	TX_ASM

	CheckEvent EVENT_MIST_STONE_WAIT
	jr nz, BillGarden_ResetScript

	ld hl, BillsGarden_SachaGreet
	call PrintText
	ld hl, BillsGarden_SachaBattle
	call PrintText	;print the challenge text
	call YesNoChoice	;prompt a yes/no choice
	ld a, [wCurrentMenuItem]	;load the player choice
	and a	;check the player choice
	jr nz, .noThanks	;kick out if no chosen
	;otherwise begin loading battle
	ld hl, BillsGarden_SachaPrebattle	;load pre battle text
	call PrintText	;print the pre battle text
	ld hl, wd72d;set the bits for triggering battle
	set 6, [hl]	;
	set 7, [hl]	;
	ld hl, BillsGarden_SachaAfterBattle	;load text for when you win
	ld de, BillsGarden_SachaAfterBattle	;load text for when you lose
	call SaveEndBattleTextPointers	;save the win/lose text
	ld a, $9
	ld [wGymLeaderNo], a ;set bgm to champion music
	ld a, OPP_SACHA	;load the trainer type
	ld [wCurOpponent], a ;set as the current opponent

	ld a, 1 ;get the right roster
	ld [wTrainerNo], a

	CheckEvent EVENT_GOT_MIST_STONE
	jr z, .next ; if Sacha never beaten
	; else
	ld a, 2 ;get the right roster
	ld [wTrainerNo], a
.next
	xor a
	ld [hJoyHeld], a
	ld a, $3
	ld [wBillsGardenCurScript], a
	ld [wCurMapScript], a
	jp TextScriptEnd
.noThanks
	ld hl, BillsGarden_SachaDecline
	call PrintText
	jp TextScriptEnd

BillGarden_ResetLegendaries:	;joenote - adding this function to respawn the legendaries if future red is beaten
	xor a
	ld [wJoyIgnore], a
	ld [wBillsGardenCurScript], a
	ld [wCurMapScript], a
	ld a, [wIsInBattle]
	cp $ff
	ret z
	; else fallthrough
BillGarden_ResetScript:
	ResetEvent EVENT_MIST_STONE_WAIT
	ld a, $2
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID

	;give MIST_STONE item
	lb bc, MIST_STONE, 1
	call GiveItem
	jr nc, .bagFull	;jump if not enough room in bag

	ld a, SFX_GET_ITEM_1
	call PlaySound 
	call WaitForSoundToFinish

	ld a, $4
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID

	SetEvent EVENT_GOT_MIST_STONE
;reset Mew events
	ResetEvent EVENT_ENCOUNTERED_MEW
	ResetEvent EVENT_FOUND_MEW
;reset articuno's seafoam islands puzzles
	ld a, HS_SEAFOAM_ISLANDS_B3F_BOULDER_1
	call .showstuff
	ld a, HS_SEAFOAM_ISLANDS_B3F_BOULDER_2
	call .showstuff
	ld a, HS_SEAFOAM_ISLANDS_B4F_BOULDER_1
	call .hidestuff
	ld a, HS_SEAFOAM_ISLANDS_B4F_BOULDER_2
	call .hidestuff
	ResetEvents EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE
;reset mewtwo
	ld a, HS_MEWTWO
	call .showstuff
	ResetEvent EVENT_BEAT_MEWTWO
;reset moltres
	ld a, HS_MOLTRES
	call .showstuff
	ResetEvent EVENT_BEAT_MOLTRES
;reset zapdos
	ld a, HS_ZAPDOS
	call .showstuff
	ResetEvent EVENT_BEAT_ZAPDOS
;reset articuno and its specific puzzle
	ld a, HS_ARTICUNO
	call .showstuff
	ResetEvent EVENT_BEAT_ARTICUNO
;return now
	jp .end
.bagFull
	SetEvent EVENT_MIST_STONE_WAIT
	ld a, $3
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.end
	xor a
	ld [hJoyHeld], a
	jp TextScriptEnd

.showstuff
	ld [wMissableObjectIndex], a
	predef_jump ShowObject
.hidestuff
	ld [wMissableObjectIndex], a
	predef_jump HideObject

BillsGarden_SachaGreet:
	TX_FAR _BillsGarden_SachaGreet
	db "@"
BillsGarden_SachaBattle:
	TX_FAR _BillsGarden_SachaBattle
	db "@"
BillsGarden_SachaPrebattle:
	TX_FAR _BillsGarden_SachaPrebattle
	db "@"
BillsGarden_SachaAfterBattle:
	TX_FAR _BillsGarden_SachaAfterBattle
	db "@"	
BillsGarden_SachaDecline:
	TX_FAR _BillsGarden_SachaDecline
	db "@"
BillsGarden_SachaCongrat:
	TX_FAR _BillsGarden_SachaCongrat
	db "@"
BillsGarden_SachaBagFull:
	TX_FAR _BillsGarden_SachaBagFull
	db "@"
BillsGarden_SachaStoneExplain:
	TX_FAR _BillsGarden_SachaStoneExplain
	db "@"
