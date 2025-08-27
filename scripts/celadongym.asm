CeladonGymScript:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	call nz, CeladonGymScript_Header
	call EnableAutoTextBoxDrawing
	ld hl, CeladonGymTrainerHeader0
	ld de, CeladonGymScriptPointers
	ld a, [wCeladonGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wCeladonGymCurScript], a
	ret

CeladonGymScript_Header:
	ld hl, Gym4CityName
	ld de, Gym4LeaderName
	jp LoadGymLeaderAndCityName

Gym4CityName:
	db "Céladopole@"

Gym4LeaderName:
	db "Erika@"

CeladonGymScript_Reset:
	xor a
	ld [wJoyIgnore], a
	ld [wCeladonGymCurScript], a
	ld [wCurMapScript], a
	ret

CeladonGymScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw CeladonGymScript_Battle

CeladonGymScript_Battle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, CeladonGymScript_Reset
	ld a, $f0
	ld [wJoyIgnore], a

CeladonGymScript_GiveTM:
	ld a, $9
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_ERIKA
	lb bc, TM21_MEGA_DRAIN, 1
	call GiveItem
	jr nc, .bagFull
	ld a, $a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM21
	jr .endScript
.bagFull
	ld a, $b
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.endScript
	ld hl, wObtainedBadges
	set 3, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_CELADON_GYM_TRAINER_0, EVENT_BEAT_CELADON_GYM_TRAINER_6

	ld a, [wMoreGameplayOptions]
	bit 0, a
	jr z, .next ; no levelcaps
	; else
	; display new level cap to the player
	callfar GetLevelCap
	ld a, $c
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.next
	jp CeladonGymScript_Reset

CeladonGymTextPointers:
	dw CeladonGymText_Erika
	dw CeladonGymText_Trainer0
	dw CeladonGymText_Trainer1
	dw CeladonGymText_Trainer2
	dw CeladonGymText_Trainer3
	dw CeladonGymText_Trainer4
	dw CeladonGymText_Trainer5
	dw CeladonGymText_Trainer6
	dw CeladonGymText_Badge
	dw CeladonGymText_TMReceived
	dw CeladonGymText_BagFull
	dw CeladonGymText_LevelCap

CeladonGymTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_0
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_0
	dw CeladonGymText_Trainer0PreBattle ; TextBeforeBattle
	dw CeladonGymText_Trainer0AfterBattle ; TextAfterBattle
	dw CeladonGymText_Trainer0EndBattle ; TextEndBattle
	dw CeladonGymText_Trainer0EndBattle ; TextEndBattle

CeladonGymTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_1
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_1
	dw CeladonGymText_Trainer1PreBattle ; TextBeforeBattle
	dw CeladonGymText_Trainer1AfterBattle ; TextAfterBattle
	dw CeladonGymText_Trainer1EndBattle ; TextEndBattle
	dw CeladonGymText_Trainer1EndBattle ; TextEndBattle

CeladonGymTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_2
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_2
	dw CeladonGymText_Trainer2PreBattle ; TextBeforeBattle
	dw CeladonGymText_Trainer2AfterBattle ; TextAfterBattle
	dw CeladonGymText_Trainer2EndBattle ; TextEndBattle
	dw CeladonGymText_Trainer2EndBattle ; TextEndBattle

CeladonGymTrainerHeader3:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_3
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_3
	dw CeladonGymText_Trainer3PreBattle ; TextBeforeBattle
	dw CeladonGymText_Trainer3AfterBattle ; TextAfterBattle
	dw CeladonGymText_Trainer3EndBattle ; TextEndBattle
	dw CeladonGymText_Trainer3EndBattle ; TextEndBattle

CeladonGymTrainerHeader4:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_4
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_4
	dw CeladonGymText_Trainer4PreBattle ; TextBeforeBattle
	dw CeladonGymText_Trainer4AfterBattle ; TextAfterBattle
	dw CeladonGymText_Trainer4EndBattle ; TextEndBattle
	dw CeladonGymText_Trainer4EndBattle ; TextEndBattle

CeladonGymTrainerHeader5:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_5
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_5
	dw CeladonGymText_Trainer5PreBattle ; TextBeforeBattle
	dw CeladonGymText_Trainer5AfterBattle ; TextAfterBattle
	dw CeladonGymText_Trainer5EndBattle ; TextEndBattle
	dw CeladonGymText_Trainer5EndBattle ; TextEndBattle

