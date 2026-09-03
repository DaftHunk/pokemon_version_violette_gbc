; Credit PureRGB
AnimateTiles::
; PureRGBnote: CHANGED: the code for animating these tiles was moved to another bank for space.

	ld a, [hTilesetType]
	and a
	ret z ; no animations if indoors (or if a menu set this to 0)

;joenote - fixes a strange incident where $FF is written to this one byte of a water tile
	ld a,[rLY]
	cp $90 ; check if not in vblank period??? (maybe if vblank is too long)
	ret c

	ld a, [wCurMapTileset]
	cp CAVERN
	jr z, .seafoamCurrents
	cp VOLCANO
	jr nz, .normal


	ldh a, [hMovingBGTilesCounter1]
	inc a
	ldh [hMovingBGTilesCounter1], a
	cp 20
	ret c
	cp 21
	jp z, AnimateLavaBubbles1
	cp 40
	jr c, AnimateLavaFlowTiles
    call AnimateLavaBubbles2
	jp AnimateLavaWaterTiles
.normal
	ld a, [hMovingBGTilesCounter1]
	inc a
	ld [hMovingBGTilesCounter1], a
	cp 20
	ret c
	cp 21
	jr z, AnimateWaterTile
	cp 40
	jr c, AnimateWaterfallTiles
	jp AnimateFlowerTile
.seafoamCurrents
	ldh a, [hMovingBGTilesCounter1]
	inc a
	ldh [hMovingBGTilesCounter1], a
	; for whatever reason if we have fast currents on map load it gets visually glitched out
	; so we'll set it once the map loads in the script file
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	jr nz, .skipQuickCurrent
	call CheckAnimateSeafoamCurrents
	ldh a, [hMovingBGTilesCounter1]
.skipQuickCurrent
	cp 20
	ret c
	; fall through
; moves water tile sometimes left and and sometimes right to look like waves
AnimateWaterTile::
	ld hl, vTileset + $14 * $10
	ld c, $10
AnimateArbitraryWaterTile2:
	ld a, [wMovingBGTilesCounter2]
	inc a
	and 7
	ld [wMovingBGTilesCounter2], a
AnimateArbitraryWaterTile:
	and 4
	jr nz, .left
	call ScrollTileRight
	jr .done
.left
	call ScrollTileLeft
.done
	; if nc, we also need to animate flowers, and the counter needs to keep counting up
	; so return and don't reset counter
	ldh a, [hTilesetType]
	rrca
	ret nc

	; reset the counter if we only need to animate water
	xor a
	ldh [hMovingBGTilesCounter1], a
	ret

AnimateFlowerTile::
	; reset the counter to loop back to the start of tile animation timer
	xor a
	ldh [hMovingBGTilesCounter1], a

	ld de, vTileset + $3 * $10
	ld c, $10

	ld a, [wMovingBGTilesCounter2]
	and 3
	cp 2
	ld hl, FlowerTile1
	jr c, AnimateCopyTile
	ld hl, FlowerTile2
; fallthrough
AnimateCopyTile:
	ld c, 16
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

AnimateWaterfallTiles:
	cp 36
	ret c
	ret nz
	ld hl, vTileset + $73 * $10
    ld c, $10
	jp ScrollTileDown

AnimateLavaFlowTiles:
	cp 36
	ret c
	jr z, AnimateLavaFlowDown
	cp 37
	jr z, AnimateLavaFlowUp
	cp 38
	jr z, AnimateLavaFlowLeft
	; fall through for 39
AnimateLavaFlowRight:
	ld hl, vTileset + $23 * $10 ; right flowing lava
    ld c, $10
	jp ScrollTileRight

AnimateLavaFlowUp:
	ld hl, vTileset + $26 * $10 ; up flowing lava
    ld c, $10
	jp ScrollTileUp

AnimateLavaFlowLeft:
	ld hl, vTileset + $25 * $10 ; left flowing lava
    ld c, $10
	jp ScrollTileLeft

AnimateLavaFlowDown:
	ld hl, vTileset + $24 * $10 ; down flowing lava
    ld c, $10
	jp ScrollTileDown

AnimateLavaWaterTiles::
	call AnimateWaterTile ; stationary lava uses default water tile
    ret

AnimateLavaBubbles1::
	ld de, vTileset + $21 * $10 ; bubble tile 1
    ld c, $10
	push de
	ld hl, LavaBubbleJumpTable
	ld a, [wMovingBGTilesCounter2]
	and 3
	call GetAddressFromPointerArray
	pop de
	jp AnimateCopyTile

