extends Node
class_name Level

var level_data : LevelDataResource

var stack_node : Stack

var hand_node : Hand

func _ready() -> void:
	# Placeholder for testing and debugging
	level_data = load("res://Levels/level_one.tres")
	
	# Stack initialisation
	stack_node = self.get_node("Stack")
	stack_node.initialise_stack(level_data.start_stack)
	
	# Hand initialisation
	hand_node = self.get_node("Hand")
	hand_node.initialise_hand(level_data.hand)

func _process(delta: float) -> void:
	pass
