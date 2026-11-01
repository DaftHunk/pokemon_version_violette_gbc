; The follower engine lives in its own bank. The sheet table
; (data/pokemons/follower_sheets.asm) must be included right after this file
; so it lands in the SAME bank: GetFollowerSheetEntry reads it directly
; (no bank switch); FarCopyData2 fetches each sheet from its own bank.
SECTION "Follower engine", ROMX[$4000], BANK[75]

; Follower mon engine.
; The first party mon follows the player on outside maps, using the sprite
; sheets from data/pokemons/follower_sheets.asm (indexed by the internal species ID).
; Uses sprite struct 15 ($C1F0/$C2F0, VRAM slot 2, the SPRITE_FOLLOWER
; placeholder that is entry 0 of all 14 outside sprite sets).
; Adapted from pret/pokeyellow's Pikachu follower, old-disasm style.
;
; Flow:
; - TrySpawnFollower (called from InitOutsideMapSprites before the VRAM
;   slot assignment loop) spawns struct 15 so it gets VRAM slot 2.
; - RefreshFollowerSheet (called after every sprite set (re)load) copies
;   the leader's sheet over VRAM slot 2.
; - QueueFollowerFollowCommand (called from home/overworld.asm when the
;   player starts a step) appends the direction to a FIFO.
; - FollowerUpdate (called from the _UpdateSprites hijack every frame)
;   consumes the FIFO and animates the follower.
; A leader without a follower sheet (null table entry) never shows up.

; ---------------------------------------------------------------------------
; per-frame update, hijacked from .updateCurrentSprite (struct 15)
; ---------------------------------------------------------------------------

FollowerUpdate::
; hide and freeze while the player is biking or surfing
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .active
	ld hl, wFollowerStateFlags
	set 0, [hl] ; remember the follower is hidden
	ld hl, wSpriteStateData1 + $f0
	ld [hl], $0 ; picture ID 0: invisible and no collision
	ld hl, wSpriteStateData1 + $f2
	ld [hl], $ff ; image index: hidden
	ret
.active
	ld hl, wFollowerStateFlags
	bit 0, [hl]
	jr z, .spawned
; the follower was hidden while the player was biking or surfing: reload
; the leader's sheet (the player's biking/surfing sheet may have
; overwritten VRAM slot 2), restore the picture and snap behind the player
	res 0, [hl]
	call GetFollowerSheetEntry
	jr c, .reactivate
	ret ; the leader has no sheet (anymore): stay hidden
.reactivate
	ld a, SPRITE_FOLLOWER
	ld [wSpriteStateData1 + $f0], a
	call RefreshFollowerSheet
	call CalculateFollowerSpawnCoordsAndFacing
.spawned
	ld hl, wSpriteStateData1 + $f0
	ld a, [hl]
	and a
	ret z ; follower not spawned on this map
	ld hl, wSpriteStateData1 + $f1
	bit 7, [hl] ; does the game want the follower to face the player?
	jp nz, FollowerFaceAwayFromPlayer
	ld a, [hl]
	and $7f
	cp $6
	jr c, .valid
	xor a
.valid
	add a
	ld e, a
	ld d, 0
	ld hl, FollowerMovementStateTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

FollowerMovementStateTable:
	dw FollowerMovementState_Init ; $0
	dw FollowerMovementState_ProcessCommand ; $1
	dw FollowerMovementState_ProcessCommand ; $2 (unused, defensive)
	dw FollowerMovementState_NormalFollow ; $3
	dw FollowerMovementState_DoubleStep ; $4
	dw FollowerMovementState_FastFollow ; $5

