extends Control

@export var music: AudioStream
@export var background_texture: Texture2D
@onready var background: TextureRect = $Background
@onready var right_bg: TextureRect = $RightBg
@onready var left_bg: TextureRect = $LeftBg
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var screen_shake: AnimationPlayer = $ScreenShake
@onready var fight_button: TextureRect = $Fight
@onready var run_button: TextureRect = $Run
@onready var attack_button: TextureRect = $Attack
@onready var skill_button: TextureRect = $Skill
@onready var snack_button: TextureRect = $Snack
@onready var toy_button: TextureRect = $Toy
@onready var sfx_select: AudioStreamPlayer = $Select
@onready var sfx_move: AudioStreamPlayer = $Move
@onready var sfx_cancel: AudioStreamPlayer = $Cancel
@onready var sfx_buzzer: AudioStreamPlayer = $Buzzer
@onready var sfx_levelUp: AudioStreamPlayer = $LevelUp
@onready var dialog_box_text: Label = $DialogBox/Container/Text
@onready var energy_bar: TextureRect = $EnergyBar
@onready var energy_bar_top_marker: Marker2D = $EnergyBarUp
@onready var moving_energy_orbs: TextureRect = $EnergyBar/MovingEnergyOrbs
@onready var energy_amount: Label = $EnergyBar/Amount
@onready var line_1: Label = $DialogBox/Container/Line1
@onready var line_2: Label = $DialogBox/Container/Line2
@onready var line_3: Label = $DialogBox/Container/Line3
@onready var line_4: Label = $DialogBox/Container/Line4
@onready var line_5: Label = $DialogBox/Container/Line5
@onready var option_1: Label = $ActionBox/Option1
@onready var option_2: Label = $ActionBox/Option2
@onready var option_3: Label = $ActionBox/Option3
@onready var option_4: Label = $ActionBox/Option4
@onready var foe_box: HBoxContainer = $FoeBox
@onready var foes = $FoeBox.get_children()
@onready var fight_marker: Marker2D = $FightMarker
@onready var run_marker: Marker2D = $RunMarker
@onready var top_left_marker: Marker2D = $Attack/TopLeftMarker
@onready var top_right_marker: Marker2D = $Skill/TopRightMarker
@onready var bottom_left_marker: Marker2D = $Snack/BottomLeftMarker
@onready var bottom_right_marker: Marker2D = $Toy/BottomRightMarker
@onready var marker1_choice: Marker2D = $"ActionBox/1MarkerChoice"
@onready var marker2_choice: Marker2D = $"ActionBox/2MarkerChoice"
@onready var marker3_choice: Marker2D = $"ActionBox/3MarkerChoice"
@onready var marker4_choice: Marker2D = $"ActionBox/4MarkerChoice"
@onready var action_cursor: Sprite2D = $ActionCursor
@onready var choice_cursor: Sprite2D = $ActionBox/ChoiceCursor
@onready var hold_cost: Label = $ActionBox/HoldCost
@onready var cost_amount: Label = $ActionBox/CostAmount
@onready var item_name: Label = $DialogBox/Container/ItemName
@onready var item_description: Label = $DialogBox/Container/ItemDescription
@onready var item_description_toy_snack: Label = $DialogBox/Container/ItemDescriptionToySnack
@onready var toy_snack_image: TextureRect = $DialogBox/Container/ToySnackImage
@onready var up_arrow: TextureRect = $ActionBox/Up
@onready var down_arrow: TextureRect = $ActionBox/Down
@onready var luke: Node2D = $Luke
@onready var brenna: Node2D = $Brenna
@onready var cost_icon: TextureRect = $ActionBox/CostAmount/CostIcon
@onready var sfx_attack: AudioStreamPlayer = $AttackSfx
const WIN_MUSIC = preload("res://audio/battle/010 - So, How_d We Do.mp3")
const LOSE_MUSIC = preload("res://audio/battle/011 - It_s Okay To Try Again....mp3")
var fight_run_buttons: Array = []
var action_buttons: Array = []
var choice_buttons: Array = []
const RED_POINTER_RIGHT = preload("res://ui/redPointerRight.png")
const GRAY_POINTER_RIGHT = preload("res://ui/grayPointerRight.png")
const BOUNCE_SIDEWAYS = preload("res://shaders/bounce_sideways.gdshader")
var alivePlayers: Array = []
var players: Array = []
var selectedPlayer
var isFighting: bool = false
@export var currentlyInBattle: bool = false
@onready var attackAnimations: AnimatedSprite2D = $AnimatedSprite2D
var selected_cursor: String = "fightRun"
var previous_cursor: String = "none"
var luke_skills
var brenna_skills
var luke_last_slot: int = 0
var brenna_last_slot: int = 0
var luke_last_layer: int = 0
var brenna_last_layer: int = 0
var luke_turn_over: bool = false
var brenna_turn_over: bool = false
const total_first_buttons: int = 2
const total_second_buttons: int = 4
var currently_selected: int = 0
var selected_button: String = "fight"
var selected_player: int = 1
var choosing_friend_foe: bool = false # true = friend, false = foe
var showRewards: bool = false
var xp_reward: int = 0
var chips_reward: int = 0
var awarded_items: Array = []
var energy: int = 3
var playersLeveledUp: Array = []
var prev_luke_level
var prev_brenna_level
var canPressAgain: bool = true
var currentLayer: int = 0
var currentLayerToy: int = 0
var delete_snacks: Array = []
var delete_toys: Array = []
var luke_fup_active: bool = false
var brenna_fup_active: bool = false
var begin_dialog: String = "begin"
@onready var screen_animation: AnimationPlayer = $ScreenAnimation


var can_run: bool = true

func _ready() -> void:
	attackAnimations.visible = false
	AutoplayMusic.checkMusic(music)
	
	gray_out_cursor(null, action_cursor)
	
	background.texture = background_texture
	right_bg.texture = background_texture
	left_bg.texture = background_texture
	
	MainInfo.LukeStatsPreBattle = MainInfo.LukeStats.duplicate(true)
	MainInfo.BrennaStatsPreBattle = MainInfo.BrennaStats.duplicate(true)
	MainInfo.heldSnacksPreBattle = MainInfo.heldSnacks.duplicate(true)
	MainInfo.heldToysPreBattle = MainInfo.heldToys.duplicate(true)
	
	luke.animation.play("unhighlight")
	brenna.animation.play("unhighlight")
	
	luke_skills = MainInfo.LukeMainSkills
	brenna_skills = MainInfo.BrennaMainSkills
	
	fight_run_buttons = [fight_marker,run_marker]
	action_buttons = [top_left_marker, top_right_marker, bottom_left_marker, bottom_right_marker]
	choice_buttons = [marker1_choice, marker2_choice, marker3_choice, marker4_choice]
	action_cursor.global_position = fight_run_buttons[currently_selected].global_position
	
	showFightOrRun()
	for foe in foes:
		foe.attackAnimation.visible = false
	for player in alivePlayers:
		player.attackAnimation.visible = false
	energy_bar.position = energy_bar_top_marker.position
	if Logic.brennaInParty():
		alivePlayers = [luke, brenna]
		players = [luke, brenna]
		luke.visible = true
		brenna.visible = true
		begin_dialog = "begin"
		dialog_box_text.text = Dialog.battle.get(begin_dialog)
	else:
		alivePlayers = [luke]
		players = [luke]
		luke.visible = true
		brenna.visible = false
		begin_dialog = "begin_luke"
		dialog_box_text.text = Dialog.battle.get(begin_dialog)
	resetLines()

func showFightOrRun():
	fight_button.visible = true
	run_button.visible = true
	attack_button.visible = false
	skill_button.visible = false
	snack_button.visible = false
	toy_button.visible = false
	#energy_bar.position = energy_bar_top_marker.position
	
func showActions():
	fight_button.visible = false
	run_button.visible = false
	attack_button.visible = true
	skill_button.visible = true
	snack_button.visible = true
	toy_button.visible = true
	#energy_bar.position = energy_bar_top_marker.position

