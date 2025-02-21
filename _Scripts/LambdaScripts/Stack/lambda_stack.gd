extends Node
class_name LambdaStack

var stack : Array[LambdaCard]

func _ready():
	var hand = get_parent().get_node("LambdaHand")
	hand.card_played.connect(_on_card_played)
	var parser = LambdaParser.new()
	var evaluator = LambdaEvaluator.new()

	var ast = parser.parse("(λx. x) y")
	print(ast)  # Before reduction: Application(Abstraction("x", Variable("x")), Variable("y"))

	var reduced_ast = evaluator.evaluate(ast)
	print(reduced_ast)  # After reduction: Variable("y")


#----------------------------------------------------------------

func push(card : LambdaCard):
	stack.push_back(card)
	var label : Label = Label.new()
	label.text = card.lambda_card_data.icon
	label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
	self.add_child(label)
	self.move_child(label, 0)
	
	#var sep_label : Label = Label.new()
	#sep_label.text = "----------"
	#sep_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
	#self.add_child(sep_label)
	#self.move_child(sep_label, 0)

func initialise_stack(stack_of_ids : Array[String]):
	for id in stack_of_ids:
		var temp_card = LambdaCard.new()
		var a = load("res://Resources/LambdaCardData/" + id + ".tres")
		temp_card.lambda_card_data = a
		push(temp_card)

func _on_card_played(card: LambdaCard):
	push(card)
