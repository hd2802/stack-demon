extends Node
class_name Card

var card_data : CardDataResource

signal clicked(card: Node)

func _ready() -> void:
	pass

func createCard(card : String):
	self.card_data = load("res://Resources/CardData/" + card + ".tres")
	self.get_node("Label").text = card_data.text

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self)
			
