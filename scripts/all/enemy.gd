extends CharacterBody2D

@export var cell_size = Vector2i(32, 32)
@export var speed: float = 100.0  # Movement speed
@export var follow_area: Area2D  # The area to trigger follow behavior
@export var original_position: Vector2  # Save the original position

var astar_grid = AStarGrid2D.new()
var grid_size
var player

var start = Vector2i.ZERO
var end = Vector2i(5, 5)

var path: PackedVector2Array = []
var path_index = 0
var player_in_area = false  # To track if player is in range

func _ready():
	initialize_grid()
	update_path()
	original_position = global_position  # Save the original position of the enemy

func initialize_grid():
	grid_size = Vector2i(Vector2i(10000, 10000)) / cell_size
	astar_grid.size = grid_size
	astar_grid.cell_size = cell_size
	astar_grid.offset = cell_size / 2
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()

func update_path():
	if player_in_area:
		end = Vector2i(player.global_position.x, player.global_position.y)
	else:
		end = Vector2i(original_position.x, original_position.y)

	path = astar_grid.get_point_path(start, end)
	path_index = 0

func draw_grid():
	for x in range(grid_size.x + 1):
		draw_line(Vector2(x * cell_size.x, 0), Vector2(x * cell_size.x, grid_size.y * cell_size.y), Color.DARK_GRAY, 2.0)
	for y in range(grid_size.y + 1):
		draw_line(Vector2(0, y * cell_size.y), Vector2(grid_size.x * cell_size.x, y * cell_size.y), Color.DARK_GRAY, 2.0)


func _draw() -> void:
	draw_grid()

func _process(delta):
	if player_in_area:
		move_along_path(delta)
	elif !player_in_area and position != original_position:
		move_along_path(delta)

func move_along_path(delta):
	if path.is_empty() or path_index >= path.size():
		return

	var target_position = path[path_index]
	var direction = (target_position - position).normalized()
	var distance = position.distance_to(target_position)

	# Move towards the next point
	if distance > speed * delta:
		position += direction * speed * delta
	else:
		position = target_position  # Snap to point
		path_index += 1  # Move to the next point in the path

func _on_player_entered_area(body):
	if body.has_method("player"):
		player = body
		player_in_area = true
		update_path()

func _on_player_left_area(body):
	if body.has_method("player"):  # Ensure it's the player that left
		player_in_area = false
		update_path()

# Collision detection with player
func _on_collision(body):
	if body.has_method("player"):
		BattleScene.startBattle([])
