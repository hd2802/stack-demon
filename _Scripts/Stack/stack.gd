extends Node
class_name Stack

var stack : Array[String]

var stack_top : String = ""
var stack_second : String = ""
var stack_third : String = ""

signal target_check(current_stack : Array[String])

func _ready():
	var hand = get_parent().get_node("Hand")
	hand.card_played.connect(_on_card_played)

#----------------------------------------------------------------

func push(value_to_push : String):
	stack.push_back(value_to_push)
	var label : Label = Label.new()
	label.text = value_to_push
	label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
	self.add_child(label)
	self.move_child(label, 0)
	
	stack_third = stack_second
	stack_second = stack_top
	stack_top = value_to_push

func _on_card_played(card: Card):
	push(card.card_data.text)
	
#----------------------------------------------------------------

func is_operation(v : String) -> bool:
	if int(v) == 0 and v != "0":
		return true
	else:
		return false

func calculator(operation : String, operand_1 : String, operand_2 : String) -> int:
	match operation:
		"+":
			return int(operand_1) + int(operand_2)
		"-":
			return int(operand_1) - int(operand_2)
		"/":
			return int(operand_1) / int(operand_2)
		"*":
			return int(operand_1) / int(operand_2)
	
	return 0
			

func _on_stack_calculation_button_pressed() -> void:
	if is_operation(stack_top) and !is_operation(stack_third) and !is_operation(stack_second):
		var result = calculator(stack_top, stack_third, stack_second)
		
		self.remove_child(self.get_children()[len(stack) - 1])
		self.remove_child(self.get_children()[len(stack) - 2])
		self.remove_child(self.get_children()[len(stack) - 3])
		stack.pop_back()
		stack.pop_back()
		stack.pop_back()
		
		self.push(str(result))
		
		# Checking if the target is achieved after calculation
		target_check.emit(stack)
		
	else:
		# Check if the target is achieved regardless of calculation
		target_check.emit(stack)
