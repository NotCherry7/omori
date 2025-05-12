extends Node2D

@onready var watermelon_sprite: Sprite2D = $watermelon
@onready var squashed_sprite: Sprite2D = $squashed
@onready var collision: CollisionShape2D = $StaticBody2D/CollisionShape2D

@export var sound: AudioStream
var tileName: String = "Watermelon"
var dialog_root: Dictionary = Dialog.common_messages
var dialog: Dictionary = Dialog.common_messages.get("findItem")
var content: String = "Granola"
var interacted: bool = false

@export_enum("Weapon", "Charm", "Snack", "Item", "Toy") var content_type: String = "Snack"
@export var content_list: Array = ["Granola", "Popcorn", "Butter Chicken"]

@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer
const SFX_SOUND = preload("res://audio/tiles/SE_New_Skill.ogg")

func _ready() -> void:
	if Data.squashed_watermelons.has(global_position):
		squash()
	content = content_list.pick_random()
	sfx.stream = sound
	dialog = Dialog.common_messages.get("findItem").duplicate(true)
	dialog["text"] = dialog["text"].replace("/item", content.to_upper())

func squash():
	watermelon_sprite.visible = false
	squashed_sprite.visible = true
	interacted = true
	call_deferred("disableCollision")

func interact(player):
	sfx.playing = true
	squash()
	Data.squashed_watermelons.append(global_position)
	player.find(content_type.to_lower(), content)
	player.play_dialog(dialog_root, dialog, SFX_SOUND)

func disableCollision():
	collision.disabled = true
