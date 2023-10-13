class_name Door
extends MeshInstance3D

enum DoorType{standard, residential, reactor, medical, engineering, bridge, escape}

var key_type = {
	DoorType.medical: GlobalVars.Keys.Medical,
	DoorType.engineering: GlobalVars.Keys.Engineering,
	DoorType.bridge: GlobalVars.Keys.Bridge,
	DoorType.reactor: GlobalVars.Keys.Reactor,
}

var texture_closed_locked = {
	DoorType.standard : preload("res://textures/environment/doors/standard/door_locked.png"),
	DoorType.residential : preload("res://textures/environment/doors/residential/door_locked.png"),
	DoorType.reactor : preload("res://textures/environment/doors/reactor/door_locked.png"),
	DoorType.medical : preload("res://textures/environment/doors/medical/door_locked.png"),
	DoorType.engineering : preload("res://textures/environment/doors/engineering/door_locked.png"),
	DoorType.bridge : preload("res://textures/environment/doors/bridge/door_locked.png"),
	DoorType.escape : preload("res://textures/environment/doors/escape/door_locked.png"),
}

var texture_closed_unlocked = {
	DoorType.standard : preload("res://textures/environment/doors/standard/door_unlocked.png"),
	DoorType.residential : preload("res://textures/environment/doors/residential/door_unlocked.png"),
	DoorType.reactor : preload("res://textures/environment/doors/reactor/door_unlocked.png"),
	DoorType.medical : preload("res://textures/environment/doors/medical/door_unlocked.png"),
	DoorType.engineering : preload("res://textures/environment/doors/engineering/door_unlocked.png"),
	DoorType.bridge : preload("res://textures/environment/doors/bridge/door_unlocked.png"),
	DoorType.escape : preload("res://textures/environment/doors/escape/door_unlocked.png"),
}

var texture_open_unlocked = preload("res://textures/environment/doors/standard/door_open_unlocked.png")
var texture_open_locked = preload("res://textures/environment/doors/standard/door_open_locked.png")
var texture_closed_broken = preload("res://textures/environment/doors/standard/broken.png")
var texture_open_broken = preload("res://textures/environment/doors/standard/broken_open.png")

@export var type = DoorType.standard
@export var is_open = false
@export var locked = false
@export var self_closing = true
@export var is_broken = false
@export var breakable = false

var damage_taken = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_open_state(is_open, true, true, true)
	material_override = get_active_material(0).duplicate()
	if is_broken:
		break_door(is_open)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func damage():
	if damage_taken > 2:
		return  # why is this happening?
	damage_taken += 1
	if damage_taken == 1:
		$SFX/damage_1.play()
		break_door(false)
		return
	$SFX/damage_2.play()
	break_door(true)

func break_door(open=false):
	is_broken = true
	set_open_state(open, true, true, true)
	if !open:
		get_active_material(0).set_texture(0, texture_closed_broken)
	else:
		get_active_material(0).set_texture(0, texture_open_broken)
	

func trigger():
	set_open_state(!is_open)

func set_locked(lock):
	locked = lock

func self_close():
	if is_broken:
		return
	if $PreventCloseArea.has_overlapping_areas():
		$self_close_timer.start()
		return
	set_open_state(false, true, true)

func set_open_state(state, silence_prompt=false, force=false, silence=false):
	if is_broken && !force:
		if !silence:
			$SFX/denied.play()
		if !silence_prompt:
			GlobalVars.hud.display_message("THE DOOR IS BROKEN", 1, 5, false)
		return
	
	if locked && !force:
		if !silence:
			$SFX/denied.play()
		if !silence_prompt:
			GlobalVars.hud.display_message("THE DOOR IS LOCKED", 1, 5, false)
		return
	
	if key_type.has(type) && !force:
		if !GlobalVars.held_keys.has(key_type[type]):
			if !silence:
				$SFX/denied.play()
			if !silence_prompt:
				GlobalVars.hud.display_message("DOOR REQUIRES " + GlobalVars.key_desc[key_type[type]] + " ACCESS", 1, 5, false)
			return
			
	if state:
		$blocker.collision_layer = 0
		if !locked:
			get_active_material(0).set_texture(0, texture_open_unlocked)
		else:
			get_active_material(0).set_texture(0, texture_open_locked)
		
		if !silence:
			$SFX/close.stop()
			$SFX/open.play()
		if !silence_prompt:
			GlobalVars.hud.display_message("THE DOOR OPENS")
		if self_closing:
			$self_close_timer.start()
	else:
		$blocker.collision_layer = 1
		if !locked:
			get_active_material(0).set_texture(0, texture_closed_unlocked[type])
		else:
			get_active_material(0).set_texture(0, texture_closed_locked[type])
			
		if !silence:
			$SFX/open.stop()
			$SFX/close.play()
		if !silence_prompt:
			GlobalVars.hud.display_message("THE DOOR CLOSES")
		$self_close_timer.stop()
	
	if !breakable:
		GlobalNav.nav_root.set_point_disabled(
			GlobalNav.nav_root.get_closest_point(global_position, true), !state)
	
	is_open = state
