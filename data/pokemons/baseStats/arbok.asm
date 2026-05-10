db DEX_ARBOK ; pokedex id
db 62 ; base hp
db 95 ; base attack
db 69 ; base defense
db 90 ; base speed
db 65 ; base special
db POISON ; species type 1
db DARK ; species type 2
db 90 ; catch rate
db 147 ; base exp yield
INCBIN "gfx/pokemon/front/arbok.pic",0,1 ; 77, sprite dimensions
dw ArbokPicFront
dw ArbokPicBack
; attacks known at lvl 0
db WRAP
db LEER
db POISON_STING
db BITE
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm21_MEGA_DRAIN
; 25 -> 32
	tmlearn tm26_EARTHQUAKE, tm27_FISSURE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm37_SLUDGE_BOMB, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm41_GIGA_DRAIN, tm44_REST, tm46_DARK_PULSE, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;   db 0 ; padding
	db BANK(ArbokPicFront)
	assert BANK(ArbokPicFront) == BANK(ArbokPicBack)

