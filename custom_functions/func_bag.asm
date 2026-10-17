;joenote - this is a general function for doing stuff with the bag data
;Entered by pressing START on the bag menu list
HandleBagData:
	ld a, [wListMenuID]
	cp ITEMLISTMENU
	ret nz
	
	ld a, [hJoyHeld]
	bit BIT_SELECT, a
	jp nz, SortItems	;if holding SELECT, then prompt to sort items
	
	;if holding RIGHT or LEFT, then send the item to the backup bag space
	bit BIT_D_RIGHT, a	
	jp nz, SendToBackupBag
	bit BIT_D_LEFT, a	
	jp nz, SendToBackupBag
;else fall through	

;joenote - This function swaps the primary bag data with a second set of stored bag data
SwapBagData:
	;do not swap bag data if the current list shown is the PC item box
	ld a, [wMiscFlags]
	bit BIT_NO_SPRITE_UPDATES, a
	ret nz
	
	push bc
	push de
	push hl
	
	coord hl, 5, 3
	ld de, .swaptext
	call PlaceString
	ld c, 9
	call DelayFrames
	
	call BackupBagSwap

	call UpdateMenuInfo
	
	ld a, [wNumBagItems]
	ld [wListCount], a
	cp 2 ; does the list have less than 2 entries?
	jr c, .setMenuVariables
	ld a, 2 ; max menu item ID is 2 if the list has at least 2 entries
.setMenuVariables
	ld [wMaxMenuItem], a
	
	ld a, SFX_START_MENU
	call PlaySound

	call DrawItemIcon ; refresh the icon: the bag contents changed
	
	pop hl
	pop de
	pop bc
	ret
.swaptext
	db " [changement]@"

BackupBagSwap:
	;swap out the items
	push bc
	push de

	;format the terminator at the end
	ld a, $FF
	ld [wBagItemsBackupTerminator], a
	;format the list terminator given the number of items
	ld a, [wBagNumBackup]
	ld b, $00
	ld c, a
	ld hl, wBagItemsBackup
	add hl, bc
	add hl, bc
	ld [hl], $FF
	
	ld c, wBagBackupSpaceEnd - wBagBackupSpace
	ld de, wBagBackupSpace
	ld hl, wNumBagItems
	call SwapDataSmall

	pop de
	pop bc
	ret

SwapDataSmall:
; Swap c bytes from hl to de using a and b.
	ld a, [hl]
	ld b, a
	ld a, [de]
	ld [hl], a
	ld a, b
	ld [de], a
	inc de
	inc hl
	dec c
	jr nz, SwapDataSmall
	ret

UpdateMenuInfo:
	; update menu info
	xor a
	ld [wListScrollOffset], a
	ld [wCurrentMenuItem], a
	ld [wBagSavedMenuItem], a
	ld [wSavedListScrollOffset], a
	ld [wMenuItemToSwap], a
	ret

SendToBackupBag:

	;do not do anything if the current list shown is the PC item box
	ld a, [wMiscFlags]
	bit BIT_NO_SPRITE_UPDATES, a
	ret nz

	push bc
	push de
	push hl
;First we have to find out which item the cursor is pointing to and put it in wcf91
	ld a, [wCurrentMenuItem]
	ld c, a
	ld a, [wListScrollOffset]
	add c
	ld c, a
	ld a, [wListCount]
	and a ; is the list empty?
	jr z, .return ; if so, return
	dec a
	cp c ; did the player select Cancel?
	jr c, .return ; if so, exit the menu
	ld a, c
	ld [wWhichPokemon], a	;Store the index (within the inventory) of the item
	sla c ; item entries are 2 bytes long, so multiply by 2
	ld a, [wListPointer]
	ld l, a
	ld a, [wListPointer + 1]
	ld h, a
	inc hl ; hl = beginning of list entries
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wcf91], a
;Now to get the quantity of that item and put it in wMaxItemQuantity and wItemQuantity
	inc hl
	ld a, [hl] ; a = item quantity
	ld [wMaxItemQuantity], a
	ld [wItemQuantity], a
;Display some text
	coord hl, 5, 3
	ld de, .shifttext
	call PlaceString
	ld c, 18
	call DelayFrames
;Copy item to backup bag space
	ld hl, wBagNumBackup
	call AddItemToInventory
	jr nc, .return	;jump if no room available in the backup bag
;Remove from the active bag space
	ld hl, wNumBagItems
	call RemoveItemFromInventory
;Update the menu list
	call UpdateMenuInfo
	ld a, [wListCount]
	cp 2 ; does the list have less than 2 entries?
	jr c, .setMenuVariables
	ld a, 2 ; max menu item ID is 2 if the list has at least 2 entries
.setMenuVariables
	ld [wMaxMenuItem], a
