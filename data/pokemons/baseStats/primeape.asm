db DEX_PRIMEAPE ; pokedex id
db 65 ; base hp
db 105 ; base attack
db 60 ; base defense
db 95 ; base speed
db 60 ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 75 ; catch rate
db 149 ; base exp yield
INCBIN "gfx/pokemon/front/primeape.pic",0,1 ; 77, sprite dimensions
dw PrimeapePicFront
dw PrimeapePicBack
; attacks known at lvl 0
db SCRATCH
db LEER
db LOW_KICK
db RAGE
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM, tm16_PAY_DAY
; 17 -> 24
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm26_EARTHQUAKE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm35_METRONOME, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;   db 0 ; padding
	db BANK(PrimeapePicFront)
	assert BANK(PrimeapePicFront) == BANK(PrimeapePicBack)

