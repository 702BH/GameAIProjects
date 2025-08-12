class_name SparseGraph
extends Node



# the nodes that comprise this graph
var nodes : Array[GraphVertex] = []
var edges: Dictionary = {}
var di_graph : bool
var next_index := 0

func _init(context_digraph:bool) -> void:
	di_graph = context_digraph


func add_vertex() -> void:
	var vertex = GraphVertex.new(next_index)
	nodes.append(vertex)
	edges[next_index] = []
	next_index += 1


func add_edge(_from : int, _to: int, weight : float) -> void:
	# prevent duplicates
	for e:GraphEdge in edges[_from]:
		if e.to == _to:
			return
	edges[_from].append(GraphEdge.new(_from, _to, weight))
	
	# if undirected graph, add the reverse edge
	if not di_graph:
		for e:GraphEdge in edges[_to]:
			if e.to == _from:
				return
		edges[_to].append(GraphEdge.new(_to, _from, weight))



func remove_edge(_from : int, _to: int) -> void:
	edges[_from] = edges[_from].filter(func(e): return e.to != _to)
	if not di_graph:
		edges[_to] = edges[_to].filter(func(e): return e.to != _from)



func remove_vertex(id : int) -> void:
	if not edges.has(id):
		return
	
	# remove the node
	edges.erase(id)
	
	# remove all edges to this vertex
	for key in edges.keys():
		edges[key] = edges[key].filter(func(e): return e.to != id)
	
	nodes[id] = null


func depth_first_search() -> void:
	var is_visited : Array = []
	for node : GraphVertex in nodes:
		is_visited[node.id].append(false)
	var result : Array = []
