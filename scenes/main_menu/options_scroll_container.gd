extends ScrollContainer

## The minimum number of pixels the cursor must move before being counted as a drag.
@export var drag_threshold: float = 10.0
## The scroll speed multiplier.
@export var scroll_speed: float = 30.0

var _target_scroll: float = 0.0

var _just_dragged: bool = false
var _pressing: bool = false
var _dragging: bool = false
var _start_x: float = 0.0
var _start_scroll: float = 0.0


func _ready() -> void:
	await get_tree().process_frame  # wait one frame for the ScrollContainer to calculate range
	_target_scroll = self.scroll_horizontal


func _process(delta: float) -> void:
	var bar: HScrollBar = get_h_scroll_bar()
	_target_scroll = clampf(
		_target_scroll,
		0.0,
		bar.max_value
	)  # keep target between beginning and end of content

	# Scroll smoothly toward the target scroll position
	self.scroll_horizontal = roundi(
		lerpf(
			self.scroll_horizontal,
			_target_scroll,
			1.0 - exp(-12.0 * delta)
		)
	)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and get_global_rect().has_point(
		event.position
	):
		var amount: float = scroll_speed * event.factor

		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_LEFT:
				_target_scroll -= amount
				get_viewport().set_input_as_handled()
			MOUSE_BUTTON_WHEEL_DOWN, MOUSE_BUTTON_WHEEL_RIGHT:
				_target_scroll += amount
				get_viewport().set_input_as_handled()
	elif event is InputEventPanGesture:
		_target_scroll += event.delta.x * scroll_speed
		get_viewport().set_input_as_handled()

	_target_scroll = clampf(
		_target_scroll,
		0.0,
		get_h_scroll_bar().max_value
	)

	# Check if the left mouse button is either lifted or pressed
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# If the LMB is pressed AND the click was inside the scroll bar, start scrolling
		if event.pressed and get_global_rect().has_point(event.global_position):
			_pressing = true
			_dragging = false
			_start_x = event.global_position.x
			_start_scroll = self.scroll_horizontal
		else:  # lifted up
			if _dragging:
				_just_dragged = true
				_clear_just_dragged()
			_pressing = false
			_dragging = false
	elif event is InputEventMouseMotion and _pressing:
		# Calculate how far the mouse moved while pressing to determine whether it passes drag_threshold and counts as a drag
		var dx: float = event.global_position.x - _start_x

		if not _dragging and abs(dx) > drag_threshold:
			_dragging = true

		if _dragging:
			self.scroll_horizontal = int(_start_scroll - dx)
			_target_scroll = self.scroll_horizontal
			get_viewport().set_input_as_handled()


func _clear_just_dragged() -> void:
	await get_tree().process_frame
	_just_dragged = false


## The callback process for button press events that ignores release signals if it resulted from a scroll that just ended.
# TODO: Implement this function.
func _on_button_pressed() -> void:
	if _just_dragged:
		return
