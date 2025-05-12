extends CharacterBody2D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@export var leader: CharacterBody2D
@export var delay_frames: int
@export var hasLeader: bool = false

@export var tileName: String = "Watermelon"
@export var dialog_root: Dictionary = Dialog.nathan_messages
@export var dialog: Dictionary
var interacted: bool = false

var moving: bool = false
@onready var collision: CollisionShape2D = $StaticBody2D/CollisionShape2D

var move_direction: String = "down"
var target_position

@export var playName: String = "Brenna"


func _ready() -> void:
	dialog = Dialog.nathan_messages.get("message_" + str(Dialog.nathan_current_message))
	if hasLeader:
		position = leader.position.snapped(Vector2.ONE * ConstantValues.tile_size)
		animation.speed_scale = leader.move_speed / 5
		call_deferred("disableCollision")
	else:
		pass
		#position = position.snapped(Vector2.ONE * ConstantValues.tile_size)
		
	#position += Vector2.ONE * ConstantValues.tile_size/2
	
func disableCollision():
	collision.disabled = true

func move():
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
	if !leader.moving: animation.play("idle_" + str(move_direction))

func interact(player):
	dialog = Dialog.nathan_messages.get("message_" + str(Dialog.nathan_current_message))
	var opposite = opposite_direction(player.move_direction)
	animation.play("idle_" + opposite)
	player.play_dialog(dialog_root, dialog, null, self)

func face_originalDir():
	animation.play("idle_" + move_direction)

func opposite_direction(dir: String):
	if dir == "down":
		return "up"
	elif dir == "up":
		return "down"
	elif dir == "left":
		return "right"
	elif dir == "right":
		return "left"

func finished_dialog():
	animation.play("idle_down")
	match Dialog.nathan_current_message:
		0:
			Dialog.nathan_current_message = 1
		1:
			Dialog.nathan_current_message = 1
		2:
			Dialog.nathan_current_message = 3