func _process(delta: float) -> void:
	if luke_fup_active == true:
		if Input.is_action_just_pressed("right"):
			luke_fup_active = false
	if Input.is_action_just_pressed("z"):
		if showRewards:
			var dialog_text = []
			if canPressAgain:
				if currently_selected == 0:
					if playersLeveledUp.has("Luke"):
						canPressAgain = false
						var stats = MainInfo.LukeStats
						var levels_dict = Logic.luke_levels
						var new_luke_level = stats["level"]
						dialog_text.append(Dialog.battle["levelUp"].replace("/p", "LUKE").replace("/l", str(new_luke_level)))
						var level_stats = levels_dict.get(new_luke_level)
						if level_stats == null:
							var max_level = levels_dict.keys().max()
							level_stats = levels_dict[max_level]
						var main_skills = MainInfo.LukeMainSkills
						var unlocked_skills = MainInfo.lukeUnlockedSkills

						stats["maxHeart"] = level_stats["maxHeart"]
						stats["currentHeart"] += level_stats["maxHeart"] - stats["maxHeart"]
						stats["maxJuice"] = level_stats["maxJuice"]
						stats["currentJuice"] += level_stats["maxJuice"] - stats["maxJuice"]
						stats["attack"] = level_stats["attack"]
						stats["defense"] = level_stats["defense"]
						stats["speed"] = level_stats["speed"]

						var i: int = 1
						for level in levels_dict.keys():
							var level_rewards = Logic.luke_levels.get(level)
							level = int(level)
							if prev_luke_level < level and level <= new_luke_level:
								var new_skill = level_rewards["new_skill"] if level_rewards.has("new_skill") else null
								if new_skill:
									if !unlocked_skills.has(new_skill) || !main_skills.has(new_skill):
										if main_skills.size() < 4:
											main_skills.append(new_skill)
										else:
											unlocked_skills.append(new_skill)
										dialog_text.append(Dialog.battle["learnSkill"].replace("/s", new_skill.to_upper()))
							i += 1

						await displayTextSound(dialog_text, sfx_levelUp)
						canPressAgain = true
						currently_selected += 1
					elif playersLeveledUp.has("Brenna"):
						canPressAgain = false
						var stats = MainInfo.BrennaStats
						var levels_dict = Logic.brenna_levels
						var new_brenna_level = stats["level"]
						dialog_text.append(Dialog.battle["levelUp"].replace("/p", "BRENNA").replace("/l", str(new_brenna_level)))
						var level_stats = levels_dict.get(new_brenna_level)
						if level_stats == null:
							var max_level = levels_dict.keys().max()
							level_stats = levels_dict[max_level]
						var main_skills = MainInfo.BrennaMainSkills
						var unlocked_skills = MainInfo.brennaUnlockedSkills

						stats["maxHeart"] = level_stats["maxHeart"]
						stats["currentHeart"] += level_stats["maxHeart"] - stats["maxHeart"]
						stats["maxJuice"] = level_stats["maxJuice"]
						stats["currentJuice"] += level_stats["maxJuice"] - stats["maxJuice"]
						stats["attack"] = level_stats["attack"]
						stats["defense"] = level_stats["defense"]
						stats["speed"] = level_stats["speed"]

						for level in levels_dict.keys():
							level = int(level)
							var level_rewards = Logic.luke_levels.get(level)
							if prev_brenna_level < level and level <= new_brenna_level:
								var new_skill = level_rewards["new_skill"] if level_rewards.has("new_skill") else null
								if new_skill:
									if !unlocked_skills.has(new_skill) || !main_skills.has(new_skill):
										if main_skills.size() < 4:
											main_skills.append(new_skill)
										else:
											unlocked_skills.append(new_skill)
										dialog_text.append(Dialog.battle["learnSkill"].replace("/s", new_skill.to_upper()))

						await displayTextSound(dialog_text, sfx_levelUp)
						canPressAgain = true
						currently_selected += 1
					elif playersLeveledUp.is_empty():
						call_deferred("change_scene_win")
				elif currently_selected == playersLeveledUp.size():
					call_deferred("change_scene_win")
				elif currently_selected == playersLeveledUp.size() - 1:
					if playersLeveledUp.has("Brenna"):
						canPressAgain = false
						var stats = MainInfo.BrennaStats
						var levels_dict = Logic.brenna_levels
						var new_brenna_level = stats["level"]
						dialog_text.append(Dialog.battle["levelUp"].replace("/p", "BRENNA").replace("/l", str(new_brenna_level)))
						var level_stats = levels_dict.get(new_brenna_level)
						if level_stats == null:
							var max_level = levels_dict.keys().max()
							level_stats = levels_dict[max_level]
						var main_skills = MainInfo.BrennaMainSkills
						var unlocked_skills = MainInfo.brennaUnlockedSkills

						stats["maxHeart"] = level_stats["maxHeart"]
						stats["currentHeart"] += level_stats["maxHeart"] - stats["maxHeart"]
						stats["maxJuice"] = level_stats["maxJuice"]
						stats["currentJuice"] += level_stats["maxJuice"] - stats["maxJuice"]
						stats["attack"] = level_stats["attack"]
						stats["defense"] = level_stats["defense"]
						stats["speed"] = level_stats["speed"]

						for level in levels_dict.keys():
							level = int(level)
							var level_rewards = Logic.luke_levels.get(level)
							if prev_brenna_level < level and level <= new_brenna_level:
								var new_skill = level_rewards["new_skill"] if level_rewards.has("new_skill") else null
								if new_skill:
									if !unlocked_skills.has(new_skill) || !main_skills.has(new_skill):
										if main_skills.size() < 4:
											main_skills.append(new_skill)
										else:
											unlocked_skills.append(new_skill)
										dialog_text.append(Dialog.battle["learnSkill"].replace("/s", new_skill.to_upper()))

						await displayTextSound(dialog_text, sfx_levelUp)
						canPressAgain = true
						currently_selected += 1

	if !currentlyInBattle: return
	if isFighting: return
	if Input.is_action_just_pressed("switch_sides"):
		choosing_friend_foe = !choosing_friend_foe
		if selected_cursor == "selectEither":
			sfx_move.playing = true
			if choosing_friend_foe:
				for foe in foes:
					foe.hp_frame.visible = false
				currently_selected = 0
				if currently_selected == 0:
					luke.animation.play("highlighted")
					brenna.animation.play("unhighlight")
			if !choosing_friend_foe:
				luke.animation.play("unhighlight")
				brenna.animation.play("unhighlight")
				currently_selected = 0
				for foe in foes:
					foe.hp_frame.visible = false
				foes[currently_selected].hp_frame.visible = true
			if selected_player == 1:
				luke.friend_foe = choosing_friend_foe
				luke.target = foes[currently_selected] if !choosing_friend_foe else alivePlayers[currently_selected]
			elif selected_player == 2:
				brenna.friend_foe = choosing_friend_foe
				brenna.target = foes[currently_selected] if !choosing_friend_foe else alivePlayers[currently_selected]
	if Input.is_action_just_pressed("up"):
		move_up()
	if Input.is_action_just_pressed("down"):
		move_down()
	if Input.is_action_just_pressed("right"):
		move_right()
	if Input.is_action_just_pressed("left"):
		move_left()
	if Input.is_action_just_pressed("z"):
		if selected_cursor == "fightRun":
			if currently_selected == 0:
				lastPlayerAction()
				action_cursor.global_position = action_buttons[currently_selected].global_position
				showActions()
				previous_cursor = selected_cursor
				selected_cursor = "selectAction"
				sfx_select.playing = true
				luke.animation.play("highlighted")
				dialog_box_text.text = Dialog.battle.get("selected").replace("/p", "LUKE" if selected_player == 1 else "BRENNA")
			elif currently_selected == 1:
				if can_run:
					sfx_select.playing = true
					var foe_speed = 0
					var player_speed = 0
					for foe in foes:
						foe_speed += foe.speed
					for plyer in alivePlayers:
						player_speed += plyer.speed
					if randf() < (0.65 * player_speed / foe_speed):
						screen_animation.play("run")
						await screen_animation.animation_finished
						update_stats()
						MainInfo.enemyEncountered = null
						get_tree().change_scene_to_file(MainInfo.last_scene_path)
					else:
						initiateBattle(false)
						action_cursor.visible = false
						animation.play("hideEnergyBar")
						isFighting = true
				else:
					sfx_buzzer.playing = true
		elif selected_cursor == "selectAction":
			match currently_selected:
				0: # attack
					sfx_select.playing = true
					previous_cursor = selected_cursor
					selected_cursor = "selectFoe"
					if selected_player == 1:
						luke.action = "attack"
					elif selected_player == 2:
						brenna.action = "attack"
					gray_out_cursor(action_cursor, null)
					#dialog_box_text.text = Dialog.battle.get("useOn")
					dialogTextVisible()
					for foe in foes:
						foe.hp_frame.visible = false
					foes[currently_selected].hp_frame.visible = true
					if selected_player == 1:
						luke.target = foes[currently_selected]
					elif selected_player == 2:
						brenna.target = foes[currently_selected]
				1:
					sfx_select.playing = true
					currently_selected = 0
					previous_cursor = selected_cursor
					selected_cursor = "selectSkill"
					up_arrow.visible = false
					down_arrow.visible = false
					choice_cursor.global_position = choice_buttons[currently_selected].global_position
					var skills2 = [option_1, option_2, option_3, option_4]
					var player_skills
					if selected_player == 1:
						player_skills = luke_skills
						luke.action = "skill"
					if selected_player == 2:
						player_skills = brenna_skills
						brenna.action = "skill"
					var i = 0
					for skill in skills2:
						if player_skills.size() > i:
							skill.text = player_skills[i]
						else:
							skill.text = "-------------"
						i += 1
					hold_cost.text = "COST:"
					checkCost()
					selectActionButton("skill")
				2:
					if MainInfo.heldSnacks.size() > 0:
						sfx_select.playing = true
						currentLayer = 0
						currently_selected = 0
						previous_cursor = selected_cursor
						selected_cursor = "selectSnack"
						choice_cursor.global_position = choice_buttons[currently_selected].global_position
						var skills2 = [option_1, option_2, option_3, option_4]
						var snacks = MainInfo.heldSnacks
						var i = 0
						for snack in skills2:
							if MainInfo.heldSnacks.size() >= i + 1:
								var snackeroo = SkillsItemsWeapons.snacks.get(snacks.keys()[i + currentLayer * 2])
								var snack_name = snackeroo["name"]
								snack.text = snack_name.to_upper()
							else:
								snack.text = ""
							i += 1
						if MainInfo.heldSnacks.size() > 4 + currentLayer * 2:
							down_arrow.visible = true
						else:
							down_arrow.visible = false
						toySnackTextVisible()
						selectActionButton("snack")
						checkHold()
					else:
						sfx_buzzer.playing = true
				3:
					if MainInfo.heldToys.size() > 0:
						sfx_select.playing = true
						currentLayerToy = 0
						currently_selected = 0
						previous_cursor = selected_cursor
						selected_cursor = "selectToy"
						choice_cursor.global_position = choice_buttons[currently_selected].global_position
						var skills2 = [option_1, option_2, option_3, option_4]
						var snacks = MainInfo.heldToys
						var i = 0
						for snack in skills2:
							if MainInfo.heldToys.size() >= i + 1:
								var snackeroo = SkillsItemsWeapons.toys.get(snacks.keys()[i + currentLayerToy * 2])
								var snack_name = snackeroo["name"]
								snack.text = snack_name.to_upper()
							else:
								snack.text = ""
							i += 1
						if MainInfo.heldToys.size() > 4 + currentLayerToy * 2:
							down_arrow.visible = true
						else:
							down_arrow.visible = false
						toySnackTextVisible()
						selectActionButton("toy")
						checkHold()
					else:
						sfx_buzzer.playing = true
		elif selected_cursor == "selectSkill" || selected_cursor == "selectSnack" || selected_cursor == "selectToy":
			if selected_player == 1:
				if luke.action == "skill":
					handle_skill_use(luke, luke.action, luke_skills, luke.slot, luke.target)
				if luke.action == "snack":
					handle_snack_use(luke.action, luke.slot, luke.target)
				if luke.action == "toy":
					handle_toy_use(luke.action, luke.slot, luke.target)
			elif selected_player == 2:
				if brenna.action == "skill":
					handle_skill_use(brenna, brenna.action, brenna_skills, brenna.slot, brenna.target)
				if brenna.action == "snack":
					handle_snack_use(brenna.action, brenna.slot, brenna.target)
				if brenna.action == "toy":
					handle_toy_use(brenna.action, brenna.slot, brenna.target)
		elif selected_cursor == "selectFoe" || "selectFriend":
			currently_selected = 0
			sfx_select.playing = true
			dialog_box_text.text = Dialog.battle.get("useOn")
			dialogTextVisible()
			turnOver()
		elif selected_cursor == "selectEither":
			currently_selected = 0
			sfx_select.playing = true
			dialog_box_text.text = Dialog.battle.get("useOnBoth")
			dialogTextVisible()
			turnOver()
			
	if Input.is_action_just_pressed("x"):
		if selected_cursor == "selectAction":
			if selected_player == 1:
				dialog_box_text.text = Dialog.battle.get(begin_dialog)
				selected_cursor = "fightRun"
				currently_selected = 0
				action_cursor.global_position = fight_run_buttons[currently_selected].global_position
				showFightOrRun()
				sfx_cancel.playing = true
			elif selected_player == 2:
				selected_player = 1
				currently_selected = luke_last_slot
				sfx_cancel.playing = true
				if luke.action == "skill":
					choice_cursor.global_position = choice_buttons[currently_selected].global_position
					var skills2 = [option_1, option_2, option_3, option_4]
					var player_skills
					if selected_player == 1:
						player_skills = luke_skills
					if selected_player == 2:
						player_skills = brenna_skills
					var i = 0
					for skill in skills2:
						if player_skills.size() > i:
							skill.text = player_skills[i]
						else:
							skill.text = "-------------"
						i += 1
					hold_cost.text = "COST:"
					checkCost()
					animation.play("displayActionBox")
					selected_cursor = "selectSkill"
					up_arrow.visible = false
					down_arrow.visible = false
					gray_out_cursor(action_cursor, choice_cursor)
				elif luke.action == "snack":
					choice_cursor.global_position = choice_buttons[currently_selected].global_position
					var snack_list = [option_1, option_2, option_3, option_4]
					var snacks = MainInfo.heldSnacks
					var i = 0
					currentLayer = luke_last_layer
					for snack in snack_list:
						snack.text = ""
						if MainInfo.heldSnacks.size() >= i + currentLayer * 2:
							if snacks.size() >= i + 1 + currentLayer * 2:
								var snackeroo = SkillsItemsWeapons.snacks.get(snacks.keys()[i + currentLayer * 2])
								var snack_name = snackeroo["name"]
								snack.text = snack_name.to_upper()
							else:
								snack.text = ""
						i += 1
					if MainInfo.heldSnacks.size() > 4 + currentLayer * 2:
						down_arrow.visible = true
					else:
						down_arrow.visible = false
					if currentLayer != 0:
						up_arrow.visible = true
					else:
						up_arrow.visible = false
					checkHold()
					animation.play("displayActionBox")
					selected_cursor = "selectSnack"
					gray_out_cursor(action_cursor, choice_cursor)
				elif luke.action == "toy":
					choice_cursor.global_position = choice_buttons[currently_selected].global_position
					var toy_list = [option_1, option_2, option_3, option_4]
					var toys = MainInfo.heldToys
					var i = 0
					currentLayerToy = luke_last_layer
					for toy in toy_list:
						toy.text = ""
						if MainInfo.heldToys.size() >= i + currentLayerToy * 2:
							if toys.size() >= i + 1 + currentLayerToy * 2:
								var snackeroo = SkillsItemsWeapons.toys.get(toys.keys()[i + currentLayerToy * 2])
								var snack_name = snackeroo["name"]
								toy.text = snack_name.to_upper()
							else:
								toy.text = ""
						i += 1
					if toys.size() > 4 + currentLayerToy * 2:
						down_arrow.visible = true
					else:
						down_arrow.visible = false
					if currentLayerToy != 0:
						up_arrow.visible = true
					else:
						up_arrow.visible = false
					checkHold()
					animation.play("displayActionBox")
					selected_cursor = "selectToy"
					gray_out_cursor(action_cursor, choice_cursor)
				elif luke.action == "attack":
					dialog_box_text.text = Dialog.battle.get("selected").replace("/p", "LUKE" if selected_player == 1 else "BRENNA")
					lastPlayerAction()
					selected_cursor = "selectAction"
					action_cursor.global_position = action_buttons[currently_selected].global_position
					gray_out_cursor(choice_cursor, action_cursor)
					
				luke.animation.play("highlighted")
				brenna.animation.play("unhighlight")
		elif selected_cursor == "selectSkill" || selected_cursor == "selectSnack" || selected_cursor == "selectToy":
			dialog_box_text.text = Dialog.battle.get("selected").replace("/p", "LUKE" if selected_player == 1 else "BRENNA")
			selected_cursor = "selectAction"
			lastPlayerAction()
			action_cursor.global_position = action_buttons[currently_selected].global_position
			showActions()
			animation.play("hideActionBox")
			dialogTextVisible()
			gray_out_cursor(choice_cursor, action_cursor)
			sfx_cancel.playing = true
		elif selected_cursor == "selectFoe":
			for foe in foes:
				foe.hp_frame.visible = false
			if selected_player == 1:
				luke.animation.play("highlighted")
				brenna.animation.play("unhighlight")
			if selected_player == 2:
				luke.animation.play("unhighlight")
				brenna.animation.play("highlighted")
			if previous_cursor == "selectAction":
				dialog_box_text.text = Dialog.battle.get("selected").replace("/p", "LUKE" if selected_player == 1 else "BRENNA")
				selected_cursor = "selectAction"
				lastPlayerAction()
				action_cursor.global_position = action_buttons[currently_selected].global_position
				showActions()
				dialogTextVisible()
				gray_out_cursor(null, action_cursor)
				sfx_cancel.playing = true
			elif previous_cursor == "selectSkill":
				selected_cursor = "selectSkill"
				if selected_player == 1:
					currently_selected = luke_last_slot
				elif selected_player == 2:
					currently_selected = brenna_last_slot
				choice_cursor.global_position = choice_buttons[currently_selected].global_position
				infoTextVisible()
				gray_out_cursor(action_cursor, choice_cursor)
				sfx_cancel.playing = true
			elif previous_cursor == "selectToy":
				selected_cursor = "selectToy"
				if selected_player == 1:
					currently_selected = luke_last_slot
				elif selected_player == 2:
					currently_selected = brenna_last_slot
				choice_cursor.global_position = choice_buttons[currently_selected].global_position
				toySnackTextVisible()
				checkHold()
				gray_out_cursor(action_cursor, choice_cursor)
				sfx_cancel.playing = true
		elif selected_cursor == "selectFriend":
			if selected_player == 1:
				luke.animation.play("highlighted")
				brenna.animation.play("unhighlight")
			if selected_player == 2:
				luke.animation.play("unhighlight")
				brenna.animation.play("highlighted")
			if previous_cursor == "selectAction":
				dialog_box_text.text = Dialog.battle.get("selected").replace("/p", "LUKE" if selected_player == 1 else "BRENNA")
				selected_cursor = "selectAction"
				lastPlayerAction()
				action_cursor.global_position = action_buttons[currently_selected].global_position
				showActions()
				dialogTextVisible()
				gray_out_cursor(null, action_cursor)
				sfx_cancel.playing = true
			elif previous_cursor == "selectSkill":
				selected_cursor = "selectSkill"
				if selected_player == 1:
					currently_selected = luke_last_slot
				elif selected_player == 2:
					currently_selected = brenna_last_slot
				choice_cursor.global_position = choice_buttons[currently_selected].global_position
				infoTextVisible()
				gray_out_cursor(action_cursor, choice_cursor)
				sfx_cancel.playing = true
			elif previous_cursor == "selectSnack":
				selected_cursor = "selectSnack"
				if selected_player == 1:
					currently_selected = luke_last_slot
				elif selected_player == 2:
					currently_selected = brenna_last_slot
				choice_cursor.global_position = choice_buttons[currently_selected].global_position
				toySnackTextVisible()
				checkHold()
				gray_out_cursor(action_cursor, choice_cursor)
				sfx_cancel.playing = true
			elif previous_cursor == "selectToy":
				selected_cursor = "selectToy"
				if selected_player == 1:
					currently_selected = luke_last_slot
				elif selected_player == 2:
					currently_selected = brenna_last_slot
				choice_cursor.global_position = choice_buttons[currently_selected].global_position
				toySnackTextVisible()
				checkHold()
				gray_out_cursor(action_cursor, choice_cursor)
				sfx_cancel.playing = true
		elif selected_cursor == "selectEither":
			for foe in foes:
				foe.hp_frame.visible = false
			if selected_player == 1:
				luke.animation.play("highlighted")
				brenna.animation.play("unhighlight")
			if selected_player == 2:
				luke.animation.play("unhighlight")
				brenna.animation.play("highlighted")
			if previous_cursor == "selectAction":
				dialog_box_text.text = Dialog.battle.get("selected").replace("/p", "LUKE" if selected_player == 1 else "BRENNA")
				selected_cursor = "selectAction"
				lastPlayerAction()
				action_cursor.global_position = action_buttons[currently_selected].global_position
				showActions()
				dialogTextVisible()
				gray_out_cursor(null, action_cursor)
				sfx_cancel.playing = true
			elif previous_cursor == "selectSkill":
				selected_cursor = "selectSkill"
				if selected_player == 1:
					currently_selected = luke_last_slot
				elif selected_player == 2:
					currently_selected = brenna_last_slot
				choice_cursor.global_position = choice_buttons[currently_selected].global_position
				infoTextVisible()
				gray_out_cursor(action_cursor, choice_cursor)
				sfx_cancel.playing = true
			elif previous_cursor == "selectToy":
				selected_cursor = "selectToy"
				if selected_player == 1:
					currently_selected = luke_last_slot
				elif selected_player == 2:
					currently_selected = brenna_last_slot
				choice_cursor.global_position = choice_buttons[currently_selected].global_position
				toySnackTextVisible()
				checkHold()
				gray_out_cursor(action_cursor, choice_cursor)
				sfx_cancel.playing = true

