db DEX_MACHAMP ; pokedex id
db 90 ; base hp
db 130 ; base attack
db 80 ; base defense
db 55 ; base speed
db 65 ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 45 ; catch rate
db 193 ; base exp yield
INCBIN "gfx/pokemon/front/machamp.pic",0,1 ; 77, sprite dimensions
dw MachampPicFront
dw MachampPicBack
; attacks known at lvl 0
db LOW_KICK
db LEER
db FOCUS_ENERGY
db 0
db 3 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm04_FLAMETHROWER, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS
; 25 -> 32
	tmlearn tm26_EARTHQUAKE, tm27_FISSURE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm35_METRONOME, tm38_FIRE_BLAST, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;   db 0 ; padding
	db BANK(MachampPicFront)
	assert BANK(MachampPicFront) == BANK(MachampPicBack)

