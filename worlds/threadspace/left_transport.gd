extends Node


@export var room_width: float = 1024.0
@export var room_height: float = 768.0

var player
var brenna

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	player = get_parent().luke
	if get_parent().brenna:
		brenna = get_parent().brenna

func checkPos(player_last_direction: Vector2):
	var pos = player.global_position
	var changed = false

	# Horizontal wrapping
	if pos.x > room_width:
		pos.x -= room_width
		changed = true
	elif pos.x < 0:
		pos.x += room_width
		changed = true

	# Vertical wrapping
	if pos.y > room_height:
		pos.y -= room_height
		changed = true
	elif pos.y < 0:
		pos.y += room_height
		changed = true

	if changed:
		player.global_position = pos

		if brenna:
			# Place brenna 1 tile (32px) behind the player based on their last movement
			var offset = -player_last_direction.normalized() * 32
			brenna.global_position = player.global_position + offset
