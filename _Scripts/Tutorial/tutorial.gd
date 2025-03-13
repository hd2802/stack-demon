extends Node
class_name TutorialLevel

var text_count : int

var pc : float

var label : Label

func _ready() -> void:
	_GameManager.game_loop = false
	_LevelManager._clear_level()
	label = self.get_node("TerminalText")
	initialise_label()
	
func initialise_label() -> void:
	label.visible_ratio = 0.0
	pc = 1.0 / label.text.length()
	$Timer.start()
	
func _on_next_button_pressed() -> void:
	load_next_text()

func _on_timer_timeout() -> void:
	label.visible_ratio += pc
	if label.visible_ratio >= 1.0:
		$Timer.stop()
		
		if text_count == 2:
			pass
	
func load_next_text():
	text_count += 1
	label.text = ""
	if text_count == 1:
		label.text="> WE CAN'T LET YOU IN WITHOUT LEARNING HOW 
		> IT WORKS FIRST"
	elif text_count == 2:
		label.text="next text"
	initialise_label()
