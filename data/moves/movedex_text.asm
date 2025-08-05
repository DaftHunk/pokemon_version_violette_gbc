; PureRGBnote: ADDED: text pointers for the descriptions that show up in the movedex.

_PoundDexEntry::
	text "Ecrase l'ennemi"
	next "avec les pattes"
	next "avant, la queue.@"
	text_jump _GenericNoEffectText

_KarateChopDexEntry::
	text "L'ennemi est tran-"
	next "ché violemment.@"
	; fall through
	text_jump _GenericHighCritChancesText

_DoubleslapDexEntry::
	text "Gifle rapidement"
	next "l'ennemi à plu-"
	next "sieurs reprises.@"
	; fall through
	text_jump _Generic2To5HitsText

_CometPunchDexEntry::
	text "Une tornade de"
	next "coups de poing.@"
	; fall through
	text_jump _Generic2To5HitsText

_MegaPunchDexEntry::
	text "L'ennemi reçoit"
	next "un coup de poing"
	next "d'une puissance"

	bage "incroyable"
	dex

_PayDayDexEntry::
	text "Des pièces sont"
	next "lancées sur"
	next "l'ennemi."
	
	bage "Permet d'obtenir"
	next "de l'argent à"
	next "la fin du combat."

	bage "Peut aussi servir"
	next "aux machines à"
	next "sous.."
	dex

_FirePunchDexEntry::
	text "Un coup de poing"
	next "enflammé vient"
	next "frapper l'ennemi.@"
	; fall through
	text_jump _Generic10PercentBurnText

_IcePunchDexEntry::
	text "Un coup de poing"
	next "glacé vient"
	next "frapper l'ennemi.@"
	; fall through
	text_jump _Generic10PercentFrozeText

_ThunderPunchDexEntry::
	text "Un coup de poing"
	next "électrique vient"
	next "frapper l'ennemi.@"
	; fall through
	text_jump  _Generic10PercentParalysisText

_ScratchDexEntry::
	text "Lacère l'ennemi"
	next "avec des griffes"
	next "acérées.@"
	text_jump _GenericNoEffectText

_VicegripDexEntry::
	text "L'ennemi est attr-"
	next "rapé et compressé"
	next "par les côtés.@"
	; fall through
	text_jump _Generic30PercentParalysisText

_GuillotineDexEntry::
	text "Des pinces lacè-"
	next "rent violemment"
	next "l'ennemi.@"
	; fall through
	text_jump _GenericOHKOText

_RazorWindDexEntry::
	text "Un tourbillon est"
	next "créé pendant 1"
	next "tour pour que des"

	bage "lames de vent s'"
	next "abattent sur la"
	next "cible au 2ème.@"
	; fall through
 	text_jump _GenericHighCritChancesText

_SwordsDanceDexEntry::
	text "Danse frénétique"
	next "qui exalte l'"
	next "esprit combatif.@"
	; fall through
	text_jump _GenericAddAtk2Text
	

_CutDexEntry::
	text "Coupe l'ennemi"
	next "avec des lames"
	next "ou des griffes."

	bage "Hors combat, per-"
	next "met de couper des"
	next "arbres fins et les"
	
	bage "hautes herbes"
	dex

_GustDexEntry::
	text "Le lanceur bat des"
	next "ailes pour générer"
	next "une bourrasque qui"

	bage "blesse l'ennemi"
	dex

_WingAttackDexEntry::
	text "L'ennemi est frap-"
	next "pé par de larges"
	next "ailes déployées"

	bage "pour infliger"
	next "des dégâts"
	dex

_WhirlwindDexEntry::
	text "Ejecte le Pokémon"
	next "ennemi et le remp-"
	next "lace par un autre."

	bage "Dans la nature,"
	next "met fin au combat"
	dex

_FlyDexEntry::
	text "Le lanceur s'envo-"
	next "le au 1er tour"
	next "et frappe au 2ème."

	bage "Esquive la plupart"
	next "des attaques"
	next "durant le vol."

	bage "Permet aussi"
	next "d'être porté dans"
	next "une ville visitée"
	dex

_BindDexEntry::
	text "Ecrase l'ennemie"
	next "comme s'il était"
	next "sous un rocher.@"
	; fall through
	text_jump _GenericTrappingMoveText

_SlamDexEntry::
	text "Fouette l'ennemi"
	next "avec la queue, une"
	next "liane, etc.@"
	; fall through
	text_jump _GenericNoEffectText

_VineWhipDexEntry::
	text "Fouette l'ennemi"
	next "avec de fines"
	next "lianes.@"
	; fall through
	text_jump _GenericNoEffectText

