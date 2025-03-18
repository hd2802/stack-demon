extends Node

var pc: float

var label : Label

var text_count : int

var sound_player

func _ready() -> void:
	_GameManager.game_loop = false
	_LevelManager._clear_level()
	
	sound_player = self.get_children()[0]
	label = self.get_children()[2]
	
	initialise_label()
	sound_player.play()

func initialise_label() -> void:
	label.visible_ratio = 0.0
	pc = 1.0 / label.text.length()
	$Timer.start()

func _on_timer_timeout() -> void:
	label.visible_ratio += pc
	if label.visible_ratio >= 1.0:
		$Timer.stop()
		
		if text_count == 2:
			sound_player.stop()
		load_next_text()
	

func load_next_text():
	text_count += 1
	label.text = ""
	if text_count == 1:
		label.text = ">> WELCOME, OPERATIVE.  
		>> YOU’VE BEEN CHOSEN FOR A HIGH-LEVEL BREACH OP.  
		>> TARGET: [REDACTED].  
		>> METHOD: REVERSE POLISH STACK MANIPULATION.  
		>> DECRYPT, RECONSTRUCT, OVERRIDE. "
	elif text_count == 2:
		label.text = ">> FIREWALLS STAND BETWEEN US AND THE TRUTH.  
		>> YOU HOLD THE CODES. YOU HOLD THE POWER.  

		>> FAILURE = LOCKOUT.  
		>> SUCCESS = CONTROL.  

		>> THINK FAST. BREAK IN. GET THE JOB DONE. "
	initialise_label()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://_Scenes/TutorialManager/tutorial_manager.tscn")
