extends Node
class_name Level

var level_data : LevelDataResource

var title_node : Label
var tier_title_node : Label
var hand_node : Hand
var target_node : Target
var move_node : Moves

var next_button
var next_label

var target : int

var tier_complete = false

signal level_complete()
signal game_over()
signal moves_decremented()

func _ready() -> void:
	# Placeholder for testing and debugging
	#level_data = load("res://Resources/Levels/zero.tres")
	#load_level(level_data)
	pass
	

func load_level(level_data) -> void:
	# Title initialisation
	title_node = self.get_node("LevelTitleLabel")
	title_node.text = "Level " + str(level_data.level_number)
	
	# Tier title initialisation
	tier_title_node = self.get_node("LevelTierLabel")
	tier_title_node.text = "Tier " + str(level_data.tier)
	
	# Hand initialisation
	hand_node = self.get_node("Hand")
	
	# Target initialisation
	target_node = self.get_node("Target")
	target_node.initialise_target(level_data.target_value)
	
	target = level_data.target_value

func _on_next_button_pressed() -> void:
	level_complete.emit()
