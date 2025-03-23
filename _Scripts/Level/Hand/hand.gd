extends Node
class_name Hand

var current_hand : Array[String]
var selected_card : Card

var selected_cards : Array[Card] = []

var calculator : Calculator

const HAND_SIZE = 5

signal move()

func _ready():
	fill_hand(0)
	
	calculator = Calculator.new()
	
# -----------------------------------------------------------------------------

func add_card(card_id : String):
	current_hand.push_back(card_id)
	var new_card : Card = load("res://_Scenes/Card/card.tscn").instantiate()
	new_card.createCard(card_id)
	new_card.clicked.connect(_on_card_clicked)
	self.add_child(new_card)
	
# -----------------------------------------------------------------------------

func add_random_card():
	await get_tree().create_timer(0.5).timeout
	var new_card_id = _DeckManager.draw_card()
	add_card(new_card_id)

func fill_hand(num_cards : int) -> void:
	while num_cards < HAND_SIZE:
		add_random_card()
		num_cards += 1

# -----------------------------------------------------------------------------

func _on_card_clicked(card: Card):
	# if the EXACT card is already in the list of selected cards
		# begs the question of - how do we measure if the exact card is in the list or not
	# if we store as cards and use the .has function then it should work?
	if selected_cards.has(card):
		# here we assume that the card is already risen and marked as selected
		# so we want to deselect it
		card.position.y += 20
		selected_cards.erase(card)
	else:
		selected_cards.push_back(card)
		card.position.y -= 20


func _on_play_card_button_pressed() -> void:
	if !selected_cards:
		pass
	else:
		calculator._on_hand_played(selected_cards)

		# remove them physically from the hand 
		for card in selected_cards:
			card.queue_free()
			
		move.emit()
		
		# remove the selected cards from the logic of the hand 
		selected_cards = []
		add_random_card()

func _on_discard_button_pressed() -> void:
	
	if selected_card:
		selected_card.queue_free()
		selected_card = null
		move.emit()
		add_random_card()
		
	else:
		pass
