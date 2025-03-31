extends Node
class_name TutorialLevel

var level_data : LevelDataResource

var tutorial_step : int = 0

var tutorial_panel : ColorRect
var tutorial_label : Label

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

var play_card_button
var discard_button

var back_button

var next_button

var exit_button 

var main_menu_button

signal exit_tutorial()

var button_audio

func _ready() -> void:
	button_audio = $ButtonPress
	level_data = load("res://resources/Levels/start.tres")
	load_level(level_data)
	main_menu_button = $MainMenuButton
	main_menu_button.disabled = true
	for child in get_children():
		if child is not ColorRect:
			if child is not AnimationPlayer:
				if child is not AudioStreamPlayer2D:
					child.visible = false
	
	for child in get_children():
		if child is Button:
			child.disabled = true
	
	tutorial_panel = $TutorialPanel
	tutorial_label = $TutorialPanel/Label
	next_button = self.get_node("NextButton")
	next_button.visible = true
	next_button.disabled = false
	
	back_button = self.get_node("BackButton")
	back_button.visible = true
	back_button.disabled = false
	
	play_card_button = $PlayCardButton
	
	var exit_button = $Button
	exit_button.visible = true
	exit_button.disabled = false
	for card in self.get_node("PlayArea").get_node("Hand").get_children():
		card.disabled = true
		
	process_tutorial()

# this is going to be one messy function
# processes the tutorial and all the introduction of new game mechanics e.t.c.
func process_tutorial() -> void:
	match tutorial_step:
		0:
			back_button.visible = false
			tutorial_label.text = "In this game, you need to use play cards and
			use POSTFIX NOTATION to reach a target score.
			"
		1:
			back_button.visible = true
			tutorial_label.text = "Postfix notation is a method of 
			writing mathematical expressions that is 
			often used in older computers,
			calculators and algorithms in computer science.
			"
		2:
			tutorial_label.text = "Rather than writing
			2 + 3
			in normal notation (infix notation);
			in postfix notation we write
			2 3 +"
		3:
			tutorial_label.text = "This removes the needs for brackets
			and means that expressions can be evaluated 
			on a stack - an important data structrue in 
			computer science"
		4:
			tutorial_label.text = "Your challenge is to learn
			and use the postfix notation 
			to reach a target score."
		5:
			self.get_node("TargetLabel").visible = true
			self.get_node("CurrentScore").visible = true
			self.get_node("Score").visible = true
			target_node.visible = true
			tutorial_label.text = "For example, in this level
			the target score that you have to reach is 2
			(displayed in the information panel above)"
		6:
			self.get_node("PlayArea").visible = true
			tutorial_label.text = "The way that you construct
			these expressions is using the cards below"
		7:
			tutorial_label.text = "Select cards from the hand
			in postfix order to create an expression"
		8:
			self.get_node("PlayCardButton").visible = true
			tutorial_label.text = "You can press the play button
			to evaluate the expression and add it to
			your current score"
		9:
			tutorial_label.text = "Playing a valid postfix
			expression will give you more score towards the
			target"
		10:
			self.get_node("DiscardButton").visible = true
			tutorial_label.text = "If you want some new
			cards you can select the ones you want to
			get rid of and press the discard button"
		11:
			self.get_node("HandLabel").visible = true
			self.get_node("Hands").visible = true
			tutorial_label.text = "Be careful, as you can
			only play so many expression to reach
			the target"
		12:
			tutorial_label.text = "Run out of hands
			without reaching the target, and its game over"
		13:
			self.get_node("DiscardsLabel").visible = true
			self.get_node("Discards").visible = true
			tutorial_label.text = "You are also only allowed to
			discard up to 3 times, so be clever
			in which cards you discard and which you keep"
		14:
			self.get_node("LevelTierLabel").visible = true
			tutorial_label.text = "Reaching the target completes
			the ROUND"
		15:
			self.get_node("LevelTitleLabel").visible = true
			tutorial_label.text = "There are three rounds in each level. 
			Completing a level rewards you with 
			modifiersthat can help you reach your 
			target in further levels."
		16:
			tutorial_label.text = "Learning postifx notation and 
			how to play the game requires a practice.
			Press the next button to attempt the first level."
		17:
			for child in self.get_children():
				if child is Button:
					child.disabled = false
			discard_button.disabled = false
			play_card_button.disabled = false
			tutorial_label.visible = false
			tutorial_panel.visible = false
			next_button.visible = false
			back_button.visible = false
			for card in self.get_node("PlayArea").get_node("Hand").get_children():
				card.disabled = false
		18:
			tutorial_label.visible = true
			tutorial_panel.visible = true
			
			tutorial_label.text = "Congratulations on completing the
			tutorial! You are now ready to play the game 
			- good luck!
			(Click anywhere to return to the main menu)"
			main_menu_button.disabled = false
		_:
			pass
			
func _on_next_button_pressed() -> void:
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
	tutorial_step += 1
	process_tutorial()

func _on_back_button_pressed() -> void:
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
	tutorial_step -= 1
	process_tutorial()

func load_level(data) -> void:
	# Title initialisation
	title_node = self.get_node("LevelTitleLabel")
	title_node.text = "[wave amp=25 freq=1]Level " + str(data.level_number) + "[/wave]" 
	
	# Tier title initialisation
	tier_title_node = self.get_node("LevelTierLabel")
	tier_title_node.text = "[wave amp=25 freq=1]Round " + str(data.tier) + "[/wave]" 
	
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
			next_button.visible = true
			print("complete")
		else:
			await get_tree().create_timer(1.25).timeout
			print("game over")

	elif current_hands > 0:
		if current_score >= target:
			await get_tree().create_timer(1.25).timeout
			next_button.visible = true
			print("complete")
		else:
			pass
	else:
		await get_tree().create_timer(1.25).timeout
		print("game over")
		
func _on_play_area_hand_discarded() -> void:
	current_discards -= 1
	discards.text = str(current_discards)
	
	if current_discards <= 0:
		discard_button.disabled = true

# -----------------------------------------------------------------------------------


func _on_play_card_button_pressed() -> void:
	pass # Replace with function body.

func _on_discard_button_pressed() -> void:
	pass # Replace with function body.

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://_Scenes/MainMenu/main_menu.tscn")
