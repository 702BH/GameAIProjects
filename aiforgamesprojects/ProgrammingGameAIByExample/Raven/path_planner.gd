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
		return return_path
	else:
		return []

func position_to_grid(pos: Vector2) -> Vector2:
	var col = clamp(int(pos.x / resolution), 0, columns - 1)
	var row = clamp(int(pos.y / resolution) , 0 , rows - 1)
	return Vector2(col, row)


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
