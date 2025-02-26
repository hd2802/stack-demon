extends Node
class_name Level

var level_data : LevelDataResource

var title_node : Label
var stack_node : Stack
var hand_node : Hand
var target_node : Target
var move_node : Moves

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
	

func _process(delta: float) -> void:
	pass

func _on_hand_move() -> void:
	move_node.decrement_move_counter()
