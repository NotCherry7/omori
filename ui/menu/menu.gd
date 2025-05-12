extends Control

@onready var chips: Label = $ClamBar/HBoxContainer/Chips
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var top_bar_buttons = $TopBar/MarginContainer/HBoxContainer.get_children()
@onready var move_cursor_timer: Timer = $MoveCursorTimer
@onready var sfx_select: AudioStreamPlayer = $Select
@onready var sfx_move: AudioStreamPlayer = $Move
@onready var sfx_cancel: AudioStreamPlayer = $Cancel
@onready var sfx_buzzer: AudioStreamPlayer = $Buzzer
@onready var sfx_heal: AudioStreamPlayer = $Heal
@onready var top_bar_cursor: Sprite2D = $TopBar/TopBarCursor
@onready var bottom_player_equip_skills: NinePatchRect = $Bottom
@onready var player: CharacterBody2D = $"../.."
@onready var player_cursor: Sprite2D = $Bottom/Cursor
@onready var top_label_marker: Marker2D = $Bottom/TopLabelMarker
@onready var bottom_label_marker: Marker2D = $Bottom/BottomLabelMarker
@onready var top_label: Label = $Bottom/TopLabel
@onready var top_text: Label = $Bottom/TopText
@onready var bottom_label: Label = $Bottom/BottomLabel
@onready var bottom_text: Label = $Bottom/BottomText
@onready var top_line: ColorRect = $Bottom/TopLine
@onready var middle_line: ColorRect = $Bottom/MiddleLine
@onready var bottom_line: ColorRect = $Bottom/BottomLine
@onready var description_animation: AnimationPlayer = $Bottom/DescriptionBoxAnimation
@onready var replace_with_animation: AnimationPlayer = $Bottom/ReplaceWithBoxAnimation
@onready var item_type_animation: AnimationPlayer = $ItemTypeAnimation
@onready var item_description_animation: AnimationPlayer = $ItemDescriptionAnimation
@onready var item_list_animation: AnimationPlayer = $ItemListAnimation
@onready var stat_animation: AnimationPlayer = $Bottom/StatBoxAnimation
@onready var desc_item_name: Label = $Bottom/DescriptionBox/ColorRect/ItemName
@onready var desc_item_description: Label = $Bottom/DescriptionBox/ColorRect/ItemDescription
@onready var desc_item_image: TextureRect = $Bottom/DescriptionBox/ColorRect/ItemImage
@onready var option_1: Label = $Bottom/ReplaceWithBox/ColorRect/Option1
@onready var opt1_cursor_pos: Marker2D = $Bottom/ReplaceWithBox/ColorRect/Option1/CursorPos
@onready var option_2: Label = $Bottom/ReplaceWithBox/ColorRect/Option2
@onready var opt2_cursor_pos: Marker2D = $Bottom/ReplaceWithBox/ColorRect/Option2/CursorPos
@onready var option_3: Label = $Bottom/ReplaceWithBox/ColorRect/Option3
@onready var opt3_cursor_pos: Marker2D = $Bottom/ReplaceWithBox/ColorRect/Option3/CursorPos
@onready var option_4: Label = $Bottom/ReplaceWithBox/ColorRect/Option4
@onready var opt4_cursor_pos: Marker2D = $Bottom/ReplaceWithBox/ColorRect/Option4/CursorPos
@onready var option_5: Label = $Bottom/ReplaceWithBox/ColorRect/Option5
@onready var opt5_cursor_pos: Marker2D = $Bottom/ReplaceWithBox/ColorRect/Option5/CursorPos
@onready var option_6: Label = $Bottom/ReplaceWithBox/ColorRect/Option6
@onready var opt6_cursor_pos: Marker2D = $Bottom/ReplaceWithBox/ColorRect/Option6/CursorPos
@onready var skill_1: Label = $Bottom/Skill1
@onready var skill_2: Label = $Bottom/Skill2
@onready var skill_3: Label = $Bottom/Skill3
@onready var skill_4: Label = $Bottom/Skill4
@onready var heart_current: Label = $Bottom/StatBox/ColorRect/HeartCurrent
@onready var heart_after: Label = $Bottom/StatBox/ColorRect/HeartAfter
@onready var juice_current: Label = $Bottom/StatBox/ColorRect/JuiceCurrent
@onready var juice_after: Label = $Bottom/StatBox/ColorRect/JuiceAfter
@onready var attack_current: Label = $Bottom/StatBox/ColorRect/AttackCurrent
@onready var attack_after: Label = $Bottom/StatBox/ColorRect/AttackAfter
@onready var defense_current: Label = $Bottom/StatBox/ColorRect/DefenseCurrent
@onready var defense_after: Label = $Bottom/StatBox/ColorRect/DefenseAfter
@onready var speed_current: Label = $Bottom/StatBox/ColorRect/SpeedCurrent
@onready var speed_after: Label = $Bottom/StatBox/ColorRect/SpeedAfter
@onready var luck_current: Label = $Bottom/StatBox/ColorRect/LuckCurrent
@onready var luck_after: Label = $Bottom/StatBox/ColorRect/LuckAfter
@onready var hit_current: Label = $Bottom/StatBox/ColorRect/HitCurrent
@onready var hit_after: Label = $Bottom/StatBox/ColorRect/HitAfter
@onready var replace_with_cursor: Sprite2D = $Bottom/ReplaceWithBox/ColorRect/Cursor
@onready var item_type_cursor: Sprite2D = $MiddleLeftBar/SelectItemType
@onready var item_option_cursor: Sprite2D = $RightBar/OptionCursor
@onready var item_name: Label = $BottomLeftBar/ItemName
@onready var item_description: Label = $BottomLeftBar/ItemDescription
@onready var item_image: TextureRect = $BottomLeftBar/ItemImage
@onready var up_arrow: TextureRect = $Bottom/ReplaceWithBox/ColorRect/Up
@onready var down_arrow: TextureRect = $Bottom/ReplaceWithBox/ColorRect/Down
@onready var up_arrow_item: TextureRect = $RightBar/Up
@onready var down_arrow_item: TextureRect = $RightBar/Down
@onready var luke: Node2D = $Player1
@onready var brenna: Node2D = $Player2
const WHITE_TITLE = preload("res://labelSettings/whiteTitle.tres")
const WHITE_SUB_TITLE = preload("res://labelSettings/whiteSubTitle.tres")
const GRAY_TITLE = preload("res://labelSettings/grayTitle.tres")
const GRAY_SUB_TITLE = preload("res://labelSettings/graySubTitle.tres")
const RED_POINTER_RIGHT = preload("res://ui/redPointerRight.png")
const GRAY_POINTER_RIGHT = preload("res://ui/grayPointerRight.png")
const BOUNCE_SIDEWAYS = preload("res://shaders/bounce_sideways.gdshader")
const GREEN_NUMBER = preload("res://labelSettings/greenNumber.tres")
const RED_NUMBER = preload("res://labelSettings/redNumber.tres")
const WHITE_NUMBER = preload("res://labelSettings/whiteNumber.tres")
var selected_skill
var pauseMenuShown: bool = false
var selected_cursor: String = "selectAction"
var lastPressedKey: String = "null"
var button1: String = "none"
var button2: String = "none"
var action: String = ""
var selected_player: String = ""
var currentMenuShown: int = 1
var currently_selected: int = 0
var currentLayer: int = 0
var currentTab: int = 0
var topBarCursorPoints: Array = []
var playerBottomMarkers: Array = []
var playerSkillMarkers: Array = []
var replaceWithOptions: Array = []
var replaceWithLabels: Array = []
var itemListLabels: Array = []
var itemListMarkers: Array = []
var itemTypeMarkers: Array = []
var itemHoldLabels: Array = []
var skillLabels: Array = []
var selected_item_type: String = ""
var selected_snack
var player_count

