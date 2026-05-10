db DEX_TANGELA ; pokedex id
db 65 ; base hp
db 55 ; base attack
db 115 ; base defense
db 60 ; base speed
db 100 ; base special
db GRASS ; species type 1
db GRASS ; species type 2
db 45 ; catch rate
db 166 ; base exp yield
INCBIN "gfx/pokemon/front/tangela.pic",0,1 ; 66, sprite dimensions
dw TangelaPicFront
dw TangelaPicBack
; attacks known at lvl 0
db CONSTRICT
db 0
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm03_SWORDS_DANCE, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm21_MEGA_DRAIN, tm22_SOLARBEAM
; 25 -> 32
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm37_SLUDGE_BOMB, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm41_GIGA_DRAIN, tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm05_FLASH
;   db 0 ; padding
	db BANK(TangelaPicFront)
	assert BANK(TangelaPicFront) == BANK(TangelaPicBack)

