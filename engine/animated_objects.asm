; Pikachu's Beach minigame - animated object engine
; Adapted from Marcel's implementation (yumepokered).

; animated_object struct members (16 bytes per object)
DEF ANIM_OBJ_INDEX		   EQUS "$0"
DEF ANIM_OBJ_FRAME_SET	   EQUS "$1"
DEF ANIM_OBJ_CALLBACK		EQUS "$2"
DEF ANIM_OBJ_TILE			EQUS "$3"
DEF ANIM_OBJ_X_COORD		 EQUS "$4"
DEF ANIM_OBJ_Y_COORD		 EQUS "$5"
DEF ANIM_OBJ_X_OFFSET		EQUS "$6"
DEF ANIM_OBJ_Y_OFFSET		EQUS "$7"
DEF ANIM_OBJ_DURATION		EQUS "$8"
DEF ANIM_OBJ_DURATION_OFFSET EQUS "$9"
DEF ANIM_OBJ_FRAME_IDX	   EQUS "$a"
DEF ANIM_OBJ_FIELD_B		 EQUS "$b"
DEF ANIM_OBJ_FIELD_C		 EQUS "$c"
DEF ANIM_OBJ_FIELD_D		 EQUS "$d"
DEF ANIM_OBJ_FIELD_E		 EQUS "$e"
DEF ANIM_OBJ_FIELD_F		 EQUS "$f"

; the minigame engine shares the overworld OAM buffer
; text aliases: wOAMBuffer lives in wram.o, not a constant in this assembly unit
DEF wShadowOAM EQUS "wOAMBuffer"
DEF wShadowOAMEnd EQUS "wOAMBuffer + 4 * 40"
DEF wShadowOAMSprite00TileID EQUS "wOAMBuffer + 4 * 0 + 2"
DEF wShadowOAMSprite02TileID EQUS "wOAMBuffer + 4 * 2 + 2"
DEF wShadowOAMSprite04XCoord EQUS "wOAMBuffer + 4 * 4 + 1"
DEF wShadowOAMSprite05XCoord EQUS "wOAMBuffer + 4 * 5 + 1"

; hardware / geometry constants not defined by the base engine
IF !DEF(TILE_WIDTH)
TILE_WIDTH EQU 8
ENDC
IF !DEF(TILE_HEIGHT)
TILE_HEIGHT EQU 8
ENDC
IF !DEF(TILE_SIZE)
TILE_SIZE EQU 16
ENDC
IF !DEF(SCREEN_AREA)
SCREEN_AREA EQU SCREEN_WIDTH * SCREEN_HEIGHT
ENDC
IF !DEF(SCREEN_WIDTH_PX)
SCREEN_WIDTH_PX EQU 160
ENDC
IF !DEF(SCREEN_HEIGHT_PX)
SCREEN_HEIGHT_PX EQU 144
ENDC
IF !DEF(TILEMAP_WIDTH)
TILEMAP_WIDTH EQU 32
ENDC
IF !DEF(TILEMAP_WIDTH_PX)
TILEMAP_WIDTH_PX EQU TILEMAP_WIDTH * TILE_WIDTH
ENDC
IF !DEF(TILEMAP_HEIGHT)
TILEMAP_HEIGHT EQU 32 ; background tilemap is 32x32 tiles (matches BG_MAP_HEIGHT)
ENDC
IF !DEF(TILEMAP_AREA)
TILEMAP_AREA EQU TILEMAP_WIDTH * TILEMAP_HEIGHT
ENDC
IF !DEF(OBJ_SIZE)
; one OAM buffer entry is 4 bytes (Y, X, tile ID, attributes)
; matches yumepokered's OBJ_SIZE (hardware.inc rsreset chain)
OBJ_SIZE EQU 4
ENDC
IF !DEF(OAM_X_OFS)
OAM_X_OFS EQU 8
ENDC

