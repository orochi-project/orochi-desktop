extends Sprite2D

## The movement speed of the image in pixels per second.
@export var movement_velocity: float = 60.0
## The width of one repeated image in pixels.
@export var texture_width: float = 1920.0

var starting_x: float


func _ready() -> void:
	starting_x = position.x


func _process(delta: float) -> void:
	position.x += movement_velocity * delta

	# Reposition the image to make it scroll forever
	if position.x >= starting_x + texture_width:
		position.x -= texture_width
	elif position.x <= starting_x - texture_width:
		position.x += texture_width
