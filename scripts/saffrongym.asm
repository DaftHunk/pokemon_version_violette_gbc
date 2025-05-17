SaffronGymScript:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	call nz, .extra
	call EnableAutoTextBoxDrawing
	ld hl, SaffronGymTrainerHeader0
	ld de, SaffronGymScriptPointers
	ld a, [wSaffronGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSaffronGymCurScript], a
	ret

.extra
	ld hl, Gym6CityName
	ld de, Gym6LeaderName
	jp LoadGymLeaderAndCityName

Gym6CityName:
	db "Safrania@"

Gym6LeaderName:
	db "Morgane@"

SaffronGymScript_Reset:
	xor a
	ld [wJoyIgnore], a
	ld [wSaffronGymCurScript], a
	ld [wCurMapScript], a
	ret

SaffronGymScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw SaffronGymScript_Battle

SaffronGymScript_Battle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, SaffronGymScript_Reset
	ld a, $f0
	ld [wJoyIgnore], a

SaffronGymText_GiveTM:
	ld a, $a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_SABRINA
	lb bc, TM46_PSYWAVE, 1
	call GiveItem
	jr nc, .bagFull
	ld a, $b
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM46
	jr .endScript
.bagFull
	ld a, $c
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.endScript
	ld hl, wObtainedBadges
	set 5, [hl]
	;ld hl, wBeatSpecial4Flags	;joenote - redundant
	;set 5, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_SAFFRON_GYM_TRAINER_0, EVENT_BEAT_SAFFRON_GYM_TRAINER_6

	jp SaffronGymScript_Reset

SaffronGymTextPointers:
	dw SaffronGymText_Sabrina
	dw SaffronGymText_Trainer0
	dw SaffronGymText_Trainer1
	dw SaffronGymText_Trainer2
	dw SaffronGymText_Trainer3
	dw SaffronGymText_Trainer4
	dw SaffronGymText_Trainer5
	dw SaffronGymText_Trainer6
	dw SaffronGymText_Guide
	dw SaffronGymText_Badge
	dw SaffronGymText_ReceivedTM
	dw SaffronGymText_BagFull

SaffronGymTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_SAFFRON_GYM_TRAINER_0
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SAFFRON_GYM_TRAINER_0
	dw SaffronGymText_Trainer0PreBattle ; TextBeforeBattle
	dw SaffronGymText_Trainer0AfterBattle ; TextAfterBattle
	dw SaffronGymText_Trainer0EndBattle ; TextEndBattle
	dw SaffronGymText_Trainer0EndBattle ; TextEndBattle

SaffronGymTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_SAFFRON_GYM_TRAINER_1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SAFFRON_GYM_TRAINER_1
	dw SaffronGymText_Trainer1PreBattle ; TextBeforeBattle
	dw SaffronGymText_Trainer1AfterBattle ; TextAfterBattle
	dw SaffronGymText_Trainer1EndBattle ; TextEndBattle
	dw SaffronGymText_Trainer1EndBattle ; TextEndBattle

SaffronGymTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_SAFFRON_GYM_TRAINER_2
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SAFFRON_GYM_TRAINER_2
	dw SaffronGymText_Trainer2PreBattle ; TextBeforeBattle
	dw SaffronGymText_Trainer2AfterBattle ; TextAfterBattle
	dw SaffronGymText_Trainer2EndBattle ; TextEndBattle
	dw SaffronGymText_Trainer2EndBattle ; TextEndBattle

SaffronGymTrainerHeader3:
	dbEventFlagBit EVENT_BEAT_SAFFRON_GYM_TRAINER_3
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SAFFRON_GYM_TRAINER_3
	dw SaffronGymText_Trainer3PreBattle ; TextBeforeBattle
	dw SaffronGymText_Trainer3AfterBattle ; TextAfterBattle
	dw SaffronGymText_Trainer3EndBattle ; TextEndBattle
	dw SaffronGymText_Trainer3EndBattle ; TextEndBattle

SaffronGymTrainerHeader4:
	dbEventFlagBit EVENT_BEAT_SAFFRON_GYM_TRAINER_4
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SAFFRON_GYM_TRAINER_4
	dw SaffronGymText_Trainer4PreBattle ; TextBeforeBattle
	dw SaffronGymText_Trainer4AfterBattle ; TextAfterBattle
	dw SaffronGymText_Trainer4EndBattle ; TextEndBattle
	dw SaffronGymText_Trainer4EndBattle ; TextEndBattle

SaffronGymTrainerHeader5:
	dbEventFlagBit EVENT_BEAT_SAFFRON_GYM_TRAINER_5
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SAFFRON_GYM_TRAINER_5
	dw SaffronGymText_Trainer5PreBattle ; TextBeforeBattle
	dw SaffronGymText_Trainer5AfterBattle ; TextAfterBattle
	dw SaffronGymText_Trainer5EndBattle ; TextEndBattle
	dw SaffronGymText_Trainer5EndBattle ; TextEndBattle

