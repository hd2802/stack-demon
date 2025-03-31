extends Node
class_name Hint 

signal hint_closed()
var audio

func _ready() -> void:
	audio = $AudioStreamPlayer2D

func _on_button_pressed() -> void:
	audio.play()
	await get_tree().create_timer(0.25).timeout
	hint_closed.emit()
