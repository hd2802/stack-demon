extends Node
class_name Level

var level_data : LevelDataResource

var title_node : Label
var tier_title_node : Label
var stack_node : Stack
var hand_node : Hand
var target_node : Target
var move_node : Moves

var term : Terminal

var next_button
var next_label

var target : int

var tier_complete = false

signal level_complete()
signal game_over()
signal moves_decremented()
signal terminal_text(text : String)

func _ready() -> void:
	# Placeholder for testing and debugging
	#level_data = load("res://Resources/Levels/zero.tres")
	#load_level(level_data)
	pass
	

func load_level(level_data) -> void:
	# Title initialisation
	title_node = self.get_node("LevelTitleLabel")
	title_node.text = "LEVEL " + str(level_data.level_number)
	
	# Tier title initialisation
	tier_title_node = self.get_node("LevelTierLabel")
	tier_title_node.text = "TIER " + str(level_data.tier) + " HACK" 
	
	# Stack initialisation
	stack_node = self.get_node("Stack")
	
	# Hand initialisation
	hand_node = self.get_node("Hand")
	
	# Target initialisation
	target_node = self.get_node("Target")
	target_node.initialise_target(level_data.target_value)
	
	# Setting up the target label
	var target_label = self.get_node("TargetLabelRich")
	target_label.text = "[center]SCORE [color=red]AT LEAST[/color][/center]"
		
	# Setting up the Move Counter
	move_node = self.get_node("Moves")
	move_node.set_move_counter(level_data.moves)
	
	target = level_data.target_value
	
	term = load("res://_Scenes/Terminal/terminal.tscn").instantiate()
	self.add_child(term)
	term.visible = false
	
	next_button = self.get_node("NextButton")
	next_button.visible = false

func set_move_counter(moves : int) -> void:
	move_node.set_move_counter(moves)

func _on_hand_move() -> void:
	move_node.decrement_move_counter()
	moves_decremented.emit()

func _on_moves_game_over() -> void:
	game_over.emit()

func _on_stack_target_check(current_stack: Array[String]) -> void:
	await get_tree().create_timer(1.5).timeout
	
	if len(current_stack) == 1 and int(current_stack[0]) >= target:
		terminal_text.emit("> HACK COMPLETE - PLEASE CONTINUE")
		tier_complete = true
		next_button.visible = true
	else:
		terminal_text.emit("> HACK INCOMPLETE - TRY AGAIN")

func _on_next_button_pressed() -> void:
	level_complete.emit()
	stack_node.clear_stack()
