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
;;;;joenote added tutor
	ld a, [wPartyCount]
	dec a
	jr nz, .notutor	;party count must be 1
	ld a, [wPartyMon1Species]
	cp SCYTHER
	jr nz, .notutor	;must have a solo scyther
	ld a, [wPartyMon1Type2]
	cp GHOST
	jr z, .notutor	;can't aready have a ghost scyther
	ld a, 12
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.notutor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
	;ld hl, wBeatGymFlags	;joenote - redundant
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
	dw KogaScytherNinjaTraining

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
	call KogaScytherTutor
	jp z, KogaScytherTutorEndScript
;;;;;;;joenote - have a rematch with gym leader?
	ld hl, RematchTrainerText
	call PrintText
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .leaderFight
;;;;;;;
	ld hl, FuchsiaGymText_LeaderAfterBattle
	call PrintText
	jr .endScript
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
	

	
;joenote - allow Scyther to be trained as a ninja if Koga was beaten solo	
;Gives it bug/ghost typing and allows it to be tutored in a number of ninja-like moves	
	
KogaScytherNinjaTraining:
	TX_ASM
	ld hl, _KogaTutorOffer
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp nz, KogaScytherTutorEndScript
.yes
	call GBFadeOutToBlack
	ld a, GHOST
	ld [wPartyMon1Type2], a
	ld a, SFX_GET_ITEM_2
	call PlaySound 
	call WaitForSoundToFinish
	call GBFadeInFromBlack	
	ld hl, _KogaTutorOffer2
	call PrintText
.end
	jp TextScriptEnd

KogaScytherTutorEndScript:
	ld hl, _KogaTutorBye
	call PrintText
	jp TextScriptEnd
	
KogaScytherTutor:
	ld a, [wPartyMon1Species]
	cp SCYTHER
	jp nz, .ret_cont
	ld a, [wPartyMon1Type2]
	cp GHOST
	jr nz, .ret_cont
	ld hl, _KogaTutorIntro
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .ret_cont
	
	ld hl, wMoveBuffer+1
	push hl
	

	ld b, 0
	ld de, KogaTutorMoves
.loop2
	ld a, [de]
	and a
	jr z, .endloop2

	ld hl, wPartyMon1Moves
	ld c, 4
.loop1
	cp [hl]
	jr z, .endloop1
	inc hl
	dec c
	jr nz, .loop1
	pop hl
	ld [hli], a
	inc b
	push hl
.endloop1

	inc de
	jr .loop2
.endloop2
	
	
	pop hl
	ld a, $ff
	ld [hl], a
	ld a, b
	ld [wMoveBuffer], a
	
	xor a
	ld [wListScrollOffset], a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, MOVESLISTMENU
	ld [wListMenuID], a
	ld de, wMoveBuffer
	ld hl, wListPointer
	ld [hl], e
	inc hl
	ld [hl], d
	xor a
	ld [wPrintItemPrices], a ; don't print prices
	call DisplayListMenuID
	jr c, .ret_close	;return if cancel selected	
	; Save the selected move id.
	ld a, [wcf91]
	ld [wMoveNum], a
	ld [wd11e],a
	call GetMoveName
	call CopyStringToCF4B ; copy name to wcf4b
	xor a	;working with first party pokemon
	ld [wWhichPokemon], a
	ld a, [wLetterPrintingDelayFlags]
	push af
	xor a
	ld [wLetterPrintingDelayFlags], a
	predef LearnMove
	pop af
	ld [wLetterPrintingDelayFlags], a	
	ret
.ret_close
	xor a
	ret
.ret_cont
	ld a, 1
	and a
	ret

KogaTutorMoves:
	db CONFUSE_RAY	;"erie lights" in japanese, scyther reflects light off its blades
	db HYPNOSIS		;genjutsu
	db PIN_MISSILE	;shuriken
	db ROLLING_KICK	;martial arts
	db LIGHT_SCREEN	;invisible walls
	db $00
	
_KogaTutorOffer:
	text "Tu as un"
	line "Insécateur très"
	cont "talentueux."
	cont "Je pourrais lui"
	cont "apprendre la voie"
	cont "secrète du Ninja."

	para "Ses mouvements"
	line "seront si rapide"
	cont "que ses ennemis"
	cont "seront traversés"
	cont "tel des fantômes."
	done
	db "@"

_KogaTutorOffer2:
	text "L'entraînement est"
	line "terminé. Reviens"
	cont "me voir si tu as"
	cont "de nouveau besoin"
	cont "de ma maitrise."
	done
	db "@"

_KogaTutorIntro:
	text "Ton Insécateur est"
	line "un grand Ninja."
	cont "Devrais-je lui"
	cont "apprendre plus?"
	done
	db "@"

_KogaTutorBye:
	text "Je te souhaite"
	line "bonne chance."
	done
	db "@"
