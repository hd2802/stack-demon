extends Node
class_name Moves

var label : Label
var num : int

signal game_over()

func set_move_counter(moves : int) -> void:
	label = self.get_node("Label")
	num = moves
	label.text = str(num)

func decrement_move_counter() -> void:
	num-=1
	label.text = str(num)
	
	if num < 0:
		game_over.emit()