func handle_skill_use(selected_character, action, skills, slot, target):
	if action != "skill": return
	else:
		var skill_list = [option_1, option_2, option_3, option_4]
		if skill_list[currently_selected].text == "-------------": return
		var skill_dictionary = SkillsItemsWeapons.skills.get(skills[currently_selected])
		if skill_dictionary["name"] == "-------------": return
		if selected_character.juice >= skill_dictionary["cost"]:
			if selected_player == 1:
				luke_last_slot = currently_selected
			elif selected_player == 2:
				brenna_last_slot = currently_selected
			sfx_select.playing = true
			previous_cursor = "selectSkill"
			currently_selected = 0
			slot = skill_dictionary
			dialogTextVisible()
			gray_out_cursor(choice_cursor, null)
			match skill_dictionary["useableOn"]:
				"foe":
					target = foes[currently_selected]
					selected_cursor = "selectFoe"
					dialog_box_text.text = Dialog.battle.get("useOn")
					for foe in foes:
						foe.hp_frame.visible = false
					foes[currently_selected].hp_frame.visible = true
					luke.animation.play("unhighlight")
					brenna.animation.play("unhighlight")
				"both":
					selected_cursor = "selectEither"
					dialog_box_text.text = Dialog.battle.get("useOnBoth")
					choosing_friend_foe = false
					target = foes[currently_selected]
					for foe in foes:
						foe.hp_frame.visible = false
					foes[currently_selected].hp_frame.visible = true
					luke.animation.play("unhighlight")
					brenna.animation.play("unhighlight")
				"friend":
					target = alivePlayers[currently_selected]
					selected_cursor = "selectFriend"
					luke.animation.play("highlighted")
					brenna.animation.play("unhighlight")
					dialog_box_text.text = Dialog.battle.get("useOn")
				"self", "none":
					target = translateToPlayer(selected_player)
					if selected_player == 1:
						luke.target = target
						luke.slot = slot
					elif selected_player == 2:
						brenna.target = target
						brenna.slot = slot
					turnOver()
			if selected_player == 1:
				luke.target = target
				luke.slot = slot
			elif selected_player == 2:
				brenna.target = target
				brenna.slot = slot
		else:
			sfx_buzzer.playing = true

func handle_snack_use(action, slot, target):
	if action != "snack": return
	else:
		var skill_list = [option_1, option_2, option_3, option_4]
		if skill_list[currently_selected].text == "-------------": return
		var snack_name = MainInfo.heldSnacks.keys()[currently_selected + currentLayer * 2]
		var snack_dictionary = SkillsItemsWeapons.snacks.get(snack_name)
		if selected_player == 1:
			luke_last_slot = currently_selected
		elif selected_player == 2:
			brenna_last_slot = currently_selected
		sfx_select.playing = true
		previous_cursor = "selectSnack"
		currently_selected = 0
		slot = snack_dictionary
		dialogTextVisible()
		gray_out_cursor(choice_cursor, null)
		dialog_box_text.text = Dialog.battle.get("useOn")
		match snack_dictionary["useableOn"]:
			"friend":
				target = alivePlayers[currently_selected]
				selected_cursor = "selectFriend"
				luke.animation.play("highlighted")
				brenna.animation.play("unhighlight")
			"self", "none":
				target = translateToPlayer(selected_player)
				if selected_player == 1:
					luke.target = target
					luke.slot = slot
				elif selected_player == 2:
					brenna.target = target
					brenna.slot = slot
				luke.animation.play("unhighlight")
				brenna.animation.play("highlighted")
				turnOver()
		
		if selected_player == 1:
			luke.target = target
			luke.slot = slot
		elif selected_player == 2:
			brenna.target = target
			brenna.slot = slot

func handle_toy_use(action, slot, target):
	if action != "toy": return
	else:
		var skill_list = [option_1, option_2, option_3, option_4]
		if skill_list[currently_selected].text == "-------------": return
		var toy_name = MainInfo.heldToys.keys()[currently_selected + currentLayerToy * 2]
		var toy_dictionary = SkillsItemsWeapons.toys.get(toy_name)
		if selected_player == 1:
			luke_last_slot = currently_selected
		elif selected_player == 2:
			brenna_last_slot = currently_selected
		sfx_select.playing = true
		previous_cursor = "selectToy"
		currently_selected = 0
		slot = toy_dictionary
		dialogTextVisible()
		gray_out_cursor(choice_cursor, null)
		dialog_box_text.text = Dialog.battle.get("useOn")
		match toy_dictionary["useableOn"]:
			"foe":
				target = foes[currently_selected]
				selected_cursor = "selectFoe"
				for foe in foes:
					foe.hp_frame.visible = false
				foes[currently_selected].hp_frame.visible = true
				luke.animation.play("unhighlight")
				brenna.animation.play("unhighlight")
			"both":
				selected_cursor = "selectEither"
				dialog_box_text.text = Dialog.battle.get("useOnBoth")
				choosing_friend_foe = false
				target = foes[currently_selected]
				for foe in foes:
					foe.hp_frame.visible = false
				foes[currently_selected].hp_frame.visible = true
				luke.animation.play("unhighlight")
				brenna.animation.play("unhighlight")
			"friend":
				target = alivePlayers[currently_selected]
				selected_cursor = "selectFriend"
				luke.animation.play("highlighted")
				brenna.animation.play("unhighlight")
			"self", "none":
				target = translateToPlayer(selected_player)
				if selected_player == 1:
					luke.target = target
					luke.slot = slot
				elif selected_player == 2:
					brenna.target = target
					brenna.slot = slot
				turnOver()

		if selected_player == 1:
			luke.target = target
			luke.slot = slot
		elif selected_player == 2:
			brenna.target = target
			brenna.slot = slot

func translateToPlayer(player_num: int):
	if player_num == 1:
		return luke
	if player_num == 2:
		return brenna

func turnOver():
	if alivePlayers.has(brenna) && Logic.brennaInParty():
		if selected_player == 1:
			dialog_box_text.text = Dialog.battle.get("selected").replace("/p", "BRENNA")
			luke_turn_over = true
			for foe in foes:
				foe.hp_frame.visible = false
			selected_player = 2
			up_arrow.visible = false
			down_arrow.visible = false
			brenna.animation.play("highlighted")
			luke.animation.play("unhighlight")
			lastPlayerAction()
			match previous_cursor:
				"selectSkill", "selectEither", "selectFriend", "selectSnack", "selectToy":
					animation.play("hideActionBox")
				"selectFoe":
					if luke.action != "attack":
						animation.play("hideActionBox")
			showActions()
			selected_cursor = "selectAction"
			gray_out_cursor(choice_cursor, action_cursor)
			action_cursor.global_position = action_buttons[currently_selected].global_position
		elif selected_player == 2:
			brenna_turn_over = true
			for foe in foes:
				foe.hp_frame.visible = false
			dialog_box_text.text = ""
			resetLines()
			initiateBattle()
			gray_out_cursor(action_cursor, null)
			action_cursor.visible = false
			isFighting = true
			up_arrow.visible = false
			down_arrow.visible = false
			if previous_cursor == "selectSkill" || previous_cursor == "selectEither" || previous_cursor == "selectFriend" || previous_cursor == "selectSnack" || previous_cursor == "selectToy":
				animation.play("hideEnergyBarr")
			elif previous_cursor == "selectFoe":
				if brenna.action != "attack":
					animation.play("hideEnergyBarr")
				else:
					animation.play("hideEnergyBar")
			else:
				animation.play("hideEnergyBar")
	else:
		luke_turn_over = true
		for foe in foes:
			foe.hp_frame.visible = false
		dialog_box_text.text = ""
		resetLines()
		initiateBattle()
		gray_out_cursor(action_cursor, null)
		action_cursor.visible = false
		isFighting = true
		up_arrow.visible = false
		down_arrow.visible = false
		if previous_cursor == "selectSkill" || previous_cursor == "selectEither" || previous_cursor == "selectFriend" || previous_cursor == "selectSnack" || previous_cursor == "selectToy":
			animation.play("hideEnergyBarr")
		elif previous_cursor == "selectFoe":
			if luke.action != "attack":
				animation.play("hideEnergyBarr")
			else:
				animation.play("hideEnergyBar")
		else:
			animation.play("hideEnergyBar")

func lastPlayerAction():
	var player_action
	if selected_player == 1:
		player_action = luke.action
	elif selected_player == 2:
		player_action = brenna.action
	if player_action == "attack":
		currently_selected = 0
	if player_action == "skill":
		currently_selected = 1
	if player_action == "snack":
		currently_selected = 2
	if player_action == "toy":
		currently_selected = 3

