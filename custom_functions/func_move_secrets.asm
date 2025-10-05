
ImproveCatchRate:
	ld a, [wcf91]
	cp 5	;look for master through poke ball
	ret nc
	ld a, GLARE
	call CheckActiveMonMoves
	call c, .boost
	ld a, SPORE
	call CheckActiveMonMoves
	call c, .boost
	ld a, ROAR
	call CheckActiveMonMoves
	call c, .boost
	ld a, WHIRLWIND
	call CheckActiveMonMoves
	call c, .boost
	ret
.boost
	ld a, [wEnemyMonActualCatchRate]
	add 10
	jr nc, .next_boost
	ld a, 255
.next_boost
	ld [wEnemyMonActualCatchRate], a
	ret

CheckActiveMonMoves:
	ld b, a
	ld c, NUM_MOVES
	ld hl, wBattleMonMoves
.loop
	ld a, [hli]
	cp b
	jr z, .alreadyKnown ; found a match
	dec c
	jr nz, .loop
	and a
	ret
.alreadyKnown
	scf
	ret
	