func _ready() -> void:
	topBarCursorPoints = [$TopBar/MarginContainer/HBoxContainer/Tag/CursorPoint,$TopBar/MarginContainer/HBoxContainer/Equip/CursorPoint,$TopBar/MarginContainer/HBoxContainer/Pocket/CursorPoint,$TopBar/MarginContainer/HBoxContainer/Skills/CursorPoint,$TopBar/MarginContainer/HBoxContainer/Options/CursorPoint]
	playerBottomMarkers = [$Bottom/TopLabelMarker, $Bottom/BottomLabelMarker]
	replaceWithOptions = [$Bottom/ReplaceWithBox/ColorRect/Option1/CursorPos, $Bottom/ReplaceWithBox/ColorRect/Option2/CursorPos, $Bottom/ReplaceWithBox/ColorRect/Option3/CursorPos, $Bottom/ReplaceWithBox/ColorRect/Option4/CursorPos, $Bottom/ReplaceWithBox/ColorRect/Option5/CursorPos, $Bottom/ReplaceWithBox/ColorRect/Option6/CursorPos]
	replaceWithLabels = [$Bottom/ReplaceWithBox/ColorRect/Option1, $Bottom/ReplaceWithBox/ColorRect/Option2, $Bottom/ReplaceWithBox/ColorRect/Option3, $Bottom/ReplaceWithBox/ColorRect/Option4, $Bottom/ReplaceWithBox/ColorRect/Option5, $Bottom/ReplaceWithBox/ColorRect/Option6]
	playerSkillMarkers = [$Bottom/Skill1Marker, $Bottom/Skill2Marker, $Bottom/Skill3Marker, $Bottom/Skill4Marker]
	skillLabels = [$Bottom/Skill1, $Bottom/Skill2, $Bottom/Skill3, $Bottom/Skill4]
	itemListLabels = [$RightBar/Option1, $RightBar/Option2, $RightBar/Option3, $RightBar/Option4]
	itemListMarkers = [$RightBar/Option1/CursorPos, $RightBar/Option2/CursorPos, $RightBar/Option3/CursorPos, $RightBar/Option4/CursorPos]
	itemTypeMarkers = [$MiddleLeftBar/Snacks/CursorPoint, $MiddleLeftBar/Toys/CursorPoint, $MiddleLeftBar/Important/CursorPoint]
	itemHoldLabels = [$RightBar/Option1/Hold, $RightBar/Option2/Hold, $RightBar/Option3/Hold, $RightBar/Option4/Hold]
	chips.text = format_number_with_commas(MainInfo.chips)
	if MainInfo.current_world == "Realworld":
		$TopBar/MarginContainer/HBoxContainer/Pocket.label_settings = Resources.MENU_GRAY_TITLE
		$TopBar/MarginContainer/HBoxContainer/Skills.label_settings = Resources.MENU_GRAY_TITLE
	else:
		$TopBar/MarginContainer/HBoxContainer/Pocket.label_settings = Resources.MENU_WHITE_TITLE
		$TopBar/MarginContainer/HBoxContainer/Skills.label_settings = Resources.MENU_WHITE_TITLE

func format_number_with_commas(number: int) -> String:
	var num_str := str(number)
	var result := ""
	var count := 0
	for i in range(num_str.length() - 1, -1, -1):
		result = num_str[i] + result
		count += 1
		if count % 3 == 0 and i != 0 and num_str[i - 1] != '-': result = "," + result
	return result

func resume():
	get_tree().paused = false
	animation.play_backwards("show")
	await animation.animation_finished
	visible = false

func pause():
	gray_out_cursor(null, top_bar_cursor)
	luke.update_stats()
	brenna.update_stats()
	luke.update_health()
	brenna.update_health()
	player_count = 2
	if MainInfo.followers.is_empty():
		brenna.visible = false
		player_count = 1
		$TopBar/MarginContainer/HBoxContainer/Tag.label_settings = Resources.MENU_GRAY_TITLE
	else:
		$TopBar/MarginContainer/HBoxContainer/Tag.label_settings = Resources.MENU_WHITE_TITLE
	chips.text = format_number_with_commas(MainInfo.chips)
	get_tree().paused = true
	animation.play("show")
	visible = true
	currentLayer = 0
	currently_selected = 0
	top_bar_cursor.position = Vector2(25.0, 32.0)
	await animation.animation_finished
	moveToCorrectPosition()

func _reset():
	lastPressedKey = "null"
	action = ""
	selected_cursor = "selectAction"
	currently_selected = 0
	pauseMenuShown = false
	currentTab = 0
	gray_out_cursor(null, top_bar_cursor)
	luke.select_frame.visible = false
	brenna.select_frame.visible = false

func moveToCorrectPosition():
	luke.global_position = Vector2(92.0, 424.0)
	brenna.global_position = Vector2(244.0, 424.0)

func gray_out_cursor(gray_cursor, red_cursor):
	var mat = ShaderMaterial.new()
	mat.shader = Resources.BOUNCE_SIDEWAYS
	if gray_cursor:
		gray_cursor.texture = Resources.GRAY_POINTER_RIGHT
		gray_cursor.material.shader = null
	if red_cursor:
		red_cursor.texture = Resources.RED_POINTER_RIGHT
		red_cursor.material = mat

