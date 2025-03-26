extends Node
class_name Hand

@export var spread_curve : Curve
@export var height_curve : Curve

var current_hand : Array[String]
var selected_card : Card

var selected_cards : Array[Card] = []

var calculator : Calculator

const HAND_SIZE = 7

signal hand_played()
signal hand_discarded()
signal scored(sc : int)

var cards_added : int = 0


func _ready():
	for i in range(0, HAND_SIZE):
		add_card()
	calculator = Calculator.new()
	
	for card in get_children():
		card.connect("dragged", Callable(self, "_on_card_dragged"))
# -----------------------------------------------------------------------------

func add_card():
	var card_id = _DeckManager.draw_card()
	current_hand.push_back(card_id)
	var new_card : Card = load("res://_Scenes/Card/card.tscn").instantiate()
	new_card.createCard(card_id)
	new_card.clicked.connect(_on_card_clicked)
	self.add_child(new_card)
	arrange_cards()
	cards_added += 1
	
# -----------------------------------------------------------------------------

func arrange_cards():
	if get_child_count() == 0:
		return

	for i in range(self.get_child_count()):
		var card = self.get_child(i)

		var hand_ratio = float(i) / float(self.get_child_count() - 1) if get_child_count() > 1 else 0.5

		var spread_offset = spread_curve.sample(hand_ratio) * 625

		var height_offset = height_curve.sample(hand_ratio) * -8

		card.position = Vector2(spread_offset, height_offset)
	
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
		var score = calculator._on_hand_played(selected_cards)
		scored.emit(score)

		# remove them physically from the hand 
		for card in selected_cards:
			# remove the card sprite from the hand
			self.remove_child(card)
			card.queue_free()
			
			# remove the card data from the array
			current_hand.erase(card.card_data.text)
			
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

func _on_card_dragged(card : Card, new_position : Vector2):
	card.position = new_position
	
	arrange_cards()
