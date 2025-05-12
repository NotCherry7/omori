class_name Follower extends CharacterBody2D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@export var leader: CharacterBody2D
@export var delay_frames: int
@export var hasLeader: bool = false

var moving: bool = false

var move_direction: String = "down"
var target_position

@export var playName: String = "Brenna"


func _ready() -> void:
	if hasLeader:
		position = leader.position.snapped(Vector2.ONE * ConstantValues.tile_size)
		animation.speed_scale = leader.move_speed / 5
	else:
		position = position.snapped(Vector2.ONE * ConstantValues.tile_size)
		
	position += Vector2.ONE * ConstantValues.tile_size/2
	

func move():
	if !MainInfo.cut_scene_active:
		playAnimations()
		var cur_speed = leader.move_speed
		if leader.sprinting:
			cur_speed = cur_speed * 2
		moving = true
		var tween = create_tween()
		tween.tween_property(self, "position", target_position, 1.0/cur_speed)
		await tween.finished
		moving = false

func playAnimations():
	if !leader.sprinting && animation.current_animation.begins_with("sprint_"):
		pass
	#elif (animation.current_animation.ends_with(move_direction) && !leader.sprinting): return
	if leader.sprinting:
		animation.play("sprint_" + move_direction)
	else:
		animation.play("walk_" + move_direction)

func checkAnimations():
	if !MainInfo.cut_scene_active:
		if !leader.moving: animation.play("idle_" + str(move_direction))
