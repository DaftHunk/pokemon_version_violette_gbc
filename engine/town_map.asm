;joenote - Implement the japanese map layout based on Rangi's Red/Blue Star project
DisplayTownMap:
	call LoadTownMap
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl
	ld a, $1
	ld [hJoy7], a
	ld a, [wCurMap]
	push af
	ld b, $0
	call DrawPlayerOrBirdSprite ; player sprite

	coord hl, 1, 0
	ld de, wcd6d
	call PlaceString

	ld hl, wOAMBuffer
	ld de, wTileMapBackup
	ld bc, $10
	call CopyData
	ld hl, vSprites + $40
	ld de, TownMapCursor
	lb bc, BANK(TownMapCursor), (TownMapCursorEnd - TownMapCursor) / $8
	call CopyVideoDataDouble
		
	;joenote - this fixes a minor cursor error when the player is on route 1 or the power plant
	ld a, $01
	ld [wWhichTownMapLocation], a
	ld a, [wCurMap]
	ld hl, TownMapOrder+1
	cp [hl]
	jr z, .townmaplocationset

	ld a, (TownMapOrderEnd-TownMapOrder)-1
	ld [wWhichTownMapLocation], a
	ld a, [wCurMap]
	ld hl, TownMapOrderEnd-1
	cp [hl]
	jr z, .townmaplocationset

	xor a
	ld [wWhichTownMapLocation], a
	
.townmaplocationset
	pop af
	jr .enterLoop

.townMapLoop
	coord hl, 0, 0
	lb bc, 1, 20
	call ClearScreenArea
	ld hl, TownMapOrder
	ld a, [wWhichTownMapLocation]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
.enterLoop
	ld de, wTownMapCoords
	call LoadTownMapEntry
	ld a, [de]
	push hl
	call TownMapCoordsToOAMCoords
	ld a, $4
	ld [wOAMBaseTile], a
	ld hl, wOAMBuffer + $10
	call WriteTownMapSpriteOAM ; town map cursor sprite
	pop hl
	ld de, wcd6d
.copyMapName
	ld a, [hli]
	ld [de], a
	inc de
	cp $50
	jr nz, .copyMapName
	coord hl, 1, 0
	ld de, wcd6d
	call PlaceString

	ld hl, wOAMBuffer + $10
	ld de, wTileMapBackup + 16
	ld bc, $10
	call CopyData
.inputLoop
	call TownMapSpriteBlinkingAnimation
	call JoypadLowSensitivity
	ld a, [hJoy5]
	ld b, a
	and A_BUTTON | B_BUTTON | D_UP | D_DOWN
	jr z, .inputLoop
	ld a, SFX_TINK
	call PlaySound
	bit 6, b
	jr nz, .pressedUp
	bit 7, b
	jr nz, .pressedDown
	xor a
	ld [wTownMapSpriteBlinkingEnabled], a
	ld [hJoy7], a
	ld [wAnimCounter], a
	call ExitTownMap
	pop hl
	pop af
	ld [hl], a
	ret
.pressedUp
	ld a, [wWhichTownMapLocation]
	inc a
	cp TownMapOrderEnd - TownMapOrder ; number of list items + 1
	jr nz, .noOverflow
	xor a
.noOverflow
	ld [wWhichTownMapLocation], a
	jp .townMapLoop
.pressedDown
	ld a, [wWhichTownMapLocation]
	dec a
	cp -1
	jr nz, .noUnderflow
	ld a, TownMapOrderEnd - TownMapOrder - 1 ; number of list items
.noUnderflow
	ld [wWhichTownMapLocation], a
	jp .townMapLoop

INCLUDE "data/maps/town_map_order.asm"

TownMapCursor:
	INCBIN "gfx/tiles/town_map_cursor.1bpp"
TownMapCursorEnd:

LoadTownMap_Nest:
	call LoadTownMap
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl
	call DisplayWildLocations
	call ExitTownMap
	pop hl
	pop af
	ld [hl], a
	ret

MonsNestText:
	db "Nid de @"