func initiateBattle(playersFight: bool = true):
	battleTextVisible()
	luke.animation.play("unhighlight")
	brenna.animation.play("unhighlight")
	var attack_order = []
	var dialog_textee = []
	if playersFight:
		if alivePlayers.has(luke): attack_order.append(luke)
		if alivePlayers.has(brenna) && Logic.brennaInParty(): attack_order.append(brenna)
	else:
		dialog_textee.append(Dialog.battle["run"])
	for foe in foes:
		attack_order.append(foe)
	attack_order.sort_custom(func(a, b):
		return a.speed > b.speed
	)
	if playersFight:
		if brenna.action == "skill":
			if brenna.slot.has("actFirst"):
				attack_order.erase(brenna)
				attack_order.push_front(brenna)
		if luke.action == "skill":
			if luke.slot.has("actFirst"):
				attack_order.erase(luke)
				attack_order.push_front(luke)
	
	await get_tree().create_timer(1).timeout
	if !playersFight:
		await displayText(dialog_textee)
	for i in range(attack_order.size()):
		var variation = randf_range(0.8, 1.2)
		var currentAttacker = attack_order.front()
		attack_order.pop_front()
		if foes.has(currentAttacker):
			currentAttacker.target = alivePlayers.pick_random()
			currentAttacker.chooseSkill()
			await useEnemySkill(currentAttacker)
		else:
			if alivePlayers.has(currentAttacker):
				currentAttacker.damageReducedNextAttack = 0
				if currentAttacker.action == "attack":
					#if currentAttacker == luke:
						#luke_fup_active = true
						#currentAttacker.get_child("FollowUps").visible = true
					screen_shake.play("shake")
					if !foes.has(currentAttacker.target):
						currentAttacker.target = foes.front()
					if currentAttacker == luke:
						await playAttackAnimations(currentAttacker, "luke_attack")
					elif currentAttacker == brenna:
						await playAttackAnimations(currentAttacker, "brenna_attack")
					var target = currentAttacker.target
					var targetName = target.thisName
					var dialog_text = []
					dialog_text.append(Dialog.battle["attack"].replace("/a", currentAttacker.thisName.to_upper()).replace("/t", currentAttacker.target.thisName.to_upper()))
					if randf() < currentAttacker.hitRate:
						var emot_percentage = Logic.get_emotion_multiplier(currentAttacker.emotion, target.emotion)
						if emot_percentage > 1.0: dialog_text.append(Dialog.battle["emotion_advantage"])
						elif emot_percentage < 1.0: dialog_text.append(Dialog.battle["emotion_disadvantage"])
						if randf() < (currentAttacker.luck / 100):
							currentAttacker.target.attack_sfx.stream = Resources.SFX_CRITICAL_HIT
							currentAttacker.target.attack_sfx.playing = true
							currentAttacker.target.applyDamage(currentAttacker.attack * 2.5 * emot_percentage * variation + 2, true)
							dialog_text.append(Dialog.battle["crit"].replace("/a", currentAttacker.thisName.to_upper()).replace("/t", currentAttacker.target.thisName.to_upper()))
						else:
							currentAttacker.target.applyDamage(currentAttacker.attack * 2 * emot_percentage * variation, true) # LA DI DA
						if target.lastDamageTaken > 0:
							dialog_text.append(Dialog.battle["loseDamage"].replace("/t", targetName.to_upper()).replace("/a", str(target.lastDamageTaken)))
						if target.lastJuiceLost > 0:
							dialog_text.append(Dialog.battle["loseJuice"].replace("/t", targetName.to_upper()).replace("/a", str(target.lastJuiceLost)))
					else:
						currentAttacker.target.miss()
						dialog_text.append(Dialog.battle["miss"].replace("/a", currentAttacker.thisName.to_upper()).replace("/t", currentAttacker.target.thisName.to_upper()))
					target.lastDamageTaken = 0
					target.lastJuiceLost = 0
					await displayText(dialog_text)

					if target.health <= 0:
						if foes.has(currentAttacker.target):
							await get_tree().create_timer(0.8).timeout
							match currentAttacker.emotion:
								"neutral":
									xp_reward += currentAttacker.target.experience
									chips_reward += currentAttacker.target.chips
									if randf() < currentAttacker.target.item_chance:
										awarded_items.append(currentAttacker.target.item)
								"happy", "ecstatic", "manic":
									xp_reward += currentAttacker.target.experience
									chips_reward += currentAttacker.target.chips * 1.5
									if randf() < currentAttacker.target.item_chance * 2:
										awarded_items.append(currentAttacker.target.item)
								"sad", "depressed", "miserable":
									xp_reward += currentAttacker.target.experience * 0.75
									chips_reward += currentAttacker.target.chips * 0.75
									if randf() < currentAttacker.target.item_chance:
										awarded_items.append(currentAttacker.target.item)
								"angry", "enraged", "furious":
									xp_reward += currentAttacker.target.experience * 1.5
									chips_reward += currentAttacker.target.chips
									if randf() < currentAttacker.target.item_chance:
										awarded_items.append(currentAttacker.target.item)
							currentAttacker.target.die()

					
					if target.health <= 0:
						if foes.has(currentAttacker.target):
							foes.erase(currentAttacker.target)
							#currentAttacker.target.queue_free()
				if currentAttacker.action == "skill":
					await usePlayerSkill(currentAttacker)
				if currentAttacker.action == "snack":
					await useSnack(currentAttacker)
				if currentAttacker.action == "toy":
					await useToy(currentAttacker)
			else:
				continue
		if foes.size() <= 0:
			AutoplayMusic.stream = WIN_MUSIC
			AutoplayMusic.playing = true
			for player in alivePlayers:
				player.applyEmotion("neutral")
				player.animated_face.play("happy_" + player.thisName.to_lower())
			for snk in delete_snacks:
				MainInfo.heldSnacks.erase(snk)
			for ty in delete_toys:
				MainInfo.heldToys.erase(ty)
			var dialog_text = []
			if begin_dialog == "begin":
				dialog_text.append(Dialog.battle["win"])
			else:
				dialog_text.append(Dialog.battle["win_luke"])
			dialog_text.append(Dialog.battle["gainXP"].replace("/a", str(xp_reward)))
			dialog_text.append(Dialog.battle["gainChips"].replace("/a", str(chips_reward)))
			if luke.isAlive:
				MainInfo.LukeStats["xp"] += round(xp_reward / 2)
			if brenna.isAlive && Logic.brennaInParty():
				MainInfo.BrennaStats["xp"] += round(xp_reward / 2)
			MainInfo.chips += chips_reward
			await displayTextNoReset(dialog_text)
			showRewards = true
			prev_luke_level = MainInfo.LukeStats["level"]
			prev_brenna_level = MainInfo.BrennaStats["level"]

			level_up("Luke")
			if Logic.brennaInParty():
				level_up("Brenna")
			
			update_stats()
			if prev_luke_level != MainInfo.LukeStats["level"]:
				playersLeveledUp.append("Luke")
			if prev_brenna_level != MainInfo.LukeStats["level"]:
				if alivePlayers.has(brenna) && Logic.brennaInParty():
					playersLeveledUp.append("Brenna")
			
			currently_selected = 0
			return
		if alivePlayers.size() == 0:
			return
		if get_tree():
			await get_tree().create_timer(1).timeout

	for snk in delete_snacks:
		MainInfo.heldSnacks.erase(snk)
	for ty in delete_toys:
		MainInfo.heldToys.erase(ty)
	selected_player = 1
	currently_selected = 0
	action_cursor.global_position = fight_run_buttons[0].global_position
	selected_cursor = "fightRun"
	gray_out_cursor(null, action_cursor)
	isFighting = false
	animation.play_backwards("hideEnergyBar")
	dialog_box_text.text = Dialog.battle.get(begin_dialog)
	dialogTextVisible()
	showFightOrRun()
	await animation.animation_finished
	action_cursor.visible = true

func useSnack(currentAttacker):
	var snack_data = currentAttacker.slot
	var target = currentAttacker.target
	
	var dialog_text = []
	dialog_text.append(Dialog.battle["useSnack"].replace("/a", currentAttacker.thisName.to_upper()).replace("/s", snack_data["name"].to_upper()))

	if MainInfo.heldSnacks.get(snack_data["name"])["hold"] <= 0:
		if !delete_snacks.has(snack_data["name"]):
			delete_snacks.append(snack_data["name"])
		dialog_text.append(Dialog.battle["failedSnack"].replace("/a", currentAttacker.thisName.to_upper()).replace("/s", snack_data["name"].to_upper()))
		await displayText(dialog_text)
		return
	
	await playSnackAnimations(currentAttacker, snack_data.name)
	
	MainInfo.heldSnacks.get(snack_data["name"])["hold"] -= 1
	if MainInfo.heldSnacks.get(snack_data["name"])["hold"] <= 0:
		if !delete_snacks.has(snack_data["name"]):
			delete_snacks.append(snack_data["name"])

	if !alivePlayers.has(target) && !snack_data.has("all") && !snack_data["name"] == "Life Jam":
		currentAttacker.target = currentAttacker
		target = currentAttacker.target

	var targetName = currentAttacker.target.thisName
	if snack_data["name"] == "Life Jam":
		var snack_heal = target.maxHealth * 0.5
		currentAttacker.target.applyHealth(roundi(snack_heal))
		dialog_text.append(Dialog.battle["recoverHealth"].replace("/t", targetName.to_upper()).replace("/a", str(roundi(snack_heal))))
		dialog_text.append(Dialog.battle["riseAgain"].replace("/t", targetName.to_upper()))
		target.applyEmotion("neutral")
		if !alivePlayers.has(target):
			alivePlayers.append(target)
	
	if !snack_data.has("all"):
		if snack_data.has("health") && !snack_data.has("juice"):
			var snack_heal = snack_data["health"].call(target)
			currentAttacker.target.applyHealth(roundi(snack_heal))
			dialog_text.append(Dialog.battle["recoverHealth"].replace("/t", targetName.to_upper()).replace("/a", str(roundi(snack_heal))))
		elif snack_data.has("juice") && !snack_data.has("health"):
			var snack_heal = snack_data["juice"].call(target)
			currentAttacker.target.applyJuice(roundi(snack_heal))
			dialog_text.append(Dialog.battle["recoverJuice"].replace("/t", targetName.to_upper()).replace("/a", str(roundi(snack_heal))))
		elif snack_data.has("health") && snack_data.has("juice"):
			var snack_heal = snack_data["health"].call(target)
			var snack_juice = snack_data["juice"].call(target)
			currentAttacker.target.applyHealthJuice(roundi(snack_heal), roundi(snack_juice))
			dialog_text.append(Dialog.battle["recoverHealth"].replace("/t", targetName.to_upper()).replace("/a", str(roundi(snack_heal))))
			dialog_text.append(Dialog.battle["recoverJuice"].replace("/t", targetName.to_upper()).replace("/a", str(roundi(snack_juice))))
	else:
		for tgt in alivePlayers:
			if snack_data.has("health") && !snack_data.has("juice"):
				var snack_heal = snack_data["health"].call(tgt)
				tgt.applyHealth(roundi(snack_heal))
				dialog_text.append(Dialog.battle["recoverHealth"].replace("/t", tgt.thisName.to_upper()).replace("/a", str(roundi(snack_heal))))
			elif snack_data.has("juice") && !snack_data.has("health"):
				var snack_heal = snack_data["juice"].call(tgt)
				tgt.applyJuice(roundi(snack_heal))
				dialog_text.append(Dialog.battle["recoverJuice"].replace("/t", tgt.thisName.to_upper()).replace("/a", str(roundi(snack_heal))))
			elif snack_data.has("health") && snack_data.has("juice"):
				var snack_heal = snack_data["health"].call(tgt)
				var snack_juice = snack_data["juice"].call(tgt)
				tgt.applyHealthJuice(roundi(snack_heal), roundi(snack_juice))
				dialog_text.append(Dialog.battle["recoverHealth"].replace("/t", tgt.thisName.to_upper()).replace("/a", str(roundi(snack_heal))))
				dialog_text.append(Dialog.battle["recoverJuice"].replace("/t", tgt.thisName.to_upper()).replace("/a", str(roundi(snack_juice))))
	await displayText(dialog_text)

func useToy(currentAttacker):
	var damage: int = 0
	var toy_data = currentAttacker.slot
	var target = currentAttacker.target

	var dialog_text = []
	dialog_text.append(Dialog.battle["useSnack"].replace("/a", currentAttacker.thisName.to_upper()).replace("/s", toy_data["name"].to_upper()))

	if MainInfo.heldToys.get(toy_data["name"])["hold"] <= 0:
		if !delete_toys.has(toy_data["name"]):
			delete_toys.append(toy_data["name"])
		dialog_text.append(Dialog.battle["failedSnack"].replace("/a", currentAttacker.thisName.to_upper()).replace("/s", toy_data["name"].to_upper()))
		await displayText(dialog_text)
		return

	MainInfo.heldToys.get(toy_data["name"])["hold"] -= 1
	if MainInfo.heldToys.get(toy_data["name"])["hold"] <= 0:
		if !delete_toys.has(toy_data["name"]):
			delete_toys.append(toy_data["name"])

	if !foes.has(currentAttacker.target) && !alivePlayers.has(currentAttacker.target):
		currentAttacker.target = foes.front()
		target = currentAttacker.target
	await playToyAnimations(currentAttacker, toy_data.name)

	var targetName = currentAttacker.target.thisName
	if toy_data.has("damage"):
		screen_shake.play("shake")
		var skill_damage = toy_data["damage"].call(currentAttacker)
		if toy_data.has("allFoes"):
			for tgt in foes:
				tgt.applyDamage(skill_damage, true)
				if tgt.lastDamageTaken > 0:
					dialog_text.append(Dialog.battle["loseDamage"].replace("/t", tgt.thisName.to_upper()).replace("/a", str(tgt.lastDamageTaken)))
				if tgt.lastJuiceLost > 0:
					dialog_text.append(Dialog.battle["loseJuice"].replace("/t", tgt.thisName.to_upper()).replace("/a", str(tgt.lastJuiceLost)))
				tgt.lastDamageTaken = 0
				tgt.lastJuiceLost = 0
		else:
			target.applyDamage(skill_damage, true)
			if target.lastDamageTaken > 0:
				dialog_text.append(Dialog.battle["loseDamage"].replace("/t", targetName.to_upper()).replace("/a", str(target.lastDamageTaken)))
			if target.lastJuiceLost > 0:
				dialog_text.append(Dialog.battle["loseJuice"].replace("/t", targetName.to_upper()).replace("/a", str(target.lastJuiceLost)))
			target.lastDamageTaken = 0
			target.lastJuiceLost = 0
	if toy_data.has("emotion"):
		if toy_data.has("allFoes"):
			for tgt in foes:
				var new_emot = Logic.checkEmotion(toy_data.emotion, tgt)
				if new_emot == "SADDER" || new_emot == "ANGRIER" || new_emot == "HAPPIER":
					dialog_text.append(Dialog.battle["maxEmotion"].replace("/t", tgt.thisName.to_upper()).replace("/e", new_emot.to_upper()))
				else:
					tgt.applyEmotion(new_emot)
					dialog_text.append(Dialog.battle["applyEmotion"].replace("/t", tgt.thisName.to_upper()).replace("/e", new_emot.to_upper()))
		elif toy_data.has("allFriends"):
			for tgt in alivePlayers:
				var new_emot = Logic.checkEmotion(toy_data.emotion, tgt)
				if new_emot == "SADDER" || new_emot == "ANGRIER" || new_emot == "HAPPIER":
					dialog_text.append(Dialog.battle["maxEmotion"].replace("/t", tgt.thisName.to_upper()).replace("/e", new_emot.to_upper()))
				else:
					tgt.applyEmotion(new_emot)
					dialog_text.append(Dialog.battle["applyEmotion"].replace("/t", tgt.thisName.to_upper()).replace("/e", new_emot.to_upper()))
		else:
			var new_emot = Logic.checkEmotion(toy_data.emotion, target)
			if new_emot == "SADDER" || new_emot == "ANGRIER" || new_emot == "HAPPIER":
				dialog_text.append(Dialog.battle["maxEmotion"].replace("/t", targetName.to_upper()).replace("/e", new_emot.to_upper()))
			else:
				target.applyEmotion(new_emot)
				dialog_text.append(Dialog.battle["applyEmotion"].replace("/t", targetName.to_upper()).replace("/e", new_emot.to_upper()))
	if toy_data.has("debuff"):
		if toy_data.has("allFoes"):
			for tgt in foes:
				match toy_data["debuff"]:
					"attack":
						tgt.attack_buff = clampi(tgt.attack_buff - 1, -3, 3)
					"defense":
						tgt.attack_buff = clampi(tgt.defense_buff - 1, -3, 3)
					"speed":
						tgt.attack_buff = clampi(tgt.speed_buff - 1, -3, 3)
				dialog_text.append(Dialog.battle["debuff"].replace("/t", tgt.thisName.to_upper()).replace("/b", toy_data["debuff"].to_upper()))
				tgt.updateBuffs()
		else:
			match toy_data["debuff"]:
				"attack":
					target.attack_buff = clampi(target.attack_buff - 1, -3, 3)
				"defense":
					target.attack_buff = clampi(target.defense_buff - 1, -3, 3)
				"speed":
					target.attack_buff = clampi(target.speed_buff - 1, -3, 3)
			dialog_text.append(Dialog.battle["debuff"].replace("/t", targetName.to_upper()).replace("/b", toy_data["debuff"].to_upper()))
			target.updateBuffs()
	if toy_data.has("buff"):
		if toy_data.has("allFoes"):
			for tgt in foes:
				match toy_data["buff"]:
					"attack":
						tgt.attack_buff = clampi(tgt.attack_buff + 1, -3, 3)
					"defense":
						tgt.attack_buff = clampi(tgt.defense_buff + 1, -3, 3)
					"speed":
						tgt.attack_buff = clampi(tgt.speed_buff + 1, -3, 3)
				dialog_text.append(Dialog.battle["buff"].replace("/t", tgt.thisName.to_upper()).replace("/b", toy_data["buff"].to_upper()))
				tgt.updateBuffs()
		else:
			match toy_data["buff"]:
				"attack":
					target.attack_buff = clampi(target.attack_buff + 1, -3, 3)
				"defense":
					target.attack_buff = clampi(target.defense_buff + 1, -3, 3)
				"speed":
					target.attack_buff = clampi(target.speed_buff + 1, -3, 3)
			dialog_text.append(Dialog.battle["buff"].replace("/t", targetName.to_upper()).replace("/b", toy_data["buff"].to_upper()))
			target.updateBuffs()
	var erase_foes = []
	for foe in foes:
		if foe.health <= 0:
			match currentAttacker.emotion:
				"neutral":
					xp_reward += foe.experience
					chips_reward += foe.chips
					if randf() < foe.item_chance:
						awarded_items.append(foe.item)
				"happy", "ecstatic", "manic":
					xp_reward += foe.experience
					chips_reward += foe.chips * 1.5
					if randf() < foe.item_chance * 2:
						awarded_items.append(foe.item)
				"sad", "depressed", "miserable":
					xp_reward += foe.experience * 0.75
					chips_reward += foe.chips * 0.75
					if randf() < foe.item_chance:
						awarded_items.append(foe.item)
				"angry", "enraged", "furious":
					xp_reward += foe.experience * 1.5
					chips_reward += foe.chips
					if randf() < foe.item_chance:
						awarded_items.append(foe.item)
			erase_foes.append(foe)

	await displayText(dialog_text)
	for foe in erase_foes:
		foe.die()
		foes.erase(foe)

