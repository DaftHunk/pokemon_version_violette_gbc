db DEX_HOOH ; pokedex id
db 106 ; base hp
db 130 ; base attack
db 90 ; base defense
db 90 ; base speed
db 134 ; base special
db FIRE ; species type 1
db FLYING ; species type 2
db 3 ; catch rate
db 220 ; base exp yield
INCBIN "gfx/pokemon/front/hooh.pic",0,1 ; 77, sprite dimensions
dw HoohPicFront
dw HoohPicBack
; attacks known at lvl 0
db WING_ATTACK
db EMBER
db 0
db 0
db 5 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm02_RAZOR_WIND, tm04_FLAMETHROWER, tm06_TOXIC
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm22_SOLARBEAM
; 25 -> 32
	tmlearn tm25_THUNDER, tm26_EARTHQUAKE, tm29_PSYCHIC_M, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm38_FIRE_BLAST, tm39_SWIFT
; 41 -> 48
	tmlearn tm41_GIGA_DRAIN, tm42_SHADOW_BALL, tm43_SKY_ATTACK, tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm02_FLY, hm04_STRENGTH, hm05_FLASH
;   db 0 ; padding
	db BANK(HoohPicFront)
	assert BANK(HoohPicFront) == BANK(HoohPicBack)