func _process(delta: float) -> void:
	if pauseMenuShown:
		if Input.is_action_just_pressed("up"):
			move_up()
		if Input.is_action_just_pressed("down"):
			move_down()
		if Input.is_action_just_pressed("right"):
			move_right()
		if Input.is_action_just_pressed("left"):
			move_left()
		if Input.is_action_just_pressed("z"):
			currentTab += 1
			if selected_cursor == "selectAction":
				match currently_selected:
					0:
						if player_count <= 1:
							sfx_buzzer.playing = true
							return
						sfx_select.playing = true
						action = "tag"
						gray_out_cursor(top_bar_cursor, null)
						selected_cursor = "selectPlayer"
						currently_selected = 0
						luke.select_frame.visible = true
						brenna.select_frame.visible = false
						luke.play_face("luke")
						brenna.play_face("brenna", true)
					1:
						sfx_select.playing = true
						action = "equip"
						gray_out_cursor(top_bar_cursor, null)
						selected_cursor = "selectPlayer"
						currently_selected = 0
						luke.select_frame.visible = true
						brenna.select_frame.visible = false
						luke.play_face("luke")
						brenna.play_face("brenna", true)
					2:
						sfx_select.playing = true
						action = "pocket"
						selected_cursor = "selectItemType"
						gray_out_cursor(top_bar_cursor, item_type_cursor)
						item_type_animation.play("show")
						currently_selected = 0
						item_type_cursor.global_position = itemTypeMarkers[currently_selected].global_position
					3:
						sfx_select.playing = true
						action = "skills"
						gray_out_cursor(top_bar_cursor, null)
						selected_cursor = "selectPlayer"
						currently_selected = 0
						luke.select_frame.visible = true
						brenna.select_frame.visible = false
						luke.play_face("luke")
						brenna.play_face("brenna", true)
					4:
						sfx_select.playing = true
						action = "options"
						get_tree().change_scene_to_file("res://ui/title/title_screen.tscn")
			elif selected_cursor == "selectPlayer":
				if action == "tag":
					if currently_selected == 0 && MainInfo.leader == "Brenna":
						MainInfo.leader = "Luke"
						player.changeSkin()
					elif currently_selected == 1 && MainInfo.leader == "Luke":
						MainInfo.leader = "Brenna"
						player.changeSkin()
					else:
						sfx_buzzer.playing = true
						return
					sfx_select.playing = true
					currently_selected = 0
					_reset()
					luke.select_frame.visible = false
					brenna.select_frame.visible = false
					luke.play_face("luke", true)
					brenna.play_face("brenna", true)
					resume()
				elif action == "equip":
					sfx_select.playing = true
					select_player(currently_selected)
					if selected_player == "luke":
						top_text.text = MainInfo.LukeStats["weapon"]
						bottom_text.text = MainInfo.LukeStats["charm"]
					elif selected_player == "brenna":
						top_text.text = MainInfo.BrennaStats["weapon"]
						bottom_text.text = MainInfo.BrennaStats["charm"]
					selected_cursor = "selectEquip"
					showWeaponCharm()
					showCurrentWeaponDesc()
					currently_selected = 0
					player_cursor.global_position = playerBottomMarkers[currently_selected].global_position
					luke.select_frame.visible = false
					brenna.select_frame.visible = false
					if selected_player == "brenna":
						await get_tree().create_timer(0.4).timeout
					else:
						await get_tree().create_timer(0.2).timeout
					description_animation.play("showDescription")
				elif action == "skills":
					sfx_select.playing = true
					select_player(currently_selected)
					var i = 0
					if selected_player == "luke":
						for label in skillLabels:
							if MainInfo.LukeMainSkills.size() > i:
								label.text = MainInfo.LukeMainSkills[i]
							else:
								label.text = "-------------"
							i += 1
					elif selected_player == "brenna":
						for label in skillLabels:
							if MainInfo.BrennaMainSkills.size() > i:
								label.text = MainInfo.BrennaMainSkills[i]
							else:
								label.text = "-------------"
							i += 1
					selected_cursor = "selectSkill"
					showSkills()
					currently_selected = 0
					showCurrentSkillDesc()
					player_cursor.global_position = playerSkillMarkers[currently_selected].global_position
					luke.select_frame.visible = false
					brenna.select_frame.visible = false
					if selected_player == "brenna":
						await get_tree().create_timer(0.4).timeout
					else:
						await get_tree().create_timer(0.2).timeout
					description_animation.play("showDescription")
				elif action == "pocket":
					sfx_select.playing = true
					select_player(currently_selected)
					luke.select_frame.visible = false
					brenna.select_frame.visible = false
					luke.play_face("luke", true)
					brenna.play_face("brenna", true)
					useSnack()
					item_description_animation.play("show")
					item_list_animation.play("show")
					currentLayer = 0
					var items = MainInfo.heldSnacks
					var all_item_dictionary = SkillsItemsWeapons.snacks
					currently_selected = 0
					selected_cursor = "selectItem"
					gray_out_cursor(item_type_cursor, item_option_cursor)
					var i: int = 0
					var keys = items.keys()
					for item in itemListLabels:
						item.text = ""
						itemHoldLabels[i].text = ""
						if items.size() >= i + 1 + currentLayer:
							var item_d = all_item_dictionary.get(keys[i + currentLayer])
							if item_d:
								var item_name = item_d["name"]
								var item_hold = items.get(keys[i + currentLayer])["hold"]
								itemHoldLabels[i].text = "x" + str(item_hold)
								item.text = item_name.to_upper()
						i += 1
					if items.size() > 4 + currentLayer:
						down_arrow_item.visible = true
					else:
						down_arrow_item.visible = false
					item_option_cursor.global_position = itemListMarkers[currently_selected].global_position
					showItemDesc()
			elif selected_cursor == "selectEquip":
				if currently_selected == 0: # weapon
					if MainInfo.heldWeapons.is_empty():
						sfx_buzzer.playing = true
						return
					sfx_select.playing = true
					selected_cursor = "selectWeapon"
					currently_selected = 0
					replace_with_animation.play("showOptions")
					stat_animation.play("showStatBox")
					var i = 0
					for weapon in replaceWithLabels:
						weapon.text = ""
						if MainInfo.heldWeapons.size() >= i + 1: # 
							var weapon_d = SkillsItemsWeapons.weapons.get(MainInfo.heldWeapons[i + currentLayer * 2])
							var weapon_name = weapon_d["name"]
							weapon.text = weapon_name.to_upper()
						i += 1
					updateStats()
					gray_out_cursor(player_cursor, replace_with_cursor)
					replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
					showWeaponDesc()
					
				elif currently_selected == 1: # charm
					if MainInfo.heldCharms.is_empty():
						sfx_buzzer.playing = true
						return
					sfx_select.playing = true
					selected_cursor = "selectCharm"
					currently_selected = 0
					replace_with_animation.play("showOptions")
					stat_animation.play("showStatBox")
					var i = 0
					for weapon in replaceWithLabels:
						weapon.text = ""
						if MainInfo.heldCharms.size() >= i + 1: # 
							var weapon_d = SkillsItemsWeapons.charms.get(MainInfo.heldCharms[i + currentLayer * 2])
							var weapon_name = weapon_d["name"]
							weapon.text = weapon_name.to_upper()
						i += 1
					updateStats(false)
					gray_out_cursor(player_cursor, replace_with_cursor)
					replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
					showCharmDesc()
			elif selected_cursor == "selectWeapon":
				sfx_select.playing = true
				var current_player_stats
				if selected_player == "luke": current_player_stats = MainInfo.LukeStats
				if selected_player == "brenna": current_player_stats = MainInfo.BrennaStats
				var old_weapon = current_player_stats["weapon"]
				var new_weapon = MainInfo.heldWeapons[currently_selected + currentLayer * 2]
				
				current_player_stats["weapon"] = new_weapon
				MainInfo.heldWeapons[currently_selected + currentLayer * 2] = old_weapon
				showWeaponDesc()
				luke.update_stats()
				brenna.update_stats()
				
				top_text.text = current_player_stats["weapon"].to_upper()
				var i = 0
				for weapon in replaceWithLabels:
					weapon.text = ""
					if MainInfo.heldWeapons.size() >= i + 1: # 
						var weapon_d = SkillsItemsWeapons.weapons.get(MainInfo.heldWeapons[i + currentLayer * 2])
						var weapon_name = weapon_d["name"]
						weapon.text = weapon_name.to_upper()
					i += 1
				updateStats()
			elif selected_cursor == "selectCharm":
				sfx_select.playing = true
				var current_player_stats
				if selected_player == "luke": current_player_stats = MainInfo.LukeStats
				if selected_player == "brenna": current_player_stats = MainInfo.BrennaStats
				var old_weapon = current_player_stats["charm"]
				var new_weapon = MainInfo.heldCharms[currently_selected + currentLayer * 2]
				
				current_player_stats["charm"] = new_weapon
				MainInfo.heldCharms[currently_selected + currentLayer * 2] = old_weapon
				showCharmDesc()
				luke.update_stats()
				brenna.update_stats()
				
				bottom_text.text = current_player_stats["charm"].to_upper()
				var i = 0
				for weapon in replaceWithLabels:
					weapon.text = ""
					if MainInfo.heldCharms.size() >= i + 1:
						var weapon_d = SkillsItemsWeapons.charms.get(MainInfo.heldCharms[i + currentLayer * 2])
						var weapon_name = weapon_d["name"]
						weapon.text = weapon_name.to_upper()
					i += 1
				updateStats(false)
			elif selected_cursor == "selectSkill":
				sfx_select.playing = true
				selected_skill = currently_selected
				selected_cursor = "selectReplaceSkill"
				var all_player_skills
				var current_player_skills
				if selected_player == "luke":
					current_player_skills = MainInfo.LukeMainSkills
					all_player_skills = MainInfo.lukeUnlockedSkills.duplicate(true)
				if selected_player == "brenna":
					current_player_skills = MainInfo.BrennaMainSkills
					all_player_skills = MainInfo.brennaUnlockedSkills.duplicate(true)
				for skill in current_player_skills:
					all_player_skills.erase(skill)
				currently_selected = 0
				replace_with_animation.play("showOptions")
				var i = 0
				for weapon in replaceWithLabels:
					weapon.text = ""
					if all_player_skills.size() >= i + 1: # 
						var weapon_d = SkillsItemsWeapons.skills.get(all_player_skills[i + currentLayer * 2])
						if weapon_d:
							var weapon_name = weapon_d["name"]
							weapon.text = weapon_name.to_upper()
						else:
							weapon.text = "-------------"
					i += 1
				gray_out_cursor(player_cursor, replace_with_cursor)
				replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
				showSkillDesc()
			elif selected_cursor == "selectReplaceSkill":
				sfx_select.playing = true
				var all_player_skills
				var current_player_skills
				var not_selected_skills
				if selected_player == "luke":
					current_player_skills = MainInfo.LukeMainSkills
					all_player_skills = MainInfo.lukeUnlockedSkills.duplicate(true)
				if selected_player == "brenna":
					current_player_skills = MainInfo.BrennaMainSkills
					all_player_skills = MainInfo.brennaUnlockedSkills.duplicate(true)
				not_selected_skills = all_player_skills.duplicate(true)
				for skill in current_player_skills:
					not_selected_skills.erase(skill)
				var old_skill = current_player_skills[selected_skill]
				var new_skill = not_selected_skills[currently_selected + currentLayer * 2]
				
				current_player_skills[selected_skill] = new_skill
				not_selected_skills[currently_selected + currentLayer * 2] = old_skill
				showSkillDesc()
				
				skillLabels[selected_skill].text = current_player_skills[selected_skill].to_upper()
				var i = 0
				for skill in replaceWithLabels:
					skill.text = ""
					if not_selected_skills.size() >= i + 1:
						var skill_d = SkillsItemsWeapons.skills.get(not_selected_skills[i + currentLayer * 2])
						var skill_name = skill_d["name"]
						skill.text = skill_name.to_upper()
					i += 1
			elif selected_cursor == "selectItemType":
				currentLayer = 0
				var items
				var all_item_dictionary = SkillsItemsWeapons.snacks
				all_item_dictionary.merge(SkillsItemsWeapons.toys, true)
				all_item_dictionary.merge(SkillsItemsWeapons.items, true)
				if currently_selected == 0:
					selected_item_type = "snacks"
					items = MainInfo.heldSnacks
				elif currently_selected == 1:
					selected_item_type = "toys"
					items = MainInfo.heldToys.duplicate()
					items.merge(MainInfo.heldItems, true)
				elif currently_selected == 2:
					selected_item_type = "important"
					items = MainInfo.heldImportant
				if items.size() <= 0:
					sfx_buzzer.playing = true
					return
				item_description_animation.play("show")
				item_list_animation.play("show")
				sfx_select.playing = true
				currently_selected = 0
				selected_cursor = "selectItem"
				gray_out_cursor(item_type_cursor, item_option_cursor)
				var i: int = 0
				var keys = items.keys()
				for item in itemListLabels:
					item.text = ""
					itemHoldLabels[i].text = ""
					if items.size() >= i + 1 + currentLayer:
						var item_d = all_item_dictionary.get(keys[i + currentLayer])
						if item_d:
							var item_name = item_d["name"]
							var item_hold = items.get(keys[i + currentLayer])["hold"]
							itemHoldLabels[i].text = "x" + str(item_hold)
							item.text = item_name.to_upper()
					i += 1
				if items.size() > 4 + currentLayer:
					down_arrow_item.visible = true
				else:
					down_arrow_item.visible = false
				item_option_cursor.global_position = itemListMarkers[currently_selected].global_position
				showItemDesc()
			elif selected_cursor == "selectItem":
				if selected_item_type == "snacks":
					selected_snack = SkillsItemsWeapons.snacks.get(MainInfo.heldSnacks.keys()[currently_selected + currentLayer])
					if selected_snack["name"] == "Life Jam": return
					sfx_select.playing = true
					if selected_snack.has("all"):
						useSnack()
						currentLayer = 0
						var items = MainInfo.heldSnacks
						var all_item_dictionary = SkillsItemsWeapons.snacks
						currently_selected = 0
						selected_cursor = "selectItem"
						gray_out_cursor(item_type_cursor, item_option_cursor)
						var i: int = 0
						var keys = items.keys()
						for item in itemListLabels:
							item.text = ""
							itemHoldLabels[i].text = ""
							if items.size() >= i + 1 + currentLayer:
								var item_d = all_item_dictionary.get(keys[i + currentLayer])
								if item_d:
									var item_name = item_d["name"]
									var item_hold = items.get(keys[i + currentLayer])["hold"]
									itemHoldLabels[i].text = "x" + str(item_hold)
									item.text = item_name.to_upper()
							i += 1
						if items.size() > 4 + currentLayer:
							down_arrow_item.visible = true
						else:
							down_arrow_item.visible = false
						item_option_cursor.global_position = itemListMarkers[currently_selected].global_position
						showItemDesc()
					else:
						selected_cursor = "selectPlayer"
						currently_selected = 0
						luke.select_frame.visible = true
						brenna.select_frame.visible = false
						item_list_animation.play_backwards("show")
						item_description_animation.play_backwards("show")

	if Input.is_action_just_pressed("x"):
		if player.dialog_menu.is_active: return
		if pauseMenuShown:
			currentTab -= 1
			if selected_cursor == "selectAction":
				resume()
				sfx_cancel.playing = true
				pauseMenuShown = false
				currentTab = 0
			elif selected_cursor == "selectPlayer":
				sfx_cancel.playing = true
				luke.select_frame.visible = false
				brenna.select_frame.visible = false
				luke.play_face("luke", true)
				brenna.play_face("brenna", true)
				if action == "pocket":
					selected_cursor = "selectItem"
					item_description_animation.play("show")
					item_list_animation.play("show")
					currentLayer = 0
					var items = MainInfo.heldSnacks
					var all_item_dictionary = SkillsItemsWeapons.snacks
					currently_selected = 0
					selected_cursor = "selectItem"
					gray_out_cursor(item_type_cursor, item_option_cursor)
					var i: int = 0
					var keys = items.keys()
					for item in itemListLabels:
						item.text = ""
						itemHoldLabels[i].text = ""
						if items.size() >= i + 1 + currentLayer:
							var item_d = all_item_dictionary.get(keys[i + currentLayer])
							if item_d:
								var item_name = item_d["name"]
								var item_hold = items.get(keys[i + currentLayer])["hold"]
								itemHoldLabels[i].text = "x" + str(item_hold)
								item.text = item_name.to_upper()
						i += 1
					if items.size() > 4 + currentLayer:
						down_arrow_item.visible = true
					else:
						down_arrow_item.visible = false
					item_option_cursor.global_position = itemListMarkers[currently_selected].global_position
					showItemDesc()
				else:
					selected_cursor = "selectAction"
					setCSbasedAction()
					gray_out_cursor(null, top_bar_cursor)
			elif selected_cursor == "selectEquip":
				sfx_cancel.playing = true
				selected_cursor = "selectPlayer"
				#gray_out_cursor(null, top_bar_cursor)
				setCSbasedAction()
				description_animation.play_backwards("showDescription")
				await description_animation.animation_finished
				if selected_player == "luke":
					return_player(0)
					luke.select_frame.visible = true
					luke.play_face("luke")
					currently_selected = 0
				elif selected_player == "brenna":
					return_player(1)
					brenna.select_frame.visible = true
					brenna.play_face("brenna")
					currently_selected = 1
			elif selected_cursor == "selectSkill":
				sfx_cancel.playing = true
				selected_cursor = "selectPlayer"
				#gray_out_cursor(null, top_bar_cursor)
				description_animation.play_backwards("showDescription")
				await description_animation.animation_finished
				setCSbasedAction()
				if selected_player == "luke":
					return_player(0)
					luke.select_frame.visible = true
					luke.play_face("luke")
					currently_selected = 0
				elif selected_player == "brenna":
					return_player(1)
					brenna.select_frame.visible = true
					brenna.play_face("brenna")
					currently_selected = 1
			elif selected_cursor == "selectWeapon":
				sfx_cancel.playing = true
				selected_cursor = "selectEquip"
				gray_out_cursor(null, player_cursor)
				currently_selected = 0
				currentLayer = 0
				replace_with_animation.play_backwards("showOptions")
				stat_animation.play_backwards("showStatBox")
				showCurrentWeaponDesc()
			elif selected_cursor == "selectCharm":
				sfx_cancel.playing = true
				selected_cursor = "selectEquip"
				gray_out_cursor(null, player_cursor)
				currently_selected = 1
				currentLayer = 0
				replace_with_animation.play_backwards("showOptions")
				stat_animation.play_backwards("showStatBox")
				showCurrentCharmDesc()
			elif selected_cursor == "selectReplaceSkill":
				sfx_cancel.playing = true
				selected_cursor = "selectSkill"
				gray_out_cursor(null, player_cursor)
				currently_selected = selected_skill
				currentLayer = 0
				replace_with_animation.play_backwards("showOptions")
				showCurrentSkillDesc()
			elif selected_cursor == "selectItem":
				sfx_cancel.playing = true
				selected_cursor = "selectItemType"
				gray_out_cursor(null, item_type_cursor)
				if selected_item_type == "snacks":
					currently_selected = 0
				elif selected_item_type == "toys":
					currently_selected = 1
				elif selected_item_type == "important":
					currently_selected = 2
				currentLayer = 0
				item_list_animation.play_backwards("show")
				item_description_animation.play_backwards("show")
			elif selected_cursor == "selectItemType":
				sfx_cancel.playing = true
				selected_cursor = "selectAction"
				setCSbasedAction()
				gray_out_cursor(null, top_bar_cursor)
				item_type_animation.play_backwards("show")
		elif !pauseMenuShown && currentTab == 0:
			if !player.moving:
				pause()
				pauseMenuShown = true
			else:
				player.queue_menu = true