func usePlayerSkill(currentAttacker):
	var variation = randf_range(0.8, 1.2)
	var damage: int = 0
	var skill_data = currentAttacker.slot
	var target = currentAttacker.target
	
	var dialog_text = []
	if !currentAttacker.juice >= skill_data["cost"]:
		dialog_text.append(Dialog.battle["attemptSkill"].replace("/a", str(currentAttacker.thisName).to_upper()).replace("/s", skill_data["name"].to_upper()))
		dialog_text.append(Dialog.battle["lowJuice"].replace("/a", str(currentAttacker.thisName).to_upper()))
		await displayText(dialog_text)
		return
	
	else: dialog_text.append(skill_data["dialog"].call(currentAttacker.thisName, target.thisName))
	currentAttacker.juice = max(currentAttacker.juice - skill_data["cost"], 0)
	currentAttacker.updateHealth()

	var emot_percentage = Logic.get_emotion_multiplier(currentAttacker.emotion, target.emotion)
	
	if !foes.has(currentAttacker.target) && !alivePlayers.has(currentAttacker.target):
		currentAttacker.target = foes.front()
		target = currentAttacker.target
	if !skill_data.has("randomFoes"):
		await playAttackAnimations(currentAttacker, skill_data.name)

	var targetName = currentAttacker.target.thisName
	variation = randf_range(0.8, 1.2)
	if skill_data.has("damage"):
		screen_shake.play("shake")
		var skill_damage = skill_data["damage"].call(currentAttacker)
		if emot_percentage > 1.0: dialog_text.append(Dialog.battle["emotion_advantage"])
		elif emot_percentage < 1.0: dialog_text.append(Dialog.battle["emotion_disadvantage"])
		if skill_data.has("noDefenseEmotion"):
			if currentAttacker.emotion == skill_data.noDefenseEmotion:
				target.applyDamage(skill_damage * emot_percentage * variation, false)
			else:
				target.applyDamage(skill_damage * emot_percentage * variation, true)
		elif skill_data.has("ignoreDefense"):
			target.applyDamage(skill_damage * emot_percentage * variation, false)
		else:
			target.applyDamage(skill_damage * emot_percentage * variation, true)
		if target.lastDamageTaken > 0:
			dialog_text.append(Dialog.battle["loseDamage"].replace("/t", targetName.to_upper()).replace("/a", str(target.lastDamageTaken)))
		if target.lastJuiceLost > 0:
			dialog_text.append(Dialog.battle["loseJuice"].replace("/t", targetName.to_upper()).replace("/a", str(target.lastJuiceLost)))
		target.lastDamageTaken = 0
		target.lastJuiceLost = 0
	if skill_data.has("damageAllFoes"):
		screen_shake.play("shake")
		if emot_percentage > 1.0: dialog_text.append(Dialog.battle["emotion_advantage"])
		elif emot_percentage < 1.0: dialog_text.append(Dialog.battle["emotion_disadvantage"])
		var skill_damage = skill_data["damageAllFoes"].call(currentAttacker)
		var individual_damage = round(skill_damage / foes.size())
		for enemy in foes:
			variation = randf_range(0.8, 1.2)
			enemy.applyDamage(individual_damage * emot_percentage * variation, true)
			if enemy.lastDamageTaken > 0:
				dialog_text.append(Dialog.battle["loseDamage"].replace("/t", enemy.thisName.to_upper()).replace("/a", str(enemy.lastDamageTaken)))
			if enemy.lastJuiceLost > 0:
				dialog_text.append(Dialog.battle["loseJuice"].replace("/t", enemy.thisName.to_upper()).replace("/a", str(enemy.lastJuiceLost)))
	
	#if skill_data.has("randomFoes"):
		#screen_shake.play("shake")
		#var skill_damage = skill_data["randomFoeDamage"].call(currentAttacker)
		#for foe in skill_data["randomFoes"]:
			#currentAttacker.target = foes.pick_random()
			#var enemy = currentAttacker.target
			#playAttackAnimations(currentAttacker, skill_data.name)
			#variation = randf_range(0.8, 1.2)
			#enemy.applyDamage(skill_damage * variation, true)
			#if enemy.lastDamageTaken > 0:
				#dialog_text.append(Dialog.battle["loseDamage"].replace("/t", enemy.thisName.to_upper()).replace("/a", str(enemy.lastDamageTaken)))
			#if enemy.lastJuiceLost > 0:
				#dialog_text.append(Dialog.battle["loseJuice"].replace("/t", enemy.thisName.to_upper()).replace("/a", str(enemy.lastJuiceLost)))
			#await get_tree().create_timer(0.3).timeout
	if skill_data.has("randomFoes"):
		screen_shake.play("shake")
		var skill_damage = skill_data["randomFoeDamage"].call(currentAttacker)

		# Dictionary to track accumulated damage per enemy
		var enemy_damage_map = {}

		# Select random foes and accumulate damage
		for i in range(skill_data["randomFoes"]):
			var enemy = foes.pick_random()
			variation = randf_range(0.8, 1.2)
			var total_damage = skill_damage * emot_percentage * variation

			# Add damage if enemy was picked before
			if enemy in enemy_damage_map:
				enemy_damage_map[enemy] += total_damage
			else:
				enemy_damage_map[enemy] = total_damage

		# Apply total accumulated damage to each enemy
		for enemy in enemy_damage_map.keys():
			if emot_percentage > 1.0: dialog_text.append(Dialog.battle["emotion_advantage"])
			elif emot_percentage < 1.0: dialog_text.append(Dialog.battle["emotion_disadvantage"])
			currentAttacker.target = enemy
			await playAttackAnimations(currentAttacker, skill_data.name)
			enemy.applyDamage(enemy_damage_map[enemy], true)

			if enemy.lastDamageTaken > 0:
				dialog_text.append(Dialog.battle["loseDamage"]
					.replace("/t", enemy.thisName.to_upper())
					.replace("/a", str(enemy.lastDamageTaken)))
			if enemy.lastJuiceLost > 0:
				dialog_text.append(Dialog.battle["loseJuice"]
					.replace("/t", enemy.thisName.to_upper())
					.replace("/a", str(enemy.lastJuiceLost)))

			await get_tree().create_timer(0.3).timeout
	
	if skill_data.has("reduceDamage"):
		currentAttacker.damageReducedNextAttack = skill_data["reduceDamage"]
	if skill_data.has("emotion"):
		var new_emot = Logic.checkEmotion(skill_data.emotion, target)
		if new_emot == "SADDER" || new_emot == "ANGRIER" || new_emot == "HAPPIER":
			dialog_text.append(Dialog.battle["maxEmotion"].replace("/t", targetName.to_upper()).replace("/e", new_emot.to_upper()))
		else:
			target.applyEmotion(new_emot)
			dialog_text.append(Dialog.battle["applyEmotion"].replace("/t", targetName.to_upper()).replace("/e", new_emot.to_upper()))
	if skill_data.has("debuff"):
		match skill_data["debuff"]:
			"attack":
				target.attack_buff = clampi(target.attack_buff - 1, -3, 3)
			"defense":
				target.attack_buff = clampi(target.defense_buff - 1, -3, 3)
			"speed":
				target.attack_buff = clampi(target.speed_buff - 1, -3, 3)
		dialog_text.append(Dialog.battle["debuff"].replace("/t", targetName.to_upper()).replace("/b", skill_data["debuff"].to_upper()))
		target.updateBuffs()
	if skill_data.has("buff"):
		match skill_data["buff"]:
			"attack":
				target.attack_buff = clampi(target.attack_buff + 1, -3, 3)
			"defense":
				target.attack_buff = clampi(target.defense_buff + 1, -3, 3)
			"speed":
				target.attack_buff = clampi(target.speed_buff + 1, -3, 3)
		dialog_text.append(Dialog.battle["buff"].replace("/t", targetName.to_upper()).replace("/b", skill_data["buff"].to_upper()))
		target.updateBuffs()
	if skill_data.has("heal"):
		var skill_heal = skill_data["heal"].call(currentAttacker)
		currentAttacker.target.applyHealth(roundi(skill_heal))
		dialog_text.append(Dialog.battle["recoverHealth"].replace("/t", targetName.to_upper()).replace("/a", str(roundi(skill_heal))))
	var erase_foes = []
	for foe in foes:
		if foe.health <= 0:
			#await get_tree().create_timer(0.8).timeout
			match currentAttacker.emotion:
				"neutral":
					xp_reward += foe.experience
					chips_reward += foe.chips
					if randf() < foe.item_chance:
						awarded_items.append(foe.item)
				"happy", "ecstatic", "manic":
					xp_reward += foe.experience
					chips_reward += foe.chips * 1.5
					if randf() < foe.item_chance * 2:
						awarded_items.append(foe.item)
				"sad", "depressed", "miserable":
					xp_reward += foe.experience * 0.75
					chips_reward += foe.chips * 0.75
					if randf() < foe.item_chance:
						awarded_items.append(foe.item)
				"angry", "enraged", "furious":
					xp_reward += foe.experience * 1.5
					chips_reward += foe.chips
					if randf() < foe.item_chance:
						awarded_items.append(foe.item)
			erase_foes.append(foe)

	await displayText(dialog_text)
	for foe in erase_foes:
		foe.die()
		foes.erase(foe)
