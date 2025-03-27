extends Control
class_name Shop

signal shop_finished()

func _on_continue_button_pressed() -> void:
	shop_finished.emit()
