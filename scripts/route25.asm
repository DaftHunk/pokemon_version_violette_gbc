Route25Script:
	call Route25Script_515e1
	call EnableAutoTextBoxDrawing
	call BillSecretGarden	;joenote - fun little easter egg
	ld hl, Route25TrainerHeader0
	ld de, Route25ScriptPointers
	ld a, [wRoute25CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute25CurScript], a
	ret

Route25Script_515e1:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	ret z
	CheckEventHL EVENT_LEFT_BILLS_HOUSE_AFTER_HELPING
	ret nz
	CheckEventReuseHL EVENT_MET_BILL_2
	jr nz, .asm_515ff
	ResetEventReuseHL EVENT_BILL_SAID_USE_CELL_SEPARATOR
	ld a, HS_BILL_POKEMON
	ld [wMissableObjectIndex], a
	predef_jump ShowObject
.asm_515ff
	CheckEventAfterBranchReuseHL EVENT_GOT_SS_TICKET, EVENT_MET_BILL_2
	ret z
	SetEventReuseHL EVENT_LEFT_BILLS_HOUSE_AFTER_HELPING
	ld a, HS_NUGGET_BRIDGE_GUY
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_BILL_1
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_BILL_2
	ld [wMissableObjectIndex], a
	predef_jump ShowObject

Route25ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw Route25Script3

Route25TextPointers:
	dw Route25Text1
	dw Route25Text2
	dw Route25Text3
	dw Route25Text4
	dw Route25Text5
	dw Route25Text6
	dw Route25Text7
	dw Route25Text8
	dw Route25Text9
	dw PickUpItemText
	dw Route25TextRed
	dw Route25Text11
	
Route25TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_ROUTE_25_TRAINER_0
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_25_TRAINER_0
	dw Route25BattleText1 ; TextBeforeBattle
	dw Route25AfterBattleText1 ; TextAfterBattle
	dw Route25EndBattleText1 ; TextEndBattle
	dw Route25EndBattleText1 ; TextEndBattle

Route25TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_ROUTE_25_TRAINER_1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_25_TRAINER_1
	dw Route25BattleText2 ; TextBeforeBattle
	dw Route25AfterBattleText2 ; TextAfterBattle
	dw Route25EndBattleText2 ; TextEndBattle
	dw Route25EndBattleText2 ; TextEndBattle

Route25TrainerHeader2:
	dbEventFlagBit EVENT_BEAT_ROUTE_25_TRAINER_2
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_25_TRAINER_2
	dw Route25BattleText3 ; TextBeforeBattle
	dw Route25AfterBattleText3 ; TextAfterBattle
	dw Route25EndBattleText3 ; TextEndBattle
	dw Route25EndBattleText3 ; TextEndBattle

Route25TrainerHeader3:
	dbEventFlagBit EVENT_BEAT_ROUTE_25_TRAINER_3
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_25_TRAINER_3
	dw Route25BattleText4 ; TextBeforeBattle
	dw Route25AfterBattleText4 ; TextAfterBattle
	dw Route25EndBattleText4 ; TextEndBattle
	dw Route25EndBattleText4 ; TextEndBattle

Route25TrainerHeader4:
	dbEventFlagBit EVENT_BEAT_ROUTE_25_TRAINER_4
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_25_TRAINER_4
	dw Route25BattleText5 ; TextBeforeBattle
	dw Route25AfterBattleText5 ; TextAfterBattle
	dw Route25EndBattleText5 ; TextEndBattle
	dw Route25EndBattleText5 ; TextEndBattle

Route25TrainerHeader5:
	dbEventFlagBit EVENT_BEAT_ROUTE_25_TRAINER_5
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_25_TRAINER_5
	dw Route25BattleText6 ; TextBeforeBattle
	dw Route25AfterBattleText6 ; TextAfterBattle
	dw Route25EndBattleText6 ; TextEndBattle
	dw Route25EndBattleText6 ; TextEndBattle

Route25TrainerHeader6:
	dbEventFlagBit EVENT_BEAT_ROUTE_25_TRAINER_6
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_25_TRAINER_6
	dw Route25BattleText7 ; TextBeforeBattle
	dw Route25AfterBattleText7 ; TextAfterBattle
	dw Route25EndBattleText7 ; TextEndBattle
	dw Route25EndBattleText7 ; TextEndBattle

Route25TrainerHeader7:
	dbEventFlagBit EVENT_BEAT_ROUTE_25_TRAINER_7, 1
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_25_TRAINER_7, 1
	dw Route25BattleText8 ; TextBeforeBattle
	dw Route25AfterBattleText8 ; TextAfterBattle
	dw Route25EndBattleText8 ; TextEndBattle
	dw Route25EndBattleText8 ; TextEndBattle

