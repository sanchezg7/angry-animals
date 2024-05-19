extends RigidBody2D

@onready var anDrag = preload("res://global/animal_drag.gd").new()

@onready var debug_label = $DebugLabel
@onready var stretch_sound = $StretchSound
@onready var launch_sound = $LaunchSound
@onready var arrow = $Arrow

enum ANIMAL_STATE { READY, DRAG, RELEASE }
var _state: ANIMAL_STATE = ANIMAL_STATE.READY

const ACTION_DRAG = "drag"

# the initial position of the animal
var _start: Vector2 = Vector2.ZERO

const IMPULSE_MULT: float = 20.0
const IMPULSE_MAX: float = 1200.0

var _arrow_scale_x: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	_arrow_scale_x = arrow.scale.x
	arrow.hide()
	_start = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update(delta)
	
	var _dragged_vector = anDrag.get_dragged_vector()
	# This will give a list of keys, since enums are a dict
	debug_label.text = "%s\n" % ANIMAL_STATE.keys()[_state]
	debug_label.text += "%.1f,%.1f" % [_dragged_vector.x, _dragged_vector.y]

func die() -> void:
	queue_free()

func get_impulse() -> Vector2:
	return anDrag.get_dragged_vector() * -1 * IMPULSE_MULT

func set_release_state() -> void:
	arrow.hide()
	freeze = false
	_state = ANIMAL_STATE.RELEASE
	apply_central_impulse(get_impulse())
	launch_sound.play()
	
func set_drag_state() -> void:
	arrow.show()
	_state = ANIMAL_STATE.DRAG
	anDrag.set_drag_start(get_global_mouse_position())

func has_user_released_and_update_state() -> bool:
	if _state == ANIMAL_STATE.DRAG:
		if Input.is_action_just_released(ACTION_DRAG) == true:
			set_release_state()
			return true
	return false

func update(delta: float) -> void:
	var gmp = get_global_mouse_position()
	match _state:
		ANIMAL_STATE.DRAG:
			if has_user_released_and_update_state() == true:
				return
			position = anDrag.get_dragged_position(gmp, _start)
			play_stretch_sound()
			scale_arrow()

func _on_visible_on_screen_notifier_2d_screen_exited():
	AnimalManager.on_animal_died.emit()
	die()
	
func _on_input_event(viewport, event: InputEvent, shape_idx):
	var isDragPressed = event.is_action_pressed(ACTION_DRAG)
	if _state == ANIMAL_STATE.READY and isDragPressed:
		set_drag_state()


func scale_arrow() -> void:
	var imp_len = get_impulse().length()
	var perc = imp_len / IMPULSE_MAX
	arrow.scale.x = (_arrow_scale_x * perc) + _arrow_scale_x
	
	arrow.rotation = (_start - position).angle()
	

func play_stretch_sound() -> void:
	var hasUserDragged: bool = (anDrag.get_last_dragged_vector() - anDrag.get_dragged_vector()).length() > 0
	if(hasUserDragged):
		if stretch_sound.playing == false:
			stretch_sound.play()
		