func useSnack():
	var snack_data = selected_snack
	var target
	if selected_player == "luke":
		target = luke
	elif selected_player == "brenna":
		target = brenna
	
	MainInfo.heldSnacks.get(snack_data["name"])["hold"] -= 1
	if MainInfo.heldSnacks.get(snack_data["name"])["hold"] <= 0: MainInfo.heldSnacks.erase(snack_data["name"])
	if snack_data["name"] == "Life Jam": return
	
	if !snack_data.has("all"):
		if snack_data.has("health") && !snack_data.has("juice"):
			var snack_heal = snack_data["health"].call(target)
			target.applyHealth(roundi(snack_heal))
		elif snack_data.has("juice") && !snack_data.has("health"):
			var snack_heal = snack_data["juice"].call(target)
			target.applyJuice(roundi(snack_heal))
		elif snack_data.has("health") && snack_data.has("juice"):
			var snack_heal = snack_data["health"].call(target)
			var snack_juice = snack_data["juice"].call(target)
			target.applyHealthJuice(roundi(snack_heal), roundi(snack_juice))
	else:
		for tgt in [luke, brenna]:
			if snack_data.has("health") && !snack_data.has("juice"):
				var snack_heal = snack_data["health"].call(tgt)
				tgt.applyHealth(roundi(snack_heal))
			elif snack_data.has("juice") && !snack_data.has("health"):
				var snack_heal = snack_data["juice"].call(tgt)
				tgt.applyJuice(roundi(snack_heal))
			elif snack_data.has("health") && snack_data.has("juice"):
				var snack_heal = snack_data["health"].call(tgt)
				var snack_juice = snack_data["juice"].call(tgt)
				tgt.applyHealthJuice(roundi(snack_heal), roundi(snack_juice))