_StompDexEntry::
	text "Ecrase l'ennemi"
	next "avec un énorme"
	next "pied.@"
	; fall through
	text_jump _Generic30PercentFlinchText

_DoubleKickDexEntry::
	text "2 coups de pied"
	next "qui frappent l'en-"
	next "nemi rapidement.@"
	; fall through
	text_jump _Generic2HitsText

_MegaKickDexEntry::
	text "Un coup de pied"
	next "superpuissant"
	next "et intense qui"

	bage "frappe l'ennemi"
	dex

_JumpKickDexEntry::
	text "Le lanceur s'"
	next "envole pour"
	next "décocher un coup"
	
	bage "de pied sauté."

	bage "Attaque signature"
	next "de Kicklee.@"
	; fall through
	text_jump _Generic30PercentFlinchText

_RollingKickDexEntry::
	text "Le lanceur donne"
	next "un coup de pied"
	next "tournoyant extrê-"

	bage "mement rapide."

	bage "Attaque signature"
	next "de Kicklee.@"
	; fall through
	text_jump _Generic30PercentFlinchText

_SandAttackDexEntry::
	text "Lance du sable"
	next "au visage de"
	next "l'ennemi.@"
	; fall through
	text_jump _GenericLowPre1Text

_HeadbuttDexEntry::
	text "Le lanceur lève"
	next "la tête avant"
	next "d'asséner un coup"

	bage "vers l'avant.@"
	; fall through
	text_jump _Generic30PercentFlinchText

_HornAttackDexEntry::
	text "Frappe l'ennemi"
	next "d'un coup de corne"
	next "pointue.@"
	; fall through
	text_jump _GenericNoEffectText

_FuryAttackDexEntry::
	text "Frappe l'ennemi"
	next "de façon répétée"
	next "avec une corne"

	bage "ou un bec.@"
	; fall through
	text_jump _Generic2To5HitsText

_HornDrillDexEntry::
	text "Un coup de corne"
	next "qui empale l'"
	next "ennemi en tournant"
	
	bage "comme une vrille.@"
	; fall through
	text_jump _GenericOHKOText

_TackleDexEntry::
	text "Le lanceur charge"
	next "l'ennemi et le"
	next "percute de"

	bage "de tout son corps"
	dex

_BodySlamDexEntry::
	text "Le lanceur se"
	next "laisse tomber"
	next "sur l'ennemi de"
	
	bage "tout son poids.@"
	; fall through
	text_jump _Generic30PercentParalysisText

_WrapDexEntry::
	text "Le lanceur ligote"
	next "l'ennemi avec des"
	next "lianes ou son"

	bage "corps pour l'"
	next "écraser.@"
	; fall through
	text_jump _GenericTrappingMoveText

_TakeDownDexEntry::
	text "Une charge violen-"
	next "te qui blesse"
	next "aussi légèrement"

	bage "le lanceur.@"
	; fall through
	text_jump _Generic25PercentRecoilText

_ThrashDexEntry::
	text "Une attaque furi-"
	next "euse sur laquelle"
	next "l'utilisateur va"

	bage "rester bloqué.@"
	; fall through
	text_jump _GenericThrashEffectText

_DoubleEdgeDexEntry::
	text "Une dangereuse ch-"
	next "arge qui blesse"
	next "aussi le lanceur.@"
	; fall through
	text_jump _Generic25PercentRecoilText

_TailWhipDexEntry::
	text "Le lanceur remue"
	next "son adorable queue"
	next "pour tromper la"

	bage "vigilance de"
	next "l'ennemi.@"
	; fall through
	text_jump _GenericLowDef1Text

_PoisonStingDexEntry::
	text "Un dard toxique"
	next "qui transperce"
	next "l'ennemi.@"
	; fall through
	text_jump _Generic40PercentPoisonText

_TwineedleDexEntry::
	text "Un double coup de"
	next "dards qui trans-"
	next "perce l'ennemi."

	bage "Attaque signature"
	next "de Dardargnan.@"
	; fall through
	text_call _Generic2HitsText
	text_end
	text_jump _Generic20PercentPoisonText

_PinMissileDexEntry::
	text "Envoie une rafale"
	next "de dards.@"
	; fall through
	text_jump _Generic2To5HitsText

_LeerDexEntry::
	text "Lance un regard"
	next "noir à l'ennemi"
	next "pour l'intimider.@"
	; fall through
	text_jump _GenericLowDef1Text

_BiteDexEntry::
	text "L'ennemi est mordu"
	next "par de tranchantes"
	next "canines.@"
	; fall through
	text_jump _Generic10PercentFlinchText

_GrowlDexEntry::
	text "Le lanceur pousse"
	next "un cri tout mimi"
	next "pour tromper la"

	bage "vigilance de son"
	next "ennemi.@"
	; fall through
	text_jump _GenericLowAtk1Text

