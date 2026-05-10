db DEX_ARTICUNO ; pokedex id
db 90 ; base hp
db 85 ; base attack
db 100 ; base defense
db 85 ; base speed
db 125 ; base special
db ICE ; species type 1
db FLYING ; species type 2
db 3 ; catch rate
db 215 ; base exp yield
INCBIN "gfx/pokemon/front/articuno.pic",0,1 ; 77, sprite dimensions
dw ArticunoPicFront
dw ArticunoPicBack
; attacks known at lvl 0
db GUST
db 0
db 0
db 0
db 5 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm02_RAZOR_WIND, tm06_TOXIC
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn 0
; 25 -> 32
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm39_SWIFT
; 41 -> 48
	tmlearn tm43_SKY_ATTACK, tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm02_FLY
;   db 0 ; padding
	db BANK(ArticunoPicFront)
	assert BANK(ArticunoPicFront) == BANK(ArticunoPicBack)

