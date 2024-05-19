extends Node2D

const ANIMAL = preload("res://scenes/animal/animal.tscn")
@onready var animal_start_marker = $AnimalStartMarker

# Called when the node enters the scene tree for the first time.
func _ready():
	add_animal()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func add_animal() -> void:
	var animal = ANIMAL.instantiate()
	animal.position = animal_start_marker.position
	add_child(animal)
