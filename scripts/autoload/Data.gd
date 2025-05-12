extends Node

var file_preview1_save_path = "user://omori_file_preview1.save"
var file_preview2_save_path = "user://omori_file_preview2.save"
var file_preview3_save_path = "user://omori_file_preview3.save"

var file_1_save_path = "user://omori_file1.save"
var file_2_save_path = "user://omori_file2.save"
var file_3_save_path = "user://omori_file3.save"

var squashed_watermelons: Array = []
var interactedTiles: Array = []

func save(fileNum: int):
	var file
	var file_preview
	match fileNum:
		1:
			file = FileAccess.open(file_1_save_path, FileAccess.WRITE)
			file_preview = FileAccess.open(file_preview1_save_path, FileAccess.WRITE)
		2:
			file = FileAccess.open(file_2_save_path, FileAccess.WRITE)
			file_preview = FileAccess.open(file_preview2_save_path, FileAccess.WRITE)
		3:
			file = FileAccess.open(file_3_save_path, FileAccess.WRITE)
			file_preview = FileAccess.open(file_preview3_save_path, FileAccess.WRITE)
	file.store_var(squashed_watermelons)
	file.store_var(interactedTiles)
	file.store_var(MainInfo.FALukeStats)
	file.store_var(MainInfo.FABrennaStats)
	file.store_var(MainInfo.LukeStats)
	file.store_var(MainInfo.LukeMainSkills)
	file.store_var(MainInfo.lukeUnlockedSkills)
	file.store_var(MainInfo.BrennaStats)
	file.store_var(MainInfo.BrennaMainSkills)
	file.store_var(MainInfo.brennaUnlockedSkills)
	file.store_var(MainInfo.leader)
	file.store_var(MainInfo.followers)
	file.store_var(MainInfo.chips)
	file.store_var(MainInfo.heldItems)
	file.store_var(MainInfo.heldSnacks)
	file.store_var(MainInfo.heldToys)
	file.store_var(MainInfo.heldImportant)
	file.store_var(MainInfo.heldCharms)
	file.store_var(MainInfo.heldWeapons)
	file.store_var(MainInfo.location)
	file.store_var(MainInfo.last_scene_path)
	file.store_var(MainInfo.last_player_location)
	file.store_var(MainInfo.last_player_direction)
	file.store_var(MainInfo.pos_history)
	file.store_var(MainInfo.dir_history)
	file.store_var(MainInfo.playtime_seconds)
	file.store_var(MainInfo.defeatedBosses)
	file.store_var(MainInfo.current_world)
	
	file.store_var(Dialog.nathan_current_message)
	file.store_var(Dialog.hearts_current_message)
	
	file.store_var(MainInfo.flowersFound)
	file.store_var(MainInfo.current_ending)
	file.store_var(MainInfo.visited_brenna)
	
	
	
	
	# THIS IS FOR THE PREVIEW -=- DO NOT STORE REAL INFO HERE!!!
	
	file_preview.store_var(MainInfo.leader)
	file_preview.store_var(MainInfo.LukeStats["level"])
	file_preview.store_var(MainInfo.location)
	file_preview.store_var(MainInfo.playtime_seconds)
	file_preview.store_var(MainInfo.current_world)

func load_data(fileNum: int):
	var file
	match fileNum:
		1:
			if !FileAccess.file_exists(file_1_save_path): return
			file = FileAccess.open(file_1_save_path, FileAccess.READ)
		2:
			if !FileAccess.file_exists(file_2_save_path): return
			file = FileAccess.open(file_2_save_path, FileAccess.READ)
		3:
			if !FileAccess.file_exists(file_3_save_path): return
			file = FileAccess.open(file_3_save_path, FileAccess.READ)
	squashed_watermelons = file.get_var()
	interactedTiles = file.get_var()
	MainInfo.FALukeStats = file.get_var()
	MainInfo.FABrennaStats = file.get_var()
	MainInfo.LukeStats = file.get_var()
	MainInfo.LukeMainSkills = file.get_var()
	MainInfo.lukeUnlockedSkills = file.get_var()
	MainInfo.BrennaStats = file.get_var()
	MainInfo.BrennaMainSkills = file.get_var()
	MainInfo.brennaUnlockedSkills = file.get_var()
	MainInfo.leader = file.get_var()
	MainInfo.followers = file.get_var()
	MainInfo.chips = file.get_var()
	MainInfo.heldItems = file.get_var()
	MainInfo.heldSnacks = file.get_var()
	MainInfo.heldToys = file.get_var()
	MainInfo.heldImportant = file.get_var()
	MainInfo.heldCharms = file.get_var()
	MainInfo.heldWeapons = file.get_var()
	MainInfo.location = file.get_var()
	MainInfo.last_scene_path = file.get_var()
	MainInfo.last_player_location = file.get_var()
	MainInfo.last_player_direction = file.get_var()
	MainInfo.pos_history = file.get_var()
	MainInfo.dir_history = file.get_var()
	MainInfo.playtime_seconds = file.get_var()
	MainInfo.defeatedBosses = file.get_var()
	MainInfo.current_world = file.get_var()
	
	Dialog.nathan_current_message = file.get_var()
	Dialog.hearts_current_message = file.get_var()
	
	MainInfo.flowersFound = file.get_var()
	MainInfo.current_ending = file.get_var()
	MainInfo.visited_brenna = file.get_var()

