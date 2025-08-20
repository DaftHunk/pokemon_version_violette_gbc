UpdatePlayerSprite:
	ld a, [wSpriteStateData2]
	and a
	jr z, .checkIfTextBoxInFrontOfSprite
	cp $ff
	jr z, .disableSprite
	dec a
	ld [wSpriteStateData2], a
	jr .disableSprite
; check if a text box is in front of the sprite by checking if the lower left
; background tile the sprite is standing on is greater than $5F, which is
; the maximum number for map tiles
.checkIfTextBoxInFrontOfSprite
	aCoord 8, 9
	ld [hTilePlayerStandingOn], a
	cp $79
	jr c, .lowerLeftTileIsMapTile
.disableSprite
	ld a, $ff
	ld [wSpriteStateData1 + 2], a
	ret
.lowerLeftTileIsMapTile
	call DetectCollisionBetweenSprites
	ld h, wSpriteStateData1 / $100
	ld a, [wWalkCounter]
	and a
	jr nz, .moving
	ld a, [wPlayerMovingDirection]
; check if down
	bit PLAYER_DIR_BIT_DOWN, a
	jr z, .checkIfUp
	xor a ; ld a, SPRITE_FACING_DOWN
	jr .next
.checkIfUp
	bit PLAYER_DIR_BIT_UP, a
	jr z, .checkIfLeft
	ld a, SPRITE_FACING_UP
	jr .next
.checkIfLeft
	bit PLAYER_DIR_BIT_LEFT, a
	jr z, .checkIfRight
	ld a, SPRITE_FACING_LEFT
	jr .next
.checkIfRight
	bit PLAYER_DIR_BIT_RIGHT, a
	jr z, .notMoving
	ld a, SPRITE_FACING_RIGHT
	jr .next
.notMoving
; zero the animation counters
	xor a
	ld [wSpriteStateData1 + 7], a
	ld [wSpriteStateData1 + 8], a
	jr .calcImageIndex
.next
	ld [wSpriteStateData1 + 9], a ; facing direction
	ld a, [wFontLoaded]
	bit 0, a
	jr nz, .notMoving
.moving
	ld a, [wd736]
	bit 7, a ; is the player sprite spinning due to a spin tile?
	jr nz, .skipSpriteAnim
	ld a, [H_CURRENTSPRITEOFFSET]
	add $7
	ld l, a
	ld a, [hl]
	inc a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;60fps - only update every other tick	
	call sprite60fps
	sub b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	ld [hl], a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - If B is being held to go faster and full joypad is enabled (i.e. not in a cutscene),
;Then increase player animation speed by 25%
	push bc
	ld c, 4
	ld b, a
	ld a, [wJoyIgnore]
	and a
	jr nz, .doneSpeed
	ld a, [hJoyHeld]
	and B_BUTTON
	jr z, .doneSpeed
	ld c, 3
.doneSpeed
	ld a, b
	cp c
	pop bc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	jr nz, .calcImageIndex
	jr c, .calcImageIndex	;joenote - prevents interframe counter from increasing forever
	xor a
	ld [hl], a
	inc hl
	ld a, [hl]
	inc a
	and $3
	ld [hl], a
.calcImageIndex
	ld a, [wSpriteStateData1 + 8]
	ld b, a
	ld a, [wSpriteStateData1 + 9]
	add b
	ld [wSpriteStateData1 + 2], a
.skipSpriteAnim
; If the player is standing on a grass tile, make the player's sprite have
; lower priority than the background so that it's partially obscured by the
; grass. Only the lower half of the sprite is permitted to have the priority
; bit set by later logic.
	ld a, [hTilePlayerStandingOn]
	ld c, a
	ld a, [wGrassTile]
	cp c
	ld a, $0
	jr nz, .next2
	ld a, $80
.next2
	ld [wSpriteStateData2 + 7], a
	ret

UnusedReadSpriteDataFunction:
	push bc
	push af
	ld a, [H_CURRENTSPRITEOFFSET]
	ld c, a
	pop af
	add c
	ld l, a
	pop bc
	ret

UpdateNPCSprite:
	ld a, [H_CURRENTSPRITEOFFSET]
	swap a
	dec a
	add a
	ld hl, wMapSpriteData
	add l
	