Route25TrainerHeader8:
	dbEventFlagBit EVENT_BEAT_ROUTE_25_TRAINER_8, 1
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_25_TRAINER_8, 1
	dw Route25BattleText9 ; TextBeforeBattle
	dw Route25AfterBattleText9 ; TextAfterBattle
	dw Route25EndBattleText9 ; TextEndBattle
	dw Route25EndBattleText9 ; TextEndBattle

	db $ff

Route25Script3:	;joenote - adding this function to respawn the legendaries if future red is beaten
	xor a
	ld [wJoyIgnore], a
	ld [wRoute25CurScript], a
	ld [wCurMapScript], a
	ld a, [wIsInBattle]
	cp $ff
	ret z
;reset the special trainer flags
	ld a, [wBeatGymFlags]
	and $F0
	ld [wBeatGymFlags], a
;reset MIST_STONE events
	ResetEvent EVENT_8C3
	ResetEvent EVENT_8C4
;reset Mew events
	ResetEvent EVENT_8C0
	ResetEvent EVENT_8C2
;reset articuno's seafoam islands puzzles
	ld a, HS_SEAFOAM_ISLANDS_B3F_BOULDER_1
	call .showstuff
	ld a, HS_SEAFOAM_ISLANDS_B3F_BOULDER_2
	call .showstuff
	ld a, HS_SEAFOAM_ISLANDS_B4F_BOULDER_1
	call .hidestuff
	ld a, HS_SEAFOAM_ISLANDS_B4F_BOULDER_2
	call .hidestuff
	ResetEvents EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE
;reset mewtwo
	ld a, HS_MEWTWO
	call .showstuff
	ResetEvent EVENT_BEAT_MEWTWO
;reset moltres
	ld a, HS_MOLTRES
	call .showstuff
	ResetEvent EVENT_BEAT_MOLTRES
;reset zapdos
	ld a, HS_ZAPDOS
	call .showstuff
	ResetEvent EVENT_BEAT_ZAPDOS	
;reset articuno and its specific puzzle
	ld a, HS_ARTICUNO
	call .showstuff
	ResetEvent EVENT_BEAT_ARTICUNO
;return now
	ret
.showstuff
	ld [wMissableObjectIndex], a
	predef_jump ShowObject
.hidestuff
	ld [wMissableObjectIndex], a
	predef_jump HideObject
	
Route25Text1:
	TX_ASM
	ld hl, Route25TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route25Text2:
	TX_ASM
	ld hl, Route25TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route25Text3:
	TX_ASM
	ld hl, Route25TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route25Text4:
	TX_ASM
	ld hl, Route25TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route25Text5:
	TX_ASM
	ld hl, Route25TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route25Text6:
	TX_ASM
	ld hl, Route25TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route25Text7:
	TX_ASM
	ld hl, Route25TrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

Route25Text8:
	TX_ASM
	ld hl, Route25TrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

Route25Text9:
	TX_ASM
	ld hl, Route25TrainerHeader8
	call TalkToTrainer
	jp TextScriptEnd
	
;joenote - text for red battle
Route25TextRed:
	TX_ASM
	ld hl, Route25PrintText12
	call PrintText
;	ld a,[wBeatGymFlags]	;has the other special battles been beaten?
;	and $0F
;	sub $0F
;	jr nz, .specials_not_beaten
	ld hl, RedText_challenge	;else ask if you want to challenge
	call PrintText	;print the challenge text
	call YesNoChoice	;prompt a yes/no choice
	ld a, [wCurrentMenuItem]	;load the player choice
	and a	;check the player choice
	jr nz, .specials_not_beaten	;kick out if no chosen
	;otherwise begin loading battle
	ld hl, RedText_prebattle	;load pre battle text
	call PrintText	;print the pre battle text
	ld hl, wd72d;set the bits for triggering battle
	set 6, [hl]	;
	set 7, [hl]	;
	ld hl, RedTextVictorySpeech	;load text for when you win
	ld de, RedTextVictorySpeech	;load text for when you lose
	call SaveEndBattleTextPointers	;save the win/lose text
	ld a, $9
	ld [wGymLeaderNo], a	;set bgm to champion music
	ld a, OPP_SACHA	;load the trainer type
	ld [wCurOpponent], a	;set as the current opponent
	ld a, 1	;get the right roster
	ld [wTrainerNo], a
	xor a
	ld [hJoyHeld], a
	ld a, $3
	ld [wRoute25CurScript], a
	ld [wCurMapScript], a
	jp TextScriptEnd
