class_name RavenNode
extends "res://ProgrammingGameAIByExample/Graphs/graph_vertex.gd"

enum NodeType {TRAVERSAL, WALL, SPAWN}
var node_type : NodeType
var node_pos : Vector2
var is_border : bool

func _init(_id: int, _node_type: NodeType, _node_pos:Vector2, _border: bool) -> void:
	super(_id)
	node_type = _node_type
	node_pos = _node_pos
	is_border = _border
