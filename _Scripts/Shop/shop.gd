extends Control
class_name Shop

signal shop_finished

var modifier_cards

var POSSIBLE_MODIFIERS = [
	"hand", "discard", "mult"
]

func _ready() -> void:
	modifier_cards = $ModifierCards
		
func _on_continue_button_pressed() -> void:
	shop_finished.emit()

func generate_random_modifier() -> void:
	var rand_index:int = randi() % POSSIBLE_MODIFIERS.size()
	var random_modifier = POSSIBLE_MODIFIERS[rand_index]
	print(random_modifier)
	
func _on_button_pressed() -> void:
	generate_random_modifier()

func _on_button_2_pressed() -> void:
	generate_random_modifier()

func _on_button_3_pressed() -> void:
	generate_random_modifier()