_RoarDexEntry::
	text "Effraie le #mon"
	next "ennemi et le remp-"
	next "lace par un autre."

	bage "Dans la nature,"
	next "met fin au combat"
	dex

_SingDexEntry::
	text "Une berceuse qui"
	next "plonge ceux qui"
	next "l'écoute dans un"

	bage "profond sommeil"
	dex

_SupersonicDexEntry::
	text "Le lanceur produit"
	next "d'étranges ondes"
	next "sonores.@"
	; fall through
	text_jump _GenericConfusionText

_SonicboomDexEntry::
	text "Une onde de choc"
	next "destructrice."

	bage "Inflige toujours"
	next "20 PV de dégâts"
	dex

_DisableDexEntry::
	text "Empêche l'ennemi"
	next "d'employer à nou-"
	next "veau sa dernière"

	bage "attaque."
	
	bage "Dure 2 à 8 tours"
	dex

_AcidDexEntry::
	text "Attaque l'ennemi"
	next "avec un jet"
	next "d'acide corrosif.@"
	; fall through
	text_jump _Generic33PercentLowDef1Text

_EmberDexEntry::
	text "L'ennemi est atta-"
	next "qué par de faibles"
	next "flammes.@"
	; fall through
	text_jump _Generic10PercentBurnText

_FlamethrowerDexEntry::
	text "L'ennemi reçoit"
	next "un torrent de"
	next "flammes.@"
	; fall through
	text_jump _Generic10PercentBurnText

_MistDexEntry::
	text "Une brume blanche"
	next "enveloppe l'équipe"
	next "du lanceur et"

	bage "empêche la rédu-"
	next "ction des stats"
	dex

_WaterGunDexEntry::
	text "De l'eau est pro-"
	next "jetée sur l'ennemi"
	next "en arc de cercle.@"
	; fall through
	text_jump _GenericNoEffectText

_HydroPumpDexEntry::
	text "Un surpuissant jet"
	next "d'eau est dirigé"
	next "sur l'ennemi.@"
	; fall through
	text_jump _GenericNoEffectText

_SurfDexEntry::
	text "Une énorme vague"
	next "s'abat sur le"
	next "champ de bataille."

	bage "Permet de voyager"
	next "sur l'eau en de-"
	next "hors des combats"
	dex

_IceBeamDexEntry::
	text "Un rayon de glace"
	next "frappe l'ennemi.@"
	; fall through
	text_jump _Generic10PercentFrozeText

_BlizzardDexEntry::
	text "Une violente tem-"
	next "pête de neige est"
	next "déclenchée sur"

	bage "l'ennemi.@"
	; fall through
	text_jump _Generic10PercentFrozeText

_PsybeamDexEntry::
	text "Un étrange rayon"
	next "frappe l'ennemi.@"
	; fall through
	text_jump _Generic10PercentConfusionText

_BubblebeamDexEntry::
	text "Des bulles d'eau"
	next "sont envoyées avec"
	next "puissance sur"

	bage "l'ennemi.@"
	; fall through
	text_jump _Generic33PercentLowSpd1Text

_AuroraBeamDexEntry::
	text "Envoie un rayon"
	next "arc-en-ciel sur"
	next "l'ennemi.@"
	; fall through
	text_jump _Generic33PercentLowAtk1Text

_HyperBeamDexEntry::
	text "Projette un puiss-"
	next "ant rayon sur"
	next "l'ennemi."

	bage "Le lanceur doit se"
	next "reposer au tour"
	next "suivant, si"

	bage "l'ennemi n'est pas"
	next "mis KO"
	dex

_PeckDexEntry::
	text "Frappe l'ennemi"
	next "d'un bec pointu ou"
	next "ou d'une corne.@"
	; fall through
	text_jump _GenericNoEffectText

_DrillPeckDexEntry::
	text "Une attaque utili-"
	next "sant le bec comme"
	next "une perceuse.@"
	; fall through
	text_jump _GenericNoEffectText

_SubmissionDexEntry::
	text "Le lanceur agrippe"
	next "l'ennemi et l'"
	next "écrase au sol.@"
	; fall through
	text_jump _Generic25PercentRecoilText

_LowKickDexEntry::
	text "Un puissant coup"
	next "de pied bas qui"
	next "fauche l'ennemi.@"
	; fall through
	text_jump _Generic30PercentFlinchText

_CounterDexEntry::
	text "Une riposte qui"
	next "contre toute atta-"
	next "que physique en"

	bage "infligeant le dou-"
	next "ble de dégâts"
	dex

