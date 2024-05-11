extends RigidBody2D

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = "%s" % sleeping


func _on_timer_timeout():
	freeze = false
