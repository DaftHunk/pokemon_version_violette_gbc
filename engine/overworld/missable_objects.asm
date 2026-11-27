MarkTownVisitedAndLoadMissableObjects:
	ld a, [wCurMap]
	cp ROUTE_1
	jr nc, .notInTown
	ld c, a
	ld b, FLAG_SET
	ld hl, wTownVisitedFlag   ; mark town as visited (for flying)
	predef FlagActionPredef
.notInTown
	ld hl, MapHSPointers
	ld a, [wCurMap]
	ld b, $0
	ld c, a
	add hl, bc
	add hl, bc
	ld a, [hli]                ; load missable objects pointer in hl
	ld h, [hl]
	; fall through

LoadMissableObjects:
	ld l, a
	push hl
	ld de, PalletTownHS             ; calculate difference between out pointer and the base pointer
	ld a, l
	sub e
	jr nc, .asm_f13c
	dec h
.asm_f13c
	ld l, a
	ld a, h
	sub d
	ld h, a
	ld a, h
	ld [H_DIVIDEND], a
	ld a, l
	ld [H_DIVIDEND+1], a
	xor a
	ld [H_DIVIDEND+2], a
	ld [H_DIVIDEND+3], a
	ld a, $3
	ld [H_DIVISOR], a
	ld b, $2
	call Divide                ; divide difference by 3, resulting in the global offset (number of missable items before ours)
	ld a, [wCurMap]
	ld b, a
	ld a, [H_DIVIDEND+3]
	ld c, a                    ; store global offset in c
	ld de, wMissableObjectList
	pop hl
.writeMissableObjectsListLoop
	ld a, [hli]
	cp $ff
	jr z, .done     ; end of list
	cp b
	jr nz, .done    ; not for current map anymore
	ld a, [hli]
	inc hl
	ld [de], a                 ; write (map-local) sprite ID
	inc de
	ld a, c
	inc c
	ld [de], a                 ; write (global) missable object index
	inc de
	jr .writeMissableObjectsListLoop
.done
	ld a, $ff
	ld [de], a                 ; write sentinel
	; fall through

LoadItemBalls:
; builds wItemBallList: (sprite ID, item ball index) pairs for the current map,
; $FF-terminated. ItemBallData entries are [Map_ID][Object_ID][ItemBallIndex]
; and may appear anywhere in the table. capacity is 6 balls per map.
	ld hl, ItemBallData
	ld a, [wCurMap]
	ld b, a
	ld de, wItemBallList
	ld c, 6
.itemBallsLoop
	ld a, [hli]
	cp $ff
	jr z, .done     ; end of data
	cp b
	jr nz, .skipEntry
	ld a, [hli]
	ld [de], a                 ; write sprite ID
	inc de
	ld a, [hli]
	ld [de], a                 ; write item ball index
	inc de
	dec c
	jr z, .done     ; list is full (6 item balls)
	jr .itemBallsLoop
.skipEntry
	inc hl
	inc hl
	jr .itemBallsLoop
.done
	ld a, $ff
	ld [de], a                 ; write sentinel
	ret

InitializeMissableObjectsFlags:
	ld hl, wMissableObjectFlags
	ld bc, wMissableObjectFlagsEnd - wMissableObjectFlags
	xor a
	call FillMemory ; clear missable objects flags
	ld hl, wItemBallFlags
	ld bc, $10
	xor a
	call FillMemory ; clear item ball flags (16 bytes = 128 slots)
	ld hl, PalletTownHS
	xor a
	ld [wMissableObjectCounter], a
.missableObjectsLoop
	ld a, [hli]
	cp $ff          ; end of list
	ret z
	push hl
	inc hl
	ld a, [hl]
	cp Hide
	jr nz, .skip
	ld hl, wMissableObjectFlags
	ld a, [wMissableObjectCounter]
	ld c, a
	ld b, FLAG_SET
	call MissableObjectFlagAction ; set flag if Item is hidden
.skip
	ld hl, wMissableObjectCounter
	inc [hl]
	pop hl
	inc hl
	inc hl
	jr .missableObjectsLoop

IsObjectHidden2:	;joenote - adding in another way to test the show or hide state
	ld a, [wMissableObjectIndex]
	jr IsObjectHidden.loopdone