;Play a sound effect
	ld a, SFX_TINK
	call PlaySound
	call UpdateMenuInfo
	call DrawItemIcon ; refresh the icon: the list contents changed
.return
	pop hl
	pop de
	pop bc
	ret
.shifttext
	db " [déplacement]@"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Implementing the bag sorting feature written by devolov
;Wasn't hard to also make this work with the PC item box
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SortItems:
	push de
	push hl
	push bc
;	ld hl, SortItemsText ; Display the text to ask to sort
;	call PrintText
;	call YesNoChoice
;	ld a, [wCurrentMenuItem]
;	and a
;	jp z, .beginSorting ; If yes
;	jr .done
	jp .beginSorting
.finishedSwapping
	ld a, [hSwapTemp] ; If not 0, then a swap of items did occur
	and a
	jr z, .nothingSorted
;	ld hl, SortComplete
	jr .printResultText
.nothingSorted
;	ld hl, NothingToSort
.printResultText
;	call PrintText
	ld a, SFX_START_MENU
	call PlaySound
.done
	call UpdateMenuInfo
	xor a ; Zeroes a
	pop bc
	pop hl
	pop de
	ret
.beginSorting
	xor a
	ld [hSwapTemp], a ; 1 if something in the bag got sorted
	ld de, 0
	ld hl, ItemSortList
	ld b, [hl] ; This is the first item to check for
	call .ldHLbagorbox
	ld c, 0 ; Relative to wBagItems, this is where we'd like to begin swapping
.loopCurrItemInBag
	ld a, [hl] ; Load the value of hl to a (which is an item number)
	cp $FF ; See if the item number is $ff, which is 'cancel'
	jr z, .findNextItem ; If it is cancel, then move onto the next item
	cp b
	jr z, .hasItem 
	; If it's not b, then go to the next item in the bag
	inc hl ; increments to the quantity past the quantity to the next item to check
	inc hl ; increments past the quantity to the next item to check
	jr .loopCurrItemInBag
.findNextItem
	ld d, 0
	inc e
	ld hl, ItemSortList
	add hl, de
	ld b, [hl]
	call .ldHLbagorbox ; Resets hl to start at the beginning of the bag
	ld a, b
	cp $FF ; Check if we got through all of the items, to the last one
	jr z, .finishedSwapping
	jr .loopCurrItemInBag
.hasItem ; c contains where to swap to relative to the start of wBagItems
		 ; hl contains where the item to swap is absolute
		 ; b contains the item ID
	push de
	ld d, h
	ld e, l
	call .ldHLbagorbox
	ld a, b
	ld b, 0
	add hl, bc ; hl now holds where we'd like to swap to
	ld b, a
	ld a, [de]
	cp [hl]
	jr z, .cont ; If they're the same item
	ld a, 1
	ld [hSwapTemp], a
	ld a, [hl]
	ld [hSwapItemID],a ; [hSwapItemID] = second item ID
	inc hl
	ld a,[hld]
	ld [hSwapItemQuantity],a ; [hSwapItemQuantity] = second item quantity
	ld a,[de]
	ld [hli],a ; put first item ID in second item slot
	inc de
	ld a,[de]
	ld [hl],a ; put first item quantity in second item slot
	ld a,[hSwapItemQuantity]
	ld [de],a ; put second item quantity in first item slot
	dec de
	ld a,[hSwapItemID]
	ld [de],a ; put second item ID in first item slot
.cont
	inc c
	inc c
	ld h, d
	ld l, e
	pop de
	jr .findNextItem

;joenote - allow for sorting both the bag and the item PC box
.ldHLbagorbox
	ld hl, wBagItems
	push af
	ld a, [wMiscFlags]
	bit BIT_NO_SPRITE_UPDATES, a
	jr z, .ldHLbagorbox_next
	ld hl, wBoxItems
.ldHLbagorbox_next
	pop af
	ret


