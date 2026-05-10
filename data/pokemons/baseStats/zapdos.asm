db DEX_ZAPDOS ; pokedex id
db 90 ; base hp
db 90 ; base attack
db 85 ; base defense
db 100 ; base speed
db 125 ; base special
db ELECTRIC ; species type 1
db FLYING ; species type 2
db 3 ; catch rate
db 216 ; base exp yield
INCBIN "gfx/pokemon/front/zapdos.pic",0,1 ; 77, sprite dimensions
dw ZapdosPicFront
dw ZapdosPicBack
; attacks known at lvl 0
db PECK
db THUNDERSHOCK
db 0
db 0
db 5 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm02_RAZOR_WIND, tm06_TOXIC
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm39_SWIFT
; 41 -> 48
	tmlearn tm43_SKY_ATTACK, tm44_REST, tm45_THUNDER_WAVE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm02_FLY, hm05_FLASH
;   db 0 ; padding
	db BANK(ZapdosPicFront)
	assert BANK(ZapdosPicFront) == BANK(ZapdosPicBack)

