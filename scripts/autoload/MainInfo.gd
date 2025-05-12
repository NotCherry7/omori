extends Node

#var begin_world = "res://worlds/forest/start_forest.tscn"
var begin_world = "res://cutscenes/to_dream.tscn"

var previous_scene: int = -1
var canSave: bool = true
var newGame: bool = false

var cut_scene_active: bool = false

var pos_before_battle
var scene_before_battle

# above is stuff that is temp and does not need to be saved

var current_ending: String = "Good"
var flowersFound: Array = []
var visited_brenna: bool = false
var last_player_location: Vector2
var last_player_direction: String
var pos_history = []
var dir_history = []

var current_world: String = "Dreamworld"

var enemyEncountered
var defeatedBosses = []

var last_scene_path: String = ""
var playtime_seconds: float = 0.0
var leader: String = "Luke"
var followers: Array[String] = ["Brenna"]
var chips: int = 0
var location = "none"

var defaultLukeStats = {
	"name": "Lukathy",
	"level": 1,
	"xp": 0,
	"maxHeart": 30,
	"currentHeart": 30,
	"maxJuice": 25,
	"currentJuice": 25,
	"attack": 3, # 3
	"defense": 2,
	"speed": 2,
	"luck": 3,
	"hitRate": 0,
	"weapon": "Spray Can",
	"charm": "-------------"
}

var defaultFALukeStats = {
	"name": "Luke",
	"level": 1,
	"xp": 0,
	"maxHeart": 10,
	"currentHeart": 10,
	"maxJuice": 15,
	"currentJuice": 15,
	"attack": 3,
	"defense": 2,
	"speed": 2,
	"luck": 3,
	"hitRate": 0,
	"weapon": "-------------",
	"charm": "-------------"
}

var LukeStats = {
	"name": "Luke",
	"level": 1,
	"xp": 0,
	"maxHeart": 33,
	"currentHeart": 3,
	"maxJuice": 30,
	"currentJuice": 3,
	"attack": 6, # 6
	"defense": 4,
	"speed": 4,
	"luck": 5,
	"hitRate": 0,
	"weapon": "Spray Can",
	"charm": "Sunglasses"
}

var FALukeStats = {
	"name": "Luke",
	"level": 1,
	"xp": 0,
	"maxHeart": 30,
	"currentHeart": 30,
	"maxJuice": 30,
	"currentJuice": 30,
	"attack": 6, # 6
	"defense": 4,
	"speed": 4,
	"luck": 5,
	"hitRate": 0,
	"weapon": "Spray Can",
	"charm": "-------------"
}

var defaultBrennaStats = {
	"name": "Brenna",
	"level": 1,
	"xp": 0,
	"maxHeart": 30,
	"currentHeart": 30,
	"maxJuice": 20,
	"currentJuice": 20,
	"attack": 5,
	"defense": 1,
	"speed": 1,
	"luck": 3,
	"hitRate": 0,
	"weapon": "Katana",
	"charm": "-------------"
}

var defaultFABrennaStats = {
	"name": "Brenna",
	"level": 1,
	"xp": 0,
	"maxHeart": 15,
	"currentHeart": 15,
	"maxJuice": 10,
	"currentJuice": 10,
	"attack": 4,
	"defense": 1,
	"speed": 1,
	"luck": 2,
	"hitRate": 0,
	"weapon": "-------------",
	"charm": "-------------"
}

var BrennaStats = {
	"name": "Brenna",
	"level": 1,
	"xp": 0,
	"maxHeart": 35,
	"currentHeart": 5,
	"maxJuice": 30,
	"currentJuice": 3,
	"attack": 7,
	"defense": 2,
	"speed": 1,
	"luck": 3,
	"hitRate": 0,
	"weapon": "Katana",
	"charm": "Bow"
}

var FABrennaStats = {}

var heldWeapons: Array = [
	"-------------"
]

var heldCharms: Array = [
	"-------------"
]

var LukeMainSkills: Array = [
	"Guard",
	"Shove",
	"Pester",
	"Spray Away"
]

var lastBattle = {
	"enemies": [],
	"bg": null,
	"music": null
}

var BrennaMainSkills: Array = [
	"Bake",
	"Hug",
	"Slice",
	"Rapid Slash"
]

var heldSnacks: Dictionary = {
	"Granola": {
		"hold": 3
	},
	"Butter Chicken": {
		"hold": 1
	},
	"Popcorn": {
		"hold": 1
	},
	"Life Jam": {
		"hold": 2
	},
	"Chocolate Milk": {
		"hold": 2
	},
	"Acai Bowl": {
		"hold": 2
	},
	"Peanut Butter": {
		"hold": 1
	},
}
var heldToys: Dictionary = {
	"Jacks": {
		"hold": 1
	},
	"Rubber Band": {
		"hold": 2
	},
	"Sparkler": {
		"hold": 2
	},
	"Confetti": {
		"hold": 1
	},
	"Dandelion": {
		"hold": 2
	},
	"Poetry Book": {
		"hold": 2
	},
	"Present": {
		"hold": 2
	},
	"Air Horn": {
		"hold": 1
	},
}

var heldItems: Dictionary = {
	"Can": {
		"hold": 1
	},
	"Man": {
		"hold": 1
	}
}

var heldImportant: Dictionary = {
	"hello": {
		"hold": 1
	}
}

var lukeUnlockedSkills: Array = [
	"Guard",
	"Shove",
	"Pester",
	"Spray Away",
	"-------------"
]

var brennaUnlockedSkills: Array = [
	"Guard",
	"Bake",
	"Hug",
	"Slice",
	"Rapid Slash",
	"-------------"
]

var LukeStatsPreBattle
var BrennaStatsPreBattle
var heldSnacksPreBattle
var heldToysPreBattle



func _process(delta: float) -> void:
	playtime_seconds += delta
