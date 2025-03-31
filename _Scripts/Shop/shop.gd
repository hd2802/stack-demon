extends Control
class_name Shop

var selected_card : StaticCard

var card_list : Array[Card]
var gen_cards : Array[String]

var card_container : HBoxContainer
var card_one : StaticCard
var card_two : StaticCard
var card_three : StaticCard

var CARDS = [
	"multiply", "multiply", "exponent",
	"multiply", "multiply", "multiply", "multiply"
]

signal shop_finished()

func _ready() -> void:
	get_tree().paused = false
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
		card_container.add_child(new_card)
		new_card.clicked.connect(_on_card_clicked)
		
func _on_card_clicked(card : StaticCard) -> void:
	selected_card = card
	var idx = card_list.find(card)
	
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
			
			static_card.add_child(shader_rect)

func _on_continue_button_pressed() -> void:
	shop_finished.emit()
