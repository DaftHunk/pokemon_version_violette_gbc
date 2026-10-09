db DEX_GOROCHU ; pokedex id
db 60 ; base hp
db 90 ; base attack
db 55 ; base defense
db 130 ; base speed
db 130 ; base special
db ELECTRIC ; species type 1
db FIRE ; species type 2
db 45 ; catch rate
db 190 ; base exp yield
INCBIN "gfx/pokemon/front/gorochu.pic",0,1 ; 77, sprite dimensions
dw GorochuPicFront
dw GorochuPicBack
; attacks known at lvl 0
db THUNDER_WAVE
db THUNDERBOLT
db TAIL_WHIP
db FIRE_PUNCH
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm04_FLAMETHROWER, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM, tm16_PAY_DAY
; 17 -> 24
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm38_FIRE_BLAST, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST, tm45_THUNDER_WAVE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH, hm05_FLASH
;   db 0 ; padding
	db BANK(GorochuPicFront)
	assert BANK(GorochuPicFront) == BANK(GorochuPicBack)

