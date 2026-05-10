db DEX_KOFFING ; pokedex id
db 40 ; base hp
db 65 ; base attack
db 95 ; base defense
db 35 ; base speed
db 60 ; base special
db POISON ; species type 1
db POISON ; species type 2
db 190 ; catch rate
db 114 ; base exp yield
INCBIN "gfx/pokemon/front/koffing.pic",0,1 ; 66, sprite dimensions
dw KoffingPicFront
dw KoffingPicBack
; attacks known at lvl 0
db POISON_GAS
db TACKLE
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm04_FLAMETHROWER, tm06_TOXIC
; 9 -> 16
	tmlearn 0
; 17 -> 24
	tmlearn tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm36_SELFDESTRUCT, tm37_SLUDGE_BOMB, tm38_FIRE_BLAST
; 41 -> 48
	tmlearn tm42_SHADOW_BALL, tm44_REST, tm46_DARK_PULSE, tm47_EXPLOSION
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm05_FLASH
;   db 0 ; padding
	db BANK(KoffingPicFront)
	assert BANK(KoffingPicFront) == BANK(KoffingPicBack)

