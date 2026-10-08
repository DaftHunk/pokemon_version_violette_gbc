db DEX_AZUMARILL ; pokedex id
db 100 ; base hp
db 50 ; base attack
db 80 ; base defense
db 50 ; base speed
db 80 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 75 ; catch rate
db 153 ; base exp yield
INCBIN "gfx/pokemon/front/azumarill.pic",0,1 ; 66, sprite dimensions
dw AzumarillPicFront
dw AzumarillPicBack
; attacks known at lvl 0
db DEFENSE_CURL
db TACKLE
db WATER_GUN
db TAIL_WHIP
db 4 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM
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
	db BANK(AzumarillPicFront)
	assert BANK(AzumarillPicFront) == BANK(AzumarillPicBack)

