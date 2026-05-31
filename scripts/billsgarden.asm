BillsGardenScript:
	call EnableAutoTextBoxDrawing
	ld hl, BillsGardenTrainerHeader
	ld de, BillsGardenScriptPointers
	ld a, [wBillsGardenCurScript]
	call ExecuteCurMapScriptInTable
	ld [wBillsGardenCurScript], a
	ret

BillsGardenScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw BillsGarden_ResetLegendaries

BillsGardenTextPointers:
	dw BillsGarden_HoohText
	dw BillsGardenText_Sacha
	dw BillsGarden_SachaCongrat
	dw BillsGarden_SachaBagFull
	dw BillsGarden_SachaGiveStone
	dw BillsGarden_SachaStoneExplain
	dw BillsGarden_SachaRespawnLegendaries

BillsGardenTrainerHeader:
	dbEventFlagBit EVENT_BEAT_HOOH
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_HOOH
	dw BillsGarden_HoohBattleText ; TextBeforeBattle
	dw BillsGarden_HoohBattleText ; TextAfterBattle
	dw BillsGarden_HoohBattleText ; TextEndBattle
	dw BillsGarden_HoohBattleText ; TextEndBattle

db $ff

BillsGarden_HoohText:
	TX_ASM
	ld hl, BillsGardenTrainerHeader
	;make the shiny attract cheat work on static wild encounters
	push hl
	push bc
	callba ShinyAttractFunction
	pop bc
	pop hl
	call TalkToTrainer
	jp TextScriptEnd

BillsGarden_HoohBattleText:
	TX_FAR _BillsGarden_HoohText
	TX_ASM
	ld a, HOOH
	call PlayCry
	call WaitForSoundToFinish
	ld a, 8
	ld [wGymLeaderNo], a ;joenote - use gym leader music
	jp TextScriptEnd

;joenote - text for red battle
BillsGardenText_Sacha:
	TX_ASM

	CheckEvent EVENT_MIST_STONE_WAIT
	jr nz, BillsGarden_ResetScript

	ld hl, BillsGarden_SachaGreet
	call PrintText
	ld hl, BillsGarden_SachaBattle
	; print the challenge text
	call PrintText
	; prompt a yes/no choice
	call YesNoChoice
	; load the player choice
	ld a, [wCurrentMenuItem]
	; check the player choice
	and a
	; kick out if no chosen
	jr nz, .noThanks
	;otherwise begin loading battle

	; load pre battle text
	ld hl, BillsGarden_SachaPrebattle
	call PrintText
	; set the bits for triggering battle
	ld hl, wStatusFlags3
	set 6, [hl]
	set 7, [hl]
	; load texts for when you win and lose
	ld hl, BillsGarden_SachaAfterBattle
	ld de, BillsGarden_SachaAfterBattle
	; save the win/lose text
	call SaveEndBattleTextPointers
	; set bgm to champion music
	ld a, $9
	ld [wGymLeaderNo], a
	; load the trainer type
	ld a, OPP_SACHA
	ld [wCurOpponent], a
	;get the right roster
	ld a, 1
	ld [wTrainerNo], a

	; if Sacha never beaten
	CheckEvent EVENT_GOT_MIST_STONE
	jr z, BillsGarden_ResetScripts
	; else
	; get the right roster
	ld a, 2
	ld [wTrainerNo], a
	jr BillsGarden_ResetScripts
	
.noThanks
	ld hl, BillsGarden_SachaDecline
	call PrintText
	jp TextScriptEnd

BillsGarden_ResetScripts:
	xor a
	ld [hJoyHeld], a
	ld a, $3
	ld [wBillsGardenCurScript], a
	ld [wCurMapScript], a
	jp TextScriptEnd

;joenote - adding this function to respawn the legendaries if future red is beaten
BillsGarden_ResetLegendaries: 
	xor a
	ld [wJoyIgnore], a
	ld [wBillsGardenCurScript], a
	ld [wCurMapScript], a
	ld a, [wIsInBattle]
	cp $ff
	ret z
	; else fallthrough
BillsGarden_ResetScript:
	ResetEvent EVENT_MIST_STONE_WAIT
	ld a, $3
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID

	;give MIST_STONE item
	lb bc, MIST_STONE, 1
	call GiveItem
	jp nc, .bagFull	;jump if not enough room in bag

	ld a, $5
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID

	ld a, $6
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID

	SetEvent EVENT_GOT_MIST_STONE

	call GBFadeOutToBlack
	ld a, HOOH
	call PlayCry
	ld a, MEWTWO
	call PlayCry
	ld a, ZAPDOS
	call PlayCry
	call WaitForSoundToFinish

; show Hooh
	ld a, HS_HOOH
	call .showstuff
	ResetEvent EVENT_BEAT_HOOH
; reset Marowrath
	ResetEvent EVENT_BEAT_GHOST_MAROWAK
; reset Articuno
	ld a, HS_ARTICUNO
	call .showstuff
	ResetEvent EVENT_BEAT_ARTICUNO
; reset Volcano fights
	ResetEventRange EVENT_BEAT_VOLCANO_1F_TRAINER_0, EVENT_BEAT_VOLCANO_1F_TRAINER_2
	ResetEvents EVENT_BEAT_VOLCANO_B1F_TRAINER_0, EVENT_BEAT_VOLCANO_B1F_TRAINER_1
; reset Moltres
	ld a, HS_MOLTRES
	call .showstuff
	ResetEvent EVENT_BEAT_MOLTRES
; reset Zapdos
	ld a, HS_ZAPDOS
	call .showstuff
	ResetEvent EVENT_BEAT_ZAPDOS
; reset Mewtwo
	ld a, HS_MEWTWO
	call .showstuff
	ResetEvent EVENT_BEAT_MEWTWO
; reset Mew events
	ResetEvents EVENT_ENCOUNTERED_MEW, EVENT_FOUND_MEW
; return now
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack

	ld a, $7
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID

	jp .end
.bagFull
	SetEvent EVENT_MIST_STONE_WAIT
	ld a, $4
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
BillsGarden_SachaGiveStone:
	TX_FAR _BillsGarden_SachaGiveStone
	TX_SFX_KEY_ITEM ; actually plays the second channel of SFX_BALL_POOF due to the wrong music bank being loaded
	db "@"
BillsGarden_SachaBagFull:
	TX_FAR _BillsGarden_SachaBagFull
	db "@"
BillsGarden_SachaStoneExplain:
	TX_FAR _BillsGarden_SachaStoneExplain
	db "@"
BillsGarden_SachaRespawnLegendaries:
	TX_FAR _BillsGarden_SachaRespawnLegendaries
	db "@"
