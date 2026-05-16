db DEX_JYNX ; pokedex id
db 70 ; base hp
db 50 ; base attack
db 75 ; base defense
db 95 ; base speed
db 105 ; base special
db ICE ; species type 1
db PSYCHIC ; species type 2
db 45 ; catch rate
db 137 ; base exp yield
INCBIN "gfx/pokemon/front/jynx.pic",0,1 ; 66, sprite dimensions
dw JynxPicFront
dw JynxPicBack
; attacks known at lvl 0
db POUND
db LICK
db LOVELY_KISS
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS
; 25 -> 32
	tmlearn tm29_PSYCHIC_M, tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm35_METRONOME, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm42_SHADOW_BALL, tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm05_FLASH
;   db 0 ; padding
	db BANK(JynxPicFront)
	assert BANK(JynxPicFront) == BANK(JynxPicBack)

