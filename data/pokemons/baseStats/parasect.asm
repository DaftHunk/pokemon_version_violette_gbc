db DEX_PARASECT ; pokedex id
db 60 ; base hp
db 95 ; base attack
db 80 ; base defense
db 30 ; base speed
db 80 ; base special
db BUG ; species type 1
db GHOST ; species type 2
db 75 ; catch rate
db 128 ; base exp yield
INCBIN "gfx/pokemon/front/parasect.pic",0,1 ; 77, sprite dimensions
dw ParasectPicFront
dw ParasectPicBack
; attacks known at lvl 0
db SCRATCH
db STUN_SPORE
db POISONPOWDER
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm03_SWORDS_DANCE, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
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
	db BANK(ParasectPicFront)
	assert BANK(ParasectPicFront) == BANK(ParasectPicBack)

