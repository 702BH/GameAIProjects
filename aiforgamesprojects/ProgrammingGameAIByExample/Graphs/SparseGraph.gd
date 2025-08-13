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


func depth_first_search(target:int) -> Array[GraphVertex]:
	var is_visited : Array[bool] = []
	is_visited.resize(nodes.size())
	var result : Array[GraphVertex] = []
	_dfs(is_visited, nodes[0], result, target)
	print(result)
	for i in range(result.size()):
		print(result[i].vertex_text())
	return result


func _dfs(isVisited: Array[bool], node : GraphVertex, result: Array[GraphVertex], target:int) -> void:
	result.append(node)
	isVisited[node.id] = true
	if node.id == target:
		return
	var node_edges = edges[node.id]
	for edge:GraphEdge in node_edges:
		if !isVisited[edge.to]:
			_dfs(isVisited, nodes[edge.to], result, target)