_SeismicTossDexEntry::
	text "L'ennemi est proj-"
	next "eté grâce au pouv-"
	next "oir de la gravité.@"
	; fall through
	text_jump _GenericAbsorbMoveText

_StrengthDexEntry::
	text "Le lanceur cogne"
	next "l'ennemi de toute"
	next "sa force."

	bage "Permet de déplacer"
	next "des rochers en de-"
	next "hors des combats"
	dex

_AbsorbDexEntry::
	text "Une attaque qui"
	next "absorbe les nutri-"
	next "ments de l'ennemi.@"
	; fall through
	text_jump _GenericAbsorbMoveText

_MegaDrainDexEntry::
	text "Draine rapidement"
	next "les nutriments de"
	next "la cible.@"
	; fall through
	text_jump _GenericAbsorbMoveText

_LeechSeedDexEntry::
	text "Une graine est se-"
	next "mée sur l'ennemi"
	next "Elle lui draine"

	bage "lentement sa vie"
	next "et les rends au"
	next "lanceur."

	bage "Ne fonctionne pas"
	next "sur les #mon"
	next "plantes"
	dex

_GrowthDexEntry::
	text "Le corps du lanc-"
	next "eur se développe.@"
	; fall through
	text_jump _GenericAddSpe1Text

_RazorLeafDexEntry::
	text "Des feuilles aigu-"
	next "usées comme des"
	next "rasoirs entaillent"
	
	bage "l'ennemi.@"
	; fall through
	text_jump _GenericHighCritChancesText

_SolarbeamDexEntry::
	text "Absorbe la lumière"
	next "au 1er tour et"
	next "envoie un rayon"
	
	bage "puissant au 2ème"
	dex

_PoisonPowderDexEntry::
	text "Une poudre toxique"
	next "est lâchée sur"
	next "l'ennemi."

	bage "Ne fonctionne pas"
	next "sur les #mon"
	next "poisons.@"
	; fall through
	text_jump _GenericPoisonText

_StunSporeDexEntry::
	text "Le lanceur répand"
	next "une poudre paraly-"
	next "sante sur l'ennemi@"
	; fall through
	text_jump _GenericParalizeText

_SleepPowderDexEntry::
	text "Le lanceur répand"
	next "une poudre sopori-"
	next "fique sur l'ennemi@"
	; fall through
	text_jump _GenericSleepText

_PetalDanceDexEntry::
	text "Le lanceur attaque"
	next "en projetant des"
	next "pétales."

	bage "Il ne fait plus"
	next "qu'un avec cette"
	next "dance florale."

	bage "Attaque signature"
	next "de Mystherbe, Ort-"
	next "ide et Rafflesia.@"
	; fall through
	text_jump _GenericThrashEffectText

_StringShotDexEntry::
	text "Le lanceur crache"
	next "de la soie pour"
	next "ligoter l'ennemi.@"
	; fall through
	text_jump _GenericLowSpd1Text

_DragonRageDexEntry::
	text "Une onde de choc"
	next "destructrice."
	
	bage "Inflige toujours"
	next "40 PV de dégats"
	dex

_FireSpinDexEntry::
	text "Un tourbillon de"
	next "flammes emprisonne"
	next "l'ennemi.@"
	; fall through
	text_jump _GenericTrappingMoveText

_ThundershockDexEntry::
	text "Une décharge élec-"
	next "trique tombe sur"
	next "l'ennemi.@"
	; fall through
	text_jump _Generic10PercentParalysisText

_ThunderboltDexEntry::
	text "Une grosse déchar-"
	next "ge électrique tom-"
	next "be sur l'ennemi.@"
	; fall through
	text_jump _Generic10PercentParalysisText

_ThunderWaveDexEntry::
	text "Un faible choc"
	next "électrique frappe"
	next "l'ennemi.@"
	; fall through
	text_jump _GenericParalizeText

_ThunderDexEntry::
	text "La foudre tombe"
	next "violemment sur"
	next "l'ennemi.@"
	; fall through
	text_jump _Generic10PercentParalysisText

_RockThrowDexEntry::
	text "Le lanceur soulève"
	next "une pierre et la"
	next "lance sur la cible@"
	; fall through
	text_jump _GenericNoEffectText

_EarthquakeDexEntry::
	text "Le lanceur provo-"
	next "que un tremblement"
	next "de terre touchant"

	bage "tous les #mon"
	next "autour de lui"
	dex

_FissureDexEntry::
	text "Le lanceur essaie"
	next "de faire tomber"
	next "l'ennemi dans"

	bage "une crevasse.@"
	; fall through
	text_jump _GenericOHKOText

