JumpMoveEffect:
	call _JumpMoveEffect
	ld b, $1
	ret

_JumpMoveEffect:
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerMoveEffect]
	jr z, .next1
	ld a, [wEnemyMoveEffect]
.next1
	dec a ; subtract 1, there is no special effect for 00
	add a ; x2, 16bit pointers
	ld hl, MoveEffectPointerTable
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl ; jump to special effect handler

INCLUDE "data/moves/effects_pointers.asm"

SleepEffect:
	ld de, wEnemyMonStatus
	ld bc, wEnemyBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jp z, .sleepEffect
	ld de, wBattleMonStatus
	ld bc, wPlayerBattleStatus2	
.sleepEffect
	;joenote - should not be able to sleep an opponent with substitute up
	call CheckTargetSubstitute
	jr nz, .didntAffect
;joenote: moved later to avoid recharge+sleep glitch. the opponent should not have a status effect
;	ld a, [bc]
;	bit NEEDS_TO_RECHARGE, a ; does the target need to recharge? (hyper beam)
;	res NEEDS_TO_RECHARGE, a ; target no longer needs to recharge
;	ld [bc], a
;	jr nz, .setSleepCounter ; if the target had to recharge, all hit tests will be skipped
	                        ; including the event where the target already has another status
	ld a, [de]
	;ld b, a	;joenote - no need to overwrite b
	and $7
	jr z, .notAlreadySleeping ; can't affect a mon that is already asleep
	ld hl, AlreadyAsleepText
	jp PrintText
.notAlreadySleeping
	ld a, [de];ld a, b
	and a
	jr nz, .didntAffect ; can't affect a mon that is already statused
	push de
	push bc	;joenote - need to preserve bc register
	call MoveHitTest ; apply accuracy tests
	pop bc
	pop de
	ld a, [wMoveMissed]
	and a
	jr nz, .didntAffect
	;joenote - check for sleep clause
	call HandleSlpFrzClause
	jr nz, .didntAffect
;;;;;joenote: recharge hyper beam if fallen asleep
	ld a, [bc]
	res NEEDS_TO_RECHARGE, a ; target no longer needs to recharge
	ld [bc], a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.setSleepCounter
; set target's sleep counter to a random number between 1 and 7
	call BattleRandom
	and $7
	;joenote - sleep for at least +1 count since attacks can now happen on wakeup
	;also made this more efficient
	cp $2
	jr c, .setSleepCounter
	ld [de], a
	call PlayCurrentMoveAnimation2
	ld hl, FellAsleepText
	jp PrintText
.didntAffect
	jp PrintDidntAffectText

FellAsleepText:
	TX_FAR _FellAsleepText
	db "@"

AlreadyAsleepText:
	TX_FAR _AlreadyAsleepText
	db "@"

PoisonEffect:
	ld hl, wEnemyMonStatus
	ld de, wPlayerMoveEffect
	ld a, [H_WHOSETURN]
	and a
	jr z, .poisonEffect
	ld hl, wBattleMonStatus
	ld de, wEnemyMoveEffect
.poisonEffect
	call CheckTargetSubstitute
	jr nz, .noEffect ; can't poison a substitute target
	ld a, [hli]
	ld b, a
	and a
	jr nz, .noEffect ; miss if target is already statused
	ld a, [hli]
	cp POISON ; can't poison a poison-type target
	jr z, .noEffect
	ld a, [hld]
	cp POISON ; can't poison a poison-type target
	jr z, .noEffect
	ld a, [de]
	cp POISON_SIDE_EFFECT1
	ld b, $34 ; ~20% chance of poisoning
	jr z, .sideEffectTest
	cp POISON_SIDE_EFFECT2
	ld b, $67 ; ~40% chance of poisoning
	jr z, .sideEffectTest
	push hl
	push de
	call MoveHitTest ; apply accuracy tests
	pop de
	pop hl
	ld a, [wMoveMissed]
	and a
	jr nz, .didntAffect
	jr .inflictPoison
.sideEffectTest
	call BattleRandom
	cp b ; was side effect successful?
	ret nc
.inflictPoison
	dec hl
	set 3, [hl] ; mon is now poisoned
	push de
	dec de
	ld a, [H_WHOSETURN]
	and a
	ld b, ANIM_C7
	ld hl, wPlayerBattleStatus3
	ld a, [de]
	ld de, wPlayerToxicCounter
	jr nz, .ok
	ld b, ANIM_A9
	ld hl, wEnemyBattleStatus3
	ld de, wEnemyToxicCounter
.ok
	cp TOXIC
	jr nz, .normalPoison ; done if move is not Toxic
	set BADLY_POISONED, [hl] ; else set Toxic battstatus
	xor a
	ld [de], a
	ld hl, BadlyPoisonedText
	jr .continue
.normalPoison
	ld hl, PoisonedText
.continue
	pop de
	ld a, [de]
	cp POISON_EFFECT
	jr z, .regularPoisonEffect
	ld a, b
	call PlayBattleAnimation2
	jp PrintText
.regularPoisonEffect
	call PlayCurrentMoveAnimation2
	jp PrintText
.noEffect
	ld a, [de]
	cp POISON_EFFECT
	ret nz
.didntAffect
	ld c, 50
	call DelayFrames
	jp PrintDidntAffectText

PoisonedText:
	TX_FAR _PoisonedText
	db "@"

BadlyPoisonedText:
	TX_FAR _BadlyPoisonedText
	db "@"

DrainHPEffect:
	jpab DrainHPEffect_

ExplodeEffect:
	ld hl, wBattleMonHP
	ld de, wPlayerBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .faintUser
	ld hl, wEnemyMonHP
	ld de, wEnemyBattleStatus2
.faintUser
	xor a
	ld [hli], a ; set the mon's HP to 0
	ld [hli], a
	inc hl
	ld [hl], a ; set mon's status to 0
	ld a, [de]
	res SEEDED, a ; clear mon's leech seed status
	ld [de], a
	ret

