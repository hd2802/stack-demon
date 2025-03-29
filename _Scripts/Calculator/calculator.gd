extends Node
class_name Calculator

var stack: Array[String]

var _multiplier: int = 1
var _is_complex: bool = false

signal expression_validity(multiplier: int, is_complex: bool)

func _ready() -> void:
	pass
	
func _on_hand_played(cards_played: Array[Card]) -> int:
	stack.clear()
	for card in cards_played:
		stack.push_back(card.card_data.text)

	var is_valid = is_valid_expression()
	var operator_count = count_operators()

	if !is_valid or len(stack) == 1:
		_multiplier = 1
	elif operator_count == 1:
		_multiplier = 2
	elif operator_count > 1:
		_multiplier = 3
	else:
		_multiplier = 1

	_is_complex = operator_count > 1


	expression_validity.emit(_multiplier, _is_complex)

	return evaluate()

func evaluate() -> int:
	if !is_valid_expression() or len(stack) == 1:
		var max_card_value = 0
		for card in stack:
			if int(card) > max_card_value:
				max_card_value = int(card)
		stack.clear()
		return max_card_value
	else:
		while len(stack) >= 3:
			var operation = stack.pop_back()
			var operand1 = int(stack.pop_back())
			var operand2 = int(stack.pop_back())
			stack.push_back(str(calculate(operation, operand1, operand2)))

		return int(stack[0])

func count_operators() -> int:
	var count = 0
	for token in stack:
		if is_operation(token):
			count += 1
	return count

func calculate(operation: String, operand1: int, operand2: int) -> int:
	match operation:
		"+":
			return operand1 + operand2
		"-":
			return operand1 - operand2
		"X":
			return operand1 * operand2
		"/":
			return operand1 / operand2 if operand2 != 0 else 0
		"^":
			return int(pow(operand1, operand2))
		_:
			return 0

func is_operation(value: String) -> bool:
	return value in ["+", "-", "X", "/", "^"]

func is_valid_expression() -> bool:
	var operand_count = 0
	for token in stack:
		if !is_operation(token):
			operand_count += 1
		elif operand_count >= 2:
			operand_count -= 1
		else:
			return false
	return operand_count == 1
