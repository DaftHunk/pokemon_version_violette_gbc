db DEX_MEOWTH ; pokedex id
db 40 ; base hp
db 45 ; base attack
db 35 ; base defense
db 90 ; base speed
db 40 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 255 ; catch rate
db 69 ; base exp yield
INCBIN "gfx/pokemon/front/meowth.pic",0,1 ; 55, sprite dimensions
dw MeowthPicFront
dw MeowthPicBack
; attacks known at lvl 0
db SCRATCH
db GROWL
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm16_PAY_DAY
; 17 -> 24
	tmlearn tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm42_SHADOW_BALL, tm44_REST, tm46_DARK_PULSE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm05_FLASH
;   db 0 ; padding
	db BANK(MeowthPicFront)
	assert BANK(MeowthPicFront) == BANK(MeowthPicBack)

