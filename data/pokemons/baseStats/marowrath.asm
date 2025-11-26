db DEX_MAROWRATH ; pokedex id
db 70 ; base hp
db 80 ; base attack
db 110 ; base defense
db 50 ; base speed
db 100 ; base special
db FIRE ; species type 1
db GHOST ; species type 2
db 75 ; catch rate
db 124 ; base exp yield
INCBIN "gfx/pokemon/front/marowrath.pic",0,1 ; 66, sprite dimensions
dw MarowrathPicFront
dw MarowrathPicBack
; attacks known at lvl 0
db GROWL
db TAIL_WHIP
db BONE_CLUB
db HEADBUTT
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm04_FLAMETHROWER, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm20_RAGE
; 25 -> 32
	tmlearn tm26_EARTHQUAKE, tm27_FISSURE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm38_FIRE_BLAST, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;   db 0 ; padding
	db BANK(MarowrathPicFront)
	assert BANK(MarowrathPicFront) == BANK(MarowrathPicBack)

