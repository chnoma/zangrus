class_name Waypoint
extends Sprite3D

signal reached

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func made_it():
	reached.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
