; Credit item icons : Polished Crystal
; Item icons for the inventory list menus (bag, PC item box, mart sell)
; each sprite is 24x24 px = 9 tiles of 16 bytes = 144 bytes in 2bpp
; items with identical sprites share a single INCBIN to save ROM space
ItemIcons:: ; anchor label: gives the ROM bank to CopyVideoData
	MasterBallIcon:    INCBIN "gfx/items/master_ball.2bpp"
	UltraBallIcon:     INCBIN "gfx/items/ultra_ball.2bpp"
	GreatBallIcon:     INCBIN "gfx/items/great_ball.2bpp"
	PokeBallIcon:      INCBIN "gfx/items/poke_ball.2bpp"
	TownMapIcon:       INCBIN "gfx/items/townmap.2bpp"
	BicycleIcon:       INCBIN "gfx/items/bicycle.2bpp"
	SurfboardIcon:     INCBIN "gfx/items/surfboard.2bpp"
	SafariBallIcon:    INCBIN "gfx/items/safari_ball.2bpp"
	PokedexIcon:       INCBIN "gfx/items/pokedex.2bpp"
	MoonStoneIcon:     INCBIN "gfx/items/moon_stone.2bpp"
	StatusHealIcon:    INCBIN "gfx/items/antidote.2bpp"     ; shared: ANTIDOTE, BURN_HEAL, ICE_HEAL, AWAKENING, PARLYZ_HEAL
	FullRestoreIcon:   INCBIN "gfx/items/full_restore.2bpp" ; shared: FULL_RESTORE, FULL_HEAL
	HyperPotionIcon:   INCBIN "gfx/items/hyper_potion.2bpp" ; shared: HYPER_POTION, MAX_POTION
	PotionIcon:        INCBIN "gfx/items/potion.2bpp"       ; shared: SUPER_POTION, POTION
	EscapeRopeIcon:    INCBIN "gfx/items/escape_rope.2bpp"
	RepelIcon:         INCBIN "gfx/items/repel.2bpp"         ; shared: REPEL, SUPER_REPEL, MAX_REPEL
	OldAmberIcon:      INCBIN "gfx/items/old_amber.2bpp"
	FireStoneIcon:     INCBIN "gfx/items/fire_stone.2bpp"
	ThunderStoneIcon:  INCBIN "gfx/items/thunder_stone.2bpp"
	WaterStoneIcon:    INCBIN "gfx/items/water_stone.2bpp"
	HpUpIcon:          INCBIN "gfx/items/hp_up.2bpp"
	VitaminIcon:       INCBIN "gfx/items/protein.2bpp"       ; shared: PROTEIN, IRON, CARBOS, CALCIUM
	RareCandyIcon:     INCBIN "gfx/items/rare_candy.2bpp"
	DomeFossilIcon:    INCBIN "gfx/items/dome_fossil.2bpp"
	HelixFossilIcon:   INCBIN "gfx/items/helix_fossil.2bpp"
	SecretKeyIcon:     INCBIN "gfx/items/secret_key.2bpp"
	AdnIcon:           INCBIN "gfx/items/berserk_adn.2bpp"   ; shared: BERSERK_ADN, M_GENE
	BikeVoucherIcon:   INCBIN "gfx/items/bike_voucher.2bpp"
	XItemIcon:         INCBIN "gfx/items/x_attack.2bpp"       ; shared: X_ACCURACY, GUARD_SPEC, DIRE_HIT, X_ATTACK, X_DEFEND, X_SPEED, X_SPECIAL
	LeafStoneIcon:     INCBIN "gfx/items/leaf_stone.2bpp"
	CardKeyIcon:       INCBIN "gfx/items/card_key.2bpp"
	NuggetIcon:        INCBIN "gfx/items/nugget.2bpp"
	PokeDollIcon:      INCBIN "gfx/items/poke_doll.2bpp"
	ReviveIcon:        INCBIN "gfx/items/revive.2bpp"
	MaxReviveIcon:     INCBIN "gfx/items/max_revive.2bpp"
	FreshWaterIcon:    INCBIN "gfx/items/fresh_water.2bpp"
	SodaPopIcon:       INCBIN "gfx/items/soda_pop.2bpp"
	LemonadeIcon:      INCBIN "gfx/items/lemonade.2bpp"
	SSTicketIcon:      INCBIN "gfx/items/s_s_ticket.2bpp"
	GoldTeethIcon:     INCBIN "gfx/items/gold_teeth.2bpp"
	CoinCaseIcon:      INCBIN "gfx/items/coin_case.2bpp"
	OaksParcelIcon:    INCBIN "gfx/items/oaks_parcel.2bpp"
	ItemfinderIcon:    INCBIN "gfx/items/itemfinder.2bpp"
	SilphScopeIcon:    INCBIN "gfx/items/silph_scope.2bpp"
	PokefluteIcon:     INCBIN "gfx/items/poke_flute.2bpp"
	LiftKeyIcon:       INCBIN "gfx/items/lift_key.2bpp"
	ExpAllIcon:        INCBIN "gfx/items/exp_all.2bpp"
	OldRodIcon:        INCBIN "gfx/items/old_rod.2bpp"
	GoodRodIcon:       INCBIN "gfx/items/good_rod.2bpp"
	SuperRodIcon:      INCBIN "gfx/items/super_rod.2bpp"
	PPUpIcon:          INCBIN "gfx/items/pp_up.2bpp"
	EtherIcon:         INCBIN "gfx/items/ether.2bpp"         ; shared: ETHER, MAX_ETHER, ELIXER, MAX_ELIXER
	MetalCoatIcon:     INCBIN "gfx/items/metal_coat.2bpp"
	ExpCatchUpIcon:    INCBIN "gfx/items/exp_catch_up.2bpp"
	SoulStoneIcon:     INCBIN "gfx/items/soul_stone.2bpp"
	MistStoneIcon:     INCBIN "gfx/items/mist_stone.2bpp"
	TMHMIcon:          INCBIN "gfx/items/tm_hm.2bpp"          ; shared by every TM/HM
	