_DigDexEntry::
	text "Le lanceur creuse"
	next "au premier tour,"
	next "se rendant intou-"

	bage "chable. Il frappe"
	next "ensuite au second."

	bage "En dehors des com-"
	next "bats, permet de"
	next "sortir des caves"
	dex

_ToxicDexEntry::
	text "Empoisonne grave-"
	next "ment l'ennemi."
	next "Les dégâts dus au"

	bage "poison augmentent"
	next "à chaque tour"
	dex

_ConfusionDexEntry::
	text "Une faible vague"
	next "télékinétique"
	next "frappe l'ennemi.@"
	; fall through
	text_jump _Generic10PercentConfusionText

_PsychicDexEntry::
	text "Une puissante for-"
	next "ce télékinétique"
	next "frappe l'ennemi.@"
	; fall through
	text_jump _Generic33PercentLowSpe1Text

_HypnosisDexEntry::
	text "Le lanceur hypno-"
	next "tise la cible.@"
	; fall through
	text_jump _GenericSleepText

_MeditateDexEntry::
	text "Le lanceur médite"
	next "pour éveiller son"
	next "pouvoir latent.@"
	; fall through
	text_jump _GenericAddAtk1Text

_AgilityDexEntry::
	text "Le lanceur se re-"
	next "laxe et allège son"
	next "corps.@"
	; fall through
	text_jump _GenericAddSpd2Text

_QuickAttackDexEntry::
	text "Le lanceur fonce"
	next "sur l'ennemi si"
	next "rapidement qu'on"

	bage "parvient à peine"
	next "à le discerner."
	
	bage "Frappe toujours"
	next "en premier"
	dex

_RageDexEntry::
	text "Une fois activée,"
	next "cette capacité au-"
	next "gmente l'Attaque"

	bage "du lanceur à cha-"
	next "que fois qu'il"
	next "subit des dégâts"
	dex

_TeleportDexEntry::
	text "Permet de fuir un"
	next "#mon sauvage."

	bage "Hors combat,"
	next "permet de revenir"
	next "au dernier Centre"
	
	bage "#mon visité"
	dex

_NightShadeDexEntry::
	text "Le lanceur invoque"
	next "un mirage pour te-"
	next "rrifier la cible.@"
	; fall through
	text_jump _GenericLevelDamageText

_MimicDexEntry::
	text "Le lanceur copie"
	next "la dernière capa-"
	next "cité utilisée par"

	bage "la cible et la"
	next "conserve tant qu'"
	next "reste en combat"
	dex

_ScreechDexEntry::
	text "Le lanceur émet un"
	next "son strident.@"
	; fall through
	text_jump _GenericLowDef2Text

_DoubleTeamDexEntry::
	text "Le lanceur se dép-"
	next "lace si vite qu'il"
	next "crée des copies"

	bage "illusoires de lui-"
	next "même.@"
	; fall through
	text_jump _GenericAddEva1Text

_RecoverDexEntry::
	text "Le lanceur se soi-"
	next "gne en régénérant"
	next "ses cellules.@"
	; fall through
	text_jump _GenericHealsHalfText

_HardenDexEntry::
	text "Le lanceur con-"
	next "tracte tous ses"
	next "muscles.@"
	; fall through
	text_jump _GenericAddDef1Text

_MinimizeDexEntry::
	text "Le lanceur se com-"
	next "prime pour se"
	next "faire tout petit.@"
	; fall through
	text_jump _GenericAddEva1Text

_SmokescreenDexEntry::
	text "Disperse un nuage"
	next "d'encre ou de"
	next "fumée.@"
	; fall through
	text_jump _GenericLowPre1Text

_ConfuseRayDexEntry::
	text "Un rayon sinistre"
	next "dirigé vers l'"
	next "ennemi.@"
	; fall through
	text_jump _GenericConfusionText

_WithdrawDexEntry::
	text "Le lanceur se"
	next "recroqueville dans"
	next "sa carapace.@"
	; fall through
	text_jump _GenericAddDef1Text

_DefenseCurlDexEntry::
	text "Le lanceur s'enr-"
	next "oule pour cacher"
	next "ses points faibles@"
	; fall through
	text_jump _GenericAddDef1Text

_BarrierDexEntry::
	text "Le lanceur érige"
	next "un mur psychique"
	next "solide.@"
	; fall through
	text_jump _GenericAddDef2Text

_LightScreenDexEntry::
	text "Crée un fabuleux"
	next "mur de lumière qui"
	next "réduit les dégâts"

	bage "causés par les ca-"
	next "pacités spéciales"
	next "pendant 5 tours.@"
	; fall through
	text_jump _GenericStopIfUserSwitchText

