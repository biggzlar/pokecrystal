TomorrowEffect:
; Jump every clock that is already running.
; The calendar does not move. A clock on its last step is resolved
; here, so the end-of-turn tick cannot wrap it and skip the result.
	call TomorrowAdvanceTimeOfDay
	call TomorrowTickWeather
	call SetPlayerTurn
	call TomorrowTickSide
	call SetEnemyTurn
	jp TomorrowTickSide

TomorrowTickSide:
	call TomorrowTickScreens
	call TomorrowTickSafeguard
	call TomorrowTickPerish
	call TomorrowTickFutureSight
	call TomorrowMonIsAlive
	ret z
	call TomorrowTickSleep
	call TomorrowTickConfusion
	jp TomorrowTickToxic

; Morning, then day, then night, then morning again.
TomorrowAdvanceTimeOfDay:
	ld a, [wTimeOfDay]
	inc a
	cp DARKNESS_F
	jr c, .ok
	xor a
.ok
	ld [wTimeOfDay], a
	ld hl, .Messages
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp StdBattleTextbox

.Messages:
	dw BattleText_TomorrowMorning
	dw BattleText_TomorrowDay
	dw BattleText_TomorrowNight

TomorrowTickWeather:
	ld a, [wBattleWeather]
	and a
	ret z
	cp NUM_WEATHERS + 1
	ret nc
	ld c, a
	ld hl, wWeatherCount
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	xor a
	ld [wBattleWeather], a
	dec c
	ld b, 0
	ld hl, .EndedMessages
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp StdBattleTextbox

.EndedMessages:
	dw BattleText_TheRainStopped
	dw BattleText_TheSunlightFaded
	dw BattleText_TheSandstormSubsided

TomorrowTickScreens:
	ld de, .Your
	ld hl, wPlayerScreens
	ld bc, wPlayerLightScreenCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld de, .Enemy
	ld hl, wEnemyScreens
	ld bc, wEnemyLightScreenCount
.got
	push hl
	push bc
	ld hl, wStringBuffer1
	call CopyName2
	pop bc
	pop hl
	ld d, b
	ld e, c
	bit SCREENS_LIGHT_SCREEN, [hl]
	call nz, .Light
	bit SCREENS_REFLECT, [hl]
	call nz, .Reflect
	ret

.Light:
	ld a, [de]
	and a
	jr z, .LightOff
	dec a
	ld [de], a
	ret nz
.LightOff:
	res SCREENS_LIGHT_SCREEN, [hl]
	push hl
	push de
	ld hl, BattleText_MonsLightScreenFell
	call StdBattleTextbox
	pop de
	pop hl
	ret

.Reflect:
	inc de
	ld a, [de]
	and a
	jr z, .ReflectOff
	dec a
	ld [de], a
	ret nz
.ReflectOff:
	res SCREENS_REFLECT, [hl]
	ld hl, BattleText_MonsReflectFaded
	jp StdBattleTextbox

.Your:
	db "Your@"
.Enemy:
	db "Enemy@"

TomorrowTickSafeguard:
	ld hl, wPlayerScreens
	ld de, wPlayerSafeguardCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld hl, wEnemyScreens
	ld de, wEnemySafeguardCount
.got
	bit SCREENS_SAFEGUARD, [hl]
	ret z
	ld a, [de]
	and a
	jr z, .off
	dec a
	ld [de], a
	ret nz
.off
	res SCREENS_SAFEGUARD, [hl]
	ld hl, BattleText_SafeguardFaded
	jp StdBattleTextbox

TomorrowTickPerish:
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVar
	bit SUBSTATUS_PERISH, a
	ret z
	ld hl, wPlayerPerishCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld hl, wEnemyPerishCount
.got
	ld a, [hl]
	and a
	jr z, .expire
	dec a
	ld [hl], a
	ld [wTextDecimalByte], a
	push af
	ld hl, PerishCountText
	call StdBattleTextbox
	pop af
	ret nz

.expire
; Residual would decrement 0 and never faint. Faint now.
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	res SUBSTATUS_PERISH, [hl]
	jp TomorrowFaintCurrentMon

; Future Sight lands when a decrement leaves the count at 1.
; 4 or 3 can be decremented: the residual tick still lands one
; turn sooner. 2 is already landing at the end of this turn, and
; decrementing it would make that residual skip the hit.
TomorrowTickFutureSight:
	ld hl, wPlayerFutureSightCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld hl, wEnemyFutureSightCount
.got
	ld a, [hl]
	cp 3
	ret c
	dec [hl]
	ret

TomorrowTickSleep:
	ld hl, wBattleMonStatus
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld hl, wEnemyMonStatus
.got
	ld a, [hl]
	and SLP_MASK
	ret z
	dec a
	ld c, a
	ld a, [hl]
	and %11111000
	or c
	ld [hl], a
	ret nz
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	res SUBSTATUS_NIGHTMARE, [hl]
	ld hl, WokeUpText
	call StdBattleTextbox
	call UpdateUserInParty
	ld hl, UpdatePlayerHUD
	ldh a, [hBattleTurn]
	and a
	jr z, .hud
	ld hl, UpdateEnemyHUD
.hud
	ld a, BANK("Battle Core")
	rst FarCall
	ld a, $1
	ldh [hBGMapMode], a
	ret

TomorrowTickConfusion:
	ld hl, wPlayerSubStatus3
	ld de, wPlayerConfuseCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld hl, wEnemySubStatus3
	ld de, wEnemyConfuseCount
.got
	bit SUBSTATUS_CONFUSED, [hl]
	ret z
	ld a, [de]
	and a
	jr z, .snap
	dec a
	ld [de], a
	ret nz
.snap
	res SUBSTATUS_CONFUSED, [hl]
	ld hl, ConfusedNoMoreText
	jp StdBattleTextbox

TomorrowTickToxic:
	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVar
	bit SUBSTATUS_TOXIC, a
	ret z
	ld hl, wPlayerToxicCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld hl, wEnemyToxicCount
.got
	inc [hl]
	ret

TomorrowMonIsAlive:
	ld hl, wBattleMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld hl, wEnemyMonHP
.got
	ld a, [hli]
	or [hl]
	ret

TomorrowFaintCurrentMon:
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	ld hl, wBattleMonHP
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, wPartyMon1HP
	ld a, [wCurBattleMon]
	call GetPartyLocation
	xor a
	ld [hli], a
	ld [hl], a
	jp RefreshBattleHuds

.enemy
	ld hl, wEnemyMonHP
	xor a
	ld [hli], a
	ld [hl], a
	ld a, [wBattleMode]
	dec a
	jr z, .hud
	ld hl, wOTPartyMon1HP
	ld a, [wCurOTMon]
	call GetPartyLocation
	xor a
	ld [hli], a
	ld [hl], a
.hud
	jp RefreshBattleHuds
