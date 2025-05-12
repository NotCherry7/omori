extends Node

var nathan_current_message: int = 0
var hearts_current_message: int = 0





var battle = {
	"begin": "What will LUKE and BRENNA do?",
	"begin_luke": "What will LUKE do?",
	"run": "The party tried to escape... but failed.",
	"selected": "What will /p do?",
	"useOn": "Use on whom?",
	"useOnBoth": "Use on whom?
		Press SHIFT to switch sides.",
	"crit": "IT HIT RIGHT IN THE HEART!",
	"applyEmotion": "/t feels /e.",
	"maxEmotion": "/t cannot get any /e!",
	"loseDamage": "/t takes /a damage!",
	"loseJuice": "/t lost /a JUICE...",
	"gainHealth": "/t healed /a HEART!",
	"gainJuice": "/t gained /a JUICE!",
	"attack": "/a attacks /t!",
	"miss": "/a's attack whiffed.",
	"toast": "/t became TOAST!",
	"buff": "/t's /b rose!",
	"debuff": "/t's /b fell!",
	"win": "LUKE and BRENNA were victorious!",
	"win_luke": "LUKE was victorious!",
	"gainXP": "You gained /a EXP!",
	"gainChips": "You got /a CHIPS!",
	"levelUp": "/p grew to LEVEL /l!",
	"learnSkill": "...and learned /s!",
	"attemptSkill": "/a tried to use /s!",
	"lowJuice": "...but did not have enough JUICE.",
	"recoverHealth": "/t recovered /a HEART!",
	"recoverJuice": "/t recovered /a JUICE!",
	"riseAgain": "/t rose again!",
	"useSnack": "/a uses /s!",
	"failedSnack": "/a ran out of /s.",
	"emotion_advantage": "It was a moving attack!",
	"emotion_disadvantage": "It was a dull attack..."
}

var common_messages = {
	"findItem": {
		"speaker": null,
		"face": null,
		"text": "You found [color=lime_green]/item[/color]!"
	},
	"findCharm": {
		"speaker": null,
		"face": null,
		"text": "You found [color=purple]/item[/color]!"
	},
	"nathanSnack": {
		"speaker": null,
		"face": null,
		"choices": ["yes", "no"],
		"text": "Ah yes, some delicious /i! \nWould you like to eat some?"
	},
	"save": {
		"speaker": null,
		"face": null,
		"choices": ["yes", "no"],
		"text": "NATHAN's picnic basket. Would you like to save?"
	},
	"fa_save": {
		"speaker": null,
		"face": null,
		"choices": ["yes", "no"],
		"text": "An empty picnic basket. Would you like to save?"
	},
	"renewed": {
		"speaker": null,
		"face": null,
		"text": "You and your friends feel like new!"
	},
	"lockedDoor": {
		"speaker": null,
		"face": null,
		"text": "This door is locked!"
	},
}

var template_message = {
	"message_0": {
		"speaker": "speaker_name", # name of who is talking
		"face": Resources.NATHAN_FACE, # what face
		"text": "Line 1!<n>Line 2, this requires the player to tap again!<n>Line 3! italics are [i]distressed[/i] text..." # <n> = new line, <p> = new page (must message name in same dictionary root)
	}
}

var nathan_messages = {
	"message_0": {
		"speaker": "nathan",
		"face": Resources.NATHAN_FACE, # happy
		"text": "Helloooo!<n>You should go to see HEARTS!<n>I'm sure he'll love to see atleast BRENNA.<p>message_0_1"
	},
	"message_0_1": {
		"speaker": "nathan",
		"face": Resources.NATHAN_FACE, # happy
		"text": "Here LUKE, take this [color=lime_green]MEDICINE[/color] for your allergies.<p>message_0_2",
		"item": func(player): return player.find("Snack", "Medicine"),
		"sfx": Resources.SFX_NEW_SKILL
	},
	"message_0_2": {
		"speaker": "nathan",
		"face": Resources.NATHAN_FACE, # happy
		"text": "Goodbye bubs."
	},
	"message_1": {
		"speaker": "nathan",
		"face": Resources.NATHAN_FACE, # happy
		"text": "Hi!<n>You should go to see HEARTS!"
	},
	"message_2": {
		"speaker": "nathan",
		"face": Resources.NATHAN_FACE, # sad
		"text": "Hey LUKE.<n>Where is BRENNA?<p>message_2_1"
	},
	"message_2_1": {
		"speaker": "nathan",
		"face": Resources.NATHAN_FACE, # sad
		"text": "Oh no. That's not good...<n>BRENNA will be fine and I know you'll get her out."
	},
	"message_3": {
		"speaker": "nathan",
		"face": Resources.NATHAN_FACE, # sad
		"text": "I think the only way to save BRENNA is to FIGHT HEARTS."
	}
}

