db DEX_MAGNEMITE ; pokedex id
db 25 ; base hp
db 35 ; base attack
db 70 ; base defense
db 45 ; base speed
db 95 ; base special
db ELECTRIC, ; species type 1
db STEEL ; species type 2
db 190 ; catch rate
db 89 ; base exp yield
INCBIN "gfx/pokemon/front/magnemite.pic",0,1 ; 55, sprite dimensions
dw MagnemitePicFront
dw MagnemitePicBack
; attacks known at lvl 0
db TACKLE
db 0
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm06_TOXIC
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
	tmlearn tm20_RAGE, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm39_SWIFT
	tmlearn tm44_REST, tm45_THUNDER_WAVE
	tmlearn tm50_SUBSTITUTE, hm05_FLASH
;	db 0 ; padding
	db BANK(MagnemitePicFront)
	assert BANK(MagnemitePicFront) == BANK(MagnemitePicBack)

