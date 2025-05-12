extends Node

var skills = {
	"Guard": {
		"name": "Guard",
		"dialog": func(attackerName, targetName): return str(attackerName).to_upper() + " guards!",
		"description": "Acts first, reducing damage taken for 1 turn.", 
		"cost": 0,
		"useableOn": "self",
		"reduceDamage": 1, # percentage value of how much damage is reduced
		"actFirst": true
	},
	"Shove": {
		"name": "Shove",
		"dialog": func(attackerName, targetName): return str(attackerName).to_upper() + " shoves " +  str(targetName).to_upper() + "!",
		"description": "Inflicts SAD on a foe.", 
		"cost": 5,
		"useableOn": "foe",
		"emotion": "sad",
		"damage": func(attacker): 
			return attacker.attack * 2,
	},
	"Pester": {
		"name": "Pester",
		"dialog": func(attackerName, targetName): return str(attackerName).to_upper() + " pesters " + str(targetName).to_upper() + "!",
		"description": "Inflicts ANGRY on a friend or foe.", 
		"cost": 5,
		"useableOn": "both",
		"emotion": "angry"
	},
	"Slice": {
		"name": "Slice",
		"dialog": func(attackerName, targetName): return str(attackerName).to_upper() + " slices " + str(targetName).to_upper() + "!",
		"description": "Always deals a critical hit. Ignores DEFENSE when BRENNA is SAD.", 
		"cost": 12,
		"useableOn": "foe",
		"noDefenseEmotion": "sad",
		"damage": func(attacker): 
			return attacker.attack * 3,
	},
	"Rapid Slash": {
		"name": "Rapid Slash",
		"dialog": func(attackerName, targetName): return str(attackerName).to_upper() + " goes crazy!",
		"description": "Attacks three times, and each hit will land on a random foe.", 
		"cost": 25,
		"useableOn": "none",
		"randomFoes": 3,
		"randomFoeDamage": func(attacker): 
			return attacker.attack * 2,
	},
	"Spray Away": {
		"name": "Spray Away",
		"dialog": func(attackerName, targetName): return str(attackerName).to_upper() + " unleashes his spray can!",
		"description": "Deals damage to all foes.", 
		"cost": 20,
		"useableOn": "none",
		"damageAllFoes": func(attacker): 
			return (attacker.attack + attacker.speed) * 3,
	},
	"Hug": {
		"name": "Hug",
		"dialog": func(attackerName, targetName): return str(attackerName).to_upper() + " hugs " + str(targetName).to_upper() + "!",
		"description": "Inflicts HAPPY on a friend or foe.", 
		"cost": 7,
		"useableOn": "both",
		"emotion": "happy",
	},
	"Bake": {
		"name": "Bake",
		"dialog": func(attackerName, targetName): return str(attackerName).to_upper() + " makes a cookie just for " + str(targetName).to_upper() + "!",
		"description": "Heals a friend for 75% of their HEART.", 
		"cost": 10,
		"useableOn": "friend",
		"heal": func(attacker): 
			return round(attacker.maxHealth * 0.75),
	},
	"-------------": {
		"name": "-------------",
		"dialog": "",
		"description": "", 
		"cost": 0,
	}
}

var enemySkills = {
	"Attack": {
		"name": "Attack",
		"damage": func(attacker): 
			return attacker.attack * 2,
		"dialog": func(attackerName, targetName): return str(attackerName).to_upper() + " headbutts " + str(targetName).to_upper() + "!"
	},
	"Do Nothing": {
		"name": "Do Nothing",
		"dialog": func(attackerName, targetName): return str(attackerName).to_upper() + " stares at nothing."
	},
	"Be Cute": {
		"name": "Be Cute",
		"dialog": func(attackerName, targetName): return str(attackerName).to_upper() + " looks cutely at " + str(targetName).to_upper() + "!",
		"debuff": "attack",
	},
	"Sad Eyes": {
		"name": "Sad Eyes",
		"dialog": func(attackerName, targetName): return str(attackerName).to_upper() + " looks sadly at " + str(targetName).to_upper() + "!",
		"emotion": "sad",
	},
}

