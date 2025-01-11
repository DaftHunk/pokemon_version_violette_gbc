ConfusionSideEffect_:
	callab CheckTargetSubstitute	;joenote - return if opponent has substitute up
	ret nz
	callab BattleRandom
	cp $19 ; ~10% chance
	ret nc
	jr ConfusionSideEffectSuccess

ConfusionEffect_:
	callab CheckTargetSubstitute
	jr nz, ConfusionEffectFailed
	callab MoveHitTest
	ld a, [wMoveMissed]
	and a
	jr nz, ConfusionEffectFailed

ConfusionSideEffectSuccess:
	ld a, [H_WHOSETURN]
	and a
	ld hl, wEnemyBattleStatus1
	ld bc, wEnemyConfusedCounter
	ld a, [wPlayerMoveEffect]
	jr z, .confuseTarget
	ld hl, wPlayerBattleStatus1
	ld bc, wPlayerConfusedCounter
	ld a, [wEnemyMoveEffect]
.confuseTarget
	bit CONFUSED, [hl] ; is mon confused?
	jr nz, ConfusionEffectFailed
	set CONFUSED, [hl] ; mon is now confused
	push af
	callab BattleRandom
	and $3
	inc a
	inc a
	ld [bc], a ; confusion status will last 2-5 turns
	pop af
	cp CONFUSION_SIDE_EFFECT
	callab PlayCurrentMoveAnimation2
	ld hl, BecameConfusedText
	jp PrintText

BecameConfusedText:
	TX_FAR _BecameConfusedText
	db "@"

ConfusionEffectFailed:
	cp CONFUSION_SIDE_EFFECT
	ret z
	ld c, 50
	callab DelayFrames
	jpab ConditionalPrintButItFailed
    