db DEX_SEEL ; pokedex id
db 65 ; base hp
db 45 ; base attack
db 55 ; base defense
db 45 ; base speed
db 70 ; base special
db ICE ; species type 1
db ICE ; species type 2
db 190 ; catch rate
db 100 ; base exp yield
INCBIN "gfx/pokemon/front/seel.pic",0,1 ; 66, sprite dimensions
dw SeelPicFront
dw SeelPicBack
; attacks known at lvl 0
db HEADBUTT
db 0
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm06_TOXIC, tm07_HORN_DRILL, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm16_PAY_DAY
	tmlearn tm20_RAGE
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm40_SKULL_BASH
	tmlearn tm44_REST
	tmlearn tm50_SUBSTITUTE, hm03_SURF, hm04_STRENGTH
;	db 0 ; padding
	db BANK(SeelPicFront)
	assert BANK(SeelPicFront) == BANK(SeelPicBack)

