CeruleanGymScript:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	call nz, CeruleanGymScript_Header
	call EnableAutoTextBoxDrawing
	ld hl, CeruleanGymTrainerHeader0
	ld de, CeruleanGymScriptPointers
	ld a, [wCeruleanGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wCeruleanGymCurScript], a
	ret

CeruleanGymScript_Header:
	ld hl, Gym2CityName
	ld de, Gym2LeaderName
	jp LoadGymLeaderAndCityName

Gym2CityName:
	db "Azuria@"

Gym2LeaderName:
	db "Ondine@"

CeruleanGymScript_Reset:
	xor a
	ld [wJoyIgnore], a
	ld [wCeruleanGymCurScript], a
	ld [wCurMapScript], a
	ret

CeruleanGymScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw CeruleanGymScript_Battle

CeruleanGymScript_Battle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, CeruleanGymScript_Reset
	ld a, $f0
	ld [wJoyIgnore], a

CeruleanGymScript_GiveTM:
	ld a, $5
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_MISTY
	lb bc, TM11_BUBBLEBEAM, 1
	call GiveItem
	jr nc, .bagFull
	ld a, $6
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM11
	jr .endScript
.bagFull
	ld a, $7
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.endScript
	ld hl, wObtainedBadges
	set 1, [hl]

	; deactivate gym trainers
	SetEvents EVENT_BEAT_CERULEAN_GYM_TRAINER_0, EVENT_BEAT_CERULEAN_GYM_TRAINER_1

	ld a, [wMoreGameplayOptions]
	bit 0, a
	jr z, .next ; no levelcaps
	; else
	; display new level cap to the player
	callfar GetLevelCap
	ld a, $8
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.next
	jp CeruleanGymScript_Reset

CeruleanGymTextPointers:
	dw CeruleanGymText_Misty
	dw CeruleanGymText_Trainer0
	dw CeruleanGymText_Trainer1
	dw CeruleanGymText_Guide
	dw CeruleanGymText_Badge
	dw CeruleanGymText_ReceivedTM
	dw CeruleanGymText_BagFull
	dw CeruleanGymText_LevelCap

CeruleanGymTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_CERULEAN_GYM_TRAINER_0
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CERULEAN_GYM_TRAINER_0
	dw CeruleanGymText_Trainer0PreBattle ; TextBeforeBattle
	dw CeruleanGymText_Trainer0AfterBattle ; TextAfterBattle
	dw CeruleanGymText_Trainer0EndBattle ; TextEndBattle
	dw CeruleanGymText_Trainer0EndBattle ; TextEndBattle

CeruleanGymTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_CERULEAN_GYM_TRAINER_1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CERULEAN_GYM_TRAINER_1
	dw CeruleanGymText_Trainer1PreBattle ; TextBeforeBattle
	dw CeruleanGymText_Trainer1AfterBattle ; TextAfterBattle
	dw CeruleanGymText_Trainer1EndBattle ; TextEndBattle
	dw CeruleanGymText_Trainer1EndBattle ; TextEndBattle

	db $ff

CeruleanGymText_Misty:
	TX_ASM
	CheckEvent EVENT_BEAT_MISTY
	jr z, .leaderFight
	CheckEventReuseA EVENT_GOT_TM11
	jr nz, .askForRematch
	call z, CeruleanGymScript_GiveTM
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
	CheckEitherEventSet EVENT_NEW_GAME_PLUS, EVENT_BEAT_MISTY_REMATCH
	jp nz, BlastoiseTutor

	ld hl, CeruleanGymText_LeaderAfterBattle
	call PrintText
	jr .endScript
.leaderFight
	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .leaderFightAfterElite4

	ld hl, CeruleanGymText_LeaderPreBattle
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, CeruleanGymText_LeaderEndBattle
	ld de, CeruleanGymText_LeaderEndBattle
	call SaveEndBattleTextPointers
	ld a, $2
	ld [wGymLeaderNo], a
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	xor a
	ld [hJoyHeld], a
;;;;joenote - added for rematch to skip gym leader tm
	CheckEvent EVENT_GOT_TM11
	jp nz, TextScriptEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, $3
	ld [wCeruleanGymCurScript], a
	jr .endScript
.leaderFightAfterElite4
	ld hl, CeruleanGymText_RematchPreBattle
	call PrintText

	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, CeruleanGymText_RematchEndBattle
	ld de, CeruleanGymText_RematchEndBattle
	call SaveEndBattleTextPointers
	ld a, $2
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

