db DEX_HYPNO ; pokedex id
db 85 ; base hp
db 73 ; base attack
db 70 ; base defense
db 67 ; base speed
db 115 ; base special
db PSYCHIC ; species type 1
db DARK ; species type 2
db 75 ; catch rate
db 165 ; base exp yield
INCBIN "gfx/pokemon/front/hypno.pic",0,1 ; 77, sprite dimensions
dw HypnoPicFront
dw HypnoPicBack
; attacks known at lvl 0
db POUND
db HYPNOSIS
db DISABLE
db CONFUSION
db 0 ; growth rate
; learnset
	tmlearn tm01_MEGA_PUNCH, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm20_RAGE
	tmlearn tm29_PSYCHIC_M, tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm35_METRONOME, tm40_SKULL_BASH
	tmlearn tm42_DREAM_EATER, tm44_REST, tm45_THUNDER_WAVE, tm46_PSYWAVE
	tmlearn tm49_TRI_ATTACK, tm50_SUBSTITUTE, hm05_FLASH
;	db 0 ; padding
	db BANK(HypnoPicFront)
	assert BANK(HypnoPicFront) == BANK(HypnoPicBack)

