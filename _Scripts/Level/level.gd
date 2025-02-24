extends Node
class_name Level

var level_data : LevelDataResource

var stack_node : Stack
var hand_node : Hand
var target_node : Target

func _ready() -> void:
	# Placeholder for testing and debugging
	level_data = load("res://Levels/level_one.tres")
	
	# Stack initialisation
	stack_node = self.get_node("Stack")
	stack_node.initialise_stack(level_data.start_stack)
	
	# Hand initialisation
	hand_node = self.get_node("Hand")
	hand_node.initialise_hand(level_data.hand)
	
	# Target initialisation
	target_node = self.get_node("Target")
	target_node.initialise_target(level_data.target_state)

func _process(delta: float) -> void:
	pass