CeladonGymTrainerHeader6:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_6, 1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_6, 1
	dw CeladonGymText_Trainer6PreBattle ; TextBeforeBattle
	dw CeladonGymText_Trainer6AfterBattle ; TextAfterBattle
	dw CeladonGymText_Trainer6EndBattle ; TextEndBattle
	dw CeladonGymText_Trainer6EndBattle ; TextEndBattle

	db $ff

CeladonGymText_Erika:
	TX_ASM
	CheckEvent EVENT_BEAT_ERIKA
	jr z, .leaderFight
	CheckEventReuseA EVENT_GOT_TM21
	jr nz, .askForRematch
	call z, CeladonGymScript_GiveTM
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
	CheckEitherEventSet EVENT_NEW_GAME_PLUS, EVENT_BEAT_ERIKA_REMATCH
	jp nz, VenusaurTutor

	ld hl, CeladonGymText_LeaderAfterBattle
	call PrintText
	jp .endScript
.leaderFight
	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .leaderFightAfterElite4

	ld hl, CeladonGymText_LeaderPreBattle
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, CeladonGymText_LeaderEndBattle
	ld de, CeladonGymText_LeaderEndBattle
	call SaveEndBattleTextPointers
	ld a, $4
	ld [wGymLeaderNo], a
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters

	; Check if both Koga and Sabrina are defeated
	CheckBothEventsSet EVENT_BEAT_KOGA, EVENT_BEAT_SABRINA
	jr z, .erika3
	; Else only one of them is
	CheckEitherEventSet EVENT_BEAT_KOGA, EVENT_BEAT_SABRINA
	jr nz, .erika2
	; Else none of them are defeated
	jr .erika1
.erika1
	ld a, 1	;get the right roster
	ld [wTrainerNo], a
	jr .afterBattle
.erika2
	ld a, 2	;get the right roster
	ld [wTrainerNo], a
	jr .afterBattle
.erika3
	ld a, 3	;get the right roster
	ld [wTrainerNo], a
	jr .afterBattle
.afterBattle
;;;;joenote - added for rematch to skip gym leader tm
	CheckEvent EVENT_GOT_TM21
	jp nz, TextScriptEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, $3
	ld [wCeladonGymCurScript], a
	ld [wCurMapScript], a
	jr .endScript
.leaderFightAfterElite4
	ld hl, CeladonGymText_RematchPreBattle
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, CeladonGymText_RematchEndBattle
	ld de, CeladonGymText_RematchEndBattle
	call SaveEndBattleTextPointers
	ld a, $4
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

CeladonGymText_LeaderPreBattle:
	TX_FAR _CeladonGymText_LeaderPreBattle
	db "@"

CeladonGymText_LeaderEndBattle:
	TX_FAR _CeladonGymText_LeaderEndBattle
	TX_SFX_KEY_ITEM	;joenote - play an unused sfx instead (triggered by playing GET_KEY_ITEM in battle)
	db "@"

CeladonGymText_LeaderAfterBattle:
	TX_ASM
	ld a, [wMoreGameplayOptions]
	bit 0, a
	jr z, .next ; no levelcaps
	; else
	; display new level cap to the player
	callfar GetLevelCap
	ld hl, CeladonGymText_LevelCap
	call PrintText
.next
	ld hl, .LeaderAfterBattle
	call PrintText
	jp TextScriptEnd
.LeaderAfterBattle
	TX_FAR _CeladonGymText_LeaderAfterBattle
	db "@"

CeladonGymText_LevelCap:
	TX_FAR _DisplayLevelCap
	db "@"

CeladonGymText_Badge:
	TX_FAR _CeladonGymText_Badge
	db "@"

CeladonGymText_TMReceived:
	TX_FAR _ReceivedCeladonGymText_TMReceived
	TX_SFX_ITEM_1
	TX_FAR _CeladonGymText_TMExplanation
	db "@"

CeladonGymText_BagFull:
	TX_FAR _CeladonGymText_BagFull
	db "@"

CeladonGymText_RematchPreBattle:
	TX_FAR _CeladonGymText_RematchPreBattle
	db "@"

CeladonGymText_RematchEndBattle:
	TX_ASM
	SetEvent EVENT_BEAT_ERIKA_REMATCH
	ld hl, wBeatGymLeadersRematch
	set 3, [hl]
	
	ld hl, .celadonGymText_RematchEndBattle
	call PrintText
	jp TextScriptEnd