ItemSortList::	;only for items that are bag-accessed
	; Active-Usage Key Items
	db BICYCLE
	db ITEMFINDER
	db TOWN_MAP
	db SURFBOARD
	; Rods
	db OLD_ROD
	db GOOD_ROD
	db SUPER_ROD
	; Balls
	db POKE_BALL
	db GREAT_BALL
	db ULTRA_BALL
	db MASTER_BALL
	; Common Items
	db REPEL
	db SUPER_REPEL
	db MAX_REPEL
	db ESCAPE_ROPE
	db POKE_DOLL
	; Health
	db POTION
	db SUPER_POTION
	db HYPER_POTION
	db MAX_POTION
	db FULL_RESTORE
	db FRESH_WATER
	db SODA_POP
	db LEMONADE
	; Revival
	db REVIVE
	db MAX_REVIVE
	; Status
	db ANTIDOTE
	db BURN_HEAL
	db ICE_HEAL
	db AWAKENING
	db PARLYZ_HEAL
	db FULL_HEAL
	db POKE_FLUTE
	; PP
	db ETHER
	db MAX_ETHER
	db ELIXER
	db MAX_ELIXER
	; Battle Raises
	db X_ACCURACY
	db X_ATTACK
	db X_DEFEND
	db X_SPEED
	db X_SPECIAL
	db GUARD_SPEC
	db DIRE_HIT
	; Permanent Raises
	db RARE_CANDY
	db HP_UP
	db PROTEIN
	db IRON
	db CARBOS
	db CALCIUM
	db PP_UP
	db M_GENE
	db BERSERK_ADN
	; Stones
	db LEAF_STONE
	db FIRE_STONE
	db THUNDER_STONE
	db WATER_STONE
	db MOON_STONE
	db SOUL_STONE
	db MIST_STONE
	db METAL_COAT
	; Money
	db COIN_CASE
	db NUGGET
	; Gift Passives
	db EXP_ALL
	db EXP_CATCH_UP
	db DOME_FOSSIL
	db HELIX_FOSSIL
	db OLD_AMBER
	; Key Items With No Active Use
	db S_S_TICKET
	db SILPH_SCOPE
	db SECRET_KEY
	db LIFT_KEY
	db CARD_KEY
	; Key Items That Are Used For Events
	db GOLD_TEETH
	db BIKE_VOUCHER
	db OAKS_PARCEL
	; TMs
	db TM01_MEGA_PUNCH
	db TM01_MEGA_PUNCH + 1
	db TM01_MEGA_PUNCH + 2
	db TM01_MEGA_PUNCH + 3
	db TM01_MEGA_PUNCH + 4
	db TM01_MEGA_PUNCH + 5
	db TM01_MEGA_PUNCH + 6
	db TM01_MEGA_PUNCH + 7
	db TM01_MEGA_PUNCH + 8
	db TM01_MEGA_PUNCH + 9
	db TM01_MEGA_PUNCH + 10
	db TM01_MEGA_PUNCH + 11
	db TM01_MEGA_PUNCH + 12
	db TM01_MEGA_PUNCH + 13
	db TM01_MEGA_PUNCH + 14
	db TM01_MEGA_PUNCH + 15
	db TM01_MEGA_PUNCH + 16
	db TM01_MEGA_PUNCH + 17
	db TM01_MEGA_PUNCH + 18
	db TM01_MEGA_PUNCH + 19
	db TM01_MEGA_PUNCH + 20
	db TM01_MEGA_PUNCH + 21
	db TM01_MEGA_PUNCH + 22
	db TM01_MEGA_PUNCH + 23
	db TM01_MEGA_PUNCH + 24
	db TM01_MEGA_PUNCH + 25
	db TM01_MEGA_PUNCH + 26
	db TM01_MEGA_PUNCH + 27
	db TM01_MEGA_PUNCH + 28
	db TM01_MEGA_PUNCH + 29
	db TM01_MEGA_PUNCH + 30
	db TM01_MEGA_PUNCH + 31
	db TM01_MEGA_PUNCH + 32
	db TM01_MEGA_PUNCH + 33
	db TM01_MEGA_PUNCH + 34
	db TM01_MEGA_PUNCH + 35
	db TM01_MEGA_PUNCH + 36
	db TM01_MEGA_PUNCH + 37
	db TM01_MEGA_PUNCH + 38
	db TM01_MEGA_PUNCH + 39
	db TM01_MEGA_PUNCH + 40
	db TM01_MEGA_PUNCH + 41
	db TM01_MEGA_PUNCH + 42
	db TM01_MEGA_PUNCH + 43
	db TM01_MEGA_PUNCH + 44
	db TM01_MEGA_PUNCH + 45
	db TM01_MEGA_PUNCH + 46
	db TM01_MEGA_PUNCH + 47
	db TM01_MEGA_PUNCH + 48
	db TM01_MEGA_PUNCH + 49
	; HMs
	db HM01_CUT
	db HM01_CUT + 1
	db HM01_CUT + 2
	db HM01_CUT + 3
	db HM01_CUT + 4
	db $FF ; end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Adapted from pureRGB
; Called from DisplayRepelWoreOffText (home bank 0) when a repel wears off.
; Scans the ACTIVE bag (wBagItems) for REPEL, then SUPER_REPEL, then MAX_REPEL
; (weakest first, like pureRGB) and offers to use one.
; The backup bag space is deliberately NOT searched: it is storage-only and
; RemoveUsedItem consumes from the active bag anyway.
; Do not use IsItemInBag here: joenote's GetQuantityOfItemInBag predef
; also searches the backup bag, which would offer unusable repels.
UseAnotherRepel:
	ld hl, .repelList
