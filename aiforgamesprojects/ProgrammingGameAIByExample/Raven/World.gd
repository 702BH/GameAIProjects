class_name RavenWorld
extends Node

var width : float
var height: float
var resolution : float
var rows : int
var columns: int


var graph: RavenGraph
var grid_world: Array = []
var spawn_points: Array = []

var triggers: Array = []


var cell_size : int
var cell_buckets_agents: Dictionary ={}
var cell_buckets_static: Dictionary ={}

var loaded_map : bool = false

var pre_calc_costs = []
var NUM_THREADS := 6
var threads := []
var is_saving := false
var save_thread : Thread

func initialise(_width:float, _height:float, _resolution:float, _cell_size:int) -> void:
	width = _width
	height = _height
	resolution = _resolution
	cell_size = _cell_size

func generate_grid() -> void:
	rows = int(height / resolution)
	columns = int(width/ resolution)
	grid_world.resize(rows)
	cell_buckets_static.clear()
	for i in range(rows):
		grid_world[i] = []
		for j in range(columns):
			if i == 0 or i == rows-1 or j== 0 or j==columns-1:
				#graph.add_vertex(RavenNode.NodeType.WALL, Vector2(j * resolution + resolution / 2, i * resolution + resolution / 2), true)
				graph.add_vertex(RavenNode.NodeType.WALL, Vector2(j, i), true)
				grid_world[i].append(graph.nodes[i * columns + j])
			else:
				#graph.add_vertex(RavenNode.NodeType.TRAVERSAL, Vector2(j * resolution + resolution / 2, i * resolution + resolution / 2), false)
				graph.add_vertex(RavenNode.NodeType.TRAVERSAL, Vector2(j , i ), false)
				grid_world[i].append(graph.nodes[i * columns + j])
			var cell_x = int(j/cell_size)
			var cell_y = int(i/cell_size)
			var key = Vector2i(cell_x, cell_y)
			if !cell_buckets_static.has(key):
				cell_buckets_static[key] = []
			cell_buckets_static[key].append(graph.nodes[i * columns + j])
			
	# generated edges
	generate_edges(rows, columns)
	RavenServiceBus.grid_generated.emit()

func generate_edges(rows, columns) ->void:
	for i in range(rows):
		for j in range(columns):
			var node: RavenNode = grid_world[i][j]
			if node.node_type == RavenNode.NodeType.WALL:
				continue
			for k in range(-1, 2):
				for l in range(-1, 2):
					var neighbor: RavenNode = grid_world[i+k][j+l]
					if neighbor.node_type == RavenNode.NodeType.WALL:
						continue
					var distance = grid_to_world(graph.nodes[node.id].node_pos.x, graph.nodes[node.id].node_pos.y, resolution).distance_to(grid_to_world(graph.nodes[neighbor.id].node_pos.x, graph.nodes[neighbor.id].node_pos.y, resolution))
					graph.add_edge(node.id, neighbor.id, distance)


func load_world_from_file(file_path: String) -> void:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Could not open file")
		return
	
	var text = file.get_as_text()
	var result = JSON.parse_string(text)
	if result == null:
		push_error("invalid Json")
		return
	
	graph = RavenGraph.new(false)
	grid_world = []
	
	var map_rows = result["rows"]
	var map_columns = result["columns"]
	var map_res = result["resolution"]
	var nodes = result["nodes"]
	
	grid_world.resize(map_rows)
	for i in range(map_rows):
		grid_world[i] = []
		grid_world[i].resize(map_columns)
	
	cell_buckets_static.clear()
	
	for node in nodes:
		if node["row"] == 0 or node["row"] == map_rows-1 or node["column"]== 0 or node["column"]==map_columns-1:
			var graph_node = graph.add_vertex(node["type"], Vector2(node["position"]["x"], node["position"]["y"]), true)
			grid_world[node["row"]][node["column"]] = graph_node
			var cell_x = int(node["position"]["x"]/cell_size)
			var cell_y = int(node["position"]["y"]/cell_size)
			var key = Vector2i(cell_x, cell_y)
			if !cell_buckets_static.has(key):
				cell_buckets_static[key] = []
			cell_buckets_static[key].append(graph.nodes[node["row"] * columns + node["column"]])
		else:
			var graph_node = graph.add_vertex(node["type"], Vector2(node["position"]["x"], node["position"]["y"]), false)
			grid_world[node["row"]][node["column"]] = graph_node
			if node["item_type"] == RavenNodeItem.ItemType.WEAPON:
				var item := RavenNodeItemWeapon.new(RavenNodeItem.ItemSubType.SHOTGUN)
				graph_node.set_item_type(item)
				# create trigger item trigger
				triggers.append(graph_node)
			elif node["item_type"] == RavenNodeItem.ItemType.HEALTH:
				var item := RavenNodeItemHealth.new()
				graph_node.set_item_type(item)
				triggers.append(graph_node)
			if graph_node.node_type == RavenNode.NodeType.SPAWN:
				spawn_points.append(graph_node)
				#print("spawn loaded")
				#print("node pos ", graph_node.node_pos)
				#print("loc row: ", node["row"], " column: ", node["column"])
				#print("grid to world: ", grid_to_world(graph_node.node_pos.x, graph_node.node_pos.y, resolution))
				#print("world to grid: ", position_to_grid(graph_node.node_pos))
			if graph_node.node_type == RavenNode.NodeType.WALL:
				var cell_x = int(node["position"]["x"]/cell_size)
				var cell_y = int(node["position"]["y"]/cell_size)
				var key = Vector2i(cell_x, cell_y)
				if !cell_buckets_static.has(key):
					cell_buckets_static[key] = []
				cell_buckets_static[key].append(graph.nodes[node["row"] * columns + node["column"]])
	generate_edges(map_rows, map_columns)
	RavenServiceBus.grid_generated.emit()
	loaded_map = true
	
	# after loading, do the precalc cost table
	pre_calc_costs = result["pre_calc_costs"]
	
	# debugging
	for key in cell_buckets_static:
		var walls = cell_buckets_static[key]
		for wall in walls:
			print(wall.wall_segments)


