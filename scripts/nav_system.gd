extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalNav.nav_map = self
	GlobalNav.calculate_nav()