;joenote - Increment H if A overflows. Otherwise H will hold $D4 instead of $D5 like it should.
;This fixes some issues with the 15th map object.
	jr nc, .no_carry
	inc h
.no_carry
	
	ld l, a
	ld a, [hl]        ; read movement byte 2
	ld [wCurSpriteMovement2], a
	ld h, $c1
	ld a, [H_CURRENTSPRITEOFFSET]
	ld l, a
	inc l
	ld a, [hl]        ; c1x1
	and a
	jp z, InitializeSpriteStatus
	call CheckSpriteAvailability
	ret c             ; if sprite is invisible, on tile >=$79, in grass or player is currently walking
	ld h, $c1
	ld a, [H_CURRENTSPRITEOFFSET]
	ld l, a
	inc l
	ld a, [hl]        ; c1x1
	bit 7, a ; is the face player flag set?
	jp nz, MakeNPCFacePlayer
	ld b, a
	ld a, [wFontLoaded]
	bit 0, a
	jp nz, notYetMoving
	ld a, b
	cp $2
	jp z, UpdateSpriteMovementDelay  ; c1x1 == 2
	cp $3
	jp z, UpdateSpriteInWalkingAnimation  ; c1x1 == 3
	ld a, [wWalkCounter]	;joenote - Do the check here and remove the redundancy from CheckSpriteAvailability
	and a					;			so that npc walking animations get updated while the player is moving.
	ret nz           ; don't do anything yet if player is currently moving (redundant, already tested in CheckSpriteAvailability)
	call InitializeSpriteScreenPosition
	ld h, $c2
	ld a, [H_CURRENTSPRITEOFFSET]
	add $6
	ld l, a
	ld a, [hl]       ; c2x6: movement byte 1
	inc a
	jr z, .randomMovement  ; value $FF
	inc a
	jr z, .randomMovement  ; value $FE
; scripted movement
	dec a
	ld [hl], a       ; increment movement byte 1 (movement data index)
	dec a
	push hl
	ld hl, wNPCNumScriptedSteps
	dec [hl]         ; decrement wNPCNumScriptedSteps
	pop hl
	ld de, wNPCMovementDirections
	call LoadDEPlusA ; a = [wNPCMovementDirections + movement byte 1]
	cp $e0
	jp z, ChangeFacingDirection
	cp STAY
	jr nz, .next
; reached end of wNPCMovementDirections list
	ld [hl], a ; store $ff in movement byte 1, disabling scripted movement
	ld hl, wd730
	res 0, [hl]
	xor a
	ld [wSimulatedJoypadStatesIndex], a
	ret
.next
	cp WALK
	jr nz, .determineDirection
; current NPC movement data is $fe. this seems buggy
	ld [hl], $1     ; set movement byte 1 to $1
	ld de, wNPCMovementDirections
	call LoadDEPlusA ; a = [wNPCMovementDirections + $fe] (?)
	jr .determineDirection
.randomMovement
	call GetTileSpriteStandsOn
	push hl
	push de
	callba CheckForcedFacing
	ld a, d
	pop de
	pop hl
	jr c, .determineDirection
	call Random
.determineDirection
	ld b, a
	ld a, [wCurSpriteMovement2]
	cp $d0
	jr z, .moveDown    ; movement byte 2 = $d0 forces down
	cp $d1
	jr z, .moveUp      ; movement byte 2 = $d1 forces up
	cp $d2
	jr z, .moveLeft    ; movement byte 2 = $d2 forces left
	cp $d3
	jr z, .moveRight   ; movement byte 2 = $d3 forces right
	ld a, b
	cp $40             ; a < $40: down (or left)
	jr nc, .notDown
	ld a, [wCurSpriteMovement2]
	cp $2
	jr z, .moveLeft    ; movement byte 2 = $2 only allows left or right
.moveDown
	ld de, 2*SCREEN_WIDTH
	add hl, de         ; move tile pointer two rows down
	lb de, 1, 0
	lb bc, 4, SPRITE_FACING_DOWN
	jr TryWalking
.notDown
	cp $80             ; $40 <= a < $80: up (or right)
	jr nc, .notUp
	ld a, [wCurSpriteMovement2]
	cp $2
	jr z, .moveRight   ; movement byte 2 = $2 only allows left or right
