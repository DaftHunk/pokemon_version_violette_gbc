db DEX_KINGDRA ; pokedex id
db 75 ; base hp
db 95 ; base attack
db 95 ; base defense
db 85 ; base speed
db 95 ; base special
db WATER ; species type 1
db DRAGON ; species type 2
db 45 ; catch rate
db 207 ; base exp yield
INCBIN "gfx/pokemon/front/kingdra.pic",0,1 ; 77, sprite dimensions
dw KingdraPicFront
dw KingdraPicBack
; attacks known at lvl 0
db BUBBLE
db SMOKESCREEN
db LEER
db WATER_GUN
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC, tm07_HORN_DRILL
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn 0
; 25 -> 32
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm03_SURF
;   db 0 ; padding
	db BANK(KingdraPicFront)
	assert BANK(KingdraPicFront) == BANK(KingdraPicBack)

