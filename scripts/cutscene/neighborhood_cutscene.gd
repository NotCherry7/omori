extends AnimationPlayer

var dialog_root
var dialog

var parent

func _ready() -> void:
	parent = get_parent()

func visit_brenna():
	MainInfo.leader = "Luke"
	parent.luke.position = Vector2(1200.0, 1232.0)
	dialog_root = Dialog.visit_brenna.duplicate(true)
	dialog = dialog_root.get("message_0")
	parent.player.play_dialog(dialog_root, dialog, null, self)
	pause()

func finished_dialog():
	play()

func choose_choice(choice: String):
	match current_animation:
		"visit_brenna":
			match choice:
				"yes":
					MainInfo.visited_brenna = true
					dialog_root = Dialog.visit_brenna.duplicate(true)
					dialog = dialog_root.get("message_2")
					parent.player.play_dialog(dialog_root, dialog, null, self)
					MainInfo.current_ending = "Good"
					pause()
					parent.add_brenna()
				"no":
					dialog_root = Dialog.visit_brenna.duplicate(true)
					dialog = dialog_root.get("message_1")
					parent.player.play_dialog(dialog_root, dialog, null, self)
					MainInfo.current_ending = "Bad"
					pause()

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "visit_brenna":
		if MainInfo.visited_brenna:
			for r in get_tree().get_nodes_in_group("flower"):
				r.reveal()
	if parent.brenna:
		parent.brenna.visible = true
	await parent.end_cutscene()
	$"../y-sort/LukeSprite".visible = false
	$"../y-sort/BrennaSprite".visible = false
	parent.luke.visible = true
	MainInfo.cut_scene_active = false
	parent.attach_camera()
