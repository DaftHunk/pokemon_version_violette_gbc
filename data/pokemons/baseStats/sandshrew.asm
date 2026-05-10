db DEX_SANDSHREW ; pokedex id
db 50 ; base hp
db 75 ; base attack
db 85 ; base defense
db 40 ; base speed
db 30 ; base special
db GROUND ; species type 1
db GROUND ; species type 2
db 255 ; catch rate
db 93 ; base exp yield
INCBIN "gfx/pokemon/front/sandshrew.pic",0,1 ; 55, sprite dimensions
dw SandshrewPicFront
dw SandshrewPicBack
; attacks known at lvl 0
db SCRATCH
db 0
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm03_SWORDS_DANCE, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm20_X_SCISSOR
; 25 -> 32
	tmlearn tm26_EARTHQUAKE, tm27_FISSURE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm04_STRENGTH
;   db 0 ; padding
	db BANK(SandshrewPicFront)
	assert BANK(SandshrewPicFront) == BANK(SandshrewPicBack)

