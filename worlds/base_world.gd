extends Node2D

@onready var start_pos: Marker2D = $StartPos

@export var music: AudioStream
#@onready var player: CharacterBody2D = $"y-sort/Player"
#@onready var luke: CharacterBody2D = $"y-sort/Player"
@onready var ground_tilemap: TileMapLayer = $Ground
@onready var camera: Camera2D = $Camera2D
#@onready var brenna: Follower = $"y-sort/Brenna"
@onready var y_sort: Node2D = $"y-sort"

var player

var luke
var brenna


# LINKS
@onready var links = $Links.get_children()
const FA_LUKE = preload("res://characters/luke (player)/fa_player.tscn")
const FA_BRENNA = preload("res://characters/brenna/fa_brenna.tscn")

const LUKE = preload("res://characters/luke (player)/player.tscn")
const BRENNA = preload("res://characters/brenna/brenna.tscn")
const CAMERA = preload("res://characters/camera.tscn")
@onready var glitch: ColorRect = $CanvasLayer/Glitch

@export var area = "forest"

var shake_strength = 0.0
var shake_decay = 5.0
var shake_max_offset = Vector2(8, 8)
var shake_duration = 0.0
var shake_timer = 0.0


func _ready() -> void:
	var gmat = glitch.get_material().duplicate()
	glitch.set_material(gmat)
	gmat.set_shader_parameter("enable_effects", false)
	var luke_node
	if MainInfo.current_world == "Dreamworld":
		luke_node = LUKE.instantiate()
	else:
		luke_node = FA_LUKE.instantiate()
	y_sort.add_child(luke_node)
	luke = y_sort.get_node("Player")
	player = luke
	attach_camera()
	if !MainInfo.followers.has("Brenna") && !MainInfo.leader == "Brenna":
		brenna = null
	else:
		var brenna_node
		if MainInfo.current_world == "Dreamworld":
			brenna_node = BRENNA.instantiate()
		else:
			brenna_node = FA_BRENNA.instantiate()
		brenna_node.leader = luke
		brenna_node.hasLeader = true
		player.followers.append(brenna_node)
		y_sort.add_child(brenna_node)
		brenna = y_sort.get_node("Brenna")
		brenna.position = luke.position
	if MainInfo.previous_scene == -2:
		if MainInfo.last_player_location:
			player.global_position = MainInfo.last_player_location
			player.animation.play("idle_" + MainInfo.last_player_direction.to_lower())
			var i: int = 0
			for f in player.followers:
				if MainInfo.pos_history.size() > i:
					f.position = MainInfo.pos_history[i]
					f.move_direction = MainInfo.dir_history[i+1]
					f.animation.play("idle_" + MainInfo.dir_history[i+1].to_lower())
				else:
					f.global_position = MainInfo.last_player_location
					f.animation.play("idle_" + MainInfo.last_player_direction.to_lower())
				i += 1
		else:
			player.global_position = start_pos.global_position
			for f in player.followers:
				f.global_position = start_pos.global_position
		if MainInfo.enemyEncountered:
			var enemy = get_node(MainInfo.enemyEncountered)
			enemy.finished_battle()
			MainInfo.enemyEncountered = null
	
	MainInfo.last_scene_path = get_tree().current_scene.scene_file_path
	MainInfo.location = area
	
	if MainInfo.leader == "Luke":
		if MainInfo.current_world == "Dreamworld":
			luke.sprite.texture = Resources.LUKE_SPRITE
			if brenna:
				brenna.sprite.texture = Resources.BRENNA_SPRITE
		else:
			luke.sprite.texture = Resources.FA_LUKE_SPRITE
			if brenna:
				brenna.sprite.texture = Resources.FA_BRENNA_SPRITE
	elif MainInfo.leader == "Brenna":
		if MainInfo.current_world == "Dreamworld":
			luke.sprite.texture = Resources.BRENNA_SPRITE
			if brenna:
				brenna.sprite.texture = Resources.LUKE_SPRITE
		else:
			luke.sprite.texture = Resources.FA_BRENNA_SPRITE
			if brenna:
				brenna.sprite.texture = Resources.FA_LUKE_SPRITE
	
	var link
	for lnk in links:
		if lnk.link_digit == MainInfo.previous_scene:
			link = lnk
	if link:
		player.global_position = link.global_position
		for f in player.followers:
			f.global_position = link.global_position
		player.allFace(link.direction)
	AutoplayMusic.checkMusic(music)
	if ground_tilemap and ground_tilemap.tile_set:
		var cell_size = ground_tilemap.tile_set.tile_size
		var used_rect = ground_tilemap.get_used_rect()

		var rect_position = Vector2(ground_tilemap.global_position) + Vector2(used_rect.position) * Vector2(cell_size)
		var rect_size = used_rect.size * cell_size

		camera.limit_left = rect_position.x
		camera.limit_top = rect_position.y
		camera.limit_right = rect_position.x + rect_size.x
		camera.limit_bottom = rect_position.y + rect_size.y

func shake(strength = 1.0):
	shake_strength = strength
	shake_duration = strength * 0.5
	shake_timer = shake_duration

func _process(delta):
	if shake_timer > 0:
		camera.offset = Vector2(
			randf_range(-shake_max_offset.x, shake_max_offset.x),
			randf_range(-shake_max_offset.y, shake_max_offset.y)
		) * shake_strength
		shake_strength = move_toward(shake_strength, 0, shake_decay * delta)
		shake_timer -= delta
		if shake_timer <= 0:
			camera.offset = Vector2.ZERO
			shake_strength = 0.0

func detach_camera():
	if player.get_node("Camera2D"):
		player.remove_child(camera)
	add_child(camera)
	camera.global_position = player.global_position

func attach_camera():
	if get_node("Camera2D"):
		remove_child(camera)
	player.add_child(camera)
	camera.global_position = player.global_position

func begin_cutscene(withFadeIn: bool = true):
	if withFadeIn:
		player.screen_animation.play("fade")
		await player.screen_animation.animation_finished
	detach_camera()
	luke.visible = false
	if brenna:
		brenna.visible = false
	player.screen_animation.play_backwards("fade")

func end_cutscene():
	player.screen_animation.play("fade")
	await player.screen_animation.animation_finished
	player.screen_animation.play_backwards("fade")

func add_brenna():
	var brenna_node
	if MainInfo.current_world == "Dreamworld":
		brenna_node = BRENNA.instantiate()
	else:
		brenna_node = FA_BRENNA.instantiate()
	brenna_node.leader = luke
	brenna_node.hasLeader = true
	brenna_node.visible = false
	player.followers.append(brenna_node)
	MainInfo.followers = ["Brenna"]
	y_sort.add_child(brenna_node)
	brenna = y_sort.get_node("Brenna")
	brenna.position = Vector2(luke.position.x, luke.position.y + 32)
	brenna.animation.play("idle_up")
