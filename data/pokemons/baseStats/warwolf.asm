db DEX_WARWOLF ; pokedex id
db 90 ; base hp
db 70 ; base attack
db 80 ; base defense
db 70 ; base speed
db 95 ; base special
db ICE ; species type 1
db STEEL ; species type 2
db 75 ; catch rate
db 176 ; base exp yield
INCBIN "gfx/pokemon/front/warwolf.pic",0,1 ; 66, sprite dimensions
dw WarwolfPicFront
dw WarwolfPicBack
; attacks known at lvl 0
db HEADBUTT
db GROWL
db AURORA_BEAM
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC, tm07_HORN_DRILL, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM, tm16_PAY_DAY
; 17 -> 24
	tmlearn tm20_X_SCISSOR
; 25 -> 32
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm03_SURF, hm04_STRENGTH
;   db 0 ; padding
	db BANK(WarwolfPicFront)
	assert BANK(WarwolfPicFront) == BANK(WarwolfPicBack)

