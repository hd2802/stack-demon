extends Node
class_name Hand

var cards : Array[String]

var selected_card : Card = null

const POSSIBLE_CARDS = [
	"add", "divide", "multiply", "subtract",
	"zero", "one", "two", "three", "four",
	"five", "six", "seven", "eight", "nine"
]

const HAND_SIZE = 5

signal card_played(card: Card)

signal move()

func _ready():
	pass

func initialise_hand(start_cards : Array[String]):
	for card in start_cards:
		add_card(card)
	
	fill_hand(len(start_cards))

func add_card(card_id : String):
	var new_card : Card = load("res://_Scenes/card.tscn").instantiate()
	new_card.createCard(card_id)
	new_card.clicked.connect(_on_card_clicked)
	self.add_child(new_card)

func add_random_card():
	var rng = RandomNumberGenerator.new()
	var card_id = POSSIBLE_CARDS[rng.randi_range(0, len(POSSIBLE_CARDS) - 1)]
	add_card(card_id)
	
func fill_hand(num_cards : int) -> void:
	while num_cards < HAND_SIZE:
		add_random_card()
		num_cards += 1

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
		move.emit()
		selected_card = null
		add_random_card()

func _on_discard_button_pressed() -> void:
	if selected_card:
		selected_card.queue_free()
		selected_card = null
		move.emit()
		add_random_card()
	else:
		pass
