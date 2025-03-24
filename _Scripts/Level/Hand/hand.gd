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


func _ready():
	fill_hand(HAND_SIZE - HAND_SIZE)
	
	calculator = Calculator.new()
	
# -----------------------------------------------------------------------------

func add_card(card_id : String):
	current_hand.push_back(card_id)
	var new_card : Card = load("res://_Scenes/Card/card.tscn").instantiate()
	new_card.createCard(card_id)
	new_card.clicked.connect(_on_card_clicked)
	self.add_child(new_card)
	arrange_cards()

# -----------------------------------------------------------------------------

func arrange_cards():
	if get_child_count() == 0:
		return

	for i in range(get_child_count()):
		var card = get_child(i)

		var hand_ratio = float(i) / float(get_child_count() - 1) if get_child_count() > 1 else 0.5

		var spread_offset = spread_curve.sample(hand_ratio) * 625

		var height_offset = height_curve.sample(hand_ratio) * -8
	

		card.position = Vector2(spread_offset, height_offset)


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
		var score = calculator._on_hand_played(selected_cards)
		scored.emit(score)

		# remove them physically from the hand 
		for card in selected_cards:
			card.queue_free()
			
		hand_played.emit()
		
		# remove the selected cards from the logic of the hand 
		selected_cards = []
		add_random_card()

# need to make it so multiple cards can be discarded at one time 
func _on_discard_button_pressed() -> void:
	
	if selected_card:
		selected_card.queue_free()
		selected_card = null
		hand_discarded.emit()
		add_random_card()
		
	else:
		pass
