extends Node
class_name LambdaLevel

var level_data : LambdaLevelDataResource

var stack_node : LambdaStack

func _ready() -> void:
	# Placeholder for testing and debugging
	level_data = load("res://Resources/Levels/LambdaLevels/sample.tres")
	
	# Stack initialisation
	stack_node = self.get_node("LambdaStack")
	stack_node.initialise_stack(level_data.start_stack)

func _process(delta: float) -> void:
	pass