CeruleanGymText_LeaderPreBattle:
	TX_FAR _CeruleanGymText_LeaderPreBattle
	db "@"

CeruleanGymText_LeaderAfterBattle:
	TX_ASM
	ld a, [wMoreGameplayOptions]
	bit 0, a
	jr z, .next ; no levelcaps
	; else
	; display new level cap to the player
	callfar GetLevelCap
	ld hl, CeruleanGymText_LevelCapWait
	call PrintText
.next
	ld hl, .LeaderAfterBattle
	call PrintText
	jp TextScriptEnd
.LeaderAfterBattle
	TX_FAR _CeruleanGymText_LeaderAfterBattle
	db "@"

CeruleanGymText_LevelCapWait:
	TX_FAR _DisplayLevelCap
	TX_WAIT
	db "@"

CeruleanGymText_LevelCap:
	TX_FAR _DisplayLevelCap
	db "@"

CeruleanGymText_Badge:
	TX_FAR _CeruleanGymText_Badge
	db "@"

CeruleanGymText_ReceivedTM:
	TX_FAR _CeruleanGymText_ReceivedTM
	TX_SFX_ITEM_1
	db "@"

CeruleanGymText_BagFull:
	TX_FAR _CeruleanGymText_BagFull
	db "@"

CeruleanGymText_LeaderEndBattle:
	TX_FAR _CeruleanGymText_LeaderEndBattle
	;joenote - now plays an unused item sfx for getting a badge
	TX_SFX_KEY_ITEM ; actually plays the second channel of SFX_BALL_POOF due to the wrong music bank being loaded
	TX_BLINK
	db "@"

CeruleanGymText_Trainer0:
	TX_ASM
	ld hl, CeruleanGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

CeruleanGymText_Trainer0PreBattle:
	TX_FAR _CeruleanGymText_Trainer0PreBattle
	db "@"

CeruleanGymText_Trainer0EndBattle:
	TX_FAR _CeruleanGymText_Trainer0EndBattle
	db "@"

CeruleanGymText_Trainer0AfterBattle:
	TX_FAR _CeruleanGymText_Trainer0AfterBattle
	db "@"

CeruleanGymText_Trainer1:
	TX_ASM
	ld hl, CeruleanGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

CeruleanGymText_Trainer1PreBattle:
	TX_FAR _CeruleanGymText_Trainer1PreBattle
	db "@"

CeruleanGymText_Trainer1EndBattle:
	TX_FAR _CeruleanGymText_Trainer1EndBattle
	db "@"

CeruleanGymText_Trainer1AfterBattle:
	TX_FAR _CeruleanGymText_Trainer1AfterBattle
	db "@"

CeruleanGymText_RematchPreBattle:
	TX_FAR _CeruleanGymText_RematchPreBattle
	db "@"

CeruleanGymText_RematchEndBattle:
	TX_ASM
	SetEvent EVENT_BEAT_MISTY_REMATCH
	ld hl, wBeatGymLeadersRematch
	set 1, [hl]
	
	ld hl, .ceruleanGymText_RematchEndBattle
	call PrintText
	jp TextScriptEnd
.ceruleanGymText_RematchEndBattle
	TX_FAR _CeruleanGymText_RematchEndBattle
	db "@"

CeruleanGymText_Guide:
	TX_ASM
	CheckEvent EVENT_BEAT_MISTY
	jr nz, .arenaVictory
	ld hl, CeruleanGymText_GuideTip
	call PrintText
	jr .endScript
.arenaVictory
	ld hl, CeruleanGymText_GuideVictory
	call PrintText
.endScript
	jp TextScriptEnd

CeruleanGymText_GuideTip:
	TX_FAR _CeruleanGymText_GuideTip
	db "@"

CeruleanGymText_GuideVictory:
	TX_FAR _CeruleanGymText_GuideVictory
	db "@"

BlastoiseTutor:
	ld a, [wPartyMon1Species]
	cp BLASTOISE
	jr nz, .displayBring

	xor a
	ld [wWhichPokemon], a

	ld hl, .textStart
	call PrintText

	call GBFadeOutToBlack
	ld a, STEEL
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
	text "Si tu m'amènes un"
	line "Tortank, je l'en-"
	cont "trainerai à"
	cont "devenir solide"
	cont "comme l'Acier!"
	done
	db "@"
.textStart
	text "Ton Tortank va"
	line "être blindé"
	cont "comme jamais!"
	prompt
	db "@"
.textAfter
	text "Tortank est"
	line "maintenant"
	cont "Eau/Acier!"
	done
	db "@"
