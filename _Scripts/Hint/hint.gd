extends Node
class_name Hint 

signal hint_closed()

func _on_button_pressed() -> void:
	hint_closed.emit()
