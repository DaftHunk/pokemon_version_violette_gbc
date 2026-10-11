Route10SouthScript:
	call EnableAutoTextBoxDrawing
	ld hl, Route10SouthTrainerHeader0
	ld de, Route10SouthScriptPointers
	ld a, [wRoute10SouthCurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute10SouthCurScript], a
	ret

Route10SouthScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route10SouthTextPointers:
	dw Route10SouthText1
	dw Route10SouthText2
	dw Route10SouthText3
	dw Route10SouthText4
	dw Route10SouthSignText1

Route10SouthTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_ROUTE_10_SOUTH_TRAINER_0
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_10_SOUTH_TRAINER_0
	dw Route10SouthBattleText1 ; TextBeforeBattle
	dw Route10SouthAfterBattleText1 ; TextAfterBattle
	dw Route10SouthEndBattleText1 ; TextEndBattle
	dw Route10SouthEndBattleText1 ; TextEndBattle

Route10SouthTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_ROUTE_10_SOUTH_TRAINER_1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_10_SOUTH_TRAINER_1
	dw Route10SouthBattleText2 ; TextBeforeBattle
	dw Route10SouthAfterBattleText2 ; TextAfterBattle
	dw Route10SouthEndBattleText2 ; TextEndBattle
	dw Route10SouthEndBattleText2 ; TextEndBattle

Route10SouthTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_ROUTE_10_SOUTH_TRAINER_2
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_10_SOUTH_TRAINER_2
	dw Route10SouthBattleText3 ; TextBeforeBattle
	dw Route10SouthAfterBattleText3 ; TextAfterBattle
	dw Route10SouthEndBattleText3 ; TextEndBattle
	dw Route10SouthEndBattleText3 ; TextEndBattle

Route10SouthTrainerHeader3:
	dbEventFlagBit EVENT_BEAT_ROUTE_10_SOUTH_TRAINER_3
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_10_SOUTH_TRAINER_3
	dw Route10SouthBattleText4 ; TextBeforeBattle
	dw Route10SouthAfterBattleText4 ; TextAfterBattle
	dw Route10SouthEndBattleText4 ; TextEndBattle
	dw Route10SouthEndBattleText4 ; TextEndBattle

	db $ff

Route10SouthText1:
	TX_ASM
	ld hl, Route10SouthTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route10SouthBattleText1:
	TX_FAR _Route10SouthBattleText1
	db "@"

Route10SouthEndBattleText1:
	TX_FAR _Route10SouthEndBattleText1
	db "@"

Route10SouthAfterBattleText1:
	TX_FAR _Route10SouthAfterBattleText1
	db "@"

Route10SouthText2:
	TX_ASM
	ld hl, Route10SouthTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route10SouthBattleText2:
	TX_FAR _Route10SouthBattleText2
	db "@"

Route10SouthEndBattleText2:
	TX_FAR _Route10SouthEndBattleText2
	db "@"

Route10SouthAfterBattleText2:
	TX_FAR _Route10SouthAfterBattleText2
	db "@"

Route10SouthText3:
	TX_ASM
	ld hl, Route10SouthTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route10SouthBattleText3:
	TX_FAR _Route10SouthBattleText3
	db "@"

Route10SouthEndBattleText3:
	TX_FAR _Route10SouthEndBattleText3
	db "@"

Route10SouthAfterBattleText3:
	TX_FAR _Route10SouthAfterBattleText3
	db "@"

Route10SouthText4:
	TX_ASM
	ld hl, Route10SouthTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route10SouthBattleText4:
	TX_FAR _Route10SouthBattleText4
	db "@"

Route10SouthEndBattleText4:
	TX_FAR _Route10SouthEndBattleText4
	db "@"

Route10SouthAfterBattleText4:
	TX_FAR _Route10SouthAfterBattleText4
	db "@"

Route10SouthSignText1:
	TX_FAR _Route10SouthSignText1
	db "@"