func open_menu():
	if !pauseMenuShown && currentTab == 0:
		pause()
		pauseMenuShown = true

func updateStats(isWeapon: bool = true):
	var stats
	if selected_player == "luke": stats = MainInfo.LukeStats
	elif selected_player == "brenna": stats = MainInfo.BrennaStats
	else: return
	var weapon = SkillsItemsWeapons.weapons.get(stats.get("weapon"))
	var charm = SkillsItemsWeapons.charms.get(stats.get("charm"))
	var new_item
	var other_item
	if isWeapon:
		new_item = SkillsItemsWeapons.weapons.get(MainInfo.heldWeapons[currently_selected])
		other_item = SkillsItemsWeapons.charms.get(stats.get("charm"))
	else:
		new_item = SkillsItemsWeapons.charms.get(MainInfo.heldCharms[currently_selected])
		other_item = SkillsItemsWeapons.weapons.get(stats.get("weapon"))
	
	heart_current.text = str(stats.get("maxHeart") + (weapon.get("health", 0) if weapon else 0) + (charm.get("health", 0) if charm else 0))
	juice_current.text = str(stats.get("maxJuice") + (weapon.get("juice", 0) if weapon else 0) + (charm.get("juice", 0) if charm else 0))
	attack_current.text = str(stats.get("attack") + (weapon.get("attack", 0) if weapon else 0) + (charm.get("attack", 0) if charm else 0))
	defense_current.text = str(stats.get("defense") + (weapon.get("defense", 0) if weapon else 0) + (charm.get("defense", 0) if charm else 0))
	speed_current.text = str(stats.get("speed") + (weapon.get("speed", 0) if weapon else 0) + (charm.get("speed", 0) if charm else 0))
	luck_current.text= str(stats.get("luck") + (weapon.get("luck", 0) if weapon else 0) + (charm.get("luck", 0) if charm else 0))
	hit_current.text = str((weapon.get("hitRate") if weapon else stats.get("hitRate", 0)) + (charm.get("hitRate", 0) if charm else 0))

	heart_after.text = str(stats.get("maxHeart") + (new_item.get("health", 0) if new_item else 0) + (other_item.get("health", 0) if other_item else 0))
	juice_after.text = str(stats.get("maxJuice") + (new_item.get("juice", 0) if new_item else 0) + (other_item.get("juice", 0) if other_item else 0))
	attack_after.text = str(stats.get("attack") + (new_item.get("attack", 0) if new_item else 0) + (other_item.get("attack", 0) if other_item else 0))
	defense_after.text = str(stats.get("defense") + (new_item.get("defense", 0) if new_item else 0) + (other_item.get("defense", 0) if other_item else 0))
	speed_after.text = str(stats.get("speed") + (new_item.get("speed", 0) if new_item else 0) + (other_item.get("speed", 0) if other_item else 0))
	luck_after.text= str(stats.get("luck") + (new_item.get("luck", 0) if new_item else 0) + (other_item.get("luck", 0) if other_item else 0))
	hit_after.text = str((new_item.get("hitRate") if new_item else stats.get("hitRate", 0)) + (other_item.get("hitRate", 0) if other_item else 0))

	updateStatLabels(heart_current, heart_after)
	updateStatLabels(juice_current, juice_after)
	updateStatLabels(attack_current, attack_after)
	updateStatLabels(defense_current, defense_after)
	updateStatLabels(speed_current, speed_after)
	updateStatLabels(luck_current, luck_after)
	updateStatLabels(hit_current, hit_after)

func updateStatLabels(current, after):
	if int(str(current.text)) > int(str(after.text)):
		after.label_settings = RED_NUMBER
	if int(str(current.text)) == int(str(after.text)):
		after.label_settings = WHITE_NUMBER
	if int(str(current.text)) < int(str(after.text)):
		after.label_settings = GREEN_NUMBER

func setCSbasedAction():
	if action == "tag":
		currently_selected = 0
	elif action == "equip":
		currently_selected = 1
	elif action == "pocket":
		currently_selected = 2
	elif action == "skills":
		currently_selected = 3
	elif action == "options":
		currently_selected = 4

func showWeaponCharm():
	skill_1.visible = false
	skill_2.visible = false
	skill_3.visible = false
	skill_4.visible = false
	top_label.text = "WEAPON"
	top_label.visible = true
	top_text.visible = true
	bottom_label.visible = true
	bottom_text.visible = true
	top_line.visible = true
	middle_line.visible = true
	bottom_line.visible = true

func showSkills():
	skill_1.visible = true
	skill_2.visible = true
	skill_3.visible = true
	skill_4.visible = true
	top_label.text = "SKILLS"
	top_label.visible = true
	top_text.visible = false
	bottom_label.visible = false
	bottom_text.visible = false
	top_line.visible = true
	middle_line.visible = false
	bottom_line.visible = false

func showCurrentWeaponDesc():
	var weapon_dict
	if selected_player == "luke":
		weapon_dict = SkillsItemsWeapons.weapons.get(MainInfo.LukeStats.get("weapon"))
	elif selected_player == "brenna":
		weapon_dict = SkillsItemsWeapons.weapons.get(MainInfo.BrennaStats.get("weapon"))
	desc_item_name.text = weapon_dict["name"]
	desc_item_description.text = weapon_dict["description"]
	desc_item_image.texture = weapon_dict["image"]

func showCurrentSkillDesc():
	var skill_dict
	if selected_player == "luke":
		skill_dict = SkillsItemsWeapons.skills.get(MainInfo.LukeMainSkills[currently_selected])
	elif selected_player == "brenna":
		skill_dict = SkillsItemsWeapons.skills.get(MainInfo.BrennaMainSkills[currently_selected])
	desc_item_name.text = skill_dict["name"]
	desc_item_description.text = skill_dict["description"]
	desc_item_image.texture = null

func showCurrentCharmDesc():
	var weapon_dict
	if selected_player == "luke":
		weapon_dict = SkillsItemsWeapons.charms.get(MainInfo.LukeStats.get("charm"))
	elif selected_player == "brenna":
		weapon_dict = SkillsItemsWeapons.charms.get(MainInfo.BrennaStats.get("charm"))
	desc_item_name.text = weapon_dict["name"]
	desc_item_description.text = weapon_dict["description"]
	desc_item_image.texture = weapon_dict["image"]

func showWeaponDesc():
	var weapon_dict = SkillsItemsWeapons.weapons.get(MainInfo.heldWeapons.get(currently_selected + currentLayer * 2))
	desc_item_name.text = weapon_dict["name"]
	desc_item_description.text = weapon_dict["description"]
	desc_item_image.texture = weapon_dict["image"]

func showCharmDesc():
	var charm_dict = SkillsItemsWeapons.charms.get(MainInfo.heldCharms.get(currently_selected + currentLayer * 2))
	desc_item_name.text = charm_dict["name"]
	desc_item_description.text = charm_dict["description"]
	desc_item_image.texture = charm_dict["image"]

