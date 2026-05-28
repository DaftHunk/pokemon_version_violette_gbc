SubstituteEffect_:
	ld c, 50
	call DelayFrames
	ld hl, wBattleMonMaxHP
	ld de, wPlayerSubstituteHP
	ld bc, wPlayerBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .notEnemy
	ld hl, wEnemyMonMaxHP
	ld de, wEnemySubstituteHP
	ld bc, wEnemyBattleStatus2
.notEnemy
	ld a, [bc]
	bit HAS_SUBSTITUTE_UP, a ; user already has substitute?
	jr nz, .alreadyHasSubstitute
; quarter health to remove from user
; assumes max HP is 1023 or lower
	push bc
	ld a, [hli]
	ld b, [hl]
	srl a
	rr b
	srl a
	rr b ; max hp / 4
	push de
	ld de, wBattleMonHP - wBattleMonMaxHP
	add hl, de ; point hl to current HP low byte
	pop de
	ld a, b
	ld [de], a ; save copy of HP to subtract in ccd7/ccd8 [how much HP substitute has]
	ld a, [hld]
; subtract [max hp / 4] to current HP
	sub b
	ld d, a
	ld a, [hl]
	sbc 0
	pop bc
	jr c, .notEnoughHP ; underflow means user would be left with negative health
                           ; bug: since it only branches on carry, it will possibly leave user with 0 HP
;;;;joenote - fix the bug to also check for exactly 0 hp
	inc d ;d is still holding the hp loss value from substitute. increment it by 1.
	dec d ;decrement it by one to change it back
	jr z, .notEnoughHP ; inc and dec set z if they result in zero values, if so then jump to the fail
;;;;
.userHasZeroOrMoreHP
	ldi [hl], a ; save resulting HP after subtraction into current HP
	ld [hl], d
	ld h, b
	ld l, c
	set HAS_SUBSTITUTE_UP, [hl]
	ld a, [wOptions]
	bit BIT_BATTLE_ANIMATION, a ; battle animation is enabled?
	ld hl, PlayCurrentMoveAnimation
	ld b, BANK(PlayCurrentMoveAnimation)
	jr z, .animationEnabled
	ld hl, AnimationSubstitute
	ld b, BANK(AnimationSubstitute)
.animationEnabled
	call Bankswitch ; jump to routine depending on animation setting
	ld hl, SubstituteText
	call PrintText
	jpab DrawHUDsAndHPBars
.alreadyHasSubstitute
	ld hl, HasSubstituteText
	jr .printText
.notEnoughHP
	ld hl, TooWeakSubstituteText
.printText
	jp PrintText

_AttackSubstitute:
	ld hl, wTempExpFlags	;joenote - only print text if bit 0 of wTempExpFlags is cleared
	bit 0, [hl]
	ld hl, SubstituteTookDamageText
	call z, PrintText
; values for player turn
	ld de, wEnemySubstituteHP
	ld bc, wEnemyBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .applyDamageToSubstitute
; values for enemy turn
	ld de, wPlayerSubstituteHP
	ld bc, wPlayerBattleStatus2
.applyDamageToSubstitute
	ld hl, wDamage
	ld a, [hli]
	and a
	jr nz, .substituteBroke ; damage > 0xFF always breaks substitutes
; subtract damage from HP of substitute
	ld a, [de]
	sub [hl]
	ld [de], a
;	ret nc		;joenote - slight rewrite
	jr c, .substituteBroke
	;;;;;;;;;;;;;;;;;;;;;;
	;joenote - get original turn back
	push af
	ld a, [wMiscsFlags2]
	ld [H_WHOSETURN], a
	pop af
	;;;;;;;;;;;;;;;;;;;;;;
	ret
.substituteBroke
; If the target's Substitute breaks, wDamage isn't updated with the amount of HP
; the Substitute had before being attacked.
	ld h, b
	ld l, c
	res HAS_SUBSTITUTE_UP, [hl] ; unset the substitute bit
	ld hl, SubstituteBrokeText
	call PrintText
; flip whose turn it is for the next function call
	ld a, [H_WHOSETURN]
	xor $01
	ld [H_WHOSETURN], a
	callab HideSubstituteShowMonAnim ; animate the substitute breaking
; flip the turn back to the way it was
	ld a, [H_WHOSETURN]
	xor $01
	ld [H_WHOSETURN], a
	ld hl, wPlayerMoveEffect ; value for player's turn
	and a
	jr z, .nullifyEffect
	ld hl, wEnemyMoveEffect ; value for enemy's turn
.nullifyEffect
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not nullify certain effects
	ld a, [hl]
	cp HYPER_BEAM_EFFECT
	jr z, .skipnullify
	cp EXPLODE_EFFECT
	jr z, .skipnullify
	cp RECOIL_EFFECT
	jr z, .skipnullify
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	xor a
	ld [hl], a ; zero the effect of the attacker's move
.skipnullify
	ret
	
SubstituteTookDamageText:
	TX_FAR _SubstituteTookDamageText
	db "@"

SubstituteBrokeText:
	TX_FAR _SubstituteBrokeText
	db "@"

SubstituteText:
	TX_FAR _SubstituteText
	db "@"

HasSubstituteText:
	TX_FAR _HasSubstituteText
	db "@"

TooWeakSubstituteText:
	TX_FAR _TooWeakSubstituteText
	db "@"