.nextRepel
	ld a, [hli]
	ld d, a ; d = repel item ID
	cp $FF
	ret z ; end of the list, no repel in the active bag
; scan the active bag for this repel (b = bag index)
	push hl ; save the position in the repel list
	ld hl, wBagItems
	ld b, $00
.scan
	ld a, [hli] ; a = item ID of the current bag slot
	cp $FF
	jr z, .notInActiveBag ; end of the bag without a match
	cp d
	jr z, .found
	inc hl ; skip the quantity byte
	inc b
	jr .scan
.found
	pop hl ; drop the saved list pointer (balance the stack)
; stash everything in WRAM before PrintText/YesNoChoice clobber the registers
	ld a, d
	ld [wcf91], a ; item ID for UseItem_
	ld [wPokedexNum], a ; item ID for GetItemName
	ld a, b
	ld [wWhichPokemon], a ; bag index for RemoveUsedItem
	ld hl, RepelUseAnotherText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ret nz ; player chose No (or pressed B)
	call GetItemName
	call CopyStringToCF4B ; copy name to wcf4b (wStringBuffer) so it shows in the use text
	call UseItem
	ret
.notInActiveBag
	pop hl
	jr .nextRepel

.repelList
	db REPEL
	db SUPER_REPEL
	db MAX_REPEL
	db $FF ; end

RepelUseAnotherText::
	TX_FAR _RepelUseAnotherText
	db "@"

; Refills the enhanced GBC BGP palettes even when rBGP did not change
; since the last refill (UpdateGBCPal_BGP short-circuits in that case).
; Must be called AFTER wItemIconState got its final value: the
; .ReadMasterPals override in func_enhancedcolor.asm serves the icon
; palette only while an icon session is active.
ForceEnhancedBGPPalRefill:
	ld a, [hGBC]
	and a
	ret z
	ld a, [wGraphicOptions]
	bit BIT_GRAPHIC_ENHANCED_GBC, a
	ret z
	callba UpdateEnhancedGBCPal_BGP
	ret

; Called from PrintListMenuEntries every time a list menu is (re)drawn
InitItemIconState:
	ld a, [wListMenuID]
	cp ITEMLISTMENU
	jr z, .itemList
	cp PRICEDITEMLISTMENU
	jr nz, .notItemList
.itemList
	; never start a session in battle: tile IDs $C0-$C8 are the EXP bar
	; there, and an active session would leak the borrowed palette slot
	; into the battle palettes through the .ReadMasterPals override
	ld a, [wIsInBattle]
	and a
	ret nz
	; hide the overworld sprites: the vanilla sprite update only keeps
	; them behind the list box, but the icon frame sticks out to the
	; left of it and the sprites would draw over the frame and the icon.
	; PrepareOAMData (engine/overworld/oam.asm) rebuilds the whole OAM
	; buffer from the sprite data at every DelayFrame while
	; wUpdateSpritesEnabled is 1, so a one-shot HideSprites on the
	; buffer gets overwritten within a frame. The engine's own way to
	; hide sprites durably (the party menus use it too) is to set
	; wUpdateSpritesEnabled to 0: the next PrepareOAMData then hides
	; all sprites once and leaves the OAM buffer alone afterwards.
	; The flag is set back to 1 when the session ends (EraseItemIcon
	; and the CloseStartMenu hook), so the vanilla UpdateSprites calls
	; on the menu exit paths rebuild the sprites.
	; The PC item box context (BIT_NO_SPRITE_UPDATES) manages its own
	; sprite state: leave the flag alone there.
	ld a, [wMiscFlags]
	bit BIT_NO_SPRITE_UPDATES, a
	jr nz, .skipSpriteHide
	xor a
	ld [wUpdateSpritesEnabled], a
.skipSpriteHide
	; item list or mart stock: start an icon session if none is active yet,
	; or refresh the borrowed palette after a submenu / a leaked session
	ld a, [wItemIconState]
	and a
	jr z, .startSession
	cp $FD ; drawn-but-needs-repair: back from a submenu or a leaked session
	jr z, .refreshIconPal
	ret
.startSession
	ld a, $FE ; active, nothing drawn yet
	ld [wItemIconState], a
.refreshIconPal
	; UpdateGBCPal_BGP only refills the GBC palettes when rBGP changed
	; since the last refill (it compares rBGP with wLastBGP). Opening a
	; list menu usually leaves rBGP unchanged, so the borrowed slot 7
	; would keep the overworld blue until the first BGP change - which is
	; why the icon colors only showed up after the Utiliser/Info/Jeter
	; submenus changed the palette. Force one enhanced refill now: the
	; .ReadMasterPals override then fills slot 7 immediately.
	call ForceEnhancedBGPPalRefill
	ret
