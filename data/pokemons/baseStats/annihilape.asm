db DEX_ANNIHILAPE ; pokedex id
db 100 ; base hp
db 115 ; base attack
db 80 ; base defense
db 90 ; base speed
db 80 ; base special
db FIGHTING ; species type 1
db GHOST ; species type 2
db 45 ; catch rate
db 215 ; base exp yield
INCBIN "gfx/pokemon/front/annihilape.pic",0,1 ; 55, sprite dimensions
dw AnnihilapePicFront
dw AnnihilapePicBack
; attacks known at lvl 0
db SCRATCH
db LEER
db COUNTER
db FOCUS_ENERGY
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM, tm16_PAY_DAY
; 17 -> 24
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm26_EARTHQUAKE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm35_METRONOME, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm42_SHADOW_BALL, tm44_REST, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;   db 0 ; padding
	db BANK(AnnihilapePicFront)
	assert BANK(AnnihilapePicFront) == BANK(AnnihilapePicBack)

