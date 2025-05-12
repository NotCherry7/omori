extends Node2D

@onready var watermelon_sprite: Sprite2D = $watermelon
@onready var squashed_sprite: Sprite2D = $squashed
@onready var collision: CollisionShape2D = $StaticBody2D/CollisionShape2D

@export var sound: AudioStream
@export var tileName: String = "Watermelon"
@export var dialog_root: Dictionary = Dialog.common_messages
@export var dialog: Dictionary = Dialog.common_messages.get("findCharm")
@export var content: String = "Spray Can"
@export_enum("Weapon", "Charm", "Snack", "Item", "Toy") var content_type: String = "Charm"
var interacted: bool = false



@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer
const SFX_SOUND = preload("res://audio/tiles/SE_New_Skill.ogg")

func _ready() -> void:
	dialog = Dialog.common_messages.get("findCharm").duplicate(true)
	dialog["text"] = dialog["text"].replace("/item", content.to_upper())
	if Data.squashed_watermelons.has(global_position):
		squash()
	sfx.stream = sound

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
