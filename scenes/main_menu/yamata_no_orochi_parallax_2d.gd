extends Parallax2D

@export var mouse_strength: float = 30.0
@export var smoothness: float = 2.0
@export var max_rotation_degrees: float = 2.0
@export var anchor: Anchor = Anchor.LEFT

enum Anchor {
	LEFT,
	RIGHT,
}


func _process(delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	var mouse_pos = get_global_mouse_position()

	# The cursor's movement should have a larger effect on the rotation depending on how close the cursor is to the anchor
	var mouse_x_scaled = (
		1.5 - mouse_pos.x / viewport_size.x
		if anchor == Anchor.LEFT
		else 0.5 + mouse_pos.x / viewport_size.x
	) * max_rotation_degrees
	var mouse_y_scaled = (mouse_pos.y / viewport_size.y) * max_rotation_degrees

	var target = -deg_to_rad(
		clampf(mouse_x_scaled - mouse_y_scaled, 0.0, max_rotation_degrees)
		- max_rotation_degrees / 2
	)

	# Interpolate the object to the target angle
	self.rotation = lerp_angle(self.rotation, target, clampf(smoothness * delta, 0.0, 1.0))
