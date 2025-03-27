extends Button
class_name StaticCard

var card_data : CardDataResource
var sprite : Sprite2D

var selected : bool = false

signal clicked(card: Node)

func _ready() -> void:
	sprite = self.get_node("Sprite2D")
	
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

func _on_pressed() -> void:
	clicked.emit(self)
	selected = true
