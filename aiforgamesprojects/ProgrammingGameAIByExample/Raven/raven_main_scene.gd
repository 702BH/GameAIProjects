extends Node2D


@export var width := 1152.0
@export var height := 600.0

@onready var ui := $CanvasLayer/UI
@onready var grid_container := $CanvasLayer/UI/Container/GridContainer
@onready var agent_prefab := preload("res://ProgrammingGameAIByExample/Raven/raven_agent.tscn")
@onready var agents_container := $AgentContainer
@onready var map_drawing := $MapDrawing

var resolution := 24.0
var rows := 0
var columns := 0
var grid_world = []
var graph: RavenGraph
var loaded_map := ""

var spawn_points := []

# grid-space partioning
var cell_size = 4
var cell_buckets: Dictionary = {}



func _ready() -> void:
	graph = RavenGraph.new(false)
	generate_grid()
	initialise_ui_container(rows, columns, resolution, grid_world, graph, spawn_points, map_drawing)
	#ui.initialise_grid_container(rows, columns, resolution, grid_world, ui)
	initialise_map_drawer(rows, columns, resolution, grid_world, graph, cell_size, cell_buckets)
	print("Debug")
	print("Edges for node 1 ", graph.edges[1])
	print("Edges for node 56", graph.edges[56])
	print("Cell Space")
	print(cell_buckets[Vector2i(0,0)])

func initialise_ui_container(rows, columns, resolution, grid_world, graph, spawn_points, map_drawer) -> void:
	ui.rows = rows
	ui.columns = columns
	ui.resolution = resolution
	ui.grid_world = grid_world
	ui.graph = graph
	ui.spawn_points = spawn_points
	ui.map_drawer = map_drawer

func initialise_map_drawer(rows, columns, resolution, grid_world, graph, cell_size, cell_space) -> void:
	map_drawing.rows = rows
	map_drawing.columns = columns
	map_drawing.resolution = resolution
	map_drawing.grid_world = grid_world
	map_drawing.width = width
	map_drawing.height = height
	map_drawing.graph = graph
	map_drawing.cell_size = cell_size
	map_drawing.cell_space = cell_space
	map_drawing.queue_redraw()


func generate_grid() -> void:
	rows = int(height / resolution)
	columns = int(width/ resolution)
	grid_world.resize(rows)
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
			if !cell_buckets.has(key):
				cell_buckets[key] = []
			cell_buckets[key].append(graph.nodes[i * columns + j])
	
	# generated edges
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
					graph.add_edge(node.id, neighbor.id, 1.0)


func _on_ui_map_load_request(file_path: String) -> void:
	#print(file_path)
	load_world_from_file(file_path)
	#print(spawn_points)
	#for node:RavenNode in spawn_points:
		#print(node.node_pos)



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
	
	for node in nodes:
		if node["row"] == 0 or node["row"] == map_rows-1 or node["column"]== 0 or node["column"]==map_columns-1:
			var graph_node = graph.add_vertex(node["type"], Vector2(node["position"]["x"], node["position"]["y"]), true)
			grid_world[node["row"]][node["column"]] = graph_node
		else:
			var graph_node = graph.add_vertex(node["type"], Vector2(node["position"]["x"], node["position"]["y"]), false)
			grid_world[node["row"]][node["column"]] = graph_node
			if graph_node.node_type == RavenNode.NodeType.SPAWN:
				spawn_points.append(graph_node)
				#print("spawn loaded")
				#print("node pos ", graph_node.node_pos)
				#print("loc row: ", node["row"], " column: ", node["column"])
				#print("grid to world: ", grid_to_world(graph_node.node_pos.x, graph_node.node_pos.y, resolution))
				#print("world to grid: ", position_to_grid(graph_node.node_pos))
	initialise_ui_container(map_rows, map_columns, map_res, grid_world, graph, spawn_points, map_drawing)
	initialise_map_drawer(map_rows, map_columns, map_res, grid_world, graph, cell_size, cell_buckets)
	#print("completed")


func spawn_agents() -> void:
	for node:RavenNode in spawn_points:
		var agent : RavenAgent = agent_prefab.instantiate()
		agent.position = grid_to_world(node.node_pos.x, node.node_pos.y, resolution)
		if randf() > 0.3:
			agent.rotate(randf_range(-2, 2))
		#print(node.node_pos)
		#print(agent.position)
		#print(grid_to_world(node.node_pos.x, node.node_pos.y, resolution))
		agents_container.add_child(agent)
		agent.queue_redraw()
		


func _on_ui_start_map_request() -> void:
	spawn_agents()



func position_to_grid(pos: Vector2) -> Vector2:
	var col = clamp(int(pos.x / resolution), 0, columns - 1)
	var row = clamp(int(pos.y / resolution) , 0 , rows - 1)
	return Vector2(col, row)


func grid_to_world(col:int, row:int, res: float) -> Vector2:
	return Vector2(
		col * resolution + resolution / 2,
		row * resolution + resolution / 2
	)
