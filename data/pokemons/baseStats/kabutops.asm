db DEX_KABUTOPS ; pokedex id
db 60 ; base hp
db 115 ; base attack
db 105 ; base defense
db 80 ; base speed
db 70 ; base special
db ROCK ; species type 1
db BUG ; species type 2
db 45 ; catch rate
db 201 ; base exp yield
INCBIN "gfx/pokemon/front/kabutops.pic",0,1 ; 66, sprite dimensions
dw KabutopsPicFront
dw KabutopsPicBack
; attacks known at lvl 0
db SCRATCH
db HARDEN
db LEECH_LIFE
db 0
db 0 ; growth rate
; learnset	;joenote - gains CUT from Yellow moveset
	tmlearn tm02_RAZOR_WIND, tm03_SWORDS_DANCE, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm15_HYPER_BEAM
	tmlearn tm17_SUBMISSION, tm19_SEISMIC_TOSS, tm20_RAGE, tm28_DIG
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm40_SKULL_BASH
	tmlearn tm44_REST, tm48_ROCK_SLIDE
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm03_SURF
;	db 0 ; padding
	db BANK(KabutopsPicFront)
	assert BANK(KabutopsPicFront) == BANK(KabutopsPicBack)

