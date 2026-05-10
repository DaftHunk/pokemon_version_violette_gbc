db DEX_NINETALES ; pokedex id
db 73 ; base hp
db 76 ; base attack
db 75 ; base defense
db 100 ; base speed
db 100 ; base special
db FIRE ; species type 1
db FIRE ; species type 2
db 75 ; catch rate
db 178 ; base exp yield
INCBIN "gfx/pokemon/front/ninetales.pic",0,1 ; 77, sprite dimensions
dw NinetalesPicFront
dw NinetalesPicBack
; attacks known at lvl 0
db EMBER
db QUICK_ATTACK
db CONFUSE_RAY
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm04_FLAMETHROWER, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn 0
; 25 -> 32
	tmlearn tm28_DIG, tm29_PSYCHIC_M, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm38_FIRE_BLAST, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm42_SHADOW_BALL, tm44_REST, tm46_DARK_PULSE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE
;   db 0 ; padding
	db BANK(NinetalesPicFront)
	assert BANK(NinetalesPicFront) == BANK(NinetalesPicBack)

