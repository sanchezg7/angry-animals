extends RigidBody2D

@onready var anDrag = preload("res://global/animal_drag.gd").new()

@onready var debug_label = $DebugLabel
@onready var stretch_sound = $StretchSound

enum ANIMAL_STATE { READY, DRAG, RELEASE }
var _state: ANIMAL_STATE = ANIMAL_STATE.READY

const ACTION_DRAG = "drag"

var _start: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	_start = position
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update(delta)
	# This will give a list of keys, since enums are a dict
	var _dragged_vector = anDrag.get_dragged_vector()
	debug_label.text = "%s\n" % ANIMAL_STATE.keys()[_state]
	debug_label.text += "%.1f,%.1f" % [_dragged_vector.x, _dragged_vector.y]

func die() -> void:
	queue_free()

func set_release_state() -> void:
	freeze = false
	_state = ANIMAL_STATE.RELEASE
	
func set_drag_state() -> void:
	_state = ANIMAL_STATE.DRAG
	anDrag.set_drag_start(get_global_mouse_position())

func has_user_released() -> bool:
	if _state == ANIMAL_STATE.DRAG:
		if Input.is_action_just_released(ACTION_DRAG) == true:
			set_release_state()
			return true
	return false

func update(delta: float) -> void:
	var gmp = get_global_mouse_position()
	match _state:
		ANIMAL_STATE.DRAG:
			if has_user_released() == true:
				return
			position = anDrag.get_dragged_position(gmp, _start)
			play_stretch_sound()

func _on_visible_on_screen_notifier_2d_screen_exited():
	AnimalManager.on_animal_died.emit()
	die()
	
func _on_input_event(viewport, event: InputEvent, shape_idx):
	var isDragPressed = event.is_action_pressed(ACTION_DRAG)
	if _state == ANIMAL_STATE.READY and isDragPressed:
		set_drag_state()
		
func play_stretch_sound() -> void:
	var hasUserDragged: bool = (anDrag.get_last_dragged_vector() - anDrag.get_dragged_vector()).length() > 0
	if(hasUserDragged):
		if stretch_sound.playing == false:
			stretch_sound.play()
		
