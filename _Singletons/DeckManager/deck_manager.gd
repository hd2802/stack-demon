extends Node

# Only edited when adding or removing a card from the deck
var deck : Array[String] = []

# Used in gameplay 
var draw_pile : Array[String] = []

const START_DECK : Array[String] = [
	"one", "one",
	"two", "two",
	"three", "three",
	"four", "four",
	"five", "five",
	"six", "six",
	"seven", "seven",
	"eight", "eight",
	"nine", "nine",
	"add", "add",
	"add", "add",
	"multiply", "multiply",
	"multiply", "multiply",
	# debugging - increase chance of having card to test appear
	"del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del", "del"
]

func _ready() -> void:
	if deck.is_empty():
		deck = START_DECK.duplicate()
	if draw_pile.is_empty():
		draw_pile = START_DECK.duplicate()
		draw_pile.shuffle()

# These functions are for permanant changes to the cards of the
# deck
func add_card_to_deck(card_id: String):
	deck.append(card_id)

func remove_card_from_deck(card_id: String):
	deck.erase(card_id)

func draw_card() -> String:
	if draw_pile.is_empty():
		return ""
	else:
		return draw_pile.pop_front()
	
func reset_draw_pile():
	draw_pile = deck.duplicate()
	draw_pile.shuffle()
