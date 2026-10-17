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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Item icons in the inventory list menus (bag, PC item box, mart sell and buy)
; A 24x24 px (3x3 tiles) icon of the item under the cursor is drawn in a small
; UI frame at the bottom-left of the list menu box, at screen coordinates
; (1,9) to (3,11). The frame spans rows 8-12 on columns 0-4 and stays
; visible while the menu is open; its interior is filled with blank tiles
; when the cursor is on Cancel or on an item without an icon.
; The frame and icon also stay visible while a submenu is open
; (Util/Info/Jeter/mart): dialogs may blank them, and state $FD tells
; DrawItemIcon to repair the drawing when the menu resumes.
; Everything is erased on menu exit only (ExitListMenu).
; wItemIconState: 0 = off, $FE = on/nothing drawn, $FF = on/empty frame,
; $FD = on/drawn but needs repair after a submenu,
; $01-$FA = on/icon of that item drawn.
; The icon tiles are loaded to vChars1 + $400 (tile IDs $C0-$C8, right below KeysLogoGraphics).
; The graphics and the ItemIconPointers lookup table live in the icon ROM bank
; (linker-assigned; BANK() is self-consistent).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Called from PrintListMenuEntries every time a list menu is (re)drawn
InitItemIconState:
	ld a, [wListMenuID]
	cp ITEMLISTMENU
	jr z, .itemList
	cp PRICEDITEMLISTMENU
	jr nz, .notItemList
.itemList
	; item list or mart stock: start an icon session if none is active yet
	ld a, [wItemIconState]
	and a
	ret nz
	ld a, $FE ; active, nothing drawn yet
	ld [wItemIconState], a
	ret
.notItemList
	; any other list menu type deactivates the icons
	xor a
	ld [wItemIconState], a
	ret

; Called from ExitListMenu (the list menu is closing)
EraseItemIcon:
	ld a, [wItemIconState]
	and a
	ret z            ; icons not active
	cp $FE
	jr z, .nothingDrawn ; nothing was drawn at all
	call EraseItemIconBG
.nothingDrawn
	xor a
	ld [wItemIconState], a
	ret

; Restores the background tiles covered by the framed icon (rows 8-12, columns 0-4)
; rows 8-11 come from the pre-menu screen copy in buffer 2
; row 12 was saved in WRAM when the icon was first drawn
; column 4 overlaps the list menu box's left border and is rebuilt from constants
EraseItemIconBG:
	ld hl, wTileMapBackup2 + 8 * SCREEN_WIDTH
	ld de, wTileMap + 8 * SCREEN_WIDTH
	call .copy4        ; row 8, columns 0-3
	ld hl, wTileMapBackup2 + 9 * SCREEN_WIDTH
	ld de, wTileMap + 9 * SCREEN_WIDTH
	call .copy4        ; row 9
	ld hl, wTileMapBackup2 + 10 * SCREEN_WIDTH
	ld de, wTileMap + 10 * SCREEN_WIDTH
	call .copy4        ; row 10
	ld hl, wTileMapBackup2 + 11 * SCREEN_WIDTH
	ld de, wTileMap + 11 * SCREEN_WIDTH
	call .copy4        ; row 11
	ld hl, wItemIconSavedTiles
	ld de, wTileMap + 12 * SCREEN_WIDTH
	call .copy4        ; row 12
	ld a, "│"          ; restore the list menu box's left border at column 4
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
DrawItemIcon:
    ; icons must be active
    ld a, [wItemIconState]
    and a
    ret z
    ; never draw in battle: tile IDs $C0-$C8 are used by the EXP bar there
    ld a, [wIsInBattle]
    and a
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
    ; nothing to do if this icon is already on screen and intact
    ; (avoids lag on cursor blink)
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
    ret
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