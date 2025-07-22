ViridianGymScript:
	ld hl, Gym8CityName
	ld de, Gym8LeaderName
	call LoadGymLeaderAndCityName
	call EnableAutoTextBoxDrawing
	ld hl, ViridianGymTrainerHeader0
	ld de, ViridianGymScriptPointers
	ld a, [wViridianGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wViridianGymCurScript], a
	ret

Gym8CityName:
	db "Jadielle@"
Gym8LeaderName:
;	db "GIOVANNI@"	;joenote - let's remove this funny nonsense spoiler
	db "???@"

ViridianGymScript_Reset:
	xor a
	ld [wJoyIgnore], a
	ld [wViridianGymCurScript], a
	ld [wCurMapScript], a
	ret

ViridianGymScriptPointers:
	dw ViridianGymScript_ArrowTiles
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw ViridianGymScriptBattle
	dw ViridianGymScript_Spinning

ViridianGymScript_ArrowTiles:
	ld a, [wYCoord]
	ld b, a
	ld a, [wXCoord]
	ld c, a
	ld hl, ViridianGymArrowTilePlayerMovement
	call DecodeArrowMovementRLE
	cp $ff
	jp z, CheckFightingMapTrainers
	call StartSimulatingJoypadStates
	ld hl, wd736
	set 7, [hl]
	ld a, SFX_ARROW_TILES
	call PlaySound
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, $4
	ld [wCurMapScript], a
	ret

;format:
;db y,x
;dw pointer to movement
ViridianGymArrowTilePlayerMovement:
	db $b,$13
	dw ViridianGymArrowMovement1
	db $1,$13
	dw ViridianGymArrowMovement2
	db $2,$12
	dw ViridianGymArrowMovement3
	db $2,$b
	dw ViridianGymArrowMovement4
	db $a,$10
	dw ViridianGymArrowMovement5
	db $6,$4
	dw ViridianGymArrowMovement6
	db $d,$5
	dw ViridianGymArrowMovement7
	db $e,$4
	dw ViridianGymArrowMovement8
	db $f,$0
	dw ViridianGymArrowMovement9
	db $f,$1
	dw ViridianGymArrowMovement10
	db $10,$d
	dw ViridianGymArrowMovement11
	db $11,$d
	dw ViridianGymArrowMovement12
	db $FF

;format: direction, count
ViridianGymArrowMovement1:
	db D_UP,$09,$FF

ViridianGymArrowMovement2:
	db D_LEFT,$08,$FF

ViridianGymArrowMovement3:
	db D_DOWN,$09,$FF

ViridianGymArrowMovement4:
	db D_RIGHT,$06,$FF

ViridianGymArrowMovement5:
	db D_DOWN,$02,$FF

ViridianGymArrowMovement6:
	db D_DOWN,$07,$FF

ViridianGymArrowMovement7:
	db D_RIGHT,$08,$FF

ViridianGymArrowMovement8:
	db D_RIGHT,$09,$FF

ViridianGymArrowMovement9:	;joenote - swapped the stop-tiles associated with arrow movement 9 and 10,
	;db D_UP,$08,$FF		;so the movement distance needs to be swapped as well
	db D_UP,$06,$FF
	
ViridianGymArrowMovement10:
	;db D_UP,$06,$FF
	db D_UP,$08,$FF

ViridianGymArrowMovement11:
	db D_LEFT,$06,$FF

ViridianGymArrowMovement12:
	db D_LEFT,$0C,$FF

ViridianGymScript_Spinning:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	jr nz, .loadSpin
	xor a
	ld [wJoyIgnore], a
	ld hl, wd736
	res 7, [hl]
	ld a, $0
	ld [wCurMapScript], a
	ret
.loadSpin
	jpba LoadSpinnerArrowTiles

ViridianGymScriptBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ViridianGymScript_Reset
	ld a, $f0
	ld [wJoyIgnore], a
ViridianGymScript_GiveTM:
	ld a, $d
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	lb bc, TM27_FISSURE, 1
	call GiveItem
	jr nc, .bagFull
	ld a, $e
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM27
	jr .endScript
.bagFull
	ld a, $f
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.endScript
	ld hl, wObtainedBadges
	set 7, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_VIRIDIAN_GYM_TRAINER_0, EVENT_BEAT_VIRIDIAN_GYM_TRAINER_7

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; wispnote - Move this routine to be executed upon encounter.
	; ld a, HS_ROUTE_22_RIVAL_2
	; ld [wMissableObjectIndex], a
	; predef ShowObject
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	SetEvents EVENT_2ND_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE

	; force afterbattle dialogue to ensure Giovani is gone
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID

	jp ViridianGymScript_Reset

ViridianGymTextPointers:
	dw ViridianGymText_Giovanni
	dw ViridianGymText_Trainer0
	dw ViridianGymText_Trainer1
	dw ViridianGymText_Trainer2
	dw ViridianGymText_Trainer3
	dw ViridianGymText_Trainer4
	dw ViridianGymText_Trainer5
	dw ViridianGymText_Trainer6
	dw ViridianGymText_Trainer7
	dw ViridianGymText_Guide
	dw PickUpItemText
	dw ViridianGymText_Note
	dw ViridianGymText_Badge
	dw ViridianGymText_ReceivedTM
	dw ViridianGymText_BagFull

ViridianGymTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_GYM_TRAINER_0
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_GYM_TRAINER_0
	dw ViridianGymText_Trainer0PreBattle ; TextBeforeBattle
	dw ViridianGymText_Trainer0AfterBattle ; TextAfterBattle
	dw ViridianGymText_Trainer0EndBattle ; TextEndBattle
	dw ViridianGymText_Trainer0EndBattle ; TextEndBattle

ViridianGymTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_GYM_TRAINER_1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_GYM_TRAINER_1
	dw ViridianGymText_Trainer1PreBattle ; TextBeforeBattle
	dw ViridianGymText_Trainer1AfterBattle ; TextAfterBattle
	dw ViridianGymText_Trainer1EndBattle ; TextEndBattle
	dw ViridianGymText_Trainer1EndBattle ; TextEndBattle

ViridianGymTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_GYM_TRAINER_2
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_GYM_TRAINER_2
	dw ViridianGymText_Trainer2PreBattle ; TextBeforeBattle
	dw ViridianGymText_Trainer2AfterBattle ; TextAfterBattle
	dw ViridianGymText_Trainer2EndBattle ; TextEndBattle
	dw ViridianGymText_Trainer2EndBattle ; TextEndBattle

ViridianGymTrainerHeader3:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_GYM_TRAINER_3
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_GYM_TRAINER_3
	dw ViridianGymText_Trainer3PreBattle ; TextBeforeBattle
	dw ViridianGymText_Trainer3AfterBattle ; TextAfterBattle
	dw ViridianGymText_Trainer3EndBattle ; TextEndBattle
	dw ViridianGymText_Trainer3EndBattle ; TextEndBattle

ViridianGymTrainerHeader4:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_GYM_TRAINER_4
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_GYM_TRAINER_4
	dw ViridianGymText_Trainer4PreBattle ; TextBeforeBattle
	dw ViridianGymText_Trainer4AfterBattle ; TextAfterBattle
	dw ViridianGymText_Trainer4EndBattle ; TextEndBattle
	dw ViridianGymText_Trainer4EndBattle ; TextEndBattle

ViridianGymTrainerHeader5:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_GYM_TRAINER_5
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_GYM_TRAINER_5
	dw ViridianGymText_Trainer5PreBattle ; TextBeforeBattle
	dw ViridianGymText_Trainer5AfterBattle ; TextAfterBattle
	dw ViridianGymText_Trainer5EndBattle ; TextEndBattle
	dw ViridianGymText_Trainer5EndBattle ; TextEndBattle

ViridianGymTrainerHeader6:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_GYM_TRAINER_6, 1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_GYM_TRAINER_6, 1
	dw ViridianGymText_Trainer6PreBattle ; TextBeforeBattle
	dw ViridianGymText_Trainer6AfterBattle ; TextAfterBattle
	dw ViridianGymText_Trainer6EndBattle ; TextEndBattle
	dw ViridianGymText_Trainer6EndBattle ; TextEndBattle

ViridianGymTrainerHeader7:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_GYM_TRAINER_7, 1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_GYM_TRAINER_7, 1
	dw ViridianGymText_Trainer7PreBattle ; TextBeforeBattle
	dw ViridianGymText_Trainer7AfterBattle ; TextAfterBattle
	dw ViridianGymText_Trainer7EndBattle ; TextEndBattle
	dw ViridianGymText_Trainer7EndBattle ; TextEndBattle

	db $ff

ViridianGymText_Giovanni:
	TX_ASM
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	jr z, .leaderFight
	CheckEventReuseA EVENT_GOT_TM27
	jr nz, .afterFight
	call z, ViridianGymScript_GiveTM
	call DisableWaitingAfterTextDisplay
	jr .endScript
.afterFight
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, ViridianGymText_LeaderAfterBattle
	call PrintText
	call GBFadeOutToBlack
	ld a, HS_VIRIDIAN_GYM_GIOVANNI
	ld [wMissableObjectIndex], a
	predef HideObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	jr .endScript
.leaderFight
	ld hl, ViridianGymText_LeaderPreBattle
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, ViridianGymText_LeaderEndBattle
	ld de, ViridianGymText_LeaderEndBattle
	call SaveEndBattleTextPointers
	ld a, $8
	ld [wGymLeaderNo], a
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $3
	ld [wViridianGymCurScript], a
.endScript
	jp TextScriptEnd

ViridianGymText_LeaderPreBattle:
	TX_FAR _ViridianGymText_LeaderPreBattle
	db "@"

ViridianGymText_LeaderEndBattle:
	TX_FAR _ViridianGymText_LeaderEndBattle
	;TX_SFX_LEVEL_UP ; probably supposed to play SFX_GET_ITEM_1 but the wrong music bank is loaded
	TX_SFX_KEY_ITEM	;joenote - play an unused sfx instead (triggered by playing GET_KEY_ITEM in battle)
	db "@"

