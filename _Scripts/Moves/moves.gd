extends Node
class_name Moves

var label : Label
var moves : int

signal game_over()

func initialise_move_counter() -> void:
	label = self.get_node("Label")
	moves = 5
	label.text = str(moves)

func decrement_move_counter() -> void:
	moves-=1
	label.text = str(moves)
	
	if moves < 0:
		game_over.emit()