FollowerMovementState_Init:
; status 0: convert the follower's map coords to screen pixels and show up
; (InitializeSpriteScreenPosition inlined for struct 15)
	ld h, wSpriteStateData2 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	add $4
	ld l, a
	ld a, [wYCoord]
	ld b, a
	ld a, [hl] ; $c2f4: map Y (+4)
	sub b ; relative to the player position
	swap a ; * 16
	sub $4
	dec h
	ld [hli], a ; $c1f4: screen Y position
	inc h
	ld a, [wXCoord]
	ld b, a
	ld a, [hli] ; $c2f5: map X (+4)
	sub b
	swap a
	dec h
	ld [hl], a ; $c1f6: screen X position
	ld hl, wSpriteStateData1 + $f1
	ld [hl], $1
	call UpdateFollowerWalkingSprite
	ret

FollowerMovementState_ProcessCommand:
; hold the oldest command while the player is mid-step, unless the follower
; is already lagging two steps behind: consuming the command only once the
; player's step has finished keeps the follower one step behind on the
; player's path (retracing the trail) instead of moving in parallel.
; This reproduces pokeyellow's natural lag (its step is half the length of
; the player's 30fps step, so the next command only arrives mid-idle).
	ld a, [wWalkCounter]
	and a
	jr z, .gotCommand
	call AreThereAtLeastTwoStepsInFollowerCommandBuffer
	jp nc, FollowerMovementState_Idle
.gotCommand
	call GetNextFollowerFollowCommand
	jp c, FollowerMovementState_Idle
	call CorrectFollowerFollowStep
	dec a
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, FollowerMovementCommandData
	add hl, de
	ld d, h
	ld e, l
	ld a, [de] ; facing
	inc de
	ld hl, wSpriteStateData1 + $f9
	ld [hl], a
	ld a, [de] ; X step
	inc de
	ld hl, wSpriteStateData1 + $f5
	ld [hl], a
	dec hl
	dec hl
	ld a, [de] ; Y step
	ld [hl], a
	inc de
	ld a, [de] ; movement status
	ld hl, wSpriteStateData1 + $f1
	ld [hl], a
	cp $4
	jp z, FollowerDoubleStep
; when the player is running, steps complete at double speed: always
; take fast (4-tick) steps to keep pace, instead of rubber-banding
; between slow steps and the backlog-gated fast follow
	ld a, [wJoyIgnore]
	and a
	jr nz, .checkBacklog
	ld a, [hJoyHeld]
	and B_BUTTON
	jr z, .checkBacklog
	jp FastFollowerFollow
.checkBacklog
	call AreThereAtLeastTwoStepsInFollowerCommandBuffer
	jp c, FastFollowerFollow
	jp NormalFollowerFollow

FollowerMovementState_Idle:
; no pending commands: stand still, but snap back behind the player if the
; trail got broken (dropped commands after a full buffer, ledges, etc.)
	call CheckFollowerDistanceToPlayer
	jr c, .snap
	call CheckFollowerBlockingPlayerPath
	jr c, .snap
; stand on the standing frame, like the player sprite when it stops moving
	xor a
	ld hl, wSpriteStateData1 + $f7
	ld [hli], a
	ld [hl], a
	call UpdateFollowerWalkingSprite
	ret
.snap
	call SnapFollowerBehindPlayer
	ret

CheckFollowerBlockingPlayerPath:
; carry = the follower occupies the tile directly in front of the player.
; After a 180-degree turn it would sit in the player's path and permanently
; block movement (a deadlock in one-tile-wide corridors), so the idle state
; snaps it back behind the player instead.
; d = expected follower map Y, e = expected follower map X (both in +4 space)
	ld hl, wSpriteStateData2 + $f4
	ld a, [wYCoord]
	add $4
	ld d, a
	ld a, [wXCoord]
	add $4
	ld e, a
; also treat the follower standing on the player's own tile as blocking
	ld a, [hl]
	cp d
	jr nz, .checkFront
	inc hl
	ld a, [hl]
	cp e
	jr z, .block
    dec hl
.checkFront
	ld a, [wSpriteStateData1 + 9] ; player facing
	and a ; SPRITE_FACING_DOWN
	jr z, .down
	cp SPRITE_FACING_UP
	jr z, .up
	cp SPRITE_FACING_LEFT
	jr z, .left
