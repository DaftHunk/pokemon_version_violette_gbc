FuchsiaGymScript:
	call FuchsiaGymScript_Header
	call EnableAutoTextBoxDrawing
	ld hl, FuchsiaGymTrainerHeader0
	ld de, FuchsiaGymScriptPointers
	ld a, [wFuchsiaGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wFuchsiaGymCurScript], a
	ret

FuchsiaGymScript_Header:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	ret z
	ld hl, Gym5CityName
	ld de, Gym5LeaderName
	call LoadGymLeaderAndCityName
	ret

Gym5CityName:
	db "Parmanie@"
Gym5LeaderName:
	db "Koga@"

FuchsiaGymScript_Reset:
	xor a
	ld [wJoyIgnore], a
	ld [wFuchsiaGymCurScript], a
	ld [wCurMapScript], a
	ret

FuchsiaGymScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw FuchsiaGymScript_Battle

FuchsiaGymScript_Battle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, FuchsiaGymScript_Reset
	ld a, $f0
	ld [wJoyIgnore], a
;;;;joenote - added for rematch to skip gym leader tm
	CheckEvent EVENT_GOT_TM06
	jp nz, FuchsiaGymScript_Reset
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FuchsiaGymScript_GiveTM:
	ld a, $9
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_KOGA
	lb bc, TM06_TOXIC, 1
	call GiveItem
	jr nc, .bagFull
	ld a, $a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM06
	jr .endScript
.bagFull
	ld a, $b
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.endScript
	ld hl, wObtainedBadges
	set BIT_SOULBADGE, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_FUCHSIA_GYM_TRAINER_0, EVENT_BEAT_FUCHSIA_GYM_JANINE

	ld a, $c
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.next
	jp FuchsiaGymScript_Reset

FuchsiaGymTextPointers:
	dw FuchsiaGymText_Koga
	dw FuchsiaGymText_Trainer0
	dw FuchsiaGymText_Trainer1
	dw FuchsiaGymText_Trainer2
	dw FuchsiaGymText_Trainer3
	dw FuchsiaGymText_Trainer4
	dw FuchsiaGymJanineText
	dw FuchsiaGymText_Guide
	dw FuchsiaGymText_Badge
	dw FuchsiaGymText_ReceiveTM
	dw FuchsiaGymText_BagFull
	dw FuchsiaGymText_LevelCap

FuchsiaGymTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_FUCHSIA_GYM_TRAINER_0
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FUCHSIA_GYM_TRAINER_0
	dw FuchsiaGymText_Trainer0PreBattle ; TextBeforeBattle
	dw FuchsiaGymText_Trainer0AfterBattle ; TextAfterBattle
	dw FuchsiaGymText_Trainer0EndBattle ; TextEndBattle
	dw FuchsiaGymText_Trainer0EndBattle ; TextEndBattle

FuchsiaGymTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_FUCHSIA_GYM_TRAINER_1
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FUCHSIA_GYM_TRAINER_1
	dw FuchsiaGymText_Trainer1PreBattle ; TextBeforeBattle
	dw FuchsiaGymText_Trainer1AfterBattle ; TextAfterBattle
	dw FuchsiaGymText_Trainer1EndBattle ; TextEndBattle
	dw FuchsiaGymText_Trainer1EndBattle ; TextEndBattle

FuchsiaGymTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_FUCHSIA_GYM_TRAINER_2
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FUCHSIA_GYM_TRAINER_2
	dw FuchsiaGymText_Trainer2PreBattle ; TextBeforeBattle
	dw FuchsiaGymText_Trainer2AfterBattle ; TextAfterBattle
	dw FuchsiaGymText_Trainer2EndBattle ; TextEndBattle
	dw FuchsiaGymText_Trainer2EndBattle ; TextEndBattle

FuchsiaGymTrainerHeader3:
	dbEventFlagBit EVENT_BEAT_FUCHSIA_GYM_TRAINER_3
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FUCHSIA_GYM_TRAINER_3
	dw FuchsiaGymText_Trainer3PreBattle ; TextBeforeBattle
	dw FuchsiaGymText_Trainer3AfterBattle ; TextAfterBattle
	dw FuchsiaGymText_Trainer3EndBattle ; TextEndBattle
	dw FuchsiaGymText_Trainer3EndBattle ; TextEndBattle

