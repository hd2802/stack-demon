extends Node
class_name PlayerHand

var cards : Array[String]

var selected_card : Card = null

func _ready():
	var card : Card = load("res://_Scenes/card.tscn").instantiate()
	card.createCard("one")
	card.clicked.connect(_on_card_clicked)
	self.add_child(card)

func _on_card_clicked(card: Card):
	print("card clicked")
	if selected_card :
		selected_card.position.y += 20
		
	if selected_card != card:
		selected_card = card
		selected_card.position.y -= 20 
		
	else:
		selected_card = null
