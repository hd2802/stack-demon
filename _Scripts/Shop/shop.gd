extends Control
class_name Shop

signal shop_finished

func _ready() -> void:
	pass

func _on_continue_button_pressed() -> void:
	shop_finished.emit()