FreezeBurnParalyzeEffect:
	xor a
	ld [wAnimationType], a
	call CheckTargetSubstitute ; test bit 4 of d063/d068 flags [target has substitute flag]
	ret nz ; return if they have a substitute, can't effect them
	ld a, [H_WHOSETURN]
	and a
	jp nz, opponentAttacker
	ld a, [wEnemyMonStatus]
	and a
	jp nz, CheckDefrost ; can't inflict status if opponent is already statused
	ld a, [wPlayerMoveType]
	ld b, a
	ld a, [wEnemyMonType1]
	cp b ; do target type 1 and move type match?
	ret z  ; return if they match (an ice move can't freeze an ice-type, body slam can't paralyze a normal-type, etc.)
	ld a, [wEnemyMonType2]
	cp b ; do target type 2 and move type match?
	ret z  ; return if they match
	ld a, [wPlayerMoveEffect]
	cp PARALYZE_SIDE_EFFECT1 + 1 ; 10% status effects are 04, 05, 06 so 07 will set carry for those
	ld b, $1a ; 0x1A/0x100 or 26/256 = 10.2%~ chance
	jr c, .next1 ; branch ahead if this is a 10% chance effect..
	ld b, $4d ; else use 0x4D/0x100 or 77/256 = 30.1%~ chance
	sub $1e ; subtract $1E to map to equivalent 10% chance effects
.next1
	push af
	call BattleRandom ; get random 8bit value for probability test
	cp b
	pop bc
	ret nc ; do nothing if random value is >= 1A or 4D [no status applied]
	ld a, b ; what type of effect is this?
	cp BURN_SIDE_EFFECT1
	jr z, .burn
	cp FREEZE_SIDE_EFFECT
	jr z, .freeze
; .paralyze
	ld a, 1 << PAR
	ld [wEnemyMonStatus], a
	call QuarterSpeedDueToParalysis ; quarter speed of affected mon
	ld a, ANIM_A9
	call PlayBattleAnimation
	jp PrintMayNotAttackText ; print paralysis text
.burn
	ld a, 1 << BRN
	ld [wEnemyMonStatus], a
	call HalveAttackDueToBurn ; halve attack of affected mon
	ld a, ANIM_A9
	call PlayBattleAnimation
	ld hl, BurnedText
	jp PrintText
.freeze
	;joenote - check for freeze clause
	call HandleSlpFrzClause
	ret c	;no effect if opposing team has a frozen 'mon
	call ClearHyperBeam ; resets hyper beam (recharge) condition from target
	ld a, 1 << FRZ
	ld [wEnemyMonStatus], a
	ld a, ANIM_A9
	call PlayBattleAnimation
	ld hl, FrozenText
	jp PrintText
opponentAttacker:
	ld a, [wBattleMonStatus] ; mostly same as above with addresses swapped for opponent
	and a
	jp nz, CheckDefrost
	ld a, [wEnemyMoveType]
	ld b, a
	ld a, [wBattleMonType1]
	cp b
	ret z
	ld a, [wBattleMonType2]
	cp b
	ret z
	ld a, [wEnemyMoveEffect]
	cp PARALYZE_SIDE_EFFECT1 + 1
	ld b, $1a
	jr c, .next1
	ld b, $4d
	sub $1e
.next1
	push af
	call BattleRandom
	cp b
	pop bc
	ret nc
	ld a, b
	cp BURN_SIDE_EFFECT1
	jr z, .burn
	cp FREEZE_SIDE_EFFECT
	jr z, .freeze
	ld a, 1 << PAR
	ld [wBattleMonStatus], a
	call QuarterSpeedDueToParalysis
	jp PrintMayNotAttackText
.burn
	ld a, 1 << BRN
	ld [wBattleMonStatus], a
	call HalveAttackDueToBurn
	ld hl, BurnedText
	jp PrintText
.freeze
	;joenote - check for freeze clause
	call HandleSlpFrzClause
	ret c	;no effect if opposing team has a frozen 'mon
; hyper beam bits aren't reset for opponent's side
	call ClearHyperBeam ; joenote - adding this to prevent an infinite loop if frozen before recharging
	ld a, 1 << FRZ
	ld [wBattleMonStatus], a
	ld hl, FrozenText
	jp PrintText

BurnedText:
	TX_FAR _BurnedText
	db "@"

FrozenText:
	TX_FAR _FrozenText
	db "@"

CheckDefrost:
; any fire-type move that has a chance inflict burn (all but Fire Spin) will defrost a frozen target
	and 1 << FRZ ; are they frozen?
	ret z ; return if so
	ld a, [H_WHOSETURN]
	and a
	jr nz, .opponent
	;player [attacker]
	ld a, [wPlayerMoveType]
	sub FIRE
	ret nz ; return if type of move used isn't fire
	ld [wEnemyMonStatus], a ; set opponent status to 00 ["defrost" a frozen monster]
	ld hl, wEnemyMon1Status
	ld a, [wEnemyMonPartyPos]
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	xor a
	ld [hl], a ; clear status in roster
	ld hl, FireDefrostedText
	jr .common
.opponent
	ld a, [wEnemyMoveType] ; same as above with addresses swapped
	sub FIRE
	ret nz
	ld [wBattleMonStatus], a
	ld hl, wPartyMon1Status
	ld a, [wPlayerMonNumber]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	xor a
	ld [hl], a
	ld hl, FireDefrostedText
.common
	jp PrintText

FireDefrostedText:
	TX_FAR _FireDefrostedText
	db "@"

StatModifierUpEffect:
	ld hl, wPlayerMonStatMods
	ld de, wPlayerMoveEffect
	ld a, [H_WHOSETURN]
	and a
	jr z, .statModifierUpEffect
	ld hl, wEnemyMonStatMods
	ld de, wEnemyMoveEffect
.statModifierUpEffect
	ld a, [de]
	sub ATTACK_UP1_EFFECT
	cp EVASION_UP1_EFFECT + $3 - ATTACK_UP1_EFFECT ; covers all +1 effects
	jr c, .incrementStatMod
	sub ATTACK_UP2_EFFECT - ATTACK_UP1_EFFECT ; map +2 effects to equivalent +1 effect
