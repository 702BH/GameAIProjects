class_name SparseGraph
extends Node



# the nodes that comprise this graph
var nodes : Array[GraphVertex] = []
var edges: Dictionary = {}
var di_graph : bool
var next_index := 0

func _init(context_digraph:bool) -> void:
	di_graph = context_digraph


func add_vertex(_node : GraphVertex) -> void:
	if not nodes.has(_node):
		nodes.append(_node)
	if not edges.find_key(_node):
		edges[_node] = []

func add_edge(_from : GraphVertex, _to: GraphVertex, weight : float) -> void:
	var edge_exists := false
	var edge_list :Array[GraphEdge] = edges.get(_from)
	for edge : GraphEdge in edge_list:
		if edge.to == _to:
			edge_exists = true
	# if this source -> target edge already exists then dont add
	if not edge_exists:
		var edge := GraphEdge.new(_from, _to, weight)
		edge_list.append(edge)


func remove_edge(_from : GraphVertex, _to: GraphVertex) -> void:
	var edge_list :Array[GraphEdge] = edges.get(_from)
	
	for i in range(edge_list.size() - 1):
		if edge_list[i].to == _to:
			edge_list.remove_at(i)
			return


func remove_vertex(_node : GraphVertex) -> void:
	if not edges.find_key(_node):
		return
	
	# remove the node
	edges.erase(_node)
	
	# look for other ingoing edges
	for nodes in edges:
		var edge_list = edges[nodes]
		for i in range(edge_list.size() - 1):
			if edge_list[i].to == _node:
				edge_list.remove_at(i)
				return


func depth_first_search() -> void:
	var is_visited : Array = []
	for node : GraphVertex in nodes:
		is_visited[node.id].append(false)
	var result : Array = []
