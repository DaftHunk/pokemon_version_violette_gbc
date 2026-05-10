db DEX_STEELIX ; pokedex id
db 75 ; base hp
db 90 ; base attack
db 200 ; base defense
db 30 ; base speed
db 60 ; base special
db STEEL ; species type 1
db GROUND ; species type 2
db 25 ; catch rate
db 196 ; base exp yield
INCBIN "gfx/pokemon/front/steelix.pic",0,1 ; 77, sprite dimensions
dw SteelixPicFront
dw SteelixPicBack
; attacks known at lvl 0
db TACKLE
db SCREECH
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn 0
; 25 -> 32
	tmlearn tm26_EARTHQUAKE, tm27_FISSURE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm36_SELFDESTRUCT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST, tm46_DARK_PULSE, tm47_EXPLOSION, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm04_STRENGTH
;   db 0 ; padding
	db BANK(SteelixPicFront)
	assert BANK(SteelixPicFront) == BANK(SteelixPicBack)