func showItemDesc():
	var item_d
	var all_item_dictionary = SkillsItemsWeapons.snacks
	all_item_dictionary.merge(SkillsItemsWeapons.toys, true)
	all_item_dictionary.merge(SkillsItemsWeapons.items, true)
	if selected_item_type == "snacks":
		item_d = all_item_dictionary.get(MainInfo.heldSnacks.keys()[currently_selected + currentLayer])
	elif selected_item_type == "toys":
		var item_dea = MainInfo.heldToys.duplicate()
		item_dea.merge(MainInfo.heldItems, true)
		item_d = all_item_dictionary.get(item_dea.keys()[currently_selected + currentLayer])
	elif selected_item_type == "important":
		item_d = all_item_dictionary.get(MainInfo.heldImportant.keys()[currently_selected + currentLayer])
	item_name.text = item_d["name"]
	item_description.text = item_d["description"]
	item_image.texture = null

func showSkillDesc():
	var skill_dict
	if selected_player == "luke":
		skill_dict = SkillsItemsWeapons.skills.get(MainInfo.LukeMainSkills[currently_selected + currentLayer * 2])
	elif selected_player == "brenna":
		skill_dict = SkillsItemsWeapons.skills.get(MainInfo.BrennaMainSkills[currently_selected + currentLayer * 2])
	desc_item_name.text = skill_dict["name"]
	desc_item_description.text = skill_dict["description"]
	desc_item_image.texture = null

func select_player(index: int):
	if action == "tag" || action == "pocket":
		match index:
			0:
				selected_player = "luke"
			1:
				selected_player = "brenna"
		return
	match index:
		0:
			selected_player = "luke"
			var tween = create_tween()
			tween.tween_property(luke, "position", Vector2(luke.position.x, 424.0 - 135.0), 0.2)
			var tween2 = create_tween()
			tween2.tween_property(luke, "modulate", Color(1.0, 1.0, 1.0), 0.2)
			var tween3 = create_tween()
			tween3.tween_property(brenna, "position", Vector2(brenna.position.x, 424.0 + 256), 0.2)
			var tween4 = create_tween()
			tween4.tween_property(brenna, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2)
			var tween_bottom = create_tween()
			tween_bottom.tween_property(bottom_player_equip_skills, "position", Vector2(bottom_player_equip_skills.position.x, 345.0), 0.2)
		1:
			selected_player = "brenna"
			var tween3 = create_tween()
			tween3.tween_property(luke, "position", Vector2(luke.position.x, 424.0 + 256), 0.2)
			var tween4 = create_tween()
			tween4.tween_property(luke, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2)
			var tween = create_tween()
			tween.tween_property(brenna, "position", Vector2(92, brenna.position.y), 0.2)
			await tween.finished
			var tween1 = create_tween()
			tween1.tween_property(brenna, "position", Vector2(brenna.position.x, 424.0 - 135.0), 0.2)
			var tween2 = create_tween()
			tween2.tween_property(brenna, "modulate", Color(1.0, 1.0, 1.0), 0.2)
			var tween_bottom = create_tween()
			tween_bottom.tween_property(bottom_player_equip_skills, "position", Vector2(bottom_player_equip_skills.position.x, 345.0), 0.2)

func return_player(index: int):
	match index:
		0:
			var tween = create_tween()
			tween.tween_property(luke, "position", Vector2(luke.position.x, 424.0), 0.2)
			var tween2 = create_tween()
			tween2.tween_property(luke, "modulate", Color(1.0, 1.0, 1.0), 0.2)
			var tween3 = create_tween()
			tween3.tween_property(brenna, "position", Vector2(brenna.position.x, 424.0), 0.2)
			var tween4 = create_tween()
			tween4.tween_property(brenna, "modulate", Color(1.0, 1.0, 1.0), 0.2)
			
			var tween_bottom = create_tween()
			tween_bottom.tween_property(bottom_player_equip_skills, "position", Vector2(bottom_player_equip_skills.position.x, 480.0), 0.2)
		1:
			var tween4 = create_tween()
			tween4.tween_property(luke, "modulate", Color(1.0, 1.0, 1.0), 0.2)
			var tween = create_tween()
			tween.tween_property(brenna, "position", Vector2(brenna.position.x, 424.0), 0.2)
			
			var tween_bottom = create_tween()
			tween_bottom.tween_property(bottom_player_equip_skills, "global_position", Vector2(bottom_player_equip_skills.position.x, 480.0), 0.2)
			
			await tween.finished
			var tween5 = create_tween()
			tween5.tween_property(brenna, "position", Vector2(244.0, brenna.position.y), 0.2)
			var tween3 = create_tween()
			tween3.tween_property(luke, "position", Vector2(luke.position.x, 424.0), 0.2)
			var tween1 = create_tween()
			tween1.tween_property(brenna, "position", Vector2(244.0, 424.0), 0.2)
			var tween2 = create_tween()
			tween2.tween_property(brenna, "modulate", Color(1.0, 1.0, 1.0), 0.2)

	#luke.global_position = Vector2(92.0, 424.0)
	#brenna.global_position = Vector2(244.0, 424.0)

func showframe():
	if currently_selected == 0:
		luke.select_frame.visible = true
		brenna.select_frame.visible = false
	elif currently_selected == 1:
		luke.select_frame.visible = false
		brenna.select_frame.visible = true

func move_left():
	if selected_cursor == "selectAction":
		currently_selected = (currently_selected - 1 + 5) % 5
		top_bar_cursor.global_position = topBarCursorPoints[currently_selected].global_position
		button1 = top_bar_buttons[currently_selected].name
		sfx_move.playing = true
	elif selected_cursor == "selectPlayer":
		if MainInfo.followers.size() > 0: sfx_move.playing = true
		currently_selected = (currently_selected + 1) % (MainInfo.followers.size() + 1)
		showframe()
		if currently_selected == 0:
			luke.play_face("luke")
			brenna.play_face("brenna", true)
		elif currently_selected == 1: 
			luke.play_face("luke", true)
			brenna.play_face("brenna")
	elif selected_cursor == "selectWeapon":
		if currently_selected == 1 || currently_selected == 3 || currently_selected == 5:
			currently_selected = (currently_selected - 1)
			sfx_move.playing = true
		replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
		updateStats()
		showWeaponDesc()
	elif selected_cursor == "selectCharm":
		if currently_selected == 1 || currently_selected == 3 || currently_selected == 5:
			currently_selected = (currently_selected - 1)
			sfx_move.playing = true
		replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
		updateStats(false)
		showCharmDesc()
	elif selected_cursor == "selectReplaceSkill":
		if currently_selected == 1 || currently_selected == 3 || currently_selected == 5:
			currently_selected = (currently_selected - 1)
			sfx_move.playing = true
		replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
		showSkillDesc()
	elif selected_cursor == "selectItemType":
		sfx_move.playing = true
		currently_selected = (currently_selected - 1 + 3) % 3
		item_type_cursor.global_position = itemTypeMarkers[currently_selected].global_position

func move_right():
	if selected_cursor == "selectAction":
		sfx_move.playing = true
		currently_selected = (currently_selected + 1) % 5
		top_bar_cursor.global_position = topBarCursorPoints[currently_selected].global_position
		button1 = top_bar_buttons[currently_selected].name
	elif selected_cursor == "selectPlayer":
		if MainInfo.followers.size() > 0: sfx_move.playing = true
		currently_selected = (currently_selected + 1) % (MainInfo.followers.size() + 1)
		showframe()
		if currently_selected == 0:
			luke.play_face("luke")
			brenna.play_face("brenna", true)
		elif currently_selected == 1:
			luke.play_face("luke", true)
			brenna.play_face("brenna")
	elif selected_cursor == "selectWeapon":
		if currently_selected == 0 || currently_selected == 2 || currently_selected == 4:
			if MainInfo.heldWeapons.size() >= currently_selected + 2 + currentLayer * 2:
				currently_selected = (currently_selected + 1)
				sfx_move.playing = true
		replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
		updateStats()
		showWeaponDesc()
	elif selected_cursor == "selectCharm":
		if currently_selected == 0 || currently_selected == 2 || currently_selected == 4:
			if MainInfo.heldCharms.size() >= currently_selected + 2 + currentLayer * 2:
				currently_selected = (currently_selected + 1)
				sfx_move.playing = true
		replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
		updateStats(false)
		showCharmDesc()
	elif selected_cursor == "selectReplaceSkill":
		var all_player_skills
		var current_player_skills
		if selected_player == "luke":
			current_player_skills = MainInfo.LukeMainSkills
			all_player_skills = MainInfo.lukeUnlockedSkills.duplicate(true)
		if selected_player == "brenna":
			current_player_skills = MainInfo.BrennaMainSkills
			all_player_skills = MainInfo.brennaUnlockedSkills.duplicate(true)
		for skill in current_player_skills:
			all_player_skills.erase(skill)
		if currently_selected == 0 || currently_selected == 2 || currently_selected == 4:
			if all_player_skills.size() >= currently_selected + 2 + currentLayer * 2:
				currently_selected = (currently_selected + 1)
				sfx_move.playing = true
		replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
		showSkillDesc()
	elif selected_cursor == "selectItemType":
		sfx_move.playing = true
		currently_selected = (currently_selected + 1) % 3
		item_type_cursor.global_position = itemTypeMarkers[currently_selected].global_position

