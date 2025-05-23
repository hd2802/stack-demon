extends Control
class_name LevelTransition

# TODO: edit this so that the cards are weighted properly
# and so that it contains some interesting cards that can be added
var CARDS : Array[String] = [
	"ten", "ten", "ten",
	"twenty", "twenty", "twenty",
	"one", "one", "one",
	"three", "three", "three",
	"four", "two", "five", "nine",
	"six", "seven", "nine", "nine", "two",
	"two", "three", "one", "two", "three",
	"four", "six", "six", "six", "seven",
	"nine", "ten", "add", "add", "add",
	"add", "ten", "add", "add",
	"add", "add","add","add",
	"add", "add", "multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply",
	"multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply",
	"multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply",
	"multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply",
	"multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply",
	"multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply",
	"multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply",
	"multiply","multiply","multiply","multiply","multiply","multiply","multiply","multiply"
]

var card_list : Array[StaticCard]
var gen_cards : Array[String]

var selected_card : StaticCard 

var card_container : HBoxContainer
var card_one : StaticCard
var card_two : StaticCard
var card_three : StaticCard

var continue_button : Button

var selection_prompt : Label

var button_audio

signal level_next 

func _ready() -> void:
	button_audio = $AudioStreamPlayer2D
	card_container = $CardContainer
	continue_button = $ContinueButton
	selection_prompt = $SelectionPrompt
	
	var round_number = self.get_parent().current_tier
	if round_number == 0:
		round_number += 1
	
	var title = $Title
	title.text = "[wave amp=25 freq=1.5] Round "  + str(round_number) + " Complete[/wave]"
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
	continue_button.text = "Continue"
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
			
			static_card.add_child(shader_rect)
	
	_DeckManager.add_card_to_deck(gen_cards[idx])
	selection_prompt.visible = false
	
func _on_continue_button_pressed() -> void:
	button_audio.play()
	await get_tree().create_timer(0.25).timeout
	level_next.emit()
