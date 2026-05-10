db DEX_HAUNTER ; pokedex id
db 45 ; base hp
db 50 ; base attack
db 45 ; base defense
db 95 ; base speed
db 115 ; base special
db GHOST ; species type 1
db GHOST ; species type 2
db 90 ; catch rate
db 126 ; base exp yield
INCBIN "gfx/pokemon/front/haunter.pic",0,1 ; 66, sprite dimensions
dw HaunterPicFront
dw HaunterPicBack
; attacks known at lvl 0
db HYPNOSIS
db LICK
db 0
db 0
db 3 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC
; 9 -> 16
	tmlearn 0
; 17 -> 24
	tmlearn tm21_MEGA_DRAIN, tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm29_PSYCHIC_M, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm36_SELFDESTRUCT, tm37_SLUDGE_BOMB
; 41 -> 48
	tmlearn tm41_GIGA_DRAIN, tm42_SHADOW_BALL, tm44_REST, tm46_DARK_PULSE, tm47_EXPLOSION
; 49 -> 56
	tmlearn tm50_SUBSTITUTE
;   db 0 ; padding
	db BANK(HaunterPicFront)
	assert BANK(HaunterPicFront) == BANK(HaunterPicBack)

