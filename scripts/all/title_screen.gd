extends Control


@onready var new_game_cursor: Marker2D = $MarginContainer/NewGameCursor
@onready var continue_cursor: Marker2D = $MarginContainer2/ContinueCursor
@onready var options_cursor: Marker2D = $MarginContainer3/OptionsCursor

@onready var sfx_select: AudioStreamPlayer = $Select
@onready var sfx_move: AudioStreamPlayer = $Move

@onready var cursor: Sprite2D = $Cursor
@onready var move_cursor_timer: Timer = $MoveCursorTimer

@export var music: AudioStream

const total_buttons: int = 3
var currently_selected: int = 0
var selected_button: String = "new_game"

var lastPressedKey: String = "null"

func _ready() -> void:
	get_tree().paused = false
	AutoplayMusic.checkMusic(music)
	updateCursor()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("right"):
		move_right()
		var timer = get_tree().create_timer(0.3)
		await timer.timeout
		move_cursor_timer.stop()
		move_cursor_timer.start()
		lastPressedKey = "right"
	if Input.is_action_just_pressed("left"):
		move_left()
		var timer = get_tree().create_timer(0.3)
		await timer.timeout
		move_cursor_timer.stop()
		move_cursor_timer.start()
		lastPressedKey = "left"
	if Input.is_action_just_pressed("z"):
		sfx_select.playing = true
		await sfx_select.finished
		match selected_button:
			"new_game":
				_new_game_pressed()
			"continue":
				_continue_pressed()
			"options":
				_options_pressed()

func move_right():
	currently_selected = (currently_selected + 1) % total_buttons
	updateCursor()
	sfx_move.playing = true

func move_left():
	currently_selected = (currently_selected - 1 + total_buttons) % total_buttons
	updateCursor()
	sfx_move.playing = true

func _new_game_pressed():
	if get_tree():
		#get_tree().change_scene_to_file("res://worlds/forest/forest.tscn")
		MainInfo.previous_scene = -1
		MainInfo.newGame = true
		#get_tree().change_scene_to_file("res://worlds/base_world.tscn")
		get_tree().change_scene_to_file("res://ui/saveScreen/save_load_screen.tscn")

func _continue_pressed():
	if get_tree():
		MainInfo.canSave = false
		MainInfo.previous_scene = -2
		get_tree().change_scene_to_file("res://ui/saveScreen/save_load_screen.tscn")
	
func _options_pressed():
	if get_tree():
		get_tree().quit()
		#get_tree().change_scene_to_file("res://ui/battle/battle_menu.tscn")

func updateCursor():
	match currently_selected:
		0:
			cursor.position = new_game_cursor.global_position
			selected_button = "new_game"
		1:
			cursor.position = continue_cursor.global_position
			selected_button = "continue"
		2:
			cursor.position = options_cursor.global_position
			selected_button = "options"


func _on_move_cursor_timer_timeout() -> void:
	if lastPressedKey == "left":
		if Input.is_action_pressed("left"):
			move_left()
		else:
			move_cursor_timer.stop()
	if lastPressedKey == "right":
		if Input.is_action_pressed("right"):
			move_right()
		else:
			move_cursor_timer.stop()
