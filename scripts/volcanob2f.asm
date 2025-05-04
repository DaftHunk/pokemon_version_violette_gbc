VolcanoB2FScript:
	call EnableAutoTextBoxDrawing
	ld hl, VolcanoB2FMoltresTrainerHeader
	ld de, VolcanoB2FScriptPointers
	ld a, [wVolcanoB2FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wVolcanoB2FCurScript], a
	ret

VolcanoB2FScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

VolcanoB2FMoltresTrainerHeader:
	dbEventFlagBit EVENT_BEAT_MOLTRES
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_MOLTRES
	dw MoltresBattleText ; TextBeforeBattle
	dw MoltresBattleText ; TextAfterBattle
	dw MoltresBattleText ; TextEndBattle
	dw MoltresBattleText ; TextEndBattle

db $ff

VolcanoB2FTextPointers:
    dw MoltresText

MoltresText:
	TX_ASM
	ld hl, VolcanoB2FMoltresTrainerHeader
	;make the shiny attract cheat work on static wild encounters
	push hl
	push bc
	callba ShinyAttractFunction
	pop bc
	pop hl
	call TalkToTrainer
	jp TextScriptEnd

MoltresBattleText:
	TX_FAR _MoltresBattleText
	TX_ASM
	ld a, MOLTRES
	call PlayCry
	call WaitForSoundToFinish
	ld a, 8
	ld [wGymLeaderNo], a	;joenote - use gym leader music
	jp TextScriptEnd