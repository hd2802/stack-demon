extends Node2D
class_name Card

var card_data : CardDataResource

var is_hovered : bool = false
var is_dragged : bool = false
var drag_offset : Vector2
var original_position : Vector2 

var tween_hover : Tween
var sprite : Sprite2D

signal clicked(card: Node)
signal dragged(card, new_position : Vector2)

func _ready() -> void:  
	sprite = self.get_node("Sprite2D")
	original_position = position

func _process(delta : float) -> void:
	if is_dragged:
		position = get_viewport().get_mouse_position() - drag_offset

func createCard(card : String):
	self.card_data = load("res://Resources/CardData/" + card + ".tres")
	sprite = self.get_node("Sprite2D")
	self.set_labels()

func set_labels():
	var top_left : Label = sprite.get_node("TopLeft")
	var bottom_right : Label = sprite.get_node("BottomRight")
	var center : Label = sprite.get_node("Center")
	top_left.text = self.card_data.text
	bottom_right.text = self.card_data.text
	center.text = self.card_data.text
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self)
			if event.pressed:
				is_dragged = true
				drag_offset = event.position - position
				emit_signal("clicked", self)
			else:
				is_dragged = false
				emit_signal("dragged", self, position)
		elif event.button_index == MOUSE_BUTTON_RIGHT and get_parent().selected_card == self:
			get_parent()._on_card_clicked(self)

func _on_area_2d_mouse_entered() -> void:
	is_hovered = true

func _on_area_2d_mouse_exited() -> void:
	is_hovered = false