.notItemList
	; any other list menu type deactivates the icons; force the refill
	; there too: a session can also end this way without ExitListMenu
	; ever running, and nothing else would put the overworld blue back
	; into the borrowed slot (rBGP did not change)
	ld a, [wItemIconState]
	and a
	ret z ; no session was active: nothing to do
	xor a
	ld [wItemIconState], a
	; a session can also end here without ExitListMenu: restore the
	; sprite flag too (see InitItemIconState), unless the PC item box
	; context is managing its own sprite state
	ld a, [wMiscFlags]
	bit BIT_NO_SPRITE_UPDATES, a
	jr nz, .skipSpriteRestore
	ld a, 1
	ld [wUpdateSpritesEnabled], a
.skipSpriteRestore
	call ForceEnhancedBGPPalRefill
	ret

; Called from ExitListMenu (the list menu is closing)
; The palette must be restored here, not just the state: closing the menu
; does not change rBGP, and UpdateGBCPal_BGP short-circuits when rBGP did
; not change, so no refill would ever put the overworld blue back into the
; borrowed slot - the water would stay recolored until the next palette
; change. Clearing wItemIconState first disables the .ReadMasterPals
; override, then the forced refill serves the overworld blue.
EraseItemIcon:
	ld a, [wItemIconState]
	and a
	ret z			; icons not active
	cp $FE
	jr z, .nothingDrawn ; nothing was drawn at all
	call EraseItemIconBG
.nothingDrawn
	xor a
	ld [wItemIconState], a
	; bring the overworld sprites back: the vanilla UpdateSprites calls
	; on the menu exit paths rebuild the OAM buffer, but only when
	; wUpdateSpritesEnabled is 1 (see InitItemIconState). The PC item
	; box context manages its own sprite state: leave it alone there.
	ld a, [wMiscFlags]
	bit BIT_NO_SPRITE_UPDATES, a
	jr nz, .skipSpriteRestore
	ld a, 1
	ld [wUpdateSpritesEnabled], a
.skipSpriteRestore
	call ForceEnhancedBGPPalRefill
	ret

; Restores the background tiles covered by the framed icon (rows 8-12, columns 0-4)
; rows 8-11 come from the pre-menu screen copy in buffer 2
; row 12 was saved in WRAM when the icon was first drawn
; column 4 overlaps the list menu box's left border and is rebuilt from constants
EraseItemIconBG:
	ld hl, wTileMapBackup2 + 8 * SCREEN_WIDTH
	ld de, wTileMap + 8 * SCREEN_WIDTH
	call .copy4		; row 8, columns 0-3
	ld hl, wTileMapBackup2 + 9 * SCREEN_WIDTH
	ld de, wTileMap + 9 * SCREEN_WIDTH
	call .copy4		; row 9
	ld hl, wTileMapBackup2 + 10 * SCREEN_WIDTH
	ld de, wTileMap + 10 * SCREEN_WIDTH
	call .copy4		; row 10
	ld hl, wTileMapBackup2 + 11 * SCREEN_WIDTH
	ld de, wTileMap + 11 * SCREEN_WIDTH
	call .copy4		; row 11
	ld hl, wItemIconSavedTiles
	ld de, wTileMap + 12 * SCREEN_WIDTH
	call .copy4		; row 12
	ld a, "│"		  ; restore the list menu box's left border at column 4
	ld [wTileMap + 8 * SCREEN_WIDTH + 4], a
	ld [wTileMap + 9 * SCREEN_WIDTH + 4], a
	ld [wTileMap + 10 * SCREEN_WIDTH + 4], a
	ld [wTileMap + 11 * SCREEN_WIDTH + 4], a
	ld a, "└"
	ld [wTileMap + 12 * SCREEN_WIDTH + 4], a
	ret
.copy4
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ret

; Saves the 4 background tiles under the frame's bottom row to WRAM
; Must be called BEFORE the frame is drawn, and only when nothing is drawn
; yet: these tiles are the pre-menu background used to erase the frame on
; menu exit, so they must never capture dialog blanks or the frame itself
SaveItemFrameTiles:
	coord hl, 0, 12
	ld de, wItemIconSavedTiles
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret

; Draws the UI frame around the icon area (rows 8-12, columns 0-4)
; the frame's right column sits on the list menu box's left border column
; and is restored from constants by EraseItemIconBG
DrawItemFrame:
	; top edge
	coord hl, 0, 8
	ld a, "┌"
	ld [hli], a
	ld a, "─"
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, "┐"
	ld [hl], a
	; left edge
	coord hl, 0, 9
	ld a, "│"
	ld [hl], a
	coord hl, 0, 10
	ld [hl], a
	coord hl, 0, 11
	ld [hl], a
	; right edge, over the list menu box's left border
	coord hl, 4, 9
	ld [hl], a
	coord hl, 4, 10
	ld [hl], a
	coord hl, 4, 11
	ld [hl], a
	; bottom edge
	coord hl, 0, 12
	ld a, "└"
	ld [hli], a
	ld a, "─"
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, "┘"
	ld [hl], a
	ret

