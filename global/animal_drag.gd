extends Node

# 60 px bounding box to gaurantee we fire in the right direction
const DRAG_LIM_MAX: Vector2 = Vector2(0, 60) # top left point
const DRAG_LIM_MIN: Vector2 = Vector2(-60, 0) # bottom right point

func hello():
	print("hello")

func drag_within_limits(_dragged_vector: Vector2, _start: Vector2) -> Vector2:
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
