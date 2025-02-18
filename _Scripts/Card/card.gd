extends Node
class_name Card

var card_data : CardDataResource

func _ready() -> void:
	pass

func createCard(card : String):
	self.card_data = load("res://Resources/CardData/" + card + ".tres")
	self.get_node("Label").text = card_data.text
