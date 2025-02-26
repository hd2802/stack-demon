extends Node
class_name Level

var level_data : LevelDataResource

var title_node : Label
var stack_node : Stack
var hand_node : Hand
var target_node : Target
var move_node : Moves

var next_button
var next_label

signal game_over()

func _ready() -> void:
	# Placeholder for testing and debugging
	level_data = load("res://Resources/Levels/zero.tres")
	
	# Title initialisation
	title_node = self.get_node("LevelTitleLabel")
	title_node.text = "LEVEL " + str(level_data.level_number)
	
	# Stack initialisation
	stack_node = self.get_node("Stack")
	
	# Hand initialisation
	hand_node = self.get_node("Hand")
	hand_node.initialise_hand(level_data.hand)
	
	# Target initialisation
	target_node = self.get_node("Target")
	target_node.initialise_target(level_data.target_value)
	
	# Setting up the target label
	var target_label = self.get_node("TargetLabelRich")
	if level_data.exact_target:
		target_label.text = "[center]SCORE [color=red]EXACTLY[/color][/center]"
	else:
		target_label.text = "[center]SCORE [color=red]AT LEAST[/color][/center]"
		
	# Setting up the Move Counter
	move_node = self.get_node("Moves")
	move_node.initialise_move_counter()
	
	# Initialising the Next Button
	next_button = self.get_node("NextButton")
	next_button.visible = false
	next_label = self.get_node("ContinueLabel")
	next_label.visible = false

func _on_hand_move() -> void:
	move_node.decrement_move_counter()

func _on_moves_game_over() -> void:
	game_over.emit()

func _on_stack_target_check(current_stack: Array[String]) -> void:
	if len(current_stack) == 1:
		if level_data.exact_target:
			if int(current_stack[0]) == level_data.target_value:
				# Level is complete
				print("Level complete")
				next_button.visible = true
				next_label.visible = true
		else:
			if int(current_stack[0]) >= level_data.target_value:
				# Level is complete
				print("Level complete")
				next_button.visible = true
				next_label.visible = true
	else:
		pass	
