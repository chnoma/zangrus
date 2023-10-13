extends Node

var finale = false

enum Keys {Medical, Engineering, Bridge, Reactor}

enum Music {Ambient, DangerClose, Chase, Escape, None}

var key_desc = {
	Keys.Medical: "MEDICAL",
	Keys.Engineering: "ENG",
	Keys.Bridge: "BRIDGE",
	Keys.Reactor: "REACTOR"
}

var held_keys = []
#var held_keys = [Keys.Medical, Keys.Engineering, Keys.Bridge, Keys.Reactor]
var player
var camera: Camera3D
var hud: Hud
var scene_root: Node3D
var ai_pause = false

var enemies = []

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func register_enemy(ent):
	enemies.append(ent)

func update_music():
	if !hud:
		return
	if finale:
		return
	var new_music = Music.Ambient
	for enemy in enemies:
		var music = Music.Ambient
		if enemy.current_behavior == Enemy.Behavior.CHASE:
			music = Music.Chase
		elif enemy.agressive:
			music = Music.DangerClose
		if music > new_music:
			new_music = music
	hud.set_music(new_music)

func begin_finale():
	hud.timer_on()
	hud.set_music(Music.Escape)
	finale = true
