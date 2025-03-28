extends Control
class_name LevelTransition

signal level_next()

func _on_continue_button_pressed() -> void:
	level_next.emit()