FuchsiaGymTrainerHeader4:
	dbEventFlagBit EVENT_BEAT_FUCHSIA_GYM_TRAINER_4
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FUCHSIA_GYM_TRAINER_4
	dw FuchsiaGymText_Trainer4PreBattle ; TextBeforeBattle
	dw FuchsiaGymText_Trainer4AfterBattle ; TextAfterBattle
	dw FuchsiaGymText_Trainer4EndBattle ; TextEndBattle
	dw FuchsiaGymText_Trainer4EndBattle ; TextEndBattle

FuchsiaGymJanineHeader:
	dbEventFlagBit EVENT_BEAT_FUCHSIA_GYM_JANINE
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FUCHSIA_GYM_JANINE
	dw FuchsiaGymText_JaninePreBattle ; TextBeforeBattle
	dw FuchsiaGymText_JanineAfterBattle ; TextAfterBattle
	dw FuchsiaGymText_JanineEndBattle ; TextEndBattle
	dw FuchsiaGymText_JanineEndBattle ; TextEndBattle

	db $ff

FuchsiaGymText_Koga:
	TX_ASM
	CheckEvent EVENT_BEAT_KOGA
	jr z, .leaderFight
	CheckEventReuseA EVENT_GOT_TM06
	jr nz, .askForRematch
	call z, FuchsiaGymScript_GiveTM
	call DisableWaitingAfterTextDisplay
	jp .endScript
.askForRematch
;;;;;;;joenote - have a rematch with gym leader?
	ld hl, RematchTrainerText
	call PrintText
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .leaderFight
;;;;;;;
	CheckEitherEventSet EVENT_NEW_GAME_PLUS, EVENT_BEAT_KOGA_REMATCH
	jp nz, ScizorTutor

	ld hl, FuchsiaGymText_LeaderAfterBattle
	call PrintText
	jp .endScript
.leaderFight
	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .leaderFightAfterElite4

	ld hl, FuchsiaGymText_LeaderPreBattle
	call PrintText
	ld hl, wStatusFlags3
	set 6, [hl]
	set 7, [hl]
	ld hl, FuchsiaGymText_LeaderEndBattle
	ld de, FuchsiaGymText_LeaderEndBattle
	call SaveEndBattleTextPointers
	ld a, $5
	ld [wGymLeaderNo], a
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters

	; Check if both Erika and Sabrina are defeated
	CheckBothEventsSet EVENT_BEAT_ERIKA, EVENT_BEAT_SABRINA
	jr z, .koga3
	; Else only one of them is
	CheckEitherEventSet EVENT_BEAT_ERIKA, EVENT_BEAT_SABRINA
	jr nz, .koga2
	; Else none of them are defeated fallthrough
.koga1
	ld a, 1	;get the right roster
	ld [wTrainerNo], a
	jr .afterBattle
.koga2
	ld a, 2	;get the right roster
	ld [wTrainerNo], a
	jr .afterBattle
.koga3
	ld a, 3	;get the right roster
	ld [wTrainerNo], a
	; fallthrough
.afterBattle
;;;;joenote - added for rematch to skip gym leader tm
	CheckEvent EVENT_GOT_TM06
	jp nz, TextScriptEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	xor a
	ld [hJoyHeld], a
	ld a, $3
	ld [wFuchsiaGymCurScript], a
	jr .endScript
.leaderFightAfterElite4
	ld hl, FuchsiaGymText_RematchPreBattle
	call PrintText

	ld hl, wStatusFlags3
	set 6, [hl]
	set 7, [hl]
	ld hl, FuchsiaGymText_RematchEndBattle
	ld de, FuchsiaGymText_RematchEndBattle
	call SaveEndBattleTextPointers
	ld a, $5
	ld [wGymLeaderNo], a
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, 4	;get the right roster
	ld [wTrainerNo], a
	xor a
	ld [hJoyHeld], a
	jr .endScript
.endScript
	jp TextScriptEnd

