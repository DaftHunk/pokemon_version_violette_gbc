TypeNames:

	dw .Normal
	dw .Fighting
	dw .Flying
	dw .Poison
	dw .Ground
	dw .Rock
	dw .Bird
	dw .Bug
	dw .Dragon
	dw .Steel

	dw .Normal
	dw .Normal
	dw .Normal
	dw .Normal
	dw .Normal
	dw .Normal
	dw .Normal
	dw .Normal
	dw .Normal
	dw .Normal

	dw .Fire
	dw .Water
	dw .Grass
	dw .Electric
	dw .Psychic
	dw .Ice
	dw .Ghost
	dw .Dark

.Normal:   db "Normal@"
.Fighting: db "Combat@"
.Flying:   db "Vol@"
.Poison:   db "Poison@"
.Fire:     db "Feu@"
.Water:    db "Eau@"
.Grass:    db "Plante@"
.Electric: db "Electrik@"
.Psychic:  db "Psy@"
.Ice:      db "Glace@"
.Ground:   db "Sol@"
.Rock:     db "Roche@"
.Bird:     db "Neutre@"	;joenote - Bird type will be used as a neutral typless dummy type for Struggle
.Bug:      db "Insecte@"
.Ghost:    db "Spectre@"
.Steel:    db "Acier@"
.Dragon:   db "Dragon@"
.Dark:     db "Ténèbre@"
