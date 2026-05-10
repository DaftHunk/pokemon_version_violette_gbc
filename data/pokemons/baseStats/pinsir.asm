db DEX_PINSIR ; pokedex id
db 65 ; base hp
db 125 ; base attack
db 100 ; base defense
db 85 ; base speed
db 55 ; base special
db BUG ; species type 1
db BUG ; species type 2
db 45 ; catch rate
db 200 ; base exp yield
INCBIN "gfx/pokemon/front/pinsir.pic",0,1 ; 77, sprite dimensions
dw PinsirPicFront
dw PinsirPicBack
; attacks known at lvl 0
db VICEGRIP
db 0
db 0
db 0
db 5 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm03_SWORDS_DANCE, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm17_SUBMISSION, tm19_SEISMIC_TOSS, tm20_X_SCISSOR
; 25 -> 32
	tmlearn tm26_EARTHQUAKE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE
; 40 -> 48
	tmlearn tm44_REST, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm04_STRENGTH
;	db 0 ; padding
	db BANK(PinsirPicFront)
	assert BANK(PinsirPicFront) == BANK(PinsirPicBack)

