RocketHideout2Script:
	call EnableAutoTextBoxDrawing
	ld hl, RocketHideout2TrainerHeader0
	ld de, RocketHideout2ScriptPointers
	ld a, [wRocketHideout2CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRocketHideout2CurScript], a
	ret

RocketHideout2ScriptPointers:
	dw RocketHideout2Script0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw RocketHideout2Script3

RocketHideout2Script0:
	ld a, [wYCoord]
	ld b, a
	ld a, [wXCoord]
	ld c, a
	ld hl, RocketHideout2ArrowTilePlayerMovement
	call DecodeArrowMovementRLE
	cp $ff
	jp z, CheckFightingMapTrainers
	ld hl, wd736
	set 7, [hl]
	call StartSimulatingJoypadStates
	ld a, SFX_ARROW_TILES
	call PlaySound
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, $3
	ld [wCurMapScript], a
	ret

;format:
;db y,x
;dw pointer to movement
RocketHideout2ArrowTilePlayerMovement:
	db $9,$4
	dw RocketHideout2ArrowMovement1
	db $b,$4
	dw RocketHideout2ArrowMovement2
	db $f,$4
	dw RocketHideout2ArrowMovement3
	db $10,$4
	dw RocketHideout2ArrowMovement4
	db $13,$4
	dw RocketHideout2ArrowMovement1
	db $16,$4
	dw RocketHideout2ArrowMovement5
	db $e,$5
	dw RocketHideout2ArrowMovement6
	db $16,$6
	dw RocketHideout2ArrowMovement7
	db $18,$6
	dw RocketHideout2ArrowMovement8
	db $9,$8
	dw RocketHideout2ArrowMovement9
	db $c,$8
	dw RocketHideout2ArrowMovement10
	db $f,$8
	dw RocketHideout2ArrowMovement8
	db $13,$8
	dw RocketHideout2ArrowMovement9
	db $17,$8
	dw RocketHideout2ArrowMovement11
	db $e,$9
	dw RocketHideout2ArrowMovement12
	db $16,$9
	dw RocketHideout2ArrowMovement12
	db $9,$a
	dw RocketHideout2ArrowMovement13
	db $a,$a
	dw RocketHideout2ArrowMovement14
	db $f,$a
	dw RocketHideout2ArrowMovement15
	db $11,$a
	dw RocketHideout2ArrowMovement16
	db $13,$a
	dw RocketHideout2ArrowMovement17
	db $19,$a
	dw RocketHideout2ArrowMovement2
	db $e,$b
	dw RocketHideout2ArrowMovement18
	db $10,$b
	dw RocketHideout2ArrowMovement19
	db $12,$b
	dw RocketHideout2ArrowMovement12
	db $9,$c
	dw RocketHideout2ArrowMovement20
	db $b,$c
	dw RocketHideout2ArrowMovement21
	db $d,$c
	dw RocketHideout2ArrowMovement22
	db $11,$c
	dw RocketHideout2ArrowMovement23
	db $a,$d
	dw RocketHideout2ArrowMovement24
	db $c,$d
	dw RocketHideout2ArrowMovement25
	db $10,$d
	dw RocketHideout2ArrowMovement26
	db $12,$d
	dw RocketHideout2ArrowMovement27
	db $13,$d
	dw RocketHideout2ArrowMovement28
	db $16,$d
	dw RocketHideout2ArrowMovement29
	db $17,$d
	dw RocketHideout2ArrowMovement30
	db $11,$e
	dw RocketHideout2ArrowMovement31
	db $10,$f
	dw RocketHideout2ArrowMovement12
	db $e,$10
	dw RocketHideout2ArrowMovement32
	db $10,$10
	dw RocketHideout2ArrowMovement33
	db $12,$10
	dw RocketHideout2ArrowMovement34
	db $a,$11
	dw RocketHideout2ArrowMovement35
	db $b,$11
	dw RocketHideout2ArrowMovement36
	db $FF

;format: direction, count
;each list is read starting from the $FF and working backwards
RocketHideout2ArrowMovement1:
	db D_LEFT,$02
	db $FF

