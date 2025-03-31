extends Node
class_name Win

var button_audio

signal endless

func _ready() -> void:
	button_audio = $AudioStreamPlayer2D

func _on_continue_button_pressed() -> void:
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
	_GameManager.game_loop = false
	get_tree().change_scene_to_file("res://_Scenes/MainMenu/main_menu.tscn")

func _on_endless_mode_pressed() -> void:
	endless.emit()
