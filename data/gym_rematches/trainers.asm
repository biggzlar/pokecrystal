MACRO gym_rematch_entry
; trainer class, trainer id, gym rank, EVENT_BEAT_* flag, anchor parties
	db \1, \2, \3
	dw \4, \5
ENDM

GymRematchTrainers:
; entries correspond to REMATCH_* constants
	table_width GYM_REMATCH_SIZE
	gym_rematch_entry FALKNER,      FALKNER1,           GYMRANK_FALKNER,  EVENT_BEAT_FALKNER,             FalknerRematchAnchors
	gym_rematch_entry BIRD_KEEPER,  ROD,                GYMRANK_FALKNER,  EVENT_BEAT_BIRD_KEEPER_ROD,     0
	gym_rematch_entry BIRD_KEEPER,  ABE,                GYMRANK_FALKNER,  EVENT_BEAT_BIRD_KEEPER_ABE,     0
	gym_rematch_entry BUGSY,        BUGSY1,             GYMRANK_BUGSY,    EVENT_BEAT_BUGSY,               BugsyRematchAnchors
	gym_rematch_entry TWINS,        AMYANDMAY1,         GYMRANK_BUGSY,    EVENT_BEAT_TWINS_AMY_AND_MAY,   0
	gym_rematch_entry TWINS,        AMYANDMAY2,         GYMRANK_BUGSY,    EVENT_BEAT_TWINS_AMY_AND_MAY,   0
	gym_rematch_entry BUG_CATCHER,  BUG_CATCHER_BENNY,  GYMRANK_BUGSY,    EVENT_BEAT_BUG_CATCHER_BENNY,   0
	gym_rematch_entry BUG_CATCHER,  AL,                 GYMRANK_BUGSY,    EVENT_BEAT_BUG_CATCHER_AL,      0
	gym_rematch_entry BUG_CATCHER,  JOSH,               GYMRANK_BUGSY,    EVENT_BEAT_BUG_CATCHER_JOSH,    0
	gym_rematch_entry WHITNEY,      WHITNEY1,           GYMRANK_WHITNEY,  EVENT_BEAT_WHITNEY,             WhitneyRematchAnchors
	gym_rematch_entry LASS,         CARRIE,             GYMRANK_WHITNEY,  EVENT_BEAT_LASS_CARRIE,         0
	gym_rematch_entry LASS,         BRIDGET,            GYMRANK_WHITNEY,  EVENT_BEAT_LASS_BRIDGET,        0
	gym_rematch_entry BEAUTY,       VICTORIA,           GYMRANK_WHITNEY,  EVENT_BEAT_BEAUTY_VICTORIA,     0
	gym_rematch_entry BEAUTY,       SAMANTHA,           GYMRANK_WHITNEY,  EVENT_BEAT_BEAUTY_SAMANTHA,     0
	gym_rematch_entry MORTY,        MORTY1,             GYMRANK_MORTY,    EVENT_BEAT_MORTY,               MortyRematchAnchors
	gym_rematch_entry SAGE,         JEFFREY,            GYMRANK_MORTY,    EVENT_BEAT_SAGE_JEFFREY,        0
	gym_rematch_entry SAGE,         PING,               GYMRANK_MORTY,    EVENT_BEAT_SAGE_PING,           0
	gym_rematch_entry MEDIUM,       MARTHA,             GYMRANK_MORTY,    EVENT_BEAT_MEDIUM_MARTHA,       0
	gym_rematch_entry MEDIUM,       GRACE,              GYMRANK_MORTY,    EVENT_BEAT_MEDIUM_GRACE,        0
	gym_rematch_entry CHUCK,        CHUCK1,             GYMRANK_CHUCK,    EVENT_BEAT_CHUCK,               ChuckRematchAnchors
	gym_rematch_entry BLACKBELT_T,  YOSHI,              GYMRANK_CHUCK,    EVENT_BEAT_BLACKBELT_YOSHI,     0
	gym_rematch_entry BLACKBELT_T,  LAO,                GYMRANK_CHUCK,    EVENT_BEAT_BLACKBELT_LAO,       0
	gym_rematch_entry BLACKBELT_T,  NOB,                GYMRANK_CHUCK,    EVENT_BEAT_BLACKBELT_NOB,       0
	gym_rematch_entry BLACKBELT_T,  LUNG,               GYMRANK_CHUCK,    EVENT_BEAT_BLACKBELT_LUNG,      0
	gym_rematch_entry JASMINE,      JASMINE1,           GYMRANK_JASMINE,  EVENT_BEAT_JASMINE,             JasmineRematchAnchors
	gym_rematch_entry PRYCE,        PRYCE1,             GYMRANK_PRYCE,    EVENT_BEAT_PRYCE,               PryceRematchAnchors
	gym_rematch_entry SKIER,        ROXANNE,            GYMRANK_PRYCE,    EVENT_BEAT_SKIER_ROXANNE,       0
	gym_rematch_entry SKIER,        CLARISSA,           GYMRANK_PRYCE,    EVENT_BEAT_SKIER_CLARISSA,      0
	gym_rematch_entry BOARDER,      RONALD,             GYMRANK_PRYCE,    EVENT_BEAT_BOARDER_RONALD,      0
	gym_rematch_entry BOARDER,      BRAD,               GYMRANK_PRYCE,    EVENT_BEAT_BOARDER_BRAD,        0
	gym_rematch_entry BOARDER,      DOUGLAS,            GYMRANK_PRYCE,    EVENT_BEAT_BOARDER_DOUGLAS,     0
	gym_rematch_entry CLAIR,        CLAIR1,             GYMRANK_CLAIR,    EVENT_BEAT_CLAIR,               ClairRematchAnchors
	gym_rematch_entry COOLTRAINERM, PAUL,               GYMRANK_CLAIR,    EVENT_BEAT_COOLTRAINERM_PAUL,   0
	gym_rematch_entry COOLTRAINERM, MIKE,               GYMRANK_CLAIR,    EVENT_BEAT_COOLTRAINERM_MIKE,   0
	gym_rematch_entry COOLTRAINERF, LOLA,               GYMRANK_CLAIR,    EVENT_BEAT_COOLTRAINERF_LOLA,   0
	gym_rematch_entry COOLTRAINERM, CODY,               GYMRANK_CLAIR,    EVENT_BEAT_COOLTRAINERM_CODY,   0
	gym_rematch_entry COOLTRAINERF, FRAN,               GYMRANK_CLAIR,    EVENT_BEAT_COOLTRAINERF_FRAN,   0
	gym_rematch_entry BROCK,        BROCK1,             GYMRANK_BROCK,    EVENT_BEAT_BROCK,               BrockRematchAnchors
	gym_rematch_entry CAMPER,       JERRY,              GYMRANK_BROCK,    EVENT_BEAT_CAMPER_JERRY,        0
	gym_rematch_entry MISTY,        MISTY1,             GYMRANK_MISTY,    EVENT_BEAT_MISTY,               MistyRematchAnchors
	gym_rematch_entry SWIMMERF,     DIANA,              GYMRANK_MISTY,    EVENT_BEAT_SWIMMERF_DIANA,      0
	gym_rematch_entry SWIMMERF,     BRIANA,             GYMRANK_MISTY,    EVENT_BEAT_SWIMMERF_BRIANA,     0
	gym_rematch_entry SWIMMERM,     PARKER,             GYMRANK_MISTY,    EVENT_BEAT_SWIMMERM_PARKER,     0
	gym_rematch_entry LT_SURGE,     LT_SURGE1,          GYMRANK_LT_SURGE, EVENT_BEAT_LTSURGE,             LtSurgeRematchAnchors
	gym_rematch_entry GENTLEMAN,    GREGORY,            GYMRANK_LT_SURGE, EVENT_BEAT_GENTLEMAN_GREGORY,   0
	gym_rematch_entry GUITARIST,    VINCENT,            GYMRANK_LT_SURGE, EVENT_BEAT_GUITARIST_VINCENT,   0
	gym_rematch_entry JUGGLER,      HORTON,             GYMRANK_LT_SURGE, EVENT_BEAT_JUGGLER_HORTON,      0
	gym_rematch_entry ERIKA,        ERIKA1,             GYMRANK_ERIKA,    EVENT_BEAT_ERIKA,               ErikaRematchAnchors
	gym_rematch_entry LASS,         MICHELLE,           GYMRANK_ERIKA,    EVENT_BEAT_LASS_MICHELLE,       0
	gym_rematch_entry PICNICKER,    TANYA,              GYMRANK_ERIKA,    EVENT_BEAT_PICNICKER_TANYA,     0
	gym_rematch_entry BEAUTY,       JULIA,              GYMRANK_ERIKA,    EVENT_BEAT_BEAUTY_JULIA,        0
	gym_rematch_entry TWINS,        JOANDZOE1,          GYMRANK_ERIKA,    EVENT_BEAT_TWINS_JO_AND_ZOE,    0
	gym_rematch_entry TWINS,        JOANDZOE2,          GYMRANK_ERIKA,    EVENT_BEAT_TWINS_JO_AND_ZOE,    0
	gym_rematch_entry JANINE,       JANINE1,            GYMRANK_JANINE,   EVENT_BEAT_JANINE,              JanineRematchAnchors
	gym_rematch_entry LASS,         ALICE,              GYMRANK_JANINE,   EVENT_BEAT_LASS_ALICE,          0
	gym_rematch_entry LASS,         LINDA,              GYMRANK_JANINE,   EVENT_BEAT_LASS_LINDA,          0
	gym_rematch_entry PICNICKER,    CINDY,              GYMRANK_JANINE,   EVENT_BEAT_PICNICKER_CINDY,     0
	gym_rematch_entry CAMPER,       BARRY,              GYMRANK_JANINE,   EVENT_BEAT_CAMPER_BARRY,        0
	gym_rematch_entry SABRINA,      SABRINA1,           GYMRANK_SABRINA,  EVENT_BEAT_SABRINA,             SabrinaRematchAnchors
	gym_rematch_entry MEDIUM,       REBECCA,            GYMRANK_SABRINA,  EVENT_BEAT_MEDIUM_REBECCA,      0
	gym_rematch_entry PSYCHIC_T,    FRANKLIN,           GYMRANK_SABRINA,  EVENT_BEAT_PSYCHIC_FRANKLIN,    0
	gym_rematch_entry MEDIUM,       DORIS,              GYMRANK_SABRINA,  EVENT_BEAT_MEDIUM_DORIS,        0
	gym_rematch_entry PSYCHIC_T,    JARED,              GYMRANK_SABRINA,  EVENT_BEAT_PSYCHIC_JARED,       0
	gym_rematch_entry BLAINE,       BLAINE1,            GYMRANK_BLAINE,   EVENT_BEAT_BLAINE,              BlaineRematchAnchors
	gym_rematch_entry BLUE,         BLUE1,              GYMRANK_BLUE,     EVENT_BEAT_BLUE,                BlueRematchAnchors
	assert_table_length NUM_GYM_REMATCHES

