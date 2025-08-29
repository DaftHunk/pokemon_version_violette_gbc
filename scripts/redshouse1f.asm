RedsHouse1FScript:
	call EnableAutoTextBoxDrawing
	jp RedsHouse1FMomAskForShoes

RedsHouse1FMomAskForShoes:
	; skip if already played
	CheckEvent EVENT_MOM_ASK_SHOES
	ret nz
	; Check for Y area
	ld a, [wYCoord]
	cp $6
	jr z, .next
	cp $7
	jr z, .next
	; If not here return
	ret
.next
	; Check for X coords
	ld a, [wXCoord]
	cp $2
	jr z, .displayText
	cp $3
	jr z, .displayText
	; If not here return
	ret
.displayText
	; player faces mom
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	; mom faces player
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_DOWN
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	; display text
	ld a, $3
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	; Reset current input
	xor a
	ld [hJoyHeld], a
	; set event to not play again
	SetEvent EVENT_MOM_ASK_SHOES
	ret

RedsHouse1FTextPointers:
	dw RedsHouse1FText1
	dw RedsHouse1FText2
	dw RedsHouse1FText_RunningShoes

RedsHouse1FText1: ; Mom
	TX_ASM
	ld a, [wd72e]
	bit 3, a
	jr nz, .heal ; if player has received a Pokémon from Oak, heal team
	ld hl, MomWakeUpText
	call PrintText
	jr .done
.heal
	call MomHealPokemon
.done
	jp TextScriptEnd

MomWakeUpText:
	TX_FAR _MomWakeUpText
	db "@"

MomHealPokemon:
	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .afterElite4
	; else
	ld hl, .beforeElite4Text
	jp .done
.beforeElite4Text
	TX_FAR _MomHealText1
	db "@"
.afterElite4
	ld hl, .afterElite4Text
	jp .done
.afterElite4Text
	TX_FAR _MomHealText1AfterElite4
	db "@"
.done
	call PrintText
	call GBFadeOutToWhite
	call ReloadMapData
	predef HealParty

	ld c, BANK(Music_RestPallet)
	ld a, MUSIC_REST_PALLET
	call PlayMusic

	ld c, $AA
	call DelayFrames

	call GBFadeInFromWhite
	call PlayDefaultMusic

	ld hl, MomHealText2
	jp PrintText

MomHealText2:
	TX_FAR _MomHealText2
	db "@"

RedsHouse1FText2: ; TV
	TX_ASM
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP
	ld hl, TVWrongSideText
	jr nz, .notUp
	ld hl, StandByMeText
.notUp
	call PrintText
	jp TextScriptEnd

StandByMeText:
	TX_FAR _StandByMeText
	db "@"

TVWrongSideText:
	TX_FAR _TVWrongSideText
	db "@"

RedsHouse1FText_RunningShoes:
	TX_FAR _RedsHouse1FText_RunningShoes
	db "@"