.moveUp
	ld de, -2*SCREEN_WIDTH
	add hl, de         ; move tile pointer two rows up
	lb de, -1, 0
	lb bc, 8, SPRITE_FACING_UP
	jr TryWalking
.notUp
	cp $c0             ; $80 <= a < $c0: left (or up)
	jr nc, .notLeft
	ld a, [wCurSpriteMovement2]
	cp $1
	jr z, .moveUp      ; movement byte 2 = $1 only allows up or down
.moveLeft
	dec hl
	dec hl             ; move tile pointer two columns left
	lb de, 0, -1
	lb bc, 2, SPRITE_FACING_LEFT
	jr TryWalking
.notLeft              ; $c0 <= a: right (or down)
	ld a, [wCurSpriteMovement2]
	cp $1
	jr z, .moveDown    ; movement byte 2 = $1 only allows up or down
.moveRight
	inc hl
	inc hl             ; move tile pointer two columns right
	lb de, 0, 1
	lb bc, 1, SPRITE_FACING_RIGHT
	jr TryWalking

; changes facing direction by zeroing the movement delta and calling TryWalking
ChangeFacingDirection:
	ld de, $0
	; fall through

; b: direction (1,2,4 or 8)
; c: new facing direction (0,4,8 or $c)
; d: Y movement delta (-1, 0 or 1)
; e: X movement delta (-1, 0 or 1)
; hl: pointer to tile the sprite would walk onto
; set carry on failure, clears carry on success
TryWalking:
	push hl
	ld h, $c1
	ld a, [H_CURRENTSPRITEOFFSET]
	add $9
	ld l, a
	ld [hl], c          ; c1x9 (update facing direction)
	ld a, [H_CURRENTSPRITEOFFSET]
	add $3
	ld l, a
	ld [hl], d          ; c1x3 (update Y movement delta)
	inc l
	inc l
	ld [hl], e          ; c1x5 (update X movement delta)
	pop hl
	push de
	ld c, [hl]          ; read tile to walk onto
	call CanWalkOntoTile
	pop de
	ret c               ; cannot walk there (reinitialization of delay values already done)
	ld h, $c2
	ld a, [H_CURRENTSPRITEOFFSET]
	add $4
	ld l, a
	ld a, [hl]          ; c2x4: Y position
	add d
	ld [hli], a         ; update Y position
	ld a, [hl]          ; c2x5: X position
	add e
	ld [hl], a          ; update X position
	ld a, [H_CURRENTSPRITEOFFSET]
	ld l, a
	ld [hl], $10        ; c2x0=16: walk animation counter
	dec h
	inc l
	ld [hl], $3         ; c1x1: set movement status to walking
	jp UpdateSpriteImage

; update the walking animation parameters for a sprite that is currently walking
UpdateSpriteInWalkingAnimation:
	ld a, [H_CURRENTSPRITEOFFSET]
	add $7
	ld l, a
	ld a, [hl]                       ; c1x7 (counter until next walk animation frame)
	inc a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;60fps - updated xy every other tick
	call sprite60fps	
	push bc
	sub b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
	ld [hl], a                       ; c1x7 += 1
	cp $4
	jr nz, .noNextAnimationFrame
	xor a
	ld [hl], a                       ; c1x7 = 0
	inc l
	ld a, [hl]                       ; c1x8 (walk animation frame)
	inc a
	and $3
	ld [hl], a                       ; advance to next animation frame every 4 ticks (16 ticks total for one step)
.noNextAnimationFrame
	ld a, [H_CURRENTSPRITEOFFSET]
	add $3
	ld l, a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;60fps - updated xy every other tick
	pop bc
	push bc
	ld a, b
	and a 
	jr nz, .xydone
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	ld a, [hli]                      ; c1x3 (movement Y delta)
	ld b, a
	ld a, [hl]                       ; c1x4 (screen Y position)
	add b
	ld [hli], a                      ; update screen Y position
	ld a, [hli]                      ; c1x5 (movement X delta)
	ld b, a
	ld a, [hl]                       ; c1x6 (screen X position)
	add b
	ld [hl], a                       ; update screen X position
