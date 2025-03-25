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

func add_card():
	var card_id = _DeckManager.draw_card()
	current_hand.push_back(card_id)
	var new_card : Card = load("res://_Scenes/Card/card.tscn").instantiate()
	new_card.createCard(card_id)
	new_card.clicked.connect(_on_card_clicked)
	self.add_child(new_card)
	arrange_cards()
	cards_added += 1

func arrange_cards():
	if get_child_count() == 0:
		return

	var total_cards = self.get_child_count()
	for i in range(total_cards):
		var card = self.get_child(i)

		var hand_ratio = float(i) / float(total_cards - 1) if total_cards > 1 else 0.5
		var spread_offset = spread_curve.sample(hand_ratio) * 625
		var height_offset = height_curve.sample(hand_ratio) * -8

		card.position = Vector2(spread_offset, height_offset)

		if card in selected_cards:
			card.position.y -= 20 

func _on_card_clicked(card: Card):
	if selected_cards.has(card):
		card.position.y += 20 
		selected_cards.erase(card)
		card.is_selected = false
	else:
		selected_cards.push_back(card)
		card.position.y -= 20 
		card.is_selected = true

	arrange_cards() 

func _on_card_dragged(card: Card, new_position: Vector2):
	card.position = new_position

	if card.is_selected:
		card.position.y -= 20

	arrange_cards()

func _on_play_card_button_pressed() -> void:
	if !selected_cards:
		pass
	else:
		var score = calculator._on_hand_played(selected_cards)
		scored.emit(score)

		for card in selected_cards:
			self.remove_child(card)
			card.queue_free()
			current_hand.erase(card.card_data.text)
			add_card()
		hand_played.emit()

		selected_cards = []

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
