extends Node

var luke_levels = {
	"1": {
		"maxHeart": 30,
		"maxJuice": 25,
		"attack": 3,
		"defense": 2,
		"speed": 2,
		"skill": ""
	},
	"2": {
		"maxHeart": 33,
		"maxJuice": 28,
		"attack": 5,
		"defense": 3,
		"speed": 2,
		"skill": "Shove"
	}
}

var brenna_levels = {
	"1": {
		"maxHeart": 30,
		"maxJuice": 22,
		"attack": 5,
		"defense": 1,
		"speed": 1,
		"skill": ""
	},
	"2": {
		"maxHeart": 34,
		"maxJuice": 26,
		"attack": 5,
		"defense": 2,
		"speed": 1,
		"skill": "Rapid Slash"
	}
}

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

func checkEmotion(emotion: String, target) -> String:
	var emotions = ["neutral", "happy", "ecstatic", "manic", "sad", "depressed", "miserable", "angry", "enraged", "furious"]
	if !emotion in emotions:
		return "neutral"
	var current_emotion = target.emotion
	var new_emotion = emotion
	var max_level = target.max_emotion_level
	if current_emotion == "sad" && emotion == "sad":
		new_emotion = "depressed"
	if current_emotion == "sad" && emotion == "depressed":
		new_emotion = "depressed"
	if current_emotion == "depressed" && emotion == "depressed":
		new_emotion = "miserable"
	if current_emotion == "depressed" && emotion == "miserable":
		new_emotion = "miserable"
	if current_emotion == "miserable" && emotion == "miserable":
		new_emotion = "miserable"
	if current_emotion == "sad" && emotion == "miserable":
		new_emotion = "miserable"
	if current_emotion == "miserable" && emotion == "sad":
		new_emotion = "miserable"
	if current_emotion == "depressed" && emotion == "sad":
		new_emotion = "miserable"
	if current_emotion == "miserable" && emotion == "depressed":
		new_emotion = "miserable"
	if current_emotion == "happy" && emotion == "happy":
		new_emotion = "ecstatic"
	if current_emotion == "happy" && emotion == "ecstatic":
		new_emotion = "ecstatic"
	if current_emotion == "ecstatic" && emotion == "ecstatic":
		new_emotion = "manic"
	if current_emotion == "ecstatic" && emotion == "manic":
		new_emotion = "manic"
	if current_emotion == "manic" && emotion == "manic":
		new_emotion = "manic"
	if current_emotion == "happy" && emotion == "manic":
		new_emotion = "manic"
	if current_emotion == "manic" && emotion == "happy":
		new_emotion = "manic"
	if current_emotion == "manic" && emotion == "ecstatic":
		new_emotion = "manic"
	if current_emotion == "ecstatic" && emotion == "happy":
		new_emotion = "manic"
	if current_emotion == "angry" && emotion == "angry":
		new_emotion = "enraged"
	if current_emotion == "angry" && emotion == "enraged":
		new_emotion = "enraged"
	if current_emotion == "enraged" && emotion == "enraged":
		new_emotion = "furious"
	if current_emotion == "enraged" && emotion == "furious":
		new_emotion = "furious"
	if current_emotion == "furious" && emotion == "furious":
		new_emotion = "furious"
	if current_emotion == "angry" && emotion == "furious":
		new_emotion = "furious"
	if current_emotion == "furious" && emotion == "angry":
		new_emotion = "furious"
	if current_emotion == "furious" && emotion == "enraged":
		new_emotion = "furious"
	if current_emotion == "enraged" && emotion == "angry":
		new_emotion = "furious"
	if current_emotion == "miserable" && emotion == "angry":
		new_emotion = "angry"
	if current_emotion == "miserable" && emotion == "enraged":
		new_emotion = "enraged"
	if current_emotion == "miserable" && emotion == "furious":
		new_emotion = "furious"
	if current_emotion == "depressed" && emotion == "angry":
		new_emotion = "angry"
	if current_emotion == "depressed" && emotion == "enraged":
		new_emotion = "enraged"
	if current_emotion == "depressed" && emotion == "furious":
		new_emotion = "furious"
	if current_emotion == "sad" && emotion == "angry":
		new_emotion = "angry"
	if current_emotion == "sad" && emotion == "enraged":
		new_emotion = "enraged"
	if current_emotion == "sad" && emotion == "furious":
		new_emotion = "furious"
	if current_emotion == "miserable" && emotion == "happy":
		new_emotion = "happy"
	if current_emotion == "miserable" && emotion == "ecstatic":
		new_emotion = "ecstatic"
	if current_emotion == "miserable" && emotion == "manic":
		new_emotion = "manic"
	if current_emotion == "depressed" && emotion == "happy":
		new_emotion = "happy"
	if current_emotion == "depressed" && emotion == "ecstatic":
		new_emotion = "ecstatic"
	if current_emotion == "depressed" && emotion == "manic":
		new_emotion = "manic"
	if current_emotion == "sad" && emotion == "happy":
		new_emotion = "happy"
	if current_emotion == "sad" && emotion == "ecstatic":
		new_emotion = "ecstatic"
	if current_emotion == "sad" && emotion == "manic":
		new_emotion = "manic"
	if current_emotion == "furious" && emotion == "happy":
		new_emotion = "happy"
	if current_emotion == "furious" && emotion == "ecstatic":
		new_emotion = "ecstatic"
	if current_emotion == "furious" && emotion == "manic":
		new_emotion = "manic"
	if current_emotion == "enraged" && emotion == "happy":
		new_emotion = "happy"
	if current_emotion == "enraged" && emotion == "ecstatic":
		new_emotion = "ecstatic"
	if current_emotion == "enraged" && emotion == "manic":
		new_emotion = "manic"
	if current_emotion == "angry" && emotion == "happy":
		new_emotion = "happy"
	if current_emotion == "angry" && emotion == "ecstatic":
		new_emotion = "ecstatic"
	if current_emotion == "angry" && emotion == "manic":
		new_emotion = "manic"
	if max_level == 1:
		if new_emotion == "miserable" || new_emotion == "depressed":
			new_emotion = "sad"
		if new_emotion == "furious" || new_emotion == "enraged":
			new_emotion = "angry"
		if new_emotion == "manic" || new_emotion == "ecstatic":
			new_emotion = "happy"
	if max_level == 2:
		if new_emotion == "miserable" || new_emotion == "depressed": new_emotion = "depressed"
		if new_emotion == "furious" || new_emotion == "enraged": new_emotion = "enraged"
		if new_emotion == "manic" || new_emotion == "ecstatic": new_emotion = "ecstatic"
	if current_emotion == new_emotion:
		if new_emotion == "miserable" || new_emotion == "depressed" || new_emotion == "sad":
			return "SADDER"
		if new_emotion == "furious" || new_emotion == "enraged" || new_emotion == "angry":
			return "ANGRIER"
		if new_emotion == "manic" || new_emotion == "ecstatic" || new_emotion == "happy":
			return "HAPPIER"
	return new_emotion

var enemies = {
	"Hearts": {
		"name": "Hearts",
		"scene": preload("res://ui/battle/foe/hearts.tscn"),
		"maxHeart": 1,
		"attack": 5,
		"defense": 10,
		"speed": 3
	}
}

func brennaInParty() -> bool:
	var fol = MainInfo.followers.duplicate(true)
	fol.append(MainInfo.leader)
	if fol.has("Brenna"):
		return true
	else:
		return false
