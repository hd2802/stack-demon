extends Sprite2D

@export var rotation_speed: float = 5.0

var is_hovered = false

func _ready():
	material = material.duplicate()

func _input(event):
	if event is InputEventMouseMotion:
		var local_mouse_pos = to_local(event.position)
		var in_bounds = get_rect().has_point(local_mouse_pos)

		if in_bounds:
			is_hovered = true
			var sprite_size = get_rect().size

			var centered_mouse_pos = (local_mouse_pos - (sprite_size / 2.0)) / sprite_size

			var x_angle = -centered_mouse_pos.y  * rotation_speed * 2.0
			var y_angle = centered_mouse_pos.x * rotation_speed * 2.0

			material.set_shader_parameter("x_rot", x_angle)
			material.set_shader_parameter("y_rot", y_angle)
			
		elif is_hovered:

			is_hovered = false
			material.set_shader_parameter("x_rot", 0.0)
			material.set_shader_parameter("y_rot", 0.0)
