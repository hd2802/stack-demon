extends Node
class_name Options

signal resume()

func _ready() -> void:
	get_tree().paused = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	_GameManager.game_loop = true
	get_tree().change_scene_to_file("res://_Scenes/LevelRunner/level_runner.tscn")

func _on_resume_pressed() -> void:
	get_tree().paused = false
	resume.emit()

func _on_cross_button_pressed() -> void:
	get_tree().paused = false
	resume.emit()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	_GameManager.game_loop = false
	get_tree().change_scene_to_file("res://_Scenes/MainMenu/main_menu.tscn")
