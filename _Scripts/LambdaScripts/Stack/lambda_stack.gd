extends Node
class_name LambdaStack

var stack : Array[LambdaAST.LambdaTerm]
var parser = LambdaParser.new()
var evaluator = LambdaEvaluator.new()

func _ready():
	var hand = get_parent().get_node("LambdaHand")
	hand.card_played.connect(_on_card_played)

func push(expr_string: String):
	var ast = parser.parse(expr_string)
	stack.push_back(ast) 

	var label := Label.new()
	label.text = expr_string
	label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
	label.modulate = Color(1, 1, 1, 0) 
	self.add_child(label)
	self.move_child(label, 0)
	var tween := get_tree().create_tween()
	tween.tween_property(label, "modulate", Color(1, 1, 1, 1), 0.3)

func initialise_stack(stack_expressions: Array[String]):
	for expr in stack_expressions:
		push(expr)

func _on_lambda_calculate_button_pressed():
	evaluate_stack()

func evaluate_stack():
	if stack.size() >= 2:
		var arg = stack.pop_back()
		var function = stack.pop_back()

		var applied = LambdaAST.Application.new(function, arg)
		var result = evaluator.evaluate(applied)

		stack.push_back(result)

		var result_label := Label.new()
		result_label.text = result._to_string()
		result_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
		self.add_child(result_label)
		self.move_child(result_label, 0)

func _on_card_played(card: LambdaCard):
	push(card.lambda_card_data.expression)
