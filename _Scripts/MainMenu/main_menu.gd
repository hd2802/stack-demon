extends Control
class_name MainMenu

func _ready() -> void:
	_GameManager.game_loop = false

func _on_play_button_pressed() -> void:
	_GameManager.game_loop = true
	get_tree().change_scene_to_file("res://_Scenes/LevelRunner/level_runner.tscn")

func _on_tutorial_button_pressed() -> void:
	pass # Replace with function body.


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.
