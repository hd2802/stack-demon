extends Control
class_name TierTransition

# TODO: edit this so that the cards are weighted properly
# and so that it contains some interesting cards that can be added
var CARDS : Array[String] = [
	"multiply", "multiply", "multiply"
]

var card_list : Array[StaticCard]
var gen_cards : Array[String]

var selected_card : StaticCard 

var card_container : HBoxContainer
var card_one : StaticCard
var card_two : StaticCard
var card_three : StaticCard

var continue_button : Button

signal next 

func _ready() -> void:
	card_container = $CardContainer
	continue_button = $ContinueButton
	continue_button.visible = false
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

func _on_card_clicked(card : StaticCard) -> void:
	selected_card = card
	var idx = card_list.find(card)
	
	# visual effects
	for static_card in card_list:
		if selected_card != static_card:
			card_container.remove_child(static_card)
			static_card.queue_free()
		else:
			static_card.disabled = true
			
			var shader_rect = ColorRect.new()
			shader_rect.set_size(Vector2(100, 150))
			
			var highlight_shader = load("res://Resources/Shaders/highlight.gdshader")
			shader_rect.material = ShaderMaterial.new()
			shader_rect.material.shader = highlight_shader
	
	_DeckManager.add_card_to_deck(gen_cards[idx])
	continue_button.visible = true


func _on_continue_button_pressed() -> void:
	next.emit()
