extends AudioStreamPlayer


func _ready() -> void:
	fade_in()

func checkMusic(music = null):
	if music == null:
		return
	if stream != music:
		stream = music
		fade_in()

func fade_in():
	playing = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", 0.0, 0.5)

func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -10.0, 0.5)
	await tween.finished
	playing = false
