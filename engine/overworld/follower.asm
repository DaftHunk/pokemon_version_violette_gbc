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
; consume commands as they are queued: the follower steps in parallel with
; the player, always landing on the tile they vacate with their current
; step — one tile behind at all times, like the follower in Pokemon
; Yellow. The step animation itself bounds consumption to one command per
; player step: this state only runs again once the follower's step ends.
; when the oldest command heads opposite the player's current direction
; and its replay would step onto their tile (a 180-degree turn just
; happened), hold it: standing this frame lets the next command (the
; new direction) re-enter the trail behind them once they've walked
; on, instead of the replay crossing straight through them
	ld a, [wFollowerCommandBufferSize]
	and a
	jr z, .popCommand
	ld a, [wFollowerCommandBuffer]
	call FollowerCommandWouldCrossPlayer
	jp c, FollowerMovementState_Idle
; hold a far command while its crossing would land on the player:
; mid-jump, or the player standing on its landing tile. The follower
; waits on the takeoff tile and crosses once the landing has freed
; up, like Pokemon Yellow's follower. Only the crossing itself is
; held; approach steps run freely.
	ld a, [wFollowerCommandBuffer]
	cp $5
	jr c, .popCommand
	call FollowerFarCrossingBlocked
	jp c, FollowerMovementState_Idle
.popCommand
	call GetNextFollowerFollowCommand
	jp c, FollowerMovementState_Idle
	call CorrectFollowerFollowStep
; drop the command when its step would land on the tile the player is
; entering: both sprites would end up on the same tile and the next
; replays would keep the follower glued to the player. Standing this
; frame lets the player's step close the gap so the next command can
; land on the tile they just left (the trailing position)
	call FollowerStepWouldLandOnPlayerFrontTile
	jp c, FollowerMovementState_Idle
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
; trail got broken (dropped commands after a full buffer, ledges, etc.).
; A follower standing in front of the player is not a broken trail: the
; player walks through it (DetectCollisionBetweenSprites skips the
; blocking bits for the follower) and it re-enters the trail behind
; them, like the follower in Pokemon Yellow
	call CheckFollowerDistanceToPlayer
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

; carry = the command in a heads opposite the player's current moving
; direction AND the follower sits in their path, one or two tiles away
; on the player's line: replaying it would meet the player head-on (a
; 180-degree turn just happened; one tile apart they swap tiles, two
; apart they land on the same tile and the follower sticks to the
; player). Hold it for a step instead and let the idle snaps or the
; next commands re-enter the trail cleanly.
FollowerCommandWouldCrossPlayer:
	dec a
	and $3 ; fold far commands 5-8 onto their base direction
	ld e, a
	ld d, 0
	ld hl, PlayerDirBitTable
	add hl, de
	ld c, [hl] ; the command's direction bit
	ld a, [wPlayerMovingDirection]
	and a
	ret z ; player standing: never hold
	xor c
	cp $3 ; left/right pair (PLAYER_DIR_RIGHT = 1, PLAYER_DIR_LEFT = 2)?
	jr z, .horizontal
	cp $0c ; down/up pair (PLAYER_DIR_DOWN = 4, PLAYER_DIR_UP = 8)?
	jr z, .vertical
	and a ; same or perpendicular direction: let it replay
	ret
.horizontal
; the follower must be on the player's row, in their path: one or two
; tiles away in the direction the old command heads (from there its
; replay meets the player walking the other way)
	ld a, [wYCoord]
	add $4
	ld h, a
	ld a, [wSpriteStateData2 + $f4]
	sub h
	and a
	ret nz ; not on the player's row
	ld a, [wXCoord]
	add $4
	ld h, a
	ld a, [wSpriteStateData2 + $f5]
	sub h
	ld e, a ; signed follower X offset from the player
	ld a, c
	cp PLAYER_DIR_LEFT
	jr z, .hOldLeft
; the old command steps right (the player now walks left): hold when the
; follower sits 1-2 tiles left of the player
	ld a, e
	cp -1
	jr z, .hold
	cp -2
	jr z, .hold
	and a ; wrong side or too far: let it replay
	ret