.incrementStatMod
	ld c, a
	ld b, $0
	inc a ;joenote - backup the address offset for the stat mod 
	ld [wUnusedD71B], a	;joenote - backup the address offset for the stat mod
	add hl, bc
	ld b, [hl]
	inc b ; increment corresponding stat mod
	ld a, $d
	cp b ; can't raise stat past +6 ($d or 13)
	jp c, PrintNothingHappenedText
	ld a, [de]
	cp ATTACK_UP1_EFFECT + $8 ; is it a +2 effect?
	jr c, .ok
	inc b ; if so, increment stat mod again
	ld a, $d
	cp b ; unless it's already +6
	jr nc, .ok
	ld b, a
.ok
	ld [hl], b
	ld a, c
	cp $4
	jr nc, UpdateStatDone ; jump if mod affected is evasion/accuracy
	push hl
	ld hl, wBattleMonAttack + 1
	ld de, wPlayerMonUnmodifiedAttack
	ld a, [H_WHOSETURN]
	and a
	jr z, .pointToStats
	ld hl, wEnemyMonAttack + 1
	ld de, wEnemyMonUnmodifiedAttack
.pointToStats
	push bc
	sla c
	ld b, $0
	add hl, bc ; hl = modified stat
	ld a, c
	add e
	ld e, a
	jr nc, .checkIf999
	inc d ; de = unmodified (original) stat
.checkIf999
	pop bc
	ld a, [hld]
	sub 999 % $100 ; check if stat is already 999
	jr nz, .recalculateStat
	ld a, [hl]
	sbc 999 / $100
	jp z, RestoreOriginalStatModifier
.recalculateStat ; recalculate affected stat
                 ; paralysis and burn penalties, as well as badge boosts are ignored
	push hl
	push bc
	ld hl, StatModifierRatios
	dec b
	sla b
	ld c, b
	ld b, $0
	add hl, bc
	pop bc
	xor a
	ld [H_MULTIPLICAND], a
	ld a, [de]
	ld [H_MULTIPLICAND + 1], a
	inc de
	ld a, [de]
	ld [H_MULTIPLICAND + 2], a
	ld a, [hli]
	ld [H_MULTIPLIER], a
	call Multiply
	ld a, [hl]
	ld [H_DIVISOR], a
	ld b, $4
	call Divide
	pop hl
; cap at 999
	ld a, [H_PRODUCT + 3]
	sub 999 % $100
	ld a, [H_PRODUCT + 2]
	sbc 999 / $100
	jp c, UpdateStat
	ld a, 999 / $100
	ld [H_MULTIPLICAND + 1], a
	ld a, 999 % $100
	ld [H_MULTIPLICAND + 2], a

UpdateStat:
	ld a, [H_PRODUCT + 2]
	ld [hli], a
	ld a, [H_PRODUCT + 3]
	ld [hl], a
	pop hl
UpdateStatDone:
	ld b, c
	inc b
	call PrintStatText
	ld hl, wPlayerBattleStatus2
	ld de, wPlayerMoveNum
	ld bc, wPlayerMonMinimized
	ld a, [H_WHOSETURN]
	and a
	jr z, .asm_3f4e6
	ld hl, wEnemyBattleStatus2
	ld de, wEnemyMoveNum
	ld bc, wEnemyMonMinimized
.asm_3f4e6
	ld a, [de]
	cp MINIMIZE
	jr nz, .asm_3f4f9
 ; if a substitute is up, slide off the substitute and show the mon pic before
 ; playing the minimize animation
	bit HAS_SUBSTITUTE_UP, [hl]
	push af
	push bc
	ld hl, HideSubstituteShowMonAnim
	ld b, BANK(HideSubstituteShowMonAnim)
	push de
	call nz, Bankswitch
	pop de
.asm_3f4f9
	call PlayCurrentMoveAnimation
	ld a, [de]
	cp MINIMIZE
	jr nz, .applyBadgeBoostsAndStatusPenalties
	pop bc
	ld a, $1
	ld [bc], a
	ld hl, ReshowSubstituteAnim
	ld b, BANK(ReshowSubstituteAnim)
	pop af
	call nz, Bankswitch
.applyBadgeBoostsAndStatusPenalties
	ld a, [H_WHOSETURN]
	and a
	call z, ApplyBadgeStatBoosts ; whenever the player uses a stat-up move, badge boosts get reapplied again to every stat,
	                             ; even to those not affected by the stat-up move (will be boosted further)
								 ;joenote - this has been fixed
	ld hl, MonsStatsRoseText
	call PrintText

; these shouldn't be here
	;call QuarterSpeedDueToParalysis ; apply speed penalty to the player whose turn is not, if it's paralyzed
	;jp HalveAttackDueToBurn ; apply attack penalty to the player whose turn is not, if it's burned
;joenote - now to fix this to properly apply the BRN and PAR stat penalties.
;In pokemon generation 1, stat-ups are always dealt to a pkmn's self on its own turn.
;But the default penalty functions are written to apply penalties to the opponent of whoever's turn it is.
;So if speed or attack rises: invert H_WHOSETURN, call the appropriate function, when revert H_WHOSETURN.
;This make it so the penalties are applied to the self of whoever's turn it is.
;All that remains is to check which stat-up is applied and call the appropriate function.
	push de	;preserve de on the stack
	ld de, wPlayerMoveEffect	;get the player move effect
	ld a, [H_WHOSETURN]	;load the turn
	and a	;check the turn
	jr z, .skip1	;if it is not the player's turn...
	ld de, wEnemyMoveEffect	;...then it's the enemy's turn - load enemy move effect
.skip1
	xor $1	;invert the turn
	ld [H_WHOSETURN], a	;store the inverted turn
	ld a, [de]	;get the move effect into a
	cp ATTACK_UP1_EFFECT
	jr z, .skip_brn	;attack effect. skip to brn penalty
	cp ATTACK_UP2_EFFECT
	jr z, .skip_brn	;attack effect. skip to brn penalty
	cp SPEED_UP1_EFFECT
	jr z, .skip_par	;speed effect. skip to par penalty.
	cp SPEED_UP2_EFFECT
	jr z, .skip_par	;speed effect. skip to par penalty.
	jr .skip_end	;no attack or speed effect if at this line. skip to end.
