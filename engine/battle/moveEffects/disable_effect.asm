DisableEffect_:
	callab MoveHitTest
	ld a, [wMoveMissed]
	and a
	jp nz, .moveMissed
	ld de, wEnemyDisabledMove
	ld hl, wEnemyMonMoves
	ld a, [H_WHOSETURN]
	and a
	jr z, .disableEffect
	ld de, wPlayerDisabledMove
	ld hl, wBattleMonMoves
.disableEffect
; no effect if target already has a move disabled
	ld a, [de]
	and a
	jr nz, .moveMissed
.pickMoveToDisable
	push hl		;preserve wBattleMonMoves/wEnemyMonMoves
	callab BattleRandom
	and $3
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	pop hl		;get back wBattleMonMoves/wEnemyMonMoves
	and a
	jr z, .pickMoveToDisable ; loop until a non-00 move slot is found
	ld [wd11e], a ; store move number
	push hl		;preserve wBattleMonMoves/wEnemyMonMoves
	ld a, [H_WHOSETURN]
	and a
	ld hl, wBattleMonPP
	jr nz, .enemyTurn
;	ld a, [wLinkState]	;joenote - non-link enemy mons now have PP, so always run checks during disable effect
;	cp LINK_STATE_BATTLING
;	pop hl ; wEnemyMonMoves
;	jr nz, .playerTurnNotLinkBattle
; .playerTurnLinkBattle
;	push hl
	ld hl, wEnemyMonPP
.enemyTurn
	push hl		;preserve wEnemymonPP/wBattleMonPP
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	and $3f
	pop hl ;get back wBattleMonPP or wEnemyMonPP
	jr z, .moveMissedPopHL ; nothing to do if all moves have no PP left
	add hl, bc
	ld a, [hl]
	pop hl		;get back wBattleMonMoves/wEnemyMonMoves
	and a
	jr z, .pickMoveToDisable ; pick another move if this one had 0 PP
;.playerTurnNotLinkBattle
; non-link battle enemies have unlimited PP so the previous checks aren't needed
	callab BattleRandom
	and $7
	inc a ; 1-8 turns disabled

	;joenote - will handle this a different way
	;change the lower nybble (a = 0000xxxx) from [1,2,3,4,5,6,7,8] to instead be [9,A,B,C,D,E,F,0]
	add 8
	res 4, a	;clear bit in case nybble overflows from F to 0

	inc c ; move 1-4 will be disabled
	swap c
	add c ; map disabled move to high nybble of wEnemyDisabledMove / wPlayerDisabledMove
	ld [de], a
	callab PlayCurrentMoveAnimation2
	ld hl, wPlayerDisabledMoveNumber
	ld a, [H_WHOSETURN]
	and a
	jr nz, .printDisableText
	inc hl ; else increment to wEnemyDisabledMoveNumber
.printDisableText
	ld a, [wd11e] ; move number
	ld [hl], a
	callab GetMoveName
	ld hl, MoveWasDisabledText
	jp PrintText
.moveMissedPopHL
	pop hl
.moveMissed
	jpab PrintButItFailedText_

MoveWasDisabledText:
	TX_FAR _MoveWasDisabledText
	db "@"