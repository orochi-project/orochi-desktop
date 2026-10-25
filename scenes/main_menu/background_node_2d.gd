extends Node2D

## The list of parallax mouse strengths.[br]
## Each item corresponds to a Parallax2D child of the node.
@export var mouse_strengths: Array[float] = []
## The speed at which the object moves to a target position.
@export var smoothness: float = 0.5

## The child Parallax2D layers to apply the parallax effect to.
var layers: Array[Parallax2D] = []


func _ready() -> void:
	for child in get_children():
		if child is Parallax2D:
			layers.append(child)


func _process(delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	var mouse_pos = get_global_mouse_position()
	var offset = (mouse_pos / viewport_size) * 2.0 - Vector2.ONE

	for i in range(mini(layers.size(), mouse_strengths.size())):
		var layer = layers[i]
		var target = -offset * mouse_strengths[i]

		# Interpolate the layer's position to the new scroll offset
		layer.scroll_offset = layer.scroll_offset.lerp(target, clampf(smoothness * delta, 0.0, 1.0))