func useEnemySkill(currentAttacker):
	var variation = randf_range(0.8, 1.2)
	var damage: int = 0
	var skill_data = SkillsItemsWeapons.enemySkills.get(currentAttacker.skill)
	var target = currentAttacker.target
	
	var dialog_text = []
	
	dialog_text.append(skill_data["dialog"].call(currentAttacker.thisName, target.thisName))
	if !foes.has(currentAttacker.target) && !alivePlayers.has(currentAttacker.target):
		currentAttacker.target = foes.front()
		target = currentAttacker.target
	await playAttackAnimations(currentAttacker, skill_data.name)
	
	var emot_percentage = Logic.get_emotion_multiplier(currentAttacker.emotion, target.emotion)
	
	var targetName = currentAttacker.target.thisName
	if skill_data.has("damage"):
		screen_shake.play("shake")
		if emot_percentage > 1.0: dialog_text.append(Dialog.battle["emotion_advantage"])
		elif emot_percentage < 1.0: dialog_text.append(Dialog.battle["emotion_disadvantage"])
		var skill_damage = skill_data["damage"].call(currentAttacker)
		if skill_data.has("noDefenseEmotion"):
			variation = randf_range(0.8, 1.2)
			if currentAttacker.emotion == skill_data.noDefenseEmotion:
				currentAttacker.target.applyDamage(skill_damage * emot_percentage * variation, false)
			else:
				currentAttacker.target.applyDamage(skill_damage * emot_percentage * variation, true)
		elif skill_data.has("ignoreDefense"):
			currentAttacker.target.applyDamage(skill_damage * emot_percentage * variation, false)
		else:
			currentAttacker.target.applyDamage(skill_damage * emot_percentage * variation, true)
		if target.lastDamageTaken > 0:
			dialog_text.append(Dialog.battle["loseDamage"].replace("/t", targetName.to_upper()).replace("/a", str(target.lastDamageTaken)))
		if target.lastJuiceLost > 0:
			dialog_text.append(Dialog.battle["loseJuice"].replace("/t", targetName.to_upper()).replace("/a", str(target.lastJuiceLost)))
		
		if target.lastDamageTaken > 0 || target.lastJuiceLost > 0:
			energy = clamp(energy + 1, 0, 10)
			checkEnergyBar()
		target.lastDamageTaken = 0
		target.lastJuiceLost = 0
	if skill_data.has("damageAllFoes"):
		screen_shake.play("shake")
		variation = randf_range(0.8, 1.2)
		var skill_damage = skill_data["damageAllFoes"].call(currentAttacker)
		var individual_damage = round(skill_damage / foes.size())
		for enemy in foes:
			if emot_percentage > 1.0: dialog_text.append(Dialog.battle["emotion_advantage"])
			elif emot_percentage < 1.0: dialog_text.append(Dialog.battle["emotion_disadvantage"])
			enemy.applyDamage(individual_damage * emot_percentage * variation, true)
			if enemy.lastDamageTaken > 0:
				dialog_text.append(Dialog.battle["loseDamage"].replace("/t", enemy.thisName.to_upper()).replace("/a", str(enemy.lastDamageTaken)))
			if enemy.lastJuiceLost > 0:
				dialog_text.append(Dialog.battle["loseJuice"].replace("/t", enemy.thisName.to_upper()).replace("/a", str(enemy.lastJuiceLost)))
	if skill_data.has("emotion"):
		var new_emot = Logic.checkEmotion(skill_data.emotion, target)
		if new_emot == "SADDER" || new_emot == "ANGRIER" || new_emot == "HAPPIER":
			dialog_text.append(Dialog.battle["maxEmotion"].replace("/t", targetName.to_upper()).replace("/e", new_emot.to_upper()))
		else:
			target.applyEmotion(new_emot)
			dialog_text.append(Dialog.battle["applyEmotion"].replace("/t", targetName.to_upper()).replace("/e", new_emot.to_upper()))
	if skill_data.has("debuff"):
		match skill_data["debuff"]:
			"attack":
				target.attack_buff = clampi(target.attack_buff - 1, -3, 3)
			"defense":
				target.attack_buff = clampi(target.defense_buff - 1, -3, 3)
			"speed":
				target.attack_buff = clampi(target.speed_buff - 1, -3, 3)
		dialog_text.append(Dialog.battle["debuff"].replace("/t", targetName.to_upper()).replace("/b", skill_data["debuff"].to_upper()))
		target.updateBuffs()
	if skill_data.has("buff"):
		match skill_data["buff"]:
			"attack":
				target.attack_buff = clampi(target.attack_buff + 1, -3, 3)
			"defense":
				target.attack_buff = clampi(target.defense_buff + 1, -3, 3)
			"speed":
				target.attack_buff = clampi(target.speed_buff + 1, -3, 3)
		dialog_text.append(Dialog.battle["buff"].replace("/t", targetName.to_upper()).replace("/b", skill_data["buff"].to_upper()))
		target.updateBuffs()
	if skill_data.has("heal"):
		var skill_heal = skill_data["heal"].call(currentAttacker)
		currentAttacker.target.applyHealth(skill_heal)

	if target.health <= 0:
		if alivePlayers.has(currentAttacker.target):
			currentAttacker.target.toast()
			dialog_text.append(Dialog.battle["toast"].replace("/t", currentAttacker.target.thisName.to_upper()))
			alivePlayers.erase(currentAttacker.target)
	
	await displayText(dialog_text)
	if target.health <= 0:
		if currentAttacker.target == luke:
			update_stats()
			call_deferred("change_scene")
func playSnackAnimations(currentAttacker, snackName: String):
	attackAnimations.visible = true
	for foe in foes:
		foe.attackAnimation.visible = true
	for player in alivePlayers:
		player.attackAnimation.visible = true
	var anim = currentAttacker.attackAnimation
	var target = currentAttacker.target
	var targetAnim = currentAttacker.target.attackAnimation
	var sfx = currentAttacker.attack_sfx
	var target_sfx = currentAttacker.target.attack_sfx
	var snack = SkillsItemsWeapons.snacks.get(snackName)
	if snack.has("all"):
		for tgt in alivePlayers:
			if snack.has("health"):
				tgt.attackAnimation.play("healHeart")
				target_sfx.stream = Resources.HEAL_HEART
				target_sfx.playing = true
			elif snack.has("juice"):
				tgt.attackAnimation.play("healJuice")
				target_sfx.stream = Resources.HEAL_JUICE
				target_sfx.playing = true
	else:
		if snack.has("health"):
			targetAnim.play("healHeart")
			target_sfx.stream = Resources.HEAL_HEART
			target_sfx.playing = true
		elif snack.has("juice"):
			targetAnim.play("healJuice")
			target_sfx.stream = Resources.HEAL_JUICE
			target_sfx.playing = true
		
	match snackName:
		"Life Jam":
			if !alivePlayers.has(target):
				targetAnim.z_index = 0
				target.emotion_bg.texture = Resources.NEUTRAL_BG
				targetAnim.play("lifeJam")
				target_sfx.stream = Resources.LIFE_JAM_SPREAD
				target_sfx.playing = true
				await targetAnim.animation_finished
				target_sfx.stream = Resources.LIFE_JAM_REVIVE
				target_sfx.playing = true
				targetAnim.z_index = 5

func playToyAnimations(currentAttacker, toyName: String):
	attackAnimations.visible = true
	for foe in foes:
		foe.attackAnimation.visible = true
	for player in alivePlayers:
		player.attackAnimation.visible = true
	var anim = currentAttacker.attackAnimation
	var targetAnim = currentAttacker.target.attackAnimation
	var sfx = currentAttacker.attack_sfx
	var target_sfx = currentAttacker.target.attack_sfx
	
	var toy = SkillsItemsWeapons.toys.get(toyName)
	if toy.has("allFoes"):
		for tgt in foes:
			if toy.has("damage"):
				tgt.attackAnimation.play("attack")
				tgt.attack_sfx.stream = Resources.SFX_ATTACK_SOLID
				tgt.attack_sfx.playing = true
				await tgt.attackAnimation.animation_finished
			if toy.has("debuff"):
				tgt.attackAnimation.play("stat_down")
				tgt.attack_sfx.stream = Resources.SFX_STAT_DOWN
				tgt.attack_sfx.playing = true
			if toy.has("buff"):
				tgt.attackAnimation.play("stat_up")
				tgt.attack_sfx.stream = Resources.SFX_STAT_UP
				tgt.attack_sfx.playing = true
			await get_tree().create_timer(0.2).timeout
	else:
		if toy.has("damage"):
			targetAnim.play("attack")
			target_sfx.stream = Resources.SFX_ATTACK_SOLID
			target_sfx.playing = true
			await targetAnim.animation_finished
		if toy.has("debuff"):
			targetAnim.play("stat_down")
			target_sfx.stream = Resources.SFX_STAT_DOWN
			target_sfx.playing = true
		if toy.has("buff"):
			targetAnim.play("stat_up")
			target_sfx.stream = Resources.SFX_STAT_UP
			target_sfx.playing = true
	match toyName:
		"Slice":
			targetAnim.play("slice")
			target_sfx.stream = Resources.SFX_BRENNA_ATTACK
			target_sfx.playing = true

func disappearAnimations():
	await get_tree().create_timer(3).timeout
	attackAnimations.visible = false
	for foe in foes:
		foe.attackAnimation.visible = false
	for player in alivePlayers:
		player.attackAnimation.visible = false

func playAttackAnimations(currentAttacker, skillName: String):
	attackAnimations.visible = true
	for foe in foes:
		foe.attackAnimation.visible = true
	for player in alivePlayers:
		player.attackAnimation.visible = true
	var anim = currentAttacker.attackAnimation
	var targetAnim = currentAttacker.target.attackAnimation
	var sfx = currentAttacker.attack_sfx
	var target_sfx = currentAttacker.target.attack_sfx
	targetAnim.z_index = 5
	match skillName:
		"Slice":
			targetAnim.play("slice")
			target_sfx.stream = Resources.SFX_BRENNA_ATTACK
			target_sfx.playing = true
		"brenna_attack":
			targetAnim.play("slice")
			target_sfx.stream = Resources.SFX_BRENNA_ATTACK
			target_sfx.playing = true
		"luke_attack":
			targetAnim.play("luke_attack")
			target_sfx.stream = Resources.SFX_LUKE_ATTACK
			target_sfx.playing = true
		"Attack":
			targetAnim.play("attack")
			target_sfx.stream = Resources.SFX_ATTACK_SOLID
			target_sfx.playing = true
		"Be Cute":
			anim.play("be_cute")
			await get_tree().create_timer(0.5).timeout
			targetAnim.z_index = 0
			targetAnim.play("player_stat_down")
			target_sfx.stream = Resources.SFX_STAT_DOWN
			target_sfx.playing = true
		"Sad Eyes":
			#anim.play("be_cute")
			pass
		"Spray Away":
			attackAnimations.play("sprayCan")
			target_sfx.stream = Resources.SFX_SPRAY
			target_sfx.playing = true
			await get_tree().create_timer(0.5).timeout
		"Bake":
			targetAnim.play("healHeart")
			target_sfx.stream = Resources.HEAL_HEART
			target_sfx.playing = true
			await targetAnim.animation_finished
			targetAnim.play("bake")
			for i in range(4):
				target_sfx.stream = Resources.SFX_MUNCH
				target_sfx.playing = true
				await target_sfx.finished
				
		"Rapid Slash":
			targetAnim.play("slice")
			target_sfx.stream = Resources.SFX_BRENNA_ATTACK
			target_sfx.playing = true
		"Do Nothing":
			pass
		"Guard":
			pass
		_:
			targetAnim.play("attack")
			target_sfx.stream = Resources.SFX_ATTACK_SOLID
			target_sfx.playing = true
func change_scene():
	screen_animation.play_backwards("fade_in")
	await screen_animation.animation_finished
	get_tree().change_scene_to_file("res://ui/battle/game_over.tscn")

func change_scene_win():
	screen_animation.play_backwards("fade_in")
	await screen_animation.animation_finished
	if get_tree():
		get_tree().change_scene_to_file(MainInfo.last_scene_path)

func checkEnergyBar():
	energy_amount.text = "0" + str(energy)
	match energy:
		0:
			energy_bar.texture = Resources.BAR_0_1_2
			moving_energy_orbs.texture = Resources.ORB_0
		1:
			energy_bar.texture = Resources.BAR_0_1_2
			moving_energy_orbs.texture = Resources.ORB_1
		2:
			energy_bar.texture = Resources.BAR_0_1_2
			moving_energy_orbs.texture = Resources.ORB_2
		3:
			energy_bar.texture = Resources.BAR_3_4
			moving_energy_orbs.texture = Resources.ORB_3
		4:
			energy_bar.texture = Resources.BAR_3_4
			moving_energy_orbs.texture = Resources.ORB_4
		5:
			energy_bar.texture = Resources.BAR_5_6
			moving_energy_orbs.texture = Resources.ORB_5
		6:
			energy_bar.texture = Resources.BAR_5_6
			moving_energy_orbs.texture = Resources.ORB_6
		7:
			energy_bar.texture = Resources.BAR_7_8_9
			moving_energy_orbs.texture = Resources.ORB_7
		8:
			energy_bar.texture = Resources.BAR_7_8_9
			moving_energy_orbs.texture = Resources.ORB_8
		9:
			energy_bar.texture = Resources.BAR_7_8_9
			moving_energy_orbs.texture = Resources.ORB_9
		10:
			energy_bar.texture = Resources.BAR_10
			moving_energy_orbs.texture = Resources.ORB_10
			energy_amount.text = str(energy)
func displayBattleDamageText(currentAttacker):
	if currentAttacker.target.lastDamageTaken > 0 && currentAttacker.target.lastJuiceLost > 0:
		line_2.text = Dialog.battle["loseDamage"].replace("/t", currentAttacker.target.thisName.to_upper()).replace("/a", str(currentAttacker.target.lastDamageTaken))
		await fadeInLine(2)
		line_3.text = Dialog.battle["loseJuice"].replace("/t", currentAttacker.target.thisName.to_upper()).replace("/a", str(currentAttacker.target.lastJuiceLost))
		await fadeInLine(3)
	elif currentAttacker.target.lastDamageTaken > 0 && !currentAttacker.target.lastJuiceLost > 0:
		line_2.text = Dialog.battle["loseDamage"].replace("/t", currentAttacker.target.thisName.to_upper()).replace("/a", str(currentAttacker.target.lastDamageTaken))
		await fadeInLine(2)
	elif !currentAttacker.target.lastDamageTaken > 0 && currentAttacker.target.lastJuiceLost > 0:
		line_2.text = Dialog.battle["loseJuice"].replace("/t", currentAttacker.target.thisName.to_upper()).replace("/a", str(currentAttacker.target.lastJuiceLost))
		await fadeInLine(2)
	currentAttacker.target.lastDamageTaken = 0
	currentAttacker.target.lastJuiceLost = 0
