TrackPlayTime:
	call CountDownIgnoreInputBitReset
	ld a, [wStatusFlags6]
	bit 0, a
	ret z
	ld a, [wPlayTimeMaxed]
	bit 7, a
	ret nz
	ld a, [wPlayTimeFrames]
	inc a
	ld [wPlayTimeFrames], a
	cp 60
	ret nz
	xor a
	ld [wPlayTimeFrames], a
	ld a, [wPlayTimeSeconds]
	inc a
	ld [wPlayTimeSeconds], a
	cp 60
	ret nz
	xor a
	ld [wPlayTimeSeconds], a
	ld a, [wPlayTimeMinutes]
	inc a
	ld [wPlayTimeMinutes], a
	cp 60
	ret nz
	xor a
	ld [wPlayTimeMinutes], a
	ld a, [wPlayTimeHours]
	add 1	;use add instead of inc in order to get the carry bit on overflow
	ld [wPlayTimeHours], a
	ret nc
	ld a, [wPlayTimeMaxed]
	adc 0 ;add 0 + the carry bit from the overflowed hours
	ld [wPlayTimeMaxed], a
	ret

CountDownIgnoreInputBitReset:
	ld a, [wIgnoreInputCounter]
	and a
	jr nz, .asm_18e40
	ld a, $ff
	jr .asm_18e41
.asm_18e40
	dec a
.asm_18e41
	ld [wIgnoreInputCounter], a
	and a
	ret nz
	ld a, [wStatusFlags5]
	res 1, a
	res 2, a
	bit 5, a
	res 5, a
	ld [wStatusFlags5], a
	ret z
	xor a
	ld [hJoyPressed], a
	ld [hJoyHeld], a
	ret