.specials_not_beaten
	ld hl, RedText_decline
	call PrintText
	jp TextScriptEnd
	
BillSecretGarden:
	ld hl, GardenCoordsData	;load the table of coordinates defining the garden
	call ArePlayerCoordsInArray	;check player coordinates and set the carry flag if a match is found
	jr nc, .return	;leave if the carry flag is not set
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;everything checks out, so do stuff
	;generate an encounter if the random number adder is 0
	ld a, [hRandomAdd]
	and a
	jr nz, .return

	;make it shiny if random number subtracter is below 2 (that's 1 in 128 odds)
	ld a, [hRandomSub]
	cp 2
	jr nc, .noshiny
	ld a, [wFontLoaded]
	set 7, a 
	ld [wFontLoaded], a
.noshiny

	;load the pokemon level
	ld a, 5
	ld [wCurEnemyLVL], a

	;set the current opponent
	call Random
	and $07
	ld b, 0
	ld c, a
	ld hl, GardenList
	add hl, bc
	ld a, [hl]
	ld [wCurOpponent], a

	ld hl, wd72d;set the bits for triggering battle
	set 6, [hl]	;
	set 7, [hl]	;
	xor a
	ld [hJoyHeld], a
	jp TextScriptEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.return
	ret

GardenList:
	db PIKACHU
	db EEVEE
	db CLEFAIRY
	db BULBASAUR
	db SQUIRTLE
	db CHARMANDER
	db ABRA
	db PORYGON

GardenCoordsData:
		;Y,X
	db $00,$2F
	db $00,$2E
	db $00,$2D
	db $00,$2C
	db $ff

Route25BattleText1:
	TX_FAR _Route25BattleText1
	db "@"

Route25EndBattleText1:
	TX_FAR _Route25EndBattleText1
	db "@"

Route25AfterBattleText1:
	TX_FAR _Route25AfterBattleText1
	db "@"

Route25BattleText2:
	TX_FAR _Route25BattleText2
	db "@"

Route25EndBattleText2:
	TX_FAR _Route25EndBattleText2
	db "@"

Route25AfterBattleText2:
	TX_FAR _Route25AfterBattleText2
	db "@"

Route25BattleText3:
	TX_FAR _Route25BattleText3
	db "@"

Route25EndBattleText3:
	TX_FAR _Route25EndBattleText3
	db "@"

Route25AfterBattleText3:
	TX_FAR _Route25AfterBattleText3
	db "@"

Route25BattleText4:
	TX_FAR _Route25BattleText4
	db "@"

Route25EndBattleText4:
	TX_FAR _Route25EndBattleText4
	db "@"

Route25AfterBattleText4:
	TX_FAR _Route25AfterBattleText4
	db "@"

Route25BattleText5:
	TX_FAR _Route25BattleText5
	db "@"

Route25EndBattleText5:
	TX_FAR _Route25EndBattleText5
	db "@"

Route25AfterBattleText5:
	TX_FAR _Route25AfterBattleText5
	db "@"

Route25BattleText6:
	TX_FAR _Route25BattleText6
	db "@"

Route25EndBattleText6:
	TX_FAR _Route25EndBattleText6
	db "@"

Route25AfterBattleText6:
	TX_FAR _Route25AfterBattleText6
	db "@"

Route25BattleText7:
	TX_FAR _Route25BattleText7
	db "@"

Route25EndBattleText7:
	TX_FAR _Route25EndBattleText7
	db "@"

Route25AfterBattleText7:
	TX_FAR _Route25AfterBattleText7
	db "@"

Route25BattleText8:
	TX_FAR _Route25BattleText8
	db "@"

Route25EndBattleText8:
	TX_FAR _Route25EndBattleText8
	db "@"

Route25AfterBattleText8:
	TX_FAR _Route25AfterBattleText8
	db "@"

Route25BattleText9:
	TX_FAR _Route25BattleText9
	db "@"

Route25EndBattleText9:
	TX_FAR _Route25EndBattleText9
	db "@"

Route25AfterBattleText9:
	TX_FAR _Route25AfterBattleText9
	db "@"

Route25Text11:
	TX_FAR _Route25Text11
	db "@"

;joenote - dialogue for Red battle
Route25PrintText12:
	TX_FAR _Route25PrintText12
	db "@"
RedText_challenge:
	TX_FAR _RedText_challenge
	db "@"
RedText_prebattle:
	TX_FAR _RedText_prebattle
	db "@"
RedTextVictorySpeech:
	TX_FAR _RedTextVictorySpeech
	db "@"	
RedText_decline:
	TX_FAR _RedText_decline
	db "@"