RocketHideout2ArrowMovement2:
	db D_RIGHT,$04
	db $FF

RocketHideout2ArrowMovement3:
	db D_UP,$04
	db D_RIGHT,$04
	db $FF

RocketHideout2ArrowMovement4:
	db D_UP,$04
	db D_RIGHT,$04
	db D_UP,$01
	db $FF

RocketHideout2ArrowMovement5:
	db D_LEFT,$02
	db D_UP,$03
	db $FF

RocketHideout2ArrowMovement6:
	db D_DOWN,$02
	db D_RIGHT,$04
	db $FF

RocketHideout2ArrowMovement7:
	db D_UP,$02
	db $FF

RocketHideout2ArrowMovement8:
	db D_UP,$04
	db $FF

RocketHideout2ArrowMovement9:
	db D_LEFT,$06
	db $FF

RocketHideout2ArrowMovement10:
	db D_UP,$01
	db $FF

RocketHideout2ArrowMovement11:
	db D_LEFT,$06
	db D_UP,$04
	db $FF

RocketHideout2ArrowMovement12:
	db D_DOWN,$02
	db $FF

RocketHideout2ArrowMovement13:
	db D_LEFT,$08
	db $FF

RocketHideout2ArrowMovement14:
	db D_LEFT,$08
	db D_UP,$01
	db $FF

RocketHideout2ArrowMovement15:
	db D_LEFT,$08
	db D_UP,$06
	db $FF

RocketHideout2ArrowMovement16:
	db D_UP,$02
	db D_RIGHT,$04
	db $FF

RocketHideout2ArrowMovement17:
	db D_UP,$02
	db D_RIGHT,$04
	db D_UP,$02
	db $FF

RocketHideout2ArrowMovement18:
	db D_DOWN,$02
	db D_RIGHT,$04
	db D_DOWN,$02
	db $FF

RocketHideout2ArrowMovement19:
	db D_DOWN,$02
	db D_RIGHT,$04
	db $FF

RocketHideout2ArrowMovement20:
	db D_LEFT,$0A
	db $FF

RocketHideout2ArrowMovement21:
	db D_LEFT,$0A
	db D_UP,$02
	db $FF

RocketHideout2ArrowMovement22:
	db D_LEFT,$0A
	db D_UP,$04
	db $FF

RocketHideout2ArrowMovement23:
	db D_UP,$02
	db D_RIGHT,$02
	db $FF

RocketHideout2ArrowMovement24:
	db D_RIGHT,$01
	db D_DOWN,$02
	db $FF

RocketHideout2ArrowMovement25:
	db D_RIGHT,$01
	db $FF

RocketHideout2ArrowMovement26:
	db D_DOWN,$02
	db D_RIGHT,$02
	db $FF

RocketHideout2ArrowMovement27:
	db D_DOWN,$02
	db D_LEFT,$02
	db $FF

RocketHideout2ArrowMovement28:
	db D_UP,$02
	db D_RIGHT,$04
	db D_UP,$02
	db D_LEFT,$03
	db $FF

RocketHideout2ArrowMovement29:
	db D_DOWN,$02
	db D_LEFT,$04
	db $FF

RocketHideout2ArrowMovement30:
	db D_LEFT,$06
	db D_UP,$04
	db D_LEFT,$05
	db $FF

RocketHideout2ArrowMovement31:
	db D_UP,$02
	db $FF

RocketHideout2ArrowMovement32:
	db D_UP,$01
	db $FF

RocketHideout2ArrowMovement33:
	db D_UP,$03
	db $FF

RocketHideout2ArrowMovement34:
	db D_UP,$05
	db $FF

RocketHideout2ArrowMovement35:
	db D_RIGHT,$01
	db D_DOWN,$02
	db D_LEFT,$04
	db $FF

RocketHideout2ArrowMovement36:
	db D_LEFT,$0A
	db D_UP,$02
	db D_LEFT,$05
	db $FF

