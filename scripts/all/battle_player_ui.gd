extends Node2D

@export var playerName: String = "Luke"
@export var thisName: String = "Luke"
@export var health: int
@export var maxHealth: int
@export var juice: int
@export var maxJuice: int

@export var attack: float
@export var defense: float
@export var speed: float
@export var luck: float
@export var hitRate: float

var damageReducedNextAttack: float

var defaultAttack: int
var defaultDefense: int
var defaultSpeed: int
var defaultLuck: int
var defaultHitRate: float

var unbuffedAttack: int
var unbuffedDefense: int
var unbuffedSpeed: int

var attack_buff: int = 0 #negatives = debuff
var defense_buff: int = 0
var speed_buff: int = 0 

@export var emotion: String = "neutral"

var sadTypes = ["sad", "depressed", "miserable"]
var angryTypes = ["angry", "enraged", "furious"]
var happyTypes = ["happy", "ecstatic", "manic"]

var isAlive: bool = true
@onready var hurt_animation: AnimationPlayer = $HurtAnimations
@onready var attack_sfx: AudioStreamPlayer = $AttackSFX
@onready var animated_face: AnimatedSprite2D = $Frame/Container/AnimatedFaceHighRes
@onready var animated_face_low_res: AnimatedSprite2D = $Frame/Container/AnimatedFace

@onready var emotion_text: TextureRect = $EmotionText
@onready var emotion_bg: TextureRect = $EmotionBg
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var face: TextureRect = $Frame/Container/Face

@onready var health_bar: TextureProgressBar = $Health
@onready var health_label: Label = $Health/Label
@onready var juice_bar: TextureProgressBar = $Juice
@onready var juice_label: Label = $Juice/Label

@onready var first_text_hbox: HBoxContainer = $TopTextBox
@onready var second_text_hbox: HBoxContainer = $BottomTextBox

var target
var slot # refers to skills, toys, or snacks
var friend_foe: bool = false
var action: String = "attack"

var lastDamageTaken: int = 0
var lastJuiceLost: int = 0

@export var max_emotion_level: int = 3

const text_scene = preload("res://ui/battle/damage_text.tscn")
const miss_text_scene = preload("res://ui/battle/miss_text.tscn")

const DAMAGE = preload("res://assets/ui/numbers/damage.png")
const HEAL = preload("res://assets/ui/numbers/heal.png")
const GAIN_JUICE = preload("res://assets/ui/numbers/gainJuice.png")
const LOSE_JUICE = preload("res://assets/ui/numbers/loseJuice.png")


@onready var attackAnimations: CenterContainer = $Attack
var attackAnimation

func _ready() -> void:
	attackAnimation = attackAnimations.animations
	update_stats()
	updateFace()
	updateHealthReady()
	update_default_stats()
	applyEmotion("neutral")

func update_default_stats():
	defaultAttack = attack
	defaultDefense = defense
	defaultSpeed = speed
	defaultLuck = luck
	defaultHitRate = hitRate

	unbuffedAttack = attack
	unbuffedDefense = defense
	unbuffedSpeed = speed

func updateBuffs():
	match attack_buff:
		-3:
			attack = unbuffedAttack * 0.7
		-2:
			attack = unbuffedAttack * 0.8
		-1:
			attack = unbuffedAttack * 0.9
		0:
			attack = unbuffedAttack
		1:
			attack = unbuffedAttack * 1.1
		2:
			attack = unbuffedAttack * 1.25
		3:
			attack = unbuffedAttack * 1.5
	match defense_buff:
		-3:
			defense = unbuffedDefense * 0.25
		-2:
			defense = unbuffedDefense * 0.5
		-1:
			defense = unbuffedDefense * 0.75
		0:
			defense = unbuffedDefense
		1:
			defense = unbuffedDefense * 1.15
		2:
			defense = unbuffedDefense * 1.3
		3:
			defense = unbuffedDefense * 1.5
	match speed_buff:
		-3:
			speed = unbuffedSpeed * 0.25
		-2:
			speed = unbuffedSpeed * 0.5
		-1:
			speed = unbuffedSpeed * 0.8
		0:
			speed = unbuffedSpeed
		1:
			speed = unbuffedSpeed * 1.5
		2:
			speed = unbuffedSpeed * 2
		3:
			speed = unbuffedSpeed * 5

