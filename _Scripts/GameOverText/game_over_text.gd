extends RichTextLabel

@export var speed : int = 5
@export var fade : bool = false

var time = 0
var sin_time = 0
var _visible = true

func _ready() -> void:
	self.text = "[center] [color=red] BREACH DETECTED: SHUTTING DOWN [/color][/center]"

func flash_text():
	if !fade:
		if sin_time > 0:
			_visible = true
		else:
			_visible = false
	else:
		_visible = true
		modulate.a = sin_time
	visible = _visible

func _physics_process(delta):
	time += delta
	sin_time = sin(time * speed)
	flash_text()
