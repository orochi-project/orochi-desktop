@tool
extends RichTextEffect
class_name RandomFlickerEffect

var bbcode = "flicker"

@export var flicker_color: Color = Color(0.0, 0.0, 0.0)
@export_range(0.0, 1.0) var max_flicker_strength: float = 0.5
@export_range(0.0, 1.0) var flicker_chance: float = 0.02
@export_range(0.01, 1.0) var flicker_duration_seconds: float = 0.1

var last_flickered_char_fx: CharFXTransform


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	# Do not flicker the same character consecutively
	if char_fx == last_flickered_char_fx:
		pass

	var slot := int(char_fx.elapsed_time / flicker_duration_seconds)

	var rng := RandomNumberGenerator.new()
	rng.seed = hash(Vector2i(char_fx.range.x, slot))

	if rng.randf() < flicker_chance:
		char_fx.color = char_fx.color.lerp(
			flicker_color,
			rng.randf_range(0.0, max_flicker_strength),
		)
		last_flickered_char_fx = char_fx

	return true
