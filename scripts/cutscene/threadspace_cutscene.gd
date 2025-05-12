extends AnimationPlayer

var parent

func _ready() -> void:
	parent = get_parent()

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "open_door":
		pass
	if parent.brenna:
		parent.brenna.visible = true
	await parent.end_cutscene()
	$"../y-sort/LukeSprite".visible = false
	$"../y-sort/BrennaSprite".visible = false
	parent.luke.visible = true
	MainInfo.cut_scene_active = false
	parent.attach_camera()
