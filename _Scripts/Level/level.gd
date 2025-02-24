extends Node
class_name Level

var level_data : LevelDataResource

var stack_node : Stack

func _ready() -> void:
	# Placeholder for testing and debugging
	level_data = load("res://Levels/test_level.tres")
	
	# Stack initialisation
	stack_node = self.get_node("Stack")
	stack_node.initialise_stack(level_data.start_stack)

func _process(delta: float) -> void:
	pass
