extends Node
class_name Card

var card_data : CardDataResource

signal clicked(card: Node)

var card_selected_player

var stat : bool = false

func _ready() -> void:  
	pass

func createCard(card : String):
	self.card_data = load("res://Resources/CardData/" + card + ".tres")
	var sprite = self.get_node("Sprite2D")
	sprite.texture = load("res://Assets/Sprites/CardSprites/" + card + ".png")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !stat:
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				clicked.emit(self)
			elif event.button_index == MOUSE_BUTTON_RIGHT and get_parent().selected_card == self:
				get_parent()._on_card_clicked(self)
	else:
		pass
