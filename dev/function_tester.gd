extends Control


@onready var cur_emot: LineEdit = $curEmot
@onready var add_emot: LineEdit = $addEmot
@onready var result: Label = $result

func get_emotion_multiplier(attacker_emotion: String, victim_emotion: String) -> float:
	var sad_emotions = ["sad", "depressed", "miserable"]
	var happy_emotions = ["happy", "ecstatic", "manic"]
	var angry_emotions = ["angry", "enraged", "furious"]
	if sad_emotions.has(attacker_emotion) && victim_emotion == "happy":
		return 1.5
	elif sad_emotions.has(attacker_emotion) && victim_emotion == "ecstatic":
		return 2.0
	elif sad_emotions.has(attacker_emotion) && victim_emotion == "manic":
		return 2.5
	elif happy_emotions.has(attacker_emotion) && victim_emotion == "sad":
		return 0.8
	elif happy_emotions.has(attacker_emotion) && victim_emotion == "depressed":
		return 0.65
	elif happy_emotions.has(attacker_emotion) && victim_emotion == "miserable":
		return 0.5
		
	elif angry_emotions.has(attacker_emotion) && victim_emotion == "sad":
		return 1.5
	elif angry_emotions.has(attacker_emotion) && victim_emotion == "depressed":
		return 2.0
	elif angry_emotions.has(attacker_emotion) && victim_emotion == "miserable":
		return 2.5
	elif sad_emotions.has(attacker_emotion) && victim_emotion == "angry":
		return 0.8
	elif sad_emotions.has(attacker_emotion) && victim_emotion == "enraged":
		return 0.65
	elif sad_emotions.has(attacker_emotion) && victim_emotion == "furious":
		return 0.5
		
	elif happy_emotions.has(attacker_emotion) && victim_emotion == "angry":
		return 1.5
	elif happy_emotions.has(attacker_emotion) && victim_emotion == "enraged":
		return 2.0
	elif happy_emotions.has(attacker_emotion) && victim_emotion == "furious":
		return 2.5
	elif angry_emotions.has(attacker_emotion) && victim_emotion == "happy":
		return 0.8
	elif angry_emotions.has(attacker_emotion) && victim_emotion == "ecstatic":
		return 0.65
	elif angry_emotions.has(attacker_emotion) && victim_emotion == "manic":
		return 0.5
	else:
		return 1.0
	

func _on_calculate_pressed() -> void:
	result.text = str(get_emotion_multiplier(cur_emot.text, add_emot.text))
