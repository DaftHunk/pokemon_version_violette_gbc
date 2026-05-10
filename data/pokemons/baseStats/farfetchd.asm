db DEX_FARFETCHD ; pokedex id
db 62 ; base hp
db 135 ; base attack
db 95 ; base defense
db 65 ; base speed
db 70 ; base special
db FLYING ; species type 1
db FIGHTING ; species type 2
db 45 ; catch rate
db 94 ; base exp yield
INCBIN "gfx/pokemon/front/farfetchd.pic",0,1 ; 66, sprite dimensions
dw FarfetchdPicFront
dw FarfetchdPicBack
; attacks known at lvl 0
db PECK
db 0
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm02_RAZOR_WIND, tm03_SWORDS_DANCE, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS
; 25 -> 32
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm02_FLY, hm04_STRENGTH
;   db 0 ; padding
	db BANK(FarfetchdPicFront)
	assert BANK(FarfetchdPicFront) == BANK(FarfetchdPicBack)

