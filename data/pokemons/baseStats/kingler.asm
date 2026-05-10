db DEX_KINGLER ; pokedex id
db 55 ; base hp
db 130 ; base attack
db 115 ; base defense
db 75 ; base speed
db 50 ; base special
db WATER ; species type 1
db GROUND ; species type 2
db 60 ; catch rate
db 206 ; base exp yield
INCBIN "gfx/pokemon/front/kingler.pic",0,1 ; 77, sprite dimensions
dw KinglerPicFront
dw KinglerPicBack
; attacks known at lvl 0
db BUBBLE
db LEER
db VICEGRIP
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm03_SWORDS_DANCE, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm20_X_SCISSOR, tm28_DIG
; 25 -> 32
	tmlearn tm26_EARTHQUAKE, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE
; 41 -> 48
	tmlearn tm44_REST, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm03_SURF, hm04_STRENGTH
;   db 0 ; padding
	db BANK(KinglerPicFront)
	assert BANK(KinglerPicFront) == BANK(KinglerPicBack)