SaffronGymTrainerHeader6:
	dbEventFlagBit EVENT_BEAT_SAFFRON_GYM_TRAINER_6, 1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SAFFRON_GYM_TRAINER_6, 1
	dw SaffronGymText_Trainer6PreBattle ; TextBeforeBattle
	dw SaffronGymText_Trainer6AfterBattle ; TextAfterBattle
	dw SaffronGymText_Trainer6EndBattle ; TextEndBattle
	dw SaffronGymText_Trainer6EndBattle ; TextEndBattle

	db $ff

SaffronGymText_Sabrina:
	TX_ASM
	CheckEvent EVENT_BEAT_SABRINA
	jr z, .leaderFight
	CheckEventReuseA EVENT_GOT_TM46
	jr nz, .askForRematch
	call z, SaffronGymText_GiveTM
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
	CheckEvent EVENT_BEAT_SABRINA_REMATCH
	call nz, NinetalesTutor

	ld hl, SaffronGymText_LeaderAfterBattle
	call PrintText
	jp .endScript
.leaderFight
	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .leaderFightAfterElite4

	ld hl, SaffronGymText_LeaderPreBattle
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, SaffronGymText_LeaderEndBattle
	ld de, SaffronGymText_LeaderEndBattle
	call SaveEndBattleTextPointers
	ld a, $6
	ld [wGymLeaderNo], a
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters

	; Check if Erika is defeated
	CheckEvent EVENT_BEAT_ERIKA
	jr nz, .sabrina2
	; Else
	jr .sabrina1
.sabrina1
	ld a, 1	;get the right roster
	ld [wTrainerNo], a
	jr .afterBattle
.sabrina2
	ld a, 2	;get the right roster
	ld [wTrainerNo], a
	jr .afterBattle
.afterBattle
	xor a
	ld [hJoyHeld], a
;;;;joenote - added for rematch to skip gym leader tm
	CheckEvent EVENT_GOT_TM46
	jp nz, TextScriptEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, $3
	ld [wSaffronGymCurScript], a
	jr .endScript
.leaderFightAfterElite4
	ld hl, SaffronGymText_RematchPreBattle
	call PrintText	
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, SaffronGymText_RematchEndBattle
	ld de, SaffronGymText_RematchEndBattle
	call SaveEndBattleTextPointers
	ld a, $6
	ld [wGymLeaderNo], a
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, 3	;get the right roster
	ld [wTrainerNo], a
	xor a
	ld [hJoyHeld], a
	jr .endScript
.endScript
	jp TextScriptEnd

SaffronGymText_LeaderPreBattle:
	TX_FAR _SaffronGymText_LeaderPreBattle
	db "@"

SaffronGymText_LeaderEndBattle:
	TX_FAR _SaffronGymText_LeaderEndBattle
	;joenote - now plays an unused item sfx for getting a badge
	TX_SFX_KEY_ITEM ; actually plays the second channel of SFX_BALL_POOF due to the wrong music bank being loaded
	TX_BLINK
	db "@"

SaffronGymText_LeaderAfterBattle:
	TX_FAR _SaffronGymText_LeaderAfterBattle
	db "@"

SaffronGymText_Badge:
	TX_FAR _SaffronGymText_Badge
	db "@"

SaffronGymText_ReceivedTM:
	TX_FAR _SaffronGymText_ReceivedTM
	TX_SFX_ITEM_1
	TX_FAR _SaffronGymText_TMExplanation
	db "@"

SaffronGymText_BagFull:
	TX_FAR _SaffronGymText_BagFull
	db "@"

SaffronGymText_RematchPreBattle:
	TX_FAR _SaffronGymText_RematchPreBattle
	db "@"

SaffronGymText_RematchEndBattle:
	TX_ASM
	SetEvent EVENT_BEAT_SABRINA_REMATCH
	ld hl, .saffronGymText_RematchEndBattle
	call PrintText
	jp TextScriptEnd
.saffronGymText_RematchEndBattle
	TX_FAR _SaffronGymText_RematchEndBattle
	db "@"

SaffronGymText_Trainer0:
	TX_ASM
	ld hl, SaffronGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymText_Trainer1:
	TX_ASM
	ld hl, SaffronGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymText_Trainer2:
	TX_ASM
	ld hl, SaffronGymTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymText_Trainer3:
	TX_ASM
	ld hl, SaffronGymTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymText_Trainer4:
	TX_ASM
	ld hl, SaffronGymTrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymText_Trainer5:
	TX_ASM
	ld hl, SaffronGymTrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymText_Trainer6:
	TX_ASM
	ld hl, SaffronGymTrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymText_Guide:
	TX_ASM
	CheckEvent EVENT_BEAT_SABRINA
	jr nz, .arenaVictory
	ld hl, SaffronGymText_GuideTip
	call PrintText
	jr .endScript
