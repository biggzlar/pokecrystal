; Gym leaders and their gym trainers can be battled again once per day, once
; the player has earned more badges than the gym is worth. The whole gym's
; levels follow the leader's win count. Crew Pokémon evolve and learn by
; level, and leaders swap in bigger parties at the tiers listed in
; data/gym_rematches/parties.asm.

CheckGymRematch::
; Takes a REMATCH_* constant in wScriptVar and returns TRUE if that trainer
; will battle the player again right now.
	ld a, [wScriptVar]
	ld [wCurGymRematch], a
	call .IsAvailable
	ld a, TRUE
	jr c, .done
	xor a
.done
	ld [wScriptVar], a
	ret

.IsAvailable:
	ld b, CHECK_FLAG
	call GymRematch_DailyFlagAction
	ld a, c
	and a
	jr nz, .no ; already battled today

	call GymRematch_GetEntry
	ld de, GYM_REMATCH_EVENT
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	jr z, .no ; never beaten in the first place

	call GymRematch_GetTier
	cp b
	jr z, .no
	jr c, .no
	scf
	ret

.no
	and a
	ret

SetUpGymRematch::
; Loads the trainer and the party scaling for the battle that follows.
	call GymRematch_GetTier
	ld c, b
	ld b, a
	push bc ; b = tier, c = gym rank

	ld c, b
	call GymRematch_GetAnchor
	jr c, .got_anchor

	; no anchor party: scale the trainer's usual party instead
	xor a
	ld [wGymRematchPartyAddr], a
	ld [wGymRematchPartyAddr + 1], a
	pop bc
	push bc
	ld a, c
	dec a
	ld e, a
	ld d, 0
	ld hl, GymBaseLevels
	add hl, de
	ld c, [hl]
	jr .got_base_level

.got_anchor
	; hl points at the anchor's level, then its party
	ld c, [hl]
	inc hl
	ld a, [hli]
	ld [wGymRematchPartyAddr], a
	ld a, [hl]
	ld [wGymRematchPartyAddr + 1], a
	ld a, BANK(GymRematchAnchorParties)
	ld [wGymRematchPartyBank], a

.got_base_level
	; the party is written for level c, so raise every level by cap[tier] - c
	pop de ; d = tier
	ld a, d
	dec a
	ld e, a
	ld d, 0
	ld hl, GymRematchLevelCaps
	add hl, de
	ld a, [hl]
	sub c
	jr nc, .got_delta
	xor a
.got_delta
	ld [wGymRematchLevelDelta], a

	call GymRematch_GetEntry
	ld a, [hli]
	ld [wOtherTrainerClass], a
	ld a, [hl]
	ld [wOtherTrainerID], a
	ld a, (1 << 7) | 1
	ld [wBattleScriptFlags], a
	ret

FinishGymRematch::
; Locks the trainer out until tomorrow and credits the win towards their next party.
	ld b, SET_FLAG
	call GymRematch_DailyFlagAction
	ld a, [wBattleResult]
	and ~BATTLERESULT_BITMASK
	cp WIN
	ret nz
	jp GymRematch_AddWin

GymRematch_GetTier:
; Returns the tier to battle wCurGymRematch at in a, and their gym's rank in b.
; The tier is the player's progress, but climbs one step per leader win.
	ld hl, wBadges
	ld b, 2
	call CountSetBits
	push af
	ld de, EVENT_BEAT_ELITE_FOUR
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	pop bc ; b = badges
	ld a, b
	jr z, .no_elite_four
	inc a
.no_elite_four
	cp MAX_GYM_REMATCH_TIER
	jr c, .got_progress
	ld a, MAX_GYM_REMATCH_TIER
.got_progress
	push af

	call GymRematch_GetEntry
	ld de, GYM_REMATCH_RANK
	add hl, de
	ld b, [hl]
	push bc
	call GymRematch_GetWins
	pop bc
	add b
	inc a
	pop de ; d = progress
	cp d
	ret c
	ld a, d
	ret

GymRematch_GetAnchor:
; Returns carry and hl pointing at the level of the highest anchor party that
; tier c has reached. Anchor data is in this bank.
	push bc
	call GymRematch_GetEntry
	ld de, GYM_REMATCH_ANCHORS
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc
	or h
	jr z, .none

	ld de, 0 ; best anchor so far
.loop
	ld a, [hl]
	cp -1
	jr z, .done
	cp c
	jr z, .reached
	jr nc, .next ; tier not high enough yet
.reached
	inc hl
	ld d, h
	ld e, l
	dec hl
.next
	ld a, REMATCH_ANCHOR_SIZE
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	jr .loop

.done
	ld a, d
	or e
	jr z, .none
	ld h, d
	ld l, e
	scf
	ret

.none
	and a
	ret