.skip_brn
	call HalveAttackDueToBurn	;the active pkmn has a new recalculated attack. the non-active pkmn applies brn penalty to its opponent.
	jr .skip_end
.skip_par
	call QuarterSpeedDueToParalysis	;the active pkmn has a new recalculated speed. the non-active pkmn applies par penalty to its opponent.
.skip_end
	ld a, [H_WHOSETURN]	;load the inverted turn
	xor $1	;revert the turn back to normal
	ld [H_WHOSETURN], a	;store the normal turn
	pop de	;restore de from the stack
	ret	;remember to return
	
RestoreOriginalStatModifier:
	pop hl
	dec [hl]

PrintNothingHappenedText:
	ld hl, NothingHappenedText
	jp PrintText

MonsStatsRoseText:
	TX_FAR _MonsStatsRoseText
	TX_ASM
	ld hl, GreatlyRoseText
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerMoveEffect]
	jr z, .playerTurn
	ld a, [wEnemyMoveEffect]
.playerTurn
	cp ATTACK_DOWN1_EFFECT
	ret nc
	ld hl, RoseText
	ret

GreatlyRoseText:
	TX_DELAY
	TX_FAR _GreatlyRoseText
; fallthrough
RoseText:
	TX_FAR _RoseText
	db "@"

StatModifierDownEffect:
	ld hl, wEnemyMonStatMods
	ld de, wPlayerMoveEffect
	ld bc, wEnemyBattleStatus1
	ld a, [H_WHOSETURN]
	and a
	jr z, .statModifierDownEffect
	ld hl, wPlayerMonStatMods
	ld de, wEnemyMoveEffect
	ld bc, wPlayerBattleStatus1
;joenote - do not have stat-downs have 25% miss chance with AI opponent
;	ld a, [wLinkState]
;	cp LINK_STATE_BATTLING
;	jr z, .statModifierDownEffect
;	call BattleRandom
;	cp $40 ; 1/4 chance to miss by in regular battle
;	jp c, MoveMissed
.statModifierDownEffect
	call CheckTargetSubstitute ; can't hit through substitute
	jp nz, MoveMissed
	ld a, [de]
	cp ATTACK_DOWN_SIDE_EFFECT
	jr c, .nonSideEffect
	call BattleRandom
	cp $55 ; 85/256 chance for side effects
	jp nc, CantLowerAnymore
	ld a, [de]
	sub ATTACK_DOWN_SIDE_EFFECT ; map each stat to 0-3
	jr .decrementStatMod
.nonSideEffect ; non-side effects only
	push hl
	push de
	push bc
	call MoveHitTest ; apply accuracy tests
	pop bc
	pop de
	pop hl
	ld a, [wMoveMissed]
	and a
	jp nz, MoveMissed
	ld a, [bc]
	bit INVULNERABLE, a ; fly/dig
	jp nz, MoveMissed
	ld a, [de]
	sub ATTACK_DOWN1_EFFECT
	cp EVASION_DOWN1_EFFECT + $3 - ATTACK_DOWN1_EFFECT ; covers all -1 effects
	jr c, .decrementStatMod
	sub ATTACK_DOWN2_EFFECT - ATTACK_DOWN1_EFFECT ; map -2 effects to corresponding -1 effect
.decrementStatMod
	ld c, a
	ld b, $0
	inc a ;joenote - backup the address offset for the stat mod 
	ld [wUnusedD71B], a	;joenote - backup the address offset for the stat mod
	add hl, bc
	ld b, [hl]
	dec b ; dec corresponding stat mod
	jp z, CantLowerAnymore ; if stat mod is 1 (-6), can't lower anymore
	ld a, [de]
	cp ATTACK_DOWN2_EFFECT - $16 ; $24
	jr c, .ok
	cp EVASION_DOWN2_EFFECT + $5 ; $44
	jr nc, .ok
	dec b ; stat down 2 effects only (dec mod again)
	jr nz, .ok
	inc b ; increment mod to 1 (-6) if it would become 0 (-7)
.ok
	ld [hl], b ; save modified mod
	ld a, c
	cp $4
	jr nc, UpdateLoweredStatDone ; jump for evasion/accuracy
	push hl
	push de
	ld hl, wEnemyMonAttack + 1
	ld de, wEnemyMonUnmodifiedAttack
	ld a, [H_WHOSETURN]
	and a
	jr z, .pointToStat
	ld hl, wBattleMonAttack + 1
	ld de, wPlayerMonUnmodifiedAttack
.pointToStat
	push bc
	sla c
	ld b, $0
	add hl, bc ; hl = modified stat
	ld a, c
	add e
	ld e, a
	jr nc, .noCarry
	inc d ; de = unmodified stat
.noCarry
	pop bc
	ld a, [hld]
	sub $1 ; can't lower stat below 1 (-6)
	jr nz, .recalculateStat
	ld a, [hl]
	and a
	jp z, CantLowerAnymore_Pop
.recalculateStat
; recalculate affected stat
; paralysis and burn penalties, as well as badge boosts are ignored
	push hl
	push bc
	ld hl, StatModifierRatios
	dec b
	sla b
	ld c, b
	ld b, $0
	add hl, bc
	pop bc
	xor a
	ld [H_MULTIPLICAND], a
	ld a, [de]
	ld [H_MULTIPLICAND + 1], a
	inc de
	ld a, [de]
	ld [H_MULTIPLICAND + 2], a
	ld a, [hli]
	ld [H_MULTIPLIER], a
	call Multiply
	ld a, [hl]
	ld [H_DIVISOR], a
	ld b, $4
	call Divide
	pop hl
	ld a, [H_PRODUCT + 3]
	ld b, a
	ld a, [H_PRODUCT + 2]
	or b
	jp nz, UpdateLoweredStat
	ld [H_MULTIPLICAND + 1], a
	ld a, $1
	ld [H_MULTIPLICAND + 2], a