LoadTownMap_Fly:
	call ClearSprites
	call LoadTownMap
	call LoadPlayerSpriteGraphics
	call LoadFontTilePatterns
	; use the party icon of the FLY user as the location
	; cursor instead of the generic bird sprite
	call LoadFlyUserIconGfx
	ld de, TownMapUpArrow
	ld hl, vChars1 + $6d0
	lb bc, BANK(TownMapUpArrow), (TownMapUpArrowEnd - TownMapUpArrow) / $8
	call CopyVideoDataDouble
	call BuildFlyLocationsList
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl

	coord hl, 0, 0
	ld de, ToText
	call PlaceString

	ld a, [wCurMap]
	ld b, $0
	call DrawPlayerOrBirdSprite
	ld hl, wFlyLocationsList
	coord de, 18, 0
.townMapFlyLoop
	ld a, " "
	ld [de], a
	push hl
	push hl
	coord hl, 3, 0
	lb bc, 1, 15
	call ClearScreenArea
	pop hl
	ld a, [hl]
	ld b, $4
	call DrawPlayerOrBirdSprite ; draw bird sprite
	coord hl, 3, 0
	ld de, wcd6d
	call PlaceString
;	ld c, 15
;	call DelayFrames
	call Delay3		;joenote - make the fly menu more responsive and snappy
	coord hl, 18, 0
	ld [hl], "▲"
	coord hl, 19, 0
	ld [hl], "▼"
	pop hl
.inputLoop
	push hl
	call DelayFrame
	call JoypadLowSensitivity
	ld a, [hJoy5]
	ld b, a
	pop hl
	and A_BUTTON | B_BUTTON | D_UP | D_DOWN
	jr z, .inputLoop
	bit 0, b
	jr nz, .pressedA
	ld a, SFX_TINK
	call PlaySound
	bit 6, b
	jr nz, .pressedUp
	bit 7, b
	jr nz, .pressedDown
	jr .pressedB
.pressedA
	call WaitForSoundToFinish
	ld a, SFX_HEAL_AILMENT
	call PlaySound
	ld a, [hl]
	ld [wDestinationMap], a
	ld hl, wStatusFlags6
	set 3, [hl]
	inc hl
	set 7, [hl]
.pressedB
	xor a
	ld [wTownMapSpriteBlinkingEnabled], a
	call GBPalWhiteOutWithDelay3
	pop hl
	pop af
	ld [hl], a
	ret
.pressedUp
	coord de, 18, 0
	inc hl
	ld a, [hl]
	cp $ff
	jr z, .wrapToStartOfList
	cp $fe
	jr z, .pressedUp ; skip past unvisited towns
	jp .townMapFlyLoop
.wrapToStartOfList
	ld hl, wFlyLocationsList
	jp .townMapFlyLoop
.pressedDown
	coord de, 19, 0
	dec hl
	ld a, [hl]
	cp $ff
	jr z, .wrapToEndOfList
	cp $fe
	jr z, .pressedDown ; skip past unvisited towns
	jp .townMapFlyLoop
.wrapToEndOfList
	ld hl, wFlyLocationsList + NUM_CITY_MAPS + EXTRA_FLYING_MAPS
	jr .pressedDown

ToText:
	db " →@"

GetFlyUserIconId:
; look up the party icon id of the mon that used FLY (the
; same lookup the party menu does) and stash it in wFlyUserIconId for
; the town map cursor and the fly cutscenes. Must be called while
; wWhichPokemon still points at the FLY user (true on fly menu entry).
	ld a, [wWhichPokemon]
	ld c, a
	ld b, 0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl] ; species of the FLY user
	ld [wcf91], a
	ld [wPokedexNum], a
	predef IndexToPokedex
	ld a, [wPokedexNum]
	dec a
	ld hl, MonPartyData
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl] ; icon id
	ld [wFlyUserIconId], a
	ret

GetFlyUserIconPointer:
; returns hl = address of the FLY user's party icon graphics
; (first frame) and a = its ROM bank
	ld a, [wFlyUserIconId]
	cp $80
	jr c, .useMonIcons
; icon ids >= $80 index the MonIcons2 table
	sub $80
	ld d, a
	ld hl, MonIcons2
	ld a, BANK(MonIcons2)
	jr .gotTable
.useMonIcons
	ld d, a
	ld hl, MonIcons
	ld a, BANK(MonIcons)
.gotTable
	ld e, a
	ld bc, $80 ; each icon is 8 tiles (2 animation frames)
	ld a, d
	call AddNTimes ; hl = icon graphics
	ld a, e ; a = icon bank
	ret

