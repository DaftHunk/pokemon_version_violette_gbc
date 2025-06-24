db DEX_NIDORINO ; pokedex id
db 61 ; base hp
db 72 ; base attack
db 57 ; base defense
db 65 ; base speed
db 55 ; base special
db POISON ; species type 1
db POISON ; species type 2
db 120 ; catch rate
db 118 ; base exp yield
INCBIN "gfx/pokemon/front/nidorino.pic",0,1 ; 66, sprite dimensions
dw NidorinoPicFront
dw NidorinoPicBack
; attacks known at lvl 0
db LEER
db TACKLE
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn tm06_TOXIC, tm07_HORN_DRILL, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD
	tmlearn tm20_RAGE, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm37_SLUDGE_BOMB, tm40_SKULL_BASH
	tmlearn tm44_REST
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm04_STRENGTH
;	db 0 ; padding
	db BANK(NidorinoPicFront)
	assert BANK(NidorinoPicFront) == BANK(NidorinoPicBack)

