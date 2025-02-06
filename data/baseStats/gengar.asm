db DEX_GENGAR ; pokedex id
db 60 ; base hp
db 65 ; base attack
db 60 ; base defense
db 110 ; base speed
db 130 ; base special
db GHOST ; species type 1
db POISON ; species type 2
db 45 ; catch rate
db 190 ; base exp yield
INCBIN "gfx/pokemon/front/gengar.pic",0,1 ; 66, sprite dimensions
dw GengarPicFront
dw GengarPicBack
; attacks known at lvl 0
db HYPNOSIS
db LICK
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn tm01_MEGA_PUNCH, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm20_RAGE, tm21_MEGA_DRAIN, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm29_PSYCHIC_M, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm35_METRONOME, tm36_SELFDESTRUCT, tm37_SLUDGE_BOMB, tm40_SKULL_BASH
	tmlearn tm42_DREAM_EATER, tm44_REST, tm46_PSYWAVE, tm47_EXPLOSION
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;	db 0 ; padding
	db BANK(GengarPicFront)
	assert BANK(GengarPicFront) == BANK(GengarPicBack)

