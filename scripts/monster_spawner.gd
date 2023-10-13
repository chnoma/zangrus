class_name MonsterSpawner
extends Sprite3D

@export var enemy: PackedScene = load("res://scene/entities/crystal_spider.tscn")

@export var damage_override: float
@export var agressive_override: bool
@export var sight_range_override: float
@export var enlarge_when_close_override: bool
@export var think_min_override: float
@export var think_max_override: float
@export var current_behavior_override: Enemy.Behavior
@export var waypoint_override: Node3D
@export var post_waypoint_behavior_override: Enemy.Behavior
@export var can_break_doors_override: bool
@export var vanishes_override: bool
@export var vanish_steps_override: int

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func spawn():
	var new_enemy = enemy.instantiate()
	if damage_override != null:
		new_enemy.damage = damage_override
	if agressive_override != null:
		new_enemy.agressive = agressive_override
	if sight_range_override != null:
		new_enemy.sight_range = sight_range_override
	if enlarge_when_close_override != null:
		new_enemy.enlarge_when_close = enlarge_when_close_override
	if think_min_override != null:
		new_enemy.think_min = think_min_override
	if think_max_override != null:
		new_enemy.think_max = think_max_override
	if current_behavior_override != null:
		new_enemy.current_behavior = current_behavior_override
	if waypoint_override != null:
		new_enemy.waypoint = waypoint_override
	if post_waypoint_behavior_override != null:
		new_enemy.post_waypoint_behavior = post_waypoint_behavior_override
	if can_break_doors_override != null:
		new_enemy.can_break_doors = can_break_doors_override
	if vanishes_override != null:
		new_enemy.vanishes = vanishes_override
	if vanish_steps_override != null:
		new_enemy.vanish_steps = vanish_steps_override
	GlobalVars.scene_root.add_child(new_enemy)
	new_enemy.global_position = global_position
