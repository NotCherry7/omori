extends Control

var foe_type: String = "Chunion"
var thisName: String = "Chunion"
var health: int = 70
var maxHealth: int = 70
var juice: int = 25
var maxJuice: int = 25
var attack: float = 5
var defense: float = 1
var speed: float = 2
var luck: float = 1
var hitRate: float = 1
var emotion: String = "neutral"
var isAlive: bool = true

var target
var skill: String = "Attack"
@export var skills = {
	"Attack": {
		"neutral": 0.55,
		"happy": 0.35,
		"sad": 0.2,
		"angry": 0.6 
	}, "Do Nothing": {
		"neutral": 0.4,
		"happy": 0.3,
		"sad": 0.55,
		"angry": 0.2 
	}, "Be Cute": {
		"neutral": 1,
		"happy": 1,
		"sad": 0,
		"angry": 1 
	}, "Sad Eyes": {
		"neutral": 0,
		"happy": 0,
		"sad": 1,
		"angry": 0 
	}
}

@onready var sprite_animation: AnimationPlayer = $SpriteAnimation

var unbuffedAttack: int
var unbuffedDefense: int
var unbuffedSpeed: int

var attack_buff: int = 0 #negatives = debuff
var defense_buff: int = 0
var speed_buff: int = 0 
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

@onready var sprite: Sprite2D = $Sprite

@onready var hurt_animation: AnimationPlayer = $HurtAnimations
@onready var health_bar: TextureProgressBar = $Frame/HealthBar
@onready var first_text_hbox: HBoxContainer = $TopTextBox
@onready var second_text_hbox: HBoxContainer = $BottomTextBox
@onready var attack_sfx: AudioStreamPlayer = $AttackSFX

@onready var hp_frame: TextureRect = $Frame
@onready var foe_name: Label = $Frame/Name

var sadTypes = ["sad", "depressed", "miserable"]
var angryTypes = ["angry", "enraged", "furious"]
var happyTypes = ["happy", "ecstatic", "manic"]

const text_scene = preload("res://ui/battle/damage_text.tscn")
const miss_text_scene = preload("res://ui/battle/miss_text.tscn")

const DAMAGE = preload("res://assets/ui/numbers/damage.png")
const HEAL = preload("res://assets/ui/numbers/heal.png")
const GAIN_JUICE = preload("res://assets/ui/numbers/gainJuice.png")
const LOSE_JUICE = preload("res://assets/ui/numbers/loseJuice.png")

var defaultAttack: int
var defaultDefense: int
var defaultSpeed: int
var defaultLuck: int
var defaultHitRate: int

var lastDamageTaken: int = 0
var lastJuiceLost: int = 0

# REWARDS
@export var max_emotion_level: int = 1

@export var experience: int = 500
@export var chips: int = 4
@export var item: String = ""
@export var item_chance: float = 0.1


@onready var attackAnimations: CenterContainer = $Attack
var attackAnimation

func update_default_stats():
	defaultAttack = attack
	defaultDefense = defense
	defaultSpeed = speed
	defaultLuck = luck
	defaultHitRate = hitRate

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

func hurt():
	var mat = get_material()
	if mat.resource_local_to_scene == false:
		mat = mat.duplicate()
		mat.resource_local_to_scene = true
		set_material(mat)
	mat.set_shader_parameter("enable_effects", true)
	await get_tree().create_timer(1.0).timeout
	if !hurt_animation.is_playing():
		mat.set_shader_parameter("enable_effects", false)

func _ready() -> void:
	attackAnimation = attackAnimations.animations
	foe_name.text = thisName.to_upper()
	update_default_stats()
	updateHealth()
	applyEmotion("neutral")

func chooseSkill():
	for skill_name in skills.keys():
		var chance = skills[skill_name].get(emotion, 0)
		if randf() < chance:
			skill = skill_name
			return skill

func applyHealth(value: int):
	var final_health = roundi(value)
	health = clamp(health + roundi(value), 0, maxHealth)
	updateHealth()
	
	for child in first_text_hbox.get_children():
		child.queue_free()
	for child in second_text_hbox.get_children():
		child.queue_free()

	if final_health > 0:
		displayDamageText("heal", final_health, 1)

func applyDamage(value: int, withDefense: bool):
	if health <= 0:
		isAlive = false
		return
	var final_damage = max(roundi(value), 0)
	final_damage = roundi(final_damage)
	
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

func die():
	var mat = get_material()
	mat.set_shader_parameter("enable_effects", true)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector2(global_position.x, global_position.y + 480), 1.0)

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

func updateHealth():
	health_bar.max_value = maxHealth
	health_bar.value = health

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
			
		"happy":
			emotion = "happy"
			hitRate = defaultHitRate * 0.9
			luck = defaultLuck * 2
			speed = defaultSpeed * 1.25
		"ecstatic":
			emotion = "ecstatic"
			hitRate = defaultHitRate * 0.8
			luck = defaultLuck * 3
			speed = defaultSpeed * 1.5
		"manic":
			emotion = "manic"
			hitRate = defaultHitRate * 0.7
			luck = defaultLuck * 4
			speed = defaultSpeed * 2
		"sad":
			emotion = "sad"
			defense = defaultDefense * 1.25
			speed = defaultSpeed * 0.8
		"depressed":
			emotion = "depressed"
			defense = defaultDefense * 1.35
			speed = defaultSpeed * 0.65
		"miserable":
			emotion = "miserable"
			defense = defaultDefense * 1.5
			speed = defaultSpeed * 0.5
		"angry":
			emotion = "angry"
			attack = defaultAttack * 1.3
			defense = defaultDefense * 0.5
		"enraged":
			emotion = "enraged"
			attack = defaultAttack * 1.5
			defense = defaultDefense * 0.3
		"furious":
			emotion = "furious"
			attack = defaultAttack * 2
			defense = defaultDefense * 0.15
		"afraid":
			emotion = "afraid"
		"stressed_out":
			emotion = "stressed_out"
	unbuffedAttack = attack
	unbuffedDefense = defense
	unbuffedSpeed = speed
	updateBuffs()
	if sprite_animation.has_animation(emotion):
		sprite_animation.play(emotion)
