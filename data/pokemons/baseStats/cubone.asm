db DEX_CUBONE ; pokedex id
db 50 ; base hp
db 50 ; base attack
db 95 ; base defense
db 35 ; base speed
db 40 ; base special
db GROUND ; species type 1
db GROUND ; species type 2
db 190 ; catch rate
db 87 ; base exp yield
INCBIN "gfx/pokemon/front/cubone.pic",0,1 ; 55, sprite dimensions
dw CubonePicFront
dw CubonePicBack
; attacks known at lvl 0
db GROWL
db BONE_CLUB
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm01_MEGA_PUNCH, tm04_FLAMETHROWER, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm20_RAGE
	tmlearn tm26_EARTHQUAKE, tm27_FISSURE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm38_FIRE_BLAST, tm40_SKULL_BASH
	tmlearn tm44_REST, tm48_ROCK_SLIDE
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;	db 0 ; padding
	db BANK(CubonePicFront)
	assert BANK(CubonePicFront) == BANK(CubonePicBack)

