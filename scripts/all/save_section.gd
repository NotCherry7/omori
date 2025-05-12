extends MarginContainer

@export var saveFile: int = 1
@export var isLoaded: bool = false

@onready var file_num: Label = $"TextureRect/File#"
@onready var file_part: Label = $TextureRect/FilePart
@onready var current_name: Label = $TextureRect/CurrentName
@onready var current_level: Label = $TextureRect/CurrentLevel
@onready var total_playtime: Label = $TextureRect/TotalPlaytime
@onready var playtime: Label = $TextureRect/Playtime
@onready var last_location: Label = $TextureRect/LastLocation
@onready var location: Label = $TextureRect/Location
@onready var cursor_point: Marker2D = $CursorPoint
@onready var background = $TextureRect.get_children()
@onready var darken_overlay: ColorRect = $TextureRect/bg/Darken
@onready var face: AnimatedSprite2D = $TextureRect/bg/Container/Face
@onready var bg: TextureRect = $TextureRect/bg

const WHITE_TITLE = preload("res://labelSettings/whiteTitle.tres")
const WHITE_SUB_TITLE = preload("res://labelSettings/whiteSubTitle.tres")
const GRAY_TITLE = preload("res://labelSettings/grayTitle.tres")
const GRAY_SUB_TITLE = preload("res://labelSettings/graySubTitle.tres")


var titleLabels = [file_num, file_part]
var subtitleLabels = [current_name, current_level, total_playtime, playtime, last_location, location]

func _ready() -> void:
	titleLabels = [file_num, file_part]
	subtitleLabels = [current_name, current_level, total_playtime, playtime, last_location, location]
	file_num.text = "FILE " + str(saveFile) + ":"
	match saveFile:
		1:
			var fileData = Data.load_file_preview(1)
			if !fileData.is_empty():
				updateText()
				playtime.text = format_playtime_string(fileData.playtime)
				current_name.text = fileData.leader.to_upper()
				current_level.text = "Level: " + str(fileData.level)
				if fileData.leader == "Luke":
					if fileData.world == "Dreamworld":
						face.play("luke")
					else:
						face.play("fa_luke")
				if fileData.leader == "Brenna":
					if fileData.world == "Dreamworld":
						face.play("brenna")
					else:
						face.play("fa_brenna")
				location.text = fileData.location.to_upper()
		2:
			var fileData = Data.load_file_preview(2)
			if !fileData.is_empty():
				updateText()
				playtime.text = format_playtime_string(fileData.playtime)
				current_name.text = fileData.leader.to_upper()
				current_level.text = "Level: " + str(fileData.level)
				if fileData.leader == "Luke":
					if fileData.world == "Dreamworld":
						face.play("luke")
					else:
						face.play("fa_luke")
				if fileData.leader == "Brenna":
					if fileData.world == "Dreamworld":
						face.play("brenna")
					else:
						face.play("fa_brenna")
				location.text = fileData.location.to_upper()
		3:
			var fileData = Data.load_file_preview(3)
			if !fileData.is_empty():
				updateText()
				playtime.text = format_playtime_string(fileData.playtime)
				current_name.text = fileData.leader.to_upper()
				current_level.text = "Level: " + str(fileData.level)
				if fileData.leader == "Luke":
					if fileData.world == "Dreamworld":
						face.play("luke")
					else:
						face.play("fa_luke")
				if fileData.leader == "Brenna":
					if fileData.world == "Dreamworld":
						face.play("brenna")
					else:
						face.play("fa_brenna")
				location.text = fileData.location.to_upper()

func updateText():
	total_playtime.text = "Total Playtime:"
	playtime.text = format_playtime_string(MainInfo.playtime_seconds)
	file_part.text = "Prologue"
	match MainInfo.leader:
		"Luke":
			current_name.text = "LUKE"
			current_level.text = "Level: " + str(MainInfo.LukeStats["level"])
			if MainInfo.current_world == "Dreamworld":
				face.play("luke")
			else:
				face.play("fa_luke")
			bg.visible = true
		"Brenna":
			current_name.text = "BRENNA"
			current_level.text = "Level: " + str(MainInfo.BrennaStats["level"])
			if MainInfo.current_world == "Dreamworld":
				face.play("brenna")
			else:
				face.play("fa_brenna")
			bg.visible = true
			
	last_location.text = "Location:"
	location.text = MainInfo.location.to_upper()
	isLoaded = true

func format_playtime_string(playtime: float) -> String:
	var total_seconds = int(playtime)
	var hours = total_seconds / 3600
	var minutes = (total_seconds % 3600) / 60
	var seconds = total_seconds % 60
	return "%02d:%02d:%02d" % [hours, minutes, seconds] 

func highlightText():
	for t in titleLabels:
		t.label_settings = WHITE_TITLE
	for st in subtitleLabels:
		st.label_settings = WHITE_SUB_TITLE
	darken_overlay.visible = false

func unhighlightText():
	for t in titleLabels:
		t.label_settings = GRAY_TITLE
	for st in subtitleLabels:
		st.label_settings = GRAY_SUB_TITLE
	darken_overlay.visible = true
