extends Control

@onready var save_load_cursor: Sprite2D = $SaveLoadCursor
@onready var file_cursor: Sprite2D = $FileCursor

@onready var save_cursor_point: Marker2D = $SaveOrLoad/Save/saveCursor
@onready var load_cursor_point: Marker2D = $SaveOrLoad/Load/loadCursor

@onready var save_label: Label = $SaveOrLoad/Save
@onready var load_label: Label = $SaveOrLoad/Load

@onready var file_1: MarginContainer = $File1
@onready var file_2: MarginContainer = $File2
@onready var file_3: MarginContainer = $File3

const WHITE_TITLE = preload("res://labelSettings/whiteTitle.tres")
const WHITE_SUB_TITLE = preload("res://labelSettings/whiteSubTitle.tres")
const GRAY_TITLE = preload("res://labelSettings/grayTitle.tres")
const GRAY_SUB_TITLE = preload("res://labelSettings/graySubTitle.tres")

const RED_POINTER_RIGHT = preload("res://ui/redPointerRight.png")
const GRAY_POINTER_RIGHT = preload("res://ui/grayPointerRight.png")

const BOUNCE_SIDEWAYS = preload("res://shaders/bounce_sideways.gdshader")
@onready var screen: ColorRect = $Screen
@onready var screen_animation: AnimationPlayer = $ScreenAnimation

@onready var sfx_select: AudioStreamPlayer = $Select
@onready var sfx_move: AudioStreamPlayer = $Move
@onready var sfx_cancel: AudioStreamPlayer = $Cancel
@onready var sfx_buzzer: AudioStreamPlayer = $Buzzer
@onready var sfx_load: AudioStreamPlayer = $Load

@onready var move_cursor_timer: Timer = $MoveCursor

var selected_cursor: int = 1
var action: String = "none"

var canSave: bool = true
var newGame: bool = false

const total_buttons: int = 2
var currently_selected: int = 0
var selected_button: String = "save"

const total_files: int = 3
var currently_selected_file: int = 0
var last_save_file: int = 1

var currently_loading: bool = false

var lastPressedKey: String = "null"

func _ready() -> void:
	if MainInfo.canSave == false:
		MainInfo.canSave = true
		canSave = false
		action = "load"
		save_load_cursor.global_position = load_cursor_point.global_position
		selected_button = "load"
		save_label.label_settings = GRAY_TITLE
		load_label.label_settings = GRAY_TITLE
		var mat = ShaderMaterial.new()
		mat.shader = BOUNCE_SIDEWAYS
		selected_cursor = 2
		save_load_cursor.texture = GRAY_POINTER_RIGHT
		file_cursor.texture = RED_POINTER_RIGHT
		save_load_cursor.material.shader = null
		file_cursor.material = mat
		updateCursorFile()
	else:
		updateCursorSaveLoad()
	
	if MainInfo.newGame == true:
		MainInfo.newGame = false
		newGame = true
		action = "newGame"
		save_load_cursor.global_position = save_cursor_point.global_position
		selected_button = "load"
		save_label.label_settings = GRAY_TITLE
		load_label.label_settings = GRAY_TITLE
		var mat = ShaderMaterial.new()
		mat.shader = BOUNCE_SIDEWAYS
		selected_cursor = 2
		save_load_cursor.texture = GRAY_POINTER_RIGHT
		file_cursor.texture = RED_POINTER_RIGHT
		save_load_cursor.material.shader = null
		file_cursor.material = mat
		updateCursorFile()

func _process(delta: float) -> void:
	if currently_loading: return
	if Input.is_action_just_pressed("x"):
		sfx_cancel.playing = true
		if selected_button == "save" || selected_button == "load" || canSave == false || newGame == true:
			if MainInfo.last_scene_path:
				get_tree().change_scene_to_file(MainInfo.last_scene_path)
			else:
				get_tree().change_scene_to_file("res://ui/title/title_screen.tscn")
		else:
			selected_button = action
			file_1.unhighlightText()
			file_2.unhighlightText()
			file_3.unhighlightText()
			changeCursor(1)
	if Input.is_action_just_pressed("down"):
		move_down()
	if Input.is_action_just_pressed("up"):
		move_up()
	if Input.is_action_just_pressed("z"):
		match selected_button:
			"save":
				sfx_select.playing = true
				_save_pressed()
			"load":
				sfx_select.playing = true
				_load_pressed()
			"file_1":
				if action == "save":
					sfx_select.playing = true
					file_1.updateText()
					Data.save(1)
				if action == "load":
					if file_1.isLoaded:
						await play_load()
						Data.load_data(1)
						load_game()
					else:
						sfx_buzzer.playing = true
				if action == "newGame":
					await play_load()
					Data.new_game()
					load_game()
					
			"file_2":
				if action == "save":
					sfx_select.playing = true
					file_2.updateText()
					Data.save(2)
				if action == "load":
					if file_2.isLoaded:
						await play_load()
						Data.load_data(2)
						load_game()
					else:
						sfx_buzzer.playing = true
				if action == "newGame":
					await play_load()
					Data.new_game()
					load_game()
			"file_3":
				if action == "save":
					sfx_select.playing = true
					file_3.updateText()
					Data.save(3)
				if action == "load":
					if file_3.isLoaded:
						await play_load()
						Data.load_data(3)
						load_game()
					else:
						sfx_buzzer.playing = true
				if action == "newGame":
					await play_load()
					Data.new_game()
					load_game()

