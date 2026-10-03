#!/usr/bin/env python3
"""Exercises the gym rematch routines directly in an emulator.

Boots the ROM, plants WRAM state by hand, then calls CheckGymRematch,
SetUpGymRematch and ReadTrainerParty and checks what they produce.

Usage: python3 tools/test_gym_rematch.py   (requires pyboy)
"""

import re
import sys

from pyboy import PyBoy

ROM = "pokecrystal.gbc"

syms = {}
for line in open("pokecrystal.sym"):
    line = line.strip()
    if not line or line.startswith(";") or " " not in line:
        continue
    addr, name = line.split(" ", 1)
    if ":" not in addr:
        continue
    bank, off = addr.split(":")
    syms[name.strip()] = (int(bank, 16), int(off, 16))

W = {k: v[1] for k, v in syms.items()}


def parse_consts(path):
    """Reads a const_def list into {name: value}."""
    values, value = {}, 0
    for line in open(path):
        line = line.split(";")[0].strip()
        m = re.match(r"const_def(?:\s+(-?\d+))?$", line)
        if m:
            value = int(m.group(1) or 0)
        elif re.match(r"const_skip$", line):
            value += 1
        elif re.match(r"const_next\s+(\d+)$", line):
            value = int(re.match(r"const_next\s+(\d+)$", line).group(1))
        elif re.match(r"const\s+\w+$", line):
            values[line.split()[1]] = value
            value += 1
    return values


EVENTS = parse_consts("constants/event_flags.asm")
REMATCH = parse_consts("constants/gym_rematch_constants.asm")
MOVES = parse_consts("constants/move_constants.asm")

pyboy = PyBoy(ROM, window="null", log_level="ERROR")
for _ in range(400):
    pyboy.tick(1, False)

mem = pyboy.memory
regs = pyboy.register_file

SPIN = 0xFF80  # a `jr -2` planted in HRAM, so a routine's RET parks the CPU


def set_bank(bank):
    mem[0x2000] = bank
    mem[0xFF9D] = bank  # hROMBank, so the game's own bankswitches stay in sync


def call(name):
    bank, addr = syms[name]
    mem[0xFFFF] = 0  # no interrupts, so only the routine under test runs
    mem[0xFF0F] = 0
    mem[0xFF70] = 1  # WRAM bank 1
    mem[SPIN] = 0x18
    mem[SPIN + 1] = 0xFE
    set_bank(bank)
    mem[0xCFFE] = SPIN & 0xFF
    mem[0xCFFF] = SPIN >> 8
    regs.SP = 0xCFFE
    regs.PC = addr
    for _ in range(60):
        pyboy.tick(1, False)
        if regs.PC == SPIN:
            break
    else:
        raise RuntimeError("%s did not return (pc=%04x)" % (name, regs.PC))
    return dict(a=regs.A, b=regs.B, c=regs.C, hl=regs.HL)


def read_rom(bank, addr, length):
    set_bank(bank)
    return bytes(mem[addr + i] for i in range(length))


GYM_REMATCH_SIZE = 7
PARTYMON_STRUCT_LENGTH = 0x30


def entry(name):
    bank, addr = syms["GymRematchTrainers"]
    d = read_rom(bank, addr + REMATCH[name] * GYM_REMATCH_SIZE, GYM_REMATCH_SIZE)
    return dict(cls=d[0], id=d[1], rank=d[2], event=d[3] | (d[4] << 8),
                anchors=d[5] | (d[6] << 8))


def leader_index(index):
    """Crew entries sit after their leader and have no anchor parties."""
    bank, addr = syms["GymRematchTrainers"]
    while index > 0:
        d = read_rom(bank, addr + index * GYM_REMATCH_SIZE, GYM_REMATCH_SIZE)
        if d[5] or d[6]:
            return index
        index -= 1
    return 0


