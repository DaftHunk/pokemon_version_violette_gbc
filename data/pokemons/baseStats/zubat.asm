db DEX_ZUBAT ; pokedex id
db 40 ; base hp
db 45 ; base attack
db 35 ; base defense
db 55 ; base speed
db 40 ; base special
db POISON ; species type 1
db FLYING ; species type 2
db 255 ; catch rate
db 54 ; base exp yield
INCBIN "gfx/pokemon/front/zubat.pic",0,1 ; 55, sprite dimensions
dw ZubatPicFront
dw ZubatPicBack
; attacks known at lvl 0
db LEECH_LIFE
db 0
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm02_RAZOR_WIND, tm06_TOXIC
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn tm21_MEGA_DRAIN
; 25 -> 32
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm37_SLUDGE_BOMB, tm39_SWIFT
; 41 -> 48
	tmlearn tm41_GIGA_DRAIN, tm42_SHADOW_BALL, tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE
;   db 0 ; padding
	db BANK(ZubatPicFront)
	assert BANK(ZubatPicFront) == BANK(ZubatPicBack)