func displayTextSound(text: Array, sfx):
	resetLines()
	match text.size():
		1:
			line_1.text = text[0]
		2:
			line_1.text = text[0]
			line_2.text = text[1]
		3:
			line_1.text = text[0]
			line_2.text = text[1]
			line_3.text = text[2]
		4:
			line_1.text = text[0]
			line_2.text = text[1]
			line_3.text = text[2]
			line_4.text = text[3]
		5:
			line_1.text = text[0]
			line_2.text = text[1]
			line_3.text = text[2]
			line_4.text = text[3]
			line_5.text = text[4]
	sfx.playing = true
	await fadeInLine(1)
	if text.size() >= 2:
		await fadeInLine(2)
		if text.size() >= 3:
			await fadeInLine(3)
			if text.size() >= 4:
				animation.play("revealLine4")
				await fadeInLine(4)
				if text.size() >= 5:
					animation.play("revealLine5")
					await fadeInLine(5)
	if text.size() > 5:
		resetLines()
		animation.play("resetLines")
		match text.size():
			6:
				line_1.text = text[5]
			7:
				line_1.text = text[5]
				line_2.text = text[6]
			8:
				line_1.text = text[5]
				line_2.text = text[6]
				line_3.text = text[7]
			9:
				line_1.text = text[5]
				line_2.text = text[6]
				line_3.text = text[7]
				line_4.text = text[8]
			10:
				line_1.text = text[5]
				line_2.text = text[6]
				line_3.text = text[7]
				line_4.text = text[8]
				line_5.text = text[9]
		sfx.playing = true
		await fadeInLine(1)
		if text.size() >= 6:
			await fadeInLine(2)
			if text.size() >= 7:
				await fadeInLine(3)
				if text.size() >= 8:
					animation.play("revealLine4")
					await fadeInLine(4)
					if text.size() >= 9:
						animation.play("revealLine5")
						await fadeInLine(5)
		await get_tree().create_timer(2).timeout
		resetLines()
		animation.play("resetLines")
	if text.size() > 10:
		match text.size():
			11:
				line_1.text = text[10]
			12:
				line_1.text = text[10]
				line_2.text = text[11]
			13:
				line_1.text = text[10]
				line_2.text = text[11]
				line_3.text = text[12]
			14:
				line_1.text = text[10]
				line_2.text = text[11]
				line_3.text = text[12]
				line_4.text = text[13]
			15:
				line_1.text = text[10]
				line_2.text = text[11]
				line_3.text = text[12]
				line_4.text = text[13]
				line_5.text = text[14]
		sfx.playing = true
		await fadeInLine(1)
		if text.size() >= 11:
			await fadeInLine(2)
			if text.size() >= 12:
				await fadeInLine(3)
				if text.size() >= 13:
					animation.play("revealLine4")
					await fadeInLine(4)
					if text.size() >= 14:
						animation.play("revealLine5")
						await fadeInLine(5)
		await get_tree().create_timer(2).timeout
		resetLines()
		animation.play("resetLines")
func displayTextNoReset(text: Array):
	resetLines()
	match text.size():
		1:
			line_1.text = text[0]
		2:
			line_1.text = text[0]
			line_2.text = text[1]
		3:
			line_1.text = text[0]
			line_2.text = text[1]
			line_3.text = text[2]
	await fadeInLine(1)
	if text.size() >= 2:
		await fadeInLine(2)
		if text.size() >= 3:
			await fadeInLine(3)
	await get_tree().create_timer(2).timeout
func displayText(text: Array):
	resetLines()
	match text.size():
		1:
			line_1.text = text[0]
		2:
			line_1.text = text[0]
			line_2.text = text[1]
		3:
			line_1.text = text[0]
			line_2.text = text[1]
			line_3.text = text[2]
		4:
			line_1.text = text[0]
			line_2.text = text[1]
			line_3.text = text[2]
			line_4.text = text[3]
		5:
			line_1.text = text[0]
			line_2.text = text[1]
			line_3.text = text[2]
			line_4.text = text[3]
			line_5.text = text[4]
	await fadeInLine(1)
	if text.size() >= 2:
		await fadeInLine(2)
		if text.size() >= 3:
			await fadeInLine(3)
			if text.size() >= 4:
				animation.play("revealLine4")
				await fadeInLine(4)
				if text.size() >= 5:
					animation.play("revealLine5")
					await fadeInLine(5)
	await get_tree().create_timer(2).timeout
	resetLines()
	animation.play("resetLines")
	if text.size() > 5:
		match text.size():
			6:
				line_1.text = text[5]
			7:
				line_1.text = text[5]
				line_2.text = text[6]
			8:
				line_1.text = text[5]
				line_2.text = text[6]
				line_3.text = text[7]
			9:
				line_1.text = text[5]
				line_2.text = text[6]
				line_3.text = text[7]
				line_4.text = text[8]
			10:
				line_1.text = text[5]
				line_2.text = text[6]
				line_3.text = text[7]
				line_4.text = text[8]
				line_5.text = text[9]
		await fadeInLine(1)
		if text.size() >= 6:
			await fadeInLine(2)
			if text.size() >= 7:
				await fadeInLine(3)
				if text.size() >= 8:
					animation.play("revealLine4")
					await fadeInLine(4)
					if text.size() >= 9:
						animation.play("revealLine5")
						await fadeInLine(5)
		await get_tree().create_timer(2).timeout
		resetLines()
		animation.play("resetLines")
	if text.size() > 10:
		match text.size():
			11:
				line_1.text = text[10]
			12:
				line_1.text = text[10]
				line_2.text = text[11]
			13:
				line_1.text = text[10]
				line_2.text = text[11]
				line_3.text = text[12]
			14:
				line_1.text = text[10]
				line_2.text = text[11]
				line_3.text = text[12]
				line_4.text = text[13]
			15:
				line_1.text = text[10]
				line_2.text = text[11]
				line_3.text = text[12]
				line_4.text = text[13]
				line_5.text = text[14]
		await fadeInLine(1)
		if text.size() >= 11:
			await fadeInLine(2)
			if text.size() >= 12:
				await fadeInLine(3)
				if text.size() >= 13:
					animation.play("revealLine4")
					await fadeInLine(4)
					if text.size() >= 14:
						animation.play("revealLine5")
						await fadeInLine(5)
		await get_tree().create_timer(2).timeout
		resetLines()
		animation.play("resetLines")
func selectActionButton(action_type: String):
	animation.play("displayActionBox")
	if selected_player == 1:
		luke.action = action_type
	elif selected_player == 2:
		brenna.action = action_type
	gray_out_cursor(action_cursor, choice_cursor)
func gray_out_cursor(gray_cursor, red_cursor):
	var mat = ShaderMaterial.new()
	mat.shader = BOUNCE_SIDEWAYS
	if gray_cursor:
		gray_cursor.texture = GRAY_POINTER_RIGHT
		gray_cursor.material.shader = null
	if red_cursor:
		red_cursor.texture = RED_POINTER_RIGHT
		red_cursor.material = mat
func move_down():
	if selected_cursor == "fightRun":
		currently_selected = (currently_selected - 1 + 2) % 2
		action_cursor.global_position = fight_run_buttons[currently_selected].global_position
		sfx_move.playing = true
	elif selected_cursor == "selectAction":
		currently_selected = (currently_selected + 2) % 4
		action_cursor.global_position = action_buttons[currently_selected].global_position
		dialogTextVisible()
		sfx_move.playing = true
	elif selected_cursor == "selectSkill":
		currently_selected = (currently_selected + 2) % 4
		choice_cursor.global_position = choice_buttons[currently_selected].global_position
		up_arrow.visible = false
		down_arrow.visible = false
		checkCost()
		sfx_move.playing = true
	elif selected_cursor == "selectToy":
		if currently_selected == 0 || currently_selected == 1:
			if MainInfo.heldToys.size() >= currently_selected + 3 + currentLayerToy * 2:
				currently_selected += 2
				choice_cursor.global_position = choice_buttons[currently_selected].global_position
				sfx_move.playing = true
				checkHold()
		elif currently_selected == 2 || currently_selected == 3:
			if MainInfo.heldToys.size() > 4 + currentLayerToy * 2:
				sfx_move.playing = true
				up_arrow.visible = true
				currentLayerToy += 1
				setLastLayer()
				if !MainInfo.heldToys.size() >= currently_selected + 1 + currentLayerToy * 2:
					currently_selected -= 2
				choice_cursor.global_position = choice_buttons[currently_selected].global_position
				var snack_list = [option_1, option_2, option_3, option_4]
				var snacks = MainInfo.heldToys
				var i = 0
				for snack in snack_list:
					snack.text = ""
					if MainInfo.heldToys.size() >= i + currentLayerToy * 2:
						if snacks.size() >= i + 1 + currentLayerToy * 2:
							var snackeroo = SkillsItemsWeapons.toys.get(snacks.keys()[i + currentLayerToy * 2])
							var snack_name = snackeroo["name"]
							snack.text = snack_name.to_upper()
						else:
							snack.text = ""
					i += 1
				if MainInfo.heldToys.size() > 4 + currentLayerToy * 2:
					down_arrow.visible = true
				else:
					down_arrow.visible = false
					
				checkHold()
			elif MainInfo.heldToys.size() <= 4:
				up_arrow.visible = false
				down_arrow.visible = false
	elif selected_cursor == "selectSnack":
		if currently_selected == 0 || currently_selected == 1:
			if MainInfo.heldSnacks.size() >= currently_selected + 3 + currentLayer * 2:
				currently_selected += 2
				choice_cursor.global_position = choice_buttons[currently_selected].global_position
				sfx_move.playing = true
				checkHold()
		elif currently_selected == 2 || currently_selected == 3:
			if MainInfo.heldSnacks.size() > 4 + currentLayer * 2:
				sfx_move.playing = true
				up_arrow.visible = true
				currentLayer += 1
				if !MainInfo.heldSnacks.size() >= currently_selected + 1 + currentLayer * 2:
					currently_selected -= 2
				choice_cursor.global_position = choice_buttons[currently_selected].global_position
				var snack_list = [option_1, option_2, option_3, option_4]
				var snacks = MainInfo.heldSnacks
				var i = 0
				for snack in snack_list:
					snack.text = ""
					if MainInfo.heldSnacks.size() >= i + currentLayer * 2:
						if snacks.size() >= i + 1 + currentLayer * 2:
							var snackeroo = SkillsItemsWeapons.snacks.get(snacks.keys()[i + currentLayer * 2])
							var snack_name = snackeroo["name"]
							snack.text = snack_name.to_upper()
						else:
							snack.text = ""
					i += 1
				if MainInfo.heldSnacks.size() > 4 + currentLayer * 2:
					down_arrow.visible = true
				else:
					down_arrow.visible = false
					
				checkHold()
			elif MainInfo.heldSnacks.size() <= 4:
				up_arrow.visible = false
				down_arrow.visible = false
func move_up():
	if selected_cursor == "fightRun":
		currently_selected = (currently_selected + 1) % 2
		action_cursor.global_position = fight_run_buttons[currently_selected].global_position
		sfx_move.playing = true
	elif selected_cursor == "selectAction":
		currently_selected = (currently_selected + 2) % 4
		action_cursor.global_position = action_buttons[currently_selected].global_position
		dialogTextVisible()
		sfx_move.playing = true
	elif selected_cursor == "selectSkill":
		currently_selected = (currently_selected + 2) % 4
		choice_cursor.global_position = choice_buttons[currently_selected].global_position
		checkCost()
		sfx_move.playing = true
	elif selected_cursor == "selectToy":
		if currently_selected == 2 || currently_selected == 3:
			currently_selected -= 2
			choice_cursor.global_position = choice_buttons[currently_selected].global_position
			sfx_move.playing = true
			checkHold()
			if currentLayerToy == 0:
				up_arrow.visible = false
			if MainInfo.heldToys.size() > 4 + currentLayerToy * 2:
				down_arrow.visible = true
			else:
				down_arrow.visible = false
		elif currently_selected == 0 || currently_selected == 1:
			if currentLayerToy != 0:
				sfx_move.playing = true
				currentLayerToy -= 1
				setLastLayer()
				choice_cursor.global_position = choice_buttons[currently_selected].global_position
				var snack_list = [option_1, option_2, option_3, option_4]
				var snacks = MainInfo.heldToys
				var i = 0
				for snack in snack_list:
					snack.text = ""
					if MainInfo.heldToys.size() >= i + 1: # 
						var snackeroo = SkillsItemsWeapons.toys.get(snacks.keys()[i + currentLayerToy * 2])
						var snack_name = snackeroo["name"]
						snack.text = snack_name.to_upper()
					i += 1
				if currentLayerToy != 0:
					up_arrow.visible = true
				else:
					up_arrow.visible = false
				if MainInfo.heldToys.size() > 4 + currentLayerToy * 2:
					down_arrow.visible = true
				else:
					down_arrow.visible = false
				checkHold()
			elif MainInfo.heldToys.size() <= 4:
				up_arrow.visible = false
				down_arrow.visible = false
			else:
				down_arrow.visible = true
	elif selected_cursor == "selectSnack":
		if currently_selected == 2 || currently_selected == 3:
			currently_selected -= 2
			choice_cursor.global_position = choice_buttons[currently_selected].global_position
			sfx_move.playing = true
			checkHold()
			if currentLayer == 0:
				up_arrow.visible = false
			if MainInfo.heldSnacks.size() > 4 + currentLayer * 2:
				down_arrow.visible = true
			else:
				down_arrow.visible = false
		elif currently_selected == 0 || currently_selected == 1:
			if currentLayer != 0:
				sfx_move.playing = true
				currentLayer -= 1
				choice_cursor.global_position = choice_buttons[currently_selected].global_position
				var snack_list = [option_1, option_2, option_3, option_4]
				var snacks = MainInfo.heldSnacks
				var i = 0
				for snack in snack_list:
					snack.text = ""
					if MainInfo.heldSnacks.size() >= i + 1: # 
						var snackeroo = SkillsItemsWeapons.snacks.get(snacks.keys()[i + currentLayer * 2])
						var snack_name = snackeroo["name"]
						snack.text = snack_name.to_upper()
					i += 1
				if currentLayer != 0:
					up_arrow.visible = true
				else:
					up_arrow.visible = false
				if MainInfo.heldSnacks.size() > 4 + currentLayer * 2:
					down_arrow.visible = true
				else:
					down_arrow.visible = false
				checkHold()
			elif MainInfo.heldSnacks.size() <= 4:
				up_arrow.visible = false
				down_arrow.visible = false
			else:
				if MainInfo.heldSnacks.size() > 4 + currentLayer * 2:
					down_arrow.visible = true
