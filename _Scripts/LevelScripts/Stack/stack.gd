extends Node
class_name Stack

var stack : Array[String]

const SPECIAL_CARD : Array[String] = [
	"del"
]

var stack_top : String = ""
var stack_second : String = ""
var stack_third : String = ""

var enter_audio_player
var card_audio_player

signal target_check(current_stack : Array[String])

func _ready():
	enter_audio_player = $"../EnterButtonAudio"
	card_audio_player = $"../CardPlayedAudio"
	var hand = get_parent().get_node("Hand")
	if hand: 
		hand.card_played.connect(_on_card_played)
	else:
		pass

#----------------------------------------------------------------

func push(value_to_push : String):
	stack.push_back(value_to_push)
	var label : Label = Label.new()
	label.text = value_to_push.to_upper()
	label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
	self.add_child(label)
	
	var spacer_label : Label = Label.new()
	spacer_label.text = " "
	self.add_child(spacer_label)
	
	label.set_scale(Vector2(0, 0))
	label.modulate.a = 0

	var tween = get_tree().create_tween()
	tween.tween_property(label, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_BOUNCE)
	tween.parallel().tween_property(label, "modulate:a", 1, 0.3)

	update_stack_references()

func _on_card_played(card: Card):
	card_audio_player.play()
	push(card.card_data.text)
	
#----------------------------------------------------------------

func is_operation(v : String) -> bool:
	return v in ["+", "-", "*", "/"]

func is_special_card(v : String) -> bool:
	return v in SPECIAL_CARD

func calculator(operation : String, operand_1 : String, operand_2 : String) -> int:
	match operation:
		"+":
			return int(operand_1) + int(operand_2)
		"-":
			return int(operand_1) - int(operand_2)
		"/":
			# Preventing division by 0
			if int(operand_1) == 0:
				return 0 
			return int(operand_1) / int(operand_2)
		"*":
			return int(operand_1) * int(operand_2)
	return 0

func _on_stack_calculation_button_pressed() -> void:
	print(stack)
	enter_audio_player.play()
	# Ensure we have enough elements for a calculation
	if stack.size() >= 3 and is_operation(stack[-1]) and not is_operation(stack[-2]) and not is_operation(stack[-3]):
		var operand_1 = stack[-2]
		var operand_2 = stack[-3]
		var operation = stack[-1]

		var result = calculator(operation, operand_1, operand_2)

		# Remove last three items from stack and UI
		
		# Range here is 6 because we have padding elements
		# REMOVE THESE IF PADDING LABELS ARE REMOVED
		for i in range(6):
			var label = self.get_children()[-1]
			if label is Label:
				var tween = get_tree().create_tween()
				tween.tween_property(label, "scale", Vector2(0, 0), 0.3).set_trans(Tween.TRANS_CUBIC)
				tween.parallel().tween_property(label, "modulate:a", 0, 0.3)
				await tween.finished
				self.remove_child(label)
				stack.pop_back()

		# Push result onto stack
		push(str(result))
		update_stack_references()

		await get_tree().create_timer(1.0).timeout
		target_check.emit(stack)

	elif is_special_card(stack_top):
		handle_special_card(stack_top)
	else:
		target_check.emit(stack)
	
func handle_special_card(spec : String):
	match spec:
		"del":
			self.remove_child(self.get_children()[len(stack) - 1])
			stack.pop_back()
			if !stack.is_empty():
				self.remove_child(self.get_children()[len(stack) - 1])
				stack.pop_back()
	

func update_stack_references():
	stack_top = stack[-1] if stack.size() > 0 else ""
	stack_second = stack[-2] if stack.size() > 1 else ""
	stack_third = stack[-3] if stack.size() > 2 else ""

func clear_stack():
	for child in get_children():
		if child is Label:
			remove_child(child)
			child.queue_free() 

	stack.clear()

	update_stack_references()
		
