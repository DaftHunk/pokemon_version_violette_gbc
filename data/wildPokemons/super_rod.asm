ReadSuperRodData:
	call GetPredefRegisters

;joenote - takes the value in D as an argument
;D = 0 as argument --> super rod functionality
;D = 'mon hex ID as argument --> If the 'mon in D is fishable with the super rod on this map, return D = 0
	
; return e = 2 if no fish on this map
; return e = 1 if a bite, bc = level,species
; return e = 0 if no bite
	ld a, [wCurMap]
	push de
	ld de, 3 ; each fishing group is three bytes wide
	ld hl, SuperRodData
	call IsInArray
	pop de
	jr c, .ReadFishingGroup
	ld e, $2 ; $2 if no fishing groups found
	ret

.ReadFishingGroup
; hl points to the fishing group entry in the index

	;joenote - if wild pokemon are randomized, then don't do the joke dittos
	ld a, [hl]
	cp CERULEAN_CAVE_B1F
	jr nz, .skipmapID
	CheckEvent EVENT_8DE
	jr z, .skipmapID
	inc hl
	inc hl
	inc hl
	
.skipmapID
	inc hl ; skip map id

	; read fishing group address
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld b, [hl] ; how many mons in group
	inc hl ; point to data
	ld e, $0 ; no bite yet

;joenote - added functionality where we can now check of a 'mon in D is in the fishing group.
	ld a, d
	and a
	jr nz, .CheckIfInGroup
	
.RandomLoop
	call Random
	srl a
	ret c ; 50% chance of no battle

	and %11 ; 2-bit random number
	cp b
	jr nc, .RandomLoop ; if a is greater than the number of mons, regenerate

	; get the mon
	add a
	ld c, a
	ld b, $0
	add hl, bc
	ld b, [hl] ; level
	inc hl
	ld c, [hl] ; species
	ld e, $1 ; $1 if there's a bite
	ret

.CheckIfInGroup
	inc hl
	ld a, [hli]
	sub d
	jr z, .found
	dec b
	jr nz, .CheckIfInGroup
	ret
.found
	ld d, a
	ret

; super rod data
; format: map, pointer to fishing group
;joenote - Ditto encounters set in fishing group 2 (route 22 set to group 1)
;		- Super Rod now randomly increases level by 0 to 7
SuperRodData:
	dbw PALLET_TOWN, FishingGroup1
	dbw VIRIDIAN_CITY, FishingGroup1
	dbw CERULEAN_CITY, FishingGroup3
	dbw VERMILION_CITY, FishingGroup4
	dbw CELADON_CITY, FishingGroup5
	dbw FUCHSIA_CITY, FishingGroup10
	dbw CINNABAR_ISLAND, FishingGroup8
	dbw ROUTE_4, FishingGroup3
	dbw ROUTE_6, FishingGroup4
	dbw ROUTE_10, FishingGroup5
	dbw ROUTE_11, FishingGroup4
	dbw ROUTE_12, FishingGroup7
	dbw ROUTE_13, FishingGroup7
	dbw ROUTE_17, FishingGroup7
	dbw ROUTE_18, FishingGroup7
	dbw ROUTE_19, FishingGroup8
	dbw ROUTE_20, FishingGroup8
	dbw ROUTE_21, FishingGroup8
	dbw ROUTE_22, FishingGroup1
	dbw ROUTE_23, FishingGroup9
	dbw ROUTE_24, FishingGroup3
	dbw ROUTE_25, FishingGroup3
	dbw CERULEAN_GYM, FishingGroup3
	dbw VERMILION_DOCK, FishingGroup4
	dbw SEAFOAM_ISLANDS_B3F, FishingGroup8
	dbw SEAFOAM_ISLANDS_B4F, FishingGroup8
	dbw SAFARI_ZONE_EAST, FishingGroup6
	dbw SAFARI_ZONE_NORTH, FishingGroup6
	dbw SAFARI_ZONE_WEST, FishingGroup6
	dbw SAFARI_ZONE_CENTER, FishingGroup6
	dbw CERULEAN_CAVE_2F, FishingGroup9
	dbw CERULEAN_CAVE_B1F, FishingGroup2
	dbw CERULEAN_CAVE_1F, FishingGroup9
	db $FF

SuperRodLabelStart::
; fishing groups
; number of monsters, followed by level/monster pairs
FishingGroup1:
	db 2
	db 15,PSYDUCK
	db 15,POLIWAG

FishingGroup2:
	db 4
	db 120,DITTO
	db 160,DITTO
	db 200,DITTO
	db 240,DITTO
	
FishingGroup3:
	db 3
	db 15,PSYDUCK
	db 15,GOLDEEN
	db 15,KRABBY

FishingGroup4:
	db 2
	db 15,KRABBY
	db 15,SHELLDER

FishingGroup5:
	db 2
	db 23,POLIWHIRL
	db 15,SLOWPOKE

FishingGroup6:
	db 4
	db 15,DRATINI
	db 15,LAPRAS
	db 15,PSYDUCK
	db 15,SLOWPOKE

FishingGroup7:
	db 4
	db 5,TENTACOOL
	db 15,KRABBY
	db 15,GOLDEEN
	db 15,MAGIKARP

FishingGroup8:
	db 4
	db 15,STARYU
	db 15,HORSEA
	db 15,SHELLDER
	db 15,GOLDEEN

FishingGroup9:
	db 4
	db 23,SLOWBRO
	db 23,SEAKING
	db 23,KINGLER
	db 23,SEADRA

FishingGroup10:
	db 4
	db 23,SEAKING
	db 15,KRABBY
	db 15,GOLDEEN
	db 15,MAGIKARP

SuperRodLabelEnd::