func new_game():
	squashed_watermelons = []
	interactedTiles = []
	MainInfo.FALukeStats = MainInfo.defaultFALukeStats.duplicate(true)
	MainInfo.FABrennaStats = MainInfo.defaultFABrennaStats.duplicate(true)
	MainInfo.LukeStats = MainInfo.defaultLukeStats.duplicate(true)
	MainInfo.LukeMainSkills = ["Guard", "Pester", "Spray Away"]
	MainInfo.lukeUnlockedSkills = ["Guard", "Pester", "Spray Away", "-------------"]
	MainInfo.BrennaStats = MainInfo.defaultBrennaStats.duplicate(true)
	MainInfo.BrennaMainSkills = ["Guard", "Bake", "Slice"]
	MainInfo.brennaUnlockedSkills = ["Guard", "Bake", "Slice", "-------------"]
	MainInfo.leader = "Luke"
	MainInfo.followers = ["Brenna"]
	MainInfo.chips = 0
	MainInfo.previous_scene = -2
	MainInfo.heldItems = {}
	MainInfo.heldSnacks = {}
	MainInfo.heldToys = {}
	MainInfo.heldImportant = {}
	MainInfo.heldCharms = []
	MainInfo.heldWeapons = []
	MainInfo.location = null
	MainInfo.last_scene_path = ""
	MainInfo.last_player_location = Vector2(0,0)
	MainInfo.last_player_direction = "Down"
	MainInfo.pos_history = []
	MainInfo.dir_history = []
	MainInfo.playtime_seconds = 0
	MainInfo.defeatedBosses = []
	MainInfo.current_world = "Dreamworld"
	
	Dialog.nathan_current_message = 0
	Dialog.hearts_current_message = 0
	
	MainInfo.flowersFound = []
	MainInfo.current_ending = "Good"
	MainInfo.visited_brenna = false

func checkFile(fileNum: int) -> bool:
	match fileNum:
		1:
			if !FileAccess.file_exists(file_1_save_path): return false
			else: return true
		2:
			if !FileAccess.file_exists(file_2_save_path): return false
			else: return true
		3:
			if !FileAccess.file_exists(file_3_save_path): return false
			else: return true
		_:
			return false

func load_file_preview(fileNum: int) -> Dictionary:
	var file_dict = {
		"leader": null,
		"level": null,
		"location": null,
		"playtime": 0.0,
		"world": null
	}
	var file_preview
	match fileNum:
		1:
			if !FileAccess.file_exists(file_preview1_save_path): return {}
			file_preview = FileAccess.open(file_preview1_save_path, FileAccess.READ)
		2:
			if !FileAccess.file_exists(file_preview2_save_path): return {}
			file_preview = FileAccess.open(file_preview2_save_path, FileAccess.READ)
		3:
			if !FileAccess.file_exists(file_preview3_save_path): return {}
			file_preview = FileAccess.open(file_preview3_save_path, FileAccess.READ)
	
	var leader = file_preview.get_var()
	var level = file_preview.get_var()
	var location = file_preview.get_var()
	var playtime = file_preview.get_var()
	var world = file_preview.get_var()
	file_dict["leader"] = leader
	file_dict["level"] = level
	file_dict["location"] = location
	file_dict["playtime"] = playtime
	file_dict["world"] = world
	return file_dict
