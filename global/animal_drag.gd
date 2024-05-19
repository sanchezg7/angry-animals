extends RigidBody2D

# 60 px bounding box to gaurantee we fire in the right direction
const DRAG_LIM_MAX: Vector2 = Vector2(0, 60) # top left point
const DRAG_LIM_MIN: Vector2 = Vector2(-60, 0) # bottom right point

var _start: Vector2 = Vector2.ZERO
# Where the drag starts when the user clicks
var _drag_start: Vector2 = Vector2.ZERO
func set_drag_start(value: Vector2) -> void:
	_drag_start = value

# Track where the mouse has gone after recording drag start. Delta computed off of newest gmp
var _dragged_vector: Vector2 = Vector2.ZERO
func get_dragged_vector() -> Vector2:
	return _dragged_vector
	
func get_position_dragged_within_limits(_dragged_vector: Vector2, _start: Vector2) -> Vector2:
	# don't let x go outside the limits
	_dragged_vector.x = clampf(
		_dragged_vector.x,
		DRAG_LIM_MIN.x,
		DRAG_LIM_MAX.x)
	_dragged_vector.y = clampf(
		_dragged_vector.y, 
		DRAG_LIM_MIN.y, 
		DRAG_LIM_MAX.y)
	return _start + _dragged_vector
	
func calculate_dragged_vector(gmp: Vector2, _drag_start: Vector2) -> Vector2:
	return gmp - _drag_start

func get_dragged_position(gmp: Vector2, _start: Vector2) -> Vector2:
	var raw_dragged_vector = calculate_dragged_vector(gmp, _drag_start)
	_dragged_vector = get_position_dragged_within_limits(raw_dragged_vector, _start)
	return _dragged_vector
