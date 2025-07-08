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
	tmlearn tm04_FLAMETHROWER, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD
	tmlearn tm20_RAGE, tm23_DRAGON_RAGE, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm38_FIRE_BLAST, tm39_SWIFT, tm40_SKULL_BASH
	tmlearn tm44_REST, tm45_THUNDER_WAVE
	tmlearn tm50_SUBSTITUTE, hm03_SURF
;	db 0 ; padding
	db BANK(DratiniPicFront)
	assert BANK(DratiniPicFront) == BANK(DratiniPicBack)

