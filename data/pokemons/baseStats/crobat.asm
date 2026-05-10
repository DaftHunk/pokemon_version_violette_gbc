db DEX_CROBAT ; pokedex id
db 85 ; base hp
db 90 ; base attack
db 80 ; base defense
db 130 ; base speed
db 75 ; base special
db POISON ; species type 1
db FLYING ; species type 2
db 90 ; catch rate
db 241 ; base exp yield
INCBIN "gfx/pokemon/front/crobat.pic",0,1 ; 77, sprite dimensions
dw CrobatPicFront
dw CrobatPicBack
; attacks known at lvl 0
db LEECH_LIFE
db SCREECH
db BITE
db SUPERSONIC
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm02_RAZOR_WIND, tm04_FLAMETHROWER, tm06_TOXIC
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm20_X_SCISSOR, tm21_MEGA_DRAIN
; 25 -> 32
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm37_SLUDGE_BOMB, tm39_SWIFT
; 41 -> 48
	tmlearn tm41_GIGA_DRAIN, tm42_SHADOW_BALL, tm44_REST, tm46_DARK_PULSE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm02_FLY
;   db 0 ; padding
	db BANK(CrobatPicFront)
	assert BANK(CrobatPicFront) == BANK(CrobatPicBack)