.celadonGymText_RematchEndBattle
	TX_FAR _CeladonGymText_RematchEndBattle
	db "@"

CeladonGymText_Trainer0:
	TX_ASM
	ld hl, CeladonGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymText_Trainer0PreBattle:
	TX_FAR _CeladonGymText_Trainer0PreBattle
	db "@"

CeladonGymText_Trainer0EndBattle:
	TX_FAR _CeladonGymText_Trainer0EndBattle
	db "@"

CeladonGymText_Trainer0AfterBattle:
	TX_FAR _CeladonGymText_Trainer0AfterBattle
	db "@"

CeladonGymText_Trainer1:
	TX_ASM
	ld hl, CeladonGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymText_Trainer1PreBattle:
	TX_FAR _CeladonGymText_Trainer1PreBattle
	db "@"

CeladonGymText_Trainer1EndBattle:
	TX_FAR _CeladonGymText_Trainer1EndBattle
	db "@"

CeladonGymText_Trainer1AfterBattle:
	TX_FAR _CeladonGymText_Trainer1AfterBattle
	db "@"

CeladonGymText_Trainer2:
	TX_ASM
	ld hl, CeladonGymTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymText_Trainer2PreBattle:
	TX_FAR _CeladonGymText_Trainer2PreBattle
	db "@"

CeladonGymText_Trainer2EndBattle:
	TX_FAR _CeladonGymText_Trainer2EndBattle
	db "@"

CeladonGymText_Trainer2AfterBattle:
	TX_FAR _CeladonGymText_Trainer2AfterBattle
	db "@"

CeladonGymText_Trainer3:
	TX_ASM
	ld hl, CeladonGymTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymText_Trainer3PreBattle:
	TX_FAR _CeladonGymText_Trainer3PreBattle
	db "@"

CeladonGymText_Trainer3EndBattle:
	TX_FAR _CeladonGymText_Trainer3EndBattle
	db "@"

CeladonGymText_Trainer3AfterBattle:
	TX_FAR _CeladonGymText_Trainer3AfterBattle
	db "@"

CeladonGymText_Trainer4:
	TX_ASM
	ld hl, CeladonGymTrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymText_Trainer4PreBattle:
	TX_FAR _CeladonGymText_Trainer4PreBattle
	db "@"

CeladonGymText_Trainer4EndBattle:
	TX_FAR _CeladonGymText_Trainer4EndBattle
	db "@"

CeladonGymText_Trainer4AfterBattle:
	TX_FAR _CeladonGymText_Trainer4AfterBattle
	db "@"

CeladonGymText_Trainer5:
	TX_ASM
	ld hl, CeladonGymTrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymText_Trainer5PreBattle:
	TX_FAR _CeladonGymText_Trainer5PreBattle
	db "@"

CeladonGymText_Trainer5EndBattle:
	TX_FAR _CeladonGymText_Trainer5EndBattle
	db "@"

CeladonGymText_Trainer5AfterBattle:
	TX_FAR _CeladonGymText_Trainer5AfterBattle
	db "@"

CeladonGymText_Trainer6:
	TX_ASM
	ld hl, CeladonGymTrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymText_Trainer6PreBattle:
	TX_FAR _CeladonGymText_Trainer6PreBattle
	db "@"

CeladonGymText_Trainer6EndBattle:
	TX_FAR _CeladonGymText_Trainer6EndBattle
	db "@"

CeladonGymText_Trainer6AfterBattle:
	TX_FAR _CeladonGymText_Trainer6AfterBattle
	db "@"
	
VenusaurTutor:
	ld a, [wPartyMon1Species]
	cp VENUSAUR
	jr nz, .displayBring

	xor a
	ld [wWhichPokemon], a

	ld hl, .textStart
	call PrintText

	call GBFadeOutToBlack
	ld a, DARK
	ld [wPartyMon1Type2], a

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
	text "Bien joué!"
	line "Passe me voir"
	cont "avec ton"
	cont "Florizarre et je"
	cont "te révélerai sa"
	cont "vraie person-"
	cont "nalité!"
	done
	db "@"
.textStart
	text "Tous le monde a"
	line "sa part d'ombre..."

	para "Le tout c'est de"
	line "savoir la"
	cont "maîtriser!"
	prompt
	db "@"
.textAfter
	text "Florizarre est"
	line "maintenant"
	cont "Plante/Ténèbres!"
	done
	db "@"
