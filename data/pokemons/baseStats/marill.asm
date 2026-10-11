db DEX_MARILL ; pokedex id
db 70 ; base hp
db 20 ; base attack
db 50 ; base defense
db 40 ; base speed
db 50 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 190 ; catch rate
db 58 ; base exp yield
INCBIN "gfx/pokemon/front/marill.pic",0,1 ; 55, sprite dimensions
dw MarillPicFront
dw MarillPicBack
; attacks known at lvl 0
db WATER_GUN
db DEFENSE_CURL
db TACKLE
db TAIL_WHIP
db 4 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD
; 17 -> 24
	tmlearn tm19_SEISMIC_TOSS
; 25 -> 32
	tmlearn tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm35_METRONOME, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm03_SURF, hm04_STRENGTH
;   db 0 ; padding
	db BANK(MarillPicFront)
	assert BANK(MarillPicFront) == BANK(MarillPicBack)

