class_name RavenGraph

# the nodes that comprise this graph
var nodes : Array[RavenNode] = []
var edges: Dictionary = {}
var di_graph : bool
var next_index := 0


func _init(context_digraph:bool) -> void:
	di_graph = context_digraph

func add_vertex(type: RavenNode.NodeType, pos: Vector2, border:bool) -> RavenNode:
	var vertex = RavenNode.new(next_index, type, pos, border)
	nodes.append(vertex)
	edges[next_index] = []
	next_index += 1
	return vertex
