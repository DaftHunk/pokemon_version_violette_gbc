db DEX_HORSEA ; pokedex id
db 30 ; base hp
db 40 ; base attack
db 70 ; base defense
db 60 ; base speed
db 70 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 225 ; catch rate
db 83 ; base exp yield
INCBIN "gfx/pokemon/front/horsea.pic",0,1 ; 55, sprite dimensions
dw HorseaPicFront
dw HorseaPicBack
; attacks known at lvl 0
db BUBBLE
db 0
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD
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
	db BANK(HorseaPicFront)
	assert BANK(HorseaPicFront) == BANK(HorseaPicBack)

