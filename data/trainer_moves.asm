

;joenote - commenting this all out because yellow's method is now being used
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;LoneMoves:
;; these are used for gym leaders.
;; this is not automatic! you have to write the number you want to wLoneAttackNo
;; first. e.g.,erika's script writes 4 to wLoneAttackNo to get mega drain,
;; the fourth entry in the list.
;
;; first byte:  pokemon in the trainer's party that gets the move
;; second byte: move
;; unterminated
;	db 1,BIDE
;	db 1,BUBBLEBEAM
;	db 2,THUNDERBOLT
;	db 2,MEGA_DRAIN
;	db 3,TOXIC
;	db 3,PSYWAVE
;	db 3,FIRE_BLAST
;	db 4,FISSURE
;
;TeamMoves:
;; these are used for elite four.
;; this is automatic,based on trainer class.
;; don't be confused by LoneMoves above,the two data structures are
;	; _completely_ unrelated.
;
;; first byte: trainer (all trainers in this class have this move)
;; second byte: move
;; ff-terminated
;	db LORELEI,BLIZZARD
;	db BRUNO,FISSURE
;	db AGATHA,TOXIC
;	db LANCE,BARRIER
;	db $FF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; yellow has its own format.

; entry = trainerclass,trainerid,moveset+,0
; moveset = partymon location,partymon's move,moveid
SpecialTrainerMoves:
	db YOUNGSTER,14
	db 1,4,FISSURE
	db 0

	db BROCK,1
	db 1,3,ROCK_THROW
	db 2,1,CONSTRICT
	db 2,3,BIDE
	db 2,4,BIND
	db 0

	db BROCK,2
	db 1,1,BLIZZARD
	db 2,1,FISSURE
	db 4,1,BODY_SLAM
	db 5,2,SOLARBEAM
	db 5,3,CONFUSE_RAY
	db 6,1,FLY
	db 6,3,EARTHQUAKE
	db 6,4,DOUBLE_EDGE
	db 0

	;joenote - give the abra of the cerulean rival something to do
	;		-assume the rival got some TMs from Celadon City
	db SONY1, $7
	;pidgeotto - gust, sand attack, quick attack
	;abra - teleport, counter, tri attack
	db 2,2,COUNTER
	db 2,3,TRI_ATTACK
	;rattata - tackle, tail whip, quick attack, hyper fang
	;squirtle - tackle, tail whip, bubble, water gun
	db 0

	db SONY1, $8
	;pidgeotto - gust, sand attack, quick attack
	;abra - teleport, counter, tri attack
	db 2,2,COUNTER
	db 2,3,TRI_ATTACK
	;rattata - tackle, tail whip, quick attack, hyper fang
	;bulbasaur - tackle, growl, leech seed, vine whip
	db 0

	db SONY1, $9
	;pidgeotto - gust, sand attack, quick attack
	;abra - teleport, counter, tri attack
	db 2,2,COUNTER
	db 2,3,TRI_ATTACK
	;rattata - tackle, tail whip, quick attack, hyper fang
	;charmander - scratch, growl, ember, leer
	db 0

	db MISTY,1
	db 2,1,TAIL_WHIP
	db 0

	db MISTY,2
	db 1,1,ICE_BEAM
	db 1,2,DOUBLE_TEAM
	db 2,1,BLIZZARD
	db 3,1,PSYCHIC_M
	db 3,2,THUNDER
	db 4,1,SURF
	db 4,2,EARTHQUAKE
	db 4,4,REFLECT
	db 5,1,SUBSTITUTE
	db 5,3,BLIZZARD
	db 6,1,SURF
	db 6,3,RECOVER
	db 6,4,THUNDERBOLT
	db 0

	db LT_SURGE,1 ; db $FF,29,RAICHU,0
	db 1,1,THUNDERBOLT
	db 1,2,THUNDER_WAVE
	db 1,3,BODY_SLAM
	db 1,4,SURF
	db 0

	db LT_SURGE,2 ; db $FF,64,ELECTRODE,65,MAGNETON,64,JOLTEON,64,PORYGON,64,ELECTABUZZ,65,RAICHU,0
	db 1,2,THUNDER_WAVE
	db 2,1,THUNDER_WAVE
	db 2,3,REFLECT
	db 3,1,HEADBUTT
	db 3,2,DIG
	db 4,1,THUNDER
	db 4,2,BLIZZARD
	db 4,3,RECOVER
	db 5,1,ICE_PUNCH
	db 5,3,PSYCHIC_M
	db 6,1,SURF
	db 6,2,CUT
	db 6,3,THUNDER
	db 6,4,THUNDER_WAVE
	db 0

	db ERIKA,1 ; db $FF,33,TANGELA,34,VICTREEBEL,31,IVYSAUR,35,VILEPLUME,0
	db 1,1,BIND
	db 3,1,RAZOR_LEAF
	db 3,2,ACID
	db 3,3,LEECH_SEED
	db 4,1,ACID
	db 4,2,SOLARBEAM
	db 4,3,STUN_SPORE
	db 4,4,SLEEP_POWDER
	db 0

	db ERIKA,2 ; db $FF,41,TANGELA,42,VICTREEBEL,42,VENUSAUR,43,VILEPLUME,0
	db 1,1,BIND
	db 1,2,BODY_SLAM
    db 2,1,SWORDS_DANCE
	db 2,2,WRAP
    db 3,1,RAZOR_LEAF
    db 3,2,LEECH_SEED
    db 3,3,SLUDGE
    db 4,2,SLEEP_POWDER
    db 0 

	db ERIKA,3 ; db $FF,48,TANGELA,49,VICTREEBEL,48,VENUSAUR,49,EXEGGUTOR,50,VILEPLUME,0
	db 1,2,STUN_SPORE
    db 1,3,SOLARBEAM
    db 2,4,SWORDS_DANCE
    db 3,2,SOLARBEAM
    db 3,3,LEECH_SEED
    db 4,1,REFLECT
    db 5,1,LEECH_SEED
    db 0

	db ERIKA,4
	db 1,3,STUN_SPORE
	db 2,2,LEECH_SEED
	db 2,3,SLEEP_POWDER
	db 2,4,RAZOR_LEAF
	db 3,1,LEECH_LIFE
	db 3,3,SOLARBEAM
	db 4,1,MEGA_DRAIN
	db 4,2,SUBSTITUTE
	db 5,1,MEGA_DRAIN
	db 5,3,GROWTH
	db 6,2,LEECH_SEED
	db 6,3,SUBSTITUTE
	db 6,4,MEGA_DRAIN
    db 0

	db KOGA,1 ; 42,GOLBAT,42,MUK,41,TENTACRUEL,43,VENOMOTH,0
	db 1,2,TOXIC
	db 1,3,BITE
	db 2,1,ACID_ARMOR
	db 2,3,MEGA_DRAIN
	db 3,1,SURF
	db 3,2,ICE_BEAM
	db 3,4,SLUDGE
	db 4,1,SOLARBEAM
	db 4,2,DOUBLE_TEAM
	db 4,3,TOXIC
	db 0

	db KOGA,2 ; 49,GOLBAT,48,MUK,49,TENTACRUEL,48,WEEZING,50,VENOMOTH,0
	db 1,1,TOXIC
	db 1,2,CONFUSE_RAY
	db 1,4,BITE
	db 2,2,MEGA_DRAIN
	db 2,4,ACID_ARMOR
	db 3,2,SURF
	db 3,3,ICE_BEAM
	db 4,2,SLUDGE
	db 4,3,THUNDERBOLT
	db 5,1,SOLARBEAM
	db 5,2,DOUBLE_TEAM
	db 5,3,TOXIC
	db 0

	db KOGA,3
	db 1,1,FLY
	db 1,2,TOXIC
	db 1,3,DOUBLE_TEAM
	db 1,4,CONFUSE_RAY
	db 2,3,MEGA_DRAIN
	db 2,4,MINIMIZE
	db 3,1,SURF
	db 3,3,BLIZZARD
	db 3,4,REFLECT
	db 4,2,FIRE_BLAST
	db 4,3,THUNDERBOLT
	db 4,4,SLUDGE
	db 5,2,EARTHQUAKE
	db 5,3,ROCK_SLIDE
	db 6,1,DOUBLE_TEAM
	db 6,4,LEECH_LIFE
	db 0

	db SABRINA,1 ; db $FF,50,ABRA, 48,HYPNO,49,MR_MIME,50,KADABRA, 50,ALAKAZAM,0
	db 1,1,PSYCHIC_M
	db 2,2,PSYWAVE
	db 3,1,LIGHT_SCREEN
	db 3,2,MIMIC
	db 4,1,REFLECT
	db 4,2,PSYWAVE
	db 4,3,PSYCHIC_M
	db 4,4,RECOVER 
	db 5,1,THUNDER_WAVE
	db 0

	db SABRINA,2 ; db $FF,43,ABRA, 42,MR_MIME,43,KADABRA, 43,ALAKAZAM,0
	db 1,1,PSYCHIC_M
	db 2,1,SUBSTITUTE
	db 2,1,LIGHT_SCREEN
	db 2,2,MIMIC
	db 2,3,SUBSTITUTE
	db 2,4,PSYCHIC_M
	db 3,1,PSYWAVE
	db 4,1,THUNDER_WAVE
	db 0

	db SABRINA,3 ; db $FF,65,MR_MIME,64,HYPNO,64,SLOWBRO,64,JYNX,64,GENGAR,65,ALAKAZAM,0
	db 1,1,THUNDERBOLT
	db 1,4,THUNDER_WAVE
	db 2,1,SUBSTITUTE
	db 2,2,PSYWAVE
	db 3,1,SURF
	db 3,2,REFLECT
	db 4,1,LOVELY_KISS
	db 4,2,DREAM_EATER
	db 4,3,BUBBLEBEAM
	db 5,1,PSYCHIC_M
	db 5,3,DOUBLE_TEAM
	db 5,4,MEGA_DRAIN
	db 6,1,THUNDER_WAVE
	db 0

	db BLAINE,1
	db 2,1,FIRE_BLAST
	db 2,2,WING_ATTACK
	db 2,3,SLASH
	db 2,4,SEISMIC_TOSS
	db 3,1,FIRE_BLAST
	db 3,2,CONFUSE_RAY
	db 3,3,SOLARBEAM
	db 4,1,FIRE_BLAST 
	db 4,2,DOUBLE_EDGE
	db 4,3,DIG
	db 5,1,FIRE_BLAST
	db 5,2,PSYCHIC_M
	db 5,3,CONFUSE_RAY
	db 5,4,THUNDERPUNCH
	db 0

	db BLAINE,2
	db 1,2,AGILITY
	db 1,3,SOLARBEAM
	db 1,4,HORN_DRILL
	db 2,4,DIG
	db 3,2,FIRE_BLAST
	db 3,3,EARTHQUAKE
	db 3,4,SWORDS_DANCE
	db 4,2,CONFUSE_RAY
	db 4,3,SOLARBEAM
	db 5,1,FIRE_BLAST
	db 5,2,DIG
	db 5,3,DOUBLE_EDGE
	db 6,1,THUNDERPUNCH
	db 6,2,PSYCHIC_M
	db 6,3,CONFUSE_RAY
	db 0

	db GIOVANNI,1
	db 1,1,ROCK_THROW
	db 1,2,DIG
	db 1,3,SCREECH
	db 1,4,TAKE_DOWN
	db 2,1,MEGA_PUNCH
	db 2,2,SUBMISSION
	db 3,1,BONE_CLUB
	db 3,2,HEADBUTT
	db 3,3,CUT
	db 4,1,TAKE_DOWN
	db 4,2,BUBBLEBEAM
	db 4,3,THUNDERBOLT
	db 0

	db GIOVANNI,2
	db 1,1,CRABHAMMER
	db 1,2,CUT 
	db 1,3,BODY_SLAM
	db 2,1,ICE_PUNCH
	db 2,2,ROCK_SLIDE
	db 2,3,SUBMISSION
	db 3,1,DIG
	db 3,3,ROCK_SLIDE
	db 4,1,EARTHQUAKE
	db 4,2,ROCK_SLIDE
	db 4,3,EXPLOSION
	db 5,1,SLASH
	db 5,2,BUBBLEBEAM
	db 5,3,THUNDERBOLT
	db 0

	db GIOVANNI,3 ; 53,DUGTRIO,54,NIDOQUEEN,55,PERSIAN, 54,NIDOKING,55,RHYDON
	db 1,1,EARTHQUAKE
	db 1,2,SLASH
	db 1,3,FISSURE
	db 1,4,ROCK_SLIDE
	db 2,1,EARTHQUAKE
	db 2,2,ICE_BEAM
	db 2,3,THUNDERBOLT
	db 2,4,BODY_SLAM
	db 3,1,SLASH
	db 3,2,HYPER_BEAM
	db 3,3,BUBBLEBEAM
	db 3,4,THUNDERBOLT
	db 4,1,EARTHQUAKE
	db 4,2,BLIZZARD
	db 4,3,THUNDER
	db 4,4,SLUDGE
	db 5,1,ROCK_SLIDE
	db 5,2,EARTHQUAKE
	db 5,3,SUBMISSION
	db 5,4,THUNDERBOLT
	db 0

	db LORELEI,1 ; 56,SLOWBRO,55,CLOYSTER,55,DEWGONG, 56,JYNX,57,LAPRAS
	db 1,1,EARTHQUAKE
	db 1,2,BLIZZARD
	db 2,1,SURF
	db 2,3,EXPLOSION
	db 3,1,SURF
	db 3,2,REST
	db 4,2,BUBBLEBEAM
	db 4,3,LOVELY_KISS
	db 5,1,THUNDERBOLT
	db 5,3,SURF
	db 0

	db LORELEI,2 ; db $FF,70,WIGGLYTUFF,71,STARMIE,71,CLOYSTER,70,OMASTAR,70,EXEGGUTOR,72,LAPRAS,0
    db 1,4,BLIZZARD
    db 2,1,THUNDER_WAVE
    db 2,3,THUNDER
    db 2,4,SURF
    db 3,3,TOXIC
    db 3,4,EXPLOSION
    db 4,1,BLIZZARD
    db 4,3,HORN_DRILL
    db 5,1,LEECH_SEED
    db 6,1,CONFUSE_RAY
    db 6,2,PSYCHIC_M
    db 6,3,SURF
	db 0

	db BRUNO,1 ; 57,HITMONCHAN,56,POLIWRATH,57,HITMONLEE,56,ONIX,58,MACHAMP
	db 1,3,ICE_PUNCH
	db 1,4,THUNDERPUNCH
	db 2,1,ICE_BEAM
	db 3,1,BODY_SLAM
	db 4,1,EXPLOSION
	db 5,1,BODY_SLAM
	db 5,2,ROCK_SLIDE
	db 5,3,EARTHQUAKE
	db 0

	db BRUNO,2 ; db $FF,71,CLEFABLE,71,MUK,70,SLOWBRO,72,HITMONLEE,72,RHYDON,73,MACHAMP,0
	db 1,1,SOFTBOILED
    db 1,2,PSYCHIC_M
    db 1,3,ICE_BEAM
    db 1,4,THUNDERBOLT
    db 2,3,MINIMIZE
    db 2,4,FIRE_BLAST
    db 3,1,DOUBLE_TEAM
    db 3,2,SURF
    db 4,1,BODY_SLAM
    db 4,2,DOUBLE_TEAM
    db 4,4,METRONOME
    db 5,3,BODY_SLAM
    db 5,4,SURF
    db 6,1,EARTHQUAKE
    db 6,2,HYPER_BEAM
    db 6,3,ROCK_SLIDE
	db 0

	db AGATHA,1 ; 57,GENGAR,58,GOLBAT,57,MAROWAK,58,ARBOK,59,GENGAR
	db 1,1,MEGA_DRAIN
	db 2,1,FLY
	db 2,2,TOXIC
	db 2,4,DOUBLE_TEAM
	db 3,1,SWORDS_DANCE
	db 3,2,BODY_SLAM
	db 3,3,ROCK_SLIDE 
	db 4,2,SUBSTITUTE
	db 5,1,PSYCHIC_M
	db 5,3,MEGA_DRAIN
	db 5,4,THUNDER
	db 0

	db AGATHA,2 ; db $FF,71,JYNX,71,GYARADOS,72,ALAKAZAM,71,VENUSAUR,72,ARBOK,73,GENGAR,0
    db 1,2,LOVELY_KISS
    db 1,3,REFLECT
    db 2,1,FIRE_BLAST
    db 2,2,THUNDERBOLT
    db 2,3,SURF
    db 3,1,THUNDER_WAVE
    db 3,4,SUBSTITUTE
    db 4,1,SLEEP_POWDER
    db 4,2,DOUBLE_EDGE
    db 4,3,LEECH_SEED
    db 5,2,EARTHQUAKE
    db 6,1,CONFUSE_RAY
    db 6,3,EXPLOSION
    db 6,4,THUNDERBOLT
	db 0

	db LANCE,1 ; 61,DRAGONITE,60,GYARADOS,60,CHARIZARD,61,AERODACTYL,62,DRAGONITE
	db 1,1,WRAP
	db 1,3,THUNDER_WAVE
	db 2,1,FLY
	db 2,2,SURF
	db 2,3,SLAM
	db 3,3,HYPER_BEAM
	db 3,4,EARTHQUAKE
	db 4,3,EARTHQUAKE
	db 5,1,BLIZZARD
	db 5,2,FIRE_BLAST
	db 5,3,THUNDER
	db 0

	db LANCE,2 ; db $FF,73,ARCANINE,73,ELECTABUZZ,74,SNORLAX,74,CHARIZARD,72,KANHASKHAN,75,DRAGONITE,0
	db 1,1,DRAGON_RAGE
    db 1,2,FIRE_BLAST
    db 1,3,HYPER_BEAM
    db 1,4,DIG
    db 2,1,THUNDER_WAVE
    db 2,4,PSYCHIC_M
    db 3,1,SELFDESTRUCT
    db 3,2,EARTHQUAKE
    db 3,3,REFLECT
    db 4,1,SLASH
    db 4,2,FIRE_BLAST
    db 4,3,EARTHQUAKE
    db 4,4,DOUBLE_TEAM
    db 5,1,HYPER_BEAM
    db 5,2,SUBMISSION
    db 5,3,EARTHQUAKE
    db 5,4,ROCK_SLIDE
    db 6,1,THUNDER
    db 6,2,THUNDER_WAVE
    db 6,3,BLIZZARD
	db 0

	db SONY3,$1
	;pidgeot
	db 1,1,SKY_ATTACK
	db 1,2,TRI_ATTACK
	db 1,3,MIMIC
	db 1,4,DOUBLE_TEAM
	;alakazam - thunderwave, recover, psychic, reflect
	db 2,1,THUNDER_WAVE
	;rhydon
	db 3,1,THUNDERBOLT
	db 3,2,EARTHQUAKE
	db 3,3,ROCK_SLIDE
	db 3,4,TAKE_DOWN
	;arcanine - reflect, rest, double edge, flamethrower
	db 4,1,REFLECT
	db 4,2,REST
	db 4,3,DOUBLE_EDGE
	;exeggutor - leech seed, stomp, solar beam, hypnosis
	db 5,1,LEECH_SEED
	;blastoise - blizzard, reflect, skull bash, hydro pump
	db 6,1,BLIZZARD
	db 6,2,REFLECT
	db 0

	db SONY3,$2
	;pidgeot
	db 1,1,SKY_ATTACK
	db 1,2,TRI_ATTACK
	db 1,3,MIMIC
	db 1,4,DOUBLE_TEAM
	;alakazam - thunderwave, recover, psychic, reflect
	db 2,1,THUNDER_WAVE
	;rhydon
	db 3,1,THUNDERBOLT
	db 3,2,EARTHQUAKE
	db 3,3,ROCK_SLIDE
	db 3,4,TAKE_DOWN
	;gyarados - ice beam, body slam, hydro pump, hyperbeam
	db 4,1,ICE_BEAM
	db 4,2,BODY_SLAM
	;arcanine - reflect, rest, double edge, flamethrower
	db 5,1,REFLECT
	db 5,2,REST
	db 5,3,DOUBLE_EDGE
	;venusaur - razor leaf, toxic, sleep powder, solar beam
	db 6,2,TOXIC
	db 0

	db SONY3,$3
	;pidgeot
	db 1,1,SKY_ATTACK
	db 1,2,TRI_ATTACK
	db 1,3,MIMIC
	db 1,4,DOUBLE_TEAM
	;alakazam - thunderwave, recover, psychic, reflect
	db 2,1,THUNDER_WAVE
	;rhydon
	db 3,1,THUNDERBOLT
	db 3,2,EARTHQUAKE
	db 3,3,ROCK_SLIDE
	db 3,4,TAKE_DOWN
	;exeggutor - leech seed, stomp, solar beam, hypnosis
	db 4,1,LEECH_SEED
	;gyarados - ice beam, body slam, hydro pump, hyperbeam
	db 5,1,ICE_BEAM
	db 5,2,BODY_SLAM
	;charizard - fly, slash, fire blast, fire spin
	db 6,1,FLY
	db 6,3,FIRE_BLAST
	db 0

	;prof oak's pokemon
	db PROF_OAK,$1
	;tauros - tail whip, earthquake, thunderbolt, hyperbeam
	db 1,2,EARTHQUAKE
	db 1,3,THUNDERBOLT
	db 1,4,HYPER_BEAM
	;exeggutor - reflect, stomp, solarbeam, hypnosis
	;arcanine - bite, fire blast, takedown, flamethrower
	db 3,2,FIRE_BLAST
	;blastoise - bite, withdraw, blizzard, hydro pump
	db 4,3,BLIZZARD
	;gyarados - thunderbolt, ice beam, hydro pump, hyper beam
	db 5,1,THUNDERBOLT
	db 5,2,ICE_BEAM
	db 0
	
	db PROF_OAK,$2
	;tauros - tail whip, earthquake, thunderbolt, hyperbeam
	db 1,2,EARTHQUAKE
	db 1,3,THUNDERBOLT
	db 1,4,HYPER_BEAM
	;exeggutor - reflect, stomp, solarbeam, hypnosis
	;arcanine - bite, fire blast, takedown, flamethrower
	db 3,2,FIRE_BLAST
	;venusaur - razor leaf, growth, body slam, solar beam
	db 4,3,BODY_SLAM
	;gyarados - thunderbolt, ice beam, hydro pump, hyper beam
	db 5,1,THUNDERBOLT
	db 5,2,ICE_BEAM
	db 0
	
	db PROF_OAK,$3
	;tauros - tail whip, earthquake, thunderbolt, hyperbeam
	db 1,2,EARTHQUAKE
	db 1,3,THUNDERBOLT
	db 1,4,HYPER_BEAM
	;exeggutor - reflect, stomp, solarbeam, hypnosis
	;arcanine - bite, fire blast, takedown, flamethrower
	db 3,2,FIRE_BLAST
	;charizard - toxic, slash, flamethrower, fire spin
	db 4,1,TOXIC
	;gyarados - thunderbolt, ice beam, hydro pump, hyper beam
	db 5,1,THUNDERBOLT
	db 5,2,ICE_BEAM
	db 0
	
	;mr fuji battle
	db GENTLEMAN,$5
	;marowak
	db 1,1,BONEMERANG
	db 1,2,BODY_SLAM
	db 1,3,SEISMIC_TOSS
	db 1,4,BLIZZARD
	;omastar
	db 2,1,HYDRO_PUMP
	db 2,2,ICE_BEAM
	db 2,3,REFLECT
	db 2,4,TOXIC
	;kabutops
	db 3,1,SWORDS_DANCE
	db 3,2,SURF
	db 3,3,SLASH
	db 3,4,DOUBLE_EDGE
	;aerodactyl
	db 4,1,SKY_ATTACK
	db 4,2,REFLECT
	db 4,3,HYPER_BEAM
	db 4,4,SUPERSONIC
	;arcanine
	db 5,1,FIRE_BLAST
	db 5,2,BODY_SLAM
	db 5,3,MIMIC
	db 5,4,HYPER_BEAM
	db 0
		
	;Chief battle
	db CHIEF,$1
	;kangaskhan
	db 1,1,BODY_SLAM
	db 1,2,SUBMISSION
	db 1,3,FIRE_BLAST
	db 1,4,HYPER_BEAM
	;rhydon
	db 2,1,THUNDERBOLT
	db 2,2,ROCK_SLIDE
	db 2,3,SUBSTITUTE
	db 2,4,EARTHQUAKE
	;golduck
	db 3,1,AMNESIA
	db 3,2,BLIZZARD
	db 3,3,SURF
	db 3,4,MIMIC
	;pinsir
	db 4,1,SLASH
	db 4,2,SWORDS_DANCE
	db 4,3,SEISMIC_TOSS
	db 4,4,BODY_SLAM
	;scyther
	db 5,1,SWORDS_DANCE
	db 5,2,SLASH
	db 5,3,AGILITY
	db 5,4,DOUBLE_EDGE
	;tauros
	db 6,1,HYPER_BEAM
	db 6,2,DOUBLE_EDGE
	db 6,3,STOMP
	db 6,4,REST
	db 0

	;Red battle
	db JR_TRAINER_M,$9
	;lapras
	db 1,1,BLIZZARD
	db 1,2,THUNDERBOLT
	db 1,3,BODY_SLAM
	db 1,4,CONFUSE_RAY
	;venusaur
	db 2,1,RAZOR_LEAF
	db 2,2,SLEEP_POWDER
	db 2,3,BODY_SLAM
	db 2,4,SWORDS_DANCE
	;charizard
	db 3,1,FIRE_BLAST
	db 3,2,EARTHQUAKE
	db 3,3,SWORDS_DANCE
	db 3,4,HYPER_BEAM
	;blastoise
	db 4,1,HYDRO_PUMP
	db 4,2,BLIZZARD
	db 4,3,BODY_SLAM
	db 4,4,EARTHQUAKE
	;snorlax
	db 5,1,HYPER_BEAM
	db 5,2,REST
	db 5,3,BODY_SLAM
	db 5,4,EARTHQUAKE
	;pikachu
	db 6,1,THUNDER
	db 6,2,THUNDER_WAVE
	db 6,3,SURF
	db 6,4,DOUBLE_TEAM
	db 0
	
	;multi missingno superboss battle
	db CHIEF,$3
	db 1,1,LEECH_SEED
	db 1,2,TOXIC
	db 1,3,SUPER_FANG
	db 1,4,NIGHT_SHADE
	db 2,1,EARTHQUAKE
	db 2,2,HYPER_BEAM
	db 2,3,CONFUSE_RAY
	db 2,4,SPORE
	db 3,1,PSYCHIC_M
	db 3,2,BLIZZARD
	db 3,3,THUNDER_WAVE
	db 3,4,REST
	db 0

	db JOY,1 ; db 62,KANGASKHAN,SNORLAX,STARMIE,PORYGON,EXEGGUTOR,CHANSEY,0
	db 1,1,REST
    db 1,2,DOUBLE_TEAM
    db 1,3,FISSURE
    db 2,2,ICE_BEAM
    db 2,3,AMNESIA
    db 2,4,DOUBLE_TEAM
    db 3,1,RECOVER
    db 3,3,THUNDER_WAVE
    db 3,4,SUBSTITUTE
    db 4,1,REFLECT
    db 4,2,BLIZZARD
    db 4,3,RECOVER
    db 4,4,THUNDER_WAVE
    db 5,1,SOFTBOILED
    db 5,2,REFLECT
    db 5,3,DREAM_EATER
    db 6,1,SOFTBOILED
    db 6,2,REFLECT
    db 6,3,EGG_BOMB
    db 6,4,THUNDER_WAVE
	db 0

	db JENNY,1 ; db 62,PIDGEOT,BLASTOISE,TANGELA,GENGAR,PARASECT,ARCANINE,0
	db 1,1,TAKE_DOWN
    db 1,4,TOXIC
    db 2,1,SURF
    db 2,2,EARTHQUAKE
    db 2,4,BODY_SLAM
    db 3,2,SLEEP_POWDER
    db 3,3,MIMIC
    db 4,1,PSYCHIC_M
    db 4,4,THUNDERBOLT
    db 5,4,LEECH_LIFE
    db 6,1,REFLECT
    db 6,2,FIRE_BLAST
    db 6,3,BODY_SLAM
    db 6,4,DIG
	db 0

	db JESSIE_JAMES,1 ; db 15,EKANS,MEOWTH,KOFFING,0
	db 1,1,LEER
    db 1,2,POISON_STING
    db 1,3,BITE
    db 1,4,ACID
    db 2,1,SCRATCH
    db 2,2,GROWL
    db 2,3,FURY_SWIPES
    db 2,4,BITE
    db 3,1,TACKLE
    db 3,2,SMOG
	db 0

	db JESSIE_JAMES,2 ; db 28,KOFFING,MEOWTH,ARBOK,0
	db 1,1,TACKLE
    db 1,2,SMOG
	db 1,3,ACID
	db 1,4,SMOKESCREEN
    db 2,1,BITE
    db 2,2,PAY_DAY
    db 2,3,SCREECH
    db 2,4,TAKE_DOWN
	db 3,1,BITE
    db 3,2,ACID
    db 3,3,SUBSTITUTE
    db 3,4,GLARE
	db 0

	db JESSIE_JAMES,3 ; db $FF,33,MEOWTH,31,ARBOK,30,LICKITUNG,31,WEEZING,0
	db 1,1,BITE
    db 1,2,PAY_DAY
    db 1,3,SCREECH
    db 1,4,TAKE_DOWN
    db 2,1,ACID
    db 2,2,SUBSTITUTE
    db 2,3,GLARE
    db 2,4,SCREECH
    db 3,1,STOMP
    db 3,2,DISABLE
	db 3,3,HEADBUTT
	db 3,4,DEFENSE_CURL
	db 4,1,TACKLE
	db 4,2,SMOG
	db 4,3,ACID
	db 4,4,SMOKESCREEN
	db 0


	db JESSIE_JAMES,4 ; db $FF,42,WEEZING,41,LICKITUNG,42,ARBOK,44,MEOWTH,43,VICTREEBEL,0
	db 1,1,SMOKESCREEN
    db 1,2,SLUDGE_BOMB
    db 1,3,AMNESIA
    db 1,4,SELFDESTRUCT
    db 2,1,HEADBUTT
    db 2,2,DEFENSE_CURL
    db 2,3,BODY_SLAM
    db 2,4,SCREECH
    db 3,1,GLARE
    db 3,2,SCREECH
	db 3,3,SLUDGE
	db 3,4,WRAP
	db 4,1,PAY_DAY
	db 4,2,SCREECH
	db 4,3,TAKE_DOWN
	db 4,4,SLASH
	db 5,1,ACID
	db 5,2,RAZOR_LEAF
	db 5,3,SLUDGE
	db 5,4,WRAP
	db 0

	db $ff
	