class_name Calculations
extends RefCounted

# --do_walls_obstruct_line_segment--
#
# given a line segment defined by two points
# iterate through all map walls and test for any intersection
# Returns true if an intersection occurs
#
# ------------------------
static func do_walls_obstruct_line_segment(from:Vector2, to:Vector2) -> bool:
	for key in World.cell_buckets_static:
		var walls = World.cell_buckets_static[key]
		for wall in walls:
			var wall_segments = wall.wall_segments
			for segment:Array in wall_segments:
				var calc_point : Vector2 = Calculations.line_intersection2D(from, to, segment[0], segment[1])
				if calc_point != Vector2.INF:
					return true
	return false





# --is_path_obstructed--
#
# returs true if agent cannot move from a to b
# step from A to B in steps of radius
# test for intersections with world geometry
#
# ------------------------

static func is_path_obstructed(A:Vector2, B:Vector2, radius:float) -> bool:
	var to_b: Vector2 = (B-A).normalized()
	var current_pos :Vector2 = A
	
	while current_pos.distance_squared_to(B) > radius*radius:
		# Advance current position one step
		current_pos += to_b * 0.5 * radius
		
		# Test all walls against the new position
		# for now, just circle-circle collision
		# to be replaced with line intersections
		var key = World.world_to_bucket(World.position_to_grid(current_pos))
		var bucket:Array = World.cell_buckets_static.get(Vector2i(int(key.x), int(key.y)), [])
		# filter buckets for only wall nodes
		bucket = bucket.filter(
			func(r:RavenNode): return r.node_type == RavenNode.NodeType.WALL
		)
		
		if bucket.is_empty():
			print("No walls")
			return false
		else:
			print("Walls found")
			for node:RavenNode in bucket:
				var node_pos: Vector2 = World.grid_to_world(node.node_pos.x, node.node_pos.y)
				if do_circles_intersect(node_pos, current_pos, World.resolution/2, radius):
					print("Circles intersect")
					return true
		
	return false



static func do_circles_intersect(pos_1: Vector2, pos_2: Vector2, r_1:float, r_2:float) -> bool:
	return (pos_2.x-pos_1.x)**2 + (pos_2.y-pos_1.y)**2 <= (r_1 + r_2)**2




static func line_intersection2D(a: Vector2, b: Vector2, c: Vector2, d: Vector2) -> Vector2:
	var rtop:float = (a.y - c.y) * (d.x - c.x) - (a.x-c.x)*(d.y - c.y)
	var rbot:float = (b.x-a.x)*(d.y-c.y) - (b.y-a.y)*(d.x-c.x)
	
	var stop:float = (a.y-c.y)*(b.x-a.x)-(a.x-c.x)*(b.y-a.y)
	var sbot:float = (b.x-a.x)*(d.y-c.y)-(b.y-a.y)*(d.x-c.x)
	
	var epsilon = 1e-6
	#print(epsilon)
	if abs(rbot) < epsilon or abs(sbot)<epsilon:
		# lines are paraellel
		return Vector2.INF
	
	var r : float = rtop/rbot
	var s: float = stop/sbot
	
	if r>=0 and r<=1 and s>=0 and s<=1:
		var point = a + r*(b-a)
		#print(point)
		return point
	
	# no intersection
	return Vector2.INF
