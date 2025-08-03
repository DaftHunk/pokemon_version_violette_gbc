db DEX_ELECTABUZZ_S ; pokedex id
db 65 ; base hp
db 83 ; base attack
db 57 ; base defense
db 105 ; base speed
db 85 ; base special
db ELECTRIC ; species type 1
db FIGHTING ; species type 2
db 45 ; catch rate
db 156 ; base exp yield
INCBIN "gfx/pokemon/front/electabuzz.pic",0,1 ; 66, sprite dimensions
dw ElectabuzzPicFront
dw ElectabuzzPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
;	db 0 ; padding
	db BANK(ElectabuzzPicFront)
	assert BANK(ElectabuzzPicFront) == BANK(ElectabuzzPicBack)

