RedsHouse1FScript:
	jp EnableAutoTextBoxDrawing

RedsHouse1FTextPointers:
	dw RedsHouse1FText1
	dw RedsHouse1FText2

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
