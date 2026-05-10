db DEX_TYRANITAR ; pokedex id
db 100 ; base hp
db 134 ; base attack
db 110 ; base defense
db 61 ; base speed
db 97 ; base special
db ROCK ; species type 1
db DARK ; species type 2
db 45 ; catch rate
db 218 ; base exp yield
INCBIN "gfx/pokemon/front/tyranitar.pic",0,1 ; 55, sprite dimensions
dw TyranitarPicFront
dw TyranitarPicBack
; attacks known at lvl 0
db BITE
db LEER
db SCREECH
db 0
db 5 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC, tm07_HORN_DRILL, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm26_EARTHQUAKE, tm27_FISSURE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm38_FIRE_BLAST, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST, tm46_DARK_PULSE, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm03_SURF, hm04_STRENGTH
;   db 0 ; padding
	db BANK(TyranitarPicFront)
	assert BANK(TyranitarPicFront) == BANK(TyranitarPicBack)