LoadFlyUserIconGfx:
; copy the party icon of the FLY user over the bird cursor
; tiles of the town map fly menu (vSprites + $40), both frames. The
; cursor OAM uses tiles 4-7, i.e. the icon's first frame.
	call GetFlyUserIconId
	call GetFlyUserIconPointer
	ld b, a
	ld c, 8 ; both animation frames
	ld d, h
	ld e, l
	ld hl, vSprites + $40
	jp CopyVideoData

BuildFlyLocationsList:
	ld hl, wFlyAnimUsingCoordList
	ld [hl], $ff
	inc hl ; it's wFlyLocationsList
	ld a, [wTownVisitedFlag]
	ld e, a
	ld a, [wTownVisitedFlag + 1]
	ld d, a
	ld b, 0
	ld c, NUM_CITY_MAPS + EXTRA_FLYING_MAPS
.loop
	srl d
	rr e
	ld a, $fe ; store $fe if the town hasn't been visited
	jr nc, .notVisited
	ld a, b ; store the map number of the town if it has been visited
; new for Route 4 and Route 10
	cp ROUTE_4_FLY
	jr nz, .notRoute4
	ld a, ROUTE_4
.notRoute4
	cp ROUTE_10_FLY
	jr nz, .notRoute10
	ld a, ROUTE_10
; back to vanilla
.notRoute10
.notVisited
	ld [hl], a
	inc hl
	inc b
	dec c
	jr nz, .loop
	ld [hl], $ff
	ret

TownMapUpArrow:
	INCBIN "gfx/tiles/up_arrow.1bpp"
TownMapUpArrowEnd:

LoadTownMap:
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	coord hl, 0, 0
	ld b, $12
	ld c, $12
	call TextBoxBorder
	call DisableLCD
	ld hl, WorldMapTileGraphics
	ld de, vChars2 + $600
	ld bc, WorldMapTileGraphicsEnd - WorldMapTileGraphics
	ld a, BANK(WorldMapTileGraphics)
	call FarCopyData2
	ld hl, MonNestIcon
	ld de, vSprites + $40
	ld bc, MonNestIconEnd - MonNestIcon
	ld a, BANK(MonNestIcon)
	call FarCopyDataDouble
	coord hl, 0, 0
	ld de, CompressedMap
.nextTile
	ld a, [de]
	and a
	jr z, .done
	ld b, a
	and $f
	ld c, a
	ld a, b
	swap a
	and $f
	add $60
.writeRunLoop
	ld [hli], a
	dec c
	jr nz, .writeRunLoop
	inc de
	jr .nextTile
.done
	call EnableLCD
	ld b, SET_PAL_TOWN_MAP
	call RunPaletteCommand
	call Delay3
	call GBPalNormal
	xor a
	ld [wAnimCounter], a
	inc a
	ld [wTownMapSpriteBlinkingEnabled], a
	ret

CompressedMap:
; you can decompress this file with the redrle program in the extras/ dir
	INCBIN "gfx/tilemaps/town_map.rle"

ExitTownMap:
; clear town map graphics data and load usual graphics data
	xor a
	ld [wTownMapSpriteBlinkingEnabled], a
	call GBPalWhiteOut
	call ClearScreen
	call ClearSprites
	call LoadPlayerSpriteGraphics
	call LoadFontTilePatterns
	call UpdateSprites
	jp RunDefaultPaletteCommand

DrawPlayerOrBirdSprite:
; a = map number
; b = OAM base tile
	push af
	ld a, b
	ld [wOAMBaseTile], a
	pop af
	ld de, wTownMapCoords
	call LoadTownMapEntry
	ld a, [de]
	push hl
	call TownMapCoordsToOAMCoords
	call WritePlayerOrBirdSpriteOAM
	pop hl
	ld de, wcd6d
.loop
	ld a, [hli]
	ld [de], a
	inc de
	cp "@"
	jr nz, .loop
	ld hl, wOAMBuffer
	ld de, wTileMapBackup
	ld bc, $a0
	jp CopyData

