db DEX_SLOWKING ; pokedex id
db 95 ; base hp
db 75 ; base attack
db 80 ; base defense
db 30 ; base speed
db 110 ; base special
db WATER ; species type 1
db PSYCHIC ; species type 2
db 70 ; catch rate
db 164 ; base exp yield
INCBIN "gfx/pokemon/front/slowking.pic",0,1 ; 55, sprite dimensions
dw SlowkingPicFront
dw SlowkingPicBack
; attacks known at lvl 0
db TACKLE
db GROWL
db WATER_GUN
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm04_FLAMETHROWER, tm05_MEGA_KICK, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM, tm16_PAY_DAY
; 17 -> 24
	tmlearn tm18_COUNTER, tm19_SEISMIC_TOSS
; 25 -> 32
	tmlearn tm26_EARTHQUAKE, tm28_DIG, tm29_PSYCHIC_M, tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm35_METRONOME, tm38_FIRE_BLAST, tm39_SWIFT
; 41 -> 48
	tmlearn tm42_SHADOW_BALL, tm44_REST, tm45_THUNDER_WAVE, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm49_TRI_ATTACK, tm50_SUBSTITUTE, hm03_SURF, hm04_STRENGTH, hm05_FLASH
;   db 0 ; padding
	db BANK(SlowkingPicFront)
	assert BANK(SlowkingPicFront) == BANK(SlowkingPicBack)

