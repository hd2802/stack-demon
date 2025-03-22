extends Node

var pc: float
var label : Label

var text_count : int = 0

func _ready() -> void:
	_GameManager.game_loop = false
	_LevelManager._clear_level()

	label = self.get_node("Label")
	
	$MathsLabel.visible = false
	
	$ContinueButton.visible = false
	
	initialise_label()

func initialise_label() -> void:
	$ContinueButton.visible = false
	label.visible_ratio = 0.0
	pc = 1.0 / label.text.length()
	$Timer.start()

func _on_timer_timeout() -> void:
	label.visible_ratio += pc
	if label.visible_ratio >= 1.0:
		$Timer.stop()

		if text_count == 0:
			$ContinueButton.visible = true
		elif text_count == 1:
			$ContinueButton.text = "WHAT?"
			$ContinueButton.visible = true
		elif text_count == 2:
			$ContinueButton.text = "HACKING???"
			$ContinueButton.visible = true
		elif text_count == 3:
			$ContinueButton.visible = true

func _on_continue_button_pressed() -> void:
	text_count += 1
	if text_count == 1:
		label.text = "> INFIX NOTATION... HAVE YOU EVER HEARD OF IT?"
	elif text_count == 2:
		label.text = "> DO YOU EVEN KNOW ANYTHING ABOUT HACKING?"
	elif text_count == 3:
		label.text = "> OKAY. LET'S START FROM THE BEGINNING
		> IN THIS WORLD, COMPUTERS RUN OFF CODE IN REVERSE POLISH NOTATION"
	if text_count == 4:
		label.text = "> RATHER THAN WRITING 2 + 3, THIS SYSTEM USES THE NOTATION 2 3 +"
	initialise_label()
