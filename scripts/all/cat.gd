extends Node2D

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var sfx_meow: AudioStreamPlayer = $Meow

@export var tileName: String = "Cat"
@export var dialog_root: Dictionary = Dialog.hearts_messages
@export var dialog: Dictionary
var i_player
var interacted: bool = false

func _ready() -> void:
	if MainInfo.defeatedBosses.has("Hearts"):
		queue_free()

func interact(player):
	i_player = player
	dialog = Dialog.hearts_messages.get("message_" + str(Dialog.hearts_current_message))
	player.play_dialog(dialog_root, dialog, null, self)
	meow()

func meow():
	sprite.play("open")
	sfx_meow.playing = true
	await sprite.animation_finished
	sprite.play("close")

func finished_dialog():
	pass

func open():
	sprite.play("open")

func close():
	sprite.play("close")

func update_current_message():
	match Dialog.hearts_current_message:
		0:
			Dialog.hearts_current_message = 1
		1:
			Dialog.hearts_current_message = 2

func choose_choice(choice: String):
	match Dialog.hearts_current_message:
		0:
			match choice: # pet
				"yes":
					Dialog.hearts_current_message = 3
					Dialog.nathan_current_message = 2
					await get_tree().current_scene.begin_cutscene()
					get_tree().current_scene.get_node("CutScenes").play("pet_hearts")
					MainInfo.cut_scene_active = true
				"no":
					Dialog.hearts_current_message = 1
					dialog = Dialog.hearts_messages.get("message_" + str(Dialog.hearts_current_message))
					i_player.play_dialog(dialog_root, dialog, null, self)
					meow()
		1:
			match choice: # pet
				"yes":
					Dialog.hearts_current_message = 3
					Dialog.nathan_current_message = 2
					await get_tree().current_scene.begin_cutscene()
					get_tree().current_scene.get_node("CutScenes").play("pet_hearts")
					MainInfo.cut_scene_active = true
				"no":
					Dialog.hearts_current_message = 2
					dialog = Dialog.hearts_messages.get("message_" + str(Dialog.hearts_current_message))
					i_player.play_dialog(dialog_root, dialog, null, self)
					meow()
		2:
			match choice: # pet
				"yes":
					Dialog.hearts_current_message = 3
					Dialog.nathan_current_message = 2
					await get_tree().current_scene.begin_cutscene()
					get_tree().current_scene.get_node("CutScenes").play("pet_hearts")
					MainInfo.cut_scene_active = true
		3:
			match choice: # fight HEARTS
				"yes":
					Dialog.nathan_current_message = 3
					i_player.enter_battle(get_path(), ["Hearts"], Resources.BG_DW_FOREST, Resources.THREE_BAR_LOGOS)

func finished_battle():
	get_tree().current_scene.luke.position = Vector2(560.0, 880.0)
	MainInfo.defeatedBosses.append("Hearts")
	get_tree().current_scene.begin_cutscene(false)
	get_tree().current_scene.get_node("CutScenes").play("defeat_hearts")
	#queue_free()
