class_name RavenPathPlanner
extends RefCounted

var owner_agent:RavenAgent

var type_map = {
	RavenNodeItem.ItemType.WEAPON : Callable(self, "is_weapon")
}

var item_map = {
	RavenNodeItem.ItemSubType.SHOTGUN : Callable(self, "is_shotgun"),
	RavenNodeItem.ItemSubType.ROCKET_LAUNCHER : Callable(self, "is_rocket_launcher"),
	RavenNodeItem.ItemSubType.RAIL_GUN : Callable(self, "is_rail_gun"),
	RavenNodeItem.ItemSubType.HEALTH : Callable(self, "is_health")
}

func _init(_agent: RavenAgent) -> void:
	owner_agent = _agent

func get_random_path(agent_pos: Vector2) -> Array:
	var return_path = World.graph.dijkstras(get_nearest_node(agent_pos).id, is_shotgun)
	if !return_path.is_empty():
		return smooth_path_edges_quick(return_path)
		#return return_path
	else:
		return []

func get_path_to_item(agent_pos: Vector2, item: RavenNodeItem.ItemSubType) -> Array:
	var return_path = World.graph.dijkstras(get_nearest_node(agent_pos).id, item_map.get(item))
	if !return_path.is_empty():
		return smooth_path_edges_quick(return_path)
	return []


func get_path_to_target(target_pos: Vector2, agent_pos: Vector2) -> Array:
	var return_path = World.graph.A_star(get_nearest_node(agent_pos).id, get_nearest_node(target_pos).id, World.columns)
	#print("ORIGINAL")
	#print(return_path)
	if !return_path.is_empty():
		return smooth_path_edges_quick(return_path)
		#return return_path
	else:
		return []

func get_nearest_node(pos: Vector2) -> RavenNode:
	var grid_pos = World.position_to_grid(pos)
	var node = World.graph.nodes[grid_pos.y * World.columns + grid_pos.x]
	return node


func is_shotgun(node: RavenNode) -> bool:
	if node.item_type == null:
		return false
	if node.item_type.item_sub_type == RavenNodeItem.ItemSubType.SHOTGUN:
		return true
	return false

func is_rocket_launcher(node: RavenNode) -> bool:
	if node.item_type == null:
		return false
	if node.item_type.item_sub_type == RavenNodeItem.ItemSubType.ROCKET_LAUNCHER:
		return true
	return false

func is_rail_gun(node: RavenNode) -> bool:
	if node.item_type == null:
		return false
	if node.item_type.item_sub_type == RavenNodeItem.ItemSubType.RAIL_GUN:
		return true
	return false

func is_health(node: RavenNode) -> bool:
	if node.item_type == null:
		return false
	if node.item_type.item_sub_type == RavenNodeItem.ItemSubType.HEALTH:
		return true
	return false


func is_weapon(node: RavenNode) -> bool:
	if node.node_type == null:
		return false
	if node.item_type is RavenNodeItemWeapon:
		return true
	return false


func smooth_path_edges_quick(path: Array[PathEdge]) -> Array[PathEdge]:
		var e1 = 0
		var e2 = 1
		
		var return_path = path
		
		while e2 < return_path.size():
			if _can_walk_between(return_path[e1].source, return_path[e2].destination):
				return_path[e1].destination = return_path[e2].destination
				return_path[e1].cost = World.grid_to_world(return_path[e1].source.x, return_path[e1].source.y).distance_to(World.grid_to_world(return_path[e2].destination.x, return_path[e2].destination.y))
				return_path.pop_at(e2)
			else:
				e1 = e2
				e2 +=1
		
		#print("SMOOTH")
		#print(return_path)
		return return_path


func _can_walk_between(source:Vector2, dest:Vector2) -> bool:
	var vector = World.grid_to_world(dest.x, dest.y)- World.grid_to_world(source.x, source.y)
	var direction = vector.normalized()
	var distance = 0.0
	
	while distance < vector.length():
		var pos = World.grid_to_world(source.x, source.y) + direction * distance
		var grid_pos = World.position_to_grid(pos)
		var node = World.graph.nodes[grid_pos.y * World.columns + grid_pos.x]
		if node.node_type == RavenNode.NodeType.WALL:
			return false
		distance += World.resolution
	return true


func get_cost_to_closest_item(item: RavenNodeItem.ItemSubType) -> float:
	
	var agent_pos_id = get_nearest_node(owner_agent.position).id
	var function : Callable = item_map.get(item, null)
	
	var cost_sum := 0.0
	
	if function:
		var return_path = World.graph.dijkstras(agent_pos_id, function)
		if !return_path.is_empty():
			for p:PathEdge in return_path:
				cost_sum += p.cost
	
	
	return cost_sum


func get_pre_calc_cost_to_closest_item(agent_pos:Vector2, item: RavenNodeItem.ItemSubType) -> float:
	if World.triggers.is_empty():
		return 0.0
	var closest_so_far := 9223372036854775807 
	var source_node := get_nearest_node(agent_pos).id
	
	for node:RavenNode in World.triggers:
		if node.item_type.item_sub_type == item and node.item_type.associated_trigger.is_active:
			var cost = World.pre_calc_costs[source_node][node.id]
			if cost < closest_so_far:
				closest_so_far = cost
	
	return closest_so_far
