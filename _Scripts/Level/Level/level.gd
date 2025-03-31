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

var deck_view_scene 

var current_score: int = 0
var target: int

var tier_complete = false

var discard_button
var deck_view

var multiplier_label : RichTextLabel

var button_audio
var audio
var failure

signal level_complete()
signal game_over()

func load_level(data) -> void:
	button_audio = $ButtonPress
	audio = $Success
	failure = $Failure
	
	title_node = self.get_node("LevelTitleLabel")
	title_node.text = "[wave amp=25 freq=1]Level " + str(data.level_number) + "/5[/wave]" 

	tier_title_node = self.get_node("LevelTierLabel")
	
	var print_tier : int
	if data.tier == 0:
		print_tier = data.tier + 1
	else:
		print_tier = data.tier
		
	tier_title_node.text = "[wave amp=25 freq=1]Round " + str(print_tier) + "/3[/wave]" 

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
	
	multiplier_label = $Multiplier

	discard_button = self.get_node("DiscardButton")

func _on_play_area_scored(sc: int, multiplier: int, is_complex: bool) -> void:
	var final_score = sc * multiplier
	current_score += final_score
	score.text = str(current_score)
	
	current_hands -= 1
	hands.text = str(current_hands)
	
	await get_tree().create_timer(1.0).timeout
	
	if current_score >= target:
		audio.play()
		await get_tree().create_timer(0.25).timeout
		level_complete.emit()
	elif current_hands == 0:
		failure.play()
		await get_tree().create_timer(0.25).timeout
		game_over.emit()

func _on_hint_button_pressed() -> void:
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
	var hint_scene = load("res://_Scenes/Hint/hint.tscn").instantiate()
	self.add_child(hint_scene)
	hint_scene.hint_closed.connect(_close_hint)

func _close_hint() -> void:
	for child in get_children():
		if child is Hint:
			self.remove_child(child)
			child.queue_free()
	
func _on_options_button_pressed() -> void:
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
	var options_scene = load("res://_Scenes/Options/options.tscn").instantiate()
	self.add_child(options_scene)
	options_scene.resume.connect(_close_options)

func _close_options() -> void:
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
	for child in get_children():
		if child is Options:
			self.remove_child(child)
			child.queue_free()

func _on_deck_pressed() -> void:	
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
	deck_view_scene = load("res://_Scenes/DeckView/deck_view.tscn").instantiate()
	self.add_child(deck_view_scene)
	deck_view_scene.back.connect(_remove_deck_view)

func _remove_deck_view() -> void:
	if deck_view_scene:
		self.remove_child(deck_view_scene)

func _on_play_area_hand_discarded() -> void:
	current_discards -= 1
	discards.text = str(current_discards)


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()
