PowerPlant1FScript:
	call EnableAutoTextBoxDrawing
	ld hl, Electrode2TrainerHeader
	ld de, .ScriptPointers
	ld a, [wPowerPlant1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPowerPlant1FCurScript], a
	ret

.ScriptPointers
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

PowerPlant1FTextPointers:
	dw Electrode2Text
	dw ZapdosText
	dw PickUpItemText
	dw PickUpItemText

Electrode2TrainerHeader:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_VOLTORB_7, 1
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_VOLTORB_7, 1
	dw Electrode2BattleText ; TextBeforeBattle
	dw Electrode2BattleText ; TextAfterBattle
	dw Electrode2BattleText ; TextEndBattle
	dw Electrode2BattleText ; TextEndBattle

ZapdosTrainerHeader:
	dbEventFlagBit EVENT_BEAT_ZAPDOS, 1
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_ZAPDOS, 1
	dw ZapdosBattleText ; TextBeforeBattle
	dw ZapdosBattleText ; TextAfterBattle
	dw ZapdosBattleText ; TextEndBattle
	dw ZapdosBattleText ; TextEndBattle

	db $ff

Electrode2Text:
	TX_ASM
	ld hl, Electrode2TrainerHeader
	jp InitVoltorbBattle

ZapdosText:
	TX_ASM
	ld hl, ZapdosTrainerHeader
	jp InitVoltorbBattle

Electrode2BattleText:
	TX_FAR _VoltorbBattleText
	db "@"

ZapdosBattleText:
	TX_FAR _ZapdosBattleText
	TX_ASM
	ld a, ZAPDOS
	call PlayCry
	call WaitForSoundToFinish
	ld a, 8
	ld [wGymLeaderNo], a	; use gym leader music
	jp TextScriptEnd
