extends Control

@export var scene_to_send: String = "res://worlds/faraway_town/neighborhood.tscn"
@onready var music: AudioStreamPlayer = $music

func _ready():
	AutoplayMusic.stream = null

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	MainInfo.last_player_location = Vector2(0,0)
	MainInfo.previous_scene = -2
	get_tree().change_scene_to_file(scene_to_send)

func play_music():
	AutoplayMusic.checkMusic(music.stream)
	AutoplayMusic.fade_in()
