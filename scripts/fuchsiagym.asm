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
	bit 6, [hl]
	res 6, [hl]
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
	set 4, [hl]
	;ld hl, wBeatSpecial4Flags	;joenote - redundant
	;set 4, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_FUCHSIA_GYM_TRAINER_0, EVENT_BEAT_FUCHSIA_GYM_JANINE

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
	CheckEvent EVENT_BEAT_KOGA_REMATCH
	call nz, ScytherTutor

	ld hl, FuchsiaGymText_LeaderAfterBattle
	call PrintText
	jp .endScript
.leaderFight
	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .leaderFightAfterElite4

	ld hl, FuchsiaGymText_LeaderPreBattle
	call PrintText
	ld hl, wd72d
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

	; Check if Erika is defeated
	CheckEvent EVENT_BEAT_ERIKA
	jr nz, .koga2
	; Else
	jr .koga1
.koga1
	ld a, 1	;get the right roster
	ld [wTrainerNo], a
	jr .afterBattle
.koga2
	ld a, 2	;get the right roster
	ld [wTrainerNo], a
	jr .afterBattle
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

	ld hl, wd72d
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
	ld a, 3	;get the right roster
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
	TX_FAR _FuchsiaGymText_LeaderAfterBattle
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
	ld hl, .fuchsiaGymText_RematchEndBattle
	call PrintText
	jp TextScriptEnd
.fuchsiaGymText_RematchEndBattle
	TX_FAR _FuchsiaGymText_RematchEndBattle
	db "@"

FuchsiaGymText_Trainer0:
	TX_ASM
	ld hl, FuchsiaGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymText_Trainer0PreBattle:
	TX_FAR _FuchsiaGymText_Trainer0PreBattle
	db "@"

FuchsiaGymText_Trainer0EndBattle:
	TX_FAR _FuchsiaGymText_Trainer0EndBattle
	db "@"

FuchsiaGymText_Trainer0AfterBattle:
	TX_FAR _FuchsiaGymText_Trainer0AfterBattle
	db "@"

FuchsiaGymText_Trainer1:
	TX_ASM
	ld hl, FuchsiaGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymText_Trainer1PreBattle:
	TX_FAR _FuchsiaGymText_Trainer1PreBattle
	db "@"

FuchsiaGymText_Trainer1EndBattle:
	TX_FAR _FuchsiaGymText_Trainer1EndBattle
	db "@"

FuchsiaGymText_Trainer1AfterBattle:
	TX_FAR _FuchsiaGymText_Trainer1AfterBattle
	db "@"

FuchsiaGymText_Trainer2:
	TX_ASM
	ld hl, FuchsiaGymTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymText_Trainer2PreBattle:
	TX_FAR _FuchsiaGymText_Trainer2PreBattle
	db "@"

FuchsiaGymText_Trainer2EndBattle:
	TX_FAR _FuchsiaGymText_Trainer2EndBattle
	db "@"

FuchsiaGymText_Trainer2AfterBattle:
	TX_FAR _FuchsiaGymText_Trainer2AfterBattle
	db "@"

FuchsiaGymText_Trainer3:
	TX_ASM
	ld hl, FuchsiaGymTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymText_Trainer3PreBattle:
	TX_FAR _FuchsiaGymText_Trainer3PreBattle
	db "@"

FuchsiaGymText_Trainer3EndBattle:
	TX_FAR _FuchsiaGymText_Trainer3EndBattle
	db "@"

FuchsiaGymText_Trainer3AfterBattle:
	TX_FAR _FuchsiaGymText_Trainer3AfterBattle
	db "@"

FuchsiaGymText_Trainer4:
	TX_ASM
	ld hl, FuchsiaGymTrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymText_Trainer4PreBattle:
	TX_FAR _FuchsiaGymText_Trainer4PreBattle
	db "@"

FuchsiaGymText_Trainer4EndBattle:
	TX_FAR _FuchsiaGymText_Trainer4EndBattle
	db "@"

FuchsiaGymText_Trainer4AfterBattle:
	TX_FAR _FuchsiaGymText_Trainer4AfterBattle
	db "@"

FuchsiaGymJanineText:
	TX_ASM
	ld hl, FuchsiaGymJanineHeader
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymText_JaninePreBattle:
	TX_FAR _FuchsiaGymText_JaninePreBattle
	db "@"

FuchsiaGymText_JanineEndBattle:
	TX_FAR _FuchsiaGymText_JanineEndBattle
	db "@"

FuchsiaGymText_JanineAfterBattle:
	TX_FAR _FuchsiaGymText_JanineAfterBattle
	db "@"

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
	
ScytherTutor:
	ld a, [wPartyMon1Species]
	cp SCYTHER
	ret nz

	xor a
	ld [wWhichPokemon], a

	ld hl, .textStart
	call PrintText

	ld a, HYPNOSIS		;genjutsu
	call .learnmove
	ld a, PIN_MISSILE	;shuriken
	call .learnmove
	ld a, LIGHT_SCREEN	;invisible walls
	call .learnmove
	ret
.textStart
	text "Tu as un"
	line "Insécateur très"
	cont "talentueux."
	cont "Je pourrais lui"
	cont "apprendre la voie"
	cont "secrète du Ninja."

	para "Un vrai Ninja doit"
	line "maîtriser l'art"
	cont "du Genjutsu, le"
	cont "lancer de Shuri-"
	cont "ken et bien évi-"
	cont "demment, les murs"
	cont "invisibles!"
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
	jr c, .finish

	ld hl, wFlags_D733
	set 6, [hl]
	push hl		;make it so the move-forget list covers up sprites
	predef LearnMove
	pop hl
	res 6, [hl]
	ld a, b
	and a
	ret z
.finish
	ret
