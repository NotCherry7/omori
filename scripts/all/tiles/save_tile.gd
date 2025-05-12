extends Node2D

var interacted: bool = false

@export var dialog_root: Dictionary = Dialog.common_messages
@export var dialog: Dictionary = Dialog.common_messages.get("save").duplicate(true)

func _ready():
	if MainInfo.current_world == "Dreamworld":
		dialog = Dialog.common_messages.get("save").duplicate(true)
	else:
		dialog = Dialog.common_messages.get("fa_save").duplicate(true)

func save_tile():
	pass

func interact(player):
	player.play_dialog(dialog_root, dialog, null, self)

func choose_choice(choice: String):
	match choice:
		"yes":
			MainInfo.canSave = true
			MainInfo.previous_scene = -2
			get_tree().change_scene_to_file("res://ui/saveScreen/save_load_screen.tscn")
		"no":
			pass
