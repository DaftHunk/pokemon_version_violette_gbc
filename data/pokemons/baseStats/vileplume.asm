db DEX_VILEPLUME ; pokedex id
db 95 ; base hp
db 80 ; base attack
db 85 ; base defense
db 50 ; base speed
db 100 ; base special
db GRASS ; species type 1
db POISON ; species type 2
db 45 ; catch rate
db 184 ; base exp yield
INCBIN "gfx/pokemon/front/vileplume.pic",0,1 ; 77, sprite dimensions
dw VileplumePicFront
dw VileplumePicBack
; attacks known at lvl 0
db ABSORB
db POISONPOWDER
db STUN_SPORE
db SLEEP_POWDER
db 3 ; growth rate
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
	tmlearn tm33_REFLECT, tm34_BIDE, tm37_SLUDGE_BOMB
; 41 -> 48
	tmlearn tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm05_FLASH
;   db 0 ; padding
	db BANK(VileplumePicFront)
	assert BANK(VileplumePicFront) == BANK(VileplumePicBack)

