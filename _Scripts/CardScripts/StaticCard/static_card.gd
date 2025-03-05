extends Node
class_name StaticCard

var card_data : CardDataResource

func createCard(card : String):
	self.card_data = load("res://Resources/CardData/" + card + ".tres")
	var sprite = self.get_node("Sprite2D")
	sprite.texture = load("res://Assets/Sprites/CardSprites/" + card + ".png")
	if card == "del":
		sprite.scale.x = 0.17
		sprite.scale.y = 0.17
