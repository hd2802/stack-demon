extends Node
class_name LevelManager

var level: Level = null

# Can only be 0, 1, or 2 
var current_tier: int = 1
# Incremented when all 3 tiers are completed
var current_level: int = 1
var tier_base_target: int = 2
var tier_current_target: int = tier_base_target

const MAX_MOVES: int = 5
var moves: int = 5

var rng = RandomNumberGenerator.new()

const MIN_RAND_RANGE: int = 10
const MAX_RAND_RANGE: int = 20
const TIER_INCREASE: int = 20

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
	level.game_over.connect(_on_game_over)

func _on_level_complete() -> void:
	level.get_node("PlayArea").clear_hand()
	await get_tree().create_timer(1.25).timeout
	# only after the level transition is over do we want to load in the next level 
	get_tree().paused = true
	var transition_scene
	
	if current_level == 5:
		# here the game is over - the player can continue if they would like
		# in 'endless mode' but other than that, they have completed the game
		pass
	else:
		if current_tier == 3:
			transition_scene = load("res://_Scenes/Transitions/Level/level_transition.tscn").instantiate()
			transition_scene.level_next.connect(_load_transition)
		else:
			transition_scene = load("res://_Scenes/Transitions/Tier/tier_transition.tscn").instantiate()
			transition_scene.next.connect(_load_next_level)
		
		self.add_child(transition_scene)

func _load_transition() -> void:
	get_tree().paused = false
	if level:
		_clear_level()
	var shop = load("res://_Scenes/Shop/shop.tscn").instantiate()
	shop.shop_finished.connect(_load_next_level)
	self.add_child(shop)

func _create_next_level() -> LevelDataResource:
	var lvl_data = LevelDataResource.new()
	
	# Increment tier
	current_tier += 1
	
	if current_tier == 2:
		tier_current_target += rng.randi_range(MIN_RAND_RANGE, MAX_RAND_RANGE)
	elif current_tier == 3:
		tier_current_target += rng.randi_range(MIN_RAND_RANGE, MAX_RAND_RANGE)
	else: # current_tier == 3
		current_tier = 1
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
	
	get_tree().current_scene.add_child(level)

	level.level_complete.connect(_on_level_complete)
	level.game_over.connect(_on_game_over)
		
	_DeckManager.reset_draw_pile()
	
func _clear_level() -> void:
	for child in get_tree().current_scene.get_children():
		if child is Hand:
			child.queue_free()  
	if level:
		level.queue_free()

func _on_game_over() -> void:
	await get_tree().create_timer(1.25).timeout
	get_tree().paused = true
	var game_over = load("res://_Scenes/Transitions/GameOver/game_over.tscn").instantiate()
	self.add_child(game_over)
