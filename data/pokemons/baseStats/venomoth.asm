db DEX_VENOMOTH ; pokedex id
db 70 ; base hp
db 75 ; base attack
db 60 ; base defense
db 100 ; base speed
db 95 ; base special
db BUG ; species type 1
db POISON ; species type 2
db 75 ; catch rate
db 138 ; base exp yield
INCBIN "gfx/pokemon/front/venomoth.pic",0,1 ; 77, sprite dimensions
dw VenomothPicFront
dw VenomothPicBack
; attacks known at lvl 0
db TACKLE
db DISABLE
db SUPERSONIC
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm02_RAZOR_WIND, tm06_TOXIC
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm21_MEGA_DRAIN, tm22_SOLARBEAM
; 25 -> 32
	tmlearn tm29_PSYCHIC_M, tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm37_SLUDGE_BOMB, tm39_SWIFT
; 41 -> 48
	tmlearn tm41_GIGA_DRAIN, tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm05_FLASH
;   db 0 ; padding
	db BANK(VenomothPicFront)
	assert BANK(VenomothPicFront) == BANK(VenomothPicBack)

