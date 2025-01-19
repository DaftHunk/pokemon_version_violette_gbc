SeafoamIslands4Script:
	call EnableAutoTextBoxDrawing
	ld hl, wFlags_0xcd60
	bit 7, [hl]
	res 7, [hl]
	jr z, .asm_465dc
	ld hl, Seafoam4HolesCoords
	call CheckBoulderCoords
	ret nc
	EventFlagAddress hl, EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE
	ld a, [wCoordIndex]
	cp $1
	jr nz, .asm_465b8
	SetEventReuseHL EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE
	ld a, HS_SEAFOAM_ISLANDS_B3F_BOULDER_1
	ld [wObjectToHide], a
	ld a, HS_SEAFOAM_ISLANDS_B4F_BOULDER_1
	ld [wObjectToShow], a
	jr .asm_465c4
.asm_465b8
	SetEventAfterBranchReuseHL EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE
	ld a, HS_SEAFOAM_ISLANDS_B3F_BOULDER_2
	ld [wObjectToHide], a
	ld a, HS_SEAFOAM_ISLANDS_B4F_BOULDER_2
	ld [wObjectToShow], a
.asm_465c4
	ld a, [wObjectToHide]
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, [wObjectToShow]
	ld [wMissableObjectIndex], a
	predef ShowObject
	jr .asm_465ed
.asm_465dc
	ld a, $a2
	ld [wDungeonWarpDestinationMap], a
	ld hl, Seafoam4HolesCoords
	call IsPlayerOnDungeonWarp
	ld a, [wd732]
	bit 4, a
	ret nz
.asm_465ed
	ld hl, SeafoamIslands4ScriptPointers
	ld a, [wSeafoamIslands4CurScript]
	jp CallFunctionInTable

Seafoam4HolesCoords:
	db $10,$03
	db $10,$06
	db $ff

SeafoamIslands4ScriptPointers:
	dw SeafoamIslands4Script0
	dw SeafoamIslands4Script1
	dw SeafoamIslands4Script2
	dw SeafoamIslands4Script3

; wispnote - Added a check for the righ bank size which executes
; a different JoyPad sequence to simulate the current.
SeafoamIslands4Script0:
SeafoamIslands4Script2:
;joenote - check if player entering/exiting via water warps
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	jr nz, .donewaterwarpcheck
	;check if just in front of the warp-out tiles (exiting)
	ld hl, Seafoam4WaterWarpOutArray
	call ArePlayerCoordsInArray
	jr c, .waterwarp_exiting
	;check if on the warp tiles (entering)
	ld hl, Seafoam4WaterWarpInArray
	call ArePlayerCoordsInArray
	jr c, .waterwarp_entering
	jr .donewaterwarpcheck
.waterwarp_exiting
	;do a scripted movement for exiting
	ld de, Seafoam4RLEMovementExitFromWater
	jr .simJoyPadFromBanksSeafoamIslands4
.waterwarp_entering
	;do a scripted movement for entering
	ld de, Seafoam4RLEMovementEnterFromWater
	ld hl, wFlags_D733
	res 2, [hl]
	jr .simJoyPadFromBanksSeafoamIslands4_noset
.donewaterwarpcheck

	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	ret z
	
	;check if this is script 2 stuff
	ld a, [wSeafoamIslands4CurScript]
	cp 2
	jp z, SeafoamIslands4Script2_stuff
	
	ld a, [wYCoord]
	cp $8
	jr nz, .checkEntryFromRightBank
	ld a, [wXCoord]
	cp $f
	ret nz
	jp .isEntryFromLeftBank
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; wispnote - Right Bank Check
.checkEntryFromRightBank
	cp $a
	ret nz
	ld a, [wXCoord]
	cp $17
	ret nz
	ld de, RLEMovementRightBank
	jp .simJoyPadFromBanksSeafoamIslands4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.isEntryFromLeftBank
	ld de, RLEMovement46632
.simJoyPadFromBanksSeafoamIslands4
	ld hl, wFlags_D733
	set 2, [hl]
.simJoyPadFromBanksSeafoamIslands4_noset
	ld hl, wSimulatedJoypadStatesEnd
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSeafoamIslands4CurScript], a
	ret

RLEMovement46632:
	db D_DOWN,6
	db D_RIGHT,5
	db D_DOWN,3
	db $ff

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; wispnote - JoyPad Sequence for Entry from the Right Bank Side
RLEMovementRightBank:
	db D_DOWN,6
	db D_LEFT,2
	db D_DOWN,1
	db $ff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;joenote - move space automatically if entering/exiting this map from the water warps
Seafoam4RLEMovementExitFromWater:
	db D_DOWN,1
	db $ff
Seafoam4RLEMovementEnterFromWater:
	db D_UP,2
	db $ff
;joenote - coordinate of the water spaces for handling warps
Seafoam4WaterWarpOutArray:	;y,x
	db $10,$14
	db $10,$15
	db $ff
Seafoam4WaterWarpInArray:	;y,x
	db $11,$14
	db $11,$15
	db $ff

SeafoamIslands4Script1:
SeafoamIslands4Script3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld a, $0
	ld [wSeafoamIslands4CurScript], a
	ret

;SeafoamIslands4Script2:	;joenote - kick this off from script 0 instead
;	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
;	ret z
SeafoamIslands4Script2_stuff:
	ld a, [wXCoord]
	cp $12
	jr z, .asm_4665e
	cp $13
	ld a, $0
	jr nz, .asm_4667b
	ld de, RLEData_4667f
	jr .asm_46661
.asm_4665e
	ld de, RLEData_46688
.asm_46661
	ld hl, wSimulatedJoypadStatesEnd
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	xor a
	ld [wSpriteStateData2 + $06], a
	ld hl, wd730
	set 7, [hl]
	ld hl, wFlags_D733
	set 2, [hl]
	ld a, $3
.asm_4667b
	ld [wSeafoamIslands4CurScript], a
	ret

; wispnote - Correct strong current's path after falling through 2nd boulder's hole.
RLEData_4667f:
	db D_DOWN,$06
	db D_RIGHT,$01
	db D_DOWN,$04
	db $FF

RLEData_46688:
	db D_DOWN,$06
	db D_RIGHT,$02
	db D_DOWN,$04
	db $FF

;SeafoamIslands4Script3:	;joenote - this is redundant, and can be combined with script 1
;	ld a, [wSimulatedJoypadStatesIndex]
;	and a
;	ret nz
;	ld a, $0
;	ld [wSeafoamIslands4CurScript], a
;	ret

SeafoamIslands4TextPointers:
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