func hurt():
	var mat = animated_face.get_material()
	if mat.resource_local_to_scene == false:
		mat = mat.duplicate()
		mat.resource_local_to_scene = true
		animated_face.set_material(mat)
	mat.set_shader_parameter("enable_effects", true)
	await get_tree().create_timer(1.0).timeout
	mat.set_shader_parameter("enable_effects", false)

func applyHealth(value: int):
	var final_health = roundi(value)
	health = clamp(health + final_health, 0, maxHealth)
	updateHealth()
	
	for child in first_text_hbox.get_children():
		child.queue_free()
	for child in second_text_hbox.get_children():
		child.queue_free()

	if final_health > 0:
		displayDamageText("heal", final_health, 1)

func applyJuice(value: int):
	var final_juice = roundi(value)
	juice = clamp(juice + final_juice, 0, maxJuice)
	updateHealth()
	
	for child in first_text_hbox.get_children():
		child.queue_free()
	for child in second_text_hbox.get_children():
		child.queue_free()

	displayDamageText("gainJuice", final_juice, 1)

func applyHealthJuice(healthValue: int, juiceValue: int):
	var final_health = roundi(healthValue)
	health = clamp(health + final_health, 0, maxHealth)
	var final_juice = roundi(juiceValue)
	juice = clamp(juice + final_juice, 0, maxJuice)
	updateHealth()
	
	for child in first_text_hbox.get_children():
		child.queue_free()
	for child in second_text_hbox.get_children():
		child.queue_free()

	displayDamageText("heal", final_health, 1)
	print(final_juice)
	displayDamageText("gainJuice", final_juice, 2)

func applyDamage(value: int, withDefense: bool):
	if health <= 0:
		isAlive = false
		return
	var final_damage = max(roundi(value), 0)
	final_damage = roundi(final_damage)
	
	final_damage = final_damage * abs(damageReducedNextAttack - 1)
	
	var damage_with_defense = max(final_damage - defense, 0)
	if withDefense: damage_with_defense = max(final_damage - defense, 0)
	elif !withDefense: damage_with_defense = max(final_damage, 0)
	var to_juice = 0

	# Handle special case for emotions
	if emotion in sadTypes:
		match emotion:
			"sad":
				to_juice = ceil(damage_with_defense * 0.3)
				final_damage = floor(damage_with_defense * 0.7)
			"depressed":
				to_juice = ceil(damage_with_defense * 0.5)
				final_damage = floor(damage_with_defense * 0.5)
			"miserable":
				to_juice = damage_with_defense
				final_damage = 0
		juice = clampi(juice - to_juice, 0, 9999)

	# Apply final damage
	health = clampi(health - final_damage, 0, 9999)
	updateHealth()

	# Clear previous damage text
	for child in first_text_hbox.get_children():
		child.queue_free()
	for child in second_text_hbox.get_children():
		child.queue_free()

	# Display damage numbers if not zero
	if final_damage > 0:
		displayDamageText("damage", final_damage, 1)

	if to_juice > 0:
		displayDamageText("loseJuice", to_juice, 2 if final_damage > 0 else 1)
	if final_damage <= 0 && to_juice <= 0:
		miss()
	else:
		hurt()
	lastDamageTaken = final_damage
	lastJuiceLost = to_juice

func displayDamageText(type: String, value: int, box: int):
	var hbox
	if box == 1: hbox = first_text_hbox
	if box == 2: hbox = second_text_hbox
	hbox.modulate = Color(1.0, 1.0, 1.0, 0.0)
	for digit in str(value):
		if digit == ".": break
		var damage_text = text_scene.instantiate()
		var damage_sprite = damage_text.get_node("DamageText")
		damage_sprite.frame = int(digit)
		hbox.add_child(damage_text)

		match type:
			"damage":
				damage_sprite.texture = DAMAGE
			"heal":
				damage_sprite.texture = HEAL
			"gainJuice":
				damage_sprite.texture = GAIN_JUICE
			"loseJuice":
				damage_sprite.texture = LOSE_JUICE

	var tween = get_tree().create_tween()
	tween.tween_property(hbox, "modulate", Color(1.0, 1.0, 1.0), 0.2)
	
	await get_tree().create_timer(2).timeout

	var tween_out = get_tree().create_tween()
	tween_out.tween_property(hbox, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2)
	await tween_out.finished

	for child in hbox.get_children():
		child.queue_free()