_HazeDexEntry::
	text "Crée un brouillard"
	next "qui annule les"
	next "changements de"

	bage "stats de tous les"
	next "#mon au combat"
	dex

_ReflectDexEntry::
	text "Crée un fabuleux"
	next "mur de lumière qui"
	next "réduit les dégâts"

	bage "causés par les ca-"
	next "pacités physiques"
	next "pendant 5 tours.@"
	; fall through
	text_jump _GenericStopIfUserSwitchText

_FocusEnergyDexEntry::
	text "Le lanceur prend"
	next "une profonde ins-"
	next "piration et se"

	bage "concentre.@"
	; fall through
	text_jump _GenericAddCrit4Text

_BideDexEntry::
	text "Le lanceur encais-"
	next "se les coups du-"
	next "rant 2 tours et"

	bage "réplique en infli-"
	next "geant le double"
	next "des dégâts subis"
	dex

_MetronomeDexEntry::
	text "Le lanceur agite"
	next "un doigt et sti-"
	next "mule son cerveau"

	bage "pour utiliser n'"
	next "importe quelle ca-"
	next "pacité au hasard"
	dex

_MirrorMoveDexEntry::
	text "Le lanceur riposte"
	next "à l'attaque de l'"
	next "ennemi avec la"

	bage "même attaque"
	dex

_SelfdestructDexEntry::
	text "Le lanceur provo-"
	next "que une explosion.@"
	; fall through
	text_jump _GenericExplodeText

_EggBombDexEntry::
	text "De toutes ses for-"
	next "ces, le lanceur"
	next "jette un gros oeuf"

	bage "qui explose sur"
	next "l'ennemi"
	dex

_LickDexEntry::
	text "Un grand coup de"
	next "langue qui inflige"
	next "des dégâts.@"
	; fall through
	text_jump _Generic10PercentParalysisText

_SmogDexEntry::
	text "Le lanceur attaque"
	next "à l'aide d'une"
	next "éruption de gaz"

	bage "répugnants.@"
	; fall through
	text_jump _Generic40PercentPoisonText

_SludgeDexEntry::
	text "Des détritus toxi-"
	next "ques sont projetés"
	next "sur l'ennemi.@"
	; fall through
	text_jump _Generic40PercentPoisonText

_BoneClubDexEntry::
	text "Le lanceur frappe"
	next "l'ennemi à grands"
	next "coups d'os."

	bage "Attaque signature"
	next "d'Osselait et"
	next "d'Ossatueur.@"
	; fall through
	text_jump _Generic10PercentFlinchText

_FireBlastDexEntry::
	text "Un déluge de flam-"
	next "mes ardentes sub-"
	next "merge l'ennemi.@"
	; fall through
	text_jump _Generic30PercentBurnText

_WaterfallDexEntry::
	text "Le lanceur charge"
	next "l'ennemi à une vi-"
	next "tesse remarquable."
	
	bage "Attaque signature"
	next "de Poissirène et"
	next "Poissoroy.@"
	; fall through
	text_jump _Generic30PercentFlinchText

_ClampDexEntry::
	text "Le lanceur piège"
	next "l'ennemi dans sa"
	next "dure coquille."

	bage "Attaque signature"
	next "de Kokiyas et"
	next "Crustabri.@"
	; fall through
	text_jump _GenericTrappingMoveText

_SwiftDexEntry::
	text "Le lanceur envoie"
	next "des rayons"
	next "d'étoiles.@"
	; fall through
	text_jump _GenericNeverMissText

_SkullBashDexEntry::
	text "Le lanceur baisse"
	next "la tête pour augm-"
	next "enter sa Défense"

	bage "au 1er tour et"
	next "percuter l'ennemi"
	next "au 2nd.@"
	; fall through
	text_jump _GenericAddDef1Text

_SpikeCannonDexEntry::
	text "Envoie une rafale"
	next "de dards.@"
	; fall through
	text_jump _Generic2To5HitsText

_ConstrictDexEntry::
	text "De longues tenta-"
	next "cules ou lianes"
	next "attaquent l'ennemi@"
	; fall through
	text_jump _Generic33PercentLowSpd1Text

_AmnesiaDexEntry::
	text "Le lanceur fait le"
	next "vide dans son"
	next "esprit.@"
	; fall through
	text_jump _GenericAddSpe2Text

_KinesisDexEntry::
	text "Le lanceur dis-"
	next "trait l'ennemi"
	next "en pliant une"

	bage "cuillère."

	bage "Attaque signature"
	next "de Kadabra et"
	next "Alakazam.@"
	; fall through
	text_jump _GenericLowPre1Text