def set_event(index, on=True):
    byte = W["wEventFlags"] + index // 8
    bit = 1 << (index % 8)
    mem[byte] = (mem[byte] | bit) if on else (mem[byte] & ~bit)


def set_badges(n):
    bits = (1 << n) - 1
    mem[W["wBadges"]] = bits & 0xFF
    mem[W["wBadges"] + 1] = (bits >> 8) & 0xFF


def begin(name, badges, wins=0, elite_four=False):
    """Clears the rematch state and sets up a player partway through the game."""
    for i in range(9):
        mem[W["wGymRematchFlags"] + i] = 0
    for i in range(33):
        mem[W["wGymRematchWins"] + i] = 0
    for i in range(0x100):
        mem[W["wEventFlags"] + i] = 0
    mem[W["wGymRematchLevelDelta"]] = 0
    mem[W["wGymRematchPartyAddr"]] = 0
    mem[W["wGymRematchPartyAddr"] + 1] = 0
    set_badges(badges)
    if elite_four:
        set_event(EVENTS["EVENT_BEAT_ELITE_FOUR"])
    e = entry(name)
    set_event(e["event"])
    index = REMATCH[name]
    mem[W["wCurGymRematch"]] = index
    mem[W["wScriptVar"]] = index
    leader = leader_index(index)
    byte = W["wGymRematchWins"] + leader // 2
    if leader % 2:
        mem[byte] = (mem[byte] & 0x0F) | (wins << 4)
    else:
        mem[byte] = (mem[byte] & 0xF0) | (wins & 0x0F)
    return e


failures = []


def check(label, got, want):
    ok = got == want
    print("%-56s %s got=%s want=%s" % (label, "ok  " if ok else "FAIL", got, want))
    if not ok:
        failures.append(label)


def party():
    count = mem[W["wOTPartyCount"]]
    levels = [mem[W["wOTPartyMon1Level"] + i * PARTYMON_STRUCT_LENGTH] for i in range(count)]
    species = [mem[W["wOTPartyMon1Species"] + i * PARTYMON_STRUCT_LENGTH] for i in range(count)]
    return species, levels


def moves(slot):
    base = W["wOTPartyMon1Moves"] + slot * PARTYMON_STRUCT_LENGTH
    return [mem[base + i] for i in range(4)]


def pp(slot):
    base = W["wOTPartyMon1PP"] + slot * PARTYMON_STRUCT_LENGTH
    return [mem[base + i] for i in range(4)]


def build_party():
    mem[W["wLinkMode"]] = 0
    mem[W["wInBattleTowerBattle"]] = 0
    mem[W["wEnemyTrainerBaseReward"]] = 10
    call("ReadTrainerParty")
    return party()


caps_bank, caps = syms["GymRematchLevelCaps"]
CAPS = list(read_rom(caps_bank, caps, 17))
base_bank, base = syms["GymBaseLevels"]
BASES = list(read_rom(base_bank, base, 16))

# --- data tables ------------------------------------------------------------
check("table: Falkner is rank 1 and has anchor parties",
      (entry("REMATCH_FALKNER")["rank"], entry("REMATCH_FALKNER")["anchors"] != 0), (1, True))
check("table: a gym trainer has no anchor parties", entry("REMATCH_ROD")["anchors"], 0)
check("table: Blue is rank 16", entry("REMATCH_BLUE")["rank"], 16)
check("table: level caps rise to 64", (CAPS[0], CAPS[-1], CAPS == sorted(CAPS)), (9, 64, True))
check("table: Falkner's base level", BASES[0], 9)

# --- when a rematch is offered ----------------------------------------------
begin("REMATCH_FALKNER", badges=1)
for i in range(0x100):
    mem[W["wEventFlags"] + i] = 0
call("CheckGymRematch")
check("1 badge, Falkner never beaten -> no rematch", mem[W["wScriptVar"]], 0)

begin("REMATCH_FALKNER", badges=1)
call("CheckGymRematch")
check("1 badge, Falkner beaten -> no rematch yet", mem[W["wScriptVar"]], 0)

