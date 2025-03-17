extends Node2D
class_name Terminal

var pc : float

var label : Label

func _ready() -> void:
	label = self.get_node("TerminalText")
	initialise_label()
	
# Starts the text writing animation
func initialise_label() -> void:
	label.visible_ratio = 0.0
	pc = 1.0 / label.text.length()
	$Timer.start()

# Responsible for the animation
func _on_timer_timeout() -> void:
	label.visible_ratio += pc
	if label.visible_ratio >= 1.0:
		$Timer.stop()

	
#func _on_next_button_pressed() -> void:
	#pass

func _on_level_terminal_text(text: String) -> void:
	label.text = text
	initialise_label()
