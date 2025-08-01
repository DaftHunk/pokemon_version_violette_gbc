SpriteFacingAndAnimationTable:
	dw SpriteFacingDownAndStanding, SpriteOAMParameters           ; facing down, walk animation frame 0
	dw SpriteFacingDownAndWalking,  SpriteOAMParameters           ; facing down, walk animation frame 1
	dw SpriteFacingDownAndStanding, SpriteOAMParameters           ; facing down, walk animation frame 2
	dw SpriteFacingDownAndWalking,  SpriteOAMParametersFlipped    ; facing down, walk animation frame 3
	dw SpriteFacingUpAndStanding,   SpriteOAMParameters           ; facing up, walk animation frame 0
	dw SpriteFacingUpAndWalking,    SpriteOAMParameters           ; facing up, walk animation frame 1
	dw SpriteFacingUpAndStanding,   SpriteOAMParameters           ; facing up, walk animation frame 2
	dw SpriteFacingUpAndWalking,    SpriteOAMParametersFlipped    ; facing up, walk animation frame 3
	dw SpriteFacingLeftAndStanding, SpriteOAMParameters           ; facing left, walk animation frame 0
	dw SpriteFacingLeftAndWalking,  SpriteOAMParameters           ; facing left, walk animation frame 1
	dw SpriteFacingLeftAndStanding, SpriteOAMParameters           ; facing left, walk animation frame 2
	dw SpriteFacingLeftAndWalking,  SpriteOAMParameters           ; facing left, walk animation frame 3
	dw SpriteFacingLeftAndStanding, SpriteOAMParametersFlipped    ; facing right, walk animation frame 0
	dw SpriteFacingLeftAndWalking,  SpriteOAMParametersFlipped    ; facing right, walk animation frame 1
	dw SpriteFacingLeftAndStanding, SpriteOAMParametersFlipped    ; facing right, walk animation frame 2
	dw SpriteFacingLeftAndWalking,  SpriteOAMParametersFlipped    ; facing right, walk animation frame 3
	dw SpriteFacingDownAndStanding, SpriteOAMParameters           ; ---
	dw SpriteFacingDownAndStanding, SpriteOAMParameters           ; This table is used for sprites $a and $b.
	dw SpriteFacingDownAndStanding, SpriteOAMParameters           ; All orientation and animation parameters
	dw SpriteFacingDownAndStanding, SpriteOAMParameters           ; lead to the same result. Used for immobile
	dw SpriteFacingDownAndStanding, SpriteOAMParameters           ; sprites like items on the ground
	dw SpriteFacingDownAndStanding, SpriteOAMParameters           ; ---
	dw SpriteFacingDownAndStanding, SpriteOAMParameters
	dw SpriteFacingDownAndStanding, SpriteOAMParameters
	dw SpriteFacingDownAndStanding, SpriteOAMParameters
	dw SpriteFacingDownAndStanding, SpriteOAMParameters
	dw SpriteFacingDownAndStanding, SpriteOAMParameters
	dw SpriteFacingDownAndStanding, SpriteOAMParameters
	dw SpriteFacingDownAndStanding, SpriteOAMParameters
	dw SpriteFacingDownAndStanding, SpriteOAMParameters
	dw SpriteFacingDownAndStanding, SpriteOAMParameters
	dw SpriteFacingDownAndStanding, SpriteOAMParameters
	dw SpriteFacingDownAndStanding, SpriteOAMParameters
	; $20 Oddmons Up/Down Flipped Y-1 Offset
 	dw SpriteFacingDownAndStanding, SpriteOAMParameters           ; facing down, walk animation frame 0
 	dw SpriteFacingDownAndWalking,  SpriteOAMParameters           ; facing down, walk animation frame 1
 	dw SpriteFacingDownAndStanding, SpriteOAMParameters           ; facing down, walk animation frame 2
 	dw SpriteFacingDownAndWalking,  OddmonOAM                     ; facing down, walk animation frame 3
 	dw SpriteFacingUpAndStanding,   SpriteOAMParameters           ; facing up, walk animation frame 0
 	dw SpriteFacingUpAndWalking,    SpriteOAMParameters           ; facing up, walk animation frame 1
 	dw SpriteFacingUpAndStanding,   SpriteOAMParameters           ; facing up, walk animation frame 2
 	dw SpriteFacingUpAndWalking,    OddmonOAM                     ; facing up, walk animation frame 3
 	dw SpriteFacingLeftAndStanding, SpriteOAMParameters           ; facing left, walk animation frame 0
 	dw SpriteFacingLeftAndStanding, SpriteOAMParameters           ; facing left, walk animation frame 1
 	dw SpriteFacingLeftAndStanding, SpriteOAMParameters           ; facing left, walk animation frame 2
 	dw SpriteFacingLeftAndStanding, SpriteOAMParameters           ; facing left, walk animation frame 3
 	dw SpriteFacingLeftAndStanding, SpriteOAMParametersFlipped    ; facing right, walk animation frame 0
 	dw SpriteFacingLeftAndStanding, SpriteOAMParametersFlipped    ; facing right, walk animation frame 1
 	dw SpriteFacingLeftAndStanding, SpriteOAMParametersFlipped    ; facing right, walk animation frame 2
 	dw SpriteFacingLeftAndStanding, SpriteOAMParametersFlipped    ; facing right, walk animation frame 3

