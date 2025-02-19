extends Node
class_name LambdaHand

var cards : Array[LambdaCard]

var selected_card : LambdaCard = null

signal card_played(card: LambdaCard)

func _ready():
	# Placeholder code for loading a card
	var l_card : LambdaCard = load("res://_Scenes/LambdaScenes/lambda_card.tscn").instantiate()
	l_card.createCard("test")
	l_card.clicked.connect(_on_card_clicked)
	self.add_child(l_card)

func _on_card_clicked(card: LambdaCard):
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
