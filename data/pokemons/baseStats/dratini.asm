db DEX_DRATINI ; pokedex id
db 41 ; base hp
db 64 ; base attack
db 45 ; base defense
db 50 ; base speed
db 50 ; base special
db DRAGON ; species type 1
db DRAGON ; species type 2
db 45 ; catch rate
db 67 ; base exp yield
INCBIN "gfx/pokemon/front/dratini.pic",0,1 ; 55, sprite dimensions
dw DratiniPicFront
dw DratiniPicBack
; attacks known at lvl 0
db BIND
db LEER
db 0
db 0
db 5 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm04_FLAMETHROWER, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD
; 17 -> 24
	tmlearn tm23_DRAGON_RAGE, tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm38_FIRE_BLAST, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST, tm45_THUNDER_WAVE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm03_SURF
;   db 0 ; padding
	db BANK(DratiniPicFront)
	assert BANK(DratiniPicFront) == BANK(DratiniPicBack)

