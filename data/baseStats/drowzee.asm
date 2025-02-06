db DEX_DROWZEE ; pokedex id
db 60 ; base hp
db 48 ; base attack
db 45 ; base defense
db 42 ; base speed
db 90 ; base special
db PSYCHIC ; species type 1
db PSYCHIC ; species type 2
db 190 ; catch rate
db 102 ; base exp yield
INCBIN "gfx/pokemon/front/drowzee.pic",0,1 ; 66, sprite dimensions
dw DrowzeePicFront
dw DrowzeePicBack
; attacks known at lvl 0
db POUND
db HYPNOSIS
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm01_MEGA_PUNCH, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm20_RAGE
	tmlearn tm29_PSYCHIC_M, tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm35_METRONOME, tm40_SKULL_BASH
	tmlearn tm42_DREAM_EATER, tm44_REST, tm45_THUNDER_WAVE, tm46_PSYWAVE
	tmlearn tm49_TRI_ATTACK, tm50_SUBSTITUTE, hm05_FLASH
;	db 0 ; padding
	db BANK(DrowzeePicFront)
	assert BANK(DrowzeePicFront) == BANK(DrowzeePicBack)

