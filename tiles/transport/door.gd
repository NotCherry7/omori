extends Node2D

@onready var animation: AnimationPlayer = $AnimationPlayer

@export var scene: String
var interacted: bool = false

var player

func interact(body):
	if body.has_method("player"):
		player = body
		await get_tree().current_scene.begin_cutscene()
		get_tree().current_scene.get_node("CutScenes").play("open_door")

func open():
	animation.play("open")

func change_scene():
	MainInfo.last_player_location = Vector2(0,0)
	MainInfo.previous_scene = -2
	player.screen_animation.play("fade")
	await player.screen_animation.animation_finished
	get_tree().change_scene_to_file(scene)