FuchsiaGymText_LeaderPreBattle:
	TX_FAR _FuchsiaGymText_LeaderPreBattle
	db "@"

FuchsiaGymText_LeaderEndBattle:
	TX_FAR _FuchsiaGymText_LeaderEndBattle
	TX_SFX_KEY_ITEM	;joenote - play an unused sfx instead (triggered by playing GET_KEY_ITEM in battle)
	db "@"

FuchsiaGymText_LeaderAfterBattle:
	TX_ASM
	callfar DisplayCurrentCap
	
	ld hl, .LeaderAfterBattle
	call PrintText
	jp TextScriptEnd
.LeaderAfterBattle
	TX_FAR _FuchsiaGymText_LeaderAfterBattle
	db "@"

FuchsiaGymText_LevelCap:
	TX_FAR DisplayCurrentCapScript
	db "@"

FuchsiaGymText_Badge:
	TX_FAR _FuchsiaGymText_Badge
	db "@"

FuchsiaGymText_ReceiveTM:
	TX_FAR _FuchsiaGymText_ReceiveTM
	;TX_SFX_KEY_ITEM	;joenote - wrong SFX played
	TX_SFX_ITEM_1

FuchsiaGymText_TMExplanation:
	TX_FAR _FuchsiaGymText_TMExplanation
	db "@"

FuchsiaGymText_BagFull:
	TX_FAR _FuchsiaGymText_BagFull
	db "@"

FuchsiaGymText_RematchPreBattle:
	TX_FAR _FuchsiaGymText_RematchPreBattle
	db "@"

FuchsiaGymText_RematchEndBattle:
	TX_ASM
	SetEvent EVENT_BEAT_KOGA_REMATCH
	ld hl, wBeatGymLeadersRematch
	set 4, [hl]
	
	ld hl, .fuchsiaGymText_RematchEndBattle
	call PrintText
	jp TextScriptEnd
.fuchsiaGymText_RematchEndBattle
	TX_FAR _FuchsiaGymText_RematchEndBattle
	db "@"

FuchsiaGymText_Trainer0:
	TX_ASM
	SetEvent EVENT_GYM_LVL_SCALING
	ld hl, FuchsiaGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymText_Trainer0PreBattle:
	TX_FAR _FuchsiaGymText_Trainer0PreBattle
	db "@"

FuchsiaGymText_Trainer0EndBattle:
	TX_FAR _FuchsiaGymText_Trainer0EndBattle
	TX_ASM
	jp FuchsiaGymText_StopLevelScaling

FuchsiaGymText_Trainer0AfterBattle:
	TX_FAR _FuchsiaGymText_Trainer0AfterBattle
	TX_ASM
	jp FuchsiaGymText_StopLevelScaling

FuchsiaGymText_Trainer1:
	TX_ASM
	SetEvent EVENT_GYM_LVL_SCALING
	ld hl, FuchsiaGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymText_Trainer1PreBattle:
	TX_FAR _FuchsiaGymText_Trainer1PreBattle
	db "@"

FuchsiaGymText_Trainer1EndBattle:
	TX_FAR _FuchsiaGymText_Trainer1EndBattle
	TX_ASM
	jp FuchsiaGymText_StopLevelScaling

FuchsiaGymText_Trainer1AfterBattle:
	TX_FAR _FuchsiaGymText_Trainer1AfterBattle
	TX_ASM
	jp FuchsiaGymText_StopLevelScaling

FuchsiaGymText_Trainer2:
	TX_ASM
	SetEvent EVENT_GYM_LVL_SCALING
	ld hl, FuchsiaGymTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymText_Trainer2PreBattle:
	TX_FAR _FuchsiaGymText_Trainer2PreBattle
	db "@"

FuchsiaGymText_Trainer2EndBattle:
	TX_FAR _FuchsiaGymText_Trainer2EndBattle
	TX_ASM
	jr FuchsiaGymText_StopLevelScaling

FuchsiaGymText_Trainer2AfterBattle:
	TX_FAR _FuchsiaGymText_Trainer2AfterBattle
	TX_ASM
	jr FuchsiaGymText_StopLevelScaling

