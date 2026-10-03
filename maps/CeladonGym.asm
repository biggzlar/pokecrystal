	object_const_def
	const CELADONGYM_ERIKA
	const CELADONGYM_LASS1
	const CELADONGYM_LASS2
	const CELADONGYM_BEAUTY
	const CELADONGYM_TWIN1
	const CELADONGYM_TWIN2

CeladonGym_MapScripts:
	def_scene_scripts

	def_callbacks

CeladonGymErikaScript:
	faceplayer
	gym_rematch REMATCH_ERIKA, ErikaRematchOfferText, ErikaRematchAcceptText, ErikaRematchDeclineText, ErikaRematchBeatenText
	opentext
	checkflag ENGINE_RAINBOWBADGE
	iftrue .FightDone
	writetext ErikaBeforeBattleText
	waitbutton
	closetext
	winlosstext ErikaBeatenText, 0
	loadtrainer ERIKA, ERIKA1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_ERIKA
	setevent EVENT_BEAT_LASS_MICHELLE
	setevent EVENT_BEAT_PICNICKER_TANYA
	setevent EVENT_BEAT_BEAUTY_JULIA
	setevent EVENT_BEAT_TWINS_JO_AND_ZOE
	opentext
	writetext PlayerReceivedRainbowBadgeText
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_RAINBOWBADGE
.FightDone:
	checkevent EVENT_GOT_TM19_GIGA_DRAIN
	iftrue .GotGigaDrain
	writetext ErikaExplainTMText
	promptbutton
	verbosegiveitem TM_GIGA_DRAIN
	iffalse .GotGigaDrain
	setevent EVENT_GOT_TM19_GIGA_DRAIN
.GotGigaDrain:
	writetext ErikaAfterBattleText
	waitbutton
	closetext
	end

TrainerLassMichelle:
	trainer LASS, MICHELLE, EVENT_BEAT_LASS_MICHELLE, LassMichelleSeenText, LassMichelleBeatenText, 0, .Script

.Script:
	endifjustbattled
	gym_rematch REMATCH_MICHELLE, MichelleRematchOfferText, MichelleRematchAcceptText, MichelleRematchDeclineText, MichelleRematchBeatenText
	opentext
	writetext LassMichelleAfterBattleText
	waitbutton
	closetext
	end

TrainerPicnickerTanya:
	trainer PICNICKER, TANYA, EVENT_BEAT_PICNICKER_TANYA, PicnickerTanyaSeenText, PicnickerTanyaBeatenText, 0, .Script

.Script:
	endifjustbattled
	gym_rematch REMATCH_TANYA, TanyaRematchOfferText, TanyaRematchAcceptText, TanyaRematchDeclineText, TanyaRematchBeatenText
	opentext
	writetext PicnickerTanyaAfterBattleText
	waitbutton
	closetext
	end

TrainerBeautyJulia:
	trainer BEAUTY, JULIA, EVENT_BEAT_BEAUTY_JULIA, BeautyJuliaSeenText, BeautyJuliaBeatenText, 0, .Script

.Script:
	endifjustbattled
	gym_rematch REMATCH_JULIA, JuliaRematchOfferText, JuliaRematchAcceptText, JuliaRematchDeclineText, JuliaRematchBeatenText
	opentext
	writetext BeautyJuliaAfterBattleText
	waitbutton
	closetext
	end

TrainerTwinsJoAndZoe1:
	trainer TWINS, JOANDZOE1, EVENT_BEAT_TWINS_JO_AND_ZOE, TwinsJoAndZoe1SeenText, TwinsJoAndZoe1BeatenText, 0, .Script

.Script:
	endifjustbattled
	gym_rematch REMATCH_JOANDZOE1, JoAndZoe1RematchOfferText, JoAndZoe1RematchAcceptText, JoAndZoe1RematchDeclineText, JoAndZoe1RematchBeatenText
	opentext
	writetext TwinsJoAndZoe1AfterBattleText
	waitbutton
	closetext
	end

