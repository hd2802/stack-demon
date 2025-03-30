extends Node
class_name Level

var level_data: LevelDataResource

const MAX_HANDS: int = 4
const MAX_DISCARDS: int = 3

var current_hands: int = MAX_HANDS
var current_discards: int = MAX_DISCARDS

var title_node: RichTextLabel
var tier_title_node: RichTextLabel
var hand_node
var target_node: Target
var move_node: Moves
var play_area

var hands: Label
var discards: Label
var score: Label

var current_score: int = 0
var target: int

var tier_complete = false

var discard_button
var deck_view

signal level_complete()
signal game_over()

func load_level(data) -> void:
	title_node = self.get_node("LevelTitleLabel")
	title_node.text = "[wave amp=25 freq=1]Level " + str(data.level_number) + "[/wave]" 

	tier_title_node = self.get_node("LevelTierLabel")
	tier_title_node.text = "[wave amp=25 freq=1]Tier " + str(data.tier) + "[/wave]" 

	play_area = self.get_node("PlayArea")

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

func _on_play_area_scored(sc: int, multiplier: int, is_complex: bool) -> void:
	var final_score = sc * multiplier
	current_score += final_score
	score.text = str(current_score)
	
	var mult_label = $Multiplier
	
	mult_label.text = "[wave amp=25 freq=1]Mult:\n"+ str(multiplier) + "[/wave]"
	current_hands -= 1
	hands.text = str(current_hands)
	
	await get_tree().create_timer(1.0).timeout
	
	if current_score >= target:
		level_complete.emit()
	elif current_hands == 0:
		game_over.emit()


func _on_hint_button_pressed() -> void:
	var hint_scene = load("res://_Scenes/Hint/hint.tscn").instantiate()
	self.add_child(hint_scene)
	hint_scene.hint_closed.connect(_close_hint)

func _close_hint() -> void:
	for child in get_children():
		if child is Hint:
			self.remove_child(child)
			child.queue_free()