.hOldLeft
; the old command steps left (the player now walks right): hold when the
; follower sits 1-2 tiles right of the player
	ld a, e
	cp $1
	jr z, .hold
	cp $2
	jr z, .hold
	and a ; wrong side or too far: let it replay
	ret
.vertical
; the follower must be on the player's column, in their path: one or two
; tiles away in the direction the old command heads
	ld a, [wXCoord]
	add $4
	ld h, a
	ld a, [wSpriteStateData2 + $f5]
	sub h
	and a
	ret nz ; not on the player's column
	ld a, [wYCoord]
	add $4
	ld h, a
	ld a, [wSpriteStateData2 + $f4]
	sub h
	ld e, a ; signed follower Y offset from the player
	ld a, c
	cp PLAYER_DIR_UP
	jr z, .vOldUp
; the old command steps down (the player now walks up): hold when the
; follower sits 1-2 tiles above the player
	ld a, e
	cp -1
	jr z, .hold
	cp -2
	jr z, .hold
	and a ; wrong side or too far: let it replay
	ret
.vOldUp
; the old command steps up (the player now walks down): hold when the
; follower sits 1-2 tiles below the player
	ld a, e
	cp $1
	jr z, .hold
	cp $2
	jr z, .hold
	and a ; wrong side or too far: let it replay
	ret
.hold
	scf
	ret

PlayerDirBitTable:
	db PLAYER_DIR_DOWN, PLAYER_DIR_UP, PLAYER_DIR_LEFT, PLAYER_DIR_RIGHT
 
; carry = the landing tile of the step command in a (1-8) is the tile
; the player is entering with their current step (their front tile).
; This catches the head-on meets the opposite-pair hold above cannot
; see (corrective steps toward the player). Only checked while the
; player is walking; at rest the idle snaps already clean up overlaps.
FollowerStepWouldLandOnPlayerFrontTile:
	ld b, a ; step command
; landing vector: d = dy, pushed dx (doubled for far commands 5-8)
	ld a, b
	dec a
	and $3 ; folded: 0 down, 1 up, 2 left, 3 right
	add a
	ld e, a
	ld d, 0
	ld hl, FollowerStepVectorTable
	add hl, de
	ld a, b
	sub $5 ; carry = near step (1-4)
	ld a, [hli] ; dy
	jr c, .nearY
	add a
.nearY
	ld d, a
	ld a, [hli] ; dx
	jr c, .nearX
	add a
.nearX
	push af