func miss():
	first_text_hbox.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var damage_text = miss_text_scene.instantiate()
	first_text_hbox.add_child(damage_text)

	var tween = get_tree().create_tween()
	tween.tween_property(first_text_hbox, "modulate", Color(1.0, 1.0, 1.0), 0.2)
	
	await get_tree().create_timer(2).timeout

	var tween_out = get_tree().create_tween()
	tween_out.tween_property(first_text_hbox, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2)
	await tween_out.finished

	for child in first_text_hbox.get_children():
		child.queue_free()

func toast():
	var mat = animated_face.get_material()
	mat.set_shader_parameter("enable_effects", false)
	emotion_text.texture = null
	emotion_bg.texture = Resources.STRESSED_OUT_BG
	animated_face.play("toast_" + currentPlayer())
	isAlive = false

func currentPlayer() -> String:
	return playerName.to_lower()

func update_stats():
	var stats
	if playerName == "Luke": stats = MainInfo.LukeStats
	elif playerName == "Brenna": stats = MainInfo.BrennaStats
	else: return
	var weapon = SkillsItemsWeapons.weapons.get(stats.get("weapon"))
	var charm = SkillsItemsWeapons.charms.get(stats.get("charm"))
	thisName = playerName
	health = stats.get("currentHeart")
	juice = stats.get("currentJuice")
	maxHealth = stats.get("maxHeart") + (weapon.get("health", 0) if weapon else 0) + (charm.get("health", 0) if charm else 0)
	maxJuice = stats.get("maxJuice") + (weapon.get("juice", 0) if weapon else 0) + (charm.get("juice", 0) if charm else 0)
	attack = stats.get("attack") + (weapon.get("attack", 0) if weapon else 0) + (charm.get("attack", 0) if charm else 0)
	defense = stats.get("defense") + (weapon.get("defense", 0) if weapon else 0) + (charm.get("defense", 0) if charm else 0)
	speed = stats.get("speed") + (weapon.get("speed", 0) if weapon else 0) + (charm.get("speed", 0) if charm else 0)
	luck = stats.get("luck") + (weapon.get("luck", 0) if weapon else 0) + (charm.get("luck", 0) if charm else 0)
	hitRate = (weapon.get("hitRate") if weapon else stats.get("hitRate", 0)) + (charm.get("hitRate", 0) if charm else 0)

func updateFace():
	match playerName:
		"Luke":
			face.texture = Resources.LUKE_SKETCH
		"Brenna":
			face.texture = Resources.BRENNA_SKETCH

func updateHealth():
	var old_health = int(health_label.text.split("/")[0])
	var new_health = health
	var old_juice = int(juice_label.text.split("/")[0])
	var new_juice = juice
	var health_difference = abs(old_health - new_health)
	var juice_difference = abs(old_juice - new_juice)

	var tween = get_tree().create_tween()
	tween.set_parallel(true)

	# Tween health
	tween.tween_method(update_health_text, old_health, new_health, health_difference * 0.02)
	tween.tween_property(health_bar, "value", new_health, health_difference * 0.02)

	# Tween juice
	tween.tween_method(update_juice_text, old_juice, new_juice, juice_difference * 0.02)
	tween.tween_property(juice_bar, "value", new_juice, juice_difference * 0.02)

	health_bar.max_value = maxHealth
	juice_bar.max_value = maxJuice

	#health_label.text = str(health) + "/" + str(maxHealth)
	#juice_label.text = str(juice) + "/" + str(maxJuice)
	#
	#health_bar.value = health
	#juice_bar.value = juice
	
# Custom function to update health text during tween
func update_health_text(value):
	health_label.text = str(int(value)) + "/" + str(maxHealth)

# Custom function to update juice text during tween
func update_juice_text(value):
	juice_label.text = str(int(value)) + "/" + str(maxJuice)


