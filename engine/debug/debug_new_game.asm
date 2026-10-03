; Reusable postgame test save for `make crystal_debug`.
; Change the warp and tables below to land somewhere else or plant a
; different party / bag / story state.

Debug_SetUpTestSave::
	call Debug_InitPlayer
	call Debug_InitClock
	farcall SpawnPlayer
	farcall _InitializeStartDay
	call Debug_GiveParty
	call Debug_GiveItems
	call Debug_GiveProgress
	jp Debug_SetWarp

Debug_InitPlayer:
	ld hl, .Name
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	jp CopyBytes

.Name:
	dname "DEBUG", NAME_LENGTH

Debug_InitClock:
; Sunday 10:00, matching Oak's default hour.
	xor a
	ld [wStringBuffer2], a
	ld [wStringBuffer2 + 2], a
	ld [wStringBuffer2 + 3], a
	ld a, 10
	ld [wStringBuffer2 + 1], a
	jp InitTime

Debug_GiveParty:
	ld hl, .Party
.loop
	ld a, [hli]
	and a
	ret z
	ld [wCurPartySpecies], a
	ld a, [hli]
	ld [wCurPartyLevel], a
	ld a, [hli]
	push hl
	push af
	xor a
	ld [wMonType], a
	predef TryAddMonToParty
	pop af
	and a
	jr z, .next
	ld d, a
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, d
	ld [hl], a
	push hl
	ld bc, wPartyMon1PP - wPartyMon1Moves
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	predef FillPP
.next
	pop hl
	jr .loop

.Party:
; species, level, extra first move (NO_MOVE to keep level-up moves)
	db TYPHLOSION, 70, NO_MOVE
	db FERALIGATR, 70, NO_MOVE
	db MEGANIUM,   70, NO_MOVE
	db PIDGEOT,    70, FLY
	db LAPRAS,     70, SURF
	db SNORLAX,    70, NO_MOVE
	db 0

Debug_GiveItems:
	ld hl, .Items
.loop
	ld a, [hli]
	and a
	ret z
	ld [wCurItem], a
	ld a, [hli]
	ld [wItemQuantityChange], a
	push hl
	ld hl, wNumItems
	call ReceiveItem
	pop hl
	jr .loop

.Items:
	db FULL_RESTORE, 99
	db MAX_REVIVE,   99
	db MAX_ELIXER,   99
	db RARE_CANDY,   99
	db ESCAPE_ROPE,  99
	db MAX_REPEL,    99
	db MASTER_BALL,  99
	db BICYCLE,       1
	db HM_CUT,        1
	db HM_FLY,        1
	db HM_SURF,       1
	db HM_STRENGTH,   1
	db HM_FLASH,      1
	db HM_WHIRLPOOL,  1
	db HM_WATERFALL,  1
	db 0

Debug_GiveProgress:
; All badges, so every gym is rematchable at the top tier.
	ld a, (1 << NUM_JOHTO_BADGES) - 1
	ld [wJohtoBadges], a
	ld a, (1 << NUM_KANTO_BADGES) - 1
	ld [wKantoBadges], a

	ld a, HIGH(MAX_MONEY >> 8)
	ld [wMoney], a
	ld a, HIGH(MAX_MONEY)
	ld [wMoney + 1], a
	ld a, LOW(MAX_MONEY)
	ld [wMoney + 2], a

	ld a, 15
	ld [wGymRematchWins], a

	ld a, (1 << POKEGEAR_MAP_CARD_F) \
	    | (1 << POKEGEAR_RADIO_CARD_F) \
	    | (1 << POKEGEAR_PHONE_CARD_F) \
	    | (1 << POKEGEAR_EXPN_CARD_F) \
	    | (1 << POKEGEAR_OBTAINED_F)
	ld [wPokegearFlags], a

	ld a, (1 << STATUSFLAGS_POKEDEX_F) \
	    | (1 << STATUSFLAGS_NO_WILD_ENCOUNTERS_F) \
	    | (1 << STATUSFLAGS_HALL_OF_FAME_F)
	ld [wStatusFlags], a

	ld hl, wVisitedSpawns
	ld bc, (NUM_SPAWNS + 7) / 8
	ld a, $ff
	call ByteFill

	call Debug_SetGymRematchEvents
	ld hl, .Events
.event_loop
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	and e
	inc a
	ret z
	push hl
	ld b, SET_FLAG
	call EventFlagAction
	pop hl
	jr .event_loop

.Events:
; Add story flags here as we need other maps unlocked.
	dw EVENT_INITIALIZED_EVENTS
	dw EVENT_BEAT_ELITE_FOUR
	dw EVENT_JASMINE_RETURNED_TO_GYM
	dw EVENT_CLEARED_RADIO_TOWER
	dw EVENT_CLEARED_ROCKET_HIDEOUT
	dw EVENT_RESTORED_POWER_TO_KANTO
; Gym leaders hand out their TM the first time they are spoken to after a win.
	dw EVENT_GOT_TM31_MUD_SLAP
	dw EVENT_GOT_TM49_FURY_CUTTER
	dw EVENT_GOT_TM45_ATTRACT
	dw EVENT_GOT_TM30_SHADOW_BALL
	dw EVENT_GOT_TM01_DYNAMICPUNCH
	dw EVENT_GOT_TM23_IRON_TAIL
	dw EVENT_GOT_TM16_ICY_WIND
	dw EVENT_GOT_TM24_DRAGONBREATH
	dw EVENT_GOT_TM19_GIGA_DRAIN
	dw EVENT_GOT_TM06_TOXIC
	dw -1

Debug_SetGymRematchEvents:
; Mark every gym trainer as already beaten so talking offers a rematch.
	ld hl, GymRematchTrainers
	ld b, NUM_GYM_REMATCHES
.loop
	push bc
	push hl
	ld de, GYM_REMATCH_EVENT
	add hl, de
	ld a, BANK(GymRematchTrainers)
	call GetFarWord
	ld d, h
	ld e, l
	ld b, SET_FLAG
	call EventFlagAction
	pop hl
	ld de, GYM_REMATCH_SIZE
	add hl, de
	pop bc
	dec b
	jr nz, .loop
	ret

Debug_SetWarp:
; Violet City, one tile south of the gym door.
	ld a, GROUP_VIOLET_CITY
	ld [wMapGroup], a
	ld a, MAP_VIOLET_CITY
	ld [wMapNumber], a
	ld a, 18
	ld [wXCoord], a
	ld a, 18
	ld [wYCoord], a
	ld a, LANDMARK_VIOLET_CITY
	ld [wPrevLandmark], a
	ld a, SPAWN_N_A
	ld [wDefaultSpawnpoint], a
	ret