_SoftboiledDexEntry::
	text "Le lanceur se re-"
	next "pose pour guérir.@"
	; fall through
	text_call _GenericHealsHalfText
	; fall through
	bage "En dehors du com-"
	next "bat, sacrifie ses"
	next "PV pour soigner"
	
	bage "un autre #mon"
	dex

_HiJumpKickDexEntry::
	text "Le lanceur s'élan-"
	next "ce pour effectuer"
	next "un coup de genou "

	bage "sauté."

	bage "Attaque signature"
	next "de Kicklee.@"
	; fall through
	text_jump _GenericMissRecoilText

_GlareDexEntry::
	text "Le lanceur intimi-"
	next "de l'ennemi grâce"
	next "à son regard"

	bage "terrifiant."

	bage "Attaque signature"
	next "d'Arbo et Arbok.@"
	; fall through
	text_jump _GenericParalizeText

_DreamEaterDexEntry::
	text "Le lanceur mange"
	next "le rêve de l'enne-"
	next "mi endormi.@"
	; fall through
	text_jump _GenericAbsorbMoveText

_PoisonGasDexEntry::
	text "Un nuage de gaz"
	next "toxique est pro-"
	next "jeté.@"
	; fall through
	text_jump _Generic20PercentPoisonText

_BarrageDexEntry::
	text "Projette de 2 à 5"
	next "grosses boules"
	next "sur l'ennemi."

	bage "Attaque signature"
	next "de Noeunoeuf et"
	next "Noadkoko.@"
	; fall through
	text_jump _Generic2To5HitsText

_LeechLifeDexEntry::
	text "Une attaque qui"
	next "aspire le sang"
	next "de l'ennemi.@"
	; fall through
	text_jump _GenericAbsorbMoveText

_LovelyKissDexEntry::
	text "Le lanceur fait un"
	next "bisou à la cible"
	next "en prenant une"

	bage "mine effrayante."
	
	bage "Attaque signature"
	next "de Lippoutou.@"
	; fall through
	text_jump _GenericSleepText

_SkyAttackDexEntry::
	text "Une attaque sur-"
	next "puissante en 2"
	next "tours.@"
	; fall through
	text_jump _Generic30PercentFlinchText

_TransformDexEntry::
	text "Le lanceur devient"
	next "une copie de sa"
	next "cible et obtient"

	bage "la même palette"
	next "de capacité"
	dex

_BubbleDexEntry::
	text "Des bulles"
	next "fappent l'ennemi.@"
	; fall through
	text_jump _Generic33PercentLowSpd1Text

_DizzyPunchDexEntry::
	text "Un enchaînement de"
	next "coups de poing ca-"
	next "encés."

	bage "Attaque signature"
	next "de Kangourex.@"
	; fall through
	text_jump _Generic30PercentConfusionText

_SporeDexEntry::
	text "Le lanceur répand"
	next "un nuage de"
	next "spores."

	bage "Attaque signature"
	next "de Paras et"
	next "Parasect.@"
	; fall through
	text_jump _GenericSleepText

_FlashDexEntry::
	text "Le lanceur produit"
	next "Une explosion lu-"
	next "mineuse.@"
	; fall through
	text_call _GenericLowPre1Text
	; fall through
	bage "Hors combat, per-"
	next "met d'éclairer les"
	next "grottes"
	dex

_PsywaveDexEntry::
	text "Une étrange onde"
	next "d'énergie chaude"
	next "frappe l'ennemi.@"
	; fall through
	text_jump _GenericLevelDamageText

_SplashDexEntry::
	text "Le lanceur barbote"
	next "inutilement."

	bage "Attaque signature"
	next "de Magicarpe.@"
	; fall through
	text_jump _GenericNoEffectText

_AcidArmorDexEntry::
	text "Le lanceur modifie"
	next "sa structure molé-"
	next "culaire.@"
	; fall through
	text_jump _GenericAddDef2Text
	
_CrabhammerDexEntry::
	text "Une grande pince"
	next "martèle l'ennemi."

	bage "Attaque signature"
	next "de Krabby et"
	next "Krabboss.@"
	; fall through
	text_jump _GenericHighCritChancesText

_ExplosionDexEntry::
	text "Le lanceur explose"
	next "et inflige de sér-"
	next "ieux dégâts.@"
	; fall through
	text_jump _GenericExplodeText

_FurySwipesDexEntry::
	text "L'ennemi est lacé-"
	next "ré par des faux ou"
	next "des griffes.@"
	; fall through
	text_jump _Generic2To5HitsText

_BonemerangDexEntry::
	text "Le lanceur projet-"
	next "te son os comme un"
	next "boomerang."

	bage "Attaque signature"
	next "d'Osselait et"
	next "d'Ossatueur.@"
	; fall through
	text_jump _Generic2HitsText

