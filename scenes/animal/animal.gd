extends RigidBody2D

@onready var debug_label = $DebugLabel

enum ANIMAL_STATE { READY, DRAG, RELEASE }

var _state: ANIMAL_STATE = ANIMAL_STATE.READY

const ACTION_DRAG = "drag"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update(delta)
	# This will give a list of keys, since enums are a dict
	debug_label.text = "%s" % ANIMAL_STATE.keys()[_state]

func die() -> void: 
	queue_free()

func set_release_state() -> void:
	freeze = false
	_state = ANIMAL_STATE.RELEASE
	
func set_drag_state() -> void:
	_state = ANIMAL_STATE.DRAG

func has_user_released() -> bool:
	if _state == ANIMAL_STATE.DRAG:
		if Input.is_action_just_released(ACTION_DRAG) == true:
			set_release_state()
			return true
	return false

func update_drag() -> void:
	if has_user_released() == true:
		return
	var gmp = get_global_mouse_position()
	position = gmp

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