; tests if current sprite is a missable object that is hidden/has been removed
IsObjectHidden:
	ld a, [H_CURRENTSPRITEOFFSET]
	swap a
	ld b, a
	ld hl, wMissableObjectList
.loop
	ld a, [hli]
	cp $ff
	jr z, .itemBallTest ; not a regular missable -> check item balls
	cp b
	ld a, [hli]
	jr nz, .loop
.loopdone
	ld c, a
	ld b, FLAG_TEST
	ld hl, wMissableObjectFlags
	call MissableObjectFlagAction
	ld a, c
	and a
	jr nz, .hidden
.notHidden
	xor a
.hidden
	ld [$ffe5], a
	ret
 
.itemBallTest
; item balls were split out of the missable objects system:
; check wItemBallList and test the picked-up flag in wItemBallFlags
	ld hl, wItemBallList
.itemBallLoop
	ld a, [hli]
	cp $ff
	jr z, .notHidden ; not an item ball -> not hidden
	cp b
	ld a, [hli]
	jr nz, .itemBallLoop
	ld c, a
	ld b, FLAG_TEST
	ld hl, wItemBallFlags
	call MissableObjectFlagAction
	ld a, c
	and a
	jr nz, .hidden
	jr .notHidden

;joenote - This is just for sprites that appear on the same map during a scripted event.
;It pre-loads their facing so they don't look down for one frame.
ShowObject2:
	ld hl, wMissableObjectList
	ld a, [wMissableObjectIndex]
	ld b, a
.loop
	ld a, [hli]
	cp $ff
	jr z, ShowObject ; not missable -> not hidden
	ld a, [hli]
	cp b
	jr nz, .loop
	dec hl
	dec hl
	ld a, [hl]
	ld b, a	;map sprite offset is in b
	swap a
	add $09
	ld l, a
	ld a, $c1
	ld h, a	;hl points to map sprite facing
	ld a, b
	dec a
	add a
	push hl
	ld hl, wMapSpriteData
	add l
	ld l, a
	ld a, [hl]        ; read movement byte 2
	pop hl
	cp $FF
	jr z, ShowObject
	and $0F
	sla a
	sla a
	and $0F
	ld [hl], a
	;fall through
	
; adds missable object (items, leg. pokemon, etc.) to the map
; [wMissableObjectIndex]: index of the missable object to be added (global index)
ShowObject:
	ld hl, wMissableObjectFlags
	ld a, [wMissableObjectIndex]
	ld c, a
	ld b, FLAG_RESET
	call MissableObjectFlagAction   ; reset "removed" flag
	jp UpdateSprites

; removes missable object (items, leg. pokemon, etc.) from the map
; [wMissableObjectIndex]: index of the missable object to be removed (global index)
HideObject:
	ld hl, wMissableObjectFlags
	ld a, [wMissableObjectIndex]
	ld c, a
	ld b, FLAG_SET
	call MissableObjectFlagAction   ; set "removed" flag
	jp UpdateSprites

; removes an item ball from the map after it has been picked up
; [hItemToRemoveID]: index of the item ball to be removed
HideItemBall:
	ld a, [hItemToRemoveID]
	ld c, a
	ld b, FLAG_SET
	ld hl, wItemBallFlags
	call MissableObjectFlagAction   ; set "picked up" flag
	jp UpdateSprites

MissableObjectFlagAction:
; identical to FlagAction

	push hl
	push de
	push bc

	; bit
	ld a, c
	ld d, a
	and 7
	ld e, a

	; byte
	ld a, d
	srl a
	srl a
	srl a
	add l
	ld l, a
	jr nc, .ok
	inc h
.ok

	; d = 1 << e (bitmask)
	inc e
	ld d, 1
.shift
	dec e
	jr z, .shifted
	sla d
	jr .shift
.shifted

	ld a, b
	and a
	jr z, .reset
	cp 2
	jr z, .read

.set
	ld a, [hl]
	ld b, a
	ld a, d
	or b
	ld [hl], a
	jr .done

.reset
	ld a, [hl]
	ld b, a
	ld a, d
	xor $ff
	and b
	ld [hl], a
	jr .done

.read
	ld a, [hl]
	ld b, a
	ld a, d
	and b

.done
	pop bc
	pop de
	pop hl
	ld c, a
	ret
