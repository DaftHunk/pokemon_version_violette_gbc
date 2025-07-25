InitPlayerData:
InitPlayerData2:
	call Random
	ld [wPlayerID], a
	call Random
	ld [wPlayerID + 1], a
	
	;joenote - generate a random seed for fisher-yates randomizer functions
	call Random
	ld [wRandomizerSeed], a
	
	ld hl, wNumInBox
	call InitializeEmptyList
	
	ld a, $ff
	ld [wUnusedD71B], a

	ld hl, wPartyCount
	call InitializeEmptyList

	ld hl, wNumBagItems
	call InitializeEmptyList

	ld hl, wNumBoxItems
	call InitializeEmptyList
	
	;note that the new extra bag space is wiped out when all the game progress flags get cleared

START_MONEY EQU $3000
	ld hl, wPlayerMoney + 1
	ld a, START_MONEY / $100
	ld [hld], a
	xor a
	ld [hli], a
	inc hl
	ld [hl], a

	ld [wMonDataLocation], a

	ld hl, wObtainedBadges
	ld [hli], a

	ld [hl], a

	ld hl, wPlayerCoins
	ld [hli], a
	ld [hl], a

	ld hl, wGameProgressFlags
	ld bc, wGameProgressFlagsEnd - wGameProgressFlags
	call FillMemory ; clear all game progress flags

	jp InitializeMissableObjectsFlags

InitializeEmptyList:
	xor a ; count
	ld [hli], a
	dec a ; terminator
	ld [hl], a
	ret