.xydone
	ld a, [H_CURRENTSPRITEOFFSET]
	ld l, a
	inc h
	ld a, [hl]                       ; c2x0 (walk animation counter)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;60fps - make the delay decounter update every other tick	
	pop bc
	add b	;60fps
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	dec a
	ld [hl], a                       ; update walk animation counter
	ret nz
	ld a, $6                         ; walking finished, update state
	add l
	ld l, a
	ld a, [hl]                       ; c2x6 (movement byte 1)
	cp $fe
	jr nc, .initNextMovementCounter  ; values $fe and $ff
	ld a, [H_CURRENTSPRITEOFFSET]
	inc a
	ld l, a
	dec h
	ld [hl], $1                      ; c1x1 = 1 (movement status ready)
	ret
.initNextMovementCounter
	call Random
	ld a, [H_CURRENTSPRITEOFFSET]
	add $8
	ld l, a
	ld a, [hRandomAdd]
	and $7f
	inc a			;joenote - fix the oversight that can make the delay $100
	ld [hl], a                       ; c2x8: set next movement delay to a random value in [0,$7f]
	dec h                            ;       note that value 0 actually makes the delay $100 (bug?)
	ld a, [H_CURRENTSPRITEOFFSET]
	inc a
	ld l, a
	ld [hl], $2                      ; c1x1 = 2 (movement status)
	inc l
	inc l
	xor a
	ld b, [hl]                       ; c1x3 (movement Y delta)
	ld [hli], a                      ; reset movement Y delta
	inc l
	ld c, [hl]                       ; c1x5 (movement X delta)
	ld [hl], a                       ; reset movement X delta
	ret

sprite60fps:
	push hl
	push af
	ld h, $c2
	ld l, $0a
	ld a, [H_CURRENTSPRITEOFFSET]
	add l
	ld l, a
	ld a, [wGameplayOptions]
	bit 4, a
	ld a, [hl]
	jr nz, .is60fps
	xor a
	jr .end
.is60fps
	xor $01
.end
	ld [hl], a
	ld b, a
	pop af
	pop hl
	ret

; update delay value (c2x8) for sprites in the delayed state (c1x1)
UpdateSpriteMovementDelay:
	ld h, $c2
	ld a, [H_CURRENTSPRITEOFFSET]
	add $6
	ld l, a
	ld a, [hl]              ; c2x6: movement byte 1
	inc l
	inc l
	cp $fe
	jr nc, .tickMoveCounter ; values $fe or $ff
	ld [hl], $0
	jr .moving
.tickMoveCounter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;60fps - make the delay decounter update every other tick
	ld a, [hl]
	call sprite60fps
	add b
	ld [hl], a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	dec [hl]                ; c2x8: frame counter until next movement
	jr nz, notYetMoving
.moving
	dec h
	ld a, [H_CURRENTSPRITEOFFSET]
	inc a
	ld l, a
	ld [hl], $1             ; c1x1 = 1 (mark as ready to move)
notYetMoving:
	ld h, wSpriteStateData1 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	add $8
	ld l, a
	ld [hl], $0             ; c1x8 = 0 (walk animation frame)
	jp UpdateSpriteImage

MakeNPCFacePlayer:
; Make an NPC face the player if the player has spoken to him or her.

; Check if the behaviour of the NPC facing the player when spoken to is
; disabled. This is only done when rubbing the S.S. Anne captain's back.
	ld a, [wd72d]
	bit 5, a
	jr nz, notYetMoving
	res 7, [hl]
	ld a, [wPlayerDirection]
	bit PLAYER_DIR_BIT_UP, a
	jr z, .notFacingDown
	ld c, SPRITE_FACING_DOWN
	jr .facingDirectionDetermined
.notFacingDown
	bit PLAYER_DIR_BIT_DOWN, a
	jr z, .notFacingUp
	ld c, SPRITE_FACING_UP
	jr .facingDirectionDetermined
.notFacingUp
	bit PLAYER_DIR_BIT_LEFT, a
	jr z, .notFacingRight
	ld c, SPRITE_FACING_RIGHT
	jr .facingDirectionDetermined
.notFacingRight
	ld c, SPRITE_FACING_LEFT