func move_up():
	if selected_cursor == "selectEquip":
		sfx_move.playing = true
		currently_selected = (currently_selected + 1) % 2
		player_cursor.global_position = playerBottomMarkers[currently_selected].global_position
		if currently_selected == 0: showCurrentWeaponDesc()
		elif currently_selected == 1: showCurrentCharmDesc()
	elif selected_cursor == "selectWeapon":
		if currently_selected == 2 || currently_selected == 3 || currently_selected == 4 || currently_selected == 5:
			currently_selected -= 2
			replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
			sfx_move.playing = true
			showWeaponDesc()
			if currentLayer == 0:
				up_arrow.visible = false
			if MainInfo.heldWeapons.size() > 6 + currentLayer * 2:
				down_arrow.visible = true
			else:
				down_arrow.visible = false
		elif currently_selected == 0 || currently_selected == 1:
			if currentLayer != 0:
				sfx_move.playing = true
				currentLayer -= 1
				replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
				var i = 0
				for snack in replaceWithLabels:
					snack.text = ""
					if MainInfo.heldWeapons.size() >= i + 1: # 
						var snackeroo = SkillsItemsWeapons.weapons.get(MainInfo.heldWeapons[i + currentLayer * 2])
						var snack_name = snackeroo["name"]
						snack.text = snack_name.to_upper()
					i += 1
				if currentLayer != 0:
					up_arrow.visible = true
				else:
					up_arrow.visible = false
				if MainInfo.heldWeapons.size() > 6 + currentLayer * 2:
					down_arrow.visible = true
				else:
					down_arrow.visible = false
				showWeaponDesc()
			elif MainInfo.heldWeapons.size() <= 6:
				up_arrow.visible = false
				down_arrow.visible = false
			else:
				if MainInfo.heldWeapons.size() > 6 + currentLayer * 2:
					down_arrow.visible = true
		updateStats()
	elif selected_cursor == "selectCharm":
		if currently_selected == 2 || currently_selected == 3 || currently_selected == 4 || currently_selected == 5:
			currently_selected -= 2
			replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
			sfx_move.playing = true
			showCharmDesc()
			if currentLayer == 0:
				up_arrow.visible = false
			if MainInfo.heldCharms.size() > 6 + currentLayer * 2:
				down_arrow.visible = true
			else:
				down_arrow.visible = false
		elif currently_selected == 0 || currently_selected == 1:
			if currentLayer != 0:
				sfx_move.playing = true
				currentLayer -= 1
				replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
				var i = 0
				for snack in replaceWithLabels:
					snack.text = ""
					if MainInfo.heldCharms.size() >= i + 1: # 
						var snackeroo = SkillsItemsWeapons.charms.get(MainInfo.heldCharms[i + currentLayer * 2])
						var snack_name = snackeroo["name"]
						snack.text = snack_name.to_upper()
					i += 1
				if currentLayer != 0:
					up_arrow.visible = true
				else:
					up_arrow.visible = false
				if MainInfo.heldCharms.size() > 6 + currentLayer * 2:
					down_arrow.visible = true
				else:
					down_arrow.visible = false
				showCharmDesc()
			elif MainInfo.heldCharms.size() <= 6:
				up_arrow.visible = false
				down_arrow.visible = false
			else:
				if MainInfo.heldCharms.size() > 6 + currentLayer * 2:
					down_arrow.visible = true
		updateStats(false)
	elif selected_cursor == "selectReplaceSkill":
		var all_player_skills
		var current_player_skills
		if selected_player == "luke":
			current_player_skills = MainInfo.LukeMainSkills
			all_player_skills = MainInfo.lukeUnlockedSkills.duplicate(true)
		if selected_player == "brenna":
			current_player_skills = MainInfo.BrennaMainSkills
			all_player_skills = MainInfo.brennaUnlockedSkills.duplicate(true)
		for skill in current_player_skills:
			all_player_skills.erase(skill)
		if currently_selected == 2 || currently_selected == 3 || currently_selected == 4 || currently_selected == 5:
			currently_selected -= 2
			replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
			sfx_move.playing = true
			showSkillDesc()
			if currentLayer == 0:
				up_arrow.visible = false
			if all_player_skills.size() > 6 + currentLayer * 2:
				down_arrow.visible = true
			else:
				down_arrow.visible = false
		elif currently_selected == 0 || currently_selected == 1:
			if currentLayer != 0:
				sfx_move.playing = true
				currentLayer -= 1
				replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
				var i = 0
				for snack in replaceWithLabels:
					snack.text = ""
					if all_player_skills.size() >= i + 1: # 
						var snackeroo = SkillsItemsWeapons.skills.get(all_player_skills[i + currentLayer * 2])
						var snack_name = snackeroo["name"]
						snack.text = snack_name.to_upper()
					i += 1
				if currentLayer != 0:
					up_arrow.visible = true
				else:
					up_arrow.visible = false
				if all_player_skills.size() > 6 + currentLayer * 2:
					down_arrow.visible = true
				else:
					down_arrow.visible = false
				showSkillDesc()
			elif all_player_skills.size() <= 6:
				up_arrow.visible = false
				down_arrow.visible = false
			else:
				if all_player_skills.size() > 6 + currentLayer * 2:
					down_arrow.visible = true
	elif selected_cursor == "selectSkill":
		var skill_d
		if selected_player == "luke": skill_d = MainInfo.LukeMainSkills
		if selected_player == "brenna": skill_d = MainInfo.BrennaMainSkills
		sfx_move.playing = true
		currently_selected = (currently_selected - 1 + skill_d.size()) % skill_d.size()
		player_cursor.global_position = playerSkillMarkers[currently_selected].global_position
		showCurrentSkillDesc()
	elif selected_cursor == "selectItem":
		var items
		var all_item_dictionary = SkillsItemsWeapons.snacks
		all_item_dictionary.merge(SkillsItemsWeapons.toys, true)
		all_item_dictionary.merge(SkillsItemsWeapons.items, true)
		if selected_item_type == "snacks":
			items = MainInfo.heldSnacks
		elif selected_item_type == "toys":
			items = MainInfo.heldToys.duplicate()
			items.merge(MainInfo.heldItems, true)
		elif selected_item_type == "important":
			items = MainInfo.heldImportant
		if currently_selected == 1 || currently_selected == 2 || currently_selected == 3:
			currently_selected -= 1
			item_option_cursor.global_position = itemListMarkers[currently_selected].global_position
			sfx_move.playing = true
			showItemDesc()
			if currentLayer == 0:
				up_arrow_item.visible = false
			if items.size() > 4 + currentLayer:
				down_arrow_item.visible = true
			else:
				down_arrow_item.visible = false
		elif currently_selected == 0:
			if currentLayer != 0:
				sfx_move.playing = true
				currentLayer -= 1
				item_option_cursor.global_position = itemListMarkers[currently_selected].global_position
				var i: int = 0
				var keys = items.keys()
				for item in itemListLabels:
					item.text = ""
					itemHoldLabels[i].text = ""
					if items.size() >= i + 1 + currentLayer:
						var item_d = all_item_dictionary.get(keys[i + currentLayer])
						if item_d:
							var item_name = item_d["name"]
							var item_hold = items.get(keys[i + currentLayer])["hold"]
							itemHoldLabels[i].text = "x" + str(item_hold)
							item.text = item_name.to_upper()
					i += 1
				if currentLayer == 0:
					up_arrow_item.visible = false
				if items.size() > 4 + currentLayer:
					down_arrow_item.visible = true
				else:
					down_arrow_item.visible = false
				showItemDesc()
			elif items.size() <= 4:
				up_arrow_item.visible = false
				down_arrow_item.visible = false
			else:
				if items.size() > 4 + currentLayer:
					down_arrow_item.visible = true

