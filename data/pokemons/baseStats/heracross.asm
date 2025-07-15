db DEX_HERACROSS ; pokedex id
db 80 ; base hp
db 125 ; base attack
db 75 ; base defense
db 85 ; base speed
db 75 ; base special
db BUG ; species type 1
db FIGHTING ; species type 2
db 45 ; catch rate
db 175 ; base exp yield
INCBIN "gfx/pokemon/front/heracross.pic",0,1 ; 77, sprite dimensions
dw HeracrossPicFront
dw HeracrossPicBack
; attacks known at lvl 0
db TACKLE
db LEER
db 0
db 0
db 5 ; growth rate
; learnset
	tmlearn tm03_SWORDS_DANCE, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
	tmlearn tm17_SUBMISSION, tm19_SEISMIC_TOSS, tm20_RAGE, tm26_EARTHQUAKE, tm28_DIG
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE
	tmlearn tm44_REST, tm48_ROCK_SLIDE
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm04_STRENGTH
;	db 0 ; padding
	db BANK(HeracrossPicFront)
	assert BANK(HeracrossPicFront) == BANK(HeracrossPicBack)