; SPRITE_FACING_RIGHT
	inc e
	jr .compare
.down
	inc d
	jr .compare
.up
	dec d
	jr .compare
.left
	dec e
.compare
	ld a, [hli]
	cp d
	jr nz, .noBlock
	ld a, [hl]
	cp e
	jr nz, .noBlock
.block
	scf
	ret
.noBlock
	and a
	ret

CorrectFollowerFollowStep:
; Corrective logic for regular follow commands (1-4).
; If the follower already holds the steady trailing position for this
; command (on the player's line, one or two tiles behind), replay the
; command as-is so it keeps retracing the player's path. Otherwise
; burn it for a corrective step: perpendicular axis first, to get back
; on the player's line, then along it to close the gap (a far, 2-tile
; step when the gap is 3 or more). A corrective step that would land
; on the player's tile is only safe while they are walking (the tile
; is vacated the same step); at rest it would stick, so step to the
; player's trailing side instead. Far commands (5-8) replay as-is.
	ld b, a
	cp $5
	jp nc, .replay
; d = player Y - follower Y
; e = player X - follower X  (both in +4 map space)
	ld a, [wYCoord]
	add $4
	ld h, a
	ld a, [wSpriteStateData2 + $f4]
	sub h
	cpl
	inc a
	ld d, a
	ld a, [wXCoord]
	add $4
	ld h, a
	ld a, [wSpriteStateData2 + $f5]
	sub h
	cpl
	inc a
	ld e, a
	ld a, b
	cp $3
	jr nc, .horizontal

; ----- vertical commands (1-2): get back on the player's column -----
	ld a, e
	and a
	jr z, .vOnColumn
	bit 7, a
	jr nz, .vRightOfColumn
; the follower is left of the column (e > 0): step right
	cp $3
	jr nc, .vFarRight
	ld a, d
	and a
	jr nz, .vRight
	call .blockedIfIdle
	jp c, .fallback
.vRight
	ld a, $4		; right
	ret
.vFarRight
	ld a, $8		; right (far)
	ret
.vRightOfColumn
; the follower is right of the column (e < 0): step left
	ld a, e
	cp -2
	jr nc, .vNearLeft
	ld a, $7			; left (far)
	ret
.vNearLeft
	ld a, d
	and a
	jr nz, .vLeft
	call .blockedIfIdle
	jp c, .fallback
.vLeft
	ld a, $3			; left
	ret
.vOnColumn
	ld a, b
	cp $1
	jr z, .vDown
; up command: steady when the follower is 1-2 tiles below (d = -2..-1)
	ld a, d
	cp -1
	jp z, .replay
	cp -2
	jp z, .replay
	bit 7, a
	jr z, .vAhead
	and a
	jp z, .replay		; on the player's tile: replay
	ld a, $6			; up (far): d <= -3
	ret
.vAhead
	ld a, d
	cp $1
	jr nz, .vDownStep
	call .blockedIfIdle		; d == 1: lands on the player's tile
	jp c, .fallback
.vDownStep
	ld a, $1			; down
	ret
.vDown
; down command: steady when the follower is 1-2 tiles above (d = 1..2)
	ld a, d
	cp $1
	jp z, .replay
	cp $2
	jp z, .replay
	bit 7, a
	jr nz, .vBackUp
	and a
	jp z, .replay		; on the player's tile: replay
	ld a, $5			; down (far): d >= 3
	ret
.vBackUp
	ld a, d
	cp -1
	jp nz, .vUpStep
	call .blockedIfIdle		; d == -1: lands on the player's tile
	jp c, .fallback
.vUpStep
	ld a, $2			; up
	ret

.horizontal
; ----- horizontal commands (3-4): get back on the player's row -----
	ld a, d
	and a
	jr z, .hOnRow
	bit 7, a
	jr nz, .hAbove
; the follower is above the row (d > 0): step down
	cp $3
	jr nc, .hFarDown
	ld a, e
	and a
	jr nz, .hDown
	call .blockedIfIdle
	jr c, .fallback
