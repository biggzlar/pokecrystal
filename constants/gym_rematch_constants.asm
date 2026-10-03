; GymRematchTrainers indexes (see data/gym_rematches/trainers.asm)
; Each gym's entries are listed leader first, then that gym's other trainers.
	const_def
	const REMATCH_FALKNER
	const REMATCH_ROD
	const REMATCH_ABE
	const REMATCH_BUGSY
	const REMATCH_AMYANDMAY1
	const REMATCH_AMYANDMAY2
	const REMATCH_BENNY
	const REMATCH_AL
	const REMATCH_JOSH
	const REMATCH_WHITNEY
	const REMATCH_CARRIE
	const REMATCH_BRIDGET
	const REMATCH_VICTORIA
	const REMATCH_SAMANTHA
	const REMATCH_MORTY
	const REMATCH_JEFFREY
	const REMATCH_PING
	const REMATCH_MARTHA
	const REMATCH_GRACE
	const REMATCH_CHUCK
	const REMATCH_YOSHI
	const REMATCH_LAO
	const REMATCH_NOB
	const REMATCH_LUNG
	const REMATCH_JASMINE
	const REMATCH_PRYCE
	const REMATCH_ROXANNE
	const REMATCH_CLARISSA
	const REMATCH_RONALD
	const REMATCH_BRAD
	const REMATCH_DOUGLAS
	const REMATCH_CLAIR
	const REMATCH_PAUL
	const REMATCH_MIKE
	const REMATCH_LOLA
	const REMATCH_CODY
	const REMATCH_FRAN
	const REMATCH_BROCK
	const REMATCH_JERRY
	const REMATCH_MISTY
	const REMATCH_DIANA
	const REMATCH_BRIANA
	const REMATCH_PARKER
	const REMATCH_LT_SURGE
	const REMATCH_GREGORY
	const REMATCH_VINCENT
	const REMATCH_HORTON
	const REMATCH_ERIKA
	const REMATCH_MICHELLE
	const REMATCH_TANYA
	const REMATCH_JULIA
	const REMATCH_JOANDZOE1
	const REMATCH_JOANDZOE2
	const REMATCH_JANINE
	const REMATCH_ALICE
	const REMATCH_LINDA
	const REMATCH_CINDY
	const REMATCH_BARRY
	const REMATCH_SABRINA
	const REMATCH_REBECCA
	const REMATCH_FRANKLIN
	const REMATCH_DORIS
	const REMATCH_JARED
	const REMATCH_BLAINE
	const REMATCH_BLUE
DEF NUM_GYM_REMATCHES EQU const_value

; GymRematchLevelCaps and GymBaseLevels indexes (see data/gym_rematches/trainers.asm)
; A gym's rank is how many badges the player has once its leader is beaten.
	const_def 1
	const GYMRANK_FALKNER
	const GYMRANK_BUGSY
	const GYMRANK_WHITNEY
	const GYMRANK_MORTY
	const GYMRANK_CHUCK
	const GYMRANK_JASMINE
	const GYMRANK_PRYCE
	const GYMRANK_CLAIR
	const GYMRANK_BROCK
	const GYMRANK_MISTY
	const GYMRANK_LT_SURGE
	const GYMRANK_ERIKA
	const GYMRANK_JANINE
	const GYMRANK_SABRINA
	const GYMRANK_BLAINE
	const GYMRANK_BLUE
DEF NUM_GYM_RANKS EQU const_value - 1

; GymRematchTrainers struct members (see data/gym_rematches/trainers.asm)
rsreset
DEF GYM_REMATCH_CLASS   rb
DEF GYM_REMATCH_ID      rb
DEF GYM_REMATCH_RANK    rb
DEF GYM_REMATCH_EVENT   rw
DEF GYM_REMATCH_ANCHORS rw
DEF GYM_REMATCH_SIZE EQU _RS

; a trainer's tier is the player's badge count, plus one for the Elite Four
DEF MAX_GYM_REMATCH_TIER EQU NUM_GYM_RANKS + 1

DEF MAX_GYM_REMATCH_WINS EQU 15

; a party copied into wGymRematchParty: type byte, up to 6 TRAINERTYPE_ITEM_MOVES mons, terminator
DEF GYM_REMATCH_PARTY_LENGTH EQU 1 + PARTY_LENGTH * (3 + NUM_MOVES) + 1
