db DEX_CLEFAIRY ; pokedex id
db 70 ; base hp
db 45 ; base attack
db 48 ; base defense
db 35 ; base speed
db 60 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 150 ; catch rate
db 68 ; base exp yield
INCBIN "gfx/pokemon/front/clefairy.pic",0,1 ; 55, sprite dimensions
dw ClefairyPicFront
dw ClefairyPicBack
; attacks known at lvl 0
db POUND
db GROWL
db 0
db 0
db 4 ; growth rate
; learnset
	tmlearn tm01_MEGA_PUNCH, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm20_RAGE, tm22_SOLARBEAM, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm29_PSYCHIC_M, tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm35_METRONOME, tm38_FIRE_BLAST, tm40_SKULL_BASH
	tmlearn tm44_REST, tm45_THUNDER_WAVE, tm46_PSYWAVE
	tmlearn tm49_TRI_ATTACK, tm50_SUBSTITUTE, hm04_STRENGTH, hm05_FLASH
;	db 0 ; padding
	db BANK(ClefairyPicFront)
	assert BANK(ClefairyPicFront) == BANK(ClefairyPicBack)

