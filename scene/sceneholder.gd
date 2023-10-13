extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	LevelSwitch.root_node = $child_scene
	LevelSwitch.switch_to_main()