; PureRGB-style wild mon area menu
; lets the player cycle between land, water, old rod, good rod and super rod areas
STATE_LAND_AREAS EQU 0
STATE_WATER_AREAS EQU 1
STATE_OLD_ROD_AREAS EQU 2
STATE_GOOD_ROD_AREAS EQU 3
STATE_SUPER_ROD_AREAS EQU 4

DisplayWildLocations:
	xor a
	ld [wMonAreaTypeFlags], a

	call GetMonName
	coord hl, 1, 0
	ld de, MonsNestText
	call PlaceString ; leaves bc pointing right after the printed text
	ld h, b
	ld l, c
	ld de, wcd6d
	call PlaceString ; print the mon name right after "Nid de "

; load the area type UI tiles over the unused dynamic font tiles
	ld de, MapAreasUI
	ld hl, vChars1 + $400 ; tiles $C0-$D4
	lb bc, BANK(MapAreasUI), (MapAreasUIEnd - MapAreasUI) / $10
	call CopyVideoData
; load the fishing rod hook and water icons as OAM tiles 5 and 6
	ld de, FishingWaterIcons
	ld hl, vSprites + $50
	lb bc, BANK(FishingWaterIcons), 2
	call CopyVideoDataDouble

	call GetAreaDisplayTypes
	ld a, [wMonAreaTypeFlags]
	and a
	jr z, .unknown ; if it doesn't appear anywhere, don't even look
	ld a, -1
	ld [wTownMapAreaState], a ; before the first state, so we will get the first available one
	call FindNextMonAreaState
	ld a, b
	ld [wTownMapAreaState], a
.doState
	xor a
	ld hl, wOAMBuffer
	ld bc, $90
	call FillMemory ; clear the map icon OAM entries
	call DrawMonAreaButtonPrompt
	ld a, [wTownMapAreaState]
	cp STATE_LAND_AREAS
	jr z, .displayLandState
	cp STATE_WATER_AREAS
	jr z, .displayWaterState
	cp STATE_OLD_ROD_AREAS
	jr z, .displayOldRodState
	cp STATE_GOOD_ROD_AREAS
	jr z, .displayGoodRodState
.displaySuperRodState
	call DisplaySuperRodLocations
	jr .checkForNoLocations
.displayLandState
	call DisplayLandLocations
	jr .checkForNoLocations
.displayWaterState
	call DisplayWaterLocations
	jr .checkForNoLocations
.displayOldRodState
.displayGoodRodState
	call DisplayAnyWaterText
	jr .doneState
.checkForNoLocations
	ld a, l
	and a ; were any OAM entries written?
	jr nz, .drawPlayerSprite
	jr .unknown ; if no OAM entries were written, print area unknown text
.drawPlayerSprite
	ld a, [wCurMap]
	ld b, $0
	call DrawPlayerOrBirdSprite
	jr .doneState
.unknown
	coord hl, 1, 7
	ld b, 2
	ld c, 15
	call TextBoxBorder
	coord hl, 2, 9
	ld de, AreaUnknownText
	call PlaceString
.doneState
	ld hl, wOAMBuffer
	ld de, wTileMapBackup
	ld bc, $a0
	call CopyData
.inputLoop
	call DelayFrame
	call TownMapSpriteBlinkingAnimation
	call JoypadLowSensitivity
	ld a, [hJoy5]
	ld b, a
	and A_BUTTON | B_BUTTON | D_LEFT | D_RIGHT
	jr z, .inputLoop
	bit BIT_A_BUTTON, b
	jr nz, .exit
	bit BIT_B_BUTTON, b
	jr nz, .exit
	bit BIT_D_RIGHT, b
	jr z, .pressedLeft
	call FindNextMonAreaState
	jr z, .inputLoop ; there is no next state available
	jr .loadState
.pressedLeft
	call FindPrevMonAreaState
	jr z, .inputLoop ; there is no previous state available
.loadState
	ld a, b
	ld [wTownMapAreaState], a
	ld a, SFX_TINK
	call PlaySound
	call RedrawWildAreaBase ; redraw the base screen before drawing the new state
	jp .doState
.exit
	ret

; redraws the base town map screen (border, map artwork and title)
; used when switching area types to erase the previous state's info box.
; buffer2 is not used on purpose: the START menu keeps the pre-menu screen
; there and restores it when the pokedex is closed.
RedrawWildAreaBase:
	coord hl, 0, 0
	ld b, $12
	ld c, $12
	call TextBoxBorder
	coord hl, 0, 0
	ld de, CompressedMap
