db DEX_SNORLAX ; pokedex id
db 160 ; base hp
db 110 ; base attack
db 65 ; base defense
db 30 ; base speed
db 65 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 25 ; catch rate
db 154 ; base exp yield
INCBIN "gfx/pokemon/front/snorlax.pic",0,1 ; 77, sprite dimensions
dw SnorlaxPicFront
dw SnorlaxPicBack
; attacks known at lvl 0
db TACKLE
db 0
db 0
db 0
db 5 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm04_FLAMETHROWER, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM, tm16_PAY_DAY
; 17 -> 24
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm22_SOLARBEAM, tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm26_EARTHQUAKE, tm27_FISSURE, tm29_PSYCHIC_M, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm35_METRONOME, tm36_SELFDESTRUCT, tm38_FIRE_BLAST, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm42_SHADOW_BALL, tm44_REST, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm03_SURF, hm04_STRENGTH
;   db 0 ; padding
	db BANK(SnorlaxPicFront)
	assert BANK(SnorlaxPicFront) == BANK(SnorlaxPicBack)

