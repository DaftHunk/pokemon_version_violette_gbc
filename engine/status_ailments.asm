PrintStatusAilment:
	ld a, [de]
	bit PSN, a
	jr nz, .psn
	bit BRN, a
	jr nz, .brn
	bit FRZ, a
	jr nz, .frz
	bit PAR, a
	jr nz, .par
	and SLP
	ret z
	ld a, "S"
	ld [hli], a
	ld a, "o"
	ld [hli], a
	ld [hl], "m"
	ret
.psn
	ld a, "P"
	ld [hli], a
	ld a, "s"
	ld [hli], a
	ld [hl], "n"
	ret
.brn
	ld a, "B"
	ld [hli], a
	ld a, "r"
	ld [hli], a
	ld [hl], "û"
	ret
.frz
	ld a, "G"
	ld [hli], a
	ld a, "e"
	ld [hli], a
	ld [hl], "l"
	ret
.par
	ld a, "P"
	ld [hli], a
	ld a, "a"
	ld [hli], a
	ld [hl], "r"
	ret