.nextTile
	ld a, [de]
	and a
	jr z, .done
	ld b, a
	and $f
	ld c, a
	ld a, b
	swap a
	and $f
	add $60
.writeRunLoop
	ld [hli], a
	dec c
	jr nz, .writeRunLoop
	inc de
	jr .nextTile
.done
	call GetMonName
	coord hl, 1, 0
	ld de, MonsNestText
	call PlaceString ; leaves bc pointing right after the printed text
	ld h, b
	ld l, c
	ld de, wcd6d
	call PlaceString ; print the mon name right after "Nid de "
	ret

GetAreaDisplayTypes:
; sets the bits in wMonAreaTypeFlags for every kind of location
; where the mon in [wPokedexNum] can be found
	callba CheckHasLandWaterLocations
	callba CheckHasRodLocations
	callba FindSuperRodLocationsOfMon ; also fills wTownMapCoords with the super rod map list
	ld a, [wTownMapCoords]
	cp $ff
	ret z ; there are no super rod locations
	ld a, [wMonAreaTypeFlags]
	set BIT_HAS_SUPER_ROD_LOCATIONS, a
	ld [wMonAreaTypeFlags], a
	ret

; output b = next state, z flag indicates if there is one available or not
FindNextMonAreaState:
	ld a, [wTownMapAreaState]
	ld b, a
.loopNext
	inc b
	ld a, b
	cp STATE_SUPER_ROD_AREAS + 1
	ret z
	call HasAreaState
	ret nz
	jr .loopNext

; output b = previous state, z flag indicates if there is one available or not
FindPrevMonAreaState:
	ld a, [wTownMapAreaState]
	ld b, a
.loopPrev
	dec b
	ld a, b
	cp -1
	ret z
	call HasAreaState
	ret nz
	jr .loopPrev

; b = which state to check if it is available
HasAreaState:
	ld a, b
	cp STATE_LAND_AREAS
	jr z, .landState
	cp STATE_WATER_AREAS
	jr z, .waterState
	cp STATE_OLD_ROD_AREAS
	jr z, .oldRodState
	cp STATE_GOOD_ROD_AREAS
	jr z, .goodRodState
.superRodState
	ld a, [wMonAreaTypeFlags]
	bit BIT_HAS_SUPER_ROD_LOCATIONS, a
	ret
.landState
	ld a, [wMonAreaTypeFlags]
	bit BIT_HAS_LAND_LOCATIONS, a
	ret
.waterState
	ld a, [wMonAreaTypeFlags]
	bit BIT_HAS_WATER_LOCATIONS, a
	ret
.oldRodState
	ld a, [wMonAreaTypeFlags]
	bit BIT_HAS_OLD_ROD_LOCATIONS, a
	ret
.goodRodState
	ld a, [wMonAreaTypeFlags]
	bit BIT_HAS_GOOD_ROD_LOCATIONS, a
	ret

DrawMonAreaButtonPrompt:
	ld a, [wTownMapAreaState]
	cp STATE_LAND_AREAS
	jr z, .landState
	cp STATE_WATER_AREAS
	jr z, .waterState
	cp STATE_OLD_ROD_AREAS
	jr z, .oldRodState
	cp STATE_GOOD_ROD_AREAS
	jr z, .goodRodState
.superRodState
	coord hl, 13, 17
	ld a, $CB
	ld b, 3
	call DrawPrompt
	coord hl, 16, 17
	ld a, $CE
	ld b, 3
	call DrawPrompt
	coord hl, 12, 17
	jr .drawArrows
.landState
	coord hl, 11, 17
	ld a, $C0
	ld b, 8
	call DrawPrompt
	jr .drawArrows
.waterState
	coord hl, 17, 17
	ld a, $D3
	ld b, 2
	call DrawPrompt
	coord hl, 16, 17
	jr .drawArrows
.oldRodState
	coord hl, 16, 17
	ld a, $CE
	ld b, 3
	call DrawPrompt
	coord hl, 15, 17
	jr .drawArrows
.goodRodState
	coord hl, 13, 17
	ld a, $C8
	ld b, 3
	call DrawPrompt
	coord hl, 16, 17
	ld a, $CE
	ld b, 3
	call DrawPrompt
	coord hl, 12, 17