UpdateLoweredStat:
	ld a, [H_PRODUCT + 2]
	ld [hli], a
	ld a, [H_PRODUCT + 3]
	ld [hl], a
	pop de
	pop hl
UpdateLoweredStatDone:
	ld b, c
	inc b
	push de
	call PrintStatText
	pop de
	ld a, [de]
	cp $44
	jr nc, .ApplyBadgeBoostsAndStatusPenalties
	call PlayCurrentMoveAnimation2
.ApplyBadgeBoostsAndStatusPenalties
	ld a, [H_WHOSETURN]
	and a
	call nz, ApplyBadgeStatBoosts ; whenever the player gets hit with a stat-down move, badge boosts get reapplied again to every stat,
	                              ; even to those not affected by the stat-down move (will be boosted further)
								  ;joenote - this is now fixed
	ld hl, MonsStatsFellText
	call PrintText
	
; These where probably added given that a stat-down move affecting speed or attack will override
; the stat penalties from paralysis and burn respectively.
; But they are always called regardless of the stat affected by the stat-down move.
	;call QuarterSpeedDueToParalysis ; apply speed penalty to the player whose turn is not, if it's paralyzed
	;jp HalveAttackDueToBurn ; apply attack penalty to the player whose turn is not, if it's burned
;joenote - now to fix this to properly apply the BRN and PAR stat penalties.
;In pokemon generation 1, stat-downs are always dealt to an opponent during the active pkmn's turn.
;So the penalty functions have the correct assumption that whoever is getting a stat-down is not their turn
;The correct function needs to be called depending on the stat-down being applied
	push de	;preserve de on the stack
	ld de, wPlayerMoveEffect	;get the player move effect
	ld a, [H_WHOSETURN]	;load the turn
	and a	;check the turn
	jr z, .skip1	;if it is not the player's turn...
	ld de, wEnemyMoveEffect	;...then it's the enemy's turn - load enemy move effect
.skip1
	ld a, [de]	;get the move effect into a
	cp ATTACK_DOWN1_EFFECT
	jr z, .skip_brn	;attack effect. skip to brn penalty
	cp ATTACK_DOWN2_EFFECT
	jr z, .skip_brn	;attack effect. skip to brn penalty
	cp SPEED_DOWN1_EFFECT
	jr z, .skip_par	;speed effect. skip to par penalty.
	cp SPEED_DOWN2_EFFECT
	jr z, .skip_par	;speed effect. skip to par penalty.
	jr .skip_end	;no attack or speed effect if at this line. skip to end.
.skip_brn
	call HalveAttackDueToBurn	;the non-active pkmn has a new recalculated attack. the active pkmn applies brn penalty to its opponent.
	jr .skip_end
.skip_par
	call QuarterSpeedDueToParalysis	;the non-active pkmn has a new recalculated speed. the active pkmn applies par penalty to its opponent.
.skip_end
	pop de	;restore de from the stack
	ret	;remember to return 
	
CantLowerAnymore_Pop:
	pop de
	pop hl
	inc [hl]

CantLowerAnymore:
	ld a, [de]
	cp ATTACK_DOWN_SIDE_EFFECT
	ret nc
	ld hl, NothingHappenedText
	jp PrintText

MoveMissed:
	ld a, [de]
	cp $44
	ret nc
	jp ConditionalPrintButItFailed

MonsStatsFellText:
	TX_FAR _MonsStatsFellText
	TX_ASM
	ld hl, FellText
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerMoveEffect]
	jr z, .playerTurn
	ld a, [wEnemyMoveEffect]
.playerTurn
; check if the move's effect decreases a stat by 2
	cp BIDE_EFFECT
	ret c
	cp ATTACK_DOWN_SIDE_EFFECT
	ret nc
	ld hl, GreatlyFellText
	ret

GreatlyFellText:
	TX_DELAY
	TX_FAR _GreatlyFellText
; fallthrough
FellText:
	TX_FAR _FellText
	db "@"

PrintStatText:
	ld hl, StatsTextStrings
	ld c, "@"
.findStatName_outer
	dec b
	jr z, .foundStatName
.findStatName_inner
	ld a, [hli]
	cp c
	jr z, .findStatName_outer
	jr .findStatName_inner
.foundStatName
	ld de, wcf4b
	ld bc, $a
	jp CopyData

StatsTextStrings:
	db "For@"
	db "Déf@"
	db "Vit@"
	db "Spé@"
	db "Pré@"
	db "Esq@"

BideEffect:
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerBideAccumulatedDamage
	ld bc, wPlayerNumAttacksLeft
	ld a, [H_WHOSETURN]
	and a
	jr z, .bideEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyBideAccumulatedDamage
	ld bc, wEnemyNumAttacksLeft
.bideEffect
	set STORING_ENERGY, [hl] ; mon is now using bide
	xor a
	ld [de], a
	inc de
	ld [de], a
	ld [wPlayerMoveEffect], a
	ld [wEnemyMoveEffect], a
	call BattleRandom
	and $1
	inc a
	inc a
	ld [bc], a ; set Bide counter to 2 or 3 at random
	ld a, [H_WHOSETURN]
	add XSTATITEM_ANIM
	jp PlayBattleAnimation2

ThrashPetalDanceEffect:
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerNumAttacksLeft
	ld a, [H_WHOSETURN]
	and a
	jr z, .thrashPetalDanceEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyNumAttacksLeft
.thrashPetalDanceEffect
	set THRASHING_ABOUT, [hl] ; mon is now using thrash/petal dance
	call BattleRandom
	and $1
	inc a
	inc a
	ld [de], a ; set thrash/petal dance counter to 2 or 3 at random
	ld a, [H_WHOSETURN]
	add ANIM_B0
	jp PlayBattleAnimation2

SwitchAndTeleportEffect:
	jpab SwitchAndTeleportEffect_