func move_left():
	if selected_cursor == "selectAction":
		sfx_move.playing = true
		currently_selected = (currently_selected - 1 + 4) % 4
		action_cursor.global_position = action_buttons[currently_selected].global_position
		dialogTextVisible()
	elif selected_cursor == "selectSkill":
		sfx_move.playing = true
		currently_selected = (currently_selected - 1 + 4) % 4
		choice_cursor.global_position = choice_buttons[currently_selected].global_position
		checkCost()
	elif selected_cursor == "selectSnack":
		if currently_selected == 1 || currently_selected == 3:
			currently_selected = (currently_selected - 1)
			sfx_move.playing = true
		choice_cursor.global_position = choice_buttons[currently_selected].global_position
		checkHold()
	elif selected_cursor == "selectToy":
		if currently_selected == 1 || currently_selected == 3:
			currently_selected = (currently_selected - 1)
			sfx_move.playing = true
		choice_cursor.global_position = choice_buttons[currently_selected].global_position
		checkHold()
	elif selected_cursor == "selectFoe":
		sfx_move.playing = true
		currently_selected = (currently_selected - 1 + foes.size()) % foes.size()
		for foe in foes:
			foe.hp_frame.visible = false
		foes[currently_selected].hp_frame.visible = true
		if selected_player == 1:
			luke.target = foes[currently_selected]
		elif selected_player == 2:
			brenna.target = foes[currently_selected]
	elif selected_cursor == "selectFriend":
		sfx_move.playing = true
		var action
		if selected_player == 1:
			action = luke.action
		elif selected_player == 2:
			action = brenna.action
		if action == "toy":
			if luke.slot["name"] == "Life Jam":
				currently_selected = (currently_selected + 1) % players.size()
				if selected_player == 1:
					luke.target = players[currently_selected]
				elif selected_player == 2:
					brenna.target = players[currently_selected]
			else:
				currently_selected = (currently_selected + 1) % alivePlayers.size()
				if selected_player == 1:
					luke.target = alivePlayers[currently_selected]
				elif selected_player == 2:
					brenna.target = alivePlayers[currently_selected]
		else:
			currently_selected = (currently_selected + 1) % alivePlayers.size()
			if selected_player == 1:
				luke.target = alivePlayers[currently_selected]
			elif selected_player == 2:
				brenna.target = alivePlayers[currently_selected]
		if currently_selected == 0:
			luke.animation.play("highlighted")
			brenna.animation.play("unhighlight")
		if currently_selected == 1:
			brenna.animation.play("highlighted")
			luke.animation.play("unhighlight")
	elif selected_cursor == "selectEither":
		sfx_move.playing = true
		if choosing_friend_foe:
			for foe in foes:
				foe.hp_frame.visible = false
			currently_selected = (currently_selected - 1 + alivePlayers.size()) % alivePlayers.size()
			if currently_selected == 0:
				luke.animation.play("highlighted")
				brenna.animation.play("unhighlight")
			if currently_selected == 1:
				brenna.animation.play("highlighted")
				luke.animation.play("unhighlight")
			if selected_player == 1:
				luke.target = alivePlayers[currently_selected]
			elif selected_player == 2:
				brenna.target = alivePlayers[currently_selected]
		elif !choosing_friend_foe:
			luke.animation.play("unhighlight")
			brenna.animation.play("unhighlight")
			currently_selected = (currently_selected - 1 + foes.size()) % foes.size()
			for foe in foes:
				foe.hp_frame.visible = false
			foes[currently_selected].hp_frame.visible = true
			if selected_player == 1:
				luke.target = foes[currently_selected]
			elif selected_player == 2:
				brenna.target = foes[currently_selected]
func move_right():
	if selected_cursor == "selectAction":
		sfx_move.playing = true
		currently_selected = (currently_selected + 1) % 4
		action_cursor.global_position = action_buttons[currently_selected].global_position
		dialogTextVisible()
	elif selected_cursor == "selectSkill":
		sfx_move.playing = true
		currently_selected = (currently_selected + 1) % 4
		choice_cursor.global_position = choice_buttons[currently_selected].global_position
		checkCost()
	elif selected_cursor == "selectSnack":
		if currently_selected == 0 || currently_selected == 2:
			if MainInfo.heldSnacks.size() >= currently_selected + 2 + currentLayer * 2:
				currently_selected = (currently_selected + 1)
				sfx_move.playing = true
		choice_cursor.global_position = choice_buttons[currently_selected].global_position
		checkHold()
	elif selected_cursor == "selectToy":
		if currently_selected == 0 || currently_selected == 2:
			if MainInfo.heldToys.size() >= currently_selected + 2 + currentLayerToy * 2:
				currently_selected = (currently_selected + 1)
				sfx_move.playing = true
		choice_cursor.global_position = choice_buttons[currently_selected].global_position
		checkHold()
	elif selected_cursor == "selectFoe":
		sfx_move.playing = true
		currently_selected = (currently_selected + 1) % foes.size()
		for foe in foes:
			foe.hp_frame.visible = false
		foes[currently_selected].hp_frame.visible = true
		if selected_player == 1:
			luke.target = foes[currently_selected]
		elif selected_player == 2:
			brenna.target = foes[currently_selected]
	elif selected_cursor == "selectFriend":
		sfx_move.playing = true
		var action
		if selected_player == 1:
			action = luke.action
		elif selected_player == 2:
			action = brenna.action
		if action == "snack":
			if luke.slot["name"] == "Life Jam":
				currently_selected = (currently_selected + 1) % players.size()
				if selected_player == 1:
					luke.target = players[currently_selected]
				elif selected_player == 2:
					brenna.target = players[currently_selected]
			else:
				currently_selected = (currently_selected + 1) % alivePlayers.size()
				if selected_player == 1:
					luke.target = alivePlayers[currently_selected]
				elif selected_player == 2:
					brenna.target = alivePlayers[currently_selected]
		else:
			currently_selected = (currently_selected + 1) % alivePlayers.size()
			if selected_player == 1:
				luke.target = alivePlayers[currently_selected]
			elif selected_player == 2:
				brenna.target = alivePlayers[currently_selected]
		if currently_selected == 0:
			luke.animation.play("highlighted")
			brenna.animation.play("unhighlight")
		if currently_selected == 1:
			brenna.animation.play("highlighted")
			luke.animation.play("unhighlight")
	elif selected_cursor == "selectEither":
		sfx_move.playing = true
		if choosing_friend_foe:
			for foe in foes:
				foe.hp_frame.visible = false
			currently_selected = (currently_selected + 1) % 2
			if currently_selected == 0:
				luke.animation.play("highlighted")
				brenna.animation.play("unhighlight")
			if currently_selected == 1:
				brenna.animation.play("highlighted")
				luke.animation.play("unhighlight")
			if selected_player == 1:
				luke.target = alivePlayers[currently_selected]
			elif selected_player == 2:
				brenna.target = alivePlayers[currently_selected]
		if !choosing_friend_foe:
			luke.animation.play("unhighlight")
			brenna.animation.play("unhighlight")
			currently_selected = (currently_selected + 1) % foes.size()
			for foe in foes:
				foe.hp_frame.visible = false
			foes[currently_selected].hp_frame.visible = true
			if selected_player == 1:
				luke.target = foes[currently_selected]
			elif selected_player == 2:
				brenna.target = foes[currently_selected]
func level_up(player: String):
	if player == "Luke":
		if luke.isAlive:
			while MainInfo.LukeStats["xp"] >= xp_required(MainInfo.LukeStats["level"]):
				MainInfo.LukeStats["xp"] -= xp_required(MainInfo.LukeStats["level"])
				MainInfo.LukeStats["level"] += 1
	if player == "Brenna":
		if brenna.isAlive && Logic.brennaInParty():
			while MainInfo.BrennaStats["xp"] >= xp_required(MainInfo.BrennaStats["level"]):
				MainInfo.BrennaStats["xp"] -= xp_required(MainInfo.BrennaStats["level"])
				MainInfo.BrennaStats["level"] += 1
func xp_required(level: int) -> int:
	return 30 + (level - 1) * 100
func fadeInLine(line: int):
	var lineNumber
	match line:
		1:
			lineNumber = line_1
		2:
			lineNumber = line_2
		3:
			lineNumber = line_3
		4:
			lineNumber = line_4
		5:
			lineNumber = line_5
	lineNumber.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = get_tree().create_tween()
	tween.tween_property(lineNumber, "self_modulate", Color(1.0, 1.0, 1.0), 0.2)
	await tween.finished
	await get_tree().create_timer(0.3).timeout

func releaseEnergy():
	attackAnimations.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = get_tree().create_tween()
	tween.tween_property(attackAnimations, "self_modulate", Color(1.0, 1.0, 1.0), 0.5)
	await tween.finished
	attackAnimations.play("release_energy")
	sfx_attack.stream = Resources.SFX_RELEASE_ENERGY
	sfx_attack.playing = true
	await attackAnimations.animation_finished
	var tween2 = get_tree().create_tween()
	tween2.tween_property(attackAnimations, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
	await tween2.finished
	attackAnimations.self_modulate = Color(1.0, 1.0, 1.0)
	attackAnimations.play("release_energy_attack")
	sfx_attack.stream = Resources.SFX_RELEASE_ENERGY_ATTACK
	sfx_attack.playing = true

func setLastLayer():
	if selected_player == 1:
		if luke.action == "snack":
			luke_last_layer = currentLayer
		elif luke.action == "toy":
			luke_last_layer = currentLayerToy
	elif selected_player == 2:
		if brenna.action == "snack":
			brenna_last_layer = currentLayer
		elif brenna.action == "toy":
			brenna_last_layer = currentLayerToy

func resetLines():
	line_1.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	line_2.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	line_3.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	line_4.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	line_5.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	line_1.text = ""
	line_2.text = ""
	line_3.text = ""
	line_4.text = ""
	line_5.text = ""
func dialogTextVisible():
	dialog_box_text.visible = true
	item_name.visible = false
	item_description.visible = false
	item_description_toy_snack.visible = false
	toy_snack_image.visible = false
	#up_arrow.visible = false
	#down_arrow.visible = false
	line_1.visible = false
	line_2.visible = false
	line_3.visible = false
	line_4.visible = false
	line_5.visible = false
func infoTextVisible():
	dialog_box_text.visible = false
	item_name.visible = true
	item_description.visible = true
	item_description_toy_snack.visible = false
	toy_snack_image.visible = false
	line_1.visible = false
	line_2.visible = false
	line_3.visible = false
	line_4.visible = false
	line_5.visible = false
func toySnackTextVisible():
	dialog_box_text.visible = false
	item_name.visible = true
	item_description.visible = false
	item_description_toy_snack.visible = true
	toy_snack_image.visible = true
	line_1.visible = false
	line_2.visible = false
	line_3.visible = false
	line_4.visible = false
	line_5.visible = false
func battleTextVisible():
	dialog_box_text.visible = false
	item_description.visible = false
	item_name.visible = false
	line_1.visible = true
	line_2.visible = true
	line_3.visible = true
	line_4.visible = true
	line_5.visible = true
func checkCost():
	var skillName
	if selected_player == 1:
		if luke_skills.size() <= currently_selected: return
		skillName = luke_skills[currently_selected]
	elif selected_player == 2:
		if brenna_skills.size() <= currently_selected: return
		skillName = brenna_skills[currently_selected]
	var skill_dictionary = SkillsItemsWeapons.skills.get(skillName)
	cost_amount.visible = true
	cost_icon.visible = true
	cost_amount.text = str(skill_dictionary["cost"])
	infoTextVisible()
	item_name.text = str(skillName)
	if str(skill_dictionary["description"]).length() <= 45:
		item_description.text = str(skill_dictionary["description"]) + "
		COST: " + str(skill_dictionary["cost"])
	else:
		item_description.text = str(skill_dictionary["description"]) + "   COST: " + str(skill_dictionary["cost"])
func checkHold():
	var n_action
	if selected_player == 1:
		n_action = luke.action
	if selected_player == 2:
		n_action = brenna.action
	if n_action == "snack":
		if MainInfo.heldSnacks.size() >= currently_selected + 1 + currentLayer * 2:
			var snack = MainInfo.heldSnacks.values()[currently_selected + currentLayer * 2]
			var snackName = MainInfo.heldSnacks.keys()[currently_selected + currentLayer * 2]
			var skill_dictionary = SkillsItemsWeapons.snacks.get(snackName)
			cost_icon.visible = false
			cost_amount.visible = false
			hold_cost.text = "HOLD: " + "x" + str(snack["hold"])
			toySnackTextVisible()
			item_name.text = str(snackName)
			toy_snack_image.texture = skill_dictionary["image"]
			item_description_toy_snack.text = str(skill_dictionary["description"])
	elif n_action == "toy":
		if MainInfo.heldToys.size() >= currently_selected + 1 + currentLayerToy * 2:
			var snack = MainInfo.heldToys.values()[currently_selected + currentLayerToy * 2]
			var snackName = MainInfo.heldToys.keys()[currently_selected + currentLayerToy * 2]
			var skill_dictionary = SkillsItemsWeapons.toys.get(snackName)
			cost_icon.visible = false
			cost_amount.visible = false
			hold_cost.text = "HOLD: " + "x" + str(snack["hold"])
			toySnackTextVisible()
			item_name.text = str(snackName)
			toy_snack_image.texture = skill_dictionary["image"]
			item_description_toy_snack.text = str(skill_dictionary["description"])

func update_stats():
	MainInfo.LukeStats["maxHeart"] = luke.maxHealth
	MainInfo.LukeStats["currentHeart"] = luke.health if luke.health > 0 else 1
	MainInfo.LukeStats["maxJuice"] = luke.maxJuice
	MainInfo.LukeStats["currentJuice"] = luke.juice
	
	MainInfo.BrennaStats["maxHeart"] = brenna.maxHealth
	MainInfo.BrennaStats["currentHeart"] = brenna.health if brenna.health > 0 else 1
	MainInfo.BrennaStats["maxJuice"] = brenna.maxJuice
	MainInfo.BrennaStats["currentJuice"] = brenna.juice
