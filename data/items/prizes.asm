;joenote - rebalanced prizes
PrizeDifferentMenuPtrs:
	dw PrizeMenuMon1Entries
	dw PrizeMenuMon1Cost

	dw PrizeMenuMon2Entries
	dw PrizeMenuMon2Cost

	dw PrizeMenuTMsEntries
	dw PrizeMenuTMsCost

NoThanksText:
	db "Non merci@"

PrizeMenuMon1Entries:
	db ABRA
	db PIKACHU
	db EEVEE
	db "@"

PrizeMenuMon1Cost:
	coins 150
	coins 750
	coins 1500
	db "@"

PrizeMenuMon2Entries:
	db LARVITAR
	db DRATINI
	db PORYGON
	db "@"

PrizeMenuMon2Cost:
	coins 3500
	coins 5200
	coins 6500
	db "@"

PrizeMenuTMsEntries:
	db TM04_FLAMETHROWER
	db TM13_ICE_BEAM
	db TM24_THUNDERBOLT
	db "@"

PrizeMenuTMsCost:
	coins 5500
	coins 5500
	coins 5500
	db "@"
