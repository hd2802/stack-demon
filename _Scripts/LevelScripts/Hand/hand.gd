extends Node
class_name Hand

var current_hand : Array[String]

var selected_card : Card = null

const HAND_SIZE = 5

signal card_played(card: Card)

signal move()

func _ready():
	fill_hand(0)
	
func add_card(card_id : String):
	current_hand.push_back(card_id)
	var new_card : Card = load("res://_Scenes/Card/card.tscn").instantiate()
	new_card.createCard(card_id)
	new_card.clicked.connect(_on_card_clicked)
	self.add_child(new_card)

func add_random_card():
	var new_card_id = _DeckManager.draw_card()
	add_card(new_card_id)
	
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
		var tween = get_tree().create_tween()

		selected_card.pivot_offset = selected_card.get_rect().size / 2

		tween.tween_property(selected_card, "scale", Vector2(0, 0), 0.4).set_trans(Tween.TRANS_QUAD)
		tween.parallel().tween_property(selected_card, "modulate:a", 0, 0.4)
		
		await tween.finished
		
		selected_card.queue_free()
		selected_card = null
		move.emit()
		add_random_card()
	else:
		pass
