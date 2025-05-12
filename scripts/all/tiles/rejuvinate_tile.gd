extends Node2D

@onready var collision: CollisionShape2D = $StaticBody2D/CollisionShape2D

@export var tileName: String = "Food"
@export var dialog_root: Dictionary = Dialog.common_messages
@export var dialog: Dictionary = Dialog.common_messages.get("nathanSnack")
@export var content: String = "chicken"
var player
var interacted: bool = false

@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	dialog = Dialog.common_messages.get("nathanSnack").duplicate(true)
	dialog["text"] = dialog["text"].replace("/i", content)

func interact(i_player):
	player = i_player
	i_player.play_dialog(dialog_root, dialog, null, self)

func finished_dialog():
	pass

func choose_choice(choice: String):
	match choice:
		"yes":
			player.restore_health()
		"no":
			pass