GymRematchLevelCaps:
; the level a gym's strongest Pokémon is scaled to at each tier
	table_width 1
	db  9 ; 1 badge
	db 16 ; 2 badges
	db 20 ; 3 badges
	db 25 ; 4 badges
	db 30 ; 5 badges
	db 35 ; 6 badges
	db 38 ; 7 badges
	db 42 ; 8 badges
	db 46 ; 8 badges + ELITE FOUR
	db 48 ; 9 badges
	db 50 ; 10 badges
	db 52 ; 11 badges
	db 54 ; 12 badges
	db 56 ; 13 badges
	db 58 ; 14 badges
	db 61 ; 15 badges
	db 64 ; 16 badges
	assert_table_length MAX_GYM_REMATCH_TIER

GymBaseLevels:
; the level of each gym leader's strongest Pokémon in their first battle.
; a gym's whole roster is scaled by the difference between this and the tier's cap.
	table_width 1
	db  9 ; FALKNER
	db 16 ; BUGSY
	db 20 ; WHITNEY
	db 25 ; MORTY
	db 30 ; CHUCK
	db 35 ; JASMINE
	db 31 ; PRYCE
	db 40 ; CLAIR
	db 44 ; BROCK
	db 47 ; MISTY
	db 46 ; LT_SURGE
	db 46 ; ERIKA
	db 39 ; JANINE
	db 48 ; SABRINA
	db 50 ; BLAINE
	db 58 ; BLUE
	assert_table_length NUM_GYM_RANKS
