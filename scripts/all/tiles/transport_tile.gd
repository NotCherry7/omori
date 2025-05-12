extends Node2D


@export var targetScene = "res://worlds/forest/forest.tscn"
@export var connection = 0

var isCalled: bool = false

func transport_tile():
	pass

func changeScene(body):
	if !isCalled:
		if body.has_method("player"):
			isCalled = true
			MainInfo.previous_scene = connection
			MainInfo.location = get_tree().current_scene.area
			body.canMove = false
			body.screen_animation.play("fade")
			await body.screen_animation.animation_finished
			body.canMove = true
			if get_tree():
				get_tree().change_scene_to_file(targetScene)
