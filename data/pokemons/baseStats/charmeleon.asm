db DEX_CHARMELEON ; pokedex id
db 58 ; base hp
db 64 ; base attack
db 58 ; base defense
db 80 ; base speed
db 70 ; base special
db FIRE ; species type 1
db FIRE ; species type 2
db 45 ; catch rate
db 142 ; base exp yield
INCBIN "gfx/pokemon/front/charmeleon.pic",0,1 ; 66, sprite dimensions
dw CharmeleonPicFront
dw CharmeleonPicBack
; attacks known at lvl 0
db SCRATCH
db GROWL
db EMBER
db 0
db 3 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm03_SWORDS_DANCE, tm04_FLAMETHROWER, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm23_DRAGON_RAGE
; 25 -> 32
	tmlearn tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm38_FIRE_BLAST, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm04_STRENGTH
;   db 0 ; padding
	db BANK(CharmeleonPicFront)
	assert BANK(CharmeleonPicFront) == BANK(CharmeleonPicBack)

