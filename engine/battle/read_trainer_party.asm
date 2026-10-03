ReadTrainerParty:
	ld a, [wInBattleTowerBattle]
	bit IN_BATTLE_TOWER_BATTLE_F, a
	ret nz

	ld a, [wLinkMode]
	and a
	ret nz

	ld hl, wOTPartyCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a

	ld hl, wOTPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH * PARTY_LENGTH
	xor a
	call ByteFill

	ld a, [wOtherTrainerClass]
	cp CAL
	jr nz, .not_cal2
	ld a, [wOtherTrainerID]
	cp CAL2
	jr z, .cal2
	ld a, [wOtherTrainerClass]
.not_cal2

	call GetGymRematchParty
	jr c, .got_party_type

	dec a
	ld c, a
	ld b, 0
	ld hl, TrainerGroups
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [wOtherTrainerID]
	ld b, a
.skip_trainer
	dec b
	jr z, .got_trainer
.loop
	ld a, [hli]
	cp -1
	jr nz, .loop
	jr .skip_trainer
.got_trainer

.skip_name
	ld a, [hli]
	cp '@'
	jr nz, .skip_name

.got_party_type
	ld a, [hli]
	ld c, a
	ld b, 0
	ld d, h
	ld e, l
	ld hl, TrainerTypes
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, .done
	push bc
	jp hl

.done
	xor a
	ld [wGymRematchLevelDelta], a
	jp ComputeTrainerReward

.cal2
	ld a, BANK(sMysteryGiftTrainer)
	call OpenSRAM
	ld de, sMysteryGiftTrainer
	call TrainerType2
	call CloseSRAM
	jr .done

GetGymRematchParty:
; Copies the party prepared by SetUpGymRematch into wGymRematchParty and returns
; carry with hl pointing at its type byte. The setup is consumed either way, so
; an ordinary battle can never inherit it.
	push af
	ld a, [wGymRematchPartyAddr]
	ld l, a
	ld a, [wGymRematchPartyAddr + 1]
	ld h, a
	or l
	jr z, .no_party

	xor a
	ld [wGymRematchPartyAddr], a
	ld [wGymRematchPartyAddr + 1], a

	ld de, wGymRematchParty
	ld c, GYM_REMATCH_PARTY_LENGTH
.loop
	ld a, [wGymRematchPartyBank]
	call GetFarByte
	ld [de], a
	inc de
	inc hl
	cp -1
	jr z, .copied
	dec c
	jr nz, .loop
.copied
	pop af
	ld hl, wGymRematchParty
	scf
	ret

.no_party
	pop af
	and a
	ret

GymCrewRematch:
; Returns carry if the party being read is a scaled gym-crew rematch.
	ld a, [wGymRematchLevelDelta]
	and a
	ret z
	push hl
	farcall GymRematch_IsCrew
	pop hl
	ret

EvolveGymCrewSpecies:
; If this is a scaled gym-crew rematch, replace wCurPartySpecies with the
; form it reaches by level. Stone, trade, and happiness evolutions stop there.
	call GymCrewRematch
	ret nc
	ld c, 3
.next_form
	push bc
	push hl
	ld a, [wCurPartySpecies]
	dec a
	ld c, a
	ld b, 0
	ld hl, EvosAttacksPointers
	add hl, bc
	add hl, bc
	ld a, BANK(EvosAttacksPointers)
	call GetFarWord
.method
	ld a, BANK("Evolutions and Attacks")
	call GetFarByte
	and a
	jr z, .stop
	inc hl
	cp EVOLVE_LEVEL
	jr nz, .skip
	ld a, BANK("Evolutions and Attacks")
	call GetFarByte
	ld b, a
	inc hl
	ld a, [wCurPartyLevel]
	cp b
	jr c, .not_yet
	ld a, BANK("Evolutions and Attacks")
	call GetFarByte
	ld [wCurPartySpecies], a
	pop hl
	pop bc
	dec c
	jr nz, .next_form
	ret

.not_yet
	inc hl
	jr .method

.skip
	inc hl
	inc hl
	jr .method

.stop
	pop hl
	pop bc
	ret

ScaleGymRematchLevel:
; Raises the level in a to the tier the current rematch is being fought at.
	ld b, a
	ld a, [wGymRematchLevelDelta]
	add b
	jr c, .too_high
	cp MAX_LEVEL + 1
	ret c
.too_high
	ld a, MAX_LEVEL
	ret

TrainerTypes:
; entries correspond to TRAINERTYPE_* constants
	table_width 2
	dw TrainerType1 ; level, species
	dw TrainerType2 ; level, species, moves
	dw TrainerType3 ; level, species, item
	dw TrainerType4 ; level, species, item, moves
	assert_table_length NUM_TRAINERTYPES

TrainerType1:
; normal (level, species)
	ld h, d
	ld l, e
.loop
	ld a, [hli]
	cp $ff
	ret z

	call ScaleGymRematchLevel
	ld [wCurPartyLevel], a
	ld a, [hli]
	ld [wCurPartySpecies], a
	call EvolveGymCrewSpecies
	ld a, OTPARTYMON
	ld [wMonType], a
	push hl
	predef TryAddMonToParty
	pop hl
	jr .loop

TrainerType2:
; moves
	ld h, d
	ld l, e
