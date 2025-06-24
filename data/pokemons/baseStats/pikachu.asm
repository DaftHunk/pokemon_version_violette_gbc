db DEX_PIKACHU ; pokedex id
db 35 ; base hp
db 55 ; base attack
db 30 ; base defense
db 90 ; base speed
db 50 ; base special
db ELECTRIC ; species type 1
db ELECTRIC ; species type 2
db 163 ; catch rate ;joenote - adjusted from 190 to match yellow's starter pikachu
db 82 ; base exp yield
INCBIN "gfx/pokemon/front/pikachu.pic",0,1 ; 55, sprite dimensions
dw PikachuPicFront
dw PikachuPicBack
; attacks known at lvl 0
db THUNDERSHOCK
db GROWL
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm01_MEGA_PUNCH, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm16_PAY_DAY
	tmlearn tm17_SUBMISSION, tm19_SEISMIC_TOSS, tm20_RAGE, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm39_SWIFT, tm40_SKULL_BASH
	tmlearn tm44_REST, tm45_THUNDER_WAVE
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH, hm05_FLASH
;	db 0 ; padding
	db BANK(PikachuPicFront)
	assert BANK(PikachuPicFront) == BANK(PikachuPicBack)

