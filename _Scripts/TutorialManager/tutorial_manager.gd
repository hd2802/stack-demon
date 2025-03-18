extends Node2D
class_name TutorialManager

func _ready() -> void:
	_GameManager.game_loop = false
	_LevelManager._clear_level()

func _on_yes_pressed() -> void:
	pass # Replace with function body.

func _on_no_pressed() -> void:
	pass # Replace with function body.
