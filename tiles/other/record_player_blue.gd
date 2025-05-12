extends Node2D

@onready var record: Sprite2D = $Record
@export var music: Array[AudioStream] = []
@export var music_color: Array[Color] = []
var interacted: bool = false
var current_music: int = 0


func _ready() -> void:
	current_music = 0
	AutoplayMusic.checkMusic(music[current_music])
	record.self_modulate = music_color[current_music]

func interact(player):
	if player.has_method("player"):
		current_music = (current_music + 1) % music.size()
		AutoplayMusic.checkMusic(music[current_music])
		for r in get_tree().get_nodes_in_group("record_players"):
			r.record.self_modulate = music_color[current_music]
