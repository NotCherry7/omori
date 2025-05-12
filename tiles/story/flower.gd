extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

@export var frame: int = 0
@onready var sfx: AudioStreamPlayer = $sfx

var dialog_root: Dictionary = Dialog.find_flower
var dialog: Dictionary = Dialog.find_flower.get("message_0")
var content: String = "Granola"
var interacted: bool = false

@onready var collision: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready() -> void:
	if MainInfo.flowersFound.has(global_position):
		queue_free()
	if !MainInfo.visited_brenna:
		call_deferred("disable_collision")
		sprite.visible = false
	sprite.frame = frame

func interact(player):
	if interacted: return
	if player.has_method("player"):
		interacted = true
		MainInfo.flowersFound.append(global_position)
		dialog = Dialog.find_flower.get("message_" + str(MainInfo.flowersFound.size() - 1))
		player.play_dialog(dialog_root, dialog, null, self)
		sfx.playing = true
		sprite.visible = false
		call_deferred("disable_collision")
		await sfx.finished
		queue_free()

func disable_collision():
	collision.disabled = true

func enable_collision():
	collision.disabled = false

func reveal():
	call_deferred("enable_collision")
	sprite.visible = true
