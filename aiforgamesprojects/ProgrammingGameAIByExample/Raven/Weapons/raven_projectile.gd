class_name RavenProjectile
extends RavenMover

var target : Vector2
var damage_inflicted : float
var heading : Vector2


func _init(_target: Vector2) -> void:
	target = _target



func _out_of_world() -> bool:
	
	if position.x < 0 -20 or position.x > World.width + 20:
		return true
	
	if position.y < 0-20 or position.y > World.height +20:
		return true
	
	
	return false


func _wall_collision() -> bool:
	var key = World.world_to_bucket(World.position_to_grid(position))
	var bucket:Array[RavenNode] = World.cell_buckets_static.get(Vector2i(int(key.x), int(key.y)), [])
	bucket = bucket.filter(
		func(r:RavenNode): return r.node_type == RavenNode.NodeType.WALL
	)
	
	return false
