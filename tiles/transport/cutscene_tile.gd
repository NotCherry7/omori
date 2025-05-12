extends Node2D

@export var cutscene_node: AnimationPlayer
@export var cutscene_animation: String
var dialog_root: Dictionary = Dialog.common_messages
var dialog: Dictionary = Dialog.common_messages.get("lockedDoor")
var interacted: bool = false

func interact(player):
	if player.has_method("player"):
		if !interacted:
			await get_tree().current_scene.begin_cutscene()
			cutscene_node.play(cutscene_animation)
		else:
			player.play_dialog(dialog_root, dialog, null)
			Data.interactedTiles.append(global_position)