; wWalkCounter, not wPlayerMovingDirection: the moving direction keeps
; its last value at rest (it encodes the player's facing), so it is
; never zero while standing — only the walk counter truly separates
; rest from walking
	ld a, [wWalkCounter]
	and a
	jr z, .standing
	ld a, [wPlayerMovingDirection]
; c = front tile dy, e = front tile dx (from the player's heading)
	ld c, 0
	ld e, 0
	cp PLAYER_DIR_DOWN
	jr z, .frontDown
	cp PLAYER_DIR_UP
	jr z, .frontUp
	cp PLAYER_DIR_LEFT
	jr z, .frontLeft
	inc e ; PLAYER_DIR_RIGHT
	jr .checkAxes
.frontDown
	inc c
	jr .checkAxes
.frontUp
	dec c
	jr .checkAxes
.frontLeft
	dec e
	jr .checkAxes
.standing
; the player is standing: drop a step that lands on their own tile —
; the steady replay from one tile behind would step right onto them,
; and at rest the trail has no vacated tile to retrace. Everything
; else passes freely
	ld c, 0
	ld e, 0
; the front tile is always the tile the player is entering with their
; current step. Ledge jumps get no +2 special case anymore: the far
; command queued for a jump lands on the jump's landing tile, which
; the player enters with their second simulated step — dropping it
; there keeps the follower on the takeoff/ledge tile until the player
; has moved on, and the follow logic then crosses behind them, like
; the follower in Pokemon Yellow
.checkAxes
; the landing tile must equal the front tile on both axes (map coords
; are stored with a +$4 bias, so both sides keep it)
	ld a, [wSpriteStateData2 + $f4]
	add d ; landing Y
	ld h, a
	pop af ; dx
	ld d, a
	ld a, [wYCoord]
	add c ; front tile Y
	add $4
	cp h
	jr nz, .noLand
	ld a, [wSpriteStateData2 + $f5]
	add d ; landing X
	ld h, a
	ld a, [wXCoord]
	add e ; front tile X
	add $4
	cp h
	jr nz, .noLand
	scf
	ret
.noLand
	ld a, b ; restore the command for the caller's table lookup
	and a
	ret

FollowerStepVectorTable:
; dy, dx per folded direction (down, up, left, right)
	db  1,  0
	db -1,  0
	db  0, -1
	db  0,  1

; carry = the far command in a (5-8) must wait this frame: the
; follower stands on the takeoff tile ($c2f9/$c2fa), but the player
; is still mid-jump or on the landing tile (two tiles past the
; takeoff, in the far's direction). Crossing now would land the
; follower on the player; holding the command lets it cross once
; the landing has freed up. Off the takeoff, approach steps run
; freely. Clobbers a/b/d/hl.
FollowerFarCrossingBlocked:
	ld b, a
	ld hl, wSpriteStateData2 + $f4 ; follower map Y (+$4 bias)
	ld a, [$c2f9] ; takeoff map Y
	cp [hl]
	jp nz, .clear
	inc l ; follower map X
	ld a, [$c2fa] ; takeoff map X
	cp [hl]
	jp nz, .clear
; on the takeoff: hold while the player is still jumping
	ld a, [wMovementFlags]
	bit 6, a
	jr nz, .blocked
; or while they stand on the landing tile
	ld a, b
	cp $6
	jr z, .upLanding
	cp $7
	jr z, .leftLanding
	cp $8
	jr z, .rightLanding
; far down ($5): landing = (takeoff Y + 2, takeoff X)
	ld a, [$c2f9]
	inc a
	inc a
	ld d, a
	ld a, [wYCoord]
	add $4
	cp d
	jr nz, .clear
	ld a, [$c2fa]
	ld d, a
	ld a, [wXCoord]
	add $4
	cp d
	jr z, .blocked
	jr .clear
.upLanding
; far up ($6): landing = (takeoff Y - 2, takeoff X)
	ld a, [$c2f9]
	dec a
	dec a
	ld d, a
	ld a, [wYCoord]
	add $4
	cp d
	jr nz, .clear
	ld a, [$c2fa]
	ld d, a
	ld a, [wXCoord]
	add $4
	cp d
	jr z, .blocked
	jr .clear
.leftLanding
; far left ($7): landing = (takeoff Y, takeoff X - 2)
	ld a, [$c2f9]
	ld d, a
	ld a, [wYCoord]
	add $4
	cp d
	jr nz, .clear
	ld a, [$c2fa]
	dec a
	dec a
	ld d, a
	ld a, [wXCoord]
	add $4
	cp d
	jr z, .blocked
	jr .clear
.rightLanding
; far right ($8): landing = (takeoff Y, takeoff X + 2)
	ld a, [$c2f9]
	ld d, a
	ld a, [wYCoord]
	add $4
	cp d
	jr nz, .clear
	ld a, [$c2fa]
	inc a
	inc a
	ld d, a
	ld a, [wXCoord]
	add $4
	cp d
	jr z, .blocked
.clear
	and a
	ret
.blocked
	scf
	ret

CorrectFollowerFollowStep:
; Corrective logic for regular follow commands (1-4).
; If the follower already holds the steady trailing position for this
; command (on the player's line, one or two tiles behind), replay the
; command as-is so it keeps retracing the player's path. Otherwise
; burn it for a corrective step: perpendicular axis first, to get back
; on the player's line, then along it to close the gap (a far, 2-tile
; step when the gap is 3 or more). Steps that cross the player are
; transient while they are walking; at rest a follower that landed
; on the player's tile stands there until they walk on and re-enters
; the trail through them (the player walks through the follower).
; Far commands (5-8) replay as-is.
	ld b, a
	cp $5
	jr c, .nearStep
; ---- far commands (5-8): retrace the player's ledge crossing ----
; the two-tile jump is only valid from the takeoff tile stored at
; queue time ($c2f9/$c2fa); from anywhere else the far converts
; into single corrective steps toward the takeoff, so a follower
; that is merely lined up with the ledge walks back onto the
; crossing line instead of blindly jumping two tiles with no
; ledge under it
	cp $7
	jr nc, .farHorizontal
; far down ($5) / up ($6): the crossing runs along Y
	ld hl, wSpriteStateData2 + $f5 ; follower map X
	ld a, [$c2fa] ; takeoff map X
	cp [hl]
	jr z, .farVertReady
	jr c, .farGoLeft
	ld a, $4 ; right, toward the takeoff column
	ret
.farGoLeft
	ld a, $3 ; left, toward the takeoff column
	ret
.farVertReady
	ld hl, wSpriteStateData2 + $f4 ; follower map Y
	ld a, [$c2f9] ; takeoff map Y
	cp [hl]
	jr z, .farCross
; walk along the crossing line: a folded single step converges
; on the takeoff without ever stepping onto the ledge tile
	ld a, b
	dec a
	and $3
	inc a
	ret
.farHorizontal
; far left ($7) / far right ($8): the crossing runs along X
	ld hl, wSpriteStateData2 + $f4 ; follower map Y
	ld a, [$c2f9] ; takeoff map Y
	cp [hl]
	jr z, .farHorizReady
	jr c, .farGoUp
	ld a, $1 ; down, toward the takeoff row
	ret
.farGoUp
	ld a, $2 ; up, toward the takeoff row
	ret
.farHorizReady
	ld hl, wSpriteStateData2 + $f5 ; follower map X
	ld a, [$c2fa] ; takeoff map X
	cp [hl]
	jr z, .farCross
	ld a, b
	dec a
	and $3
	inc a
	ret
.farCross
; on the takeoff: the hold in ProcessCommand guarantees the landing
; tile is free; cross the gap exactly like the player did
	ld a, b
	ret
.nearStep
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
	ld a, $3			; left
	ret
.vOnColumn
	ld a, b
	cp $1
	jr z, .vDown
; up command: steady when the follower is 1 tile below (d = -1);
; two below while the player walks: far to catch up onto the tile
; they vacate with this step; at rest a single walk step closes it
	ld a, d
	cp -1
	jp z, .replay
	cp -2
	jp z, .vUpCatchUp
	bit 7, a
	jr z, .vAhead		; d >= 0: on the player's tile or ahead of it
	ld a, $6			; up (far): d <= -3
	ret
.vUpCatchUp
	ld a, [wWalkCounter]
	and a
	jp z, .replay		; standing: a single walk step closes it
	ld a, $6			; up (far)
	ret
.vAhead
	ld a, $1			; down: step back (or off the player's tile)
	ret
.vDown
; down command: steady when the follower is 1 tile above (d = 1);
; two tiles above while the player walks: far to catch up onto the
; tile they vacate with this step (real distance 1, like the follower
; in Pokemon Yellow); at rest a single walk step closes it
	ld a, d
	cp $1
	jp z, .replay
	cp $2
	jp z, .vDownCatchUp
	bit 7, a
	jr nz, .vBackUp
	and a
	jp z, .vBackUp		; on the player's tile: step back off it
	ld a, $5			; down (far): d >= 3
	ret
.vBackUp
	ld a, $2			; up
	ret
.vDownCatchUp
	ld a, [wWalkCounter]
	and a
	jr z, .replay		; standing: a single step lands adjacent
	ld a, $5			; down (far)
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
	jr z, .hRightCatchUp
	bit 7, a
	jr nz, .hBackLeft		; e < 0: ahead of the player: step back
	and a
	jr z, .hBackLeft		; on the player's tile: step back off it
	ld a, $8			; right (far): e >= 3
	ret
.hRightCatchUp
	ld a, [wWalkCounter]
	and a
	jr z, .replay		; standing: a single walk step closes it
	ld a, $8			; right (far)
	ret
.hBackLeft
	ld a, $3			; left
	ret
.hLeftCmd
; left command: steady when the follower is 1 tile right (e = -1);
; two right while the player walks: far to catch up onto the tile
; they vacate with this step; at rest a single walk step closes it
	ld a, e
	cp -1
	jr z, .replay
	cp -2
	jr z, .hLeftCatchUp
	bit 7, a
	jr z, .hBackRight		; e > 0: ahead of the player: step back
	and a
	jr z, .hBackRight		; on the player's tile: step back off it
	ld a, $7			; left (far): e <= -3
	ret
.hLeftCatchUp
	ld a, [wWalkCounter]
	and a
	jr z, .replay		; standing: a single walk step closes it
	ld a, $7			; left (far)
	ret
.hBackRight
	ld a, $4			; right
	ret
.replay
	ld a, b
	ret

FollowerGetStepTicks:
; a = ticks in a full player step at the current frame rate: $8 at 30fps
; (8 frames per tile, 2 pixels each), $10 at 60fps (16 frames per tile,
; 1 pixel each) — the same value home/overworld.asm loads into
; wWalkCounter, so the follower's steps span exactly the player's steps.
; BIT_GRAPHIC_60_FPS clear (z) = 30fps, matching Check60fps' polarity
	ld a, [wGraphicOptions]
	bit BIT_GRAPHIC_60_FPS, a
	ld a, $8
	ret z
	ld a, $10
	ret

NormalFollowerFollow:
	call FollowerGetStepTicks
	ld hl, wSpriteStateData2 + $f8
	ld [hl], a
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
; running steps are half as long: the player advances twice per frame
	call FollowerGetStepTicks
	srl a
	ld hl, wSpriteStateData2 + $f8
	ld [hl], a
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
	call FollowerGetStepTicks
	ld hl, wSpriteStateData2 + $f8
	ld [hl], a
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
; 4 pixels per tick at 30fps, 2 pixels per tick at 60fps: the far and
; running steps still cover their tiles within the player's step time
	ld a, [wGraphicOptions]
	bit BIT_GRAPHIC_60_FPS, a
	jr z, .doubleRate
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
.doubleRate
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
; move the screen pixels by the step slice for one tick: 2 pixels per
; tick at 30fps (8 ticks per tile), 1 pixel per tick at 60fps (16 ticks
; per tile) — mirroring AdvancePlayerSprite, which doubles its scroll
; deltas at 30fps only
	ld a, [wGraphicOptions]
	bit BIT_GRAPHIC_60_FPS, a
	jr z, .doubleRate
	ld hl, wSpriteStateData1 + $f3
	ld a, [hli] ; delta Y
	add [hl] ; Y pixels
	ld [hli], a
	ld a, [hli] ; delta X
	add [hl] ; X pixels
	ld [hl], a
	ret
.doubleRate
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
; Advance the walk frame at a fixed interval of 4 ticks (3 when running
; with B held), doubled to 8 (6) at 60fps: a tile takes twice as many
; ticks there, so the pose rhythm stays locked to the tile — two pose
; changes per tile at any frame rate, matching the player's gait
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
	ld a, [wGraphicOptions]
	bit BIT_GRAPHIC_60_FPS, a
	jr z, .gotInterval2 ; 30fps: ticks already match the player's frames
	sla b ; 60fps: a tile takes twice as many ticks
.gotInterval2
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
	jr z, .notLedge
; a ledge jump runs as TWO simulated steps, so this hook fires twice
; per jump. Queue the far command on the first step only and swallow
; the second: with two fars the follower would cross four tiles while
; the player jumps two and end up in front of them (pokeyellow does
; the same with a latch in PikachuLedgeOrFishingDirection)
	ld hl, wFollowerStateFlags
	bit 1, [hl]
	jr nz, .secondLedgeStep
	set 1, [hl]
; remember the takeoff tile: the follower may only cross the two-tile
; ledge gap from here ($c2f9/$c2fa hold map Y/X with the same +$4
; bias as the follower's own coords in c2f4/c2f5)
	ld a, [wYCoord]
	add $4
	ld [$c2f9], a
	ld a, [wXCoord]
	add $4
	ld [$c2fa], a
	ld a, b
	add 4 ; far commands 5-8 to cross the ledge gap
	ld b, a
	jr .append
.secondLedgeStep
	res 1, [hl]
	ret
.notLedge
; normal step: clear the latch for the next jump
	ld hl, wFollowerStateFlags
	res 1, [hl]
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
