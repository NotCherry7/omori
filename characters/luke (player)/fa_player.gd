extends CharacterBody2D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var ray = $RayCast2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var dialog_menu: Control = $CanvasLayer/Dialog
@onready var sfx_heal: AudioStreamPlayer = $heal
@onready var sfx_healbubbles: AudioStreamPlayer = $healbubbles
@onready var sfx_munch: AudioStreamPlayer = $munch
@onready var sfx_encounter: AudioStreamPlayer = $encounter

@onready var tag_photo: ColorRect = $CanvasLayer/TagPhoto
@onready var tag_animation: AnimationPlayer = $TagAnimation
@onready var battle_animation: AnimationPlayer = $BattleAnimation

var input_dir
var moving
var sprinting
var move_speed: float = 5
var move_direction: String = "down"
var dominant_direction
var currentMenuShown: int = 1

var facingTile

var canMove: bool = true
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

@onready var menu: Control = $CanvasLayer/Menu
@onready var screen_animation: AnimationPlayer = $ScreenAnimation

var leader: String = "Luke"
@export var followers: Array[CharacterBody2D] = []

signal stopped_moving

var queue_menu: bool = false
var entering_battle: bool = false

var position_history = []
var direction_history = []
const MAX_HISTORY = 10

func player():
	pass

func _ready() -> void:
	color_rect.visible = true
	leader = MainInfo.leader
	changeSkin(false)
	if !MainInfo.enemyEncountered:
		screen_animation.play_backwards("fade")
	animation.speed_scale = move_speed / 5
	position = position.snapped(Vector2.ONE * ConstantValues.tile_size)
	position += Vector2.ONE * ConstantValues.tile_size/2
	#var i = 1
	#for f in followers:
		#f.position.y += ConstantValues.tile_size * (i)
		#i += 1

func _process(delta: float) -> void:
	if MainInfo.cut_scene_active: return
	if Input.is_action_just_pressed("z"):
		if !menu.pauseMenuShown:
			if !dialog_menu.is_active:
				facingTile = ray.get_collider().get_parent() if ray.get_collider() else null
				if facingTile != null:
					if facingTile.has_method("interact"):
						if !facingTile.interacted:
							facingTile.interact(self)