SpriteFacingDownAndStanding:
	db $00,$01,$02,$03
SpriteFacingDownAndWalking:
	db $80,$81,$82,$83
SpriteFacingUpAndStanding:
	db $04,$05,$06,$07
SpriteFacingUpAndWalking:
	db $84,$85,$86,$87
SpriteFacingLeftAndStanding:
	db $08,$09,$0a,$0b
SpriteFacingLeftAndWalking:
	db $88,$89,$8a,$8b

SpriteOAMParameters:
	db $00,$00, $00                                      ; top left
	db $00,$08, $00                                      ; top right
	db $08,$00, OAMFLAG_CANBEMASKED                      ; bottom left
	db $08,$08, OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA  ; bottom right
SpriteOAMParametersFlipped:
	db $00,$08, OAMFLAG_VFLIPPED
	db $00,$00, OAMFLAG_VFLIPPED
	db $08,$08, OAMFLAG_VFLIPPED | OAMFLAG_CANBEMASKED
	db $08,$00, OAMFLAG_VFLIPPED | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA

OddmonOAM:
 	; y, x, attributes
 	db $00, $07, OAMFLAG_VFLIPPED ; top left
 	db $00, $FF, OAMFLAG_VFLIPPED ; top right
 	db $08, $07, OAMFLAG_VFLIPPED | OAMFLAG_CANBEMASKED ; bottom left
 	db $08, $FF, OAMFLAG_VFLIPPED | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA ; bottom right
 
 SpecialOAMlist:
 	; see constants/sprite_constants.asm
 	; db SPRITE_CONSTANT, $OAMtable, YPixelOffest, XPixelOffset
	db SPRITE_DOME,			$10, 0, 0
 	db SPRITE_SNORLAX,		$10, 4, 0
 	db SPRITE_BOULDER,		$10, 4, 0
 	db SPRITE_DODUO,		$20, 0, 0
 	db SPRITE_FEAROW,		$20, 0, 0
 	db SPRITE_JIGGLYPUFF,	$20, 0, 0
 	db SPRITE_MACHOKE,		$20, 0, 0
 	db SPRITE_MACHOP,		$20, 0, 0
 	db SPRITE_NIDORANF,		$20, 0, 0
 	db SPRITE_NIDORANM,		$20, 0, 0
 	db SPRITE_PIDGEY,		$20, 0, 0
 	db SPRITE_PIKACHU,		$20, 0, 0
 	db SPRITE_SEEL2,		$20, 0, 0
 	db SPRITE_ZAPDOS,		$20, 0, 0
 	db -1