.hDown
	ld a, $1			; down
	ret
.hFarDown
	ld a, $5			; down (far)
	ret
.hAbove
; the follower is below the row (d < 0): step up
	ld a, d
	cp -2
	jr nc, .hNearUp
	ld a, $6			; up (far)
	ret
.hNearUp
	ld a, e
	and a
	jr nz, .hUp
	call .blockedIfIdle
	jr c, .fallback
.hUp
	ld a, $2			; up
	ret
.hOnRow
	ld a, b
	cp $3
	jr z, .hLeftCmd
; right command: steady when the follower is 1-2 tiles left (e = 1..2)
	ld a, e
	cp $1
	jr z, .replay
	cp $2
	jr z, .replay
	bit 7, a
	jr nz, .hBackLeft		; e < 0: ahead of the player: step back
	and a
	jr z, .replay		; on the player's tile: replay
	ld a, $8			; right (far): e >= 3
	ret
.hBackLeft
	ld a, e
	cp -1
	jr nz, .hLeft
	call .blockedIfIdle		; e == -1: lands on the player's tile
	jr c, .fallback
.hLeft
	ld a, $3			; left
	ret
.hLeftCmd
; left command: steady when the follower is 1-2 tiles right (e = -2..-1)
	ld a, e
	cp -1
	jr z, .replay
	cp -2
	jr z, .replay
	bit 7, a
	jr z, .hBackRight		; e > 0: ahead of the player: step back
	and a
	jr z, .replay		; on the player's tile: replay
	ld a, $7			; left (far): e <= -3
	ret
.hBackRight
	ld a, e
	cp $1
	jr nz, .hRight
	call .blockedIfIdle		; e == 1: lands on the player's tile
	jr c, .fallback
.hRight
	ld a, $4			; right
	ret

.blockedIfIdle
; The corrective step would land on the player's tile: it only sticks
; when the player is standing still, because mid-step the tile is
; vacated the same frame. wPlayerMovingDirection is set on every step
; start and cleared whenever no direction is held, so it tells an
; imminent step apart from a full stop — wWalkCounter cannot, because
; it also reads 0 on every step-start frame. Carry = blocked at rest.
	ld a, [wPlayerMovingDirection]
	and a
	ret nz			; player walking: clear carry
	scf				; blocked at rest
	ret

.fallback
; Blocked at rest: step to the player's trailing side instead
; (opposite of their facing: 0 = down, 4 = up, 8 = left, 12 = right)
	ld a, [wSpriteStateData1 + 9]
	and a			; facing down?
	jr z, .fbUp
	cp $4			; facing up?
	jr z, .fbDown
	cp $8			; facing left?
	jr z, .fbRight
	ld a, $3			; facing right: step left
	ret
.fbUp
	ld a, $2			; up
	ret
.fbDown
	ld a, $1			; down
	ret
.fbRight
	ld a, $4			; right
	ret

.replay
	ld a, b
	ret

NormalFollowerFollow:
	ld hl, wSpriteStateData2 + $f8
	ld [hl], $8
	ld hl, wSpriteStateData1 + $f1
	ld [hl], $3
	call AddFollowerStepVector
FollowerMovementState_NormalFollow:
	call TryDoubleAddFollowerStepVectorToScreenPixelCoords
	call GetFollowerWalkingAnimationSpeed
	call UpdateFollowerWalkingSprite
	ld hl, wSpriteStateData2 + $f8
	dec [hl]
	ret nz
	call ResetFollowerStepVector
	call ComputeFollowerFacingDirection
	ld hl, wSpriteStateData1 + $f1
	ld [hl], $1
	ret

FastFollowerFollow:
	ld hl, wSpriteStateData2 + $f8
	ld [hl], $4
	ld hl, wSpriteStateData1 + $f1
	ld [hl], $5
	call AddFollowerStepVector