RanFromBattleText:
	TX_FAR _RanFromBattleText
	db "@"

RanAwayScaredText:
	TX_FAR _RanAwayScaredText
	db "@"

WasBlownAwayText:
	TX_FAR _WasBlownAwayText
	db "@"

TwoToFiveAttacksEffect:
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerNumAttacksLeft
	ld bc, wPlayerNumHits
	ld a, [H_WHOSETURN]
	and a
	jr z, .twoToFiveAttacksEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyNumAttacksLeft
	ld bc, wEnemyNumHits
.twoToFiveAttacksEffect
	bit ATTACKING_MULTIPLE_TIMES, [hl] ; is mon attacking multiple times?
	ret nz
	set ATTACKING_MULTIPLE_TIMES, [hl] ; mon is now attacking multiple times
	ld hl, wPlayerMoveEffect
	ld a, [H_WHOSETURN]
	and a
	jr z, .setNumberOfHits
	ld hl, wEnemyMoveEffect
.setNumberOfHits
	ld a, [hl]
	cp TWINEEDLE_EFFECT
	jr z, .twineedle
	cp ATTACK_TWICE_EFFECT
.load_two_hits
	ld a, $2 ; number of hits is always 2 for ATTACK_TWICE_EFFECT
	jr z, .saveNumberOfHits
; for TWO_TO_FIVE_ATTACKS_EFFECT 3/8 chance for 2 and 3 hits, and 1/8 chance for 4 and 5 hits
	call BattleRandom
	and $3
	cp $2
	jr c, .gotNumHits
; if the number of hits was greater than 2, re-roll again for a lower chance
	call BattleRandom
	and $3
.gotNumHits
	inc a
	inc a
.saveNumberOfHits
	ld [de], a
	ld [bc], a
	ret
.twineedle
	ld a, POISON_SIDE_EFFECT1
	ld [hl], a ; set Twineedle's effect to poison effect
;	jr .saveNumberOfHits	;this assumes POISON_SIDE_EFFECT1 = 2
	jr .load_two_hits 	;joenote - jump back a bit further to make sure 2 is loaded into A

FlinchSideEffect:
	call CheckTargetSubstitute
	ret nz
	ld hl, wEnemyBattleStatus1
	ld de, wPlayerMoveEffect
	ld a, [H_WHOSETURN]
	and a
	jr z, .flinchSideEffect
	ld hl, wPlayerBattleStatus1
	ld de, wEnemyMoveEffect
.flinchSideEffect
	ld a, [de]
	cp FLINCH_SIDE_EFFECT1
	ld b, $1a ; ~10% chance of flinch
	jr z, .gotEffectChance
	ld b, $4d ; ~30% chance of flinch
.gotEffectChance
	call BattleRandom
	cp b
	ret nc
	set FLINCHED, [hl] ; set mon's status to flinching
	call ClearHyperBeam
	ret

OneHitKOEffect:
	jpab OneHitKOEffect_

ChargeEffect:
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerMoveEffect
	ld a, [H_WHOSETURN]
	and a
	ld b, XSTATITEM_ANIM
	jr z, .chargeEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyMoveEffect
	ld b, ANIM_AF
.chargeEffect
	set CHARGING_UP, [hl]
	ld a, [de]
	dec de ; de contains enemy or player MOVENUM
	cp FLY_EFFECT
	jr nz, .notFly
	set INVULNERABLE, [hl] ; mon is now invulnerable to typical attacks (fly/dig)
	ld b, TELEPORT ; load Teleport's animation
.notFly
	ld a, [de]
	cp DIG
	jr nz, .notDigOrFly
	set INVULNERABLE, [hl] ; mon is now invulnerable to typical attacks (fly/dig)
	ld b, ANIM_C0
.notDigOrFly
	xor a
	ld [wAnimationType], a
	ld a, b
	callab PlayBattleAnimation
	ld a, [de]
	ld [wChargeMoveNum], a
	ld hl, ChargeMoveEffectText
	jp PrintText

ChargeMoveEffectText:
	TX_FAR _ChargeMoveEffectText
	TX_ASM
	ld a, [wChargeMoveNum]
	cp RAZOR_WIND
	ld hl, MadeWhirlwindText
	jr z, .gotText
	cp SOLARBEAM
	ld hl, TookInSunlightText
	jr z, .gotText
	cp SKULL_BASH
	ld hl, LoweredItsHeadText
	jr z, .gotText
	cp SKY_ATTACK
	ld hl, SkyAttackGlowingText
	jr z, .gotText
	cp FLY
	ld hl, FlewUpHighText
	jr z, .gotText
	cp DIG
	ld hl, DugAHoleText
.gotText
	ret

MadeWhirlwindText:
	TX_FAR _MadeWhirlwindText
	db "@"

TookInSunlightText:
	TX_FAR _TookInSunlightText
	db "@"

LoweredItsHeadText:
	TX_FAR _LoweredItsHeadText
	db "@"

SkyAttackGlowingText:
	TX_FAR _SkyAttackGlowingText
	db "@"

FlewUpHighText:
	TX_FAR _FlewUpHighText
	db "@"

DugAHoleText:
	TX_FAR _DugAHoleText
	db "@"

TrappingEffect:
;joenote - make it so the effect won't take hold if target has type immunity
	ld hl, wUnusedC000
	set 3, [hl]
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerNumAttacksLeft
	ld a, [H_WHOSETURN]
	and a
	jr z, .trappingEffect
	ld hl, wUnusedC000
	res 3, [hl]
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyNumAttacksLeft
.trappingEffect
	bit USING_TRAPPING_MOVE, [hl]
	ret nz
	
	push hl
	push bc
	push de
	call AIGetTypeEffectiveness
	pop de
	pop bc
	pop hl
	ld a, [wTypeEffectiveness]
	and a
	ret z
	
	;call ClearHyperBeam ; since this effect is called before testing whether the move will hit,
                        ; the target won't need to recharge even if the trapping move missed
						;joenote - will do this later under ApplyAttackToEnemy/Player functions
	set USING_TRAPPING_MOVE, [hl] ; mon is now using a trapping move
	call BattleRandom ; 3/8 chance for 2 and 3 attacks, and 1/8 chance for 4 and 5 attacks
	and $3
	cp $2
	jr c, .setTrappingCounter
	call BattleRandom
	and $3