begin("REMATCH_FALKNER", badges=2)
call("CheckGymRematch")
check("2 badges -> Falkner wants a rematch", mem[W["wScriptVar"]], 1)
check("2 badges -> tier 2 for a rank 1 gym", call("GymRematch_GetTier")["a"], 2)

mem[W["wBattleResult"]] = 0  # WIN
call("FinishGymRematch")
mem[W["wScriptVar"]] = REMATCH["REMATCH_FALKNER"]
call("CheckGymRematch")
check("already battled today -> no second rematch", mem[W["wScriptVar"]], 0)
check("the win was credited", mem[W["wGymRematchWins"]] & 0xF, 1)

begin("REMATCH_BLUE", badges=16)
call("CheckGymRematch")
check("16 badges, no Elite Four -> Blue has nothing to prove", mem[W["wScriptVar"]], 0)

begin("REMATCH_BLUE", badges=16, elite_four=True)
call("CheckGymRematch")
check("16 badges + Elite Four -> Blue wants a rematch", mem[W["wScriptVar"]], 1)

# --- climbing the tiers -----------------------------------------------------
begin("REMATCH_FALKNER", badges=8)
check("8 badges but no rematch wins -> tier 2", call("GymRematch_GetTier")["a"], 2)
begin("REMATCH_FALKNER", badges=8, wins=1)
check("8 badges, 1 rematch win -> tier 3", call("GymRematch_GetTier")["a"], 3)
begin("REMATCH_FALKNER", badges=8, wins=15)
check("8 badges, many wins -> tier stops at the badge count",
      call("GymRematch_GetTier")["a"], 8)

# --- scaling and anchor parties ---------------------------------------------
e = begin("REMATCH_FALKNER", badges=2)
call("SetUpGymRematch")
check("tier 2 Falkner: keeps his usual party",
      mem[W["wGymRematchPartyAddr"]] | (mem[W["wGymRematchPartyAddr"] + 1] << 8), 0)
check("tier 2 Falkner: levels raised to the tier's cap",
      mem[W["wGymRematchLevelDelta"]], CAPS[1] - BASES[0])
check("tier 2 Falkner: the right trainer is loaded",
      (mem[W["wOtherTrainerClass"]], mem[W["wOtherTrainerID"]]), (e["cls"], e["id"]))
check("tier 2 Falkner party", build_party(), ([16, 17], [14, 16]))

begin("REMATCH_FALKNER", badges=5, wins=15)
call("SetUpGymRematch")
check("tier 5 Falkner: swaps to his first anchor party",
      mem[W["wGymRematchPartyAddr"]] | (mem[W["wGymRematchPartyAddr"] + 1] << 8),
      syms["FalknerRematchParty1"][1])
check("tier 5 Falkner: anchor needs no scaling", mem[W["wGymRematchLevelDelta"]], 0)
check("tier 5 Falkner party", build_party(), ([17, 84, 164], [28, 28, 30]))

begin("REMATCH_FALKNER", badges=8, wins=15)
call("SetUpGymRematch")
check("tier 8 Falkner party is the same anchor, scaled up",
      build_party(), ([17, 84, 164], [40, 40, 42]))

begin("REMATCH_FALKNER", badges=8, wins=15, elite_four=True)
call("SetUpGymRematch")
check("Elite Four beaten: Falkner moves to his second anchor",
      mem[W["wGymRematchPartyAddr"]] | (mem[W["wGymRematchPartyAddr"] + 1] << 8),
      syms["FalknerRematchParty2"][1])
check("tier 9 Falkner party", build_party(), ([18, 85, 164, 227], [44, 44, 45, 46]))

begin("REMATCH_FALKNER", badges=16, wins=15, elite_four=True)
call("SetUpGymRematch")
check("16 badges: Falkner's final party",
      build_party(), ([18, 85, 164, 178, 169, 227], [62, 62, 62, 63, 63, 64]))

