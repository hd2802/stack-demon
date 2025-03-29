extends Control
class_name PlayArea

var hand: HBoxContainer
var e_zone: HBoxContainer

var card_positions: Dictionary = {}
var ghost_cards: Dictionary = {}

var current_hand: Array[Card]
var selected_card: Card

var selected_cards: Array[Card] = []

var calculator: Calculator

const HAND_SIZE = 6

signal hand_discarded()
signal scored(sc: int, multiplier: int, is_complex: bool)

var cards_added: int = 0

func _ready():
	hand = self.get_node("Hand")
	e_zone = self.get_node("EvaluationZone")
	await draw_initial_cards()
	
	calculator = Calculator.new()
	calculator.expression_validity.connect(_on_expression_validity)  # Connect signal

func draw_initial_cards():
	for i in range(0, HAND_SIZE):
		add_card()
		await get_tree().create_timer(0.1).timeout

# -----------------------------------------------------------------------------

func add_card():
	var card_id = _DeckManager.draw_card()
	var new_card: Card = load("res://_Scenes/Card/card.tscn").instantiate()
	
	new_card.createCard(card_id)
	new_card.clicked.connect(_on_card_clicked)
	
	hand.add_child(new_card)
	current_hand.push_back(new_card)
	
	var delay_time = cards_added * 0.075
	cards_added += 1
	
	var start_position = Vector2(500, 75) 
	var final_position = Vector2(50, 75) 

	var tween = get_tree().create_tween()
	var sprite = new_card.get_node("Sprite2D")

	sprite.position = start_position
	
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(sprite, "position", final_position, 0.25 + delay_time)
	
# -----------------------------------------------------------------------------

func _on_card_clicked(card: Card):
	if selected_cards.has(card):
		selected_cards.erase(card)
	else:
		selected_cards.push_back(card)
		if card in hand.get_children():
			move_card_to_e_zone(card)
		else:
			move_card_back_to_hand(card)

func move_card_to_e_zone(card: Card) -> void:
	var original_index = hand.get_children().find(card)
	card_positions[card] = original_index
	
	var ghost_card = card.duplicate()
	ghost_card.modulate = Color(1, 1, 1, 0.5)
	ghost_card.position = card.position
	hand.add_child(ghost_card)
	
	if original_index != -1:
		hand.move_child(ghost_card, original_index)
	
	ghost_cards[card] = ghost_card
		
	hand.remove_child(card)
	card.scale = Vector2(1.2, 1.2)
	e_zone.add_child(card)

func move_card_back_to_hand(card: Card):
	card.visible = false
	e_zone.remove_child(card)
	card.scale = Vector2(1.0, 1.0)
	
	var ghost_card = ghost_cards.get(card, null)
	
	if ghost_card:
		hand.remove_child(ghost_card)
		ghost_card.queue_free()
		ghost_cards.erase(card)
	
	hand.add_child(card)
	hand.move_child(card, card_positions[card])
	card.visible = true

func clear_hand() -> void:
	for card in current_hand:
		var delay_time = cards_added * 0.1
		cards_added += 1
		
		var final_position = Vector2(1000, 75) 
		var start_position = Vector2(50, 75) 

		var tween = get_tree().create_tween()
		var sprite = card.get_node("Sprite2D")

		sprite.position = start_position
		
		tween.set_trans(Tween.TRANS_QUART)
		tween.tween_property(sprite, "position", final_position, 0.25 + delay_time)

func _on_play_card_button_pressed() -> void:
	if !selected_cards:
		return
	
	var score = calculator._on_hand_played(selected_cards)

	scored.emit(score, calculator._multiplier, calculator._is_complex)

	# Remove played cards
	for card in selected_cards:
		e_zone.remove_child(card)
		card.queue_free()

		var ghost_card = ghost_cards.get(card, null)
		if ghost_card:
			hand.remove_child(ghost_card)
			ghost_card.queue_free()
			ghost_cards.erase(card)

		current_hand.erase(card)
		add_card()

	selected_cards = []

func _on_expression_validity(multiplier: int, is_complex: bool) -> void:
	calculator._multiplier = multiplier
	calculator._is_complex = is_complex

func _on_discard_button_pressed() -> void:
	if len(selected_cards) != 0:
		for card in selected_cards:
			e_zone.remove_child(card)

			var ghost_card = ghost_cards.get(card, null)
			if ghost_card:
				hand.remove_child(ghost_card)
				ghost_card.queue_free()

			card.queue_free()
			current_hand.erase(card)
			add_card()

		selected_cards = []
		hand_discarded.emit()
