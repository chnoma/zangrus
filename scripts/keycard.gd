extends Sprite3D

@export var type = GlobalVars.Keys.Medical
var collected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pickup():
	collected = true
	visible = false
	$Area3D/CollisionShape3D.disabled = true
	GlobalVars.hud.display_message("OBTAINED " + GlobalVars.key_desc[type] + " ACCESS")
	GlobalVars.held_keys.append(type)
	
