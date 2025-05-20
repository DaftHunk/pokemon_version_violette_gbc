MtMoonB1FScript:
	call EnableAutoTextBoxDrawing
	ld hl, MtMoonB1FTrainerHeader0
	ld de, MtMoonB1FScriptPointers
	ld a, [wMtMoonB1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wMtMoonB1FCurScript], a
	ret

MtMoonB1FScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw MtMoonB1FScriptJessieJames

MtMoonB1FTextPointers:
	dw MtMoonB1FTextJessieJames
	dw MtMoonB1FTextJessieJames

MtMoonB1FTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_MT_MOON_B1F_JESSIE_JAMES
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_MT_MOON_B1F_JESSIE_JAMES
	dw MtMoonB1FBattleTextJessieJames ; TextBeforeBattle
	dw MtMoonB1FAfterBattleTextJessieJames ; TextAfterBattle
	dw MtMoonB1FEndBattleTextJessieJames ; TextEndBattle
	dw MtMoonB1FEndBattleTextJessieJames ; TextEndBattle

	db $ff

MtMoonB1FScriptJessieJames:
	ld hl, wFlags_0xcd60
	res 0, [hl]
	ld a, [wIsInBattle]
	cp $ff
	jp z, MtMoonB1FScriptNotInBattle
	call EndTrainerBattle
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, [wSpriteIndex]
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID

	CheckEvent EVENT_BEAT_MT_MOON_B1F_JESSIE_JAMES
	jr nz, .hideJessieJames	
	; else
	ld a, $0
	ld [wMtMoon1FCurScript], a
	ld [wCurMapScript], a
	ret
.hideJessieJames
	call GBFadeOutToBlack
	ld a, HS_MT_MOON_B1F_JESSIE
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_MT_MOON_B1F_JAMES
	ld [wMissableObjectIndex], a
	predef HideObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	xor a
	ld [wd730], a
	jr MtMoonB1FScriptNotInBattle

MtMoonB1FScriptNotInBattle:
	xor a
	ld [wJoyIgnore], a
	ld [wMtMoon1FCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonB1FTextJessieJames:
	TX_ASM
	ld hl, MtMoonB1FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

MtMoonB1FBattleTextJessieJames:
	TX_FAR _MtMoonB1FBattleTextJessieJames
	db "@"

MtMoonB1FEndBattleTextJessieJames:
	TX_FAR _MtMoonB1FEndBattleTextJessieJames
	db "@"

MtMoonB1FAfterBattleTextJessieJames:
	TX_FAR _MtMoonB1FAfterBattleTextJessieJames
	db "@"
