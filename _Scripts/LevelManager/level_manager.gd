extends Node
class_name LevelManager

var level : Level

# Can only be the values 0, 1 or 2 
var current_tier : int = 0
# Incremented when all 3 tiers are completed
var current_level : int = 0
var tier_base_target : int = 2
var tier_current_target : int = tier_base_target

var rng = RandomNumberGenerator.new()

const MIN_RAND_RANGE : int = 5
const MAX_RAND_RANGE : int = 12

const TIER_INCREASE : int = 5

func _ready() -> void:
	level = load("res://_Scenes/Level/level.tscn").instantiate()
	var lvl_data = load("res://Resources/Levels/start.tres")
	level.load_level(lvl_data)
	self.add_child(level)
	
	level.level_complete.connect(_on_level_complete)
	
func _on_level_complete() -> void:
	_load_next_level()
	
func _create_next_level() -> LevelDataResource:
	var lvl_data = LevelDataResource.new()
	
	# Note: this is when the level is completed so the tier needs to be incremented
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
	
	lvl_data.level_number = current_level
	lvl_data.target_value = tier_current_target
	lvl_data.tier = current_tier

	return lvl_data

func _load_next_level() -> void:
	if level:
		level.queue_free()

	level = load("res://_Scenes/Level/level.tscn").instantiate()
	var level_data = _create_next_level()
	level.load_level(level_data)
	self.add_child(level)

	level.level_complete.connect(_on_level_complete)