.setTrappingCounter
	inc a
	ld [de], a
;joenote - have the trapping effect user get its speed temporarily reduced until stats get recalculated
;	callba ReduceSpeed
;joenote - increment a trapping spam counter that checks for consecutive usage of trapping moves
	inc hl
	inc hl	;now points to xBattleStatus3
	ld a, [hl]
	add TRAPPING_COUNT_BIT
	ld [hl], a	;else increment the consecutive use counter
	ret

MistEffect:
	jpab MistEffect_

FocusEnergyEffect:
	jpab FocusEnergyEffect_

RecoilEffect:
	jpab RecoilEffect_

ConfusionSideEffect:
	call CheckTargetSubstitute	;joenote - return if opponent has substitute up
	ret nz
	call BattleRandom
	cp $19 ; ~10% chance
	ret nc
	jr ConfusionSideEffectSuccess

ConfusionEffect:
	call CheckTargetSubstitute
	jr nz, ConfusionEffectFailed
	call MoveHitTest
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
	call BattleRandom
	and $3
	inc a
	inc a
	ld [bc], a ; confusion status will last 2-5 turns
	pop af
	cp CONFUSION_SIDE_EFFECT
	call PlayCurrentMoveAnimation2
	ld hl, BecameConfusedText
	jp PrintText

BecameConfusedText:
	TX_FAR _BecameConfusedText
	db "@"

ConfusionEffectFailed:
	cp CONFUSION_SIDE_EFFECT
	ret z
	ld c, 50
	call DelayFrames
	jp ConditionalPrintButItFailed

ParalyzeEffect:
	jpab ParalyzeEffect_

SubstituteEffect:
	jpab SubstituteEffect_

HyperBeamEffect:
	call _HandleHyperbeamClause	;joenote - handle hyper beam clause
	ret nz
	ld hl, wPlayerBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .hyperBeamEffect
	ld hl, wEnemyBattleStatus2
.hyperBeamEffect
	set NEEDS_TO_RECHARGE, [hl] ; mon now needs to recharge
	ret

ClearHyperBeam:	;for whoever's turn it is, clear their opponent's hyperbeam status
	push hl
	ld hl, wEnemyBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .playerTurn
	ld hl, wPlayerBattleStatus2
.playerTurn
	res NEEDS_TO_RECHARGE, [hl] ; mon no longer needs to recharge
	pop hl
	ret

RageEffect:	;joenote - modified to last 2 to 3 turns
	ld hl, wPlayerBattleStatus2
	ld bc, wPlayerNumAttacksLeft
	ld a, [H_WHOSETURN]
	and a
	jr z, .player
	ld hl, wEnemyBattleStatus2
	ld bc, wEnemyNumAttacksLeft
.player
	set USING_RAGE, [hl] ; mon is now in "rage" mode
	call BattleRandom
	and $1
	inc a
	inc a
	ld [bc], a ; set Rage counter to 2 or 3 at random
	ret

MimicEffect:
	ld c, 50
	call DelayFrames
	call MoveHitTest
	ld a, [wMoveMissed]
	and a
	jp nz, .mimicMissed
	ld a, [H_WHOSETURN]
	and a
	ld hl, wBattleMonMoves
	ld a, [wPlayerBattleStatus1]
	jr nz, .enemyTurn
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .letPlayerChooseMove
	ld hl, wEnemyMonMoves
	ld a, [wEnemyBattleStatus1]
.enemyTurn
	bit INVULNERABLE, a
	jr nz, .mimicMissed
.getRandomMove
	push hl
	call BattleRandom
	and $3
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jr z, .getRandomMove
	ld d, a
	ld a, [H_WHOSETURN]
	and a
	ld hl, wBattleMonMoves
	ld a, [wPlayerMoveListIndex]
	jr z, .playerTurn
	ld hl, wEnemyMonMoves
	ld a, [wEnemyMoveListIndex]
	jr .playerTurn
.letPlayerChooseMove
	ld a, [wEnemyBattleStatus1]
	bit INVULNERABLE, a
	jr nz, .mimicMissed
	
	call SaveScreenTilesToBuffer1	;joenote - need to save the tiles in case the opponent switched before mimic
	
	ld a, [wCurrentMenuItem]
	push af
	ld a, $1
	ld [wMoveMenuType], a
	call MoveSelectionMenu
	call LoadScreenTilesFromBuffer1
	ld hl, wEnemyMonMoves
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0
	add hl, bc
	ld d, [hl]
	pop af
	ld hl, wBattleMonMoves
.playerTurn
	ld c, a
	ld b, $0
	add hl, bc
	ld a, d
	ld [hl], a
	ld [wd11e], a
	call GetMoveName
	call PlayCurrentMoveAnimation
	ld hl, MimicLearnedMoveText
	jp PrintText
.mimicMissed
	jp PrintButItFailedText_

MimicLearnedMoveText:
	TX_FAR _MimicLearnedMoveText
	db "@"

LeechSeedEffect:
	jpab LeechSeedEffect_

SplashEffect:
	call PlayCurrentMoveAnimation
	jp PrintNoEffectText

DisableEffect:
	call MoveHitTest
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
	call BattleRandom
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
	call PlayCurrentMoveAnimation2
	ld hl, wPlayerDisabledMoveNumber
	ld a, [H_WHOSETURN]
	and a
	jr nz, .printDisableText
	inc hl ; else increment to wEnemyDisabledMoveNumber
.printDisableText
	ld a, [wd11e] ; move number
	ld [hl], a
	call GetMoveName
	ld hl, MoveWasDisabledText
	jp PrintText
.moveMissedPopHL
	pop hl
.moveMissed
	jp PrintButItFailedText_

MoveWasDisabledText:
	TX_FAR _MoveWasDisabledText
	db "@"

