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
	World.graph = RavenGraph.new(false)
	graph = RavenGraph.new(false)
	World.generate_grid()
	initialise_ui_container(rows, columns, resolution, grid_world, graph, spawn_points, map_drawing)
	#ui.initialise_grid_container(rows, columns, resolution, grid_world, ui)
	initialise_map_drawer(rows, columns, resolution, grid_world, graph, cell_size, cell_buckets)
	#print("Debug")
	#print("Edges for node 1 ", graph.edges[1])
	#print("Edges for node 56", graph.edges[56])
	#print("Cell Space")
	#print(cell_buckets[Vector2i(0,0)])
	
	agents_container.connect("agent_selected", ui.on_agent_selected)
	agents_container.connect("agent_deselected", ui.on_agent_deselected)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("place"):
		agents_container.query_selectable(get_global_mouse_position())
	if event.is_action_pressed("remove"):
		if agents_container.selected_agent:
			print("Should generate a path")

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



func _on_ui_map_load_request(file_path: String) -> void:
	#print(file_path)
	World.load_world_from_file(file_path)
	#print(spawn_points)
	#for node:RavenNode in spawn_points:
		#print(node.node_pos)



func spawn_agents() -> void:
	for node:RavenNode in World.spawn_points:
		var agent : RavenAgent = agent_prefab.instantiate()
		agent.path_planner = RavenPathPlanner.new(World.graph, World.columns,World.rows, World.resolution)
		agent.position = World.grid_to_world(node.node_pos.x, node.node_pos.y)
		if randf() > 0.3:
			agent.rotate(randf_range(-2, 2))
		#print(node.node_pos)
		#print(agent.position)
		#print(grid_to_world(node.node_pos.x, node.node_pos.y, resolution))
		agents_container.add_child(agent)
		agent.queue_redraw()
		


func _on_ui_start_map_request() -> void:
	spawn_agents()
