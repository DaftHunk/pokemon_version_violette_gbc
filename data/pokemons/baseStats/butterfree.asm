db DEX_BUTTERFREE ; pokedex id
db 60 ; base hp
db 45 ; base attack
db 50 ; base defense
db 70 ; base speed
db 80 ; base special
db BUG ; species type 1
db FLYING ; species type 2
db 45 ; catch rate
db 160 ; base exp yield
INCBIN "gfx/pokemon/front/butterfree.pic",0,1 ; 77, sprite dimensions
dw ButterfreePicFront
dw ButterfreePicBack
; attacks known at lvl 0
db CONFUSION
db 0
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm02_RAZOR_WIND, tm06_TOXIC
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm21_MEGA_DRAIN, tm22_SOLARBEAM
; 25 -> 32
	tmlearn tm29_PSYCHIC_M, tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm39_SWIFT
; 41 -> 48
	tmlearn tm41_GIGA_DRAIN, tm42_SHADOW_BALL, tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm05_FLASH;joenote - learns flash in yellow
;   db 0 ; padding
	db BANK(ButterfreePicFront)
	assert BANK(ButterfreePicFront) == BANK(ButterfreePicBack)

