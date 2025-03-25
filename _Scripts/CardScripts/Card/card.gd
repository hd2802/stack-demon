extends Node
class_name Card

var card_data : CardDataResource

var is_hovered : bool = false

var tween_hover : Tween

signal clicked(card: Node)

func _ready() -> void:  
	pass

func createCard(card : String):
	self.card_data = load("res://Resources/CardData/" + card + ".tres")
	self.setLabels()

func setLabels():
	var top_left = self.get_node("TopLeft")
	var bottom_right = self.get_node("BottomRight")
	var center = self.get_node("Center")
	top_left.text = self.card_data.text
	bottom_right.text = self.card_data.text
	center.text = self.card_data.text
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self)
		elif event.button_index == MOUSE_BUTTON_RIGHT and get_parent().selected_card == self:
			get_parent()._on_card_clicked(self)
	else:
		pass

func _on_area_2d_mouse_entered() -> void:
	is_hovered = true

func _on_area_2d_mouse_exited() -> void:
	is_hovered = false
