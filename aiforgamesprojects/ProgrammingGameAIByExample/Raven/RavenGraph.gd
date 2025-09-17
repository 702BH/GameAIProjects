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
	for e:NavGraphEdge in edges[_from]:
		if e.to == _to:
			return
	edges[_from].append(NavGraphEdge.new(_from, _to, weight))
	
	# if undirected graph, add the reverse edge
	if not di_graph:
		for e:NavGraphEdge in edges[_to]:
			if e.to == _from:
				return
		edges[_to].append(NavGraphEdge.new(_to, _from, weight))



func remove_edge(_from : int, _to: int) -> void:
	edges[_from] = edges[_from].filter(func(e): return e.to != _to)
	if not di_graph:
		edges[_to] = edges[_to].filter(func(e): return e.to != _from)


func remove_wall(id : int) -> void:
	if not edges.has(id):
		return
	
	# remove the node
	edges[id] = []
	
	# remove all edges to this vertex
	for key in edges.keys():
		edges[key] = edges[key].filter(func(e): return e.to != id)
	


func get_edge_between(from_id: int, to_id:int) -> NavGraphEdge:
	for e:NavGraphEdge in edges[from_id]:
		if e.to == to_id:
			return e
	return null

func get_random_node() -> RavenNode:
	var return_node
	while true:
		var node: RavenNode = nodes[randi_range(0, nodes.size())]
		if node.node_type != RavenNode.NodeType.WALL:
			return_node = node
			break
	return return_node


func dijkstras(source: int, item_predicate: Callable) -> Array[PathEdge]:
	var result : Array[GraphVertex] = []
	var costs : Dictionary = {}
	var parents : Dictionary = {}
	var found_target
	
	var queue = []
	var open_set = MinHeap.new()
	for node in nodes:
		if node == null:
			continue
		costs[node.id] = 9223372036854775807 
	costs[source] = 0
	parents[source] = null
	
	open_set.push(source, 0)
	
	
	while open_set.data.size() > 0:
		var current_node = open_set.pop()
		var current_node_v = nodes[current_node]
		if item_predicate.call(current_node_v):
			found_target = current_node
			break
		var neighbors = edges[current_node]
		var cost = costs[current_node]
		for edge:GraphEdge in neighbors:
			var new_cost = cost + edge.cost
			if costs[edge.to] > new_cost:
				costs[edge.to] = new_cost
				parents[edge.to] = current_node
				open_set.push(edge.to, new_cost)
	
	var path_to_target: Array[PathEdge]  = []
	var current = found_target
	while parents.has(current):
		var parent = parents[current]
		if parent == null:
			break
		var from_node: RavenNode = nodes[parent]
		var to_node: RavenNode = nodes[current]
		var edge: NavGraphEdge = get_edge_between(parent, current)
		var behaviour = edge.behaviour_type if edge != null else PathEdge.BehaviourType.WALK
		path_to_target.push_front(PathEdge.new(from_node.node_pos, to_node.node_pos, behaviour, edge.cost))
		current = parent
	return path_to_target




func A_star(source: int, target: int, columns: int) -> Array[RavenNode]:
	var result : Array[RavenNode] = []
	var costs : Dictionary = {}
	var parents : Dictionary = {}
	
	var target_row = target / columns
	var target_col = target % columns
	var target_grid_pos = Vector2(target_col, target_row)
	
	var open_set = MinHeap.new()
	
	for node in nodes:
		if node == null:
			continue
		costs[node.id] = 9223372036854775807 
	costs[source] = 0
	parents[source] = null
	
	open_set.push(source, heuristic(source, target_grid_pos, columns))
	
	while open_set.data.size() > 0:
		var current_node = open_set.pop()
		var neighbors = edges[current_node]
		var cost = costs[current_node]
		for edge:GraphEdge in neighbors:
			var new_cost = cost + edge.cost
			
			if costs[edge.to] > new_cost:
				costs[edge.to] = new_cost
				parents[edge.to] = current_node
				var f_cost = new_cost + heuristic(edge.to, target_grid_pos, columns)
				open_set.push(edge.to, f_cost)
				#queue.sort_custom(func(a, b): return costs[a] + heuristic(a, target_grid_pos, columns)  < costs[b] + heuristic(b, target_grid_pos, columns))
	
	var path_to_target: Array[RavenNode]  = []
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
