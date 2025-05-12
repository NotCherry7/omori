extends Control
@export var music: AudioStream
@onready var screen_animation: AnimationPlayer = $ScreenAnimation
@onready var sfx_load: AudioStreamPlayer = $Load
@onready var sfx_dialog: AudioStreamPlayer = $Dialog
@onready var sfx_move: AudioStreamPlayer = $Move
@onready var animation: AnimationPlayer = $AnimationPlayer

@onready var retry_label: Label = $Retry
@onready var cursor: Sprite2D = $Cursor

var currently_loading
var can_choose: bool = false
var currently_selected: int = 0
var markerPos = []

func _ready() -> void:
	AutoplayMusic.stream = music
	AutoplayMusic.playing = true
	animation.play("ready")
	markerPos = [$YesMarker, $NoMarker]
	await animation.animation_finished
	can_choose = true

func _process(delta: float) -> void:
	if !can_choose: return
	if Input.is_action_just_pressed("left") || Input.is_action_just_pressed("right"):
		sfx_move.playing = true
		currently_selected = (currently_selected + 1) % 2
		cursor.global_position = markerPos[currently_selected].global_position
	if Input.is_action_just_pressed("z"):
		match currently_selected:
			0:
				MainInfo.LukeStats = MainInfo.LukeStatsPreBattle
				MainInfo.BrennaStats = MainInfo.BrennaStatsPreBattle
				MainInfo.heldSnacks = MainInfo.heldSnacksPreBattle
				MainInfo.heldToys = MainInfo.heldToysPreBattle
				await play_anim()
				var scene = preload("res://ui/battle/battle_menu.tscn").instantiate()
				var foe_box = scene.get_node("FoeBox")
				for e in MainInfo.lastBattle["enemies"]:
					var enemy = Logic.enemies.get(e)
					var enemy_scene = enemy["scene"].instantiate()
					
					enemy_scene.thisName = enemy["name"]
					enemy_scene.maxHealth = enemy["maxHeart"]
					enemy_scene.health = enemy["maxHeart"]
					enemy_scene.attack = enemy["attack"]
					enemy_scene.defense = enemy["defense"]
					enemy_scene.speed = enemy["speed"]
					
					foe_box.add_child(enemy_scene)
				scene.background_texture = MainInfo.lastBattle["bg"]
				scene.music = MainInfo.lastBattle["music"]

				get_tree().root.add_child(scene)
				get_tree().current_scene.queue_free()
				get_tree().current_scene = scene
			1:
				await play_anim()
				get_tree().change_scene_to_file("res://ui/title/title_screen.tscn")

func play_anim():
	currently_loading = true
	sfx_load.playing = true
	screen_animation.play("fade")
	await screen_animation.animation_finished

func show_text():
	for i in range(retry_label.text.length() + 1):
		retry_label.visible_characters += 1
		sfx_dialog.pitch_scale = randf_range(0.85, 1.15)
		sfx_dialog.playing = true
		await get_tree().create_timer(0.1).timeout
