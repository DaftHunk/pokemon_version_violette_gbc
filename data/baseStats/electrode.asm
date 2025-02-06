db DEX_ELECTRODE ; pokedex id
db 60 ; base hp
db 50 ; base attack
db 70 ; base defense
db 140 ; base speed
db 80 ; base special
db ELECTRIC ; species type 1
db ELECTRIC ; species type 2
db 60 ; catch rate
db 150 ; base exp yield
INCBIN "gfx/pokemon/front/electrode.pic",0,1 ; 55, sprite dimensions
dw ElectrodePicFront
dw ElectrodePicBack
; attacks known at lvl 0
db TACKLE
db SCREECH
db SONICBOOM
db SELFDESTRUCT
db 0 ; growth rate
; learnset
	tmlearn tm06_TOXIC
	tmlearn tm09_TAKE_DOWN, tm15_HYPER_BEAM
	tmlearn tm20_RAGE, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm36_SELFDESTRUCT, tm39_SWIFT, tm40_SKULL_BASH
	tmlearn tm44_REST, tm45_THUNDER_WAVE, tm47_EXPLOSION
	tmlearn tm50_SUBSTITUTE, hm05_FLASH
;	db 0 ; padding
	db BANK(ElectrodePicFront)
	assert BANK(ElectrodePicFront) == BANK(ElectrodePicBack)

