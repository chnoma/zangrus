class_name Player
extends Node3D

@export var god_mode = false

var health := 1.0
var alive = true
var direction := Vector3(1, 0, 0)
var desired_rotation_change = 0.0

const TURN_TIME = 0.125
var turn_speed = 0
var has_warned_low = false

var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVars.player = self
	GlobalVars.camera = $camera
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !alive:
		return
	$heartbeat_timer.wait_time = 0.02 + (health**2.2) * 0.78
	health += 0.03*delta
	
	if health > 1:
		health = 1
	elif health > 0.5 && has_warned_low:
		has_warned_low = false
	elif health < 0.3 && !has_warned_low:
		GlobalVars.hud.display_message("YOU ARE FEELING FAINT", 0)
		has_warned_low = true
	
	
	if desired_rotation_change < 0:
		var degrees = turn_speed*delta;
		if desired_rotation_change-degrees >= 0:
			rotate_y(deg_to_rad(desired_rotation_change))
			finish_turn()
			desired_rotation_change = 0
		else:
			rotate_y(deg_to_rad(degrees))
			desired_rotation_change -= degrees
	elif desired_rotation_change > 0:
		var degrees = turn_speed*delta;
		if desired_rotation_change-degrees <= 0:
			rotate_y(deg_to_rad(desired_rotation_change))
			finish_turn()
			desired_rotation_change = 0
		else:
			rotate_y(deg_to_rad(degrees))
			desired_rotation_change -= degrees


func turn(degrees: int):
	if !alive:
		return
	$SFX/Turn.play()
	rotate_y(deg_to_rad(desired_rotation_change))
	finish_turn()
	desired_rotation_change = degrees
	turn_speed = degrees / TURN_TIME

func moveRelative(desired_direction: Vector2):
	if !alive:
		return
	if (desired_direction.x < 0 && $BackRaycast.is_colliding()) ||\
		(desired_direction.x > 0 && $ForwardRaycast.is_colliding()) ||\
		(desired_direction.y < 0 && $LeftRaycast.is_colliding()) ||\
		(desired_direction.y > 0 && $RightRaycast.is_colliding()):
		$SFX/HitWall.play()
		return
	damage(0.018)
	$SFX/Step.play()
	global_transform.origin += global_transform.basis.x * desired_direction.x\
							+ global_transform.basis.z * desired_direction.y

func finish_turn():
	GlobalVars.hud.set_compass(global_transform.basis)

func damage(amount: float):
	if !alive || god_mode:
		return
	health -= amount
	if health < 0:
		die()
		health = 0

func die():
	GlobalVars.hud.set_music(GlobalVars.Music.None)
	$heartbeat_timer.stop()
	$SFX/Death.play()
	GlobalVars.hud.set_hud_color(Vector3(0,0,0))
	GlobalVars.hud.freeze_controls(true)
	GlobalVars.ai_pause = true
	await get_tree().create_timer(3).timeout
	LevelSwitch.switch_to_death()
