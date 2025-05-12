extends Node2D


@export var sound: AudioStream
@export var tileName: String = ""
@export var dialog: String = ""
@export var content: Array[String] = []

@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	sfx.stream = sound

func interact():
	match tileName:
		"Watermelon":
			pass
