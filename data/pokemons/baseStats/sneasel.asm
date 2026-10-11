db DEX_SNEASEL ; pokedex id
db 70 ; base hp
db 90 ; base attack
db 65 ; base defense
db 110 ; base speed
db 100 ; base special
db DARK ; species type 1
db ICE ; species type 2
db 60 ; catch rate
db 132 ; base exp yield
INCBIN "gfx/pokemon/front/sneasel.pic",0,1 ; 66, sprite dimensions
dw SneaselPicFront
dw SneaselPicBack
; attacks known at lvl 0
db SCRATCH
db LEER
db 0
db 0
db 3 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm01_MEGA_PUNCH, tm03_SWORDS_DANCE, tm05_MEGA_KICK, tm06_TOXIC
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm13_ICE_BEAM, tm14_BLIZZARD
; 17 -> 24
	tmlearn tm18_COUNTER, tm20_X_SCISSOR
; 25 -> 32
	tmlearn tm28_DIG, tm29_PSYCHIC_M, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm42_SHADOW_BALL, tm44_REST, tm46_DARK_PULSE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm03_SURF, hm04_STRENGTH
;   db 0 ; padding
	db BANK(SneaselPicFront)
	assert BANK(SneaselPicFront) == BANK(SneaselPicBack)

