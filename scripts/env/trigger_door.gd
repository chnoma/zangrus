extends Node


@export var target: Door
@export var lock = false
@export var open = true
@export var monster_reveal: Area3D

var triggered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if triggered:
		return
	target.set_locked(lock)
	target.set_open_state(open, true, true)
	GlobalVars.hud.display_message("THE DOOR BEHIND YOU OPENS")
	monster_reveal.monitoring = true
	triggered = true
