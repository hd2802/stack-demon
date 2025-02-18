extends Node
class_name PlayerHand

var cards : Array[String]

func _ready():
	var card : Card = load("res://_Scenes/card.tscn").instantiate()
	card.createCard("one")
	self.add_child(card)

func populateHand():
	pass
