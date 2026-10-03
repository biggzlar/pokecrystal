MACRO rematch_anchor
; minimum tier, level this party is written for, party
	db \1, \2
	dw \3
ENDM
DEF REMATCH_ANCHOR_SIZE EQU 4

MACRO rematch_mon
; level, species, and either four moves or none at all.
; A mon with no moves listed fights with the moveset it learnt by level, so it
; keeps up as the party is scaled. Spell the moves out to pin down a signature
; set that should never change.
	db \1, \2
	if _NARG == 2
		db NO_MOVE, NO_MOVE, NO_MOVE, NO_MOVE
	else
		db \3, \4, \5, \6
	endc
ENDM

; A leader uses the highest anchor whose tier the player has reached, and their
; first-battle party below that. Either way the levels are scaled to the tier,
; so these parties only need to be written once, at the level noted above them.

GymRematchAnchorParties:

FalknerRematchAnchors:
	rematch_anchor 5,  30, FalknerRematchParty1
	rematch_anchor 9,  46, FalknerRematchParty2
	rematch_anchor 17, 64, FalknerRematchParty3
	db -1 ; end

BugsyRematchAnchors:
	rematch_anchor 5,  30, BugsyRematchParty1
	rematch_anchor 9,  46, BugsyRematchParty2
	rematch_anchor 17, 64, BugsyRematchParty3
	db -1 ; end

WhitneyRematchAnchors:
	rematch_anchor 5,  30, WhitneyRematchParty1
	rematch_anchor 9,  46, WhitneyRematchParty2
	rematch_anchor 17, 64, WhitneyRematchParty3
	db -1 ; end

MortyRematchAnchors:
	rematch_anchor 5,  30, MortyRematchParty1
	rematch_anchor 9,  46, MortyRematchParty2
	rematch_anchor 17, 64, MortyRematchParty3
	db -1 ; end

ChuckRematchAnchors:
	rematch_anchor 9,  46, ChuckRematchParty1
	rematch_anchor 17, 64, ChuckRematchParty2
	db -1 ; end

JasmineRematchAnchors:
	rematch_anchor 9,  46, JasmineRematchParty1
	rematch_anchor 17, 64, JasmineRematchParty2
	db -1 ; end

PryceRematchAnchors:
	rematch_anchor 9,  46, PryceRematchParty1
	rematch_anchor 17, 64, PryceRematchParty2
	db -1 ; end

ClairRematchAnchors:
	rematch_anchor 9,  46, ClairRematchParty1
	rematch_anchor 17, 64, ClairRematchParty2
	db -1 ; end

BrockRematchAnchors:
	rematch_anchor 17, 64, BrockRematchParty1
	db -1 ; end

MistyRematchAnchors:
	rematch_anchor 17, 64, MistyRematchParty1
	db -1 ; end

LtSurgeRematchAnchors:
	rematch_anchor 17, 64, LtSurgeRematchParty1
	db -1 ; end

ErikaRematchAnchors:
	rematch_anchor 17, 64, ErikaRematchParty1
	db -1 ; end

JanineRematchAnchors:
	rematch_anchor 17, 64, JanineRematchParty1
	db -1 ; end

SabrinaRematchAnchors:
	rematch_anchor 17, 64, SabrinaRematchParty1
	db -1 ; end

BlaineRematchAnchors:
	rematch_anchor 17, 64, BlaineRematchParty1
	db -1 ; end

BlueRematchAnchors:
	rematch_anchor 17, 64, BlueRematchParty1
	db -1 ; end

FalknerRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 28, PIDGEOTTO
	rematch_mon 28, DODUO
	rematch_mon 30, NOCTOWL,    HYPNOSIS, CONFUSION, TAKE_DOWN, REFLECT
	db -1 ; end

FalknerRematchParty2:
	db TRAINERTYPE_MOVES
	rematch_mon 44, PIDGEOT
	rematch_mon 44, DODRIO
	rematch_mon 45, NOCTOWL
	rematch_mon 46, SKARMORY,   DRILL_PECK, STEEL_WING, AGILITY, WHIRLWIND
	db -1 ; end

FalknerRematchParty3:
	db TRAINERTYPE_MOVES
	rematch_mon 62, PIDGEOT
	rematch_mon 62, DODRIO
	rematch_mon 62, NOCTOWL
	rematch_mon 63, XATU
	rematch_mon 63, CROBAT
	rematch_mon 64, SKARMORY,   DRILL_PECK, STEEL_WING, FLY, WHIRLWIND
	db -1 ; end

BugsyRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 28, BUTTERFREE
	rematch_mon 28, BEEDRILL
	rematch_mon 30, SCYTHER,    FURY_CUTTER, QUICK_ATTACK, WING_ATTACK, LEER
	db -1 ; end

BugsyRematchParty2:
	db TRAINERTYPE_MOVES
	rematch_mon 44, BUTTERFREE
	rematch_mon 44, ARIADOS
	rematch_mon 45, PINSIR
	rematch_mon 46, SCIZOR,     FURY_CUTTER, METAL_CLAW, AGILITY, SWORDS_DANCE
	db -1 ; end

BugsyRematchParty3:
	db TRAINERTYPE_MOVES
	rematch_mon 62, BUTTERFREE
	rematch_mon 62, ARIADOS
	rematch_mon 62, FORRETRESS
	rematch_mon 63, PINSIR
	rematch_mon 63, HERACROSS
	rematch_mon 64, SCIZOR,     FURY_CUTTER, METAL_CLAW, SWORDS_DANCE, BATON_PASS
	db -1 ; end

WhitneyRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 28, CLEFAIRY
	rematch_mon 28, FURRET
	rematch_mon 30, MILTANK,    ROLLOUT, ATTRACT, STOMP, MILK_DRINK
	db -1 ; end

WhitneyRematchParty2:
	db TRAINERTYPE_MOVES
	rematch_mon 44, CLEFABLE
	rematch_mon 44, FURRET
	rematch_mon 44, GIRAFARIG
	rematch_mon 46, MILTANK,    ROLLOUT, ATTRACT, BODY_SLAM, MILK_DRINK
	db -1 ; end

WhitneyRematchParty3:
	db TRAINERTYPE_MOVES
	rematch_mon 62, CLEFABLE
	rematch_mon 62, FURRET
	rematch_mon 62, GIRAFARIG
	rematch_mon 63, URSARING
	rematch_mon 63, SNORLAX
	rematch_mon 64, MILTANK,    ROLLOUT, ATTRACT, EARTHQUAKE, MILK_DRINK
	db -1 ; end

MortyRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 28, HAUNTER
	rematch_mon 28, HAUNTER
	rematch_mon 30, GENGAR,     HYPNOSIS, SHADOW_BALL, MEAN_LOOK, DREAM_EATER
	db -1 ; end

MortyRematchParty2:
	db TRAINERTYPE_MOVES
	rematch_mon 44, HAUNTER
	rematch_mon 44, MISDREAVUS
	rematch_mon 44, HYPNO
	rematch_mon 46, GENGAR,     HYPNOSIS, SHADOW_BALL, MEAN_LOOK, DREAM_EATER
	db -1 ; end

MortyRematchParty3:
	db TRAINERTYPE_MOVES
	rematch_mon 62, HAUNTER
	rematch_mon 62, MISDREAVUS
	rematch_mon 62, HYPNO
	rematch_mon 63, UMBREON
	rematch_mon 63, NOCTOWL
	rematch_mon 64, GENGAR,     HYPNOSIS, SHADOW_BALL, DESTINY_BOND, DREAM_EATER
	db -1 ; end

ChuckRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 44, PRIMEAPE
	rematch_mon 44, HITMONLEE
	rematch_mon 45, MACHAMP
	rematch_mon 46, POLIWRATH,  DYNAMICPUNCH, MIND_READER, SURF, HYPNOSIS
	db -1 ; end

ChuckRematchParty2:
	db TRAINERTYPE_MOVES
	rematch_mon 62, PRIMEAPE
	rematch_mon 62, HITMONLEE
	rematch_mon 62, HITMONCHAN
	rematch_mon 63, HERACROSS
	rematch_mon 63, MACHAMP
	rematch_mon 64, POLIWRATH,  DYNAMICPUNCH, MIND_READER, SURF, BELLY_DRUM
	db -1 ; end

JasmineRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 44, MAGNETON
	rematch_mon 45, SKARMORY
	rematch_mon 46, STEELIX,    IRON_TAIL, ROCK_SLIDE, SANDSTORM, EARTHQUAKE
	db -1 ; end

JasmineRematchParty2:
	db TRAINERTYPE_MOVES
	rematch_mon 62, MAGNETON
	rematch_mon 62, FORRETRESS
	rematch_mon 63, SKARMORY
	rematch_mon 63, SCIZOR
	rematch_mon 64, STEELIX,    IRON_TAIL, EARTHQUAKE, ROCK_SLIDE, SCREECH
	db -1 ; end

PryceRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 44, DEWGONG
	rematch_mon 44, CLOYSTER
	rematch_mon 45, PILOSWINE
	rematch_mon 46, LAPRAS,     BLIZZARD, SURF, BODY_SLAM, REST
	db -1 ; end

PryceRematchParty2:
	db TRAINERTYPE_MOVES
	rematch_mon 62, DEWGONG
	rematch_mon 62, CLOYSTER
	rematch_mon 62, JYNX
	rematch_mon 63, PILOSWINE
	rematch_mon 64, LAPRAS,     BLIZZARD, SURF, THUNDER, REST
	db -1 ; end

ClairRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 44, DRAGONAIR
	rematch_mon 44, DRAGONAIR
	rematch_mon 45, GYARADOS
	rematch_mon 46, KINGDRA,    DRAGONBREATH, SURF, SMOKESCREEN, HYPER_BEAM
	db -1 ; end

ClairRematchParty2:
	db TRAINERTYPE_MOVES
	rematch_mon 62, DRAGONAIR
	rematch_mon 62, GYARADOS
	rematch_mon 62, AERODACTYL
	rematch_mon 63, DRAGONITE
	rematch_mon 64, KINGDRA,    DRAGONBREATH, SURF, REST, HYPER_BEAM
	db -1 ; end

BrockRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 62, GOLEM
	rematch_mon 62, RHYDON
	rematch_mon 62, OMASTAR
	rematch_mon 63, KABUTOPS
	rematch_mon 63, SUDOWOODO
	rematch_mon 64, STEELIX,    IRON_TAIL, EARTHQUAKE, ROCK_SLIDE, SANDSTORM
	db -1 ; end

MistyRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 62, GOLDUCK
	rematch_mon 62, QUAGSIRE
	rematch_mon 63, LAPRAS
	rematch_mon 63, VAPOREON
	rematch_mon 64, STARMIE,    SURF, ICE_BEAM, RECOVER, CONFUSE_RAY
	db -1 ; end

LtSurgeRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 62, ELECTRODE
	rematch_mon 62, MAGNETON
	rematch_mon 63, JOLTEON
	rematch_mon 63, ELECTABUZZ
	rematch_mon 64, RAICHU,     THUNDERBOLT, THUNDER_WAVE, QUICK_ATTACK, THUNDER
	db -1 ; end

ErikaRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 62, TANGELA
	rematch_mon 62, JUMPLUFF
	rematch_mon 62, SUNFLORA
	rematch_mon 63, VICTREEBEL
	rematch_mon 63, VILEPLUME
	rematch_mon 64, BELLOSSOM,  PETAL_DANCE, SOLARBEAM, SUNNY_DAY, SYNTHESIS
	db -1 ; end

JanineRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 62, WEEZING
	rematch_mon 62, WEEZING
	rematch_mon 62, ARIADOS
	rematch_mon 63, VENOMOTH
	rematch_mon 63, MUK
	rematch_mon 64, CROBAT,     WING_ATTACK, CONFUSE_RAY, TOXIC, SCREECH
	db -1 ; end

SabrinaRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 62, MR__MIME
	rematch_mon 62, HYPNO
	rematch_mon 62, SLOWBRO
	rematch_mon 63, EXEGGUTOR
	rematch_mon 63, ESPEON
	rematch_mon 64, ALAKAZAM,   PSYCHIC_M, RECOVER, FUTURE_SIGHT, REFLECT
	db -1 ; end

BlaineRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 62, MAGCARGO
	rematch_mon 62, MAGMAR
	rematch_mon 62, NINETALES
	rematch_mon 63, HOUNDOOM
	rematch_mon 63, ARCANINE
	rematch_mon 64, RAPIDASH,   FIRE_BLAST, FIRE_SPIN, QUICK_ATTACK, FURY_ATTACK
	db -1 ; end

BlueRematchParty1:
	db TRAINERTYPE_MOVES
	rematch_mon 62, PIDGEOT
	rematch_mon 62, ALAKAZAM
	rematch_mon 62, RHYDON
	rematch_mon 63, EXEGGUTOR
	rematch_mon 63, GYARADOS
	rematch_mon 64, ARCANINE,   FLAMETHROWER, EXTREMESPEED, ROAR, SWIFT
	db -1 ; end
