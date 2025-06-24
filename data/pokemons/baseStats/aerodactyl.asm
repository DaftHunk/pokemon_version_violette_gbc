db DEX_AERODACTYL ; pokedex id
db 80 ; base hp
db 105 ; base attack
db 65 ; base defense
db 130 ; base speed
db 60 ; base special
db ROCK ; species type 1
db DRAGON ; species type 2
db 45 ; catch rate
db 202 ; base exp yield
INCBIN "gfx/pokemon/front/aerodactyl.pic",0,1 ; 77, sprite dimensions
dw AerodactylPicFront
dw AerodactylPicBack
; attacks known at lvl 0
db WING_ATTACK
db 0
db 0
db 0
db 5 ; growth rate
; learnset
	tmlearn tm02_RAZOR_WIND, tm06_TOXIC
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
	tmlearn tm20_RAGE, tm23_DRAGON_RAGE
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm38_FIRE_BLAST, tm39_SWIFT
	tmlearn tm43_SKY_ATTACK, tm44_REST
	tmlearn tm50_SUBSTITUTE, hm02_FLY, hm04_STRENGTH
;	db 0 ; padding
	db BANK(AerodactylPicFront)
	assert BANK(AerodactylPicFront) == BANK(AerodactylPicBack)