func play_load():
	currently_loading = true
	sfx_load.playing = true
	screen_animation.play("fade")
	await screen_animation.animation_finished

func load_game():
	if get_tree():
		if MainInfo.last_scene_path:
			get_tree().change_scene_to_file(MainInfo.last_scene_path)
		else:
			get_tree().change_scene_to_file(MainInfo.begin_world)

func move_up():
	sfx_move.playing = true
	if selected_cursor == 1:
		currently_selected = (currently_selected - 1 + total_buttons) % total_buttons
		updateCursorSaveLoad()
	else:
		currently_selected_file = (currently_selected_file - 1 + total_files) % total_files
		updateCursorFile()

func move_down():
	sfx_move.playing = true
	if selected_cursor == 1:
		currently_selected = (currently_selected + 1) % total_buttons
		updateCursorSaveLoad()
	else:
		currently_selected_file = (currently_selected_file + 1) % total_files
		updateCursorFile()

func _save_pressed():
	changeCursor(2)
	action = "save"
	selected_button = "file_" + str(last_save_file)
	save_label.label_settings = GRAY_TITLE
	load_label.label_settings = GRAY_TITLE
	updateCursorFile()

func _load_pressed():
	changeCursor(2)
	action = "load"
	selected_button = "file_" + str(last_save_file)
	save_label.label_settings = GRAY_TITLE
	load_label.label_settings = GRAY_TITLE
	updateCursorFile()

func changeCursor(cNum: int):
	var mat = ShaderMaterial.new()
	mat.shader = BOUNCE_SIDEWAYS
	if cNum == 1:
		selected_cursor = cNum # 1
		save_load_cursor.texture = RED_POINTER_RIGHT
		file_cursor.texture = GRAY_POINTER_RIGHT
		save_load_cursor.material = mat
		file_cursor.material.shader = null
		updateCursorSaveLoad()
	if cNum == 2:
		selected_cursor = cNum # 2
		save_load_cursor.texture = GRAY_POINTER_RIGHT
		file_cursor.texture = RED_POINTER_RIGHT
		save_load_cursor.material.shader = null
		file_cursor.material = mat
		updateCursorFile()

func updateCursorSaveLoad():
	match currently_selected:
		0:
			save_load_cursor.global_position = save_cursor_point.global_position
			selected_button = "save"
			save_label.label_settings = WHITE_TITLE
			load_label.label_settings = GRAY_TITLE
		1:
			save_load_cursor.global_position = load_cursor_point.global_position
			selected_button = "load"
			save_label.label_settings = GRAY_TITLE
			load_label.label_settings = WHITE_TITLE

func updateCursorFile():
	match currently_selected_file:
		0:
			file_cursor.global_position = file_1.cursor_point.global_position
			selected_button = "file_1"
			last_save_file = 1
			file_1.highlightText()
			file_2.unhighlightText()
			file_3.unhighlightText()
		1:
			file_cursor.global_position = file_2.cursor_point.global_position
			selected_button = "file_2"
			last_save_file = 2
			file_2.highlightText()
			file_1.unhighlightText()
			file_3.unhighlightText()
		2:
			file_cursor.global_position = file_3.cursor_point.global_position
			selected_button = "file_3"
			last_save_file = 3
			file_3.highlightText()
			file_1.unhighlightText()
			file_2.unhighlightText()


func _on_move_cursor_timeout() -> void:
	if lastPressedKey == "down":
		if Input.is_action_pressed("down"):
			move_down()
		else:
			move_cursor_timer.stop()
	if lastPressedKey == "up":
		if Input.is_action_pressed("up"):
			move_up()
		else:
			move_cursor_timer.stop()
