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
	db HORSEA
	db "@"

PrizeMenuMon1Cost:
	coins 150
	coins 750
	coins 1200
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
	db TM24_THUNDERBOLT
	db TM14_BLIZZARD
	db TM15_HYPER_BEAM
	db "@"

PrizeMenuTMsCost:
	coins 3300
	coins 5500
	coins 7700
	db "@"