ViridianGymText_LeaderAfterBattle:
	TX_FAR _ViridianGymText_LeaderAfterBattle
	TX_WAIT
	db "@"

ViridianGymText_Badge:
	TX_FAR _ViridianGymText_Badge
	db "@"

ViridianGymText_ReceivedTM:
	TX_FAR _ViridianGymText_ReceivedTM
	TX_SFX_ITEM_1

ViridianGymText_TMExplanation:
	TX_FAR _ViridianGymText_TMExplanation
	db "@"

ViridianGymText_BagFull:
	TX_FAR _ViridianGymText_BagFull
	db "@"

ViridianGymText_Trainer0:
	TX_ASM
	ld hl, ViridianGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymText_Trainer0PreBattle:
	TX_FAR _ViridianGymText_Trainer0PreBattle
	db "@"

ViridianGymText_Trainer0EndBattle:
	TX_FAR _ViridianGymText_Trainer0EndBattle
	db "@"

ViridianGymText_Trainer0AfterBattle:
	TX_FAR _ViridianGymText_Trainer0AfterBattle
	db "@"

ViridianGymText_Trainer1:
	TX_ASM
	ld hl, ViridianGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymText_Trainer1PreBattle:
	TX_FAR _ViridianGymText_Trainer1PreBattle
	db "@"

ViridianGymText_Trainer1EndBattle:
	TX_FAR _ViridianGymText_Trainer1EndBattle
	db "@"

ViridianGymText_Trainer1AfterBattle:
	TX_FAR _ViridianGymText_Trainer1AfterBattle
	db "@"

ViridianGymText_Trainer2:
	TX_ASM
	ld hl, ViridianGymTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymText_Trainer2PreBattle:
	TX_FAR _ViridianGymText_Trainer2PreBattle
	db "@"

ViridianGymText_Trainer2EndBattle:
	TX_FAR _ViridianGymText_Trainer2EndBattle
	db "@"

ViridianGymText_Trainer2AfterBattle:
	TX_FAR _ViridianGymText_Trainer2AfterBattle
	db "@"

ViridianGymText_Trainer3:
	TX_ASM
	ld hl, ViridianGymTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymText_Trainer3PreBattle:
	TX_FAR _ViridianGymText_Trainer3PreBattle
	db "@"

ViridianGymText_Trainer3EndBattle:
	TX_FAR _ViridianGymText_Trainer3EndBattle
	db "@"

ViridianGymText_Trainer3AfterBattle:
	TX_FAR _ViridianGymText_Trainer3AfterBattle
	db "@"

ViridianGymText_Trainer4:
	TX_ASM
	ld hl, ViridianGymTrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymText_Trainer4PreBattle:
	TX_FAR _ViridianGymText_Trainer4PreBattle
	db "@"

ViridianGymText_Trainer4EndBattle:
	TX_FAR _ViridianGymText_Trainer4EndBattle
	db "@"

ViridianGymText_Trainer4AfterBattle:
	TX_FAR _ViridianGymText_Trainer4AfterBattle
	db "@"

ViridianGymText_Trainer5:
	TX_ASM
	ld hl, ViridianGymTrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymText_Trainer5PreBattle:
	TX_FAR _ViridianGymText_Trainer5PreBattle
	db "@"

ViridianGymText_Trainer5EndBattle:
	TX_FAR _ViridianGymText_Trainer5EndBattle
	db "@"

ViridianGymText_Trainer5AfterBattle:
	TX_FAR _ViridianGymText_Trainer5AfterBattle
	db "@"

ViridianGymText_Trainer6:
	TX_ASM
	ld hl, ViridianGymTrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymText_Trainer6PreBattle:
	TX_FAR _ViridianGymText_Trainer6PreBattle
	db "@"

ViridianGymText_Trainer6EndBattle:
	TX_FAR _ViridianGymText_Trainer6EndBattle
	db "@"

ViridianGymText_Trainer6AfterBattle:
	TX_FAR _ViridianGymText_Trainer6AfterBattle
	db "@"

ViridianGymText_Trainer7:
	TX_ASM
	ld hl, ViridianGymTrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymText_Trainer7PreBattle:
	TX_FAR _ViridianGymText_Trainer7PreBattle
	db "@"

ViridianGymText_Trainer7EndBattle:
	TX_FAR _ViridianGymText_Trainer7EndBattle
	db "@"

ViridianGymText_Trainer7AfterBattle:
	TX_FAR _ViridianGymText_Trainer7AfterBattle
	db "@"

ViridianGymText_Guide:
	TX_ASM
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	jr nz, .arenaVictory
	ld hl, ViridianGymText_GuideTip
	call PrintText
	jr .endScript
.arenaVictory
	ld hl, ViridianGymText_GuideVictory
	call PrintText
.endScript
	jp TextScriptEnd

ViridianGymText_GuideTip:
	TX_FAR _ViridianGymText_GuideTip
	db "@"

ViridianGymText_GuideVictory:
	TX_FAR _ViridianGymText_GuideVictory
	db "@"

ViridianGymText_Note:
	TX_FAR _ViridianGymText_Note
	db "@"
