extends Control
class_name LevelTransition

signal level_next()

var title

func _ready() -> void:
	title = $Title
	title.text = "[wave amp=25 freq=1.5] Level " + str(self.get_parent().current_level) +  " Complete[/wave]"

func _on_continue_button_pressed() -> void:
	level_next.emit()
