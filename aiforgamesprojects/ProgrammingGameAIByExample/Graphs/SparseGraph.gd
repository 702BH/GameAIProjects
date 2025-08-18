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

func depth_first_search_source(source:int, target:int) -> Array[GraphVertex]:
	var is_visited : Array[bool] = []
	is_visited.resize(nodes.size())
	var path : Array[GraphVertex] = []
	if _dfs(is_visited, nodes[source], path, target):
		print("found")
		for i in range(path.size()):
			print(path[i].vertex_text())
		return path
	print("failed")
	return []


func _dfs(isVisited: Array[bool], node : GraphVertex, path: Array[GraphVertex], target:int) -> bool:
	path.append(node)
	isVisited[node.id] = true
	if node.id == target:
		return true
	var node_edges = edges[node.id]
	for edge:GraphEdge in node_edges:
		if !isVisited[edge.to]:
			if _dfs(isVisited, nodes[edge.to], path, target):
				return true
	path.pop_back()
	return false