.facingDirectionDetermined
	ld a, [H_CURRENTSPRITEOFFSET]
	add $9
	ld l, a
	ld [hl], c              ; c1x9: set facing direction
	jr notYetMoving

InitializeSpriteStatus:
	ld [hl], $1   ; $c1x1: set movement status to ready
	inc l
	ld [hl], $ff  ; $c1x2: set sprite image to $ff (invisible/off screen)
	inc h
	ld a, [H_CURRENTSPRITEOFFSET]
	add $2
	ld l, a
	ld a, $8
	ld [hli], a   ; $c2x2: set Y displacement to 8
	ld [hl], a    ; $c2x3: set X displacement to 8
	;ret
	;fall through to InitializeSpriteScreenPosition
	;This is essentially what Pokemon Yellow does to fix the amazing man glitch

; calculates the sprite's screen position form its map position and the player position
InitializeSpriteScreenPosition:
	ld h, wSpriteStateData2 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	add $4
	ld l, a
	ld a, [wYCoord]
	ld b, a
	ld a, [hl]      ; c2x4 (Y position + 4)
	sub b           ; relative to player position
	swap a          ; * 16
	sub $4          ; - 4
	dec h
	ld [hli], a     ; c1x4 (screen Y position)
	inc h
	ld a, [wXCoord]
	ld b, a
	ld a, [hli]     ; c2x6 (X position + 4)
	sub b           ; relative to player position
	swap a          ; * 16
	dec h
	ld [hl], a      ; c1x6 (screen X position)
	ret

