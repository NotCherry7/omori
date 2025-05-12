extends Node

const BATTLE_MENU = preload("res://ui/battle/battle_menu.tscn")

func startBattle(enemies: Array):
	get_tree().paused = true
