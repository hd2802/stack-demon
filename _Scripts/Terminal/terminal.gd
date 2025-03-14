extends Node2D
class_name Terminal

var pc : float

var label : Label

func _ready() -> void:
	label = self.get_node("TerminalText")
	initialise_label()
	
func set_text(term_text : String) -> void:
	label.text = ""
	initialise_label()
	label.text = term_text
	initialise_label()
	
func initialise_label() -> void:
	label.visible_ratio = 0.0
	pc = 1.0 / label.text.length()
	$Timer.start()
	
#func _on_next_button_pressed() -> void:
	#load_next_text()

func _on_timer_timeout() -> void:
	label.visible_ratio += pc
	if label.visible_ratio >= 1.0:
		$Timer.stop()
		load_next_text()

func load_next_text():
	label.text = ""
	label.text="> "

	initialise_label()
