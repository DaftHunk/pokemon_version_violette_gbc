MtMoon1FScript:
	call EnableAutoTextBoxDrawing
	ld hl, MtMoon1FTrainerHeader0
	ld de, MtMoon1FScriptPointers
	ld a, [wMtMoon1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wMtMoon1FCurScript], a
	ret

MtMoon1FScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

MtMoon1FTextPointers:
	dw MtMoon1FText1
	dw MtMoon1FText2
	dw MtMoon1FText3
	dw MtMoon1FText4
	dw MtMoon1FText5
	dw MtMoon1FText6
	dw MtMoon1FText7
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw MtMoon1FText14

MtMoon1FTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_MT_MOON_1F_TRAINER_0
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_MT_MOON_1F_TRAINER_0
	dw MtMoon1FBattleText2 ; TextBeforeBattle
	dw MtMoon1FAfterBattleText2 ; TextAfterBattle
	dw MtMoon1FEndBattleText2 ; TextEndBattle
	dw MtMoon1FEndBattleText2 ; TextEndBattle

MtMoon1FTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_MT_MOON_1F_TRAINER_1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_MT_MOON_1F_TRAINER_1
	dw MtMoon1FBattleText3 ; TextBeforeBattle
	dw MtMoon1FAfterBattleText3 ; TextAfterBattle
	dw MtMoon1FEndBattleText3 ; TextEndBattle
	dw MtMoon1FEndBattleText3 ; TextEndBattle

MtMoon1FTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_MT_MOON_1F_TRAINER_2
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_MT_MOON_1F_TRAINER_2
	dw MtMoon1FBattleText4 ; TextBeforeBattle
	dw MtMoon1FAfterBattleText4 ; TextAfterBattle
	dw MtMoon1FEndBattleText4 ; TextEndBattle
	dw MtMoon1FEndBattleText4 ; TextEndBattle

MtMoon1FTrainerHeader3:
	dbEventFlagBit EVENT_BEAT_MT_MOON_1F_TRAINER_3
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_MT_MOON_1F_TRAINER_3
	dw MtMoon1FBattleText5 ; TextBeforeBattle
	dw MtMoon1FAfterBattleText5 ; TextAfterBattle
	dw MtMoon1FEndBattleText5 ; TextEndBattle
	dw MtMoon1FEndBattleText5 ; TextEndBattle

MtMoon1FTrainerHeader4:
	dbEventFlagBit EVENT_BEAT_MT_MOON_1F_TRAINER_4
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_MT_MOON_1F_TRAINER_4
	dw MtMoon1FBattleText6 ; TextBeforeBattle
	dw MtMoon1FAfterBattleText6 ; TextAfterBattle
	dw MtMoon1FEndBattleText6 ; TextEndBattle
	dw MtMoon1FEndBattleText6 ; TextEndBattle

MtMoon1FTrainerHeader5:
	dbEventFlagBit EVENT_BEAT_MT_MOON_1F_TRAINER_5
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_MT_MOON_1F_TRAINER_5
	dw MtMoon1FBattleText7 ; TextBeforeBattle
	dw MtMoon1FAfterBattleText7 ; TextAfterBattle
	dw MtMoon1FEndBattleText7 ; TextEndBattle
	dw MtMoon1FEndBattleText7 ; TextEndBattle

MtMoon1FTrainerHeader6:
	dbEventFlagBit EVENT_BEAT_MT_MOON_1F_TRAINER_6
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_MT_MOON_1F_TRAINER_6
	dw MtMoon1FBattleText8 ; TextBeforeBattle
	dw MtMoon1FAfterBattleText8 ; TextAfterBattle
	dw MtMoon1FEndBattleText8 ; TextEndBattle
	dw MtMoon1FEndBattleText8 ; TextEndBattle

	db $ff

MtMoon1FText1:
	TX_ASM
	ld hl, MtMoon1FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

MtMoon1FText2:
	TX_ASM
	ld hl, MtMoon1FTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

MtMoon1FText3:
	TX_ASM
	ld hl, MtMoon1FTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

MtMoon1FText4:
	TX_ASM
	ld hl, MtMoon1FTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

MtMoon1FText5:
	TX_ASM
	ld hl, MtMoon1FTrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

MtMoon1FText6:
	TX_ASM
	ld hl, MtMoon1FTrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

MtMoon1FText7:
	TX_ASM
	ld hl, MtMoon1FTrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

MtMoon1FBattleText2:
	TX_FAR _MtMoon1FBattleText2
	db "@"

MtMoon1FEndBattleText2:
	TX_FAR _MtMoon1FEndBattleText2
	db "@"

MtMoon1FAfterBattleText2:
	TX_FAR _MtMoon1FAfterBattleText2
	db "@"

MtMoon1FBattleText3:
	TX_FAR _MtMoon1FBattleText3
	db "@"

MtMoon1FEndBattleText3:
	TX_FAR _MtMoon1FEndBattleText3
	db "@"

MtMoon1FAfterBattleText3:
	TX_FAR _MtMoon1FAfterBattleText3
	db "@"

MtMoon1FBattleText4:
	TX_FAR _MtMoon1FBattleText4
	db "@"

MtMoon1FEndBattleText4:
	TX_FAR _MtMoon1FEndBattleText4
	db "@"

MtMoon1FAfterBattleText4:
	TX_FAR _MtMoon1FAfterBattleText4
	db "@"

MtMoon1FBattleText5:
	TX_FAR _MtMoon1FBattleText5
	db "@"

MtMoon1FEndBattleText5:
	TX_FAR _MtMoon1FEndBattleText5
	db "@"

MtMoon1FAfterBattleText5:
	TX_FAR _MtMoon1FAfterBattleText5
	db "@"

MtMoon1FBattleText6:
	TX_FAR _MtMoon1FBattleText6
	db "@"

MtMoon1FEndBattleText6:
	TX_FAR _MtMoon1FEndBattleText6
	db "@"

MtMoon1FAfterBattleText6:
	TX_FAR _MtMoon1FAfterBattleText6
	db "@"

MtMoon1FBattleText7:
	TX_FAR _MtMoon1FBattleText7
	db "@"

MtMoon1FEndBattleText7:
	TX_FAR _MtMoon1FEndBattleText7
	db "@"

MtMoon1FAfterBattleText7:
	TX_FAR _MtMoon1FAfterBattleText7
	db "@"

MtMoon1FBattleText8:
	TX_FAR _MtMoon1FBattleText8
	db "@"

MtMoon1FEndBattleText8:
	TX_FAR _MtMoon1FEndBattleText8
	db "@"

MtMoon1FAfterBattleText8:
	TX_FAR _MtMoon1FAfterBattleText8
	db "@"

MtMoon1FText14:
	TX_FAR _MtMoon1FText14
	db "@"