TrainerTwinsJoAndZoe2:
	trainer TWINS, JOANDZOE2, EVENT_BEAT_TWINS_JO_AND_ZOE, TwinsJoAndZoe2SeenText, TwinsJoAndZoe2BeatenText, 0, .Script

.Script:
	endifjustbattled
	gym_rematch REMATCH_JOANDZOE2, JoAndZoe2RematchOfferText, JoAndZoe2RematchAcceptText, JoAndZoe2RematchDeclineText, JoAndZoe2RematchBeatenText
	opentext
	writetext TwinsJoAndZoe2AfterBattleText
	waitbutton
	closetext
	end

CeladonGymStatue:
	checkflag ENGINE_RAINBOWBADGE
	iftrue .Beaten
	jumpstd GymStatue1Script
.Beaten:
	gettrainername STRING_BUFFER_4, ERIKA, ERIKA1
	jumpstd GymStatue2Script

ErikaBeforeBattleText:
	text "ERIKA: Hello…"
	line "Lovely weather,"

	para "isn't it?"
	line "It's so pleasant…"

	para "…I'm afraid I may"
	line "doze off…"

	para "My name is ERIKA."
	line "I am the LEADER of"
	cont "CELADON GYM."

	para "…Oh? All the way"
	line "from JOHTO, you"
	cont "say? How nice…"

	para "Oh. I'm sorry, I"
	line "didn't realize"

	para "that you wished to"
	line "challenge me."

	para "Very well, but I"
	line "shall not lose."
	done

ErikaBeatenText:
	text "ERIKA: Oh!"
	line "I concede defeat…"

	para "You are remarkably"
	line "strong…"

	para "I shall give you"
	line "RAINBOWBADGE…"
	done

PlayerReceivedRainbowBadgeText:
	text "<PLAYER> received"
	line "RAINBOWBADGE."
	done

ErikaExplainTMText:
	text "ERIKA: That was a"
	line "delightful match."

	para "I felt inspired."
	line "Please, I wish you"
	cont "to have this TM."

	para "It is GIGA DRAIN."

	para "It is a wonderful"
	line "move that drains"

	para "half the damage it"
	line "inflicts to heal"
	cont "your #MON."

	para "Please use it if"
	line "it pleases you…"
	done

ErikaAfterBattleText:
	text "ERIKA: Losing"
	line "leaves a bitter"
	cont "aftertaste…"

	para "But knowing that"
	line "there are strong"

	para "trainers spurs me"
	line "to do better…"
	done

LassMichelleSeenText:
	text "Do you think a"
	line "girls-only GYM"
	cont "is rare?"
	done

LassMichelleBeatenText:
	text "Oh, bleah!"
	done

LassMichelleAfterBattleText:
	text "I just got care-"
	line "less, that's all!"
	done

PicnickerTanyaSeenText:
	text "Oh, a battle?"
	line "That's kind of"
	cont "scary, but OK!"
	done

PicnickerTanyaBeatenText:
	text "Oh, that's it?"
	done

PicnickerTanyaAfterBattleText:
	text "Oh, look at all"
	line "your BADGES. No"

	para "wonder I couldn't"
	line "win!"
	done

BeautyJuliaSeenText:
	text "Were you looking"
	line "at these flowers"
	cont "or at me?"
	done

BeautyJuliaBeatenText:
	text "How annoying!"
	done

BeautyJuliaAfterBattleText:
	text "How do I go about"
	line "becoming ladylike"
	cont "like ERIKA?"
	done

TwinsJoAndZoe1SeenText:
	text "We'll show you"
	line "#MON moves that"
	cont "ERIKA taught us!"
	done

TwinsJoAndZoe1BeatenText:
	text "Oh… We lost…"
	done

TwinsJoAndZoe1AfterBattleText:
	text "ERIKA will get you"
	line "back for us!"
	done

