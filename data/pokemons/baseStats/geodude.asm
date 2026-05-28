db DEX_GEODUDE ; pokedex id
db 40 ; base hp
db 80 ; base attack
db 100 ; base defense
db 20 ; base speed
db 30 ; base special
db ROCK ; species type 1
db ROCK ; species type 2
db 255 ; catch rate
db 86 ; base exp yield
INCBIN "gfx/pokemon/front/geodude.pic",0,1 ; 55, sprite dimensions
dw GeodudePicFront
dw GeodudePicBack
; attacks known at lvl 0
db TACKLE
db 0
db 0
db 0
db 3 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm04_FLAMETHROWER, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS
; 25 -> 32
	tmlearn tm26_EARTHQUAKE, tm27_FISSURE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm35_METRONOME, tm36_SELFDESTRUCT, tm38_FIRE_BLAST
; 41 -> 48
	tmlearn tm44_REST, tm47_EXPLOSION, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;   db 0 ; padding
	db BANK(GeodudePicFront)
	assert BANK(GeodudePicFront) == BANK(GeodudePicBack)

