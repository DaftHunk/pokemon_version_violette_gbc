db DEX_GOLEM ; pokedex id
db 80 ; base hp
db 110 ; base attack
db 130 ; base defense
db 45 ; base speed
db 55 ; base special
db ROCK ; species type 1
db GROUND ; species type 2
db 45 ; catch rate
db 177 ; base exp yield
INCBIN "gfx/pokemon/front/golem.pic",0,1 ; 66, sprite dimensions
dw GolemPicFront
dw GolemPicBack
; attacks known at lvl 0
db TACKLE
db DEFENSE_CURL
db ROCK_THROW
db 0
db 3 ; growth rate
; learnset
	tmlearn tm01_MEGA_PUNCH, tm04_FLAMETHROWER, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm20_RAGE
	tmlearn tm26_EARTHQUAKE, tm27_FISSURE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm35_METRONOME, tm36_SELFDESTRUCT, tm38_FIRE_BLAST
	tmlearn tm44_REST, tm47_EXPLOSION, tm48_ROCK_SLIDE
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;	db 0 ; padding
	db BANK(GolemPicFront)
	assert BANK(GolemPicFront) == BANK(GolemPicBack)