; OAM attribute flags (values matching yumepokered's engine)
IF !DEF(OAM_PAL1)
OAM_PAL1	   EQU $10
B_OAM_PAL1	 EQU 4
ENDC
IF !DEF(OAM_XFLIP)
OAM_XFLIP	  EQU $20
B_OAM_XFLIP	EQU 5
ENDC
IF !DEF(OAM_YFLIP)
OAM_YFLIP	  EQU $40
B_OAM_YFLIP	EQU 6
ENDC
IF !DEF(OAM_PRIO)
OAM_PRIO	   EQU $80
ENDC
; pseudo-flag of the minigame engine (not a hardware flag)
IF !DEF(OAM_HIGH_PALS)
OAM_HIGH_PALS  EQU $04
ENDC

; joypad bit masks (bit 0 = newly pressed, higher bits = held)
IF !DEF(PAD_A)
PAD_A		  EQU $01
PAD_B		  EQU $02
PAD_SELECT	 EQU $04
PAD_START	  EQU $08
PAD_RIGHT	  EQU $10
PAD_LEFT	   EQU $20
PAD_UP		 EQU $40
PAD_DOWN	   EQU $80
ENDC

; interrupt enable flags
IF !DEF(IE_VBLANK)
IE_VBLANK	  EQU $01
ENDC
IF !DEF(IE_STAT)
IE_STAT		EQU $02
ENDC
IF !DEF(IE_LCDC)
IE_LCDC		EQU $02
ENDC
IF !DEF(IE_TIMER)
IE_TIMER	   EQU $04
ENDC
IF !DEF(IE_SERIAL)
IE_SERIAL	  EQU $08
ENDC
IF !DEF(IE_JOYPAD)
IE_JOYPAD	 EQU $10
ENDC

IF !DEF(BIT_NO_TEXT_DELAY)
BIT_NO_TEXT_DELAY EQU 6
ENDC

; LCD control flags
IF !DEF(LCDC_ON)
LCDC_BG_ON	 EQU $01
ENDC
IF !DEF(LCDC_OBJ_ON)
LCDC_OBJ_ON	EQU $02
ENDC
IF !DEF(LCDC_OBJ_16)
LCDC_OBJ_16	EQU $04
ENDC
IF !DEF(LCDC_BG9C00)
LCDC_BG9C00	EQU $08
ENDC
IF !DEF(LCDC_BG8000)
LCDC_BG8000	EQU $10
ENDC
IF !DEF(LCDC_WIN_ON)
LCDC_WIN_ON	EQU $20
ENDC
IF !DEF(LCDC_WIN9C00)
LCDC_WIN9C00   EQU $40
ENDC
IF !DEF(LCDC_ON)
LCDC_ON		EQU $80
ENDC

; STAT register
IF !DEF(STAT_MODE_0)
STAT_MODE_0	EQU $08 ; 1 = HBlank triggers the STAT interrupt
ENDC

ClearObjectAnimationBuffers:
	ld hl, wAnimatedObjectsData
	ld bc, wAnimatedObjectsDataEnd - wAnimatedObjectsData
	xor a
	jp FillMemory

RunObjectAnimations:
	ld hl, wAnimatedObjectDataStructs
	ld e, 10
.loop
	ld a, [hl]
	and a
	jr z, .next
	ld c, l
	ld b, h
	push hl
	push de
	call ExecuteCurrentAnimatedObjectCallback
	call UpdateCurrentAnimatedObjectFrame
	pop de
	pop hl
	ret c
.next
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
	ld a, [wCurrentAnimatedObjectOAMBufferOffset]
	ld l, a
	ld h, HIGH(wShadowOAM)
.deinitUnusedOamLoop
	ld a, l
	cp LOW(wShadowOAMEnd)
	ret nc
	xor a
	ld [hli], a
	jr .deinitUnusedOamLoop

SpawnAnimatedObject:
	push de
	push af
	ld hl, wAnimatedObjectDataStructs
	ld e, 10
.loop
	ld a, [hl]
	and a
	jr z, .init
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
	pop af
	pop de
	scf
	ret

.init
	pop af
	ld c, l
	ld b, h
	ld hl, wNumLoadedAnimatedObjects
	inc [hl]
	ld e, a
	ld d, 0
	ld hl, wAnimatedObjectSpawnStateDataPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	add hl, de
	add hl, de
	ld e, l
	ld d, h
	ld hl, $0
	add hl, bc
	ld a, [wNumLoadedAnimatedObjects]
	ld [hli], a
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	xor a
	ld [hli], a
	pop de
	ld hl, $4
	add hl, bc
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

MaskCurrentAnimatedObjectStruct:
	ld hl, $0
	add hl, bc
	ld [hl], $0
	ret

MaskAllAnimatedObjectStructs:
	ld hl, wAnimatedObjectDataStructs
	ld e, 10
.loop
	ld [hl], $0
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
	ret

UpdateCurrentAnimatedObjectFrame:
	xor a
	ld [wCurAnimatedObjectOAMAttributes], a
	ld hl, $3
	add hl, bc
	ld a, [hli]
	ld [wCurrentAnimatedObjectVTileOffset], a
	ld a, [hli]
	ld [wCurrentAnimatedObjectXCoord], a
	ld a, [hli]
	ld [wCurrentAnimatedObjectYCoord], a
	ld a, [hli]
	ld [wCurrentAnimatedObjectXOffset], a
	ld a, [hl]
	ld [wCurrentAnimatedObjectYOffset], a
	call UpdateDurationTimerAndFrameStateForCurrentAnimatedObject
	cp $fd
	jr z, .finish
	cp $fc
	jr z, .deleteAnimation
	call GetCurrentAnimatedObjectOAMDataPointer
	ld a, [wCurrentAnimatedObjectVTileOffset]
	add [hl]
	ld [wCurrentAnimatedObjectVTileOffset], a
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push bc
	ld a, [wCurrentAnimatedObjectOAMBufferOffset]
	ld e, a
	ld d, HIGH(wShadowOAM)
	ld a, [hli]
	ld c, a
.loop
	ld a, [wCurrentAnimatedObjectYCoord]
	ld b, a
	ld a, [wCurrentAnimatedObjectYOffset]
	add b
	ld b, a
	ld a, [wAnimatedObjectGlobalYOffset]
	add b
	ld b, a
	call GetCurrentAnimatedObjectTileYCoordinate
	add b
	ld [de], a
	inc hl
	inc de
	ld a, [wCurrentAnimatedObjectXCoord]
	ld b, a
	ld a, [wCurrentAnimatedObjectXOffset]
	add b
	ld b, a
	ld a, [wAnimatedObjectGlobalXOffset]
	add b
	ld b, a
	call GetCurrentAnimatedObjectTileXCoordinate
	add b
	ld [de], a
	inc hl
	inc de
	ld a, [wCurrentAnimatedObjectVTileOffset]
	add [hl]
	ld [de], a
	inc hl
	inc de
	call SetCurrentAnimatedObjectOAMAttributes
	; the computed OAM attributes are returned in a by the call above
	ld [de], a
	inc hl
	inc de
	ld a, e
	ld [wCurrentAnimatedObjectOAMBufferOffset], a
	cp LOW(wShadowOAMEnd)
	jr nc, .oamIsFull
	dec c
	jr nz, .loop
	pop bc
	jr .finish

.deleteAnimation
	call MaskCurrentAnimatedObjectStruct
.finish
	and a
	ret

.oamIsFull
	pop bc
	scf
	ret

GetCurrentAnimatedObjectTileYCoordinate:
	push hl
	ld a, [hl]
	ld hl, wCurAnimatedObjectOAMAttributes
	bit B_OAM_YFLIP, [hl]
	jr z, .noFlip
	add $8
	xor $ff
	inc a
.noFlip
	pop hl
	ret

GetCurrentAnimatedObjectTileXCoordinate:
	push hl
	ld a, [hl]
	ld hl, wCurAnimatedObjectOAMAttributes
	bit B_OAM_XFLIP, [hl]
	jr z, .noFlip
	add $8
	xor $ff
	inc a
.noFlip
	pop hl
	ret

SetCurrentAnimatedObjectOAMAttributes:
	ld a, [wCurAnimatedObjectOAMAttributes]
	ld b, a
	ld a, [hl]
	xor b
	and OAM_XFLIP | OAM_YFLIP | OAM_PRIO
	ld b, a
	ld a, [hl]
	and OAM_PAL1
	or b
	bit B_OAM_PAL1, a
	ret z
	or OAM_HIGH_PALS
	ret

GetCurrentAnimatedObjectOAMDataPointer:
	ld e, a
	ld d, 0
	ld hl, wAnimatedObjectOAMDataPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	add hl, de
	add hl, de
	ret

SetCurrentAnimatedObjectCallbackAndResetFrameStateRegisters:
	ld hl, $1
	add hl, bc
	ld [hl], a
	ld hl, $8
	add hl, bc
	ld [hl], $0
	ld hl, $9
	add hl, bc
	ld [hl], $0
	ld hl, $a
	add hl, bc
	ld [hl], $ff
	ret

UpdateDurationTimerAndFrameStateForCurrentAnimatedObject:
.loop
	ld hl, $8
	add hl, bc
	ld a, [hl]
	and a
	jr z, .nextFrame
	dec [hl]
	call GetPointerToCurrentAnimatedObjectFrameScript
	ld a, [hli]
	push af
	jr .finish

.nextFrame
	ld hl, $a
	add hl, bc
	inc [hl]
	call GetPointerToCurrentAnimatedObjectFrameScript
	ld a, [hli]
	cp $fe
	jr z, .restartAnim
	cp $ff
	jr z, .holdLastFrameState
	push af
	ld a, [hl]
	push hl
	and $3f
	ld hl, $9
	add hl, bc
	add [hl]
	ld hl, $8
	add hl, bc
	ld [hl], a
	pop hl
.finish
	ld a, [hl]
	and $c0
	srl a
	ld [wCurAnimatedObjectOAMAttributes], a
	pop af
	ret

.holdLastFrameState
	xor a
	ld hl, $8
	add hl, bc
	ld [hl], a
	ld hl, $a
	add hl, bc
	dec [hl]
	dec [hl]
	jr .loop

.restartAnim
	xor a
	ld hl, $8
	add hl, bc
	ld [hl], a
	dec a
	ld hl, $a
	add hl, bc
	ld [hl], a
	jr .loop

GetPointerToCurrentAnimatedObjectFrameScript:
	ld hl, $1
	add hl, bc
	ld e, [hl]
	ld d, 0
	ld hl, wAnimatedObjectFramesDataPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, $a
	add hl, bc
	ld l, [hl]
	ld h, 0
	add hl, hl
	add hl, de
	ret

ExecuteCurrentAnimatedObjectCallback:
	ld hl, $2
	add hl, bc
	ld e, [hl]
	ld d, 0
	ld hl, wAnimatedObjectJumptablePointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
