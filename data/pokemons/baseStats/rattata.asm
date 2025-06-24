db DEX_RATTATA ; pokedex id
db 30 ; base hp
db 56 ; base attack
db 35 ; base defense
db 72 ; base speed
db 25 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 255 ; catch rate
db 57 ; base exp yield
INCBIN "gfx/pokemon/front/rattata.pic",0,1 ; 55, sprite dimensions
dw RattataPicFront
dw RattataPicBack
; attacks known at lvl 0
db TACKLE
db TAIL_WHIP
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm14_BLIZZARD
	tmlearn tm20_RAGE, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm39_SWIFT, tm40_SKULL_BASH
	tmlearn tm44_REST
	tmlearn tm50_SUBSTITUTE, hm01_CUT
;	db 0 ; padding
	db BANK(RattataPicFront)
	assert BANK(RattataPicFront) == BANK(RattataPicBack)

