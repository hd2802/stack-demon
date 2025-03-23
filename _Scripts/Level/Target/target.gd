extends Node
class_name Target

func ready() -> void:
	pass
	
func initialise_target(target : int):
	var label : Label = Label.new()
	label.text = str(target)
	label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
	label.set_vertical_alignment(VERTICAL_ALIGNMENT_CENTER)
	
	# very precise way of centering as other methods don't currently work
	label.position = Vector2((64+32)/2 + 6, 40)
	self.add_child(label)
