class_name Hud
extends Node

var current_message_priority = -1
var current_music = GlobalVars.Music.None

func _init():
	GlobalVars.hud = self
	call_deferred("spawn")
	call_deferred("set_hud_color", Vector3(1,1,1))

func spawn():
	display_message("IT'S QUIET... TOO QUIET...")

func set_compass(basis: Basis):
	var dir = basis.get_euler()
	$compass_up.visible = abs(dir.y) < 0.1
	$compass_down.visible = (dir.y < -3 || dir.y > 3)
	$compass_left.visible = (-3 < dir.y && dir.y  < -1)
	$compass_right.visible = (dir.y > 1 && dir.y < 3)


func freeze_controls(frozen=true):
	$moveForwardButton.visible = !frozen
	$moveLeftButton.visible = !frozen
	$moveRightButton.visible = !frozen
	$turnleftButton.visible = !frozen
	$turnrightButton.visible = !frozen
	$turnaroundButton.visible = !frozen


func display_message(text: String, priority=1, timeout=5, play_sound=true):
	if GlobalVars.finale:
		return
	if priority < current_message_priority:
		return
	if play_sound:
		$SFX/msg.play()
	$MsgboxHideTimer.wait_time = timeout
	$MsgBox.text = text
	$MsgBox.visible = true
	$MsgboxHideTimer.start()
	current_message_priority = priority

func hide_msgbox():
	$MsgBox.visible = false
	current_message_priority = -1

func set_music(music: GlobalVars.Music):
	if current_music == music:
		return
		
	if music == GlobalVars.Music.Ambient:
		$Music/anim_ambient.play("fade_in")
	else:
		$Music/anim_ambient.play("fade_out")
		
	if music == GlobalVars.Music.DangerClose:
		$Music/anim_danger.play("fade_in")
	else:
		$Music/anim_danger.play("fade_out")

	if music == GlobalVars.Music.Chase:
		$Music/anim_chase.play("fade_in")
	else:
		$Music/anim_chase.play("fade_out")
	
	if music == GlobalVars.Music.Escape:
		$Music/escape.play()
		print("ESCAPING!!!!")
	
	current_music = music

func set_hud_color(color: Vector3):
	$colorize.material.set_shader_parameter("color", color)

func timer_on():
	$Music/alarm.play()
	$timertext.visible = true
	$timertext.running = true
	$timer_box.visible = true
