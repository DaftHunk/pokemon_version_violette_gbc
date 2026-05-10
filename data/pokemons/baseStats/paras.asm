db DEX_PARAS ; pokedex id
db 35 ; base hp
db 70 ; base attack
db 55 ; base defense
db 25 ; base speed
db 55 ; base special
db BUG ; species type 1
db GRASS ; species type 2
db 190 ; catch rate
db 70 ; base exp yield
INCBIN "gfx/pokemon/front/paras.pic",0,1 ; 55, sprite dimensions
dw ParasPicFront
dw ParasPicBack
; attacks known at lvl 0
db SCRATCH
db 0
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm03_SWORDS_DANCE, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn tm18_COUNTER, tm20_X_SCISSOR, tm21_MEGA_DRAIN, tm22_SOLARBEAM
; 25 -> 32
	tmlearn tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm37_SLUDGE_BOMB, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm41_GIGA_DRAIN, tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm05_FLASH
;   db 0 ; padding
	db BANK(ParasPicFront)
	assert BANK(ParasPicFront) == BANK(ParasPicBack)