var weapons = {
	"Katana": {
		"name": "Katana",
		"description": "A shiny new katana. You can see your reflection in the blade.",
		"health": 0,
		"juice": 0,
		"attack": 5,
		"defense": 0,
		"speed": 0,
		"hitRate": 100,
		"luck": 0,
		"user": "Brenna",
		"image": Resources.WEAPON_KATANA
	},
	"Spray Can": {
		"name": "Spray Can",
		"description": "A colorful mess. Throwable and good for spraying on walls... or foes.",
		"health": 0,
		"juice": 0,
		"attack": 6,
		"defense": 0,
		"speed": 0,
		"hitRate": 100,
		"luck": 0,
		"user": "Luke",
		"image": Resources.WEAPON_SPRAY_CAN
	},
	"-------------": {
		"name": "-------------",
		"description": "",
		"health": 0,
		"juice": 0,
		"attack": 0,
		"defense": 0,
		"speed": 0,
		"hitRate": 0,
		"luck": 0,
		"user": "both",
		"image": null
	},
}

var charms = {
	"Bow": {
		"name": "Bow",
		"description": "A simple and elegant bow. DEF +4",
		"health": 0,
		"juice": 0,
		"attack": 0,
		"defense": 4,
		"speed": 0,
		"hitRate": 0,
		"luck": 0,
		"image": Resources.CHARM_BOW
	},
	"Sunglasses": {
		"name": "Sunglasses",
		"description": "Automatically makes you look cooler. DEF +5. Increases HIT RATE.",
		"health": 0,
		"juice": 0,
		"attack": 0,
		"defense": 5,
		"speed": 0,
		"hitRate": 200,
		"luck": 0,
		"image": Resources.CHARM_SUNGLASSES
	},
	"Necklace": {
		"name": "Necklace",
		"description": "Automatically makes you look cooler. DEF +5. Increases HIT RATE.",
		"health": 0,
		"juice": 0,
		"attack": 0,
		"defense": 5,
		"speed": 0,
		"hitRate": 200,
		"luck": 0,
		"image": null
	},
	"Ring": {
		"name": "Ring",
		"description": "It is not real silver. DEF +3. ATTACK +5",
		"health": 0,
		"juice": 0,
		"attack": 5,
		"defense": 3,
		"speed": 0,
		"hitRate": 0,
		"luck": 0,
		"image": null
	},
	"-------------": {
		"name": "-------------",
		"description": "",
		"health": 0,
		"juice": 0,
		"attack": 0,
		"defense": 0,
		"speed": 0,
		"hitRate": 0,
		"luck": 0,
		"image": null
	},
}

var items = {
	"hello": {
		"name": "hello",
		"description": "Sup, this is a friendly hello",
		"price": 5,
		"image": null
	},
	"Can": {
		"name": "Can",
		"description": "Useless piece of trash... Like you!",
		"price": 5,
		"image": null
	},
	"Man": {
		"name": "Man",
		"description": "Useless piece of... hey this isn't a can!",
		"price": 5,
		"image": null
	},
}

