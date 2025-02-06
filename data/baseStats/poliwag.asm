db DEX_POLIWAG ; pokedex id
db 40 ; base hp
db 50 ; base attack
db 40 ; base defense
db 90 ; base speed
db 40 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 255 ; catch rate
db 77 ; base exp yield
INCBIN "gfx/pokemon/front/poliwag.pic",0,1 ; 55, sprite dimensions
dw PoliwagPicFront
dw PoliwagPicBack
; attacks known at lvl 0
db BUBBLE
db 0
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD
	tmlearn tm20_RAGE
	tmlearn tm29_PSYCHIC_M, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm40_SKULL_BASH
	tmlearn tm44_REST, tm46_PSYWAVE
	tmlearn tm50_SUBSTITUTE, hm03_SURF
;	db 0 ; padding
	db BANK(PoliwagPicFront)
	assert BANK(PoliwagPicFront) == BANK(PoliwagPicBack)