.drawArrows ; assumes hl points at the location the left arrow should be at (if there needs to be one)
	call FindPrevMonAreaState
	jr z, .nextArrow
	ld [hl], $D1
.nextArrow
	call FindNextMonAreaState
	ret z
	coord hl, 19, 17
	ld [hl], $D2 ; right prompt
	ret

; draw a prompt of b tiles starting with tile a at coord hl
DrawPrompt:
.loop
	ld [hli], a
	inc a
	dec b
	jr nz, .loop
	ret

DisplayLandLocations:
	callba FindLandLocationsOfMon
	ld a, $4 ; nest icon tile no.
	jp LoadMapIcons

DisplayWaterLocations:
	callba FindWaterLocationsOfMon
	ld a, $6 ; water icon tile no.
	jp LoadMapIcons

DisplaySuperRodLocations:
	callba FindSuperRodLocationsOfMon
	ld a, $5 ; fishing rod hook icon tile no.
	; fall through to LoadMapIcons

LoadMapIcons:
; a = OAM tile to draw the location icons with
; draws an OAM icon for every map in the wTownMapCoords list
; returns l = 0 if no icons were drawn
	push af
	ld hl, wOAMBuffer
	ld de, wTownMapCoords
.loop
	ld a, [de]
	cp $ff ; indicates end of list
	jr z, .exitLoop
	push hl
	call LoadTownMapEntry
	pop hl
	ld a, [de]
	cp $19 ; Cerulean Cave's coordinates
	jr z, .nextEntry ; skip Cerulean Cave
	call TownMapCoordsToOAMCoords

; the above function was modified to not write to [hl], so write to ShadowOAM here.
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	pop af ; get icon tile to display
	push af
	ld [hli], a
	xor a
	ld [hli], a
.nextEntry
	inc de
	jr .loop
.exitLoop
	pop af
	ret

DisplayAnyWaterText:
; the old rod and good rod encounter lists are global,
; so just tell the player that any water works
	coord hl, 2, 7
	ld b, 2
	ld c, 14
	call TextBoxBorder
	coord hl, 4, 9
	ld de, AnyWaterText
	call PlaceString
	ret

AnyWaterText:
	db "N'importe où@"

AreaUnknownText:
	db " Zone Inconnue@"

TownMapCoordsToOAMCoords:
; in: lower nybble of a = x, upper nybble of a = y
; out: b and [hl] = (y * 8) + 24, c and [hl+1] = (x * 8) + 24
;joenote - revising output to not write to [hl] & [hl+1] since this causes a write to ROM under certain calls
	push af
	and $f0
	srl a
	add 24
	ld b, a
;	ld [hli], a
	pop af
	and $f
	swap a
	srl a
	add 24
	ld c, a
;	ld [hli], a
	ret

WritePlayerOrBirdSpriteOAM:
	ld a, [wOAMBaseTile]
	and a
	ld hl, wOAMBuffer + $90 ; for player sprite
	jr z, WriteTownMapSpriteOAM
	ld hl, wOAMBuffer + $80 ; for bird sprite

WriteTownMapSpriteOAM:
	push hl

; Subtract 4 from c (X coord) and 4 from b (Y coord). However, the carry from c
; is added to b, so the net result is that only 3 is subtracted from b.
	lb hl, -4, -4
	add hl, bc

	ld b, h
	ld c, l
	pop hl

WriteAsymmetricMonPartySpriteOAM:
; Writes 4 OAM blocks for a helix mon party sprite, since it does not have
; a vertical line of symmetry.
	lb de, 2, 2
.loop
	push de
	push bc
.innerLoop
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, [wOAMBaseTile]
	ld [hli], a
	inc a
	ld [wOAMBaseTile], a
	xor a
	ld [hli], a
	inc d
	ld a, 8
	add c
	ld c, a
	dec e
	jr nz, .innerLoop
	pop bc
	pop de
	ld a, 8
	add b
	ld b, a
	dec d
	jr nz, .loop
	ret

