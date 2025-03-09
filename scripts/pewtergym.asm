PewterGymScript:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	call nz, PewterGymScript_Header
	call EnableAutoTextBoxDrawing
	ld hl, PewterGymTrainerHeader0
	ld de, PewterGymScriptPointers
	ld a, [wPewterGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPewterGymCurScript], a
	ret

PewterGymScript_Header:
	ld hl, Gym1CityName
	ld de, Gym1LeaderName
	jp LoadGymLeaderAndCityName

Gym1CityName:
	db "Argenta@"

Gym1LeaderName:
	db "Pierre@"

PewterGymScriptReset:
	xor a
	ld [wJoyIgnore], a
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
	ret

PewterGymScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw PewterGymScriptBattle

PewterGymScriptBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PewterGymScriptReset
	ld a, $f0
	ld [wJoyIgnore], a

PewterGymScriptGiveTM:
	ld a, $4
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_BROCK
	lb bc, TM34_BIDE, 1
	call GiveItem
	jr nc, .bagFull
	ld a, $5
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM34
	jr .endScript
.bagFull
	ld a, $6
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.endScript
	ld hl, wObtainedBadges
	set 0, [hl]
	;ld hl, wBeatGymFlags	;joenote - redundant
	;set 0, [hl]

	ld a, HS_GYM_GUY
	ld [wMissableObjectIndex], a
	predef HideObject

	;if the first route 22 rival battle was skipped, clear the events and hide the associated npc
	;joenote - have to have this if the battle was skipped
	ld a, HS_ROUTE_22_RIVAL_1
	ld [wMissableObjectIndex], a
	predef HideObject
	ResetEvents EVENT_1ST_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE

	; deactivate gym trainers
	SetEvent EVENT_BEAT_PEWTER_GYM_TRAINER_0

	jp PewterGymScriptReset

PewterGymTextPointers:
	dw PewterGymText_BrockMain
	dw PewterGymText_Trainer0
	dw PewterGymText_GuideMain
	dw PewterGymText_BrockWait
	dw PewterGymText_BrockReceivedTM
	dw PewterGymText_BagFull

PewterGymTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_PEWTER_GYM_TRAINER_0
	db ($5 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_PEWTER_GYM_TRAINER_0
	dw PewterGymText_Trainer0PreBattle ; TextBeforeBattle
	dw PewterGymText_Trainer0AfterBattle ; TextAfterBattle
	dw PewterGymText_Trainer0EndBattle ; TextEndBattle
	dw PewterGymText_Trainer0EndBattle ; TextEndBattle

	db $ff

PewterGymText_BrockMain:
	TX_ASM
	CheckEvent EVENT_BEAT_BROCK
	jr z, .brockFight
	CheckEventReuseA EVENT_GOT_TM34
	jr nz, .askForRematch
	call z, PewterGymScriptGiveTM
	call DisableWaitingAfterTextDisplay
	jp .endScript
.askForRematch
;;;;;;;joenote - have a rematch with gym leader?
	ld hl, RematchTrainerText
	call PrintText
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .brockFight
;;;;;;;
	ld hl, PewterGymText_BrockAfterBattle
	call PrintText
	jp .endScript
.brockFight
	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .brockFightAfterElite4

	ld hl, PewterGymText_BrockPreBattle
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, PewterGymText_BrockEndBattle1
	ld de, PewterGymText_BrockEndBattle1
	call SaveEndBattleTextPointers
	ld a, $1
	ld [wGymLeaderNo], a
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	xor a
	ld [hJoyHeld], a
;;;;joenote - added for rematch to skip gym leader tm
	CheckEvent EVENT_GOT_TM34
	jp nz, TextScriptEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, $3
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
	jr .endScript
.brockFightAfterElite4
	ld hl, PewterGymText_RematchPreBattle
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, PewterGymText_RematchEndBattle
	ld de, PewterGymText_RematchEndBattle
	call SaveEndBattleTextPointers
	ld a, $1
	ld [wGymLeaderNo], a
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, 2	;get the right roster
	ld [wTrainerNo], a
	xor a
	ld [hJoyHeld], a
	jr .endScript
.endScript
	jp TextScriptEnd

PewterGymText_BrockPreBattle:
	TX_FAR _PewterGymText_BrockPreBattle
	db "@"

PewterGymText_BrockAfterBattle:
	TX_FAR _PewterGymText_BrockAfterBattle
	db "@"

PewterGymText_BrockWait:
	TX_FAR _PewterGymText_BrockWait
	db "@"

PewterGymText_BrockReceivedTM:
	TX_FAR _PewterGymText_BrockReceivedTM
	TX_SFX_ITEM_1
	TX_FAR _PewterGymText_BrockTMExplanation
	db "@"

PewterGymText_BagFull:
	TX_FAR _PewterGymText_BagFull
	db "@"

PewterGymText_BrockEndBattle1:
	TX_FAR _PewterGymText_BrockEndBattle1
	;TX_SFX_LEVEL_UP ; probably supposed to play SFX_GET_ITEM_1 but the wrong music bank is loaded
	TX_SFX_KEY_ITEM	;joenote - play an unused sfx instead (triggered by playing GET_KEY_ITEM in battle)
	TX_FAR _PewterGymText_BrockEndBattle2
	db "@"

PewterGymText_Trainer0:
	TX_ASM
	ld hl, PewterGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PewterGymText_Trainer0PreBattle:
	TX_FAR _PewterGymText_Trainer0PreBattle
	db "@"

PewterGymText_Trainer0EndBattle:
	TX_FAR _PewterGymText_Trainer0EndBattle
	db "@"

PewterGymText_Trainer0AfterBattle:
	TX_FAR _PewterGymText_Trainer0AfterBattle
	db "@"

PewterGymText_RematchPreBattle:
	TX_FAR _PewterGymText_RematchPreBattle
	db "@"

PewterGymText_RematchEndBattle:
	TX_FAR _PewterGymText_RematchEndBattle
	db "@"

PewterGymText_GuideMain:
	TX_ASM
	ld a, [wObtainedBadges];[wBeatGymFlags]
	bit 0, a
	jr nz, .arenaVictory
	ld hl, PewterGymText_GuideAsk
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .noAnswer
	ld hl, PewterGymText_GuideYes
	call PrintText
	jr .tellTip
.noAnswer
	ld hl, PewterGymText_GuideNo
	call PrintText
.tellTip
	ld hl, PewterGymText_GuideTip
	call PrintText
	jr .endScript
.arenaVictory
	ld hl, PewterGymText_GuideEnd
	call PrintText
.endScript
	jp TextScriptEnd

PewterGymText_GuideAsk:
	TX_FAR _PewterGymText_GuideAsk
	db "@"

PewterGymText_GuideYes:
	TX_FAR _PewterGymText_GuideYes
	db "@"

PewterGymText_GuideTip:
	TX_FAR _PewterGymText_GuideTip
	db "@"

PewterGymText_GuideNo:
	TX_FAR _PewterGymText_GuideNo
	db "@"

PewterGymText_GuideEnd:
	TX_FAR _PewterGymText_GuideEnd
	db "@"