RocketHideout2Script3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	jr nz, LoadSpinnerArrowTiles
	xor a
	ld [wJoyIgnore], a
	ld hl, wd736
	res 7, [hl]
	ld a, $0
	ld [wCurMapScript], a
	ret

LoadSpinnerArrowTiles:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - This ties the spin frame update to an external counter.
;			It will only get updated every 4 overworld updates (half that if in 60fps mode).
;			CopyVideoData only gets run 1 time as well, and it supplants 1 DelayFrame in OverworldLoop.
;			Now there are no wasted frames when this runs, and spin movement is now at full speed.
	push bc
	ld b, 2
	ld a, [wUnusedD721]
	bit 4, a
	jr z, .no60fps
	sla b
.no60fps
	ld c, b
	inc c
	ld a, [wSpinnerTileFrameCount]
	cp c
	jr c, .notgreater
	ld a, b
	ld [wSpinnerTileFrameCount], a
	jr .noadjust
.notgreater
	cp 1
	jr nc, .noadjust
	ld a, b
	ld [wSpinnerTileFrameCount], a
.noadjust
	pop bc
	ld a, [wSpinnerTileFrameCount]
	dec a
	ld [wSpinnerTileFrameCount], a
	ret nz
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, [wSpriteStateData1 + 2]
	srl a
	srl a
	ld hl, SpinnerPlayerFacingDirections
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld [wSpriteStateData1 + 2], a
	ld a, [wCurMapTileset]
	cp FACILITY
	ld hl, FacilitySpinnerArrows
	jr z, .asm_44ff6
	ld hl, GymSpinnerArrows
.asm_44ff6
	ld a, [wSimulatedJoypadStatesIndex]
	bit 0, a
	jr nz, .asm_45001
	ld de, $18
	add hl, de
.asm_45001
	ld a, $4	;update all four arrow tiles
	ld bc, $0
.asm_45006
	push af
	push hl
	push bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
;	call CopyVideoData

	;joenote - use a new function to update the tiles
	call CopySpinnerTiles

	pop bc
	ld a, $6
	add c
	ld c, a
	pop hl
	pop af
	dec a
	jr nz, .asm_45006
	call DelayFrame	;Delay a frame because CopySpinnerTiles does not do this like CopyVideoData
	ret

	
;DE = tile source address
;C = data length (not used)
;B = source bank (not used)
;HL = tile destination address
CopySpinnerTiles:
	di	;prevent vblank functions from running
	
	;back up destination address
	ld b, h
	ld c, l
	;back up stack pointer
	ld hl, sp + 0
	ld a, h
	ld [H_SPTEMP], a
	ld a, l
	ld [H_SPTEMP + 1], a
	;set stack pointer to source address
	ld h, d
	ld l, e
	ld sp, hl
	;restore destination address
	ld h, b
	ld l, c
	
	;Stack Pointer = tile source address
	;HL = tile destination address

	ld c, 8
.loop
	pop de ;copies the next 2 bytes of whatever the stack pointer is pointing to (the source address) to de
;wait if in mode 2 or mode 3
;HBLANK length (mode 0) is highly variable. Worst case scenario is 21 cycles.
;Can also write VRAM during OAM scan (mode 2) which is always 20 cycles.
;For more info about timing the HBLANK, see https://gbdev.io/guides/lyc_timing.html
.waitVRAM
	ldh a, [rSTAT]		;read from stat register to get the mode
	and %10				
	jr nz, .waitVRAM	
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	dec c
	jr nz, .loop

	;restore stack spointer
	ld a, [H_SPTEMP]
	ld h, a
	ld a, [H_SPTEMP + 1]
	ld l, a
	ld sp, hl
	
	ei	;re-enable vblank functions
	ret


MACRO spinner
; \1: source
; \2: offset (BANK() chokes on literals)
; \3: length
; \4: dest
	dw \1 + \2
	db \3, BANK(\1)
	dw \4
ENDM

;joenote - modified these spinner data sets for CopySpinnerTiles