; Fills the 9 cells inside the frame with blank tiles (the frame itself is kept)
ClearItemIconCells:
	ld a, " "
	coord hl, 1, 9
	ld [hli], a
	ld [hli], a
	ld [hl], a
	coord hl, 1, 10
	ld [hli], a
	ld [hli], a
	ld [hl], a
	coord hl, 1, 11
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

; Called from DisplayListMenuID when the A button is pressed on a list entry
; The frame and icon stay on screen while the banked code runs a submenu
; (Util/Info/Jeter/mart); $FD tells DrawItemIcon to repair them on return
HideItemIcon:
	ld a, [wItemIconState]
	and a
	ret z ; icons not active
	cp $FE
	ret z ; nothing is drawn: nothing to repair
	ld a, $FD ; something is drawn: mark it for repair
	ld [wItemIconState], a
	ret

; Called from PlaceMenuCursor whenever the menu cursor is redrawn
; (list menu cursors only: see the cursor variable checks below)
DrawItemIcon:
	; icons must be active
	ld a, [wItemIconState]
	and a
	ret z
	; never draw in battle: tile IDs $C0-$C8 are used by the EXP bar there
	ld a, [wIsInBattle]
	and a
	ret nz
	; only act when the cursor belongs to an item list menu shown by
	; DisplayListMenuID: it always sets the cursor variables to
	; wTopMenuItemY = 4 and wTopMenuItemX = 5 before showing the list.
	; Submenus opened from the list (the Utiliser/Info/Jeter popup,
	; party menus, Yes/No boxes) reuse the same PlaceMenuCursor and
	; HandleMenuInput machinery with their own cursor coordinates and
	; their own menu indices, and DisplayTextIDInit zeroes wListMenuID
	; for the text they print: without these checks, a popup index would
	; be mistaken for an item index, the icon would change while browsing
	; the popup, and the corrupted state would keep DrawItemIcon from
	; repairing the frame when the list resumes (the popup flow restores
	; the pre-list screen, which erases the frame).
	ld a, [wListMenuID]
	cp ITEMLISTMENU
	jr z, .listCursor
	cp PRICEDITEMLISTMENU
	ret nz
.listCursor
	ld a, [wTopMenuItemY]
	cp 4
	ret nz
	ld a, [wTopMenuItemX]
	cp 5
	ret nz
	; c = index of the highlighted entry within the inventory list
	ld a, [wCurrentMenuItem]
	ld c, a
	ld a, [wListScrollOffset]
	add c
	ld c, a
	; same cancel check as DisplayListMenuID
	ld a, [wListCount]
	and a
	jr z, .emptyFrame ; empty list: the cursor is on Cancel
	dec a
	cp c
	jr c, .emptyFrame ; cursor on Cancel: show an empty frame
.onItem
	; b = item ID of the highlighted entry
	; mart stock lists (PRICEDITEMLISTMENU) have 1-byte entries, other item lists 2
	ld a, [wListMenuID]
	cp PRICEDITEMLISTMENU
	jr z, .gotListEntry
	sla c
.gotListEntry
	ld a, [wListPointer]
	ld l, a
	ld a, [wListPointer + 1]
	ld h, a
	inc hl
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld b, a
	; find the icon pointer in de
	ld a, b
	cp HM01_CUT
	jr nc, .tmhm
	; regular item: read ItemIconPointers[(ID - 1)] in the icon bank
	dec a
	add a
	ld e, a
	ld d, 0
	push bc ; save the item ID (callba clobbers b and hl)
	callba GetItemIconPointer ; de = icon source address
	pop bc
	; no icon for this item (badges, COIN, floors): show an empty frame
	ld a, e
	or d
	jr z, .emptyFrame
	jr .gotIcon
.tmhm
	; all TMs and HMs share a single sprite
	ld de, TMHMIcon
.gotIcon
	; skip the copy if this icon is already on screen and intact
	; (avoids lag on cursor blink); the borrowed palette slot survives
	; every LoadGBPal refill via the .ReadMasterPals override, so there
	; is nothing left to repair while the icon stays on screen
	ld a, [wItemIconState]
	cp b
	ret z
	; first drawing of the session: save the background under the frame,
	; then draw the frame (SaveItemFrameTiles clobbers de)
	cp $FE
	jr nz, .iconNeedsRepair
	push de
	call SaveItemFrameTiles
	call DrawItemFrame
	pop de
	jr .iconDraw
.iconNeedsRepair
	; back from a submenu ($FD): dialogs may have blanked the frame,
	; redraw it before the icon ($FD never collides with an item ID, so the
	; repair happens even if the item under the cursor did not change)
	cp $FD
	jr nz, .iconDraw
	call DrawItemFrame ; preserves de
