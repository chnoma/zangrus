extends Node

var nav_map: Node3D
var nav_root: AStar3D
var mesh = {}

func calculate_nav():
	nav_root = AStar3D.new()
	mesh = {}
	var size = nav_map.get_children().size()
	if size > 64:  # get this damn compiler off my ass
		nav_root.reserve_space(size)
	var point_id = 0
	for child in nav_map.get_children(): 
		var pos = child.global_transform.origin
		if !mesh.has(pos.x):
			mesh[pos.x] = {}
		mesh[pos.x][pos.z] = point_id
		nav_root.add_point(point_id, Vector3(pos.x, 0.5, pos.z))
		point_id += 1
	
	for id in nav_root.get_point_ids():
		var pos = nav_root.get_point_position(id)
		
		if mesh.has(pos.x+1) && mesh[pos.x+1].has(pos.z):
			nav_root.connect_points(id, mesh[pos.x+1][pos.z])
		if mesh.has(pos.x-1) && mesh[pos.x-1].has(pos.z):
			nav_root.connect_points(id, mesh[pos.x-1][pos.z])
		if mesh.has(pos.x) && mesh[pos.x].has(pos.z+1):
			nav_root.connect_points(id, mesh[pos.x][pos.z+1])
		if mesh.has(pos.x) && mesh[pos.x].has(pos.z-1):
			nav_root.connect_points(id, mesh[pos.x][pos.z-1])
	