WriteSymmetricMonPartySpriteOAM:
; Writes 4 OAM blocks for a mon party sprite other than a helix. All the
; sprites other than the helix one have a vertical line of symmetry which allows
; the X-flip OAM bit to be used so that only 2 rather than 4 tile patterns are
; needed.
	xor a
	ld [wSymmetricSpriteOAMAttributes], a
	lb de, 2, 2
.loop
	push de
	push bc
.innerLoop
	ld a, b
	ld [hli], a ; Y
	ld a, c
	ld [hli], a ; X
	ld a, [wOAMBaseTile]
	ld [hli], a ; tile
	ld a, [wSymmetricSpriteOAMAttributes]
	ld [hli], a ; attributes
	xor (1 << OAM_X_FLIP)
	ld [wSymmetricSpriteOAMAttributes], a
	inc d
	ld a, 8
	add c
	ld c, a
	dec e
	jr nz, .innerLoop
	pop bc
	pop de
	push hl
	ld hl, wOAMBaseTile
	inc [hl]
	inc [hl]
	pop hl
	ld a, 8
	add b
	ld b, a
	dec d
	jr nz, .loop
	ret

ZeroOutDuplicatesInList:
; replace duplicate bytes in the list of wild pokemon locations with 0
	ld de, wBuffer
.loop
	ld a, [de]
	inc de
	cp $ff
	ret z
	ld c, a
	ld l, e
	ld h, d
.zeroDuplicatesLoop
	ld a, [hl]
	cp $ff
	jr z, .loop
	cp c
	jr nz, .skipZeroing
	xor a
	ld [hl], a
.skipZeroing
	inc hl
	jr .zeroDuplicatesLoop
	
RemoveDuplicatesInList:
;joenote - like ZeroOutDuplicatesInList, but removes duplicate entries entirely
	ld hl, wBuffer
.loop
	ld a, [hli]
	cp $ff
	ret z
	ld c, a
	ld a, [hld]
	cp c
	jr nz, .skipRemoving
	push hl
	call RemoveEntryInList
	pop hl
	jr .loop
.skipRemoving
	inc hl
	jr .loop

;joenote - this removes the first entry in a list that begins at address HL+0 and terminates the list with a FF value
;All the entries in the list are shifted towards the removed entry and FF is backfilled
RemoveEntryInList:
	inc hl
	ld a, [hld]
	ld [hli], a
	cp $ff
	jr nz, RemoveEntryInList
	ret
	


LoadTownMapEntryFromD:	;joenote - for more versatility, like with using callba
	ld a, d
	ld de, wTownMapCoords
	call LoadTownMapEntry
	ld a, [de]
	ld d, a
	ret
LoadTownMapEntry:
; in: a = map number
; out: lower nybble of [de] = x, upper nybble of [de] = y, hl = address of name
	cp PALLET_REDS_HOUSE_1F
	jr c, .external
	ld bc, 4
	ld hl, InternalMapEntries
.loop
	cp [hl]
	jr c, .foundEntry
	add hl, bc
	jr .loop
.foundEntry
	inc hl
	jr .readEntry
.external
	ld hl, ExternalMapEntries
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	add hl, bc
.readEntry
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

GetMapName::
	ld a, e
	ld de, wEnemyMonNick ; LoadTownMapEntry write in [de].
	; To avoid any issues that could arise from a random write in a random place 
	; we point DE at an armless address that we are going to overwrite anyway.
	call LoadTownMapEntry
	ld de, wEnemyMonNick
	ld bc, 20
	call CopyData
	ret

INCLUDE "data/maps/town_map_entries.asm"
INCLUDE "text/map_names.asm"

MonNestIcon:
	INCBIN "gfx/tiles/mon_nest_icon.1bpp"
MonNestIconEnd:

TownMapSpriteBlinkingAnimation:
	ld a, [wAnimCounter]
	inc a
	cp 25
	jr z, .hideSprites
	cp 50
	jr nz, .done
; show sprites when the counter reaches 50
	ld hl, wTileMapBackup
	ld de, wOAMBuffer
	ld bc, $90
	call CopyData
	xor a
	jr .done
.hideSprites
	ld hl, wOAMBuffer
	ld b, $24
	ld de, $4
.hideSpritesLoop
	ld [hl], $a0
	add hl, de
	dec b
	jr nz, .hideSpritesLoop
	ld a, 25
.done
	ld [wAnimCounter], a
	jp DelayFrame
