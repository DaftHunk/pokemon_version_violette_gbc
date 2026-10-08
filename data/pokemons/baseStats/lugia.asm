db DEX_LUGIA ; pokedex id
db 106 ; base hp
db 90 ; base attack
db 130 ; base defense
db 110 ; base speed
db 154 ; base special
db PSYCHIC ; species type 1
db FLYING ; species type 2
db 3 ; catch rate
db 220 ; base exp yield
INCBIN "gfx/pokemon/front/lugia.pic",0,1 ; 77, sprite dimensions
dw LugiaPicFront
dw LugiaPicBack
; attacks known at lvl 0
db GUST
db WHIRLWIND
db 0
db 0
db 5 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC, tm08_BODY_SLAM,
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm26_EARTHQUAKE, tm29_PSYCHIC_M, tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm39_SWIFT
; 41 -> 48
	tmlearn tm41_GIGA_DRAIN, tm42_SHADOW_BALL, tm43_SKY_ATTACK, tm44_REST, tm45_THUNDER_WAVE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm02_FLY, hm03_SURF, hm04_STRENGTH, hm05_FLASH
;   db 0 ; padding
	db BANK(LugiaPicFront)
	assert BANK(LugiaPicFront) == BANK(LugiaPicBack)