PayDayEffect:
	jpab PayDayEffect_

ConversionEffect:
	jpab ConversionEffect_

HazeEffect:
	jpab HazeEffect_

HealEffect:
	jpab HealEffect_

TransformEffect:
	jpab TransformEffect_

ReflectLightScreenEffect:
	jpab ReflectLightScreenEffect_

NothingHappenedText:
	TX_FAR _NothingHappenedText
	db "@"

PrintNoEffectText:
	ld hl, NoEffectText
	jp PrintText

NoEffectText:
	TX_FAR _NoEffectText
	db "@"

ConditionalPrintButItFailed:
	ld a, [wMoveDidntMiss]
	and a
	ret nz ; return if the side effect failed, yet the attack was successful

PrintButItFailedText_:
	ld hl, ButItFailedText
	jp PrintText

ButItFailedText:
	TX_FAR _ButItFailedText
	db "@"

PrintDidntAffectText:
	ld hl, DidntAffectText
	jp PrintText

DidntAffectText:
	TX_FAR _DidntAffectText
	db "@"

IsUnaffectedText:
	TX_FAR _IsUnaffectedText
	db "@"

PrintMayNotAttackText:
	ld hl, ParalyzedMayNotAttackText
	jp PrintText

ParalyzedMayNotAttackText:
	TX_FAR _ParalyzedMayNotAttackText
	db "@"

CheckTargetSubstitute:
	push hl
	ld hl, wEnemyBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .next1
	ld hl, wPlayerBattleStatus2
.next1
	bit HAS_SUBSTITUTE_UP, [hl]
	pop hl
	ret

PlayCurrentMoveAnimation2:
; animation at MOVENUM will be played unless MOVENUM is 0
; plays wAnimationType 3 or 6
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerMoveNum]
	jr z, .notEnemyTurn
	ld a, [wEnemyMoveNum]
.notEnemyTurn
	and a
	ret z

PlayBattleAnimation2:
; play animation ID at a and animation type 6 or 3
	ld [wAnimationID], a
	ld a, [H_WHOSETURN]
	and a
	ld a, $6
	jr z, .storeAnimationType
	ld a, $3
.storeAnimationType
	ld [wAnimationType], a
	jp PlayBattleAnimationGotID

PlayCurrentMoveAnimation:
; animation at MOVENUM will be played unless MOVENUM is 0
; resets wAnimationType
	xor a
	ld [wAnimationType], a
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerMoveNum]
	jr z, .notEnemyTurn
	ld a, [wEnemyMoveNum]
.notEnemyTurn
	and a
	ret z

PlayBattleAnimation:
; play animation ID at a and predefined animation type
	ld [wAnimationID], a

PlayBattleAnimationGotID:
; play animation at wAnimationID
	push hl
	push de
	push bc
	predef MoveAnimation
	callab Func_78e98
	pop bc
	pop de
	pop hl
	ret


;joenote - function for checking and reseting the AI's already-acted bit
CheckandResetEnemyActedBit:
	ld a, [wUnusedC000]
	bit 1, a	;check a for already-acted bit (sets or clears zero flag)
	res 1, a ; resets the already-acted bit (does not affect flags)
	ld [wUnusedC000], a
	ret 

;joenote - function for setting the AI's already-acted bit
SetEnemyActedBit:
	ld a, [wUnusedC000]
	set 1, a ; sets the already-acted bit
	ld [wUnusedC000], a
	ret

;joenote - this sets the last damage dealt to zero
;meant for fixing counter glitches
ZeroLastDamage:
	push af
	push hl
	ld a, $00
	ld hl, wDamage
	ld [hli], a
	ld [hl], a
	pop hl
	pop af
	ret

;joenote - play an animation such as for for shiny DVs
;register e should hold the animation's constant value
;d = 00 for player animation / d = 01 for enemy animation
PlaySelectedAnimation:
	ld a, [H_WHOSETURN]
	push af
	ld a, d
	ld [H_WHOSETURN], a
	xor a
	ld [wAnimationType], a
	ld a, e
	call PlayMoveAnimation
	pop af
	ld [H_WHOSETURN], a
	ret 


;joenote - function to play an animation to signify the last attack of a trapping move
PlayEndTrappingMove:
	push hl
	push bc
	push de
	ld e, POOF_ANIM
	ld a, [H_WHOSETURN]
	xor $01
	ld d, a
	call PlaySelectedAnimation
	pop de
	pop bc
	pop hl
	ret

;joenote - consolidate this to save a bit of space
DecAttackPlayer:
	push hl
	ld hl, wPlayerNumAttacksLeft
	jr DecAttack
DecAttackEnemy:
	push hl
	ld hl, wEnemyNumAttacksLeft
	;fall through
DecAttack:
	dec [hl]
	pop hl
	ret

;Battle status2 in "a"
;resets the rage bit in "a" if zero flag is set
DeactivateRageInA:
	ret nz
	res USING_RAGE, a
	ret

SpriteScalingAndInterlacing:
	predef ScaleSpriteByTwo
	ld de, vBackPic
	call InterlaceMergeSpriteBuffers ; combine the two buffers to a single 2bpp sprite
	ret
	
PsywaveDamage:
;adjusted to account for underflow/overflow
;adjusted for 2 bytes bc
;loop until a random number in the range [1, bc] is found
;take heed that the min/max possible bc value for psywave is [$0001, $017E]
;can use BC and HL freely
	push de
	ld a, [hl]	;load level from HL
	ld e, a

	xor a
	ld [wDamage], a
	ld [wDamage+1], a
	
	ld a, [H_WHOSETURN]
	and a
	ld hl, wEnemyMonHP
	jr z, .got_turn
	ld hl, wBattleMonHP
.got_turn
	ld a, [hli]
	ld [wcf4b], a
	ld a, [hl]
	ld [wcf4b+1], a

.loop
	call BattleRandom
	cp e
	jr z, .next
	jr nc, .loop
.next
	ld d, a
	callba PsywaveEnhanced
	jr c, .loop

	pop de
	ret