var snacks = {
	"Granola": {
		"name": "Granola",
		"useableOn": "friend",
		"description": "Crunchy. Heals 5 HEART.",
		"price": 5,
		"health": func(player): 
			return 5,
		"image": null
	},
	"Medicine": {
		"name": "Medicine",
		"useableOn": "friend",
		"description": "Clears allergies and may have side effects. Recovers all HEART.",
		"price": 5000,
		"health": func(player): 
			return player.maxHealth - player.health,
		"image": null
	},
	"Peanut Butter": {
		"name": "Peanut Butter",
		"useableOn": "friend",
		"description": "Tad bit sticky. Heals 5 HEART and 25% of max JUICE.",
		"price": 10,
		"health": func(player): 
			return 5,
		"juice": func(player): 
			return player.maxJuice * 0.25,
		"image": null
	},
	"Acai Bowl": {
		"name": "Acai Bowl",
		"useableOn": "friend",
		"description": "Delicious in the mornings. Heals 50% max HEART and 75% max JUICE.",
		"price": 50,
		"health": func(player): 
			return player.maxHealth * 0.5,
		"juice": func(player): 
			return player.maxJuice * 0.75,
		"image": null
	},
	"Chocolate Milk": {
		"name": "Chocolate Milk",
		"useableOn": "friend",
		"description": "Does it come from brown cows? Heals 50% of max JUICE.",
		"price": 20,
		"juice": func(player): 
			return player.maxJuice * 0.5,
		"image": null
	},
	"Butter Chicken": {
		"name": "Butter Chicken",
		"useableOn": "friend",
		"description": "Likely the best meal! Fully recovers all HEART and JUICE.",
		"price": 50,
		"health": func(player): 
			return player.maxHealth - player.health,
		"juice": func(player): 
			return player.maxJuice - player.juice,
		"image": null
	},
	"Popcorn": {
		"name": "Popcorn",
		"useableOn": "none",
		"description": "Make sure to share! Heals 15 HEART to all friends.",
		"price": 10,
		"all": true,
		"health": func(player): 
			return 15,
		"image": Resources.SNACK_POPCORN
	},
	"Life Jam": {
		"name": "Life Jam",
		"useableOn": "friend",
		"description": "Infused with the spirit of life. Revives a friend that is TOAST.",
		"price": 300,
		"image": Resources.SNACK_LIFE_JAM
	},
}

var toys = {
	"Jacks": {
		"name": "Jacks",
		"useableOn": "none",
		"description": "Deals small damage to all foes and reduces their SPEED.",
		"price": 25,
		"allFoes": true,
		"damage": func(player): 
			return 25,
		"debuff": "speed",
		"image": Resources.TOY_JACKS
	},
	"Rubber Band": {
		"name": "Rubber Band",
		"useableOn": "foe",
		"description": "Deals damage to a foe and reduces their DEFENSE.",
		"price": 75,
		"damage": func(player): 
			return 50,
		"debuff": "defense",
		"image": Resources.TOY_RUBBER_BAND
	},
	"Dynamite": {
		"name": "Dynamite",
		"useableOn": "none",
		"description": "Deals heavy damage to all foes.",
		"price": 1000,
		"allFoes": true,
		"damage": func(player): 
			return 150,
		"image": Resources.TOY_DYNAMITE
	},
	"Sparkler": {
		"name": "Sparkler",
		"useableOn": "both",
		"description": "Little fires. Inflicts HAPPY on a friend or foe.",
		"price": 100,
		"emotion": "happy",
		"image": Resources.TOY_SPARKLER
	},
	"Confetti": {
		"name": "Confetti",
		"useableOn": "none",
		"description": "Small squares of colorful paper. Inflicts HAPPY on all friends.",
		"price": 250,
		"allFriends": true,
		"emotion": "happy",
		"image": Resources.TOY_CONFETTI
	},
	"Dandelion": {
		"name": "Dandelion",
		"useableOn": "both",
		"description": "Has a claming effect. Removes EMOTION from a friend or foe.",
		"price": 250,
		"emotion": "neutral",
		"image": Resources.TOY_DANDELION
	},
	"Poetry Book": {
		"name": "Poetry Book",
		"useableOn": "both",
		"description": "Sad words strung together. Inflicts SAD on a friend or foe.",
		"price": 100,
		"emotion": "sad",
		"image": Resources.TOY_POETRY_BOOK
	},
	"Present": {
		"name": "Present",
		"useableOn": "both",
		"description": "It's not what you wanted... Inflicts ANGER on a friend or foe.",
		"price": 100,
		"emotion": "angry",
		"image": Resources.TOY_PRESENT
	},
	"Air Horn": {
		"name": "Air Horn",
		"useableOn": "none",
		"description": "Who would invent this!? Inflicts ANGER on all friends.",
		"price": 250,
		"allFriends": true,
		"emotion": "anger",
		"image": Resources.TOY_AIR_HORN
	},
}
