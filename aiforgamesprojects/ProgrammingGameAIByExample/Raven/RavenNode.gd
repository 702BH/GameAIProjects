class_name RavenNode
extends "res://ProgrammingGameAIByExample/Graphs/graph_vertex.gd"

enum NodeType {TRAVERSAL, WALL, SPAWN, ITEM}
enum PlaceableType {Health, Weapon, Spawn}
var node_type : NodeType
var node_pos : Vector2
var is_border : bool
var item_type : RavenNodeItem = null
var dirty := false

var wall_segments: Array
var wall_normals: Array

func _init(_id: int, _node_type: NodeType, _node_pos:Vector2, _border: bool) -> void:
	super(_id)
	node_type = _node_type
	node_pos = _node_pos
	is_border = _border
	if _node_type == NodeType.WALL:
		_initialise_wall_segments()


func set_item_type(_type: RavenNodeItem) -> void:
	item_type = _type



func _initialise_wall_segments() -> void:
	var half_res = World.resolution /2
	var node_world_pos = World.grid_to_world(node_pos.x, node_pos.y)
	var top_left := Vector2(node_world_pos.x -half_res, node_world_pos.y -half_res)
	var top_right:= Vector2(node_world_pos.x +half_res, node_world_pos.y -half_res)
	var bottom_left:= Vector2(node_world_pos.x -half_res, node_world_pos.y +half_res)
	var bottom_right:= Vector2(node_world_pos.x +half_res, node_world_pos.y +half_res)
	wall_segments = [
				[top_left, top_right],
				[top_right, bottom_right],
				[bottom_right, bottom_left],
				[bottom_left, top_left]
			]
	for segment in wall_segments:
		var edge = segment[1] - segment[0]
		var normal = Vector2(-edge.y, edge.x).normalized()
		wall_normals.append(normal)
