db DEX_MUK ; pokedex id
db 105 ; base hp
db 105 ; base attack
db 75 ; base defense
db 50 ; base speed
db 85 ; base special
db POISON ; species type 1
db POISON ; species type 2
db 75 ; catch rate
db 157 ; base exp yield
INCBIN "gfx/pokemon/front/muk.pic",0,1 ; 77, sprite dimensions
dw MukPicFront
dw MukPicBack
; attacks known at lvl 0
db POISON_GAS
db POUND
db HARDEN
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm04_FLAMETHROWER, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm21_MEGA_DRAIN, tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm36_SELFDESTRUCT, tm37_SLUDGE_BOMB, tm38_FIRE_BLAST
; 41 -> 48
	tmlearn tm41_GIGA_DRAIN, tm42_SHADOW_BALL, tm44_REST, tm46_DARK_PULSE, tm47_EXPLOSION, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;   db 0 ; padding
	db BANK(MukPicFront)
	assert BANK(MukPicFront) == BANK(MukPicBack)

