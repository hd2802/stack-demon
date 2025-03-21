extends Node

var pc: float
var label : Label

var text_count : int = 0

func _ready() -> void:
	_GameManager.game_loop = false
	_LevelManager._clear_level()

	label = self.get_node("Label")
	
	$HUHButton.visible = false
	$ContinueButton.visible = false
	
	initialise_label()

func initialise_label() -> void:
	label.visible_ratio = 0.0
	pc = 1.0 / label.text.length()
	$Timer.start()

func _on_timer_timeout() -> void:
	label.visible_ratio += pc
	if label.visible_ratio >= 1.0:
		$Timer.stop()

		if text_count == 0:
			$HUHButton.visible = true
		elif text_count == 1:
			$HUHButton.text = "WHAT?"
			$HUHButton.visible = true
		elif text_count == 2:
			$HUHButton.text = "HACKING???"
			$HUHButton.visible = true
		elif text_count == 3:
			$ContinueButton.visible = true

func _on_huh_button_pressed() -> void:
	$HUHButton.visible = false
	text_count += 1
	if text_count == 1:
		label.text = "> INFIX NOTATION... HAVE YOU EVER HEARD OF IT?"
	elif text_count == 2:
		label.text = "> DO YOU EVEN KNOW ANYTHING ABOUT HACKING?"
	elif text_count == 3:
		label.text = "> OKAY. LET'S START FROM THE BEGINNING
		> IN THIS WORLD, COMPUTERS RUN OFF CODE FED TO THEM BY CARDS
		> THE COMPUTER PROCESSES THESE CARDS TO RUN PROGRAMS"
	initialise_label()

func _on_continue_button_pressed() -> void:
	text_count += 1
	if text_count == 4:
		label.text = "> WE CAN HACK INTO SYSTEMS BY USING THESE CARDS TO OUR ADVANTAGE"
	initialise_label()
