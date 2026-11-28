PlayPokedexRatingSfx::
	ldh a, [hDexRatingNumMonsOwned]
	ld c, $0
	ld hl, OwnedMonValues
.getSfxPointer
	cp [hl]
	jr c, .gotSfxPointer
	inc c
	inc hl
	jr .getSfxPointer
.gotSfxPointer
	push bc
	ld a, SFX_STOP_ALL_MUSIC
;	ld [wMusicFadeID], a
	call PlaySoundWaitForCurrent
	pop bc
	ld b, $0
	ld hl, PokedexRatingSfxPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, [hl]
	call PlaySound
	jp PlayDefaultMusic

PokedexRatingSfxPointers:
	db SFX_DENIED,         0
	db SFX_POKEDEX_RATING, 0
	db SFX_GET_ITEM_1,     0
	db SFX_CAUGHT_MON,     0
	db SFX_LEVEL_UP,       0
	db SFX_GET_KEY_ITEM,   0
	db SFX_GET_ITEM_2,     0

OwnedMonValues:
	db 10, 40, 60, 90, 120, 150, $ff