.arenaVictory
	ld hl, SaffronGymText_GuideVictory
	call PrintText
.endScript
	jp TextScriptEnd

SaffronGymText_GuideTip:
	TX_FAR _SaffronGymText_GuideTip
	db "@"

SaffronGymText_GuideVictory:
	TX_FAR _SaffronGymText_GuideVictory
	db "@"

SaffronGymText_Trainer0PreBattle:
	TX_FAR _SaffronGymText_Trainer0PreBattle
	db "@"

SaffronGymText_Trainer0EndBattle:
	TX_FAR _SaffronGymText_Trainer0EndBattle
	db "@"

SaffronGymText_Trainer0AfterBattle:
	TX_FAR _SaffronGymText_Trainer0AfterBattle
	db "@"

SaffronGymText_Trainer1PreBattle:
	TX_FAR _SaffronGymText_Trainer1PreBattle
	db "@"

SaffronGymText_Trainer1EndBattle:
	TX_FAR _SaffronGymText_Trainer1EndBattle
	db "@"

SaffronGymText_Trainer1AfterBattle:
	TX_FAR _SaffronGymText_Trainer1AfterBattle
	db "@"

SaffronGymText_Trainer2PreBattle:
	TX_FAR _SaffronGymText_Trainer2PreBattle
	db "@"

SaffronGymText_Trainer2EndBattle:
	TX_FAR _SaffronGymText_Trainer2EndBattle
	db "@"

SaffronGymText_Trainer2AfterBattle:
	TX_FAR _SaffronGymText_Trainer2AfterBattle
	db "@"

SaffronGymText_Trainer3PreBattle:
	TX_FAR _SaffronGymText_Trainer3PreBattle
	db "@"

SaffronGymText_Trainer3EndBattle:
	TX_FAR _SaffronGymText_Trainer3EndBattle
	db "@"

SaffronGymText_Trainer3AfterBattle:
	TX_FAR _SaffronGymText_Trainer3AfterBattle
	db "@"

SaffronGymText_Trainer4PreBattle:
	TX_FAR _SaffronGymText_Trainer4PreBattle
	db "@"

SaffronGymText_Trainer4EndBattle:
	TX_FAR _SaffronGymText_Trainer4EndBattle
	db "@"

SaffronGymText_Trainer4AfterBattle:
	TX_FAR _SaffronGymText_Trainer4AfterBattle
	db "@"

SaffronGymText_Trainer5PreBattle:
	TX_FAR _SaffronGymText_Trainer5PreBattle
	db "@"

SaffronGymText_Trainer5EndBattle:
	TX_FAR _SaffronGymText_Trainer5EndBattle
	db "@"

SaffronGymText_Trainer5AfterBattle:
	TX_FAR _SaffronGymText_Trainer5AfterBattle
	db "@"

SaffronGymText_Trainer6PreBattle:
	TX_FAR _SaffronGymText_Trainer6PreBattle
	db "@"

SaffronGymText_Trainer6EndBattle:
	TX_FAR _SaffronGymText_Trainer6EndBattle
	db "@"

SaffronGymText_Trainer6AfterBattle:
	TX_FAR _SaffronGymText_Trainer6AfterBattle
	db "@"

NinetalesTutor:
	ld a, [wPartyMon1Species]
	cp NINETALES
	jr z, .next
	ret
.next
	ld hl, .Text1
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .finish
	xor a
	ld [wWhichPokemon], a
	ld a, HYPNOSIS
	call .learnmove
	ld a, DARK_PULSE
	call .learnmove
.finish
	ret
.Text1
	text "Je ressens de gr-"
	line "andes forces my-"
	cont "stiques avec ton"
	cont "Feunard. Je peux"
	cont "lui apprendre un"
	cont "truc sympa."
	prompt
	db "@"
	
.learnmove
	ld [wMoveNum], a
	ld [wPokedexNum],a
	call GetMoveName
	call CopyStringToCF4B ; copy name to wcf4b

	ld a, [wPokedexNum]
	push af
	ld a, [wPartyMon1Species]
	ld [wPokedexNum], a
	call GetMonName
	pop af
	ld [wPokedexNum], a
	
	callba CheckIfMoveIsKnown
	ret c	;carry set of move known already

	ld hl, wFlags_D733
	set 6, [hl]
	push hl		;make it so the move-forget list covers up sprites
	predef LearnMove
	pop hl
	res 6, [hl]
	ret
