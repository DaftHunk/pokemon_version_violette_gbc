db DEX_SCIZOR; pokedex id
db 70 ; base hp
db 130 ; base attack
db 100 ; base defense
db 65 ; base speed
db 70 ; base special
db BUG ; species type 1
db STEEL ; species type 2
db 25 ; catch rate
db 200 ; base exp yield
INCBIN "gfx/pokemon/front/scizor.pic",0,1 ; 77, sprite dimensions
dw ScizorPicFront
dw ScizorPicBack
; attacks known at lvl 0
db QUICK_ATTACK
db LEER
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm03_SWORDS_DANCE, tm06_TOXIC
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm20_X_SCISSOR
; 25 -> 32
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm02_FLY, hm04_STRENGTH
;   db 0 ; padding
	db BANK(ScizorPicFront)
	assert BANK(ScizorPicFront) == BANK(ScizorPicBack)

