extends AnimationPlayer

var dialog_root
var dialog

var parent

func _ready() -> void:
	parent = get_parent()

func eat_brenna():
	MainInfo.leader = "Luke"
	parent.luke.position = Vector2(560.0, 880.0)
	parent.player.followers.pop_front()
	parent.brenna.queue_free()
	MainInfo.followers = []
	dialog_root = Dialog.pet_hearts.duplicate(true)
	dialog = dialog_root.get("message_0")
	parent.player.play_dialog(dialog_root, dialog, null, self)
	pause()

func command_hearts():
	parent.luke.position = Vector2(560.0, 880.0)
	dialog_root = Dialog.pet_hearts.duplicate(true)
	dialog = dialog_root.get("message_1")
	parent.player.play_dialog(dialog_root, dialog, null, self)
	pause()

func puke_brenna():
	MainInfo.leader = "Luke"
	parent.luke.position = Vector2(560.0, 880.0)
	dialog_root = Dialog.pet_hearts.duplicate(true)
	dialog = dialog_root.get("message_2")
	parent.player.play_dialog(dialog_root, dialog, null, self)
	MainInfo.current_world = "Realworld"
	pause() 
	await get_tree().create_timer(1).timeout
	if get_tree():
		get_tree().change_scene_to_file("res://cutscenes/to_town.tscn")

func finished_dialog():
	play()

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "pet_hearts":
		parent.luke.sprite.texture = Resources.LUKE_SPRITE
		parent.luke.animation.play("idle_up")
	if parent.brenna:
		parent.brenna.visible = true
	await parent.end_cutscene()
	$"../y-sort/LukeSprite".visible = false
	$"../y-sort/BrennaSprite".visible = false
	parent.luke.visible = true
	MainInfo.cut_scene_active = false
	parent.attach_camera()