_RestDexEntry::
	text "Le lanceur s'end-"
	next "ore pendant 2"
	next "tours et soigne"

	bage "tous ses PV et"
	next "altération de"
	next "statut"
	dex

_RockSlideDexEntry::
	text "Le lanceur envoie"
	next "de gros rochers"
	next "sur l'ennemi.@"
	; fall through
	text_jump _Generic30PercentFlinchText

_HyperFangDexEntry::
	text "Mord l'ennemi à l'"
	next "aide de ses inci-"
	next "sives aiguisées."

	bage "Attaque signature"
	next "de Rattata et"
	next "Rattatac.@"
	; fall through
	text_jump _Generic10PercentFlinchText

_SharpenDexEntry::
	text "Le lanceur réduit"
	next "son nombre de"
	next "polygones pour"

	bage "accentuer ses"
	next "angles."

	bage "Attaque signature"
	next "de Porygon.@"
	; fall through
	text_jump _GenericAddAtkPre1Text

_ConversionDexEntry::
	text "Le lanceur prend"
	next "le type de son"
	next "adversaire."

	bage "Attaque signature"
	next "de Porygon"
	dex

_TriAttackDexEntry::
	text "Le lanceur envoie"
	next "3 boules d'énergie"
	next "simultanément."

	bage "30% de chance de"
	next "Brûler, Geler ou"
	next "Paralyser"
	dex

_SuperFangDexEntry::
	text "Une vilaine morsu-"
	next "re d'incisives."

	bage "Attaque signature"
	next "de Rattata et"
	next "Rattatac."

	bage "Inflige la moitié"
	next "des PV restants à"
	next "l'adversaire"
	dex

_SlashDexEntry::
	text "Un coup de griffe"
	next "ou de faux tranche"
	next "l'ennemi.@"
	; fall through
	text_jump _GenericHighCritChancesText

_SubstituteDexEntry::
	text "Le lanceur crée un"
	next "clone en sacrifi-"
	next "ant 25% de ses PV."

	bage "Ce clone sert de"
	next "leurre et subit"
	next "les dégâts"
	dex

_SludgeBombDexEntry::
	text "Des détritus toxi-"
	next "iques sont proje-"
	next "tés sur l'ennemi.@"
	; fall through
	text_jump _Generic20PercentPoisonText

_PursuitDexEntry::
	text "Une attaque qui"
	next "inflige de sérieux"
	next "dégâts à la cible.@"
	; fall through
	text_jump _Generic33PercentLowDef1Text

_CrunchDexEntry::
	text "Le lanceur mord"
	next "l'ennemi de ses"
	next "crocs pointus.@"
	; fall through
	text_jump _Generic33PercentLowDef1Text

_MetalClawDexEntry::
	text "Attaque avec des"
	next "griffes d'acier."
	next "tés sur l'ennemi.@"
	; fall through
	text_jump _GenericNoEffectText

_IronTailDexEntry::
	text "Attaque l'ennemi"
	next "avec une queue"
	next "de fer.@"
	; fall through
	text_jump _Generic33PercentLowDef1Text

_XScissorDexEntry::
	text "Le lanceur tailla-"
	next "de l'ennemi en ut-"
	next "ilisant ses faux"
	
	bage "ou ses griffes co-"
	next "mme une paire de"
	next "ciseaux"
	dex

_BugBuzzDexEntry::
	text "Le lanceur fait"
	next "vibrer son corps"
	next "pour lancer une"

	bage "vague sonique.@"
	; fall through
	text_jump _Generic33PercentLowDef1Text

_DarkPulseDexEntry::
	text "Le lanceur dégage"
	next "une horrible aura"
	next "chargée de pensées"

	bage "maléfiques.@"
	; fall through
	text_jump _Generic10PercentFlinchText

_ShadowBallDexEntry::
	text "Projette une gran-"
	next "de ombre sur"
	next "l'ennemi.@"
	; fall through
	text_jump _Generic33PercentLowSpe1Text

_DragonRushDexEntry::
	text "Le lanceur attaque"
	next "en prenant un air"
	next "menaçant.@"
	; fall through
	text_jump _Generic10PercentFlinchText

_FlashCannonDexEntry::
	text "Le lanceur concen-"
	next "tre son énergie"
	next "lumineuse et la"
	
	bage "fait exploser.@"
	; fall through
	text_jump _Generic33PercentLowSpe1Text
	
_StruggleDexEntry::
	text "Une attaque dése-"
	next "spérée, utilisée"
	next "quand le lanceur"

	bage "n'a plus de PP. Il"
	next "subit la moité des"
	next "dégâts infligés"
	dex

INCLUDE "data/moves/movedex_text_generics.asm"