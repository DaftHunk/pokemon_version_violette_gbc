db DEX_POLIWRATH ; pokedex id
db 90 ; base hp
db 85 ; base attack
db 95 ; base defense
db 70 ; base speed
db 70 ; base special
db WATER ; species type 1
db FIGHTING ; species type 2
db 45 ; catch rate
db 185 ; base exp yield
INCBIN "gfx/pokemon/front/poliwrath.pic",0,1 ; 77, sprite dimensions
dw PoliwrathPicFront
dw PoliwrathPicBack
; attacks known at lvl 0
db WATER_GUN
db HYPNOSIS
db DOUBLESLAP
db SUBMISSION
db 3 ; growth rate
; learnset
	tmlearn tm01_MEGA_PUNCH, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm20_RAGE
	tmlearn tm26_EARTHQUAKE, tm27_FISSURE, tm28_DIG, tm29_PSYCHIC_M, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm35_METRONOME, tm40_SKULL_BASH
	tmlearn tm44_REST, tm46_PSYWAVE, tm48_ROCK_SLIDE
	tmlearn tm50_SUBSTITUTE, hm03_SURF, hm04_STRENGTH
;	db 0 ; padding
	db BANK(PoliwrathPicFront)
	assert BANK(PoliwrathPicFront) == BANK(PoliwrathPicBack)

