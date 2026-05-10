db DEX_HITMONCHAN ; pokedex id
db 60 ; base hp
db 50 ; base attack
db 79 ; base defense
db 76 ; base speed
db 105 ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 45 ; catch rate
db 140 ; base exp yield
INCBIN "gfx/pokemon/front/hitmonchan.pic",0,1 ; 66, sprite dimensions
dw HitmonchanPicFront
dw HitmonchanPicBack
; attacks known at lvl 0
db COMET_PUNCH
db 0
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS
; 25 -> 32
	tmlearn tm26_EARTHQUAKE, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm35_METRONOME, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;   db 0 ; padding
	db BANK(HitmonchanPicFront)
	assert BANK(HitmonchanPicFront) == BANK(HitmonchanPicBack)

