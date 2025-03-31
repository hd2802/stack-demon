extends Node
class_name Options

var button_audio

signal resume()

func _ready() -> void:
	get_tree().paused = true
	button_audio = $AudioStreamPlayer2D

func _on_restart_pressed() -> void:
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
	get_tree().paused = false
	_GameManager.game_loop = true
	get_tree().change_scene_to_file("res://_Scenes/LevelRunner/level_runner.tscn")

func _on_resume_pressed() -> void:
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
	get_tree().paused = false
	resume.emit()

func _on_cross_button_pressed() -> void:
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
	get_tree().paused = false
	resume.emit()

func _on_main_menu_pressed() -> void:
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
	get_tree().paused = false
	_GameManager.game_loop = false
	get_tree().change_scene_to_file("res://_Scenes/MainMenu/main_menu.tscn")


func _on_mute_toggled(toggled_on: bool) -> void:
	self.get_parent().get_node("AudioStreamPlayer").playing = false
