SeafoamIslands5Script:
	call EnableAutoTextBoxDrawing
	ld a, [wSeafoamIslands5CurScript]
	ld hl, SeafoamIslands5ScriptPointers
	jp CallFunctionInTable

SeafoamIslands5Script_467a5:
	xor a
	ld [wSeafoamIslands5CurScript], a
	ld [wJoyIgnore], a
	ret

SeafoamIslands5ScriptPointers:
	dw SeafoamIslands5Script0
	dw SeafoamIslands5Script1
	dw SeafoamIslands5Script2
	dw SeafoamIslands5Script3
	dw SeafoamIslands5Script4

SeafoamIslands5Script4:
	ld a, [wIsInBattle]
	cp $ff
	jr z, SeafoamIslands5Script_467a5
	call EndTrainerBattle
	ld a, $0
	ld [wSeafoamIslands5CurScript], a
	ret

SeafoamIslands5Script0:
;joenote - check if player entering via water warps, and allow the scripted movement if so
	ld hl, wFlags_D733
	bit 2, [hl]
	jr nz, .waterwarp_entering
	;next behavior is different depending on if events are set
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	jr nz, .waterwarp_entering
	;check if just in front of the warp-out tiles (exiting)
	ld hl, Seafoam5WaterWarpOutArray
	call ArePlayerCoordsInArray
	jr nc, .donewaterwarpcheck
	;do a scripted movement for exiting
	ld hl, wFlags_D733
	set 2, [hl]
	ld de, Seafoam5RLEMovementExitFromWater
	ld hl, wSimulatedJoypadStatesEnd
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSeafoamIslands5CurScript], a
	ret
.donewaterwarpcheck
	
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	ret z
.waterwarp_entering
	ld hl, .Coords
	call ArePlayerCoordsInArray
	ret nc
	ld a, [wCoordIndex]
	cp $3
	jr nc, .asm_467e6
	ld a, NPC_MOVEMENT_UP
	ld [wSimulatedJoypadStatesEnd + 1], a
	ld a, 2
	jr .asm_467e8
.asm_467e6
	ld a, 1
.asm_467e8
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	ld hl, wFlags_D733
	res 2, [hl]
	ld a, $1
	ld [wSeafoamIslands5CurScript], a
	ret

.Coords
	db $11,$14
	db $11,$15
	db $10,$14
	db $10,$15
	db $FF

;joenote - move space automatically if entering/exiting this map from the water warps
Seafoam5RLEMovementExitFromWater:
	db D_DOWN,1
	db $ff
;joenote - coordinate of the water spaces for handling warps
Seafoam5WaterWarpOutArray:	;y,x
	db $10,$14
	db $10,$15
	db $ff

SeafoamIslands5Script1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	ld [wSeafoamIslands5CurScript], a
	ret

SeafoamIslands5Script2:
	CheckBothEventsSet EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE
	ld a, $0
	jr z, .asm_46849
	ld hl, .Coords
	call ArePlayerCoordsInArray
	ld a, $0
	jr nc, .asm_46849
	ld a, [wCoordIndex]
	cp $1
	jr nz, .asm_46837
	ld de, RLEMovementData_46859
	jr .asm_4683a
.asm_46837
	ld de, RLEMovementData_46852
.asm_4683a
	ld hl, wSimulatedJoypadStatesEnd
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
.asm_46849
	ld [wSeafoamIslands5CurScript], a
	ret

.Coords
	db $0E,$04
	db $0E,$05
	db $FF

RLEMovementData_46852:
	db D_UP,$03
	db D_RIGHT,$02
	db D_UP,$01
	db $FF

RLEMovementData_46859:
	db D_UP,$03
	db D_RIGHT,$03
	db D_UP,$01
	db $FF

SeafoamIslands5Script3:
	ld a, [wSimulatedJoypadStatesIndex]
	ld b, a
	cp $1
	call z, SeaFoamIslands5Script_46872
	ld a, b
	and a
	ret nz
	ld a, $0
	ld [wSeafoamIslands5CurScript], a
	ret

SeaFoamIslands5Script_46872:
	xor a
	ld [wWalkBikeSurfState], a
	ld [wWalkBikeSurfStateCopy], a
	jp ForceBikeOrSurf

SeafoamIslands5TextPointers:
	dw BoulderText
	dw BoulderText
	dw ArticunoText
	dw SeafoamIslands5Text4
	dw SeafoamIslands5Text5

ArticunoTrainerHeader:
	dbEventFlagBit EVENT_BEAT_ARTICUNO
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ARTICUNO
	dw ArticunoBattleText ; TextBeforeBattle
	dw ArticunoBattleText ; TextAfterBattle
	dw ArticunoBattleText ; TextEndBattle
	dw ArticunoBattleText ; TextEndBattle

	db $ff

ArticunoText:
	TX_ASM
	ld hl, ArticunoTrainerHeader
	;make the shiny attract cheat work on static wild encounters
	push hl
	push bc
	callba ShinyAttractFunction
	pop bc
	pop hl
	call TalkToTrainer
	ld a, $4
	ld [wSeafoamIslands5CurScript], a
	jp TextScriptEnd

ArticunoBattleText:
	TX_FAR _ArticunoBattleText
	TX_ASM
	ld a, ARTICUNO
	call PlayCry
	call WaitForSoundToFinish
	ld a, 8
	ld [wGymLeaderNo], a	; use gym leader music
	jp TextScriptEnd

SeafoamIslands5Text4:
	TX_FAR _SeafoamIslands5Text4
	db "@"

SeafoamIslands5Text5:
	TX_FAR _SeafoamIslands5Text5
	db "@"