.loop
	ld a, [hli]
	cp $ff
	ret z

	call ScaleGymRematchLevel
	ld [wCurPartyLevel], a
	ld a, [hli]
	ld [wCurPartySpecies], a
	call EvolveGymCrewSpecies
	ld a, OTPARTYMON
	ld [wMonType], a

	push hl
	predef TryAddMonToParty
	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	pop hl

	; crew rematches learn by level, including after they evolve
	call GymCrewRematch
	jr c, .keep_level_moves
	ld a, [hl]
	and a
	jr nz, .got_moves

	; no moves listed: keep the moveset the mon learnt by level
.keep_level_moves
	ld bc, NUM_MOVES
	add hl, bc
	jr .loop

.got_moves
	ld b, NUM_MOVES
.copy_moves
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copy_moves

	push hl

	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1Species
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, MON_PP
	add hl, de
	push hl
	ld hl, MON_MOVES
	add hl, de
	pop de

	ld b, NUM_MOVES
.copy_pp
	ld a, [hli]
	and a
	jr z, .copied_pp

	push hl
	push bc
	dec a
	ld hl, Moves + MOVE_PP
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	pop bc
	pop hl

	ld [de], a
	inc de
	dec b
	jr nz, .copy_pp
.copied_pp

	pop hl
	jr .loop

TrainerType3:
; item
	ld h, d
	ld l, e
.loop
	ld a, [hli]
	cp $ff
	ret z

	call ScaleGymRematchLevel
	ld [wCurPartyLevel], a
	ld a, [hli]
	ld [wCurPartySpecies], a
	call EvolveGymCrewSpecies
	ld a, OTPARTYMON
	ld [wMonType], a
	push hl
	predef TryAddMonToParty
	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1Item
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	pop hl
	ld a, [hli]
	ld [de], a
	jr .loop

TrainerType4:
; item + moves
	ld h, d
	ld l, e
.loop
	ld a, [hli]
	cp $ff
	ret z

	call ScaleGymRematchLevel
	ld [wCurPartyLevel], a
	ld a, [hli]
	ld [wCurPartySpecies], a
	call EvolveGymCrewSpecies

	ld a, OTPARTYMON
	ld [wMonType], a

	push hl
	predef TryAddMonToParty
	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1Item
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	pop hl

	ld a, [hli]
	ld [de], a

	push hl
	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	pop hl

	; crew rematches learn by level, including after they evolve
	call GymCrewRematch
	jr c, .keep_level_moves
	ld a, [hl]
	and a
	jr nz, .got_moves

	; no moves listed: keep the moveset the mon learnt by level
.keep_level_moves
	ld bc, NUM_MOVES
	add hl, bc
	jr .loop

.got_moves
	ld b, NUM_MOVES
.copy_moves
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copy_moves

	push hl

	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, MON_PP
	add hl, de

	push hl
	ld hl, MON_MOVES
	add hl, de
	pop de

	ld b, NUM_MOVES
.copy_pp
	ld a, [hli]
	and a
	jr z, .copied_pp

	push hl
	push bc
	dec a
	ld hl, Moves + MOVE_PP
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	pop bc
	pop hl

	ld [de], a
	inc de
	dec b
	jr nz, .copy_pp
.copied_pp

	pop hl
	jp .loop

ComputeTrainerReward:
	ld hl, hProduct
	xor a
	ld [hli], a
	ld [hli], a ; hMultiplicand + 0
	ld [hli], a ; hMultiplicand + 1
	ld a, [wEnemyTrainerBaseReward]
	ld [hli], a ; hMultiplicand + 2
	ld a, [wCurPartyLevel]
	ld [hl], a ; hMultiplier
	call Multiply
	ld hl, wBattleReward
	xor a
	ld [hli], a
	ldh a, [hProduct + 2]
	ld [hli], a
	ldh a, [hProduct + 3]
	ld [hl], a
	ret

Battle_GetTrainerName::
	ld a, [wInBattleTowerBattle]
	bit IN_BATTLE_TOWER_BATTLE_F, a
	ld hl, wOTPlayerName
	jp nz, CopyTrainerName

	ld a, [wOtherTrainerID]
	ld b, a
	ld a, [wOtherTrainerClass]
	ld c, a

GetTrainerName::
	ld a, c
	cp CAL
	jr nz, .not_cal2

	ld a, BANK(sMysteryGiftTrainerHouseFlag)
	call OpenSRAM
	ld a, [sMysteryGiftTrainerHouseFlag]
	and a
	call CloseSRAM
	jr z, .not_cal2

	ld a, BANK(sMysteryGiftPartnerName)
	call OpenSRAM
	ld hl, sMysteryGiftPartnerName
	call CopyTrainerName
	jp CloseSRAM

.not_cal2
	dec c
	push bc
	ld b, 0
	ld hl, TrainerGroups
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc

.loop
	dec b
	jr z, CopyTrainerName

.skip
	ld a, [hli]
	cp $ff
	jr nz, .skip
	jr .loop

CopyTrainerName:
	ld de, wStringBuffer1
	push de
	ld bc, NAME_LENGTH
	call CopyBytes
	pop de
	ret

IncompleteCopyNameFunction: ; unreferenced
; Copy of CopyTrainerName but without "call CopyBytes"
	ld de, wStringBuffer1
	push de
	ld bc, NAME_LENGTH
	pop de
	ret

INCLUDE "data/trainers/parties.asm"