func enter_battle(attacker, enemies: Array, bg: Texture2D, music: AudioStream = null):
	$CanvasLayer/BattleOverlay.visible = true
	MainInfo.enemyEncountered = attacker
	MainInfo.pos_history = position_history
	MainInfo.dir_history = direction_history
	MainInfo.last_player_direction = move_direction
	sfx_encounter.playing = true
	AutoplayMusic.fade_out()
	battle_animation.play("show")
	entering_battle = true
	await battle_animation.animation_finished
	MainInfo.previous_scene = -2
	MainInfo.last_player_location = global_position
	MainInfo.lastBattle["enemies"] = enemies
	MainInfo.lastBattle["bg"] = bg
	MainInfo.lastBattle["music"] = music
	var scene = preload("res://ui/battle/battle_menu.tscn").instantiate()
	var foe_box = scene.get_node("FoeBox")
	for e in enemies:
		var enemy = Logic.enemies.get(e)
		var enemy_scene = enemy["scene"].instantiate()
		
		enemy_scene.thisName = enemy["name"]
		enemy_scene.maxHealth = enemy["maxHeart"]
		enemy_scene.health = enemy["maxHeart"]
		enemy_scene.attack = enemy["attack"]
		enemy_scene.defense = enemy["defense"]
		enemy_scene.speed = enemy["speed"]
		
		foe_box.add_child(enemy_scene)
	scene.background_texture = bg
	scene.music = music

	entering_battle = false
	get_tree().root.add_child(scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = scene

func find(type: String, item_name: String):
	match type:
		"snack", "Snack":
			if MainInfo.heldSnacks.has(item_name):
				MainInfo.heldSnacks[item_name]["hold"] += 1
			else:
				MainInfo.heldSnacks[item_name] = {"hold": 1}
		"charm", "Charm":
			if !MainInfo.heldCharms.has(item_name):
				MainInfo.heldCharms.append(item_name)
		"weapon", "Weapon":
			if !MainInfo.heldWeapons.has(item_name):
				MainInfo.heldWeapons.append(item_name)
		"toy", "Toy":
			if MainInfo.heldToys.has(item_name):
				MainInfo.heldToys[item_name]["hold"] += 1
			else:
				MainInfo.heldToys[item_name] = {"hold": 1}
		"item", "Item":
			if MainInfo.heldItems.has(item_name):
				MainInfo.heldItems[item_name]["hold"] += 1
			else:
				MainInfo.heldItems[item_name] = {"hold": 1}

func play_dialog(dialog_root: Dictionary, dialog_start: Dictionary, sfx = null, sender = null):
	dialog_menu.play_dialog(dialog_root, dialog_start, sfx, sender)

func changeSkin(withTagPhoto: bool = true):
	if MainInfo.cut_scene_active: return
	if followers.is_empty():
		return
	if withTagPhoto:
		tag_animation.play("tag")
		await get_tree().create_timer(0.6).timeout
	match MainInfo.leader:
		"Luke":
			#tag_photo.texture = Resources.LUKE_TAG_BRENNA
			sprite.texture = Resources.FA_LUKE_SPRITE
			for follow in followers:
				follow.sprite.texture = Resources.FA_BRENNA_SPRITE
		"Brenna":
			#tag_photo.texture = Resources.BRENNA_TAG_LUKE
			sprite.texture = Resources.FA_BRENNA_SPRITE
			for follow in followers:
				follow.sprite.texture = Resources.FA_LUKE_SPRITE

func allFace(dir: String):
	if MainInfo.cut_scene_active: return
	move_direction = dir.to_lower()
	animation.play("idle_" + dir.to_lower())
	for f in followers:
		f.move_direction = dir.to_lower()
		f.animation.play("idle_" + dir.to_lower())

func restore_health():
	canMove = false
	screen_animation.play("fade_white")
	AutoplayMusic.fade_out()
	await screen_animation.animation_finished
	for i in range(3):
		sfx_munch.playing = true
		await get_tree().create_timer(0.3).timeout
	MainInfo.LukeStats["currentHeart"] = MainInfo.LukeStats["maxHeart"]
	MainInfo.BrennaStats["currentHeart"] = MainInfo.BrennaStats["maxHeart"]
	MainInfo.LukeStats["currentJuice"] = MainInfo.LukeStats["maxJuice"]
	MainInfo.BrennaStats["currentJuice"] = MainInfo.BrennaStats["maxJuice"]
	sfx_heal.playing = true
	await sfx_heal.finished
	sfx_healbubbles.playing = true
	await get_tree().create_timer(0.2).timeout
	sfx_healbubbles.playing = true
	var dialog_root: Dictionary = Dialog.common_messages
	var dialog: Dictionary = Dialog.common_messages.get("renewed").duplicate(true)
	dialog_menu.play_dialog(dialog_root, dialog, null, self)

func finished_dialog():
	screen_animation.play_backwards("fade_white")
	AutoplayMusic.fade_in()
	canMove = true

func _physics_process(delta: float) -> void:
	if MainInfo.cut_scene_active: return
	if !canMove: return
	sprinting = false
	
	input_dir = Vector2.ZERO
	if Input.is_action_just_pressed("up"):
		input_dir = Vector2(0,-1)
		move_direction = "up"
		dominant_direction = move_direction
	if Input.is_action_just_pressed("down"):
		input_dir = Vector2(0,1)
		move_direction = "down"
		dominant_direction = move_direction
	if Input.is_action_just_pressed("right"):
		input_dir = Vector2(1,0)
		move_direction = "right"
		dominant_direction = move_direction
	if Input.is_action_just_pressed("left"):
		input_dir = Vector2(-1,0)
		move_direction = "left"
		dominant_direction = move_direction
	if dominant_direction:
		if Input.is_action_just_released(dominant_direction):
			dominant_direction = null
	
	if Input.is_action_pressed("down") && (dominant_direction == "down" || !dominant_direction):
		input_dir = Vector2(0,1)
		move_direction = "down"
		dominant_direction = move_direction
	if Input.is_action_pressed("right") && (dominant_direction == "right" || !dominant_direction):
		input_dir = Vector2(1,0)
		move_direction = "right"
		dominant_direction = move_direction
	if Input.is_action_pressed("left") && (dominant_direction == "left" || !dominant_direction):
		input_dir = Vector2(-1,0)
		move_direction = "left"
		dominant_direction = move_direction
	if Input.is_action_pressed("up") && (dominant_direction == "up" || !dominant_direction):
		input_dir = Vector2(0,-1)
		move_direction = "up"
		dominant_direction = move_direction


	if input_dir:
		move()
	for f in followers:
		f.checkAnimations()
	checkAnimations()

func move():
	if MainInfo.cut_scene_active: return
	if input_dir:
		if !moving:
			ray.target_position = input_dir * ConstantValues.tile_size
			ray.force_raycast_update()
			if !ray.is_colliding():
				moving = true
				playAnimations()
				var cur_speed = move_speed
				if sprinting:
					cur_speed = cur_speed * 2
					
				position_history.insert(0, position)
				if position_history.size() > MAX_HISTORY:
					position_history.pop_back()
				direction_history.insert(0, move_direction)
				if direction_history.size() > MAX_HISTORY:
					direction_history.pop_back()
					
				var i = 0
				for follower in followers:
					follower.delay_frames = i
					if direction_history.size() - 1 >= follower.delay_frames:
						if direction_history.size() - 2 >= follower.delay_frames:
							follower.move_direction = direction_history[i+1]
						follower.target_position = position_history[i]
						follower.move()
						follower.animation.seek(animation.current_animation_position, true)
					i += 1
				var tween = create_tween()
				tween.tween_property(self, "position", position + input_dir*ConstantValues.tile_size, 1.0/cur_speed)
				#tween.tween_callback(move_false)
				await tween.finished
				MainInfo.last_player_location = global_position
				MainInfo.pos_history = position_history
				MainInfo.dir_history = direction_history
				move_false()
			else:
				var collider = ray.get_collider().get_parent()
				if collider.has_method("transport_tile"):
					collider.changeScene(self)

func playAnimations():
	if MainInfo.cut_scene_active: return
	if !sprinting && animation.current_animation.begins_with("sprint_"):
		pass
	#elif (animation.current_animation.ends_with(move_direction) && !sprinting): 
	#else:
		#return
	if moving:
		if sprinting:
			animation.play("sprint_" + move_direction)
		else:
			animation.play("walk_" + move_direction)

func checkAnimations():
	if MainInfo.cut_scene_active: return
	if !moving:
		animation.play("idle_" + move_direction)
		await animation.animation_finished

func move_false():
	moving = false
	if queue_menu:
		canMove = false
		await checkAnimations()
		canMove = true
		queue_menu = false
		menu.open_menu()
	else:
		stopped_moving.emit()