func updateHealthReady():
	health_label.text = "0/" + str(maxHealth)
	juice_label.text = "0/" + str(maxJuice)
	var old_health = int(health_label.text.split("/")[0])
	var new_health = health
	var old_juice = int(juice_label.text.split("/")[0])
	var new_juice = juice
	var health_difference = abs(old_health - new_health)
	var juice_difference = abs(old_juice - new_juice)

	var tween = get_tree().create_tween()
	tween.set_parallel(true)

	# Tween health
	tween.tween_method(update_health_text, old_health, new_health, health_difference * 0.02)
	tween.tween_property(health_bar, "value", new_health, health_difference * 0.02)

	# Tween juice
	tween.tween_method(update_juice_text, old_juice, new_juice, juice_difference * 0.02)
	tween.tween_property(juice_bar, "value", new_juice, juice_difference * 0.02)

	health_bar.max_value = maxHealth
	juice_bar.max_value = maxJuice

func resetStats():
	attack = defaultAttack
	defense = defaultDefense
	speed = defaultSpeed
	luck = defaultLuck
	hitRate = defaultHitRate

func applyEmotion(emotionType: String):
	resetStats()
	match emotionType:
		"neutral":
			emotion = "neutral"
			emotion_bg.texture = Resources.NEUTRAL_BG
			emotion_text.texture = Resources.NEUTRAL_TEXT
		"happy":
			emotion = "happy"
			emotion_bg.texture = Resources.HAPPY_BG
			emotion_text.texture = Resources.HAPPY_TEXT
			hitRate = defaultHitRate * 0.9
			luck = defaultLuck * 2
			speed = defaultSpeed * 1.25
		"ecstatic":
			emotion = "ecstatic"
			emotion_bg.texture = Resources.ECSTATIC_BG
			emotion_text.texture = Resources.ECSTATIC_TEXT
			hitRate = defaultHitRate * 0.8
			luck = defaultLuck * 3
			speed = defaultSpeed * 1.5
		"manic":
			emotion = "manic"
			emotion_bg.texture = Resources.MANIC_BG
			emotion_text.texture = Resources.MANIC_TEXT
			hitRate = defaultHitRate * 0.7
			luck = defaultLuck * 4
			speed = defaultSpeed * 2
		"sad":
			emotion = "sad"
			emotion_bg.texture = Resources.SAD_BG
			emotion_text.texture = Resources.SAD_TEXT
			defense = defaultDefense * 1.25
			speed = defaultSpeed * 0.8
		"depressed":
			emotion = "depressed"
			emotion_bg.texture = Resources.DEPRESSED_BG
			emotion_text.texture = Resources.DEPRESSED_TEXT
			defense = defaultDefense * 1.35
			speed = defaultSpeed * 0.65
		"miserable":
			emotion = "miserable"
			emotion_bg.texture = Resources.MISERABLE_BG
			emotion_text.texture = Resources.MISERABLE_TEXT
			defense = defaultDefense * 1.5
			speed = defaultSpeed * 0.5
		"angry":
			emotion = "angry"
			emotion_bg.texture = Resources.ANGRY_BG
			emotion_text.texture = Resources.ANGRY_TEXT
			attack = defaultAttack * 1.3
			defense = defaultDefense * 0.5
		"enraged":
			emotion = "enraged"
			emotion_bg.texture = Resources.ENRAGED_BG
			emotion_text.texture = Resources.ENRAGED_TEXT
			attack = defaultAttack * 1.5
			defense = defaultDefense * 0.3
		"furious":
			emotion = "furious"
			emotion_bg.texture = Resources.FURIOUS_BG
			emotion_text.texture = Resources.FURIOUS_TEXT
			attack = defaultAttack * 2
			defense = defaultDefense * 0.15
		"afraid":
			emotion = "afraid"
			emotion_bg.texture = Resources.AFRAID_BG
			emotion_text.texture = Resources.AFRAID_TEXT
		"stressed_out":
			emotion = "stressed_out"
			emotion_bg.texture = Resources.STRESSED_OUT_BG
			emotion_text.texture = Resources.STRESSED_OUT_TEXT
	animated_face.play(emotion + "_" + currentPlayer())
	unbuffedAttack = attack
	unbuffedDefense = defense
	unbuffedSpeed = speed
	updateBuffs()
