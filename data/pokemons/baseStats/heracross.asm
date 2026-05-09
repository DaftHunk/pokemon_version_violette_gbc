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
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm03_SWORDS_DANCE, tm05_MEGA_KICK, tm06_TOXIC, tm07_HORN_DRILL, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm20_RAGE
; 25 -> 32
	tmlearn tm26_EARTHQUAKE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm04_STRENGTH
;   db 0 ; padding
	db BANK(HeracrossPicFront)
	assert BANK(HeracrossPicFront) == BANK(HeracrossPicBack)