; tests if sprite is off screen or otherwise unable to do anything
CheckSpriteAvailability:
	predef IsObjectHidden
	ld a, [$ffe5]
	and a
	jp nz, .spriteInvisible
	ld h, wSpriteStateData2 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	add $6
	ld l, a
	ld a, [hl]      ; c2x6: movement byte 1
	cp $fe
	jr c, .skipXVisibilityTest ; movement byte 1 < $fe (i.e. the sprite's movement is scripted)
	ld a, [H_CURRENTSPRITEOFFSET]
	add $4
	ld l, a
	ld b, [hl]      ; c2x4: Y pos (+4)
	ld a, [wYCoord]
	cp b
	jr z, .skipYVisibilityTest
	jr nc, .spriteInvisible ; above screen region
	add $8                  ; screen is 9 tiles high
	cp b
	jr c, .spriteInvisible  ; below screen region
.skipYVisibilityTest
	inc l
	ld b, [hl]      ; c2x5: X pos (+4)
	ld a, [wXCoord]
	cp b
	jr z, .skipXVisibilityTest
	jr nc, .spriteInvisible ; left of screen region
	add $9                  ; screen is 10 tiles wide
	cp b
	jr c, .spriteInvisible  ; right of screen region
.skipXVisibilityTest
; make the sprite invisible if a text box is in front of it
; $5F is the maximum number for map tiles

;joenote - have to check for both rounding down and up for standing on a tile or else moving NPCs may overlap windows
	call GetTileSpriteStandsOn
	call .VisibilityTest
	jr nc, .spriteInvisible
	call GetTileSpriteStandsOn_roundUP
	call .VisibilityTest
	jr c, .spriteVisible

.spriteInvisible
	ld h, wSpriteStateData1 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	add $2
	ld l, a
	ld [hl], $ff       ; c1x2
	scf
	jr .done
.spriteVisible
	ld c, a
	call UpdateSpriteImage

	ld a, [wWalkCounter]	;joenote - move this below UpdateSpriteImage
	and a
	jr nz, .done           ; if player is currently walking, do not update the status of grass above the sprite

	inc h
	ld a, [H_CURRENTSPRITEOFFSET]
	add $7
	ld l, a
	ld a, [wGrassTile]
	cp c
	ld a, $0
	jr nz, .notInGrass
	ld a, $80
.notInGrass
	ld [hl], a       ; c2x7
	and a
.done
	ret
.VisibilityTest	;clear the carry flag if invisible, or set the flag if visible
	ld d, $79
	ld a, [hli]
	cp d
	ret nc ; standing on tile with ID >=$79 (bottom left tile)
	ld a, [hld]
	cp d
	ret nc ; standing on tile with ID >=$79 (bottom right tile)
	ld bc, -20
	add hl, bc              ; go back one row of tiles
	ld a, [hli]
	cp d
	ret nc ; standing on tile with ID >=$79 (top left tile)
	ld a, [hl]
	cp d
	ret    ; nc if standing on tile with ID >=$79 (top right tile)


UpdateSpriteImage:
	ld h, $c1
	ld a, [H_CURRENTSPRITEOFFSET]
	add $8
	ld l, a
	ld a, [hli]        ; c1x8: walk animation frame
	ld b, a
	ld a, [hl]         ; c1x9: facing direction
	add b
	ld b, a
	ld a, [$ff93]  ; current sprite offset
	add b
	ld b, a
	ld a, [H_CURRENTSPRITEOFFSET]
	add $2
	ld l, a
	ld [hl], b         ; c1x2: sprite to display
	ret

; tests if sprite can walk the specified direction
; b: direction (1,2,4 or 8)
; c: ID of tile the sprite would walk onto
; d: Y movement delta (-1, 0 or 1)
; e: X movement delta (-1, 0 or 1)
; set carry on failure, clears carry on success
CanWalkOntoTile:
	ld h, wSpriteStateData2 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	add $6
	ld l, a
	ld a, [hl]         ; c2x6 (movement byte 1)
	cp $fe
	jr nc, .notScripted    ; values $fe and $ff
; always allow walking if the movement is scripted
	and a
	ret
.notScripted
;;;;;;;;;; PureRGBnote: CHANGED: unified code for checking if a tile is passable
	push bc
	push de
	ld d, c
	callfar _CheckTilePassable
	pop de
	pop bc
	jr c, .impassable
;;;;;;;;;;
	ld h, $c2
	ld a, [H_CURRENTSPRITEOFFSET]
	add $6
	ld l, a
	ld a, [hl]         ; $c2x6 (movement byte 1)
	inc a
	jr z, .impassable  ; if $ff, no movement allowed (however, changing direction is)
	ld h, wSpriteStateData1 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	add $4
	ld l, a
;joenote - needs to be $81 and $91 because the column/row is visible
	ld a, [hli]        ; c1x4 (screen Y pos)
	add $4             ; align to blocks (Y pos is always 4 pixels off)
	add d              ; add Y delta
;	cp $80             ; if value is >$80, the destination is off screen (either $81 or $FF underflow)
	cp $81
	jr nc, .impassable ; don't walk off screen
	inc l
	ld a, [hl]         ; c1x6 (screen X pos)
	add e              ; add X delta
;	cp $90             ; if value is >$90, the destination is off screen (either $91 or $FF underflow)
	cp $91
	jr nc, .impassable ; don't walk off screen
	push de
	push bc
	call DetectCollisionBetweenSprites
	pop bc
	pop de
	ld h, wSpriteStateData1 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	add $c
	ld l, a
	ld a, [hl]         ; c1xc (directions in which sprite collision would occur)
	and b              ; check against chosen direction (1,2,4 or 8)
	jr nz, .impassable ; collision between sprites, don't go there
	ld h, wSpriteStateData2 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	add $2
	ld l, a
	ld a, [hli]        ; c2x2 (sprite Y displacement, initialized at $8, keep track of where a sprite did go)
	bit 7, d           ; check if going upwards (d=$ff)
	jr nz, .upwards
	add d
;bug: this tests probably were supposed to prevent sprites
; from walking out too far, but this line makes sprites get stuck
; whenever they walked upwards 5 steps
; on the other hand, the amount a sprite can walk out to the
; right of bottom is not limited (until the counter overflows)

;joenote - time to fix this
;	cp $5	; if c2x2+d < 5, don't go 
;	jr c, .impassable  
	cp $E	;joenote - if wanting to move downwards, don't go if c2x2+d > $D (that's 5 spaces from inital position)
	jr nc, .impassable
	jr .checkHorizontal                          
.upwards                                         
	sub $1	
	cp $3	;joenote - if wanting to move upwards, don't go if c2x2 -1 < 3 (that's 5 spaces from inital position)
	jr c, .impassable  
