PowerPlantScript:
	call EnableAutoTextBoxDrawing
	ld hl, Voltorb0TrainerHeader
	ld de, .ScriptPointers
	ld a, [wPowerPlantCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPowerPlantCurScript], a
	ret

.ScriptPointers
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

PowerPlantTextPointers:
	dw Voltorb0Text
	dw Voltorb1Text
	dw Voltorb2Text
	dw Electrode1Text
	dw Voltorb4Text
	dw Voltorb5Text
	dw Voltorb6Text
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText

Voltorb0TrainerHeader:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_VOLTORB_0
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_VOLTORB_0
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

Voltorb1TrainerHeader:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_VOLTORB_1
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_VOLTORB_1
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

Voltorb2TrainerHeader:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_VOLTORB_2
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_VOLTORB_2
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

Electrode1TrainerHeader:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_VOLTORB_3
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_VOLTORB_3
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

Voltorb4TrainerHeader:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_VOLTORB_4
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_VOLTORB_4
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

Voltorb5TrainerHeader:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_VOLTORB_5
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_VOLTORB_5
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

Voltorb6TrainerHeader:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_VOLTORB_6
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_VOLTORB_6
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

	db $ff

InitVoltorbBattle::
	;make the shiny attract cheat work on static wild encounters
	push hl
	push bc
	callba ShinyAttractFunction
	pop bc
	pop hl

	call TalkToTrainer
	ld a, [wCurMapScript]
	ld [wPowerPlantCurScript], a
	jp TextScriptEnd

Voltorb0Text:
	TX_ASM
	ld hl, Voltorb0TrainerHeader
	jr InitVoltorbBattle

Voltorb1Text:
	TX_ASM
	ld hl, Voltorb1TrainerHeader
	jr InitVoltorbBattle

Voltorb2Text:
	TX_ASM
	ld hl, Voltorb2TrainerHeader
	jr InitVoltorbBattle

Electrode1Text:
	TX_ASM
	ld hl, Electrode1TrainerHeader
	jr InitVoltorbBattle

Voltorb4Text:
	TX_ASM
	ld hl, Voltorb4TrainerHeader
	jr InitVoltorbBattle

Voltorb5Text:
	TX_ASM
	ld hl, Voltorb5TrainerHeader
	jr InitVoltorbBattle

Voltorb6Text:
	TX_ASM
	ld hl, Voltorb6TrainerHeader
	jr InitVoltorbBattle

VoltorbBattleText:
	TX_FAR _VoltorbBattleText
	db "@"