TwinsJoAndZoe2SeenText:
	text "We're going to"
	line "protect ERIKA!"
	done

TwinsJoAndZoe2BeatenText:
	text "We couldn't win…"
	done

TwinsJoAndZoe2AfterBattleText:
	text "ERIKA is much,"
	line "much stronger!"
	done


; Rematch dialogue. Passed to GymRematchScript.

ErikaRematchOfferText:
	text "The flowers bloom"
	line "on their own"
	line "time."

	para "Mine have opened"
	line "a little more."
	cont "Will you stay?"
	done

ErikaRematchAcceptText:
	text "Then breathe"
	line "in…"
	done

ErikaRematchDeclineText:
	text "The scent will"
	line "linger."
	done

ErikaRematchBeatenText:
	text "Even a full"
	line "bloom can wilt…"
	done

MichelleRematchOfferText:
	text "I talk to the"
	line "plants every"
	line "morning."

	para "They've perked"
	line "up. See?"
	done

MichelleRematchAcceptText:
	text "Grow for me!"
	done

MichelleRematchDeclineText:
	text "We'll sunbathe"
	line "over here."
	done

MichelleRematchBeatenText:
	text "They drooped"
	line "again…"
	done

TanyaRematchOfferText:
	text "Picnics are"
	line "better after"
	line "a win."

	para "I still owe"
	line "you one."
	cont "Battle?"
	done

TanyaRematchAcceptText:
	text "Sandwiches later!"
	done

TanyaRematchDeclineText:
	text "I'll save you"
	line "a bite."
	done

TanyaRematchBeatenText:
	text "There go the"
	line "sandwiches…"
	done

JuliaRematchOfferText:
	text "Petals and poise."
	line "I've practiced"
	line "both."

	para "A rematch, if"
	line "you please."
	done

JuliaRematchAcceptText:
	text "Softly, now."
	done

JuliaRematchDeclineText:
	text "I can wait"
	line "among the pots."
	done

JuliaRematchBeatenText:
	text "The arrangement"
	line "fell apart…"
	done

JoAndZoe1RematchOfferText:
	text "JO: ZOE and I"
	line "switched our"
	line "lead."

	para "It might fool"
	line "you. Try us?"
	done

JoAndZoe1RematchAcceptText:
	text "JO: Our turn!"
	done

JoAndZoe1RematchDeclineText:
	text "JO: We'll swap"
	line "again later."
	done

JoAndZoe1RematchBeatenText:
	text "JO: The switch"
	line "didn't help…"
	done

JoAndZoe2RematchOfferText:
	text "ZOE: JO talks"
	line "big."

	para "I'm the one who"
	line "trained. Ready?"
	done

JoAndZoe2RematchAcceptText:
	text "ZOE: Follow me!"
	done

JoAndZoe2RematchDeclineText:
	text "ZOE: Typical."
	done

JoAndZoe2RematchBeatenText:
	text "ZOE: Next time"
	line "I pick the lead…"
	done

CeladonGym_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 17, CELADON_CITY, 8
	warp_event  5, 17, CELADON_CITY, 8

	def_coord_events

	def_bg_events
	bg_event  3, 15, BGEVENT_READ, CeladonGymStatue
	bg_event  6, 15, BGEVENT_READ, CeladonGymStatue

	def_object_events
	object_event  5,  3, SPRITE_ERIKA, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonGymErikaScript, -1
	object_event  7,  8, SPRITE_LASS, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerLassMichelle, -1
	object_event  2,  8, SPRITE_LASS, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 2, TrainerPicnickerTanya, -1
	object_event  3,  5, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerBeautyJulia, -1
	object_event  4, 10, SPRITE_TWIN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 1, TrainerTwinsJoAndZoe1, -1
	object_event  5, 10, SPRITE_TWIN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 1, TrainerTwinsJoAndZoe2, -1