GymRematch_IsCrew::
; Returns carry if wCurGymRematch has no handwritten parties.
	call GymRematch_GetEntry
	ld de, GYM_REMATCH_ANCHORS
	add hl, de
	ld a, [hli]
	or [hl]
	jr nz, .leader
	scf
	ret

.leader
	and a
	ret

GymRematch_GetEntry:
; hl = wCurGymRematch's entry in GymRematchTrainers.
	ld a, [wCurGymRematch]
	ld hl, GymRematchTrainers
	ld bc, GYM_REMATCH_SIZE
	call AddNTimes
	ret

GymRematch_DailyFlagAction:
; Performs flag action b on wCurGymRematch's "battled today" flag.
	ld a, [wCurGymRematch]
	ld e, a
	ld d, 0
	ld hl, wGymRematchFlags
	jp FlagAction

GymRematch_GetWins:
; a = the win count that sets wCurGymRematch's tier.
; The other trainers in a gym use their leader's count.
	ld a, [wCurGymRematch]
.find_leader
	push af
	ld hl, GymRematchTrainers
	ld bc, GYM_REMATCH_SIZE
	call AddNTimes
	ld de, GYM_REMATCH_ANCHORS
	add hl, de
	ld a, [hli]
	or [hl]
	jr nz, .use_id
	pop af
	and a
	jr z, .read
	dec a
	jr .find_leader

.use_id
	pop af
.read
	ld e, a
	ld d, 0
	srl e
	ld hl, wGymRematchWins
	add hl, de
	and 1
	ld a, [hl]
	jr z, .low_nibble
	swap a
.low_nibble
	and $f
	ret

GymRematch_AddWin:
	call GymRematch_GetWinsPointer
	ld a, [hl]
	jr z, .low_nibble
	and $f0
	cp MAX_GYM_REMATCH_WINS << 4
	ret z
	add $10
	ld b, a
	ld a, [hl]
	and $f
	jr .store

.low_nibble
	and $f
	cp MAX_GYM_REMATCH_WINS
	ret z
	inc a
	ld b, a
	ld a, [hl]
	and $f0
.store
	or b
	ld [hl], a
	ret

GymRematch_GetWinsPointer:
; hl = wCurGymRematch's win counter byte, z if it is the low nibble.
	ld hl, wGymRematchWins
	ld a, [wCurGymRematch]
	ld e, a
	ld d, 0
	srl e
	add hl, de
	and 1
	ret

GymRematchScript::
; Takes a REMATCH_* constant in wScriptVar, then the map's offer, accept,
; decline, and beaten text pointers. Fighting or refusing ends the caller's
; script. Returning lets the first battle run, and plays the usual line once
; today's rematch is already done.
	callasm LoadGymRematchTexts
	special CheckGymRematch
	iffalse .nothing_to_do
	opentext
	callasm PrintGymRematchOfferText
	yesorno
	iffalse .declined
	callasm PrintGymRematchAcceptText
	waitbutton
	closetext
	special SetUpGymRematch
	callasm SetGymRematchWinText
	startbattle
	reloadmapafterbattle
	special FinishGymRematch
	endall

.declined
	callasm PrintGymRematchDeclineText
	waitbutton
	closetext
	endall

.nothing_to_do
	end

LoadGymRematchTexts::
; Copies the four text pointers that follow this script's farscall and skips
; them, so returning to the map does not execute them as commands.
	ld hl, wScriptStackSize
	ld a, [hl]
	dec a
	ld e, a
	ld d, 0
	ld hl, wScriptStack
	add hl, de
	add hl, de
	add hl, de
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	dec hl
	ld a, e
	add 8
	ld [hli], a
	ld a, d
	adc 0
	ld [hld], a
	dec hl
	ld a, [hl]
	and $7f
	ld c, a
	ld hl, wGymRematchOfferText
	ld b, 8
.copy
	push bc
	push hl
	ld h, d
	ld l, e
	ld a, c
	call GetFarByte
	pop hl
	ld [hli], a
	pop bc
	inc de
	dec b
	jr nz, .copy
	ret

PrintGymRematchOfferText::
	ld hl, wGymRematchOfferText
	jr PrintGymRematchText

PrintGymRematchAcceptText::
	ld hl, wGymRematchAcceptText
	jr PrintGymRematchText

PrintGymRematchDeclineText::
	ld hl, wGymRematchDeclineText

PrintGymRematchText:
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetMapScriptsBank
	ld b, a
	jp MapTextbox

SetGymRematchWinText::
	ld hl, wGymRematchBeatenText
	ld a, [hli]
	ld [wWinTextPointer], a
	ld a, [hl]
	ld [wWinTextPointer + 1], a
	xor a
	ld [wLossTextPointer], a
	ld [wLossTextPointer + 1], a
	call GetMapScriptsBank
	ld [wSeenTrainerBank], a
	ret

INCLUDE "data/gym_rematches/trainers.asm"
INCLUDE "data/gym_rematches/parties.asm"