func calculate_costs() -> void:
	pre_calc_costs = []
	pre_calc_costs.resize(graph.nodes.size())
	
	for node:RavenNode in graph.nodes:
		pre_calc_costs[node.id] = []
		pre_calc_costs[node.id].resize(graph.nodes.size())
		# run all djikstras
		if node.is_border:
			continue
		var costs = graph.all_djikstras(node.id)
		for key in costs:
			pre_calc_costs[node.id][key] = costs[key]


func calculate_costs_threaded() -> void:
	var num_nodes = graph.nodes.size()
	pre_calc_costs = []
	pre_calc_costs.resize(num_nodes)
	for i in range(num_nodes):
		pre_calc_costs[i] = []
		pre_calc_costs[i].resize(num_nodes)
	
	var chunk_size = ceil(float(num_nodes) / float(NUM_THREADS))
	threads.clear()
	
	for t in range(NUM_THREADS):
		var start_idx = t * chunk_size
		var end_idx = min((t+1) * chunk_size, num_nodes)
		var thread = Thread.new()
		threads.append(thread)
		thread.start(_compute_chunk.bind({"start":start_idx, "end":end_idx}))
	
	for thread:Thread in threads:
		thread.wait_to_finish()
	
	print("All precomputed costs done.")

func _compute_chunk(info) -> void:
	var start_idx = info["start"]
	var end_idx = info["end"]
	
	for i in range(start_idx, end_idx):
		var node = graph.nodes[i]
		
		if node.is_border:
			continue
		
		var costs_dict = graph.all_djikstras(node.id)
		
		for target_id in costs_dict.keys():
			pre_calc_costs[node.id][target_id] = costs_dict[target_id]


func save_map(file_name:String) -> void:
	if is_saving:
		return
	
	print("SHOULD START SAVING UI")
	RavenServiceBus.load_pop_up.emit()
	save_thread = Thread.new()
	save_thread.start(_save_world_threaded.bind(file_name))

func _save_world_threaded(file_name:String) ->void:
	save_world_to_file(file_name)
	
	is_saving = false
	call_deferred("_on_save_complete")


func save_world_to_file(file_name:String) -> void:
	print("Saving map")
	calculate_costs_threaded()
	
	var save_data = {
		"rows":rows,
		"columns": columns,
		"resolution": resolution,
		"nodes": [],
		"pre_calc_costs": pre_calc_costs
	}
	for row in range(rows):
		for col in range(columns):
			var node: RavenNode = grid_world[row][col]
			var item_type= null
			if node.item_type:
				item_type = node.item_type.item_type
			save_data["nodes"].append({
				"type": node.node_type,
				"item_type": item_type,
				"position": {"x":node.node_pos.x, "y":node.node_pos.y},
				"row": row,
				"column": col
			})
	
	var file_path = "res://ProgrammingGameAIByExample/Raven/Maps/" + file_name + ".json"
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	var json_string = JSON.stringify(save_data)
	file.store_line(json_string)
	file.close()
	print("map saved")

func _on_save_complete() -> void:
	RavenServiceBus.load_pop_up.emit()
	print("MAP SAVED")

func move_agent(agent: RavenAgent, old_pos: Vector2, new_pos: Vector2) -> void:
	var old_key = world_to_bucket((old_pos))
	var new_key = world_to_bucket((new_pos))
	
	
	if old_key != new_key:
		cell_buckets_agents[old_key].erase(agent)
		if not cell_buckets_agents.has(new_key):
			cell_buckets_agents[new_key] = []
		cell_buckets_agents[new_key].append(agent)

func place_agent(agent: RavenAgent, pos: Vector2) -> void:
	var key = world_to_bucket(pos)
	
	if not cell_buckets_agents.has(key):
		cell_buckets_agents[key] = []
	cell_buckets_agents[key].append(agent)


# Helper functions
func position_to_grid(pos: Vector2) -> Vector2:
	var col = clamp(int(pos.x / resolution), 0, columns - 1)
	var row = clamp(int(pos.y / resolution) , 0 , rows - 1)
	return Vector2(col, row)


func grid_to_world(col:int, row:int, res: float= resolution) -> Vector2:
	return Vector2(
		col * resolution + resolution / 2,
		row * resolution + resolution / 2
	)


func world_to_bucket(pos: Vector2) -> Vector2:
	return Vector2(int(pos.x / cell_size), int(pos.y) / cell_size)


func get_random_position() -> Vector2:
	return Vector2(randi_range(30, int(width)), randi_range(30, int(height)))


func remove_agent(agent: RavenAgent, pos: Vector2) -> void:
	var key = world_to_bucket(pos)
	var bucket:Array = cell_buckets_agents[key]
	
	var index = bucket.find(agent)
	if index >= 0:
		bucket.remove_at(index)
	
