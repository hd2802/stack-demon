extends Node
class_name Calculator

signal expression_validity(multiplier: int, is_complex: bool)

var stack: Array[String]

func _ready() -> void:
	pass

func _on_hand_played(cards_played: Array[Card]) -> int:
	stack.clear()

	for card in cards_played:
		stack.push_back(card.card_data.text)

	var sc = evaluate()
	return sc

func evaluate() -> int:
	var is_complex = is_complex_expression()
	
	if !is_valid_expression():
		expression_validity.emit(1, is_complex)
		var max_value = 0
		for card in stack:
			var value = int(card)
			if value > max_value:
				max_value = value
		stack.clear()
		return max_value
	else:
		expression_validity.emit(2 if !is_complex else 3, is_complex)  

		if len(stack) >= 3:
			while len(stack) >= 3:
				var operation = stack.pop_back()
				var operand1 = stack.pop_back()
				var operand2 = stack.pop_back()
				var result = calculate(operation, int(operand1), int(operand2))
				stack.push_back(str(result))

			return int(stack.pop_back())
		else:
			var max_value = 0
			for card in stack:
				var value = int(card)
				if value > max_value:
					max_value = value
			stack.clear()
			return max_value

# Helper functions ------------------------------------------------------
func is_operation(value: String) -> bool:
	return value in ["+", "/", "X", "^", "-"]

func is_valid_expression() -> bool:
	var operand_count = 0
	
	for token in stack:
		if is_operation(token):
			if operand_count < 2:
				return false
			operand_count -= 1
		else:
			operand_count += 1

	return operand_count == 1

func is_complex_expression() -> bool:
	# Count how many operations are in the stack
	var operator_count = 0

	for token in stack:
		if is_operation(token):
			operator_count += 1

	return operator_count >= 2

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