.checkHorizontal
	ld d, a
	ld a, [hl]         ; c2x3 (sprite X displacement, initialized at $8, keep track of where a sprite did go)
	bit 7, e           ; check if going left (e=$ff)
	jr nz, .left
	add e
;	cp $5              ; compare, but no conditional jump like in the vertical check above (bug?)
	cp $E	;joenote - if wanting to move right, don't go if c2x3+e > $D (that's 5 spaces from inital position)
	jr nc, .impassable
	jr .passable
.left
	sub $1	
	cp $3	;joenote - if wanting to move left, don't go if c2x3 - 1 < 3 (that's 5 spaces from inital position)
	jr c, .impassable  
.passable
	ld [hld], a        ; update c2x3
	ld [hl], d         ; update c2x2
	and a              ; clear carry (marking success)
	ret
.impassable
	ld h, $c1
	ld a, [H_CURRENTSPRITEOFFSET]
	inc a
	ld l, a
	ld [hl], $2        ; c1x1 = 2 (set movement status to delayed)
	inc l
	inc l
	xor a
	ld [hli], a        ; c1x3 = 0 (clear Y movement delta)
	inc l
	ld [hl], a         ; c1x5 = 0 (clear X movement delta)
	inc h
	ld a, [H_CURRENTSPRITEOFFSET]
	add $8
	ld l, a
	call Random
	ld a, [hRandomAdd]
	and $7f
	ld [hl], a         ; c2x8: set next movement delay to a random value in [0,$7f] (again with delay $100 if value is 0)
	scf                ; set carry (marking failure to walk)
	ret

; calculates the tile pointer pointing to the tile the current sprite stands on
; this is always the lower left tile of the 2x2 tile blocks all sprites are snapped to
; hl: output pointer
GetTileSpriteStandsOn_roundUP:
	ld h, wSpriteStateData1 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	add $4
	ld l, a
	ld a, [hli]     ; c1x4: screen Y position
	add $4          ; align to 2*2 tile blocks (Y position is always off 4 pixels to the top)
	jr GetTileSpriteStandsOn.round_up
	
GetTileSpriteStandsOn:
	ld h, wSpriteStateData1 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	add $4
	ld l, a
	ld a, [hli]     ; c1x4: screen Y position
	add $4          ; align to 2*2 tile blocks (Y position is always off 4 pixels to the top)
	and $f0         ; in case object is currently moving
	jr .done_rounding
	
;joenote - Simply ANDing with F0 rounds-down the pixel positioning to the starting Y-position of the previous movement space.
;		- This treats the sprite as standing in a higher position on the screen than where it actually is.
;		- It allows for downward-moving sprites to stand over text boxes.
;		- Correct this behavior by rounding-up instead.
.round_up
	ld c, a
	and $F0
	ld b, a
	ld a, c
	and $0F
	jr z, .next
	ld a, $10
.next
	add b

.done_rounding
	srl a           ; screen Y tile * 4
	ld c, a
	ld b, $0
	inc l
	ld a, [hl]      ; c1x6: screen X position
	srl a
	srl a
	srl a            ; screen X tile
	add SCREEN_WIDTH ; screen X tile + 20
	ld d, $0
	ld e, a
	coord hl, 0, 0
	add hl, bc
	add hl, bc
	add hl, bc
	add hl, bc
	add hl, bc
	add hl, de     ; wTileMap + 20*(screen Y tile + 1) + screen X tile
	ret

; loads [de+a] into a
LoadDEPlusA:
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	ld a, [de]
	ret

DoScriptedNPCMovement:
; This is an alternative method of scripting an NPC's movement and is only used
; a few times in the game. It is used when the NPC and player must walk together
; in sync, such as when the player is following the NPC somewhere. An NPC can't
; be moved in sync with the player using the other method.
	ld a, [wd730]
	bit 7, a
	ret z
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;60fps - update animations every other frame and halve movement
	ld de, $00
	ld a, [wGameplayOptions]
	bit 4, a
	jr z, .not60fps
	call sprite60fps
	ld e, b
	ld d, $01
