ViridianPokeCenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

ViridianPokecenterTextPointers:
	dw ViridianHealNurseText
	dw ViridianPokeCenterText2
	dw ViridianPokeCenterText3
	dw ViridianTradeNurseText
	dw ViridianPokeCenterText5	;joenote - text for added aide

ViridianHealNurseText:
	TX_POKECENTER_NURSE

ViridianPokeCenterText2:
	TX_FAR _ViridianPokeCenterText2
	db "@"

ViridianPokeCenterText3:
	TX_FAR _ViridianPokeCenterText3
	db "@"

ViridianTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST

;;;;;;;;;;;;;;;;;;;;;;;;;joenote - add text for trainer randomization
ViridianPokeCenterText5:
	TX_ASM
	CheckEvent EVENT_ENABLE_NORMAL_TRAINER_RANDOMIZATION
	jr z, .RegRandON
	ld hl, ViridianPokeCenter_RegRandomOFF 
	call PrintText
	call .choose
	ld hl, ViridianPokeCenter_AideQ_reject
	jr z, .end
	ResetEvent EVENT_ENABLE_NORMAL_TRAINER_RANDOMIZATION
	jr .print_done
.RegRandON
	ld hl, ViridianPokeCenter_RegRandomON
	call PrintText
	call .choose
	ld hl, ViridianPokeCenter_AideQ_reject
	jr z, .end
	SetEvent EVENT_ENABLE_NORMAL_TRAINER_RANDOMIZATION
.print_done
	ld hl, ViridianPokeCenter_AideQ_done
.end
	call PrintText
	jp TextScriptEnd
.choose
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	ret

ViridianPokeCenter_RegRandomON:
	TX_FAR _ViridianPokeCenter_RegRandomON
	db "@"
ViridianPokeCenter_RegRandomOFF:
	TX_FAR _ViridianPokeCenter_RegRandomOFF
	db "@"

ViridianPokeCenter_AideQ_done:
	TX_FAR _ViridianPokeCenter_AideQ_done
	db "@"
ViridianPokeCenter_AideQ_reject:
	TX_FAR _ViridianPokeCenter_AideQ_reject
	db "@"