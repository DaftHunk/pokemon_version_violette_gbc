#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mark_visible_objects.py — Pokémon Version Violette (GBC)

Colle sur les captures de cartes (PNG) les sprites des objets visibles :
PNJ, objets, dresseurs et rencontres statiques de Pokémon, chacun sur sa
case de jeu, recoloriés avec la palette des PNJ. Les objets invisibles au
début du jeu (data/maps/hide_show_data.asm) sont ignorés par défaut, sauf
les exceptions TOUJOURS_VISIBLIBLES (rivaux, Mew, Ho-Oh...) affichées
quand même, et une légende numérotée est ajoutée sous chaque capture.
Les objets cachés et les pièces (data/items/hidden_objects.asm recoupé
avec les listes de coordonnées — mêmes règles que mark_hidden_objects.py)
reçoivent en plus un badge numéroté.

Sources analysées dans le dépôt :
  - data/maps/objects/*.asm  : déclaration des objets d'une carte
        (une ligne :  object SPRITE, X, Y, MOUVEMENT, DIRECTION, TEXTE, ...)
        X et Y en tuiles de 8 px (vérifié sur les données du dépôt :
        UndergroundPathNorthSouth, 4x24 blocs = 8x48 tuiles, contient un
        warp Y=41 et un objet Y=24 — impossibles en blocs, valides en
        tuiles). Le nombre d'arguments restants donne le type (convention
        du hack) :
          6 arguments (sprite compris) -> personnage
          7                              -> objet, sauf si le dernier vaut 0
                                            (personnage)
          8                              -> dresseur si préfixe OPP_, sinon
                                            rencontre statique de Pokémon
                                            (espèce, niveau)
  - data/maps/hide_show_data.asm : objets « manquants » (missable) :
        blocs « db CONST_CARTE, $ID, Hide|Show » où $ID (premier objet =
        $01) désigne la n-ième ligne « object » de la carte (vérifié dans
        le moteur : engine/overworld/missable_objects.asm —
        InitializeMissableObjectsFlags arme le drapeau « retiré » de
        toutes les entrées Hide à l'initialisation).
        Hide = INVISIBLE au début du jeu (affiché plus tard par script) ;
        Show = présent au départ puis retiré par script (objet ramassé,
        Ronflex réveillé, rocher poussé dans un trou...).
        Par défaut ces objets Hide ne sont pas collés (--avec-caches les
        affiche aussi), SAUF les exceptions TOUJOURS_VISIBLIBLES :
        entrées Hide affichées quand même (rivaux, Mew du quai de
        Vermillon, Ho-Oh du jardin de Léo...). Une constante HS_* de
        constants/hide_show_constants.asm désigne l'entrée de même index
        dans hide_show_data.asm (les deux ordres coïncident, cf.
        l'avertissement du fichier : « THESE FUNCTIONS MUST FOLLOW THE
        ORDER LAID OUT IN "hide_show_constants.asm" »).
  - constants/map_constants.asm : dimensions des cartes
        (mapconst NOM, hauteur, largeur — en blocs de 16 px)
  - data/maps/headers/*.asm     : constante d'une carte repérée par son
        « db <NOM>_HEIGHT, <NOM>_WIDTH » ; le stem du fichier est aussi
        celui de la capture PNG
  - constants/sprite_constants.asm : identifiants des sprites (const
        séquentielles après « const_value = 1 » ; les commentaires $xx
        sont obsolètes, seul l'ordre compte)
  - data/maps/sprite_sets.asm  : SpriteSheetPointerTable — table dw dont
        l'ordre correspond aux identifiants (dw NomSprite...)
  - gfx/sprites/*.png          : sprites overworld en niveaux de gris
        2 bits sans transparence ; le crop 16x16 en haut à gauche donne
        la frame statique ; repli dans gfx/sprites/pokemons/ pour les
        Pokémon
  - gfx/pokemon/icons/*.png     : icônes du jeu, une par espèce (ex.
        mr_mime.png, nidoran_f.png) ; le crop 16x16 du haut donne la
        frame utilisée dans la légende des échanges (repli : sprite
        overworld)
  - gfx/items/*.png             : icônes du jeu, une par objet (24x24,
        MASTER_BALL -> master_ball.png, dérivation snake_case) ; une
        seule tm_hm.png pour toutes les CT/CS (TMxx_*/HMxx_*) ;
        recoloriées en palette des menus — la palette violette générique
        chargée par SetPal_Generic (PAL_MEWMON, cf. Recoloration) —
        conservées à
        leur taille d'origine (24x24, aucun redimensionnement) et
        collées devant chaque objet dans la légende : articles des
        magasins et du casino, objets au sol ou marqués par
        coordonnées, dons, récompenses de captures, objets cachés
        (repli : SPRITE_BALL pour les articles, nom seul sinon)
  - constants/item_constants.asm + text/item_names.asm + text/tmhm_names.asm :
        noms français des objets au sol (et des CT/CS, id >= $C4)
  - constants/pokemon_constants.asm + text/monster_names.asm :
        noms français des espèces des rencontres statiques
  - constants/trainer_constants.asm + text/trainer_names.asm :
        noms français des classes de dresseurs (l'ordre des « trainer_const »
        correspond à l'ordre de TrainerNames ; OPP_* = const + 190)
  - scripts/*.asm                : scripts des cartes ; les dons y sont
        rattachés au n° de texte de l'objet : un « lb bc, X, N » suivi de
        « call|predef GivePokemon » est un don de Pokémon (ex.
        CeladonMansionRoofHouse : EEVEE, 25 dans le texte 2 ;
        SaffronSilphCo7F : LAPRAS, 40 dans le texte 1), suivi de
        « call|predef GiveItem » un don d'objet (MtMoonB2F : DOME_FOSSIL
        texte 6, HELIX_FOSSIL texte 7) ; les récompenses de captures des
        assistants de Chen y sont détectées par « ld a, N » + « ld
        [hOaksAideRequirement], a » puis « ld a, ITEM » + « ld
        [hOaksAideRewardItem], a » autour du « predef OaksAideScript »
        (Route11Gate2F texte 2 : ITEMFINDER/30 captures, Route15Gate2F
        texte 1 : EXP_ALL/50 ; le seuil réduit du mode Nuzlocke est
        ignoré, le premier seuil lu gagne) ; les PNJ d'échange in-game
        y sont détectés par « ld a, N » (ou « xor a » = 0) suivi de
        « ld [wWhichTrade], a » — N est l'index de l'entrée dans
        TradeMons (Route11Gate2F texte 1 : $0, Route2TradeHouse texte
        2 : $1, VermilionTradeHouse texte 1 : $4, Route18Gate2F texte
        1 : $5, CeruleanTradeHouse texte 2 : $6, CinnabarLabTradeRoom
        textes 2 et 3 : $7 et $8) ; le n° de texte d'un label
        vient de la table « XxxTextPointers: » du script. Les dons
        atypiques (Hitmon du Dojo : « ld a, ESPECE » + « ld c, NIVEAU »
        au lieu de « lb bc » ; starters de Bourg Palette : choix par
        AddPartyMon) sont complétés à la main dans DONS_MANUELS ;
        l'ambre du musée d'Argenta, dont le don est codé dans le texte
        de l'assistant et non dans celui de l'objet (SPRITE_OLD_AMBER),
        dans DONS_OBJETS_MANUELS. Les combats déclenchés par
        le script de la carte (rival sans OPP_* dans sa ligne object —
        labo de Chen, Azuria, route 22, Océane, Tour Pokémon, Sylphe 7F,
        jardin de Léo (Sacha) — et boss Prof. Chen, « ld a, OPP_X » +
        « ld [wCurOpponent], a »)
        sont listés dans COMBATS_SCRIPTES, de même que les combats
        scriptés contre un POKÉMON unique (Ronflex de la route 12 :
        « ld a, SNORLAX » + « ld a, 30 »), référencés par
        « ESPECE/NIVEAU » et affichés comme les légendaires
        (nom FR + niveau, section « Rencontres »)
  - data/pokemons/trades.asm : échanges in-game — table TradeMons
        (« db ESPECE_DONNEE, ESPECE_RECUE, texte, surnom », 14 octets
        par entrée : 1re colonne = espèce que le joueur donne, 2e =
        espèce qu'il reçoit) ; le moteur (engine/in_game_trades.asm)
        lit wWhichTrade = index de l'entrée (l'octet de base de la
        table est recalculé par « swap a » / « sub b »)
  - data/items/mart_inventories.asm : ventes des magasins — textes
        « TX_MART ITEM, ITEM, ... » (labels Cashier/Clerk) référencés
        par les tables « XxxTextPointers: » des scripts : le PNJ dont
        le n° de texte pointe sur une vente est le vendeur (CeruleanMart
        texte 1, CeladonMart2F textes 1 et 2, CeladonMart3F texte 6,
        CeladonMart5F textes 3 et 4, IndigoPlateauLobby texte 4...) ;
        à Jadielle la table est décalée après le colis de Chen
        (« ViridianMartTextPointers + $a », soit 5 entrées) : le vendeur
        est l'objet texte 1, qui atteint l'entrée 6 de la table — la
        vente est acceptée aussi à son n° direct 6. Une vente sans
        label (vélo d'Azuria : TX_MART BICYCLE orphelin, le magasin y
        est un menu scripté) n'est pas marquée.
  - data/items/item_prices.asm + data/moves/tm_prices.asm : prix de
        vente — « money N ; CONST » pour les objets (ItemPrices) ; CT
        en nibbles de milliers (« dn 3, 2 ; TM01_MEGA_PUNCH,
        TM02_RAZOR_WIND » = 3000 et 2000 — TechnicalMachinePrices,
        moteur engine/items/tm_prices.asm)
  - data/items/prizes.asm + data/items/prize_mon_levels.asm :
        récompenses du casino (salle des prix) —
        PrizeDifferentMenuPtrs : trois paires « entrées / prix »
        (Pokémon : ABRA/PIKACHU/EEVEE puis
        LARVITAR/DRATINI/PORYGON ; CT : TM04_FLAMETHROWER,
        TM13_ICE_BEAM, TM24_THUNDERBOLT), prix en JETONS (« coins N »
        = BCD) ; le moteur (engine/menu/prize_menu.asm) charge la
        liste n° = n° de texte - 3 : les panneaux-vente sont des
        « sign » dont le texte (TX_PRIZE_VENDOR) est pointé aux rangs
        3, 4 et 5 de la table TextPointers (salle des prix de
        Céladon : sign 2,2,3 et 4,2,4 = Pokémon, sign 6,2,5 = CT) ;
        PrizeMonLevelDictionary donne le niveau de chaque Pokémon du
        casino (ABRA 8, PIKACHU 12, EEVEE 18, LARVITAR 24,
        DRATINI 24, PORYGON 22)
  - data/items/hidden_objects.asm : objets cachés
  - data/items/hidden_objects.asm : objets cachés — HiddenObjectMaps +
        HiddenObjectPointers, puis un bloc par carte (entrées
        « db Y, X, id » suivies de la routine « dbw BANK(...), Routine » ;
        bloc terminé par db $FF) ; les routines HiddenItems / HiddenCoins
        désignent les objets ramassables, les autres sont des interactifs
        invisibles (PC, statue, poubelle...) exclus, comme par défaut
        dans mark_hidden_objects.py
  - data/items/hidden_item_coords.asm / hidden_coins.asm : listes ordonnées
        (carte, Y, X) des objets cachés au sol et des pièces du Casino
        (l'ordre du fichier = index du flag de ramassement)

Positions : en jeu, un objet visible ne prend qu'une case — la tuile (X, Y)
de sa ligne « object ». Le sprite est donc collé sur exactement cette
case (redimensionné à 1 tuile), comme les icônes d'événements de
Polished Map ; il ne déborde plus sur les tuiles voisines.

Recoloration (palette des PNJ) : les niveaux de gris des PNG de sprites
sont remappés avant collage :
    fond blanc  -> transparent
    gris        -> blanc
    gris foncé  -> #F47D40 (orange de la palette des PNJ)
    noir        -> conservé (contours)
Les pixels déjà transparents sont inchangés ; le classement par
luminance reste robuste pour d'autres formats de PNG.

Les icônes d'objets (gfx/items/) suivent le même principe de
classement, mais avec la palette des menus — la palette violette
générique du jeu, chargée par SetPal_Generic (PAL_MEWMON de
data/palettes/gbc_palettes.asm), après la conversion propre du jeu
sur GBC (matrice de mixage + gamma=2 de custom_functions/
func_gamma.asm) :
    fond blanc  -> transparent
    gris        -> (232,176,144) clair
    gris foncé  -> (144,120,152) violet
    noir        -> (24,24,24)
(sur demande utilisateur : la palette des menus remplace celle du
monde pour ces icônes ; sprites, vignettes et icônes d'espèces
restent en palette des PNJ).

Légende : seuls les dresseurs, les objets ramassables, les rencontres
statiques de Pokémon, les PNJ d'échange et les vendeurs de magasin sont
numérotés ; les SPRITE_POKEBALL sont des
Pokémons offerts à récupérer et suivent le même traitement — le don est
résolu par le n° de texte de l'objet dans le script de la carte
(scripts/<carte>.asm : « lb bc, ESPECE, NIVEAU » + « call GivePokemon »
indexé par la table « XxxTextPointers: », ou l'unique don de la carte,
ou DONS_MANUELS pour les dons atypiques ; libellé générique « Pokémon »
si le don n'y est pas trouvé, la carte est alors listée en fin de run
pour compléter à la main). Un PNJ donneur de Pokémon (ex. SPRITE_LAPRAS_
GIVER du 7F de Sylphe) dont le n° de texte porte le don est marqué de la
même façon ; les fossiles du Mont Sélénite (SPRITE_DOME/SPRITE_OMANYTE)
sont des dons d'objet (GiveItem). Tous ces dons — Pokémons offerts
(SPRITE_POKEBALL, PNJ donneurs, DONS_MANUELS), fossiles, dons d'objets
de DONS_OBJETS_MANUELS (ambre du musée d'Argenta, Boîte Jeton, Ticket
Bateau, CT37...) et récompenses de captures des assistants de Chen
(OaksAideScript) — sont regroupés dans la section « Récompenses » de la
légende. Les entrées d'OBJETS_COORDONNEES (dons sans objet déclaré à
retyper, ou plusieurs dons pour un même objet : les 3 CT de la petite
fille du toit du Centre de Céladon) sont
numérotées par coordonnées (X, Y) : seul le numéro est dessiné sur la
tuile, et l'entrée s'affiche dans la légende comme un don de PNJ
(section « Récompenses ») — vignette SPRITE_BALL, puis le nom FR
de l'objet ; la valeur peut être une liste de consts : les objets
partagent alors le numéro de la tuile et un libellé (noms séparés par
une espace), avec une ligne CSV par objet.
Les combats scriptés contre un dresseur (rivaux, Prof. Chen, Sacha,
Infirmière Joëlle) sont numérotés comme des
dresseurs dans « Rencontres », sans « #n » (le n° de dresseur dépend du
starter du rival). Un combat scripté contre un Pokémon unique
(COMBATS_SCRIPTES : « ESPECE/NIVEAU », ex. Ronflex de la route 12)
s'affiche comme les légendaires : nom FR et niveau (« Ronflex n.30 »),
numéroté dans « Rencontres ». Les PNJ d'échange in-game (l'index chargé dans
wWhichTrade désigne une entrée de TradeMons) forment leur propre
section « Echanges », avec l'icône du jeu de chaque espèce
(gfx/pokemon/icons/, frame 16x16 du haut ; repli : sprite overworld).
Les vendeurs des magasins (ventes TX_MART de
data/items/mart_inventories.asm, rattachées au n° de texte d'un PNJ
par la table TextPointers du script de la carte), les PNJ vendant un
Pokémon (VENTES_POKEMON_MANUELLES, ex. le vendeur de Magicarpe du
Centre Pokémon du Mont Sélénite) et les distributeurs de boissons
(DISTRIBUTEURS_MANUELS, marqués par coordonnées) forment la section
« Magasin » : le vendeur est numéroté sur sa case, et son entrée de
légende, sans vignette latérale, ouvre sur une ligne dédiée par
l'icône du vendeur et le mot « Vendeur » (icône surélevée comme sur
la carte, numéro en bas à droite de sa case ; SPRITE_VENDEUR
n'existe pas dans sprite_constants.asm : repli automatique sur
SPRITE_MART_GUY, le vendeur du jeu), puis liste chaque objet en
vente sur sa propre ligne, « Nom FR : prix » (prix d'achat :
item_prices.asm ; CT : tm_prices.asm), chaque objet précédé de
l'icône du jeu de l'objet (gfx/items/, 24x24, recoloriée palette des
menus ; CT/CS : tm_hm.png ; groupe insécable avec son nom, repli
SPRITE_BALL si le PNG manque) et du prix suivi de l'icône des
Pokédollars (pokedollar.png, annexe à côté du script, groupe
insécable [prix + icône], repli prix seul si elle manque). Les panneaux-vente
du casino (TX_PRIZE_VENDOR, récompenses de data/items/prizes.asm)
suivent les magasins dans la section « Magasin » : badge or numéroté
sur la tuile du panneau — même rendu que les pièces cachées, en
vignette dans la légende — puis une récompense par ligne, « [icône]
Nom FR : N jetons » (Pokémon : icône de l'espèce du jeu comme les
échanges + niveau ; CT/objets : icône du jeu de l'objet, repli
SPRITE_BALL ; « N jetons »
insécable).
Les Pokémons offerts (SPRITE_POKEBALL, PNJ donneurs, DONS_MANUELS —
section « Récompenses ») portent la même icône d'espèce devant leur
nom et niveau, dans un groupe insécable. Les objets — au sol, marqués
par coordonnées, offerts (dons), récompenses de captures, cachés et
articles de magasins/casino — portent pareillement l'icône du jeu de
leur objet (gfx/items/, 24x24, MASTER_BALL -> master_ball.png ; CT/CS :
tm_hm.png), recoloriée palette des menus, conservée à sa taille
d'origine (24x24), insécable avec leur nom (repli :
SPRITE_BALL pour les articles, nom seul sinon). Les numéros sont composés avec les
chiffres de numbers.png (fichier à placer à côté du script : chiffres
0 à 9 en rangée, déjà détourés, transparents, taille d'origine), collés
tels quels ; le coin en bas à droite du numéro est posé sur le coin en
bas à droite de la case de l'objet. La numérotation suit l'ordre de
déclaration au sein de chaque catégorie de légende : « Rencontres »,
« Objets », « Récompenses », « Echanges », « Personnage », « Magasin »
et « Objets cachés » ont chacune leur compteur, repartant
à 1 ; les objets cachés sont numérotés dans l'ordre de lecture (Y, X) ;
les entrées d'OBJETS_COORDONNEES sont numérotées dans le compteur
« Récompenses » à la suite des dons déclarés de leur carte.
Les sprites sont collés surélevés de taille/4 px comme dans le jeu (ils
débordent sur la case du dessus) : le numéro, resté en bas de case, en
recouvre d'autant moins. Sous la capture, un bandeau blanc organisé en
sept sections liste une entrée par objet — « Rencontres : » (dresseurs,
Pokémons statiques), « Objets : » (objets, dont ceux marqués par
coordonnées), « Récompenses : » (dons des PNJ : Pokémons offerts,
objets donnés, récompenses de captures), « Echanges : » (PNJ d'échange
in-game : icône et nom de l'espèce reçue, « contre », icône et nom de
l'espèce donnée — icône du jeu de l'espèce, gfx/pokemon/icons/, 16x16
du haut ; repli : sprite overworld), « Personnage : » (PNJ à fonction :
libellé libre de LIBELLES_PNJ_MANUELS, ex. « Renameur », « Effaceur de
capacités »), « Magasin : » (vendeurs et
panneaux du casino : ligne dédiée « [icône du vendeur] Vendeur », puis
objets en vente, un par ligne avec leur prix ; panneaux du casino :
badge or + récompenses en jetons, une par ligne — jamais deux
vendeurs côte à côte) puis « Objets cachés : »
(objets cachés au sol, pièces), chaque titre aligné
en haut à gauche au-dessus de ses objets. Le bandeau s'élargit
au-delà de la capture pour que chaque ligne de TOUTES les sections
— articles des magasins/casino/distributeurs (une ligne par SAUT),
libellé entier des autres entrées — tienne entière sans retour à la
ligne automatique (v28 : section « Magasin » seulement, sur demande
utilisateur ; v37 : toutes les sections, sur demande utilisateur) ;
l'excédent de largeur se place autour de la capture sur
fond noir, l'image centrée horizontalement. Une entrée plus large que
la
largeur disponible passe à la ligne (coupure aux espaces ; chaque
icône reste
collée à son nom et chaque nombre à son unité « captures », insécables
— un groupe plus large qu'une ligne est décomposé : l'icône ouvre une
nouvelle ligne avec le premier mot du nom, le reste s'enroule, plus de
débordement du bord droit)
; un fragment SAUT force aussi le retour à la ligne (chaque objet
d'un magasin a ainsi sa ligne)
; une entrée peut donc occuper plusieurs lignes. Les
entrées y sont réparties en colonnes alignées (mêmes abscisses sur
chaque ligne) et reprennent exactement le rendu de la carte : vignette
du sprite à sa taille d'origine (aucun redimensionnement) avec le
numéro en bas à droite, suivie du libellé en noir :
    dresseur -> nom français de la classe (TrainerNames,
                text/trainer_names.asm, indexé par les constantes OPP_* de
                constants/trainer_constants.asm — l'ordre des
                « trainer_const » coïncide avec celui des noms,
                ex. OPP_PROF_OAK -> « Prof.Chen ») puis « #n » du
                dresseur dans l'objet (ex. « Rival1 #1 ») ; pour un
                combat scripté (COMBATS_SCRIPTES : rival, Prof. Chen,
                Sacha...), la classe seule, sans « #n » (ex. « Rival2 »)
    objet    -> nom français de l'objet (ItemNames, tmhmNames)
    objet offert (don d'objet, section « Récompenses »)
             -> nom français de l'objet (fossiles, ambre, Boîte Jeton,
                Ticket Bateau, CT37, Planche Surf...)
    pokémon  -> nom français de l'espèce (MonsterNames,
                text/monster_names.asm) et niveau (ex. « Pikachu n.12 »)
    pokémon récupérable (SPRITE_POKEBALL ou PNJ donneur, section
             « Récompenses »)
             -> icône du jeu de l'espèce (gfx/pokemon/icons/, 16x16 du
                haut, repli : sprite overworld) puis nom français de
                l'espèce et niveau lus dans le script de la carte,
                résolus par le n° de texte de l'objet (ex. « Évoli
                n.25 », « Lapras n.40 », « Kicklee n.35 » ; « Pokémon »
                si introuvable) — l'icône et le nom sont insécables
    récompense (assistant de Chen, section « Récompenses »)
             -> nom français de l'objet puis « : N captures »
                (ex. « Cherch'Objet : 30 captures », « Multi Exp : 50
                captures ») ; le « N captures » est insécable — jamais
                coupé par un retour à la ligne
    échange   -> fragments « str | Image » : « [icône] Nom français de
                l'espèce reçue contre [icône] nom de l'espèce donnée »
                (icônes = icônes du jeu de gfx/pokemon/icons/, frame
                16x16 du haut, recoloriées ; repli : sprite overworld,
                sinon libellé sans icône) ; chaque icône est collée à
                son nom dans un groupe insécable — jamais séparés par
                un retour à la ligne
    magasin  -> première ligne dédiée « [icône du vendeur] Vendeur »
                (icône = SPRITE_MART_GUY, uniforme, surélevée comme sur
                la carte, numéro en bas à droite de sa case — écrit en
                tête si la planche de chiffres manque ; icône et mot
                insécables), puis un objet en vente par ligne,
                « [SPRITE_BALL] Nom FR : prix » (nom :
                ItemNames/tmhmNames ; prix : item_prices.asm, CT via
                tm_prices.asm ; nom seul si le prix est inconnu ;
                SPRITE_BALL et nom insécables) ; les vendeurs ne sont
                jamais mis côte à côte
    casino   -> vignette = badge or numéroté (même rendu que les
                pièces cachées, sur la carte comme dans la légende),
                puis une récompense par ligne « [icône] Nom FR :
                N jetons » : Pokémon du casino -> icône de l'espèce
                du jeu (gfx/pokemon/icons/, 16x16 du haut, comme les
                échanges) et niveau (prize_mon_levels.asm) ; CT et
                objets -> SPRITE_BALL ; « N jetons » insécable (comme
                « N captures »)
    personnage -> PNJ à fonction (LIBELLES_PNJ_MANUELS : Renameur,
                effaceur de capacités...) : libellé libre de la
                config, tel quel (ex. « Renameur »), vignette = sprite
                du PNJ comme pour les autres entrées, section
                « Personnage »
Les personnages sans fonction reçoivent leur sprite mais pas de numéro
ni de légende ; ceux référencés dans LIBELLES_PNJ_MANUELS reçoivent en
outre un numéro et une entrée « Personnage » avec leur libellé.
Les accents sont conservés si une police TTF est disponible, sinon
translittérés (é -> e).

Objets cachés : les objets au sol et les pièces (data/items/) reçoivent
le même badge que mark_hidden_objects.py — disque d'une tuile de
diamètre (16 px sur les captures x2), centré sur leur tuile (Y, X),
rouge (objet) ou or (pièce), contour noir, numéro composé avec les
chiffres de numbers.png (collés tels quels, centrés sur le disque ;
numéro blanc en police Pillow si la planche est absente) — qui
poursuit la numérotation des objets visibles. Leur entrée de légende
(section « Objets cachés : ») reprend ce badge en vignette, à la même
taille que les vignettes de sprites, suivie du libellé : nom français
de l'objet (ItemNames, tmhmNames) ou « N jetons » pour les pièces
(détail COIN+n).

Échelle : la taille d'une tuile dans la capture est déduite
automatiquement des dimensions de la carte (export zoomé x2 => 16 px par
tuile, sprite collé sur 1 tuile, surélevé de taille/4 px) ;
--taille-tuile sert de repli quand la capture ne correspond pas aux
dimensions de la carte.

Exports (dans --out, défaut : dossier « Annotated_Maps » à côté du
dossier des
captures) :
  - <carte>.png         : capture annotée + légende sous l'image
                          (--sans-legende pour s'en passer) ; l'image
                          finale ENTIERE — capture annotée (sprites,
                          numéros, badges compris) ET légende (textes,
                          icônes, chiffres) — est agrandie x2 par
                          défaut (--echelle N pour changer, 1 = taille
                          d'origine)
  - visible_objects.csv : récapitulatif (séparateur « ; », ouvrable dans
                          Excel) — colonnes « numero » (numéro dessiné
                          sur la carte : compteur propre à chaque
                          catégorie de légende, repartant à 1) et
                          « cache_debut » (oui = invisible au début du
                          jeu : entrée Hide, ou objet/pièce caché ;
                          prioritaire = entrée Hide affichée quand même,
                          cf. TOUJOURS_VISIBLIBLES)

Utilisation :
  python mark_visible_objects.py
  python mark_visible_objects.py --png-dir screenshots/Maps
  python mark_visible_objects.py --avec-caches      # afficher aussi les Hide
  python mark_visible_objects.py --sans-legende
  python mark_visible_objects.py --echelle 1        # captures non agrandies

Dépendance : Pillow  (pip install pillow)
Fichiers annexes, à placer à côté du script : numbers.png (chiffres 0-9
en rangée sur fond transparent, détourés, taille d'origine) — sans lui,
aucun numéro n'est dessiné sur la carte et les numéros sont écrits en
toutes lettres dans la légende ; pokedollar.png (icône des Pokédollars,
prête à l'emploi — sur demande utilisateur : taille d'origine,
transparence, aucune recoloration) collée après chaque prix des
articles de magasin — sans elle, les prix s'affichent sans icône.
"""

import argparse
import csv
import io
import re
import sys
import time
import unicodedata
from pathlib import Path

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    sys.exit("Dépendance manquante : Pillow.  Installez-la avec :  pip install pillow")

DOSSIER_TEMOIN = "data/maps/objects"       # pour localiser la racine du dépôt
DOSSIER_OBJETS = "data/maps/objects"
DOSSIER_ENTETES = "data/maps/headers"
FICHIER_MAPCONST = "constants/map_constants.asm"
FICHIER_SPRITE_CONSTS = "constants/sprite_constants.asm"
FICHIER_SPRITE_SETS = "data/maps/sprite_sets.asm"
FICHIER_HS = "data/maps/hide_show_data.asm"
FICHIER_HS_CONSTS = "constants/hide_show_constants.asm"
FICHIER_ITEM_CONSTS = "constants/item_constants.asm"
FICHIER_ITEM_NAMES = "text/item_names.asm"
FICHIER_TMHM_NAMES = "text/tmhm_names.asm"
FICHIER_PKMN_CONSTS = "constants/pokemon_constants.asm"
FICHIER_PKMN_NAMES = "text/monster_names.asm"
FICHIER_TRADES = "data/pokemons/trades.asm"
FICHIER_MARTS = "data/items/mart_inventories.asm"
FICHIER_PRIX = "data/items/item_prices.asm"
FICHIER_PRIX_TM = "data/moves/tm_prices.asm"
FICHIER_CASINO = "data/items/prizes.asm"
FICHIER_NIVEAUX_CASINO = "data/items/prize_mon_levels.asm"
FICHIER_TRAINER_CONSTS = "constants/trainer_constants.asm"
FICHIER_TRAINER_NAMES = "text/trainer_names.asm"
FICHIER_HIDDEN_OBJECTS = "data/items/hidden_objects.asm"
FICHIER_HIDDEN_ITEMS = "data/items/hidden_item_coords.asm"
FICHIER_HIDDEN_COINS = "data/items/hidden_coins.asm"
DOSSIER_SCRIPTS = "scripts"
DOSSIER_SPRITES = "gfx/sprites"
SOUS_DOSSIER_PKMN = "pokemons"
DOSSIER_ICONES = "gfx/pokemon/icons"       # icônes des espèces (jeu)
DOSSIER_ICONES_ITEMS = "gfx/items"          # icônes des objets (24x24)
ICONE_TM_HM = "tm_hm.png"                  # icône unique des CT/CS
FICHIER_POKEDOLLAR = "pokedollar.png"      # icône des Pokédollars (annexe)

# Sprites dont le PNG ne suit pas la dérivation snake_case automatique
# (fichiers vérifiés dans gfx/sprites/ ; LaprassSprite = typo du dépôt).
# NidoranF/Seel2 sont les overworlds d'espèces de gfx/sprites/pokemons/
# (Seel2Sprite est listé dans la SpriteSheetPointerTable entre Pikachu et
# Zapdos, i.e. bloc des Pokémon — le seel.png de la racine, lui, est le
# Seel « PNJ » de SPRITE_SEEL) ; Fisher2/KimonoWoman sans séparateur ;
# MapSprite -> map_ow.png.
EXCEPTIONS_PNG = {
    "BlackHairBoy1Sprite": "black_hair_boy_1.png",
    "BlackHairBoy2Sprite": "black_hair_boy_2.png",
    "FireFighterSprite": "firefighter.png",
    "LaprassSprite": "pokemons/lapras.png",
    "Fisher2Sprite": "fisher2.png",
    "KimonoWomanSprite": "kimonowoman.png",
    "MapSprite": "map_ow.png",
    "NidoranFSprite": "pokemons/nidoranF.png",
    "NidoranMSprite": "pokemons/nidoranM.png",
    "Seel2Sprite": "pokemons/seel.png",
}

# Palette des PNJ (recoloration avant collage) :
#   fond blanc -> transparent, gris -> blanc, gris foncé -> #F47D40,
#   noir (contours) -> conservé.  Modifier PNJ_NOIR si le jeu change aussi
#   la dernière couleur des sprites.
FOND_TRANSPARENT = (255, 255, 255, 0)
PNJ_BLANC = (255, 255, 255, 255)
PNJ_ORANGE = (244, 125, 64, 255)           # #F47D40
PNJ_NOIR = (0, 0, 0, 255)

# Palette des menus (recoloration des icônes d'objets, gfx/items/) :
# le jeu charge PAL_MEWMON pour ses menus génériques (SetPal_Generic ->
# PalPacket_Generic, « used mostly for menus and the Oak intro ») et sur
# GBC convertit les couleurs brutes de data/palettes/gbc_palettes.asm par
# sa propre matrice de mixage puis sa table gamma=2
# (custom_functions/func_gamma.asm, prédef GBCGamma ; le noir y est
# épargné).  Couleurs réellement affichées à l'écran (valeurs 0-31 x8) :
#   SGB_WHITE (blanc)    -> (248,248,248)
#   RGB 30,17,11 (clair) -> mix (27,15,11) -> gamma (29,22,18) -> (232,176,144)
#   RGB 11, 5,14 (violet)-> mix (10, 7,12) -> gamma (18,15,19) -> (144,120,152)
#   RGB  3, 3, 3 (noir)  -> (24,24,24)
MENU_CLAIR = (232, 176, 144, 255)
MENU_VIOLET = (144, 120, 152, 255)
MENU_NOIR = (24, 24, 24, 255)

# Objets cachés (mêmes couleurs que mark_hidden_objects.py) : rouge =
# objet au sol (routine HiddenItems), or = pièce du Casino (HiddenCoins).
COULEURS_CACHES = {
    "objet": (214, 48, 49, 255),
    "piece": (243, 156, 18, 255),
}

# Seuls les dresseurs, les objets ramassables, les rencontres statiques,
# les dons/récompenses, les PNJ d'échange, les vendeurs de magasin et
# les PNJ à fonction (LIBELLES_PNJ_MANUELS) sont numérotés (personnages
# sans fonction : sprite seul, pas de numéro ni de légende). Le numéro est composé des
# chiffres de numbers.png (collés tels quels), même rendu sur l'image et
# dans la légende — plus de couleur par type.
TYPES_NUMEROTES = {"dresseur", "objet", "objet_offert", "pokemon",
                   "pokemon_offert", "recompense", "echange", "magasin",
                   "magasin_pokemon", "pnj_libelle"}

# Entrées Hide affichées quand même : événements scénaristiques (rivaux,
# Mew, Ho-Oh...) réactivés tôt par le scénario. Les noms sont les
# constantes HS_* de constants/hide_show_constants.asm ; la n-ième
# constante désigne la n-ième entrée de hide_show_data.asm (ordres
# identiques, cf. l'avertissement du fichier : « THESE FUNCTIONS MUST
# FOLLOW THE ORDER LAID OUT IN "hide_show_constants.asm" »).
TOUJOURS_VISIBLIBLES = {
    "HS_CERULEAN_RIVAL",             # rival d'Azuria
    "HS_PALLET_OAKS_LAB_OAK_1",      # Chen au labo (derrière sa table :
                                     # celui qui reste et que le joueur
                                     # peut affronter ; l'Oak de l'intro
                                     # (OAK_2) est exclu pour ne pas
                                     # doubler le sprite)
    "HS_MEW_VERMILION_DOCK",         # Mew sur le quai de Vermillon
    "HS_HOOH",                       # Ho-Oh, jardin de Léo
    "HS_ROUTE_22_RIVAL_1",           # rival, route 22 (1er combat)
    "HS_SS_ANNE_2F_RIVAL",           # rival de l'Océane
    "HS_SAFFRON_SILPH_CO_7F_RIVAL",  # rival, Sylphe SARL 7F
    "HS_LAVENDER_FUJIS_HOUSE_MR_FUJI"
}

# Dons que l'analyseur ne sait pas lire : certains textes ne codent pas le
# don par « lb bc, ESPECE, NIVEAU » + « call GivePokemon » mais par
# « ld a, ESPECE » ... « ld c, NIVEAU » (Hitmonlee/Hitmonchan du Dojo de
# Safronia, niveau 35). Clé = stem de la carte (scripts/<stem>.asm),
# valeur = {n° de texte: « ESPECE/NIVEAU »}. L'analyseur reste prioritaire
# (setdefault) sur ces valeurs de repli.
DONS_MANUELS = {
    "SaffronFightingDojo": {6: "HITMONLEE/35", 7: "HITMONCHAN/35"},
    # Starters du labo de Bourg Palette : le don n'y est pas codé « lb bc »
    # (choix par AddPartyMon, niveau 5) — 1 Salamèche, 2 Carapuce,
    # 3 Bulbizarre (SPRITE_POKEBALL, textes 2/3/4)
    "PalletOaksLab": {2: "CHARMANDER/5", 3: "SQUIRTLE/5", 4: "BULBASAUR/5"},
}

# Combats déclenchés par le SCRIPT de la carte : l'objet (rival, Chen)
# n'a pas de OPP_* dans sa ligne « object », la classe du combat est
# chargée par le script (« ld a, OPP_X » + « ld [wCurOpponent], a » ;
# le n° de dresseur dépend du starter du rival -> libellé sans « #n »).
# Clé = (stem de la carte, n° de l'objet dans l'ordre de déclaration).
# Valeur = « OPP_X » (combat de DRESSEUR) OU « ESPECE/NIVEAU » (combat
# contre un POKÉMON unique, ex. Ronflex de la route 12 : le script y
# charge « ld a, SNORLAX » + « ld a, 30 ») -> re-typé « pokemon », même
# style que les légendaires : « Nom FR n.niveau » (MonsterNames, ex.
# « Ronflex n.30 » ; texte libre accepté en repli si la const est
# inconnue), numéroté dans « Rencontres ».
# Vérifié : Route22 (1er et 2e combat, mêmes coordonnées), CeruleanCity,
# LavenderPokemonTower2F (combat dans le TEXTE 1), SaffronSilphCo7F,
# SSAnne2F (le script combat en OPP_RIVAL2 alors que la ligne object
# dit OPP_RIVAL1 -> la table corrige la légende), PalletOaksLab objet 5
# (Chen derrière sa table, combat de OaksLabText5), BillsGarden objet 2
# (Sacha : donne aussi l'ADN Berserk — DONS_OBJETS_MANUELS —, qui
# devient sa récompense de victoire, cf. la boucle des objets),
# FuchsiaPokecenter objet 1 (Infirmière Joëlle : le texte 1 du nurse
# combat en OPP_JOY après la Ligue, script « ld a, OPP_JOY » +
# « ld [wCurOpponent], a »), Route12 objet 1 (Ronflex 10,62 : combat
# scripté SNORLAX niveau 30 lancé par le script de la carte après la
# Poké Flute).
COMBATS_SCRIPTES = {
    ("Route22", 1): "OPP_RIVAL1",
    ("Route22", 2): "OPP_RIVAL2",
    ("CeruleanCity", 1): "OPP_RIVAL1",
    ("LavenderPokemonTower2F", 1): "OPP_RIVAL2",
    ("SaffronSilphCo7F", 9): "OPP_RIVAL2",
    ("SSAnne2F", 2): "OPP_RIVAL2",
    ("PalletOaksLab", 5): "OPP_PROF_OAK",
    ("BillsGarden", 2): "OPP_SACHA",
    ("IndigoChampionsRoom", 1): "OPP_RIVAL3",
    ("FuchsiaPokecenter", 1): "OPP_JOY",
    ("Route12", 1): "SNORLAX/30",
    ("Route16", 7): "SNORLAX/30",
    ("SaffronSilphCo11F", 1): "OPP_CHIEF",
    ("VermilionCity", 1): "OPP_JENNY",
}

# Dons d'objets portés par un autre objet que le texte du don (ou par un
# objet visible alors que le donneur du texte est caché) : l'objet
# re-typé « objet_offert » rejoint la section « Récompenses », avec le
# libellé du nom FR de l'objet (comme un ramassable). Clé = (stem de la
# carte, n° de l'objet dans l'ordre de déclaration). Vérifié dans le
# dépôt (texte du don -> objet marqué) :
#   - ambre du musée d'Argenta : don dans le TEXTE 3 de l'assistant, la
#     SPRITE_OLD_AMBER (objet 5) ne portant qu'un texte décoratif ;
#   - Boîte Jeton du Dîner de Céladon : don dans le texte 5 de l'objet 5
#     (SPRITE_GYM_HELPER) ;
#   - Ticket Bateau : don dans le texte 2 de Bill humain (objet 2,
#     caché au début du jeu) -> marqué sur l'objet 1, le Slowbro visible
#     (choix utilisateur) ;
#   - CT37 BombBeurk de Céladon : don dans le texte 5 (vieille personne,
#     objet 5, coordonnées 22,16) ;
#   - Planche Surf du directeur Game Freak (Mansion 3F) : don dans le
#     texte 4 = objet 4 ;
#   - CT18 Riposte (Centre Commercial 3F) : don dans le texte 1 du
#     premier vendeur (objet 1, 16,5).
# Les fossiles du Mont Sélénite (SPRITE_DOME/OMANYTE) sont détectés
# automatiquement et rejoignent aussi « Récompenses ». Les 3 CT de la
# petite fille du toit du Centre de Céladon restent marquées par
# coordonnées (OBJETS_COORDONNEES : leur objet affiche autre chose /
# plusieurs dons à la fois). Le don ADN Berserk de Sacha (BillsGarden
# objet 2, combat scripté OPP_SACHA) est référencé ici comme une
# récompense de victoire : le combat scripté garde la main (voir la
# boucle des objets) et le don s'affiche sous son nom en
# « Rencontres ».
# RÉCOMPENSES DE VICTOIRE DES RENCONTRES : la même table s'applique
# aussi aux dresseurs (OPP_*) et aux rencontres statiques — certains
# donnent un objet après le combat (ex. maîtres d'arènes et leur CT).
# La rencontre RESTE dans « Rencontres » (sprite, numéro, nom) ; son
# libellé ajoute les objets sur une nouvelle ligne sous le nom. La
# valeur peut
# être un objet ou plusieurs séparés par « , ». Clé = (stem, n° de
# l'objet), comme pour les personnages.
DONS_OBJETS_MANUELS = {
    ("PewterMuseum1F", 5): "OLD_AMBER",
    ("CeladonDiner", 5): "COIN_CASE",
    ("BillsHouse", 1): "S_S_TICKET",
    ("CeladonCity", 5): "TM37_SLUDGE_BOMB",
    ("CeladonMansion3F", 4): "SURFBOARD",
    ("CeladonMart3F", 1): "TM18_COUNTER",
    ("CeruleanBikeShop", 1): "BICYCLE",
    ("PewterGym", 1): "TM34_BIDE",
    ("CeruleanGym", 1): "TM11_BUBBLEBEAM",
    ("VermilionGym", 1): "TM24_THUNDERBOLT",
    ("CeladonGym", 1): "TM21_MEGA_DRAIN",
    ("FuchsiaGym", 1): "TM06_TOXIC",
    ("SaffronGym", 1): "TM29_PSYCHIC_M",
    ("CinnabarGym", 1): "TM38_FIRE_BLAST",
    ("ViridianGym", 1): "TM27_FISSURE",
    ("BillsGarden", 2): "BERSERK_ADN",
    ("CeruleanCity", 2): "TM28_DIG",
    ("CinnabarLabMetronomeRoom", 1): "TM35_METRONOME",
    ("FuchsiaWardensHouse", 1): "HM04_STRENGTH",
    ("LavenderFujisHouse", 5): "POKE_FLUTE",
    ("PalletBluesHouse", 3): "TOWN_MAP",
    ("PewterMuseum2F", 4): "RARE_CANDY",
    ("Route1", 1): "POTION",
    ("FuchsiaFisherHouse", 1): "SUPER_ROD",
    ("Route12FisherHouse", 1): "GOOD_ROD",
    ("VermilionFisherHouse", 1): "GOOD_ROD",
    ("Route16FlyHouse", 1): "HM02_FLY",
    ("SafariZoneSecretHouse", 1): "HM03_SURF",
    ("SaffronCopycatsHouse2F", 1): "TM31_MIMIC",
    ("SaffronMrPsychicsHouse", 1): "TM46_DARK_PULSE",
    ("ViridianCity", 6): "TM42_SHADOW_BALL",
    ("SaffronSilphCo2F", 1): "TM36_SELFDESTRUCT",
    ("Route12Gate2F", 1): "TM39_SWIFT",
    ("SSAnneCaptainsRoom", 1): "HM01_CUT",
    ("SaffronSilphCo11F", 1): "MASTER_BALL", 
    ("UndergroundPathWestEast", 1): "M_GENE",
    ("VermilionFanClub", 5): "BIKE_VOUCHER",
    ("ViridianForestSouthGate", 2): "POKE_BALL",
}

# Objets à marquer par coordonnées, sans retype d'un objet déclaré :
# clé = (stem, X, Y) — tuiles, comme les X, Y des lignes « object » —
# valeur = const de l'objet, OU liste de consts pour plusieurs objets
# au même endroit : ils partagent alors le numéro de la tuile et un
# libellé (noms FR séparés par une espace), avec une ligne CSV par objet.
# Sur la capture, SEUL le numéro est dessiné sur la tuile (X, Y), en
# bas à droite comme les autres numéros (pas de sprite) ; dans la
# légende, l'entrée reçoit la vignette SPRITE_BALL avec le numéro en
# bas à droite, suivie du libellé (repli : numéro écrit en tête du
# libellé si le sprite est introuvable). Les entrées sont numérotées
# dans le compteur « Récompenses », après les dons déclarés de la carte
# (choisir des tuiles sans numéro pour ne pas chevaucher).
OBJETS_COORDONNEES = {
    # don de Sacha (BillsGarden objet 2, 5,5) après le combat scripté —
    # tuile au-dessus de lui, à ajuster (désormais récompense de
    # victoire via DONS_OBJETS_MANUELS, ligne laissée en souvenir)
#    ("BillsGarden", 5, 5): "BERSERK_ADN",
    # les 3 CT de la petite fille du toit (objet 2, 5,5) selon la boisson
    # offerte (Eau Fraîche / Soda Cool / Limonade) — exemple en liste :
    # plusieurs objets au même endroit, un seul numéro
    ("CeladonMartRoof", 5, 5): ["TM13_ICE_BEAM",
                                "TM48_ROCK_SLIDE",
                                "TM49_TRI_ATTACK"],

    ("PalletRedsHouse2F", 0, 1): "POTION",
}

# Ventes de Pokémon par un PNJ (vendeur de Magicarpe du Centre Pokémon
# du Mont Sélénite) : clé = (stem, n° de l'objet PNJ dans l'ordre de
# déclaration), valeur = (ESPECE, prix en P$). Le PNJ devient un vendeur
# de la section « Magasin » — même rendu qu'un magasin : sprite du PNJ
# numéroté sur la carte, première ligne « [icône vendeur] Vendeur »,
# puis une ligne « [icône d'espèce] Nom FR : prix [icône P$] ».
# Priorité sur le don auto-détecté du script de la carte (le vendeur de
# Magicarpe serait sinon affiché comme un Pokémon offert).
VENTES_POKEMON_MANUELLES = {
    # vendeur de Magicarpe : SPRITE_FAT_BALD_GUY 10,6, texte 4
    # (MagikarpSalesmanText, avec le GivePokemon) — c'est lui le
    # vendeur, pas le gentleman 7,3 (texte 3, simple bavard) : 500 P$
    ("MtMoonPokecenter", 4): ("MAGIKARP", 500),
}

# Distributeurs (machines à boissons) marqués par coordonnées :
# clé = (stem, X, Y) — tuiles, comme OBJETS_COORDONNEES —, valeur =
# liste d'articles [(const d'objet, prix en P$), ...] ; une const seule
# (sans prix) retombe sur item_prices.asm. Rendu comme un vendeur de
# magasin : SEUL le numéro est dessiné sur la tuile (pas de sprite),
# section « Magasin », première ligne « [icône vendeur] Vente » (étiquette
# puis un article par ligne « [icône] Nom FR : prix [icône P$] », avec
# une ligne CSV par article. Prix du jeu : Eau Fraîche 200, Soda Cool
# 300, Limonade 350.
DISTRIBUTEURS_MANUELS = {
    ("CeladonMartRoof", 10, 1): [("FRESH_WATER", 200),
                            ("SODA_POP", 300),
                            ("LEMONADE", 350)],
    ("CeladonMartRoof", 11, 1): [("FRESH_WATER", 200),
                            ("SODA_POP", 300),
                            ("LEMONADE", 350)],
    ("CeladonMartRoof", 12, 2): [("FRESH_WATER", 200),
                            ("SODA_POP", 300),
                            ("LEMONADE", 350)],
    ("CinnabarLabTradeRoom", 4, 2): [("DOME_FOSSIL", 10000),
                            ("HELIX_FOSSIL", 10000)],
}

# Fonctions de certains PNJ (Name Rater, effaceur de capacités...) :
# clé = (stem, n° de l'objet PNJ dans l'ordre de déclaration), valeur =
# libellé libre de votre choix. Le PNJ rejoint la section « Personnage »
# de la légende : sprite sur la carte comme d'habitude, numéroté dans
# le compteur « Personnage », vignette + libellé dans le bandeau. Le
# libellé personnalisé a priorité sur toute détection automatique (don,
# vente, combat scripté, échange...).
LIBELLES_PNJ_MANUELS = {
    ("CeladonChiefHouse", 1): "Patron du Casino",
    ("CeladonCity", 9): "Dealer de jetons",
    ("CeladonHotel", 4): "Chasseur de prime",
    ("CeladonSchool", 2): "Rappeleur de capacité",
    ("CeladonSchool", 1): "Oublieuse de capacité",
    ("CeruleanBadgeHouse", 1): "Maître des Badges",
    ("CinnabarLabFossilRoom", 2): "Résurecteur de fossile",
    ("CinnabarLabFossilRoom", 1): "Cloneur",
    ("Daycare", 1): "Eleveur de Pokémon",
    ("DiglettsCave", 1): "Journal pourri",
    ("FuchsiaCity", 3): "Nico",    
    ("LavenderNameRatersHouse", 1): "Grand Donneur de Noms",
    ("SafariZoneCenterRestHouse", 1): "Julia",
    ("SSAnne1F", 1): "Serveur",
    ("SSAnneKitchen", 8): "Organisateur du Tournoi",
    ("UndergroundPathNorthSouth", 1): "Cilque",
}

# Catégories de la légende : « Rencontres » = dresseurs + rencontres
# statiques ; « Objets » = objets ramassables ; « Récompenses » = dons
# des PNJ (Pokémons offerts, objets donnés manuellement ou fossiles,
# objets marqués par coordonnées, récompenses de captures des
# assistants de Chen) ; « Echanges » = PNJ d'échange in-game (espèce
# reçue contre espèce donnée, table TradeMons de
# data/pokemons/trades.asm) ; « Personnage » = PNJ à fonction
# (LIBELLES_PNJ_MANUELS : Renameur, effaceur de capacités..., libellé
# libre) ; « Magasin » = vendeurs (ventes TX_MART de
# data/items/mart_inventories.asm, un objet par ligne avec son prix)
# et panneaux-vente du casino (TX_PRIZE_VENDOR, récompenses en jetons
# de data/items/prizes.asm, badge des pièces cachées) ; « Objets
# cachés » = objets cachés au sol + pièces.
CATEGORIES = {
    "dresseur": "Rencontres",
    "pokemon": "Rencontres",
    "objet": "Objets",
    "objet_offert": "Récompenses",
    "pokemon_offert": "Récompenses",
    "recompense": "Récompenses",
    "echange": "Echanges",
    "magasin": "Magasin",
    "magasin_pokemon": "Magasin",
    "distributeur": "Magasin",
    "casino": "Magasin",
    "pnj_libelle": "Personnage",
    "cache_objet": "Objets cachés",
    "cache_piece": "Objets cachés",
}
LIBELLES = {
    "dresseur": "Dresseur",
    "objet": "Objet au sol",
    "objet_offert": "Objet offert",
    "pokemon": "Pokémon",
    "pokemon_offert": "Pokémon",
    "recompense": "Récompense",
    "echange": "Échange",
    "magasin": "Magasin",
    "magasin_pokemon": "Vendeur",
    "distributeur": "Vente",
    "casino": "Casino",
    "pnj_libelle": "Personnage",
    "cache_objet": "Objet caché",
    "cache_piece": "Pièce cachée",
}

# Translittération de repli si aucune police TTF n'est disponible (les polices
# bitmap par défaut de Pillow ne couvrent pas les accents français).
TRANSLIT = str.maketrans({
    "á": "a", "à": "a", "â": "a", "ä": "a", "ã": "a",
    "é": "e", "è": "e", "ê": "e", "ë": "e",
    "í": "i", "ì": "i", "î": "i", "ï": "i",
    "ó": "o", "ò": "o", "ô": "o", "ö": "o", "õ": "o",
    "ú": "u", "ù": "u", "û": "u", "ü": "u",
    "ç": "c", "ñ": "n", "œ": "oe", "æ": "ae",
    "Á": "A", "À": "A", "Â": "A", "Ä": "A", "Ã": "A",
    "É": "E", "È": "E", "Ê": "E", "Ë": "E",
    "Í": "I", "Ì": "I", "Î": "I", "Ï": "I",
    "Ó": "O", "Ò": "O", "Ô": "O", "Ö": "O", "Õ": "O",
    "Ú": "U", "Ù": "U", "Û": "U", "Ü": "U",
    "Ç": "C", "Ñ": "N",
})
CANDIDATS_TTF = ("DejaVuSans.ttf", "arial.ttf", "LiberationSans-Regular.ttf",
                 "NotoSans-Regular.ttf", "FreeSans.ttf", "Verdana.ttf", "tahoma.ttf")

# ----------------------------------------------------------------- utilitaires

def lire(chemin: Path) -> str:
    for enc in ("utf-8", "latin-1"):
        try:
            return chemin.read_text(encoding=enc)
        except UnicodeDecodeError:
            continue
    return chemin.read_text(encoding="utf-8", errors="replace")

def val(s: str) -> int:
    """Convertit '$1a' (hexa) ou '-3'/'26' (décimal) en entier."""
    s = s.strip()
    if s.startswith("$"):
        return int(s[1:], 16)
    return int(s)

def trouver_depot() -> Path:
    """Cherche la racine du dépôt : dossier du script, ses parents, puis cwd."""
    depart = [Path(__file__).resolve().parent, Path.cwd()]
    for base in depart:
        for candidat in [base, *base.parents]:
            if (candidat / DOSSIER_TEMOIN).is_dir():
                return candidat
    sys.exit(
        "Dépôt introuvable : placez le script dans generated_scripts/ du dépôt,\n"
        "ou lancez-le depuis le dépôt, ou précisez --repo CHEMIN."
    )

def snake(nom: str) -> str:
    """BlackHairBoy1Sprite -> black_hair_boy_1 (dérivation du fichier PNG)."""
    base = nom[:-6] if nom.endswith("Sprite") else nom
    base = re.sub(r"([A-Za-z])(\d)", r"\1_\2", base)   # Boy1 -> Boy_1
    base = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", base)
    return base.lower()

def recolorer_pnj(img):
    """Recolore un sprite en palette PNJ.

    Les PNG de gfx/sprites/ sont en niveaux de gris 2 bits sans transparence
    (3 = blanc/fond, 2 = gris, 1 = gris foncé, 0 = noir) ; on classe chaque
    pixel par luminance pour rester robuste aux autres formats :
      blanc (>= 240)  -> transparent        (le fond)
      gris (140-239)  -> blanc
      gris foncé (60-139) -> #F47D40
      noir (< 60)     -> conservé
    Les pixels déjà transparents sont laissés tels quels.
    """
    img = img.convert("RGBA")
    px = img.load()
    for j in range(img.height):
        for i in range(img.width):
            r, g, b, a = px[i, j]
            if a == 0:
                continue
            lum = (r * 299 + g * 587 + b * 114) // 1000
            if lum >= 240:
                px[i, j] = FOND_TRANSPARENT
            elif lum >= 140:
                px[i, j] = PNJ_BLANC
            elif lum >= 60:
                px[i, j] = PNJ_ORANGE
            else:
                px[i, j] = PNJ_NOIR
    return img

def recolorer_menu(img):
    """Recolore l'icône d'un objet en palette des menus (sur demande
    utilisateur : la palette violette générique des menus du jeu, et
    non la palette des PNJ du monde).

    Les menus du jeu passent par SetPal_Generic, qui charge PAL_MEWMON
    (PalPacket_Generic) ; sur GBC le jeu convertit lui-même chaque
    couleur de data/palettes/gbc_palettes.asm par sa matrice de mixage
    puis sa table gamma=2 (custom_functions/func_gamma.asm, prédef
    GBCGamma), ce qui donne à l'écran :
      blanc  (SGB_WHITE)  -> (248,248,248)
      clair  (RGB 30,17,11) -> (232,176,144)
      violet (RGB 11, 5,14)  -> (144,120,152)
      noir   (RGB  3, 3, 3)  -> (24,24,24)   (épargné par la gamma)
    Comme recolorer_pnj, on classe chaque pixel par luminance pour
    rester robuste aux autres formats :
      blanc (>= 240)  -> transparent        (le fond)
      gris (140-239)  -> MENU_CLAIR
      gris foncé (60-139) -> MENU_VIOLET
      noir (< 60)     -> MENU_NOIR
    Les pixels déjà transparents sont laissés tels quels.
    """
    img = img.convert("RGBA")
    px = img.load()
    for j in range(img.height):
        for i in range(img.width):
            r, g, b, a = px[i, j]
            if a == 0:
                continue
            lum = (r * 299 + g * 587 + b * 114) // 1000
            if lum >= 240:
                px[i, j] = FOND_TRANSPARENT
            elif lum >= 140:
                px[i, j] = MENU_CLAIR
            elif lum >= 60:
                px[i, j] = MENU_VIOLET
            else:
                px[i, j] = MENU_NOIR
    return img

# ------------------------------------------------------------------- parseurs

def parse_dimensions_cartes(txt):
    """{constante de carte: (hauteur, largeur)} en blocs, depuis les mapconst."""
    dims = {}
    for m in re.finditer(r"^\s*mapconst\s+([A-Z0-9_]+)\s*,\s*(\d+)\s*,\s*(\d+)",
                        txt, re.M):
        dims[m.group(1)] = (int(m.group(2)), int(m.group(3)))
    return dims

def scan_entetes(dossier):
    """{constante de carte: stem du header} (le stem = nom de la capture PNG)."""
    mapping = {}
    for f in sorted(Path(dossier).glob("*.asm")):
        m = re.search(r"db\s+([A-Z0-9_]+)_HEIGHT\s*,\s*[A-Z0-9_]+_WIDTH", lire(f))
        if m:
            mapping[m.group(1)] = f.stem
    return mapping

def parse_constantes_sequentielles(txt, motif=r"([A-Za-z0-9_]+)"):
    """{constante: id} — const séquentielles suivant « const_value = N »."""
    ids = {}
    valeur = 1
    for ligne in txt.splitlines():
        corps = ligne.split(";")[0].strip()
        m = re.match(r"const_value\s*=\s*(\$[0-9A-Fa-f]+|\d+)$", corps)
        if m:
            valeur = val(m.group(1))
            continue
        m = re.match(r"const\s+" + motif + r"$", corps)
        if m:
            ids[m.group(1)] = valeur
            valeur += 1
    return ids

def parse_ids_sprites(txt):
    """{constante SPRITE_*: id} — seules les SPRITE_* (les ICON_* sont
    exclus par la remise « const_value = 1 » du fichier)."""
    return parse_constantes_sequentielles(txt, r"(SPRITE_[A-Za-z0-9_]+)")

def parse_constantes_items(txt):
    """{constante d'objet: id} depuis constants/item_constants.asm.

    Suit « const_value = N » puis les « const NOM » séquentiels (l'ordre =
    l'id) ; les alias « NOM EQU $xx » explicites sont aussi pris en compte.
    """
    ids = {}
    valeur = 1
    for ligne in txt.splitlines():
        corps = ligne.split(";")[0].strip()
        m = re.match(r"const_value\s*=\s*(\$[0-9A-Fa-f]+|\d+)$", corps)
        if m:
            valeur = val(m.group(1))
            continue
        m = re.match(r"const\s+([A-Za-z0-9_]+)$", corps)
        if m:
            ids[m.group(1)] = valeur
            valeur += 1
            continue
        m = re.match(r"([A-Za-z0-9_]+)\s+EQU\s+(\$[0-9A-Fa-f]+|\d+)$", corps)
        if m:
            ids.setdefault(m.group(1), val(m.group(2)))
    return ids

def parse_table_sprites(txt):
    """Liste ordonnée des dw de SpriteSheetPointerTable (index = id - 1)."""
    debut = txt.find("SpriteSheetPointerTable")
    if debut < 0:
        return []
    noms = []
    for ligne in txt[debut:].splitlines()[1:]:       # sauter la ligne du label
        if re.match(r"^[A-Za-z0-9_]+:", ligne):      # nouvelle section : stop
            break
        m = re.match(r"\s*dw\s+([A-Za-z0-9_]+)", ligne)
        if m:
            noms.append(m.group(1))
    return noms

def parse_objets(txt):
    """[(const SPRITE_*, [X, Y, MOUVEMENT, DIRECTION, TEXTE, ...]), ...]"""
    objets = []
    for ligne in txt.splitlines():
        corps = ligne.split(";")[0].strip()
        m = re.match(r"object\s+([A-Za-z0-9_]+)\s*,\s*(.+)$", corps)
        if not m:
            continue
        reste = [a.strip() for a in m.group(2).split(",")]
        objets.append((m.group(1), reste))
    return objets

def parse_signes(txt):
    """[(X, Y, n° de texte), ...] des lignes « sign X, Y, TEXTE » —
    mêmes tuiles que les lignes « object » (macro : \\1 = X, \\2 = Y,
    \\3 = n° de texte, macros/data_macros.asm) ; les panneaux-vente du
    casino sont des sign."""
    signes = []
    for ligne in txt.splitlines():
        corps = ligne.split(";")[0].strip()
        m = re.match(r"sign\s+(\S+)\s*,\s*(\S+)\s*,\s*(\S+)\s*$", corps)
        if m:
            signes.append((m.group(1), m.group(2), m.group(3)))
    return signes

def type_objet(reste):
    """(type, détail) d'après le nombre d'arguments (convention du hack).

    Rappel du macro « object » (macros/data_macros.asm) : \6 = id de texte,
    \7 = classe de dresseur (OPP_*), ou ITEM suivi de l'objet, ou espèce
    (rencontre statique), \8 = n° de dresseur / niveau. Dans « reste »
    (le sprite est retiré) : \7 = reste[5], \8 = reste[6].
    """
    n = len(reste)
    if n < 5:
        return "incomplet", ""
    if n == 5:
        return "personnage", ""
    if n == 6:
        return ("personnage", "") if reste[5] == "0" else ("objet", reste[5])
    classe = reste[5]                    # \7
    numero = reste[6] if n > 6 else ""   # \8
    if classe.startswith("OPP_"):
        return "dresseur", (f"{classe} {numero}" if numero else classe)
    if classe == "ITEM":
        return "objet", numero
    return "pokemon", (f"{classe}/{numero}" if numero else classe)

def parse_hide_show(txt):
    """{(constante de carte, n° objet): 'Hide'|'Show'} depuis hide_show_data.

    Une entrée « db CONST,$XX,Hide|Show » désigne le $XX-ième « object »
    (le premier vaut $01) de la carte CONST — convention vérifiée dans le
    moteur (IsObjectHidden compare l'id au décalage du sprite / 16).
    Seules les entrées Hide correspondent à un objet invisible au début du
    jeu (drapeau « retiré » armé à l'initialisation). Les lignes $FF de fin
    de bloc ne matchent pas le motif.
    """
    etats = {}
    for m in re.finditer(
            r"db\s+([A-Z][A-Z0-9_]*)\s*,\s*(\$[0-9A-Fa-f]+|\d+)\s*,\s*(Hide|Show)\b",
            txt):
        etats[(m.group(1), val(m.group(2)))] = m.group(3)
    return etats

def parse_hide_show_ordre(txt):
    """Liste ordonnée des entrées (carte, id, état) de hide_show_data.asm
    — l'ordre du fichier est celui des constantes HS_* de
    hide_show_constants.asm (const_value = 0, la n-ième constante désigne
    la n-ième entrée)."""
    entrees = []
    for m in re.finditer(
            r"db\s+([A-Z][A-Z0-9_]*)\s*,\s*(\$[0-9A-Fa-f]+|\d+)\s*,\s*(Hide|Show)\b",
            txt):
        entrees.append((m.group(1), val(m.group(2)), m.group(3)))
    return entrees

def parse_noms(txt):
    """Liste ordonnée des noms d'un fichier « db "NOM@@@" » (les @ de
    remplissage sont retirés) — ItemNames, tmhmNames, MonsterNames,
    TrainerNames."""
    return [m.group(1).rstrip("@").strip()
            for m in re.finditer(r'db\s+"([^"]*)"', txt)]

def parse_classes_dresseurs(txt):
    """{constante OPP_*: index (1-based)} — ordre des « trainer_const » de
    trainer_constants.asm. L'index désigne l'entrée correspondante de
    TrainerNames : l'ordre des deux fichiers coïncide (vérifié : PROF_OAK ->
    « Prof.Chen », GIOVANNI -> « Giovanni »)."""
    classes = {}
    for i, m in enumerate(re.finditer(r"trainer_const\s+([A-Za-z0-9_]+)", txt), 1):
        classes["OPP_" + m.group(1)] = i
    return classes

def nom_item(detail, ids_items, noms_items, noms_tmhm):
    """Nom français d'un objet au sol depuis son identifiant (None sinon)."""
    detail = (detail or "").strip()
    id_ = ids_items.get(detail)
    if id_ is None:
        m = re.fullmatch(r"\$([0-9A-Fa-f]{1,2})", detail)
        if m:
            id_ = int(m.group(1), 16)
    if id_ is None:
        return None
    if 1 <= id_ <= len(noms_items):
        return noms_items[id_ - 1]
    if noms_tmhm and 0xC4 <= id_ < 0xC4 + len(noms_tmhm):
        return noms_tmhm[id_ - 0xC4]
    return None

def nom_espece(const, ids_pokemon, noms_pokemon):
    """Nom français d'une espèce depuis sa constante (None sinon)."""
    id_ = ids_pokemon.get((const or "").strip())
    if id_ is not None and 1 <= id_ <= len(noms_pokemon):
        return noms_pokemon[id_ - 1]
    return None

def parse_liste_coords(txt):
    """Liste ordonnée de (carte, y, x) — fichiers hidden_item_coords /
    hidden_coins (l'ordre du fichier = index du flag de ramassement)."""
    entrees = []
    for m in re.finditer(
            r"^\s*db\s+([A-Z0-9_]+)\s*,\s*(\$[0-9A-Fa-f]+|\d+)\s*,\s*(\$[0-9A-Fa-f]+|\d+)",
            txt, re.M):
        entrees.append((m.group(1), val(m.group(2)), val(m.group(3))))
    return entrees

def parse_blocs_hidden_objects(txt):
    """{label: [(y, x, detail, routine), ...]} pour chaque bloc
    XxxHiddenObjects de hidden_objects.asm — entrées « db Y, X, id »
    suivies de la routine « dbw BANK(...), Routine » ou « db BANK(...) »
    + « dw ... » ; bloc terminé par db $FF."""
    blocs = {}
    for m in re.finditer(r"^([A-Za-z0-9_]+HiddenObjects?)\s*:\s*(?:;.*)?$",
                         txt, re.M):
        label = m.group(1)
        debut = m.end()
        fin = re.search(r"db\s+\$?FF", txt[debut:], re.I)
        corps = txt[debut:debut + fin.start()] if fin else txt[debut:]
        lignes = corps.split("\n")
        entrees = []
        for i, ligne in enumerate(lignes):
            em = re.match(
                r"\s*db\s+(\$[0-9A-Fa-f]+|\d+)\s*,\s*(\$[0-9A-Fa-f]+|\d+)"
                r"\s*,\s*(.+?)\s*(?:;.*)?$", ligne)
            if not em:
                continue
            y, x = val(em.group(1)), val(em.group(2))
            routine = ""
            for ligne_suite in lignes[i + 1:i + 5]:
                wm = re.search(r"dbw\s+BANK\([^)]*\)\s*,\s*([A-Za-z0-9_]+)",
                               ligne_suite)
                dm = re.match(r"\s*dw\s+([A-Za-z0-9_]+)", ligne_suite)
                if wm:
                    routine = wm.group(1)
                    break
                if dm:
                    routine = dm.group(1)
                    break
            entrees.append((y, x, em.group(3), routine))
        blocs[label] = entrees
    return blocs

def extraire_sections(txt):
    """(cartes de HiddenObjectMaps, pointeurs dw de HiddenObjectPointers)
    de hidden_objects.asm — les deux listes sont alignées indice à indice."""
    debut = txt.find("HiddenObjectMaps:")
    pivot = txt.find("HiddenObjectPointers:")
    if debut < 0 or pivot < 0:
        return [], []
    cartes = [m.group(1) for m in re.finditer(
        r"^\s*db\s+([A-Z0-9_]+)\s*(?:;.*)?$", txt[debut:pivot], re.M)]
    fin = re.search(r"\n\s*;\s*format\s*:", txt[pivot:], re.I)
    zone = txt[pivot: pivot + fin.start()] if fin else txt[pivot: pivot + 6000]
    pointeurs = [m.group(1) for m in re.finditer(r"^\s*dw\s+([A-Za-z0-9_]+)",
                                                 zone, re.M)]
    return cartes, pointeurs

def collecter_caches(cartes, pointeurs, blocs, items, pieces):
    """{constante de carte: [(type, y, x, detail, routine), ...]} — objets
    cachés ramassables uniquement (routines HiddenItems / HiddenCoins ;
    interactifs exclus, comme par défaut dans mark_hidden_objects.py).
    Le détail (constante d'objet, COIN+n) vient des blocs de
    hidden_objects.asm ; tri final par (y, x) pour la numérotation."""
    details = {}
    for carte, pointeur in zip(cartes, pointeurs):
        for y, x, detail, routine in blocs.get(pointeur, []):
            if routine in ("HiddenItems", "HiddenCoins"):
                details[(carte, y, x)] = (detail, routine)
    par_carte = {}
    for carte, y, x in items:
        detail, routine = details.get((carte, y, x), ("", "HiddenItems"))
        par_carte.setdefault(carte, []).append(
            ("cache_objet", y, x, detail, routine))
    for carte, y, x in pieces:
        detail, routine = details.get((carte, y, x), ("", "HiddenCoins"))
        par_carte.setdefault(carte, []).append(
            ("cache_piece", y, x, detail, routine))
    for liste in par_carte.values():
        liste.sort(key=lambda m: (m[1], m[2]))
    return par_carte

def libelle_cache(detail, routine, ids_items, noms_items, noms_tmhm,
                  icone_objet=None):
    """Libellé de légende d'un objet caché : nom français de l'objet
    (routine HiddenItems) ou « N jetons » (HiddenCoins, COIN+n) ;
    l'objet est précédé de l'icône du jeu de son objet (gfx/items/,
    24x24 ; CT/CS : tm_hm.png — passée par « icone_objet »), groupe
    insécable icône + nom ; les jetons n'ont pas d'icône."""
    detail = (detail or "").strip()
    if routine == "HiddenCoins":
        m = re.match(r"COIN\s*\+\s*(\d+)", detail)
        if m:
            return f"{m.group(1)} jetons"
    elif routine == "HiddenItems":
        nom = nom_item(detail, ids_items, noms_items, noms_tmhm)
        if nom:
            ico = icone_objet(detail) if icone_objet else None
            return [[ico, " " + nom]] if ico is not None else nom
    return detail or LIBELLES["cache_objet"]

def lire_trades(txt):
    """Table TradeMons de data/pokemons/trades.asm : liste indexée des
    échanges in-game, une entrée « db ESPECE_DONNEE, ESPECE_RECUE,
    texte, surnom » par ligne (1re colonne = espèce que le joueur
    donne, 2e = espèce qu'il reçoit ; le texte et le surnom suivent).
    Retourne [(ESPECE_DONNEE, ESPECE_RECUE), ...] indexée par la valeur
    chargée dans wWhichTrade (index direct : le moteur recalcule
    l'octet de base, cf. engine/in_game_trades.asm)."""
    especes = []
    en_table = False
    for ligne in txt.splitlines():
        if re.match(r"^TradeMons:\s*(?:;.*)?$", ligne):
            en_table = True
            continue
        if not en_table:
            continue
        m = re.match(r"^\s*db\s+([A-Za-z0-9_]+)\s*,\s*([A-Za-z0-9_]+)\s*,",
                     ligne.split(";")[0])
        if m:
            especes.append((m.group(1), m.group(2)))
        elif especes:
            break                     # fin de la table (db $FF...)
    return especes

def lire_marts(txt):
    """{label: [const d'objet, ...]} de data/items/mart_inventories.asm :
    les ventes « TX_MART ITEM, ITEM, ... » sont des textes (labels
    Cashier/Clerk) référencés par les tables « XxxTextPointers: » des
    scripts de cartes. Le label est remis à zéro après chaque vente :
    une ligne TX_MART sans label juste au-dessus (vélo d'Azuria — le
    magasin y est un menu scripté) est ignorée."""
    marts = {}
    label = ""
    for ligne in txt.splitlines():
        corps = ligne.split(";")[0]
        m = re.match(r"^\s*([A-Za-z0-9_]+)::?\s*$", corps)
        if m:
            label = m.group(1)
            continue
        m = re.match(r"^\s*TX_MART\s+(.+)$", corps)
        if m and label:
            marts.setdefault(label, [c.strip() for c in m.group(1).split(",")
                                      if c.strip()])
            label = ""
    return marts

def lire_prix(txt):
    """{const d'objet: prix} de data/items/item_prices.asm — les lignes
    « money N ; CONST » donnent le prix de vente (ItemPrices, ordre =
    id d'objet ; on se fie au commentaire de chaque ligne)."""
    prix = {}
    for m in re.finditer(r"^\s*money\s+(\d+)\s*;\s*([A-Za-z0-9_]+)",
                         txt, re.M):
        prix.setdefault(m.group(2), val(m.group(1)))
    return prix

def lire_prix_tm(txt):
    """{const de CT: prix} de data/moves/tm_prices.asm — les prix des CT
    sont des nibbles de milliers (« dn 3, 2 ; TM01_MEGA_PUNCH,
    TM02_RAZOR_WIND » = 3000 et 2000 — TechnicalMachinePrices, moteur
    engine/items/tm_prices.asm)."""
    prix = {}
    for m in re.finditer(r"^\s*dn\s+([0-9A-Fa-f])\s*,\s*([0-9A-Fa-f])\s*"
                         r";\s*([A-Za-z0-9_]+)\s*,\s*([A-Za-z0-9_]+)\s*$",
                         txt, re.M):
        prix.setdefault(m.group(3), val(m.group(1)) * 1000)
        prix.setdefault(m.group(4), val(m.group(2)) * 1000)
    return prix

def prix_de(const, prix_items, prix_tm):
    """Prix de vente d'un objet (None sinon) : item_prices.asm, sinon
    tm_prices.asm pour les CT (nibbles de milliers)."""
    return prix_items.get(const, prix_tm.get(const))

def lire_casino(txt):
    """Trois listes de récompenses du casino, data/items/prizes.asm :
    les paires « dw Entrées, dw Prix » de PrizeDifferentMenuPtrs
    (index 0, 1, 2 — le moteur charge la liste n° = n° de texte - 3),
    chaque entrée = « db CONST » et chaque prix = « coins N » (BCD),
    listes terminées par « db "@" ». Retourne [[(const, jetons), ...],
    ...] ; coût None si la paire est incomplète."""
    blocs = {}                     # label -> [consts ou coûts]
    label = ""
    for ligne in txt.splitlines():
        corps = ligne.split(";")[0]
        m = re.match(r"^\s*([A-Za-z0-9_]+)::?\s*$", corps)
        if m:
            label = m.group(1)
            blocs.setdefault(label, [])
            continue
        m = re.match(r"^\s*db\s+([A-Za-z0-9_]+)\s*$", corps)
        if m and label and m.group(1) != "@":
            blocs[label].append(m.group(1))
            continue
        m = re.match(r"^\s*coins\s+(\$[0-9A-Fa-f]+|\d+)\s*$", corps)
        if m and label:
            blocs[label].append(val(m.group(1)))
    ptrs, en_table = [], False
    for ligne in txt.splitlines():
        corps = ligne.split(";")[0]
        if re.match(r"^\s*PrizeDifferentMenuPtrs:\s*$", corps):
            en_table = True
            continue
        if en_table:
            m = re.match(r"^\s*dw\s+([A-Za-z0-9_]+)\s*$", corps)
            if m:
                ptrs.append(m.group(1))
            elif corps.strip():
                en_table = False
    listes = []
    for i in range(0, len(ptrs) - 1, 2):
        entrees = blocs.get(ptrs[i], [])
        couts = blocs.get(ptrs[i + 1], [])
        listes.append([(e, couts[j] if j < len(couts) and
                        isinstance(couts[j], int) else None)
                       for j, e in enumerate(entrees)])
    return listes

def lire_niveaux_casino(txt):
    """{espèce: niveau} de data/items/prize_mon_levels.asm —
    PrizeMonLevelDictionary, lignes « db ESPECE, N »."""
    niveaux = {}
    for m in re.finditer(r"^\s*db\s+([A-Za-z0-9_]+)\s*,\s*(\d+)\s*$",
                         txt, re.M):
        niveaux.setdefault(m.group(1), val(m.group(2)))
    return niveaux

def charger_pokedollar(chemin):
    """Icône des Pokédollars : pokedollar.png, annexe à placer à côté
    du script — prêt à l'emploi (sur demande utilisateur) : taille
    d'origine, transparence conservée, aucune recoloration ni
    redimensionnement, collée telle quelle après chaque prix.
    Retourne l'Image RGBA, ou None si le fichier est absent (les prix
    s'affichent alors sans icône)."""
    if not chemin.is_file():
        return None
    img = Image.open(chemin)
    img.load()
    return img.convert("RGBA")

def ligne_article(ico, texte, prix, pokedollar=None):
    """Fragments d'une ligne d'article (magasin, casino) : groupe
    insécable [icône + nom] — l'icône n'est jamais séparée du nom —
    puis « : prix » ; prix = chaîne (Pokédollars) collée à l'icône
    pokedollar.png en groupe insécable [prix + icône] (sur demande
    utilisateur ; pokedollar = l'Image, None = repli prix seul),
    liste insécable (ex. « N jetons », comme « N captures » — unités
    du casino, sans icône) ou None (prix inconnu, nom seul)."""
    debut = [ico, " " + texte] if ico is not None else texte
    if prix is None:
        return [debut]
    if isinstance(prix, list):
        return [debut, " : ", prix]
    if pokedollar is not None:
        return [debut, " : ", [prix, pokedollar]]
    return [debut, " : " + prix]

def dons_dans(txt):
    """Dons et échanges d'un script de carte, indexés par n° de texte :
    ({n° texte: « ESPECE/niveau »}, {n° texte: « CONST_OBJET »},
    {n° texte: « CONST_OBJET/seuil »}, {n° texte: index TradeMons}).

    Un don est un « lb bc, X, N » suivi de près (<= 3 lignes) de
    « call|predef GivePokemon » (Pokémon, ex. EEVEE 25 à Céladon, LAPRAS
    40 au 7F de Sylphe) ou « call|predef GiveItem » (objet, ex. les
    fossiles du Mont Sélénite) ; il est rattaché au label englobant
    (« Texte: ») le plus proche, dont le n° de texte (1-based) vient de
    la table « XxxTextPointers: » du script. Les récompenses de captures
    des assistants de Chen (« predef OaksAideScript ») sont détectées
    par « ld a, N » + « ld [hOaksAideRequirement], a » puis « ld a,
    OBJET » + « ld [hOaksAideRewardItem], a » (Route11Gate2F : 30
    captures -> ITEMFINDER ; Route15Gate2F : 50 -> EXP_ALL) ; le seuil
    réduit du mode Nuzlocke est ignoré (le premier lu gagne). Les PNJ
    d'échange in-game (« predef DoInGameTradeDialogue ») sont détectés
    par « ld [wWhichTrade], a » : la valeur, chargée juste au-dessus
    par « ld a, N » ou « xor a » (= 0), est l'index dans TradeMons
    (data/pokemons/trades.asm) ; le predef peut être plus loin ou
    déplacé dans un label partagé (CinnabarLabTradeRoom), on n'exige
    donc pas sa proximité."""
    numeros = {}            # label de texte -> n° (tables XxxTextPointers)
    en_table, rang = False, 0
    for ligne in txt.splitlines():
        if re.match(r"^[A-Za-z0-9_]+TextPointers:\s*(?:;.*)?$", ligne):
            en_table, rang = True, 0
            continue
        if en_table:
            m = re.match(r"^\s*dw\s+([A-Za-z0-9_]+)\s*(?:;.*)?$", ligne)
            if m:
                rang += 1
                numeros.setdefault(m.group(1), rang)
            elif ligne.strip():
                en_table = False
    pkmn, objets, recompenses, echanges = {}, {}, {}, {}  # label -> détail
    seuils = {}              # label de texte -> seuil de captures
    lignes = txt.splitlines()
    label = ""
    for i, ligne in enumerate(lignes):
        m = re.match(r"^([A-Za-z0-9_]+):\s*(?:;.*)?$", ligne)
        if m:
            label = m.group(1)
            continue
        corps = ligne.split(";")[0]
        m = re.match(r"\s*lb\s+bc\s*,\s*([A-Za-z0-9_]+)\s*,"
                     r"\s*(\$[0-9A-Fa-f]+|\d+)\s*$", corps)
        if m:
            fenetre = "\n".join(lignes[i + 1:i + 4])
            if re.search(r"^\s*(?:call|predef)\s+GivePokemon\b",
                         fenetre, re.M):
                pkmn.setdefault(label, f"{m.group(1)}/{val(m.group(2))}")
            elif re.search(r"^\s*(?:call|predef)\s+GiveItem\b",
                           fenetre, re.M):
                objets.setdefault(label, m.group(1))
            continue
        # récompense de captures (predef OaksAideScript) : seuil puis objet
        fenetre = "\n".join(lignes[i + 1:i + 3])
        m = re.match(r"\s*ld\s+a\s*,\s*(\$[0-9A-Fa-f]+|\d+)\s*$", corps)
        if m and re.search(r"^\s*ld\s+\[hOaksAideRequirement\]",
                           fenetre, re.M):
            seuils.setdefault(label, val(m.group(1)))
            continue
        m = re.match(r"\s*ld\s+a\s*,\s*([A-Za-z0-9_]+)\s*$", corps)
        if m and re.search(r"^\s*ld\s+\[hOaksAideRewardItem\]",
                           fenetre, re.M):
            recompenses.setdefault(
                label, f"{m.group(1)}/{seuils.get(label, '')}")
            continue
        # PNJ d'échange in-game (predef DoInGameTradeDialogue) : index
        # TradeMons chargé dans wWhichTrade par « ld a, N » (ou
        # « xor a » = 0) juste au-dessus
        if re.match(r"\s*ld\s+\[wWhichTrade\]\s*,\s*a\s*$", corps):
            for j in (i - 1, i - 2):
                if j < 0:
                    break
                prev = lignes[j].split(";")[0]
                if re.match(r"\s*xor\s+a\s*$", prev):
                    echanges.setdefault(label, 0)
                    break
                m = re.match(r"\s*ld\s+a\s*,\s*(\$[0-9A-Fa-f]+|\d+)\s*$",
                             prev)
                if m:
                    echanges.setdefault(label, val(m.group(1)))
                    break
    return ({numeros[l]: d for l, d in pkmn.items() if l in numeros},
            {numeros[l]: d for l, d in objets.items() if l in numeros},
            {numeros[l]: d for l, d in recompenses.items()
             if l in numeros},
            {numeros[l]: d for l, d in echanges.items() if l in numeros})

def magasins_dans(txt, marts):
    """{n° de texte: [const d'objet, ...]} — ventes TX_MART d'une carte :
    un « dw » de la table « XxxTextPointers: » pointant sur un label de
    mart_inventories.asm fait du PNJ portant ce n° de texte le vendeur.
    Prend en compte le décalage « XxxTextPointers + $N » (Jadielle :
    après le colis de Chen la table démarre N/2 entrées plus loin — la
    vente de l'entrée 6 est atteinte par le texte 1) : chaque vente est
    acceptée à son rang direct ET à son rang moins le décalage."""
    numeros = {}            # label de vente -> n° dans TextPointers
    en_table, rang = False, 0
    for ligne in txt.splitlines():
        if re.match(r"^[A-Za-z0-9_]+TextPointers:\s*(?:;.*)?$", ligne):
            en_table, rang = True, 0
            continue
        if en_table:
            m = re.match(r"^\s*dw\s+([A-Za-z0-9_]+)\s*(?:;.*)?$", ligne)
            if m:
                rang += 1
                if m.group(1) in marts:
                    numeros.setdefault(m.group(1), rang)
            elif ligne.strip():
                en_table = False
    decalage = 0
    m = re.search(r"TextPointers\s*\+\s*(\$[0-9A-Fa-f]+|\d+)\b", txt)
    if m:
        decalage = val(m.group(1)) // 2          # dw = 2 octets
    ventes = {}
    for label, rang in numeros.items():
        for tid in (rang, rang - decalage):
            if tid >= 1:
                ventes.setdefault(tid, marts[label])
    return ventes

def casinos_dans(txt):
    """Liste triée des n° de texte des panneaux-vente du casino : un
    texte dont le corps est « TX_PRIZE_VENDOR » ; plusieurs dw peuvent
    pointer sur le même texte (salle des prix : les rangs 3, 4 et 5
    désignent les listes 0, 1 et 2 de data/items/prizes.asm — le
    moteur charge la liste n° = n° de texte - 3)."""
    rangs = {}               # label de texte -> [n° dans TextPointers]
    vendeurs = set()         # labels des textes « TX_PRIZE_VENDOR »
    en_table, rang, label = False, 0, ""
    for ligne in txt.splitlines():
        if re.match(r"^[A-Za-z0-9_]+TextPointers:\s*(?:;.*)?$", ligne):
            en_table, rang = True, 0
            continue
        if en_table:
            m = re.match(r"^\s*dw\s+([A-Za-z0-9_]+)\s*(?:;.*)?$", ligne)
            if m:
                rang += 1
                rangs.setdefault(m.group(1), []).append(rang)
            elif ligne.strip():
                en_table = False
        corps = ligne.split(";")[0]
        m = re.match(r"^\s*([A-Za-z0-9_]+)::?\s*$", corps)
        if m:
            label = m.group(1)
            continue
        if re.match(r"^\s*TX_PRIZE_VENDOR\s*$", corps):
            vendeurs.add(label)
    return sorted(r for l in vendeurs for r in rangs.get(l, []))

def libelle_objet(type_o, detail, classes_dresseurs, noms_dresseurs,
                  ids_items, noms_items, noms_tmhm, ids_pokemon, noms_pokemon,
                  icone=None, icone_objet=None):
    """Libellé de la légende d'un objet numéroté.

    dresseur -> nom français de la classe (TrainerNames, indexé par la
               constante OPP_* de l'objet) suivi du n° de dresseur de
               l'objet (« #n », ex. « Rival1 #1 ») ; récompense(s) de
               victoire (DONS_OBJETS_MANUELS : détail « OPP_X n |
               ITEM[,ITEM] », ajoutées par la boucle des cartes) ->
               le nom garde sa ligne, puis les récompenses sur la
               ligne suivante (frags_recompense : SAUT + « [icône]
               Objet... ») ;
               objet et
               objet_offert -> nom français de l'objet (ItemNames,
               tmhmNames ; objet_offert = don d'objet, section
               « Récompenses ») précédé de l'icône du jeu de l'objet
               (gfx/items/, 24x24 ; CT/CS : tm_hm.png — passée par
               « icone_objet »), l'icône et le nom formant un groupe
               insécable comme pour les Pokémon ;
               pokemon -> nom français
               de l'espèce (MonsterNames) suivi du niveau (« n.12 ») ;
               pokemon_offert (SPRITE_POKEBALL) -> détail « ESPECE/niveau »
               lu dans le script de la carte, précédé de l'icône de
               l'espèce (icône du jeu — gfx/pokemon/icons/, 16x16 du
               haut, repli sprite overworld — passée par « icone »),
               l'icône et « Nom n.niveau » formant un groupe
               insécable ; « Pokémon » si introuvable ;
               recompense -> détail « ITEM/seuil » lu dans le script de
               la carte (assistant de Chen) : nom français de l'objet
               précédé de son icône (icône_objet), puis « : N
               captures », ex. « [icône] Cherch'Objet : 30
               captures » — le « N captures » est un groupe insécable
               (fragment liste) : le retour à la ligne ne sépare jamais
               le nombre de son unité, comme l'icône et le nom des
               échanges ; pnj_libelle -> fonction d'un PNJ
               (LIBELLES_PNJ_MANUELS : Renameur, effaceur de
               capacités...) : libellé libre de la config, tel quel —
               « Personnage » si vide. icone = appelable espece ->
               Image, icone_objet = appelable const d'objet -> Image
               (None pour des libellés sans icône)."""

    def frags_recompense(texte, recompenses):
        """Fragments d'une rencontre avec récompense(s) de victoire
        (DONS_OBJETS_MANUELS, collées au détail après « | », objets
        séparés par « , ») : le nom de la rencontre garde sa ligne,
        puis SAUT et les récompenses sur une nouvelle ligne — chaque
        objet un groupe insécable [icône + nom FR], séparés par une
        espace, repli nom seul."""
        frags = [texte, SAUT]
        for k, r in enumerate([x for x in recompenses.split(",") if x]):
            if k:
                frags.append(" ")
            ico = icone_objet(r) if icone_objet else None
            nom_r = nom_item(r, ids_items, noms_items, noms_tmhm) or r
            frags.append([ico, " " + nom_r] if ico is not None else nom_r)
        return frags

    if type_o == "dresseur":
        base, _, recompenses = (detail or "").partition("|")
        parties = base.split()
        opp = parties[0] if parties else ""
        idx = classes_dresseurs.get(opp)
        if idx and 1 <= idx <= len(noms_dresseurs):
            nom = noms_dresseurs[idx - 1]
        else:
            nom = opp or LIBELLES["dresseur"]
        texte = f"{nom} #{parties[1]}" if len(parties) > 1 else nom
        return frags_recompense(texte, recompenses) if recompenses else texte
    if type_o == "objet" or type_o == "objet_offert":
        nom = nom_item(detail, ids_items, noms_items, noms_tmhm) or detail \
            or LIBELLES[type_o]
        ico = icone_objet(detail) if (icone_objet and detail) else None
        # icône + « nom » : groupe insécable, même mécanisme que les
        # Pokémon offerts (l'icône suit toujours son nom)
        return [[ico, " " + nom]] if ico is not None else nom
    if type_o == "pokemon":
        base, _, recompenses = (detail or "").partition("|")
        espece, _, niveau = base.partition("/")
        nom = nom_espece(espece, ids_pokemon, noms_pokemon) or espece \
            or LIBELLES["pokemon"]
        texte = f"{nom} n.{niveau}" if niveau else nom
        return frags_recompense(texte, recompenses) if recompenses else texte
    if type_o == "pokemon_offert":   # SPRITE_POKEBALL : détail « ESPECE/niveau »
        espece, _, niveau = (detail or "").partition("/")  # lu dans le
        if not espece:                                     # script de la carte
            return LIBELLES["pokemon_offert"]
        nom = nom_espece(espece, ids_pokemon, noms_pokemon) or espece
        texte = f"{nom} n.{niveau}" if niveau else nom
        ico = icone(espece) if icone else None
        # icône + « Nom n.niveau » : groupe insécable, même mécanisme
        # que les échanges (l'icône suit toujours son nom)
        return [[ico, " " + texte]] if ico is not None else texte
    if type_o == "recompense":   # assistant de Chen : détail
        item, _, seuil = (detail or "").partition("/")  # « ITEM/seuil »
        if not item:
            return LIBELLES["recompense"]
        nom = nom_item(item, ids_items, noms_items, noms_tmhm) or item
        ico = icone_objet(item) if icone_objet else None
        if ico is not None:
            # icône + « nom : » insécables (le « : » ne se retrouve
            # jamais seul en début de ligne), « N captures » insécable
            return ([[ico, f" {nom} : "], [f"{seuil} captures"]]
                    if seuil else [[ico, " " + nom]])
        if not seuil:
            return nom
        # « N captures » en groupe insécable : le retour à la ligne ne
        # sépare jamais le nombre de son unité (même mécanisme que
        # l'icône + nom des échanges)
        return [nom + " : ", [f"{seuil} captures"]]
    if type_o == "pnj_libelle":   # fonction d'un PNJ (Renameur,
        return detail or LIBELLES["pnj_libelle"]  # effaceur...) : texte libre
    return detail or ""

def trouver_png(dossier, stem):
    """Capture d'une carte, exacte puis insensible à la casse (None sinon)."""
    p = dossier / (stem + ".png")
    if p.is_file():
        return p
    cible = (stem + ".png").lower()
    for q in dossier.glob("*.png"):
        if q.name.lower() == cible:
            return q
    return None

# Noms réservés par Windows (périphériques) — un fichier portant un de ces
# noms (avec ou sans extension) ne peut pas être créé normalement.
NOMS_RESERVES = {"CON", "PRN", "AUX", "NUL",
                 *(f"COM{i}" for i in range(1, 10)),
                 *(f"LPT{i}" for i in range(1, 10))}

def assainir_nom(nom):
    """Nom de fichier sûr : retire les caractères invisibles (contrôle,
    formatage, surrogates...) et interdits (<>:"/\\|?*), les espaces et
    points finaux, et préfixe les noms réservés de Windows (CON, NUL...)."""
    propre = "".join(c for c in nom
                     if unicodedata.category(c) not in ("Cc", "Cf", "Cs",
                                                        "Co", "Cn"))
    for c in '<>:"/\\|?*':
        propre = propre.replace(c, "_")
    propre = propre.strip(" .")
    stem = propre.rsplit(".", 1)[0] if "." in propre else propre
    if stem.upper() in NOMS_RESERVES:
        propre = "_" + propre
    return propre

def sauver(img, dossier, nom):
    """Enregistre l'image dans dossier/nom ; en cas d'échec (fichier
    verrouillé par l'Explorateur Windows ou un lecteur d'images — verrou
    souvent transitoire, d'où les tentatives espacées —, caractère
    invisible, nom réservé, bug d'encodage de Pillow...), retente à trois
    reprises, avec un nom nettoyé, puis via un tampon mémoire écrit à la
    main. Retourne le nom écrit, sinon None."""
    essais = [("direct", dossier / nom)]
    propre = assainir_nom(nom)
    if propre and propre != nom:
        essais.append(("nom nettoyé", dossier / propre))
    echecs = []
    for etiquette, chemin in essais:
        derniere = None
        for attente in (0, 0.5, 1.0):  # laisse partir un verrou transitoire
            if attente:
                time.sleep(attente)
            try:
                img.save(chemin)
                if etiquette != "direct":
                    print(f"i {nom!r} : sauvegardé via le nom {chemin.name!r}.")
                return chemin.name
            except OSError as e:
                derniere = e
        echecs.append((etiquette, derniere))
    # Repli : encoder le PNG en mémoire puis l'écrire à la main — isole un
    # problème d'encodeur (Pillow) d'un problème de système de fichiers,
    # et reformule l'erreur Windows réelle (code winerror).
    try:
        tampon = io.BytesIO()
        img.save(tampon, format="PNG")
        for etiquette, chemin in essais:
            try:
                with open(chemin, "wb") as sortie:
                    sortie.write(tampon.getvalue())
                if etiquette != "direct":
                    print(f"i {nom!r} : sauvegardé par écriture directe "
                          f"des octets, nom {chemin.name!r}.")
                return chemin.name
            except OSError as e:
                echecs.append((f"écriture octets ({etiquette})", e))
    except OSError as e:
        echecs.append(("encodage PNG en mémoire", e))
    detail = " ; ".join(f"{t} → winerror={getattr(e, 'winerror', '?')} {e}"
                       for t, e in echecs)
    print(f"!! Impossible d'enregistrer {nom!r} dans {dossier} : {detail}")
    print(f"   image {img.mode} {img.size[0]}x{img.size[1]} px.")
    print("   (Fichier affiché dans une visionneuse ou dossier ouvert dans")
    print("    l'Explorateur Windows ? Fermez-le et relancez le script.)")
    return None

# -------------------------------------------------------------------- légende

_POLICES = {}

def police(taille):
    if taille not in _POLICES:
        try:
            _POLICES[taille] = ImageFont.load_default(size=taille)
        except TypeError:  # Pillow < 10.1
            _POLICES[taille] = ImageFont.load_default()
    return _POLICES[taille]

_POLICE_LEGENDE = None

def police_legende(taille=15):
    """Police de la légende : TTF (accents gérés) sinon police par défaut.

    Retourne (police, translitterer) : translitterer=True signifie qu'aucune
    police TTF n'a été trouvée et qu'il faut convertir les accents en ASCII
    pour éviter les caractères cassés.
    """
    global _POLICE_LEGENDE
    if _POLICE_LEGENDE is None:
        for nom in CANDIDATS_TTF:
            try:
                _POLICE_LEGENDE = (ImageFont.truetype(nom, taille), False)
                break
            except OSError:
                continue
        else:
            _POLICE_LEGENDE = (police(taille), True)
    return _POLICE_LEGENDE

def charger_chiffres(chemin):
    """Découpe numbers.png — chiffres 0 à 9 en rangée sur fond transparent,
    déjà détourés — en images individuelles, collées telles quelles.

    Les colonnes entièrement transparentes servent de séparateurs ; la
    boîte alpha de chaque segment donne le cadrage exact du chiffre.
    Retourne {chiffre: Image RGBA} (10 entrées), sinon None (fichier
    absent ou inattendu)."""
    if not chemin.is_file():
        return None
    src = Image.open(chemin).convert("RGBA")
    alpha = src.getchannel("A")
    w, h = src.size
    px = alpha.load()
    occupe = [any(px[x, y] for y in range(h)) for x in range(w)]
    segments, debut = [], None
    for x, plein in enumerate(occupe):          # plages de colonnes occupées
        if plein and debut is None:
            debut = x
        elif not plein and debut is not None:
            segments.append((debut, x))
            debut = None
    if debut is not None:
        segments.append((debut, w))
    if len(segments) != 10:                     # repli : 10 parts égales
        segments = [(round(i * w / 10), round((i + 1) * w / 10))
                    for i in range(10)]
    chiffres = {}
    for chiffre, (x0, x1) in enumerate(segments):
        boite = alpha.crop((x0, 0, x1, h)).getbbox()
        if boite is None:
            continue
        chiffres[chiffre] = src.crop((x0 + boite[0], boite[1],
                                     x0 + boite[2], boite[3]))
    return chiffres if len(chiffres) == 10 else None

def coller_numero(dest, px, py, cote, numero, chiffres):
    """Colle un numéro en bas à droite d'une case (px, py, cote), avec les
    chiffres de numbers.png collés tels quels (détourés, transparents,
    taille d'origine) : le coin en bas à droite du numéro est posé sur le
    coin en bas à droite de la case, le plus près possible du bord."""
    morceaux = [chiffres[int(c)] for c in str(numero)]
    total = sum(m.width for m in morceaux)
    x = px + cote - total
    for m in morceaux:                           # bas de chaque chiffre au
        dest.paste(m, (x, py + cote - m.height), m)   # bord bas de la case
        x += m.width

def dessiner_badge(dest, draw, cx, cy, rayon, couleur, numero, chiffres,
                   font):
    """Badge des objets cachés : disque d'une tuile de diamètre, contour
    noir, numéro composé avec les chiffres de numbers.png collés tels
    quels et centrés sur le disque — repli : numéro blanc en police
    Pillow si la planche de chiffres est absente."""
    draw.ellipse([cx - rayon, cy - rayon, cx + rayon, cy + rayon],
                 fill=couleur, outline=(0, 0, 0, 255), width=1)
    if chiffres:
        morceaux = [chiffres[int(c)] for c in str(numero)]
        total = sum(m.width for m in morceaux)
        x = cx - total // 2
        for m in morceaux:                     # chiffres centrés sur le
            dest.paste(m, (x, cy - m.height // 2), m)   # centre du disque
            x += m.width
        return
    bbox = draw.textbbox((0, 0), str(numero), font=font)
    w, h = bbox[2] - bbox[0], bbox[3] - bbox[1]
    draw.text((cx - w / 2 - bbox[0], cy - h / 2 - bbox[1]), str(numero),
              fill=(255, 255, 255, 255), font=font)

# Saut de ligne explicite dans un libellé (fragment str « \\n ») : force
# le retour à la ligne dans la légende — le libellé d'un magasin liste
# un objet en vente par ligne.
SAUT = "\n"

def fragments(libelle):
    """Libellé normalisé en liste de fragments « str | Image » (une
    chaîne simple devient un fragment unique) ; une sous-liste est un
    groupe insécable : ses fragments sont dessinés à la suite et le
    retour à la ligne ne le coupe jamais (ex. une icône d'espèce
    collée à son nom dans la légende des échanges) ; le fragment SAUT
    force un retour à la ligne (un objet par ligne dans un magasin)."""
    if isinstance(libelle, (list, tuple)):
        return list(libelle)
    return [libelle]

def sans_accents(frags):
    """Translittère les fragments str, récursivement (repli sans police
    TTF) — les images et les groupes insécables (listes) sont parcourus."""
    return [f.translate(TRANSLIT) if isinstance(f, str) else
            sans_accents(f) if isinstance(f, list) else f
            for f in frags]

def largeur_fragments(frags, mesure, font):
    """Largeur en px d'une ligne de fragments (str | Image | liste
    insécable)."""
    return sum(mesure.textlength(f, font=font) if isinstance(f, str)
               else largeur_fragments(f, mesure, font)
               if isinstance(f, list) else f.width for f in frags)

def couper_libelle(frags, largeur_max, mesure, font):
    """Coupe des fragments (str | Image | liste insécable) en sous-lignes
    d'au plus largeur_max px : retour à la ligne aux espaces, une Image
    ou un groupe insécable n'est jamais coupé — sauf groupe plus
    large qu'une ligne (icône d'objet 24x24 + nom long sur une capture
    étroite) : décomposé pour ne pas déborder du bord droit, l'icône
    ouvre une nouvelle ligne avec le premier mot du nom (toujours
    insécables) et le reste du nom s'enroule mot à mot ; le fragment
    SAUT force un retour à la ligne (liste des objets d'un magasin) ;
    les espaces
    de début et de fin de ligne sont retirés.

    Un fragment mot plus large que largeur_max reste seul sur sa ligne
    (débordement inévitable sans coupure au milieu d'un mot)."""
    jetons = []
    for f in frags:                     # mots, espaces, images, groupes
        if isinstance(f, str) and f == SAUT:
            jetons.append(SAUT)         # retour à la ligne forcé
        elif isinstance(f, str):
            jetons.extend(re.findall(r"\s+|\S+", f))
        elif (not isinstance(f, list)
              or largeur_fragments(f, mesure, font) <= largeur_max):
            jetons.append(f)            # image ou groupe qui tient sur
                                        # une ligne : jamais coupé
        else:
            # groupe plus large qu'une ligne : décomposition minimale —
            # les mots de tête (repli « n° » du vendeur sans planche de
            # chiffres), l'icône et le premier mot du nom restent
            # insécables en tête d'une nouvelle ligne, le reste s'enroule
            sous = []
            for g in f:
                if isinstance(g, str):
                    sous.extend(re.findall(r"\s+|\S+", g))
                else:
                    sous.append(g)
            i_img = next((k for k, g in enumerate(sous)
                          if isinstance(g, Image.Image)), None)
            i_mot = 0
            if i_img is None:
                # groupe sans icône : le premier mot ouvre la ligne
                while i_mot < len(sous) and not (isinstance(sous[i_mot], str)
                                                 and sous[i_mot].strip()):
                    i_mot += 1
            else:
                i_mot = i_img + 1       # l'icône (et espaces) d'abord
                while i_mot < len(sous) and not (isinstance(sous[i_mot], str)
                                                 and sous[i_mot].strip()):
                    i_mot += 1
            i_mot += 1                  # puis le premier mot du nom
            tete = sous[:i_mot]
            if largeur_fragments(tete, mesure, font) <= largeur_max:
                jetons.append(SAUT)      # l'icône mène une nouvelle ligne
                jetons.append(tete)
                jetons.extend(sous[i_mot:])
            else:
                # même la tête déborde (mot unique très long) : jetons
                # libres, chacun reste seul sur sa ligne
                jetons.extend(sous)
    sous, courant, larg = [], [], 0
    for j in jetons:
        if j == SAUT:                   # fin de ligne forcée
            while courant and isinstance(courant[-1], str) \
                    and not courant[-1].strip():
                courant.pop()
            if courant:
                sous.append(courant)
            courant, larg = [], 0
            continue
        if isinstance(j, str) and not j.strip():
            if courant:                 # espace conservé en cours de ligne
                courant.append(j)
                larg += mesure.textlength(j, font=font)
            continue
        w = (mesure.textlength(j, font=font) if isinstance(j, str)
             else largeur_fragments(j, mesure, font)
             if isinstance(j, list) else j.width)   # Image seule : jamais
                                                    # coupée, largeur directe
        if courant and larg + w > largeur_max:
            while courant and isinstance(courant[-1], str) \
                    and not courant[-1].strip():
                courant.pop()           # espaces de fin de ligne retirés
            sous.append(courant)
            courant, larg = [], 0
        courant.append(j)
        larg += w
    if courant:
        while courant and isinstance(courant[-1], str) \
                and not courant[-1].strip():
            courant.pop()
        sous.append(courant)
    return sous or [[]]

def ajouter_legende(img, entrees, taille, chiffres):
    """Ajoute sous l'image un bandeau blanc organisé en sept sections.

    entrees = [(numero, libelle, sprite, categorie, badge), ...] avec
    « Rencontres » (dresseurs, rencontres statiques), « Objets » (objets
    ramassables, y compris ceux marqués par coordonnées sans sprite,
    qui reçoivent la vignette SPRITE_BALL),
    « Récompenses » (dons des PNJ : Pokémons offerts, objets donnés,
    récompenses de captures des assistants de Chen), « Echanges » (PNJ
    d'échange in-game), « Personnage » (PNJ à fonction :
    LIBELLES_PNJ_MANUELS, libellé libre), « Magasin » (vendeurs : ligne
    dédiée « [icône du vendeur] Vendeur » puis un objet en vente par
    ligne avec son prix, sans vignette latérale ; panneaux du casino :
    badge or en vignette, une récompense en jetons par ligne ; jamais
    deux vendeurs côte à côte) puis « Objets
    cachés » (objets cachés, pièces) ; chaque titre (« Rencontres : »,
    « Objets : », « Récompenses : », « Echanges : », « Personnage : »,
    « Magasin : », « Objets cachés : ») est aligné en haut à gauche,
    au-dessus des objets de sa section. Chaque entrée reprend exactement
    le rendu de la carte : vignette du sprite à sa taille d'origine
    (aucun redimensionnement), surélevé comme sur l'image, avec le
    numéro (chiffres de numbers.png) en bas à droite de la case — ou,
    pour les objets cachés (badge = couleur RGBA), le badge de la
    carte : disque rouge ou or à contour noir, numéro de numbers.png
    centré sur le disque (numéro blanc en police Pillow si la planche
    est absente), en vignette à la même taille que celle des sprites ;
    puis le libellé en noir (dresseur : nom FR puis « #n° de
    dresseur », ex. « Rival1 #1 » ; objet : icône du jeu de l'objet
    (gfx/items/, 24x24 ; CT/CS : tm_hm.png ; repli nom seul) + nom FR,
    insécables — plusieurs objets au
    même endroit séparés par « , » ; rencontre statique :
    nom FR et niveau ; récompense : icône de l'objet puis nom FR et
    « : N captures » ; Pokémon offert : icône de l'espèce puis nom FR
    et niveau (icône et nom insécables) ; échange : fragments
    str | Image — icônes d'espèces et « Nom reçu contre Nom donné » ;
    magasin : première ligne dédiée « [icône du vendeur] Vendeur »
    (icône SPRITE_MART_GUY, surélevée comme sur la carte, numéro en
    bas à droite de sa case — écrit en tête si la planche de chiffres
    manque ; icône et mot insécables) puis un objet en vente par
    ligne « [icône de l'objet] Nom FR : prix » (repli SPRITE_BALL
    si le PNG manque) ; casino : badge or en
    vignette, une récompense par ligne « [icône] Nom FR : N jetons »
    (Pokémon : icône d'espèce + niveau ; CT/objets : icône de
    l'objet) ; objet caché : icône de l'objet + nom FR ou « N jetons »).
    La bande s'élargit au-delà de la capture pour que CHAQUE ligne de
    TOUTES les sections — vendeur puis un article par ligne pour les
    magasins, casino et distributeurs (une ligne par SAUT), libellé
    entier pour les autres entrées — tienne entière sans retour à la
    ligne automatique (v28 : section « Magasin » seulement, la liste
    des articles d'un magasin de base étant illisible ; v37, sur
    demande utilisateur : toutes les sections) ; l'excédent de largeur
    se place autour de la capture sur fond noir, l'image reste centrée
    horizontalement. Un libellé plus large que la largeur disponible
    passe à la
    ligne (coupure aux espaces ; les images et les groupes insécables
    — icône collée à son nom, « N captures » — ne sont jamais coupés,
    sauf groupe plus large qu'une ligne : l'icône ouvre alors une
    nouvelle ligne avec le premier mot du nom et le reste s'enroule —
    jamais de débordement du bord droit)
    : l'entrée occupe
    alors plusieurs lignes, la vignette reste seule et les lignes
    suivantes s'alignent sur le texte. Sans sprite disponible ou sans
    planche de chiffres, le numéro est écrit en tête du libellé
    (jamais pour les badges, qui portent leur numéro). Dans chaque
    section, les entrées sont réparties en colonnes alignées : toutes
    celles d'une même colonne démarrent au même x (largeur de colonne =
    entrée la plus large) ; accents translittérés si aucune police TTF
    n'est disponible.
    """
    if not entrees:
        return img
    font, translitterer = police_legende()
    marge, ligne_h = 6, 26
    cote_v = taille                      # vignettes à la taille du jeu
    decalage = max(1, taille // 4)       # même surélévation que sur l'image
    noir = (0, 0, 0, 255)
    rayon_b = max(3, taille // 2 - 1)                # badge : mêmes
    font_b = police(max(8, round(taille * 0.55)))    # tailles que la carte
    # libellés en fragments (str | Image | liste insécable), accents
    # retirés sans police TTF
    normalisees = []
    for n, t, s, c, b in entrees:
        frags = fragments(t)
        if translitterer:
            frags = sans_accents(frags)
        normalisees.append((n, frags, s, c, b))
    entrees = normalisees
    mesure = ImageDraw.Draw(Image.new("RGBA", (1, 1)))
    dispo = img.width - 2 * marge        # largeur disponible pour une entrée

    # regroupement par catégorie, dans l'ordre d'affichage demandé
    sections = {}
    for num, frags, sprite, cat, badge in entrees:
        sections.setdefault(cat, []).append((num, frags, sprite, badge))
    ordre = [c for c in ("Rencontres", "Objets", "Récompenses", "Echanges",
                         "Personnage", "Magasin", "Objets cachés")
             if c in sections]
    ordre += [c for c in sections if c not in ordre]

    # préparation des entrées : vignette (badge ou sprite surélevé
    # avec son numéro) et préfixe, avant de connaître la largeur
    # finale de la légende
    prepa = {}
    for cat in ordre:
        items = []
        for num, frags, sprite, badge in sorted(sections[cat],
                                               key=lambda e: e[0]):
            vignette, prefixe = None, 0
            if badge is not None:
                # badge d'objet caché : même rendu que sur la carte
                # (chiffres de numbers.png), vignette à la même taille
                # que celle des sprites
                vignette = Image.new("RGBA", (cote_v, cote_v + decalage),
                                     (0, 0, 0, 0))
                dessiner_badge(vignette, ImageDraw.Draw(vignette),
                               cote_v // 2, cote_v // 2, rayon_b, badge,
                               num, chiffres, font_b)
                prefixe = cote_v + 4
            elif sprite is not None:
                # case transparente : sprite surélevé comme sur la carte,
                # le numéro en bas à droite de la case — aucun
                # redimensionnement du sprite
                vignette = Image.new("RGBA", (cote_v, cote_v + decalage),
                                     (0, 0, 0, 0))
                vignette.paste(sprite, (0, 0), sprite)
                if chiffres:
                    coller_numero(vignette, 0, decalage, cote_v, num,
                                   chiffres)
                prefixe = cote_v + 4
            # repli : numéro écrit — sauf magasin, dont le numéro est
            # porté par l'icône du vendeur (première ligne du libellé)
            if (badge is None and (vignette is None or not chiffres)
                    and cat != "Magasin"):
                frags = [f"{num} "] + frags
            items.append((vignette, prefixe, frags))
        prepa[cat] = items

    # élargissement de la légende (v28, sur demande utilisateur : la
    # liste des articles d'un magasin de base était illisible ;
    # v37, sur demande utilisateur : chaque objet tient TOUJOURS en
    # une seule ligne) : la bande s'agrandit pour que la plus large
    # des lignes de TOUTES les sections (une ligne par SAUT — vendeur,
    # puis un objet en vente par ligne pour les magasins, casino et
    # distributeurs ; libellé entier pour les autres sections) tienne
    # entière sans retour à la ligne automatique ; l'excédent de
    # largeur se place autour de la capture sur fond noir, l'image
    # reste centrée horizontalement.
    besoin = 0
    for cat_e in ordre:
        for vignette, prefixe, frags in prepa[cat_e]:
            seg, segs = [], []
            for f in frags:
                if f == SAUT:              # fin de ligne (vendeur, etc.)
                    segs.append(seg)
                    seg = []
                else:
                    seg.append(f)
            segs.append(seg)
            besoin = max(besoin, prefixe + max(largeur_fragments(s, mesure,
                                                                 font)
                                               for s in segs))
    dispo = max(dispo, round(besoin))  # textlength renvoie un flottant :
                                       # largeur finale en entiers
    largeur_finale = 2 * marge + dispo # légende plus large que la
                                       # capture si nécessaire

    blocs = []                           # [(titre, lignes, largeurs), ...]
    for cat in ordre:
        colonnes = []
        for vignette, prefixe, frags in prepa[cat]:
            # retour à la ligne si le libellé dépasse la largeur
            # disponible — élargie ci-dessus : les lignes des vendeurs
            # ne s'enroulent plus (coupure aux espaces, images
            # insécables)
            sous = couper_libelle(frags, max(1, dispo - prefixe),
                                  mesure, font)
            largeur = prefixe + max(largeur_fragments(l, mesure, font)
                                    for l in sous) + 18
            colonnes.append((vignette, sous, prefixe, largeur))
        # mise en page en colonnes alignées : on cherche le plus grand
        # nombre de colonnes qui tient dans la largeur de l'image
        # (remplissage par lignes de k entrées) ; toutes les entrées d'une
        # même colonne démarrent au même x, à gauche de la colonne.
        # Les vendeurs (magasin, casino) ne sont JAMAIS mis côte à
        # côte : un par ligne, même si la place suffirait (leurs
        # libellés font plusieurs lignes)
        total = len(colonnes)
        k = 1 if cat == "Magasin" else total
        while k > 1:
            essai = [colonnes[i * k:(i + 1) * k]
                     for i in range((total + k - 1) // k)]
            largeurs = [max((l[j][3] for l in essai if j < len(l)), default=0)
                        for j in range(k)]
            if sum(largeurs) <= dispo:
                break
            k -= 1
        lignes = [colonnes[i * k:(i + 1) * k]
                  for i in range((total + k - 1) // k)]
        largeurs = [max((l[j][3] for l in lignes if j < len(l)), default=0)
                    for j in range(k)]
        blocs.append((cat + " :", lignes, largeurs))

    # une ligne de titre par section + au moins une ligne par rangée
    # d'entrées (plus si un libellé est passé à la ligne)
    hauteur = 2 * marge + ligne_h * sum(
        1 + sum(max(len(e[1]) for e in ligne) for ligne in b[1])
        for b in blocs)
    finale = Image.new("RGBA", (largeur_finale, img.height + hauteur),
                       (255, 255, 255, 255))
    draw = ImageDraw.Draw(finale)
    # fond noir côté image (v28, sur demande utilisateur) : la capture
    # est centrée horizontalement dans la bande noire de sa hauteur —
    # la légende peut être plus large que l'image
    draw.rectangle([0, 0, largeur_finale - 1, img.height - 1],
                   fill=(0, 0, 0, 255))
    finale.paste(img, ((largeur_finale - img.width) // 2, 0))
    y = img.height + marge
    for titre, lignes, largeurs in blocs:
        # titre de section, aligné en haut à gauche au-dessus de ses objets
        cy = y + ligne_h // 2
        bbox = draw.textbbox((0, 0), titre, font=font)
        draw.text((marge, cy - (bbox[3] - bbox[1]) / 2 - bbox[1]),
                  titre, fill=noir, font=font)
        y += ligne_h
        for ligne in lignes:
            nl = max(len(e[1]) for e in ligne)   # lignes de la rangée
            for j, (vignette, sous, prefixe, largeur) in enumerate(ligne):
                x0 = marge + sum(largeurs[:j])
                # entrée centrée verticalement dans sa rangée
                ye = y + (nl - len(sous)) * ligne_h // 2
                if vignette is not None:
                    finale.paste(
                        vignette,
                        (round(x0),
                         round(ye + len(sous) * ligne_h / 2
                               - vignette.height / 2)),
                        vignette)
                for li, sous_ligne in enumerate(sous):
                    cy = ye + li * ligne_h + ligne_h // 2
                    x = x0 + prefixe
                    for f in sous_ligne:
                        # fragment str, image, ou groupe insécable
                        # (liste dessinée à la suite, jamais coupée)
                        for m in (f if isinstance(f, list) else [f]):
                            if isinstance(m, str):
                                bbox = draw.textbbox((0, 0), m, font=font)
                                draw.text(
                                    (x, cy - (bbox[3] - bbox[1]) / 2
                                         - bbox[1]),
                                    m, fill=noir, font=font)
                                x += mesure.textlength(m, font=font)
                            else:
                                finale.paste(
                                    m, (round(x), round(cy - m.height / 2)),
                                    m)
                                x += m.width
            y += nl * ligne_h
    return finale

# ---------------------------------------------------------------------- main

def main():
    ap = argparse.ArgumentParser(
        description="Colle les sprites des objets visibles sur les captures de cartes "
                    "(1 case par objet, palette des PNJ, légende numérotée).")
    ap.add_argument("--repo", help="racine du dépôt (détectée automatiquement sinon)")
    ap.add_argument("--png-dir",
                    help="dossier des captures (défaut : <dépôt>/screenshots/Maps)")
    ap.add_argument("--out",
                    help="dossier d'export (défaut : « Annotated_Maps » à côté du dossier des captures)")
    ap.add_argument("--taille-tuile", type=int, default=8,
                    help="taille d'une tuile en px (défaut : 8 ; détectée "
                         "automatiquement d'après les dimensions de la carte)")
    ap.add_argument("--avec-caches", action="store_true",
                    help="afficher aussi les objets invisibles au début du jeu "
                         "(entrées Hide de hide_show_data.asm)")
    ap.add_argument("--sans-legende", action="store_true",
                    help="ne pas ajouter le bandeau de noms sous l'image")
    ap.add_argument("--echelle", type=int, default=2,
                    help="facteur d'agrandissement de l'image finale "
                         "— capture annotée ET légende, tout le contenu "
                         "compris (défaut : 2 ; 1 = taille d'origine)")
    args = ap.parse_args()

    repo = Path(args.repo) if args.repo else trouver_depot()
    png_dir = Path(args.png_dir) if args.png_dir else repo / "screenshots" / "Maps"
    if not png_dir.is_dir():
        sys.exit(f"Dossier des captures introuvable : {png_dir}  (précisez --png-dir)")
    dossier_out = (Path(args.out) if args.out
                   else png_dir.parent / "Annotated_Maps")
    dossier_out.mkdir(parents=True, exist_ok=True)

    # ---- référentiels du dépôt
    dims = parse_dimensions_cartes(lire(repo / FICHIER_MAPCONST))
    entetes = scan_entetes(repo / DOSSIER_ENTETES)          # {const: stem}
    stem_vers_const = {s: c for c, s in entetes.items()}
    ids_sprites = parse_ids_sprites(lire(repo / FICHIER_SPRITE_CONSTS))
    table_sprites = parse_table_sprites(lire(repo / FICHIER_SPRITE_SETS))
    hs = parse_hide_show(lire(repo / FICHIER_HS))
    # HS prioritaires : une constante HS_* désigne l'entrée de même index
    # dans hide_show_data.asm (ordres identiques, cf. le fichier) ; les
    # entrées Hide correspondantes sont affichées quand même
    ids_hs = parse_constantes_sequentielles(lire(repo / FICHIER_HS_CONSTS))
    hs_ordre = parse_hide_show_ordre(lire(repo / FICHIER_HS))
    toujours_affiches = set()
    for nom in sorted(TOUJOURS_VISIBLIBLES):
        i = ids_hs.get(nom)
        if i is None or not (0 <= i < len(hs_ordre)):
            print(f"! {nom} : constante absente de "
                  f"hide_show_constants.asm — entrée ignorée.")
            continue
        carte_hs, id_hs, etat_hs = hs_ordre[i]
        if etat_hs != "Hide":
            print(f"i {nom} : {carte_hs} ${id_hs:02X} est {etat_hs} dans "
                  f"hide_show_data.asm (déjà visible au départ).")
            continue
        toujours_affiches.add((carte_hs, id_hs))
    if toujours_affiches:
        print(f"HideShow : {len(toujours_affiches)} entrée(s) Hide "
              f"affichée(s) quand même (TOUJOURS_VISIBLIBLES).")
    ids_items = parse_constantes_items(lire(repo / FICHIER_ITEM_CONSTS))
    noms_items = parse_noms(lire(repo / FICHIER_ITEM_NAMES))
    noms_tmhm = parse_noms(lire(repo / FICHIER_TMHM_NAMES))
    ids_pokemon = parse_constantes_sequentielles(lire(repo / FICHIER_PKMN_CONSTS))
    noms_pokemon = parse_noms(lire(repo / FICHIER_PKMN_NAMES))
    classes_dresseurs = parse_classes_dresseurs(lire(repo / FICHIER_TRAINER_CONSTS))
    noms_dresseurs = parse_noms(lire(repo / FICHIER_TRAINER_NAMES))
    # échanges in-game (PNJ d'échange : wWhichTrade -> TradeMons)
    trades = lire_trades(lire(repo / FICHIER_TRADES))
    # ---- magasins : ventes TX_MART (mart_inventories.asm) et prix de
    # vente (item_prices.asm ; CT : tm_prices.asm, nibbles de milliers)
    marts = lire_marts(lire(repo / FICHIER_MARTS))
    prix_items = lire_prix(lire(repo / FICHIER_PRIX))
    prix_tm = lire_prix_tm(lire(repo / FICHIER_PRIX_TM))
    # ---- casino : récompenses en jetons (prizes.asm — paires « dw
    # Entrées, dw Prix » de PrizeDifferentMenuPtrs) et niveaux des
    # Pokémon offerts (prize_mon_levels.asm — PrizeMonLevelDictionary)
    casino_listes = lire_casino(lire(repo / FICHIER_CASINO))
    niveaux_casino = lire_niveaux_casino(lire(repo / FICHIER_NIVEAUX_CASINO))
    # ---- objets cachés : mêmes sources que mark_hidden_objects.py
    # (data/items/ ; interactifs exclus)
    txt_ho = lire(repo / FICHIER_HIDDEN_OBJECTS)
    ho_cartes, ho_pointeurs = extraire_sections(txt_ho)
    ho_blocs = parse_blocs_hidden_objects(txt_ho)
    coords_items_caches = parse_liste_coords(lire(repo / FICHIER_HIDDEN_ITEMS))
    coords_pieces = parse_liste_coords(lire(repo / FICHIER_HIDDEN_COINS))
    caches_par_carte = collecter_caches(ho_cartes, ho_pointeurs, ho_blocs,
                                        coords_items_caches, coords_pieces)
    chiffres = charger_chiffres(Path(__file__).resolve().parent / "numbers.png")
    if chiffres is None:
        print("! numbers.png (chiffres 0-9 détourés) introuvable à côté du "
              "script : pas de numéros dessinés sur la carte, numéros "
              "écrits dans la légende.")
    pokedollar = charger_pokedollar(
        Path(__file__).resolve().parent / FICHIER_POKEDOLLAR)
    if pokedollar is None:
        print(f"! {FICHIER_POKEDOLLAR} (icône des Pokédollars) introuvable "
              "à côté du script : les prix des magasins s'affichent sans "
              "icône.")
    print(f"Constantes SPRITE_* : {len(ids_sprites)} ; "
          f"entrées dw de la table : {len(table_sprites)}")
    if len(ids_sprites) != len(table_sprites):
        print("! Les deux comptages diffèrent — vérifiez "
              "sprite_constants.asm / sprite_sets.asm.")
    n_hide = sum(1 for etat in hs.values() if etat == "Hide")
    print(f"HideShow : {len(hs)} entrées dont {n_hide} Hide "
          f"(invisibles au début du jeu" + ("" if args.avec_caches else ", ignorées")
          + ").")
    print(f"Noms : {len(noms_items)} objets, {len(noms_tmhm)} CT/CS, "
          f"{len(noms_pokemon)} espèces, {len(noms_dresseurs)} classes de "
          f"dresseurs.")
    print(f"Échanges in-game : {len(trades)} entrée(s) TradeMons "
          f"(data/pokemons/trades.asm).")
    n_ico_items = (len(list((repo / DOSSIER_ICONES_ITEMS).glob("*.png")))
                   if (repo / DOSSIER_ICONES_ITEMS).is_dir() else 0)
    print(f"Icônes d'objets : {n_ico_items} PNG dans gfx/items (24x24 ; "
          f"CT/CS -> tm_hm.png ; repli SPRITE_BALL/nom seul si absent).")
    print(f"Magasins : {len(marts)} vente(s) TX_MART "
          f"(data/items/mart_inventories.asm) ; prix : {len(prix_items)} "
          f"objets (item_prices.asm), {len(prix_tm)} CT (tm_prices.asm).")
    n_niv = len(niveaux_casino)
    print(f"Casino : {len(casino_listes)} liste(s) de récompenses ; "
          f"{n_niv} Pokémon avec niveau (data/items/prizes.asm, "
          f"prize_mon_levels.asm).")
    n_co = sum(1 for l in caches_par_carte.values()
               for t, *_ in l if t == "cache_objet")
    n_pc = sum(1 for l in caches_par_carte.values()
               for t, *_ in l if t == "cache_piece")
    print(f"Objets cachés : {n_co} objets au sol + {n_pc} pièces sur "
          f"{len(caches_par_carte)} cartes (interactifs exclus).")
    if ho_cartes and len(ho_cartes) != len(ho_pointeurs):
        print(f"! hidden_objects.asm : {len(ho_cartes)} cartes mais "
              f"{len(ho_pointeurs)} pointeurs dw — vérifiez le fichier.")
    if police_legende()[1]:
        print("i Police TTF introuvable (DejaVu, Arial, Liberation...) : les noms "
              "de la légende seront translittérés sans accents (é -> e) pour "
              "éviter tout souci d'encodage.")

    # ---- résolution des fichiers PNG de sprites (avec cache)
    cache_chemin = {}
    def chemin_sprite(nom_dw):
        if nom_dw in cache_chemin:
            return cache_chemin[nom_dw]
        p = None
        if nom_dw:
            rel = EXCEPTIONS_PNG.get(nom_dw)
            if rel:
                p = repo / DOSSIER_SPRITES / rel
            else:
                nom = snake(nom_dw) + ".png"
                if (repo / DOSSIER_SPRITES / nom).is_file():
                    p = repo / DOSSIER_SPRITES / nom
                elif (repo / DOSSIER_SPRITES / SOUS_DOSSIER_PKMN / nom).is_file():
                    p = repo / DOSSIER_SPRITES / SOUS_DOSSIER_PKMN / nom
        cache_chemin[nom_dw] = p if (p and p.is_file()) else None
        return cache_chemin[nom_dw]

    cache_sprite = {}      # (nom_dw, taille) -> Image prête à coller (ou None)
    def sprite_pour(nom_dw, taille):
        cle = (nom_dw, taille)
        if cle in cache_sprite:
            return cache_sprite[cle]
        img = None
        chemin = chemin_sprite(nom_dw)
        if chemin:
            src = Image.open(chemin)
            src.load()                              # plus de getdata/putdata (Pillow 14)
            img = recolorer_pnj(src.crop((0, 0, 16, 16)))   # frame statique + palette PNJ
            if img.getchannel("A").getextrema()[1] == 0:
                img = None                          # crop entièrement transparent
        if img is not None:
            img = img.resize((taille, taille), Image.NEAREST)   # 1 case en jeu
        cache_sprite[cle] = img
        return img

    # ---- icônes d'espèces pour la légende des échanges : icônes du jeu
    # (gfx/pokemon/icons/, un PNG par espèce — les 20 espèces
    # échangeables y sont toutes), frame 16x16 du haut ; repli sur le
    # sprite overworld (gfx/sprites/, notamment pokemons/) si une icône
    # manque. Index par nom normalisé (minuscules, « _ » retirés :
    # MR_MIME -> mrmime = mr_mime.png)
    index_especes = {}
    for d_ico in (repo / DOSSIER_ICONES,
                  repo / DOSSIER_SPRITES,
                  repo / DOSSIER_SPRITES / SOUS_DOSSIER_PKMN):
        if d_ico.is_dir():
            for p_ico in d_ico.glob("*.png"):
                cle_ico = p_ico.stem.lower().replace("_", "")
                if cle_ico not in index_especes:
                    index_especes[cle_ico] = p_ico
    cache_icone = {}

    def icone_espece(espece, cote):
        """Icône d'une espèce pour la légende des échanges : frame
        16x16 du haut de son icône du jeu (gfx/pokemon/icons/ ; repli :
        frame statique de son sprite overworld), recoloriée (palette
        des PNJ), redimensionnée à 1 tuile — None si le dépôt n'en a
        pas (le libellé s'affiche alors sans icône)."""
        cle = (espece, cote)
        if cle in cache_icone:
            return cache_icone[cle]
        img = None
        p_ico = index_especes.get(espece.lower().replace("_", ""))
        if p_ico is not None:
            src = Image.open(p_ico)
            src.load()
            img = recolorer_pnj(src.crop((0, 0, 16, 16)))
            if img.getchannel("A").getextrema()[1] == 0:
                img = None              # frame entièrement transparente
            else:
                img = img.resize((cote, cote), Image.NEAREST)
        cache_icone[cle] = img
        return img

    # ---- icônes d'objets pour la légende : gfx/items/*.png (24x24,
    # MASTER_BALL -> master_ball.png, dérivation snake_case), recoloriées
    # en palette des menus (violet générique PAL_MEWMON — pas la
    # palette des PNJ) et conservées à leur taille d'origine (24x24) ;
    # une seule
    # tm_hm.png pour toutes les CT/CS (TMxx_*/HMxx_*) ; None si le PNG
    # manque (repli SPRITE_BALL ou nom seul)
    cache_icone_items = {}

    def icone_item(const):
        """Icône d'un objet pour la légende : son PNG de gfx/items/
        (MASTER_BALL -> master_ball.png, dérivation snake_case de la
        constante), recoloriée (palette des menus — la palette violette
        générique chargée par SetPal_Generic, distincte de la palette
        des PNJ des sprites et des icônes d'espèces — sur demande
        utilisateur) et conservée à sa taille d'origine (24x24, aucun
        redimensionnement — sur demande utilisateur ; une icône tient
        dans l'interligne de la légende) ; tm_hm.png pour toutes les
        CT/CS (TMxx_*/HMxx_*) ; None si le PNG manque (le libellé
        garde son rendu de repli)."""
        if const in cache_icone_items:
            return cache_icone_items[const]
        img = None
        nom_png = (ICONE_TM_HM if re.match(r"(?:TM|HM)\d", const or "")
                   else snake(const) + ".png")
        p_ico = repo / DOSSIER_ICONES_ITEMS / nom_png
        if p_ico.is_file():
            src = Image.open(p_ico)
            src.load()
            img = recolorer_menu(src)      # 24x24 autonome : pas de crop,
                                         # pas de redimensionnement ;
                                         # palette des menus (PAL_MEWMON)
            if img.getchannel("A").getextrema()[1] == 0:
                img = None              # entièrement transparente
        cache_icone_items[const] = img
        return img

    def libelle_echange(detail, cote):
        """Libellé d'un PNJ d'échange : « [icône] Nom de l'espèce reçue
        contre [icône] nom de l'espèce donnée » — détail
        « ESPECE_RECUE/ESPECE_DONNEE » (constantes de TradeMons). Chaque
        icône (icône du jeu de l'espèce — gfx/pokemon/icons/, 16x16 du
        haut, repli sprite overworld) est regroupée avec son nom dans
        un fragment liste insécable : le retour à la ligne ne sépare
        jamais une icône de son nom."""
        recue, _, donnee = (detail or "").partition("/")
        if not recue:
            return [LIBELLES["echange"]]

        def groupe(espece):
            """Icône et nom de l'espèce, insécables."""
            nom = nom_espece(espece, ids_pokemon, noms_pokemon) or espece
            ico = icone_espece(espece, cote)
            return [ico, " " + nom] if ico is not None else [" " + nom]

        if not donnee:
            return [groupe(recue)]
        return [groupe(recue), " contre ", groupe(donnee)]

    def tete_vendeur(numero, etiquette, ico=None):
        """Première ligne d'une entrée de la section « Magasin » :
        « [icône du vendeur] étiquette » — icône surélevée comme sur la
        carte, numéro en bas à droite de sa case (chiffres de
        numbers.png), écrit en tête si la planche manque ; groupe
        insécable icône + étiquette. L'icône est le sprite du VRAI
        PNJ vendant (sur demande utilisateur) ; repli SPRITE_MART_GUY
        uniforme — SPRITE_VENDEUR n'existe pas dans
        sprite_constants.asm."""
        ico = ico if ico is not None else sp_vendeur
        if ico is None:
            return [f"{numero} {etiquette}" if numero else etiquette]
        case = Image.new("RGBA", (taille, taille + decalage),
                         (0, 0, 0, 0))
        case.paste(ico, (0, 0), ico)
        if chiffres and numero:
            coller_numero(case, 0, decalage, taille, numero, chiffres)
            return [case, f" {etiquette}"]
        if numero:
            return [f"{numero} ", case, f" {etiquette}"]
        return [case, f" {etiquette}"]

    def libelle_magasin(detail, numero, sprite_pnj=None):
        """Libellé d'un vendeur : première ligne dédiée « [icône du
        vendeur] Vendeur » (tete_vendeur, icône = sprite du vrai PNJ,
        repli SPRITE_MART_GUY uniforme) — puis un objet en vente par
        ligne, « [icône de l'objet] Nom FR :
        prix [icône P$] » — prix suivi de l'icône des Pokédollars
        (pokedollar.png, annexe à côté du script, groupe insécable
        [prix + icône], repli prix seul si elle manque) — icône du
        jeu de l'objet (gfx/items/, 24x24, recoloriée
        palette des menus ; CT/CS : tm_hm.png ; groupe insécable avec
        son nom, repli SPRITE_BALL si le PNG manque) — détail
        « ITEM,ITEM,... » (consts de la vente
        TX_MART). Le prix vient d'item_prices.asm (ItemPrices) ou de
        tm_prices.asm pour les CT (nibbles de milliers) ; nom seul si
        inconnu. Chaque objet a sa ligne (fragment SAUT, jamais coupé
        par le retour à la ligne automatique)."""
        items = [i for i in (detail or "").split(",") if i]
        lignes = [tete_vendeur(numero, "Vendeur", sprite_pnj)]
        for it in items:
            nom = nom_item(it, ids_items, noms_items, noms_tmhm) or it
            p = prix_de(it, prix_items, prix_tm)
            ico = icone_item(it)
            lignes.append(SAUT)
            lignes.extend(ligne_article(ico if ico is not None else sp_ball,
                                        nom,
                                        f"{p}" if p is not None else None,
                                        pokedollar))
        return lignes

    def libelle_magasin_pkmn(detail, numero, sprite_pnj=None):
        """Libellé d'un PNJ vendant un Pokémon (VENTES_POKEMON_MANUELLES,
        ex. vendeur de Magicarpe du Mont Sélénite) : première ligne
        « [icône vendeur] Vendeur » (tete_vendeur, icône = sprite du
        vrai PNJ, repli SPRITE_MART_GUY), puis « [icône
        d'espèce] Nom FR : prix [icône P$] » — détail « ESPECE/prix ».
        Icône d'espèce du jeu (gfx/pokemon/icons/, comme les échanges),
        repli SPRITE_BALL ; prix inconnu : nom seul."""
        espece, _, prix = (detail or "").partition("/")
        nom = nom_espece(espece, ids_pokemon, noms_pokemon) or espece \
            or LIBELLES["magasin_pokemon"]
        ico = icone_espece(espece, taille) if espece else None
        if ico is None:
            ico = sp_ball
        lignes = [tete_vendeur(numero, LIBELLES["magasin_pokemon"],
                               sprite_pnj)]
        lignes.append(SAUT)
        lignes.extend(ligne_article(ico, nom, prix if prix else None,
                                   pokedollar))
        return lignes

    def libelle_distributeur(numero, articles):
        """Libellé d'un distributeur (DISTRIBUTEURS_MANUELS) : première
        ligne « [icône vendeur] Vente » (tete_vendeur ; étiquette
        LIBELLES["distributeur"]), puis un
        article par ligne « [icône de l'objet] Nom FR : prix [icône
        P$] » — prix de la config, ou d'item_prices.asm si absent ;
        une ligne CSV par article (hors légende)."""
        lignes = [tete_vendeur(numero, LIBELLES["distributeur"])]
        for const, prix in articles:
            nom = nom_item(const, ids_items, noms_items, noms_tmhm) or const
            p = prix if prix is not None else prix_de(const, prix_items,
                                                     prix_tm)
            ico = icone_item(const)
            lignes.append(SAUT)
            lignes.extend(ligne_article(ico if ico is not None else sp_ball,
                                        nom,
                                        f"{p}" if p is not None else None,
                                        pokedollar))
        return lignes

    def libelle_casino(prizes):
        """Libellé d'un panneau-vente du casino : une récompense par
        ligne, « [icône] Nom FR : N jetons » — Pokémon (const dans
        PrizeMonLevelDictionary) : icône d'espèce du jeu, comme pour
        les échanges, et « Nom n.NIVEAU » ; CT/objet : icône du jeu de
        l'objet (gfx/items/, 24x24 ; CT/CS : tm_hm.png ; repli
        SPRITE_BALL si le PNG manque). Le prix « N jetons » est un
        groupe insécable (comme « N captures ») ; coût manquant :
        nom seul."""
        frags = []
        for const, cout in prizes:
            if frags:
                frags.append(SAUT)
            if const in niveaux_casino:
                nom = nom_espece(const, ids_pokemon, noms_pokemon) or const
                texte = f"{nom} n.{niveaux_casino[const]}"
                ico = icone_espece(const, taille)
            else:
                texte = (nom_item(const, ids_items, noms_items, noms_tmhm)
                         or const)
                ico = icone_item(const)
                if ico is None:
                    ico = sp_ball
            frags.extend(
                ligne_article(ico, texte,
                              [f"{cout} jetons"] if cout is not None
                              else None))
        return frags or [LIBELLES["casino"]]

    # ---- Dons de Pokémons et d'objets : résolus par n° de texte dans le
    # script de la carte (scripts/<carte>.asm), + DONS_MANUELS en repli
    cache_dons = {}
    offerts_inconnus = set()

    def dons_pour(stem):
        """({n° texte: « ESPECE/niveau »}, {n° texte: « CONST_OBJET »},
        {n° texte: « CONST_OBJET/seuil »}, {n° texte: index TradeMons})
        des dons d'une carte (vides si le script est introuvable) ;
        DONS_MANUELS complète les dons atypiques (repli, l'analyseur
        reste prioritaire)."""
        if stem not in cache_dons:
            chemin = repo / DOSSIER_SCRIPTS / (stem + ".asm")
            pkmn, objets, recomp, ech = (dons_dans(lire(chemin))
                                         if chemin.is_file()
                                         else ({}, {}, {}, {}))
            for tid, detail in DONS_MANUELS.get(stem, {}).items():
                pkmn.setdefault(tid, detail)
            cache_dons[stem] = (pkmn, objets, recomp, ech)
        return cache_dons[stem]

    cache_magasins = {}

    def magasins_pour(stem):
        """{n° de texte: [consts d'objets]} des ventes TX_MART d'une
        carte (vides si le script est introuvable) — le PNJ portant ce
        n° de texte est le vendeur."""
        if stem not in cache_magasins:
            chemin = repo / DOSSIER_SCRIPTS / (stem + ".asm")
            cache_magasins[stem] = (magasins_dans(lire(chemin), marts)
                                     if chemin.is_file() else {})
        return cache_magasins[stem]

    cache_casinos = {}

    def casinos_pour(stem):
        """[(n° de liste, n° de texte)] des panneaux-vente du casino
        d'une carte, trié par n° de texte (vide si le script est
        introuvable) — le moteur charge la liste n° = n° de texte - 3
        (engine/menu/prize_menu.asm : « sub 3 » dans GetPrizeMenuId)."""
        if stem not in cache_casinos:
            chemin = repo / DOSSIER_SCRIPTS / (stem + ".asm")
            tids = (casinos_dans(lire(chemin)) if chemin.is_file() else [])
            cache_casinos[stem] = [(t - 3, t) for t in tids if t >= 3]
        return cache_casinos[stem]

    # ---- parcours des cartes
    lignes_csv = []
    n_objets = n_colles = n_hors_carte = n_ignores = n_caches = 0
    n_badges = n_prioritaires = n_magasins = n_casino = 0
    n_erreurs = 0
    fichiers_avec_objets = cartes_annotees = 0
    consts_traitees = set()
    sans_capture = []
    detail_ignores = {"sans capture": 0, "sprite introuvable": 0,
                      "coordonnées invalides": 0, "hors cadre": 0}

    for f in sorted((repo / DOSSIER_OBJETS).glob("*.asm")):
        stem = f.stem
        txt_objets = lire(f)
        objets = parse_objets(txt_objets)
        signes = parse_signes(txt_objets)
        carte_const = stem_vers_const.get(stem, "")
        consts_traitees.add(carte_const)
        marqueurs_caches = caches_par_carte.get(carte_const, [])
        casino_ids = casinos_pour(stem)
        if not objets and not marqueurs_caches and not casino_ids:
            continue
        if objets:
            fichiers_avec_objets += 1
            n_objets += len(objets)
        h, w = dims.get(carte_const, (None, None))
        capture = trouver_png(png_dir, stem)

        img = None
        taille = args.taille_tuile
        if capture is None:
            sans_capture.append(stem)
        else:
            img = Image.open(capture).convert("RGBA")
            if h and w:
                detectee, reste_px = divmod(img.width, w * 2)
                if reste_px == 0 and detectee > 0 and img.height == h * 2 * detectee:
                    if detectee != args.taille_tuile:
                        print(f"i {capture.name} : capture à {detectee} px/tuile "
                              f"(--taille-tuile {args.taille_tuile} ignorée).")
                    taille = detectee
                else:
                    print(f"! {capture.name} : {img.width}x{img.height} px ne "
                          f"correspond pas aux {w}x{h} blocs de {carte_const} — "
                          f"on garde {args.taille_tuile} px/tuile.")
            else:
                print(f"! {capture.name} : dimensions de {stem} inconnues "
                      f"(mapconst/entête) — on garde {args.taille_tuile} px/tuile.")

        decalage = max(1, taille // 4)   # sprite surélevé comme dans le
                                        # jeu ; le numéro, lui, reste en
                                        # bas à droite de la case
        compteurs = {}       # numérotation par catégorie de légende —
        colles = 0           # « Rencontres », « Objets », « Récompenses »,
        entrees_legende = [] # « Echanges », « Magasin », « Objets
                             # cachés » ; chaque compteur repart à 1
        # icône du vendeur (première ligne « Vendeur » des entrées de
        # magasin de la légende) : SPRITE_VENDEUR n'existe pas dans
        # sprite_constants.asm -> repli automatique sur SPRITE_MART_GUY
        # (le vendeur du jeu)
        id_vendeur = ids_sprites.get("SPRITE_VENDEUR") \
            or ids_sprites.get("SPRITE_MART_GUY")
        nom_vendeur = (table_sprites[id_vendeur - 1]
                       if isinstance(id_vendeur, int)
                       and 0 < id_vendeur <= len(table_sprites) else "")
        sp_vendeur = sprite_pour(nom_vendeur, taille)
        # Poké Ball : vignette des objets marqués par coordonnées et
        # icône de chaque article de magasin/casino — SPRITE_BALL de la
        # carte en cours (la taille est détectée par capture)
        id_ball = ids_sprites.get("SPRITE_BALL")
        nom_ball = (table_sprites[id_ball - 1]
                    if isinstance(id_ball, int)
                    and 0 < id_ball <= len(table_sprites) else "")
        sp_ball = sprite_pour(nom_ball, taille)
        # badge des objets cachés : disque d'une tuile de diamètre
        # (16 px sur les captures x2), même rendu dans la légende
        draw_caches = rayon_caches = font_caches = None
        if (marqueurs_caches or casino_ids) and img is not None:
            draw_caches = ImageDraw.Draw(img)
            rayon_caches = max(3, taille // 2 - 1)
            font_caches = police(max(8, round(taille * 0.55)))

        for idx, (sprite_const, reste) in enumerate(objets, start=1):
            try:
                x, y = val(reste[0]), val(reste[1])
            except (ValueError, IndexError):
                lignes_csv.append({"carte": stem, "const_carte": carte_const,
                                   "sprite": sprite_const, "id_sprite": "",
                                   "png": "", "numero": "", "x_tuiles": "",
                                   "y_tuiles": "", "mouvement": "", "direction": "",
                                   "text_id": "", "type": "inconnu",
                                   "item_ou_dresseur": "", "cache_debut": "",
                                   "remarque": "coordonnées non numériques ignorées"})
                n_ignores += 1
                detail_ignores["coordonnées invalides"] += 1
                continue

            mouvement = reste[2] if len(reste) > 2 else ""
            direction = reste[3] if len(reste) > 3 else ""
            text_id = reste[4] if len(reste) > 4 else ""
            type_o, detail = type_objet(reste)
            # Dons du script de la carte, résolus par le n° de texte de
            # l'objet (SPRITE_POKEBALL, PNJ donneur de Pokémon, fossiles)
            try:
                tid = val(text_id)
            except ValueError:
                tid = None
            dons_pkmn, dons_objets, dons_recompenses, dons_echanges = \
                dons_pour(stem)
            magasins_carte = magasins_pour(stem)
            # SPRITE_POKEBALL = Pokémon offert à récupérer (Évoli, Lapras,
            # Hitmon...) : numéroté comme un objet, classé dans la
            # section « Récompenses » (dons des PNJ). Le don vient du n° de
            # texte de l'objet,
            # sinon de l'unique don de la carte ; s'il reste introuvable,
            # le libellé retombe sur « Pokémon » et la carte est listée
            # en fin de run (à compléter dans DONS_MANUELS).
            # fonction d'un PNJ (LIBELLES_PNJ_MANUELS : Renameur,
            # effaceur de capacités...) : libellé libre de la config,
            # section « Personnage » — priorité sur toute détection
            # automatique (don, vente, combat scripté, échange...)
            if (stem, idx) in LIBELLES_PNJ_MANUELS:
                type_o, detail = ("pnj_libelle",
                                  LIBELLES_PNJ_MANUELS[(stem, idx)])
            if sprite_const == "SPRITE_POKEBALL":
                detail_don = dons_pkmn.get(tid) or (
                    next(iter(dons_pkmn.values())) if len(dons_pkmn) == 1
                    else "")
                type_o, detail = "pokemon_offert", detail_don
                if not detail:
                    offerts_inconnus.add(stem)
            elif type_o == "personnage" and tid is not None:
                # vendeur de magasin : le n° de texte pointe sur une
                # vente TX_MART (mart_inventories.asm) -> section
                # « Magasin », un objet en vente par ligne avec son
                # prix, vignette SPRITE_MART_GUY
                if tid in magasins_carte:
                    type_o, detail = "magasin", ",".join(magasins_carte[tid])
                    n_magasins += 1
                # vente de Pokémon par un PNJ (VENTES_POKEMON_MANUELLES,
                # ex. vendeur de Magicarpe du Mont Sélénite) -> vendeur
                # de la section « Magasin » ; priorité sur le don
                # auto-détecté du script (GivePokemon du texte)
                elif (stem, idx) in VENTES_POKEMON_MANUELLES:
                    espece_v, prix_v = VENTES_POKEMON_MANUELLES[(stem, idx)]
                    type_o, detail = ("magasin_pokemon",
                                      f"{espece_v}/"
                                      f"{prix_v if prix_v is not None else ''}")
                    n_magasins += 1
                # PNJ dont le n° de texte porte le don : le donneur de
                # Lapras du 7F de Sylphe devient un Pokémon récupérable
                # (section « Récompenses »)
                elif tid in dons_pkmn:
                    type_o, detail = "pokemon_offert", dons_pkmn[tid]
                # assistant de Chen : récompense du nombre de captures
                # (predef OaksAideScript), affichée comme un dresseur
                # (vignette + numéro + libellé, section « Récompenses »)
                elif tid in dons_recompenses:
                    type_o, detail = "recompense", dons_recompenses[tid]
                # PNJ d'échange in-game (predef DoInGameTradeDialogue) :
                # l'index wWhichTrade désigne une entrée de TradeMons
                # (data/pokemons/trades.asm) — 1re colonne = espèce
                # donnée par le joueur, 2e = espèce reçue (section
                # « Echanges » de la légende, avec icônes d'espèces)
                elif tid in dons_echanges:
                    echange_i = dons_echanges[tid]
                    if 0 <= echange_i < len(trades):
                        donnee_e, recue_e = trades[echange_i]
                        type_o, detail = "echange", f"{recue_e}/{donnee_e}"
                    else:
                        print(f"! {stem} texte {tid} : échange "
                              f"{echange_i} hors table TradeMons "
                              f"({len(trades)} entrées) — libellé "
                              f"générique.")
                        type_o, detail = "echange", ""
                # fossiles du Mont Sélénite : don d'objet (GiveItem),
                # affiché comme les autres dons dans « Récompenses »
                elif (sprite_const in ("SPRITE_DOME", "SPRITE_OMANYTE")
                      and tid in dons_objets):
                    type_o, detail = "objet_offert", dons_objets[tid]
                # don d'objet porté par un autre objet que le texte du
                # don (ambre du musée, CT37, Ticket Bateau...,
                # cf. DONS_OBJETS_MANUELS) -> section « Récompenses »
                elif (stem, idx) in DONS_OBJETS_MANUELS:
                    type_o, detail = ("objet_offert",
                                      DONS_OBJETS_MANUELS[(stem, idx)])
            # Combat scripté (rivaux sans OPP_* dans la ligne object,
            # Prof. Chen, Sacha, Infirmière Joëlle) : la classe du
            # combat vient du script de la carte -> numéroté comme un
            # dresseur dans « Rencontres » ; pas de « #n » (le n° de
            # dresseur dépend du starter du rival). Valeur
            # « ESPECE/NIVEAU » (Ronflex de la route 12) : combat contre
            # un POKÉMON unique -> re-typé « pokemon », même style que
            # les légendaires (« Nom FR n.niveau »).
            # Un objet déjà re-typé (don du script auto-détecté, magasin,
            # échange...) garde ce re-typage — SAUF don manuel de
            # DONS_OBJETS_MANUELS : le combat scripté reprend alors la
            # main et le don devient une récompense de victoire (bloc
            # suivant) — Sacha s'affiche en « Rencontres » avec l'ADN
            # Berserk sur la ligne du dessous, au lieu d'un simple
            # « Objet offert » en Récompenses.
            combat = COMBATS_SCRIPTES.get((stem, idx))
            if combat and (type_o == "personnage"
                          or (stem, idx) in DONS_OBJETS_MANUELS):
                if "/" in combat:
                    type_o, detail = "pokemon", combat
                else:
                    type_o, detail = "dresseur", combat

            # récompense de victoire d'une rencontre (dresseur, rencontre
            # statique) : certains dresseurs (maîtres d'arènes...) donnent
            # un objet après le combat — même table DONS_OBJETS_MANUELS
            # que les dons de personnages, la valeur (un ou plusieurs
            # objets séparés par « , ») est collée au détail après un
            # « | » ; la rencontre reste dans « Rencontres » (sprite,
            # numéro), son libellé ajoute une ligne « [icône] Objet »
            # sous le nom (SAUT, sur demande utilisateur : pas de
            # tiret)
            if (type_o in ("dresseur", "pokemon")
                    and (stem, idx) in DONS_OBJETS_MANUELS):
                detail = ((detail or "").strip() + "|"
                          + DONS_OBJETS_MANUELS[(stem, idx)])

            # seuls les dresseurs, les objets ramassables, les rencontres
            # statiques, les dons/récompenses, les PNJ d'échange et les
            # vendeurs de magasin sont numérotés ; le n° est attribué au
            # moment du
            # collage (un objet caché au début du jeu n'est numéroté que
            # s'il est affiché)
            numero = ""

            # HideShow : entrée Hide = invisible au début du jeu — sauf
            # HS prioritaires (TOUJOURS_VISIBLIBLES : rivaux, Mew,
            # Ho-Oh...), affichées quand même
            etat_hs = hs.get((carte_const, idx))
            prioritaire = (carte_const, idx) in toujours_affiches
            cache_debut = etat_hs == "Hide" and not prioritaire
            cache_prioritaire = etat_hs == "Hide" and prioritaire
            if cache_debut:
                n_caches += 1
            if cache_prioritaire:
                n_prioritaires += 1

            id_sprite = ids_sprites.get(sprite_const, "")
            nom_dw = (table_sprites[id_sprite - 1]
                      if isinstance(id_sprite, int) and 0 < id_sprite <= len(table_sprites)
                      else "")
            chemin = chemin_sprite(nom_dw)
            png_sprite = chemin.name if chemin else ""

            remarque = ""
            if h and w and (x < 0 or y < 0 or x > w * 2 - 1 or y > h * 2 - 1):
                remarque = f"hors carte ({h}x{w} blocs)"
                n_hors_carte += 1
            elif img is None:
                remarque = "sans capture"
                n_ignores += 1
                detail_ignores["sans capture"] += 1
            elif cache_debut and not args.avec_caches:
                remarque = "invisible au début du jeu (hide_show_data)"
            else:
                px, py = x * taille, y * taille     # la case de l'objet : tuile (X, Y)
                cote = taille                       # le sprite tient sur 1 case
                if px <= -cote or py <= -cote or px >= img.width or py >= img.height:
                    remarque = "hors cadre"
                    n_ignores += 1
                    detail_ignores["hors cadre"] += 1
                else:
                    sp = sprite_pour(nom_dw, taille)
                    if sp is None:
                        remarque = f"sprite introuvable ({nom_dw or sprite_const})"
                        n_ignores += 1
                        detail_ignores["sprite introuvable"] += 1
                    else:
                        # fond transparent : masque alpha ; sprite surélevé
                        # de « decalage » px comme dans le jeu (il déborde
                        # sur la case du dessus), le numéro reste en bas
                        img.paste(sp, (px, py - decalage), sp)
                        n_colles += 1
                        colles += 1
                    # numéro en bas à droite de la case (dresseurs, objets,
                    # rencontres statiques), chiffres de numbers.png collés
                    # tels quels ; la légende reprend le même rendu :
                    # vignette du sprite, numéro en bas à droite, libellé
                    if type_o in TYPES_NUMEROTES:
                        cat = CATEGORIES.get(type_o, "Objets")
                        compteurs[cat] = compteurs.get(cat, 0) + 1
                        numero = compteurs[cat]
                        if chiffres:
                            coller_numero(img, px, py, taille, numero,
                                           chiffres)
                        # échange : libellé en fragments (icônes
                        # d'espèces + « Nom reçu contre Nom donné ») ;
                        # magasin : ligne dédiée « [icône vendeur]
                        # Vendeur » puis un objet en vente par ligne
                        # avec son prix ; Pokémons offerts : icône
                        # d'espèce + nom
                        libelle = (libelle_echange(detail, taille)
                                   if type_o == "echange"
                                   else libelle_magasin(detail, numero, sp)
                                   if type_o == "magasin"
                                   else libelle_magasin_pkmn(detail, numero,
                                                             sp)
                                   if type_o == "magasin_pokemon"
                                   else libelle_objet(
                                       type_o, detail, classes_dresseurs,
                                       noms_dresseurs, ids_items,
                                       noms_items, noms_tmhm,
                                       ids_pokemon, noms_pokemon,
                                       icone=lambda e: icone_espece(e, taille),
                                       icone_objet=icone_item))
                        # magasin : pas de vignette latérale — l'icône du
                        # vendeur ouvre la première ligne du libellé
                        entrees_legende.append(
                            (numero, libelle,
                             None if type_o in ("magasin", "magasin_pokemon")
                             else sp,
                             CATEGORIES.get(type_o, "Objets"),
                             None))

            lignes_csv.append({"carte": stem, "const_carte": carte_const,
                               "sprite": sprite_const, "id_sprite": id_sprite,
                               "png": png_sprite, "numero": numero,
                               "x_tuiles": x, "y_tuiles": y,
                               "mouvement": mouvement, "direction": direction,
                               "text_id": text_id, "type": type_o,
                               "item_ou_dresseur": detail,
                               "cache_debut": ("prioritaire" if cache_prioritaire
                                               else "oui" if cache_debut else ""),
                               "remarque": remarque})

        # ---- objets marqués par coordonnées (OBJETS_COORDONNEES) : seul
        # le numéro est dessiné sur la tuile (pas de sprite) ; entrée de
        # légende avec la vignette SPRITE_BALL (repli : numéro écrit en
        # tête du libellé si le sprite est introuvable). Numérotés dans
        # le compteur « Récompenses » à la suite des dons déclarés de
        # la carte. Valeur = const d'objet, ou liste de consts : plusieurs
        # objets au même endroit partagent le numéro de la tuile et un
        # libellé (noms séparés par une espace), une ligne CSV par objet
        for (stem_c, x_c, y_c), items_c in OBJETS_COORDONNEES.items():
            if stem_c != stem:
                continue
            if not isinstance(items_c, (list, tuple)):
                items_c = [items_c]     # une const seule -> liste
            px_c, py_c = x_c * taille, y_c * taille
            numero_c, remarque_c = "", ""
            if img is None:
                remarque_c = "sans capture"
            elif not (0 <= px_c < img.width and 0 <= py_c < img.height):
                remarque_c = "hors cadre"
            else:
                cat_c = CATEGORIES["recompense"]
                compteurs[cat_c] = compteurs.get(cat_c, 0) + 1
                numero_c = compteurs[cat_c]
                if chiffres:
                    coller_numero(img, px_c, py_c, taille, numero_c,
                                   chiffres)
                # libellé : nom FR de chaque objet (précédé de son
                # icône du jeu, gfx/items/), séparés par une espace ;
                # libellés en fragments (str | liste insécable icône +
                # nom) fusionnés, le join ne fonctionne que sans icône
                libelles_c = [libelle_objet("objet_offert", item_c,
                                            classes_dresseurs,
                                            noms_dresseurs, ids_items,
                                            noms_items, noms_tmhm,
                                            ids_pokemon, noms_pokemon,
                                            icone_objet=icone_item)
                              for item_c in items_c]
                if all(isinstance(l, str) for l in libelles_c):
                    libelle_c = " ".join(libelles_c)
                else:
                    libelle_c = []
                    for k, part in enumerate(libelles_c):
                        if k:
                            libelle_c.append(" ")
                        libelle_c.extend(part if isinstance(part, list)
                                         else [part])
                entrees_legende.append(
                    (numero_c, libelle_c, sp_ball, cat_c, None))
            for item_c in items_c:
                lignes_csv.append({"carte": stem, "const_carte": carte_const,
                                   "sprite": "", "id_sprite": "", "png": "",
                                   "numero": numero_c, "x_tuiles": x_c,
                                   "y_tuiles": y_c, "mouvement": "",
                                   "direction": "", "text_id": "",
                                   "type": "objet_offert",
                                   "item_ou_dresseur": item_c,
                                   "cache_debut": "",
                                   "remarque": remarque_c})

        # ---- distributeurs manuels (DISTRIBUTEURS_MANUELS) : SEUL le
        # numéro est dessiné sur la tuile (pas de sprite) ; entrée de
        # légende « [icône vendeur] Vente » puis un article par
        # ligne avec son prix (icône P$), numérotés dans le compteur
        # « Magasin » à la suite des vendeurs ; une ligne CSV par
        # article. Un article sans prix dans la config retombe sur
        # item_prices.asm
        for (stem_d, x_d, y_d), articles_d in DISTRIBUTEURS_MANUELS.items():
            if stem_d != stem:
                continue
            articles_d = [(a, None) if isinstance(a, str) else a
                          for a in articles_d]     # const seule -> sans prix
            px_d, py_d = x_d * taille, y_d * taille
            numero_d, remarque_d = "", ""
            if img is None:
                remarque_d = "sans capture"
            elif not (0 <= px_d < img.width and 0 <= py_d < img.height):
                remarque_d = "hors cadre"
            else:
                cat_d = CATEGORIES["distributeur"]
                compteurs[cat_d] = compteurs.get(cat_d, 0) + 1
                numero_d = compteurs[cat_d]
                if chiffres:
                    coller_numero(img, px_d, py_d, taille, numero_d,
                                   chiffres)
                entrees_legende.append(
                    (numero_d, libelle_distributeur(numero_d, articles_d),
                     None, cat_d, None))
            for const_d, prix_d in articles_d:
                lignes_csv.append({"carte": stem, "const_carte": carte_const,
                                   "sprite": "", "id_sprite": "", "png": "",
                                   "numero": numero_d, "x_tuiles": x_d,
                                   "y_tuiles": y_d, "mouvement": "",
                                   "direction": "", "text_id": "",
                                   "type": "distributeur",
                                   "item_ou_dresseur":
                                       f"{const_d}/{prix_d}"
                                       if prix_d is not None else const_d,
                                   "cache_debut": "",
                                   "remarque": remarque_d})

        # ---- casino (salle des prix de Céladon) : les panneaux-vente
        # sont des « sign » dont le texte est TX_PRIZE_VENDOR ; les
        # récompenses (data/items/prizes.asm) se paient en JETONS, pas
        # en Pokédollars. Badge or numéroté sur la tuile du panneau —
        # même rendu que les pièces cachées (disque d'une tuile,
        # COULEURS_CACHES["piece"]) — et badge en vignette de légende.
        # Numérotés dans le compteur « Magasin » à la suite des
        # vendeurs ; une récompense par ligne (icône d'espèce pour les
        # Pokémon, SPRITE_BALL pour les autres), une ligne CSV par
        # récompense (même numéro, tuile du panneau)
        for i_vente, tid_vente in casino_ids:
            if not (0 <= i_vente < len(casino_listes)):
                print(f"! {stem} texte {tid_vente} : liste "
                      f"{i_vente} hors prizes.asm ({len(casino_listes)} "
                      f"liste(s)) — panneau ignoré.")
                continue
            # panneau-vente : le « sign » portant ce n° de texte
            panneau = None
            for s_x, s_y, s_t in signes:
                try:
                    if val(s_t) == tid_vente:
                        panneau = (val(s_x), val(s_y))
                        break
                except ValueError:
                    continue
            if panneau is None:
                print(f"! {stem} texte {tid_vente} : panneau « sign » "
                      f"introuvable dans data/maps/objects/ — vendeur du "
                      f"casino ignoré.")
                continue
            x_v, y_v = panneau
            numero_v, remarque_v = "", ""
            if img is None:
                remarque_v = "sans capture"
            else:
                cat_v = CATEGORIES["casino"]    # « Magasin » : suit les vendeurs
                compteurs[cat_v] = compteurs.get(cat_v, 0) + 1
                numero_v = compteurs[cat_v]
                cx, cy = (x_v * taille + taille // 2,
                          y_v * taille + taille // 2)
                if not (0 <= cx < img.width and 0 <= cy < img.height):
                    remarque_v = "hors cadre"
                else:
                    dessiner_badge(img, draw_caches, cx, cy, rayon_caches,
                                   COULEURS_CACHES["piece"], numero_v,
                                   chiffres, font_caches)
                    n_badges += 1
                    n_casino += 1
                # légende : vignette = badge or portant le numéro (pas
                # de repli numéro écrit), une récompense par ligne
                entrees_legende.append(
                    (numero_v, libelle_casino(casino_listes[i_vente]), None,
                     cat_v, COULEURS_CACHES["piece"]))
            for const_v, cout_v in casino_listes[i_vente]:
                lignes_csv.append({"carte": stem, "const_carte": carte_const,
                                   "sprite": "", "id_sprite": "", "png": "",
                                   "numero": numero_v, "x_tuiles": x_v,
                                   "y_tuiles": y_v, "mouvement": "",
                                   "direction": "", "text_id": tid_vente,
                                   "type": "casino",
                                   "item_ou_dresseur": const_v,
                                   "cache_debut": "",
                                   "remarque": remarque_v})

        # ---- objets cachés (data/items/) : badge numéroté — compteur
        # « Objets cachés » repartant à 1, dans l'ordre de lecture (Y, X).
        # Disque d'une tuile de diamètre centré sur la tuile, contour
        # noir, numéro composé avec les chiffres de numbers.png (repli
        # police) ; rouge = objet au sol, or = pièce
        for type_c, y_c, x_c, detail_c, routine_c in marqueurs_caches:
            nom_c = libelle_cache(detail_c, routine_c, ids_items,
                                  noms_items, noms_tmhm,
                                  icone_objet=icone_item)
            if img is None:
                lignes_csv.append({"carte": stem, "const_carte": carte_const,
                                   "sprite": "", "id_sprite": "", "png": "",
                                   "numero": "", "x_tuiles": x_c,
                                   "y_tuiles": y_c, "mouvement": "",
                                   "direction": "", "text_id": "",
                                   "type": type_c,
                                   "item_ou_dresseur": detail_c,
                                   "cache_debut": "oui",
                                   "remarque": "sans capture"})
                continue
            cat_c = CATEGORIES[type_c]
            compteurs[cat_c] = compteurs.get(cat_c, 0) + 1
            numero_c = compteurs[cat_c]
            couleur_c = (COULEURS_CACHES["piece"] if type_c == "cache_piece"
                         else COULEURS_CACHES["objet"])
            cx, cy = x_c * taille + taille // 2, y_c * taille + taille // 2
            remarque_c = "" if (0 <= cx < img.width and 0 <= cy < img.height) \
                else "hors cadre"
            if not remarque_c:
                dessiner_badge(img, draw_caches, cx, cy, rayon_caches,
                               couleur_c, numero_c, chiffres,
                               font_caches)
                n_badges += 1
            entrees_legende.append((numero_c, nom_c, None,
                                    cat_c, couleur_c))
            lignes_csv.append({"carte": stem, "const_carte": carte_const,
                               "sprite": "", "id_sprite": "", "png": "",
                               "numero": numero_c,
                               "x_tuiles": x_c, "y_tuiles": y_c,
                               "mouvement": "", "direction": "",
                               "text_id": "", "type": type_c,
                               "item_ou_dresseur": detail_c,
                               "cache_debut": "oui",
                               "remarque": remarque_c})

        if img is not None:
            if not args.sans_legende:
                # le tri par catégorie et par numéro se fait dans la légende
                img = ajouter_legende(img, entrees_legende, taille, chiffres)
            # agrandissement final (sur demande utilisateur : x2 par
            # défaut) — l'image ENTIÈRE, capture annotée ET légende,
            # tout leur contenu compris (sprites, numéros, badges,
            # textes, icônes), en pixels nets (NEAREST) ; --echelle N
            # pour changer le facteur, 1 = taille d'origine
            if args.echelle != 1:
                img = img.resize((img.width * args.echelle,
                                  img.height * args.echelle),
                                 Image.NEAREST)
            if sauver(img, dossier_out, capture.name) is None:
                n_erreurs += 1
            else:
                cartes_annotees += 1
            print(f"{capture.name} : {len(objets)} objet(s), {taille} px/tuile, "
                  f"{colles} sprite(s) collé(s), "
                  f"{len(marqueurs_caches)} objet(s) caché(s)")

    # ---- CSV
    csv_path = dossier_out / "visible_objects.csv"
    with open(csv_path, "w", newline="", encoding="utf-8-sig") as fich:
        colonnes = ["carte", "const_carte", "sprite", "id_sprite", "png", "numero",
                    "x_tuiles", "y_tuiles", "mouvement", "direction",
                    "text_id", "type", "item_ou_dresseur", "cache_debut",
                    "remarque"]
        wcsv = csv.DictWriter(fich, fieldnames=colonnes, delimiter=";")
        wcsv.writeheader()
        wcsv.writerows(lignes_csv)

    detail = ", ".join(f"{k} : {v}" for k, v in detail_ignores.items() if v)
    print(f"\n{n_objets} objets dans {fichiers_avec_objets} fichiers")
    print(f"{n_colles} sprites collés, {n_hors_carte} hors carte, "
          f"{n_ignores} ignorés" + (f" ({detail})" if detail else ""))
    if n_caches:
        etat = "affichés (--avec-caches)" if args.avec_caches else "ignorés"
        print(f"{n_caches} objet(s) invisible(s) au début du jeu : {etat}")
    if n_prioritaires:
        print(f"{n_prioritaires} objet(s) invisible(s) au début du jeu mais "
              f"affiché(s) (TOUJOURS_VISIBLIBLES : rivaux, Mew, Ho-Oh...).")
    if n_badges:
        print(f"{n_badges} badge(s) d'objet(s) caché(s) dessiné(s) "
              f"(objets au sol et pièces de data/items/).")
    if n_magasins:
        print(f"{n_magasins} vendeur(s) de magasin marqué(s) "
              f"(section « Magasin » : un objet en vente par ligne "
              f"avec son prix).")
    if n_casino:
        print(f"{n_casino} panneau(x) de récompenses du casino marqué(s) "
              f"(badge or comme les pièces, prix en jetons — "
              f"data/items/prizes.asm).")
    if offerts_inconnus:
        print("! Pokémon offert non identifié (pas de « lb bc, ESPECE, "
              "NIVEAU » + « call GivePokemon » au n° de texte de l'objet "
              "dans scripts/<carte>.asm) : "
              + ", ".join(sorted(offerts_inconnus))
              + " — à compléter dans DONS_MANUELS.")
    orphelins = sorted(c for c in caches_par_carte if c not in consts_traitees)
    if orphelins:
        print("! Objet(s) caché(s) non reporté(s) — carte(s) sans fichier "
              "d'objets correspondant : " + ", ".join(orphelins))
    print(f"{cartes_annotees} captures annotées dans {dossier_out}")
    if n_erreurs:
        print(f"! {n_erreurs} capture(s) non enregistrée(s) (voir « Impossible "
              "d'enregistrer » ci-dessus)")
    print(f"Récapitulatif : {csv_path} ({len(lignes_csv)} entrées)")
    if sans_capture:
        print(f"{len(sans_capture)} carte(s) sans capture PNG : "
              + ", ".join(sans_capture))


if __name__ == "__main__":
    main()