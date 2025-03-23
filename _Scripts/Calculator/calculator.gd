extends Node
class_name Calculator

var stack : Array[String]

func _ready() -> void:
	pass

# function called by the hand class -> the only connecting method
# any other methods must be triggered through this
func _on_hand_played(cards_played : Array[Card]) -> void:
	
	# initialise the stack of operands and operations 
	for card in cards_played:
		stack.push_back(card.card_data.text)
	
	evaluate()

func evaluate() -> int:
	if !is_valid_expression():
		# then we want to use the highest value card that has been used
		var temp_int_stack = []
		for str in stack:
			temp_int_stack.push_back(int(str))
		print(temp_int_stack.max())
		return temp_int_stack.max() # works even for operations as they get converted to 0
	else:
		if len(stack) == 3:
			var operation = stack.pop_back()
			var operand1 = stack.pop_back()
			var operand2 = stack.pop_back()
			print(calculate(operation, int(operand1), int(operand2)))
			return calculate(operation, int(operand1), int(operand2))
		# TODO deal with more complex hands played here
		else:
			return 0
		

# helper functions for calculate() ------------------------------------------------------
func is_operation(value: String) -> bool:
	return value in ["+", "/", "*", "^", "-"]

func is_valid_expression() -> bool:
	var operand_count = 0
	
	for token in stack:
		if !is_operation(token):
			operand_count += 1
		elif is_operation(token):
			if operand_count < 2:
				return false
			operand_count -= 1
		else:
			return false
	
	return operand_count == 1
	
func calculate(operation: String, operand1 : int, operand2 : int) -> int:
	match operation:
		"+":
			return operand1 + operand2
		"*":
			return operand1 * operand2
		_:
			return 0
	return 0
	
