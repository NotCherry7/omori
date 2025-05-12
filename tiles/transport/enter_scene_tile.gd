extends Node2D


@export var targetScene = "res://worlds/forest/forest.tscn"
@export var connection = 0
@export var locked: bool = true

var interacted: bool = false
var dialog_root: Dictionary = Dialog.common_messages
var dialog: Dictionary = Dialog.common_messages.get("lockedDoor")


func interact(body):
	if body.has_method("player"):
		if locked:
			body.play_dialog(dialog_root, dialog, null)
		else:
			MainInfo.previous_scene = connection
			MainInfo.location = get_tree().current_scene.area
			body.canMove = false
			body.screen_animation.play("fade")
			await body.screen_animation.animation_finished
			body.canMove = true
			if get_tree():
				get_tree().change_scene_to_file(targetScene)
