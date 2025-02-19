extends Node
class_name LambdaCard

var lambda_card_data : LambdaCardDataResource

signal clicked(card: Node)

func _ready() -> void:
	pass

func createCard(card_id : String):
	self.lambda_card_data = load("res://Resources/LambdaCardData/" + card_id + ".tres")
	self.get_node("Label").text = lambda_card_data.icon
	print(lambda_card_data.icon)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self)
			
