extends Control

@onready var player: CharacterBody2D = $"../.."
@onready var animation: AnimationPlayer = $DialogAnimation
@onready var text_label: RichTextLabel = $TextBox/Text
@onready var sfx_dialog: AudioStreamPlayer = $dialog
@onready var sfx_extra: AudioStreamPlayer = $extra
@onready var cursor: Sprite2D = $Cursor
@onready var name_label: Label = $MarginContainer/HBoxContainer/Name
@onready var face: TextureRect = $FaceBox/Container/Face
@onready var choices_container: VBoxContainer = $Choices/VBoxContainer
@onready var face_box: TextureRect = $FaceBox

@onready var sfx_select: AudioStreamPlayer = $Select
@onready var sfx_move: AudioStreamPlayer = $Move
@onready var top_spacer: MarginContainer = $Choices/VBoxContainer/TopSpacer
@onready var bottom_spacer: MarginContainer = $Choices/VBoxContainer/BottomSpacer

@onready var box_animation: AnimationPlayer = $BoxAnimation
@onready var name_animation: AnimationPlayer = $NameAnimation
@onready var face_animation: AnimationPlayer = $FaceAnimation
@onready var choice_animation: AnimationPlayer = $ChoiceAnimation

var box_active: bool = false
var name_active: bool = false
var face_active: bool = false
var choice_active: bool = false

const DIALOG_OPTION = preload("res://ui/DialogOption.tscn")

var text_speed = 0.03

var boxShown: bool = false
var nameShown: bool = false
var faceShown: bool = false

var dialog_data = []
var outside_dialog_root
var lines = []
var next_dialog
var current_index = 0
var is_active = false
var hasChoices = false
var canContinue: bool = false

var original_cursor_pos = Vector2(590, 447)

var came_from_self: bool = false
var dialog_sender # such as the actual player sprite in game, or a watermelon, or a certain tile

var hold_timer: float = 0.0

signal dialog_finished

func _ready():
	visible = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("z"):
		hold_timer += delta
		if hold_timer >= 0.3:
			text_speed = 0.01
	else:
		hold_timer = 0.0
		text_speed = 0.03
	if dialog_data && dialog_data.has("choices"):
		if canContinue:
			if Input.is_action_just_pressed("up"):
				move_up()
			if Input.is_action_just_pressed("down"):
				move_down()
	if Input.is_action_just_pressed("z"):
		if canContinue:
			_on_next_pressed()

func move_up():
	sfx_move.playing = true
	var choices_cursor_pos = choices_container.get_children().filter(func(c): return not "Spacer" in c.name)
	var cursor_positions = []
	for choice in choices_cursor_pos:
		cursor_positions.append(choice.cursor_pos)
	current_index = (current_index + 1) % cursor_positions.size()
	cursor.global_position = cursor_positions[current_index].global_position

func move_down():
	sfx_move.playing = true
	var choices_cursor_pos = choices_container.get_children().filter(func(c): return not "Spacer" in c.name)
	var cursor_positions = []
	for choice in choices_cursor_pos:
		cursor_positions.append(choice.cursor_pos)
	current_index = (current_index - 1 + cursor_positions.size()) % cursor_positions.size()
	cursor.global_position = cursor_positions[current_index].global_position

func move_nowhere():
	var choices_cursor_pos = choices_container.get_children().filter(func(c): return not "Spacer" in c.name)
	var cursor_positions = []
	for choice in choices_cursor_pos:
		cursor_positions.append(choice.cursor_pos)
	current_index = 0
	cursor.global_position = cursor_positions[current_index].global_position

