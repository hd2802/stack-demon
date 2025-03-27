extends Node
class_name LevelManager

var level: Level = null

# Can only be 0, 1, or 2 
var current_tier: int = 0
# Incremented when all 3 tiers are completed
var current_level: int = 0
var tier_base_target: int = 2
var tier_current_target: int = tier_base_target

const MAX_MOVES: int = 5
var moves: int = 5

var rng = RandomNumberGenerator.new()

const MIN_RAND_RANGE: int = 5
const MAX_RAND_RANGE: int = 12
const TIER_INCREASE: int = 15

func _ready() -> void:
	# Ensure that LevelManager is only initialized once
	if level == null and _GameManager.game_loop:
		_load_first_level()

func _load_first_level():
	level = load("res://_Scenes/Level/level.tscn").instantiate()
	var lvl_data = load("res://Resources/Levels/start.tres")
	level.load_level(lvl_data)

	# Add the level to the current scene
	get_tree().current_scene.add_child(level)
	
	level.level_complete.connect(_on_level_complete)

func _on_level_complete() -> void:
	#get_tree().paused = true
	
	# here we want to load in the level transition 
	
	# only after the level transition is over do we want to load in the next level 
	get_tree().paused = true
	var transition_scene = load("res://_Scenes/Transitions/tier_transition.tscn").instantiate()
	self.add_child(transition_scene)
	transition_scene.next.connect(_load_next_level)
	#_load_next_level()

func _create_next_level() -> LevelDataResource:
	var lvl_data = LevelDataResource.new()
	
	# Increment tier
	current_tier += 1
	
	if current_tier == 1:
		tier_current_target += rng.randi_range(MIN_RAND_RANGE, MAX_RAND_RANGE)
	elif current_tier == 2:
		tier_current_target += rng.randi_range(MIN_RAND_RANGE, MAX_RAND_RANGE)
	else: # current_tier == 3
		current_tier = 0
		current_level += 1
		tier_base_target += TIER_INCREASE
		tier_current_target = tier_base_target
		moves = MAX_MOVES
	
	lvl_data.moves = moves
	lvl_data.level_number = current_level
	lvl_data.target_value = tier_current_target
	lvl_data.tier = current_tier

	return lvl_data

func _load_next_level() -> void:
	if level:
		level.queue_free()
	
	if len(self.get_children()) != 0:
		for child in self.get_children():
			child.queue_free()
			
	get_tree().paused = false
	level = load("res://_Scenes/Level/level.tscn").instantiate()
	var level_data = _create_next_level()
	level.load_level(level_data)

	# Add to the current scene tree
	get_tree().current_scene.add_child(level)

	level.level_complete.connect(_on_level_complete)
	
	_DeckManager.reset_draw_pile()
	
func _clear_level() -> void:
	for child in get_tree().current_scene.get_children():
		if child is Hand:
			child.queue_free()  
	if level:
		level.queue_free()
