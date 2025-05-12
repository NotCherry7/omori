extends Control


@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var leader_tab: TextureRect = $CurrentLeader/LeaderTab
@onready var current_leader: TextureRect = $CurrentLeader
@onready var player: CharacterBody2D = $"../.."
@onready var next_photo: AnimatedSprite2D = $CurrentLeader/NextLeader/Background/NextPhoto
@onready var second_photo: AnimatedSprite2D = $CurrentLeader/Second/Background/SecondPhoto
@onready var current_photo: AnimatedSprite2D = $CurrentLeader/Background/CurrentPhoto
@onready var sfx_buzzer: AudioStreamPlayer = $Buzzer
@onready var menu: Control = $"../Menu"

var tagMenuOpen: bool = false

var leader: String = "Luke"
var leader_number: int = 1

var player1: String = "Luke"
var player2: String = "Brenna"

var ogLeader: String = "Luke"

func _ready() -> void:
	leader = MainInfo.leader

func resume():
	get_tree().paused = false
	animation.play_backwards("open")
	await animation.animation_finished
	visible = false
func pause():
	get_tree().paused = true
	ogLeader = str(leader)
	if leader == "Luke":
		player1 = "Luke"
		player2 = "Brenna"
		if MainInfo.current_world == "Dreamworld":
			current_photo.play("luke")
			next_photo.play("luke")
			second_photo.play("brenna")
		else:
			current_photo.play("fa_luke")
			next_photo.play("fa_luke")
			second_photo.play("fa_brenna")
		leader_number = 1
	if leader == "Brenna":
		player1 = "Brenna"
		player2 = "Luke"
		if MainInfo.current_world == "Dreamworld":
			current_photo.play("brenna")
			next_photo.play("brenna")
			second_photo.play("luke")
		else:
			current_photo.play("fa_brenna")
			next_photo.play("fa_brenna")
			second_photo.play("fa_luke")
		leader_number = 1
	visible = true
	animation.play("open")

func _process(delta: float) -> void:
	if MainInfo.cut_scene_active: return
	if !menu.pauseMenuShown && !player.dialog_menu.is_active:
		if Input.is_action_just_pressed("tag"):
			if MainInfo.followers.is_empty():
				sfx_buzzer.playing = true
				return
			pause()
			tagMenuOpen = true
		if Input.is_action_just_released("tag"):
			if MainInfo.followers.is_empty():
				return
			tagMenuOpen = false
			if leader != ogLeader: tag(leader)
			else: resume()
		if tagMenuOpen:
			if MainInfo.followers.is_empty():
				return
			if !animation.is_playing():
				if Input.is_action_just_pressed("left"):
					thingyidk("left")
				elif Input.is_action_just_pressed("right"):
					thingyidk("right")

func thingyidk(direction: String = "right"):
	if leader_number == 1:
		if direction == "right":
			animation.play("swap")
		else:
			animation.play_backwards("swap_2")
		leader_number = 2
		leader_tab.visible = false
		await animation.animation_finished
		leader_tab.visible = true
		leader = player2
	else:
		if direction == "right":
			animation.play("swap_2")
		else:
			animation.play_backwards("swap")
		leader_number = 1
		leader_tab.visible = false
		await animation.animation_finished
		leader_tab.visible = true
		leader = player1

func tag(player_name: String):
	get_tree().paused = false
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	tween.tween_property(current_leader, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.3)
	tween2.tween_property($ColorRect, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.3)
	var player_num
	var player_num2
	if leader_number == 1:
		player_num = player1
		player_num2 = player2
	elif leader_number == 2:
		player_num = player2
		player_num2 = player1
	MainInfo.leader = player_num
	MainInfo.followers.erase(player_num)
	MainInfo.followers.append(player_num2)
	player.changeSkin()
	await tween.finished
	visible = false
