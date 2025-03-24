extends Node
class_name Level

var level_data : LevelDataResource

const MAX_HANDS : int = 5
const MAX_DISCARDS : int = 5

var current_hands : int = MAX_HANDS
var current_discards : int = MAX_DISCARDS

var title_node : Label
var tier_title_node : Label
var hand_node : Hand
var target_node : Target
var move_node : Moves

var hands : Label
var discards : Label
var score : Label

var current_score : int = 0
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
	
	hands = self.get_node("Hands")
	discards = self.get_node("Discards")
	hands.text = str(current_hands)
	discards.text = str(current_discards)
	
	score = self.get_node("Score")
	score.text = str(current_score)
	

func _on_next_button_pressed() -> void:
	level_complete.emit()

# TODO: add what happens when the hands < 0 (i.e. game over if target not reached)
func _on_hand_hand_played() -> void:
	current_hands -= 1
	hands.text = str(current_hands)

# TODO: add what happens when the discards < 0 (i.e. disabling discard button)
func _on_hand_hand_discarded() -> void:
	current_discards -= 1
	discards.text = str(current_discards)

func _on_hand_scored(sc: int) -> void:
	current_score += sc
	print(sc)
	score.text = str(current_score)
	
	if current_score >= target:
		tier_complete = true

# -----------------------------------------------------------------------------------
func _on_hint_button_pressed() -> void:
	pass # Replace with function body.

func _on_options_button_pressed() -> void:
	pass # Replace with function body.
