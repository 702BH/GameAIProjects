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


func remove_wall(id : int) -> void:
	if not edges.has(id):
		return
	
	# remove the node
	edges.erase(id)
	
	# remove all edges to this vertex
	for key in edges.keys():
		edges[key] = edges[key].filter(func(e): return e.to != id)
	