.iconDraw
	; remember the drawn item before the copy clobbers registers
	ld a, b
	ld [wItemIconState], a
	; load the 9 icon tiles (144 bytes) to vChars1 + $400
	; CopyVideoData lives in the home bank, so the bank switch and the
	; copy run entirely from always-mapped code
	ld hl, vChars1 + $400
	lb bc, BANK(ItemIconPointers), 9
	call CopyVideoData
	; write the tile IDs to the tile map at coordinates (1,9) to (3,11)
	coord hl, 1, 9
	ld a, $C0
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	inc a
	coord hl, 1, 10
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	inc a
	coord hl, 1, 11
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	jp SetItemIconColor ; GBC color: borrow a BGP palette slot for the icon
.emptyFrame
	; cursor on Cancel or item without an icon:
	; keep an empty frame with a blank interior visible while the menu stays open
	ld a, [wItemIconState]
	cp $FF
	ret z ; empty frame already shown and intact
	cp $FE
	jr z, .firstFrame
	cp $FD
	jr z, .redrawFrame
	; an icon is currently shown: blank the cells inside the frame
	call ClearItemIconCells
	ld a, $FF
	ld [wItemIconState], a
	ret
.firstFrame
	call SaveItemFrameTiles
.redrawFrame
	; first frame, or back from a submenu: draw the frame with a blank interior
	call DrawItemFrame
	call ClearItemIconCells
	ld a, $FF
	ld [wItemIconState], a
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GBC color for the item icon (enhanced GBC mode only)
; BGP slot ITEM_ICON_PAL is borrowed for the icon: the palette data is
; redirected at the source (.ReadMasterPals in func_enhancedcolor.asm)
; whenever an icon session is active, so every LoadGBPal refill serves
; the PAL_MEWMON colors and the slot is put back automatically when the
; session ends. This routine only points the 9 icon cells at the slot.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ITEM_ICON_PAL EQU PAL_ENH_OVW_BLUE ; borrowed blue overworld palette slot

; Called at the end of every actual icon draw
SetItemIconColor:
	ld a, 9 ; the bag icon's top row
	; fall through
; Same as SetItemIconColor for an icon area at another vertical position.
; a = top row of the 3x3 icon area (always column 1).
SetItemIconColorAt:
	ld b, a ; b = top row of the icon area
	; only on GBC with the enhanced color option enabled
	ld a, [hGBC]
	and a
	ret z
	ld a, [wGraphicOptions]
	bit BIT_GRAPHIC_ENHANCED_GBC, a
	ret z
	; point the 9 icon cells at the borrowed palette
	; While a text window is open (always the case for list menus), the
	; screen shows the vBGMap1 tile map (the GBC window); the overworld
	; behind uses vBGMap0. OpenText fills the window map attributes with
	; GRAY for every tile ID >= END_OF_OVERWORLD_TILES, icon tiles
	; included, so the attributes must be written to BOTH BG maps or
	; the icon stays gray.
	di ; a VBlank while rVBK is set would corrupt the attribute map
	ld a, 1
	ld [rVBK], a ; VRAM bank 1 = BG map attributes
	; hl = vBGMap0 + b * BG_MAP_WIDTH + 1
	; (16-bit multiply: five add a on the row would only produce the LOW
	; byte and lose the carry for rows >= 8, wrapping the target all the
	; way back to the top of the screen)
	ld l, b
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; hl = top row * 32
	ld de, vBGMap0
	add hl, de
	inc hl
	ld b, 2 ; update vBGMap0 and vBGMap1
.mapLoop
	push hl ; base of the 9 cells in the current BG map
	ld e, ITEM_ICON_PAL
	ld c, 3 ; three rows
.rowLoop
	push bc
	ld c, 3 ; three columns
.colLoop
	ldh a, [rSTAT]
	and %10 ; OAM or VRAM in use?
	jr nz, .colLoop ; if so, wait for the next H-blank/V-blank
	ld a, e
	ld [hli], a
	dec c
	jr nz, .colLoop
	ld bc, BG_MAP_WIDTH - 3
	add hl, bc ; move to the next row
	pop bc
	dec c
	jr nz, .rowLoop
	pop hl
	ld de, vBGMap1 - vBGMap0 ; same 9 cells in the other BG map
	add hl, de
	dec b
	jr nz, .mapLoop
	xor a
	ld [rVBK], a
	ei
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The icon disappears when the dialog
; closes: EraseItemIcon (hooked in CloseTextDisplay) resets the state
; and refills the borrowed palette slot, and LoadCurrentMapView reloads
; the covered tiles.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RECEIVE_ICON_TOP_ROW EQU 7 ; frame's top row
; The coord macro expands to wTileMap + SCREEN_WIDTH * <Y> + <X> with NO
; parentheses around the Y argument: an expression like RECEIVE_ICON_TOP_ROW + 1
; would shift the target sideways on the same row instead of moving it down
; one row. The rows below are precomputed single symbols so that coord's
; multiplication stays correct.
RECEIVE_ICON_ROW1 EQU RECEIVE_ICON_TOP_ROW + 1 ; icon cells' top row
RECEIVE_ICON_ROW2 EQU RECEIVE_ICON_TOP_ROW + 2
RECEIVE_ICON_ROW3 EQU RECEIVE_ICON_TOP_ROW + 3
RECEIVE_ICON_BOTTOM_ROW EQU RECEIVE_ICON_TOP_ROW + 4 ; frame's bottom row

