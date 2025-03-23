extends Node
class_name Calculator

func _ready() -> void:
	pass

# function called by the hand class -> the only connecting method
# any other methods must be triggered through this
func _on_hand_played(cards_played : Array[Card]) -> void:
	pass
