extends Control
class_name MainMenu

var button_audio

func _ready() -> void:
	_GameManager.game_loop = false
	button_audio = $AudioStreamPlayer2D

func _on_play_button_pressed() -> void:
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
	_GameManager.game_loop = true
	get_tree().change_scene_to_file("res://_Scenes/LevelRunner/level_runner.tscn")

func _on_tutorial_button_pressed() -> void:
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
	get_tree().change_scene_to_file("res://_Scenes/Tutorial/tutorial.tscn")

func _on_credits_button_pressed() -> void:
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