; Called from GiveItem (home bank) right after an item was successfully
; added to the bag. The dialog box is already on screen at that point in
; every give-item flow (NPC scripts, item balls, hidden items, Oak's aide).
DrawReceivedItemIcon:
	; only one icon session at a time (a bag/mart/PC list or a previous
	; receive in the same dialog)
	ld a, [wItemIconState]
	and a
	ret nz
	; never draw in battle: tile IDs $C0-$C8 are the EXP bar there
	ld a, [wIsInBattle]
	and a
	ret nz
	; if the screen at the frame position is not the map view, a menu is
	; covering the area (vending machine menu, game corner prize menu...)
	; and the frame must not be drawn over it. Every map view tile is
	; below $79 (END_OF_OVERWORLD_TILES, see MakeOverworldBGMapAttributes);
	; text, border and blank tiles are all $79 or above.
	ld a, [wTileMap + RECEIVE_ICON_TOP_ROW * SCREEN_WIDTH]
	cp $79
	ret nc
	; b = received item ID, de = its icon (0 if the item has none)
	ld a, [wcf91]
	ld b, a
	cp HM01_CUT
	jr nc, .tmhm
	; regular item: read ItemIconPointers[(ID - 1)] in the icon bank
	dec a
	add a
	ld e, a
	ld d, 0
	push bc ; save the item ID (callba clobbers b and hl)
	callba GetItemIconPointer ; de = icon source address
	pop bc
	; no icon for this item: no session, nothing touched
	ld a, e
	or d
	ret z
	jr .gotIcon
.tmhm
	; all TMs and HMs share a single sprite
	ld de, TMHMIcon
.gotIcon
	; no sprite hiding here: PrepareOAMData (engine/overworld/oam.asm)
	; checks wItemIconState every frame and skips only the sprites that
	; would draw over the frame, so the giving NPC stays visible
	; state = item ID: enables the .ReadMasterPals palette override
	; for the rest of the dialog
	ld a, b
	ld [wItemIconState], a
	; draw the frame above the dialog box
	push de
	call DrawReceiveItemFrame
	pop de
	; load the 9 icon tiles (144 bytes) to vChars1 + $400
	ld hl, vChars1 + $400
	lb bc, BANK(ItemIconPointers), 9
	call CopyVideoData
	; write the tile IDs to the tile map at coordinates (1,8) to (3,10)
	coord hl, 1, RECEIVE_ICON_ROW1
	ld a, $C0
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	inc a
	coord hl, 1, RECEIVE_ICON_ROW2
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	inc a
	coord hl, 1, RECEIVE_ICON_ROW3
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	; GBC color: point the icon cells at the borrowed palette slot, then
	; force one refill so the override serves the icon colors immediately
	; (UpdateGBCPal_BGP short-circuits when rBGP did not change)
	ld a, RECEIVE_ICON_TOP_ROW + 1
	call SetItemIconColorAt
	jp ForceEnhancedBGPPalRefill

; Draws the frame around the received item icon (rows 7-11, columns 0-4)
DrawReceiveItemFrame:
	; top edge
	coord hl, 0, RECEIVE_ICON_TOP_ROW
	ld a, "┌"
	ld [hli], a
	ld a, "─"
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, "┐"
	ld [hl], a
	; left edge
	ld a, "│"
	coord hl, 0, RECEIVE_ICON_ROW1
	ld [hl], a
	coord hl, 0, RECEIVE_ICON_ROW2
	ld [hl], a
	coord hl, 0, RECEIVE_ICON_ROW3
	ld [hl], a
	; right edge
	coord hl, 4, RECEIVE_ICON_ROW1
	ld [hl], a
	coord hl, 4, RECEIVE_ICON_ROW2
	ld [hl], a
	coord hl, 4, RECEIVE_ICON_ROW3
	ld [hl], a
	; bottom edge
	coord hl, 0, RECEIVE_ICON_BOTTOM_ROW
	ld a, "└"
	ld [hli], a
	ld a, "─"
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, "┘"
	ld [hl], a
	ret