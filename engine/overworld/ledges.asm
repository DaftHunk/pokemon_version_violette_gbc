HandleLedges:
	ld a, [wd736]
	bit 6, a ; already jumping down ledge
	ret nz
	ld a, [wCurMapTileset]
	and a ; OVERWORLD
	;ret nz
	jr z, .overworld
 	cp VOLCANO
 	jr z, .volcano
 	ret
 .overworld
	predef GetTileAndCoordsInFrontOfPlayer
	ld hl, LedgeTiles
	ld a, [wSpriteStateData1 + 9]
	ld b, a
	aCoord 8, 9
	ld c, a
	ld a, [wTileInFrontOfPlayer]
	ld d, a
	;ld hl, LedgeTiles
.loop
	ld a, [hli]
	cp $ff
	ret z
	cp b
	jr nz, .nextLedgeTile1
	ld a, [hli]
	cp c
	jr nz, .nextLedgeTile2
	ld a, [hli]
	cp d
	jr nz, .nextLedgeTile3
	ld a, [hl]
	ld e, a
	jr .foundMatch
.nextLedgeTile1
	inc hl
.nextLedgeTile2
	inc hl
.nextLedgeTile3
	inc hl
	jr .loop
.foundMatch
	ld a, [hJoyHeld]
	and e
	ret z
	
	;joenote - check for a sprite blocking the landing area beneath the ledge
	push de
	xor a
	ld [hSpriteIndexOrTextID], a
	ld d, $20 ; talking range in pixels (double normal range)
	call IsSpriteInFrontOfPlayer2
	ld a, [hSpriteIndexOrTextID]
	and a ; was there a sprite collision?
	pop de
	ret nz

	ld a, $ff
	ld [wJoyIgnore], a
	ld hl, wd736
	set 6, [hl] ; jumping down ledge
	call StartSimulatingJoypadStates
	ld a, e
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesEnd + 1], a
	ld a, $2
	ld [wSimulatedJoypadStatesIndex], a
	call LoadHoppingShadowOAM
	ld a, SFX_LEDGE
	call PlaySound
	ret

;;;;;;;;;; PureRGBnote: ADDED: in the volcano area, we need custom code for new ledges
 .volcano
 	ld a, [wSpriteStateData1 + 9]
 	cp SPRITE_FACING_DOWN
 	jr z, .down
 	cp SPRITE_FACING_LEFT
 	jr z, .left
 	cp SPRITE_FACING_RIGHT
 	jr z, .right
 	ret
 .down
 	aCoord 8, 10
 	cp $41 ; down ledge
 	ret nz
 	ld e, D_DOWN
 	jr .foundMatch
 .left
 	aCoord 7, 9
 	cp $30 ; left ledge
 	ret nz
 	ld e, D_LEFT
 	jr .foundMatch
 .right
 	aCoord 10, 9
 	cp $40 ; right ledge
 	ret nz
 	ld e, D_RIGHT
 	jr .foundMatch
 ;;;;;;;;

	; (player direction) (tile player standing on) (ledge tile) (input required)
LedgeTiles:
	db SPRITE_FACING_DOWN, $2C,$37,D_DOWN
	db SPRITE_FACING_DOWN, $39,$36,D_DOWN
	db SPRITE_FACING_DOWN, $39,$37,D_DOWN
	db SPRITE_FACING_LEFT, $2C,$27,D_LEFT
	db SPRITE_FACING_LEFT, $39,$27,D_LEFT
	db SPRITE_FACING_RIGHT,$2C,$0D,D_RIGHT
	db SPRITE_FACING_RIGHT,$2C,$1D,D_RIGHT
	db SPRITE_FACING_RIGHT,$39,$0D,D_RIGHT
	db $FF

; PureRGBnote: ADDED: in the volcano you can jump over specific new tiles like ledges.
VolcanoLedgeTiles:
	; player direction, ledge tile, input required
	db SPRITE_FACING_DOWN, $41,D_DOWN
	db SPRITE_FACING_RIGHT,$40,D_RIGHT
	db SPRITE_FACING_LEFT, $30,D_LEFT
	db $FF


LoadHoppingShadowOAM:
	ld hl, vChars1 + $7f0
	ld de, LedgeHoppingShadow
	lb bc, BANK(LedgeHoppingShadow), (LedgeHoppingShadowEnd - LedgeHoppingShadow) / $8
	call CopyVideoDataDouble
	ld a, $9
	lb bc, $54, $48 ; b, c = y, x coordinates of shadow
	ld de, LedgeHoppingShadowOAM
	call WriteOAMBlock
	ret

LedgeHoppingShadow:
	INCBIN "gfx/tiles/ledge_hopping_shadow.1bpp"
LedgeHoppingShadowEnd:

LedgeHoppingShadowOAM:
	db $FF,$10,$FF,$20
	db $FF,$40,$FF,$60
