extends HBoxContainer
class_name Hand

var play_area

var card_positions : Dictionary = {}

var current_hand : Array[Card]
var selected_card : Card

var selected_cards : Array[Card] = []

var calculator : Calculator

const HAND_SIZE = 7

signal hand_played()
signal hand_discarded()
signal scored(sc : int)

var cards_added : int = 0

func _ready():
	play_area = self.get_parent()
	for i in range(0, HAND_SIZE):
		add_card()
	calculator = Calculator.new()
	
# -----------------------------------------------------------------------------

func add_card():
	var card_id = _DeckManager.draw_card()
	var new_card : Card = load("res://_Scenes/Card/card.tscn").instantiate()
	new_card.createCard(card_id)
	new_card.clicked.connect(_on_card_clicked)
	self.add_child(new_card)
	current_hand.push_back(new_card)
	cards_added += 1
	
# -----------------------------------------------------------------------------


func _on_card_clicked(card: Card):
	# if the EXACT card is already in the list of selected cards
	if selected_cards.has(card):
		selected_cards.erase(card)
	else:
		selected_cards.push_back(card)
		if card in self.get_children():
			move_card_to_play_area(card)
		else:
			move_card_back_to_hand(card)

func move_card_to_play_area(card : Card) -> void:
	card_positions[card] = card.position
	self.remove_child(card)
	card.scale = Vector2(1.2, 1.2)
	play_area.add_child(card)

func move_card_back_to_hand(card: Card):
	if card_positions.has(card):
		card.position = card_positions[card]
		card.scale = Vector2(1, 1)

	play_area.remove_child(card) 
	self.add_child(card)
	
func _on_play_card_button_pressed() -> void:
	if !selected_cards:
		pass
	else:
		var score = calculator._on_hand_played(selected_cards)
		scored.emit(score)

		# remove them physically from the hand 
		for card in selected_cards:
			# remove the card sprite from the hand
			self.remove_child(card)
			card.queue_free()
			
			# remove the card data from the array
			current_hand.erase(card)
			
			# add a new card to replace the old one
			add_card()
		hand_played.emit()
		
		# remove the selected cards from the logic of the hand 
		selected_cards = []

# need to make it so multiple cards can be discarded at one time 
func _on_discard_button_pressed() -> void:
	if len(selected_cards) != 0:
		
		for card in selected_cards:
			card.queue_free()
			current_hand.erase(card.card_data.text)
			add_card()
		selected_cards = []
		hand_discarded.emit()
		
	else:
		pass
