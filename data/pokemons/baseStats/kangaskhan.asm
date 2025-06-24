db DEX_KANGASKHAN ; pokedex id
db 105 ; base hp
db 95 ; base attack
db 80 ; base defense
db 90 ; base speed
db 40 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 45 ; catch rate
db 175 ; base exp yield
INCBIN "gfx/pokemon/front/kangaskhan.pic",0,1 ; 77, sprite dimensions
dw KangaskhanPicFront
dw KangaskhanPicBack
; attacks known at lvl 0
db COMET_PUNCH
db RAGE
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm01_MEGA_PUNCH, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm20_RAGE, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm26_EARTHQUAKE, tm27_FISSURE, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm38_FIRE_BLAST, tm40_SKULL_BASH
	tmlearn tm44_REST, tm48_ROCK_SLIDE
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm03_SURF, hm04_STRENGTH
;	db 0 ; padding
	db BANK(KangaskhanPicFront)
	assert BANK(KangaskhanPicFront) == BANK(KangaskhanPicBack)