FacilitySpinnerArrows:
FACILITY_SPINNER EQU $20 * $10
vFacilitySpinner EQU vTileset + FACILITY_SPINNER

	spinner SpinnerArrowAnimTiles, $00, 1, vFacilitySpinner
	spinner SpinnerArrowAnimTiles, $10, 1, vFacilitySpinner + $10
	spinner SpinnerArrowAnimTiles, $20, 1, vFacilitySpinner + $100
	spinner SpinnerArrowAnimTiles, $30, 1, vFacilitySpinner + $110
;	spinner Facility_GFX, FACILITY_SPINNER + $000, 1, vFacilitySpinner
;	spinner Facility_GFX, FACILITY_SPINNER + $010, 1, vFacilitySpinner + $10
;	spinner Facility_GFX, FACILITY_SPINNER + $100, 1, vFacilitySpinner + $100
;	spinner Facility_GFX, FACILITY_SPINNER + $110, 1, vFacilitySpinner + $110
	spinner SpinnerArrowAnimTiles, $40, 1, vFacilitySpinner
	spinner SpinnerArrowAnimTiles, $50, 1, vFacilitySpinner + $10
	spinner SpinnerArrowAnimTiles, $60, 1, vFacilitySpinner + $100
	spinner SpinnerArrowAnimTiles, $70, 1, vFacilitySpinner + $110

GymSpinnerArrows:
GYM_SPINNER EQU $3c * $10
vGymSpinner EQU vTileset + GYM_SPINNER

	spinner SpinnerArrowAnimTiles, $10, 1, vGymSpinner
	spinner SpinnerArrowAnimTiles, $30, 1, vGymSpinner + $10
	spinner SpinnerArrowAnimTiles, $00, 1, vGymSpinner + $100
	spinner SpinnerArrowAnimTiles, $20, 1, vGymSpinner + $110
;	spinner Gym_GFX, GYM_SPINNER + $000, 1, vGymSpinner
;	spinner Gym_GFX, GYM_SPINNER + $010, 1, vGymSpinner + $10
;	spinner Gym_GFX, GYM_SPINNER + $100, 1, vGymSpinner + $100
;	spinner Gym_GFX, GYM_SPINNER + $110, 1, vGymSpinner + $110
	spinner SpinnerArrowAnimTiles, $50, 1, vGymSpinner
	spinner SpinnerArrowAnimTiles, $70, 1, vGymSpinner + $10
	spinner SpinnerArrowAnimTiles, $40, 1, vGymSpinner + $100
	spinner SpinnerArrowAnimTiles, $60, 1, vGymSpinner + $110

SpinnerPlayerFacingDirections:
; This isn't the order of the facing directions.  Rather, it's a list of
; the facing directions that come next. For example, when the player is
; facing down (00), the next facing direction is left (08).
	db $08 ; down -> left
	db $0C ; up -> right
	db $04 ; left -> up
	db $00 ; right -> down

; these tiles are the animation for the tiles that push the player in dungeons like Rocket HQ
;joenote - the tiles from Gym_GFX have been added to this file to avoid needing to read from a different bank
SpinnerArrowAnimTiles:
	INCBIN "gfx/tiles/spinner_arrow.2bpp"

RocketHideout2TextPointers:
	dw RocketHideout2Text1
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText

RocketHideout2TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_ROCKET_HIDEOUT_B2F_TRAINER_0
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCKET_HIDEOUT_B2F_TRAINER_0
	dw RocketHideout2BattleText2 ; TextBeforeBattle
	dw RocketHideout2AfterBattleTxt2 ; TextAfterBattle
	dw RocketHideout2EndBattleText2 ; TextEndBattle
	dw RocketHideout2EndBattleText2 ; TextEndBattle

	db $ff

RocketHideout2Text1:
	TX_ASM
	ld hl, RocketHideout2TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

RocketHideout2BattleText2:
	TX_FAR _RocketHideout2BattleText2
	db "@"

RocketHideout2EndBattleText2:
	TX_FAR _RocketHideout2EndBattleText2
	db "@"

RocketHideout2AfterBattleTxt2:
	TX_FAR _RocketHideout2AfterBattleTxt2
	db "@"
