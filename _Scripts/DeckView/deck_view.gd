extends Control
class_name DeckView

signal back()

var container
var audio 

func _ready() -> void:
	container = $ScrollContainer/HBoxContainer
	audio = $AudioStreamPlayer2D
	for card in _DeckManager.deck:
		var new_card = load("res://_Scenes/Card/StaticCard/static_card.tscn").instantiate()
		new_card.createCard(card)
		container.add_child(new_card)

func _on_back_pressed() -> void:
	audio.play()
	await get_tree().create_timer(0.25).timeout
	back.emit()
