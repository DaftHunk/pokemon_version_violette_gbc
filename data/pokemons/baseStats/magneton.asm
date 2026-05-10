db DEX_MAGNETON ; pokedex id
db 50 ; base hp
db 60 ; base attack
db 95 ; base defense
db 70 ; base speed
db 120 ; base special
db ELECTRIC, ; species type 1
db STEEL ; species type 2
db 60 ; catch rate
db 161 ; base exp yield
INCBIN "gfx/pokemon/front/magneton.pic",0,1 ; 66, sprite dimensions
dw MagnetonPicFront
dw MagnetonPicBack
; attacks known at lvl 0
db TACKLE
db SONICBOOM
db THUNDERSHOCK
db SUPERSONIC
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm39_SWIFT
; 41 -> 48
	tmlearn tm44_REST, tm45_THUNDER_WAVE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm05_FLASH
;   db 0 ; padding
	db BANK(MagnetonPicFront)
	assert BANK(MagnetonPicFront) == BANK(MagnetonPicBack)