FuchsiaGymText_Trainer3:
	TX_ASM
	SetEvent EVENT_GYM_LVL_SCALING
	ld hl, FuchsiaGymTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymText_Trainer3PreBattle:
	TX_FAR _FuchsiaGymText_Trainer3PreBattle
	db "@"

FuchsiaGymText_Trainer3EndBattle:
	TX_FAR _FuchsiaGymText_Trainer3EndBattle
	TX_ASM
	jr FuchsiaGymText_StopLevelScaling

FuchsiaGymText_Trainer3AfterBattle:
	TX_FAR _FuchsiaGymText_Trainer3AfterBattle
	TX_ASM
	jr FuchsiaGymText_StopLevelScaling

FuchsiaGymText_Trainer4:
	TX_ASM
	SetEvent EVENT_GYM_LVL_SCALING
	ld hl, FuchsiaGymTrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymText_Trainer4PreBattle:
	TX_FAR _FuchsiaGymText_Trainer4PreBattle
	db "@"

FuchsiaGymText_Trainer4EndBattle:
	TX_FAR _FuchsiaGymText_Trainer4EndBattle
	TX_ASM
	jr FuchsiaGymText_StopLevelScaling

FuchsiaGymText_Trainer4AfterBattle:
	TX_FAR _FuchsiaGymText_Trainer4AfterBattle
	TX_ASM
	jr FuchsiaGymText_StopLevelScaling

FuchsiaGymJanineText:
	TX_ASM
	SetEvent EVENT_GYM_LVL_SCALING
	ld hl, FuchsiaGymJanineHeader
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymText_JaninePreBattle:
	TX_FAR _FuchsiaGymText_JaninePreBattle
	db "@"

FuchsiaGymText_JanineEndBattle:
	TX_FAR _FuchsiaGymText_JanineEndBattle
	TX_ASM
	jr FuchsiaGymText_StopLevelScaling

FuchsiaGymText_JanineAfterBattle:
	TX_FAR _FuchsiaGymText_JanineAfterBattle
	TX_ASM
	jr FuchsiaGymText_StopLevelScaling

FuchsiaGymText_StopLevelScaling:
	ResetEvent EVENT_GYM_LVL_SCALING
	jp TextScriptEnd

FuchsiaGymText_Guide:
	TX_ASM
	CheckEvent EVENT_BEAT_KOGA
	ld hl, FuchsiaGymText_GuideVictory
	jr nz, .endScript
	ld hl, FuchsiaGymText_GuideTip
.endScript
	call PrintText
	jp TextScriptEnd

FuchsiaGymText_GuideTip:
	TX_FAR _FuchsiaGymText_GuideTip
	db "@"

FuchsiaGymText_GuideVictory:
	TX_FAR _FuchsiaGymText_GuideVictory
	db "@"
	
ScizorTutor:
	ld a, [wPartyMon1Species]
	cp SCIZOR
	jr nz, .displayBring

	xor a
	ld [wWhichPokemon], a

	ld hl, .textStart
	call PrintText

	call GBFadeOutToBlack
	ld a, GHOST
	ld [wPartyMon1Type1], a

	ld a, SFX_GET_ITEM_2
	call PlaySound
	call WaitForSoundToFinish
	call GBFadeInFromBlack
	ld hl, .textAfter
	jr .textEnd
.displayBring
	ld hl, .textBring
	; fallthrough
.textEnd
	call PrintText
	jp TextScriptEnd
.textBring
	text "Continue à"
	line "perfectionner tes"
	cont "talents car telle"
	cont "est la voie"
	cont "du ninja."

	para "Si tu le"
	line "souhaites, je"
	cont "peux apprendre"
	cont "cette voie à ton"
	cont "Cizayox."
	done
	db "@"
.textStart
	text "Tu as un"
	line "Cizayox très"
	cont "talentueux."
	cont "Je pourrais lui"
	cont "apprendre la voie"
	cont "secrète du Ninja!"
	prompt
	db "@"
.textAfter
	text "Cizayox est"
	line "maintenant"
	cont "Spectre/Acier!"
	done
	db "@"
