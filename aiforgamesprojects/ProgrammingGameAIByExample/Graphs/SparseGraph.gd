class_name SparseGraph
extends Node

var di_graph : bool

var nodes : Array[NodeGraph] = []
var edges: Dictionary = {}

func _init(context_digraph:bool) -> void:
	di_graph = context_digraph


func add_node(node : NodeGraph) -> void:
	nodes.append(node)
	edges[node.index] = []


func add_edge(edge: GraphEdge) -> void:
	if not edges.has(edge.from):
		edges[edge.from] = []
	edges[edge.from].append(edge)

func get_neighbors(index:int) -> Array:
	return edges.get(index, [])


func depth_first_search(start_index:int, goal_index:int) -> Array:
	var visited := []
	var path := []
	
	return path
