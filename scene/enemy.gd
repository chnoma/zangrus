class_name Enemy
extends Node3D

enum Behavior {WANDER, CHASE, IDLE, WAYPOINT}

@export var damage := 0.3
@export var agressive = false
@export var sight_range = 5
@export var enlarge_when_close = false
@export var think_min = 0.5
@export var think_max = 3
@export var current_behavior = Behavior.WANDER
@export var waypoint: Node3D
@export var post_waypoint_behavior = Behavior.WANDER
@export var can_break_doors = false
@export var vanishes = false
@export var vanish_steps = 3
var beenhadclose = false

var steps_taken = 0
var steps_since_player_seen = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = randf_range(think_min, think_max)
	$Timer.start()
	GlobalVars.enemies.append(self)
	GlobalVars.update_music()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if agressive && current_behavior != Behavior.CHASE && can_see_player()\
	   && global_position.distance_to(GlobalVars.player.global_position) < sight_range:
		$SFX/PlayerSpotted.play()
		current_behavior = Behavior.CHASE
		GlobalVars.update_music()
		
	close_test()


func can_see_player(infinite_range=false):
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, GlobalVars.player.global_position,
	0x00000101)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if !result:
		return false
	if result.collider.collision_mask == 0x1:
		return false
	if !infinite_range && global_position.distance_to(GlobalVars.player.global_position) > sight_range:
		return false
	return true
	
	


func think():
	if !GlobalVars.player or GlobalVars.ai_pause:
		return
	$Timer.wait_time = randf_range(think_min, think_max)
	if global_transform.origin.distance_to(GlobalVars.player.global_position) <= 1.25:
		$SFX/Attack.play()
		GlobalVars.player.damage(damage)
		return
	var possible_moves = []
	if !$LeftRaycast.is_colliding():
		possible_moves.append(Vector2(0, -1))
	if !$RightRaycast.is_colliding():
		possible_moves.append(Vector2(0, 1))
	if !$ForwardRaycast.is_colliding():
		possible_moves.append(Vector2(1, 0))
	if !$BackRaycast.is_colliding():
		possible_moves.append(Vector2(-1, 0))
	
	if current_behavior == Behavior.WANDER:
		if possible_moves.size() == 0:
			return
		moveRelative(possible_moves[randi() % possible_moves.size()])
		if vanishes and steps_since_player_seen > vanish_steps:
			self.call_deferred("queue_free")
	elif current_behavior == Behavior.CHASE:
		if !navigate_towards(GlobalVars.player.global_position):
			steps_taken +=1
		else:
			steps_taken = 0
		if steps_taken > 5:
			current_behavior = Behavior.WANDER
			steps_taken = 0
			GlobalVars.update_music()
	elif current_behavior == Behavior.WAYPOINT:
		if !waypoint:
			return
		if global_position == waypoint.global_position:
			current_behavior = post_waypoint_behavior
		else:
			navigate_towards(waypoint.global_position)
	
	if can_see_player(true):
		steps_since_player_seen = 0
	else:
		steps_since_player_seen += 1
	
	close_test()

func navigate_towards(target_pos: Vector3):
	var start = GlobalNav.nav_root.get_closest_point(global_position)
	var end = GlobalNav.nav_root.get_closest_point(target_pos)
	if start == -1 or end == -1:
		print("no path")
		return false
	var path = GlobalNav.nav_root.get_point_path(start, end)
	if path.size() < 2:
		print("no path")
		return false
	else:
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(path[0], path[1],
		0x00000001)
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		if result && is_instance_of(result.collider.get_parent(), Door):
			var door = result.collider.get_parent()
			if door.breakable:
				door.damage()
				if door.damage_taken != 2:
					$Timer.wait_time = think_max*2
				$Timer.stop()
				$Timer.start()
		else:
			moveAbsolute(path[1] - path[0])
	return true

func close_test():
	if !GlobalVars.player:
		return
	if global_transform.origin.distance_to(GlobalVars.player.global_transform.origin) <= 1.25:
		if enlarge_when_close:
			$Sprite.no_depth_test = true
			$Sprite.pixel_size = 0.01
		if !beenhadclose:
			$SFX/Close.play()
			beenhadclose = true
	else:
		beenhadclose = false
		$Sprite.no_depth_test = false
		$Sprite.pixel_size = 0.005

func moveRelative(direction: Vector2):
	if (direction.x < 0 && $BackRaycast.is_colliding()) ||\
		(direction.x > 0 && $ForwardRaycast.is_colliding()) ||\
		(direction.y < 0 && $LeftRaycast.is_colliding()) ||\
		(direction.y > 0 && $RightRaycast.is_colliding()):
		return
	$SFX/Move.play()
	global_transform.origin += global_transform.basis.x * direction.x\
							+ global_transform.basis.z * direction.y

func moveAbsolute(direction: Vector3):
	$SFX/Move.play()
	global_transform.origin += direction

func _notification(event):
	if event == NOTIFICATION_PREDELETE:
		GlobalVars.enemies.erase(self)
		GlobalVars.update_music()