FollowerMovementState_FastFollow:
	call DoubleAddFollowerStepVectorToScreenPixelCoords
	call GetFollowerWalkingAnimationSpeed
	call UpdateFollowerWalkingSprite
	ld hl, wSpriteStateData2 + $f8
	dec [hl]
	ret nz
	call ResetFollowerStepVector
	call ComputeFollowerFacingDirection
	ld hl, wSpriteStateData1 + $f1
	ld [hl], $1
	ret

FollowerDoubleStep:
	ld hl, wSpriteStateData2 + $f8
	ld [hl], $8
	ld hl, wSpriteStateData1 + $f1
	ld [hl], $4
	call AddFollowerStepVector
	call AddFollowerStepVector
FollowerMovementState_DoubleStep:
	call DoubleAddFollowerStepVectorToScreenPixelCoords
	call GetFollowerWalkingAnimationSpeed
	call UpdateFollowerWalkingSprite
	ld hl, wSpriteStateData2 + $f8
	dec [hl]
	ret nz
	call ResetFollowerStepVector
	call ComputeFollowerFacingDirection
	ld hl, wSpriteStateData1 + $f1
	ld [hl], $1
	ret

; facing, X step, Y step, movement status
; commands 1-4: one tile, 5-8: two tiles (ledge catch-up).
; The far commands use a one-tile delta like pokeyellow: FollowerDoubleStep
; adds the step vector twice to the map coords and the DoubleAdd pixel
; update moves 4 pixels per tick, covering two tiles in the same 8 ticks
; as the player's jump.
FollowerMovementCommandData:
	db  0,  0,  1, $3 ; 1 down
	db  4,  0, -1, $3 ; 2 up
	db  8, -1,  0, $3 ; 3 left
	db 12,  1,  0, $3 ; 4 right
	db  0,  0,  1, $4 ; 5 down (far)
	db  4,  0, -1, $4 ; 6 up (far)
	db  8, -1,  0, $4 ; 7 left (far)
	db 12,  1,  0, $4 ; 8 right (far)

FollowerFaceAwayFromPlayer:
; the player bumped into the follower (bit 7 of the movement status)
	ld hl, wSpriteStateData1 + $f1
	res 7, [hl]
	xor a
	ld hl, wSpriteStateData1 + $f7
	ld [hli], a
	ld [hl], a
	ld a, [wSpriteStateData1 + 9]
	xor $4 ; face the opposite way of the player
	ld [wSpriteStateData1 + $f9], a
	call UpdateFollowerWalkingSprite
	ret

AddFollowerStepVector:
; add the step deltas to the follower's map coords
	ld hl, wSpriteStateData1 + $f3
	ld e, [hl] ; delta Y
	inc hl
	inc hl
	ld d, [hl] ; delta X
	ld hl, wSpriteStateData2 + $f4
	ld a, [hl]
	add e
	ld [hli], a
	ld a, [hl]
	add d
	ld [hl], a
	ret

TryDoubleAddFollowerStepVectorToScreenPixelCoords:
; move the screen pixels at double speed while the player is biking
	ld a, [wWalkBikeSurfState]
	cp $1 ; biking?
	jr nz, AddFollowerStepVectorToScreenPixelCoords
	ld a, [wMovementFlags]
	bit 6, a ; ledge jump?
	jr nz, AddFollowerStepVectorToScreenPixelCoords
DoubleAddFollowerStepVectorToScreenPixelCoords:
	ld hl, wSpriteStateData1 + $f3
	ld a, [hli] ; delta Y
	add a
	add a
	add [hl] ; Y pixels
	ld [hli], a
	ld a, [hli] ; delta X
	add a
	add a
	add [hl] ; X pixels
	ld [hl], a
	ret

AddFollowerStepVectorToScreenPixelCoords:
	ld hl, wSpriteStateData1 + $f3
	ld a, [hli] ; delta Y
	add a
	add [hl] ; Y pixels
	ld [hli], a
	ld a, [hli] ; delta X
	add a
	add [hl] ; X pixels
	ld [hl], a
	ret

