extends Node
class_name Hand

var cards : Array[String]

var selected_card : Card = null

signal card_played(card: Card)

func _ready():
	# Placeholder code for loading a card
	var card : Card = load("res://_Scenes/card.tscn").instantiate()
	card.createCard("one")
	card.clicked.connect(_on_card_clicked)
	self.add_child(card)
	
	var card_2 : Card = load("res://_Scenes/card.tscn").instantiate()
	card_2.createCard("add")
	card_2.clicked.connect(_on_card_clicked)
	self.add_child(card_2)

func _on_card_clicked(card: Card):
	if selected_card :
		selected_card.position.y += 20
		
	if selected_card != card:
		selected_card = card
		selected_card.position.y -= 20 
	else:
		selected_card = null

func _on_play_card_button_pressed() -> void:
	if !selected_card:
		pass
	else:
		card_played.emit(selected_card)
		selected_card.queue_free()
		selected_card = null
