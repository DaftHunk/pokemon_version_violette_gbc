DisplayDexRating:
	ld hl, wPokedexSeen
	ld b, wPokedexSeenEnd - wPokedexSeen
	call CountSetBits
	ld a, [wNumSetBits]
	ld [hDexRatingNumMonsSeen], a
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	ld [hDexRatingNumMonsOwned], a
	ld hl, DexRatingsTable
.findRating
	ld a, [hli]
	ld b, a
	ld a, [hDexRatingNumMonsOwned]
	cp b
	jr c, .foundRating
	inc hl
	inc hl
	jr .findRating
.foundRating
	ld a, [hli]
	ld h, [hl]
	ld l, a ; load text pointer into hl
	CheckAndResetEventA EVENT_INDIGO_HALL_OF_FAME_DEX_RATING
	jr nz, .hallOfFame
	push hl
	ld hl, PokedexRatingText_441cc
	call PrintText
	pop hl
	call PrintText
	callba PlayPokedexRatingSfx
	jp WaitForTextScrollButtonPress
.hallOfFame
	ld de, wDexRatingNumMonsSeen
	ld a, [hDexRatingNumMonsSeen]
	ld [de], a
	inc de
	ld a, [hDexRatingNumMonsOwned]
	ld [de], a
	inc de
.copyRatingTextLoop
	ld a, [hli]
	cp "@"
	jr z, .doneCopying
	ld [de], a
	inc de
	jr .copyRatingTextLoop
.doneCopying
	ld [de], a
	ret

PokedexRatingText_441cc:
	TX_FAR _OaksLabText_441cc
	db "@"

DexRatingsTable:
	db 10
	dw PokedexRatingText_Caught10
	db 20
	dw PokedexRatingText_Caught20
	db 30
	dw PokedexRatingText_Caught30
	db 40
	dw PokedexRatingText_Caught40
	db 50
	dw PokedexRatingText_Caught50
	db 60
	dw PokedexRatingText_Caught60
	db 70
	dw PokedexRatingText_Caught70
	db 80
	dw PokedexRatingText_Caught80
	db 90
	dw PokedexRatingText_Caught90
	db 100
	dw PokedexRatingText_Caught100
	db 110
	dw PokedexRatingText_Caught110
	db 120
	dw PokedexRatingText_Caught120
	db 130
	dw PokedexRatingText_Caught130
	db 140
	dw PokedexRatingText_Caught140
	db 180 ; Everything except Mew, MewtwoArmor & MissingNo
	dw PokedexRatingText_CaughtAllExceptFabulous
	db 182 ; Everything
	dw PokedexRatingText_CaughtAll
	; dafthunk Handle MissingNo or error
	db 183
	dw PokedexRatingText_CaughtAll
	db 184
	dw PokedexRatingText_CaughtAll

PokedexRatingText_Caught10:
	TX_FAR _OaksLabText_Caught10
	db "@"

PokedexRatingText_Caught20:
	TX_FAR _OaksLabText_Caught20
	db "@"

PokedexRatingText_Caught30:
	TX_FAR _OaksLabText_Caught30
	db "@"

PokedexRatingText_Caught40:
	TX_FAR _OaksLabText_Caught40
	db "@"

PokedexRatingText_Caught50:
	TX_FAR _OaksLabText_Caught50
	db "@"

PokedexRatingText_Caught60:
	TX_FAR _OaksLabText_Caught60
	db "@"

PokedexRatingText_Caught70:
	TX_FAR _OaksLabText_Caught70
	db "@"

PokedexRatingText_Caught80:
	TX_FAR _OaksLabText_Caught80
	db "@"

PokedexRatingText_Caught90:
	TX_FAR _OaksLabText_Caught90
	db "@"

PokedexRatingText_Caught100:
	TX_FAR _OaksLabText_Caught100
	db "@"

PokedexRatingText_Caught110:
	TX_FAR _OaksLabText_Caught110
	db "@"

PokedexRatingText_Caught120:
	TX_FAR _OaksLabText_Caught120
	db "@"

PokedexRatingText_Caught130:
	TX_FAR _OaksLabText_Caught130
	db "@"

PokedexRatingText_Caught140:
	TX_FAR _OaksLabText_Caught140
	db "@"

PokedexRatingText_CaughtAllExceptFabulous:
	TX_FAR _OaksLabText_CaughtAllExceptFabulous
	db "@"

PokedexRatingText_CaughtAll:
	TX_FAR _OaksLabText_CaughtAll
	db "@"
