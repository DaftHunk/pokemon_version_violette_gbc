db DEX_ESPEON ; pokedex id
db 65 ; base hp
db 65 ; base attack
db 60 ; base defense
db 110 ; base speed
db 130 ; base special
db PSYCHIC ; species type 1
db PSYCHIC ; species type 2
db 45 ; catch rate
db 197 ; base exp yield
INCBIN "gfx/pokemon/front/espeon.pic",0,1 ; 66, sprite dimensions
dw EspeonPicFront
dw EspeonPicBack
; attacks known at lvl 0
db BITE
db TAIL_WHIP
db GROWL
db TACKLE
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM, tm16_PAY_DAY
; 17 -> 24
	tmlearn 0
; 25 -> 32
	tmlearn tm28_DIG, tm29_PSYCHIC_M, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm42_SHADOW_BALL, tm44_REST, tm45_THUNDER_WAVE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm03_SURF, hm05_FLASH
;   db 0 ; padding
	db BANK(EspeonPicFront)
	assert BANK(EspeonPicFront) == BANK(EspeonPicBack)

