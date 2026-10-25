extends Node2D

@export var mouse_strengths: Array[float] = []
@export var smoothness: float = 5.0

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
