extends Node2D

@export var music: AudioStream

var scene_name = "upper_forest"

func _ready() -> void:
	AutoplayMusic.checkMusic(music)