AnimateLavaBubbles2::
	xor a
	ldh [hMovingBGTilesCounter1], a
	ld hl, LavaBubbleJumpTable
	ld a, [wMovingBGTilesCounter2]
	and 3
	inc a
	cp 4
	jr nz, .noReset
	xor a
.noReset
	call GetAddressFromPointerArray
	ld de, vTileset + $6 * $10 ; bubble tile 2
    ld c, $10
	jp AnimateCopyTile

LavaBubbleJumpTable:
	dw LavaBubble1
	dw LavaBubble2
	dw LavaBubble3
	dw LavaBubble4

CheckAnimateSeafoamCurrents:
	ldh a, [hGBC]
	and a
	ldh a, [hMovingBGTilesCounter1]
	jr z, .slowerCurrents
	rrca ; every other frame update all the currents on GBC
	ret c
	jr AnimateSeafoamCurrents
.slowerCurrents
	; when not on GBC we have to animate the currents slower on different frames or vblank goes too long and the tiles get corrupted
	and %11
	cp 1
	jr z, AnimateSeafoamCurrentsDown
	cp 2
	jr z, AnimateSeafoamCurrentsRight
	cp 3
	jr z, AnimateSeafoamCurrentsUp
	cp 4
	jr z, AnimateSeafoamCurrentsLeft
	ret

AnimateSeafoamCurrents:
	ld hl, vTileset + $3B * $10 ; right flowing water
	ld c, $10
	call ScrollTileRight
	ld hl, vTileset + $42 * $10 ; down flowing water
	ld c, $10
	call ScrollTileDown
	ld hl, vTileset + $43 * $10 ; left flowing water
	ld c, $10
	call ScrollTileLeft
	ld hl, vTileset + $30 * $10 ; up flowing water
	ld c, $10
	jr ScrollTileUp

AnimateSeafoamCurrentsRight:
	ld hl, vTileset + $3B * $10 ; right flowing water
	ld c, $10
	jr ScrollTileRight

AnimateSeafoamCurrentsLeft:
	ld hl, vTileset + $43 * $10 ; left flowing water
	ld c, $10
	jr ScrollTileRight

AnimateSeafoamCurrentsDown:
	ld hl, vTileset + $42 * $10 ; down flowing water
	ld c, $10
	jr ScrollTileDown

AnimateSeafoamCurrentsUp:
	ld hl, vTileset + $30 * $10 ; up flowing water
	ld c, $10
	jr ScrollTileUp

ScrollTileRight:
	ld c, 16
.right
	ld a, [hl]
	rrca
	ld [hli], a
	dec c
	jr nz, .right
	ret

ScrollTileLeft:
	ld c, 16
.left
	ld a, [hl]
	rlca
	ld [hli], a
	dec c
	jr nz, .left
	ret

; PureRGBnote: ADDED: scrolls the tile in hl down, copied from pokecrystal
ScrollTileDown:
	ld de, 16 - 2 ; 16 bytes per tile, first two bytes are read right away
	push hl
	add hl, de
	ld d, [hl]
	inc hl
	ld e, [hl]
	pop hl
	ld a, 16 / 4 ; 16 bytes per tile, loop does 4 bytes per go
.loop
	ld b, [hl]
	ld [hl], d
	inc hl
	ld c, [hl]
	ld [hl], e
	inc hl
	ld d, [hl]
	ld [hl], b
	inc hl
	ld e, [hl]
	ld [hl], c
	inc hl
	dec a
	jr nz, .loop
	ret

; PureRGBnote: ADDED: scrolls the tile in hl down, copied from pokecrystal
ScrollTileUp:
	ld d, [hl]
	inc hl
	ld e, [hl]
	ld bc, 16 - 2
	add hl, bc
	ld a, 16 / 4
.loop
	ld c, [hl]
	ld [hl], e
	dec hl
	ld b, [hl]
	ld [hl], d
	dec hl
	ld e, [hl]
	ld [hl], c
	dec hl
	ld d, [hl]
	ld [hl], b
	dec hl
	dec a
	jr nz, .loop
	ret

;dafthunk : #7
FlowerTile1: INCBIN "gfx/tilesets/flowers/flower1.2bpp"
FlowerTile2: INCBIN "gfx/tilesets/flowers/flower2.2bpp"

LavaBubble1: INCBIN "gfx/tilesets/lava/lava1.2bpp"
LavaBubble2: INCBIN "gfx/tilesets/lava/lava2.2bpp"
LavaBubble3: INCBIN "gfx/tilesets/lava/lava3.2bpp"
LavaBubble4: INCBIN "gfx/tilesets/lava/lava4.2bpp"
