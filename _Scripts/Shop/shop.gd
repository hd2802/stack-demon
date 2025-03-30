extends Control
class_name Shop

var card_list : Array[StaticCard]
var gen_cards : Array[String]

var selected_card : StaticCard 

var card_container : HBoxContainer
var card_one : StaticCard
var card_two : StaticCard
var card_three : StaticCard

var CARDS = [
	"multiply", "multiply", "multiply"
]

signal shop_finished()

func _ready() -> void:
	card_container = $CardContainer
	
	generate_cards()
	
func generate_cards() -> void:
	CARDS.shuffle()
	gen_cards.append(CARDS[0])
	gen_cards.append(CARDS[1])
	gen_cards.append(CARDS[2])

	for card in gen_cards:
		var new_card = load("res://_Scenes/Card/StaticCard/static_card.tscn").instantiate()
		new_card.createCard(card)
		new_card.clicked.connect(_on_card_clicked)
		card_container.add_child(new_card)
		card_list.append(new_card)

func _on_card_clicked() -> void:
	pass

func _on_continue_button_pressed() -> void:
	shop_finished.emit()