func play_dialog(dialog_root: Dictionary, dialog_start: Dictionary, sfx = null, sender = null):
	if sfx:
		sfx_extra.stream = sfx
	else:
		stop_sound()
	
	dialog_sender = sender
	
	cursor.global_position = original_cursor_pos
	outside_dialog_root = dialog_root
	
	next_dialog = null
	
	text_label.text = ""
	text_label.visible_characters = 0
	
	var original_text = dialog_start["text"]
	if "<p>" in original_text:
		var p_index = original_text.find("<p>")
		var after_p = original_text.substr(p_index + 3)
		original_text = original_text.substr(0, p_index)

		next_dialog = dialog_root.get(after_p)
	dialog_data = dialog_start
	lines = original_text.split("<n>")
	for child in choices_container.get_children().filter(func(c): return not "Spacer" in c.name):
		child.queue_free()
	if !box_active:
		box_animation.play("show")
		box_active = true
	if !came_from_self:
		if dialog_start["face"] != null:
			if !face_active:
				face_animation.play("show")
			face_active = true
		if dialog_start["speaker"] != null:
			if !name_active:
				name_animation.play("show")
			name_active = true
		if dialog_start.has("choices"):
			hasChoices = true
			for i in range(dialog_start["choices"].size()):
				var option_tab = DIALOG_OPTION.instantiate()
				var spacer_index = choices_container.get_children().find(bottom_spacer)
				choices_container.add_child(option_tab)
				choices_container.move_child(option_tab, spacer_index)
				option_tab.choice.text = dialog_start["choices"][i].to_upper()
			if !choice_active:
				choice_animation.play("show")
			choice_active = true
	else:
		if dialog_start.has("choices"):
			hasChoices = true
			for i in range(dialog_start["choices"].size()):
				var option_tab = DIALOG_OPTION.instantiate()
				var spacer_index = choices_container.get_children().find(bottom_spacer)
				choices_container.add_child(option_tab)
				choices_container.move_child(option_tab, spacer_index)
				option_tab.choice.text = dialog_start["choices"][i].to_upper()
			if !choice_active:
				choice_animation.play("show")
			choice_active = true
	if dialog_start["speaker"]: name_label.text = dialog_start["speaker"].to_upper()
	if dialog_start["face"]: 
		face_box.visible = true
		face.texture = dialog_start["face"]
	else:
		face_box.visible = false
	current_index = 0
	canContinue = false
	is_active = true
	player.canMove = false
	visible = true
	if !came_from_self:
		if box_animation.is_playing():
			await box_animation.animation_finished
	came_from_self = false
	_show_current_line()

func _show_current_line():
	if current_index >= lines.size():
		if !next_dialog:
			play_sound()
			_end_dialogue()
		else:
			came_from_self = true
			play_sound()
			play_dialog(outside_dialog_root, next_dialog, null, dialog_sender)
		return
	var line = lines[current_index]
	var shake_regex = RegEx.new()
	shake_regex.compile("%s([\\d\\.]+)%")
	var shake_match = shake_regex.search(line)

	if shake_match:
		var strength_text = shake_match.get_string(1)
		var strength = strength_text.to_float()
		if get_tree().current_scene.has_method("shake"):
			get_tree().current_scene.shake(strength)
		line = line.replace(shake_match.get_string(), "")
	cursor.visible = false
	canContinue = false
	var previous_text_vis = text_label.visible_characters
	if previous_text_vis != 0: previous_text_vis += 1
	var plain_text = strip_bbcode(line)
	text_label.text += line + "\n"
	text_label.visible_characters = previous_text_vis + 0
	for i in range(plain_text.length() + 1):
		text_label.visible_characters += 1
		sfx_dialog.pitch_scale = randf_range(0.85, 1.15)
		sfx_dialog.playing = true
		await get_tree().create_timer(text_speed).timeout
	if dialog_data.has("item"):
		dialog_data["item"].call(player)
	if dialog_data.has("choices"):
		move_nowhere()
	canContinue = true
	cursor.visible = true
	if Input.is_action_pressed("z"):
		if canContinue:
			canContinue = false
			await get_tree().create_timer(0.5).timeout
			canContinue = true
			if Input.is_action_pressed("z"):
				_on_next_pressed()

func strip_bbcode(source:String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(source, "", true)

func play_sound():
	if !sfx_extra.stream && dialog_data && dialog_data.has("sfx"):
		sfx_extra.stream = dialog_data["sfx"]
		sfx_extra.playing = true
		stop_sound()
	elif sfx_extra.stream:
		sfx_extra.playing = true

func _on_next_pressed():
	if not is_active:
		return
	if dialog_data.has("choices"):
		sfx_select.playing = true
		_end_dialogue()
		return
	current_index = current_index + 1
	_show_current_line()

func _end_dialogue():
	if box_active:
		box_animation.play_backwards("show")
		box_active = false
	if face_active:
		face_animation.play_backwards("show")
		face_active = false
	if name_active:
		name_animation.play_backwards("show")
		name_active = false
	if choice_active:
		choice_animation.play_backwards("show")
		choice_active = false
	var temp_dialog_data = dialog_data.duplicate(true)
	next_dialog = null
	dialog_data = null
	var last_index = str(current_index)
	current_index = 0
	lines = null
	is_active = false
	hasChoices = false
	player.canMove = true
	await box_animation.animation_finished
	visible = false
	var temp_dialog_sender = dialog_sender
	dialog_sender = null
	if temp_dialog_sender:
		if temp_dialog_sender.has_method("finished_dialog"):
			temp_dialog_sender.finished_dialog()
		if temp_dialog_data.has("choices"):
			temp_dialog_sender.choose_choice(temp_dialog_data["choices"][int(last_index)])
	stop_sound()
	dialog_finished.emit()

func stop_sound():
	if sfx_extra.playing:
		await sfx_extra.finished
	sfx_extra.stream = null
