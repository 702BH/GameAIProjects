class_name Calculations
extends RefCounted





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