.not60fps
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	ld hl, wd72e
	bit 7, [hl]
	set 7, [hl]
	jp z, InitScriptedNPCMovement
	ld hl, wNPCMovementDirections2
	ld a, [wNPCMovementDirections2Index]
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld a, [hl]
; check if moving up
	cp NPC_MOVEMENT_UP
	jr nz, .checkIfMovingDown
	call GetSpriteScreenYPointer
	ld c, SPRITE_FACING_UP
	ld a, -2
	
	add d	;60fps
	
	jr .move
.checkIfMovingDown
	cp NPC_MOVEMENT_DOWN
	jr nz, .checkIfMovingLeft
	call GetSpriteScreenYPointer
	ld c, SPRITE_FACING_DOWN
	ld a, 2
	
	sub d	;60fps
	
	jr .move
.checkIfMovingLeft
	cp NPC_MOVEMENT_LEFT
	jr nz, .checkIfMovingRight
	call GetSpriteScreenXPointer
	ld c, SPRITE_FACING_LEFT
	ld a, -2
	
	add d	;60fps
	
	jr .move
.checkIfMovingRight
	cp NPC_MOVEMENT_RIGHT
	jr nz, .noMatch
	call GetSpriteScreenXPointer
	ld c, SPRITE_FACING_RIGHT
	ld a, 2
	
	sub d	;60fps
	
	jr .move
.noMatch
	cp $ff
	ret
.move
	ld b, a
	ld a, [hl]
	add b
	ld [hl], a
	ld a, [H_CURRENTSPRITEOFFSET]
	add $9
	ld l, a
	ld a, c
	ld [hl], a ; facing direction
	call AnimScriptedNPCMovement
	ld hl, wScriptedNPCWalkCounter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;60fps - every other frame, do not decrement walk counter
	ld a, [hl]
	add e
	ld [hl], a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	dec [hl]
	ret nz
	ld a, 8
	ld [wScriptedNPCWalkCounter], a
	ld hl, wNPCMovementDirections2Index
	inc [hl]
	ret

InitScriptedNPCMovement:
	xor a
	ld [wNPCMovementDirections2Index], a
	ld a, 8
	ld [wScriptedNPCWalkCounter], a
	jp AnimScriptedNPCMovement

GetSpriteScreenYPointer:
	ld a, $4
	ld b, a
	jr GetSpriteScreenXYPointerCommon

GetSpriteScreenXPointer:
	ld a, $6
	ld b, a

GetSpriteScreenXYPointerCommon:
	ld hl, wSpriteStateData1
	ld a, [H_CURRENTSPRITEOFFSET]
	add l
	add b
	ld l, a
	ret

AnimScriptedNPCMovement:
	ld hl, wSpriteStateData2
	ld a, [H_CURRENTSPRITEOFFSET]
	add $e
	ld l, a
	ld a, [hl] ; VRAM slot
	dec a
	swap a
	ld b, a
	ld hl, wSpriteStateData1
	ld a, [H_CURRENTSPRITEOFFSET]
	add $9
	ld l, a
	ld a, [hl] ; facing direction
	cp SPRITE_FACING_DOWN
	jr z, .anim
	cp SPRITE_FACING_UP
	jr z, .anim
	cp SPRITE_FACING_LEFT
	jr z, .anim
	cp SPRITE_FACING_RIGHT
	jr z, .anim
	ret
.anim
	add b
	ld b, a
	ld [hSpriteVRAMSlotAndFacing], a
	call AdvanceScriptedNPCAnimFrameCounter
	ld hl, wSpriteStateData1
	ld a, [H_CURRENTSPRITEOFFSET]
	add $2
	ld l, a
	ld a, [hSpriteVRAMSlotAndFacing]
	ld b, a
	ld a, [hSpriteAnimFrameCounter]
	add b
	ld [hl], a
	ret

AdvanceScriptedNPCAnimFrameCounter:
	ld a, [H_CURRENTSPRITEOFFSET]
	add $7
	ld l, a
	ld a, [hl] ; intra-animation frame counter
	inc a
	
	sub e	;60fps
	
	ld [hl], a
	cp 4
	ret nz
	xor a
	ld [hl], a ; reset intra-animation frame counter
	inc l
	ld a, [hl] ; animation frame counter
	inc a	
	and $3
	ld [hl], a
	ld [hSpriteAnimFrameCounter], a
	ret
