db DEX_NIDORINA ; pokedex id
db 70 ; base hp
db 62 ; base attack
db 67 ; base defense
db 56 ; base speed
db 55 ; base special
db POISON ; species type 1
db POISON ; species type 2
db 120 ; catch rate
db 117 ; base exp yield
INCBIN "gfx/pokemon/front/nidorina.pic",0,1 ; 66, sprite dimensions
dw NidorinaPicFront
dw NidorinaPicBack
; attacks known at lvl 0
db GROWL
db TACKLE
db 0
db 0
db 3 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm04_FLAMETHROWER, tm06_TOXIC, tm07_HORN_DRILL, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD
; 17 -> 24
	tmlearn tm18_COUNTER, tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm37_SLUDGE_BOMB, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm04_STRENGTH
;   db 0 ; padding
	db BANK(NidorinaPicFront)
	assert BANK(NidorinaPicFront) == BANK(NidorinaPicBack)