var pet_hearts = {
	"message_0": {
		"speaker": "luke",
		"face": Resources.LUKE_DEPRESSED,
		"text": "%s2%BRENNA?<n>%s3%HEARTS SPIT BRENNA OUT NOW!<n>%s5%HEARTS!"
	},
	"message_1": {
		"speaker": "luke",
		"face": Resources.LUKE_ENRAGED,
		"text": "%s2%HEARTS.<n>Spit BRENNA out now."
	},
	"message_2": {
		"speaker": "luke",
		"face": Resources.LUKE_FURIOUS,
		"text": "[i]Brenna[/i]"
	}
}
var realworld = {
	"bed_fail": {
		"speaker": null,
		"face": null,
		"text": "You do not feel tired right now."
	},
	"bed": {
		"speaker": null,
		"face": null,
		"text": "A cozy bed. Would you like to go to sleep?",
		"choices": ["yes", "no"]
	},
	"love_letter": {
		"speaker": null,
		"face": null,
		"text": "A letter from BRENNA. Would you like to read it?",
		"choices": ["yes", "no"]
	},
	"love_letter_text": {
		"speaker": null,
		"face": null,
		"text": "Hey LUKE! I think you are a great person.<n>I really loved hanging out with you.<n>I hope you have a great summer, BRENNA."
	},
	"couch": {
		"speaker": null,
		"face": null,
		"text": "A cozy looking couch."
	},
	"boxes": {
		"speaker": null,
		"face": null,
		"text": "Some boxes left over from moving.<n>They need to be moved."
	},
	"mirror": {
		"speaker": null,
		"face": null,
		"text": "You see yourself in the reflection."
	},
	"toilet": {
		"speaker": null,
		"face": null,
		"text": "A toilet. You stare into the water."
	},
	"piano": {
		"speaker": null,
		"face": null,
		"text": "A nice piano. You would play it but you forgot the songs you knew."
	},
}

var visit_brenna = {
	"message_0": {
		"speaker": "brenna",
		"face": Resources.BRENNA_ECSTATIC,
		"text": "Hi LUKE!<n>It's been a little bit.<n>But you're back!<p>message_0_1"
	},
	"message_0_1": {
		"speaker": "brenna",
		"face": null,
		"text": "Do you want to go pick flowers with me?",
		"choices": ["yes", "no"]
	},
	"message_1": {
		"speaker": "luke",
		"face": Resources.FA_LUKE_SAD,
		"text": "No. Thanks, but I have to go.<p>message_1_1"
	},
	"message_1_1": {
		"speaker": "brenna",
		"face": Resources.BRENNA_DEPRESSED,
		"text": "Oh.<n>Well. Bye."
	},
	"message_2": {
		"speaker": "luke",
		"face": Resources.FA_LUKE_HAPPY,
		"text": "Yes! I'd love to!<p>message_2_1"
	},
	"message_2_1": {
		"speaker": "brenna",
		"face": Resources.BRENNA_HAPPY,
		"text": "Great! Let's go!"
	}
}


var find_flower = {
	"message_0": {
		"speaker": "brenna",
		"face": Resources.BRENNA_NEUTRAL,
		"text": "That's one flower down, four to go!"
	},
	"message_1": {
		"speaker": "brenna",
		"face": Resources.BRENNA_NEUTRAL,
		"text": "We need three more flowers."
	},
	"message_2": {
		"speaker": "brenna",
		"face": Resources.BRENNA_NEUTRAL,
		"text": "Just two more!"
	},
	"message_3": {
		"speaker": "brenna",
		"face": Resources.BRENNA_NEUTRAL,
		"text": "Almost there! One to go."
	},
	"message_4": {
		"speaker": "brenna",
		"face": Resources.BRENNA_NEUTRAL,
		"text": "We did it, that's all the flowers! Thank you LUKE."
	}
}

var hearts_messages = {
	"message_0": {
		"speaker": "hearts",
		"face": null,
		"text": "Meow... (Pet HEARTS?)",
		"choices": ["yes", "no"]
	},
	"message_1": {
		"speaker": "hearts",
		"face": null,
		"text": "Meow... (Maybe you should pet HEARTS?)",
		"choices": ["yes", "no"]
	},
	"message_2": {
		"speaker": "hearts",
		"face": null,
		"text": "Meow... (You will pet HEARTS.)",
		"choices": ["yes"]
	},
	"message_3": {
		"speaker": "hearts",
		"face": null,
		"text": "Meow... (Fight HEARTS?)",
		"choices": ["yes", "no"]
	}
}
