; tests if mon [wcf91] can learn move [wMoveNum]
CanLearnTM:
	ld a, [wcf91]
	ld [wd0b5], a
	call GetMonHeader
	ld hl, wMonHLearnset

	call SpecialMachineMove ;joenote - handle a pokemon that can learn machines not normally allowed (like surfing pikachu)
	
	ld a, [wMoveNum]
	call MachineMoveInC
	ld b, FLAG_TEST
	predef_jump FlagActionPredef

; converts TM/HM number in wd11e into move number
; HMs start at 51
TMToMove:
	ld a, [wd11e]
	dec a
	ld hl, TechnicalMachines
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wd11e], a
	ret

;takes a machine move in A, finds the corresponding arry bit offset, and puts that into C
MachineMoveInC:
	push hl
	ld b, a
	ld c, $0
	ld hl, TechnicalMachines
.findTMloop
	ld a, [hli]
	cp b
	jr z, .TMfoundLoop
	inc c
	jr .findTMloop
.TMfoundLoop
	pop hl
	ret

;let pikachu learn surf
;HL must equal wMonHLearnset and be called from CanLearnTM
SpecialMachineMove:
	call CheckGorgeousBox
	ret nz

	push hl
	ld a, [wcf91]
	ld b, a
	ld hl, SpecialMachineMoveList - 1
.loop
	inc hl
	ld a, [hli]
	cp $ff
	jr z, .ret_ff
	cp b
	jr nz, .loop
.end_loop
	ld a, [hl]
	pop hl

	call MachineMoveInC
	ld b, FLAG_SET
	predef_jump FlagActionPredef

.ret_ff
	pop hl
	and a
	ret
	
;ret z if the pokemon is holding a Gen 2 gorgeous box according to its catch rate
CheckGorgeousBox:
	push bc
	push hl
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1CatchRate
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hl]
	cp 168
	pop hl
	pop bc
	ret
	
SpecialMachineMoveList:
	db PIKACHU, SURF
	db DRAGONITE, FLY
	db $ff

GetTMMoves:
 	ld de, wMoveBuffer ; reusing from move relearner for tmhm move list
 	ld a, 0
 	ld b, a ; current move ID / counter
 .findTMloop
 	inc b
 	ld a, b
 	cp NUM_ATTACKS ; done if looked at all moves
 	jr z, .done
 
 	ld a, b
 	ld [wMoveNum], a
 	ld [wd11e], a
 	push de
 	push bc
 	predef CanLearnTM
 	ld a, c
 	and a ; can the pokemon learn the move?
 	pop bc
 	pop de
 	jr z, .cantLearn
 .canLearn
 	ld a, b
 	ld [de], a ; add move ID to list of learnable moves
 	inc de
 .cantLearn
 	ld a, b
 	jr .findTMloop
 .done
 	ld a, 0 ; terminator
 	ld [de], a
 	ret

INCLUDE "data/tms.asm"