func move_down():
	if selected_cursor == "selectEquip":
		sfx_move.playing = true
		currently_selected = (currently_selected + 1) % 2
		player_cursor.global_position = playerBottomMarkers[currently_selected].global_position
		if currently_selected == 0: showCurrentWeaponDesc()
		elif currently_selected == 1: showCurrentCharmDesc()
	elif selected_cursor == "selectWeapon":
		if currently_selected == 0 || currently_selected == 1 || currently_selected == 2 || currently_selected == 3:
			if MainInfo.heldWeapons.size() >= currently_selected + 3 + currentLayer * 2:
				currently_selected += 2
				replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
				sfx_move.playing = true
				showWeaponDesc()
		elif currently_selected == 4 || currently_selected == 5:
			if MainInfo.heldWeapons.size() > 6 + currentLayer * 2:
				sfx_move.playing = true
				up_arrow.visible = true
				currentLayer += 1
				if !MainInfo.heldWeapons.size() >= currently_selected + 1 + currentLayer * 2:
					currently_selected -= 2
				replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
				var i = 0
				for snack in replaceWithLabels:
					snack.text = ""
					if MainInfo.heldWeapons.size() >= i + currentLayer * 2:
						if MainInfo.heldWeapons.size() >= i + 1 + currentLayer * 2:
							var snackeroo = SkillsItemsWeapons.weapons.get(MainInfo.heldWeapons[i + currentLayer * 2])
							var snack_name = snackeroo["name"]
							snack.text = snack_name.to_upper()
						else:
							snack.text = ""
					i += 1
				if MainInfo.heldWeapons.size() > 6 + currentLayer * 2:
					down_arrow.visible = true
				else:
					down_arrow.visible = false
				showWeaponDesc()
			elif MainInfo.heldWeapons.size() <= 6:
				up_arrow.visible = false
				down_arrow.visible = false
		updateStats()
	elif selected_cursor == "selectCharm":
		if currently_selected == 0 || currently_selected == 1 || currently_selected == 2 || currently_selected == 3:
			if MainInfo.heldCharms.size() >= currently_selected + 3 + currentLayer * 2:
				currently_selected += 2
				replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
				sfx_move.playing = true
				showCharmDesc()
		elif currently_selected == 4 || currently_selected == 5:
			if MainInfo.heldCharms.size() > 6 + currentLayer * 2:
				sfx_move.playing = true
				up_arrow.visible = true
				currentLayer += 1
				if !MainInfo.heldCharms.size() >= currently_selected + 1 + currentLayer * 2:
					currently_selected -= 2
				replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
				var i = 0
				for snack in replaceWithLabels:
					snack.text = ""
					if MainInfo.heldCharms.size() >= i + currentLayer * 2:
						if MainInfo.heldCharms.size() >= i + 1 + currentLayer * 2:
							var snackeroo = SkillsItemsWeapons.charms.get(MainInfo.heldCharms[i + currentLayer * 2])
							var snack_name = snackeroo["name"]
							snack.text = snack_name.to_upper()
						else:
							snack.text = ""
					i += 1
				if MainInfo.heldCharms.size() > 6 + currentLayer * 2:
					down_arrow.visible = true
				else:
					down_arrow.visible = false
				showCharmDesc()
			elif MainInfo.heldCharms.size() <= 6:
				up_arrow.visible = false
				down_arrow.visible = false
		updateStats(false)
	elif selected_cursor == "selectReplaceSkill":
		var all_player_skills
		var current_player_skills
		if selected_player == "luke":
			current_player_skills = MainInfo.LukeMainSkills
			all_player_skills = MainInfo.lukeUnlockedSkills.duplicate(true)
		if selected_player == "brenna":
			current_player_skills = MainInfo.BrennaMainSkills
			all_player_skills = MainInfo.brennaUnlockedSkills.duplicate(true)
		for skill in current_player_skills:
			all_player_skills.erase(skill)
		if currently_selected == 0 || currently_selected == 1 || currently_selected == 2 || currently_selected == 3:
			if all_player_skills.size() >= currently_selected + 3 + currentLayer * 2:
				currently_selected += 2
				replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
				sfx_move.playing = true
				showSkillDesc()
		elif currently_selected == 4 || currently_selected == 5:
			if all_player_skills.size() > 6 + currentLayer * 2:
				sfx_move.playing = true
				up_arrow.visible = true
				currentLayer += 1
				if !all_player_skills.size() >= currently_selected + 1 + currentLayer * 2:
					currently_selected -= 2
				replace_with_cursor.global_position = replaceWithOptions[currently_selected].global_position
				var i = 0
				for snack in replaceWithLabels:
					snack.text = ""
					if all_player_skills.size() >= i + currentLayer * 2:
						if all_player_skills.size() >= i + 1 + currentLayer * 2:
							var snackeroo = SkillsItemsWeapons.skills.get(all_player_skills[i + currentLayer * 2])
							var snack_name = snackeroo["name"]
							snack.text = snack_name.to_upper()
						else:
							snack.text = ""
					i += 1
				if all_player_skills.size() > 6 + currentLayer * 2:
					down_arrow.visible = true
				else:
					down_arrow.visible = false
				showSkillDesc()
			elif all_player_skills.size() <= 6:
				up_arrow.visible = false
				down_arrow.visible = false
	elif selected_cursor == "selectSkill":
		var skill_d
		if selected_player == "luke": skill_d = MainInfo.LukeMainSkills
		if selected_player == "brenna": skill_d = MainInfo.BrennaMainSkills
		sfx_move.playing = true
		currently_selected = (currently_selected + 1) % skill_d.size()
		player_cursor.global_position = playerSkillMarkers[currently_selected].global_position
		showCurrentSkillDesc()
	elif selected_cursor == "selectItem":
		var items
		var all_item_dictionary = SkillsItemsWeapons.snacks
		all_item_dictionary.merge(SkillsItemsWeapons.toys, true)
		all_item_dictionary.merge(SkillsItemsWeapons.items, true)
		if selected_item_type == "snacks":
			items = MainInfo.heldSnacks
		elif selected_item_type == "toys":
			items = MainInfo.heldToys.duplicate()
			items.merge(MainInfo.heldItems, true)
		elif selected_item_type == "important":
			items = MainInfo.heldImportant
		if currently_selected == 0 || currently_selected == 1 || currently_selected == 2:
			if items.size() >= currently_selected + 2 + currentLayer:
				currently_selected += 1
				item_option_cursor.global_position = itemListMarkers[currently_selected].global_position
				sfx_move.playing = true
				showItemDesc()
				if currentLayer == 0:
					up_arrow_item.visible = false
				if items.size() > 4 + currentLayer:
					down_arrow_item.visible = true
				else:
					down_arrow_item.visible = false
		elif currently_selected == 3:
			if items.size() > 4 + currentLayer:
				sfx_move.playing = true
				currentLayer += 1
				up_arrow_item.visible = true
				item_option_cursor.global_position = itemListMarkers[currently_selected].global_position
				var i: int = 0
				var keys = items.keys()
				for item in itemListLabels:
					item.text = ""
					itemHoldLabels[i].text = ""
					if items.size() >= i + 1 + currentLayer:
						var item_d = all_item_dictionary.get(keys[i + currentLayer])
						if item_d:
							var item_name = item_d["name"]
							var item_hold = items.get(keys[i + currentLayer])["hold"]
							itemHoldLabels[i].text = "x" + str(item_hold)
							item.text = item_name.to_upper()
					i += 1
				if items.size() > 4 + currentLayer:
					down_arrow_item.visible = true
				else:
					down_arrow_item.visible = false
				showItemDesc()
			elif items.size() <= 4:
				up_arrow_item.visible = false
				down_arrow_item.visible = false
			else:
				if items.size() > 4 + currentLayer:
					down_arrow_item.visible = true

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
