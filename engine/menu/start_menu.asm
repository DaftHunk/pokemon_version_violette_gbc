DisplayStartMenu::
	ld a, BANK(StartMenu_Pokedex)
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ld a, [wWalkBikeSurfState] ; walking/biking/surfing
	ld [wWalkBikeSurfStateCopy], a
	ld a, SFX_START_MENU
	call PlaySound

RedisplayStartMenu::
	callba DrawStartMenu
	callba PrintSafariZoneSteps ; print Safari Zone info, if in Safari Zone

	;GBCNote - if using enhanced GBC color, add some extra delay
	ld a, [wGameplayOptions]
	bit 7, a
	call nz, Delay3

	call LoadGBPal	;joenote - moved this here for smoother whiteout transition
	call UpdateSprites
.loop
	call HandleMenuInput
	ld b, a
.checkIfUpPressed
	bit 6, a ; was Up pressed?
	jr z, .checkIfDownPressed
	ld a, [wCurrentMenuItem] ; menu selection
	and a
	jr nz, .loop
	ld a, [wLastMenuItem]
	and a
	jr nz, .loop
; if the player pressed tried to go past the top item, wrap around to the bottom
	CheckEvent EVENT_GOT_SS_TICKET
	jr nz, .hasMeetBillTop

	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .hasPokedexTop

	ld a, 5 ; there are only 6 menu items without the pokedex + portablePC
	jr .wrapMenuItemId
.hasPokedexTop
	ld a, 6 ; edited; there are 7 menu items with the pokedex, so the max index is 6 
	jr .wrapMenuItemId
.hasMeetBillTop
	ld a, 7; edited; there are 8 menu items with the pokedex + portablePC, so the max index is 7
	jr .wrapMenuItemId

.wrapMenuItemId
	ld [wCurrentMenuItem], a
	call EraseMenuCursor
	jr .loop
.checkIfDownPressed
	bit 7, a
	jr z, .buttonPressed
; if the player pressed tried to go past the bottom item, wrap around to the top	
	CheckEvent EVENT_GOT_SS_TICKET
	jr nz, .hasMeetBillBottom

	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .hasPokedexBottom

	ld c, 6 ; edited, there are only 6 menu items without the pokedex + portablePC
	jr .checkIfPastBottom
.hasPokedexBottom
	ld c, 7 ; edited, there are only 7 menu items with the pokedex
	jr .checkIfPastBottom
.hasMeetBillBottom
	ld c, 8 ; edited, there are 8 menu items with the pokedex + portablePC
	jr .checkIfPastBottom

.checkIfPastBottom
	ld a, [wCurrentMenuItem]
	cp c
	jr nz, .loop
; the player went past the bottom, so wrap to the top
	xor a
	ld [wCurrentMenuItem], a
	call EraseMenuCursor
	jr .loop
.buttonPressed ; A, B, or Start button pressed
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	ld [wBattleAndStartSavedMenuItem], a ; save current menu selection
	ld a, b
	and %00001010 ; was the Start button or B button pressed?
	jp nz, CloseStartMenu
	call SaveScreenTilesToBuffer2 ; copy background from wTileMap to wTileMapBackup2
	CheckEvent EVENT_GOT_POKEDEX
	ld a, [wCurrentMenuItem]
	jr nz, .displayMenuItem
	inc a ; adjust position to account for missing pokedex menu item
.displayMenuItem
	cp 0
	jp z, StartMenu_Pokedex
	cp 1
	jp z, StartMenu_Pokemon
	cp 2
	jp z, StartMenu_Item
	cp 3
	jp z, StartMenu_TrainerInfo
	cp 4
	jp z, StartMenu_SaveReset
	cp 5
	jp z, StartMenu_Option
	cp 6
	jp z, .exitOrPortablePC
	jr CloseStartMenu

.exitOrPortablePC
	CheckEvent EVENT_GOT_SS_TICKET
	jr z, CloseStartMenu
	jp StartMenu_PortablePC
 ; back to vanilla

; EXIT falls through to here
CloseStartMenu::
	ld a, [hJoyHeld]
	cp SELECT + START
	jr z, .softlock

	call Joypad
	ld a, [hJoyPressed]
	bit 0, a ; was A button newly pressed?
	jr nz, CloseStartMenu
.end
	jp CloseTextDisplay
.softlock
	callab SoftlockTeleport ;joenote - do a check for a softlock warp
	jr .end
