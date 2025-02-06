db DEX_KRABBY ; pokedex id
db 30 ; base hp
db 105 ; base attack
db 90 ; base defense
db 50 ; base speed
db 25 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 225 ; catch rate
db 115 ; base exp yield
INCBIN "gfx/pokemon/front/krabby.pic",0,1 ; 55, sprite dimensions
dw KrabbyPicFront
dw KrabbyPicBack
; attacks known at lvl 0
db BUBBLE
db 0
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm03_SWORDS_DANCE, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD
	tmlearn tm20_RAGE
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE
	tmlearn tm44_REST
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm03_SURF, hm04_STRENGTH
;	db 0 ; padding
	db BANK(KrabbyPicFront)
	assert BANK(KrabbyPicFront) == BANK(KrabbyPicBack)