# a gym trainer has no anchors, so only the levels move, using the leader's wins
begin("REMATCH_ROD", badges=8, wins=0)
mem[W["wGymRematchWins"]] = 0xF0  # Rod's own half is 15, Falkner's is 0
check("a gym trainer ignores his own wins", call("GymRematch_GetTier")["a"], 2)
e = begin("REMATCH_ROD", badges=8, wins=15)
call("SetUpGymRematch")
check("gym trainer scales off his leader's base level",
      mem[W["wGymRematchLevelDelta"]], CAPS[7] - BASES[0])
check("Bird Keeper Rod's party scales with the gym",
      build_party(), ([18, 18], [40, 40]))
check("Rod's Pidgey evolve and use Pidgeot's level-up moves", moves(0),
      [MOVES[m] for m in ("GUST", "QUICK_ATTACK", "WHIRLWIND", "WING_ATTACK")])
begin("REMATCH_CARRIE", badges=8, wins=15)
call("SetUpGymRematch")
check("Lass Carrie's Snubbull evolves", build_party(), ([210], [40]))
check("the evolved mon uses its level-up moves", moves(0),
      [MOVES[m] for m in ("BITE", "LICK", "ROAR", "RAGE")])

# a Kanto leader
begin("REMATCH_SABRINA", badges=16, wins=15, elite_four=True)
call("SetUpGymRematch")
check("Sabrina's final party",
      build_party(), ([122, 97, 80, 103, 196, 65], [62, 62, 62, 63, 63, 64]))

# --- signature movesets vs. level-up movesets -------------------------------
begin("REMATCH_WHITNEY", badges=5, wins=15)
call("SetUpGymRematch")
species, levels = build_party()
check("tier 5 Whitney party", (species, levels), ([35, 162, 241], [28, 28, 30]))
check("Miltank keeps her signature moveset", moves(2),
      [MOVES[m] for m in ("ROLLOUT", "ATTRACT", "STOMP", "MILK_DRINK")])
check("Miltank's signature moves have PP", all(p > 0 for p in pp(2)), True)
clefairy = moves(0)
check("Clefairy falls back to her level-up moveset",
      (clefairy[0] != 0, clefairy != [MOVES[m] for m in ("ROLLOUT", "ATTRACT", "STOMP", "MILK_DRINK")]),
      (True, True))
check("Clefairy's level-up moves have PP", pp(0)[0] > 0, True)

begin("REMATCH_WHITNEY", badges=16, wins=15, elite_four=True)
call("SetUpGymRematch")
species, levels = build_party()
check("16 badge Miltank still has her signature moveset", moves(5),
      [MOVES[m] for m in ("ROLLOUT", "ATTRACT", "EARTHQUAKE", "MILK_DRINK")])
begin("REMATCH_ROD", badges=2, wins=15)
call("SetUpGymRematch")
build_party()
low = moves(0)
begin("REMATCH_ROD", badges=8, wins=15)
call("SetUpGymRematch")
build_party()
check("a scaled mon's level-up moveset grows with its level", moves(0) != low, True)

# --- nothing leaks into ordinary battles ------------------------------------
mem[W["wOtherTrainerClass"]] = entry("REMATCH_FALKNER")["cls"]
mem[W["wOtherTrainerID"]] = entry("REMATCH_FALKNER")["id"]
check("a plain Falkner battle is untouched", build_party(), ([16, 17], [7, 9]))
check("the scaling was consumed", mem[W["wGymRematchLevelDelta"]], 0)
check("a vanilla party's listed moves still load", moves(0),
      [MOVES["TACKLE"], MOVES["MUD_SLAP"], 0, 0])

pyboy.stop(save=False)
print()
if failures:
    print("%d FAILED: %s" % (len(failures), ", ".join(failures)))
    sys.exit(1)
print("all checks passed")
