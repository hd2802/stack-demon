extends Control
class_name Shop

var button_audio

signal shop_finished

func _ready() -> void:
	button_audio = $AudioStreamPlayer2D
		
func _on_continue_button_pressed() -> void:
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
	shop_finished.emit()
