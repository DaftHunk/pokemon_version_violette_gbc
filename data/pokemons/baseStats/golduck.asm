db DEX_GOLDUCK ; pokedex id
db 80 ; base hp
db 82 ; base attack
db 78 ; base defense
db 85 ; base speed
db 80 ; base special
db WATER ; species type 1
db PSYCHIC ; species type 2
db 75 ; catch rate
db 174 ; base exp yield
INCBIN "gfx/pokemon/front/golduck.pic",0,1 ; 77, sprite dimensions
dw GolduckPicFront
dw GolduckPicBack
; attacks known at lvl 0
db SCRATCH
db TAIL_WHIP
db DISABLE
db CONFUSION
db 0 ; growth rate
; learnset
	tmlearn tm01_MEGA_PUNCH, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM, tm16_PAY_DAY
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm20_RAGE
	tmlearn tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm39_SWIFT, tm40_SKULL_BASH
	tmlearn tm44_REST
	tmlearn tm50_SUBSTITUTE, hm03_SURF, hm04_STRENGTH, hm05_FLASH
;	db 0 ; padding
	db BANK(GolduckPicFront)
	assert BANK(GolduckPicFront) == BANK(GolduckPicBack)

