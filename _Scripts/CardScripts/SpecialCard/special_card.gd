extends Node
class_name SpecialCard

var card_data : SpecialCardData
var sprite : Sprite2D
var popup : Label

var is_hovered : bool

signal clicked(card: Node)

func _ready() -> void:
	popup.visible = false
	
func create_card(card : String):
	sprite = $Sprite2D
	popup = $Label
	self.card_data = load("res://Resources/SpecialCardData/" + card + ".tres")
	var sprite_img = load(card_data.sprite_path)
	sprite.texture = sprite_img
	popup.text = card_data.description
	
	if card_data.labels != "":
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

func _on_mouse_entered() -> void:
	if not is_hovered:
		is_hovered = true
		popup.visible = true

func _on_mouse_exited() -> void:
	if is_hovered:
		is_hovered = false
		popup.visible = false
