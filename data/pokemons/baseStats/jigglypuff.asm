db DEX_JIGGLYPUFF ; pokedex id
db 115 ; base hp
db 45 ; base attack
db 20 ; base defense
db 20 ; base speed
db 25 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 170 ; catch rate
db 76 ; base exp yield
INCBIN "gfx/pokemon/front/jigglypuff.pic",0,1 ; 55, sprite dimensions
dw JigglypuffPicFront
dw JigglypuffPicBack
; attacks known at lvl 0
db SING
db 0
db 0
db 0
db 4 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm04_FLAMETHROWER, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD
; 17 -> 24
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm22_SOLARBEAM, tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm28_DIG, tm29_PSYCHIC_M, tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm38_FIRE_BLAST, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm42_SHADOW_BALL, tm44_REST, tm45_THUNDER_WAVE, tm46_DARK_PULSE
; 49 -> 56
	tmlearn tm49_TRI_ATTACK, tm50_SUBSTITUTE, hm04_STRENGTH, hm05_FLASH
;   db 0 ; padding
	db BANK(JigglypuffPicFront)
	assert BANK(JigglypuffPicFront) == BANK(JigglypuffPicBack)

