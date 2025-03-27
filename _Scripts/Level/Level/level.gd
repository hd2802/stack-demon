extends Node
class_name Level

var level_data : LevelDataResource

const MAX_HANDS : int = 4
const MAX_DISCARDS : int = 3

var current_hands : int = MAX_HANDS
var current_discards : int = MAX_DISCARDS

var title_node : RichTextLabel
var tier_title_node : RichTextLabel
var hand_node
var target_node : Target
var move_node : Moves
var play_area

var hands : Label
var discards : Label
var score : Label

var current_score : int = 0
var target : int

var tier_complete = false

var discard_button

signal level_complete()
signal game_over()

func load_level(data) -> void:
	# Title initialisation
	title_node = self.get_node("LevelTitleLabel")
	title_node.text = "[wave amp=25 freq=1]Level " + str(data.level_number) + "[/wave]" 
	
	# Tier title initialisation
	tier_title_node = self.get_node("LevelTierLabel")
	tier_title_node.text = "[wave amp=25 freq=1]Tier " + str(data.tier) + "[/wave]" 
	
	play_area = self.get_node("PlayArea")
	
	# Target initialisation
	target_node = self.get_node("Target")
	target_node.initialise_target(data.target_value)
	
	target = data.target_value
	
	hands = self.get_node("Hands")
	discards = self.get_node("Discards")
	hands.text = str(current_hands)
	discards.text = str(current_discards)
	
	score = self.get_node("Score")
	score.text = str(current_score)
	
	discard_button = self.get_node("DiscardButton")
	
func _on_play_area_hand_played() -> void:
	current_hands -= 1
	hands.text = str(current_hands)

func _on_play_area_scored(sc: int) -> void:
	current_score += sc
	score.text = str(current_score)
	
	if current_hands <= 0 and current_score < target:
		game_over.emit()
	elif current_score >= target:
		level_complete.emit()
	else:
		pass
		
func _on_play_area_hand_discarded() -> void:
	current_discards -= 1
	discards.text = str(current_discards)
	
	if current_discards <= 0:
		discard_button.disabled = true

# -----------------------------------------------------------------------------------
func _on_hint_button_pressed() -> void:
	pass # Replace with function body.

func _on_options_button_pressed() -> void:
	pass # Replace with function body.
