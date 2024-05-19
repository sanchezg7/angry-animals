extends RigidBody2D

@onready var debug_label = $DebugLabel

enum ANIMAL_STATE { READY, DRAG, RELEASE }

var _state: ANIMAL_STATE = ANIMAL_STATE.READY

const ACTION_DRAG = "drag"

# 60 px bounding box to gaurantee we fire in the right direction
const DRAG_LIM_MAX: Vector2 = Vector2(0, 60) # top left point
const DRAG_LIM_MIN: Vector2 = Vector2(-60, 0) # bottom right point

var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	_start = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update(delta)
	# This will give a list of keys, since enums are a dict
	debug_label.text = "%s\n" % ANIMAL_STATE.keys()[_state]
	debug_label.text += "%.1f,%.1f" % [_dragged_vector.x, _dragged_vector.y]

func die() -> void:
	queue_free()

func set_release_state() -> void:
	freeze = false
	_state = ANIMAL_STATE.RELEASE
	
func set_drag_state() -> void:
	_state = ANIMAL_STATE.DRAG
	_drag_start = get_global_mouse_position()

func has_user_released() -> bool:
	if _state == ANIMAL_STATE.DRAG:
		if Input.is_action_just_released(ACTION_DRAG) == true:
			set_release_state()
			return true
	return false

func get_dragged_vector(gmp: Vector2) -> Vector2:
	return gmp - _drag_start

func drag_within_limits() -> void:
	# don't let x go outside the limits
	_dragged_vector.x = clampf(
		_dragged_vector.x,
		DRAG_LIM_MIN.x,
		DRAG_LIM_MAX.x)
	_dragged_vector.y = clampf(
		_dragged_vector.y, 
		DRAG_LIM_MIN.y, 
		DRAG_LIM_MAX.y)
	position = _start + _dragged_vector

func update_drag() -> void:
	if has_user_released() == true:
		return
	var gmp = get_global_mouse_position()
	_dragged_vector = get_dragged_vector(gmp)
	drag_within_limits()

func update(delta: float) -> void:
	match _state:
		ANIMAL_STATE.DRAG:
			update_drag()

func _on_visible_on_screen_notifier_2d_screen_exited():
	AnimalManager.on_animal_died.emit()
	die()
	
func _on_input_event(viewport, event: InputEvent, shape_idx):
	var isDragPressed = event.is_action_pressed(ACTION_DRAG)
	if _state == ANIMAL_STATE.READY and isDragPressed:
		set_drag_state()
