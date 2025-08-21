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


func breadth_first_search_source(source:int, target:int) -> Array[GraphVertex]:
	var is_visited : Array[bool] = []
	is_visited.resize(nodes.size())
	var path : Array[GraphVertex] = []
	var parents : Dictionary = {}
	if _bfs(is_visited, nodes[source], path, target, parents):
		print("found")
		var path_to_target: Array[GraphVertex]  = []
		var current = target
		
		while current != null:
			path_to_target.push_front(nodes[current])
			current = parents.get(current, null)
		for i in range(path_to_target.size()):
			print(path[i].vertex_text())
		return path_to_target
	print("failed")
	return []

func _bfs(isVisited: Array[bool], node : GraphVertex, path: Array[GraphVertex], target:int, parents:Dictionary) -> bool:
	isVisited[node.id] = true
	var queue = []
	queue.push_back(node)
	parents[node.id] = null
	while queue.size() > 0:
		var next = queue.pop_front()
		path.append(next)
		if next.id == target:
			return true
		var node_edges = edges[next.id]
		for edge:GraphEdge in node_edges:
			if !isVisited[edge.to]:
				isVisited[edge.to] = true
				parents[edge.to] = next.id
				queue.push_back(nodes[edge.to])
	return false


func dijkstras(source: int, target: int) -> Array[GraphVertex]:
	var result : Array[GraphVertex] = []
	var costs : Dictionary = {}
	var parents : Dictionary = {}
	
	
	var queue = []
	for node in nodes:
		if node == null:
			continue
		costs[node.id] = 9223372036854775807 
		queue.push_back(node.id)
	costs[source] = 0
	parents[source] = null
	
	queue.sort_custom(func(a, b): return costs[a] < costs[b])
	
	while queue.size() > 0:
		var current_node = queue.pop_front()
		var neighbors = edges[current_node]
		var cost = costs[current_node]
		for edge:GraphEdge in neighbors:
			var new_cost = cost + edge.cost
			if costs[edge.to] > new_cost:
				costs[edge.to] = new_cost
				parents[edge.to] = current_node
				queue.sort_custom(func(a, b): return costs[a] < costs[b])
	
	var path_to_target: Array[GraphVertex]  = []
	var current = target
	while current != null:
		path_to_target.push_front(nodes[current])
		current = parents.get(current, null)
	return path_to_target


func A_star(source: int, target: int, columns: int) -> Array[GraphVertex]:
	var result : Array[GraphVertex] = []
	var costs : Dictionary = {}
	var parents : Dictionary = {}
	
	var target_row = target / columns
	var target_col = target % columns
	var target_grid_pos = Vector2(target_col, target_row)
	
	var queue = []
	for node in nodes:
		if node == null:
			continue
		costs[node.id] = 9223372036854775807 
		queue.push_back(node.id)
	costs[source] = 0
	parents[source] = null
	
	queue.sort_custom(func(a, b): return costs[a] < costs[b])
	
	while queue.size() > 0:
		var current_node = queue.pop_front()
		var neighbors = edges[current_node]
		var cost = costs[current_node]
		for edge:GraphEdge in neighbors:
			var new_cost = cost + edge.cost
			
			if costs[edge.to] > new_cost:
				costs[edge.to] = new_cost
				parents[edge.to] = current_node
				queue.sort_custom(func(a, b): return costs[a] + heuristic(a, target_grid_pos, columns)  < costs[b] + heuristic(b, target_grid_pos, columns))
	
	var path_to_target: Array[GraphVertex]  = []
	var current = target
	while current != null:
		path_to_target.push_front(nodes[current])
		current = parents.get(current, null)
	return path_to_target


func heuristic(node_index: int, target_pos: Vector2, columns:int) -> float:
	var row = node_index / columns
	var col = node_index % columns
	var node_pos = Vector2(col, row)
	return (node_pos - target_pos).length()