ResetFollowerStepVector:
	ld hl, wSpriteStateData1 + $f3
	xor a
	ld [hli], a
	inc hl
	ld [hl], a
	ret

GetFollowerWalkingAnimationSpeed:
; Advance the walk frame at a fixed interval of 4 ticks (3 when
; running with B held): two pose changes per tile, the classic gait,
; at any frame rate — at 60fps tiles are crossed twice as fast, so the
; feet must cycle twice as fast too.
	ld a, [wJoyIgnore]
	and a
	jr nz, .notRunning
	ld a, [hJoyHeld]
	and B_BUTTON
	jr z, .notRunning
	ld a, 3
	jr .gotInterval
.notRunning
	ld a, 4
.gotInterval
	ld b, a
	ld hl, wSpriteStateData1 + $f7
	ld a, [hl]
	inc a
	ld [hl], a
	cp b
	ret c
	xor a
	ld [hli], a
	ld a, [hl]
	inc a
	and $3
	ld [hl], a
	ret

UpdateFollowerWalkingSprite:
; image index = (VRAM slot - 1) << 4 | anim frame | facing
	ld a, [wSpriteStateData2 + $fe]
	dec a
	swap a
	ld d, a
	ld a, [wMovementFlags]
	bit 7, a ; is the player spinning (spin tiles)?
	jr nz, .copyPlayer
	ld a, [wSpriteStateData1 + $f9] ; facing
	or d
	ld d, a
	ld a, [wSpriteStateData1 + $f8] ; anim frame counter
	or d
	ld [wSpriteStateData1 + $f2], a
	ret
.copyPlayer
	ld a, [wSpriteStateData1 + 2] ; player image index
	and $f
	or d
	ld [wSpriteStateData1 + $f2], a
	ret

ComputeFollowerFacingDirection:
; face the next queued command, else face toward the player
	call GetFollowerFollowCommandIfBufferSizeNonzero
	and a
	jr z, .checkY
	dec a
	and $3
	add a
	add a
	jr .load
.checkY
	ld a, [wYCoord]
	add $4
	ld d, a
	ld a, [wXCoord]
	add $4
	ld e, a
	ld a, [wSpriteStateData2 + $f4]
	cp d
	jr z, .checkX
	ld a, SPRITE_FACING_DOWN
	jr c, .load
	ld a, SPRITE_FACING_UP
	jr .load
.checkX
	ld a, [wSpriteStateData2 + $f5]
	cp e
	jr z, .copyFromPlayer
	ld a, SPRITE_FACING_RIGHT
	jr c, .load
	ld a, SPRITE_FACING_LEFT
	jr .load
.copyFromPlayer
	ld a, [wSpriteStateData1 + 9]
.load
	ld [wSpriteStateData1 + $f9], a
	ret

; ---------------------------------------------------------------------------
; command FIFO
; ---------------------------------------------------------------------------

ClearFollowerCommandBuffer:
	ld hl, wFollowerCommandBufferSize
	xor a
	ld [hli], a
	ld b, $10
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

AppendFollowerFollowCommandToBuffer:
; a = command to append
	ld b, a
	ld hl, wFollowerCommandBufferSize
	ld a, [hl]
	cp 16
	jr c, .append
	ret ; buffer full: command dropped; FollowerUpdate snaps the follower
		 ; back behind the player when it lags too far
.append
	ld e, a
	ld d, 0
	inc [hl]
	ld hl, wFollowerCommandBuffer
	add hl, de
	ld [hl], b
	ret

GetNextFollowerFollowCommand:
; pop the oldest command, return it in a; carry = buffer empty
	ld hl, wFollowerCommandBufferSize
	ld a, [hl]
	and a
	jr z, .exit
	dec [hl]
	ld b, [hl] ; number of entries to shift down
	ld hl, wFollowerCommandBuffer
	ld a, [hli] ; oldest command
	push af
	ld a, b
	and a
	jr z, .done ; the popped command was the only one: nothing to shift
