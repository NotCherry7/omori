extends Node2D

@export var playerName: String = "Lukathy"
@export var level: int
@export var maxHealth: int
@export var health: int
@export var maxJuice: int
@export var juice: int
@export var attack: int
@export var defense: int
@export var speed: int
@export var luck: int
@export var hitRate: int
@export var xp: float

@onready var level_bar: TextureRect = $Frame/Level/LevelBar
@onready var name_label: Label = $Frame/Name
@onready var level_label: Label = $Frame/Level
@onready var health_label: Label = $Frame/healthBar/Label
@onready var juice_label: Label = $Frame/juiceBar/Label
@onready var juice_bar: TextureProgressBar = $Frame/juiceBar
@onready var face: AnimatedSprite2D = $Frame/Face


@onready var select_frame = $Select
@onready var tag_select: TextureRect = $TagSelect

@onready var health_bar: TextureProgressBar = $Frame/healthBar

const MAX_WIDTH: float = 148.0  # Maximum width

@export var level_xp: float = 1.0 :
	set(value):
		level_xp = clamp(value, 0.0, 1.0)
		update_level()

func _ready():
	update_stats()
	update_name()
	update_level()
	update_health()

func update_stats():
	var stats
	if MainInfo.current_world == "Dreamworld":
		if playerName == "Lukathy": stats = MainInfo.LukeStats
		elif playerName == "Brenna": stats = MainInfo.BrennaStats
		else: return
	else:
		if playerName == "Lukathy": stats = MainInfo.FALukeStats
		elif playerName == "Brenna": stats = MainInfo.FABrennaStats
		else: return
	var weapon = SkillsItemsWeapons.weapons.get(stats.get("weapon"))
	var charm = SkillsItemsWeapons.charms.get(stats.get("charm"))
	level = stats.get("level")
	xp = stats.get("xp")
	health = stats.get("currentHeart")
	juice = stats.get("currentJuice")
	maxHealth = stats.get("maxHeart") + (weapon.get("health", 0) if weapon else 0) + (charm.get("health", 0) if charm else 0)
	maxJuice = stats.get("maxJuice") + (weapon.get("juice", 0) if weapon else 0) + (charm.get("juice", 0) if charm else 0)
	attack = stats.get("attack") + (weapon.get("attack", 0) if weapon else 0) + (charm.get("attack", 0) if charm else 0)
	defense = stats.get("defense") + (weapon.get("defense", 0) if weapon else 0) + (charm.get("defense", 0) if charm else 0)
	speed = stats.get("speed") + (weapon.get("speed", 0) if weapon else 0) + (charm.get("speed", 0) if charm else 0)
	luck = stats.get("luck") + (weapon.get("luck", 0) if weapon else 0) + (charm.get("luck", 0) if charm else 0)
	hitRate = (weapon.get("hitRate") if weapon else stats.get("hitRate", 0)) + (charm.get("hitRate", 0) if charm else 0)


#func update_stats():
	#match playerName:
		#"Luke":
			#level = MainInfo.LukeStats.get("level")
			#maxHealth = MainInfo.LukeStats.get("maxHeart")
			#health = MainInfo.LukeStats.get("currentHeart")
			#maxJuice = MainInfo.LukeStats.get("maxJuice")
			#juice = MainInfo.LukeStats.get("currentJuice")
			#attack = MainInfo.LukeStats.get("attack")
			#defense = MainInfo.LukeStats.get("defense")
			#speed = MainInfo.LukeStats.get("speed")
			#luck = MainInfo.LukeStats.get("luck")
			#hitRate = MainInfo.LukeStats.get("hitRate")
			#xp = MainInfo.LukeStats.get("xp")
		#"Brenna":
			#level = MainInfo.BrennaStats.get("level")
			#maxHealth = MainInfo.BrennaStats.get("maxHeart")
			#health = MainInfo.BrennaStats.get("currentHeart")
			#maxJuice = MainInfo.BrennaStats.get("maxJuice")
			#juice = MainInfo.BrennaStats.get("currentJuice")
			#attack = MainInfo.BrennaStats.get("attack")
			#defense = MainInfo.BrennaStats.get("defense")
			#speed = MainInfo.BrennaStats.get("speed")
			#luck = MainInfo.BrennaStats.get("luck")
			#hitRate = MainInfo.BrennaStats.get("hitRate")
			#xp = MainInfo.BrennaStats.get("xp")

func update_name():
	name_label.text = playerName
	match playerName:
		"Lukathy":
			play_face("luke", true)
		"Brenna":
			play_face("brenna", true)

func play_face(person: String, still: bool = false):
	if MainInfo.current_world == "Dreamworld":
		if still:
			face.play(person + "_still")
		else:
			face.play(person)
	else:
		if still:
			face.play("fa_" + person + "_still")
		else:
			face.play("fa_" + person)

func update_level():
	level_label = $Frame/Level
	level_bar = $Frame/Level/LevelBar
	level_label.text = "LVL. " + str(level)
	level_bar.size.x = (xp / (30 + (level - 1) * 100)) * MAX_WIDTH

func applyHealth(value: int):
	var final_health = roundi(value)
	health = clamp(health + final_health, 0, maxHealth)
	update_health()

func applyJuice(value: int):
	var final_juice = roundi(value)
	juice = clamp(juice + final_juice, 0, maxJuice)
	update_health()

func applyHealthJuice(healthValue: int, juiceValue: int):
	var final_health = roundi(healthValue)
	health = clamp(health + final_health, 0, maxHealth)
	var final_juice = roundi(juiceValue)
	juice = clamp(juice + final_juice, 0, maxJuice)
	update_health()

func update_health():
	health_label.text = str(health) + "/" + str(maxHealth)
	juice_label.text = str(juice) + "/" + str(maxJuice)
	
	health_bar.max_value = maxHealth
	health_bar.value = health
	juice_bar.max_value = maxJuice
	juice_bar.value = juice
