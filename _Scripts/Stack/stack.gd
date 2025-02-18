extends Node
class_name Stack

var stack : Array[String]

func _ready():
	var player_hand = get_parent().get_node("PlayerHand")
	player_hand.card_played.connect(_on_card_played)

func _on_card_played(card: Card):
	stack.push_back(card.card_data.operation)
	var label : Label = Label.new()
	label.text = card.card_data.text
	self.add_child(label)
