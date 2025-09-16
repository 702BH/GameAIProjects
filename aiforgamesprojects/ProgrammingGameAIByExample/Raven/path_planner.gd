class_name RavenPathPlanner
extends Node

var graph : RavenGraph
var columns : int
var rows: int
var resolution: float

func _init(_graph: RavenGraph, _columns:int, _rows:int, _resolution: float) -> void:
	graph = _graph
	columns = _columns
	rows = _rows
	resolution = _resolution

func get_random_path(agent_pos: Vector2) -> Array:
	var return_path = graph.dijkstras(get_nearest_node(agent_pos).id, is_shotgun)
	if !return_path.is_empty():
		return smooth_path_edges_quick(return_path)
		#return return_path
	else:
		return []

func position_to_grid(pos: Vector2) -> Vector2:
	var col = clamp(int(pos.x / resolution), 0, columns - 1)
	var row = clamp(int(pos.y / resolution) , 0 , rows - 1)
	return Vector2(col, row)

func grid_to_world(col:int, row:int, res: float) -> Vector2:
	return Vector2(
		col * resolution + resolution / 2,
		row * resolution + resolution / 2
	)

func get_nearest_node(pos: Vector2) -> RavenNode:
	var grid_pos = position_to_grid(pos)
	var node = graph.nodes[grid_pos.y * columns + grid_pos.x]
	return node


func is_shotgun(node: RavenNode) -> bool:
	if node.node_type == null:
		return false
	if node.item_type is RavenNodeItemWeapon:
		return true
	return false



func smooth_path_edges_quick(path: Array[PathEdge]) -> Array[PathEdge]:
		var e1 = 0
		var e2 = 1
		
		var return_path = path
		
		while e2 < return_path.size():
			if _can_walk_between(return_path[e1].source, return_path[e2].destination):
				return_path[e1].destination = return_path[e2].destination
				return_path.pop_at(e2)
			else:
				e1 = e2
				e2 +=1
		
		return return_path


func _can_walk_between(source:Vector2, dest:Vector2) -> bool:
	var vector = grid_to_world(dest.x, dest.y, resolution)-grid_to_world(source.x, source.y, resolution)
	var direction = vector.normalized()
	var distance = 0.0
	
	while distance < vector.length():
		var pos = grid_to_world(source.x, source.y, resolution) + direction * distance
		var grid_pos = position_to_grid(pos)
		var node = graph.nodes[grid_pos.y * columns + grid_pos.x]
		if node.node_type == RavenNode.NodeType.WALL:
			return false
		distance += resolution
	return true
