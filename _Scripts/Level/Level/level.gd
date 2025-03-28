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

var deck_view

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

func _on_play_area_scored(sc: int) -> void:
	current_score += sc
	score.text = str(current_score)
	
	current_hands -= 1
	hands.text = str(current_hands)

	if current_hands == 0:
		if current_score >= target:
			await get_tree().create_timer(1.25).timeout
			print("complete")
			level_complete.emit()
		else:
			await get_tree().create_timer(1.25).timeout
			print("game over")
			game_over.emit()
	elif current_hands > 0:
		if current_score >= target:
			await get_tree().create_timer(1.25).timeout
			level_complete.emit()
			print("complete")
		else:
			pass
	else:
		await get_tree().create_timer(1.25).timeout
		game_over.emit()
		print("game over")
		
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

func _on_deck_pressed() -> void:
	deck_view = load("res://_Scenes/DeckView/deck_view.tscn").instantiate()
	deck_view.back.connect(_back_to_level)
	self.add_child(deck_view)

func _back_to_level() -> void:
	self.remove_child(deck_view)
	deck_view.queue_free()