; one pointer per item ID ($01-$65), indexed by (item ID - 1) * 2
; 0 = no icon (badges, COIN, elevator floors); TMs/HMs ($C4	) are handled in code
ItemIconPointers::
    dw MasterBallIcon     ; $01 MASTER_BALL
    dw UltraBallIcon      ; $02 ULTRA_BALL
    dw GreatBallIcon      ; $03 GREAT_BALL
    dw PokeBallIcon       ; $04 POKE_BALL
    dw 0                  ; $05 TOWN_MAP (no icon)
    dw BicycleIcon        ; $06 BICYCLE
    dw SurfboardIcon      ; $07 SURFBOARD
    dw 0                  ; $08 SAFARI_BALL (no icon)
    dw 0                  ; $09 POKEDEX (no icon)
    dw MoonStoneIcon      ; $0A MOON_STONE
    dw StatusHealIcon     ; $0B ANTIDOTE
    dw StatusHealIcon     ; $0C BURN_HEAL
    dw StatusHealIcon     ; $0D ICE_HEAL
    dw StatusHealIcon     ; $0E AWAKENING
    dw StatusHealIcon     ; $0F PARLYZ_HEAL
    dw FullRestoreIcon    ; $10 FULL_RESTORE
    dw HyperPotionIcon    ; $11 MAX_POTION
    dw HyperPotionIcon    ; $12 HYPER_POTION
    dw PotionIcon         ; $13 SUPER_POTION
    dw PotionIcon         ; $14 POTION
    dw 0                  ; $15 BOULDERBADGE (no icon)
    dw 0                  ; $16 CASCADEBADGE (no icon)
    dw 0                  ; $17 THUNDERBADGE (no icon)
    dw 0                  ; $18 RAINBOWBADGE (no icon)
    dw 0                  ; $19 SOULBADGE (no icon)
    dw 0                  ; $1A MARSHBADGE (no icon)
    dw 0                  ; $1B VOLCANOBADGE (no icon)
    dw 0                  ; $1C EARTHBADGE (no icon)
    dw EscapeRopeIcon     ; $1D ESCAPE_ROPE
    dw RepelIcon          ; $1E REPEL
    dw OldAmberIcon       ; $1F OLD_AMBER
    dw FireStoneIcon      ; $20 FIRE_STONE
    dw ThunderStoneIcon   ; $21 THUNDER_STONE
    dw WaterStoneIcon     ; $22 WATER_STONE
    dw HpUpIcon           ; $23 HP_UP
    dw VitaminIcon        ; $24 PROTEIN
    dw VitaminIcon        ; $25 IRON
    dw VitaminIcon        ; $26 CARBOS
    dw VitaminIcon        ; $27 CALCIUM
    dw RareCandyIcon      ; $28 RARE_CANDY
    dw DomeFossilIcon     ; $29 DOME_FOSSIL
    dw HelixFossilIcon    ; $2A HELIX_FOSSIL
    dw SecretKeyIcon      ; $2B SECRET_KEY
    dw AdnIcon            ; $2C BERSERK_ADN
    dw BikeVoucherIcon    ; $2D BIKE_VOUCHER
    dw XItemIcon          ; $2E X_ACCURACY
    dw LeafStoneIcon      ; $2F LEAF_STONE
    dw CardKeyIcon        ; $30 CARD_KEY
    dw NuggetIcon         ; $31 NUGGET
    dw AdnIcon            ; $32 M_GENE
    dw PokeDollIcon       ; $33 POKE_DOLL
    dw FullRestoreIcon    ; $34 FULL_HEAL
    dw ReviveIcon         ; $35 REVIVE
    dw MaxReviveIcon      ; $36 MAX_REVIVE
    dw XItemIcon          ; $37 GUARD_SPEC
    dw RepelIcon          ; $38 SUPER_REPEL
    dw RepelIcon          ; $39 MAX_REPEL
    dw XItemIcon          ; $3A DIRE_HIT
    dw 0                  ; $3B COIN (no icon)
    dw FreshWaterIcon     ; $3C FRESH_WATER
    dw SodaPopIcon        ; $3D SODA_POP
    dw LemonadeIcon       ; $3E LEMONADE
    dw SSTicketIcon       ; $3F S_S_TICKET
    dw GoldTeethIcon      ; $40 GOLD_TEETH
    dw XItemIcon          ; $41 X_ATTACK
    dw XItemIcon          ; $42 X_DEFEND
    dw XItemIcon          ; $43 X_SPEED
    dw XItemIcon          ; $44 X_SPECIAL
    dw CoinCaseIcon       ; $45 COIN_CASE
    dw OaksParcelIcon     ; $46 OAKS_PARCEL
    dw ItemfinderIcon     ; $47 ITEMFINDER
    dw SilphScopeIcon     ; $48 SILPH_SCOPE
    dw PokefluteIcon      ; $49 POKE_FLUTE
    dw LiftKeyIcon        ; $4A LIFT_KEY
    dw ExpAllIcon         ; $4B EXP_ALL
    dw OldRodIcon         ; $4C OLD_ROD
    dw GoodRodIcon        ; $4D GOOD_ROD
    dw SuperRodIcon       ; $4E SUPER_ROD
    dw PPUpIcon           ; $4F PP_UP
    dw EtherIcon          ; $50 ETHER
    dw EtherIcon          ; $51 MAX_ETHER
    dw EtherIcon          ; $52 ELIXER
    dw EtherIcon          ; $53 MAX_ELIXER
    dw 0                  ; $54 FLOOR_B2F (no icon)
    dw 0                  ; $55 FLOOR_B1F (no icon)
    dw 0                  ; $56 FLOOR_1F (no icon)
    dw 0                  ; $57 FLOOR_2F (no icon)
    dw 0                  ; $58 FLOOR_3F (no icon)
    dw 0                  ; $59 FLOOR_4F (no icon)
    dw 0                  ; $5A FLOOR_5F (no icon)
    dw 0                  ; $5B FLOOR_6F (no icon)
    dw 0                  ; $5C FLOOR_7F (no icon)
    dw 0                  ; $5D FLOOR_8F (no icon)
    dw 0                  ; $5E FLOOR_9F (no icon)
    dw 0                  ; $5F FLOOR_10F (no icon)
    dw 0                  ; $60 FLOOR_11F (no icon)
    dw 0                  ; $61 FLOOR_B4F (no icon)
    dw MetalCoatIcon      ; $62 METAL_COAT
    dw ExpCatchUpIcon     ; $63 EXP_CATCH_UP
    dw SoulStoneIcon      ; $64 SOUL_STONE
    dw MistStoneIcon      ; $65 MIST_STONE

GetItemIconPointer::
; input: de = byte offset within ItemIconPointers
; output: de = address of the item icon graphics
	ld hl, ItemIconPointers
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ret