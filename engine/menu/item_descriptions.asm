DisplayItemDescription::
	ld a, [wcf91]
	dec a
	cp a, HM01_CUT - 1
	jr c, .ok
	sub HM01_CUT - METAL_COAT - 1 ;dafthunk Always put last item here
.ok
	ld hl, ItemDescriptionPointers
	ld bc, 5
	call AddNTimes
	jp PrintText

ItemDescriptionPointers:
	TX_FAR _MasterBallDescription
	text_end
	TX_FAR _UltraBallDescription
	text_end
	TX_FAR _GreatBallDescription
	text_end
	TX_FAR _PokeBallDescription
	text_end
	TX_FAR _TownMapDescription
	text_end
	TX_FAR _BicycleDescription
	text_end
	TX_FAR _UnusedItemDescription
	text_end
	TX_FAR _UnusedItemDescription
	text_end
	TX_FAR _UnusedItemDescription
	text_end
	TX_FAR _MoonStoneDescription
	text_end
	TX_FAR _AntidoteDescription
	text_end
	TX_FAR _BurnHealDescription
	text_end
	TX_FAR _IceHealDescription
	text_end
	TX_FAR _AwakeningDescription
	text_end
	TX_FAR _ParlyzHealDescription
	text_end
	TX_FAR _FullRestoreDescription
	text_end
	TX_FAR _MaxPotionDescription
	text_end
	TX_FAR _HyperPotionDescription
	text_end
	TX_FAR _SuperPotionDescription
	text_end
	TX_FAR _PotionDescription
	text_end
	TX_FAR _UnusedItemDescription
	text_end
	TX_FAR _UnusedItemDescription
	text_end
	TX_FAR _UnusedItemDescription
	text_end
	TX_FAR _UnusedItemDescription
	text_end
	TX_FAR _UnusedItemDescription
	text_end
	TX_FAR _UnusedItemDescription
	text_end
	TX_FAR _UnusedItemDescription
	text_end
	TX_FAR _UnusedItemDescription
	text_end
	TX_FAR _EscapeRopeDescription
	text_end
	TX_FAR _RepelDescription
	text_end
	TX_FAR _OldAmberDescription
	text_end
	TX_FAR _FireStoneDescription
	text_end
	TX_FAR _ThunderStoneDescription
	text_end
	TX_FAR _WaterStoneDescription
	text_end
	TX_FAR _HPUpDescription
	text_end
	TX_FAR _ProteinDescription
	text_end
	TX_FAR _IronDescription
	text_end
	TX_FAR _CarbosDescription
	text_end
	TX_FAR _CalciumDescription
	text_end
	TX_FAR _RareCandyDescription
	text_end
	TX_FAR _DomeFossilDescription
	text_end
	TX_FAR _HelixFossilDescription
	text_end
	TX_FAR _SecretKeyDescription
	text_end
	TX_FAR _MistStoneDescription
	text_end
	TX_FAR _BikeVoucherDescription
	text_end
	TX_FAR _XAccuracyDescription
	text_end
	TX_FAR _LeafStoneDescription
	text_end
	TX_FAR _CardKeyDescription
	text_end
	TX_FAR _NuggetDescription
	text_end
	TX_FAR _MGeneDescription
	text_end
	TX_FAR _PokeDollDescription
	text_end
	TX_FAR _FullHealDescription
	text_end
	TX_FAR _ReviveDescription
	text_end
	TX_FAR _MaxReviveDescription
	text_end
	TX_FAR _GuardSpecDescription
	text_end
	TX_FAR _SuperRepelDescription
	text_end
	TX_FAR _MaxRepelDescription
	text_end
	TX_FAR _DireHitDescription
	text_end
	TX_FAR _UnusedItemDescription
	text_end
	TX_FAR _FreshWaterDescription
	text_end
	TX_FAR _SodaPopDescription
	text_end
	TX_FAR _LemonadeDescription
	text_end
	TX_FAR _SSTicketDescription
	text_end
	TX_FAR _GoldTeethDescription
	text_end
	TX_FAR _XAttackDescription
	text_end
	TX_FAR _XDefendDescription
	text_end
	TX_FAR _XSpeedDescription
	text_end
	TX_FAR _XSpecialDescription
	text_end
	TX_FAR _CoinCaseDescription
	text_end
	TX_FAR _OaksParcelDescription
	text_end
	TX_FAR _ItemfinderDescription
	text_end
	TX_FAR _SilphScopeDescription
	text_end
	TX_FAR _PokeFluteDescription
	text_end
	TX_FAR _LiftKeyDescription
	text_end
	TX_FAR _ExpAllDescription
	text_end
	TX_FAR _OldRodDescription
	text_end
	TX_FAR _GoodRodDescription
	text_end
	TX_FAR _SuperRodDescription
	text_end
	TX_FAR _PPUpDescription
	text_end
	TX_FAR _EtherDescription
	text_end
	TX_FAR _MaxEtherDescription
	text_end
	TX_FAR _ElixerDescription
	text_end
	TX_FAR _MaxElixerDescription
	text_end
    TX_FAR _UnusedItemDescription
	text_end
    TX_FAR _UnusedItemDescription
	text_end
    TX_FAR _UnusedItemDescription
	text_end
    TX_FAR _UnusedItemDescription
	text_end
    TX_FAR _UnusedItemDescription
	text_end
    TX_FAR _UnusedItemDescription
	text_end
    TX_FAR _UnusedItemDescription
	text_end
    TX_FAR _UnusedItemDescription
	text_end
    TX_FAR _UnusedItemDescription
	text_end
    TX_FAR _UnusedItemDescription
	text_end
    TX_FAR _UnusedItemDescription
	text_end
    TX_FAR _UnusedItemDescription
	text_end
    TX_FAR _UnusedItemDescription
	text_end
    TX_FAR _UnusedItemDescription
	text_end
    TX_FAR _MetalCoatDescription
	text_end
	TX_FAR _HM01Description
	text_end
	TX_FAR _HM02Description
	text_end
	TX_FAR _HM03Description
	text_end
	TX_FAR _HM04Description
	text_end
	TX_FAR _HM05Description
	text_end
	TX_FAR _TM01Description
	text_end
	TX_FAR _TM02Description
	text_end
	TX_FAR _TM03Description
	text_end
	TX_FAR _TM04Description
	text_end
	TX_FAR _TM05Description
	text_end
	TX_FAR _TM06Description
	text_end
	TX_FAR _TM07Description
	text_end
	TX_FAR _TM08Description
	text_end
	TX_FAR _TM09Description
	text_end
	TX_FAR _TM10Description
	text_end
	TX_FAR _TM11Description
	text_end
	TX_FAR _TM12Description
	text_end
	TX_FAR _TM13Description
	text_end
	TX_FAR _TM14Description
	text_end
	TX_FAR _TM15Description
	text_end
	TX_FAR _TM16Description
	text_end
	TX_FAR _TM17Description
	text_end
	TX_FAR _TM18Description
	text_end
	TX_FAR _TM19Description
	text_end
	TX_FAR _TM20Description
	text_end
	TX_FAR _TM21Description
	text_end
	TX_FAR _TM22Description
	text_end
	TX_FAR _TM23Description
	text_end
	TX_FAR _TM24Description
	text_end
	TX_FAR _TM25Description
	text_end
	TX_FAR _TM26Description
	text_end
	TX_FAR _TM27Description
	text_end
	TX_FAR _TM28Description
	text_end
	TX_FAR _TM29Description
	text_end
	TX_FAR _TM30Description
	text_end
	TX_FAR _TM31Description
	text_end
	TX_FAR _TM32Description
	text_end
	TX_FAR _TM33Description
	text_end
	TX_FAR _TM34Description
	text_end
	TX_FAR _TM35Description
	text_end
	TX_FAR _TM36Description
	text_end
	TX_FAR _TM37Description
	text_end
	TX_FAR _TM38Description
	text_end
	TX_FAR _TM39Description
	text_end
	TX_FAR _TM40Description
	text_end
	TX_FAR _TM41Description
	text_end
	TX_FAR _TM42Description
	text_end
	TX_FAR _TM43Description
	text_end
	TX_FAR _TM44Description
	text_end
	TX_FAR _TM45Description
	text_end
	TX_FAR _TM46Description
	text_end
	TX_FAR _TM47Description
	text_end
	TX_FAR _TM48Description
	text_end
	TX_FAR _TM49Description
	text_end
	TX_FAR _TM50Description
	text_end