.shiftLoop
	ld a, [hli]
	dec hl
	dec hl
	ld [hl], a
	inc hl
	inc hl
	dec b
	jr nz, .shiftLoop
.done
	pop af
	and a
	ret
.exit
	scf
	ret

GetFollowerFollowCommandIfBufferSizeNonzero:
; return the newest command in a without consuming it
	ld hl, wFollowerCommandBufferSize
	ld a, [hl]
	and a
	ret z
	dec a
	ld e, a
	ld d, 0
	ld hl, wFollowerCommandBuffer
	add hl, de
	ld a, [hl]
	ret

AreThereAtLeastTwoStepsInFollowerCommandBuffer:
	ld a, [wFollowerCommandBufferSize]
	cp 2
	jr nc, .setCarry
	and a
	ret
.setCarry
	scf
	ret

; ---------------------------------------------------------------------------
; player step hook (called from home/overworld.asm via callba)
; ---------------------------------------------------------------------------

QueueFollowerFollowCommand::
; called when the player starts a walking step: append the same direction
; to the FIFO so the follower retraces the player's path
	ld a, [wSpriteStateData1 + $f0] ; follower picture ID
	and a
	ret z ; follower not spawned on this map
	ld a, [wWalkBikeSurfState]
	and a
	ret nz ; no following while biking or surfing
; the D-pad handlers only set the delta of the pressed axis, so the other
; axis keeps a stale value from a previous step; the current moving
; direction (set from wPlayerDirection on every step start) is reliable
	ld a, [wPlayerMovingDirection]
	and a
	ret z ; no direction (should not happen when a step starts)
	cp PLAYER_DIR_DOWN
	jr z, .down
	cp PLAYER_DIR_UP
	jr z, .up
	cp PLAYER_DIR_LEFT
	jr z, .left
	cp PLAYER_DIR_RIGHT
	jr z, .right
	ret ; unknown direction: nothing to queue
.down
	ld b, 1
	jr .checkLedge
.up
	ld b, 2
	jr .checkLedge
.left
	ld b, 3
	jr .checkLedge
.right
	ld b, 4
.checkLedge
	ld a, [wMovementFlags]
	bit 6, a ; is the player jumping down a ledge?
	jr z, .append
	ld a, b
	add 4 ; far commands 5-8 to cross the ledge gap
	ld b, a
.append
	ld a, b
	jp AppendFollowerFollowCommandToBuffer

; ---------------------------------------------------------------------------
; spawn / position helpers
; ---------------------------------------------------------------------------

TrySpawnFollower::
; called from InitOutsideMapSprites before the VRAM slot assignment loop:
; spawning struct 15 here gets it VRAM slot 2 (SPRITE_FOLLOWER is entry 0
; of every outside sprite set). LoadMapHeader zeroes the structs on every
; map load, so this re-spawns the follower on each map transition.
	ld hl, wFollowerStateFlags
	res 0, [hl] ; follower starts active
	ld a, [wSpriteStateData1 + $f0]
	and a
	ret nz ; already spawned (e.g. after displaying text)
	call GetFollowerSheetEntry
	ret nc ; leader has no follower sheet yet: no follower for now
	ld a, SPRITE_FOLLOWER
	ld [wSpriteStateData1 + $f0], a
	jp CalculateFollowerSpawnCoordsAndFacing

CalculateFollowerSpawnCoordsAndFacing:
; place the follower one tile behind the player, facing the player's
; direction, and leave it in the Init state
	ld a, [wYCoord]
	add $4
	ld e, a
	ld a, [wXCoord]
	add $4
	ld d, a
	ld a, [wSpriteStateData1 + 9] ; player facing
	and a ; SPRITE_FACING_DOWN
	jr z, .above
	cp SPRITE_FACING_UP
	jr z, .below
	cp SPRITE_FACING_LEFT
	jr z, .right
	jr .left
.above
	dec e
	jr .load
.below
	inc e
	jr .load
.right
	inc d
	jr .load
.left
	dec d
