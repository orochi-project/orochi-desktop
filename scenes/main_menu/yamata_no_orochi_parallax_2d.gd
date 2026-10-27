extends Parallax2D

## Determines which anchor type to use.
enum Anchor {
	LEFT,  ## Anchors to the left side.
	RIGHT,  ## Anchors to the right side.
}

## The speed at which the object rotates to a target angle.
@export var smoothness: float = 2.0
## The maximum number of degrees the object can rotate before being clamped.
@export var max_rotation_degrees: float = 2.0
## The side of the screen on which the sensor is placed.
@export var anchor: Anchor = Anchor.LEFT


func _process(delta: float) -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	var mouse_pos: Vector2 = get_global_mouse_position()

	## The rotation target modifier based on the position of the cursor relative to the anchor.[br]
	## The cursor's movement should have a larger effect on the rotation depending on how close the cursor is to the anchor.
	var mouse_x_modifier: float

	# Using 1.5 and 0.5 instead of 1 and 0 so that the object still rotates even if the cursor is all the way at the opposite edge of the screen
	if anchor == Anchor.LEFT:
		# If the sensor is anchored on the left, the modifier should be larger when the cursor is closer to the left side of the screen
		mouse_x_modifier = 1.5 - mouse_pos.x / viewport_size.x
	else:
		# Otherwise, if the sensor is anchored on the right, the modifier should be larger when the cursor is closer to the right side of the screen
		mouse_x_modifier = 0.5 + mouse_pos.x / viewport_size.x

	var mouse_y_scaled: float = (1 - mouse_pos.y / viewport_size.y) * max_rotation_degrees

	## The rotation angle to interpolate the object to
	var target: float = -deg_to_rad(
		clampf(mouse_y_scaled * mouse_x_modifier, 0.0, max_rotation_degrees)
		- max_rotation_degrees / 2
	)

	# Interpolate the object to the target angle
	self.rotation = lerp_angle(self.rotation, target, clampf(smoothness * delta, 0.0, 1.0))
