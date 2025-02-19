extends Node
class_name Stack

var stack : Array[String]

func _ready():
	var player_hand = get_parent().get_node("PlayerHand")
	player_hand.card_played.connect(_on_card_played)

#----------------------------------------------------------------

func push(value_to_push : String):
	stack.push_back(value_to_push)
	var label : Label = Label.new()
	label.text = value_to_push
	label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
	self.add_child(label)
	self.move_child(label, 0)
	
	var sep_label : Label = Label.new()
	sep_label.text = "----------"
	sep_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
	self.add_child(sep_label)
	self.move_child(sep_label, 0)

func initialise_stack(array : Array[String]):
	for a in array:
		push(a)

func _on_card_played(card: Card):
	push(card.card_data.text)

#----------------------------------------------------------------