.load
	ld hl, wSpriteStateData2 + $f4
	ld [hl], e ; map Y
	inc hl
	ld [hl], d ; map X
	inc hl
	ld [hl], $fe ; movement byte 1: movement is driven by FollowerUpdate
	ld a, [wSpriteStateData1 + 9]
	ld hl, wSpriteStateData1 + $f9
	ld [hl], a ; facing
	xor a
	ld hl, wSpriteStateData1 + $f1
	ld [hl], a ; movement status: Init state
	ld a, $ff
	ld [wSpriteStateData1 + $f2], a ; hidden until the first update
	call ClearFollowerCommandBuffer
	ret

SnapFollowerBehindPlayer:
; teleport the follower behind the player and restart the trail cleanly
	call ClearFollowerCommandBuffer
	call CalculateFollowerSpawnCoordsAndFacing
	jp FollowerMovementState_Init

CheckFollowerDistanceToPlayer:
; carry = the follower is more than 2 tiles away from the player
	ld hl, wSpriteStateData2 + $f4
	ld a, [wYCoord]
	add $4
	sub [hl]
	call .absCheck
	ret c
	inc hl
	ld a, [wXCoord]
	add $4
	sub [hl]
	call .absCheck
	ret
.absCheck
	bit 7, a
	jr z, .positive
	cpl
	inc a
.positive
	cp 4
	jr nc, .far
	and a
	ret
.far
	scf
	ret

; ---------------------------------------------------------------------------
; follower sheets (data/pokemons/follower_sheets.asm, indexed by internal species ID)
; ---------------------------------------------------------------------------

GetFollowerSheetEntry:
; find the leader's (party slot 1) follower sheet entry
; output: carry set = found, de = sheet data ptr, a = ROM bank
; A null entry (no sheet yet) is treated as "no follower".
	ld a, [wPartyMon1Species]
	and a
	jr z, .none ; empty party slot
	ld e, a
	ld d, 0
	ld hl, FollowerSheetTable
	add hl, de
	add hl, de
	add hl, de
	add hl, de ; entry = table + species * 4 (entry 0 = species 0, unused)
; bounds check: the whole 4-byte entry must be inside the table
	ld de, FollowerSheetTableEnd - 3
	ld a, h
	cp d
	jr c, .entryExists
	jr nz, .none
	ld a, l
	cp e
	jr c, .entryExists
	jr .none
.entryExists
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a ; de = sheet data ptr
	ld a, [hli] ; ROM bank
	ld b, a
	or e
	or d
	jr z, .none ; null entry: species has no follower sheet yet
	ld a, b
	scf
	ret
.none
	xor a
	ret

RefreshFollowerSheet::
; overwrite VRAM slot 2 (still: $80C0, walking: $88C0) with the leader's
; follower sheet. Runs after every sprite set (re)load, so it also fixes
; the walking half that LoadMapSpriteTilePatterns re-copies after text.
	ld a, [wWalkBikeSurfState]
	and a
	ret nz ; don't clobber the player's surfing sheet (same VRAM slot)
; save the LCD-safe copy flag and set bit 3 so the copies below use the
; rSTAT-polling copy loop (same idiom as the chimera fix)
	ldh a, [hFlagsFFFA]
	push af
	set 3, a
	ldh [hFlagsFFFA], a
; still half of VRAM slot 2 ($80C0)
	call GetFollowerSheetEntry
	jr c, .still
	jr .done
.still
	ld h, d
	ld l, e
	ld de, vNPCSprites + $c0
	ld bc, $c0
	call FarCopyData2
; walking half of VRAM slot 2 ($88C0)
	call GetFollowerSheetEntry
	jr c, .walking
	jr .done
.walking
	ld h, d
	ld l, e
	ld de, $c0
	add hl, de ; source = sheet + $c0
	ld de, vNPCSprites + $c0 + $800
	ld bc, $c0
	call FarCopyData2
.done
	pop af
	ldh [hFlagsFFFA], a
	ret
