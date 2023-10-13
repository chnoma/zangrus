extends Node

@export var max_use_distance := 1.25

@export var target: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1 \
		&& position.distance_to(camera.global_transform.origin) < max_use_distance \
		&& target:
			target.call("trigger")
